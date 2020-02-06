     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer/Authority Holder Screen Input')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUAHSIN - Midas SD Customer/Authority Holder Link Maint.   *
      *                                                               *
      *  Function:  This module will display the Customer/Authority   *
      *             Holders                                           *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG23774           Date 20Apr09               *
      *                 BUG22115           Date 13Jan09               *
      *                 CER034  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23774 - Updates are not committed                         *
      *  BUG22115 - Customer/Authority Holder Link screen does not    *
      *             allow single add of record                        *
      *  CER034 - German Features LF046 - New Fields and Enquiries    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRLdSrnFmt - Subroutine to Load Screen Format                *
      *  SRUpdate   - Perform Update Operation                        *
      *  SRReset    - Clear/Reset                                     *
      *  SRCpyMsg   - Copy Mesages to Dsp MSGIDARR                    *
      *  SRPopcuah  - Populate all authority holders                  *
      *  SRF03      - Exit From Program                               *
      *  SRF05      - Refresh the subfile screen                      *
      *  SRF12      - Return to Calling Screen                        *
      *  SRF09      - Subroutine To Insert New Record -               *
      *               Toggle between Add and Change mode              *
      *  SREnter    - Process enter key after subfile display         *
      *  SRDftSrnFmt- Default Screen Fmt with PRDGRP1 = 'AL'          *
      *  SRValid  -   Perform Validation                              *
      *  *INZSR   -   Program initialization routine                  *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Customer/Authority holder Link - retrieval index
      *
     FSDCUAHL1  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                            error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for
      ** error and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** External DS for Authority holder's Link Screen
      *
     D*SDCUAH**      E DS                  EXTNAME(SDCUADPD)                                  CER059
     D SDCUAH        E DS                  EXTNAME(SDCUADPD1)                                 CER059
     D                                     PREFIX(B)
      *
      ** External DS for Authority holder's Link
      *
     D SDVCUAH       E DS                  EXTNAME(SDVCUAHPD)
      *
      ** External DS for Customer Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** First DS for Access Programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D*NewScreenFmt  E DS                  EXTNAME(SDCUADPD)                                  CER059
     D NewScreenFmt  E DS                  EXTNAME(SDCUADPD1)                                 CER059
     D                                     PREFIX(N)
      *
     D*OldScreenFmt  E DS                  EXTNAME(SDCUADPD)                                  CER059
     D OldScreenFmt  E DS                  EXTNAME(SDCUADPD1)                                 CER059
     D                                     PREFIX(M)
      *
      ** OK Flags
      *
     D OKCuahDS      E DS                  EXTNAME(SDECUAHPD)
      *
     D SDCuahTemp      DS            22
      *
     D OKCuahTemp      DS             7
      *
     D UpdKey          DS
     D  UpCust                 1      6
     D  UpAuth                 7     16
     D  UpLtyp                17     18
      *
     D FldCuArr        S             22A   DIM(1950)
     D OldFldCuArr     S             22A   DIM(1950)
     D OKCuArr         S              7A   DIM(1950)
     D ActnArr         S              1A   DIM(1950)
     D ActnOK          S              1A   DIM(1950)
      *
     D FLDnOK          S              1A   DIM(1950)
      *
     D FldNameArr1     S             10A   DIM(ArrayMax)
      *
      ** Array of error message IDs
      *
     D MsgIDArr1       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
      *
      ** Array of error message data.
      *
     D MsgDtaArr1      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
      *
      ** Array of Fields with warnings.
      *
     D WFldNamArr1     S             10A   DIM(ArrayMax)
      *
      ** Array of warning message IDs
      *
     D WMsgIDArr1      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
      *
      ** Array of warning message data.
      *
     D WMsgDtaArr1     S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for Access Objects
      *
     D PEdtft          S              1A
     D PRtcd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PCnt            S              5P 0
     D PActnCd         S              1A
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D Ix              S              3P 0
     D PAuthNum        S              4S 0
     D PErrorIndex     S              3P 0
     D WIndx           S              5P 0
      *
      ** Other Variables
      *
     D WCount          S              5P 0
     D WCtr            S              5P 0
     D WCtr1           S              5P 0
     D WErr            S              1A   INZ('N')
     D Wi              S              1P 0
     D WExit           S              1A
     D WCountrcd       S              5P 0
     D WKCust          S              6A
     D WMode           S              4A
     D WAuth           S             10A
     D WLtyp           S              2A
      *
      ** F3 Exit
      *
     D PINKC           S              1A
      *
      ** F9 Insert
      *
     D PINKI           S              1A
      *
      ** F12 Cancel
      *
     D PINKL           S              1A
      *
      ** F5  Refresh
      *
     D PINKE           S              1A
      *
      ** Customer Number
      *
     D DDCUST          S              6A
      *
      ** Action Code
      *
     D DDACTN          S              1A
      *
      ** Action Code
      *
     D DDSELC          S              1A
      *
      ** This is always 'S' for Synchronous
      *
     D RespMode        S              1A   INZ('S')
     D PCallFrom       S              3A
     D WOld            S              4P 0
      *
     D WTotRec         S              5P 0 INZ(0)
     D PTotRcd         S              5P 0 INZ(0)
     D WErmn           S              1A   INZ('N')
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Main Processing
      *
     C                   EVAL      WKCust = DDCUST
      *
      ** Load all the records for CUAH into Array
      *
     C                   EXSR      SRPopcuah
      *
      ** Load the first 150 records from array to Screen Fotrmats
      *
     C                   EXSR      SRLdSrnFmt
      *
      ** Set the mode
      *
     C                   EVAL      WMode = '*CHG'
      *
      ** Perform until exit requested Using F03
      *
     C                   DOW       WExit = *OFF
      *
     C                   IF        WErmn = 'N'
     C                   EVAL      OldFldCuArr = FldCuArr
     C                   ENDIF
      *
     C                   CALLB     'SDCUAHDSP'
     C                   PARM                    Returncode
     C                   PARM                    DDACTN
     C                   PARM                    DDCUST
     C                   PARM                    WMode
     C                   PARM                    NewScreenfmt
     C                   PARM                    OldScreenfmt
     C                   PARM                    FldCuArr
     C                   PARM                    FldNameArr1
     C                   PARM                    MsgIDArr1
     C                   PARM                    MsgDtaArr1
     C                   PARM                    WFldNamArr1
     C                   PARM                    WMsgIDArr1
     C                   PARM                    WMsgDtaArr1
     C                   PARM                    ActnOK
     C                   PARM                    ActnArr
     C                   PARM      'SIN'         PCallFrom
     C                   PARM      *BLANKS       PEdtft
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKI
     C                   PARM                    PINKL
     C                   PARM                    OKCuahDS
     C                   PARM                    OKCuArr
     C                   PARM                    PTotRcd
      *
     C     PINKC         CASEQ     '1'           SRF03
     C     PINKL         CASEQ     '1'           SRF12
     C     PINKI         CASEQ     '1'           SRF09
     C     PINKE         CASEQ     '1'           SRF05
     C                   CAS                     SREnter
      *
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPopcuah - Populate all authority holders                    *
      *                                                               *
      *  Called By: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRPopcuah     BEGSR
      *
     C                   EXSR      SRReset
     C                   EVAL      WIndx = *ZEROS
      *
     C     WKCust        SETLL     SDCUAHL1
     C     WKCust        READE     SDCUAHL1
     C                   IF        %EOF(SDCUAHL1)
     C                   EVAL      FldCuArr = *BLANKS
     C                   EVAL      PTotRcd = 0                                              BUG22115
      *
     C                   ELSE
      *
     C                   DOW       NOT %EOF(SDCUAHL1)
      *
     C                   EVAL      WIndx  = WIndx + 1
      *
     C                   EVAL      %SUBST(FldCuArr(WIndx):1:10) =
     C                             CAAUTH
     C                   EVAL      %SUBST(FldCuArr(WIndx):11:2) =
     C                             CALTYP
     C                   EVAL      %SUBST(FldCuArr(WIndx):13:2) =
     C                             CAPRG1
     C                   EVAL      %SUBST(FldCuArr(WIndx):15:2) =
     C                             CAPRG2
     C                   EVAL      %SUBST(FldCuArr(WIndx):17:2) =
     C                             CAPRG3
     C                   EVAL      %SUBST(FldCuArr(WIndx):19:2) =
     C                             CAPRG4
     C                   EVAL      %SUBST(FldCuArr(WIndx):21:2) =
     C                             CATYPA
      *
     C     WKCust        READE     SDCUAHL1
      *
     C                   ENDDO
      *
     C                   EVAL      WTotRec = WIndx
     C                   EVAL      PTotRcd = WTotRec
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset: Clear/Reset Fields                                  *
      *                                                               *
      *  Called by: Main Processing, SRDFtSrnFmt                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReset       BEGSR
      *
     C                   CLEAR                   OldScreenFmt
     C                   CLEAR                   NewScreenFmt
     C                   CLEAR                   FldCuArr
     C                   CLEAR                   OKCuahDS
     C                   CLEAR                   OKCuArr
     C                   RESET                   WExit
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLdSrnFmt - Subroutine to Load Screen Format                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRLdSrnFmt    BEGSR
      *
     C                   EVAL      WCountrcd = 1
      *
     C                   EVAL      %SUBST(OldScreenFmt:1:6) = DDCUST
      *
     C                   EVAL      WOld = 7
      *
     C                   DOW       WCountrcd <= 150
      *
     C                   EVAL      %SUBST(OldScreenFmt:WOld:22) =
     C                             FldCuArr(WCountrcd)
      *
     C                   EVAL      WOld = WOld + 22
      *
     C                   EVAL      WCountrcd = WCountrcd + 1
      *
     C                   ENDDO
      *
      ** Load New Screen Format
      *
     C                   EVAL      NewScreenFmt = OldScreenFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnter - Process enter key after subfile display            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: SRValid,SRUpdate                                      *
      *                                                               *
      *****************************************************************
      *
     C     SREnter       BEGSR
      *
      ** Clear all the array and ok flags
      *
     C                   RESET                   FldNameArr1
     C                   RESET                   MsgIDArr1
     C                   RESET                   MsgDtaArr1
     C                   RESET                   WFldNamArr1
     C                   RESET                   WMsgIDArr1
     C                   RESET                   WMsgDtaArr1
     C                   RESET                   OKCuArr
     C                   CLEAR                   ActnOK
      *
     C                   EVAL      WErmn = 'N'
     C                   EVAL      WCtr = 1
      *
     C                   DOW       WCtr <= PTotRcd
      *
     C                   EVAL      WErr = 'N'
      *
      ** Check for Duplicate Records
      *
     C                   IF        FldCuArr(WCtr) <> *BLANKS AND
     C                             %SUBST(FldCuArr(WCtr):1:12)
     C                             <> *BLANKS
     C                   EXSR      SRChkDup
     C                   ENDIF
      *
     C                   IF        WErr = 'N'
      *
     C                   IF        (%SUBST(OldFldCuArr(WCtr):1:12) <>
     C                             %SUBST(FldCuArr(WCtr):1:12))
      *
      ** Populate Key Fields
      *
     C                   EVAL      WAuth  =
     C                             %SUBST(FldCuArr(WCtr):1:10)
     C                   EVAL      WLtyp =
     C                             %SUBST(FldCuArr(WCtr):11:2)
      *
     C     KLPrvK        CHAIN(N)  SDCUAHL1
      *
     C                   IF        %FOUND(SDCUAHL1)
     C                   EVAL      Wi = 1
     C                   EVAL      Wi =
     C                             %LOOKUP('USR5998':MsgIDArr1(Wi))
      *
     C                   IF        Wi = *ZEROS
     C                   EVAL      Wi = 1
     C                   EVAL      Wi =
     C                             %LOOKUP(*BLANKS:MsgIDArr1(Wi))
     C                   EVAL      MsgIDArr1(WI) = 'USR5998'
     C                   ENDIF
     C                   EVAL      %SUBST(OKCuArr(WCtr):1:1) = 'N'
     C                   EVAL      %SUBST(OKCuArr(WCtr):2:1) = 'N'
     C                   EVAL      WErr = 'Y'
     C                   EVAL      WErmn = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      ** Mode '*CHG'
      *
     C                   IF        WMode = '*CHG'
      *
      ** Validate Action Code D OR ' '
      *
     C                   IF        ActnArr(WCtr) <> ' ' AND
     C                             ActnArr(WCtr) <> 'D'
     C                   EVAL      Wi = 1
     C                   EVAL      Wi =
     C                             %LOOKUP('USR5990':MsgIDArr1(Wi))
      *
     C                   IF        Wi = *ZEROS
     C                   EVAL      Wi = 1
     C                   EVAL      Wi =
     C                             %LOOKUP(*BLANKS:MsgIDArr1(Wi))
     C                   EVAL      MsgIDArr1(Wi) = 'USR5990'
     C                   ENDIF
      *
     C                   EVAL      ActnOK(WCtr) = 'N'
     C                   EVAL      WErr = 'Y'
     C                   EVAL      WErmn = 'Y'
      *
     C                   ENDIF
      *
     C                   IF        OldFldCuArr(WCtr) <>
     C                             FldCuArr(WCtr) AND
     C                             WErr = 'N'
      *
     C                   EXSR      SRValid
     C                   IF        Idx <> 0
     C                   EXSR      SRCpyMsg
     C                   EVAL      WErmn = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
     C                   ELSE
      *
      ** Mode '*ADD'
      *
     C                   IF        WErr = 'N'
     C                             AND FldCuArr(WCtr) <> *BLANKS                            BUG22115
     C                   EXSR      SRValid
     C                   IF        Idx <> 0
     C                   EXSR      SRCpyMsg
     C                   EVAL      WErmn = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
      *
     C                   IF        WErmn = 'Y'
     C                   IF        WMode = '*ADD'
     C                   EVAL      WIndx = 1
     C                   EVAL      WIndx =
     C                             %LOOKUP(*BLANKS:FldCuArr(WIndx))
     C                   IF        WIndx <> 0
     C                   EVAL      WCountrcd = WIndx
     C                   EXSR      SRDftSrnFmt
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      *
     C                   EVAL      WCtr = 1
     C                   DOW       WCtr <= PTotRcd
     C                   IF        FldCuArr(WCtr) <> *BLANKS                                BUG22115
     C                   IF        (WMODE = '*ADD' OR
     C                             (WMODE = '*CHG' AND
     C                             (ACTNARR(WCTR) <> *BLANKS) OR
     C                             (OldFldCuArr(WCtr) <>
     C                             FldCuArr(WCtr))))
     C                   EXSR      SRUpdate
     C                   ENDIF
     C                   ENDIF                                                              BUG22115
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
      *
      ** Load all the records for CUAH into Array
      *
     C                   EXSR      SRPopcuah
      *
     C                   IF        WMode = '*CHG'
      *
      ** Load the first 150 records from array to Screen Fotrmats
      *
     C                   EXSR      SRLdSrnFmt
      *
     C                   ELSE
      *
      ** Default Screen Fmt with PRDGRP1 = 'AL'
      *
     C                   EXSR      SRReset
     C                   EVAL      WCountrcd = 1
     C                   EXSR      SRDftSrnFmt
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkDup - Check for Duplicate records in Subfile            *
      *                                                               *
      *  Called By: SREnter                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRChkDup      BEGSR
      *
     C                   EVAL      WCtr1 =  1
      *
     C                   DOW       WCtr1 <= PTotRcd
      *
     C                   IF        WCtr1 <> Wctr
      *
     C                   IF        %SUBST(FldCuArr(WCtr):1:12) =
     C                             %SUBST(FldCuArr(WCtr1):1:12)
      *
     C                   EVAL      WErr = 'Y'
     C                   EVAL      WErmn = 'Y'
      *
     C                   EVAL      %SUBST(OKCuArr(WCTR1):1:2) = 'NN'
      *
     C                   EVAL      Wi = 1
     C                   EVAL      Wi =
     C                             %LOOKUP('USR5998':MsgIDArr1(Wi))
     C                   IF        Wi = *ZEROS
     C                   EVAL      Wi = 1
     C                   EVAL      Wi =
     C                             %LOOKUP(*BLANKS:MsgIDArr1(Wi))
     C                   EVAL      MsgIDArr1(WI) = 'USR5998'
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      WCtr1 = WCtr1 + 1
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCpyMsg - Copy Mesages to Dsp MSGIDARR                      *
      *                                                               *
      *  Called By: SREnter                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCpyMsg      BEGSR
      *
     C                   EVAL      Ix = 1
     C                   DOW       MsgIdArr(Ix) <> *BLANKS
      *
     C                   EVAL      Wi = 1
     C                   EVAL      Wi =
     C                             %LOOKUP(MsgIdArr(Ix):MsgIDArr1(Wi))
      *
     C                   IF        Wi = *ZEROS
     C                   EVAL      Wi = 1
     C                   EVAL      Wi = %LOOKUP(*BLANKS:MsgIDArr1(WI))
     C                   EVAL      MsgIDArr1(WI) = MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValid - Perform Validation                                 *
      *                                                               *
      *  Called By: SREnter                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRValid       BEGSR
      *
     C                   EVAL      SDCuAhTemp = FldCuArr(WCtr)
      *
     C                   EVAL      Idx = *ZEROS
      *
     C                   EVAL      WIdx = *ZEROS
      *
     C                   EVAL      OKCuahTemp = *ALL'Y'
      *
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr = *BLANKS
     C                   EVAL      MsgDtaArr = *BLANKS
      *
     C                   EVAL      WFldNamArr = *BLANKS
     C                   EVAL      WMsgIdArr = *BLANKS
     C                   EVAL      WMsgDtaArr = *BLANKS
      *
     C                   CALLB     'SDCUAHVAL'
     C                   PARM      *BLANKS       RespMode
     C                   PARM      *ZEROS        PAuthNum
     C                   PARM                    DDCUST
     C                   PARM                    SDCuAhTemp
     C                   PARM                    OKCuahTEMP
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM      *ZEROS        PErrorIndex
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    SDVCUAH
      *
     C                   IF        %SUBST(FldCuArr(WCtr):1:1) = '?'
     C                   EVAL      %SUBST(FldCuArr(WCtr):1:10) =
     C                             %SUBST(SDCuAhTemp:1:10)
     C                   ENDIF
      *
     C                   EVAL      OKCuArr(WCtr) = OKCuAhTemp
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Perform Update Operation                          *
      *                                                               *
      *  Called By: SREnter                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdate      BEGSR
      *
     C                   EVAL      UpCust  = DDCUST
      *
     C                   EVAL      UpAuth =
     C                             %SUBST(OldFldCuArr(WCtr):1:10)
     C                   EVAL      UpLtyp =
     C                             %SUBST(OldFldCuArr(WCtr):11:2)
      *
     C                   EVAL      SDVCUAH = DDCUST + FldCuArr(WCtr)
      *
     C                   IF        WMode = '*CHG' AND
     C                             ACtnarr(WCtr) = *BLANKS
     C                   EVAL      ACTYLC = 'A'
     C                   ENDIF
      *
     C                   IF        WMode = '*ADD' AND
     C                             ACtnarr(WCtr) = *BLANKS
     C                   EVAL      ACTYLC = 'I'
     C                   ENDIF
      *
     C                   IF        ACtnarr(WCtr) = 'D'
     C                   EVAL      ACtnarr(WCtr) = *BLANKS
     C                   EVAL      ACTYLC = 'D'
     C                   ENDIF
      *
     C                   CALLB     'SDCUAHUPD'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    UpdKey
     C                   PARM                    SDVCUAH
      *
      ** If there were any errors in the update functions, rollback any updates and         BUG23774
      ** end this program. Otherwise, commit the updates                                    BUG23774
                                                                                            BUG23774
     C                   IF        PRtcd <> *BLANK AND                                      BUG23774
     C                             PRtcd <> '*RECUPD'                                       BUG23774
     C                   ROLBK                                                              BUG23774
     C                   EXSR      *PSSR                                                    BUG23774
     C                   ELSE                                                               BUG23774
                                                                                            BUG23774
     C                   IF        PRtcd = '*RECUPD'                                        BUG23774
     C                   ROLBK                                                              BUG23774
     C                   ELSE                                                               BUG23774
     C                   COMMIT                                                             BUG23774
     C                   ENDIF                                                              BUG23774
                                                                                            BUG23774
     C                   ENDIF                                                              BUG23774
                                                                                            BUG23774
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF09 - F09 key subroutine - toggle between                  *
      *          add and change WMode                                 *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRF09         BEGSR
      *
     C                   EVAL      PINKI = '0'
     C                   EVAL      WErmn = 'N'
      *
     C                   EXSR      SRpopCuah
      *
     C                   IF        WMode = '*CHG'
      *
     C                   EVAL      WMode = '*ADD'
     C                   EXSR      SRReset
     C                   EVAL      WCountrcd = 1
     C                   EXSR      SRDftSrnFmt
      *
     C                   ELSEIF    WMode = '*ADD'
      *
     C                   EVAL      WMode = '*CHG'
     C                   EXSR      SRLdSrnFmt
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF05 - F05 key subroutine                                   *
      *                                                               *
      *  Called By: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRF05         BEGSR
      *
      ** Remove previous error messages
      *
     C                   EVAL      PINKE = '0'
     C                   EVAL      WErmn = 'N'
     C                   RESET                   FldCuArr
     C                   RESET                   FldNameArr1
     C                   RESET                   MsgIDArr1
     C                   RESET                   MsgDtaArr1
     C                   RESET                   WFldNamArr1
     C                   RESET                   WMsgIDArr1
     C                   RESET                   WMsgDtaArr1
     C                   CLEAR                   OkCuahDS
     C                   CLEAR                   OKCuArr
     C                   CLEAR                   ActnOK
     C                   CLEAR                   ActnArr
      *
      ** Load all the records for CUAH into Array
      *
     C                   EXSR      SRPopcuah
      *
     C                   IF        WMode = '*ADD'
      *
     C                   EXSR      SRReset
     C                   EVAL      WCountrcd = 1
     C                   EXSR      SRDftSrnFmt
      *
     C                   ELSEIF    WMode = '*CHG'
      *
      ** Load the first 150 records from array to Screen Fotrmats
      *
     C                   EXSR      SRLdSrnFmt
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF03 - F03 key subroutine                                   *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRF03         BEGSR
      *
      ** Set exit program flag
      *
     C                   EVAL      WExit = *ON
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRF12 - F12 key subroutine                                   *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRF12         BEGSR
      *
      ** Remove previous error messages
      *
     C                   EVAL      WErmn = 'N'
     C                   CLEAR                   OldFldCuArr
     C                   CLEAR                   FldNameArr1
     C                   CLEAR                   MsgIDArr1
     C                   CLEAR                   MsgDtaArr1
     C                   CLEAR                   WFldNamArr1
     C                   CLEAR                   WMsgIDArr1
     C                   CLEAR                   WMsgDtaArr1
     C                   CLEAR                   OkCuahDS
     C                   CLEAR                   OKCuArr
     C                   CLEAR                   ActnOK
     C                   CLEAR                   ActnArr
     C                   EXSR      SRReset
      *
      ** Return From Program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDftSrnFmt - Default Screen Fmt with PRDGRP1 = 'AL'         *
      *                                                               *
      *  Called By: SRF05                                             *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRDftSrnFmt   BEGSR
      *
      *
     C                   EVAL      %SUBST(OldScreenFmt:1:6) = DDCUST
      *
     C**********                                                                            BUG22115
     C**********         EVAL      WOld = 7                                                 BUG22115
      **********                                                                            BUG22115
     C**********         DOW       WCountrcd <= (1950 - WTotRec)                            BUG22115
      **********                                                                            BUG22115
     C**********         IF        WCountrcd <= 150                                         BUG22115
     C**********         EVAL      %SUBST(OldScreenFmt:WOld+12:2) =                         BUG22115
     C**********                   'AL'                                                     BUG22115
     C**********         EVAL      WOld = WOld + 22                                         BUG22115
     C**********         ENDIF                                                              BUG22115
      **********                                                                            BUG22115
     C**********         EVAL      FldCuArr(WCountrcd) = *BLANKS                            BUG22115
     C**********         EVAL      %SUBST(FldCuArr(WCountrcd):13:2) =                       BUG22115
     C**********                   'AL'                                                     BUG22115
      **********                                                                            BUG22115
     C**********         EVAL      WCountrcd = WCountrcd + 1                                BUG22115
      **********                                                                            BUG22115
     C**********         ENDDO                                                              BUG22115
      *
      ** Load New Screen Format
      *
     C                   EVAL      NewScreenFmt = OldScreenFmt
     C**********         EVAL      PTotRcd = WCountrcd - 1                                  BUG22115
     C                   EVAL      PTotRcd = 1950 - WTotRec                                 BUG22115
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Action Code
      *
     C                   PARM                    DDACTN
      *
      ** Customer Number
      *
     C                   PARM                    DDCUST
     C                   PARM                    PInKC
     C                   PARM                    PInKL
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'SDCUAHSIN'
      *
      ** Key to Prevent duplicate keys being written
      *
     C     KLPrvK        KLIST
     C                   KFLD                    DDCUST
     C                   KFLD                    WAuth
     C                   KFLD                    WLtyp
      *
      **  Create program exit flag and set value to off
      *
     C                   MOVE      *OFF          WExit
      *
     C                   MOVE      '*CHG'        WMode
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error
      ** procesing
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2008
