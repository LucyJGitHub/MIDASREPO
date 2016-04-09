     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA Cust Type & Classification List')       *
      *****************************************************************
      *  Includes MD025438                                            *
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000107 - Midas SD FATCA Customer Type & Classification     *
      *             Allocation List                                   *
      *                                                               *
      *  Function:  This program display the records from the FATCA   *
      *             Customer Type & Classification List File          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD027298           Date 06Aug14               *
      *  Prev Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027298 - Incorrect label 'Exempt' (Recompile)              *
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
      ** FATCA Customer Type & Classification List File
     FSDFTCLL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** FATCA Customer Type & Classification List
     FSD000107DFCF   E             WORKSTN
     F                                     SFILE(SD000107S0:RRN0 )
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
     D WSelectLI       S              1A
     D WSelectLN       S              1A
     D WSelectCT       S              1A
     D WSelectST       S              1A
     D WSelectCC       S              1A
     D WSelectIC       S              1A
     D WSelectEX       S              1A
     D WCtr            S              2  0
     D PMode           S              1A
     D Mode            S              1A
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D SflPag          C                   CONST(12)
      *
      ** Parameter For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenLINC        S              3P 0
     D PLenLINM        S              3P 0
     D PLenCUTP        S              3P 0
     D PLenCSTY        S              3P 0
     D PLenCLCD        S              3P 0
     D PLenINFO        S              3P 0
     D PLenEXMT        S              3P 0
     D PLenD0LINC      S              3P 0
     D PLenD0LINM      S              3P 0
     D PLenD0CUTP      S              3P 0
     D PLenD0CSTY      S              3P 0
     D PLenD0CLCD      S              3P 0
     D PLenD0INFO      S              3P 0
     D PLenD0EXMT      S              3P 0
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
     D WLic            S                   LIKE(D0LINCS)
     D WLin            S                   LIKE(D0LINMS)
     D WFct            S                   LIKE(D0CUTPS)
     D WFcs            S                   LIKE(D0CSTYS)
     D WFcc            S                   LIKE(D0CLCDS)
     D WFic            S                   LIKE(D0INFOS)
     D WFex            S                   LIKE(D0EXMTS)
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
     C                   WRITE     SD000107F0
      *
      ** Write the Message Subfile Control Format
     C                   WRITE     SD000107C1
      *
      ** Display the Subfile
     C                   EXFMT     SD000107C0
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
     C                   IF        D0LINCS = *BLANKS
     C                   EVAL      WLic = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0LINMS = *BLANKS
     C                   EVAL      WLin = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0CUTPS = *BLANKS
     C                   EVAL      WFct = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0CSTYS = *BLANKS
     C                   EVAL      WFcs = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0CLCDS = *BLANKS
     C                   EVAL      WFcc = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0INFOS = *BLANKS
     C                   EVAL      WFic = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0EXMTS = *BLANKS
     C                   EVAL      WFex = *BLANKS
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
     C                             (D0LINCS = WLic) AND
     C                             (D0LINMS = WLin) AND
     C                             (D0CUTPS = WFct) AND
     C                             (D0CSTYS = WFcs) AND
     C                             (D0CLCDS = WFcc) AND
     C                             (D0INFOS = WFic) AND
     C                             (D0EXMTS = WFex)
      *
      ** Print
     C                   CALL      'SD000104'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      'R'           Mode
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
     C                             (D0LINCS <> *BLANKS) OR
     C                             (D0LINMS <> *BLANKS) OR
     C                             (D0CUTPS <> *BLANKS) OR
     C                             (D0CSTYS <> *BLANKS) OR
     C                             (D0CLCDS <> *BLANKS) OR
     C                             (D0INFOS <> *BLANKS) OR
     C                             (D0EXMTS <> *BLANKS)
      *
     C                   EVAL      WCus = D0CUSTS
     C                   EVAL      WLic = D0LINCS
     C                   EVAL      WLin = D0LINMS
     C                   EVAL      WFct = D0CUTPS
     C                   EVAL      WFcs = D0CSTYS
     C                   EVAL      WFcc = D0CLCDS
     C                   EVAL      WFic = D0INFOS
     C                   EVAL      WFex = D0EXMTS
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
     C                   EVAL      D0LINCS = *BLANKS
     C                   EVAL      D0LINMS = *BLANKS
     C                   EVAL      D0CUTPS = *BLANKS
     C                   EVAL      D0CSTYS = *BLANKS
     C                   EVAL      D0CLCDS = *BLANKS
     C                   EVAL      D0INFOS = *BLANKS
     C                   EVAL      D0EXMTS = *BLANKS
     C                   EVAL      WCus = *BLANKS
     C                   EVAL      WLic = *BLANKS
     C                   EVAL      WLin = *BLANKS
     C                   EVAL      WFct = *BLANKS
     C                   EVAL      WFcs = *BLANKS
     C                   EVAL      WFcc = *BLANKS
     C                   EVAL      WFic = *BLANKS
     C                   EVAL      WFex = *BLANKS
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
     C     *LOVAL        SETLL     SDFTCLL0
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      NoData = *OFF
     C                   EVAL      SflClr = *ON
      *
     C                   WRITE     SD000107C0
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
     C                   EVAL      WSelectLI = 'Y'
     C                   EVAL      WSelectLN = 'Y'
     C                   EVAL      WSelectCT = 'Y'
     C                   EVAL      WSelectST = 'Y'
     C                   EVAL      WSelectCC = 'Y'
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
      ** Set the Pointer To the Entered Customer Number
     C                   IF        (D0CUSTS <> *BLANKS) AND
     C                             (Rollup = *OFF) AND
     C                             NOT %EOF(SDFTCLL0)
     C     D0CUSTS       SETLL     SDFTCLL0
     C                   ENDIF
      *
      ** Reset Counter
     C                   EVAL      WCtr = 0
      *
      ** Display the No Of Records That Is Specified In The SFLPAG
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(SDFTCLL0)
      *
      ** Read the FATCA Customer Type & Classification List File
     C                   READ      SDFTCLL0
      *
     C                   IF        %EOF(SDFTCLL0)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(SDFTCLL0)
     C                   EVAL      D0CUST = FLCUST
     C                   EVAL      D0LINC = FLLINC
     C                   EVAL      D0CUTP = FLCUTP
     C                   EVAL      D0CSTY = FLCSTY
     C                   EVAL      D0CLCD = FLCLCD
     C                   EVAL      D0INFO = FLINFO
     C                   EVAL      D0LINM = FLLINM
     C                   EVAL      D0EXMT = FLEXMT
      *
      ** Local Institution Code Filter Is Not Blanks
     C                   IF        D0LINCS <> *BLANKS
     C                   EVAL      PLenLINC = %LEN(FLLINC)
     C                   EVAL      PLenD0LINC = %LEN(D0LINCS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    FLLINC
     C                   PARM                    PLenLINC
     C                   PARM                    PStart
     C                   PARM                    D0LINCS
     C                   PARM                    PLenD0LINC
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectLI = 'N'
     C                   EVAL      D0LINC = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectLI = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Local Institution Name Filter Is Not Blanks
     C                   IF        D0LINMS <> *BLANKS
     C                   EVAL      PLenLINM = %LEN(FLLINM)
     C                   EVAL      PLenD0LINM = %LEN(D0LINMS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    FLLINM
     C                   PARM                    PLenLINM
     C                   PARM                    PStart
     C                   PARM                    D0LINMS
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
      ** FATCA Customer Type Filter Is Not Blanks
     C                   IF        D0CUTPS <> *BLANKS
     C                   EVAL      PLenCUTP = %LEN(FLCUTP)
     C                   EVAL      PLenD0CUTP = %LEN(D0CUTPS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    FLCUTP
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
      ** FATCA Customer Sub-Type is not Blanks
     C                   IF        D0CSTYS <> *BLANKS
      *
     C                   EVAL      PLenCSTY = %LEN(FLCSTY)
     C                   EVAL      PLenD0CSTY = %LEN(D0CSTYS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    FLCSTY
     C                   PARM                    PLenCSTY
     C                   PARM                    PStart
     C                   PARM                    D0CSTYS
     C                   PARM                    PLenD0CSTY
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectST = 'N'
     C                   EVAL      D0CSTY = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectST = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** FATCA Classification Code is not Blanks
     C                   IF        D0CLCDS <> *BLANKS
      *
     C                   EVAL      PLenCLCD = %LEN(FLCLCD)
     C                   EVAL      PLenD0CLCD = %LEN(D0CLCDS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    FLCLCD
     C                   PARM                    PLenCLCD
     C                   PARM                    PStart
     C                   PARM                    D0CLCDS
     C                   PARM                    PLenD0CLCD
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectCC = 'N'
     C                   EVAL      D0CLCD = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectCC = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** FATCA Information Complete Filter Is Not Blanks
     C                   IF        D0INFOS <> *BLANKS
     C                   EVAL      PLenINFO = %LEN(FLINFO)
     C                   EVAL      PLenD0INFO = %LEN(D0INFOS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    FLINFO
     C                   PARM                    PLenINFO
     C                   PARM                    PStart
     C                   PARM                    D0INFOS
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
      ** Exempt Filter Is Not Blanks
     C                   IF        D0EXMTS <> *BLANKS
     C                   EVAL      PLenEXMT = %LEN(FLEXMT)
     C                   EVAL      PLenD0EXMT = %LEN(D0EXMTS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    FLEXMT
     C                   PARM                    PLenEXMT
     C                   PARM                    PStart
     C                   PARM                    D0EXMTS
     C                   PARM                    PLenD0EXMT
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectEX = 'N'
     C                   EVAL      D0EXMT = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectEX = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write the Selected Records
     C                   IF        WSelectLI = 'Y' AND
     C                             WSelectLN = 'Y' AND
     C                             WSelectCT = 'Y' AND
     C                             WSelectST = 'Y' AND
     C                             WSelectCC = 'Y' AND
     C                             WSelectIC = 'Y' AND
     C                             WSelectEX = 'Y'
      *
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   WRITE     SD000107S0
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
     C                   READ      SDFTCLL0
     C                   IF        %EOF(SDFTCLL0)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     SDFTCLL0
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
