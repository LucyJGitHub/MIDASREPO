     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058068
/*STD *  RPGSQLBND                                                    *                     MD058068
/*EXI *  TEXT('Midas BoE Customer Lending Extract/Validation')        *
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BY2030 - Customer Lending Extract/Validation                 *
      *                                                               *
      *  Called By: BYC2030 - Customer Lending Extract/Validation     *
      *                                                               *
      *  (c) Finastra International Limited 1997                      *
      *                                                               *
      *  Last Amend No. 251453             Date 26Apr22               *
      *  Prev Amend No. MD058068           Date 11May21               *
      *                 MD055733           Date 03Jul20               *
      *                 MD055652           Date 13Jul20               *
      *                 MD050139           Date 23Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL184             Date 07Dec16               *
      *                 MD034876           Date 01Jul15               *
      *                 263293             Date 12Jan10               *
      *                 CSD027             Date 21Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG7606            Date 17Jun05               *
      *                 LLN022             Date 24Jan05               *
      *                 232050             Date 23Feb05               *
      *                 LLN021/038         Date 26Mar04               *
      *                 LLN021             Date 08Jan04               *
      *                 LLN021             Date 20Nov03               *
      *                 LLN021             Date 21Oct03               *
      *                 210788             Date 23Aug03               *
      *                 213767             Date 08Jan03               *
      *                 LLN020             Date 17May02               *
      *                 LLN016             Date 12May00               *
      *                 163786             Date 18Oct99               *
      *                 168698             Date 11Oct99               *
      *                 168646             Date 08Oct99               *
      *                 168700             Date 08Oct99               *
      *                 LLN012             Date 30Sep99               *
      *                 165885             Date 17Aug99               *
      *                 161718             Date 08Jun99               *
      *                 LLN012             Date 23APR99               *
      *                 139245             Date 21Jul98               *
      *                 LLN009             Date 16Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Amendment History                                            *
      *  -----------------                                            *
      *                                                               *
      *  251453 - Divide by zero problem. Extract details of loans    *
      *           with new processing types 70, 71 and 72.            *
      *         - Applied for MD059499                                *
      *  MD058068 - Deliverable Data Split for Bank of England        *
      *  MD055733 - COB: Multiple UTCHOBJEX calls in LEC06A           *
      *             components                                        *
      *           - Redeliver of MD050139.                            *
      *  MD055652 - Dbase error occurs when generating MR event code  *
      *             for discount loan. Add event keys (63R1, 65R1 and *
      *             67R1) for principal repayment of discount loan in *
      *             event codes array (LLA). Pattern after fix        *
      *             MD047582A.                                        *
      *  MD050139- AOSARDR0 called every time causing performance     *
      *            issue. Recompile due to changes in /COPY           *
      *            ZFREQ/ZFRQ*.                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL184 - New Frequencies for Account Statements (Recompile)  *
      *  MD034876 - BOE Upgrade to FBM2.1 Compatibility Amendments    *
      *  263293 - BYC2030 00010 BY9070 tried to divide by zero.       *
      *           Applied fix of 239777. Do not convert if amount     *
      *           is equal to zero.                                   *
      *  BUG7606- Customer missing in the report                      *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  232050 - Write live records only in BY2030P1 and BY2030P2.   *
      *           Doesn't include matured deals in the calculation    *
      *           of totals. Ensures deals aren't reported under      *
      *           the wrong customer.                                 *
      *  LLN021/038 - Rename RECI to RECIXX from SVNTS.               *
      *  LLN021 - Records for PCOD = '9998'     should be output to   *
      *           PF/BYMTDTPP for reporting purposes                  *
      *  LLN021 - Records for mature loans      should be output to   *
      *           PF/BYMTDTPP for reporting purposes                  *
      *  LLN021 - Account Extract Validation, add industry code to the*
      *           extract criteria for BYLEEXPP.                      *
      *  210788 - Call to ZDATE1 using wrong parameters so coming     *
      *           back with error and so not using Final Maturity Date*
      *  213767 - Amend to extract details of loans with processing   *
      *           type 68 & 69, which were introduced as part of the  *
      *           lending enhacements.                                *
      *  LLN020 - Upgrade Bank of England Extract Module to Release 4 *
      *  LLN016 - Upgrade BoE to DBAR3.                               *
      *  163786 - When a loan is reported as invalid only report      *
      *           the principal being extracted for the BT return.    *
      *  168698 - Participations Sold are always signed the same way  *
      *           for both inflows and outflows.                      *
      *  168646 - Key date for events/transactions must be compared   *
      *           less than or equal to LR Report Date.  System was   *
      *           missing all those equal to date.                    *
      *  168700 - Add 4 Elements to the Array 'LLA - Events Types'.   *
      *  LLN012 - Additional BoE Changes (Patch B)                    *
      *  165885 - Interest events extracted for the LR are wrongly    *
      *           signed for particiaptions sold as the amount in     *
      *           field ULCUAS is reversed in subroutine SR/#LRPXT.   *
      *  161718 - Various problems:                                   *
      *           - Interest events are not being extracted.          *
      *           - Interbranch entries should not be extracted.      *
      *           - Events with zero amount should not be extracted.  *
      *           Note: The entries in the events table array LLA     *
      *                 have been amended for this fix.               *
      *  LLN012 - Financial Services Authority - Liquidity Report     *
      *  139245 - Ignore unused formats from LF/CLOAN                 *
      *  LLN009 - DBA2 Upgrade.                                       *
      *                                                               *
      *****************************************************************
      *
      *  Indicator Usage                                              *
      *  ---------------                                              *
      *                                                               *
      *  *IN20  -   Multi-branching                                   *
      *  *IN31  -   Report error in customer details to BY2030P2      *
      *  *IN32  -   Report error in customer details to BY2030P2      *
      *  *IN33  -   Report error in customer details to BY2030P2      *
      *  *IN34  -   Report error in customer details to BY2030P2      *
      *  *IN35  -   Report error in customer details to BY2030P2      *
      *  *IN36  -   Report error in customer details to BY2030P2      *
      *  *IN37  -   Report error in customer details to BY2030P2      *
      *  *IN41  -   Extract criteria does not exist                   *
      *  *IN86  -   End of file indicator for reading LOAMS           *
      *  *IN87  -   End of file indicator for reading BYGTEEV0        *
      *  *IN88  -   End of file indicator for reading SDBRCHL1        *
      *  *IN89  -   End of file indicator for reading CLOANB          *
      *  *IN90  -   General error indicator                           *
      *                                                               *
      *****************************************************************
      *
     F***CLOANB  IF  E           K        DISK         KINFSR *PSSR           LLN021
     FBYLOANV0  IF   E           K DISK    INFSR(*PSSR)                             LLN021
     F                                     RENAME(CLOANCLF:CLOANF)              LNN021
      *  Customer Loans By Branch/Customer
      *
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F******      CLOANCLF                          KRENAMECLOANF         LNN021
     F                                     IGNORE(CLOANHHF)                     139245
     F                                     IGNORE(CLOANZ1F)                     139245
      *  Customer Loans Details
      *
     F*LOANY9*IF**E********** K        DISK         KINFSR *PSSR                          LLN016
     FBYLOANY0  IF   E           K DISK    INFSR(*PSSR)                                         LLN0
      *  Loan extension file
      *
     FLOAMS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSZ1F)
      *  Loan Amendments file
      *
     FSVNTS     IF   E           K DISK    INFSR(*PSSR)
      *  Loan Events
      *
     F***BYGTEEV0IF  E           K        DISK         KINFSR *PSSR          LLN021
     FBYGTEEV1  IF   E           K DISK    INFSR(*PSSR)                            LLN021
      *  Guarantees
      *
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
      *  Currency details
      *
     F*DBOOKY9IF**E********** K        DISK         KINFSR *PSSR                            LLN016
     FBYBOOKY0  IF   E           K DISK    INFSR(*PSSR)                                           LL
      *  Book code Extension file
      *
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
      *  Branches
      *
     F*DBRCHY9IF**E********** K        DISK         KINFSR *PSSR                             LLN016
     FBYBRCHY0  IF   E           K DISK    INFSR(*PSSR)                                            L
      *  Branch Detail extension file
      *
     FBYRPDTPP  IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
      *  Bank of England Extract Date File
      *
     FBYLEEXPP  IF   E           K DISK    INFSR(*PSSR)
      *  Loan Details Extract Criteria
      *
     F*BYPRODPP* IF   E           K DISK    INFSR(*PSSR)                                    MD058068
      *  Bank of England Product Codes
      *
     FBYEXDTPP  O    E           K DISK    USROPN
     F                                     INFSR(*PSSR)
      *  Bank of England Extract File - (Uses member BYEXLEM)
     FBYMTDTPP  O    E           K DISK    INFSR(*PSSR)                         LLN021
     F                                     USROPN
     F                                     RENAME(BYEXDTD0:BYMTDTP0)            LLN021
      *  Mature Bank of England Extract File - (Uses member BYEXLEM)      LLN021
      *
     F*YNETDPPO***E****                DISK         KINFSR *PSSR      UC  LLN016
      ***Extract*Details*For*Netting*-*(Uses member BYNETLEM)             LLN016
      *
     FBYTOTEPP  O    E             DISK    INFSR(*PSSR)                         LLN012
      *  Asset/Liabilities Totals                                         LLN012
      *                                                                   LLN012
     FBY2030P1  O    E             PRINTER INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(SPOOL1)
      *  Bank of England Validation Report - Valid Loans
      *
     FBY2030P2  O    E             PRINTER INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(SPOOL2)
      *  Bank of England Validation Report - Invalid Loans
      *
      /EJECT
      *
      *
      *COPY*ZSRSRC,ZDATE2Z1                                                                 MD058068
      /COPY ZSRSRC,ZDATE2Z1LE                                                               MD058068
     D*COPY*ZSRSRC,ZFREQBZ1                                                                 MD058068
     D/COPY ZSRSRC,ZFREQBZ1LE                                                               MD058068
     D*COPY*ZSRSRC,ZHOLE                                                                    MD058068
     D/COPY ZSRSRC,ZHOLELE                                                                  MD058068
     D @CPY            S             80    DIM(1) CTDATA PERRCD(1)
     D**                  LLA    11  44  4                          LLN012161718
     D*********           LLA    11  49  4                          161718168700
     D*********           LLA    11  53  4                          168700213767
     D**********          LLA    11  65  4                                           213767 MD055652
     D LLA             S              4    DIM(68) CTDATA PERRCD(11)
     D @CCY            S              3    DIM(200)
     D @TAC            S             15  0 DIM(200)                             Total assets - ccy
     D @TAS            S             15  0 DIM(200)                             Total assets - sterl
     D @TLC            S             15  0 DIM(200)                             Total liabilities -
     D @TLS            S             15  0 DIM(200)                             Total liabilities -
     D @GRA            S              2    DIM(200)                             Guarantor cntry of r
     D @GRB            S             15  0 DIM(200)                             Total amount for gua
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Data Structure using Bank file format
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Country codes details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** Trading Data ICD
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                          L
      *
      ** Data Structure using Currency Details
     D SDCURR        E DS                  OCCURS(200) EXTNAME(SDCURRPD)
      *
      ** Data Structure for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Data Structure for Bank of England Customer Details
     D*DCUS7****E*DSSDCUSTX7                                                                LLN016
     D SDCUS7        E DS                  EXTNAME(BYCUSTX0)                                      LL
      *
      ** Data Structure for extra customer details returned by BY9110
      *       ULLISO  - ISO Code of customer's country of location
      *       ULCISO  - ISO Code of customer's country of citizenship
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
      *
      * Data structure for retrieval of data from DTAARA/RUNDAT
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
     D BYPROD        E DS                  EXTNAME(BYPRDJW0)                                MD058068
      *  File Information Data Structure for BY2030P1
     D SPOOL1          DS
     D  ULNUM1               123    124B 0
     D  ULOVF1               188    189B 0
     D  ULCLN1               367    368B 0
      *
      *  File Information Data Structure for BY2030P2
     D SPOOL2          DS
     D  ULNUM2               123    124B 0
     D  ULOVF2               188    189B 0
     D  ULCLN2               367    368B 0
      *
     D/COPY ZSRSRC,ZAOZ1LE                                                                  MD058068
     D/COPY ZSRSRC,ZAOZ2LE                                                                  MD058068
     D/COPY ZSRSRC,ZHOLILE                                                                  MD058068
     D/COPY ZSRSRC,ZHOLDSLE                                                                 MD058068
      /SPACE 3
     ILVENTELF                                                                                 LLN02
     I              RECI                        RECIXX                                         LLN02
      *
     I*COPY*ZSRSRC,ZAOZ1                                                                    MD058068
     I*COPY*ZSRSRC,ZAOZ2                                                                    MD058068
     I*COPY*ZSRSRC,ZHOLI                                                                    MD058068
     I*COPY*ZSRSRC,ZHOLDS                                                                   MD058068
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
      *             SR/#LFIXL - Call/Fixed Loan Processing            *
      *             SR/#LPPUR - Participations Purchased Processing   *
      *             SR/#LPSLD - Participations Sold Processing        *
      *                                                               *
      *****************************************************************
      *
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
      ***Process*all loans for the branch on LF/CLOANB
      *  Process all loans for the branch on LF/BYLOANV0
     C     ULIBOE        IFEQ      'Y'
     C*********  ULBRCA    SETLLCLOANB                                       LLN021
     C*********  ULBRCA    READECLOANB                   89                  LLN021
     C     ULBRCA        SETLL     BYLOANV0                                                       LL
     C     ULBRCA        READE     BYLOANV0                               89                      LL
     C     *IN89         DOWEQ     *OFF
      *
      ***Only*process*live*loans and according to mode                       LLN021
     C     ULMODE        IFEQ      'INTERIM'
     C     LCD           ANDEQ     BJRDNB
     C     ULMODE        OREQ      'EXTRACT'
     C     ULMODE        OREQ      'LIST   '
      *
      *  Reset work fields
     C                   EXSR      #LRSET
      *
      *                                                                      LLN021
      *  Process loan according to loan processing type
     C                   SELECT
     C     PTYP          WHENEQ    61
     C     PTYP          OREQ      62
     C     PTYP          OREQ      63
     C     PTYP          OREQ      70                                                         251453
     C                   EXSR      #LFIXL                                       Call/Fixed Loan
     C     PTYP          WHENEQ    64
     C     PTYP          OREQ      65
     C     PTYP          OREQ      68                                                          21376
     C     PTYP          OREQ      71                                                         251453
     C                   EXSR      #LPPUR                                       Participation pur.
     C     PTYP          WHENEQ    66
     C     PTYP          OREQ      67
     C     PTYP          OREQ      69                                                          21376
     C     PTYP          OREQ      72                                                         251453
     C                   EXSR      #LPSLD                                       Particiaption sold
     C                   ENDSL
      *
     C                   ENDIF
      *
     C     RECI          IFEQ      'M'                                                           LLN
     C     @MATS         ANDEQ     ' '                                                           LLN
     C                   MOVEL     'Y'           ULVALD                                          LLN
     C                   MOVEL     'Y'           MAFLAG                                          LLN
     C                   EXSR      #LRPXT                                                        LLN
     C******************   EXSR #LRPXT                                      LLN021
     C                   END                                                                     LLN
     C                   MOVEL     ' '           @MATS             1                             LLN
     C                   MOVEL     ' '           MAFLAG            1                             LLN
     C***********ULBRCA    READECLOANB                   89                 LLN021
     C     ULBRCA        READE     BYLOANV0                               89                     LLN
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
      * #LBRCH - Processing For New Branch                            *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:      SR/#LRPTT - Final Report Processing               *
      *                                                               *
      *****************************************************************
      *
     C     #LBRCH        BEGSR                                                  ** SR/#LBRCH**
      *
      *  Reset flag
     C                   MOVE      'N'           ULIBOE                         Include branch
     C**********           MOVE A8BRCD    ULBRCA                          LLN012
      *
      *  If single branch all records must be extracted
     C     AGMBIN        IFEQ      'N'
     C                   MOVE      'Y'           ULIBOE
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
      *   Reset open flag
     C                   MOVE      'N'           ULOPNF
      *
      *   Check if new branch is to be included in report extract
     C********** ULBRCA    CHAINSDBRCHY9             90                                      LLN016
     C     ULBRCA        CHAIN     BYBRCHY0                           90
     C     *IN90         IFEQ      *OFF
     C                   MOVEL     A8IBOE        ULIBOE
     C                   ENDIF
      *
      *   Include branch in Bank of England Extract
     C     ULIBOE        IFEQ      'Y'
      *
     C                   MOVE      'Y'           ULOPNF
     C                   OPEN      BY2030P1
     C                   OPEN      BY2030P2
      *
      *  RCF processing for printer file BY2030P1
     C                   Z-ADD     ULNUM1        ULSFNO
     C                   CALL      'ZSFILE'
     C                   PARM                    ULRSEQ
     C                   PARM                    ULBRCA
     C                   PARM      'BY2030P1'    ULFNAM
     C                   PARM                    ULSFNO
     C                   PARM                    ULRTCD
     C     ULRTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 01 *
     C                   MOVEL     'ZSFILE  '    DBFILE                         ************
     C                   Z-ADD     01            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *  RCF processing for printer file BY2030P2
     C                   Z-ADD     ULNUM2        ULSFNO
     C                   CALL      'ZSFILE'
     C                   PARM                    ULRSEQ
     C                   PARM                    ULBRCA
     C                   PARM      'BY2030P2'    ULFNAM
     C                   PARM                    ULSFNO
     C                   PARM                    ULRTCD
     C     ULRTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 02 *
     C                   MOVEL     'ZSFILE  '    DBFILE                         ************
     C                   Z-ADD     02            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Write report headings to BY2030P1 and BY2030P2
     C                   MOVE      L0RPDA        L#RPDA
     C                   MOVE      A8BRCD        L#BRCD
     C                   MOVE      A8BRNM        L#BRNM
     C                   WRITE     BY2030H1
     C                   WRITE     BY2030H2
      *
     C                   ENDIF
     C                   ENDIF
      *
      *  Initial currency summary arrays
     C                   Z-ADD     0             @TAC                            Tot assets ccy
     C                   Z-ADD     0             @TAS                            Tot assets STG
     C                   Z-ADD     0             @TLC                            Tot liab ccy
     C                   Z-ADD     0             @TLS                            Tot liab STG
      *                                                                                      BUG7606
      ** Reset previous customer work field when a change of branch occurs                   BUG7606
      ** to allow printing of 'Customer' in the report even the previous                     BUG7606
      ** record has the same customer                                                        BUG7606
      *                                                                                      BUG7606
     C**********           Z-ADD0         ULCUS1                                      BUG7606 CSD027
     C**********           Z-ADD0         ULCUS2                                      BUG7606 CSD027
     C                   MOVE      *BLANKS       ULCUS1
     C                   MOVE      *BLANKS       ULCUS2
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LRSET - Reset work fields for loan deal read              *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #LRSET        BEGSR
      *
      *   Clear file formats to reset fields
     C                   CLEAR                   BYEXDTD0                       Extraced details
     C***********          CLEARBYNETDD0                   Netted items                     LLN016
     C***********          CLEARCLOAND9                    Loan extensteion file            LLN016
     C                   CLEAR                   BYLOAND0                       Loan extensteion fil
      *
      *  Reset work fields
     C**********           Z-ADD0         ULCNUM           Customer no.                       CSD027
     C                   MOVE      *BLANKS       ULCNUM                         Customer no.
     C**********           Z-ADD0         ULGTCN           Grt cust no.                       CSD027
     C                   MOVE      *BLANKS       ULGTCN                         Grt cust no.
     C**********           Z-ADD0         ULLNRF           Loan ref.                        MD034876
     C                   MOVE      *BLANKS       ULLNRF                         Loan ref.
     C                   Z-ADD     0             ULMATD                         Maturity date
     C                   Z-ADD     0             ULMDAT                         Maturity date
     C                   Z-ADD     0             ULVDAT                         Value date
     C                   Z-ADD     0             ULDDAT                         Deal date
     C                   Z-ADD     0             ULNRPD                         Next rep dat
     C                   Z-ADD     0             ULRAMT                         Repay amt
     C                   Z-ADD     0             ULREPT                         Repay type
     C                   MOVE      *BLANK        ULRFRQ                         Freq code
     C                   Z-ADD     0             ULRDYN                         Repay day no.
     C                   Z-ADD     0             ULCPAM                         Currt principal
     C                   Z-ADD     0             ULPTYP                         Proc. type
     C                   MOVE      'N'           ULGTEE                         Guarantees
     C*********            MOVE 'N'       ULLENT           Netting flag                   LLN016
     C                   MOVE      *BLANK        ULCYCD                         Currency
     C                   MOVE      *BLANK        ULLTYP                         Loan type
     C                   MOVE      *BLANK        ULSUTP                         Loan subtype
     C                   MOVE      *BLANK        ULGTRF                         Gr loan ref.
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LFIXL - Format field for call/Fixed loans                    *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:      SR/#LCCYD - Get Currency Details                  *
      *             SR/#LVALD - Validate Loan Details                 *
      *             SR/#LGTEE - Get Guarantees For Loan               *
      *             SR/#LRPAY - Process Repayment Events For Loan     *
      *                                                               *
      *****************************************************************
      *
     C     #LFIXL        BEGSR                                                              **
      *
      * Set up work fields
     C**********           Z-ADDCNUM      ULCNUM           Customer no.                       CSD027
     C                   MOVE      CNUM          ULCNUM                         Customer no.
     C                   MOVEL     CCY           ULCYCD                         Currency
     C                   MOVEL     LTYP          ULLTYP                         Loan type
     C                   MOVEL     SUTP          ULSUTP                         Loan subtype
     C                   MOVE      LNRF          ULGTRF                         Gr loan ref.
     C                   MOVEL     'L'           ULGTRF
     C**********           Z-ADDCNUM      ULGTCN           Grt cust no.                       CSD027
     C                   MOVE      CNUM          ULGTCN                         Grt cust no.
     C                   MOVEL     LNRF          ULLNRF                         Loan ref.
     C                   Z-ADD     MDAT          ULMATD                         Maturity date
     C                   Z-ADD     VDAT          ULVDAT                         Value date
     C                   Z-ADD     DDAT          ULDDAT                         Deal date
     C                   Z-ADD     NRPD          ULNRPD                         Next rep dat
     C                   Z-ADD     RAMT          ULRAMT                         Repay amt
     C                   Z-ADD     REPT          ULREPT                         Repay type
     C                   MOVE      RFRQ          ULRFRQ                         Freq code
     C                   Z-ADD     RDYN          ULRDYN                         Repay day no.
     C                   Z-ADD     CPAM          ULCPAM                         Currt principal
     C                   MOVE      PTYP          ULPTYP                         Proc. type
      *
      *  Set maturity date for call loans with no maturity date
     C     PTYP          IFEQ      61
     C     MDAT          ANDEQ     0
     C     VDAT          IFLE      BJDNWD
     C                   Z-ADD     BJDNWD        ULMATD
     C                   ELSE
     C     VDAT          ADD       1             ULMATD
     C                   ENDIF
     C                   ENDIF
      *
      * Set overdue indicator if loan has reached maturity but not repaid
     C                   MOVE      ' '           ULODIN
     C     ULPCOD        IFNE      1590
     C     ULMATD        ANDLT     ULODT1                                       14 Days overdue
     C     ULPCOD        OREQ      1590
     C     ULMATD        ANDLT     ULODT2                                       28 Days Overdue
     C                   MOVE      'Y'           ULODIN
     C                   ENDIF
      *
      *  Get book codes extension fiel bank/trade inicator
     C********** BOKC      CHAINSDBOOKY9             90                                     LLN016
     C     BOKC          CHAIN     BYBOOKY0                           90
     C     *IN90         IFEQ      *OFF
     C                   MOVE      LTRDI         ULRTYP
     C                   ELSE
     C                   MOVE      'B'           ULRTYP                         Record type
     C                   END
      *
      * Get extension file details
     C                   MOVE      *BLANKS       LFMAT                                         LLN02
     C********** ULLNRF    CHAINCLOAND9              90                                      LLN016
     C     ULLNRF        CHAIN     BYLOAND0                           90
     C     *IN90         IFEQ      *ON
     C     LLNTP         OREQ      *BLANK
     C                   MOVE      '9'           ULLNTP
     C                   ELSE
     C                   MOVE      LLNTP         ULLNTP
     C                   ENDIF
      *                                                                   LLN020
      * Set loan maturity date to final maturity date                     LLN020
     C     LFMAT         IFNE      *BLANKS                                                     LLN02
     C                   MOVEL     LFMAT         ZDATEA            6                           LLN02
     C                   CALL      'ZDATE1'                                                    LLN02
     C***********          PARM           ZDATEA                          LLN020210788
     C***********          PARM           ZDAYNO  50                      LLN020210788
     C***********          PARM           BJDFIN                          LLN020210788
     C***********          PARM           ERROR   1                       LLN020210788
     C                   PARM      *BLANKS       ERROR             7                           21078
     C                   PARM                    ZDATEA                                        21078
     C                   PARM                    BJDFIN                                        21078
     C                   PARM                    ZDAYNO            5 0                         21078
     C     ERROR         IFEQ      *BLANKS                                                     LLN02
     C                   Z-ADD     ZDAYNO        ULMATD                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN020
      *
      * Get currency detail
     C                   EXSR      #LCCYD
      *
      * Validate loan details
     C                   EXSR      #LVALD
      *
      *
      * Do not report/extract details for product code 9998
     C     ULPCOD        IFNE      9998
      *
      * Process any guarantees for the loan
     C                   EXSR      #LGTEE
      *
      * Read all repayments for loan
     C                   EXSR      #LRPAY
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LPPUR - Format field for Participation Purchased Loans       *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:      SR/#LCCYD - Get Currency Details                  *
      *             SR/#LVALD - Validate Loan Details                 *
      *             SR/#LGTEE - Get Guarantees For Loan               *
      *             SR/#LRPAY - Process Repayment Events For Loan     *
      *                                                               *
      *****************************************************************
      *
     C     #LPPUR        BEGSR                                                              **
      *
      *  Initialise work fields
     C**********           Z-ADDOLNO      ULCNUM           customer no.                       CSD027
     C                   MOVE      OLNO          ULCNUM                         customer no.
     C                   MOVEL     CCY           ULCYCD                         Currency
     C                   MOVEL     LTYP          ULLTYP                         loan type
     C                   MOVEL     SUTP          ULSUTP                         loan subtype
     C                   MOVE      LNRF          ULGTRF                         Gr loan ref.
     C                   MOVEL     'L'           ULGTRF
     C**********           Z-ADDCNUM      ULGTCN           Grt cust no.                       CSD027
     C                   MOVE      CNUM          ULGTCN                         Grt cust no.
     C                   MOVEL     LNRF          ULLNRF                         Loan ref
     C                   Z-ADD     MDAT          ULMATD                         Maturity date
     C                   Z-ADD     VDAT          ULVDAT                         Value date
     C                   Z-ADD     DDAT          ULDDAT                         Deal date
     C                   Z-ADD     NRPD          ULNRPD                         next rep dat
     C                   Z-ADD     RAMT          ULRAMT                         repay amt
     C                   Z-ADD     REPT          ULREPT                         Repay type
     C                   MOVE      RFRQ          ULRFRQ                         Freq code
     C                   Z-ADD     RDYN          ULRDYN                         Repay day no.
     C                   Z-ADD     CPAM          ULCPAM                         Currt principal
     C                   MOVE      PTYP          ULPTYP                         Proc. type
      *                                                                   213767
      *  Set maturity date for call loans with no maturity date           213767
     C     PTYP          IFEQ      68                                                          21376
     C     MDAT          ANDEQ     0                                                           21376
     C     VDAT          IFLE      BJDNWD                                                      21376
     C                   Z-ADD     BJDNWD        ULMATD                                        21376
     C                   ELSE                                                                  21376
     C     VDAT          ADD       1             ULMATD                                        21376
     C                   ENDIF                                                                 21376
     C                   ENDIF                                                                 21376
      *
      *  Get book codes extension fiel bank/trade inicator
     C********** BOKC      CHAINSDBOOKY9             90                                      LLN016
     C     BOKC          CHAIN     BYBOOKY0                           90
     C     *IN90         IFEQ      *OFF
     C                   MOVE      LTRDI         ULRTYP
     C                   ELSE
     C                   MOVE      'B'           ULRTYP                         Record type
     C                   END
      *
      * Set overdue indicator if loan has reached maturity but not repaid
     C                   MOVE      ' '           ULODIN
     C     ULPCOD        IFNE      1590
     C     ULMATD        ANDLT     ULODT1                                       14 Days overdue
     C     ULPCOD        OREQ      1590
     C     ULMATD        ANDLT     ULODT2                                       28 Days Overdue
     C                   MOVE      'Y'           ULODIN
     C                   ENDIF
      *
      * Get currency detail
     C                   EXSR      #LCCYD
      *
      *
      * Validate loan details
     C                   EXSR      #LVALD
      *
      *
      * Do not report/extract details for product code 9998
     C     ULPCOD        IFNE      9998
      *
      * Process any guarantees for the loan
     C                   EXSR      #LGTEE
      *
      *
      * Read all repayments for loan
     C                   EXSR      #LRPAY
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LPSLD - Process paricipation sold loans                      *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls:      SR/#LCCYD - Get Currency Details                  *
      *             SR/#LVALD - Validate Loan Details                 *
      *             SR/#LGTEE - Get Guarantees For Loan               *
      *             SR/#LRPAY - Process Repayment Events For Loan     *
      *                                                               *
      *****************************************************************
      *
     C     #LPSLD        BEGSR                                                              **
      *
      * Set up work fields
     C                   MOVEL     CCY           ULCYCD                         Currency
     C                   MOVEL     LTYP          ULLTYP                         Loan type
     C                   MOVEL     SUTP          ULSUTP                         Loan subtype
     C                   Z-ADD     MDAT          ULMATD                         Maturity date
     C                   Z-ADD     VDAT          ULVDAT                         Value date
     C                   Z-ADD     DDAT          ULDDAT                         Deal date
     C                   Z-ADD     NRPD          ULNRPD                         next rep dat
     C                   Z-ADD     RAMT          ULRAMT                         repay amt
     C                   Z-ADD     REPT          ULREPT                         Repay type
     C                   MOVE      RFRQ          ULRFRQ                         Freq code
     C                   Z-ADD     RDYN          ULRDYN                         Repay day no.
     C                   Z-ADD     CPAM          ULCPAM                         Currt principal
     C                   MOVEL     LNRF          ULLNRF                         LOAN REF.
     C                   MOVE      PTYP          ULPTYP                         Proc. type
      *                                                                   213767
      *  Set maturity date for call loans with no maturity date           213767
     C     PTYP          IFEQ      69                                                          21376
     C     MDAT          ANDEQ     0                                                           21376
     C     VDAT          IFLE      BJDNWD                                                      21376
     C                   Z-ADD     BJDNWD        ULMATD                                        21376
     C                   ELSE                                                                  21376
     C     VDAT          ADD       1             ULMATD                                        21376
     C                   ENDIF                                                                 21376
     C                   ENDIF                                                                 21376
      *
      *  Get book codes extension fiel bank/trade inicator
     C********** BOKC      CHAINSDBOOKY9             90                                     LLN016
     C     BOKC          CHAIN     BYBOOKY0                           90
     C     *IN90         IFEQ      *OFF
     C                   MOVE      LTRDI         ULRTYP
     C                   ELSE
     C                   MOVE      'B'           ULRTYP                         Record type
     C                   END
      *
      * Set overdue indicator if loan has reached maturity but not repaid
     C                   MOVE      ' '           ULODIN
     C     ULPCOD        IFNE      1590
     C     ULMATD        ANDLT     ULODT1                                       14 Days overdue
     C     ULPCOD        OREQ      1590
     C     ULMATD        ANDLT     ULODT2                                       28 Days Overdue
     C                   MOVE      'Y'           ULODIN
     C                   ENDIF
      *
      * Get currency detail
     C                   EXSR      #LCCYD
      *
      * Get original loan from LF/CLOAN
     C**********           Z-ADDOLNO      LNRF
     C                   MOVE      OLNO          LNRF
     C                   MOVE      'A'           RCDT
     C     CLOANK        CHAIN     CLOAN                              90
     C     *IN90         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     OLNO          DBKEY                          * DBERR 03 *
     C                   MOVEL     'CLOAN   '    DBFILE                         ************
     C                   Z-ADD     03            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If original loan is participation purchased loan, use
      * original borrower otherwise use loan customer for customer No.
     C     PTYP          IFEQ      64
     C     PTYP          OREQ      65
     C     PTYP          OREQ      68                                                          21376
     C**********           Z-ADDOLNO      ULCNUM                                              CSD027
     C                   MOVE      OLNO          ULCNUM
     C                   ELSE
     C**********           Z-ADDCNUM      ULCNUM           customer no.                       CSD027
     C                   MOVE      CNUM          ULCNUM                         customer no.
     C                   ENDIF
      *
     C                   MOVE      LNRF          ULGTRF                         Gr loan ref.
     C                   MOVEL     'L'           ULGTRF                         Gr loan ref.
     C**********           Z-ADDCNUM      ULGTCN           Grt cust no.                       CSD027
     C                   MOVE      CNUM          ULGTCN                         Grt cust no.
      *
      *
      * Save loan type/sub-type of original loan being processed and
      * get extract criteria for original loan loan type/sub-type
     C                   MOVE      ULLTYP        SVLTYP            2
     C                   MOVE      ULSUTP        SVSUTP            2
     C                   MOVE      LTYP          ULLTYP
     C                   MOVE      SUTP          ULSUTP
      *
      * Validate loan details
     C                   EXSR      #LVALD
      *
      * Restore loan type/sub-type of loan being processed
     C                   MOVE      SVLTYP        ULLTYP
     C                   MOVE      SVSUTP        ULSUTP
      *
      * Do not report/extract details for product code 9998
     C     ULPCOD        IFNE      9998
      *
      *
      * Process any guarantees for the loan
     C                   EXSR      #LGTEE
      *
      *
      * Read all repayments for loan
     C                   EXSR      #LRPAY
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LVALD - Validate Details For Extract                         *
      *                                                               *
      * Called by:  SR/#LFIXL - Process Fixed/Term Loans              *
      *             SR/#LPPUR - Participation Purchase Loans          *
      *             SR/#LPSLD - Participation Sold Loans              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #LVALD        BEGSR                                                  ** SR/#LVALD**
      *
      *  Validate customer and retrieve details if customer has changed
     C     ULCNUM        IFNE      ULPCUS
     C                   CLEAR                   SDCUST
     C                   CLEAR                   SDCUS7
     C                   CLEAR                   SDCUSX
     C                   MOVE      ULCNUM        ULCUST                         Customer
     C                   CALL      'BY9110'
     C                   PARM                    ULCUST                         Customer number
     C                   PARM                    SDCUST                         SDCUSTPD details
     C                   PARM                    SDCUS7                         SDCUSTX7 details
     C                   PARM                    SDCUSX                         Extra details
     C                   PARM      0             ULERR1
     C                   PARM      *BLANK        ULRTCD                         Return code
     C     ULRTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 07 *
     C                   MOVEL     'BY9110  '    DBFILE                         ************
     C                   Z-ADD     07            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Set valid indicator
     C     ULERR1        IFNE      0
     C                   MOVE      'N'           ULVALD                         Invalid
     C                   ELSE
     C                   MOVE      'Y'           ULVALD                         Valid deal
     C                   ENDIF
      *
      *  Save customer
     C**********           Z-ADDULCNUM    ULPCUS           Previous customer                  CSD027
     C                   MOVE      ULCNUM        ULPCUS                         Previous customer
     C                   ENDIF
      *
      *
      *
      *  Check extract criteria exists for LOAN
     C                   MOVE      ULLTYP        L3LTYP                         Loan type
     C                   MOVE      ULSUTP        L3LNST                         Loan subtype
     C                   MOVE      BBLINC        L3LINS                         Institution code
     C                   MOVE      BBLICD        L3MIND                         Industry
      *                                                                                      LLN021
      *  Check extract criteria exists using Industry code                                   LLN021
     C     L3KEY         CHAIN     BYLEEXD0                           90
     C     *IN90         IFEQ      *ON
     C                   MOVE      *BLANKS       L3MIND
     C                   END
      *                                                                                      LLN021
     C     *IN90         IFEQ      *ON
     C     L3KEY         CHAIN     BYLEEXD0                           90
     C     *IN90         IFEQ      *ON
     C                   Z-ADD     0             L3LINS                         Institution code
     C     L3KEY         CHAIN     BYLEEXD0                           90
     C                   ENDIF
     C                   ENDIF
     C*                                                                                      LLN021
     C     *IN90         IFEQ      *ON
     C                   MOVE      *ON           *IN41
     C                   Z-ADD     9999          ULPCOD
     C                   ELSE
     C                   MOVE      *OFF          *IN41
     C                   Z-ADD     L3PCOD        ULPCOD
     C**********           MOVE LDLENT    ULLENT                                           LLN016
      *                                                                   LLN012
      ** If loan is non-performing set the overdue indicator              LLN012
     C     L3NPER        IFEQ      'Y'                                                         LLN01
     C                   MOVE      'Y'           ULODIN                                        LLN01
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
     C                   ENDIF
      *
      *  Set country of risk to ISO code of country of citizenship
     C                   MOVE      ULCISO        ULRISO
      *
      *  Get ISO code for loan country of risk
     C                   CALL      'AOCTRYR0'                           90
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY  '      P@OPTN            7
     C                   PARM      CRSK          P@KEY1            2
     C                   PARM      *BLANKS       SDCTRY
      *
      *
      *  If product code is 1590 override customer country code and
      *  country of risk code
     C     ULPCOD        IFEQ      1590
     C                   MOVE      'GB'          ULRISO
     C     ULLISO        IFEQ      'GB'
     C**********           MOVE A4ISOC    ULLISO                                              LLN022
     C                   MOVE      CRSK          ULLISO
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LGTEE - Process guarantee for each loan                      *
      *                                                               *
      * Called by:  SR/#LFIXL - Process Fixed/Term Loans              *
      *             SR/#LPPUR - Participation Purchase Loans          *
      *             SR/#LPSLD - Participation Sold Loans              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #LGTEE        BEGSR                                                              **
      *
      * Reset fiedls
     C                   Z-ADD     0             I                 3 0          Array Index
     C                   Z-ADD     0             J                 3 0          Array Index
     C                   Z-ADD     0             @GRB
     C                   MOVEA     *BLANK        @GRA
     C                   MOVE      'N'           ULGTEE                         Guarantees
      *
      *
      * Position guarantee file
     C*******    GTKEY     SETLLBYGTEEV0                                     LLN021
     C*******    GTKEY     READEBYGTEEV0                 87                  LLN021
     C     GTKEY         SETLL     BYGTEEV1                                                       LL
     C     GTKEY         READE     BYGTEEV1                               87                      LL
     C     *IN87         DOWEQ     *OFF
      *
      *                                                                      LLN021
      * Process guarantees if the start date is less than or equal
      * to the extract date and the end date is after the extract date
     C     STTD          IFLE      L0RPDT
     C     EDDT          ANDGT     L0RPDT
     C                   MOVE      'Y'           ULGTEE                         Guarantees
      *
      * Convert amount if guarantee currency not same as loan currency
     C     CCY           IFNE      ULCYCD
     C     TAMT          IFNE      0
     C                   CALL      'BY9070'
     C                   PARM      TAMT          ULINAM                         In amount
     C                   PARM      CCY           ULFCCY                         From currency
     C                   PARM      *ZERO         ULOTAM                         Converted amount
     C                   PARM      ULCYCD        ULTCCY                         To currency
     C                   PARM      *BLANK        ULRTCD                         Return code
     C                   ELSE
     C                   Z-ADD     0             ULOTAM
     C                   ENDIF
     C     ULRTCD        IFNE      ' '
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 04 *
     C                   MOVEL     'BY9070  '    DBFILE                         ************
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     TAMT          ULOTAM
     C                   ENDIF
      *
      * Accumulate total guarantee amount by country of risk
     C                   Z-ADD     1             I
     C     GCRK          LOOKUP    @GRA(I)                                90
     C     *IN90         IFEQ      *ON
     C                   ADD       ULOTAM        @GRB(I)
     C                   ELSE
     C                   ADD       1             J
     C                   MOVE      GCRK          @GRA(J)
     C                   Z-ADD     ULOTAM        @GRB(J)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C********** GTKEY     READEBYGTEEV0                 87                  LLN021
     C     GTKEY         READE     BYGTEEV1                               87                      LL
     C                   ENDDO
      *
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LRPAY - Process all Repayment Events For Loan             *
      *                                                               *
      * Called by:  SR/#LFIXL - Process Fixed/Term Loans              *
      *             SR/#LPPUR - Participation Purchase Loans          *
      *             SR/#LPSLD - Participation Sold Loans              *
      *                                                               *
      * Calls:      SR/#LRPYD - Process Repayment Event               *
      *                                                               *
      *****************************************************************
     C     #LRPAY        BEGSR                                                              **
      *
      * If forward valued loan then output two records to 7800
     C     ULVDAT        IFGT      L0RPDT
     C****                 EXSR #LFWDV                                    LLN012
     C                   ELSE
      *
      * Initialise fields used by ZFREQB
     C                   MOVE      ULRFRQ        ZFREQ                          Freq code
     C                   Z-ADD     ULRDYN        ZMDAY                          Repay day no.
     C                   MOVEL     ULCYCD        ZCCY                           Currency
      *                                                                   LLN012
      * Flag existing extract records                                     LLN012
     C                   MOVE      'Y'           L8BTEX                                        LLN01
     C                   MOVE      'N'           L8LREX                                        LLN01
      *
      * Get next repayment schedule if one exists
     C                   MOVE      *OFF          *IN86
     C                   Z-ADD     99999         ULVLDT
     C     *LOVAL        SETLL     LOAMS
     C     LOAMK         SETLL     LOAMS
     C     *IN86         DOWEQ     *OFF
     C     ULLNRF        READE     LOAMS                                  86
     C     AMTP          IFEQ      'RE'
     C     *IN86         ANDEQ     *OFF
     C                   Z-ADD     VDAT          ULVLDT
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
      * Set next repayment date to maturity if none due
     C     ULNRPD        IFEQ      0
     C                   Z-ADD     ULMATD        ULNRPD
     C                   ENDIF
      *
      *
      *  Process all repayments until maturity
     C     ULNRPD        DOWLT     ULMATD
     C     ULCPAM        ANDGT     0
     C     *IN86         OREQ      *OFF
     C     ULCPAM        ANDGT     0
      *
      *  Generate an extract record for a repayment schedule event
     C     *IN86         IFEQ      *OFF
     C     ULVLDT        IFLE      ULNRPD
     C     ULNRPD        ORGE      ULMATD
     C                   Z-ADD     PRAM          ULCUAS
      *
      *  Reduce principal amount by repayment amount
      *   (If repayment is greater than principal use o/s principal)
     C     ULCUAS        IFLE      ULCPAM
     C                   SUB       ULCUAS        ULCPAM
     C                   ELSE
     C                   Z-ADD     ULCPAM        ULCUAS
     C                   Z-ADD     0             ULCPAM
     C                   ENDIF
      *
     C                   Z-ADD     VDAT          ULVLDT
     C                   Z-ADD     VDAT          ULMDAT
     C                   EXSR      #LRPYD                                       Output repayment
     C     *IN86         DOWEQ     *OFF
     C     ULLNRF        READE     LOAMS                                  86
     C     AMTP          IFEQ      'RE'
     C     *IN86         ANDEQ     *OFF
     C                   Z-ADD     VDAT          ULVLDT
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
      *
      *  Generate a repayment event for generated repayment
     C     ULNRPD        IFLE      ULVLDT
     C     *IN86         ANDEQ     *OFF
     C     *IN86         OREQ      *ON
     C     ULNRPD        ANDLT     ULMATD
      *
      *  Reset event currency amount field
     C                   Z-ADD     0             ULCUAS
      *
      *  If repayment type is 3 get details from loan events
     C     ULREPT        IFEQ      3
     C     K1LVNT        KLIST
     C                   KFLD                    ULLNRF
     C                   KFLD                    ULNRPD
     C     *LOVAL        SETLL     LVENTELF
     C     K1LVNT        SETLL     LVENTELF                           90
     C     K1LVNT        READE     LVENTELF                               90
     C     *IN90         DOWEQ     *OFF
     C                   MOVE      ETYP          ULETYP            2
     C     ULETYP        IFEQ      'R1'
     C                   Z-ADD     EAMT          ULCUAS
     C                   LEAVE
     C                   ENDIF
     C     K1LVNT        READE     LVENTELF                               90
     C                   ENDDO
      *
      *  Other repayment types use the repayment amount field
     C                   ELSE
     C                   Z-ADD     ULRAMT        ULCUAS
     C                   ENDIF
      *
      *  Reduce principal amount by repayment amount
      *   (If repayment is greater than principal use o/s principal)
     C     ULCUAS        IFLE      ULCPAM
     C                   SUB       ULCUAS        ULCPAM
     C                   ELSE
     C                   Z-ADD     ULCPAM        ULCUAS
     C                   Z-ADD     0             ULCPAM
     C                   ENDIF
      *
      *  Generate extract record for repayment event
     C     ULCUAS        IFNE      0
     C                   Z-ADD     ULNRPD        ULMDAT
     C                   EXSR      #LRPYD                                       Output repayment
     C                   ENDIF
      *
      *  Generate next repayment event date
     C     ZFREQ         IFNE      *BLANK
     C                   Z-ADD     ULNRPD        ZDAYNO
     C                   EXSR      ZFREQB
     C                   Z-ADD     ZDAYNO        ULNRPD                         Next repay date
     C                   ELSE
     C                   Z-ADD     ULMATD        ULNRPD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
      *
      * Output remaining principal at maturity
     C     ULCPAM        IFGT      *ZERO
     C                   Z-ADD     ULMATD        ULMDAT
     C                   Z-ADD     ULCPAM        ULCUAS
     C                   EXSR      #LRPYD                                       Output repayment
     C                   ENDIF
      *                                                                   LLN012
      *                                                                   LLN012
      * Liquidity Reporting is on                                         LLN012
     C     LLN012        IFEQ      'Y'                                                         LLN01
      *                                                                   LLN012
      * Set extract flags                                                 LLN012
     C                   MOVE      'N'           L8BTEX                                        LLN01
     C                   MOVE      'Y'           L8LREX                                        LLN01
      *                                                                   LLN012
      * Save product code from extract                                    LLN012
     C                   Z-ADD     ULPCOD        ULPCDS            4 0                         LLN01
      *                                                                   LLN012
      ** Save Current Overdue Indicator field                             LLN012
     C     *LIKE         DEFINE    ULODIN        ULOVIN                         Overdue Ind.   LLN01
     C                   MOVEL     ULODIN        ULOVIN                                        LLN01
      *                                                                   LLN012
      * Read all records for loan being processed                         LLN012
     C     K2LVNT        SETLL     LOAMS                              85                       LLN01
     C     K2LVNT        READE     LOAMS                                  85                   LLN01
     C     *IN85         DOWEQ     *OFF                                                        LLN01
      *                                                                   LLN012
      ** Past due record found                                            LLN012
     C     AMTP          IFEQ      'PD'                                                        LLN01
      *                                                                   LLN012
      * Set overdue indicator if loan has reached maturity but not repaid LLN012
     C     ULPCOD        IFNE      1590                                                        LLN01
     C     VDAT          ANDLT     ULODT1                                       14 Days OverdueLLN01
     C     ULPCOD        OREQ      1590                                                        LLN01
     C     VDAT          ANDLT     ULODT2                                       28 Days OverdueLLN01
     C     L3NPER        OREQ      'Y'                                                         LLN01
     C                   MOVE      'Y'           ULODIN                                        LLN01
      *                                                                   LLN012
      * Report/extract record for principal amount                        LLN012
     C     PRAM          IFNE      *ZERO                                                       LLN01
     C                   MOVE      PRAM          ULCUAS                                        LLN01
      *                                                                   LLN012
      *  Convert amount to sterling                                       LLN012
     C     ULCYCD        IFEQ      BLCYCD                                                      LLN01
     C                   Z-ADD     ULCUAS        ULSGAM                                        LLN01
     C                   ELSE                                                                  LLN01
     C     ULCUAS        IFNE      0
     C                   CALL      'BY9070'                                                    LLN01
     C                   PARM      ULCUAS        ULINAM                                        LLN01
     C                   PARM      ULCYCD        ULFCCY                                        LLN01
     C                   PARM      *ZERO         ULOTAM                                        LLN01
     C                   PARM      BLCYCD        ULTCCY                                        LLN01
     C                   PARM      *BLANK        ULRTCD                                        LLN01
     C                   ELSE
     C                   Z-ADD     0             ULOTAM
     C                   ENDIF
     C     ULRTCD        IFNE      ' '                                                         LLN01
     C     *LOCK         IN        LDA                                                         LLN01
     C                   MOVEL     ULPGMN        DBPGM                          ************   LLN01
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 86 *   LLN01
     C                   MOVEL     'BY9070  '    DBFILE                         ************   LLN01
     C                   Z-ADD     86            DBASE                                         LLN01
     C                   OUT       LDA                                                         LLN01
     C                   EXSR      *PSSR                                                       LLN01
     C                   ENDIF                                                                 LLN01
     C                   Z-ADD     ULOTAM        ULSGAM                                        LLN01
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
     C                   MOVE      PRAM          ULCUAS                                        LLN01
     C                   MOVE      BJRDNB        ULMDAT                                        LLN01
     C                   MOVE      'P'           ULEVTP                                        LLN01
      *                                                                   LLN012
     C                   EXSR      #LRPXT                                                      LLN01
      *                                                                   LLN012
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
      * Report/extract record for interest amount                         LLN012
     C     INTA          IFNE      *ZERO                                                       LLN01
      *                                                                   LLN012
      *  Convert amount to sterling                                       LLN012
     C     ULCYCD        IFEQ      BLCYCD                                                      LLN01
     C                   Z-ADD     ULCUAS        ULSGAM                                        LLN01
     C                   ELSE                                                                  LLN01
     C     ULCUAS        IFNE      0
     C                   CALL      'BY9070'                                                    LLN01
     C                   PARM      ULCUAS        ULINAM                                        LLN01
     C                   PARM      ULCYCD        ULFCCY                                        LLN01
     C                   PARM      *ZERO         ULOTAM                                        LLN01
     C                   PARM      BLCYCD        ULTCCY                                        LLN01
     C                   PARM      *BLANK        ULRTCD                                        LLN01
     C                   ELSE
     C                   Z-ADD     0             ULOTAM
     C                   ENDIF
     C     ULRTCD        IFNE      ' '                                                         LLN01
     C     *LOCK         IN        LDA                                                         LLN01
     C                   MOVEL     ULPGMN        DBPGM                          ************   LLN01
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 8  *   LLN01
     C                   MOVEL     'BY9070  '    DBFILE                         ************   LLN01
     C                   Z-ADD     87            DBASE                                         LLN01
     C                   OUT       LDA                                                         LLN01
     C                   EXSR      *PSSR                                                       LLN01
     C                   ENDIF                                                                 LLN01
     C                   Z-ADD     ULOTAM        ULSGAM                                        LLN01
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
     C                   MOVE      INTA          ULCUAS                                        LLN01
     C                   MOVE      BJRDNB        ULMDAT                                        LLN01
     C                   MOVE      'I'           ULEVTP                                        LLN01
      *                                                                   LLN012
     C                   EXSR      #LRPXT                                                      LLN01
      *                                                                   LLN012
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
     C     K2LVNT        READE     LOAMS                                  85                   LLN01
      *                                                                   LLN012
     C                   ENDDO                                                                 LLN01
      *                                                                   LLN012
      ** Reset Overdue Indicator to original value for loan               LLN012
     C                   MOVE      ULOVIN        ULODIN                                        LLN01
      *                                                                   LLN012
      ******************for each processed loan where event date    LLN012168646
      ****************** report extract date                        LLN012168646
      * Read all events for each processed loan where event date          168646
      * is less than or Equal to the report extract date                  168646
     C     K2LVNT        KLIST                                                                 LLN01
     C                   KFLD                    ULLNRF                                        LLN01
     C     K2LVNT        SETLL     LVENTELF                           84                       LLN01
     C     K2LVNT        READE     LVENTELF                               84                   LLN01
     C     *IN84         DOWEQ     *OFF                                                        LLN01
     C***********EDAT      ANDLTL0LRDT                              LLN012168646
     C     EDAT          ANDLE     L0LRDT                                                      16864
      *                                                                   161718
      * Do not extract if event is an interbranch entry and               161718
      * event amount is not zero                                          161718
     C     IBRE          IFNE      'Y'                                                         16171
     C     EAMT          ANDNE     0                                                           16171
      *                                                                   161718
      *                                                                   LLN012
      * Only produce additional extract if event is a cash flow event     LLN012
     C     ETYP          LOOKUP    LLA                                    91                   LLN01
     C     *IN91         IFEQ      *ON                                                         LLN01
      *                                                                   LLN012
      * Set up extract details...                                         LLN012
      * ...Project Code                                                   LLN012
     C     ETYP          IFEQ      '71F1'                                                      LLN01
     C                   Z-ADD     1915          ULPCOD                                        LLN01
     C                   ELSE                                                                  LLN01
     C                   Z-ADD     ULPCDS        ULPCOD                                        LLN01
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
      * ...Currency amount                                                LLN012
     C                   Z-ADD     EAMT          ULCUAS                                        LLN01
      *                                                                   LLN012
      * Reverse the sign if the event is an Outflow                       LLN012
      * .....and is not a participation sold                              165885
     C     INOI          IFEQ      'O'                                                         LLN01
     C***        ULPTYP    ANDNE66                                  165885168698
     C***        ULPTYP    ANDNE67                                  165885168698
     C                   MULT      -1            ULCUAS                                        LLN01
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
      *  Convert amount to sterling                                       LLN012
     C     ULCYCD        IFEQ      BLCYCD                                                      LLN01
     C                   Z-ADD     ULCUAS        ULSGAM                                        LLN01
     C                   ELSE                                                                  LLN01
     C     ULCUAS        IFNE      0
     C                   CALL      'BY9070'                                                    LLN01
     C                   PARM      ULCUAS        ULINAM                                        LLN01
     C                   PARM      ULCYCD        ULFCCY                                        LLN01
     C                   PARM      *ZERO         ULOTAM                                        LLN01
     C                   PARM      BLCYCD        ULTCCY                                        LLN01
     C                   PARM      *BLANK        ULRTCD                                        LLN01
     C                   ELSE
     C                   Z-ADD     0             ULOTAM
     C                   ENDIF
     C     ULRTCD        IFNE      ' '                                                         LLN01
     C     *LOCK         IN        LDA                                                         LLN01
     C                   MOVEL     ULPGMN        DBPGM                          ************   LLN01
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 16 *   LLN01
     C                   MOVEL     'BY9070  '    DBFILE                         ************   LLN01
     C                   Z-ADD     16            DBASE                                         LLN01
     C                   OUT       LDA                                                         LLN01
     C                   EXSR      *PSSR                                                       LLN01
     C                   ENDIF                                                                 LLN01
     C                   Z-ADD     ULOTAM        ULSGAM                                        LLN01
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
      * ...Maturity date                                                  LLN012
     C                   Z-ADD     EDAT          ULMDAT                                        LLN01
      *                                                                   LLN012
      * New extract record                                                LLN012
     C                   MOVE      'N'           L8BTEX                                        LLN01
     C                   MOVE      'Y'           L8LREX                                        LLN01
      *                                                                   LLN012
      * Set-up event type                                                 LLN012
     C                   MOVE      ETYP          ULTYPE            2                           16171
     C     ULTYPE        IFEQ      'I2'                                                        16171
     C     ULTYPE        OREQ      'R2'                                                        16171
     C     ULTYPE        OREQ      'M2'                                                        16171
     C     ULTYPE        OREQ      'X2'                                                        16171
     C                   MOVE      'I'           ULEVTP                                        16171
     C                   ELSE                                                                  16171
     C                   MOVE      'P'           ULEVTP            1                           LLN01
     C                   ENDIF                                                                 16171
      *                                                                   LLN012
      * Report/extract record                                             LLN012
     C                   EXSR      #LRPXT                                                      LLN01
      *                                                                   LLN012
     C                   ENDIF                                                                 LLN01
      *                                                                   161718
     C                   ENDIF                                                                 16171
      *                                                                   LLN012
     C     K2LVNT        READE     LVENTELF                               84                   LLN01
     C                   ENDDO                                                                 LLN01
      *                                                                   LLN012
     C                   ENDIF                                                                 LLN01
      *                                                                   LLN012
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LFWDV - Process Forward Valued Loans                      *
      *                                                               *
      * Called by:  SR/#LFIXL - Process Fixed/Term Loans              *
      *             SR/#LPPUR - Participation Purchase Loans          *
      *             SR/#LPSLD - Participation Sold Loans              *
      *                                                               *
      * Calls:      SR/#LRPXT - Report/Extract Details                *
      *                                                               *
      *****************************************************************
     C     #LFWDV        BEGSR                                                              **
      *
      * Output record to 7800 - Negative amount
     C                   Z-ADD     ULMATD        ULMDAT
     C                   Z-SUB     CPAM          ULCUAS                         Currency amount
     C                   Z-ADD     7800          ULPCOD                         Product code
     C***********          MOVE ULFCNT    ULLENT                                           LLN016
     C                   MOVE      'P'           ULEVTP                         Event type
     C                   EXSR      #LRPXT
      *
      * Output record to 7800 - Positive amount
     C                   Z-ADD     ULMATD        ULMDAT
     C                   Z-ADD     CPAM          ULCUAS                         Currency amount
     C                   Z-ADD     7800          ULPCOD                         Product code
     C***********          MOVE ULFCNT    ULLENT                                           LLN016
     C                   MOVE      'P'           ULEVTP                         Event type
     C                   EXSR      #LRPXT
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LRPYD - Process Each Repayment Event                      *
      *                                                               *
      * Called by:  SR/#LRPAY - Repayments Processing                 *
      *                                                               *
      * Calls:      SR/#LRPXT - Report/Extract Details                *
      *                                                               *
      *****************************************************************
     C     #LRPYD        BEGSR                                                              **
      *
      *
      *  Set currency amount and country of risk
     C                   Z-ADD     ULCUAS        ULCUAT                         Repayment amount
     C                   MOVE      ULRISO        ULRISK                         Country of risk
      *
      *
      *  Create record for extract and reporting according to amount
      *  of loan guaranteed if a guarantee exists and product code
      *  is not '1590' or '7800'
     C     ULPCOD        IFNE      1590
     C     ULPCOD        ANDNE     7800
     C     ULGTEE        ANDEQ     'Y'
     C                   Z-ADD     1             #
     C     @GRA(#)       DOWNE     *BLANK
     C     @GRB(#)       IFNE      0
     C     @GRB(#)       IFGE      ULCUAT
     C                   MOVE      @GRA(#)       ULRISO
     C                   Z-ADD     ULCUAT        ULCUAS
     C                   EXSR      #LRPXT
     C                   SUB       ULCUAT        @GRB(#)
     C                   Z-ADD     0             ULCUAT
     C                   LEAVE
     C                   ELSE
     C                   Z-ADD     @GRB(#)       ULCUAS
     C                   MOVE      @GRA(#)       ULRISO
     C                   EXSR      #LRPXT
     C                   SUB       @GRB(#)       ULCUAT
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             #
     C                   ENDDO
     C                   ENDIF
      *
      *  Restore country of risk
     C                   MOVE      ULRISK        ULRISO
      *
      ** Create record for extract and reporting for non-guaranteed amounts
     C     ULCUAT        IFNE      0
     C                   Z-ADD     ULCUAT        ULCUAS
     C                   MOVE      'P'           ULEVTP
     C                   EXSR      #LRPXT
     C                   END
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LRPXT - Report/Extract Details                            *
      *                                                               *
      * Called by:  SR/#LRPYD - Process Each Repayment Event          *
      *                                                               *
      * Calls:      SR/#LRPT1 - Report Valid Details to BY2020P1      *
      *             SR/#LRPT2 - Report Invalid Details to BY2020P2    *
      *             SR/#LXTRC - Create Extract Record                 *
      *                                                               *
      *****************************************************************
     C     #LRPXT        BEGSR
      *
      * Get maturity category
     C                   CALL      'BY9060'
     C                   PARM                    ULMDAT
     C                   PARM                    ULMCAT                         Maurity categoryy
     C                   PARM                    ULMPER                                         te
     C                   PARM                    ULRTCD
     C     ULRTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 05 *
     C                   MOVEL     'BY9060  '    DBFILE                         ************
     C                   Z-ADD     05            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Participation sold amount must be negative
      * ... only required for BT extract detail                           168698
     C     L8BTEX        IFEQ      'Y'                                                         16869
     C     ULPTYP        IFEQ      66
     C     ULPTYP        OREQ      67
     C     ULPTYP        OREQ      69                                                          21376
     C                   Z-SUB     ULCUAS        ULCUAS
     C                   ENDIF
     C                   ENDIF                                                                 16869
      *
      * Convert currency amount to sterling
     C     ULCYCD        IFNE      BLCYCD
     C     ULCUAS        IFNE      0
     C                   CALL      'BY9070'
     C                   PARM      ULCUAS        ULINAM                         In amount
     C                   PARM      ULCYCD        ULFCCY                         From currency
     C                   PARM      *ZERO         ULOTAM                         Converted amount
     C                   PARM      BLCYCD        ULTCCY                         To currency
     C                   PARM      *BLANK        ULRTCD                         Return code
     C                   ELSE
     C                   Z-ADD     0             ULOTAM
     C                   ENDIF
     C     ULRTCD        IFNE      ' '
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 06 *
     C                   MOVEL     'BY9070  '    DBFILE                         ************
     C                   Z-ADD     06            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     ULOTAM        ULSGAM
     C                   ELSE
     C                   Z-ADD     ULCUAS        ULSGAM
     C                   END
      *
      *
      * Details are valid - report details to BY2030P1
      *                   - create extract record if extract mode
     C     ULVALD        IFEQ      'Y'
     C     ULPCOD        ANDNE     9999
     C     RECI          IFEQ      'D'
     C                   EXSR      #LRPT1
     C                   ENDIF
      *
     C     ULMODE        IFEQ      'EXTRACT'
     C                   EXSR      #LXTRC
     C                   ENDIF
      * Details are invalid - report details to BY2030P2
     C                   ELSE
      *                                                                   163786
      ** Only report invalid details if BT Extract flag is set            163786
     C     L8BTEX        IFEQ      'Y'                                                         16378
     C     RECI          ANDEQ     'D'
     C                   EXSR      #LRPT2                                                      16378
     C                   ENDIF                                                                 16378
      *                                                                   163786
     C                   ENDIF
      *
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LXTRC - Create Extract Record                             *
      *                                                               *
      * Called by: SR/#LRPXT - Report/Extract Details                 *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #LXTRC        BEGSR                                                  ** SR/#LXTRC**
      *
      *  Set up detail fields
     C                   MOVE      ULRTYP        L8RTYP                         Record type
     C                   Z-ADD     ULPCOD        L8PCOD                         Product code
     C**********           Z-ADDULCNUM    L8CUST           Customer                           CSD027
     C                   MOVE      ULCNUM        L8CUST                         Customer
     C                   MOVE      ULCYCD        L8CYCD                         Currency
     C                   MOVEL     ULLNRF        L8TRAN                         Transaction referenc
     C                   MOVE      ULBRCA        L8BRCD                         Branch code
     C                   MOVE      'LE'          L8MMOD                         Module id.
     C                   Z-ADD     ULDDAT        L8DDAT                         Deal date
     C                   Z-ADD     ULVDAT        L8VDAT                         Value date
     C                   Z-ADD     ULMDAT        L8MDAT                         Maturity date
     C                   MOVE      ULMCAT        L8MCAT                         Maturity category
     C                   MOVE      ULLISO        L8ISOC                         Customer country cod
     C                   MOVE      ULRISO        L8RISO                         Risk country code
     C***********          MOVE BBLICD    L8LIND           Industry code  122379             LLN016
     C***********          MOVE BBLINC    L8LINS           Institution code                  LLN016
     C                   MOVE      LLICD         L8LIND                         Industry code  12237
     C                   MOVE      LLINC         L8LINS                         Institution code
     C                   MOVE      A6SWCY        L8CCYS                         SWIFT Currency code
     C     A6SWCY        IFEQ      BLCYCD
     C                   MOVE      'N'           L8NNSI                         Sterling ccy ind.
     C                   ELSE
     C                   MOVE      'Y'           L8NNSI
     C                   ENDIF
     C                   Z-ADD     ULCUAS        L8CUAS                         Currency amount
     C                   Z-ADD     ULSGAM        L8SGAM                         Sterling equivalent
     C                   MOVE      BBCSSN        L8CSSN                         Customer shortname
     C                   SELECT
     C     LUPAR         WHENNE    *BLANK
     C                   MOVE      LUPAR         L8PCNB                         Ultimate parent
     C     BBPCNB        WHENNE    *BLANK
     C                   MOVE      BBPCNB        L8PCNB                         Customer parent
     C                   OTHER
     C                   MOVE      BBCUST        L8PCNB                         Use customer no.
     C                   ENDSL
     C                   MOVE      LELGF         L8ELIG                         Eligibility flag
     C                   MOVE      BBRWCD        L8RWCD                         Risk weighting code
      *
      * If both netting indicator in lending extraction criteria file
      *    and in customer extension file are 'Y', set netting indicato
      *    set netting indicator to 'Y', otherwise to blank
     C********** ULLENT    IFEQ 'Y'                                                         LLN016
     C********** LLENT     ANDEQ'Y'                                                         LLN016
     C**********           MOVE 'Y'       L8NETI           Netting indicator                LLN016
     C**********           ELSE                                                             LLN016
     C**********           MOVE ' '       L8NETI                                            LLN016
     C**********           END                                                              LLN016
     C                   MOVE      LHASI         L8HAIN                         Housing association
     C                   MOVE      ULLNTP        L8CTYP                         Type of Cr.
      *                                                                   LLN012
      * Set-up additional extract fields                                  LLN012
     C                   MOVE      LCNTP         L8CNTP                                        LLN01
     C                   MOVE      '00'          L8GTEE                                        LLN01
     C                   MOVE      '0'           L8CNTP                                        LLN01
     C                   MOVE      ULEVTP        L8ETYP                                        LLN01
     C                   MOVE      ULODIN        L8ODIN                         Overdue Ind.   LLN01
      *
      *
      *  Write record to extraction file
     C***********L8NETI    IFEQ 'Y'                                       LLN016
     C***********          WRITEBYNETDD0                                  LLN016
     C***********          ELSE                                           LLN016
      *                                                                   LLN021
      * If Mature write to BYMTDTPP                                       LLN021
      *                                                                   LLN021
      ** Check if loan matured this month                                    LLN021
      *                                                                      LLN021
     C                   EXSR      #MATUR                                                         LL
      *                                                                   LLN021
     C     @MATS         IFEQ      'Y'                                                         LLN02
     C                   WRITE     BYMTDTP0                                                    LLN02
     C                   MOVE      *BLANK        @MATS             1            Mature Indicator  LL
     C                   ELSE                                                                  LLN02
      *                                                                   LLN021
     C     RECI          IFEQ      'D'                                                         LLN02
     C                   WRITE     BYEXDTD0
     C                   ENDIF                                                                 LLN02
     C***********          ENDIF                                          LLN016
     C                   ENDIF                                                                 LLN02
      *
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
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LRPT1 - Write Details of Valid LOANS to BY2030P1             *
      *                                                               *
      * Called by: SR/#LRPXT - Report/Extract Details                 *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
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
     C**********           MOVELULCNUM    L#CNUM           Customer                           CSD027
     C                   MOVE      ULCNUM        L#CNUM                         Customer
     C                   MOVEL     ULLNRF        L#LNRF                         Loan number
     C                   MOVEL     ULLTYP        L#LTYP                         Loan type
     C                   MOVEL     ULSUTP        L#SUTP                         Deal sub-type
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
     C                   ELSE
     C                   MOVE      *BLANKS       L#MDAT
     C                   ENDIF
     C                   MOVEL     ULCYCD        L#CYCD                         Currency
     C                   MOVE      ULLISO        L#LISO                         Customer country cod
     C                   MOVE      ULRISO        L#RISO                         Risk country code
     C***********          MOVE BBLICD    L#LIND           Industry code                    LLN016
     C***********          MOVE BBLINC    L#LINS           Institution code                 LLN016
     C                   MOVE      LLICD         L#LIND                         Industry code
     C                   MOVE      LLINC         L#LINS                         Institution code
     C                   MOVE      BBCRNM        L#CRNM                         Customer report name
     C                   MOVE      ULCYCD        L#CYCD
     C                   CALL      'ZSEDIT'
     C                   PARM      ULCUAS        ULAMNT
     C                   PARM      A6NBDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA                         Currency amount
     C                   MOVE      ULAMTA        L#CUAS
     C                   CALL      'ZSEDIT'
     C                   PARM      ULSGAM        ULAMNT
     C                   PARM      UL$NDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA                         Sterling equivalent
     C                   MOVE      ULAMTA        L#SGAM
     C                   MOVE      ULPCOD        L#PCOD                         Product code
     C                   MOVE      L8BTEX        L#BTEX                         BT Indicator   LLN01
     C                   MOVE      L8LREX        L#LREX                         LR Indicator   LLN01
      *
      * Check if customer number and name to be printed
     C     ULCNUM        IFNE      ULCUS1
     C                   MOVE      *ON           *IN30                          Print cust n
     C**********           Z-ADDULCNUM    ULCUS1                                              CSD027
     C                   MOVE      ULCNUM        ULCUS1
     C                   ENDIF
      *
      *  Write details to report
     C     ULOVF1        SUB       ULCLN1        ULLDIF
     C   30              SUB       2             ULLDIF
     C     ULLDIF        IFLT      0
     C                   WRITE     BY2030H1
     C                   MOVE      *ON           *IN30                          Print cust n
     C                   END
     C                   WRITE     BY2030D1                             90
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
      * #LRPT2 - Write Details of Invalid Deals To BY2030P2           *
      *                                                               *
      * Called by: SR/#LRPXT - Report/Extract Details                 *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #LRPT2        BEGSR                                                  ** SR/#LRPT2**
      *
      *  Reset report indicators
     C                   MOVE      *OFF          *IN30
     C                   MOVEA     '0000000'     *IN(31)
     C                   MOVEA     '0'           *IN(41)
      *
      *  Set up report fields
     C**********           MOVELULCNUM    L#CNUM           Customer                           CSD027
     C                   MOVE      ULCNUM        L#CNUM                         Customer
     C                   MOVEL     ULLNRF        L#LNRF                         Loan number
     C                   MOVEL     ULLTYP        L#LTYP                         Loan type
     C                   MOVEL     ULSUTP        L#SUTP                         Deal sub-type
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
     C                   ELSE
     C                   MOVE      *BLANKS       L#MDAT
     C                   ENDIF
     C                   MOVEL     ULCYCD        L#CYCD                         Currency
     C                   MOVE      BBCOLC        L#COLC                         Customer country cod
     C                   MOVE      ULLISO        L#LISO                         Customer country cod
     C                   MOVE      BBCNCZ        L#CNCZ                         Risk country code
     C                   MOVE      ULRISO        L#RISO                         Risk country code
     C***********          MOVE BBLICD    L#LIND           Industry code                    LLN016
     C***********          MOVE BBLINC    L#LINS           Institution code                 LLN016
     C                   MOVE      LLICD         L#LIND                         Industry code
     C                   MOVE      LLINC         L#LINS                         Institution code
     C                   MOVE      BBCRNM        L#CRNM                         Customer report name
     C                   MOVE      ULCYCD        L#CYCD
     C                   CALL      'ZSEDIT'
     C                   PARM      ULCUAS        ULAMNT
     C                   PARM      A6NBDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA                         Currency amount
     C                   MOVE      ULAMTA        L#CUAS
     C                   CALL      'ZSEDIT'
     C                   PARM      ULSGAM        ULAMNT
     C                   PARM      UL$NDP        ULNBDP
     C                   PARM      'J'           ULECOD
     C                   PARM                    ULAMTA                         Sterling equivalent
     C                   MOVE      ULAMTA        L#SGAM
     C                   MOVE      ULPCOD        L#PCOD                         Product code
      *
      * Check if customer number and name to be printed
     C     ULCNUM        IFNE      ULCUS2
     C     ULERR1        ANDNE     0
     C                   MOVE      ULERR1        ULERR2
     C                   MOVEA     ULERR2        *IN(31)
     C                   ENDIF
     C     ULPCOD        IFEQ      9999
     C                   MOVE      *ON           *IN41
     C                   ENDIF
      *
      *  Determine no. of errors to be reported for overflow check
     C                   Z-ADD     0             X                 2 0
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
     C                   WRITE     BY2030H2
     C                   ENDIF
     C     ULCNUM        IFNE      ULCUS2
     C     *IN30         OREQ      *ON
     C                   WRITE     BY2030D2                             90
     C                   ENDIF
     C                   WRITE     BY2030D3                             90
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
      * SR/#LRPTT - Report Totals                                     *
      *                                                               *
      * Called by:  SR/#LBRCH - New Branch Processing                 *
      *             SR/#LTERM - Termination Processing                *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #LRPTT        BEGSR                                                  ** SR/#LRPTT**
      *
      *  No details to report
     C     ULRPT1        IFNE      'Y'
     C                   WRITE     BY2030E1                             90
     C                   ENDIF
      *
      *  No details to report
     C     ULRPT2        IFNE      'Y'
     C                   WRITE     BY2030E2                             90
     C                   ENDIF
      *
      *   Report currency summary if EXTRACT mode
     C     ULMODE        IFEQ      'EXTRACT'
     C     ULRPT1        ANDEQ     'Y'
      *
      *   Write heading
     C                   WRITE     BY2030R1
      *
     C                   Z-ADD     1             #
     C                   Z-ADD     0             ULTOTA
     C                   Z-ADD     0             ULTOTL
      *
      *   Write detail record for each currency
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
     C                   WRITE     BY2030S1                             90
     C     ULCLN1        IFGT      ULOVF1                                       Overflow
     C                   WRITE     BY2030R1
     C                   ENDIF
      *
      ** Write record for total assets and liabilities in CCY             LLN012
     C                   Z-ADD     @TAC(#)       ULTOT1           17 2                         LLN01
     C                   ADD       @TLC(#)       ULTOT1                                        LLN01
     C                   Z-ADD     @TAS(#)       ULTOT2           17 2                         LLN01
     C                   ADD       @TLS(#)       ULTOT2                                        LLN01
      *                                                                   LLN012
     C                   MOVEL     ULBRCA        LTBRCD                                        LLN01
     C                   MOVEL     'LE'          LTMMOD                                        LLN01
     C                   MOVEL     ' '           LTASLI                                        LLN01
     C                   MOVEL     @CCY(#)       LTCYCD                                        LLN01
     C                   Z-ADD     ULTOT1        LTCUAS                                        LLN01
     C                   Z-ADD     ULTOT2        LTSGAM                                        LLN01
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
     C                   WRITE     BY2030R1
     C                   ENDIF
     C                   WRITE     BY2030T1                             90
      *
     C                   ENDIF
      *
      *  Write end of report FOR BY2030P1
     C                   WRITE     BY2030Z1                             90
      *
      *  Write end of report FOR BY2030P2
     C                   WRITE     BY2030Z2                             90
      *
      *  Close files
     C                   CLOSE     BY2030P1
     C                   CLOSE     BY2030P2
      *
      *  Reset file open flag indicator and totals
     C                   MOVE      'N'           ULOPNF
     C                   MOVE      'N'           ULRPT1
     C                   MOVE      'N'           ULRPT2
     C                   Z-ADD     0             PAGE1
     C                   Z-ADD     0             PAGE2
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/#LCCYD - Get Currency Details                              *
      *                                                               *
      * Called by:  SR/#LFIXL - Process Fixed/Term Loans              *
      *             SR/#LPPUR - Participation Purchase Loans          *
      *             SR/#LPSLD - Participation Sold Loans              *
      *                                                               *
      * Calls:      AOCURRR0 - Currency details Access Object         *
      *                                                               *
      *****************************************************************
      *
     C     #LCCYD        BEGSR                                                  ** SR/#LCCYD**
      *
     C                   Z-ADD     1             #
     C     ULCYCD        LOOKUP    @CCY(#)                                90
     C     #             OCCUR     SDCURR
     C     *IN90         IFEQ      *OFF
     C                   Z-ADD     200           #
     C     #             OCCUR     SDCURR
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    ULCYCD
     C                   PARM                    SDCURR
     C     P@RTCD        IFNE      *BLANK                                       Error on call
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     ULCYCD        DBKEY                          * DBERR 08 *
     C                   MOVEL     'SDCURRL0'    DBFILE                         ************
     C                   Z-ADD     08            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
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
      *                                                               *
      *****************************************************************
      *
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
     C                   Z-ADD     0             #                 5 0          Array index
     C                   Z-ADD     0             ULSFNO            6 0          Spool file no.
     C                   Z-ADD     0             ULDAYN            5 0          Date - Midas day no.
     C                   Z-ADD     0             ULDATE            6 0          Date - DDMMYY
     C                   Z-ADD     0             ULODT1            5 0          Overdue date - 14
     C                   Z-ADD     0             ULODT2            5 0          Overdue date - 28
     C                   Z-ADD     0             ULERR1            7 0          Error indicators
     C                   Z-ADD     0             ULTOTA           15 0          Total assets
     C                   Z-ADD     0             ULTOTL           15 0          Total liabilities
     C                   Z-ADD     0             ULMPER            5 0          Category period date
     C                   Z-ADD     0             ULINAM           15 0          In amount - convert
     C                   Z-ADD     0             ULOTAM           15 0          Out amount - convert
     C                   Z-ADD     0             ULLDIF            2 0          Overflow line check
     C                   MOVE      'N'           ULERRI            1            Error indicators
     C                   MOVE      'N'           ULVALD            1            Valid deal
     C                   MOVE      'N'           ULRPT1            1            Details reported
     C                   MOVE      'N'           ULRPT2            1            Details reported
     C                   MOVE      'N'           ULOPNF            1            Files opened
     C                   MOVE      'N'           ULGTEE            1            Guarantees
     C                   MOVE      *BLANK        ULRTCD            1            Return code
     C                   MOVE      *BLANK        ULBRCA            3            Branch code
     C                   MOVE      *BLANK        P@RTCD            7
     C                   MOVE      *BLANK        P@OPTN            7
     C                   MOVE      *BLANK        ULDATA            7            Date - DDMMMYY
     C                   MOVE      *BLANK        ULLOCN            3            Location
     C                   MOVE      *BLANK        ULAMTA           21            Edited amount field
     C                   MOVE      *BLANK        ULECOD            1            Edit code
     C                   MOVE      *BLANK        ULFNAM           10            File name
     C                   MOVE      *BLANK        ULODIN            1            Overdue indicator
     C                   MOVE      *BLANK        ULERR2            7            Error indicators
     C     *LIKE         DEFINE    CNUM          ULCNUM                         Customer
     C     *LIKE         DEFINE    CNUM          ULPCUS                         Previous customer
     C     *LIKE         DEFINE    CNUM          ULCUS1                         Print customer 1
     C     *LIKE         DEFINE    CNUM          ULCUS2                         Print customer 2
     C     *LIKE         DEFINE    CCY           ULCYCD                         Currency
     C     *LIKE         DEFINE    L8RTYP        ULRTYP                         Record type
     C     *LIKE         DEFINE    L8PCOD        ULPCOD                         Product code
     C     *LIKE         DEFINE    L8CUAS        ULCUAS                         Extract ccy amount
     C     *LIKE         DEFINE    L8CUAS        ULCUAT                         Extract ccy amount
     C     *LIKE         DEFINE    L8SGAM        ULSGAM                         Sterling equivalent
     C     *LIKE         DEFINE    L8MMOD        ULMMOD                         Module id.
     C     *LIKE         DEFINE    L8MCAT        ULMCAT                         Maturity category
     C     *LIKE         DEFINE    L8RISO        ULRISO                         Risk country
     C     *LIKE         DEFINE    L8RISO        ULRISK                         Risk country
     C     *LIKE         DEFINE    A8IBOE        ULIBOE                         Include branch
     C     *LIKE         DEFINE    A6NBDP        ULNBDP                         No. of decimal place
     C     *LIKE         DEFINE    A6NBDP        UL$NDP                         Sterling dec. places
     C     *LIKE         DEFINE    BBCUST        ULCUST                         Customer
     C     *LIKE         DEFINE    LNRF          ULLNRF                         Loan reference
     C     *LIKE         DEFINE    ULCUAS        ULAMNT
     C     *LIKE         DEFINE    CPAM          ULCPAM                         Current principal
     C     *LIKE         DEFINE    DDAT          ULDDAT                         Deal date
     C     *LIKE         DEFINE    MDAT          ULMATD                         Maturity date
     C     *LIKE         DEFINE    MDAT          ULMDAT                         Maturity date
     C     *LIKE         DEFINE    CCY           ULFCCY                         CCY code
     C     *LIKE         DEFINE    CCY           ULTCCY                         CCY code
     C     *LIKE         DEFINE    FCLN          ULGTRF                         Guarantee ref
     C     *LIKE         DEFINE    CNUM          ULGTCN                         Guarantor customer
     C********** *LIKE     DEFN LDLENT    ULLENT           Netting flag                    LLN016
     C********** *LIKE     DEFN LDLENT    ULFCNT           Netting flag                    LLN016
     C     *LIKE         DEFINE    LTYP          ULLTYP                         Loan type
     C     *LIKE         DEFINE    NRPD          ULNRPD                         Next repay date
     C     *LIKE         DEFINE    RDYN          ULRDYN                         Freq day no.
     C     *LIKE         DEFINE    SUTP          ULSUTP                         Loan sub type
     C     *LIKE         DEFINE    VDAT          ULVDAT                         Value date
     C     *LIKE         DEFINE    RAMT          ULRAMT                         Repay amt
     C     *LIKE         DEFINE    REPT          ULREPT                         Repay type
     C     *LIKE         DEFINE    RFRQ          ULRFRQ                         Freq code
     C     *LIKE         DEFINE    VDAT          ULVLDT                         Value date
     C     *LIKE         DEFINE    PTYP          ULPTYP                         Proc. type
     C     *LIKE         DEFINE    LLNTP         ULLNTP                         Loan Type
      *
      *
      *  Key List Definitions
      *  ====================
      *
      *  Loans extract criteria
     C     L3KEY         KLIST
     C                   KFLD                    L3LTYP                         Loan type
     C                   KFLD                    L3LNST                         Loan subtype
     C                   KFLD                    L3LINS                         Institution
     C                   KFLD                    L3MIND                         Industry code
      *
      *  Loans detail
     C     CLOANK        KLIST
     C                   KFLD                    LNRF                           Loan ref
     C                   KFLD                    RCDT
      *
      *  Guarantees file key - LF/BYGTEEV0
     C     GTKEY         KLIST
     C                   KFLD                    ULGTRF                         Grt ref
     C                   KFLD                    ULGTCN                         Grt cust no.
      *
      *   Loan amendmentes details - LF/LOAMS
     C     LOAMK         KLIST
     C                   KFLD                    ULLNRF                         Loan reference
     C                   KFLD                    L0RPDT                         Value date
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
      *
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
      *
     C     #LTERM        BEGSR                                                  ** SR/#LTERM**
      *
      *  Final Report Processing
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
      *
     C     *INZSR        BEGSR                                                  ** #INZSR SR**
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
      *                                                                    LLN021
      *  Get beginning and end of month dates                              LLN021
      *                                                                    LLN021
     C                   MOVEL     CURSOM        CURSO             5 0                          LLN0
     C                   MOVEL     CUREOM        CUREO             5 0                          LLN0
      *                                                                    LLN021
      *  Get Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C                   PARM                    SDBANK
     C     P@RTCD        IFNE      *BLANKS
     C     BJTYLC        OREQ      'D'                                          ON-deleted
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 09 *
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   Z-ADD     09            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Set Date Format Indicator *IN98  on if date format is MMDDYY
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ELSE
     C                   MOVE      *OFF          *IN98
     C                   END
      *
      *  Get General Ledger ICD Details
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C                   PARM                    SDGELR
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*FIRST'      DBKEY                          * DBERR 10 *
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   Z-ADD     10            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Get Trading Data ICD Record For GBP Corrency Code (BLCYCD)
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C                   PARM                    SDTRAD
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*FIRST'      DBKEY                          * DBERR 11 *
     C                   MOVEL     'SDTRADPD'    DBFILE                         ************
     C                   Z-ADD     11            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
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
     C                   END                                                                   LLN01
      *
      *  Initialise work fields
     C                   EXSR      #LDEFN
      *
      *
      *  Get the extract date
     C                   OPEN      BYRPDTPP
     C                   READ      BYRPDTPP                               90
     C     *IN90         IFEQ      *ON
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 12 *
     C                   MOVEL     'BYRPDTPP'    DBFILE                         ************
     C                   Z-ADD     12            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   CLOSE     BYRPDTPP
      *
      *  Determine date for overdue indicator
     C     L0RPDT        SUB       14            ULODT1
     C     L0RPDT        SUB       28            ULODT2
      *
      * Check if multi-branching
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *  Single branch:
     C     AGMBIN        IFNE      'Y'
     C                   MOVE      'Y'           ULOPNF
     C                   MOVE      *OFF          *IN20
      *
      *  RCF processing for printer file BY2030P1
     C                   OPEN      BY2030P1
     C                   Z-ADD     ULNUM1        ULSFNO
     C                   CALL      'ZSFILE'
     C                   PARM                    ULRSEQ
     C                   PARM                    ULBRCA
     C                   PARM      'BY2030P1'    ULFNAM
     C                   PARM                    ULSFNO
     C                   PARM                    ULRTCD
      *
     C     ULRTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 13 *
     C                   MOVEL     'ZSFILE  '    DBFILE                         ************
     C                   Z-ADD     13            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  RCF processing for printer file BY2030P2
     C                   OPEN      BY2030P2
     C                   Z-ADD     ULNUM2        ULSFNO
     C                   CALL      'ZSFILE'
     C                   PARM                    ULRSEQ
     C                   PARM                    ULBRCA
     C                   PARM      'BY2030P2'    ULFNAM
     C                   PARM                    ULSFNO
     C                   PARM                    ULRTCD
      *
     C     ULRTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 14 *
     C                   MOVEL     'ZSFILE  '    DBFILE                         ************
     C                   Z-ADD     14            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Write report headings to BY2030P1 and BY2030P2
     C                   MOVE      L0RPDA        L#RPDA
     C                   WRITE     BY2030H1
     C                   WRITE     BY2030H2
      *
      *  Multi branching indicator
     C                   ELSE
     C                   MOVE      *ON           *IN20
     C                   ENDIF
      *
      *  Load currency details
     C                   Z-ADD     0             #
     C     *LOVAL        SETLL     SDCURRL0
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
     C                   PARM                    BLCYCD
     C     SDCURR        PARM                    DSSDY
     C     P@RTCD        IFNE      *BLANK                                       Error on call
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGMN        DBPGM                          ************
     C                   MOVEL     BLCYCD        DBKEY                          * DBERR 15 *
     C                   MOVEL     'SDCURRL0'    DBFILE                         ************
     C                   Z-ADD     15            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     A6NBDP        UL$NDP
     C                   ENDIF
      *
      * Get the LE lending netting flag for forward commitments
     C*****7800          CHAIN     BYPRODD0                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = '7800'                                                               MD058068
     C/END-EXEC                                                                             MD058068
     C                   SETOFF                                       90                    MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   SETON                                        90                    MD058068
     C                   ENDIF                                                              MD058068
     C********** *IN90     IFEQ *OFF                                                          LLN016
     C**********           MOVELLDLENT    ULFCNT           NETTING FLAG                       LLN016
     C**********           ENDIF                                                              LLN016
      *
      *  Open extract file if EXTRACT mode
     C     ULMODE        IFEQ      'EXTRACT'
     C                   OPEN      BYEXDTPP
     C                   OPEN      BYMTDTPP                                                    LLN02
     C***********          OPEN BYNETDPP                                                      LLN016
     C                   ENDIF
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
     C     #MATUR        BEGSR                                                  ** SR/#MATUR** LLN02
      *                                                                   LLN021
     C     RECI          IFEQ      'M'
     C     L8MDAT        IFNE      0                                                           LLN02
      *                                                                   LLN021
     C     L8MDAT        IFLE      CUREO                                                        LLN0
     C     L8MDAT        ANDGE     CURSO                                                        LLN0
     C                   MOVE      'Y'           @MATS                                          LLN0
     C                   ENDIF                                                                  LLN0
      *                                                                    LLN021
     C                   ENDIF                                                                  LLN0
      *                                                                    LLN021
     C                   ENDIF                                                                  LLN0
      *                                                                    LLN021
     C                   ENDSR                                                                  LLN0
      /EJECT
      ********************************************************************
     C*
     C* Calculate next repayment date
     C*
     C*COPY*ZSRSRC,ZFREQBZ2                                                                 MD058068
     C/COPY ZSRSRC,ZFREQBZ2LE                                                               MD058068
     C*
     C*COPY*ZSRSRC,ZDATE1Z2                                                                 MD058068
     C/COPY ZSRSRC,ZDATE1Z2LE                                                               MD058068
     C*COPY*ZSRSRC,ZDATE2Z2                                                                 MD058068
     C/COPY ZSRSRC,ZDATE2Z2LE                                                               MD058068
     C*COPY*ZSRSRC,ZACCH                                                                    MD058068
     C/COPY ZSRSRC,ZACCHLE                                                                  MD058068
     C*COPY*ZSRSRC,ZCHKH                                                                    MD058068
     C/COPY ZSRSRC,ZCHKHLE                                                                  MD058068
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
**  CPY@
(c) Finastra International Limited 1997
**  LLA  - Event types                                                    LNN012
61V161R161R261V361M161M261R762V162R162R262V3
62M162M262V762R962R762V563V163V263M163R363R4
63R564V164R164R264M164M264I265V165V265M166V1
66R166R266M166M266V367V167V267M170I270M271F1
61I261X262I262X266I264V364X266X270X268V168R1                              168700
68R268M168M268I269V169R169R269M169M269V363R1                                                MD055652
65R167R1                                                                                    MD055652
