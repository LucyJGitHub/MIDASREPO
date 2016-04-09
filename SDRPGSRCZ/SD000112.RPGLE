     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA High Value A/C Identification List')    *
      *****************************************************************
      *  Includes MD024763                                            *
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000112 - Midas SD FATCA High Value Account Identification  *
      *             List                                              *
      *                                                               *
      *  Function:  This program display the records from the FATCA   *
      *             High Value Account Identification List File       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    04 - Print                                                 *
      *    05 - Refresh                                               *
      *    12 - Previous                                              *
      *    30 - Subfile Display                                       *
      *    31 - Subfile Clear                                         *
      *    32 - Subfile Message End                                   *
      *    36 - Subfile End                                           *
      *    40 - Print Key                                             *
      *    80 - No Data To Display                                    *
      *    98 - Rollup Indicator                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *  SRBldSfl  - Build the Subfile                                *
      *  SRLoadSfl - Load the Subfile                                 *
      *  SRDspSfl  - Display the Subfile                              *
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
      ** FATCA High Value Account Identification List File
     FSDFTHLL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** FATCA High Value Account Identification List
     FSD000112DFCF   E             WORKSTN
     F                                     SFILE(SD000112S0:RRN0 )
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
     D Indicators      DS                  BASED(Ind_Pointer)
     D  Print                 04     04
     D  Refresh               05     05
     D  Previous              12     12
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflMsgEnd             32     32
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
     D RRN0            S              4S 0
     D WLstRrn         S              4S 0
     D WSelectUT       S              1A
     D WSelectCC       S              1A
     D WSelectNC       S              1A
     D WSelectCT       S              1A
     D WSelectHI       S              1A
     D WSelectSR       S              1A
     D WSelectHA       S              1A
     D WCtr            S              2  0
     D PMode           S              1A
     D Mode            S              1A
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D SflPag          C                   CONST(10)
      *
      ** Parameter For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenUTIN        S              3P 0
     D PLenCCLC        S              3P 0
     D PLenNCLC        S              3P 0
     D PLenCUTP        S              3P 0
     D PLenHVIN        S              3P 0
     D PLenSUBJ        S              3P 0
     D PLenHVAM        S              3P 0
     D PLenD0UTIN      S              3P 0
     D PLenD0CCLC      S              3P 0
     D PLenD0NCLC      S              3P 0
     D PLenD0CUTP      S              3P 0
     D PLenD0HVIN      S              3P 0
     D PLenD0SUBJ      S              3P 0
     D PLenD0HVAM      S              3P 0
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
     D WRun            S              1A
     D WCus            S                   LIKE(D0CUSTS)
     D WUti            S                   LIKE(D0UTINS)
     D WFcc            S                   LIKE(D0CCLCS)
     D WFnc            S                   LIKE(D0NCLCS)
     D WFct            S                   LIKE(D0CUTPS)
     D WHvi            S                   LIKE(D0HVINS)
     D WSbj            S                   LIKE(D0SUBJS)
     D WHam            S                   LIKE(D0HVAMS)
     D PLOWI           S             18A
     D PLOWE           S             18A
     D PHIGT           S             18A
     D PHVCY           S              3A
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
      ** Display Print Key If Not In Update Mode
     C                   IF        PMode <> 'U'
     C                   EVAL      *IN40 = *ON
     C                   ELSE
     C                   EVAL      *IN40 = *OFF
     C                   ENDIF
      ** Build the Subfile
     C                   EXSR      SRBldSfl
      *
      ** Display the Screen Until F12 Is Pressed
     C                   DOW       (Previous = *OFF)
      *
      ** Display And Process the Subfile
     C                   EXSR      SRDspSfl
      *
      ** Process the Subfile
     C                   EXSR      SRProcess
      *
     C                   ENDDO
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
      ** Parameters
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    PMode
     C                   PARM                    PLOWI
     C                   PARM                    PLOWE
     C                   PARM                    PHIGT
     C                   PARM                    PHVCY
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
     C                   EVAL      D0MRDT = BJMRDT
      *
      ** Populate System values
     C                   EVAL      D0LOWI = PLOWI
     C                   EVAL      D0LOWE = PLOWE
     C                   EVAL      D0HIGT = PHIGT
     C                   EVAL      D0HVCY = PHVCY
 
      ** Trim leading spaces before the display
 
     C                   EVAL      D0LOWI = %TRIML(D0LOWI)
     C                   EVAL      D0LOWE = %TRIML(D0LOWE)
     C                   EVAL      D0HIGT = %TRIML(D0HIGT)
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
     C                   WRITE     SD000112F0
      *
      ** Write the Message Subfile Control Format
     C                   WRITE     SD000112C1
      *
      ** Display the Subfile
     C                   EXFMT     SD000112C0
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
      *  Calls: SRReset, SRBldSfl, SRLoadSfl                          *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR
      *
      ** Reset the Fields and The Program Message Queue
     C                   EXSR      SRReset
      *
     C                   IF        D0CUSTS = *BLANKS
     C                   EVAL      WCus = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0UTINS = *BLANKS
     C                   EVAL      WUti = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0CCLCS = *BLANKS
     C                   EVAL      WFcc = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0NCLCS = *BLANKS
     C                   EVAL      WFnc = *BLANKS
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
     C                   IF        D0SUBJS = *BLANKS
     C                   EVAL      WSbj = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0HVAMS = *BLANKS
     C                   EVAL      WHam = *BLANKS
     C                   ENDIF
      *
     C                   SELECT
      *
      ** When F12 Is Pressed
     C                   WHEN      Previous = *ON
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
     C                   WHEN      (Print = *ON) AND
     C                             (D0CUSTS = WCus) AND
     C                             (D0UTINS = WUti) AND
     C                             (D0CCLCS = WFcc) AND
     C                             (D0NCLCS = WFnc) AND
     C                             (D0CUTPS = WFct) AND
     C                             (D0HVINS = WHvi) AND
     C                             (D0SUBJS = WSbj) AND
     C                             (D0HVAMS = WHam)
      *
      ** Print
     C                   CALL      'SD000161'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      'R'           Mode
     C                   PARM                    PLOWI
     C                   PARM                    PLOWE
     C                   PARM                    PHIGT
     C                   PARM                    PHVCY
      *
      ** Display a message that the print was successful
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      PMsgId = 'USS0286'
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** Build the Subfile Along With the New Records Added
     C                   EXSR      SRBldSfl
      *
      ** When Selection Filters Are Entered
     C                   WHEN      (D0CUSTS <> *BLANKS) OR
     C                             (D0UTINS <> *BLANKS) OR
     C                             (D0CCLCS <> *BLANKS) OR
     C                             (D0NCLCS <> *BLANKS) OR
     C                             (D0CUTPS <> *BLANKS) OR
     C                             (D0HVINS <> *BLANKS) OR
     C                             (D0SUBJS <> *BLANKS) OR
     C                             (D0HVAMS <> *BLANKS)
      *
     C                   EVAL      WCus = D0CUSTS
     C                   EVAL      WUti = D0UTINS
     C                   EVAL      WFcc = D0CCLCS
     C                   EVAL      WFnc = D0NCLCS
     C                   EVAL      WFct = D0CUTPS
     C                   EVAL      WHvi = D0HVINS
     C                   EVAL      WSbj = D0SUBJS
     C                   EVAL      WHam = D0HVAMS
      *
      ** Build the Subfile With the Selection Criteria (Filters)
     C                   EXSR      SRBldSfl
     C                   OTHER
      *
      ** Clear Program Queue
     C                   EXSR      SRReset
      *
      ** Build the Subfile
     C                   EXSR      SRBldSfl
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
     C                   IF        Refresh = *ON
      *
      ** Reset Selection Fields
     C                   EVAL      D0CUSTS = *BLANKS
     C                   EVAL      D0UTINS = *BLANKS
     C                   EVAL      D0CCLCS = *BLANKS
     C                   EVAL      D0NCLCS = *BLANKS
     C                   EVAL      D0CUTPS = *BLANKS
     C                   EVAL      D0HVINS = *BLANKS
     C                   EVAL      D0SUBJS = *BLANKS
     C                   EVAL      D0HVAMS = *BLANKS
     C                   EVAL      WCus = *BLANKS
     C                   EVAL      WUti = *BLANKS
     C                   EVAL      WFcc = *BLANKS
     C                   EVAL      WFnc = *BLANKS
     C                   EVAL      WFct = *BLANKS
     C                   EVAL      WHvi = *BLANKS
     C                   EVAL      WSbj = *BLANKS
     C                   EVAL      WHam = *BLANKS
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
     C     *LOVAL        SETLL     SDFTHLL0
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      NoData = *OFF
     C                   EVAL      SflClr = *ON
      *
     C                   WRITE     SD000112C0
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
     C                   EVAL      WSelectUT = 'Y'
     C                   EVAL      WSelectCC = 'Y'
     C                   EVAL      WSelectNC = 'Y'
     C                   EVAL      WSelectCT = 'Y'
     C                   EVAL      WSelectHI = 'Y'
     C                   EVAL      WSelectSR = 'Y'
     C                   EVAL      WSelectHA = 'Y'
      *
      ** If Relative Record Number Of The Last Record Loaded In The
      ** Subfile Is Greater Than Zero
      *
     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
     C                   ENDIF
      *
      ** Set the Pointer To the Entered Customer Number
     C                   IF        (D0CUSTS <> *BLANKS) AND
     C                             (Rollup = *OFF) AND
     C                             NOT %EOF(SDFTHLL0)
     C     D0CUSTS       SETLL     SDFTHLL0
     C                   ENDIF
      *
      ** Reset Counter
     C                   EVAL      WCtr = 0
      *
      ** Display the No Of Records That Is Specified In The SFLPAG
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(SDFTHLL0)
      *
      ** Read the FATCA Customer Type & Classification List File
     C                   READ      SDFTHLL0
      *
     C                   IF        %EOF(SDFTHLL0)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(SDFTHLL0)
     C                   EVAL      D0CUST = HLCUST
     C                   EVAL      D0UTIN = HLUTIN
     C                   EVAL      D0CCLC = HLCCLC
     C                   EVAL      D0NCLC = HLNCLC
     C                   EVAL      D0CUTP = HLCUTP
     C                   EVAL      D0HVIN = HLHVIN
     C                   EVAL      D0SUBJ = HLSUBJ
     C                   EVAL      D0HVAM = HLHVAM
      *
      ** US TIN Filter Is Not Blanks
     C                   IF        D0UTINS <> *BLANKS
     C                   EVAL      PLenUTIN = %LEN(HLUTIN)
     C                   EVAL      PLenD0UTIN = %LEN(D0UTINS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HLUTIN
     C                   PARM                    PLenUTIN
     C                   PARM                    PStart
     C                   PARM                    D0UTINS
     C                   PARM                    PLenD0UTIN
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectUT = 'N'
     C                   EVAL      D0UTIN = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectUT = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Current FATCA Classification Code is not Blanks
     C                   IF        D0CCLCS <> *BLANKS
      *
     C                   EVAL      PLenCCLC = %LEN(HLCCLC)
     C                   EVAL      PLenD0CCLC = %LEN(D0CCLCS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HLCCLC
     C                   PARM                    PLenCCLC
     C                   PARM                    PStart
     C                   PARM                    D0CCLCS
     C                   PARM                    PLenD0CCLC
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectCC = 'N'
     C                   EVAL      D0CCLC = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectCC = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** New FATCA Classification Code is not Blanks
     C                   IF        D0NCLCS <> *BLANKS
      *
     C                   EVAL      PLenNCLC = %LEN(HLNCLC)
     C                   EVAL      PLenD0NCLC = %LEN(D0NCLCS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HLNCLC
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
     C                   EVAL      WSelectNC = 'N'
     C                   EVAL      D0NCLC = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectNC = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** FATCA Customer Type Filter Is Not Blanks
     C                   IF        D0CUTPS <> *BLANKS
     C                   EVAL      PLenCUTP = %LEN(HLCUTP)
     C                   EVAL      PLenD0CUTP = %LEN(D0CUTPS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HLCUTP
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
     C                   EVAL      PLenHVIN = %LEN(HLHVIN)
     C                   EVAL      PLenD0HVIN = %LEN(D0HVINS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HLHVIN
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
     C                   EVAL      WSelectHI = 'N'
     C                   EVAL      D0HVIN = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectHI = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Subject to Reporting Is Not Blanks
     C                   IF        D0SUBJS <> *BLANKS
     C                   EVAL      PLenSUBJ = %LEN(HLSUBJ)
     C                   EVAL      PLenD0SUBJ = %LEN(D0SUBJS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HLSUBJ
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
      ** High Value Amount Is Not Blanks
     C                   IF        D0HVAMS <> *BLANKS
     C                   EVAL      PLenHVAM = %LEN(HLHVAM)
     C                   EVAL      PLenD0HVAM = %LEN(D0HVAMS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    HLHVAM
     C                   PARM                    PLenHVAM
     C                   PARM                    PStart
     C                   PARM                    D0HVAMS
     C                   PARM                    PLenD0HVAM
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectHA = 'N'
     C                   EVAL      D0HVAM = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectHA = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write the Selected Records
     C                   IF        WSelectUT = 'Y' AND
     C                             WSelectCC = 'Y' AND
     C                             WSelectNC = 'Y' AND
     C                             WSelectCT = 'Y' AND
     C                             WSelectHI = 'Y' AND
     C                             WSelectSR = 'Y' AND
     C                             WSelectHA = 'Y'
      *
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   WRITE     SD000112S0
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
     C                   READ      SDFTHLL0
     C                   IF        %EOF(SDFTHLL0)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     SDFTHLL0
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
      *
      ** Check If Records Are Written Into Subfile
     C                   IF        WLstRrn <> 0
     C                   EVAL      SflDsp = *ON
      *
      ** Display a message that the tool has been run successfully
     C                   IF        PMode = 'U'
     C                   EVAL      PMsgId = 'USS0269'
     C                   ELSE
     C                   EVAL      PMsgId = 'USS0283'
     C                   ENDIF
     C                   EXSR      SRErrDta
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
      *  SRErrDta - Output Error Message With Data                    *
      *                                                               *
      *  Called by: SRLoadSfl                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRErrDta      BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM      D0CUST        PMsgData
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
      /EJECT
      *****************************************************************
