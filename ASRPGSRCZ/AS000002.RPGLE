     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Forecast transactions')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000002 - Forecast Transactions Maintenance/Enquiry         *
      *                                                               *
      *  Function:  This module enables the user to enter, maintain,  *
      *             and enquire upon Forecast Transactions.           *
      *                                                               *
      *  Component of: AS000002                                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD027587           Date 19Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CAS010             Date 09Feb05               *
      *                 227957             Date 23Jun04               *
      *                 CGL029             Date 01Sep03               *
      *                 220004             Date 24Jul03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  MD027587 - Unable to used the C for Copy and T for Template  *
      *             (Recompile)                                       *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CAS010 - IAS + PB Enhancements Upgrade to Midasplus          *
      *  227957 - Forecast Transaction Maintenance Allow '?'          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    26         Protect Indicator                               *
      *    27         Rolldown Indicator                              *
      *    28         Unprotect Indicator for #1DESC                  *
      *    29         Maintenance Mode Indicator                      *
      *    30         Protect Selection Field Indicator               *
      *    31         SFLNXTCHG Indicator                             *
      *    32         Non - Display Indicator                         *
      *    33         Date Indicator for Enquire Mode                 *
      *    34         SFLCLR Indicator                                *
      *    35         SFLDSP Indicator                                *
      *    36         SFLEND Indicator                                *
      *    37         Selection Field Error Indicator                 *
      *    38         Status Field Reverse Image Indicator            *
      *    39         Transaction ID Error Indicator                  *
      *    40         Empty Subfile Indicator                         *
      *    41         Branch Error Indicator                          *
      *    42         Description Error Indicator                     *
      *    43         Subtype Error Indicator                         *
      *    44         Input Date Error Indicator                      *
      *    45         Maturity Date Error Indicator                   *
      *    46         Expenditure/Receipt Error Indicator             *
      *    47         Currency Error Indicator                        *
      *    48         Amount Error Indicator                          *
      *    49         Revaluation Yield Curve Error Indicator         *
      *    50         End Of File Indicator AS000002S0                *
      *    51         CHECK Indicator                                 *
      *    52         Footer for Maintenance Mode - Subfile           *
      *    53         Footer for Enquiry Mode - Subfile               *
      *    54         Footer for Detail Screen - Not Delete           *
      *    55         Footer for Detail Screen - Delete               *
      *    60         Hedge Accounting Phase B (CAS006) Indicator     *                       CAS006
      *    61         Module ID Error Indicator                       *                       CAS006
      *    62         Start Date Error Indicator                      *                       CAS006
      *    63         Underlying Ref. Number Error Indicator          *                       CAS006
      *    64         Underlying Ref. Number Unprotect Indicator      *                       CAS006
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRRefresh - Refresh Subfile                                   *
      * SRReview - Review From Field is Entered                       *
      * SRBuild - Build Non-blank Subfile                             *
      * SRValdSele - Validate Selection Fields                        *
      * SRSFMove - Move File Fields to Subfile Screen Fields          *
      * SRDtlsMove - Move Subfile Screen Fields to Detail Screen      *
      *              Fields                                           *
      * SRInsert - Insert New Record                                  *
      * SRInsTranID - Insert New Transaction ID                       *
      * SRValdTranId - Validate Transaction ID                        *
      * SRInsDetails - Insert Details                                 *
      * SRValdTranId - Validate Details                               *
      * SRWrite - Write New Record to File                            *
      * SRAction - Process Action Codes                               *
      * SRDisplay - Display Details Screen                            *
      * SRDispSF - Display Subfile Screen                             *
      * SRAmend - Amend                                               *
      * SRDelete - Delete                                             *
      * SRSDCntrl - Update Standing Data Controls                     *
      * SRSndErr- Send Error Message                                  *
      * SRRtvText - Retrieve Text From Message File                   *
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
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FAS000002DFCF   E             WORKSTN SFILE(AS000002S0:#0SFRN)
      ** Forecast Transactions Display File
 
     FASFHTRL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     RENAME(ASFHTRD0:@FHTRD0)
      ** Forecast Transaction Details Master File Update Index
 
     FASFHTRL1  IF   E           K DISK    INFSR(*PSSR)
      ** Forecast Transaction Details Master File Retrieval Index
 
     FSDFCTLL0  UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      ** Standing Data Controls Update index
 
     FSDLOANL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Midas SD Loan Type/Subtype File by Loan Type/Subtype                                 CAS006
                                                                                              CAS006
     FGLJENPL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Midas GL Journal Entry Postings File by Batch No./Item No.                           CAS006
                                                                                              CAS006
     FDEALS     IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Midas DL Deals File by Deal No.                                                      CAS006
                                                                                              CAS006
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     IGNORE(CLOANHHF)                                   CAS006
     F                                     IGNORE(CLOANCKF)                                   CAS006
     F                                     IGNORE(CLOANZ1F)                                   CAS006
      ** Midas LE Loans by Loan No.                                                           CAS006
                                                                                              CAS006
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Deal Types Array                                                                     CAS006
     D DLTYP           S              2A   DIM(22) CTDATA                                     CAS006
                                                                                              CAS006
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for Deal Subtype Details
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
 
      ** External data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for Yield Curve
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
     D                                     PREFIX(@)
 
      ** External data structure for Switchable Feature Details.                              CAS006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS006
                                                                                              CAS006
      ** Data Structure for Screen Fields
     D #1DBRC          DS           280
 
      ** Hedging ICD File
     D @1DBRC        E DS                  EXTNAME(ASFHTRL0)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Parameter to SD0520X
     D PDeleteRec      DS          3064
     D  WFileName              1     10
     D  WTransactID           11     60
     D  WDeleteR              61   3060
     D  WLstChgDate         3061   3063P 0
     D  WLstChgType         3064   3064
 
      ** Underlying Ref. Number Data Structure for GL                                         CAS006
     D UREF            DS                                                                     CAS006
     D  BatchNo                       3A                                                      CAS006
     D  ItemNo                        3A                                                      CAS006
                                                                                              CAS006
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Comparator Field to check if Numeric
     D*WNumeric        C                   '0123456789.- '                                    CAS010
     D WNumeric        C                   '0123456789TM.- '                                  CAS010
     D WDigits         C                   '0123456789'                                       CAS006
     D WPosition       S              1  0
 
      ** Work fields for subfile processing
     D WTranID         S              6  0
     D WFirst          S              1A
     D WEmpty          S              1A
     D WBuild          S              1A
     D WView           S              1A
     D WSFRRN          S              4  0
     D WSFCntr         S              2  0
     D WError          S              1A
     D WDelete         S              1A
 
      ** Input/Output Parameters
     D PRetCodeIn      S              7A
     D PMode           S              1A
     D WRun            S              1A
 
      ** Parameters for Standard Access Objects
     D PCurrency       S              3A
     D PBranch         S              3A
     D PSubtype        S              3A
     D PYield          S              5A
     D PRtCd           S              7A
     D POption         S              7A
     D PSARD           S              6A                                                      CAS006
 
      ** Work Fields for SDBANKPD fields
     D WRunDay         S              5  0
     D WSetUp          S              1A
 
      ** Other Working Variables                                                              CAS006
     D WDTYP           S              2A                                                      CAS006
     D WIdx            S              2P 0                                                    CAS006
                                                                                              CAS006
      ** Fields used for standard programs
     D PDateFormat     S              1A
     D PError          S              1A
     D PInputDate      S              5  0
     D PMatDate        S              5  0
     D PFInput         S              5  0
     D PNInput         S              6  0
     D PDate           S              6
     D PAInput         S              7A
     D PNMaturity      S              6  0
     D PAMaturity      S              7A
     D PNStrtDate      S              6  0                                                    CAS006
     D PAStrtDate      S              7A                                                      CAS006
     D PStrtDate       S              5P 0                                                    CAS006
     D PDecPlace       S              1  0
     D WDecPlace       S              1  0
     D WField          S             16A
     D PField          S             16A
     D PDecimals       S              1  0
     D PChkFld         S             16A
     D PDigits         S              2  0
     D PFldOut         S             16A
 
      ** Switchable Feature Identifiers                                                       CAS006
     D CAS006          S              1A   INZ('N')                                           CAS006
                                                                                              CAS006
      ** Database Key Fields                                                                  CAS006
     D KLNTY           S              2A                                                      CAS006
     D KBTNB           S              3A                                                      CAS006
     D KBINB           S              3P 0                                                    CAS006
     D KDLNO           S              6S 0                                                    CAS006
     D***KLNRF**         S              6S 0                                           CAS006 CLE148
     D KLNRF           S              6A                                                      CLE148
                                                                                              CAS006
      ** Fields used to update SDFCTLL0
     D WNumRec         S              5  0
     D WNumIns         S              5  0
     D WNumAmd         S              5  0
     D WNumDel         S              5  0
 
      ** Fields used for Message Files
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgID          S             10A
     D PMsgText        S             80A
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *****************************************************************
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active
 
     C                   EVAL      *IN34 = *ON
     C                   WRITE     AS000002C0
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *ON
 
      ** Initialise subfile relative record number
 
     C                   Z-ADD     0             WSFRRN
 
      ** Do While not F3
 
     C                   DOU       *INKC = *ON
 
     C                   IF        WBuild = *BLANK
     C                   READ      ASFHTRL1
 
     C                   IF        %EOF(ASFHTRL1) AND WFirst = 'Y'
     C                   EVAL      WEmpty = 'Y'
     C                   ELSE
     C                   EVAL      WFirst = 'N'
     C                   EVAL      WEmpty = 'N'
     C                   ENDIF
 
     C                   Z-ADD     0             WSFCntr
 
      **  Build Subfile
 
     C                   IF        %EOF(ASFHTRL1)
 
      ** Send 'No Details to Display' Error Message
 
     C                   EVAL      PMsgId = 'ASM0001'
     C                   EXSR      SRSndErr
 
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN30 = *ON
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN36 = *ON
     C                   EVAL      WBuild = 'N'
     C                   Z-ADD     1             WSFCntr
 
     C                   ELSE
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN30 = *OFF
     C                   EXSR      SRBuild
     C                   ENDIF
 
     C                   ENDIF
 
     C     WSFCntr       IFGT      0
     C                   EXSR      SRDispSF
     C                   ELSE
     C                   ITER
     C                   ENDIF
 
      **  If Rollup is not done and F3 is not pressed
 
     C                   IF        *IN27 = *OFF AND *INKC = *OFF
 
     C                   SELECT
 
      ** If F5 is pressed
 
     C                   WHEN      *INKE = *ON
     C                   EXSR      SRRefresh
 
      ** If F9 is pressed
 
     C                   WHEN      *INKI = *ON AND PMode <> 'E'
     C                   EXSR      SRInsert
 
      ** If Position On field is not blank and save variable is not the same
      ** as the value entered.
 
     C                   WHEN      #0RTRI <> *ZEROS AND
     C                             #0RTRI <> WTranId
     C                   EXSR      SRReview
 
      ** If Position On field is the same as the save variable
 
     C                   WHEN      #0RTRI = WTranId AND
     C                             WEmpty = 'N'
     C                   EVAL      WBuild = 'N'
     C                   EXSR      SRValdSele
 
     C                   WHEN      #0RTRI = *ZEROS AND
     C                             #0RTRI <> WTranId AND
     C                             WEmpty = 'N'
     C                   EXSR      SRRefresh
 
     C                   ENDSL
 
     C                   ELSE
 
      **  If Rollup, Build Subfile
 
     C                   EVAL      WBuild = *BLANKS
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRefresh - Refresh Subfile                                  *
      *                                                               *
      *  Called by: Main Processing, SRValdSele                       *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRRefresh     BEGSR
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active
 
     C                   EVAL      *IN34 = *ON
     C                   WRITE     AS000002C0
     C                   EVAL      *IN34 = *OFF
 
     C                   Z-ADD     0             WSFRRN
 
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      #0SELE = *BLANK
     C                   EVAL      #0RTRI = *ZEROS
     C                   EVAL      WBuild = *BLANK
     C                   EVAL      WTranId = *ZEROS
 
     C     *LOVAL        SETLL     ASFHTRL1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReview - Review From Field is Entered                      *
      *                                                               *
      *  Called by: Main Processing, SRValdSele                       *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRReview      BEGSR
 
      **  Move #0RTRI to save variable
 
     C                   EVAL      WTranId = #0RTRI
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active
 
     C                   EVAL      *IN34 = *ON
     C                   WRITE     AS000002C0
     C                   EVAL      *IN34 = *OFF
 
     C                   Z-ADD     0             WSFRRN
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      #0SELE = *BLANK
     C                   EVAL      WBuild = *BLANK
 
     C     WTranId       SETLL     ASFHTRL1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBuild - Build Non-blank Subfile                            *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : SRSFMove                                          *
      *                                                               *
      *****************************************************************
 
     C     SRBuild       BEGSR
 
 
      ** Do while not End of File
 
     C                   DOW       NOT %EOF(ASFHTRL1) AND WSFCntr < 14
 
      ** Move File Fields to Subfile Screen Fields
 
     C                   EXSR      SRSFMove
 
     C                   ADD       1             WSFCntr
     C                   ADD       1             WSFRRN
     C                   Z-ADD     WSFRRN        #0SFRN
 
     C                   WRITE     AS000002S0
 
     C                   IF        WSFCntr <= 14
     C                   READ      ASFHTRL1
     C                   ENDIF
 
     C                   IF        %EOF(ASFHTRL1)
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN27 = *OFF
     C                   ENDIF
 
     C                   IF        NOT %EOF(ASFHTRL1) AND WSFCntr = 14
     C     FSTRID        SETLL     ASFHTRL1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValdSele - Validate Selection Fields                       *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : SRSndErr, SRAction, SRDispSF, SRRefresh, SRInsert *
      *             SRReview                                          *
      *                                                               *
      *****************************************************************
 
     C     SRValdSele    BEGSR
 
      ** Read Subfile
 
     C                   READC     AS000002S0                             50
 
      **  Do while F3 is not pressed, roll-up key is not
      **  pressed and not End of File
 
     C                   DOW       *INKC = *OFF AND
     C                             *IN27 = *OFF AND
     C                             *IN50 = *OFF
 
     C                   EVAL      WError = 'N'
 
      ** Validate selection field while not End of File
 
     C                   DOW       *IN50 = *OFF
 
     C                   IF        PMode= 'M' AND
     C                             #0SELE <> 'E' AND
     C                             #0SELE <> 'A' AND
     C                             #0SELE <> 'D' AND
     C                             #0SELE <> *BLANK
     C                   EVAL      *IN37 = *ON
     C                   EVAL      PMsgId = 'ASM0002'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        PMode= 'E' AND
     C                             #0SELE <> 'E' AND
     C                             #0SELE <> *BLANK
     C                   EVAL      *IN37 = *ON
     C                   EVAL      PMsgId = 'ASM0011'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #0SELE = 'A' AND PMode = 'M'
     C                             AND #0STAT <> *BLANKS OR
     C                             #0SELE = 'D' AND PMode = 'M'
     C                             AND WSetUp = 'N'
     C                             AND #0STAT <> *BLANKS
     C                   EVAL      *IN37 = *ON
     C                   EVAL      PMsgId = 'ASM0014'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #0SELE = 'D' AND PMode = 'M'
     C                             AND WSetUp <> 'N'
     C                   EVAL      *IN37 = *ON
     C                   EVAL      PMsgId = 'ASM0019'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #0STAT <> *BLANKS
     C                   EVAL      *IN38 = *ON
     C                   ELSE
     C                   EVAL      *IN38 = *OFF
     C                   ENDIF
 
     C                   EVAL      *IN31 = *ON
     C                   UPDATE    AS000002S0
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   READC     AS000002S0                             50
 
     C                   ENDDO
 
      ** If no errors are found, call Display Detail Screen
 
     C     WError        IFEQ      'N'
 
     C                   EVAL      *IN50 = *OFF
 
     C                   DOW       *IN50 = *OFF AND *INKC = *OFF AND
     C                             *INKL = *OFF
 
     C                   READC     AS000002S0                             50
 
     C                   IF        #0SELE <> *BLANK AND
     C                             *IN50 = *OFF
 
     C                   EXSR      SRAction
 
     C                   IF        FSRECI <> 'D'
     C                   EVAL      *IN38 = *ON
     C                   EXSR      SRSFMove
     C                   ELSE
     C                   EVAL      *IN38 = *OFF
     C                   ENDIF
 
     C                   EVAL      #0SELE = *BLANK
     C                   EVAL      *IN31 = *ON
     C                   UPDATE    AS000002S0
     C                   EVAL      *IN31 = *OFF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
      ** Display screen if there is an error message, if F12 is pressed
      ** from Detail Screen or if there are no more records selected
      ** to process
 
     C                   IF        WError = 'Y' AND *INKC = *OFF OR
     C                             *INKL = *ON OR
     C                             *IN50 = *ON AND
     C                             #0RTRI = WTranId AND *INKC = *OFF
 
     C                   IF        %EOF(ASFHTRL1)
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN27 = *OFF
     C                   ENDIF
 
     C                   EXSR      SRDispSF
 
     C                   EVAL      *IN37 = *OFF
 
     C                   SELECT
 
      ** If F5 is pressed
 
     C                   WHEN      *INKE = *ON
     C                   EXSR      SRRefresh
     C                   LEAVE
 
      ** If F9 is pressed
 
     C                   WHEN      *INKI = *ON AND PMode <> 'E'
     C                   EXSR      SRInsert
     C                   LEAVE
 
      ** If Position On field is not blank and save variable is not the same
      ** as the value entered
 
     C                   WHEN      *INKC <> *ON AND #0RTRI <> *ZEROS
     C                             AND #0RTRI <> WTranId
     C                   EVAL      WView = 'Y'
     C                   EXSR      SRReview
     C                   LEAVE
 
      ** If Rollup is Pressed
 
     C                   WHEN      *IN27 = *ON
     C                   EVAL      WBuild = *BLANKS
     C                   LEAVE
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   READC     AS000002S0                             50
 
     C                   ENDDO
 
     ** When Position on Field is Blank
 
     C                   IF        WView = *BLANK AND #0RTRI = *ZEROS
     C                             AND *IN27 = *OFF
     C                   EXSR      SRRefresh
     C                   ENDIF
 
     C                   EVAL      WView = *BLANK
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSFMove - Move File Fields to Screen Fields                 *
      *                                                               *
      *  Called by: SRBuild                                           *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRSFMove      BEGSR
 
      ** Selection Field, Record ID, Transaction ID, Description, Branch,
      ** Subtype, Expenditure/Receipt, Currency, Yield Curve, Last Change
      ** Type and Last Change Date
 
     C                   EVAL      #0SELE = *BLANKS
     C                   EVAL      #0TRID = FSTRID
     C                   EVAL      #0SUBT = FSSUBT
     C                   EVAL      #0ERIN = FSERIN
     C                   EVAL      #0CCY = FSCCY
 
      ** Currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POption
     C                   PARM      FSCCY         PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd = *Blanks
     C                   Z-ADD     A6NBDP        WDecPlace
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = FSCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Input Date
 
     C                   CALL      'ZDATE2'
     C                   PARM      FSINDT        PFInput
     C                   PARM                    PDateFormat
     C                   PARM      *ZEROS        PNInput
     C                   PARM      *BLANKS       PAInput
 
     C                   EVAL      #0INDT = PAInput
 
      ** Maturity Date
 
     C                   CALL      'ZDATE2'
     C                   PARM      FSMDAT        PFInput
     C                   PARM                    PDateFormat
     C                   PARM      *ZEROS        PNMaturity
     C                   PARM      *BLANKS       PAMaturity
 
     C                   EVAL      #0MDAT = PAMaturity
 
      ** Transaction Amount
 
     C                   IF        FSAMNT <> *ZEROS
     C                   EVAL      WField = *BLANKS
     C                   MOVE      FSAMNT        WField
     C                   CALL      'ZEDIT'
     C     WField        PARM      WField        PField
     C                   PARM      WDecPlace     PDecPlace
 
     C                   MOVE      WField        #0AMNT
     C                   ENDIF
 
      ** Status
 
     C                   SELECT
 
     C                   WHEN      FSRECI = 'D'
     C                   EVAL      #0STAT = *BLANKS
 
     C                   WHEN      FSRECI = '*'
     C                   EVAL      PMsgID = 'ASM0023'
 
     C**********         WHEN      FSRECI = 'E'                                               CAS006
     C                   WHEN      FSRECI = 'E' AND                                           CAS006
     C                             CAS006 = 'N'                                               CAS006
     C                   EVAL      PMsgID = 'ASM0029'
 
     C                   WHEN      FSRECI = 'M'
     C                   EVAL      PMsgID = 'ASM0030'
 
     C**********         WHEN      FSRECI = 'X'                                               CAS006
     C                   WHEN      FSRECI = 'X' AND                                           CAS006
     C                             CAS006 = 'N'                                               CAS006
     C                   EVAL      PMsgID = 'ASM0031'
 
     C                   WHEN      FSRECI = 'T'
     C                   EVAL      PMsgID = 'ASM0003'
 
     C                   ENDSL
 
     C**********         IF        FSRECI <> 'D'                                              CAS006
     C                   IF        FSRECI <> 'D' AND                                          CAS006
     C                             CAS006 = 'N'  OR                                           CAS006
     C                             FSRECI <> 'D' AND                                          CAS006
     C                             FSRECI <> 'E' AND                                          CAS006
     C                             FSRECI <> 'X' AND                                          CAS006
     C                             CAS006 = 'Y'                                               CAS006
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0STAT = PMsgText
     C                   EVAL      *IN38 = *ON
     C                   ELSE
     C                   EVAL      *IN38 = *OFF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDtlsMove - Move Subfile Screen Fields to Detail Screen     *
      *               Fields                                          *
      *                                                               *
      *  Called by: SRAction                                          *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRDtlsMove    BEGSR
 
     C     #0TRID        CHAIN     ASFHTRL0
 
     C                   EVAL      #1TRID = FSTRID
     C                   EVAL      #1BRCA = FSBRCA
     C                   EVAL      #1DESC = FSDESC
     C                   EVAL      #1SUBT = FSSUBT
 
      ** Input Date
 
     C                   CALL      'ZDATE2'
     C                   PARM      FSINDT        PFInput
     C                   PARM                    PDateFormat
     C                   PARM      *ZEROS        PNInput
     C                   PARM      *BLANKS       PAInput
     C**********         EVAL      #1INDT = PNInput                                           CAS006
     C                   MOVE      PNInput       #1INDT                                       CAS006
     C                   EVAL      #1INDA = PAInput
 
      ** Maturity Date
 
     C                   CALL      'ZDATE2'
     C                   PARM      FSMDAT        PFInput
     C                   PARM                    PDateFormat
     C                   PARM      *ZEROS        PNMaturity
     C                   PARM      *BLANKS       PAMaturity
     C**********         EVAL      #1MDAT = PNMaturity                                        CAS006
     C                   MOVE      PNMaturity    #1MDAT                                       CAS006
     C                   EVAL      #1MDAA = PAMaturity
 
     C                   EVAL      #1ERIN = FSERIN
 
      ** Currency
 
     C                   EVAL      #1CCY = FSCCY
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POption
     C                   PARM      FSCCY         PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd = *Blanks
     C                   Z-ADD     A6NBDP        WDecPlace
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = FSCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Transaction Amount
 
     C                   EVAL      WField = *BLANKS
     C                   MOVE      FSAMNT        WField
     C                   CALL      'ZEDIT'
     C     WField        PARM      WField        PField
     C                   PARM      WDecPlace     PDecPlace
     C                   MOVE      WField        #1AMNT
 
     C                   IF        CAS006 = 'N'                                               CAS006
     C                   EVAL      #1YLDC = FSYLDC
     C                   ENDIF                                                                CAS006
     C                   EVAL      #1DBRC = @1DBRC
                                                                                              CAS006
      ** Set the Module ID, Start Date, and Underlying Ref. Number                            CAS006
      ** screen fields if CAS006 is enabled.                                                  CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
     C                   EVAL      #1MOID = *BLANKS                                           CAS006
     C                   EVAL      #1SDAT = *BLANKS                                           CAS006
     C                   EVAL      #1SDAA = *BLANKS                                           CAS006
     C                   EVAL      #1UREF = *BLANKS                                           CAS006
                                                                                              CAS006
     C                   EVAL      #1MOID = FSMOD                                             CAS006
                                                                                              CAS006
     C                   CALL      'ZDATE2'                                                   CAS006
     C                   PARM      FSSDAT        PFInput                                      CAS006
     C                   PARM                    PDateFormat                                  CAS006
     C                   PARM      *ZERO         PNStrtDate                                   CAS006
     C                   PARM      *BLANKS       PAStrtDate                                   CAS006
                                                                                              CAS006
     C                   MOVE      PNStrtDate    #1SDAT                                       CAS006
     C                   EVAL      #1SDAA = PAStrtDate                                        CAS006
                                                                                              CAS006
     C**********         IF        FSUREF <> *ZERO                                     CAS006 CLE148
     C                   IF        FSUREF <> *BLANKS                                          CLE148
     C                   MOVE      FSUREF        #1UREF                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   UNLOCK    ASFHTRL0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert - Insert New Record                                 *
      *                                                               *
      *  Called by: Main Processing, SRValdSele                       *
      *                                                               *
      *  Calls    : SRInsTranID, SRValdTranID, SRInsDetails, SRWrite  *
      *             SRRefresh                                         *
      *                                                               *
      *****************************************************************
 
     C     SRInsert      BEGSR
 
      ** Insert Transaction ID
 
     C                   EXSR      SRInsTranID
 
     C                   EVAL      WError = 'Y'
 
     C                   DOU       *INKC = *ON OR WError = 'N'
 
     C                   EVAL      WError = 'N'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      *IN53 = *OFF
     C                   EVAL      *IN54 = *ON
     C                   EVAL      *IN55 = *OFF
 
     C                   WRITE     AS000002F0
     C                   WRITE     AS000002F2
     C                   WRITE     AS000002C1
     C                   EXFMT     AS000002F1
 
     C                   CALL      'ZA0250'
     C                   EVAL      *IN39 = *OFF
 
     C                   IF        *INKL = *ON
     C                   EVAL      WError = 'N'
     C                   EVAL      *IN54 = *OFF
     C                   ENDIF
 
     C                   IF        *INKC = *OFF AND *INKL = *OFF
     C                   EXSR      SRValdTranId
     C                   ELSE
     C                   EVAL      *IN32 = *OFF
     C                   ENDIF
      ** Insert Details
 
     C                   IF        *INKC = *OFF AND *INKL = *OFF
     C                             AND WError = 'N'
     C                   EXSR      SRInsDetails
     C                   ENDIF
 
      ** Move Screen Fields to File Fields and Write new record
 
     C                   IF        *INKC = *OFF AND *INKL = *OFF
     C                             AND WError = 'N'
     C                   EXSR      SRWrite
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EXSR      SRRefresh
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsTranID - Insert New Transaction ID                      *
      *                                                               *
      *  Called by: SRInsert                                          *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRInsTranID   BEGSR
 
      ** Initialize Transaction ID
 
     C     *HIVAL        SETGT     ASFHTRL1
     C                   READP     ASFHTRL1
 
     C                   IF        %EOF(ASFHTRL1)
     C                   Z-ADD     1             WTranId
     C                   ELSE
     C     FSTRID        ADD       1             WTranId
     C                   ENDIF
 
     C                   EVAL      #1TRID =  WTranId
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValdTranId - Validate Transaction ID field                 *
      *                                                               *
      *  Called by: SRInsert                                          *
      *                                                               *
      *  Calls    : SRInsTranId, SRSndErr                             *
      *                                                               *
      *****************************************************************
 
     C     SRValdTranId  BEGSR
 
     C                   IF        #1TRID = *ZEROS
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRInsTranID
     C                   ELSE
 
      ** If Insert, check if Transaction Id already exists
 
     C     #1TRID        CHAIN     ASFHTRL1
     C                   IF        %FOUND(ASFHTRL1)
     C                   EVAL      *IN39 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0004'
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsDetails - Insert Details                                *
      *                                                               *
      *  Called by: SRInsert                                          *
      *                                                               *
      *  Calls    : SRValdDetails                                     *
      *                                                               *
      *****************************************************************
 
     C     SRInsDetails  BEGSR
 
      ** Display Detail Screen
 
     C                   EVAL      WError = 'Y'
     C                   EVAL      #1DESC = *BLANKS
     C                   EVAL      #1BRCA = *BLANKS
     C                   EVAL      #1SUBT = *BLANKS
     C**********         EVAL      #1INDT = *ZEROS                                            CAS006
     C                   EVAL      #1INDT = *BLANKS                                           CAS006
     C**********         EVAL      #1MDAT = *ZEROS                                            CAS006
     C                   EVAL      #1MDAT = *BLANKS                                           CAS006
     C                   EVAL      #1ERIN = *BLANKS
     C                   EVAL      #1CCY = *BLANKS
     C                   EVAL      #1AMNT = *BLANKS
                                                                                              CAS006
     C                   IF        CAS006 = 'N'                                               CAS006
     C                   EVAL      #1YLDC = *BLANKS
     C                   ENDIF                                                                CAS006
 
      ** Clear the Module ID, Start Date, and Underlying Ref. Number                          CAS006
      ** screen fields if CAS006 is enabled.                                                  CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      #1MOID = *BLANKS                                           CAS006
     C                   EVAL      #1SDAT = *BLANKS                                           CAS006
     C                   EVAL      #1UREF = *BLANKS                                           CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   DOU       *INKC = *ON OR *INKL = *ON
     C                             OR WError = 'N'
 
     C                   EVAL      WError = 'N'
     C                   EVAL      *IN32 = *OFF
 
     C                   WRITE     AS000002F0
     C                   WRITE     AS000002F2
     C                   WRITE     AS000002C1
     C                   EXFMT     AS000002F1
 
     C                   CALL      'ZA0250'
     C                   MOVEA     '000000000'   *IN(41)
                                                                                              CAS006
      ** Set the Module ID, Start Date, and Underlying Ref. Number                            CAS006
      ** Error Indicators to *OFF.                                                            CAS006
                                                                                              CAS006
     C                   EVAL      *IN61 = *OFF                                               CAS006
     C                   EVAL      *IN62 = *OFF                                               CAS006
     C                   EVAL      *IN63 = *OFF                                               CAS006
 
     C                   IF        *INKL = *ON
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   IF        *INKC = *OFF AND *INKL = *OFF
     C                   EXSR      SRValdDetails
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValdDetails - Validate Details                             *
      *                                                               *
      *  Called by: SRInsDetails                                      *
      *                                                               *
      *  Calls    : SRSndErr                                          *
      *                                                               *
      *****************************************************************
 
     C     SRValdDetails BEGSR
 
      ** Validate Branch Details
 
     C                   IF        #1BRCA = *BLANKS
     C                   EVAL      *IN41 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0005'
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POption
     C                   PARM      #1BRCA        PBranch
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      *IN41 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0006'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      #1BRCA = A8BRCD
     C                   ENDIF
     C                   ENDIF
                                                                                              CAS006
      ** Validate the Module ID if CAS006 is enabled.                                         CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EXSR      SRVModID                                                   CAS006
     C                   ENDIF                                                                CAS006
 
      ** Validate Description
 
     C                   IF        #1DESC = *BLANKS
     C                   EVAL      *IN42 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0007'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate Transaction Subtype Details
 
      ** Use the alternate Transaction Subtype validation subroutine                          CAS006
      ** if CAS006 is enabled.                                                                CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EXSR      SRVTrnSbTyp                                                CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        #1SUBT = *BLANKS
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0008'
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POption
     C                   PARM      #1SUBT        PSubtype
     C     SDDLST        PARM      SDDLST        DSFDY
     C
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0009'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      #1SUBT = ASDSTC
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Validate Input Date
 
     C**********         IF        #1INDT = *ZEROS                                            CAS006
     C                   IF        #1INDT = *BLANKS                                           CAS006
     C                   EVAL      *IN44 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0010'
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C                   MOVE      #1INDT        PDate
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM                    PInputDate
     C                   PARM                    PDateFormat
     C                   PARM      *BLANKS       PError
 
     C                   IF        PError = 'Y'
     C                   EVAL      *IN44 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0010'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        PInputDate > WRunDay
     C                   EVAL      *IN44 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0012'
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                              CAS006
      ** Validate the Start Date if CAS006 is enabled.                                        CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EXSR      SRVStrtDate                                                CAS006
     C                   ENDIF                                                                CAS006
 
      ** Validate Maturity Date
 
     C**********         IF        #1MDAT = *ZEROS                                            CAS006
     C                   IF        #1MDAT = *BLANKS                                           CAS006
     C                   EVAL      *IN45 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0013'
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C                   MOVE      #1MDAT        PDate
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM                    PMatDate
     C                   PARM                    PDateFormat
     C                   PARM      *BLANKS       PError
 
     C                   IF        PError = 'Y'
     C                   EVAL      *IN45 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0013'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        PMatDate <= WRunDay
     C                   EVAL      *IN45 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0015'
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Expenditure/Receipt
 
     C                   IF        #1ERIN = *BLANKS
     C                   EVAL      *IN46 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0016'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        #1ERIN <> 'E' AND #1ERIN <> 'R'
     C                   EVAL      *IN46 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0017'
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Currency
 
     C                   IF        #1CCY = *BLANKS
     C                   EVAL      WDecPlace = *ZEROS
     C                   EVAL      *IN47 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0018'
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POption
     C                   PARM      #1CCY         PCurrency
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
     C
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      *IN47 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0018'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   Z-ADD     A6NBDP        WDecPlace
     C                   EVAL      #1CCY = A6CYCD
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Transaction Amount
 
     C                   IF        #1AMNT = *BLANKS OR #1AMNT = *ALL'0'
     C                   EVAL      *IN48 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0020'
     C                   EXSR      SRSndErr
     C                   ELSE
 
      ** Not Numeric
 
     C     WNumeric      CHECK     #1AMNT        WPosition
     C                   IF        WPosition <> *ZEROS
     C                   EVAL      *IN48 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0032'
     C                   EXSR      SRSndErr
     C                   ELSE
 
      ** Negative Amount
 
     C     '-'           SCAN      #1AMNT                                 51
     C                   IF        *IN51 = *ON
     C                   EVAL      *IN48 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0021'
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WField = #1AMNT
     C     11            SUB       WDecPlace     PDigits
 
      ** Align Screen Field
 
     C                   CALL      'ZALIGN'
     C                   PARM                    PRtCd
     C     WField        PARM      WField        PChkFld
     C                   PARM      WDecPlace     PDecPlace
     C                   PARM                    PDigits
     C                   PARM                    PFldOut
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      *IN48 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0022'
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C                   CALL      'ZEDIT'
     C     WField        PARM      WField        PField
     C                   PARM      WDecPlace     PDecPlace
 
     C                   EVAL      #1AMNT = *BLANKS
     C                   MOVE      WField        #1AMNT
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                              CAS006
     C                   IF        CAS006 = 'N'                                               CAS006
 
      ** Validate Yield Curve
 
     C                   IF        #1YLDC = *BLANKS
     C                   EVAL      *IN49 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0024'
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POption
     C                   PARM      #1YLDC        PYield
     C     SDYLDC        PARM      SDYLDC        DSFDY
     C
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      *IN49 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0024'
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EVAL      #1YLDC = @FSYLDC
     C                   ENDIF
     C                   ENDIF
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
 
      ** Validate the Underlying Ref. Number if CAS006 is enabled.                            CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EXSR      SRVUndRefNo                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write New Record                                   *
      *                                                               *
      *  Called by: SRInsert                                          *
      *                                                               *
      *  Calls    : SRSndErr, SRSDCntrl                               *
      *                                                               *
      *****************************************************************
 
     C     SRWrite       BEGSR
 
     C                   EVAL      FSRECI = 'D'
     C                   EVAL      FSTRID = #1TRID
     C                   EVAL      FSDESC = #1DESC
     C                   EVAL      FSBRCA = #1BRCA
     C                   EVAL      FSSUBT = #1SUBT
     C                   EVAL      FSINDT = PInputDate
     C                   EVAL      FSMDAT = PMatDate
     C                   EVAL      FSERIN = #1ERIN
     C                   EVAL      FSCCY = #1CCY
     C                   MOVE      PFldOut       FSAMNT
                                                                                              CAS006
     C                   IF        CAS006 = 'N'                                               CAS006
     C                   EVAL      FSYLDC = #1YLDC
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      FSCHTP = 'I'
     C                   EVAL      FSLCD = WRunDay
     C                   EVAL      FSURPL = *ZERO                                             CAS006
     C                   EVAL      FSYUPL = *ZERO                                             CAS006
     C                   EVAL      FSEFUP = *ZERO                                             CAS006
     C                   EVAL      FSECUP = *ZERO                                             CAS006
                                                                                              CAS006
      ** Set the Module ID, Start Date, and Underlying Ref. Number                            CAS006
      ** file fields if CAS006 is enabled.                                                    CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
     C                   EVAL      FSMOD = #1MOID                                             CAS006
     C                   EVAL      FSSDAT = PStrtDate                                         CAS006
                                                                                              CAS006
     C                   IF        #1MOID = 'DL' OR                                           CAS006
     C                             #1MOID = 'LE'                                              CAS006
     C                   MOVE      #1UREF        FSUREF                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      UREF          FSUREF                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      FSMOD = *BLANKS                                            CAS006
     C                   EVAL      FSSDAT = *ZERO                                             CAS006
     C**********         EVAL      FSUREF = *ZERO                                      CAS006 CLE148
     C                   EVAL      FSUREF = *BLANKS                                           CLE148
     C                   ENDIF                                                                CAS006
 
      ** Check for Duplicate Primary Key
 
     C     FSTRID        CHAIN     ASFHTRL0
     C                   IF        %FOUND(ASFHTRL0)
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0004'
     C                   EXSR      SRSndErr
 
     C                   ELSE
     C                   WRITE     @FHTRD0
 
      ** Change Standing Data Controls
 
     C                   Z-ADD     1             WNumRec
     C                   Z-ADD     1             WNumIns
     C                   Z-ADD     *ZERO         WNumDel
     C                   Z-ADD     *ZERO         WNumAmd
 
     C                   EXSR      SRSDCntrl
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAction - Process Action Codes                              *
      *                                                               *
      *  Called by: SRValdSele                                        *
      *                                                               *
      *  Calls    : SRDtlsMove, SRDisplay, SRAmend, SRDelete          *
      *                                                               *
      *****************************************************************
 
     C     SRAction      BEGSR
 
 
     C                   EXSR      SRDtlsMove
 
     C                   MOVEA     '0000'        *IN(52)
 
     C                   SELECT
 
      ** Enquire
 
     C                   WHEN      #0SELE = 'E'
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN54 = *ON
     C                   EVAL      *IN64 = *OFF                                               CAS006
     C                   EXSR      SRDisplay
 
      ** Amend
 
     C                   WHEN      #0SELE = 'A' AND PMode = 'M'
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN54 = *ON
     C                   EVAL      *IN64 = *ON                                                CAS006
     C                   EXSR      SRDisplay
     C                   EXSR      SRAmend
 
      ** Delete
 
     C                   WHEN      #0SELE = 'D' AND PMode = 'M'
     C                             AND WSetUp = 'N'
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN28 = *OFF
     c                   EVAL      *IN55 = *ON
     C                   EVAL      *IN64 = *OFF                                               CAS006
     C                   EXSR      SRDelete
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Detail Screen                            *
      *                                                               *
      *  Called by: SRAction                                          *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
      ** Display Screen
 
     C                   WRITE     AS000002F0
     C                   WRITE     AS000002F2
     C                   WRITE     AS000002C1
     C                   EXFMT     AS000002F1
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN54 = *OFF
     C                   EVAL      *IN55 = *OFF
     C                   EVAL      *IN63 = *OFF                                               CAS006
     C                   EVAL      *IN64 = *OFF                                               CAS006
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDispSF - Display Subfile Screen                            *
      *                                                               *
      *  Called by: Main Processing, SRValdSele                       *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRDispSF      BEGSR
 
      ** Condition Footer
 
     C                   IF        WEmpty = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ELSE
     C                   EVAL      *IN40 = *OFF
     C                   ENDIF
 
     C                   IF        PMode = 'E'
     C                   EVAL      *IN53 = *ON
     C                   ELSE
     C                   EVAL      *IN52 = *ON
     C                   ENDIF
 
     ** Display Subfile
 
     C                   WRITE     AS000002F0
     C                   WRITE     AS000002F2
     C                   WRITE     AS000002C1
     C                   EXFMT     AS000002C0
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
     C                   EVAL      *IN36 = *OFF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend - Amend                                              *
      *                                                               *
      *  Called by: SRAction                                          *
      *                                                               *
      *  Calls    : SRDisplay, SRSndErr, SRSDCntrl                    *
      *                                                               *
      *****************************************************************
 
     C     SRAmend       BEGSR
 
     C                   EVAL      WError = 'Y'
 
     C                   DOU       *INKC = *ON OR *INKL = *ON OR
     C                             WError = 'N'
 
     C                   EVAL      WError = 'N'
 
 
     C                   IF        #1DESC = *BLANKS
     C                   EVAL      *IN42 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0007'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate the Underlying Ref. Number if CAS006 is enabled.                            CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EXSR      SRVUndRefNo                                                CAS006
     C                   ENDIF                                                                CAS006
 
     C                   IF        *INKC = *OFF AND *INKL = *OFF AND
     C                             WError = 'N'
 
     C     #1TRID        CHAIN     ASFHTRL0
     C                   IF        %FOUND(ASFHTRL0)
 
     C                   IF        #1DBRC <> @1DBRC
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0025'
     C                   EXSR      SRSndErr
     C                   UNLOCK    ASFHTRL0
 
     C                   ELSE
 
     C                   EVAL      FSDESC = #1DESC
     C                   MOVE      #1UREF        FSUREF                                       CAS006
     C                   EVAL      FSCHTP = 'A'
     C                   EVAL      FSLCD = WRunDay
     C                   UPDATE    @FHTRD0
     C                   EVAL      #1DBRC = @1DBRC
 
     C                   Z-ADD     *ZERO         WNumRec
     C                   Z-ADD     *ZERO         WNumIns
     C                   Z-ADD     *ZERO         WNumDel
     C                   Z-ADD     1             WNumAmd
     C                   EXSR      SRSDCntrl
     C                   COMMIT
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0026'
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WError = 'Y'
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN54 = *ON
     C                   EVAL      *IN64 = *ON                                                CAS006
     C                   EXSR      SRDisplay
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelete - Delete                                            *
      *                                                               *
      *  Called by: SRAction                                          *
      *                                                               *
      *  Calls    : SRDisplay, SRSndErr, SRSDCntrl                    *
      *                                                               *
      *****************************************************************
 
     C     SRDelete      BEGSR
 
     C                   EVAL      WError = 'Y'
 
     C                   DOU       *INKC = *ON OR *INKL = *ON OR
     C                             *INKJ = *ON OR WError = 'N'
 
     C                   EVAL      WError = 'N'
 
     C                   EXSR      SRDisplay
 
     C                   SELECT
 
     C                   WHEN      *INKC = *ON
     C                   EVAL      WError = 'N'
 
     C                   WHEN      *INKL = *ON
     C                   EVAL      PMsgId = 'ASM0027'
     C                   EXSR      SRSndErr
 
     C                   WHEN      *INKC = *OFF AND *INKC = *OFF
     C                             AND *INKJ = *OFF
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN28 = *OFF
     c                   EVAL      *IN55 = *ON
     C                   EVAL      *IN64 = *OFF                                               CAS006
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0028'
     C                   EXSR      SRSndErr
 
     C                   WHEN      *INKJ = *ON
 
     C     #1TRID        CHAIN     ASFHTRL0
     C                   IF        %FOUND(ASFHTRL0)
 
     C                   IF        #1DBRC <> @1DBRC
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0025'
     C                   EXSR      SRSndErr
     C                   UNLOCK    ASFHTRL0
 
     C                   ELSE
 
     C                   EVAL      FSRECI = '*'
     C                   EVAL      FSCHTP = 'D'
     C                   EVAL      FSLCD = WRunDay
     C                   UPDATE    @FHTRD0
     C                   EVAL      #1DBRC = @1DBRC
     C                   EVAL      PMsgID = 'ASM0023'
     C                   EXSR      SRRtvTxt
     C                   EVAL      #0STAT = PMsgText
 
     C                   Z-ADD     *ZERO         WNumRec
     C                   Z-ADD     *ZERO         WNumIns
     C                   Z-ADD     1             WNumDel
     C                   Z-ADD     *ZERO         WNumAmd
     C                   EXSR      SRSDCntrl
 
     C                   EVAL      WDelete = 'Y'
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgId = 'ASM0026'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        WDelete = 'Y'
 
     C                   CLEAR                   PDeleteRec
 
     C                   EVAL      WFileName = 'ASFHTRPD'
     C                   MOVEL     #1TRID        WTransactID
     C                   EVAL      WDeleteR = @1DBRC
     C                   Z-ADD     FSLCD         WLstChgDate
     C                   EVAL      WLstChgType = 'D'
 
     C                   CALL      'SD0520X'
     C                   PARM                    PRtCd
     C                   PARM                    PDeleteRec
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*CALL'
     C                   EVAL      DBFILE = 'SD0520X'
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSDCntrl - Update Standing Data Controls                    *
      *                                                               *
      *  Called by: SRWrite, SRAmend, SRDelete                        *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRSDCntrl     BEGSR
 
      ** Move key fields to @AHREAU
 
     C                   EVAL      AHFLNM = *BLANKS
     C                   EVAL      AHFLNM = 'ASFHTRPD'
 
     C     AHFLNM        CHAIN     SDFCTLL0
 
     C                   IF        NOT %FOUND(SDFCTLL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'ASFHTRPD'
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
      ** Update SDFCTLPD
 
     C     WNumRec       ADD       AHNORC        AHNORC
     C     WNumIns       ADD       AHNOIN        AHNOIN
     C     WNumAmd       ADD       AHNOAM        AHNOAM
     C     WNumDel       ADD       AHNODL        AHNODL
 
     C                   UPDATE    @AHREAU
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErr - Send Error Message                                *
      *                                                               *
      *  Called by: Main Processing, SRValdSele, SRValdTranId         *
      *             SRValdDetails, SRWrite, SRAmend, SRDelete         *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRSndErr      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgID
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTxt - Retrieve a message from message file               *
      *                                                               *
      * Called by: SRDelete, SRSFMove                                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRRtvTxt      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMsgId
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgText
 
     C                   ENDSR
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRVModID - Validates the Module ID.                          *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRVModID      BEGSR                                                                CAS006
                                                                                              CAS006
      ** Module ID must be entered.                                                           CAS006
                                                                                              CAS006
     C                   IF        #1MOID = *BLANKS                                           CAS006
     C                   EVAL      *IN61 = *ON                                                CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      PMsgId = 'ASM0127'                                         CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Module ID must be 'DL', 'LE', or 'GL'.                                               CAS006
                                                                                              CAS006
     C                   IF        #1MOID <> 'DL' AND                                         CAS006
     C                             #1MOID <> 'LE' AND                                         CAS006
     C                             #1MOID <> 'GL'                                             CAS006
     C                   EVAL      *IN61 = *ON                                                CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      PMsgId = 'ASM0128'                                         CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRVTrnSbTyp - Validates the Transaction Subtype.             *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRVTrnSbTyp   BEGSR                                                                CAS006
                                                                                              CAS006
      ** Transaction Subtype must be entered.                                                 CAS006
                                                                                              CAS006
     C                   IF        #1SUBT = *BLANKS                                           CAS006
     C                   EVAL      *IN43 = *ON                                                CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      PMsgId = 'ASM0129'                                         CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Begin Module ID Selection                                                            CAS006
      ** =========================                                                            CAS006
                                                                                              CAS006
     C                   SELECT                                                               CAS006
                                                                                              CAS006
      ** Trans. Subtype must be a valid Deal Type if Mod. ID = 'DL'.                          CAS006
                                                                                              CAS006
     C                   WHEN      #1MOID = 'DL'                                              CAS006
                                                                                              CAS006
     C                   EVAL      WDTYP = #1SUBT                                             CAS006
                                                                                              CAS006
     C                   EVAL      WIdx = %LOOKUP(WDTYP : DLTYP)                              CAS006
                                                                                              CAS006
     C                   IF        WIdx = *ZERO                                               CAS006
     C                   EVAL      *IN43 = *ON                                                CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      PMsgId = 'ASM0130'                                         CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Trans. Subtype must be a valid Loan Type if Mod. ID = 'LE'.                          CAS006
                                                                                              CAS006
     C                   WHEN      #1MOID = 'LE'                                              CAS006
                                                                                              CAS006
     C                   EVAL      KLNTY = #1SUBT                                             CAS006
                                                                                              CAS006
     C     KLNTY         CHAIN     SDLOANL1                                                   CAS006
                                                                                              CAS006
     C                   IF        NOT %FOUND(SDLOANL1)                                       CAS006
     C                   EVAL      *IN43 = *ON                                                CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      PMsgId = 'ASM0131'                                         CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Trans. Subtype must be a valid Deal Subtype if Mod. ID = 'GL'.                       CAS006
                                                                                              CAS006
     C                   WHEN      #1MOID = 'GL'                                              CAS006
                                                                                              CAS006
     C                   EVAL      PSubtype = #1SUBT                                          CAS006
                                                                                              CAS006
      ** Access Deal Subtype Details.                                                         CAS006
                                                                                              CAS006
     C                   CALL      'AODLSTR0'                                                 CAS006
     C                   PARM      *BLANKS       PRtCd                                        CAS006
     C                   PARM      '*KEY   '     POption                                      CAS006
     C                   PARM                    PSubtype                                     CAS006
     C     SDDLST        PARM      SDDLST        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRtCd <> *BLANKS AND                                       CAS006
     C                             PRtCd <> '*NRF'                                            CAS006
     C                             AND PRtCd <> '*NOSEL'                                      227957
     C                   EVAL      DBFile = 'SDDLSTPD'                                        CAS006
     C                   EVAL      DBKey  = PSubtype                                          CAS006
     C                   EVAL      DBase  = 7                                                 CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRtCd = '*NRF'                                             CAS006
     C                             OR ASDSTC = *BLANKS                                        227957
     C                   EVAL      *IN43 = *ON                                                CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      PMsgId = 'ASM0132'                                         CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   ELSE                                                                 227957
     C                   EVAL      #1SUBT = ASDSTC                                            227957
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
      ** End Module ID Selection                                                              CAS006
      ** =======================                                                              CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRVStrtDate - Validates the Start Date.                      *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRVStrtDate   BEGSR                                                                CAS006
                                                                                              CAS006
     C                   MOVE      #1SDAT        PDate                                        CAS006
                                                                                              CAS006
     C                   CALLB     'ZDATE1'                                                   CAS006
     C                   PARM                    PDate                                        CAS006
     C                   PARM                    PStrtDate                                    CAS006
     C                   PARM                    PDateFormat                                  CAS006
     C                   PARM      *BLANKS       PError                                       CAS006
                                                                                              CAS006
      ** Start Date must be a valid numerical date.                                           CAS006
                                                                                              CAS006
     C                   IF        PError = 'Y'                                               CAS006
     C                   EVAL      *IN62 = *ON                                                CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      PMsgId = 'ASM0040'                                         CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Start Date must be >= to the system Run Day.                                         CAS006
                                                                                              CAS006
     C                   IF        PStrtDate < WRunDay                                        CAS006
     C                   EVAL      *IN62 = *ON                                                CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      PMsgId = 'ASM0041'                                         CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRVUndRefNo - Validates the Underlying Reference Number.     *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRVUndRefNo   BEGSR                                                                CAS006
                                                                                              CAS006
     C                   IF        #1UREF <> *BLANKS                                          CAS006
                                                                                              CAS006
      ** Separate the Batch No. and Item No. if Module ID = 'GL'.                             CAS006
                                                                                              CAS006
     C                   IF        #1MOID = 'GL'                                              CAS006
     C                   EVAL      UREF = #1UREF                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** The Underlying Ref. Number must be a valid numerical value.                          CAS006
                                                                                              CAS006
     C                   EVAL      WPosition = %CHECK(WDigits :                               CAS006
     C                             #1UREF)                                                    CAS006
                                                                                              CAS006
     C                   IF        WPosition <> *ZERO                                         CAS006
     C                   EVAL      *IN63 = *ON                                                CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      PMsgId = 'ASM0133'                                         CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Begin Module ID Selection                                                            CAS006
      ** =========================                                                            CAS006
                                                                                              CAS006
     C                   SELECT                                                               CAS006
                                                                                              CAS006
      ** The Underlying Reference Number must be a live and valid Deal                        CAS006
      ** Number if Mod. ID = 'DL'. Moreover, the Transaction Subtype                          CAS006
      ** and the Deal Type must match.                                                        CAS006
                                                                                              CAS006
     C                   WHEN      #1MOID = 'DL'                                              CAS006
                                                                                              CAS006
     C                   MOVE      #1UREF        KDLNO                                        CAS006
     C     KDLNO         CHAIN     DEALS                                                      CAS006
                                                                                              CAS006
     C                   IF        NOT %FOUND(DEALS) OR                                       CAS006
     C                             (%FOUND(DEALS) AND RECI <> 'D') OR                         CAS006
     C                             (%FOUND(DEALS) AND DTYP <> #1SUBT)                         CAS006
     C                   EVAL      *IN63 = *ON                                                CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      PMsgId = 'ASM0134'                                         CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** The Underlying Reference Number must be a live and valid Loan                        CAS006
      ** Number if Mod. ID = 'LE'. Moreover, the Transaction Subtype                          CAS006
      ** and the Loan Type must match.                                                        CAS006
                                                                                              CAS006
     C                   WHEN      #1MOID = 'LE'                                              CAS006
                                                                                              CAS006
     C                   MOVE      #1UREF        KLNRF                                        CAS006
     C     KLNRF         CHAIN     CLOAN                                                      CAS006
                                                                                              CAS006
     C                   IF        NOT %FOUND(CLOAN) OR                                       CAS006
     C                             (%FOUND(CLOAN) AND RECI <> 'D') OR                         CAS006
     C                             (%FOUND(CLOAN) AND LTYP <> #1SUBT)                         CAS006
     C                   EVAL      *IN63 = *ON                                                CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      PMsgId = 'ASM0135'                                         CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** The Underlying Reference Number must be a valid Batch No. and                        CAS006
      ** Item No. pair if Mod. ID = 'GL'.                                                     CAS006
                                                                                              CAS006
     C                   WHEN      #1MOID = 'GL'                                              CAS006
                                                                                              CAS006
     C                   EVAL      KBTNB = BatchNo                                            CAS006
     C                   MOVE      ItemNo        KBINB                                        CAS006
     C     KJENP         CHAIN     GLJENPL1                                                   CAS006
                                                                                              CAS006
     C                   IF        NOT %FOUND(GLJENPL1)                                       CAS006
     C                   EVAL      *IN63 = *ON                                                CAS006
     C                   EVAL      WError = 'Y'                                               CAS006
     C                   EVAL      PMsgId = 'ASM0136'                                         CAS006
     C                   EXSR      SRSndErr                                                   CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
      ** End Module ID Selection                                                              CAS006
      ** =======================                                                              CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PRetCodeIn
     C                   PARM                    PMode
 
      ** Midas GL Journal Entry Postings File Key                                             CAS006
                                                                                              CAS006
     C     KJENP         KLIST                                                                CAS006
     C                   KFLD                    KBTNB                                        CAS006
     C                   KFLD                    KBINB                                        CAS006
                                                                                              CAS006
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRtCd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS006
      ** Check if CAS006 is enabled.                                                          CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRtCd                                        CAS006
     C                   PARM      '*VERIFY'     POption                                      CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRtCd = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   EVAL      *IN60 = *ON                                                CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        PRtCd <> '*NRF'                                            CAS006
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKey  = 'CAS006'                                          CAS006
     C                   EVAL      DBase  = 6                                                 CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
 
      ** Move Workstation ID to screen field
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #1PGMQ = PSProcMod
 
     C                   EVAL      PDateFormat = BJDFIN
     C                   EVAL      WRunDay = BJRDNB
     C                   EVAL      WSetUp = BJSUC
 
      ** Initialise Work Fields
 
     C                   EVAL      WError = 'Y'
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WBuild = *BLANKS
     C                   EVAL      WTranID = *ZEROS
     C                   EVAL      WNumRec = *ZEROS
     C                   EVAL      WNumIns = *ZEROS
     C                   EVAL      WNumDel = *ZEROS
     C                   EVAL      WNumAMd = *ZEROS
 
      ** Initialise screen fields, indicators and function key
 
     C                   EVAL      #0RTRI = *ZEROS
     C                   EVAL      #0SELE = *BLANKS
     C                   EVAL      #0TRID = *ZEROS
     C                   EVAL      #0SUBT = *BLANKS
     C                   EVAL      #0CCY = *BLANKS
     C                   EVAL      #0ERIN = *BLANKS
     C                   EVAL      #0AMNT = *BLANKS
     C                   EVAL      #0INDT = *BLANKS
     C                   EVAL      #0MDAT = *BLANKS
     C                   EVAL      #0STAT = *BLANKS
     C                   EVAL      WFirst = 'Y'
     C                   EVAL      WEmpty = *BLANK
 
      ** Initialise Indicators
 
     C                   MOVEA     '00000'       *IN(26)
     C                   MOVEA     '000000000'   *IN(37)
     C                   MOVEA     '0000000000'  *IN(46)
 
     C                   IF        PMode = 'E'
     C                   EVAL      *IN26 = *ON
     C                   ELSE
     C                   EVAL      *IN29 = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
** CTDATA DLTYP - Deal Types.                                                                 CAS006
IT                                                                                            CAS006
IP                                                                                            CAS006
TD                                                                                            CAS006
TI                                                                                            CAS006
CI                                                                                            CAS006
LN                                                                                            CAS006
CD                                                                                            CAS006
CL                                                                                            CAS006
DL                                                                                            CAS006
C1                                                                                            CAS006
C2                                                                                            CAS006
BP                                                                                            CAS006
BD                                                                                            CAS006
TB                                                                                            CAS006
DA                                                                                            CAS006
TA                                                                                            CAS006
FL                                                                                            CAS006
FT                                                                                            CAS006
DP                                                                                            CAS006
DT                                                                                            CAS006
LP                                                                                            CAS006
LT                                                                                            CAS006
