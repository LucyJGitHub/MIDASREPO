     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Cheque Book Charges Posting Generation')
      *****************************************************************
      *                                                               *
      *  Midas - Retail module                                        *
      *                                                               *
      *  RE004210 - Cheque Book Charges Posting Generation            *
      *                                                               *
      *  Function:  This module will to generate charge postings      *
      *             against the charge account for each cheque book   *
      *             issued today.  The postings will be generated once*
      *             during Close of Business where the issued date is *
      *             reached or during the first COB if the issued     *
      *             date has been entered today as back-valued date.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL154             Date 13Oct14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG14211D          Date 19Sep07               *
      *                 BUG14838           Date 15Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7485            Date 21Jun05               *
      *                 CRE019  *CREATE    Date 12Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  BUG14211D - Component GLC30 failed                           *
      *  BUG14838 - REC004210 Failed when CRT001 or CRT002 is OFF     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7485 - REC004210 00001 failed component                   *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    LR         End Pgm                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrInit   - Initialise work fields                            *
      *  SrDebit  - Create debit posting                              *
      *  SrCredit - Creatre credit posting                            *
      *  SrUpdTrl - Update trailer file                               *
      *  SrHash   - Hash totalling                                    *
      *                                                               *
      *  SrACOD   - retrieve account code details                     *
      *  SrBRCH   - retrieve account branch details                   *
      *  SrRETR   - retrieve transaction type details                 *
      *                                                               *
      *  SrAudit  - Subroutine to Output audit details                *
      *  SrZEdit  - Format Numeric Fields                             *
      *  *PSSR    - Error processing                                  *
      *  *INZSR   - Initialise                                        *
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
 
     FGETTPH    UF A E             DISK    INFSR(*PSSR)                                     BUG14838
     F                                     PREFIX(H_)                                       BUG14838
     FGETTPD    O    E           K DISK    INFSR(*PSSR)
      ** Midas RE Generated teller trans. entries details
 
     F**********GETTPZ    UF   E             DISK    INFSR(*PSSR)                           BUG14838
     FGETTPZ    UF A E             DISK    INFSR(*PSSR)                                     BUG14838
      ** Midas RE Generated teller trans. entries trailer
 
     FCHQBKL2   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CQ)
     F                                     IGNORE(CHQBKPHF)
     F                                     IGNORE(CHQBKPTF)
      ** Midas RE Cheque book file
 
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AN)
      ** Account Numbers Cross Reference File
 
     FRE004210AUO    E             PRINTER INFSR(*PSSR)
      ** AUD: Printer file for Cheque Book Charges Audit
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WrkSysVal       C                   'ChqbkChrgIncomeAcct'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Today's Date
     D RUNDAT          DS
     D  MBIN                  13     13
 
      ** Posting Narrative
     D WrkPNARDS       DS
     D                         1     11    INZ('Retail A/C/')
     D CQSCQN                 12     19  0
     D                        20     20    INZ('-')
     D CQECQN                 21     28  0
 
 
     D GenEntryTT    E DS                  EXTNAME(GETTPD)
     D WrkZZ019      E                     EXTFLD(ZZ019)
      ** External data structure for teller's generated entries details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structure for bank details
 
     D SDSVAL        E DS                  EXTNAME(SDSVALPD)
      ** External data structure for system value details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External data structure for general ledger details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External data structure for module details
 
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
      ** External data structure for profit centre details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External data structure for branch details
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D QQACCD1       E                     EXTFLD(QQACCD)
     D QQFNIC1       E                     EXTFLD(QQFNIC)
     D QQFNAA1       E                     EXTFLD(QQFNAA)
      ** External data structure for account code details
 
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      ** External data structure for retail transaction types details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG14838
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for Access Object
     D PRtCd           S              7
     D POptn           S              7
 
      ** Parameters for AOSVALR0
     D PRetCode        S              7A
     D PSysValK1       S             20A
     D PSysVal1        S            200A
     D PSysValK2       S             20A
     D PSysVal2        S            200A
     D PSysValK3       S             20A
     D PSysVal3        S            200A
     D PSysValK4       S             20A
     D PSysVal4        S            200A
     D PSysValK5       S             20A
     D PSysVal5        S            200A
     D PSysValK6       S             20A
     D PSysVal6        S            200A
     D PSysValK7       S             20A
     D PSysVal7        S            200A
     D PSysValK8       S             20A
     D PSysVal8        S            200A
     D PSysValK9       S             20A
     D PSysVal9        S            200A
     D PSysValK10      S             20A
     D PSysVal10       S            200A
 
      ** Parameters for ZEDIT
     D PzField         S             16A
     D PzADec          S              1P 0
 
      ** Work variables for hash total
     D WzAmt           S             15  3
     D WzAmtI          S             15  0
     D WzAmtD          S              3  0
     D WzTotD          S              3  0
     D WzTotI          S             15  0
     D WrkTotD         S              4  0
 
     D WRecRead        S              5  0
     D WRecProc        S              5  0
     D WTotCHAM        S             17  0
     D PTrat           S              5
     D PSARD           S              6A                                                    BUG14838
     D CRT001          S              1A                                                    BUG14838
     D CRT002          S              1A                                                    BUG14838
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Perform Initialisation.
 
     C                   EXSR      SrInit
 
      ** Read through all cheque book records
 
     C     *LOVAL        SETLL     CHQBKPDF
     C                   READ      CHQBKPDF
 
      ** Do while not End of file
 
     C                   DOW       NOT %EOF(CHQBKL2)
 
      ** Select only records with charges
 
     C                   IF        CQCHAM <> *ZERO
     C                   EVAL      WRecRead = WRecRead + 1
 
      ** If the record is live and issued today OR deleted and
      ** not inserted today, create accounting entries
 
     C                   IF        CQRECID = 'D'    AND
     C                             CQOEDT  = BJRDNB OR
     C                             CQRECID = '*'    AND
     C                             CQLCD   = BJRDNB AND
     C                             CQCHTP  = 'D'    AND
     C                             CQOEDT <> BJRDNB
 
      ** Create debit posting
 
     C                   EXSR      SrDebit
 
      ** Create credit posting
 
     C                   EXSR      SrCredit
 
      ** Increase counter and total
     C                   EVAL      WRecProc = WRecProc + 1
     C                   EVAL      WTotCHAM = WTotCHAM + CQCHAM
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      CHQBKPDF
 
     C                   ENDDO
 
      ** Update trailer file
 
     C                   EXSR      SrUpdTrl
 
      ** Output audit report.
 
     C                   EXSR      SrAudit
 
      ** End Program and Return.
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit   - Initialise work fields                            *
      *                                                               *
      *****************************************************************
 
     C     SrInit        BEGSR
 
      ** Define work/parameter fields
 
     C     *LIKE         DEFINE    ACOD          WrkACOD
     C     *LIKE         DEFINE    RECI          WrkRECI
     C     *LIKE         DEFINE    NORE1         WrkNORE1
     C     *LIKE         DEFINE    BKACCD        PAcod
     C     *LIKE         DEFINE    BRCA          PBrca
 
      ** Initialise work fields
 
     C                   IF        CRT001 = 'N' AND CRT002 = 'N'                            BUG14838
     C                   EVAL      H_RECI = 'H'                                             BUG14838
     C                   WRITE     GETTPHF                                                  BUG14838
      *                                                                                     BUG14838
     C                   EVAL      RECI = 'T'                                               BUG14838
     C                   EVAL      NORE1 = 2                                               BUG14211D
     C                   WRITE     APOSTZZF                                                 BUG14838
     C     1             SETLL     APOSTZZF                                                 BUG14838
     C                   ENDIF                                                              BUG14838
     C                   EVAL      WRecRead = *ZERO
     C                   EVAL      WRecProc = *ZERO
     C                   EVAL      WTotCHAM = *ZERO
 
      ** Initialise trailer fields and hash totals
 
     C                   READ      APOSTZZF
     C                   EVAL      WrkRECI  = RECI
     C                   EVAL      WrkNORE1 = NORE1
     C                   EVAL      WzTotI   = HRWN
     C                   EVAL      WzTotD   = HRDC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDebit  - Create debit posting                              *
      *                                                               *
      *****************************************************************
 
     C     SrDebit       BEGSR
 
      ** Initialise fields
 
     C                   CLEAR                   GenEntryTT
 
      ** Retrirve charge account details
 
     C     CQACNO        CHAIN     ACCNTL1
     C                   IF        NOT %FOUND(ACCNTL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = *BLANKS
     C                   MOVE      CQACNO        DBKey
     C                   EVAL      DBFile = 'ACCNTL1'
     C                   EVAL      DBase  = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrirve account code details
 
     C                   MOVEL     ANACOD        PAcod
     C                   EXSR      SrACOD
 
      ** Format file fields
 
     C                   EVAL      RECI = 'P'
     C                   EVAL      CNUM = ANCNUM
     C                   EVAL      CCY  = ANCCY
     C                   EVAL      ACOD = ANACOD
     C                   EVAL      ACSQ = ANACSQ
 
     C                   IF        CQCHAC <> 0
     C                   EVAL      ACNO = CQCHAC
     C                   ELSE
     C                   EVAL      ACNO = CQACNO
     C                   ENDIF
 
     C                   EVAL      PSTD = BJRDNB
     C                   EVAL      VALD = BJRDNB
     C                   EVAL      PSTA = CQCHAM
     C                   EVAL      SPOS = 'GE-TT'
 
     C                   EVAL      TRAT = CQCHTT
     C                   IF        CQCHTT <> *ZERO
     C                   MOVE      CQCHTT        PTraT
     C                   EXSR      SrRETR
     C                   EVAL      PNAR = A1RTNM
     C                   ENDIF
 
     C                   IF        CQRECID = 'D'
     C                   EVAL      DRCR = 0
     C                   ELSE
     C                   EVAL      DRCR = 1
     C                   ENDIF
 
     C                   EVAL      BRCA = ANBRCA
     C                   EVAL      ATYP = ANATYP
 
     C                   IF        ATYP = 'R'
     C                   EVAL      RIND = 1
     C                   ELSE
     C                   EVAL      RIND = 0
     C                   ENDIF
 
     C                   IF        BGNOST = 'Y'
     C                   EVAL      PRFC = ANPRFC
     C                   ELSE
     C                   EVAL      PRFC = *BLANKS
     C                   ENDIF
 
     C                   EVAL      PTIM = 235959
     C                   EVAL      ACSC = A5ACSC
     C                   EVAL      STYP = ANSTYP
 
      ** Write debit posting to the charge account in Teller
      ** Transaction Generated Entries file
 
     C                   WRITE     APOSTPDF
 
      ** Perform hash total
 
     C                   EVAL      NORE1 = NORE1 + 1
     C                   EVAL      WzAmt = PSTA/1000
     C                   EXSR      SrHash
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCredit - Creatre credit posting                            *
      *                                                               *
      *****************************************************************
 
     C     SrCredit      BEGSR
 
      ** Retrirve account brach details
 
     C                   EVAL      PBrca = ANBRCA
     C                   EXSR      SrBRCH
 
      ** Retrirve charge income account details
 
     C                   EVAL      PAcod = A8DFAC
     C                   EXSR      SrACOD
 
      ** Format file fields
 
     C                   MOVE      A8BICN        CNUM
     C                   MOVE      WrkACOD       ACOD
     C                   EVAL      ACSQ = 01
     C                   EVAL      ASOC = ANCNUM
     C                   EVAL      TRAT = *ZERO
     C                   EVAL      PNAR = WrkPNARDS
 
     C                   IF        CQRECID = 'D'
     C                   EVAL      DRCR = 1
     C                   ELSE
     C                   EVAL      DRCR = 0
     C                   ENDIF
 
     C                   EVAL      ACNO = *ZERO
     C                   EVAL      ATYP = A5ACTY
 
     C                   IF        ATYP = 'R'
     C                   EVAL      RIND = 1
     C                   ELSE
     C                   EVAL      RIND = 0
     C                   ENDIF
 
     C                   IF        BGNOST = 'Y'
     C                   EVAL      PRFC = FTPRFP
     C                   ELSE
     C                   EVAL      PRFC = *BLANKS
     C                   ENDIF
 
     C                   EVAL      ACSC = A5ACSC
     C                   EVAL      STYP = A5ACST
 
      ** Write credit posting to the charge income account in Teller
      ** Transaction Generated Entries file
 
     C                   WRITE     APOSTPDF
 
      ** Perform hash total
 
     C                   EVAL      NORE1 = NORE1 + 1
     C                   EVAL      WzAmt = PSTA/1000
     C                   EXSR      SrHash
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdTrl - Update trailer file                               *
      *                                                               *
      *****************************************************************
 
     C     SrUpdTrl      BEGSR
 
     C                   IF        WrkNORE1 <> NORE1
     C                   EVAL      RECI = WrkRECI
     C                   EVAL      HRWN = WzTotI
     C                   EVAL      HRDC = WzTotD
     C                   UPDATE    APOSTZZF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrHash   - Hash totalling                                    *
      *                                                               *
      *****************************************************************
 
     C     SrHash        BEGSR
 
      ** Set up fields to be hashed
 
     C                   IF        WzAmt < *ZERO
     C                   EVAL      WzAmt = 0 - WzAmt
     C                   ENDIF
     C                   EVAL      WzAmtI = WzAmt
     C                   MOVE      WzAmt         WzAmtD
 
      ** Add decimal part and check for carry over
 
     C                   EVAL      WrkTotD = WzTotD + WzAmtD
     C                   MOVE      WrkTotD       WzTotD
     C                   IF        WzTotD < WzAmtD
     C                   EVAL      WzAmtI = WzAmtI + 1
     C                   ENDIF
 
      ** Add integer part
 
     C                   EVAL      WzTotI = WzTotI + WzAmtI
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrACOD   - retrieve account code details                     *
      *                                                               *
      *****************************************************************
 
     C     SrACOD        BEGSR
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PAcod
     C     SDACOD        PARM      SDACOD        DSSDY
 
      ** Database error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey  = PAcod
     C                   EVAL      DBFile = 'SDACODPD'
     C                   EVAL      DBase  = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBRCH   - retrieve account branch details                   *
      *                                                               *
      *****************************************************************
 
     C     SrBRCH        BEGSR
 
     C**********         CALL      'AOBRCHR0'                                                BUG7485
     C                   CALL      'AOBRCHR1'                                                BUG7485
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey  = PBrca
     C                   EVAL      DBFile = 'SDBRCHPD'
     C                   EVAL      DBase  = 8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRETR   - retrieve transaction type details                 *
      *                                                               *
      *****************************************************************
 
     C     SrRETR        BEGSR
 
     C                   CALL      'AORETRR0'
     C                   PARM      '*BLANKS'     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PTraT
     C     SDRETR        PARM      SDRETR        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PTraT
     C                   EVAL      DBFile = 'SDRETRPD'
     C                   EVAL      DBase  = 9
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAudit  - Subroutine to Output audit details                *
      *                                                               *
      *****************************************************************
 
     C     SrAudit       BEGSR
 
      ** Move details to printer field
 
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      WRecRead      PzField
     C                   EVAL      PzADec = 0
     C                   EXSR      SrZEdit
     C                   MOVE      PzField       RCNT1
 
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      WRecProc      PzField
     C                   EVAL      PzADec = 0
     C                   EXSR      SrZEdit
     C                   MOVE      PzField       RCNT2
 
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      WTotCHAM      PzField
     C                   EVAL      PzADec = 0
     C                   EXSR      SrZEdit
     C                   MOVE      PzField       RCNT3
 
      ** Output Report Header and File Controls.
 
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZEdit  - Format Numeric Fields                             *
      *                                                               *
      *****************************************************************
 
     C     SrZEdit       BEGSR
 
     C                   CALL      'ZEDIT'
     C                   PARM                    PzField
     C                   PARM                    PzADec
 
     C                   ENDSR
 
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
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'RE004210'
 
      ** Access Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANK '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If error on access to bank details.
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey  = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve module details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey  = POptn
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   EVAL      DBase  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If Leo Letters of Credit, access profit centre details
 
     C                   IF        BGNOST = 'Y'
     C                   CALL      'AOPCACR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDPCAC        PARM      SDPCAC        DSFDY
 
      ** Database error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey  = POptn
     C                   EVAL      DBFile = 'SDPCACPD'
     C                   EVAL      DBase  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Retrieve cheque book charge income account
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      WrkSysVal     PSysValK1
     C                   PARM                    PSysVal1
     C                   PARM      *BLANKS       PSysValK2
     C                   PARM                    PSysVal2
     C                   PARM      *BLANKS       PSysValK3
     C                   PARM                    PSysVal3
     C                   PARM      *BLANKS       PSysValK4
     C                   PARM                    PSysVal4
     C                   PARM      *BLANKS       PSysValK5
     C                   PARM                    PSysVal5
     C                   PARM      *BLANKS       PSysValK6
     C                   PARM                    PSysVal6
     C                   PARM      *BLANKS       PSysValK7
     C                   PARM                    PSysVal7
     C                   PARM      *BLANKS       PSysValK8
     C                   PARM                    PSysVal8
     C                   PARM      *BLANKS       PSysValK9
     C                   PARM                    PSysVal9
     C                   PARM      *BLANKS       PSysValK10
     C                   PARM                    PSysVal10
 
     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NRF  '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey  = PSysValK1
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase  = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   IF        PSysVal1 = '*NRF   ' OR
     C                             PSysVal1 = *BLANKS
 
      ** If no values retireved, access General Ledger details
 
     C                   CALL      'AOGELRR0'
     C                   PARM      '*BLANK '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSFDY
 
      ** If error on access to general ledger details
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey  = POptn
     C                   EVAL      DBFile = 'SDGELRPD'
     C                   EVAL      DBase  = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
 
      ** Account code from general ledger file
 
     C                   MOVEL     BKACCD        WrkACOD
     C                   ENDIF
 
     C                   ELSE
 
      ** Account code from system value
 
     C                   MOVEL     PSysVal1      WrkACOD
 
     C                   ENDIF
 
     C                   ENDIF
      ** Check Switchable feature                                                           BUG14838
     C                   EVAL      CRT001 = 'N'                                             BUG14838
                                                                                            BUG14838
     C                   CALL      'AOSARDR0'                                               BUG14838
     C                   PARM      *BLANKS       PRTCD                                      BUG14838
     C                   PARM      '*VERIFY'     POPTN                                      BUG14838
     C                   PARM      'CRT001'      PSARD                                      BUG14838
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG14838
                                                                                            BUG14838
     C                   IF        PRTCD = *BLANKS                                          BUG14838
     C                   EVAL      CRT001 = 'Y'                                             BUG14838
     C                   ENDIF                                                              BUG14838
                                                                                            BUG14838
     C                   EVAL      CRT002 = 'N'                                             BUG14838
                                                                                            BUG14838
     C                   CALL      'AOSARDR0'                                               BUG14838
     C                   PARM      *BLANKS       PRTCD                                      BUG14838
     C                   PARM      '*VERIFY'     POPTN                                      BUG14838
     C                   PARM      'CRT002'      PSARD                                      BUG14838
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG14838
                                                                                            BUG14838
     C                   IF        PRTCD = *BLANKS                                          BUG14838
     C                   EVAL      CRT002 = 'Y'                                             BUG14838
     C                   ENDIF                                                              BUG14838
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
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
 
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called.
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SrAudit
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here.
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
