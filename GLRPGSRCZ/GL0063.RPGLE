     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Statement of Account Prompt')                 *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0063 - Statement of Account Prompt                         *
      *                                                               *
      *  Function:  This program will ask the user to input the       *
      *  (IC)       Start and End Date of Statement.                  *
      *                                                               *
      *  Called By: GL0061 - Customer Account Balances Enquiry        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL140             Date 12Dec12               *
      *                 AR787620           Date 10Jun11               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3676            Date 16Jul04               *
      *                 BUG3267            Date 16Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG1989            Date 28Apr04               *
      *                 CGL025  *CREATE    Date 14Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL140 - Online Statement                                    *
      *         - Added Hooks: CGL140_022 to CGL140_031               *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,GLH00034                                 *
      *             WNCPYSRC,GLH00035                                 *
      *             WNCPYSRC,GLH00036                                 *
      *             WNCPYSRC,GLH00037                                 *
      *             WNCPYSRC,GLH00038                                 *
      *             WNCPYSRC,GLH00039                                 *
      *             WNCPYSRC,GLH00040                                 *
      *             WNCPYSRC,GLH00041                                 *
      *             WNCPYSRC,GLH00042                                 *
      *             WNCPYSRC,GLH00045                                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3676 - Webfacing Changes.  Display function keys format.  *
      *  BUG3267- Problem on MsgIds.  Replace with new MsgIds.        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG1989- Change account code fields to 10-digits             *
      *  CGL025 - Statement of Account for a Specific Period.         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
     FGL0063DF  CF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D MsgFile         C                   CONST('GBGLUSRMSG')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D/COPY WNCPYSRC,GLH00034
     D/COPY OFCPYSRCZ,CGL140_022                                                              CGL140
     D SbmArr          S             80    DIM(2) CTDATA PERRCD(1)
     D/COPY OFCPYSRCZ,CGL140_023                                                              CGL140
     D/COPY WNCPYSRC,GLH00035
      ** SBMJOB
 
     D*AccKey***       DS            18                                                      BUG1989
     D AccKey          DS            24                                                      BUG1989
     D     kBRCA               1      3
     D     kCNUM               4      9
     D     kCCY               10     12
     D*****kACOD              13     16                                                      BUG1989
     D*****kACSQ              17     18                                                      BUG1989
     D     kACOD              13     22                                                      BUG1989
     D     kACSQ              23     24                                                      BUG1989
      ** DS for Account Key
 
     D EMSDS         E DS                  EXTNAME(EMDTA)
      * External Data Area for Linked Enquiry Processing
 
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
      ** Retail Account Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for Access Object Programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for Access Object Programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D MsgF            S             10
     D MsgId           S             10
     D StartDate       S              5  0
     D EndDate         S              5  0
     D SDateChr        S              5
     D EDateChr        S              5
     D InputOk         S              1
     D CmdText         S            512
 
     D ExcCmd          PR                  EXTPGM('QCMDEXC')
     D   Cmd                        512A   CONST OPTIONS(*VARSIZE)
     D   Len                         15P 5 CONST
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Loop until F3 of F12 is taken
     C                   DoW       *INKC = *Off AND
     C                             *INKL = *Off
 
     C                   Write     #MSGCTL
     C                   Write     GL0063F1                                                  BUG3676
     C                   Exfmt     GL0063F0
     C                   Call      'ZA0250'
 
     C                   Select
      ** F3 is pressed
     C                   When      *INKC = *On
     C     *LOCK         IN        EMSDS
     C                   MOVE      'Q'           RETND
     C                   OUT       EMSDS
      ** F5 is pressed
     C                   When      *INKE = *On
     C                   Eval      *IN20 = *Off
     C                   Eval      *IN21 = *Off
     C                   Eval      SSDAT = *Blank
     C                   Eval      SEDAT = *Blank
      ** F12 is pressed
     C                   When      *INKL = *On
     C     *LOCK         IN        EMSDS
     C                   MOVE      'U'           RETND
     C                   OUT       EMSDS
      ** ENTER is pressed
     C                   Other
     C                   Exsr      SRVInput
 
     C                   EndSl
 
     C                   EndDo
      *
      ** Terminate and return to calling pgm
     C                   Eval      *INLR = *On
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SRVInput      BegSr
 
      ** Initialise work variables and error indicators
     C                   Eval      StartDate = *Zero
     C                   Eval      EndDate   = *Zero
     C                   Eval      *IN20 = *Off
     C                   Eval      *IN21 = *Off
     C                   Eval      InputOk = 'Y'
 
      ** Start Date is mandatory
     C                   If        SSDAT = *Blank
     C                   Eval      *IN20 = *On
     C                   Eval      InputOk = 'N'
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C**********         Parm      'CGL0016   '  MsgId                                       BUG3267
     C                   Parm      'CGL0020   '  MsgId                                       BUG3267
 
      ** Start Date must be a valid date
     C                   Else
     C                   CallB     'ZDATE1'
     C                   Parm      SSDAT         DateOut           6
     C                   Parm                    DateIn            5 0
     C                   Parm      AGDFF         DateFmt           1
     C                   Parm      *Blank        ErrorInd          1
     C                   If        ErrorInd <> 'N'
     C                   Eval      *IN20 = *On
     C                   Eval      InputOk = 'N'
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C**********         Parm      'CGL0017   '  MsgId                                       BUG3267
     C                   Parm      'CGL0021   '  MsgId                                       BUG3267
     C                   Else
     C                   Eval      StartDate = DateIn
     C                   Endif
     C                   Endif
 
      ** Start Date must be less than Rundate
     C                   If        *IN20 = *Off AND
     C                             StartDate >= BJRDNB
     C                   Eval      *IN20 = *On
     C                   Eval      InputOk = 'N'
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C**********         Parm      'CGL0018   '  MsgId                                       BUG3267
     C                   Parm      'CGL0022   '  MsgId                                       BUG3267
     C                   Endif
 
      ** Start Date must NOT be less than the Date the account was opened
     C                   If        *IN20 = *Off AND
     C                             StartDate < DACO
     C                   Eval      *IN20 = *On
     C                   Eval      InputOk = 'N'
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C**********         Parm      'CGL0019   '  MsgId                                       BUG3267
     C                   Parm      'CGL0023   '  MsgId                                       BUG3267
     C                   Endif
 
      ** End Date is mandatory
     C                   If        SEDAT = *Blank
     C                   Eval      *IN21 = *On
     C                   Eval      InputOk = 'N'
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C**********         Parm      'CGL0016   '  MsgId                                       BUG3267
     C                   Parm      'CGL0020   '  MsgId                                       BUG3267
 
      ** End Date must be a valid date
     C                   Else
     C                   CallB     'ZDATE1'
     C                   Parm      SEDAT         DateOut           6
     C                   Parm                    DateIn            5 0
     C                   Parm      AGDFF         DateFmt           1
     C                   Parm      *Blank        ErrorInd          1
     C                   If        ErrorInd <> 'N'
     C                   Eval      *IN21 = *On
     C                   Eval      InputOk = 'N'
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C**********         Parm      'CGL0017   '  MsgId                                       BUG3267
     C                   Parm      'CGL0021   '  MsgId                                       BUG3267
     C                   Else
     C                   Eval      EndDate = DateIn
     C                   Endif
     C                   Endif
 
      ** End Date must be less than Rundate
     C                   If        *IN21 = *Off AND
     C                             EndDate >= BJRDNB
     C                   Eval      *IN21 = *On
     C                   Eval      InputOk = 'N'
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C**********         Parm      'CGL0018   '  MsgId                                       BUG3267
     C                   Parm      'CGL0022   '  MsgId                                       BUG3267
     C                   Endif
 
      ** End Date must be greater than Start Date
     C                   If        *IN21 = *Off AND
     C                             EndDate < StartDate
     C                   Eval      *IN21 = *On
     C                   Eval      InputOk = 'N'
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C**********         Parm      'CGL0020   '  MsgId                                       BUG3267
     C                   Parm      'CGL0024   '  MsgId                                       BUG3267
     C                   Endif
 
      ** If inputs are valid, submit the job that will generate the statement
     C                   If        InputOk = 'Y'
 
     C                   EvalR     SDateChr = %CHAR(StartDate)
     C                   EvalR     EDateChr = %CHAR(EndDate)
     C/COPY OFCPYSRCZ,CGL140_024                                                              CGL140
     C/COPY WNCPYSRC,GLH00036
 
     C                   Eval      CmdText = SbmArr(1)
     C/COPY OFCPYSRCZ,CGL140_025                                                              CGL140
     C/COPY WNCPYSRC,GLH00037
     C                   Eval      CmdText = %REPLACE(AccKey:CmdText: +
     C                               %SCAN('123456789012345678901234':CmdText))              BUG1989
     C**********                           %SCAN('123456789012345678':CmdText))              BUG1989
     C                   Eval      CmdText = %REPLACE(SDateChr:CmdText: +
     C                                     %SCAN('SSSSS':CmdText))
     C                   Eval      CmdText = %REPLACE(EDateChr:CmdText: +
     C                                     %SCAN('EEEEE':CmdText))
     C**********         Eval      CmdText = %TRIM(CmdText) + ' ' +                          BUG1989
     C/COPY WNCPYSRC,GLH00038
     C/COPY OFCPYSRCZ,CGL140_026                                                              CGL140
     C                   Eval      CmdText = %TRIM(CmdText) + ')) ' +                        BUG1989
     C                                       %TRIM(SbmArr(2))
     C/COPY OFCPYSRCZ,CGL140_027                                                              CGL140
     C/COPY WNCPYSRC,GLH00039
     C                   CallP     ExcCmd(CmdText:%LEN(%TRIM(CmdText)))
     C/COPY WNCPYSRC,GLH00040
     C/COPY OFCPYSRCZ,CGL140_028                                                              CGL140
 
      ** Reset screen fields
     C                   Eval      SSDAT = *Blank
     C                   Eval      SEDAT = *Blank
 
     C                   Endif
 
     C                   Endsr
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
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    pBRCA             3
     C                   PARM                    pCNUM             6
     C                   PARM                    pCCY              3
     C**********         PARM                    pACOD             4                         BUG1989
     C                   PARM                    pACOD            10                         BUG1989
     C                   PARM                    pACSQ             2
     C/COPY OFCPYSRCZ,CGL140_029                                                              CGL140
     C/COPY WNCPYSRC,GLH00041
 
     C                   Eval      kBRCA = pBRCA
     C                   Eval      kCNUM = pCNUM
     C                   Eval      kCCY  = pCCY
     C                   Eval      kACOD = pACOD
     C                   Eval      kACSQ = pACSQ
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  EMSDS
     C                   IN        RUNDAT
      *
      ** Access Bank details
      *
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       @RTCD             7
     C                   Parm      '*FIRST  '    @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RTCD         IfNE      *BLANKS
     C     *LOCK         In        LDA
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBFILE =  'SDBANKPD'
     C                   Eval      DBKEY  =  '*FIRST'
     C                   Eval      DBASE  =  1
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
      ** Get the account details
     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY    '    @Optn
     C                   Parm      *Blank        W@Retl           10
     C                   Parm      pCNUM         WCusN             6
     C                   Parm      pCCY          W@Cur             3
     C**********         Parm      pACOD         W@Acctcde         4                         BUG1989
     C                   Parm      pACOD         W@Acctcde        10                         BUG1989
     C                   Parm      pACSQ         W@AcctSeq         2
     C                   Parm      pBRCA         W@Brch            3
     C     ACCNT         Parm      ACCNT         DSSDY
     C     @Rtcd         IfNE      *Blank
     C     *LOCK         In        LDA
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBFILE =  'ACCNTAB'
     C                   Eval      DBKEY  =  pCNUM+pCCY+pACOD+pACSQ+pBRCA
     C                   Eval      DBASE  =  2
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Eval      ##PGM  =  PSProcPgm
     C                   Eval      SUSER  =  PSUser
     C                   Eval      SRUNA  =  BJMRDT
     C                   Eval      SWSID  =  PSJobName
     C/COPY WNCPYSRC,GLH00042
     C/COPY OFCPYSRCZ,CGL140_030                                                              CGL140
 
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      *                                                                                      BUG1989
      **  Change first element of SbmArr                                                     BUG1989
**  SbmArr
SBMJOB CMD(CALL PGM(GLC0064) PARM('123456789012345678901234' X'SSSSSF' X'EEEEEF'))
JOB(GLC0064) JOBD(MIDASIC) USER(*JOBD)
     X/COPY WNCPYSRC,GLH00045
     X/COPY OFCPYSRCZ,CGL140_031                                                              CGL140
