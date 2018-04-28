     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Send Message to MQ Queue')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Fund Transfer Module                                 *
      *                                                               *
      *  FT000988 - Midas FT Send message to MQ Queue                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD031644           Date 09Jan15               *
      *  Prev Amend No. CFT158  *CREATE    Date 14Nov14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031644 - SP7 Build issue (Rework of CFT158 Return          *
      *             Status of Interfaced FT Payments). Unable         *
      *             to compile GP002900 due to zonal access.          *
      *             Due to zonal access restriction, move the         *
      *             Watch List Checking from GP002900 to zonal        *
      *             program FT000988.                                 *
      *  CFT158 - Return Status of Interfaced FT Payments.            *
      *                                                               *
      *****************************************************************
 
      ** FT Outgoing Payments                                                               MD031664
     FOTPAY     IF   E           K DISK    INFSR(*PSSR) USROPN                              MD031664
                                                                                            MD031664
      ** FT Incoming Payments                                                               MD031664
     FINPAY     IF   E           K DISK    INFSR(*PSSR) USROPN                              MD031664
                                                                                            MD031664
      ** Watch List Check file                                                              MD031664
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR) USROPN                              MD031664
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      ** Status Messages
     D STATMSG         S             70    DIM(6) CTDATA PERRCD(1)
 
      ** Midas API Message Header Format Definition
     D MsgHeader     E DS                  EXTNAME(APHEADPD)
 
      ** Long Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** SD Status DataArea Layout
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** +--------------------------------------+
      **   Manually included D-specs            +
      **   =========================            +
      ** +--------------------------------------+
      *
      ** AOSVALR0 parameters
     D WSVALNAME       S             16A
     D RTNCDE          S              7A
     D SVALK1          S             20A
     D SVAL1           S            200A
     D SVALK2          S             20A
     D SVAL2           S            200A
     D SVALK3          S             20A
     D SVAL3           S            200A
     D SVALK4          S             20A
     D SVAL4           S            200A
     D SVALK5          S             20A
     D SVAL5           S            200A
     D SVALK6          S             20A
     D SVAL6           S            200A
     D SVALK7          S             20A
     D SVAL7           S            200A
     D SVALK8          S             20A
     D SVAL8           S            200A
     D SVALK9          S             20A
     D SVAL9           S            200A
     D SVALK0          S             20A
     D SVAL10          S            200A
     D @ZONE           S             10A
      *
      ** Entry parameters
     D PFrontID        S             20A
     D PTransID        S             20A
     D*PTransRF********S              6A                                                    MD031644
     D PTransRF        S             16A                                                    MD031644
 
     D WQueue          S             48A
     D MQString        S           6000A
     D WMessage        S             70A
     D WFiller         S             10A
     D @RUN            S              1A
 
     D WFound          S              1A                                                    MD031644
     D KPref           S             15A                                                    MD031644
     D KFunt           S              8A                                                    MD031644
     D KIden           S             40A                                                    MD031644
     D KBrca           S              3A                                                    MD031644
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   Eval      WMessage = *Blanks
      *
     C                   Select
     C                   When      %TRIM(PTransID) = 'PENDING'
     C                   MoveA     STATMSG(1)    WMessage
      *
     C                   When      %TRIM(PTransID) = 'AUTHREJECTED'
     C                   MoveA     STATMSG(2)    WMessage
      *
     C                   If        PTransRF <> *Blanks                                      MD031644
      ** Perform Watch List Checking if status received is AUTHREJECTED.                    MD031644
      *                                                                                     MD031644
     C                   Eval      KPref = %Subst(PTransRF:1:15)                            MD031644
      *                                                                                     MD031644
     C                   Select                                                             MD031644
      *                                                                                     MD031644
     C                   When      %Subst(PTransRF:12:2) = 'OP'                             MD031644
     C                   Open      OTPAY                                                    MD031644
     C     KPref         Chain     OTPAY                              80                    MD031644
     C                   If        *IN80 = *OFF                                             MD031644
     C                   Eval      WFound = 'Y'                                             MD031644
     C                   Eval      KBrca = BRCA                                             MD031644
     C                   Eval      KIden = KPref                                            MD031644
     C                   Eval      KFunt = 'OTPAYDD'                                        MD031644
     C                   Endif                                                              MD031644
     C                   Close     OTPAY                                                    MD031644
      *                                                                                     MD031644
     C                   When      %Subst(PTransRF:12:2) = 'IN'                             MD031644
     C                   Open      INPAY                                                    MD031644
     C     KPref         Chain     INPAY                              81                    MD031644
     C                   If        *IN81 = *OFF                                             MD031644
     C                   Eval      WFound = 'Y'                                             MD031644
     C                   Eval      KBrca = BRCA                                             MD031644
     C                   Eval      KIden = KPref                                            MD031644
     C                   Eval      KFunt = 'INPAYDD'                                        MD031644
     C                   Endif                                                              MD031644
     C                   Close     INPAY                                                    MD031644
      *                                                                                     MD031644
     C                   Endsl                                                              MD031644
      *                                                                                     MD031644
      ** Check Watch List Check file for AML status                                         MD031644
     C                   If        WFound = 'Y'                                             MD031644
     C                   Open      SDCWHTL1                                                 MD031644
     C     KWChk         Chain     SDCWHTL1                           82                    MD031644
      *                                                                                     MD031644
      ** If WLC record found and not temporarily released, change                           MD031644
      ** transaction status to WLCREJECTED with associated error message.                   MD031644
     C                   If        *IN82 = *OFF and W3TREL <> 'Y'                           MD031644
     C                   Eval      PTransID = *Blanks                                       MD031644
     C                   Eval      WMessage = *Blanks                                       MD031644
     C                   Eval      PTransID = 'WLCREJECTED'                                 MD031644
     C                   MoveA     STATMSG(6)    WMessage                                   MD031644
     C                   Endif                                                              MD031644
     C                   Close     SDCWHTL1                                                 MD031644
     C                   Endif                                                              MD031644
      *                                                                                     MD031644
     C                   Endif                                                              MD031644
      *
     C                   When      %TRIM(PTransID) = 'PROCESSED'
     C                   MoveA     STATMSG(3)    WMessage
      *
     C                   When      %TRIM(PTransID) = 'REPAIRED'
     C                   MoveA     STATMSG(4)    WMessage
      *
     C                   When      %TRIM(PTransID) = 'REJECTED'
     C                   MoveA     STATMSG(5)    WMessage
      *
     C                   When      %TRIM(PTransID) = 'WLCREJECTED'
     C                   MoveA     STATMSG(6)    WMessage
      *
     C                   ENDSL
 
      ** Build message header
     C                   EVAL      APTGTTYPE = 'TransStatusUpdate'
     C                   EVAL      APSRCSYS = 'MIDAS   '
     C                   EVAL      APRESPMODE = 'S'
     C                   EVAL      APMAPLOCN = 'A'
     C                   EVAL      APFOTRANID = PFrontID
     C                   EVAL      APRPRLOCN = 'F'
     C                   EVAL      WFiller = 'DDPREF    '
 
     C                   EVAL      MQString = *Blanks
     C                   EVAL      MQString = MsgHeader + 'FT' +
     C                                        PTransID + PTransRF +
     C                                        WFiller + %Trim(WMessage)
 
     C                   CALLB     'ZA000001'
     C                   PARM                    ReturnCode
     C                   PARM                    WQueue
     C                   PARM                    MQString
 
     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'FT000988'
     C                   EVAL      DBase = 01
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PFrontID
     C                   PARM                    PTransID
     C                   PARM                    PTransRF
 
     C                   EVAL      WSVALNAME = 'FTRetStatusMQ'
 
      ** Check system value for name of MQ queue name to use for
      ** sending status return messages.
 
     C                   EVAL      SVALK1 = %TRIM(WSVALNAME)
     C                   CALL      'AOSVALR0'
     C                   PARM                    RTNCDE
     C                   PARM                    SVALK1
     C                   PARM                    SVAL1
     C                   PARM                    SVALK2
     C                   PARM                    SVAL2
     C                   PARM                    SVALK3
     C                   PARM                    SVAL3
     C                   PARM                    SVALK4
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10
 
      ** If the system value is not found then issue a database error
 
     C                   IF        RTNCDE <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 01
     C                   EVAL      DBKey = SVALK1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WQueue = %Trim(SVAL1)
     C                   ENDIF
 
      ** Key for Watch List Checking file SDCWHTL1                                          MD031644
     C     KWchk         KList                                                              MD031644
     C                   Kfld                    KFunt                                      MD031644
     C                   Kfld                    KIden                                      MD031644
     C                   Kfld                    KBrca                                      MD031644
                                                                                            MD031644
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2012
**  STATMSG
FTM7126Payment awaits authorisation.
FTM7123Payment deleted after a pending approval.
FTM7127Payment successfully authorized.
FTM7125Payment repaired.
FTM7128Payment deleted.
FTM7124Payment deleted Watch List Check Failure.
