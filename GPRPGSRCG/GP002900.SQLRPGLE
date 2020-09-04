     H DEBUG
     H DFTACTGRP(*NO) ACTGRP(*CALLER)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Send T_MSWIP/T_MSRPRQ transaction status')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP002900 - Midas GP Send T_MSWIP T_MSRPRQ transactions       *
      *             status back to MHUB                               *
      *                                                               *
      *    (c) Finastra International Limited 2014                    *
      *                                                               *
      *  Last Amend No. MD052680           Date 06Mar19               *
      *  Prev Amend No. MD052679           Date 05Mar19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD031980           Date 26Jan15               *
      *                 MD032064           Date 23Jan15               *
      *                 MD031644           Date 15Dec14               *
      *                 CFT158  *CREATE    Date 10Nov14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052680 - Authority Failure Report - QZDASOINIT             *
      *  MD052679 - Authority Failure Report - GOC000110              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD031980 - Retrieval of FRNT from GZINPAYDD fails due        *
      *             to blank WKBRCA.                                  *
      *  MD032064 - In 2-EYES setting, after repairing a transaction, *
      *             status generated is 'REJECTED' instead of         *
      *             'REPAIRED'. This is due to SQL failure when       *
      *             checking if transaction was moved from T_MSRPRQ   *
      *             to T_MSWIP (using keys Front Office ID and Branch)*
      *  MD031644 - SP7 Build issue. Unable to compile program        *
      *             as global (when zonal libraries are removed)      *
      *           - remove all links to zonal objects and replace     *
      *           - with global equivalent (ie replicated file        *
      *             etc.)                                             *
      *  CFT158 - Return Status of Interfaced FT Payments             *
      *                                                               *
      *****************************************************************

      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.
     D/COPY GPCPYSRCG,STD_D_SPEC
      **------------------------------------------------------------------

      ** +--------------------------------------+
      **   Manually included D-specs            +
      **   =========================            +
      ** +--------------------------------------+

     D PARM1           DS
      ** Physical file name
     D  PFLNAME                1     10
      ** Member name
     D  MBRNAME               21     30
      ** Trigger event
     D  TRGEVENT              31     31
      ** Offset to the before image of the record
     D  BOFF                  49     52B 0
      ** Length of the before image of the record
     D  BLEN                  53     56B 0
      ** Offset to the after image of the record
     D  AOFF                  65     68B 0
      ** Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  32000A

     D PARM2           DS
     D  LENG                   1      4B 0


      /COPY GPCPYSRCG,PSDS
      **/COPY*ZACPYSRC,PRGETMDSVL                                                           MD031644

     D* --------------------------------------------------
     D* Prototypes
     D* --------------------------------------------------

     D*AOSARDR0********PR                  EXTPGM('AOSARDR0')                             //MD031644
     D**PRTCD**********               7A                                                  //MD031644
     D**POPTN**********               7A   CONST                                          //MD031644
     D**PSARD**********               6A   CONST                                          //MD031644
     D**DSFDY**********             200A   CONST                                          //MD031644
                                                                                          //MD031644
     D GPAOSARDR0      PR                  EXTPGM('GPAOSARDR0')                           //MD031644
     D  PRTCD                         7A                                                  //MD031644
     D  POPTN                         7A   CONST                                          //MD031644
     D  PSARD                         6A   CONST                                          //MD031644
                                                                                          //MD031644
     D QSNDDTAQ        PR                  EXTPGM('QSNDDTAQ')                             //MD031644
     D  DtqNam                       10A   CONST                                          //MD031644
     D  DtqLib                       10A   CONST                                          //MD031644
     D  DtqLen                        5P 0 CONST                                          //MD031644
     D  DtqDta                       60A   CONST                                          //MD031644
                                                                                          //MD031644
     D*FT000988***     PR                  EXTPGM('FT000988')                             //MD031644
     D*FrontID****                   20                                                   //MD031644
     D*TransID****                   20                                                   //MD031644
     D*TransRF****                    6                                                   //MD031644

     D T_MSWIP_AFT   E DS                  EXTNAME(T_MSWIP) PREFIX(WP_)
     D T_MSRPQ_AFT   E DS                  EXTNAME(T_MSRPRQ) PREFIX(RP_)

     D                 DS
     D  OPSVal                      200A   Inz
     D   OPSubtype                    2A   Dim(50)
     D                                     Overlay(OPSVal)
     D                 DS
     D  IPSVal                      200A   Inz
     D   IPSubtype                    2A   Dim(50)
     D                                     Overlay(IPSVal)

     D*APIData*******E DS                  EXTNAME(APOUTPUTPD)                            //MD031644
     D**FirstByte****          1      1A                                                  //MD031644
     D*MsgHeader*****E DS                  EXTNAME(APHEADPD)                              //MD031644

     D DSFDY         E DS                  EXTNAME(DSFDY)

     D @RUN            S              1A

      ***FT000988*parameters****                                                          //MD031644
      ** Components for message data to be sent to DTAQ                                   //MD031644
     D PFrontID        S             20A
     D PTransID        S             20A
     D*PTransRF********S             16A                                                  //MD031644
     D PTransRF        S             15A                                                  //MD031644

     D*wTranIDKey******S                   Like(WP_MSWFOTID)                              //MD031644
     D wAPIName        S                   Like(WP_MSWAPI)
     D wkPYST          S              2A   Inz
     D wkBRCA          S              3A   Inz
     D RecordCount     S              3U 0 Inz
     D genTrnStatus    S               N   Inz(*Off)

     D kFunt           S              8A
     D kIden           S             40A
     D kBrca           S              3A
     D pRTCD           S              7A   Inz
     D*CSC011**********S              6A                                                  //MD031644
     D*CFT158**********S              6A                                                  //MD031644
     D CSC011          S              1A                                                  //MD031644
     D CFT158          S              1A                                                  //MD031644
     D wFrontOffID     S                   Like(WP_MSWFOTID)
     D WkSysPfx        S              2A                                                  //MD031644
     D WkZone          S             10A                                                  //MD031644
     D WkMsgDta        S             60A                                                  //MD031644
     D DtqNam          S             10A                                                  //MD031644
     D DtqLib          S             10A                                                  //MD031644
     D DtqLen          S              5P 0                                                //MD031644
     D DtqDta          S             60A                                                  //MD031644
     D Pos             S              5S 0                                                //MD031644
     D P_MSWDATA       S          32000    Varying                                        //MD031644
     D WkRprRej        S              1A                                                  //MD031644
                                                                                          //MD052679
      *  Action Mode for Trigger Event                                                    //MD052679
     D INSERTMODE      S                   LIKE(TRGEVENT) INZ('1')                        //MD052679
     D DELETEMODE      S                   LIKE(TRGEVENT) INZ('2')                        //MD052679
     D AMENDMODE       S                   LIKE(TRGEVENT) INZ('3')                        //MD052679

      *  Entry Parameters
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2

      /free

        // Start of Main processing -----------------------------------+
        // Initial processing is performed automatically: the *INZSR is
        // executed at program activation.

        Clear T_MSWIP_AFT;
        Clear T_MSRPQ_AFT;

        Clear wFrontOffID;                                                                //MD031644
        Clear PFrontID;
        Clear PTransRF;
        Clear PTransID;

       Select;

       When PFLNAME = 'T_MSWIP';
                                                                                          //MD052679
        If (TRGEVENT = INSERTMODE) or (TRGEVENT = AMENDMODE);                             //MD052679
          T_MSWIP_AFT = %SUBST(PARM1:AOFF+1:ALEN) ;
                                                                                          //MD052679
        Else;                                                                             //MD052679
          T_MSWIP_AFT = %SUBST(PARM1:BOFF+1:BLEN);                                        //MD052679
                                                                                          //MD052679
        Endif;                                                                            //MD052679

          // Retrieve zone                                                                //MD031644
          WkZone = %TRIM(WP_MSWZONE);                                                     //MD031644

          // Retrieve qualifying FT subtypes from system values.                            MD031644
          Exsr SrRtvSysVals;                                                              //MD031644
                                                                                          //MD031644
          // Retrieve Front Office ID from OTPAYDD
          // using Payment Reference
          If WP_MSWACT='TR_REVERSE'
             and WP_MSWSTAT='AUTHORISED'
                and WP_MSWFOTID = *blanks;

          //*Branch*is*available*from*MSWTREF*at*pos*17-19*******                //MD031644 MD031980
            //  WKBRCA = %SUBST(WP_MSWTREF:17:3);                                //MD031644 MD031980
                                                                                         // MD031980
          // Only OPAY has the Front Office ID at pos 17-19, get the                     // MD031980
          // branch code from T_MSWIP Back Office Field Name 1 instead.                  // MD031980
                                                                                          //MD052679
             If WP_MSWBOFLD1 <> *blanks;                                                  //MD052679
                WKBRCA = %SUBST(WP_MSWBOFLD1:1:3);                                       // MD031980
             EndIf;                                                                       //MD052679
                                                                                          //MD031644
                If WP_MSWAPI = 'OPAY';
                // Exec SQL select frnt into :wFrontOffID from OTPAYDD                      MD031644
                //    where pref = left(:WP_MSWTREF,15);                                    MD031644
                Exec SQL select frnt into :wFrontOffID from GZOTPAYDD                     //MD031644
                      where pref = left(:WP_MSWTREF,15) and brca = :WKBRCA;               //MD031644
                ElseIf WP_MSWAPI = 'IPAY';                                                //MD031644
               //  Exec SQL select frnt into :wFrontOffID from INPAYDD                      MD031644
               //     where pref = left(:WP_MSWTREF,15);                                    MD031644
                   Exec SQL select frnt into :wFrontOffID from GZINPAYDD                  //MD031644
                      where pref = left(:WP_MSWTREF,15) and brca = :WKBRCA;               //MD031644
                EndIf;

             // If SQLCODE = 0;                                                             MD031644
                If SQLCODE = 0 and wFrontOffID <> *Blanks;                                //MD031644
                    WP_MSWFOTID = wFrontOffID;
                EndIf;

          EndIf;

          If (WP_MSWFOTID <> *blanks)
             and (WP_MSWAPI = 'IPAY' or WP_MSWAPI = 'OPAY');

           //Set file-specific variables ;
           // wTranIDKey = WP_MSWFOTID;                                                     MD031644
              wAPIName = WP_MSWAPI;

          // Exsr SrAPOUT;                                                                  MD031644
          // Retrieve subtype and branch from MSWDATA                                       MD031644
             Exsr SrExtMswdata;                                                           //MD031644
                                                                                          //MD031644
             Exsr SrProcessWip;

          EndIf;

       When PFLNAME = 'T_MSRPRQ';

        //T_MSRPQ_AFT = %SUBST(PARM1:BOFF+1:ALEN);                                          MD031644
                                                                                          //MD052680
        If TRGEVENT = DELETEMODE;                                                         //MD052680
          T_MSRPQ_AFT = %SUBST(PARM1:BOFF+1:BLEN);                                        //MD031644
                                                                                          //MD052680
        Else;                                                                             //MD052680
          T_MSRPQ_AFT = %SUBST(PARM1:AOFF+1:ALEN);                                        //MD052680
                                                                                          //MD052680
        Endif;                                                                            //MD052680

          // Retrieve zone                                                                  MD031644
          WkZone = %TRIM(RP_MSWZONE);                                                     //MD031644

          // Retrieve qualifying FT subtypes from system values.                            MD031644
          Exsr SrRtvSysVals;                                                              //MD031644
                                                                                          //MD031644
          If (RP_MSWFOTID <> *blanks)
             and (RP_MSWAPI = 'IPAY' or RP_MSWAPI = 'OPAY');

           //Set file-specific variables ;
           // wTranIDKey = RP_MSWFOTID;                                                     MD031644
              wAPIName = RP_MSWAPI;

          // Exsr SrAPOUT;                                                                //MD031644
          // Retrieve subtype and branch from MSWDATA                                       MD031644
             Exsr SrExtMswdata;                                                           //MD031644
                                                                                          //MD031644
             Exsr SrProcessRepair;

          EndIf;

       Endsl;

         //Check if CSC011 is installed                                                   //MD031644
         Exec SQL Select count(*) into :RecordCount                                       //MD031644
           from GZSCSARDPD                                                                //MD031644
            where SARN = 'CSC011';                                                        //MD031644
                                                                                          //MD031644
            If SQLCODE = 0 and RecordCount > 0;                                           //MD031644
               CSC011 = 'Y';                                                              //MD031644
            Else;                                                                         //MD031644
               CSC011 = 'N';                                                              //MD031644
            Endif;                                                                        //MD031644
                                                                                          //MD031644
       If  PTransID <> *blank
           and (CSC011 = 'N'
                 or %trim(PFrontID) <> 'MD'+PTransRf);

          // FT000988(PFrontID                                                              MD031644
          //          :PTransID                                                             MD031644
          //          :PTRansRF                                                             MD031644
          //          );                                                                    MD031644
                                                                                          //MD031644
        //Send details to data queue. This queue will be monitored                          MD031644
        //by zonal background job FTC000988 which will build the                            MD031644
        //status return message then send it to a MQ queue.                                 MD031644
                                                                                          //MD031644
        //Retrieve zone prefix                                                            //MD031644
         Exec SQL select ZOMSYS into :WkSysPfx                                            //MD031644
            from GPZONEPD                                                                 //MD031644
            where ZOZONE = :WkZone;                                                       //MD031644
                                                                                          //MD031644
         // Return error if record not found                                              //MD031644
         // or file access error encountered                                              //MD031644
            IF (SQLCOD < 0)                                                               //MD031644
               or (SQLCOD = 100);                                                         //MD031644
               DBPGM = PSPROCPGM;                                                         //MD031644
               DBKEY = WkZone;                                                            //MD031644
               DBFILE = 'GPZONEPD';                                                       //MD031644
               DBASE = 001;                                                               //MD031644
               Exsr *PSSR;                                                                //MD031644
            EndIf;                                                                        //MD031644
                                                                                          //MD031644
         // Set up parameters for QSNDDTAQ                                                //MD031644
            DtqNam = 'FTRETSDTQ';                                                         //MD031644
            DtqLib = WkSysPfx + 'DPLIB';                                                  //MD031644
            DtqLen = 60;                                                                  //MD031644
                                                                                          //MD031644
         // Concatenate Front Ofc ID, Trans Ref and Status                                //MD031644
         // into a single string                                                          //MD031644
            WkMsgDta = PFrontID + PTransID + PTransRF;                                    //MD031644
            DtqDta = WkMsgDta;                                                            //MD031644
                                                                                          //MD031644
       QSNDDTAQ(DtqNam                                                                    //MD031644
                :DtqLib                                                                   //MD031644
                :DtqLen                                                                   //MD031644
                :DtqDta                                                                   //MD031644
                );                                                                        //MD031644
       ENDIF;

        //Normal Termination
       *INLR = *On;
       Return;

      /Eject
       /////////////////////////////////////////////////////////////////                  //MD031644
       // SrAPOut Get info from APOUTPUTPD record                     //                  //MD031644
       /////////////////////////////////////////////////////////////////                  //MD031644
                                                                                          //MD031644
       //BegSr SrAPOut;                                                                   //MD031644
                                                                                          //MD031644
         //Clear WKPYST;                                                                  //MD031644
         //Clear WKBRCA;                                                                  //MD031644
                                                                                          //MD031644
            //Retrieve record of the passed transaction from APOUTPUTPD                   //MD031644
            //(filtered by front office transaction ID)                                   //MD031644
                                                                                          //MD031644
         //Exec SQL                                                                       //MD031644
               // select * into :APIData from APOUTPUTPD                                  //MD031644
                                                                                          //MD031644
               // -- Include XML formatted external input                                 //MD031644
               // where (                                                                 //MD031644
               //         substr(BUFFER,1,1) = '<' and                                    //MD031644
               //            locate(                                                      //MD031644
               //                   concat(                                               //MD031644
               //                          '<APFOTRANID>',                                //MD031644
               //                           trim(:wTranIDKey)                             //MD031644
               //                          )                                              //MD031644
               //                   ,BUFFER                                               //MD031644
               //                   ) > 0                                                 //MD031644
               //       )                                                                 //MD031644
               //                                                                         //MD031644
               // -- Include non-XML(flatfile) external input                             //MD031644
               // or    (                                                                 //MD031644
               //        substr(BUFFER,1,1) <> '<'                                        //MD031644
               //        and trim(substr(BUFFER,139,20))                                  //MD031644
               //        = trim(:wTranIDKey)                                              //MD031644
               //       )                                                                 //MD031644
               //                                                                         //MD031644
               // -- we only need to get 1 record for retrieval of                        //MD031644
               // -- branch and transaction subtype                                       //MD031644
               // fetch first row only;                                                   //MD031644
                                                                                          //MD031644
         //If  SQLCODE = 0;                                                               //MD031644
                                                                                          //MD031644
            //If FirstByte = '<';                                                         //MD031644
            //   Exsr SrXML;                                                              //MD031644
            //Else;                                                                       //MD031644
            //   Exsr SrFixFmt;                                                           //MD031644
            //ENDIF;                                                                      //MD031644
                                                                                          //MD031644
         //ENDIF;                                                                         //MD031644
                                                                                          //MD031644
           //Exec SQL close APOutput;                                                     //MD031644
                                                                                          //MD031644
        //EndSr;                                                                          //MD031644
       ////////////////////////////////////////////////////////////////                   //MD031644
                                                                                          //MD031644
       /Eject                                                                             //MD031644
       //////////////////////////////////////////////////////////////////                 //MD031644
       // SrRtvSysvals - retrieve required FT system values            //                 //MD031644
       //////////////////////////////////////////////////////////////////                 //MD031644
                                                                                          //MD031644
        BegSr SrRtvSysvals;                                                               //MD031644
                                                                                          //MD031644
         // Get qualifying deal subtypes for OP                                           //MD031644
         // in System Values file                                                         //MD031644
         Exec SQL select GIVAL into :OPSVal                                               //MD031644
            from GZSDSVALPD                                                               //MD031644
            where GISVAL ='FTRetStatusOP'and GIZONE = :WkZone;                            //MD031644
                                                                                          //MD031644
         // Return error if record not found                                              //MD031644
         // or file access error encountered                                              //MD031644
            IF (SQLCOD < 0)                                                               //MD031644
               or (SQLCOD = 100);                                                         //MD031644
               DBPGM = PSPROCPGM;                                                         //MD031644
               DBKEY = 'FTRetStatusOP';                                                   //MD031644
               DBFILE = 'GZSDSVALPD';                                                     //MD031644
               DBASE = 003;                                                               //MD031644
               Exsr *PSSR;                                                                //MD031644
            EndIf;                                                                        //MD031644
                                                                                          //MD031644
         // Get qualifying deal subtypes for IP                                           //MD031644
         // in System Values file                                                         //MD031644
         Exec SQL select GIVAL into :IPSVal                                               //MD031644
            from GZSDSVALPD                                                               //MD031644
            where GISVAL ='FTRetStatusIP'and GIZONE = :WkZone;                            //MD031644
                                                                                          //MD031644
         // Return error if record not found                                              //MD031644
         // or file access error encountered                                              //MD031644
            IF (SQLCOD < 0)                                                               //MD031644
               or (SQLCOD = 100);                                                         //MD031644
               DBPGM = PSPROCPGM;                                                         //MD031644
               DBKEY = 'FTRetStatusIP';                                                   //MD031644
               DBFILE = 'GZSDSVALPD';                                                     //MD031644
               DBASE = 004;                                                               //MD031644
               Exsr *PSSR;                                                                //MD031644
            EndIf;                                                                        //MD031644
          EndSr;                                                                          //MD031644
       ////////////////////////////////////////////////////////////////                   //MD031644
                                                                                          //MD031644
       /Eject                                                                             //MD031644
       //////////////////////////////////////////////////////////////////                 //MD031644
       // SrExtMswdata - retrieve FT details from MSWDATA WIP field    //                 //MD031644
       //////////////////////////////////////////////////////////////////                 //MD031644
                                                                                          //MD031644
        BegSr SrExtMswdata;                                                               //MD031644
           Clear WKPYST;                                                                  //MD031644
           Clear WKBRCA;                                                                  //MD031644
                                                                                          //MD031644
           // Retrieve record of the passed transaction from MSWDATA                      //MD031644
           // field from T_MSWIP.                                                         //MD031644
                                                                                          //MD031644
       Select;                                                                            //MD031644
       When PFLNAME = 'T_MSWIP';                                                          //MD031644
       Exec SQL                                                                           //MD031644
         Declare CursorA cursor for                                                       //MD031644
         Select CAST(MSWDATA AS VARCHAR(32000))                                           //MD031644
         From T_MSWIP where MSWID = :WP_MSWID;                                            //MD031644
       Exec SQL OPEN CursorA;                                                             //MD031644
       Exec SQL FETCH NEXT FROM CursorA INTO :P_MSWDATA;                                  //MD031644
                                                                                          //MD031644
       When PFLNAME = 'T_MSRPRQ';                                                         //MD031644
       Exec SQL                                                                           //MD031644
         Declare CurSorB cursor for                                                       //MD031644
         Select CAST(MSWDATA AS VARCHAR(32000))                                           //MD031644
         From T_MSWIP where MSWFOTID = :RP_MSWFOTID                                       //MD031644
                   and MSWACT = 'TR_INSERT'                                               //MD031644
                   and MSWSTAT = 'TO_AUTHORISE';                                          //MD031644
       Exec SQL OPEN CursorB;                                                             //MD031644
       Exec SQL FETCH NEXT FROM CursorB INTO :P_MSWDATA;                                  //MD031644
                                                                                          //MD031644
       // If T_MSRPRQ record not moved to T_MSWIP, it was rejected.                       //MD031644
          WkRprRej = 'N';                                                                 //MD031644
       If SQLCODE <> 0;                                                                   //MD031644
          WkRprRej = 'Y';                                                                 //MD031644
       EndIf;                                                                             //MD031644
                                                                                          //MD031644
       Endsl;                                                                             //MD031644
                                                                                          //MD031644
       If P_MSWDATA <> *Blanks;                                                           //MD031644
       If %SUBST(P_MSWDATA:1:1) = '<';                                                    //MD031644
        Exsr SrXML;                                                                       //MD031644
       Else;                                                                              //MD031644
        Exsr SrFixFmt;                                                                    //MD031644
       Endif;                                                                             //MD031644
       Endif;                                                                             //MD031644
                                                                                          //MD031644
        EndSr;                                                                            //MD031644
       ////////////////////////////////////////////////////////////////                   //MD031644

       /Eject
       ////////////////////////////////////////////////////////////////
       // SrXML Process XML type of APOUTPUTPD record                //
       ////////////////////////////////////////////////////////////////

        BegSr SrXML;

              If  wAPIName = 'IPAY';

              // Process IPAY transactions
              // xml-into WKPYST                                                          //MD031644
              //   %xml(APIData:'path=midasActionAPI/IPAY/DDPYST +                        //MD031644
              //     case=any');                                                          //MD031644
              //                                                                          //MD031644
              // xml-into WKBRCA                                                          //MD031644
              //   %xml(APIData:'path=midasActionAPI/IPAY/DDBRCA +                        //MD031644
              //     case=any');                                                          //MD031644
                                                                                          //MD031644
              // Retrieve payment subtype and branch                                      //MD031644
              If P_MSWDATA <> *Blanks;                                                    //MD031644
              Pos = %scan ('IPAY.DDPYST>' : P_MSWDATA);                                   //MD031644
              Pos = Pos + 12;                                                             //MD031644
              WKPYST= %SUBST(P_MSWDATA:Pos:2);                                            //MD031644
                                                                                          //MD031644
              Pos = %scan ('IPAY.DDBRCA>' : P_MSWDATA);                                   //MD031644
              Pos = Pos + 12;                                                             //MD031644
              WKBRCA= %SUBST(P_MSWDATA:Pos:3);                                            //MD031644
              EndIf;                                                                      //MD031644

              ElseIf wAPIName = 'OPAY';

              // Process OPAY transactions
              // xml-into WKPYST                                                          //MD031644
              //   %xml(APIData:'path=midasActionAPI/OPAY/SPYST +                         //MD031644
              //     case=any');                                                          //MD031644
              //                                                                          //MD031644
              // xml-into WKBRCA                                                          //MD031644
              //   %xml(APIData:'path=midasActionAPI/OPAY/SBRCA +                         //MD031644
              //     case=any');                                                          //MD031644
                                                                                          //MD031644
              // Retrieve payment subtype and branch                                      //MD031644
              If P_MSWDATA <> *Blanks;                                                    //MD031644
              Pos = %scan ('OPAY.SPYST>' : P_MSWDATA);                                    //MD031644
              Pos = Pos + 11;                                                             //MD031644
              WKPYST= %SUBST(P_MSWDATA:Pos:2);                                            //MD031644
                                                                                          //MD031644
              Pos = %scan ('OPAY.SBRCA>' : P_MSWDATA);                                    //MD031644
              Pos = Pos + 11;                                                             //MD031644
              WKBRCA= %SUBST(P_MSWDATA:Pos:3);                                            //MD031644
              EndIf;                                                                      //MD031644

              EndIf;

        EndSr;
       ////////////////////////////////////////////////////////////////

       /Eject
       ////////////////////////////////////////////////////////////////
       // SrFixFmt Process Fix Format type of APOUTPUTPD record      //
       ////////////////////////////////////////////////////////////////

        BegSr SrFixFmt;

           If wAPIName = 'IPAY';
           // WKBRCA = %subst(APIData:217:3);                                             //MD031644
           // WKPYST = %subst(APIData:223:2);                                             //MD031644
              WKBRCA = %subst(P_MSWDATA:217:3);                                           //MD031644
              WKPYST = %subst(P_MSWDATA:223:2);                                           //MD031644

           ElseIf wAPIName = 'OPAY';
           // WKBRCA = %subst(APIData:217:3);                                             //MD031644
           // WKPYST = %subst(APIData:225:2);                                             //MD031644
              WKBRCA = %subst(P_MSWDATA:217:3);                                           //MD031644
              WKPYST = %subst(P_MSWDATA:225:2);                                           //MD031644

           EndIf;

        ENDSR;
       ////////////////////////////////////////////////////////////////

       /EJECT
       ////////////////////////////////////////////////////////////////
       // SrProcessWip - Process WIP record                          //
       ////////////////////////////////////////////////////////////////

        BegSr SrProcessWip;

              genTrnStatus = *Off;

           // Ascertain if Transactions Status Message generation
           //  is necessary

              If wAPIName = 'IPAY';

                 If (IPSVal = *blanks)
                    or (%lookup(wkPYST:IPSubtype)) > 0;
                    genTrnStatus = *On;
                 EndIf;

              ElseIf wAPIName = 'OPAY';

                 If (OPSVal = *blanks)
                    or %lookup(wkPYST:OPSubtype) > 0;
                    genTrnStatus = *On;
                 EndIf;

              Endif;


           // Setup parameters for Message Generation
           If genTrnStatus;
              PFrontID = WP_MSWFOTID;
              PTransRF = WP_MSWTREF;
              PTransID = *blanks;

              Select;

                  When (WP_MSWACT = 'TR_INSERT')
                       and WP_MSWSTAT = 'AUTHORISED';

                      PTransID = 'PENDING';

                  When (WP_MSWACT = 'TR_INSERT')
                       and WP_MSWSTAT = 'REJECTED';

                      PTransID = 'AUTHREJECTED';

                  When (WP_MSWACT = 'TR_REVERSE')
                       and WP_MSWSTAT = 'AUTHORISED';

                      PTransID = 'AUTHREJECTED';

               EndSl;

              //If Authorise Rejected, check further
              //if due to Watch List Checking Failure

           // If (WP_MSWACT = 'TR_REVERSE')                                               //MD031644
           //          and WP_MSWSTAT = 'AUTHORISED';                                     //MD031644
           //                                                                             //MD031644
           //    If WP_MSWAPI = 'IPAY';                                                   //MD031644
           //        KFUNT ='INPAYDD';                                                    //MD031644
           //    ElseIf WP_MSWAPI = 'OPAY';                                               //MD031644
           //        KFUNT ='OTPAYDD';                                                    //MD031644
           //    EndIf;                                                                   //MD031644
           //                                                                             //MD031644
           //    KIDEN = %subst(WP_MSWTREF:1:15);                                         //MD031644
           //    KBRCA = WKBRCA;                                                          //MD031644
           //                                                                             //MD031644
           //    Exec SQL                                                                 //MD031644
           //       select count(*) into :RecordCount from SDCWHTL1                       //MD031644
           //          where W3FUNT = :KFUNT                                              //MD031644
           //            and W3IDEN = :KIDEN                                              //MD031644
           //            and W3BRCH = :KBRCA                                              //MD031644
           //            and W3TREL <> 'Y';                                               //MD031644

           //    If SQLCODE = 0 and RecordCount > 0;                                      //MD031644
           //        PTransID = 'WLCREJECTED';                                            //MD031644
           //    EndIf;                                                                   //MD031644

           // EndIf;                                                                      //MD031644

            Endif;

        ENDSR;

       ////////////////////////////////////////////////////////////////

      /EJECT
       ////////////////////////////////////////////////////////////////
       // SrProcessRepair - Process Repair record                    //
       ////////////////////////////////////////////////////////////////

       Begsr SrProcessRepair;

          // only process deleted record here
          If not (TRGEVENT = '2');
             LeaveSR;
          EndIf;

          genTrnStatus = *Off;

          If wAPIName = 'IPAY';

             If (IPSVal = *blanks)
              //or %lookup(wkPYST:IPSubtype) > 0;                                           MD031644
                or %lookup(wkPYST:IPSubtype) > 0                                          //MD031644
                or (wkPYST = *blanks and WkRprRej = 'Y');                                 //MD031644
                   genTrnStatus = *On;
             EndIf;

          ElseIf wAPIName = 'OPAY';

             If (OPSVal = *blanks)
              //or %lookup(wkPYST:OPSubtype) > 0;                                           MD031644
                or %lookup(wkPYST:OPSubtype) > 0                                          //MD031644
                or (wkPYST = *blanks and WkRprRej = 'Y');                                 //MD031644
                   genTrnStatus = *On;
             EndIf;

          Endif;

          // Setup parameters for Message Generation
          If genTrnStatus;
                PFrontID = RP_MSWFOTID;
                PTransRF = RP_MSWTREF;
                PTransID = *BLANKS;
                Clear RecordCount;

                Exec SQL Select count(*) into :RecordCount
                  from T_MSWIP
                   where MSWFOTID = :RP_MSWFOTID
                   and MSWACT = 'TR_INSERT'
                   and MSWSTAT = 'TO_AUTHORISE';

                If SQLCODE = 0 and RecordCount > 0;
                   PTransID = 'REPAIRED';

                // If 2_eyes setting, may not have record in T_MSWIP
                // Check if record inserted directly into OTPAYDD/INPAYDD
                ElseIf RecordCount = 0;
                   If wAPIName = 'OPAY';
                  //  Exec SQL Select count(*) into :RecordCount                          //MD031644
                  //     from OTPAYDD                                                     //MD031644
                  //        where frnt = :RP_MSWFOTID;                                    //MD031644
                                                                                          //MD031644
                      Exec SQL Select count(*) into :RecordCount                          //MD031644
                         from GZOTPAYDD                                                   //MD031644
                  //        where frnt = :RP_MSWFOTID and brca = :WKBRCA;        //MD031644 MD032064
                            where frnt = :RP_MSWFOTID;                                    //MD032064

                   ElseIf wAPIName = 'IPAY';
                  //  Exec SQL Select count(*) into :RecordCount                          //MD031644
                  //     from INPAYDD                                                     //MD031644
                  //        where frnt = :RP_MSWFOTID;                                    //MD031644
                                                                                          //MD031644
                      Exec SQL Select count(*) into :RecordCount                          //MD031644
                         from GZINPAYDD                                                   //MD031644
                  //        where frnt = :RP_MSWFOTID and brca = :WKBRCA;        //MD031644 MD032064
                            where frnt = :RP_MSWFOTID;                                    //MD032064

                   EndIf;

                   If SQLCODE = 0 and RecordCount > 0;
                      PTransID = 'REPAIRED';
                   EndIf;

                EndIf;

                //No record in T_MSWIP and OTPAYDD/INPAYDD
                //means not repaired (deleted)
                If RecordCount = 0;
                   PTransID = 'REJECTED';
                EndIf;

          EndIf;


       ENDSR;

       ////////////////////////////////////////////////////////////////
      /end-free
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

      /FREE
       BEGSR *PSSR;

         IF @RUN = *BLANK;
            @RUN = 'Y';
            DUMP;

         ENDIF;

         *INU7 = *ON;
         *INU8 = *ON;
         *INLR = *ON;
         RETURN;

       ENDSR;
      /END-FREE

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

      /FREE
       Begsr *INZSR;

         //Check if CFT158 is installed
       //AOSARDR0(pRTCD:                                                                  //MD031644
       //         '*VERIFY':                                                              //MD031644
       //          CFT158:                                                                //MD031644
       //          DSFDY);                                                                //MD031644
                                                                                          //MD031644
         GPAOSARDR0(pRTCD:                                                                //MD031644
                    '*VERIFY':                                                            //MD031644
                    'CFT158');                                                            //MD031644

         If pRTCD = *blanks;
            CFT158 = 'Y';
         ElseIf pRTCD = '*NRF';
            CFT158 = 'N';
         Else;
             DBPGM = PSPROCPGM;
             DBKEY = 'CFT158';
          // DBFILE = 'SCSARDPD';                                                           MD031644
             DBFILE = 'GPSARDPD';                                                         //MD031644
             DBASE = 002;
             Exsr *PSSR;
         EndIf;

         //Only proceed if CFT158 is on
         If CFT158 = 'N';
            *INLR = *On;
            Return;
         Endif;

       //AOSARDR0(pRTCD:                                                                  //MD031644
       //         '*VERIFY':                                                              //MD031644
       //          CSC011:                                                                //MD031644
       //          DSFDY);                                                                //MD031644
       //                                                                                 //MD031644
       //If pRTCD = *blanks;                                                              //MD031644
       //   CSC011 = 'Y';                                                                 //MD031644
       //ElseIf pRTCD = '*NRF';                                                           //MD031644
       //   CSC011 = 'N';                                                                 //MD031644
       //Else;                                                                            //MD031644
       //    DBPGM = PSPROCPGM;                                                           //MD031644
       //    DBKEY = 'CSC011';                                                            //MD031644
       //    DBFILE = 'SCSARDPD';                                                         //MD031644
       //    DBASE = 001;                                                                 //MD031644
       //    Exsr *PSSR;                                                                  //MD031644
       //EndIf;                                                                           //MD031644


       //  If GetMidasSysVal('FTRetStatusOP':                                             //MD031644
       //        OPSVal        :                                                          //MD031644
       //        'FTRetStatusIP':                                                         //MD031644
       //        IPSVal                                                                   //MD031644
       //        ) <> *Blanks;                                                            //MD031644
       //                                                                                 //MD031644
       //    Select;                                                                      //MD031644
       //                                                                                 //MD031644
       //    When OPSVal = '*NRF';                                                        //MD031644
       //      DBPGM = PSPROCPGM;                                                         //MD031644
       //      DBKEY = 'FTRetStatusOP';                                                   //MD031644
       //      DBFILE = 'SDSVALPD';                                                       //MD031644
       //      DBASE = 003;                                                               //MD031644
       //      Exsr *PSSR;                                                                //MD031644
       //                                                                                 //MD031644
       //    When IPSVal = '*NRF';                                                        //MD031644
       //      DBPGM = PSPROCPGM;                                                         //MD031644
       //      DBKEY = 'FTRetStatusIP';                                                   //MD031644
       //      DBFILE = 'SDSVALPD';                                                       //MD031644
       //      DBASE = 004;                                                               //MD031644
       //      Exsr *PSSR;                                                                //MD031644
       //                                                                                 //MD031644
       //    ENDSL;                                                                       //MD031644
       //                                                                                 //MD031644
       //  EndIf;                                                                         //MD031644

       ENDSR;
      /END-FREE

      *****************************************************************
      /EJECT
      *****************************************************************
      **/COPY*ZACPYSRC,PIGETMDSVL                                                         //MD031644


