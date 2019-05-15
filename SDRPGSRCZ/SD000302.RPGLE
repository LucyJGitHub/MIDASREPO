     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CRS Cust Type/Subtype Subfile')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000302 - Midas SD CRS Customer Type/Subtype                *
      *             Allocation Subfile                                *
      *                                                               *
      *  Function:  This program display the records from the CRS     *
      *             Customer Type/Subtype Allocation File             *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
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
      ** CSR Customer Type/Subtype Allocation File
     FSDCRCTL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** CRS Customer Type/Subtype Allocation Subfile
     FSD000302DFCF   E             WORKSTN
     F                                     SFILE(SD000302S0:RRN0 )
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
      ** External DS Based On SDINSTPD
     D SDINST        E DS                  EXTNAME(SDINSTPD)
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
     D ##OV1           S             70    DIM(1) CTDATA PERRCD(1)
     D ##OV2           S             70    DIM(1) CTDATA PERRCD(1)
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Ind_Pointer     S               *   INZ(%ADDR(*IN))
     D POpt            S              1A
     D Plinc           S              2A
     D PLicd           S              2A
     D RRN0            S              4S 0
     D WLstRrn         S              4S 0
     D WSelectCT       S              1A
     D WSelectCS       S              1A
     D WSelectCC       S              1A
     D WSelectLN       S              1A
     D WSelectIC       S              1A
     D WSelectEX       S              1A
     D WError          S              1A   INZ('N')
     D WCtr            S              2  0
     D WarnTool        S              1A   INZ('N')
     D IsFileLocked    S              1A   INZ('N')
     D LckRlsFlag      S              5A
     D WMsgLen         S             15P 5 INZ(70)
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
     D SflPag          C                   CONST(12)
     D Amend           C                   CONST('A')
     D Enquire         C                   CONST('E')
     D Delete          C                   CONST('D')
      *
      ** Parameter For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Parameter For SDC000558
     D PCallerPGM      S             10A
     D PModeLck        S              7A
      *
      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenTYPE        S              3P 0
     D PLenSTYP        S              3P 0
     D PLenLINM        S              3P 0
     D PLenINFO        S              3P 0
     D PLenEXMP        S              3P 0
     D PLenD0TYPE      S              3P 0
     D PLenD0STYP      S              3P 0
     D PLenD0LINM      S              3P 0
     D PLenD0INFO      S              3P 0
     D PLenD0EXMP      S              3P 0
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
     D WLic            S                   LIKE(D0LICS)
     D WFct            S                   LIKE(D0TYPS)
     D WFcs            S                   LIKE(D0STPS)
     D WLin            S                   LIKE(D0LIMS)
     D WFic            S                   LIKE(D0INFS)
     D WExm            S                   LIKE(D0EXMS)
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
     C                   WRITE     SD000302F0
      *
      ** Write the Message Subfile Control Format
     C                   WRITE     SD000302C1
      *
      ** Display the Subfile
     C                   EXFMT     SD000302C0
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
     C                   IF        D0LICS = *BLANKS
     C                   EVAL      WLic = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0TYPS = *BLANKS
     C                   EVAL      WFct = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0STPS = *BLANKS
     C                   EVAL      WFcs = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0LIMS = *BLANKS
     C                   EVAL      WLin = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0INFS = *BLANKS
     C                   EVAL      WFic = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0EXMS = *BLANKS
     C                   EVAL      WExm = *BLANKS
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
     C                             (D0LICS = WLic) AND
     C                             (D0TYPS = WFct) AND
     C                             (D0STPS = WFcs) AND
     C                             (D0LIMS = WLin) AND
     C                             (D0INFS = WFic) AND
     C                             (D0EXMS = WExm)
      *
      ** Process the Function Keys And the Values Entered On the
      ** Screen
     C                   EXSR      SRPrSfl
      *
      ** Call the Input Screen
     C                   IF        WIdx = 0
     C                   CALL      'SD000303'
     C                   PARM      'I'           POpt
     C                   PARM      *BLANKS       PLinc
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
     C                             (D0LICS = WLic) AND
     C                             (D0TYPS = WFct) AND
     C                             (D0STPS = WFcs) AND
     C                             (D0LIMS = WLin) AND
     C                             (D0INFS = WFic) AND
     C                             (D0EXMS = WExm)
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
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV1
     C                   PARM                    WMsgLen

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV2
     C                   PARM                    WMsgLen
      *
     C                   CALL      'SD000304'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PMode
      *
     C                   IF        PMode = 'U'
     C                   EVAL      LckRlsFlag = '*RLS '
     C                   EXSR      ChkFileLck
     C                   ENDIF
      *
     C                   CALL      'SD000305'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PMode
      *
      ** Build the Subfile Along With the New Records Added
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
     C                   ENDIF
     C                   ENDIF
      *
      ** When Selection Filters Are Not Changed And Valid Options
      ** Are Entered On the Screen, Process the Subfile
     C                   WHEN      (D0LICS = WLic) AND
     C                             (D0TYPS = WFct) AND
     C                             (D0STPS = WFcs) AND
     C                             (D0LIMS = WLin) AND
     C                             (D0INFS = WFic) AND
     C                             (D0EXMS = WExm) AND
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
     C                   WHEN      (D0LICS <> *BLANKS) OR
     C                             (D0TYPS <> *BLANKS) OR
     C                             (D0STPS <> *BLANKS) OR
     C                             (D0LIMS <> *BLANKS) OR
     C                             (D0INFS <> *BLANKS) OR
     C                             (D0EXMS <> *BLANKS)
      *
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError = 'N'
     C                   EVAL      WLic = D0LICS
     C                   EVAL      WFct = D0TYPS
     C                   EVAL      WFcs = D0STPS
     C                   EVAL      WLin = D0LIMS
     C                   EVAL      WFic = D0INFS
     C                   EVAL      WExm = D0EXMS
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
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      'SD000302'    PCallerPGM
     C                   PARM      LckRlsFlag    PModeLck

     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      IsFileLocked = 'Y'
     C                   EVAL      LckRlsFlag = *BLANKS
     C                   ENDIF
      *
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
     C                   EVAL      D0LICS = *BLANKS
     C                   EVAL      D0TYPS = *BLANKS
     C                   EVAL      D0STPS = *BLANKS
     C                   EVAL      D0LIMS = *BLANKS
     C                   EVAL      D0INFS = *BLANKS
     C                   EVAL      D0EXMS = *BLANKS
     C                   EVAL      WLic = *BLANKS
     C                   EVAL      WFct = *BLANKS
     C                   EVAL      WFcs = *BLANKS
     C                   EVAL      WLin = *BLANKS
     C                   EVAL      WFic = *BLANKS
     C                   EVAL      WExm = *BLANKS
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
     C     *LOVAL        SETLL     SDCRCTL0
     C                   EVAL      WError = 'N'
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      D0ACTN = *BLANKS
     C                   EVAL      NoData = *OFF
     C                   EVAL      ActnErr = *OFF
     C                   EVAL      SflClr = *ON
      *
     C                   WRITE     SD000302C0
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
     C                   EVAL      WSelectCS = 'Y'
     C                   EVAL      WSelectCC = 'Y'
     C                   EVAL      WSelectLN = 'Y'
     C                   EVAL      WSelectIC = 'Y'
     C                   EVAL      WSelectEX = 'Y'
      *
      ** If Relative Record Number Of The Last Record Loaded In The
      ** Subfile Is Greater Than Zero
      *
     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
     C                   ENDIF
      *
      ** Set the Pointer To the Entered Local Institution Code
     C                   IF        (D0LICS <> *BLANKS) AND
     C                             (Rollup = *OFF) AND
     C                             NOT %EOF(SDCRCTL0)
     C     D0LICS        SETLL     SDCRCTL0
     C                   ENDIF
      *
      ** Reset Counter
     C                   EVAL      WCtr = 0
      *
      ** Display the No Of Records That Is Specified In The SFLPAG
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(SDCRCTL0)
      *
      ** Read the CRS Customer Type/Subtype Allocation File
     C                   READ      SDCRCTL0
      *
     C                   IF        %EOF(SDCRCTL0)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(SDCRCTL0)
     C                   EVAL      D0LINC = CTLINC
     C                   EVAL      D0TYPE = CTTYPE
     C                   EVAL      D0STYP = CTSTYP
     C                   EVAL      D0INFO = CTINFO
     C                   EVAL      D0EXMP = CTEXMP
      *
      ** Call The Access Object AOINSTR0
     C                   CALL      'AOINSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      D0LINC        PLicd
     C     SDINST        PARM      SDINST        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      D0LINM = AKLINM
     C                   ELSE
     C                   EVAL      D0LINM = *BLANKS
     C                   EVAL      AKLINM = *BLANKS
     C                   ENDIF
      *
      ** Local Instituition Name is not Blanks
     C                   IF        D0LIMS <> *BLANKS
      *
     C                   EVAL      PLenLINM = %LEN(AKLINM)
     C                   EVAL      PLenD0LINM = %LEN(D0LIMS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    AKLINM
     C                   PARM                    PLenLINM
     C                   PARM                    PStart
     C                   PARM                    D0LIMS
     C                   PARM                    PLenD0LINM
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectLN = 'N'
     C                   EVAL      D0LINM = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectLN = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** CRS Customer Type Filter Is Not Blanks
     C                   IF        D0TYPS <> *BLANKS
     C                   EVAL      PLenTYPE = %LEN(CTTYPE)
     C                   EVAL      PLenD0TYPE = %LEN(D0TYPS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    CTTYPE
     C                   PARM                    PLenTYPE
     C                   PARM                    PStart
     C                   PARM                    D0TYPS
     C                   PARM                    PLenD0TYPE
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectCT = 'N'
     C                   EVAL      D0TYPE = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectCT = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** CRS Customer Sub-Type Filter Is Not Blanks
     C                   IF        D0STPS <> *BLANKS
     C                   EVAL      PLenSTYP = %LEN(CTSTYP)
     C                   EVAL      PLenD0STYP = %LEN(D0STPS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    CTSTYP
     C                   PARM                    PLenSTYP
     C                   PARM                    PStart
     C                   PARM                    D0STPS
     C                   PARM                    PLenD0STYP
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectCS = 'N'
     C                   EVAL      D0STYP = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectCS = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** CRS Information Complete is not Blanks
     C                   IF        D0INFS <> *BLANKS
      *
     C                   EVAL      PLenINFO = %LEN(CTINFO)
     C                   EVAL      PLenD0INFO = %LEN(D0INFS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    CTINFO
     C                   PARM                    PLenINFO
     C                   PARM                    PStart
     C                   PARM                    D0INFS
     C                   PARM                    PLenD0INFO
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectIC = 'N'
     C                   EVAL      D0INFO = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectIC = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Exempt is not Blanks
     C                   IF        D0EXMS <> *BLANKS
      *
     C                   EVAL      PLenEXMP = %LEN(CTEXMP)
     C                   EVAL      PLenD0EXMP = %LEN(D0EXMS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    CTEXMP
     C                   PARM                    PLenEXMP
     C                   PARM                    PStart
     C                   PARM                    D0EXMS
     C                   PARM                    PLenD0EXMP
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectEX = 'N'
     C                   EVAL      D0EXMP = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectEX = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write the Selected Records
     C                   IF        WSelectCT = 'Y' AND
     C                             WSelectCS = 'Y' AND
     C                             WSelectCC = 'Y' AND
     C                             WSelectLN = 'Y' AND
     C                             WSelectIC = 'Y' AND
     C                             WSelectEX = 'Y'
      *
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      D0ACTN = *BLANKS
     C                   EVAL      ActnErr = *OFF
     C                   WRITE     SD000302S0
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
     C                   READ      SDCRCTL0
     C                   IF        %EOF(SDCRCTL0)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     SDCRCTL0
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
     C                   READC     SD000302S0
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
     C                   IF        WIdx > *ZEROS
     C                   EVAL      WError = 'Y'
     C                   EVAL      ActnErr = *ON
     C                   EVAL      D0SFRN = RRN0
     C                   ELSE
     C                   EVAL      ActnErr = *OFF
     C                   ENDIF
      *
     C                   EVAL      *IN34 = *ON
     C                   UPDATE    SD000302S0
      *
     C                   READC     SD000302S0
      *
     C                   ENDDO
      *
     C                   EVAL      *IN34 = *OFF
      *
      ** If Error, Stop Processing Further
     C                   IF        ((WError = 'Y')  OR
     C                             ((WError = 'N') AND
     C                             (D0LICS <> WLic OR
     C                             D0TYPS <> WFct OR
     C                             D0STPS <> WFcs OR
     C                             D0LIMS <> WLin OR
     C                             D0INFS <> WFic OR
     C                             D0EXMS <> WExm )) OR
     C                             Add = *ON OR RunToolInf = *ON
     C                             OR RunToolUpd =*ON)
     C                   LEAVESR
     C                   ENDIF
      *
      ** If No Error Call Maintenance Program
     C                   READC     SD000302S0
     C                   DOW       NOT %EOF
      *
      ** Call the Maintenance Program In Amend Mode
     C                   IF        D0ACTN <> *BLANKS
     C                   EVAL      POpt = D0ACTN
     C                   EVAL      PLinc = D0LINC
      *
      ** Display Maintenance Screen
     C                   CALL      'SD000303'
     C                   PARM                    POpt
     C                   PARM                    PLinc
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
     C                   UPDATE    SD000302S0
      *
     C                   ENDIF
     C                   READC     SD000302S0
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
     C                   PARM      D0LINC        PMsgData
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
(c) Finastra International Limited 2016
** ##OV1
OVRDBF FILE(SDCRCLL0) TOFILE(QTEMP/SDCRCLL0) SHARE(*NO)
** ##OV2
CLRPFM FILE(QTEMP/SDCRCLPD)
