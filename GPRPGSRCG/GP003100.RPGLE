     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Send Rejection back to TOF')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP003100 - Send Rejection back to TOF Trigger Program        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR976292  *CREATE   Date 23May12              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR976292 - PBS Compatibility with BankFusion Midas 2.00      *
      *             Flag APRDEL-"Delete Repair Record" from T_APICFG  *
      *             should be set to 'N' when Private Banking module  *
      *             is switched ON for following API names:           *
      *             AMAD,CUSD,SECD,DEAM,DPMV (3),FXDL,LDNI,OPAY,TRAD  *
      *             (Child:AR976293)                                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     D/COPY GPCPYSRCG,STD_D_SPEC
 
     D InvACC        E DS                  EXTNAME(GLIAMADPD) PREFIX(X1)
     D InvSET        E DS                  EXTNAME(SEITRADPD) PREFIX(X2)
     D InvDPM        E DS                  EXTNAME(SEIDPMVPD) PREFIX(X3)
     D InvOPA        E DS                  EXTNAME(FTIOPAYPD) PREFIX(X4)
     D InvFXD        E DS                  EXTNAME(FXIFXDLPD) PREFIX(X5)
     D InvLDN        E DS                  EXTNAME(MMILDNIPD) PREFIX(X6)
     D InvMMD        E DS                  EXTNAME(MMIDEAMPD) PREFIX(X7)
     D InvCUS        E DS                  EXTNAME(SDICUPBPD) PREFIX(X8)
 
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
 
     DPSDS            SDS
 
      ** Procedure name
     D PSProcName        *PROC
     D PSPgmStat         *STATUS
     D PSPrvStat              16     20S 0
     D PSLineNum              21     28
     D PSRoutine         *ROUTINE
     D PSNoOfParm        *PARMS
     D PSExcpType             40     42
     D PSExcpNo               43     46
     D PSPgmLib               81     90
     D PSExcpData             91    170
     D PSExcpID              171    174
     D PSDate                191    198
     D PSYear                199    200S 0
     D PSLastFile            201    208
     D PSFileInfo            209    243
     D PSJobName             244    253
     D PSUser                254    263
     D PSJobNo               264    269S 0
     D PSJobDate             270    275S 0
     D PSRunDate             276    281S 0
     D PSRunTime             282    287S 0
     D PSCrtDate             288    293
     D PSCrtTime             294    299
     D PSCompLvl             300    303
     D PSSrcfile             304    313
     D PSSrcLib              314    323
     D PSSrcMbr              324    333
     D PSProcPgm             334    343
     D PSProcMod             344    353
 
      ** Before images
     D  T_MSRPRQ_BEF E DS                  EXTNAME(T_MSRPRQ) PREFIX(B1_)
     D  T_MSWIP_BEF  E DS                  EXTNAME(T_MSWIP)  PREFIX(B2_)
 
      ** After images
     D  T_MSRPRQ_AFT E DS                  EXTNAME(T_MSRPRQ) PREFIX(A1_)
     D  T_MSWIP_AFT  E DS                  EXTNAME(T_MSWIP)  PREFIX(A2_)
 
      ** Long Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** First DS for Access programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Externam DS for Bank Details
     D SDZONE        E DS                  EXTNAME(GPZONEPD)
 
     D Jobd            DS            20
     D JobDName                1     10    INZ('MIDASIC   ')
     D System                 11     12
     D XLib                   13     20    INZ('XLIB    ')
 
     D Parm            DS          1500
     D OffSetB               361    364B 0
     D LibCountB             365    368B 0
 
     D Len             S              4B 0 INZ(1500)
 
      ** If this Message array needs to increase a separate
      ** parameter will need to be added
     D MsgArrOut       S           9999    INZ(*BLANKS)
 
     D OffLen          S              9  0
     D OffSetX         S              9  0
     D InLibl          S           2750
     D Command         S           2764
 
      ** Error message format for retrieve JOBD *LIBL
     DQUSEC            DS
      ** Qus EC
     D QUSBPRV                 1      4B 0
      ** Bytes Provided
     D QUSBAVL                 5      8B 0
      ** Bytes Available
     D QUSEI                   9     15
      ** Exception Id
     D QUSERVED               16     16
      ** Varying length
     D QUSExcData             17     46
      ** Varying length field Exception Data
 
      ** +--------------------------------------+
      **   Manually included D-specs            +
      **   =========================            +
      ** +--------------------------------------+
 
     D  CurZone        S             10A
     D @RUN            S              1A
     D OFFSET          S              5P 0
     D I#AIMG          S           5000A
     D I#BIMG          S           5000A
     D PFrontID        S             20A
     D InvData         S           5000A
     D FileName        S             10A
     D @ZONE           S             10A
     D Format          S             10A
     D Length          S             15P 5
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      ** Retrieve before/after image from PARM1 using length and offset
 
     C     BOFF          ADD       1             OffSet
     C     BLen          SUBST     PARM1:OffSet  I#BIMG
 
     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG
 
      ** Call the appropriate subroutine, based on the physical file
 
     C                   SELECT
     C                   WHEN      PFLNAME = 'T_MSRPRQ'
     C                   EXSR      SrTMSRPRQ
     C                   WHEN      PFLNAME = 'T_MSWIP'
     C                   EXSR      SrTMSWIP
     C                   ENDSL
 
      ** Terminate Program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTMSRPRQ  - Processing for T_MSRPRQ                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SrGetZonePref, SrSetLIBL, RPC1600                      *
      *                                                               *
      *****************************************************************
 
     C     SrTMSRPRQ     BEGSR
 
     C                   EVAL      T_MSRPRQ_BEF = I#BIMG
     C                   EVAL      T_MSRPRQ_AFT = I#AIMG
 
      ** Setup library lists for the current zone
 
     C                   EXSR      SrGetZonePref
 
      ** Setup library lists for the current zone
 
     C                   EXSR      SrSetLIBL
 
      ** For REJECTION from REPAIR
 
     C                   IF        TrgEvent  = '3'
     C                             AND B1_MSWSTAT = 'REPAIR'
     C                             AND A1_MSWSTAT = 'DELETED'
 
     C                   CLEAR                   InvData
     C                   MOVEL     *BLANKS       FileName
 
      ** For Accounts
 
     C                   SELECT
     C                   WHEN      %TRIM(A1_MSWAPI) = 'AMAD'
     C                   CLEAR                   InvAcc
     C                   MOVE      'D'           X1DDACTN
     C                   MOVEL     A1_MSWFOTID   X1DDFOTRANID
     C                   CALL      'RPC1600'
     C                   PARM      InvAcc        InvData
     C                   PARM      'GLIAMADPD'   FileName
 
      ** For SE Trades
 
     C                   WHEN      %TRIM(A1_MSWAPI) = 'TRAD'
     C                   CLEAR                   InvSet
     C                   MOVE      'D'           X2DDACTN
     C                   MOVEL     A1_MSWFOTID   X2DDFOTRANID
     C                   CALL      'RPC1600'
     C                   PARM      InvSet        InvData
     C                   PARM      'SEITRADPD'   FileName
 
      ** For Depot Movements
 
     C                   WHEN      %TRIM(A1_MSWAPI) = 'DPMV'
     C                   CLEAR                   InvDpm
     C                   MOVE      'D'           X3DDACTN
     C                   MOVEL     A1_MSWFOTID   X3FOFFID
     C                   CALL      'RPC1600'
     C                   PARM      InvDpm        InvData
     C                   PARM      'SEIDPMVPD'   FileName
 
      ** For Outgoing Payments
 
     C                   WHEN      %TRIM(A1_MSWAPI) = 'OPAY'
     C                   CLEAR                   InvOpa
     C                   MOVE      'D'           X4SACTION
     C                   MOVEL     A1_MSWFOTID   X4SFOTRANID
     C                   CALL      'RPC1600'
     C                   PARM      InvOpa        InvData
     C                   PARM      'FTIOPAYPD'   FileName
 
      ** For FX Deals
 
     C                   WHEN      %TRIM(A1_MSWAPI) = 'FXDL'
     C                   CLEAR                   InvFxd
     C                   MOVE      'D'           X5DDACTN
     C                   MOVEL     A1_MSWFOTID   X5DDFOTRANID
     C                   EVAL      X5DDDLNO = %SUBST(A1_MSWBOFLD2:01:6)
     C                   CALL      'RPC1600'
     C                   PARM      InvFxd        InvData
     C                   PARM      'FXIFXDLPD'   FileName
 
      ** For MM Deals
 
     C                   WHEN      %TRIM(A1_MSWAPI) = 'LDNI'
     C                   CLEAR                   InvLdn
     C                   MOVE      'D'           X6DDACTN
     C                   MOVEL     A1_MSWFOTID   X6DDFOTRANID
     C                   EVAL      X6DDDLNO = %SUBST(A1_MSWBOFLD2:01:6)
     C                   CALL      'RPC1600'
     C                   PARM      InvLdn        InvData
     C                   PARM      'MMILDNIPD'   FileName
 
      ** For MM Deal Amendments
 
     C                   WHEN      %TRIM(A1_MSWAPI) = 'DEAM'
     C                   CLEAR                   InvMmd
     C                   MOVE      'D'           X7DDACTN
     C                   MOVEL     A1_MSWFOTID   X7DDFOTRANID
     C                   EVAL      X7DDDLNO = %SUBST(A1_MSWBOFLD2:01:6)
     C                   CALL      'RPC1600'
     C                   PARM      InvMmd        InvData
     C                   PARM      'MMIDEAMPD'   FileName
 
      ** For Customers
 
     C                   WHEN      %TRIM(A1_MSWAPI) = 'CUSD'
     C                             Or %TRIM(A1_MSWAPI) = 'CSDU'
     C                   CLEAR                   InvCus
     C                   MOVE      'D'           X8DDACTN
     C                   MOVEL     A1_MSWFOTID   X8DDFOTRANID
     C                   EVAL      X8DDCUSN = %SUBST(A1_MSWBOFLD1:01:6)
     C                   CALL      'RPC1600'
     C                   PARM      InvCus        InvData
     C                   PARM      'SDICUPBPD'   FileName
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTMSWIP - Processing for T_MSWIP                             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SrGetZonePref, SrSetLIBL, RPC1600                      *
      *                                                               *
      *****************************************************************
 
     C     SRTMSWIP      BEGSR
 
     C                   EVAL      T_MSWIP_BEF = I#BIMG
     C                   EVAL      T_MSWIP_AFT = I#AIMG
 
      ** Setup library lists for the current zone
 
     C                   EXSR      SrGetZonePref
 
      ** Setup library lists for the current zone
 
     C                   EXSR      SrSetLIBL
 
     C                   MOVEL     A2_MSWFOTID   PFrontID
 
      ** For transaction coming from external system REJECTED from WIP
 
     C                   IF        TrgEvent  = '3' AND
     C                             %TRIM(B2_MSWSTAT) = 'TO_AUTHORISE'
     C                             AND %TRIM(A2_MSWSTAT) = 'REJECTED'
     C                             AND PFrontID <> *BLANKS
 
      ** Only for some specific transactions (those originally
      ** sent from PBS (TOF))
 
     C                   IF        %TRIM(A2_MSWAPI) = 'AMAD' OR
     C                             %TRIM(A2_MSWAPI) = 'CUSD' OR
     C                             %TRIM(A2_MSWAPI) = 'DEAM' OR
     C                             %TRIM(A2_MSWAPI) = 'DPMV' OR
     C                             %TRIM(A2_MSWAPI) = 'FXDL' OR
     C                             %TRIM(A2_MSWAPI) = 'LDNI' OR
     C                             %TRIM(A2_MSWAPI) = 'OPAY' OR
     C                             %TRIM(A2_MSWAPI) = 'TRAD'
 
     C                   CLEAR                   InvData
     C                   MOVEL     *BLANKS       FileName
 
      ** For Accounts
 
     C                   SELECT
     C                   WHEN      %TRIM(A2_MSWAPI) = 'AMAD'
     C                   CLEAR                   InvAcc
     C                   MOVE      'D'           X1DDACTN
     C                   MOVEL     A2_MSWFOTID   X1DDFOTRANID
     C                   CALL      'RPC1600'
     C                   PARM      InvAcc        InvData
     C                   PARM      'GLIAMADPD'   FileName
 
      ** For SE Trades
 
     C                   WHEN      %TRIM(A2_MSWAPI) = 'TRAD'
     C                   CLEAR                   InvSet
     C                   MOVE      'D'           X2DDACTN
     C                   MOVEL     A2_MSWFOTID   X2DDFOTRANID
     C                   CALL      'RPC1600'
     C                   PARM      InvSet        InvData
     C                   PARM      'SEITRADPD'   FileName
 
      ** For Depot Movements
 
     C                   WHEN      %TRIM(A2_MSWAPI) = 'DPMV'
     C                   CLEAR                   InvDpm
     C                   MOVE      'D'           X3DDACTN
     C                   MOVEL     A2_MSWFOTID   X3FOFFID
     C                   CALL      'RPC1600'
     C                   PARM      InvDpm        InvData
     C                   PARM      'SEIDPMVPD'   FileName
 
      ** For Outgoing Payments
 
     C                   WHEN      %TRIM(A2_MSWAPI) = 'OPAY'
     C                   CLEAR                   InvOpa
     C                   MOVE      'D'           X4SACTION
     C                   MOVEL     A2_MSWFOTID   X4SFOTRANID
     C                   CALL      'RPC1600'
     C                   PARM      InvOpa        InvData
     C                   PARM      'FTIOPAYPD'   FileName
 
      ** For FX Deals
 
     C                   WHEN      %TRIM(A2_MSWAPI) = 'FXDL'
     C                   CLEAR                   InvFxd
     C                   MOVE      'D'           X5DDACTN
     C                   MOVEL     A2_MSWFOTID   X5DDFOTRANID
     C                   EVAL      X5DDDLNO = %SUBST(A2_MSWBOFLD2:01:6)
     C                   CALL      'RPC1600'
     C                   PARM      InvFxd        InvData
     C                   PARM      'FXIFXDLPD'   FileName
 
      ** For MM Deals
 
     C                   WHEN      %TRIM(A2_MSWAPI) = 'LDNI'
     C                   CLEAR                   InvLdn
     C                   MOVE      'D'           X6DDACTN
     C                   MOVEL     A2_MSWFOTID   X6DDFOTRANID
     C                   EVAL      X6DDDLNO = %SUBST(A2_MSWBOFLD2:01:6)
     C                   CALL      'RPC1600'
     C                   PARM      InvLdn        InvData
     C                   PARM      'MMILDNIPD'   FileName
 
      ** For MM Deal Amendments
 
     C                   WHEN      %TRIM(A2_MSWAPI) = 'DEAM'
     C                   CLEAR                   InvMmd
     C                   MOVE      'D'           X7DDACTN
     C                   MOVEL     A2_MSWFOTID   X7DDFOTRANID
     C                   EVAL      X7DDDLNO = %SUBST(A2_MSWBOFLD2:01:6)
     C                   CALL      'RPC1600'
     C                   PARM      InvMmd        InvData
     C                   PARM      'MMIDEAMPD'   FileName
 
      ** For Customers
 
     C                   WHEN      %TRIM(A2_MSWAPI) = 'CUSD'
     C                   CLEAR                   InvCus
     C                   MOVE      'D'           X8DDACTN
     C                   MOVEL     A2_MSWFOTID   X8DDFOTRANID
     C                   EVAL      X8DDCUSN = %SUBST(A2_MSWBOFLD1:01:6)
     C                   CALL      'RPC1600'
     C                   PARM      InvCus        InvData
     C                   PARM      'SDICUPBPD'   FileName
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGetZonePref - Get Zone Prefix                               *
      *                                                               *
      * Called by: SrTMSRPRQ, SrTMSWIP                                *
      *                                                               *
      * Calls: GPAOZONER0                                             *
      *                                                               *
      *****************************************************************
 
     C     SrGetZonePref BEGSR
 
     C                   SELECT
     C                   WHEN      PFLNAME = 'T_MSRPRQ'
     C                   EVAL      CurZone = A1_MSWZONE
     C                   WHEN      PFLNAME = 'T_MSWIP'
     C                   EVAL      CurZone = A2_MSWZONE
     C                   ENDSL
 
     C                   CALL      'GPAOZONER0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      CurZone       @ZONE
     C     SDZONE        PARM      SDZONE        DSFDY
 
     C                   IF        (@RTCD <> *BLANKS) AND
     C                             (@RTCD <> '*NRF   ')
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'PBTRIGGER'
     C                   EVAL      DBFILE = 'GPZONEPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      System    =  ZOMSYS
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SrSetLIBL - Set library lists                                 *
      *                                                               *
      * Called by: SrTMSRPRQ, SrTMSWIP                                *
      *                                                               *
      * Calls: QWDRJOBD                                               *
      *                                                               *
      *****************************************************************
 
     C     SrSetLIBL     BEGSR
 
      ** Set up job description library list
 
     C                   CALL      'QWDRJOBD'                           9697
     C                   PARM                    PARM
     C                   PARM                    Len
     C                   PARM      'JOBD0100'    Format
     C                   PARM                    Jobd
     C                   PARM                    QUSEC
 
     C                   IF        QUSEI = 'CPF9801' OR
     C                             QUSEI = 'CPF9810'
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'QWDRJOBD'
     C                   EVAL      DBase = 002
     C                   EVAL      DBKey = QUSEI
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   RETURN
     C                   ENDIF
 
     C                   IF        QUSEI = 'CPF9802' OR
     C                             QUSEI = 'CPF9820'
     C                   EVAL      DBPGM  = 'QWDRJOBD'
     C                   EVAL      DBase = 003
     C                   EVAL      DBKey = QUSEI
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   RETURN
     C                   ENDIF
 
     C                   EVAL      OffSetX = OffSetB + 1
     C                   EVAL      OffLen = LibCountB * 11
     C                   EVAL      InLibl = %SubSt(Parm:OffSetX:OffLen)
     C                   EVAL      Command = ('CHGLIBL LIBL(' +
     C                             InLibl + ')')
 
     C                   CALL      'QCMDEXC'                              92
     C                   PARM                    Command
     C                   PARM      2764          Length
 
     C                   ENDSR
 
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
 
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN
     C                   DUMP
 
     C                   ENDIF
 
     C                   SETON                                        U7U8LR
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
