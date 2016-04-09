     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD IGA Country Update List')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000108 - Midas SD IGA Country Update List                  *
      *                                                               *
      *  Function:  This program display the records from the IGA     *
      *             Country Update List File                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD026626           Date 12May14               *
      *  Prev Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026626 - Database error on IGA tool report                 *
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
      ** IGA Country Update List File
     FSDFTIGL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** IGA Country Update List
     FSD000108DFCF   E             WORKSTN
     F                                     SFILE(SD000108S0:RRN0 )
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
     D WSelectCN       S              1A
     D WSelectRN       S              1A
     D WSelectRT       S              1A
     D WSelectFS       S              1A
     D WSelectCC       S              1A
     D WCtr            S              2  0
     D PMode           S              1A
     D Mode            S              1A
     D PCArr           S           1000
     D PM1ST           S              2A
     D PM1CC           S              5A
     D PM2ST           S              2A
     D PM2CC           S              5A
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D SflPag          C                   CONST(6)
      *
      ** Parameter For AOBANKR0
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Parameter For QCLSCAN
     D PStart          S              3P 0 INZ(1)
     D PLenCUST        S              3P 0
     D PLenRPNM        S              3P 0
     D PLenRPTN        S              3P 0
     D PLenFFST        S              3P 0
     D PLenCLAC        S              3P 0
     D PLenD0CUST      S              3P 0
     D PLenD0RPNM      S              3P 0
     D PLenD0RPTN      S              3P 0
     D PLenD0FFST      S              3P 0
     D PLenD0CLAC      S              3P 0
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
     D WCty            S                   LIKE(D0CNCDS)
     D WCus            S                   LIKE(D0CUSTS)
     D WRnm            S                   LIKE(D0RPNMS)
     D WRtn            S                   LIKE(D0RPTNS)
     D WFfs            S                   LIKE(D0FFSTS)
     D WNcc            S                   LIKE(D0CLACS)
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
      *
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
     C                   PARM                    PCArr
     C                   PARM                    PM1ST
     C                   PARM                    PM1CC
     C                   PARM                    PM2ST
     C                   PARM                    PM2CC
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
     C                   WRITE     SD000108F0
      *
      ** Write the Message Subfile Control Format
     C                   WRITE     SD000108C1
      *
      ** Display the Subfile
     C                   EXFMT     SD000108C0
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
     C                   IF        D0CNCDS = *BLANKS
     C                   EVAL      WCty = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0CUSTS = *BLANKS
     C                   EVAL      WCus = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0RPNMS = *BLANKS
     C                   EVAL      WRnm = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0RPTNS = *BLANKS
     C                   EVAL      WRtn = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0FFSTS = *BLANKS
     C                   EVAL      WFfs = *BLANKS
     C                   ENDIF
      *
     C                   IF        D0CLACS = *BLANKS
     C                   EVAL      WNcc = *BLANKS
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
      ** Print
     C                   WHEN      (Print = *ON) AND
     C                             (D0CNCDS = WCty) AND
     C                             (D0CUSTS = WCus) AND
     C                             (D0RPNMS = WRnm) AND
     C                             (D0RPTNS = WRtn) AND
     C                             (D0FFSTS = WFfs) AND
     C                             (D0CLACS = WNcc)
      *
     C**********         CALL      'SD000106A'                                              MD026626
     C                   CALL      'SD000160'                                               MD026626
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      'R'           Mode
     C                   PARM                    PCArr
     C                   PARM                    PM1ST
     C                   PARM                    PM1CC
     C                   PARM                    PM2ST
     C                   PARM                    PM2CC
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
     C                   WHEN      (D0CNCDS <> *BLANKS) OR
     C                             (D0CUSTS <> *BLANKS) OR
     C                             (D0RPNMS <> *BLANKS) OR
     C                             (D0RPTNS <> *BLANKS) OR
     C                             (D0FFSTS <> *BLANKS) OR
     C                             (D0CLACS <> *BLANKS)
      *
     C                   EVAL      WCty = D0CNCDS
     C                   EVAL      WCus = D0CUSTS
     C                   EVAL      WRnm = D0RPNMS
     C                   EVAL      WRtn = D0RPTNS
     C                   EVAL      WFfs = D0FFSTS
     C                   EVAL      WNcc = D0CLACS
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
     C                   EVAL      D0CNCDS = *BLANKS
     C                   EVAL      D0CUSTS = *BLANKS
     C                   EVAL      D0RPNMS = *BLANKS
     C                   EVAL      D0RPTNS = *BLANKS
     C                   EVAL      D0FFSTS = *BLANKS
     C                   EVAL      D0CLACS = *BLANKS
     C                   EVAL      WCty = *BLANKS
     C                   EVAL      WCus = *BLANKS
     C                   EVAL      WRnm = *BLANKS
     C                   EVAL      WRtn = *BLANKS
     C                   EVAL      WFfs = *BLANKS
     C                   EVAL      WNcc = *BLANKS
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
     C     *LOVAL        SETLL     SDFTIGL0
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      NoData = *OFF
     C                   EVAL      SflClr = *ON
      *
     C                   WRITE     SD000108C0
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
     C                   EVAL      WSelectCN = 'Y'
     C                   EVAL      WSelectRN = 'Y'
     C                   EVAL      WSelectRT = 'Y'
     C                   EVAL      WSelectFS = 'Y'
     C                   EVAL      WSelectCC = 'Y'
      *
      ** If Relative Record Number Of The Last Record Loaded In The
      ** Subfile Is Greater Than Zero
      *
     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
     C                   ENDIF
      *
      ** Set the Pointer To the Entered Country Code
     C                   IF        (D0CNCDS <> *BLANKS) AND
     C                             (Rollup = *OFF) AND
     C                             NOT %EOF(SDFTIGL0)
     C     D0CNCDS       SETLL     SDFTIGL0
     C                   ENDIF
      *
      ** Reset Counter
     C                   EVAL      WCtr = 0
      *
      ** Display the No Of Records That Is Specified In The SFLPAG
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(SDFTIGL0)
      *
      ** Read the FATCA Customer Type & Classification List File
     C                   READ      SDFTIGL0
      *
     C                   IF        %EOF(SDFTIGL0)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(SDFTIGL0)
     C                   EVAL      D0CNCD = IGCNCD
     C                   EVAL      D0CUST = IGCUST
     C                   EVAL      D0RPNM = IGRPNM
     C                   EVAL      D0RPTN = IGRPTN
     C                   EVAL      D0FFST = IGFFST
     C                   EVAL      D0CNNM = IGCNNM
     C                   EVAL      D0CLAC = IGCLAC
      *
      ** Customer Number Filter Is Not Blanks
     C                   IF        D0CUSTS <> *BLANKS
     C                   EVAL      PLenCUST = %LEN(IGCUST)
     C                   EVAL      PLenD0CUST = %LEN(D0CUSTS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    IGCUST
     C                   PARM                    PLenCUST
     C                   PARM                    PStart
     C                   PARM                    D0CUSTS
     C                   PARM                    PLenD0CUST
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectCN = 'N'
     C                   EVAL      D0CUST = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectCN = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Customer Report Name Filter Is Not Blanks
     C                   IF        D0RPNMS <> *BLANKS
     C                   EVAL      PLenRPNM = %LEN(IGRPNM)
     C                   EVAL      PLenD0RPNM = %LEN(D0RPNMS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    IGRPNM
     C                   PARM                    PLenRPNM
     C                   PARM                    PStart
     C                   PARM                    D0RPNMS
     C                   PARM                    PLenD0RPNM
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectRN = 'N'
     C                   EVAL      D0RPNM = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectRN = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Customer Report Town Filter is not Blanks
     C                   IF        D0RPTNS <> *BLANKS
      *
     C                   EVAL      PLenRPTN = %LEN(IGRPTN)
     C                   EVAL      PLenD0RPTN = %LEN(D0RPTNS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    IGRPTN
     C                   PARM                    PLenRPTN
     C                   PARM                    PStart
     C                   PARM                    D0RPTNS
     C                   PARM                    PLenD0RPTN
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectRT = 'N'
     C                   EVAL      D0RPTN = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectRT = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** New FFi Sub-Type Filter Is Not Blanks
     C                   IF        D0FFSTS <> *BLANKS
     C                   EVAL      PLenFFST = %LEN(IGFFST)
     C                   EVAL      PLenD0FFST = %LEN(D0FFSTS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    IGFFST
     C                   PARM                    PLenFFST
     C                   PARM                    PStart
     C                   PARM                    D0FFSTS
     C                   PARM                    PLenD0FFST
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectFS = 'N'
     C                   EVAL      D0FFST = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectFS = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** New FATCA Classification Code is Not Blanks
     C                   IF        D0CLACS <> *BLANKS
     C                   EVAL      PLenCLAC = %LEN(IGCLAC)
     C                   EVAL      PLenD0CLAC = %LEN(D0CLACS)
      *
      ** Scan Database Field With the Search Argument
     C                   CALL      'QCLSCAN'
     C                   PARM                    IGCLAC
     C                   PARM                    PLenCLAC
     C                   PARM                    PStart
     C                   PARM                    D0CLACS
     C                   PARM                    PLenD0CLAC
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present, Blank Out Screen Field
     C                   IF        PResult < 1
     C                   EVAL      WSelectCC = 'N'
     C                   EVAL      D0CLAC = *BLANKS
      *
      ** If Present Display That Record
     C                   ELSE
     C                   EVAL      WSelectCC = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write the Selected Records
     C                   IF        WSelectCN = 'Y' AND
     C                             WSelectRN = 'Y' AND
     C                             WSelectRT = 'Y' AND
     C                             WSelectFS = 'Y' AND
     C                             WSelectCC = 'Y'
      *
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   WRITE     SD000108S0
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
     C                   READ      SDFTIGL0
     C                   IF        %EOF(SDFTIGL0)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     SDFTIGL0
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
