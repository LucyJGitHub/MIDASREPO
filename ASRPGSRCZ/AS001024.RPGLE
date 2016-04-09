     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Unreplaced Forecast Transactions Report')     *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standard Module                           *
      *                                                               *
      *  AS001024 -  Midas Unreplaced Forecast Transactions Report    *
      *                                                               *
      *  Function:  This module generates a report that lists all     *
      *             Forecast Transactions that will be maturing in    *
      *             the next 5 days but not replace by a "real        *
      *             transaction". It also lists the Hedge Linkages    *
      *             and FRAs hedging them                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD027587           Date 19Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  MD027587 - Unable to used the C for Copy and T for Template  *
      *             (Recompile)                                       *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      * SrValidate - Validate Deal based on Module ID                 *
      * SrValDealing - Validate Dealing Transaction                   *
      * SrValLending - Validate Lending Transaction                   *
      * SrValGenLedg - Validate Gen Ledger Transaction                *
      * SrPopHedges - Read Hedges                                     *
      * SrPopDerivs - Read Derivatives                                *
      * SrPrnt1 - Print Forecast Details                              *
      * SrPrnt2 - Print Hedge Details                                 *
      * SrPrnt3 - Print Derivatives Details                           *
      * SrChkLin - Checks Line Number for Overflow Processing         *
      * SrDate - Date Conversion                                      *
      * SrEdit - File Filed to Report Field                           *
      * SrRCFP1 - Register AS001024P1 for RCF                         *
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
 
      ** Midas Forecast Transactions Details File
     FASFHTRL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RTV : Hedge Transactions By Hedge ID and Der/Hed Ind
     FASHTRNL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RTV : Hedge Transactions By Hedge ID and Der/Hed Ind
     FASHTRNL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHTRND0:ASHTRND1)
 
      ** RTV : Hedge Linkages by ID Number
     FASHGLKL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas Forecast Transactions Details File
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDFF)
 
      ** Midas Forecast Transactions Details File
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
 
      ** Midas Forecast Transactions Details File
     FGLJENPL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** PRT: Printer file for Effective Hedges (Transaction Detail)
     FAS001024P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      ** PRT: Printer file for Hedge Effectiveness(Audit)
     FAS001024AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
     D MON             S              3    DIM(12) CTDATA PERRCD(12)
     D NUM             S              2  0 DIM(12) ALT(MON)
 
     D TP              S              2    DIM(3) CTDATA PERRCD(1)
     D A22             S              1    DIM(22)
 
      ** Record Format
     D INFDS           DS           528
     D  RCDFMT                38     45
 
      ** Today's Date
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  MBIN                  13     13
 
      ** File Information Data Structure for AS001024P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for AS001024AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** DS for SC Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** DS for SD Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for Access Programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for Access Programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** Working Data Structure for GLJEN's fields
     D WGLKey          DS
     D  WBtchNo                1      3
     D  WBtchItem              4      6  0
 
      ** Parameters for Access Objects
     D PRetCode        S              7
     D POption         S              7
 
      ** Parameters for ZSFILE
     D PSEQ            S              5
     D PENTY           S              3
     D ZSFILE          S             10
     D ZSERR           S              1
     D ZSNUMU          S              6  0
 
      ** Parameters for ZFRPED
     D PFLD15          S             15  0
     D PDECS           S              1  0
     D PECODE          S              1
     D POUT21          S             21
     D POUT22          S             22
     D POUT25          S             25
 
      ** Parameters for ZDate2
     D PDate           S              5  0
     D PDatFmt         S              1    INZ('M')
     D PZDate          S              6  0
     D PZADate         S              7
 
      ** Parameters for ZEdit
     D PField          S             16
     D PNoDecs         S              2P 0
 
      ** Key Fields
     D KHedgeID        S              6  0
     D***KForecastID     S              6  0                                                  CLE148
     D KForecastID     S                   LIKE(FSDLNO)                                       CLE148
     D KDHInd          S              1
     D KDFInd          S              1
     D KMod            S              2
     D KBtchNo         S              3
     D KBtchItem       S              3P 0
 
      ** Working Variables
     D WFrcstCnt       S              3  0 INZ(0)
     D WHglCnt         S              3  0 INZ(0)
     D WFRACnt         S              3  0 INZ(0)
     D WRqdLn          S              3P 0
     D WDifLn          S              4P 0
     D WMDAT           S              5P 0
     D WURDNB          S              5P 0
     D WHedgeID        S              6  0
 
      ** Working Flags
     D WFHTROkF        S              1
     D WRun            S              1
     D WRCFCall        S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     *LOVAL        SETLL     ASFHTRL0
     C                   READ      ASFHTRL0
 
     C                   DOW       NOT %EOF(ASFHTRL0)
 
      ** Count number of Forecast Transactions Processed
 
     C                   EVAL      WFrcstCnt = WFrcstCnt + 1
 
      ** Check if Transaction is live and if will mature within the next
      ** five days
 
     C                   EVAL      WFHTROkF = 'Y'
 
     C                   EVAL      WMDAT = FSMDAT - 5
     C                   IF        FSRECI = 'D' AND WURDNB >= WMDAT AND
     C                             WURDNB < FSMDAT
 
      ** Check if transaction is valid
 
     C                   EXSR      SrValidate
 
     C                   IF        WFHTROkF = 'Y'
     C                   READ      ASFHTRL0
     C                   ITER
     C                   ENDIF
 
     C                   EXSR      SrPrnt1
 
     C                   EXSR      SrPopHedges
     C                   ENDIF
 
     C                   READ      ASFHTRL0
 
     C                   ENDDO
 
     C                   IF        WRCFCall = 'Y'
     C                   EVAL      WRqdLn = 3
     C                   EXSR      SrChkLin
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   EXSR      SrAudit
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValidate - Validate Underlying Reference from Forecast      *
      *              Transactions File to their respective modules    *
      *                                                               *
      *****************************************************************
 
     C     SrValidate    BEGSR
 
     C                   SELECT
 
     C                   WHEN      FSMOD = 'DL'
     C                   EXSR      SrValDealing
 
     C                   WHEN      FSMOD = 'LE'
     C                   EXSR      SrValLending
 
     C                   WHEN      FSMOD = 'GL'
     C                   EXSR      SrValGenLedg
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValDealing - Check if Dealing transaction exists for        *
      *                current Forecast Transaction                   *
      *                                                               *
      *****************************************************************
 
     C     SrValDealing  BEGSR
 
     C**********         IF        FSUREF = *ZERO                                             CLE148
     C                   IF        FSUREF = *BLANKS                                           CLE148
     C                   EVAL      *IN61 = *ON
     C                   EVAL      WFHTROkF = 'N'
     C                   ELSE
     C                   EVAL      *IN61 = *OFF
     C*****FSUREF        CHAIN     DEALS                                                      CLE148
     C                   MOVEL     FSUREF        FSUREF2           6 0                        CLE148
     C     FSUREF2       CHAIN     DEALS                                                      CLE148
     C                   IF        NOT %FOUND (DEALS) OR FSSUBT <> DTYP
     C                             AND RECI = 'D'
     C                   EVAL      WFHTROkF = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValLending - Check if Lending transaction exists for        *
      *                current Forecast Transaction                   *
      *                                                               *
      *****************************************************************
 
     C     SrValLending  BEGSR
 
     C**********         IF        FSUREF = *ZERO                                             CLE148
     C                   IF        FSUREF = *BLANKS                                           CLE148
     C                   EVAL      *IN61 = *ON
     C                   EVAL      WFHTROkF = 'N'
     C                   ELSE
     C                   EVAL      *IN61 = *OFF
     C     FSUREF        CHAIN     CLOAN
     C                   IF        NOT %FOUND (CLOAN) OR FSSUBT <> LTYP
     C                             AND RECI = 'D'
     C                   EVAL      WFHTROkF = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValGenLedg - Check if GL transaction exists for current     *
      *                Forecast Transaction                           *
      *                                                               *
      *****************************************************************
 
     C     SrValGenLedg  BEGSR
 
     C**********         IF        FSUREF = *ZERO                                             CLE148
     C                   IF        FSUREF = *BLANKS                                           CLE148
     C                   EVAL      *IN61 = *ON
     C                   EVAL      WFHTROkF = 'N'
     C                   ELSE
     C                   EVAL      *IN61 = *OFF
     C                   MOVE      FSUREF        WGLKey
     C                   EVAL      KBtchNo = WBtchNo
     C                   Z-ADD     WBtchItem     KBtchItem
 
     C     KGLKey        CHAIN     GLJENPL1
     C                   IF        NOT %FOUND (GLJENPL1)
     C                   EVAL      WFHTROkF = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPopHedges - Get Hedges and Print                            *
      *                                                               *
      *****************************************************************
 
     C     SrPopHedges   BEGSR
 
     C**********         EVAL      KForecastID = FSTRID                                       CLE148
     C                   MOVEL     FSTRID        KForecastID                                  CLE148
     C                   EVAL      KDFInd = 'H'
     C                   EVAL      KMod = 'FH'
     C                   EVAL      WHedgeID = *ZERO
 
     C     KTran1        SETLL     ASHTRNL6
     C     KTran1        READE     ASHTRNL6
 
     C                   IF        NOT %FOUND (ASHTRNL6)
     C     *LOCK         IN        LDA
     C                   MOVE      FSHEDI        DBKey
     C                   EVAL      DBFILE = 'ASHTRNPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   DOW       NOT %EOF(ASHTRNL6)
     C
     C     FSHEDI        CHAIN     ASHGLKL0
     C                   IF        NOT %FOUND (ASHGLKL0)
     C     *LOCK         IN        LDA
     C                   MOVE      FSHEDI        DBKey
     C                   EVAL      DBFILE = 'ASHGLKPD'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        WHedgeID <> FSHEDI
     C                   EVAL      WRqdLn = 3
     C                   EXSR      SrChkLin
     C                   MOVE      FSHEDI        RHGID
     C                   WRITE     DETAIL1A
     C                   EVAL      WRqdLn = 3
     C                   EXSR      SrChkLin
     C                   WRITE     DETAIL2
     C                   EVAL      WHedgeID = FSHEDI
     C                   ENDIF
 
     C                   EXSR      SrPrnt2
     C                   EXSR      SRPopDerivs
 
     C     KTran1        READE     ASHTRNL6
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPopDerivs - Get Derivs and Print                            *
      *                                                               *
      *****************************************************************
 
     C     SrPopDerivs   BEGSR
 
     C                   EVAL      KHedgeID = FSHEDI
     C                   EVAL      KDHInd = 'D'
 
     C     KTran         SETLL     ASHTRNL0
     C     KTran         READE     ASHTRNL0
 
     C                   IF        NOT %FOUND (ASHTRNL0)
     C     *LOCK         IN        LDA
     C                   MOVE      FSHEDI        DBKey
     C                   EVAL      DBFILE = 'ASHTRNPD'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        NOT %EOF(ASHTRNL0)
     C                   EVAL      WRqdLn = 3
     C                   EXSR      SrChkLin
     C                   WRITE     DETAIL3
     C                   ENDIF
 
     C                   DOW       NOT %EOF(ASHTRNL0)
 
     C     FSHEDI        CHAIN     ASHGLKL0
     C                   IF        NOT %FOUND (ASHGLKL0)
     C     *LOCK         IN        LDA
     C                   MOVE      FSHEDI        DBKey
     C                   EVAL      DBFILE = 'ASHGLKPD'
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EXSR      SrPrnt3
 
     C     KTran         READE     ASHTRNL0
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrnt1 - Print Details for Forecast Transaction              *
      *                                                               *
      *****************************************************************
 
     C     SrPrnt1       BEGSR
 
     C                   IF        WRCFCall <> 'Y'
     C                   EXSR      SrRCFP1
     C                   ENDIF
 
     C                   CLEAR                   DETAIL1
 
     C                   MOVE      FSTRID        RTRID
     C                   MOVE      FSDESC        RDESC
     C                   MOVE      FSUREF        RUREF
     C                   EVAL      RMOD  = FSMOD
 
     C                   EVAL      PDate = FSMDAT
     C                   EXSR      SrDate
     C                   EVAL      RMDAT = PZADate
 
     C                   EVAL      WRqdLn = 5
     C                   EXSR      SrChkLin
 
     C                   IF        WDifLn >= WRqdLn
     C                   WRITE     DETAIL1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrnt2 - Print Details for Hedge Linkages                    *
      *                                                               *
      *****************************************************************
 
     C     SrPrnt2       BEGSR
 
     C                   CLEAR                   DETAIL2A
 
     C                   EVAL      WHglCnt = WHglCnt + 1
 
     C                   EVAL      WRqdLn = 1
     C                   EXSR      SrChkLin
 
     C                   IF        WDifLn <= WRqdLn
     C                   WRITE     DETAIL2
     C                   ENDIF
 
     C                   EVAL      RDMOD = FSMOD
     C                   MOVE      FSDLNO        RDDNO
     C                   MOVE      FSPCTG        PField
     C                   EVAL      PNoDecs = 2
     C                   EXSR      SrEdit
     C                   MOVE      PField        RPCTG
 
     C                   WRITE     DETAIL2A
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrnt3 - Print Details for FRA's                             *
      *                                                               *
      *****************************************************************
 
     C     SrPrnt3       BEGSR
 
     C                   CLEAR                   DETAIL3A
 
     C                   EVAL      WFRACnt = WFRACnt + 1
 
     C                   EVAL      WRqdLn = 1
     C                   EXSR      SrChkLin
 
     C                   IF        WDifLn <= WRqdLn
     C                   WRITE     DETAIL3
     C                   ENDIF
 
     C                   EVAL      RDMOD = FSMOD
     C                   MOVE      FSDLNO        RDDNO
     C                   MOVE      FSPCTG        PField
     C                   EVAL      PNoDecs = 2
     C                   EXSR      SrEdit
     C                   MOVE      PField        RPCTG
 
     C                   WRITE     DETAIL3A
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkLin - Checks for printer file overflow condition         *
      *                                                               *
      *****************************************************************
 
     C     SrChkLin      BEGSR
 
     C                   EVAL      WDifLn = OFLLN1 - PRTLN1
 
     C                   IF        WDifLn <= WRqdLn
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDate - Convert Date to DDMMMYY using ZDATE2                 *
      *                                                               *
      *****************************************************************
 
     C     SrDate        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDate
     C                   PARM                    PDatFmt
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEdit - Convert File Fields to report format using ZEDIT     *
      *                                                               *
      *****************************************************************
 
     C     SrEdit        BEGSR
 
     C                   CALLB     'ZEDIT2'
     C                   PARM                    PField
     C                   PARM                    PNoDecs
 
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
 
      ** Define Key Fields for GL Journal Entries File
 
     C     KGLKey        KLIST
     C                   KFLD                    KBtchNo
     C                   KFLD                    KBtchItem
 
      ** Define Key Fields for Transactions Retrieval (For ASHTRNL0)
 
     C     KTran         KLIST
     C                   KFLD                    KHedgeID
     C                   KFLD                    KDHInd
 
      ** Define Key Fields for Transactions Retrieval (For ASHTRNLF)
 
     C     KTran1        KLIST
     C                   KFLD                    KMod
     C                   KFLD                    KForecastID
     C                   KFLD                    KDFInd
 
      ** Access Local data Area (LDA) and retrieve values
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBPGM  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
     C                   OUT       LDA
 
      **  Use access program to read bank details file
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WURDNB = BJRDNB
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSeq
     C                   PARM      *BLANKS       PEnty
     C                   PARM      SFILEU        ZSFile
     C                   PARM      SFNUMU        ZSNumu
     C                   PARM      *BLANK        ZSERR
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit- Subroutine to Output Audit report and End Program   *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      ** Output Report Header and File Controls.
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON and *INU8 = *ON
     C                   WRITE     DBERROR
 
     C                   ELSE
 
      ** Or, if no records written, output "No Details" message.
 
     C                   IF        WFrcstCnt = *ZEROS
     C                   WRITE     NODTLS
     C                   ELSE
     C                   EVAL      RFRTNO = WFrcstCnt
     C                   EVAL      RHEDGE = WHglCnt
     C                   EVAL      RFRACT = WFRACnt
     C                   WRITE     TOTAUD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   WRITE     ENDRPRT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      *****************************************************************
 
     C     SRRCFP1       BEGSR
 
     C                   OPEN      AS001024P1
      *
      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM      SFILE1        ZSFile
     C                   PARM      SFNUM1        ZSnumu
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADP1
     C                   EVAL      WRCFCall = 'Y'
 
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
 
     C                   IF        WRun <> 'Y'
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here.
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRAUDIT
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
**   MON/NUM Month Short Name and Number
JAN01FEB02MAR03APR04MAY05JUN06JUL07AUG08SEP09OCT10NOV11DEC12
** Product Types
FV
FX
CF
