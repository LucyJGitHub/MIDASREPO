     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA High Value A/C Identificatn Subfile')   *
      *****************************************************************
      *  Includes MD025277, MD025277A                                 *
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000109 - Midas SD FATCA High Value Account Identification  *
      *             Subfile                                           *
      *                                                               *
      *  Function:  This program display the records from the FATCA   *
      *             High Value Account Identification File            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD029846           Date 24Sep14               *
      *  Prev Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029846 -  Clarifications on FATCA menu action codes        *
      *              Apply Fix MD030170A                              *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    05 - Refresh                                               *
      *    09 - Add                                                   *
      *    11 - Run Tool in Information Mode                          *
      *    13 - Run Tool in Update Mode                               *
      *    30 - Subfile Display                                       *
      *    31 - Subfile Clear                                         *
      *    32 - Subfile Message End                                   *
      *    33 - Error indicator                                       *
      *    36 - Subfile End                                           *
      *    80 - No Data To Display                                    *
      *    98 - Rollup Indicator                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRChkAut  - Validate Authorization Of User For The SubFile   *
      *              Option                                           *
      *  SRProcess - Process the Subfile                              *
      *  SRBldSfl  - Build the Subfile                                *
      *  SRLoadSfl - Load the Subfile                                 *
      *  SRDspSfl  - Display the Subfile                              *
      *  SRPrSfl   - Process the Subfile Functions                    *
      *  SRReset   - Reset the Fields                                 *
      *  SRClrSfl  - Clear the Subfile                                *
      *  SRErrDta  - Output Error Message With Data                   *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *    The *INZSR Subroutine Will Only Get Called Automatically   *
      *    On Entry To The Module The First Time It Is Run            *
      *    (Unless You End The Program With LR On).  Similarly        *
      *    D-spec Initialisation Only Happens The First Time.  Use    *
      *    RESET For Subsequent Passes.                               *
      *                                                               *
      *****************************************************************
      *---------------------------------------------------------------*
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      ** FATCA High Value Account Identification File
     FSDFTHVL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** FATCA High Value Account Identification Subfile
     FSD000109DFCF   E             WORKSTN
     F                                     SFILE(SD000109S0:RRN0 )
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically Included D-Specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The Following /COPY Line Includes The LDA Layout,
      ** And The Following Named Constants:
      **    True       Logical = *ON (For Indcator Processing)
      **    False      Logical = *OFF (For Indcator Processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (The Name Of The Database
      **                         Error Handler)
      ** And The Following Variables:
      **    RunBefore  1A (For The PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The Following /COPY Line Includes All The Defined Fields In
      ** the PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End Of Automatically Included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Arrays And Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS For Access Program, Shrot Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** External DS Based On SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS Based On SDFATCPD
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
      *
      ** DS For Indicators
     D Indicators      DS                  BASED(Ind_Pointer)
     D  Exit                  03     03
     D  Refresh               05     05
     D  Add                   09     09
     D  RunToolInf            11     11
     D  RunToolUpd            13     13
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflMsgEnd             32     32
     D  ActnErr               33     33
     D  SflEnd                36     36
     D  NoData                80     80
     D  Rollup                98     98
      *
      ** Define A Data Structure To Access Default Branch
     D ZMUser          DS            17
     D  PBrc                  11     13A
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Ind_Pointer     S               *   INZ(%ADDR(*IN))
     D POpt            S              1A
     D PCclc           S                   LIKE(HVCCLC)
     D PCutp           S                   LIKE(HVCUTP)
     D PHvin           S                   LIKE(HVHVIN)
     D PClas           S                   LIKE(HVCCLC)
     D RRN0            S              4S 0
     D WLstRrn         S              4S 0
     D WSelectCT       S              1A
     D WSelectHV       S              1A
     D WSelectCC       S              1A
     D WSelectCD       S              1A
     D WSelectSR       S              1A
     D WError          S              1A   INZ('N')
     D WCtr            S              2  0
     D WarnTool        S              1A   INZ('N')
     D IsFileLocked    S              1A   INZ('N')
     D LckRlsFlag      S              5A
      *
      ** Parameters For ZVACTBU/ZVACTU
     D PZbr            S              3A
     D PErr            S              1P 0
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D SflPag          C                   CONST(11)
     D Amend           C                   CONST('A')
     D Enquire         C                   CONST('E')
     D Delete          C                   CONST('D')
      *
      ** Parameter For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenCUTP        S              3P 0
     D PLenHVIN        S              3P 0
     D PLenNCLC        S              3P 0
     D PLenNCLD        S              3P 0
     D PLenSUBJ        S              3P 0
     D PLenD0CUTP      S              3P 0
     D PLenD0HVIN      S              3P 0
     D PLenD0NCLC      S              3P 0
     D PLenD0NCLD      S              3P 0
     D PLenD0SUBJ      S              3P 0
     D PTranslate      S              1A   INZ('1')
     D PTrim           S              1A   INZ('1')
     D PWild           S              1A   INZ('?')
     D PResult         S              3P 0
      *
      ** Parameter For ZA0350
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A
      *
      ** Variable Declaration
     D PRetCode        S              3A
     D WRun            S              1A
     D WIdx            S              3P 0
     D WCcc            S                   LIKE(D0CCLCS)
     D WFct            S                   LIKE(D0CUTPS)
     D WHvi            S                   LIKE(D0HVINS)
     D WFcc            S                   LIKE(D0NCLCS)
     D WFcd            S                   LIKE(D0NCLDS)
     D WStr            S                   LIKE(D0SUBJS)
     D PLOWI           S             18A
     D PLOWE           S             18A
     D PHIGT           S             18A
     D PHVCY           S              3A
      *
      ** Mode - Information/Update
     D PMode           S              1A
      *
      ** +--------------------------------------+
      ** ¦ End Of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      **+--- Start of Main Processing --------------------------------+
      **|                                                             ¦
      **¦ Initial Processing Is Performed Automatically: The *INZSR   ¦
      **¦ Is Executed At Program Activation.                          ¦
      **¦                                                             ¦
      **+-------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN - Processing                                             *
      *****************************************************************
      *
      ** Build the Subfile
     C                   EXSR      SRBldSfl
      *
      ** Display the Screen Until F3 Is Pressed
     C                   DOW       (Exit = *OFF)
      *
      ** Display And Process the Subfile
     C                   EXSR      SRDspSfl
      *
      ** Process the Subfile
     C                   EXSR      SRProcess
      *
     C                   ENDDO
      *
     C                   IF        LckRlsFlag = '*LOCK'
     C                   EVAL      LckRlsFlag = '*RLS '
     C                   EXSR      ChkFileLck
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly On Program Activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Call The Access Object AOBANKR0
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check the Return Parameter
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** GET ZMUser To Access Default Branch
     C     *DTAARA       DEFINE                  ZMUser
     C                   IN        ZMUser
     C                   UNLOCK    ZMUser
      *
      ** Populate WorkStation ID
     C                   EVAL      D0WOID = PsJobName
      *
      ** Populate User
     C                   EVAL      D0USRP = PsUser
      *
      ** Populate Midas Run Date
     C                   EVAl      D0MRDT = BJMRDT
      *
      ** Initialise Subfile Program Queue and Message File
     C                   EVAL      D1PGMQ = '*'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
      *
      ** Message Subfile Indicator
     C                   EVAL      SflMsgEnd = *ON
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *                                                               *
      *  Called by: MAIN Processing, SRProcess                        *
      *                                                               *
      *  Calls: SRClrSfl, SRLoadSfl                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSfl      BEGSR
      *
      ** Clear the Subfile
     C                   EXSR      SRClrSfl
      *
      ** Load the Subfile
     C                   EXSR      SRLoadSfl
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspSfl - Display the Subfile                               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDspSfl      BEGSR
      *
     C                   TIME                    D0TIME
      *
      ** Write the Footer
     C                   WRITE     SD000109F0
      *
      ** Write the Message Subfile Control Format
     C                   WRITE     SD000109C1
      *
      ** Display the Subfile
     C                   EXFMT     SD000109C0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRReset, SRBldSfl, SRLoadSfl, SRPrSfl, SRChkAut       *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR
      *
      ** Reset the Fields and The Program Message Queue
     C                   EXSR      SRReset
      *
     C                   IF        D0CCLCS = *BLANKS
     C                   EVAL      WCcc = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0CUTPS = *BLANKS
     C                   EVAL      WFct = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0HVINS = *BLANKS
     C                   EVAL      WHvi = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0NCLCS = *BLANKS
     C                   EVAL      WFcc = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0NCLDS = *BLANKS
     C                   EVAL      WFcd = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0SUBJS = *BLANKS
     C                   EVAL      WStr = *BLANKS
     C                   ENDIF
      *
     C                   SELECT
      *
      ** When F3 Is Pressed
     C                   WHEN      Exit = *ON
     C                   LEAVESR
      *
      ** When F5 Is Pressed
     C                   WHEN      Refresh = *ON
      *
      ** Reset And Build
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
      *
      ** When Page Down Is Pressed
     C                   WHEN      Rollup = *ON
      *
      ** Load the Next Page
     C                   EXSR      SRLoadSfl
      *
      ** When F9 Is Pressed And Selection Filters Are Not Changed
     C                   WHEN      (ADD = *ON) AND
     C                             (D0CCLCS = WCcc) AND
     C                             (D0CUTPS = WFct) AND
     C                             (D0HVINS = WHvi) AND
     C                             (D0NCLCS = WFcc) AND
     C                             (D0NCLDS = WFcd) AND
     C                             (D0SUBJS = WStr)
      *
      ** Process the Function Keys And the Values Entered On the
      ** Screen
     C                   EXSR      SRPrSfl
      *
      ***Check*the*Authority****************************************                       MD030170A
     C**********         IF        WIdx = 0                                                MD030170A
     C**********         EVAL      POpt = 'I'                                              MD030170A
     C**********         EXSR      SRChkAut                                                MD030170A
     C**********         ENDIF                                                             MD030170A
      *
      ** Call the Input Screen
     C                   IF        WIdx = 0
     C                   CALL      'SD000140'
     C                   PARM      'I'           POpt
     C                   PARM      *BLANKS       PCclc
     C                   PARM      *BLANKS       PCutp
     C                   PARM      *BLANKS       PHvin
     C                   PARM      *BLANKS       PRetCode
      *
      ** When F3 Is Pressed Go To Main Menu
     C                   IF        PRetCode = 'F3'
     C                   EVAL      Exit = *ON
     C                   LEAVESR
     C                   ENDIF
      *
      ** Build the Subfile Along With the New Records Added
     C                   EXSR      SRBldSfl
     C                   ENDIF
      *
      ** When F11 Is Pressed And Selection Filters Are Not Changed
     C                   WHEN      ((RunToolInf = *ON) OR
     C                              (RunToolUpd = *ON)) AND
     C                             (D0CCLCS = WCcc) AND
     C                             (D0CUTPS = WFct) AND
     C                             (D0HVINS = WHvi) AND
     C                             (D0NCLCS = WFcc) AND
     C                             (D0NCLDS = WFcd) AND
     C                             (D0SUBJS = WStr)
      *
      ** Process the Function Keys And the Values Entered On the
      ** Screen
     C                   EXSR      SRPrSfl
      *
      ** Information Mode
     C                   IF        RunToolInf = *ON
     C                   EVAL      PMode = 'F'
     C                   EVAL      POpt = 'R'
     C                   ENDIF
      *
      ** Update Mode
     C                   IF        RunToolUpd = *ON
     C                   EVAL      PMode = 'U'
     C                   EVAL      POpt = 'U'
      ** If Update Mode, Check Files Allocations
     C
     C                   IF        LckRlsFlag <> '*LOCK'
     C                   EVAL      LckRlsFlag = '*LOCK'
     C                   EXSR      ChkFileLck
     C                   IF        IsFileLocked = 'Y'
     C                   EVAL      PMsgId = 'USS0320'
     C                   EXSR      SRErrDta
     C
     C                   EVAL      WError = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***Check*the*Authority****************************************                       MD030170A
     C**********         IF        WIdx = 0                                                MD030170A
     C**********         EXSR      SRChkAut                                                MD030170A
     C**********         ENDIF                                                             MD030170A
      *
      ** Call the Tool
     C                   IF        WIdx = 0
     C                             and WError <> 'Y'
      *
      ** Output Warning Before Tool is Executed in Update Mode
     C                   IF        WarnTool = 'N' AND RunToolUpd = *ON
     C                   EVAL      WarnTool = 'Y'
     C                   EVAL      PMsgId = 'USS0285'
     C                   EXSR      SRErrDta
     C                   ELSE
      *
     C                   CALL      'SDC000161'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PMode
     C                   PARM                    PLOWI
     C                   PARM                    PLOWE
     C                   PARM                    PHIGT
     C                   PARM                    PHVCY
      *
     C                   IF        PMode = 'U'
     C                   EVAL      LckRlsFlag = '*RLS '
     C                   EXSR      ChkFileLck
     C                   ENDIF
      *
     C                   CALL      'SD000112'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PMode
     C                   PARM                    PLOWI
     C                   PARM                    PLOWE
     C                   PARM                    PHIGT
     C                   PARM                    PHVCY
      *
      ** Build the Subfile Along With the New Records Added
     C                   EXSR      SRBldSfl
     C                   ENDIF
     C                   ENDIF
      *
      ** When Selection Filters Are Not Changed And Valid Options
      ** Are Entered On the Screen, Process the Subfile
     C                   WHEN      (D0CCLCS = WCcc) AND
     C                             (D0CUTPS = WFct) AND
     C                             (D0HVINS = WHvi) AND
     C                             (D0NCLCS = WFcc) AND
     C                             (D0NCLDS = WFcd) AND
     C                             (D0SUBJS = WStr) AND
     C                             (Add = *OFF) AND
     C                             (RunToolInf = *OFF)  AND
     C                             (RunToolUpd = *OFF)
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError <> 'Y'
      *
      ** Clear the Programn Message Queue And the Fields
     C                   EXSR      SRReset
      *
      ** Build the Subfile
     C                   EXSR      SRBldSfl
      *
     C                   ENDIF
      *
      ** When Selection Filters Are Entered
     C                   WHEN      (D0CCLCS <> *BLANKS) OR
     C                             (D0CUTPS <> *BLANKS) OR
     C                             (D0HVINS <> *BLANKS) OR
     C                             (D0NCLCS <> *BLANKS) OR
     C                             (D0NCLDS <> *BLANKS) OR
     C                             (D0SUBJS <> *BLANKS)
      *
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError = 'N'
     C                   EVAL      WCcc = D0CCLCS
     C                   EVAL      WFct = D0CUTPS
     C                   EVAL      WHvi = D0HVINS
     C                   EVAL      WFcc = D0NCLCS
     C                   EVAL      WFcd = D0NCLDS
     C                   EVAL      WStr = D0SUBJS
      *
      ** Build the Subfile With the Selection Criteria (Filters)
     C                   EXSR      SRBldSfl
      *
     C                   ENDIF
      *
     C                   OTHER
      *
      ** Process the Subfile
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError <> 'Y'
      *
      ** Clear Program Queue
     C                   EXSR      SRReset
      *
      ** Load the Subfile
     C                   EXSR      SRBldSfl
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * ChkFileLck - Check Files Allocation                             *
      *                                                                 *
      *******************************************************************
      *
     C     ChkFileLck    BEGSR
     C                   EVAL      IsFileLocked = 'N'
     C                   CALL      'SDC000558'
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM      'SD000109'    PCallerPGM       10
     C                   PARM      LckRlsFlag    PModeLck          7
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      IsFileLocked = 'Y'
     C                   EVAL      LckRlsFlag = *BLANKS
     C                   ENDIF
     C     ChkFileLckE   ENDSR
      *******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset - Reset the Fields                                   *
      *                                                               *
      *  Called by: MAIN Processing, SRProcess                        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReset       BEGSR
      *
      ** Clear Program Queue And Message File
     C                   CALL      'ZA0250'
      *
     C                   EVAL      WIdx = 0
      *
     C                   IF        Refresh = *ON
      *
      ** Reset Selection Fields
     C                   EVAL      D0CCLCS = *BLANKS
     C                   EVAL      D0CUTPS = *BLANKS
     C                   EVAL      D0HVINS = *BLANKS
     C                   EVAL      D0NCLCS = *BLANKS
     C                   EVAL      D0NCLDS = *BLANKS
     C                   EVAL      D0SUBJS = *BLANKS
     C                   EVAL      WCcc = *BLANKS
     C                   EVAL      WFct = *BLANKS
     C                   EVAL      WHvi = *BLANKS
     C                   EVAL      WFcc = *BLANKS
     C                   EVAL      WFcd = *BLANKS
     C                   EVAL      WStr = *BLANKS
      *
     C                   ENDIF
      *
     C                   IF        RunToolUpd <> *ON
     C                   EVAL      WarnTool = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSfl - Clear The SubFile                                 *
      *                                                               *
      *  Called by: SRBldSfl                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRClrSfl      BEGSR
      *
      ** Set Pointer To First Record Of Database
     C     *LOVAL        SETLL     SDFTHVL0
     C                   EVAL      WError = 'N'
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      D0ACTN = *BLANKS
     C                   EVAL      NoData = *OFF
     C                   EVAL      ActnErr = *OFF
     C                   EVAL      SflClr = *ON
      *
     C                   WRITE     SD000109C0
      *
     C                   EVAL      SflClr = *OFF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSfl - Load the Subfile                                 *
      *                                                               *
      *  Called by: SRBldSfl,SRProcess                                *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRLoadSfl     BEGSR
     C                   EVAL      WSelectCT = 'Y'
     C                   EVAL      WSelectHV = 'Y'
     C                   EVAL      WSelectCC = 'Y'
     C                   EVAL      WSelectCD = 'Y'
     C                   EVAL      WSelectSR = 'Y'
      *
      ** If Relative Record Number Of The Last Record Loaded In The
      ** Subfile Is Greater Than Zero
      *
     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
     C                   ENDIF
      *
      ** Set the Pointer To the Entered Current Classification Code
     C                   IF        (D0CCLCS <> *BLANKS) AND
     C                             (Rollup = *OFF) AND
     C                             NOT %EOF(SDFTHVL0)
     C     D0CCLCS       SETLL     SDFTHVL0
     C                   ENDIF
      *
      ** Reset Counter
     C                   EVAL      WCtr = 0
      *
      ** Display the No Of Records That Is Specified In The SFLPAG
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(SDFTHVL0)
      *
      ** Read the FATCA High Value Account Identification File
     C                   READ      SDFTHVL0
      *
     C                   IF        %EOF(SDFTHVL0)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(SDFTHVL0)
     C                   EVAL      D0CCLC = HVCCLC
     C                   EVAL      D0CUTP = HVCUTP
     C                   EVAL      D0HVIN = HVHVIN
     C                   EVAL      D0NCLC = HVNCLC
     C                   EVAL      D0SUBJ = HVSUBJ
      *
      ** Call The Access Object AOFATCR0
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D0NCLC        PClas
     C     SDFATC        PARM      SDFATC        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      D0NCLD = FCDESC
     C                   ELSE
     C                   EVAL      D0NCLD = *BLANKS
     C                   EVAL      FCDESC = *BLANKS
     C                   ENDIF
      *
      ** FATCA Customer Type Filter Is Not Blanks
     C                   IF        D0CUTPS <> *BLANKS
     C                   EVAL      PLenCUTP = %LEN(HVCUTP)
     C                   EVAL      PLenD0CUTP = %LEN(D0CUTPS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HVCUTP
     C                   PARM                    PLenCUTP
     C                   PARM                    PStart
     C                   PARM                    D0CUTPS
     C                   PARM                    PLenD0CUTP
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectCT = 'N'
     C                   EVAL      D0CUTP = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectCT = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** High Value Indicator Is Not Blanks
     C                   IF        D0HVINS <> *BLANKS
     C                   EVAL      PLenHVIN = %LEN(HVHVIN)
     C                   EVAL      PLenD0HVIN = %LEN(D0HVINS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HVHVIN
     C                   PARM                    PLenHVIN
     C                   PARM                    PStart
     C                   PARM                    D0HVINS
     C                   PARM                    PLenD0HVIN
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectHV = 'N'
     C                   EVAL      D0HVIN = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectHV = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** New FATCA Classification Code is not Blanks
     C                   IF        D0NCLCS <> *BLANKS
      *
     C                   EVAL      PLenNCLC = %LEN(HVNCLC)
     C                   EVAL      PLenD0NCLC = %LEN(D0NCLCS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HVNCLC
     C                   PARM                    PLenNCLC
     C                   PARM                    PStart
     C                   PARM                    D0NCLCS
     C                   PARM                    PLenD0NCLC
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectCC = 'N'
     C                   EVAL      D0NCLC = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectCC = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** New FATCA Classification Code Description is not Blanks
     C                   IF        D0NCLDS <> *BLANKS
      *
     C                   EVAL      PLenNCLD = %LEN(FCDESC)
     C                   EVAL      PLenD0NCLD = %LEN(D0NCLDS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    FCDESC
     C                   PARM                    PLenNCLD
     C                   PARM                    PStart
     C                   PARM                    D0NCLDS
     C                   PARM                    PLenD0NCLD
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectCD = 'N'
     C                   EVAL      D0NCLD = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectCD = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Subject To Reporting is not Blanks
     C                   IF        D0SUBJS <> *BLANKS
      *
     C                   EVAL      PLenSUBJ = %LEN(HVSUBJ)
     C                   EVAL      PLenD0SUBJ = %LEN(D0SUBJS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HVSUBJ
     C                   PARM                    PLenSUBJ
     C                   PARM                    PStart
     C                   PARM                    D0SUBJS
     C                   PARM                    PLenD0SUBJ
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectSR = 'N'
     C                   EVAL      D0SUBJ = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectSR = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write the Selected Records
     C                   IF        WSelectCT = 'Y' AND
     C                             WSelectHV = 'Y' AND
     C                             WSelectCC = 'Y' AND
     C                             WSelectCD = 'Y' AND
     C                             WSelectSR = 'Y'
      *
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      D0ACTN = *BLANKS
     C                   EVAL      ActnErr = *OFF
     C                   WRITE     SD000109S0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** Check For Last Record For Switching On the SFLEND Indicator
     C                   READ      SDFTHVL0
     C                   IF        %EOF(SDFTHVL0)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     SDFTHVL0
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
      *
      ** Check If Records Are Written Into Subfile
     C                   IF        WLstRrn <> 0
     C                   EVAL      SflDsp = *ON
     C                   ELSE
      *
      ** If No Records Exists, Then Show 'No Data to Display' Message
     C                   EVAL      SflDsp = *OFF
     C                   EVAL      NoData = *ON
     C                   EVAL      PMsgId = 'ASM0001'
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrSfl - Process the Subfile Functions                      *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRErrDta, SRChkAut                                    *
      *                                                               *
      *****************************************************************
     C     SRPrSfl       BEGSR
      *
      ** Check For Last Relative Record Number
     C                   IF        WLstRrn > *ZEROS
      *
      ** Reset Error Flag
     C                   EVAL      WError = 'N'
     C                   READC     SD000109S0
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WIdx = *ZEROS
      *
      ** Invalid Action Code
     C                   IF        (D0ACTN <> Amend) AND
     C                             (D0ACTN <> Enquire) AND
     C                             (D0ACTN <> Delete) AND
     C                             (D0ACTN <> *BLANKS)
     C                   EVAL      PMsgId = 'USR9357'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ENDIF
      *
      ***Check*For*User*Authority***********************************                       MD030170A
     C**********         IF        WIdx = 0                                                MD030170A
     C**********         EVAL      POpt = D0ACTN                                           MD030170A
     C**********         EXSR      SRChkAut                                                MD030170A
     C**********         ENDIF                                                             MD030170A
      *
      ***Error*In*Check*Authority***********************************                       MD030170A
     C                   IF        WIdx > *ZEROS
     C                   EVAL      WError = 'Y'
     C                   EVAL      ActnErr = *ON
     C                   EVAL      D0SFRN = RRN0
     C                   ELSE
     C                   EVAL      ActnErr = *OFF
     C                   ENDIF
      *
     C                   EVAL      *IN34 = *ON
     C                   UPDATE    SD000109S0
      *
     C                   READC     SD000109S0
      *
     C                   ENDDO
      *
     C                   EVAL      *IN34 = *OFF
      *
      ** If Error, Stop Processing Further
     C                   IF        ((WError = 'Y')  OR
     C                             ((WError = 'N') AND
     C                             (D0CCLCS <> WCcc OR
     C                             D0CUTPS <> WFct OR
     C                             D0HVINS <> WHvi OR
     C                             D0NCLCS <> WFcc OR
     C                             D0NCLDS <> WFcd OR
     C                             D0SUBJS <> WStr )) OR
     C                             Add = *ON OR RunToolInf = *ON
     C                             OR RunToolUpd =*ON)
     C                   LEAVESR
     C                   ENDIF
      *
      ** If No Error Call Maintenance Program
     C                   READC     SD000109S0
     C                   DOW       NOT %EOF
      *
      ** Call the Maintenance Program In Amend Mode
     C                   IF        D0ACTN <> *BLANKS
     C                   EVAL      POpt = D0ACTN
     C                   EVAL      PCclc = D0CCLC
     C                   EVAL      PCutp = D0CUTP
     C                   EVAL      PHvin = D0HVIN
      *
      ** Display Maintenance Screen
     C                   CALL      'SD000140'
     C                   PARM                    POpt
     C                   PARM                    PCclc
     C                   PARM                    PCutp
     C                   PARM                    PHvin
     C                   PARM      *BLANKS       PRetCode
      *
      ** When F3 Is Pressed, Come Out Of the Screen
     C                   IF        PRetCode = 'F3'
     C                   EVAL      Exit = *ON
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      D0ACTN = *BLANKS
      *
     C                   UPDATE    SD000109S0
      *
     C                   ENDIF
     C                   READC     SD000109S0
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkAut - Validate Authorization Of User For The SubFile    *
      *             Option                                            *
      *                                                               *
      *  Called by: SRPrSfl, SRProcess                                *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRChkAut      BEGSR
      *
      ** Check Whether The User Is Authorized For The Selected
      ** Operation
      *
     C                   IF        BJSBRC <> *BLANKS
      *
      ** Single Branching
     C                   CALL      'ZVACTU'
     C                   PARM                    POpt
     C                   PARM      *ZEROS        PErr
      *
     C                   IF        PErr = 1
     C                   EVAL      PMSGID = 'USR4436'
     C                   EVAL      ActnErr = *ON
     C                   EVAL      WIdx = WIdx +1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Multi Branching
     C                   CALL      'ZVACTBU'
     C                   PARM                    POpt
     C                   PARM      PBrc          PZbr
     C                   PARM      *ZEROS        PErr
      *
     C                   IF        PErr = 1
     C                   EVAL      PMsgId = 'CSF9008'
     C                   EVAL      ActnErr = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ELSEIF    PErr = 2
     C                   EVAL      PMsgId = 'USR4436'
     C                   EVAL      ActnErr = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output Error Message With Data                    *
      *                                                               *
      *  Called by: SRChkAut, SRPrSfl                                 *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRErrDta      BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM      D0CCLC        PMsgData
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        Wrun = *BLANKS
      *
     C                   EVAL      Wrun = 'Y'
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
