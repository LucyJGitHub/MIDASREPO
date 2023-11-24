     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058068
/*STD *  RPGSQLBND                                                    *                     MD058068
/*EXI *  TEXT('Midas BoE Deals Extract/Validation')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BY2020 - Deals Extract and Validation                        *
      *                                                               *
      *  Called By: BYC2020 - Deals Extract and Validation            *
      *                                                               *
      *  (c) Finastra International Limited 1998                      *
      *                                                               *
      *  Last Amend No. MD061774           Date 22Nov23               *
      *  Prev Amend No. MD058815           Date 28Sep21               *
      *                 MD058068           Date 11May21               *
      *                 MD053295           Date 13Apr19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CSD027             Date 21Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG7634            Date 22Jun05               *
      *                 LLN022             Date 24Jan05               *
      *                 232050             Date 23Feb05               *
      *                 LLN021             Date 19JAN04               *
      *                 LLN021             Date 09JAN04               *
      *                 LLN021             Date 23Nov03               *
      *                 LLN021             Date 21Oct03               *
      *                 184282             Date 08Jan01               *
      *                 179320             Date 22May00               *
      *                 LLN016             Date 12May00
      *                 LLN014             Date 19Jan00               *
      *                 170555             Date 15Nov99               *
      *                 169410             Date 19Oct99               *
      *                 168646             Date 08Oct99               *
      *                 LLN012             Date 30Sep99               *
      *                 162321             Date 26Aug99               *
      *                 164680             Date 22Jul99               *
      *                 164103             Date 12JUL99               *
      *                 163513             Date 08JUL99               *
      *                 162851             Date 22JUN99               *
      *                 161718             Date 02JUN99               *
      *                 LLN012             Date 23APR99               *
      *                 155903             Date 24Feb99               *
      *                 139259             Date 21Jul98               *
      *                 LLN009             Date 16Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Amendment History                                            *
      *  -----------------                                            *
      *                                                               *
      *  MD061774 - Deal Accrual Posting Difference for Deals with    *
      *           - Value Date 28th Feb.                              *
      *           - Recompile due to changes in ZINTDYZ2LE.           *
      *           - Applied for MD062031.                             *
      *  MD058815 - Dealing interest Calculation type 6 have different*
      *             interest amount for Calculation type 1 for non-   *
      *             leap year interest period with same parameters.   *
      *             Based from MD052690 (Recompile)                   *
      *  MD058068 - Deliverable Data Split for Bank of England        *
      *  MD053295 - Lending loan with Interest Calculation Basis      *
      *             method 3 (30/360) has wrong interest payment      *
      *             amount for month of March (Recompile)             *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7634- Forward dated deals should not appear in report     *
      *           when the date in the title is greater than the      *
      *           deals value date.                                   *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  232050 - Write live records only in BY2020P1 and BY2020P2.   *
      *           Doesn't include matured deals in the calculation    *
      *           of totals. Ensures deals aren't reported under      *
      *           the wrong customer.                                 *
      *  LLN021 - Records for mature Securities should be output to   *
      *           PF/BYMTDTPP for reporting purposes                  *
      *  LLN021 - Account Extract Validation, add industry code to the*
      *           extract criteria for BYDLEXPP.                      *
      *  184282 - Set the maturity date extracted to zero for         *
      *           call/notice deals after the maturity category       *
      *           has been determined.                                *
      *  179320 - Details are not being extracted in a single branch  *
      *           environment because the branch code work field      *
      *           ULBRCA is not being set up.                         *
      *  LLN016 - Upgrade BoE to DBAR3.                               *
      *  LLN014 - Negotiable Assets Face Value Required               *
      *  169410 - Do not extract notice days interest if there is     *
      *           interim interest due on a call/notice deal.         *
      *  168646 - Key date for events/transactions must be compared   *
      *           less than or equal to LR Report Date.  System was   *
      *           missing all those equal to date.                    *
      *  LLN012 - Additional BoE Changes (Patch B)                    *
      *  162321 - Extract interest for Negotiable Assets Purchased.   *
      *  164680 - Ignore interbrach entries on dealing events.        *
      *  164103 - Extract accrued interest on call/notice deals.      *
      *           Forward valued MM deals must be extracted for LR.   *
      *           Only extract interest records for MM deals if a     *
      *           deal is valid and product code is not 9998.         *
      *  163513 - Do no extract arbitrage deals onto the LR file.     *
      *  162851 - Do not extract forward valued deposits or additional*
      *           interest details if the product code is 9998.       *
      *  161718 - BT and LR extract flags are being incorrectly set.  *
      *           Interest amounts for the LR are being signed        *
      *           incorrectly for deposit type deals.                 *
      *         - Wrong value for event type flag.                    *
      *  LLN012 - Financial Services Authority - Liquidity Report     *
      *  155903 - If run in input cycle back valued MM deals which    *
      *           require sight/time analysys are incorrectly         *
      *           extracted with a product code of 2250 instead of    *
      *           2210 when it is an overnight deal.                  *
      *  139259 - Add standard subroutine ZDAT10 which is used by     *
      *           standard subroutine ZINTDY.                         *
      *  LLN009 - DBA2 Upgrade.                                       *
      *                                                               *
      *****************************************************************
      *
      *  Indicator Usage                                              *
      *  ---------------                                              *
      *                                                               *
      *  *IN20  -   Multi-branching                                   *
      *  *IN31  -   Report error in customer details to BY2020P2      *
      *  *IN32  -   Report error in customer details to BY2020P2      *
      *  *IN33  -   Report error in customer details to BY2020P2      *
      *  *IN34  -   Report error in customer details to BY2020P2      *
      *  *IN35  -   Report error in customer details to BY2020P2      *
      *  *IN36  -   Report error in customer details to BY2020P2      *
      *  *IN37  -   Report error in customer details to BY2020P2      *
      *  *IN41  -   Extract criteria does not exist                   *
      *  *IN42  -   Product code not valid                            *
      *  *IN89  -   End of file indicator for reading BYDEALV0        *
      *  *IN90  -   General error indicator                           *
      *                                                               *
      *****************************************************************
      *
     F**BYDEALV0IF  E           K        DISK         KINFSR *PSSR
     FBYDEALV1  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS1)
      *  Deals File By Branch and Customer
      *
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
      *  Currency details
      *
     F*DBOOKY9IF**E********   K        DISK         KINFSR *PSSR                            LLN016
     FBYBOOKY0  IF   E           K DISK    INFSR(*PSSR)                                           LL
      *  Currency details
      *
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
      *  Branches
      *
     F*DBRCHY9IF**E***********K        DISK         KINFSR *PSSR                            LLN016
     FBYBRCHY0  IF   E           K DISK    INFSR(*PSSR)                                           LL
      *  Branches to be extracted for BoE Reporting
      *
     FBYDLEXPP  IF   E           K DISK    INFSR(*PSSR)
      *  Deals Extract Criteria
      *
     F*BYPRODPP* IF   E           K DISK    INFSR(*PSSR)                                    MD058068
      *  Product Codes Details
      *
     FBYRPDTPP  IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
      *  Extract Date File
      *
     FBYDLDCPP  IF   E           K DISK
     F                                     INFSR(*PSSR)
      ** MM Deals Dr/CR Position
      *
     FBYEVNTL0  IF   E           K DISK    INFSR(*PSSR)                         LLN012
      *  Dealing events                                                   LLN012
      *                                                                   LLN012
     F*EALDY9*IF**E********** K        DISK         KINFSR *PSSR          LLN016LLN012
     FBYNASPY0  IF   E           K DISK    INFSR(*PSSR)                         LLN016LLN012
      ** Negotiable Assets Purchased                                      LLN012
      *                                                                   LLN012
     FBYEXDTPP  O    E             DISK    INFSR(*PSSR)
     F                                     USROPN
      *  Bank of England Extract File - (Uses member BYEXDLM)
      *
     FBYMTDTPP  O    E           K DISK    INFSR(*PSSR)                         LLN021
     F                                     USROPN
     F                                     RENAME(BYEXDTD0:BYMTDTP0)
      *  Mature Bank of England Extract File - (Uses member BYEXDLM)      LLN021
     F*YNETDPPO***E***********         DISK         KINFSR *PSSR      UC  LLN016
      ***Extract*Details*For*netting - (Uses member BYNETDLM)             LLN016
      *
     FBYTOTEPP  O    E             DISK    INFSR(*PSSR)                         LLN012
      *  Asset/Liabilities Totals                                         LLN012
      *                                                                   LLN012
     FBY2020P1  O    E             PRINTER INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(SPOOL1)
      *  Bank of England Validation Report - Valid Deals
      *
     FBY2020P2  O    E             PRINTER INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(SPOOL2)
      *  Bank of England Validation Report - Invalid Deals
      *
      /EJECT
      *
     D*COPY*ZSRSRC,ZDATE2Z1                                                                 MD058068
     D/COPY ZSRSRC,ZDATE2Z1LE                                                               MD058068
     D*COPY*ZSRSRC,ZDATE9Z1                                                                 MD058068
     D/COPY ZSRSRC,ZDATE9Z1LE                                                               MD058068
     D @CPY            S             80    DIM(1) CTDATA PERRCD(1)
     D @CCY            S              3    DIM(200)
     D @TAC            S             15  0 DIM(200)                             Total assets - ccy
     D @TAS            S             15  0 DIM(200)                             Total assets - sterl
     D @TLC            S             15  0 DIM(200)                             Total liabilities -
     D @TLS            S             15  0 DIM(200)                             Total liabilities -
      *
      /SPACE 3
      *COPY*ZSRSRC,ZINTDYZ1                                                                 MD058068
      /COPY ZSRSRC,ZINTDYZ1LE                                                               MD058068
      *COPY*ZSRSRC,ZDATE9Z2                                                                 MD058068
      /COPY ZSRSRC,ZDATE9Z2LE                                                               MD058068
     D/EJECT
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Data Structure using Bank file format
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Dealing Data Static Data
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      *
      ** General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                          L
      *
      ** Trading Data ICD
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                          L
      *
      ** Data Structure using Currency Details
     D SDCURR        E DS                  OCCURS(200) EXTNAME(SDCURRPD)
      *
      ** Data Structure for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Data Structure for Bank of England Customer Details
     D*DCUS7****E*DSSDCUSTX7*****                                                            LLN016
     D SDCUS7        E DS                  EXTNAME(BYCUSTX0)                                       L
      *
      ** Data Structure for extra customer details returned by BY9110
      *       ULLISO  - ISO Code of customer's country of location
      *       ULCISO  - ISO Code of customer's country of citizenship
      *
     D SDCUSX          DS
     D  ULLISO                 1      2
     D  ULCISO                 3      4
     D  ULRWCD                 5      8  0
      *
      ** Program Status Data Structure
     D PSDS           SDS
     D  ULPGMN           *PROC
     D  ULWSID               244    253
     D  ULUSER               254    263
      *
      * File information data structure (for database files only)
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      *
      * First DS For Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * DS For Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data structure for retrieval of data from DTAARA/RUNDAT
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      *  File Information Data Structure for BY2020P1
     D SPOOL1          DS
     D  ULNUM1               123    124B 0
     D  ULOVF1               188    189B 0
     D  ULCLN1               367    368B 0
      *
      *  File Information Data Structure for BY2020P2
     D SPOOL2          DS
     D  ULNUM2               123    124B 0
     D  ULOVF2               188    189B 0
     D  ULCLN2               367    368B 0
     D BYPROD        E DS                  EXTNAME(BYPRDJW0)                                MD058068
      *                                                                   LLN014
      * DS to define layout of data area BYSTAT                           LLN014
     D BYSTAT        E DS                  EXTNAME(BYSTATPP)                    LLN014
      *                                                                   139259
      * Standard subroutine data structure definitions                    139259
     I*COPY*ZSRSRC,ZDAT10Z1                                               139259            MD058068
     D/COPY ZSRSRC,ZDAT10Z1LE                                             139259            MD058068
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Main Processing                                               *
      *                                                               *
      * Calls: SR/#LMAIN - Main Processing                            *
      *        SR/#LTERM - Termination Processing                     *
      *                                                               *
      *****************************************************************
      *
      *
      *  Main Processing
     C                   EXSR      #LMAIN
      *
      *
      *  Termination Processing
     C                   EXSR      #LTERM
      *
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LMAIN - Main Processing                                   *
      *                                                               *
      * Called by:  Main Processing                                   *
      *                                                               *
      * Calls:      SR/#LBRCH - Branch Processing                     *
      *             SR/#LRSET - Reset Work Fields                     *
      *             SR/#LABDL - Arbitrage Deal Processing             *
      *             SR/#LFWDL - Forward FX Deal Processing            *
      *             SR/#LFXDL - FX Deal Processing                    *
      *             SR/#LMMDL - MM Deal Processing                    *
      *             SR/#LNADL - NA's Deal Processing                  *
      *                                                               *
      *****************************************************************
     C     #LMAIN        BEGSR                                                  ** SR/#LDETL**
      *
      *
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1                               88
     C     *IN88         DOWEQ     *OFF
      *
      *  Branch processing
     C                   EXSR      #LBRCH
      *
      *
      *  Process Deals  (FX and MM Deals Only) if branch to be include
     C     ULIBOE        IFEQ      'Y'
     C***********ULBRCA    SETLLBYDEALV0                                     LLN021
     C***********ULBRCA    READEBYDEALV0                 89                  LLN021
     C     ULBRCA        SETLL     BYDEALV1                                                       LL
     C     ULBRCA        READE     BYDEALV1                               89                      LL
     C     *IN89         DOWEQ     *OFF
      *
      *  Only process live deals and according to mode
     C     ULMODE        IFEQ      'INTERIM'
     C     LCD           ANDEQ     BJRDNB
     C     ULMODE        OREQ      'EXTRACT'
     C     ULMODE        OREQ      'LIST   '
      *
      *  Reset work fields
     C                   EXSR      #LRSET
      *
      *  Determine if FX deals are forward valued
     C     RCDT          IFEQ      'B'
     C                   EXSR      #LSFWD
     C                   ENDIF
      *
      *  Process deal according to deal type
     C                   SELECT
     C     DTYP          WHENEQ    'PS'                                         Arbitrage
     C                   EXSR      #LABDL
     C     RCDT          WHENEQ    'B'                                          Forward FX
     C     VDAT          ANDGT     ULSFWD
     C                   EXSR      #LFWDL
     C     RCDT          WHENEQ    'B'                                          FX Deal Type
     C                   EXSR      #LFXDL
     C     RCDT          WHENEQ    'C'                                          MM Deal Type
     C     PCPL          ANDNE     *ZERO
     C                   EXSR      #LMMDL
     C     RCDT          WHENEQ    'D'                                          NA's Purchased
     C                   EXSR      #LNADL
     C                   ENDSL
      *
     C                   ENDIF
      *
     C********   ULBRCA    READEBYDEALV0                 89                LLN021
     C     ULBRCA        READE     BYDEALV1                               89                    LLN0
     C                   ENDDO
      *
      *
     C                   ENDIF
     C                   READ      SDBRCHL1                               88
     C                   ENDDO
      *
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LBRCH - Processing For New Branch                         *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:      SR/#LRPTT - Final Report Processing               *
      *                                                               *
      *****************************************************************
     C     #LBRCH        BEGSR                                                  ** SR/#LBRCH**
      *
      *  Reset flag
     C                   MOVE      'N'           ULIBOE                         Include branch
     C**********           MOVE A8BRCD    ULBRCA                          LLN012
      *
      *  If single branch all records must be extracted
     C     AGMBIN        IFEQ      'N'
     C                   MOVE      'Y'           ULIBOE
     C                   MOVE      A8BRCD        ULBRCA                                        17932
      *
      *  Multi-branch processing
     C                   ELSE
      *
      *  If files open report currency summaries and close files
     C     ULOPNF        IFEQ      'Y'
     C                   EXSR      #LRPTT
     C                   ENDIF
     C                   MOVE      A8BRCD        ULBRCA                                        LLN01
      *
      *   Check if new branch is to be included in report extract
     C********** ULBRCA    CHAINSDBRCHY9             90                                     LLN016
     C     ULBRCA        CHAIN     BYBRCHY0                           90
     C     *IN90         IFEQ      *OFF
     C                   MOVEL     A8IBOE        ULIBOE
     C                   ENDIF
      *
      *   Reset open flag and page numbers
     C                   MOVE      'N'           ULOPNF
     C                   Z-ADD     0             PAGE1
     C                   Z-ADD     0             PAGE2
      *
      *   Include branch in Bank of England Extract
     C     ULIBOE        IFEQ      'Y'
      *
      *  Open printer files for new branch
     C                   MOVE      'Y'           ULOPNF
     C                   OPEN      BY2020P1
     C                   OPEN      BY2020P2
      *
      *  RCF processing for printer file BY2020P1
     C                   Z-ADD     ULNUM1        ULSFNO
     C                   CALL      'ZSFILE'
     C                   PARM                    ULRSEQ
     C                   PARM                    ULBRCA
     C                   PARM      'BY2020P1'    ULFNAM
     C                   PARM                    ULSFNO
     C                   PARM                    ULRTCD
     C     ULRTCD        IFNE      *BLANK
     C                   MOVEL     '*NONE'       ULKEY                          ************
     C                   MOVEL     'ZSFILE  '    ULFILE                         * DBERR 01 *
     C                   Z-ADD     1             ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *  RCF processing for printer file BY2020P2
     C                   Z-ADD     ULNUM2        ULSFNO
     C                   CALL      'ZSFILE'
     C                   PARM                    ULRSEQ
     C                   PARM                    ULBRCA
     C                   PARM      'BY2020P2'    ULFNAM
     C                   PARM                    ULSFNO
     C                   PARM                    ULRTCD
     C     ULRTCD        IFNE      *BLANK
     C                   MOVEL     '*NONE'       ULKEY                          ************
     C                   MOVEL     'ZSFILE  '    ULFILE                         * DBERR 02 *
     C                   Z-ADD     2             ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *  Write report headings to BY2020P1 and BY2020P2
     C                   MOVE      L0RPDA        L#RPDA
     C                   MOVE      A8BRCD        L#BRCD
     C                   MOVE      A8BRNM        L#BRNM
     C                   WRITE     BY2020H1
     C                   WRITE     BY2020H2
      *
     C                   ENDIF
     C                   ENDIF
      *
      *  Reset currency summary totals
     C                   Z-ADD     0             @TAC
     C                   Z-ADD     0             @TLC
     C                   Z-ADD     0             @TAS
     C                   Z-ADD     0             @TLS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LABDL - Process Arbitrage Deal                               *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:  SR/#LVALD - Validate Deal Details                     *
      *         SR/#LABFD - Format Deposit Details                    *
      *         SR/#LABFL - Format Loan Details                       *
      *         SR/#LRPXT - Report/Extract Details                    *
      *                                                               *
      *****************************************************************
     C     #LABDL        BEGSR                                                  ** SR/#LABDL**
      *
      *  Only process second leg of arbitrage deals
     C     FSLI          IFEQ      2
      *
      *    Validate deal
     C**********           Z-ADDCNUM      ULCNUM           Customer                           CSD027
     C                   MOVE      CNUM          ULCNUM                         Customer
     C                   EXSR      #LVALD
      *
      *    Format work fields for deposit side
     C                   EXSR      #LABFD
      *
      *    Report/Extract details for deposit side
     C     ULCUAS        IFNE      0
     C                   MOVE      'I'           ULETYP            1
     C                   EXSR      #LRPXT
     C                   ENDIF
      *
      *
      *    Format work fields for loan side
     C                   EXSR      #LABFL
      *
      *    Report/Extract details for loan side
     C     ULCUAS        IFNE      0
     C                   MOVE      'I'           ULETYP
     C                   EXSR      #LRPXT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LABFD - Format Arbritrage Deal Deposit Details            *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:      SR/#LPROC - Format Common Work Fields             *
      *             SR/GLINTC - Calculate Interest                    *
      *                                                               *
      *****************************************************************
     C     #LABFD        BEGSR                                                  ** SR/#LABFD**
      *
      *  Initialise work fields
     C**********           Z-ADDCNUM      ULCNUM           Customer                           CSD027
     C                   MOVE      CNUM          ULCNUM                         Customer
     C                   Z-ADD     OTDT          ULVDAT                         Value date
     C                   Z-ADD     VDAT          ULMDAT                         Maturity date
     C                   MOVE      IDCY          ULCYCD                         Deposit currency
     C                   MOVE      'Y'           ULINTB                         Interest bearing
     C                   MOVE      'AB'          ULMMOD                         Module id.
      *   Determine maturity category using value date
     C                   CALL      'BY9060'
     C                   PARM      VDAT          ULDAYN                         Input date
     C                   PARM      *BLANK        ULMCAT                         Category type
     C                   PARM      0             ULMPER                         Category period date
     C                   PARM      *BLANK        ULRTCD                         Return code
     C     ULRTCD        IFNE      *BLANK
     C                   MOVEL     '*NONE'       ULKEY                          ************
     C                   MOVEL     'BY9060  '    ULFILE                         * DBERR 03 *
     C                   Z-ADD     3             ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *  Calculate deposit interest from report extract date
     C     L0RPDT        IFLE      OTDT
     C     BKALDI        ANDEQ     'Y'
     C     L0RPDT        ORLT      OTDT
     C     BKALDI        ANDEQ     'N'
     C                   Z-ADD     IDIA          ULCUAS                         Deposit interest
     C                   ELSE
     C                   Z-ADD     OTDT          ZIBEG
     C                   Z-ADD     L0RPDT        ZIEND
     C     BKALDI        IFEQ      'N'
     C                   ADD       1             ZIEND
     C                   ENDIF
     C                   Z-ADD     IDCM          ZICALC
     C                   Z-ADD     IDAM          ZIAMT
     C                   Z-ADD     IDIR          ZIRATE
     C                   EXSR      GLINTC
     C     IDIA          SUB       ZINTR         ULCUAS
     C                   ENDIF
      *
      *  Common processing for all deal types
     C     ULCUAS        IFNE      0
     C                   EXSR      #LPROC
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LABFL - Format Work Fields For Loan Side of Arbitrage Deal   *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:      SR/#LPROC - Format Common Work Fields             *
      *             SR/GLINTC - Calculate Interest                    *
      *                                                               *
      *****************************************************************
     C     #LABFL        BEGSR                                                  ** SR/#LABDL**
      *
      *  Initialise work fields
     C                   MOVE      ILCY          ULCYCD                         Loan currency
     C                   Z-ADD     ILIA          ULCUAS                         Loan interest
      *
      *  Calculate loan interest from report extract date
     C     L0RPDT        IFLE      OTDT
     C     BKALDI        ANDEQ     'Y'
     C     L0RPDT        ORLT      OTDT
     C     BKALDI        ANDEQ     'N'
     C                   Z-ADD     ILIA          ULCUAS
     C                   ELSE
     C                   Z-ADD     OTDT          ZIBEG
     C                   Z-ADD     L0RPDT        ZIEND
     C     BKALDI        IFEQ      'N'
     C                   ADD       1             ZIEND
     C                   ENDIF
     C                   Z-ADD     ILCM          ZICALC
     C                   Z-ADD     ILAM          ZIAMT
     C                   Z-ADD     ILIR          ZIRATE
     C                   EXSR      GLINTC
     C     ILIA          SUB       ZINTR         ULCUAS
     C                   ENDIF
      *
      *  Reverse sign for loan interest amount
     C                   Z-SUB     ULCUAS        ULCUAS
      *
      *  Common processing for all deal types
     C     ULCUAS        IFNE      0
     C                   EXSR      #LPROC
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LFXDL - Determine if FX deal to be processedd                *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:  SR/#LVALD - Validate Deal Details                     *
      *         SR/#LFXFP - Format FX Purchase Details                *
      *         SR/#LFXFS - Format FX Sale Details                    *
      *         SR/#LRPXT - Report/Extract Details                    *
      *                                                               *
      *****************************************************************
     C     #LFXDL        BEGSR                                                  ** SR/#LFXDL**
      *
      *  FX deal to be processed if:
      *  - Option to date is equal to or after report date for OP
      *  - For other deals if value date is after report extract date
     C     DTYP          IFEQ      'OP'
     C     OTDT          ANDGE     L0RPDT
     C     DTYP          ORNE      'OP'
     C     VDAT          ANDGT     L0RPDT
      *
      *
      *  Validate customer and deal details for extract
     C**********           Z-ADDCNUM      ULCNUM           Customer                           CSD027
     C                   MOVE      CNUM          ULCNUM                         Customer
     C                   EXSR      #LVALD
      *
      *
      *  Format work fields for purchase side of deal
     C                   EXSR      #LFXFP
      *
      *  Report/Extract purchase details
     C                   EXSR      #LRPXT
      *
      *
      *  Format work fields for sale side of deal
     C                   EXSR      #LFXFS
      *
      *  Report/Extract sale details
     C                   EXSR      #LRPXT
      *
     C                   ENDIF
      *
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LFXFP - Format Fields For Purchase Side of Deal              *
      *                                                               *
      * Called by:  SR/#FXDL - FX Deal Processing                     *
      *                                                               *
      * Calls:      SR/#LPROC - Format Common Work Fields             *
      *                                                               *
      *****************************************************************
     C     #LFXFP        BEGSR                                                  ** SR/#LFXFP**
      *
      *  Set up work fields
     C                   Z-ADD     6000          ULPCOD                         Product code
     C                   MOVE      PUCY          ULCYCD                         Currency
     C                   Z-SUB     PUAM          ULCUAS                         Amount
     C                   MOVE      *BLANK        ULINTB                         Interest bearing
     C                   MOVE      'FX'          ULMMOD                         Module id.
     C                   Z-ADD     VDAT          ULVDAT                         Value date
     C                   Z-ADD     VDAT          ULMDAT                         Maturity date
     C                   CALL      'BY9060'                                     Maturuty category
     C                   PARM      VDAT          ULDAYN                          for value date
     C                   PARM      *BLANK        ULMCAT
     C                   PARM      0             ULMPER                         Category period date
     C                   PARM      *BLANK        ULRTCD
     C     ULRTCD        IFNE      *BLANK
     C                   MOVEL     '*NONE'       ULKEY                          ************
     C                   MOVEL     'BY9060  '    ULFILE                         * DBERR 04 *
     C                   Z-ADD     4             ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *  Item is to be netted if customer and product code
      *  FX netting flags are set to 'Y'
     C*****ULPCOD        CHAIN     BYPRODPP                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :ULPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C                   SETOFF                                       90                    MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   SETON                                        90                    MD058068
     C                   ENDIF                                                              MD058068
     C********** *IN90     IFEQ *OFF                                                         LLN016
     C********** LFXNT     ANDEQ'Y'                                                          LLN016
     C********** LDFXNT    ANDEQ'Y'                                                          LLN016
     C**********           MOVE 'Y'       ULNETI                                             LLN016
     C**********           ENDIF                                                             LLN016
      *
      *  Perform common processing for all deal types
     C                   EXSR      #LPROC
      *
      ** Set-up event type
     C                   MOVE      'P'           ULETYP
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LFXFS - Format Fields For Sale Side of Deal                  *
      *                                                               *
      * Called by:  SR/#FXDL - FX Deal Processing                     *
      *                                                               *
      * Calls:      SR/#LPROC - Format Common Work Fields             *
      *                                                               *
      *****************************************************************
     C     #LFXFS        BEGSR                                                  ** SR/#LFXFS**
      *
      *  Set sale details
     C                   Z-ADD     6200          ULPCOD                         Product code
     C                   MOVE      SLCY          ULCYCD                         Currency
     C                   Z-ADD     SLAM          ULCUAS                         Amount
      *
      *  Item is to be netted if customer and product code
      *  FX netting flags are set to 'Y'
     C*****ULPCOD        CHAIN     BYPRODPP                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :ULPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C                   SETOFF                                       90                    MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   SETON                                        90                    MD058068
     C                   ENDIF                                                              MD058068
     C********** *IN90     IFEQ *OFF                                                         LLN016
     C********** LFXNT     ANDEQ'Y'                                                          LLN016
     C********** LDFXNT    ANDEQ'Y'                                                          LLN016
     C**********           MOVE 'Y'       ULNETI                                             LLN016
     C**********           ENDIF                                                             LLN016
      *
      *  Perform common processing for all deal types
     C                   EXSR      #LPROC
      *
      ** Set-up event type
     C                   MOVE      'P'           ULETYP
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LFWDL - Process Forward FX Deals                             *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:  SR/#LVALD - Validate Deal Details                     *
      *         SR/#LFWFP - Format Forward FX Details                 *
      *         SR/#LRPXT - Report/Extract Details                    *
      *                                                               *
      *****************************************************************
     C     #LFWDL        BEGSR                                                  ** SR/#LFWDL**
      *
      *  Validate customer and deal details for extract
     C**********           Z-ADDCNUM      ULCNUM           Customer                           CSD027
     C                   MOVE      CNUM          ULCNUM                         Customer
     C                   EXSR      #LVALD
      *
      *  Format work fields for forward FX deal
     C                   EXSR      #LFWFP
      *
      *  Report/Extract forward FX details
     C                   EXSR      #LRPXT
      *
      *
      *  Format work fields for forward FX deal - sale details
     C                   EXSR      #LFWFS
      *
      *  Report/Extract forward FX details - sale details
     C                   EXSR      #LRPXT
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LFWFP - Format Fields For Forward FX Deal                    *
      *                                                               *
      * Called by:  SR/#FWDL - FX Deal Processing                     *
      *                                                               *
      * Calls:      SR/#LPROC - Format Common Work Fields             *
      *                                                               *
      *****************************************************************
     C     #LFWFP        BEGSR                                                  ** SR/#LFWFP**
      *
      *  Set up work fields
     C                   Z-ADD     VDAT          ULVDAT                         Value date
     C                   MOVE      *BLANK        ULINTB                         Interest bearing
     C                   MOVE      '3'           ULDRVT                         Derivative type
     C                   MOVE      'FX'          ULMMOD                         Module id.
     C                   CALL      'BY9060'                                     Maturuty category
     C                   PARM      VDAT          ULDAYN                          for value date
     C                   PARM      *BLANK        ULMCAT
     C                   PARM      0             ULMPER                         Category period date
     C                   PARM      *BLANK        ULRTCD
     C     ULRTCD        IFNE      *BLANK
     C                   MOVEL     '*NONE'       ULKEY                          ************
     C                   MOVEL     'BY9060  '    ULFILE                         * DBERR 05 *
     C                   Z-ADD     5             ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *   Calculate future purchase amount
     C                   CALL      'BY9050'
     C                   PARM      L0RPDT        ULSDAY                         Spot date
     C                   PARM      VDAT          ULFDAY                         Future date
     C                   PARM      PUAM          ULFAMT                         Future amount
     C                   PARM      PUCY          ULCYCD                         Currency
     C                   PARM                    ULAMNT                         Net present amount
     C                   PARM      *BLANK        ULRTCD                         Return code
     C     ULRTCD        IFNE      ' '
     C                   MOVEL     '*NONE'       ULKEY                          ************
     C                   MOVEL     'BY9050  '    ULFILE                         * DBERR 22 *
     C                   Z-ADD     22            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *   Convert net pesent purchase amount to sterling
     C     ULCYCD        IFNE      BLCYCD
     C                   CALL      'BY9070'
     C                   PARM      ULAMNT        ULINAM                         In amount
     C                   PARM      ULCYCD        ULFCCY                         From currency
     C     ULPAMP        PARM                    ULOTAM                         Converted amount
     C                   PARM      BLCYCD        ULTCCY                         To currency
     C                   PARM      *BLANK        ULRTCD                         Return code
     C     ULRTCD        IFNE      ' '
     C                   MOVEL     '*NONE'       ULKEY                          ************
     C                   MOVEL     'BY9070  '    ULFILE                         * DBERR 06 *
     C                   Z-ADD     6             ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     ULAMNT        ULPAMP
     C                   ENDIF
      *
      *   Calculate future sale amount
     C                   Z-SUB     SLAM          ULFAMT
     C                   CALL      'BY9050'
     C                   PARM      L0RPDT        ULSDAY                         Spot date
     C                   PARM      VDAT          ULFDAY                         Future date
     C                   PARM                    ULFAMT                         Future amount
     C                   PARM      SLCY          ULCYCD                         Currency
     C                   PARM                    ULAMNT                         Net present amount
     C                   PARM      *BLANK        ULRTCD                         Return code
     C                   Z-SUB     ULAMNT        ULAMNT
      *
      *   Convert future sale amount to sterling
     C     ULCYCD        IFNE      BLCYCD
     C                   CALL      'BY9070'
     C                   PARM      ULAMNT        ULINAM                         Input amount
     C                   PARM      ULCYCD        ULFCCY                         From currency
     C     ULPAMS        PARM                    ULOTAM                         Converted amount
     C                   PARM      BLCYCD        ULTCCY                         To currency
     C                   PARM      *BLANK        ULRTCD                         Return code
     C     ULRTCD        IFNE      ' '
     C                   MOVEL     '*NONE'       ULKEY                          ************
     C                   MOVEL     'BY9070  '    ULFILE                         * DBERR 07 *
     C                   Z-ADD     7             ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     ULAMNT        ULPAMS
     C                   ENDIF
      *
      *  Calculate FX Net Present Value
     C     ULPAMP        SUB       ULPAMS        ULSMKV
      *
     C*  Set work fields for purchase details
     C                   MOVE      PUCY          ULCYCD                         Currency
     C                   Z-SUB     PUAM          ULCUAS                         Amount
     C                   MOVE      '6000'        ULPCOD                         Product code
      *
      *  Item is to be netted if customer and product code
      *  FX netting flags are set to 'Y'
     C*****ULPCOD        CHAIN     BYPRODPP                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :ULPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C                   SETOFF                                       90                    MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   SETON                                        90                    MD058068
     C                   ENDIF                                                              MD058068
     C********** *IN90     IFEQ *OFF                                                         LLN016
     C********** LFXNT     ANDEQ'Y'                                                          LLN016
     C********** LDFXNT    ANDEQ'Y'                                                          LLN016
     C**********           MOVE 'Y'       ULNETI                                             LLN016
     C**********           ENDIF                                                             LLN016
      *
      *  Perform common processing for all deal types
     C                   EXSR      #LPROC
      *
      ** Set-up event type
     C                   MOVE      'P'           ULETYP
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LFWFS - Format Fields For Sale Side of Deal                  *
      *                                                               *
      * Called by:  SR/#FWDL - Forward FX Deal Processing             *
      *                                                               *
      * Calls:      SR/#LPROC - Format Common Work Fields             *
      *                                                               *
      *****************************************************************
     C     #LFWFS        BEGSR                                                  ** SR/#LFWFS**
      *
      *  Set sale details
     C                   Z-ADD     6200          ULPCOD                         Product code
     C                   MOVE      SLCY          ULCYCD                         Currency
     C                   Z-ADD     SLAM          ULCUAS                         Amount
     C                   Z-ADD     0             ULSMKV
      *
      *  Item is to be netted if customer and product code
      *  FX netting flags are set to 'Y'
     C*****ULPCOD        CHAIN     BYPRODPP                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :ULPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C                   SETOFF                                       90                    MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   SETON                                        90                    MD058068
     C                   ENDIF                                                              MD058068
     C********** *IN90     IFEQ *OFF                                                         LLN016
     C********** LFXNT     ANDEQ'Y'                                                          LLN016
     C********** LDFXNT    ANDEQ'Y'                                                          LLN016
     C**********           MOVE 'Y'       ULNETI                                             LLN016
     C**********           ENDIF                                                             LLN016
      *
      *  Perform common processing for all deal types
     C                   EXSR      #LPROC
      *
      ** Set-up event type
     C                   MOVE      'P'           ULETYP
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LMMDL - Select MM Deal For Processing                        *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:  SR/#LVALD - Validate Deal Details                     *
      *         SR/#LMMFM - Format MM Deal Details                    *
      *         SR/#LMMF2 - Format MM Forward Loan Details            *
      *         SR/#LRPXT - Report/Extract Details                    *
      *                                                               *
      *****************************************************************
     C     #LMMDL        BEGSR                                                  ** SR/#LMMDL**
      *
      *  If the deal is a forward valued deposit do not process           164103
     C***        VDAT      IFGT L0RPDT                                    164103
     C***        RCDC      ANDEQ16                                        164103
     C***                  GOTO MMEND                                     164103
     C***                  END                                            164103
      *
      *  Validate customer and deal details for extract
     C**********           Z-ADDCNUM      ULCNUM           Customer                           CSD027
     C                   MOVE      CNUM          ULCNUM                         Customer
     C                   EXSR      #LVALD
      *
      *   Format work fields for deal
     C                   EXSR      #LMMFM
      *
      *   Report/Extract MM deal details
     C                   EXSR      #LRPXT
      *
      *
      *   If deal is forward valued produce second record
     C     VDAT          IFGT      L0RPDT
     C****       RCDC      ANDEQ15                                        164103
     C     ULPCOD        ANDNE     9998                                                        16285
     C     ULPCOD        ANDNE     9999                                                        16285
      *
      *   Format work fields for forward value
     C                   EXSR      #LMMF2
      *
      *   Report/Extract forward valued loans details
     C                   EXSR      #LRPXT
      *
     C                   ENDIF
      *                                                                   LLN012
      * If CAR LLN012 is on, extract interest events on deals             LLN012
     C     LLN012        IFEQ      'Y'                                                         LLN01
     C     ULPCOD        ANDNE     9998                                                        16285
     C     ULPCOD        ANDNE     9999                                                        16285
      *                                                                   164103
      * Only extract if deals are valid for extract                       164103
     C     ULVALD        IFEQ      'Y'                                                         16410
     C     ULPCOD        ANDNE     9998                                                        16410
     C     ULPCOD        ANDNE     9999                                                        16410
      *                                                                   164103
      *  Output accrued interest for call/notice deal                     164103
     C     DTYP          IFEQ      'CD'                                                        16410
     C     MDAT          ANDEQ     0                                                           16410
     C     NIDT          ANDEQ     0                                                           16941
     C     DTYP          OREQ      'CL'                                                        16410
     C     MDAT          ANDEQ     0                                                           16410
     C     NIDT          ANDEQ     0                                                           16941
      *                                                                   164103
      *  Set currency amount                                              164103
     C     RCDC          IFEQ      15                                            Loan amt      16410
     C                   Z-ADD     ULTINT        ULCUAS                                        16410
     C                   ELSE                                                                  16410
     C                   Z-SUB     ULTINT        ULCUAS                         Deposit amount 16410
     C                   ENDIF                                                                 16410
      *                                                                   164103
      *  Convert to sterling                                              164103
     C                   EXSR      #LPROC                                                      16410
      *                                                                   164103
      *  Set BT/LR extract flags                                          164103
     C                   MOVE      'N'           ULBTEX                                        16410
     C                   MOVE      'Y'           ULLREX                                        16410
      *                                                                   164103
      *  Set-up event type                                                164103
     C                   MOVE      'I'           ULETYP                                        16410
      *                                                                   164103
      *  Report/Extract details                                           164103
     C                   EXSR      #LRPXT                                                      16410
      *                                                                   164103
     C                   ENDIF                                                                 16410
      *                                                                   LLN012
      * Obtain all outstanding events for the deal                        LLN012
     C     DLNO          SETLL     BYEVNTL0                                                    LLN01
     C     DLNO          READE     BYEVNTL0                               99                   LLN01
     C     *IN99         DOWEQ     *OFF                                                        LLN01
      *                                                                   LLN012
      *                                                                   164680
      ** Do not process inter branch events                               164680
     C     IBRE          IFNE      'Y'                                                         16468
      *                                                                   164680
      * Generate an extra extract if an interest event is read            LLN012
      * (One of 15I2; 15M2; 16I2; 16M2)...                                LLN012
     C     ETYPD         IFEQ      '15I2'                                                      LLN01
     C     ETYPD         OREQ      '15M2'                                                      LLN01
     C     ETYPD         OREQ      '16I2'                                                      LLN01
     C     ETYPD         OREQ      '16M2'                                                      LLN01
      *                                                                   LLN012
      ***********ent date is less than LR extract date              LLN012168646
      * ...AND event date is less than or equal to LR Date                168646
     C***********EDATD     IFLT L0LRDT                              LLN012168646
     C     EDATD         IFLE      L0LRDT                                                      16864
      *                                                                   LLN012
      * Set up extract details...                                         LLN012
     C     RCDC          IFEQ      15                                            Loan amt      16171
     C                   Z-ADD     EAMTD         ULCUAS                                        LLN01
     C                   ELSE                                                                  16171
     C                   Z-SUB     EAMTD         ULCUAS                         Deposit amount 16171
     C                   ENDIF                                                                 16171
      *                                                                   LLN012
      *  Convert amount to sterling                                       LLN012
     C     ULCYCD        IFEQ      BLCYCD                                                      LLN01
     C                   Z-ADD     ULCUAS        ULSGAM                                        LLN01
     C                   ELSE                                                                  LLN01
     C                   CALL      'BY9070'                                                    LLN01
     C                   PARM      ULCUAS        ULINAM                                        LLN01
     C                   PARM      ULCYCD        ULFCCY                                        LLN01
     C                   PARM      *ZERO         ULOTAM                                        LLN01
     C                   PARM      BLCYCD        ULTCCY                                        LLN01
     C                   PARM      *BLANK        ULRTCD                                        LLN01
     C     ULRTCD        IFNE      ' '                                                         LLN01
     C     *LOCK         IN        LDA                                                         LLN01
     C                   MOVEL     ULPGMN        DBPGM                          ************   LLN01
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 25 *   LLN01
     C                   MOVEL     'BY9070  '    DBFILE                         ************   LLN01
     C                   Z-ADD     25            DBASE                                         LLN01
     C                   OUT       LDA                                                         LLN01
     C                   EXSR      *PSSR                                                       LLN01
     C                   ENDIF                                                                 LLN01
     C                   Z-ADD     ULOTAM        ULSGAM                                        LLN01
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
     C                   Z-ADD     EDATD         ULMDAT                                        LLN01
      *                                                                   161718
      *   Determine maturity category for maturity date                   161718
     C                   CALL      'BY9060'                                                    16171
     C                   PARM      ULMDAT        ULDAYN                         Input date     16171
     C                   PARM      *BLANK        ULMCAT                         Category type  16171
     C                   PARM      0             ULMPER                         Category period16171
     C                   PARM      *BLANK        ULRTCD                         Return code    16171
      *                                                                   161718
     C                   Z-ADD     0             ULMKDC                                        LLN01
     C                   Z-ADD     0             ULMXDD                                        LLN01
     C                   Z-ADD     0             ULMKCC                                        LLN01
     C                   Z-ADD     0             ULMXCD                                        LLN01
      *                                                                   LLN012
      * New extract record                                                LLN012
     C**                   MOVE 'N'       L8BTEX                    LLN012161718
     C                   MOVE      'N'           ULBTEX                                        16171
     C                   MOVE      'Y'           ULLREX                                        16171
      *
      ** Set-up event type
     C**********           MOVE 'P'       ULETYP                          161718
     C                   MOVE      'I'           ULETYP                                        16171
      *                                                                   LLN012
      * Report/Extract details                                            LLN012
     C                   EXSR      #LRPXT                                                      LLN01
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
     C                   ENDIF                                                                 LLN01
      *                                                                   164680
     C                   ENDIF                                                                 16468
      *                                                                   LLN012
     C     DLNO          READE     BYEVNTL0                               99                   LLN01
     C                   ENDDO                                                                 LLN01
      *                                                                   LLN012
     C                   ENDIF                                                                 16410
      *                                                                   164103
     C                   ENDIF                                                                 LLN01
      *
     C     MMEND         TAG
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LMMFM - Format Work Field For MM Deal                        *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:      SR/#LPROC - Format Common Work Fields             *
      *                                                               *
      *****************************************************************
     C     #LMMFM        BEGSR                                                  ** SR/#LMMFM**
      *
      *   If deal is forward valued product code is always 7800
     C     VDAT          IFGT      L0RPDT
     C     ULPCOD        ANDNE     9998                                                        16285
     C     ULPCOD        ANDNE     9999                                                        16285
     C***                  Z-ADD7800      ULPCOD                          164103
     C                   Z-ADD     7805          ULPCOD                                        16410
     C                   ENDIF
      *
      *  Initialise work fields
     C**********           Z-ADDCNUM      ULCNUM           Deal Customer                      CSD027
     C                   MOVE      CNUM          ULCNUM                         Deal Customer
     C                   MOVE      CCY           ULCYCD                         Currency
     C     RCDC          IFEQ      15
     C                   Z-ADD     PCPL          ULCUAS                         Loan amount
     C                   ELSE
     C                   Z-SUB     PCPL          ULCUAS                         Deposit amount
     C                   ENDIF
     C                   Z-ADD     VDAT          ULVDAT                         Value date
     C                   MOVE      'Y'           ULINTB                         Interest bearing
     C                   MOVE      'MM'          ULMMOD                         Module id.
      *  If deal type is a call deposit or call loan calculate
      *  maturity date and category if not yet entered for deal
     C     DTYP          IFEQ      'CD'
     C***        MDAT      ANDNE0                                         164103
     C     MDAT          ANDEQ     0                                                           16410
     C     DTYP          OREQ      'CL'
     C***        MDAT      ANDNE0                                         164103
     C     MDAT          ANDEQ     0                                                           16410
     C                   EXSR      #LNOTD
     C                   ELSE
     C                   Z-ADD     MDAT          ULMDAT                         Maturity datw
     C                   ENDIF
      *   Determine maturity category for maturity date
     C                   CALL      'BY9060'
     C                   PARM      ULMDAT        ULDAYN                         Input date
     C                   PARM      *BLANK        ULMCAT                         Category type
     C                   PARM      0             ULMPER                         Category period date
     C                   PARM      *BLANK        ULRTCD                         Return code
     C     ULRTCD        IFNE      *BLANK
     C                   MOVEL     '*NONE'       ULKEY                          ************
     C                   MOVEL     'BY9060  '    ULFILE                         * DBERR 08 *
     C                   Z-ADD     8             ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *  Default credit type
     C     RCDC          IFEQ      15                                                          12183
     C                   MOVE      '9'           ULCTYP                                        12183
     C                   ENDIF                                                                 12183
      *
      *  Internal sight time/deposit for deposit type deals
     C     L2ISTD        IFEQ      'Y'
     C     RCDC          ANDEQ     16
      *
      *
      *   Sight/time analys applies to product code 2210 and 2250
     C     ULPCOD        IFEQ      2210
     C     ULPCOD        OREQ      2250
      *                                                                   155903
      * If deal is inserted today backvalued determine overnight          155903
     C                   MOVE      'N'           ULOVNG            1                           15590
     C     ULVDAT        IFLE      BJRDNB                                                      15590
     C     ULMDAT        ANDLE     BJRDNB                                                      15590
     C     ULMDAT        ANDNE     0                                                           15590
     C                   Z-ADD     1             ULFWDY                                        15590
     C                   CALL      'ZFWDT'                                                     15590
     C                   PARM      ULVDAT        ULDAYN                                        15590
     C                   PARM                    ULFWDY                                        15590
     C                   PARM                    ULFDAY                                        15590
     C                   PARM                    ULCYCD                                        15590
     C                   PARM      *BLANK        ULLOCN                                        15590
     C     ULFDAY        IFEQ      ULMDAT                                                      15590
     C                   MOVE      'Y'           ULOVNG            1                           15590
     C                   ENDIF                                                                 15590
     C                   ENDIF                                                                 15590
      *
      *   Set product code as follows:
      *    2210 - Sight deposit if an overnight deal
      *    2250 - Time deposit for longer deal
     C     ULMCAT        IFEQ      'A'
     C     ULVDAT        ANDEQ     BJRDNB
     C     ULOVNG        OREQ      'Y'                                                         15590
     C     DTYP          OREQ      'CD'
     C     NOTD          ANDEQ     0
     C                   MOVE      '2210'        ULPCOD
     C                   ELSE
     C                   MOVE      '2250'        ULPCOD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      *  Get maximum DR/CR details
     C     DLNO          CHAIN     BYDLDCPP                           90
     C     *IN90         IFEQ      '0'
     C                   Z-ADD     LMKDC         ULMKDC
     C                   Z-ADD     LSMXD         ULSMXD
     C                   Z-ADD     LMXDD         ULMXDD
     C                   Z-ADD     LMKCC         ULMKCC
     C                   Z-ADD     LSMXC         ULSMXC
     C                   Z-ADD     LMXCD         ULMXCD
     C                   ENDIF
      *
      *
      *  Item is to be netted if customer and product code
      *  MM netting flags are set to 'Y'
     C*****ULPCOD        CHAIN     BYPRODPP                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :ULPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C                   SETOFF                                       90                    MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   SETON                                        90                    MD058068
     C                   ENDIF                                                              MD058068
     C********** *IN90     IFEQ *OFF                                      LLN016
     C********** LMMNT     ANDEQ'Y'                                       LLN016
     C********** LDMMNT    ANDEQ'Y'                                       LLN016
     C**********           MOVE 'Y'       ULNETI                          LLN016
     C**********           ENDIF                                          LLN016
      *
      *  Perform common processing for all deal types
     C                   EXSR      #LPROC
      *                                                                   164103
      ** Set BT and LR extract flags for forward valued items             164103
     C     VDAT          IFGT      L0RPDT
     C***********ULMDAT    IFLT L0LRDT                              164103168646
     C     ULMDAT        IFLE      L0LRDT                                                      16864
     C                   MOVE      'N'           ULBTEX                                        16410
     C                   MOVE      'Y'           ULLREX                                        16410
     C                   ELSE                                                                  16410
     C                   MOVE      'Y'           ULBTEX                                        16410
     C                   MOVE      'N'           ULLREX                                        16410
     C                   ENDIF                                                                 16410
     C                   ENDIF                                                                 16410
      *
      ** Set-up event type
     C                   MOVE      'P'           ULETYP
      *
      *                                                                   184282
      * Set extracted maturity date to 0 for call/notice deals where      184282
      * the maturity date for the deal is zero.                           184282
     C     DTYP          IFEQ      'CD'                                                        18428
     C     MDAT          ANDEQ     0                                                           18428
     C     DTYP          OREQ      'CL'                                                        18428
     C     MDAT          ANDEQ     0                                                           18428
     C                   Z-ADD     0             ULMDAT                         Maturity datw  18428
     C                   ENDIF                                                                 18428
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LMMF2 - Format Work Field For Forward Valued Loans           *
      *                                                               *
      * Called by:  SR/#LMMDL - MM Deal Processing                    *
      *                                                               *
      * Calls:      SR/#LPROC - Format Common Work Fields             *
      *                                                               *
      *****************************************************************
     C     #LMMF2        BEGSR                                                  ** SR/#LMMF2**
      *
      *  Create extract record with Forward Commitments product code
     C     RCDC          IFEQ      15                                                          16410
     C                   MOVE      '7800'        ULPCOD
     C                   ELSE                                                                  16410
     C                   MOVE      '7805'        ULPCOD                                        16410
     C                   ENDIF                                                                 16410
      *
      *  Determine maturity category for value date
     C                   CALL      'BY9060'
     C                   PARM      ULVDAT        ULDAYN                         Input date
     C                   PARM      *BLANK        ULMCAT                         Category type
     C                   PARM      0             ULMPER                         Category period date
     C                   PARM      *BLANK        ULRTCD                         Return code
     C     ULRTCD        IFNE      *BLANK
     C                   MOVEL     '*NONE'       ULKEY                          ************
     C                   MOVEL     'BY9060  '    ULFILE                         * DBERR 09 *
     C                   Z-ADD     9             ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *  Reverse sign of amount
     C                   Z-SUB     ULCUAS        ULCUAS
     C                   Z-SUB     ULSGAM        ULSGAM
      *                                                                   164103
      ** Set BT and LR extrcat flags for forward valued items             164103
     C***********ULVDAT    IFLT L0LRDT                              164103168646
     C     ULVDAT        IFLE      L0LRDT                                                      16864
     C                   MOVE      'N'           ULBTEX                                        16410
     C                   MOVE      'Y'           ULLREX                                        16410
     C                   ELSE                                                                  16410
     C                   MOVE      'Y'           ULBTEX                                        16410
     C                   MOVE      'N'           ULLREX                                        16410
     C                   ENDIF                                                                 16410
      *
      ** Set-up event type
     C                   MOVE      'P'           ULETYP
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LNOTD - Calculate Maturity Date & Category For Call Deals *
      *                                                               *
      * Called by:  SR/#LMMFM - Format MM Deal Details                *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #LNOTD        BEGSR                                                  ** SR/#LNOTD**
      *
      *  Determine start of maturity period of call notice deal
     C     L0RPDT        IFGT      VDAT
     C                   Z-ADD     L0RPDT        ULFDAY
     C                   ELSE
     C                   Z-ADD     VDAT          ULFDAY
     C                   ENDIF
      *
      *  Adjust notice days if zero or 1 notice days
     C     NOTD          IFEQ      0
     C     NOTD          OREQ      1
     C     NOTD          ADD       1             ULNOTD
     C                   ELSE
     C                   Z-ADD     NOTD          ULNOTD
     C                   ENDIF
      *
      *  Calculate maturity based on no. of working days forward
      *   (As ZFWDT can only cope with a maximum of 99 days forward
      *    include processing if notice days is greater than 99)
     C     ULNOTD        DOULE     99
     C     ULNOTD        IFGT      99
     C                   Z-ADD     99            ULFWDY
     C                   SUB       99            ULNOTD
     C                   ELSE
     C                   Z-ADD     ULNOTD        ULFWDY
     C                   ENDIF
     C                   CALL      'ZFWDT'
     C                   PARM      ULFDAY        ULDAYN
     C                   PARM                    ULFWDY
     C                   PARM                    ULFDAY
     C                   PARM                    ULCYCD
     C                   PARM      *BLANK        ULLOCN
     C                   ENDDO
      *
      *   Set maturity date to calculated forward date
     C                   Z-ADD     ULFDAY        ULMDAT
      *                                                                   164103
      *                                                                   164103
      **  Calculate accrued interest if LR is on                          164103
     C                   Z-ADD     0             ULTINT           13 0                         16410
     C     LLN012        IFEQ      'Y'                                                         16410
     C                   Z-ADD     IACD          ZIBEG                                         16410
     C     IACD          IFEQ      0                                                           16410
     C                   Z-ADD     VDAT          ZIBEG                                         16410
     C                   ENDIF                                                                 16410
     C                   Z-ADD     ULMDAT        ZIEND                                         16410
     C                   Z-ADD     ICBS          ZICALC                                        16410
     C                   Z-ADD     PCPL          ZIAMT                                         16410
     C                   Z-ADD     INTR          ZIRATE                                        16410
     C                   EXSR      GLINTC                                                      16410
     C     ZINTR         ADD       AITC          ULTINT                                        16410
     C                   ADD       AIAN          ULTINT                                        16410
     C                   ADD       AIAP          ULTINT                                        16410
     C                   SUB       IPRD          ULTINT                                        16410
     C                   SUB       ICTD          ULTINT                                        16410
     C                   ENDIF                                                                 16410
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LNADL - Select NA's Purchased For Processing                 *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:  SR/#LVALD - Validate Deal Details                     *
      *         SR/#LNAFM - Format NA Deal Details                    *
      *         SR/#LRPXT - Report/Extract Details                    *
      *                                                               *
      *****************************************************************
     C     #LNADL        BEGSR                                                  ** SR/#LMMDL**
      *
      ***Process deals if value date is before or equal to extract date   162321
     C***        VDAT      IFLE L0RPDT                                    162321
      *
      *  Validate customer and deal details for extract
     C**********           Z-ADDISCN      ULCNUM           Customer                           CSD027
     C                   MOVE      ISCN          ULCNUM                         Customer
     C                   EXSR      #LVALD
      *
      *  Format work fields for deal
     C                   EXSR      #LNAFM
      *                                                                   162321
      *  Process deals if value date is before or equal to extract date   162321
     C     VDAT          IFLE      L0RPDT                                                      16232
      *
      *  Report/Extract NA's deal details
     C                   EXSR      #LRPXT
      *
     C                   ENDIF
      *                                                                   162321
      *                                                                   162321
      * If CAR LLN012 is on, extract interest events on deals             162321
     C     LLN012        IFEQ      'Y'                                                         16232
     C     ULPCOD        ANDNE     9998                                                        16232
     C     ULPCOD        ANDNE     9999                                                        16232
     C     ULVALD        ANDEQ     'Y'                                                         16232
      *                                                                   162321
      *  Set BT/LR extract flags                                          162321
     C                   MOVE      'N'           ULBTEX                                        16232
     C                   MOVE      'Y'           ULLREX                                        16232
      *                                                                   162321
      *  Set-up event type                                                162321
     C                   MOVE      'I'           ULETYP                                        16232
      *                                                                   162321
      * Obtain all outstanding events for the deal                        162321
     C     DLNO          SETLL     BYEVNTL0                                                    16232
     C     DLNO          READE     BYEVNTL0                               99                   16232
     C     *IN99         DOWEQ     *OFF                                                        16232
      *                                                                   162321
      *                                                                   162321
      ** Do not process inter branch events                               162321
     C     IBRE          IFNE      'Y'                                                         16232
      *                                                                   162321
      * Generate an extra extract if an interest event is read            162321
     C     ETYPD         IFEQ      '17I2'                                                      16232
     C     ETYPD         OREQ      '17M2'                                                      16232
      *                                                                   162321
      ***********ent date is less than LR extract date              162321168646
      * ...AND event date is less than or equal LR extract date           168646
     C***********EDATD     IFLT L0LRDT                              162321168646
     C     EDATD         IFLE      L0LRDT                                                      16864
     C     VDAT          ANDLE     L0RPDT
      *                                                                   162321
      * Set up extract details...                                         162321
     C                   Z-ADD     EAMTD         ULCUAS                                        16232
      *                                                                   162321
      *  Convert amount to sterling                                       162321
     C     ULCYCD        IFEQ      BLCYCD                                                      16232
     C                   Z-ADD     ULCUAS        ULSGAM                                        16232
     C                   ELSE                                                                  16232
     C                   CALL      'BY9070'                                                    16232
     C                   PARM      ULCUAS        ULINAM                                        16232
     C                   PARM      ULCYCD        ULFCCY                                        16232
     C                   PARM      *ZERO         ULOTAM                                        16232
     C                   PARM      BLCYCD        ULTCCY                                        16232
     C                   PARM      *BLANK        ULRTCD                                        16232
     C     ULRTCD        IFNE      ' '                                                         16232
     C     *LOCK         IN        LDA                                                         16232
     C                   MOVEL     ULPGMN        DBPGM                          ************   16232
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 25 *   16232
     C                   MOVEL     'BY9070  '    DBFILE                         ************   16232
     C                   Z-ADD     25            DBASE                                         16232
     C                   OUT       LDA                                                         16232
     C                   EXSR      *PSSR                                                       16232
     C                   ENDIF                                                                 16232
     C                   Z-ADD     ULOTAM        ULSGAM                                        16232
     C                   ENDIF                                                                 16232
      *                                                                   162321
     C                   Z-ADD     EDATD         ULMDAT                                        16232
      *                                                                   162321
      *   Determine maturity category for maturity date                   162321
     C                   CALL      'BY9060'                                                    16232
     C                   PARM      ULMDAT        ULDAYN                         Input date     16233
     C                   PARM      *BLANK        ULMCAT                         Category type  16232
     C                   PARM      0             ULMPER                         Category period16232
     C                   PARM      *BLANK        ULRTCD                         Return code    16232
      *                                                                   162321
     C                   Z-ADD     0             ULMKDC                                        16232
     C                   Z-ADD     0             ULMXDD                                        16232
     C                   Z-ADD     0             ULMKCC                                        16232
     C                   Z-ADD     0             ULMXCD                                        16232
      *                                                                   162321
      * New extract record                                                162321
     C                   MOVE      'N'           ULBTEX                                        16232
     C                   MOVE      'Y'           ULLREX                                        16232
      *                                                                   162321
      ** Set-up event type                                                162321
     C                   MOVE      'I'           ULETYP                                        16232
      *                                                                   162321
      * Report/Extract details                                            162321
     C                   EXSR      #LRPXT                                                      16232
     C                   ENDIF                                                                 16232
      *                                                                   162321
     C                   ENDIF                                                                 16232
      *                                                                   162321
     C                   ENDIF                                                                 16232
      *                                                                   162321
     C     DLNO          READE     BYEVNTL0                               99                   16232
     C                   ENDDO                                                                 16232
      *                                                                   162321
     C                   ENDIF                                                                 16232
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LNAFM - Format Work Fields For NA's Purchased                *
      *                                                               *
      * Called by:  SR/#LNADL - NA's Purchased Processing             *
      *                                                               *
      * Calls:      SR/#LPROC - Format Common Work Fields             *
      *                                                               *
      *****************************************************************
     C     #LNAFM        BEGSR                                                  ** SR/#LNAFM**
      *
     C                   MOVE      CCY           ULCYCD                         Currency
     C***        BNNAIA    IFEQ 'Y'                                       LLN014
     C     LFACE         IFEQ      'Y'                                                         LLN01
     C                   Z-ADD     FVAL          ULCUAS                         Currency amount
     C                   ELSE
     C*                                                                   LLN014
     C** Calculate No. Days Passed Since Value Date                       LLN014
     C     L0RPDT        SUB       VDAT          ULDAYS            5 0                         LLN01
     C*                                                                   LLN014
     C** Include Report Date in processing                                LLN014
     C                   ADD       1             ULDAYS                                        LLN01
     C*                                                                   LLN014
     C** Calculate Maturity Period                                        LLN014
     C     MDAT          SUB       VDAT          ULPERD            5 0                         LLN01
     C*                                                                   LLN014
     C** Calculate Amortised Discount Amount                              LLN014
     C     DISA          MULT      ULDAYS        ULAMDA           13 0                         LLN01
     C     ULAMDA        DIV       ULPERD        ULAMDA                                        LLN01
     C*                                                                   LLN014
     C** Overwrite Currency Amount                                        LLN014
     C                   Z-ADD     PUPR          ULCUAS                         Currency amount
     C                   ADD       ULAMDA        ULCUAS                                        LLN01
     C                   ENDIF
      *                                                                   LLN014
      *                                                                   LLN014
     C     ULPCOD        IFGE      3500                                         Liability
     C     ULPCOD        ANDLE     3990
     C                   Z-SUB     ULCUAS        ULCUAS
     C                   ENDIF
     C                   Z-ADD     VDAT          ULVDAT                         Value date
     C                   Z-ADD     MDAT          ULMDAT                         Maturity datw
      *
      ** If record exists on extension file, and final maturity-date      LLN012
      ** is non-zero, then maturity date is set to final maturity-date    LLN012
     C********** DLNO      CHAINDEALDY9              90                   LLN016LLN012
     C     DLNO          CHAIN     BYNASPY0                           90                       LLN01
     C     *IN90         IFEQ      '0'                                                         LLN01
     C     LFMAT         ANDNE     *ZERO                                                       LLN01
      *                                                                                       LLN022
      ** Convert the final maturity date to day number before                                 LLN022
      ** moving it to ULMDAT                                                                  LLN022
      *                                                                                       LLN022
     C                   CALL      'ZDATE1'
     C                   PARM                    PZERR             7
     C                   PARM      LFMAT         PZDATE            6 0
     C                   PARM      BJDFIN        PDATFM            1
     C                   PARM      *ZERO         PZDAYN            5 0
     C                   Z-ADD     PZDAYN        ULMDAT
     C**********           Z-ADDLFMAT     ULMDAT                                       LLN012 LLN022
     C                   ENDIF                                                                 LLN01
      *
     C                   MOVE      'Y'           ULINTB                         Interest bearing
     C                   MOVE      'MM'          ULMMOD                         Module id.
      *   Determine maturity category for maturity date
     C                   CALL      'BY9060'
     C                   PARM      ULMDAT        ULDAYN                         Input date
     C                   PARM      *BLANK        ULMCAT                         Category type
     C                   PARM      0             ULMPER                         Category period date
     C                   PARM      *BLANK        ULRTCD                         Return code
     C     ULRTCD        IFNE      *BLANK
     C                   MOVEL     '*NONE'       ULKEY                          ************
     C                   MOVEL     'BY9060  '    ULFILE                         * DBERR 10 *
     C                   Z-ADD     10            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *  Perform common processing for all deal types
     C                   EXSR      #LPROC
      *
      ** Set-up event type
     C                   MOVE      'P'           ULETYP
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LRSET - Reset Work Fields                                 *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #LRSET        BEGSR                                                  ** SR/#LRSET**
      *
      *   Clear file formats to reset fields
     C                   CLEAR                   BYDLEXD0                       Deal extract details
     C                   CLEAR                   BYDLDCD0                       MM maximum dr/cr pos
      *
      *   Reset all extract details work fields
     C                   MOVE      *BLANK        ULVCAT                         Value date cat.
     C                   MOVE      *BLANK        ULMCAT                         Maturity date cat.
     C                   MOVE      *BLANK        ULCYCD                         Currency
     C                   MOVE      *BLANK        ULINTB                         Interest bearing
     C**********           MOVE *BLANK    ULNETI           Netting indicator                LLN016
     C                   MOVE      '0'           ULCTYP                         Credit type
     C**********           Z-ADD0         ULCNUM           Customer                           CSD027
     C                   MOVE      *BLANKS       ULCNUM                         Customer
     C                   Z-ADD     0             ULVDAT                         Value date
     C                   Z-ADD     0             ULMDAT                         Maturity date
     C                   Z-ADD     0             ULPCOD                         Product code
     C                   Z-ADD     0             ULMKDC
     C                   Z-ADD     0             ULSMXD
     C                   Z-ADD     0             ULMXDD
     C                   Z-ADD     0             ULMKCC
     C                   Z-ADD     0             ULSMXC
     C                   Z-ADD     0             ULMXCD
     C                   Z-ADD     0             ULCUAS                         Extract ccy amount
     C                   Z-ADD     0             ULSGAM                         Extract GBP amount
     C                   Z-ADD     0             ULDRVT                         Derivative type
     C                   Z-ADD     0             ULSMKV
      *
      *   Reset all general work fields
     C                   MOVE      *BLANK        ULDATA                         Date - DDMMMYY
     C                   MOVE      *BLANK        ULLOCN                         Location
     C                   MOVE      *BLANK        ULAMTA                         Edited amount field
     C                   MOVE      *BLANK        ULECOD                         Edit code
     C                   MOVE      *BLANK        ULMMOD                         Module id.
     C                   Z-ADD     0             ULDAYN                         Date - Midas day no.
     C                   Z-ADD     0             ULDATE                         Date - DDMMYY
     C                   Z-ADD     0             ULSDAY                         Spot date
     C                   Z-ADD     0             ULFDAY                         Future date
     C                   Z-ADD     0             ULFWDY                         No. of days forward
     C                   Z-ADD     0             ULAMNT                         Amount field
     C                   Z-ADD     0             ULFAMT                         Future amount
     C                   Z-ADD     0             ULPAMP                         Net present purchase
     C                   Z-ADD     0             ULPAMS                         Net present sale
     C                   Z-ADD     0             ULINAM                         In amount
     C                   Z-ADD     0             ULOTAM                         Converted amount
     C                   Z-ADD     0             ULNOTD                         Notice days
     C                   Z-ADD     0             ULNBDP                         No. of decimal place
     C                   Z-ADD     0             ULTINT                                        16410
      *
      **  Reset BT and LR flags for new deal                              161718
     C                   MOVE      'Y'           ULBTEX                                        16171
     C                   MOVE      'N'           ULLREX                                        16171
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LSFWD - Determine Forward Valued Date For FX Deals        *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #LSFWD        BEGSR                                                  ** SR/#LSFWD**
      *
      *   Reset forward date field
     C                   Z-ADD     0             ULFWDP            5 0          Purchase ccy
     C                   Z-ADD     0             ULFWDS            5 0          Sale ccy
     C                   Z-ADD     0             ULSFWD
      *
      *  Get spot days for purchase currency
     C                   MOVE      PUCY          ULCYCD
     C                   EXSR      #LCCYD
      *
      *  Calculate spot forward date for FX deal purchase currency
     C                   Z-ADD     A6SPDY        ULFWDY
     C                   CALL      'ZFWDT'
     C                   PARM      DDAT          ULDAYN
     C                   PARM                    ULFWDY
     C                   PARM                    ULFDAY
     C                   PARM                    ULCYCD
     C                   PARM      *BLANK        ULLOCN
     C                   Z-ADD     ULFDAY        ULFWDP
     C                   ADD       14            ULFWDP
      *
      *  Get spot days for sale currency
     C                   MOVE      SLCY          ULCYCD
     C                   EXSR      #LCCYD
      *
      *  Calculate spot forward date for FX deal sale currency
     C                   Z-ADD     A6SPDY        ULFWDY
     C                   CALL      'ZFWDT'
     C                   PARM      DDAT          ULDAYN
     C                   PARM                    ULFWDY
     C                   PARM                    ULFDAY
     C                   PARM                    ULCYCD
     C                   PARM      *BLANK        ULLOCN
     C                   Z-ADD     ULFDAY        ULFWDS
     C                   ADD       14            ULFWDS
      *
      *  Use later of purchase and sale currency dates
     C     ULFWDP        IFGT      ULFWDS
     C                   Z-ADD     ULFWDP        ULSFWD
     C                   ELSE
     C                   Z-ADD     ULFWDS        ULSFWD
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LCCYD - Get Currency Details                              *
      *                                                               *
      * Called by:  SR/#LSFWD - Determine Forward Valued FX Deals     *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #LCCYD        BEGSR                                                  ** SR/#LCCYD**
      *
      *  Get currency details for currency being processed
     C                   Z-ADD     1             #
     C     ULCYCD        LOOKUP    @CCY(#)                                90
     C     *IN90         IFEQ      *ON                                          Currency found
     C     #             OCCUR     SDCURR
     C                   ELSE
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    ULCYCD
     C                   PARM                    DSSDY
     C     P@RTCD        IFNE      *BLANK                                                   l
     C                   MOVEL     ULCYCD        ULKEY                          ************
     C                   MOVEL     'SDCURRPD'    ULFILE                         * DBERR 23 *
     C                   Z-ADD     23            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
     C     200           OCCUR     SDCURR
     C                   MOVE      DSSDY         SDCURR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LPROC - Common Processing For All Deal Types              *
      *                                                               *
      * Called by:  SR/#LABFD - Format Arbritrage Deal Deposit Details*
      *             SR/#LABFL - Format Arbritrage Deal Loan Details   *
      *             SR/#LFWFP - Format Forward FX Purchase Details    *
      *             SR/#LFWFS - Format Forward FX Sale Details        *
      *             SR/#LFXFP - Format FX Purchase Details            *
      *             SR/#LFXFS - Format FX Sale Details                *
      *             SR/#LMMFM - Format MM Deal Details                *
      *             SR/#LMMF2 - Format Forward Loan Details           *
      *             SR/#LNAFM - Format NA Deal Details                *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #LPROC        BEGSR                                                  ** SR/#LPROC**
      *
      *  Get currency details for currency being processed
     C                   Z-ADD     1             #
     C     ULCYCD        LOOKUP    @CCY(#)                                90
     C     *IN90         IFEQ      *ON                                          Currency found
     C     #             OCCUR     SDCURR
     C                   ELSE
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    ULCYCD
     C                   PARM                    DSSDY
     C     P@RTCD        IFNE      *BLANK                                                   l
     C                   MOVEL     ULCYCD        ULKEY                          ************
     C                   MOVEL     'SDCURRPD'    ULFILE                         * DBERR 11 *
     C                   Z-ADD     11            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
     C     200           OCCUR     SDCURR
     C                   MOVE      DSSDY         SDCURR
     C                   ENDIF
      *
      *   Convert amount into sterling if not sterling
     C     ULCYCD        IFNE      BLCYCD
     C     ULCUAS        IFLT      0
     C                   Z-SUB     ULCUAS        ULINAM
     C                   ELSE
     C                   Z-ADD     ULCUAS        ULINAM
     C                   ENDIF
     C                   CALL      'BY9070'
     C                   PARM                    ULINAM                         Input amount
     C                   PARM      ULCYCD        ULFCCY                         From currency
     C     ULSGAM        PARM                    ULOTAM                         Converted amount
     C                   PARM      BLCYCD        ULTCCY                         To currency
     C                   PARM      *BLANK        ULRTCD                         Return code
     C     ULRTCD        IFNE      ' '
     C                   MOVEL     '*NONE '      ULKEY                          ************
     C                   MOVEL     'BY9070  '    ULFILE                         * DBERR 12 *
     C                   Z-ADD     12            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
     C     ULCUAS        IFLT      0
     C                   Z-SUB     ULSGAM        ULSGAM
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     ULCUAS        ULSGAM                         Sterling amount
     C                   ENDIF
      *
      *  Get Book/Trading indicator
     C*********  BOKC      CHAINSDBOOKY9             90                                     LLN016
     C     BOKC          CHAIN     BYBOOKY0                           90
     C     *IN90         IFEQ      *OFF
     C                   MOVE      LTRDI         ULRTYP
     C                   ELSE
     C                   MOVE      'B'           ULRTYP
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LVALD - Validate Details For Extract                         *
      *                                                               *
      * Called by:  SR/#LABDL - Arbitrage Deal Processing             *
      *             SR/#LFWDL - Forward FX Deal Processing            *
      *             SR/#LFXDL - FX Deal Processing                    *
      *             SR/#LMMDL - MM Deal Processing                    *
      *             SR/#LNADL - NA's Deal Processing                  *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #LVALD        BEGSR                                                  ** SR/#LVALD**
      *
      *  Validate customer and retrieve details if customer has changed
     C     ULCNUM        IFNE      ULPCUS
     C                   MOVE      ULCNUM        ULCUST
     C                   CALL      'BY9110'
     C                   PARM                    ULCUST                         Customer number
     C                   PARM      *BLANK        SDCUST                         SDCUSTPD details
     C                   PARM      *BLANK        SDCUS7                         SDCUSTX7 details
     C                   PARM      *BLANK        SDCUSX                         Extra details
     C                   PARM      0             ULERR1
     C                   PARM      *BLANK        ULRTCD                         Return code
     C     ULRTCD        IFNE      *BLANK
     C                   MOVEL     '*NONE '      ULKEY                          ************
     C                   MOVEL     'BY9110  '    ULFILE                         * DBERR 13 *
     C                   Z-ADD     13            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *  Save customer
     C**********           Z-ADDULCNUM    ULPCUS           Previous customer                  CSD027
     C                   MOVE      ULCNUM        ULPCUS                         Previous customer
     C                   ENDIF
      *
      *
      *  Set report indicators (*IN31 to *IN37) with returned settings
     C     ULERR1        IFNE      0
     C                   MOVE      'N'           ULVALD                         Invalid
     C                   ELSE
     C                   MOVE      'Y'           ULVALD                         Valid deal
     C                   ENDIF
      *
      *
      *  Check extract criteria exists for deal
      *  (Not required for FX deals )
     C     RCDT          IFNE      'B'
     C     DTYP          OREQ      'PS'
     C                   MOVE      DTYP          K1DTYP
     C                   MOVE      DLST          K1DLST
     C**********           MOVE BBLINC    K1LINS                                             LLN016
     C                   MOVE      LLINC         K1LINS
     C                   MOVE      BBLICD        K1LICD
      *                                                                                      LLN021
      *  Check extract criteria exists using Industry code                                   LLN021
     C     K1DLEX        CHAIN     BYDLEXPP                           90
     C     *IN90         IFEQ      *ON
     C                   MOVE      *BLANKS       K1LICD
     C                   END
      *                                                                                      LLN021
     C     *IN90         IFEQ      *ON
     C     K1DLEX        CHAIN     BYDLEXPP                           90
     C     *IN90         IFEQ      *ON
     C                   Z-ADD     0             K1LINS
     C     K1DLEX        CHAIN     BYDLEXPP                           90
     C                   ENDIF
     C                   ENDIF
     C*                                                                                      LLN021
     C     *IN90         IFEQ      *ON
     C                   Z-ADD     9999          ULPCOD
     C                   ELSE
     C                   Z-ADD     L2PCOD        ULPCOD
     C                   ENDIF
      *
      *   Validate Product Code
      *      Currency must be sterling if product code is 1550 or 1595
     C     ULPCOD        IFEQ      1550
     C     ULCYCD        ANDNE     BLCYCD
     C     ULPCOD        OREQ      1595
     C     ULCYCD        ANDNE     BLCYCD
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LRPXT - Report/Extract Processing                         *
      *                                                               *
      * Called by:  SR/#LABDL - Arbitrage Deal Processing             *
      *             SR/#LFWDL - Forward FX Deal Processing            *
      *             SR/#LFXDL - FX Deal Processing                    *
      *             SR/#LMMDL - MM Deal Processing                    *
      *             SR/#LNADL - NA's Deal Processing                  *
      *                                                               *
      * Calls:      SR/#LRPT1 - Report Valid Details to BY2020P1      *
      *             SR/#LRPT2 - Report Valid Details to BY2020P2      *
      *             SR/#LXTRC - Create Extract Record                 *
      *                                                               *
      *****************************************************************
     C     #LRPXT        BEGSR                                                  ** SR/#LRPXT**
      *
      *  Do not report/extract details for product code 9998
     C     ULPCOD        IFNE      9998
      *
      *  Details are valid - report details to BY2020P1
     C     ULVALD        IFEQ      'Y'
     C     ULPCOD        ANDNE     9999
      *
      *    Report details to BY2020P1
     C     RECI          IFEQ      'D'
     C                   EXSR      #LRPT1
     C                   ENDIF
      *
      *    Create extract record if extract mode
     C     ULMODE        IFEQ      'EXTRACT'
     C                   EXSR      #LXTRC
     C                   ENDIF
      *
      *  Details are invalid - report details to BY2020P2
     C                   ELSE
     C     RECI          IFEQ      'D'
     C                   EXSR      #LRPT2
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C***********ULPCOD    IFNE 9998                                       LLN021
     C     ULPCOD        IFEQ      9998                                                         LLN0
     C                   MOVEL     'Y'           MBFLAG            1                            LLN0
     C                   EXSR      #LXTRC                                                       LLN0
     C                   MOVEL     ' '           MBFLAG            1                            LLN0
     C                   END                                                                    LLN0
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LXTRC - Create Extract Record                                *
      *                                                               *
      * Called by: Sr/#LRPXT - Report/Extract Details                 *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #LXTRC        BEGSR                                                  ** SR/#LXTRC**
      *
      *  Set up detail fields for report
     C                   MOVE      ULRTYP        L8RTYP                         Record type
     C                   Z-ADD     ULPCOD        L8PCOD                         Product code
     C**********           Z-ADDULCNUM    L8CUST           Customer                           CSD027
     C                   MOVE      ULCNUM        L8CUST                         Customer
     C                   MOVE      ULCYCD        L8CYCD                         Currency
     C                   MOVEL     DLNO          L8TRAN                         Transaction referenc
     C                   MOVE      ULBRCA        L8BRCD                         Branch code
     C                   MOVE      ULMMOD        L8MMOD                         Module id.
     C                   Z-ADD     DDAT          L8DDAT                         Deal date
     C                   Z-ADD     ULVDAT        L8VDAT                         Value date
     C                   Z-ADD     ULMDAT        L8MDAT                         Maturity date
     C                   MOVE      ULMCAT        L8MCAT                         Maturity category
     C                   MOVE      ULLISO        L8ISOC                         Customer country cod
     C                   MOVE      ULCISO        L8RISO                         Risk country code
     C**********           MOVE BBLICD    L8LIND           Industry code                     LLN016
     C**********           MOVE BBLINC    L8LINS           Institution code                  LLN016
     C                   MOVE      LLICD         L8LIND                         Industry code
     C                   MOVE      LLINC         L8LINS                         Institution code
     C                   MOVE      A6SWCY        L8CCYS                         SWIFT Currency code
     C     A6SWCY        IFEQ      BLCYCD
     C                   MOVE      'N'           L8NNSI                         Sterling ccy ind.
     C                   ELSE
     C                   MOVE      'Y'           L8NNSI
     C                   ENDIF
     C                   Z-ADD     ULCUAS        L8CUAS                         Currency amount
     C                   Z-ADD     ULSGAM        L8SGAM                         Sterling equivalent
     C                   Z-ADD     ULSMKV        L8SMKV                         Market value
     C                   MOVE      LSIOF         L8SIO                          SIO indicator
     C                   MOVE      ULINTB        L8INTB                         Interest bearing ind
     C                   MOVE      BBCSSN        L8CSSN                         Customer shortname
     C                   SELECT
     C     LUPAR         WHENNE    *BLANK
     C                   MOVE      LUPAR         L8PCNB                         Ultimate parent
     C     BBPCNB        WHENNE    *BLANK
     C                   MOVE      BBPCNB        L8PCNB                         Customer parent
     C                   OTHER
     C                   MOVE      BBCUST        L8PCNB                         Use customer no.
     C                   ENDSL
     C                   MOVE      '0'           L8DTYP                         Deposit type
     C                   MOVE      LELGF         L8ELIG                         Eligibility flag
     C                   MOVE      ULRWCD        L8RWCD                         Risk weighting code
     C**********           MOVE ULNETI    L8NETI           Netting indicator                 LLN016
     C                   MOVE      LHASI         L8HAIN                         Housing association
     C                   MOVE      ULDRVT        L8DRVT                         Derivative type
     C                   MOVE      LCNTP         L8CNTP                                        LLN01
     C                   MOVE      '00'          L8GTEE                         Null values    LLN01
     C                   MOVE      '0'           L8QUAL                         Null values    LLN01
     C**                   MOVE 'Y'       L8BTEX                    LLN012161718
     C**                   MOVE 'N'       L8LREX                    LLN012161718
     C                   MOVE      ULBTEX        L8BTEX                         BT Ind.        16171
     C                   MOVE      ULLREX        L8LREX                         LR Ind.        16171
     C                   MOVE      ULETYP        L8ETYP                                        LLN01
     C                   MOVE      LGTEE         L8GTEE                         Guarantee Code LLN01
     C                   MOVE      LQUAL         L8QUAL                         Qualifying FlagLLN01
      *                                                                   LLN012
      *                                                                   LLN012
      * If CAR LLN012 is on, setup additional extract fields              LLN012
     C     LLN012        IFEQ      'Y'                                                         LLN01
      *                                                                   LLN012
      * LR Extract should be 'Y' if maturity category is range A - E      LLN012
     C     'ABCDE'       CHECK     L8MCAT                                 90                   LLN01
     C     *IN90         IFEQ      *OFF                                                        LLN01
     C                   MOVE      'Y'           L8LREX                                        LLN01
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
     C                   ENDIF                                                                 LLN01
      *                                                                   163513
      * Do not extract arbitrage deals onto LR file                       163513
     C     DTYP          IFEQ      'PS'                                         Arbitrage      16351
     C                   MOVE      'N'           L8LREX                                        16351
     C                   ENDIF                                                                 16351
      *                                                                   LLN012
      *
      *  Only fill following fields if MM deal
     C     RCDT          IFEQ      'C'
     C                   MOVE      ULCTYP        L8CTYP                         Credit given
     C                   Z-ADD     ULMKDC        L8MKDC
     C                   Z-ADD     ULSMXD        L8SMXD
     C                   Z-ADD     ULMXDD        L8MXDD
     C                   Z-ADD     ULMKCC        L8MKCC
     C                   Z-ADD     ULSMXC        L8SMXC
     C                   Z-ADD     ULMXCD        L8MXCD
     C                   ENDIF
      *
      ***Write*record*to*BYNETDPP if item to be netted                    LLN016
     C********** ULNETI    IFEQ 'Y'                                       LLN016
     C**********           WRITEBYNETDD0                                  LLN016
     C**********           ELSE                                           LLN016
      *                                                                   LLN021
      ** Check whether deal matured this month                               LLN021
      *                                                                      LLN021
     C     MBFLAG        IFEQ      'Y'                                                         LLN02
     C                   WRITE     BYMTDTP0                                                    LLN02
     C                   GOTO      #END                                                        LLN02
     C                   ENDIF                                                                 LLN02
     C***********          EXSR #MATUR                                       LLN021
      *                                                                      LLN021
      * If Mature write to BYMTDTPP                                       LLN021
      *                                                                   LLN021
     C***********@MATS     IFEQ 'Y'                                       LLN021
     C     RECI          IFNE      'D'                                                         LLN02
     C                   WRITE     BYMTDTP0                                                    LLN02
     C                   ELSE                                                                  LLN02
      *  Write record to BYEXDTPP if item not to be netted
     C                   WRITE     BYEXDTD0
     C                   ENDIF                                                                 LLN02
     C**********           ENDIF                                          LLN016
      *
     C                   MOVE      *BLANK        @MATS             1            Mature Indicator  LL
      *
      *  Accumulate total assets and liabilities
      ** (only if Extract Record is for the BT report)                    LLN012
     C     L8BTEX        IFEQ      'Y'                                                         LLN01
     C     RECI          ANDEQ     'D'
      *                                                                   LLN012
     C                   Z-ADD     1             #
     C     ULCYCD        LOOKUP    @CCY(#)                                90
     C     ULPCOD        IFGE      1100
     C     ULPCOD        ANDLE     1960
     C                   ADD       ULCUAS        @TAC(#)
     C                   ADD       ULSGAM        @TAS(#)
     C                   ENDIF
     C     ULPCOD        IFGE      2100
     C     ULPCOD        ANDLE     3990
     C                   ADD       ULCUAS        @TLC(#)
     C                   ADD       ULSGAM        @TLS(#)
     C                   ENDIF
      *                                                                   LLN012
     C                   ENDIF                                                                 LLN01
      *
     C     #END          TAG                                                                   LLN02
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LRPT1 - Write Details of Valid Deals to BY2020P1             *
      *                                                               *
      * Called by: SR/#LRPXT - Report/Extract Details                 *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #LRPT1        BEGSR                                                  ** SR/#LRPT1**
      *
      *  Reset report indicator
     C                   MOVE      *OFF          *IN30
     C                   MOVE      *OFF          *IN41
     C     ULPCOD        IFEQ      9999
     C                   MOVE      *ON           *IN41
     C                   ENDIF
      *
      *  Set up report fields
     C                   CLEAR                   BY2020D1
     C**********           MOVELULCNUM    L#CNUM           Customer                           CSD027
     C                   MOVE      ULCNUM        L#CNUM                         Customer
     C                   MOVEL     DLNO          L#DLNO                         Deal number
     C                   MOVEL     DTYP          L#DTYP                         Deal type
     C                   MOVEL     DLST          L#DLST                         Deal sub-type
     C                   CALL      'ZDATE2'                                     Value date
     C                   PARM      ULVDAT        ULDAYN
     C                   PARM                    BJDFIN
     C                   PARM                    ULDATE
     C     L#VDAT        PARM                    ULDATA
     C     ULMDAT        IFNE      0
     C                   CALL      'ZDATE2'                                     Maturity date
     C                   PARM      ULMDAT        ULDAYN
     C                   PARM                    BJDFIN
     C                   PARM                    ULDATE
     C     L#MDAT        PARM                    ULDATA
     C                   ENDIF
     C                   MOVEL     ULCYCD        L#CYCD                         Currency
     C                   MOVE      ULLISO        L#LISO                         Customer country cod
     C                   MOVE      ULCISO        L#RISO                         Risk country code
     C************         MOVE BBLICD    L#LIND           Industry code                    LLN016
     C************         MOVE BBLINC    L#LINS           Institution code                 LLN016
     C                   MOVE      LLICD         L#LIND                         Industry code
     C                   MOVE      LLINC         L#LINS                         Institution code
     C                   MOVE      BBCRNM        L#CRNM                         Customer report name
     C                   CALL      'ZSEDIT'
     C                   PARM      ULCUAS        ULAMNT
     C                   PARM      A6NBDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA
     C                   MOVE      ULAMTA        L#CUAS                         Currency amount
     C                   CALL      'ZSEDIT'
     C                   PARM      ULSGAM        ULAMNT
     C                   PARM      UL$NDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA
     C                   MOVE      ULAMTA        L#SGAM                         Sterling equivalent
     C                   MOVE      ULPCOD        L#PCOD                         Product code
     C                   MOVEL     ULBTEX        L#BTEX                         BT Indicator   LLN01
     C                   MOVEL     ULLREX        L#LREX                         LR Indicator   LLN01
      *
      *  Set print customer indicator
     C     ULCNUM        IFNE      ULCUS1
     C                   MOVE      *ON           *IN30
     C**********           Z-ADDULCNUM    ULCUS1                                              CSD027
     C                   MOVE      ULCNUM        ULCUS1
     C                   ENDIF
      *
      *  Write details to report
     C     ULOVF1        SUB       ULCLN1        ULLDIF
     C   30              SUB       2             ULLDIF
     C     ULLDIF        IFLT      0
     C                   MOVE      *ON           *IN30
     C                   WRITE     BY2020H1
     C                   ENDIF
     C                   WRITE     BY2020D1                             90
      *
      *  Set flag to indicate details written
     C     ULRPT1        IFNE      'Y'
     C                   MOVE      'Y'           ULRPT1
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LRPT2 - Write Details of Invalid Deals To BY2020P2           *
      *                                                               *
      * Called by: SR/#LRPXT - Report/Extract Details                 *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #LRPT2        BEGSR                                                  ** SR/#LRPT2**
      *
      *  Reset report indicators
     C                   MOVE      *OFF          *IN30
     C                   MOVEA     '0000000'     *IN(31)
     C                   MOVEA     '00'          *IN(41)
      *
      *  Set up report fields
     C                   CLEAR                   BY2020D2
     C**********           MOVELULCNUM    L#CNUM           Customer                           CSD027
     C                   MOVE      ULCNUM        L#CNUM                         Customer
     C                   MOVEL     DLNO          L#DLNO                         Deal number
     C                   MOVEL     DTYP          L#DTYP                         Deal type
     C                   MOVEL     DLST          L#DLST                         Deal sub-type
     C                   CALL      'ZDATE2'                                     Value date
     C                   PARM      ULVDAT        ULDAYN
     C                   PARM                    BJDFIN
     C                   PARM                    ULDATE
     C     L#VDAT        PARM                    ULDATA
     C     ULMDAT        IFNE      0
     C                   CALL      'ZDATE2'                                     Maturity date
     C                   PARM      ULMDAT        ULDAYN
     C                   PARM                    BJDFIN
     C                   PARM                    ULDATE
     C     L#MDAT        PARM                    ULDATA
     C                   ENDIF
     C                   MOVEL     ULCYCD        L#CYCD                         Currency
     C                   MOVE      BBCOLC        L#COLC                         Customer country cod
     C                   MOVE      ULLISO        L#LISO                         Customer country cod
     C                   MOVE      BBCNCZ        L#CNCZ                         Risk country code
     C                   MOVE      ULCISO        L#RISO                         Risk country code
     C************         MOVE BBLICD    L#LIND           Industry code                     LLN016
     C************         MOVE BBLINC    L#LINS           Institution code                  LLN016
     C                   MOVE      LLICD         L#LIND                         Industry code
     C                   MOVE      LLINC         L#LINS                         Institution code
     C                   MOVE      BBCRNM        L#CRNM                         Customer report name
     C                   CALL      'ZSEDIT'
     C                   PARM      ULCUAS        ULAMNT
     C                   PARM      A6NBDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA
     C                   MOVE      ULAMTA        L#CUAS                         Currency amount
     C                   CALL      'ZSEDIT'
     C                   PARM      ULSGAM        ULAMNT
     C                   PARM      UL$NDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA
     C                   MOVE      ULAMTA        L#SGAM                         Sterling equivalent
     C                   MOVE      ULPCOD        L#PCOD                         Product code
      *
      *  Set report indicators if customer is in error
     C     ULCNUM        IFNE      ULCUS2
     C     ULERR1        ANDNE     0
     C                   MOVE      ULERR1        ULERR2
     C                   MOVEA     ULERR2        *IN(31)
     C                   ENDIF
     C     ULPCOD        IFEQ      9999
     C                   MOVE      *ON           *IN41
     C                   ENDIF
     C     ULPCOD        IFEQ      1550
     C     ULCYCD        ANDNE     BLCYCD
     C     ULPCOD        OREQ      1595
     C     ULCYCD        ANDNE     BLCYCD
     C                   MOVE      *ON           *IN42
     C                   ENDIF
      *
      *  Determine no. of errors to be reported for overflow check
     C                   Z-ADD     0             X
     C   31              ADD       1             X
     C   32              ADD       1             X
     C   33              ADD       1             X
     C   34              ADD       1             X
     C   35              ADD       1             X
     C   36              ADD       1             X
     C   37              ADD       1             X
      *
      *  Write details to report
     C     ULOVF2        SUB       ULCLN2        ULLDIF
     C                   SUB       X             ULLDIF
     C     ULLDIF        IFLE      5
     C     ULCNUM        ANDNE     ULCUS2
     C     ULLDIF        ORLE      0
     C     ULCNUM        ANDEQ     ULCUS2
     C                   MOVE      *ON           *IN30
     C                   WRITE     BY2020H2
     C                   ENDIF
     C     ULCNUM        IFNE      ULCUS2
     C     *IN30         OREQ      *ON
     C                   WRITE     BY2020D2                             90
     C                   ENDIF
     C                   WRITE     BY2020D3                             90
      *
      *  Save customer
     C**********           Z-ADDULCNUM    ULCUS2                                              CSD027
     C                   MOVE      ULCNUM        ULCUS2
      *
      *  Set flag to indicate details written
     C     ULRPT2        IFNE      'Y'
     C                   MOVE      'Y'           ULRPT2
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LRPTT - Final Reporting                                   *
      *                                                               *
      * Called by:  SR/#LBRCH - Change of Branch Processing           *
      *             SR/#LTERM - Termination Processing                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     #LRPTT        BEGSR                                                  ** SR/#LRPTT**
      *
      *  No details to report
     C     ULRPT1        IFNE      'Y'
     C                   WRITE     BY2020E1                             90
     C                   ENDIF
      *
      *  No details to report
     C     ULRPT2        IFNE      'Y'
     C                   WRITE     BY2020E2                             90
     C                   ENDIF
      *
      *   Report currency summary if EXTRACT mode
     C     ULMODE        IFEQ      'EXTRACT'
     C     ULRPT1        ANDEQ     'Y'
      *
      *   Write heading
     C                   WRITE     BY2020R1
      *
      *   Write detail record for each currency
     C                   Z-ADD     0             ULTOTA
     C                   Z-ADD     0             ULTOTL
     C                   Z-ADD     1             #
     C     @CCY(#)       DOWNE     *BLANK
     C     #             ANDLT     200
     C     #             OCCUR     SDCURR
      *
     C     @TAC(#)       IFNE      0
     C     @TLC(#)       ORNE      0
     C                   MOVE      A6CYCD        L#CYCD                         Currency
     C                   MOVE      A6CYNM        L#CYNM                         Currency name
     C                   CALL      'ZSEDIT'
     C                   PARM      @TAC(#)       ULAMNT
     C                   PARM      A6NBDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA                         Total assets - ccy
     C                   MOVE      ULAMTA        L#TLAC
     C                   CALL      'ZSEDIT'
     C                   PARM      @TAS(#)       ULAMNT
     C                   PARM      UL$NDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA                         Total assets - STG
     C                   MOVE      ULAMTA        L#TLAS
     C                   CALL      'ZSEDIT'
     C                   PARM      @TLC(#)       ULAMNT
     C                   PARM      A6NBDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA                         Total liabs. - ccy
     C                   MOVE      ULAMTA        L#TLLC
     C                   CALL      'ZSEDIT'
     C                   PARM      @TLS(#)       ULAMNT
     C                   PARM      UL$NDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA                         Total liabs. - STG
     C                   MOVE      ULAMTA        L#TLLS
      *
      *   Report details
     C                   WRITE     BY2020S1                             90
     C     ULCLN1        IFGT      ULOVF1                                       Overflow
     C                   WRITE     BY2020R1
     C                   ENDIF
      *
      ** Write record for total assets in CCY                             LLN012
     C                   MOVEL     ULBRCA        LTBRCD                                        LLN01
     C                   MOVEL     'DL'          LTMMOD                                        LLN01
     C                   MOVEL     'A'           LTASLI                                        LLN01
     C                   MOVEL     @CCY(#)       LTCYCD                                        LLN01
     C                   MOVEL     @TAC(#)       LTCUAS                                        LLN01
     C                   MOVEL     @TAS(#)       LTSGAM                                        LLN01
     C                   WRITE     BYTOTED0                             90                     LLN01
      *                                                                   LLN012
      ** Write record for total liabilities in CCY                        LLN012
     C                   MOVEL     ULBRCA        LTBRCD                                        LLN01
     C                   MOVEL     'DL'          LTMMOD                                        LLN01
     C                   MOVEL     'L'           LTASLI                                        LLN01
     C                   MOVEL     @CCY(#)       LTCYCD                                        LLN01
     C                   MOVEL     @TLC(#)       LTCUAS                                        LLN01
     C                   MOVEL     @TLS(#)       LTSGAM                                        LLN01
      *                                                                   LLN012
     C                   WRITE     BYTOTED0                             90                     LLN01
      *                                                                   LLN012
      *  Accumulate total assets and liabilities in sterling
     C                   ADD       @TAS(#)       ULTOTA
     C                   ADD       @TLS(#)       ULTOTL
     C                   ENDIF
      *
     C                   ADD       1             #
     C                   ENDDO
      *
      *
      *   Report overall asset and libilities totals
     C                   CALL      'ZSEDIT'
     C                   PARM      ULTOTA        ULAMNT
     C                   PARM      UL$NDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA                         Total assets - STG
     C                   MOVE      ULAMTA        L#TOTA
     C                   CALL      'ZSEDIT'
     C                   PARM      ULTOTL        ULAMNT
     C                   PARM      UL$NDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA                         Total liabs. - STG
     C                   MOVE      ULAMTA        L#TOTL
     C     ULCLN1        IFGT      ULOVF1                                       Overflow
     C                   WRITE     BY2020R1
     C                   ENDIF
     C                   WRITE     BY2020T1                             90
      *
     C                   ENDIF
      *
      *  Write end of report FOR BY2020P1
     C                   WRITE     BY2020Z1                             90
      *
      *  Write end of report FOR BY2020P2
     C                   WRITE     BY2020Z2                             90
      *
      *  Close files
     C                   CLOSE     BY2020P1
     C                   CLOSE     BY2020P2
      *
      *  Reset file open flag indicator and totals
     C                   MOVE      'N'           ULOPNF
     C                   MOVE      'N'           ULRPT1
     C                   MOVE      'N'           ULRPT2
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LDEFN - Field Definition Routine                             *
      *                                                               *
      * Called by:  None - Contains definitions only                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     #LDEFN        BEGSR                                                  ** SR/#LDEFN**
      *
      *  Copyright statement
     C                   MOVEA     @CPY          ULCPY@           80
      *
      ** Define external data areas
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  RUNDAT
      *
      ** Define and initialise work fields
     C                   Z-ADD     0             #                 5 0
     C                   Z-ADD     0             X                 2 0
     C                   Z-ADD     0             ULSFNO            6 0          Spool file no.
     C                   Z-ADD     0             ULDAYN            5 0          Date - Midas day no.
     C                   Z-ADD     0             ULDATE            6 0          Date - DDMMYY
     C                   Z-ADD     0             ULSDAY            5 0          Spot date
     C                   Z-ADD     0             ULFDAY            5 0          Future date
     C                   Z-ADD     0             ULFWDY            2 0          No. of days forward
     C                   Z-ADD     0             ULAMNT           15 0          Amount field
     C                   Z-ADD     0             ULFAMT           15 0          Future amount
     C                   Z-ADD     0             ULPAMP           15 0          Net present purchase
     C                   Z-ADD     0             ULPAMS           15 0          Net present sale
     C                   Z-ADD     0             ULINAM           15 0          In amount
     C                   Z-ADD     0             ULOTAM           15 0          Converted amount
     C                   Z-ADD     0             ULERR1            7 0          Error indicators
     C                   Z-ADD     0             ULSFWD            5 0          Spot forward day
     C                   Z-ADD     0             ULTOTA           15 0          Total assets
     C                   Z-ADD     0             ULTOTL           15 0          Total liabilities
     C                   Z-ADD     0             ULMPER            5 0          Category period date
     C                   Z-ADD     0             ULLDIF            3 0          Line difference
     C                   MOVE      'N'           ULERRI            1            Error indicators
     C                   MOVE      'N'           ULVALD            1            Valid deal
     C                   MOVE      'N'           ULRPT1            1            Details reported
     C                   MOVE      'N'           ULRPT2            1            Details reported
     C                   MOVE      'N'           ULOPNF            1            Files opened
     C                   MOVE      *BLANK        ULRTCD            1            Return code
     C                   MOVE      *BLANK        ULBRCA            3            Branch code
     C                   MOVE      *BLANK        P@RTCD            7
     C                   MOVE      *BLANK        P@OPTN            7
     C                   MOVE      *BLANK        ULVCAT            1            Value date cat.
     C                   MOVE      *BLANK        ULDATA            7            Date - DDMMMYY
     C                   MOVE      *BLANK        ULLOCN            3            Location
     C                   MOVE      *BLANK        ULAMTA           21            Edited amount field
     C                   MOVE      *BLANK        ULECOD            1            Edit code
     C                   MOVE      *BLANK        ULFNAM           10            File name
     C                   MOVE      *BLANK        ULFCCY            3            From currency
     C                   MOVE      *BLANK        ULTCCY            3            To currency
     C                   MOVE      *BLANK        ULERR2            7            Error indicators
     C     *LIKE         DEFINE    CNUM          ULCNUM                         Customer
     C     *LIKE         DEFINE    CNUM          ULCUS1                         Customer print 1
     C     *LIKE         DEFINE    CNUM          ULCUS2                         Customer print 2
     C     *LIKE         DEFINE    CNUM          ULPCUS                         Previous customer
     C     *LIKE         DEFINE    CCY           ULCYCD                         Currency
     C     *LIKE         DEFINE    VDAT          ULVDAT                         Value date
     C     *LIKE         DEFINE    MDAT          ULMDAT                         Maturity date
     C     *LIKE         DEFINE    NOTD          ULNOTD                         Notice days
     C     *LIKE         DEFINE    L8RTYP        ULRTYP                         Record type
     C     *LIKE         DEFINE    L8PCOD        ULPCOD                         Product code
     C     *LIKE         DEFINE    L8CUAS        ULCUAS                         Currency amount
     C     *LIKE         DEFINE    L8SGAM        ULSGAM                         Extract GBP amount
     C     *LIKE         DEFINE    L8SMKV        ULSMKV                         Market value
     C     *LIKE         DEFINE    L8INTB        ULINTB                         Interest bearing
     C     *LIKE         DEFINE    L8MCAT        ULMCAT                         Maturity date cat.
     C     *LIKE         DEFINE    L8DRVT        ULDRVT                         Derivative type
     C     *LIKE         DEFINE    L8MMOD        ULMMOD                         Module id.
     C********** *LIKE     DEFN L8NETI    ULNETI           Netting indicator                LLN016
     C     *LIKE         DEFINE    L8CTYP        ULCTYP                         Credit type
     C     *LIKE         DEFINE    L8BTEX        ULBTEX                                        16171
     C     *LIKE         DEFINE    L8LREX        ULLREX                                        16171
     C     *LIKE         DEFINE    A8IBOE        ULIBOE                         Include branch
     C     *LIKE         DEFINE    A6NBDP        ULNBDP                         No. of decimal place
     C     *LIKE         DEFINE    A6NBDP        UL$NDP                         Sterling dec. places
     C     *LIKE         DEFINE    BBCUST        ULCUST                         Customer
     C     *LIKE         DEFINE    LMKDC         ULMKDC
     C     *LIKE         DEFINE    LSMXD         ULSMXD
     C     *LIKE         DEFINE    LMXDD         ULMXDD
     C     *LIKE         DEFINE    LMKCC         ULMKCC
     C     *LIKE         DEFINE    LSMXC         ULSMXC
     C     *LIKE         DEFINE    LMXCD         ULMXCD
     C     *LIKE         DEFINE    L2DTYP        K1DTYP
     C     *LIKE         DEFINE    L2DLST        K1DLST
     C     *LIKE         DEFINE    L2LINS        K1LINS
     C     *LIKE         DEFINE    L2MIND        K1LICD                         Industry code
     C     *LIKE         DEFINE    DBKEY         ULKEY
     C     *LIKE         DEFINE    DBFILE        ULFILE
     C     *LIKE         DEFINE    DBASE         ULBASE
      *
      ** Key List Definitions
      *   K1DLEX - Key list for PF/BYDLEXPP
     C     K1DLEX        KLIST
     C                   KFLD                    K1DTYP
     C                   KFLD                    K1DLST
     C                   KFLD                    K1LINS
     C                   KFLD                    K1LICD                         Industry code
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LDBER - Database Error Handling                              *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     #LDBER        BEGSR                                                  ** #LDBER **
      *
      *  Update LDA with details of error
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM
     C                   MOVEL     ULKEY         DBKEY
     C                   MOVEL     ULFILE        DBFILE
     C                   Z-ADD     ULBASE        DBASE
     C                   OUT       LDA
      *
      *  Report data base error details
     C                   WRITE     BY2020F2
      *
      *  Terminate program
     C                   EXSR      *PSSR
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
      *  Check if error has previously been reported
     C     ULERRI        IFNE      'Y'
     C                   MOVE      'Y'           ULERRI
     C                   MOVE      'Y'           ULRTCD
     C                   DUMP
     C                   ENDIF
      *
      *  Set on external indicators
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
      *
      *  Terminate program
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LTERM - Termination Processing                               *
      *                                                               *
      * Called by:  Main Processing                                   *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     #LTERM        BEGSR                                                  ** SR/#LTERM**
      *
      *  Final reporting
     C     ULOPNF        IFEQ      'Y'
     C                   EXSR      #LRPTT
     C                   ENDIF
      *
      *  Terminate program
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      * Called by:  At program initialisation                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR                                                  ** *INZSR SR**
      *
     C     *ENTRY        PLIST
     C                   PARM                    ULMODE            7            Run mode
     C                   PARM                    ULRSEQ            5            Report sequence
     C                   PARM                    ULRTCD                         Return code
     C                   PARM                    CUREOM            5                        LLN021
     C                   PARM                    CURSOM            5                        LLN021
      *
      *  Set report indicator according to mode
     C     ULMODE        IFEQ      'EXTRACT'
     C                   MOVE      *ON           *IN21
     C                   ELSE
     C                   MOVE      *OFF          *IN21
     C                   ENDIF
      *
     C                   MOVEL     CURSOM        CURSO             5 0                          LLN0
     C                   MOVEL     CUREOM        CUREO             5 0                          LLN0
      *  Get Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C                   PARM                    SDBANK
     C     P@RTCD        IFNE      *BLANKS
     C     BJTYLC        OREQ      'D'                                          ON-DELETED
     C                   MOVEL     '*NONE '      ULKEY                          ************
     C                   MOVEL     'SDBANKPD'    ULFILE                         * DBERR 14 *
     C                   Z-ADD     14            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *  Set Date Format Indicator *IN98  on if date format is MMDDYY
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ELSE
     C                   MOVE      *OFF          *IN98
     C                   END
      *
      *  Get Dealing ICD Record
     C                   CALL      'AODEALR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C                   PARM                    SDDEAL
     C     P@RTCD        IFNE      *BLANKS
     C                   MOVEL     '*NONE '      ULKEY                          ************
     C                   MOVEL     'AODEALR0'    ULFILE                         * DBERR 15 *
     C                   Z-ADD     15            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *  Get General Ledger ICD Details
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C                   PARM                    SDGELR
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     '*NONE '      ULKEY                          ************
     C                   MOVEL     'AOGELRR0'    ULFILE                         * DBERR 17 *
     C                   Z-ADD     17            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *  Get Trading Data ICD Record For GBP Corrency Code (BLCYCD)
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C                   PARM                    SDTRAD
     C     P@RTCD        IFNE      *BLANKS
     C                   MOVEL     '*NONE '      ULKEY                          ************
     C                   MOVEL     'AOTRADR0'    ULFILE                         * DBERR 18 *
     C                   Z-ADD     18            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *                                                                   LLN012
      ** Check switchable feature to see if LLN012 is on                  LLN012
     C                   MOVE      'N'           LLN012            1                           LLN01
     C                   CALL      'AOSARDR0'                                                  LLN01
     C                   PARM      '       '     @RTCD             7                           LLN01
     C                   PARM      '*VERIFY'     @OPTN             7                           LLN01
     C                   PARM      'LLN012'      @SARD             6                           LLN01
     C     @RTCD         IFEQ      *BLANKS                                                     LLN01
     C                   MOVE      'Y'           LLN012                                        LLN01
     C                   ENDIF                                                                 LLN01
      *
      *  Initialise work fields
     C                   EXSR      #LDEFN
      *
      *
      *  Get the extract date
     C                   OPEN      BYRPDTPP
     C     1             CHAIN     BYRPDTPP                           90
     C     *IN90         IFEQ      *ON
     C                   MOVEL     '*NONE '      ULKEY                          ************
     C                   MOVEL     'BYRPDTPP'    ULFILE                         * DBERR 19 *
     C                   Z-ADD     19            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
     C                   CLOSE     BYRPDTPP
      *
      * Check if multi-branching
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *  Single branch:
     C     AGMBIN        IFNE      'Y'
     C                   MOVE      'Y'           ULOPNF
     C                   MOVE      *OFF          *IN20
      *
      *  RCF processing for printer file BY2020P1
     C                   OPEN      BY2020P1
     C                   Z-ADD     ULNUM1        ULSFNO
     C                   CALL      'ZSFILE'
     C                   PARM                    ULRSEQ
     C                   PARM                    ULBRCA
     C                   PARM      'BY2020P1'    ULFNAM
     C                   PARM                    ULSFNO
     C                   PARM                    ULRTCD
     C     ULRTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 19 *
     C                   MOVEL     'ZSFILE  '    DBFILE                         ************
     C                   Z-ADD     19            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  RCF processing for printer file BY2020P2
     C                   OPEN      BY2020P2
     C                   Z-ADD     ULNUM2        ULSFNO
     C                   CALL      'ZSFILE'
     C                   PARM                    ULRSEQ
     C                   PARM                    ULBRCA
     C                   PARM      'BY2020P2'    ULFNAM
     C                   PARM                    ULSFNO
     C                   PARM                    ULRTCD
     C     ULRTCD        IFNE      *BLANK
     C                   MOVEL     '*NONE '      ULKEY                          ************
     C                   MOVEL     'ZSFILE  '    ULFILE                         * DBERR 20 *
     C                   Z-ADD     20            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
      *
      *  Write report headings to BY2020P1 and BY2020P2
     C                   MOVE      L0RPDA        L#RPDA
     C                   WRITE     BY2020H1
     C                   WRITE     BY2020H2
      *
      *  Multi branching indicator
     C                   ELSE
     C                   MOVE      *ON           *IN20
     C                   ENDIF
      *
      *  Load currency details
     C                   Z-ADD     0             #
     C     *IN90         DOWEQ     *OFF
     C     #             ANDLT     200
     C                   ADD       1             #
     C     #             OCCUR     SDCURR
     C                   READ      SDCURRL0                               90
     C     *IN90         IFEQ      *OFF
     C                   MOVE      A6CYCD        @CCY(#)
     C                   ENDIF
     C                   ENDDO
      *
      *  Get decimal places for sterling currency code
     C                   Z-ADD     1             #
     C     BLCYCD        LOOKUP    @CCY(#)                                90
     C     *IN90         IFEQ      *ON
     C     #             OCCUR     SDCURR
     C                   Z-ADD     A6NBDP        UL$NDP
     C                   ELSE
     C     200           OCCUR     SDCURR
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    ULCYCD
     C     SDCURR        PARM                    DSSDY
     C     P@RTCD        IFNE      *BLANK                                       Error on call
     C                   MOVEL     BLCYCD        ULKEY                          ************
     C                   MOVEL     'SDCURRPD'    ULFILE                         * DBERR 21 *
     C                   Z-ADD     21            ULBASE                         ************
     C                   EXSR      #LDBER
     C                   ENDIF
     C                   Z-ADD     A6NBDP        UL$NDP
     C                   ENDIF
      *
      *  Open extract file if EXTRACT mode
     C     ULMODE        IFEQ      'EXTRACT'
     C                   OPEN      BYEXDTPP
     C                   OPEN      BYMTDTPP                                                    LLN02
     C**********           OPEN BYNETDPP                                  LLN016
     C                   ENDIF
      *                                                                   LLN014
      ** Get Face Value indicator for Negotiable Assets                   LLN014
      ** (Default to Y if blank)                                          LLN014
     C     *DTAARA       DEFINE                  BYSTAT                                        LLN01
     C                   IN        BYSTAT                                                      LLN01
     C     LFACE         IFEQ      *BLANK                                                      LLN01
     C                   MOVE      'N'           LFACE                                         LLN01
     C                   ENDIF                                                                 LLN01
     C                   UNLOCK    BYSTAT                                                      LLN01
      *
     C                   ENDSR
      /EJECT
      *****************************************************************   LLN021
      *                                                               *   LLN021
      * SR/#MATUR - Check Security matured this month                 *   LLN021
      *                                                               *   LLN021
      * Called by:  SR/#LSECD - Main Processing                       *   LLN021
      *                                                               *   LLN021
      * Calls:                                                        *   LLN021
      *                                                               *   LLN021
      *****************************************************************   LLN021
      *                                                                   LLN021
     C*********  #MATUR    BEGSR                           ** SR/#MATUR** LLN021
      *                                                                   LLN021
     C*********  RECI      IFEQ 'M'
     C*********  MDAT      IFNE 0                                         LLN021
      *                                                                   LLN021
     C********   L8MDAT    IFLE CUREO                                      LLN021
     C********   L8MDAT    ANDGECURSO                                      LLN021
     C********             MOVE 'Y'       @MATS                              LLN021
     C********             ENDIF                                             LLN021
      ********                                                               LLN021
     C********             ENDIF                                             LLN021
      ********                                                               LLN021
     C********             ENDIF                                             LLN021
      ********                                                               LLN021
     C********             ENDSR                                          LLN021
      /EJECT
      ********************************************************************
     C*COPY*ZSRSRC,GLINTCZ1                                                                 MD058068
     C/COPY ZSRSRC,GLINTCZ1LE                                                               MD058068
     C/EJECT
     C*COPY*ZSRSRC,ZSAVEZ1                                                                  MD058068
     C/COPY ZSRSRC,ZSAVEZ1LE                                                                MD058068
     C/EJECT
     C*COPY*ZSRSRC,ZRSTORZ1                                                                 MD058068
     C/COPY ZSRSRC,ZRSTORZ1LE                                                               MD058068
     C/EJECT
     C*COPY*ZSRSRC,ZDATE2Z2                                                                 MD058068
     C/COPY ZSRSRC,ZDATE2Z2LE                                                               MD058068
     C/EJECT
     C*COPY*ZSRSRC,ZDATE9Z3                                                                 MD058068
     C/COPY ZSRSRC,ZDATE9Z3LE                                                               MD058068
     C/EJECT
     C/EJECT
     C*COPY*ZSRSRC,ZINTDYZ2                                                                 MD058068
     C/COPY ZSRSRC,ZINTDYZ2LE                                                               MD058068
     C/EJECT
     C*COPY*ZSRSRC,ZDAT10Z2                                               139259            MD058068
     C/COPY ZSRSRC,ZDAT10Z2LE                                                               MD058068
     C/EJECT                                                              139259
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
**  CPY@
(c) Finastra International Limited 1997
