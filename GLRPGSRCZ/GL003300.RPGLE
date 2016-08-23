     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Acc. Transfer Gen A/Cs to be Transfered')     *
      *****************************************************************
      *                                                               *
      *  Midas   -  General Ledger Module                             *
      *                                                               *
      *  GL003300 - Midas GL ATU Generate Accounts to be Transferred  *
      *                                                               *
      *  Function:  This program generates the accounts to be         *
      *             transfered and outputs these to the Accounts      *
      *             Transferd Selected file.                          *
      *             Two reports are produced to show successful and   *
      *             and failed accounts generations.                  *
      *                                                               *
      *  Called by: GLC003200                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      *  Prev Amend No. BUG27769           Date 09Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CGL114  *CREATE    Date 04Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG27769 - Incorrect error code                              *
      *  CGL114 - Account Transfer Utility                            *
      *                                                               *
      *****************************************************************
      *  Use of indicators.                                           *
      *                                                               *
      *  01 - 19      Input Control.                                  *
      *  20 - 29      I/O Conditioning (ie. CHAIN, LOKUP etc...)      *
      *   20          Record Not Found                                *
      *   21          File Error Occurred                             *
      *   22          Start/End Of File Reached                       *
      *   25          Lookup/Scan.                                    *
      *  30 - 39      Program Work Indicators                         *
      *  40 - 49      Output Control.                                 *
      *  50 - 89      Output Conditioning (ie. Cursor Positioning)    *
      *  90 - 99      Error Control.                                  *
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FGLACCSJ0  IP   E           K DISK    INFSR(*PSSR)
 
     FGLACRFPD  UF   E           K DISK    INFSR(*PSSR)
 
     FGLSLACPD  O  A E           K DISK    INFSR(*PSSR)
 
     FGLSLACL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLSLACD0:GLSLAC3)
 
     FGL003300P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     OFLIND(*IN81)
 
     FGL003300P2O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL2)
     F                                     OFLIND(*IN82)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Access Object Data Feedback.
 
      ** Second DS for Access Programs, long data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Access Object Data Feedback.
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Definition: Bank Details accessed via access program.
 
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
 
      ** Definition: Account Details accessed via access program.
 
      ** File Information Data Structure for GL003300P1
 
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for GL003300P2
 
     D SPOOL2          DS
     D   SFILE2               83     92
     D   SFNUM2              123    124B 0
     D   OFLLN2              188    189B 0
     D   PRTLN2              367    368B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D MKI@@           S             80
     D WKP1OP          S              1
     D WKP2OP          S              1
     D WKNOA1          S              9  0
     D WKNOA2          S              9  0
     D WKDFMT          S              9
     D WKYEAR          S              2  0
     D WKCCYY          S              4  0
 
      ** Entry Parameters
 
     D P@REFN          S             10
     D P@RTCD          S              2
 
      ** Access Object Parameters
 
     D @RTCD           S              7
     D @OPTN           S              7
     D @RETL           S             10
     D @CNUM           S              6
     D @CUCD           S              3
     D @ACCD           S             10
     D @ACSQ           S              2
     D @BRCA           S              3
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      SrPSACCS
 
     CLR                 EXSR      SrPLRTTL
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPSACCS - Process Account and Customer Details              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SrPSACCS      BEGSR
 
     C                   MOVEL     'CR'          WKSLST
 
      ** Set Selected Accounts File Details
 
     C                   EXSR      SrXSSLAC
 
      ** Validate if the 'To Account' has already been selected.
 
     C                   EVAL      KCUSN = SLTCNU
     C                   EVAL      KCCY = SLCCY
     C                   EVAL      KACOD = SLTACO
     C                   EVAL      KACSQ = SLTACS
     C                   EVAL      KBRCA = SLTBRC
 
     C     KSLAC3        SETLL     GLSLACL3                             2122
 
     C                   IF        *IN21 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'GLSLACL3'
     C                   EVAL      DBKEY  =  'To a/c'
     C                   EVAL      DBASE  =  020
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        *IN22 = *ON
     C                   EVAL      WKACST = 'PC'
     C                   EVAL      WKSLST = 'DU'
     C                   ENDIF
 
      ** Validate if the 'To Account' exist
      ** Retrieve Account Details.
 
     C                   CALL      'AOACCTR0'                           21
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM                    @RETL
     C                   PARM      SLTCNU        @CNUM
     C                   PARM      SLCCY         @CUCD
     C                   PARM      SLTACO        @ACCD
     C                   PARM      SLTACS        @ACSQ
     C                   PARM      SLTBRC        @BRCA
     C     SDACCT        PARM      SDACCT        DSSDY
 
     C                   IF        *IN21 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'ACCNTAB'
     C                   EVAL      DBKEY  =  SDACCT
     C                   EVAL      DBASE  =  010
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      WKACST = 'PC'
     C                   EVAL      WKSLST = 'FA'
     C                   ENDIF
 
      ** Write to Selected Accounts File
 
     C                   EVAL      SLSTAT = WKSLST
     C                   WRITE     GLSLACD0                             21
 
     C                   IF        *IN21 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'GLSLACPD'
     C                   EVAL      DBKEY  =  'WRITE'
     C                   EVAL      DBASE  =  030
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Produce Reports
 
     C                   IF        WKSLST = 'CR'
     C                   EXSR      SrXWP1
     C                   ELSE
     C                   EXSR      SrXWP2
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrXSSLAC - Set field for output to GLSLACPD - Selected       *
      *              Accounts                                         *
      *                                                               *
      *  Called By: SrPSACCS                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrXSSLAC      BEGSR
 
     C                   CLEAR                   GLSLACD0
     C                   EVAL      SLRFNO = P@REFN
     C                   EVAL      SLSTAT = WKSLST
     C                   EVAL      SLCRTD = WKDFMT
     C                   EVAL      SLDESC = ACDESC
     C                   EVAL      SLFBRC = BRCA
     C                   EVAL      SLFCNU = BBCUST
     C                   MOVEL     ACOD          SLFACO
     C                   MOVEL     ACSQ          SLFACS
     C                   EVAL      SLCCY = CCY
     C                   MOVEL     ACNO          SLACNO
     C                   EVAL      SLACOC = BBACOC
     C                   EVAL      SLATYP = ATYP
     C                   EVAL      SLCOLC = BBCNCZ
 
     C                   IF        ACTBRC = *BLANKS
     C                   EVAL      SLTBRC = BRCA
     C                   ELSE
     C                   EVAL      SLTBRC = ACTBRC
     C                   ENDIF
 
     C                   IF        ACTCNU = *BLANKS
     C                   EVAL      SLTCNU = BBCUST
     C                   ELSE
     C                   EVAL      SLTCNU = ACTCNU
     C                   ENDIF
 
     C                   IF        ACTACO = *BLANKS
     C                   MOVEL     ACOD          SLTACO
     C                   ELSE
     C                   EVAL      SLTACO = ACTACO
     C                   ENDIF
 
     C                   IF        ACTACS = *BLANKS
     C                   MOVE      ACSQ          SLTACS
     C                   ELSE
     C                   EVAL      SLTACS = ACTACS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrXWP1 - Write details of all successful to report P1        *
      *                                                               *
      *  Called By: SrPSACCS                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrXWP1        BEGSR
 
     C                   EVAL      P1RFNO = P@REFN
     C                   EVAL      P1FCNU = BBCUST
     C                   EVAL      P1FCCY = CCY
     C                   MOVEL     ACOD          P1FACO
     C                   MOVEL     ACSQ          P1FACS
     C                   EVAL      P1FBRC = BRCA
     C                   MOVEL     ACNO          P1ACNO
     C                   EVAL      P1ACOC = BBACOC
     C                   EVAL      P1ATYP = ATYP
     C                   EVAL      P1COLC = BBCNCZ
     C                   EVAL      P1TBRC = SLTBRC
     C                   EVAL      P1TCCY = CCY
     C                   EVAL      P1TCNU = SLTCNU
     C                   EVAL      P1TACO = SLTACO
     C                   EVAL      P1TACS = SLTACS
     C                   EVAL      P1STAT = WKSLST
 
      ** Print Detail Lines.
 
     C                   IF        *IN81 = *ON
     C                   EVAL      *IN81 = *OFF
     C                   WRITE     HEADP1                               21
     C                   EVAL      WKP1OP = 'Y'
     C                   Endif
 
     C                   EVAL      WKNOA1 = WKNOA1 + 1
 
     C                   WRITE     DETAILP1                             21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrXWP2 - Write details of all successful to report P2.       *
      *                                                               *
      *  Called By: SrPSACCS                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrXWP2        BEGSR
 
     C                   EVAL      P2RFNO = P@REFN
     C                   EVAL      P2FCNU = BBCUST
     C                   EVAL      P2FCCY = CCY
     C                   MOVEL     ACOD          P2FACO
     C                   MOVEL     ACSQ          P2FACS
     C                   EVAL      P2FBRC = BRCA
     C                   MOVEL     ACNO          P2ACNO
     C                   EVAL      P2ACOC = BBACOC
     C                   EVAL      P2ATYP = ATYP
     C                   EVAL      P2COLC = BBCNCZ
     C                   EVAL      P2TBRC = SLTBRC
     C                   EVAL      P2TCCY = CCY
     C                   EVAL      P2TCNU = SLTCNU
     C                   EVAL      P2TACO = SLTACO
     C                   EVAL      P2TACS = SLTACS
     C                   EVAL      P2STAT = WKSLST
 
      ** Print Detail Lines.
 
     C                   IF        *IN82 = *ON
     C                   EVAL      *IN82 = *OFF
     C                   WRITE     HEADP2                               21
     C                   EVAL      WKP2OP = 'Y'
     C                   ENDIF
 
     C                   EVAL      WKNOA2 = WKNOA2 + 1
 
     C                   WRITE     DETAILP2                             21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrXRACRF - Retreive from Account Transfer Criteria           *
      *                                                               *
      *  Called By: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrXRACRF      BEGSR
 
      ** Retreive Account Transfer Criteria Details.
 
     C                   EVAL      KREFN = P@REFN
     C     KREF          CHAIN     GLACRFPD                           2021
 
     C                   IF        NOT %FOUND(GLACRFPD) OR
     C                             *IN21 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 040
     C                   EVAL      DBFILE = 'GLACRFPD'
     C                   EVAL      DBKEY = P@REFN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPLRTTL - Last Record Total Time.                           *
      *                                                               *
      *  Called By: PSACRF                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrPLRTTL      BEGSR
 
      ** If printer if P1 open write End of Report.
 
     C                   EVAL      P1NOAC = WKNOA1
     C                   EVAL      P2NOAC = WKNOA2
 
     C                   IF        WKP1OP = 'Y'
     C                   IF        OFLLN1 - PRTLN1 <= 5
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     TRAILP1
     C                   ENDIF
 
      ** If printer if P2 open write End of Report.
 
     C                   IF        WKP2OP = 'Y'
     C                   IF        OFLLN2 - PRTLN2 <= 5
     C                   WRITE     HEADP2
     C                   ENDIF
     C                   WRITE     TRAILP2
     C                   ENDIF
 
      ** Set Status on the Accounts Criteria file..
 
     C                   EVAL      ACSTAT = WKACST
 
     C                   UPDATE    GLACRFD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR -  Initialise and define fields                       *
      *                                                               *
      *  Called By: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    P@REFN
     C                   PARM                    P@RTCD
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
 
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
      ** Initialise parameters, work fields, etc.
 
     C                   EVAL      WKACST = 'CR'
 
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      PRTLN1 = 0
     C                   EVAL      PRTLN2 = 0
 
     C                   EVAL      WKP1OP = 'N'
     C                   EVAL      WKP2OP = 'N'
     C                   EVAL      WKNOA1 = *ZERO
     C                   EVAL      WKNOA2 = *ZERO
 
     C     KREF          KLIST
     C                   KFLD                    KREFN
 
     C     KSLAC3        KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCUSN
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
 
     C     *LIKE         DEFINE    ACRFNO        KREFN
 
     C     *LIKE         DEFINE    SLFBRC        KBRCA
     C     *LIKE         DEFINE    SLFCNU        KCUSN
     C     *LIKE         DEFINE    SLCCY         KCCY
     C     *LIKE         DEFINE    SLFACO        KACOD
     C     *LIKE         DEFINE    SLFACS        KACSQ
 
     C     *LIKE         DEFINE    ACSTAT        WKACST
     C     *LIKE         DEFINE    SLSTAT        WKSLST
 
      ** Clear & Populate Local dataarea with program name.
 
     C     *LOCK         IN        LDA
     C                   CLEAR                   LDA
     C                   OUT       LDA
 
      ** Retrieve Run Date.
 
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      *BLANKS       DSFDY
 
      ** If return with an error (LR seton in called program) then
      ** process for database error.
 
     C                   IF        *IN90 = '1' OR
     C**********                   @RTCD = '*ERROR*'                                        BUG27769
     C                             @RTCD <> *BLANKS                                         BUG27769
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'AOBANKR0'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 050
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WKDFMT = BJMRDT
     C                   MOVE      BJMRDT        WKYEAR
 
     C                   IF        WKYEAR < 72
     C                   EVAL      WKCCYY = WKYEAR + 2000
     C                   ELSE
     C                   EVAL      WKCCYY = WKYEAR + 1900
     C                   ENDIF
 
     C                   MOVE      WKCCYY        WKDFMT
 
      ** Retreive Account Transfer Criteria Details.
 
     C                   EXSR      SrXRACRF
 
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
      *  Called By: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
