     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD MIC Code SubFile')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009802 - Midas SD Market Identification Code               *
      *             Subfile                                           *
      *                                                               *
      *  Function:  This program display the records from the         *
      *             MIC Code file                                     *
      *                                                               *
      *  Called By: SDC009818 - MIDAS SD MiFID Subfile Menu Option    *
      *                         Controller                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. MD029814           Date 28Aug14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029814 - MIC Code Maintenance, Action invalid for user when*
      *             insertion. If Add, move 'I' to D0Opt.             *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03 - Exit                                                  *
      *    05 - Refresh                                               *
      *    09 - Add                                                   *
      *    12 - Cancel                                                *
      *    30 - Subfile Display                                       *
      *    31 - Subfile Clear                                         *
      *    32 - Subfile Message End                                   *
      *    33 - Error indicator                                       *
      *    36 - Subfile End                                           *
      *    80 - No Data To Display                                    *
      *    98 - Rollup Indicator                                      *
      *    42 - Enquire Mode                                          *
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
      ** Market Identification Code File
     FSDMICCL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** MIC Code Maintenance Display File
     FSD009802DFCF   E             WORKSTN
     F                                     SFILE(SD009802S0:RRN0 )
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
      ** DS For Indicators
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                  03     03
     D  Refresh               05     05
     D  Add                   09     09
     D  Cancel                12     12
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
     D IndPointer      S               *   INZ(%ADDR(*IN))
     D POpt            S              1A
     D PMicCod         S              6A
     D RRN0            S              4S 0
     D WLstRrn         S              4S 0
     D WSelectYN       S              1A
     D WError          S              1A   INZ('N')
     D WCtr            S              2  0
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
     D SflPag          C                   CONST(14)
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
     D PLenMICDES      S              3P 0
     D PLenD0CDES      S              3P 0
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
      ** Variable Decleration
     D PRetCode        S              3A
     D WRun            S              1A
     D WIdx            S              3P 0
     D WCCod           S                   LIKE(D0CCODS)
     D WCDes           S                   LIKE(D0CDESS)
      *
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
      ** Check if in Enquiry Mode
     C                   IF        PMode = 'E'
     C                   EVAL      *IN42 = *ON
     C                   ELSE
     C                   EVAL      *IN42 = *OFF
     C                   ENDIF
      *
      ** Build the Subfile
     C                   EXSR      SRBldSfl
      *
      ** Dsiplay the Screen Untill F12 or F3 Is Pressed
     C                   DOW       (Exit = *OFF) AND
     C                             (Cancel = *OFF)
      *
      ** Display And Process the Subfile
     C                   EXSR      SRDspSfl
      *
      ** Process the Subfile
     C                   EXSR      SRProcess
      *
     C                   ENDDO
      *
      ** Commit For File SDMICCL0
     C                   COMMIT
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
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
     C     *ENTRY        PLIST
     C                   PARM                    PMode
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
     C                   EVAL      DBASE = 001
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
     C                   EVAL      D0WID = PsJobName
      *
      ** Populate User
     C                   EVAL      D0USER = PsUser
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
     C                   WRITE     SD009802F0
      *
      ** Write the Message Subfile Control Format
     C                   WRITE     SD009802C1
      *
      ** Display the Subfile
     C                   EXFMT     SD009802C0
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
      ** Reset the Fields and the Program Message Queue
     C                   EXSR      SRReset
      *
     C                   IF        D0CCODS = *BLANKS
     C                   EVAL      WCCod = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0CDESS = *BLANKS
     C                   EVAL      WCDes = *BLANKS
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
      ** Reset and Build
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
      *
      ** When Page Down Is Pressed
     C                   WHEN      Rollup = *ON
      *
      ** Load the Next Page
     C                   EXSR      SRLoadSfl
      *
      ** When F9 Is Pressed And Mic Code And Description
      ** Filters Are Not Changed
      *
     C                   WHEN      (ADD = *ON) AND
     C                             (D0CCODS =  WCCod) AND
     C                             (D0CDESS =  WCDes)
      *
      ** Process the Function Keys and the Values Entered On the
      ** Screen
      *
     C                   EXSR      SRPrSfl
      *
      ** Check the Authority
     C                   IF        WIdx = 0
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Call the Input Screen
     C                   IF        WIdx = 0
     C                   CALL      'SD009803'
     C                   PARM      'I'           POpt
     C                   PARM      *BLANKS       PMicCod
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
      ** When MIC code And Description Filters Are Not Changed And
      ** Valid Options Are Entered On the Screen, Process the Subfile
      *
     C                   WHEN      (D0CCODS =  WCCod) AND
     C                             (D0CDESS =  WCDes) AND
     C                             (Add = *OFF)
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError <> 'Y'
      *
      ** Reset Program Message Queue and Fields
     C                   EXSR      SRReset
      *
      ** Build the Subfile
     C                   EXSR      SRBldSfl
      *
     C                   ENDIF
      *
     C                   WHEN      (D0CCODS <> *BLANKS) OR
     C                             (D0CDESS <> *BLANKS)
      *
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError = 'N'
     C                   EVAL      WCCod = D0CCODS
     C                   EVAL      WCDes = D0CDESS
      *
      ** Build the Subfile With the Selection Criteria
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
      ** Reset Program Queue
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
      ** Reset Search Fields
     C                   EVAL      D0CCODS = *BLANKS
     C                   EVAL      D0CDESS = *BLANKS
     C                   EVAL      WCCod = *BLANKS
     C                   EVAL      WCDes = *BLANKS
      *
     C                   ENDIF
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
     C     *LOVAL        SETLL     SDMICCL0
      *
      ** Intialise Fields
     C                   EVAL      WError = 'N'
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      D0OPT = *BLANKS
     C                   EVAL      NoData = *OFF
     C                   EVAL      ActnErr = *OFF
     C                   EVAL      SflClr = *ON
      *
     C                   WRITE     SD009802C0
      *
     C                   EVAL      SflClr = *OFF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSfl - Load the subfile                                 *
      *                                                               *
      *  Called by: SRBldSfl, SRProcess                               *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRLoadSfl     BEGSR
      *
      ** Intialise Filter Flags - No Search Criteria
     C                   EVAL      WSelectYN = 'Y'
      *
      ** If Relative Record Number Of The Last Record Loaded In The
      ** Subfile Is Greater Than Zero
      *
     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
     C                   ENDIF
      *
      ** If Position field - MIC Code is not blank,
      ** Set the Pointer To the Entered MIC Code
      *
     C                   IF        (D0CCODS <> *BLANKS) AND
     C                             (Rollup = *OFF) AND
     C                             NOT %EOF(SDMICCL0)
     C     D0CCODS       SETLL     SDMICCL0
     C                   ENDIF
      *
      ** Reset Counter
     C                   EVAL      WCtr = 0
      *
      ** Display the No Of Records That Is Specified In The SFLPAG
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(SDMICCL0)
      *
      ** Read the MIC Code file
     C                   READ      SDMICCL0
      *
     C                   IF        %EOF(SDMICCL0)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(SDMICCL0)
     C                   EVAL      D0CCOD = MICCOD
     C                   EVAL      D0CDES = MICDES
      *
      ** MIC code Filter Is Not Blanks
     C                   IF        D0CDESS <> *BLANKS
     C                   EVAL      PLenMICDES = %LEN(MICDES)
     C                   EVAL      PLenD0CDES = %LEN(D0CDESS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    MICDES
     C                   PARM                    PLenMICDES
     C                   PARM                    PStart
     C                   PARM                    D0CDESS
     C                   PARM                    PLenD0CDES
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      MICCOD = *BLANKS
     C                   EVAL      WSelectYN = 'N'
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectYN = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write the Selected Records
     C                   IF        WSelectYN = 'Y'
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      D0OPT = *BLANKS
     C                   EVAL      ActnErr = *OFF
     C                   WRITE     SD009802S0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** Check For Last Record for Switching On the SFLEND Indicator
     C                   READ      SDMICCL0
     C                   IF        %EOF(SDMICCL0)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     SDMICCL0
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
      *
      ** Check If Records are Written Into Subfile
     C                   IF        WLstRrn <> 0
     C                   EVAL      SflDsp = *ON
     C                   ELSE
      *
      ** If No Records Exists, then show 'No Data to Display' Message
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
     C                   READC     SD009802S0
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WIdx = *ZEROS
      *
      ** Invalid Action Code
      ** in case of maintenance mode
      *
     C                   IF        (D0OPT <> Amend) AND
     C                             (D0OPT <> Enquire) AND
     C                             (D0OPT <> Delete) AND
     C                             (D0OPT <> *BLANKS) AND
     C                             (PMode = 'M')
     C                   EVAL      PMsgId = 'SCC0013'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
      ** Validation for Action code - in case of Enquire mode
     C                   ELSEIF    (D0OPT <> Enquire) AND
     C                             (D0OPT <> *BLANKS) AND
     C                             (PMode = 'E')
      *
     C                   EVAL      PMsgId = 'SDA0005'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ENDIF
      *
      ** Check For User Authority
     C                   IF        WIdx = 0
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Error In Check Authority
     C                   IF        WIdx > *ZEROS
     C                   EVAL      WError = 'Y'
     C                   EVAL      ActnErr = *ON
     C                   EVAL      D0SFRN = RRN0
     C                   ELSE
     C                   EVAL      ActnErr = *OFF
     C                   ENDIF
      *
     C                   EVAL      *IN34 = *ON
     C                   UPDATE    SD009802S0
      *
     C                   READC     SD009802S0
      *
     C                   ENDDO
      *
     C                   EVAL      *IN34 = *OFF
      *
      ** If Error, Stop Processing Further
     C                   IF        ((WError = 'Y')  OR
     C                             ((WError = 'N') AND
     C                             (D0CCODS <> WCCod OR
     C                             D0CDESS <> WCDes )) OR
     C                             Add = *ON)
     C                   LEAVESR
     C                   ENDIF
      *
      ** If No Error Call Maintenance Program
     C                   READC     SD009802S0
     C                   DOW       NOT %EOF
      *
      ** Call the Maintenance Program In Amend Mode
     C                   IF        D0OPT <> *BLANKS
     C                   EVAL      POpt = D0OPT
     C                   EVAL      PMicCod = D0CCOD
      *
      ** Display Maintenance Screen
     C                   CALL      'SD009803'
     C                   PARM                    POpt
     C                   PARM                    PMicCod
     C                   PARM      *BLANKS       PRetCode
      *
      ** When F3 Is Pressed, Come Out Of the Screen
     C                   IF        PRetCode = 'F3'
     C                   EVAL      Exit = *ON
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      D0OPT = *BLANKS
      *
     C                   UPDATE    SD009802S0
      *
     C                   ENDIF
     C                   READC     SD009802S0
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
      *                                                                                     MD029814
      ** If D0Opt (subfile field) is equal blank, move 'I' to process                       MD029814
      ** the user if authorized for the selected operation                                  MD029814
      *                                                                                     MD029814
     C                   If        ADD = *ON AND                                            MD029814
     C                             D0Opt = ' '                                              MD029814
     C                   Eval      D0Opt = 'I'                                              MD029814
     C                   Endif                                                              MD029814
      *
      ** Check Whether The User Is Authorized For The Selected
      ** Operation
      *
     C                   IF        BJSBRC <> *BLANKS
      *
      ** Single Branching
     C                   CALL      'ZVACTU'
     C                   PARM      POpt          D0OPT
     C                   PARM      *ZEROS        PErr
      *
     C                   IF        PErr = 1
     C                   EVAL      PMSGID = 'FXM0292'
     C                   EVAL      ActnErr = *ON
     C                   EVAL      WIdx = WIdx +1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Multi Branching
     C                   CALL      'ZVACTBU'
     C                   PARM      D0OPT         POpt
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
     C                   CAll      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM      *BLANKS       PMsgData
      *
     C                   ENDSR
      *
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
      /EJECT
      *****************************************************************
