     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE EU Tax - Position Settlement Take-on')        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEPSTLTKN - Take-on tax calculation for Position Settlement  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26839           Date 05Jan10               *
      *                 BUG24029           Date 20May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23123           Date 09Mar09               *
      *                 BUG22911           Date 17Feb09               *
      *                 BUG22529           Date 10Feb09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER034A            Date 19May08               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 CSD027A            Date 05May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 237063             Date 20Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 236453             Date 29Sep05               *
      *                 236042             Date 14Sep05               *
      *                 236453             Date 25Aug05               *
      *                 235320             Date 08Aug05               *
      *                 235271             Date 02Aug05               *
      *                 235045  *CREATE    Date 12Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26839 - JA1_Threshold limit of the main joint customer was*
      *             utilized by the member                            *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  BUG22911 - Changes for Correct Tax Calculation               *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *           (Recompile)                                         *
      *  CER034A - LF046 German Features - New Fields and Enquiries   *
      *           (Recompile)                                         *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  236453 - TSRDNB must be set to BJRDNB - 1 to avoid           *
      *           accounting problems                                 *
      *  236042 - Coupon interest wrong if NMDP not zero              *
      *  236453 - Change access object for customer to also consider  *
      *           'Closed' customer.                                  *
      *  235320 - Coupon amount taxable incorrectly calculated        *
      *  235271 - Joint account holder field not set to blanks for    *
      *           non joint customers                                 *
      *  235045 - Calculate tax on deal for take-on                   *
      *                                                               *
      *****************************************************************
 
     FPOSET1    IF   E           K DISK    PREFIX(P_)
 
     FSECTY     IF   E           K DISK    PREFIX(S_)
     FSEDEV     IF   E           K DISK
     FSECEO     IF   E           K DISK    PREFIX(E_)
     F                                     RENAME(SEDEVDF:SEDEVDO)
     F                                     RENAME(SNDEVDF:SNDEVDO)
     FSDJACCLB  IF   E           K DISK
 
      ** Tax Calculation Methods file
     FSDTXCML1  IF   E           K DISK    INFSR(*pssr)
 
     F* Securities WHT details file
     FSESWHTL0  IF   E           K DISK
 
      ** Customer Income File
     FSDCSINPD  O    E             DISK    INFSR(*pssr)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the SE standard declares
     D/COPY SECPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data Structure for Bank Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      * External DS for Branch Details
 
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      * External DS for Location Details
 
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
      * External DS for Securities Clients
 
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      ** External DS for Additional Customer Details
 
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      ** External DS for Non Account Holder Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * Data Structure for Currency Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D CUST_DFAC     E                     EXTFLD(QQDFAC)                                     CGL035
                                                                                              CGL035
      ** External DS for Customer
 
     D SDINV         E DS                  EXTNAME(INVTPD)
      ** Externally described DS for investment types
 
     D SECT          E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(S_)
     D CDArr                 183    230
     D CRArr                 231    242
                                                                                              236042
      ** Array for manipulating decimal positions                                             236042
     D POWER9          S              9  4 DIM(9) CTDATA PERRCD(1)                            236042
                                                                                              236042
      ** Security Details
 
     D ETCPOS        E DS                  EXTNAME(ETCPOSND)
     D E_REC         E                     EXTFLD(RECI)
      ** customer position for EU Savings tax
 
     D SECNTR        E DS                  EXTNAME(SECNTRPD)
     D** SE Country tax rate details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     236453
      *                                                                                     BUG22911
      ** Data area for Midas SD Tax Parameter File                                          BUG22911
     D SDTXPA        E DS                  EXTNAME(SDTXPAPD)                                BUG22911
      *                                                                                     BUG22911
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @PCUST          S              6A
     D @PNAHO          S             10A
 
     D PCURR           S              3A
     D @@KEY           S             10A
     D @@FILE          S             10A
     D @@RTRN          S              7A
     D @@JANO          S              6A
     D @@NARF          S             10A
     D @@INVP          S             10A
     D @@BRCA          S              3A
     D PCurrency       S              3A
     D PSetType        S              2S 0
     D PSetAcc         S             12A
     D PAccCode        S              4S 0
     D PAccSeq         S              2S 0
     D @@MODI          S              1A
     D @@CUST          S              6A
     D @@CTAX          S              2A
     D @@COLC          S              2A
     D @@STAT          S              5A
     D @@WTAC          S              4P 0
     D @@STRD          S              5P 0
     D @@ENDD          S              5P 0
     D @@IAED          S             15P 0
     D @@TOTO          S             15P 0
     D @@OCCY          S              3A
     D POPTN           S              7A
     D @@TAXA          S             15P 0
     D @@TXBS          S              2A
     D @@TXCY          S              3A
     D @@TAXR          S              6P 4
     D @@TXR1          S              6P 4
     D @@TOTI          S             15P 0
     D @@TRRF          S             18A
     D @@TRTE          S              1A
     D PTSTNLU         S              5P 0
     D PRTCD           S              7A
 
     D UTXRSR          S                   LIKE(S1RASO)
     D WCNCD           S              2A
     D WCOLC           S              2A
     D WCURRKEY        S                   LIKE(TSOCCY)
     D WDATEYYYY       S                   LIKE(TSIPDT)
     D WDealNo         S              6A
     D WEUTaxAmt       S             15P 0
     D WMMDD           S              4A
     D WMonth          S              2  0
     D WTdvd           S              5P 0
     D WYear1          S              2A
     D WYear2          S              4A
     D WAMT            S             15  0                                                    235320
     D IRATE           S             15  9                                                    235320
     D ZZACINT1        S             15P 0                                                    235320
     D ZZACINT2        S             15P 1                                                    235320
     D NODAYS1         S              5  0                                                    235320
     D NODAYS2         S              5  0                                                    235320
     D ZRP             S              1A                                                      235320
     D WSTART          S                   LIKE(EWEDT1)                                       235320
     D*WPCPY*****      S              6S 0                                            235320 CSD027A
     D WPCPY           S              6                                                      CSD027A
     D WPAMD           S             15  0                                                    235320
 
     D Indx            S              1  0                                                    236042
                                                                                              236042
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D ZRATE1          S             13P 8
     D ZRATE2          S             13P 8
     D ZRATEX          S             13P 8
     D ZMDI1           S              1A
     D ZMDI2           S              1A
     D ZMDIX           S              1A
     D ZAMTCI          S             15P 0
     D ZEXCH           S             13P 8
     D ZMD             S              1A
     D ZCCYI           S              3A
     D ZCCYO           S              3A
     D ZCDPI           S              1P 0
     D ZCDPO           S              1P 0
     D ZAMTCO          S             15P 0
     D ZZLCD           S              5P 0
     D ZZNCD           S              5P 0
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
     D ZADEC           S              1P 0
 
      ** Constant for Instrument Reference                                                    CGL031
     D***WINST1          C                   CONST(' - Coupon')                               236453
     D WINST1          C                   CONST(' - Coupon  ')                               236453
     D WINST2          C                   CONST(' - Dividend')
     D WINST3          C                   CONST(' - Maturity')
     D WINST4          C                   CONST(' - Mortgage Payment')
      *                                                                                       CER048
      ** Parameters for Taxes                                                                 CER048
      *                                                                                       CER048
     D PInth           S              1A                                                      CER048
     D*PStxb****       S              2P 0                                           CER048 BUG22911
     D*PStac****       S             10P 0                                           CER048 BUG22911
     D*PSttr****       S              6P 4                                           CER048 BUG22911
     D*PSttp****       S              1A                                             CER048 BUG22911
     D*PStxa****       S             15P 0                                           CER048 BUG22911
      *                                                                                       CER048
      ** Feature for Taxes                                                                    CER048
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C     *LOVAL        SETLL     POSET1
 
     C                   DOW       *IN30 = '0'
     C                   READ      POSET1                                 30
     C                   IF        *IN30 = '0' AND P_RECI <> 'D'
 
     C                   EVAL      @@BRCA  = P_PBCA
     C                   MOVE      P_PCPY        @@CUST
     C                   EVAL      PCurrency = P_PNCY
     C                   EVAL      PSetType = P_PSMT
     C                   EVAL      PSetAcc = P_PSEA
 
     C                   EVAL      WEUTaxAmt = *Zero
     C                   EXSR      SRSecty
     C                   EXSR      SRRtvTax
 
     C                   IF        P_PDUD >= EWEDT1  AND P_PDUD < BJRDNB
     C*****                        AND WNOTAX = ' '  AND S_SETX = 'Y'                         235320
     C                             AND S_SETX = 'Y'                                           235320
     C                             AND P_PPRE = 'P'
      *
     C** EXECUTE SUBROUTINES DEPENDING ON ACTION TYPE
     C*
     C     P_PEVT        CASEQ     'DV'          DIVIDN
     C     P_PEVT        CASEQ     'CP'          COUPON
     C*****P_PEVT        CASEQ     'MA'          MATURE                                       236453
     C     P_PEVT        CASEQ     'MT'          MATURE                                       236453
     C     P_PEVT        CASEQ     'MP'          MORTPY
     C                   END
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDDO
 
      ** Return
 
     C                   SETON                                        LR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSecty  - Access security details                            *
      *                                                               *
      *****************************************************************
     C     SRSecty       BEGSR
 
     C     P_PSSH        CHAIN     SECTY
 
     C                   IF        NOT%FOUND(SECTY)
     C                   EVAL      DBKEY = P_PSSH
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBASE = 7
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOINVTR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    S_SITP
     C                   PARM                    S_NMCY
     C     SDINV         PARM      SDINV         DSFDY
 
     C                   IF        @Rtcd <> *BLANKS
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     S_NMCY        DBKEY
     C                   MOVE      S_SITP        DBKEY
     C                   MOVEL     'INVTPD'      DBFILE
     C                   EVAL      DBASE = 8
     C                   EXSR      *PSSR
     C                   END
 
     C                   MOVE      *BLANKS       S1CTTA
     C     SECTKY        CHAIN     SESWHTL0                           80
     C   80              MOVEL     'N'           SWHTFD            1
     C  N80              MOVEL     'Y'           SWHTFD            1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTax - Retrieve EU Tax Information                        *
      *                                                               *
      *****************************************************************
     C     SRRtvTax      BEGSR
 
     C                   MOVEL     P_PBCA        @BRCH             3
     C                   CALLB     'AOBRCHR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @BRCH
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = P_PBCA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     A8LCCD        @LCCD             3
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @LCCD
     C     SDLOCN        PARM      SDLOCN        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = A8LCCD
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     *BLANK        @PKEY1           10
     C                   MOVEL     P_PCPY        @PKEY1
 
      ** Customer details
 
     C**********         CALL      'AOCUSTR0'                                                 236453
     C                   CALL      'AOCUSTR2'                                                 236453
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @PKEY1
     C                   PARM                    @PKYST            7
     C*****SDCUST        PARM      SDCUST        DSSDY                                        236453
     C     SDCUST        PARM      SDCUST        DSLDY                                        236453
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANK
     C     BBCLST        ANDNE     'Y'                                                        236453
     C**********         EVAL      DBKEY = @PKYST                                             236453
     C                   EVAL      DBKEY = @PKEY1                                             236453
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 5
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Country of Tax
 
     C                   EVAL      WCNCD = DVCNCD
     C                   EVAL      WCOLC = BBCOLC
 
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCNCD         @PCTRT            2
     C                   PARM      WCOLC         @PCTRR            2
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
     C                   IF        @RTCD = '*NRF   '
 
     C                   EVAL      WCOLC = *BLANK
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCNCD         @PCTRT
     C                   PARM      WCOLC         @PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      DBKEY = @PCTRT + ' ' + @PCTRR
     C                   EVAL      DBFILE = 'SDCTTXPD'
     C                   EVAL      DBASE = 6
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Get Tax Basket Details
      *
     C                   CALL      'AOTXBSR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      DVCNCD        P@CTTT            2
     C                   PARM      EWTXBS        P@TXBS            2
     C                   PARM      P_PDUD        P@DATE            5 0
     C                   PARM                    P@NARR           15
     C                   PARM                    P@RATE            6 4
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      ' '           WNOTAX            1
     C                   Z-ADD     P@RATE        WTRAB             6 4
     C                   ELSE
      *
      ** If no record found, no tax is calculated.
      *
     C                   MOVE      'Y'           WNOTAX
     C                   ENDIF
 
     C                   IF        WNOTAX = ' '
     C                             AND SWHTFD = 'Y'
      *
      *** Initialise work tax rate and amount fields
      *
     C                   CLEAR                   UTXRSR
      *
      *** If tax band at source is zero, then take rate from security
      *** WHT file; Otherwise access SEcountry tax rate file to
      *** get tax rate at source
      *
     C     S1TABD        IFEQ      *ZERO                                        *B1
     C                   Z-ADD     S1RASO        UTXRSR
     C                   ELSE                                                   *X1
      *
     C                   MOVEL     S1CTTA        UKEY              3
     C                   MOVE      S1TABD        UKEY
      *
     C                   CALL      'AOSCTXR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      S1CTTA        @CTTA             2
     C                   PARM      S1TABD        @TABD             1 0
     C     SECNTR        PARM      SECNTR        DSSDY
     C*
     C     @RTCD         IFNE      *BLANKS                                      *B2
     C     TXRECI        ORNE      'D'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SECNTRL0'    DBFILE                         ***************
     C                   MOVEL     UKEY          DBKEY                          ** DBERROR 018
     C                   Z-ADD     18            DBASE                          ***************
     C                   SETON                                          U7U8
     C                   EXSR      *PSSR
     C                   ELSE                                                   *X2
     C                   Z-ADD     TXRASO        UTXRSR
     C                   END                                                    *E2
     C                   END                                                    *E1
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  DIVIDN - Subroutine to produce Dividend Account Keys and/or  *
      *           Position Settlements.                               *
      *                                                               *
      *****************************************************************
      *
     C     DIVIDN        BEGSR                                                  ** DIVIDN **
      *
      ** If Security or Security Diary Event is not Taxable, nothing must be calculated and
      ** nothing must be output on SDCSINPD.
      *
      ** Check if Security is Taxable
      *
     C                   Z-ADD     P_PAMD        WPAMD                                        236453
      *                                                                                       236453
     C     SEDKEY        SETLL     SEDEVDO
     C                   READ      SEDEVDO                                81
     C     *IN81         IFEQ      *OFF
     C     E_SDSN        ANDEQ     P_PSSH
     C     E_SDET        ANDEQ     'DV'
      *
      ** Check if Diary Event is Taxable
      *
     C     E_SETX        IFEQ      'Y'
     C                   EXSR      SRCalc_Tax
     C                   ENDIF
      *
     C                   ENDIF
 
     C     ENDDIV        ENDSR                                                  **ENDDIV**
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalc_Tax - Subroutine Calculate Tax and Output to SDCSINPD *
      *                                                               *
      *****************************************************************
      *
     C     SRCalc_Tax    BEGSR
      *
      ** Initialise work variables
      *
     C                   MOVE      ' '           WTXPI             1
     C                   MOVE      ' '           WTXJA             1
     C                   MOVE      *BLANKS       @@JANO                                       235271
     C                   MOVE      *BLANKS       @@NARF                                       235271
     C                   MOVE      *BLANKS       @@INVP                                       235271
      *
     C                   MOVE      P_PCPY        @@CUST
      *
     C                   CALL      'ZATXCLPI'
      ** Input
     C                   PARM      'S'           @@MODI
     C                   PARM      P_PSSH        @@TRRF
     C                   PARM      P_PBCA        @@BRCA
     C                   PARM                    @@CUST
     C                   PARM      *ZERO         @@STRD
     C                   PARM      *ZERO         @@ENDD
     C                   PARM      P_PAMD        @@TOTI
     C                   PARM      WTRAB         @@TAXR
     C                   PARM      S_NMCY        @@OCCY
     C                   PARM      *BLANKS       PInth                                        CER048
      ** Output
     C                   PARM                    @@IAED
     C                   PARM                    @@TAXA
     C                   PARM                    @@TOTO
     C                   PARM                    @@TXCY
     C                   PARM                    @@CTAX
     C                   PARM                    @@TXBS
     C                   PARM                    @@WTAC
     C                   PARM                    @@COLC
     C                   PARM                    @@STAT
     C                   PARM                    @@TRTE
     C                   PARM                    @@TXR1
     C**********         PARM      *ZEROS        PStxb                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStac                               CER048 BUG22911
     C**********         PARM      *ZEROS        PSttr                               CER048 BUG22911
     C**********         PARM      *BLANKS       PSttp                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStxa                               CER048 BUG22911
     C                   PARM                    @@KEY
     C                   PARM                    @@FILE
     C                   PARM                    @@RTRN
     C     SDTXPA        PARM      SDTXPA        DSSDY                                      BUG22911
      *
     C                   SELECT
      *
      ** If return code = Error.
      *
     C     @@RTRN        WHENEQ    'ERROR'
     C                   MOVE      @@FILE        DBFILE
     C                   MOVE      @@KEY         DBKEY
     C                   Z-ADD     60            DBASE
     C                   EXSR      *PSSR
      *
      ** If return code = Private Individual
      *
     C     @@RTRN        WHENNE    'JOINT'
      *
     C     @@TOTO        IFNE      *ZERO
     C     @@STAT        IFEQ      'TAXAB'
     C     @@STAT        OREQ      'DISCL'
     C     @@STAT        OREQ      'SELF'
      *
     C                   MOVE      'Y'           WTXPI
     C                   MOVE      S1CTTA        KCSIS
     C                   MOVE      @@CTAX        KCTRT
      *
     C     KTXCM         CHAIN     SDTXCML1                           61
     C     *IN61         IFEQ      *OFF
      *
     C                   SELECT
     C     TCTXCM        WHENEQ    1
     C     SWHTFD        OREQ      'N'
     C     UTXRSR        OREQ      0
     C                   Z-ADD     @@TAXA        @@TAXA
      *
     C     TCTXCM        WHENEQ    2
     C     UTXRSR        MULT      @@TOTO        WTAXA            15 0
     C                   DIV       100           WTAXA
     C     @@TOTO        SUB       WTAXA         @@TAXA
     C                   MULT      @@TAXR        @@TAXA
     C                   DIV(H)    100           @@TAXA
     C     @@TAXA        IFLT      0
     C                   Z-ADD     0             @@TAXA
     C                   ENDIF
      *
     C     TCTXCM        WHENEQ    3
     C     UTXRSR        MULT      @@TOTO        WTAXA
     C                   DIV       100           WTAXA
     C                   SUB       WTAXA         @@TAXA
     C     @@TAXA        IFLT      0
     C                   Z-ADD     0             @@TAXA
     C                   ENDIF
      *
     C     TCTXCM        WHENEQ    4
     C                   Z-ADD     0             @@TAXA
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** Write record to SDCSINPD
      *
     C                   EXSR      SR_OutFile
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If return code = Joint Account
      *
     C     @@RTRN        WHENEQ    'JOINT'
     C                   MOVE      P_PCPY        KJANO             6
      *
     C     KJANO         SETLL     SDJACCLB
     C     KJANO         READE     SDJACCLB                               60
      *
     C     *IN60         DOWEQ     *OFF
      *
     C                   CALL      'ZATXCLJA'
      ** Input
     C                   PARM      'S'           @@MODI
     C                   PARM      P_PSSH        @@TRRF
     C                   PARM      P_PBCA        @@BRCA
     C                   PARM      JCJANO        @@JANO            6
     C                   PARM      JCCUST        @@CUST
     C                   PARM      JCNAHO        @@NARF
     C                   PARM      JCINVP        @@INVP
     C                   PARM      JCPAHT        @@PPAHT           1                        BUG26839
     C                   PARM      *ZERO         @@STRD
     C                   PARM      *ZERO         @@ENDD
     C                   PARM      P_PAMD        @@TOTI
     C                   PARM      WTRAB         @@TAXR
     C                   PARM      S_NMCY        @@OCCY
     C                   PARM      *BLANKS       PInth                                        CER048
      ** Output
     C                   PARM                    @@IAED
     C                   PARM                    @@TAXA
     C                   PARM                    @@TOTO
     C                   PARM                    @@TXCY
     C                   PARM                    @@CTAX
     C                   PARM                    @@TXBS
     C                   PARM                    @@WTAC
     C                   PARM                    @@COLC
     C                   PARM                    @@STAT
     C                   PARM                    @@TRTE
     C                   PARM                    @@TXR1
     C                   PARM                    @@JAMG            1
     C**********         PARM      *ZEROS        PStxb                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStac                               CER048 BUG22911
     C**********         PARM      *ZEROS        PSttr                               CER048 BUG22911
     C**********         PARM      *BLANKS       PSttp                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStxa                               CER048 BUG22911
     C                   PARM                    @@KEY
     C                   PARM                    @@FILE
     C                   PARM                    @@RTRN
     C     SDTXPA        PARM      SDTXPA        DSSDY                                      BUG22911
      *
      ** If return code = Error.
      *
     C     @@RTRN        IFEQ      'ERROR'
     C                   MOVE      @@FILE        DBFILE
     C                   MOVE      @@KEY         DBKEY
     C                   Z-ADD     61            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @@TOTO        IFNE      *ZERO
     C     @@STAT        IFEQ      'TAXAB'
     C     @@STAT        OREQ      'DISCL'
     C     @@STAT        OREQ      'SELF '
      *
     C                   MOVE      'Y'           WTXJA
     C                   MOVE      S1CTTA        KCSIS
     C                   MOVE      @@CTAX        KCTRT
      *
     C     KTXCM         CHAIN     SDTXCML1                           61
     C     *IN61         IFEQ      *OFF
      *
     C                   SELECT
     C     TCTXCM        WHENEQ    1
     C     SWHTFD        OREQ      'N'
     C     UTXRSR        OREQ      0
     C                   Z-ADD     @@TAXA        @@TAXA
      *
     C     TCTXCM        WHENEQ    2
     C     UTXRSR        MULT      @@TOTO        WTAXA
     C     S1RASO        MULT      @@TOTO        WTAXA
     C                   DIV       100           WTAXA
     C     @@TOTO        SUB       WTAXA         @@TAXA
     C                   MULT      @@TAXR        @@TAXA
     C                   DIV(H)    100           @@TAXA
     C     @@TAXA        IFLT      0
     C                   Z-ADD     0             @@TAXA
     C                   ENDIF
      *
     C     TCTXCM        WHENEQ    3
     C     UTXRSR        MULT      @@TOTO        WTAXA
     C                   DIV       100           WTAXA
     C                   SUB       WTAXA         @@TAXA
     C     @@TAXA        IFLT      0
     C                   Z-ADD     0             @@TAXA
     C                   ENDIF
      *
     C     TCTXCM        WHENEQ    4
     C                   Z-ADD     0             @@TAXA
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Write record to SDCSINPD
      *
     C                   EXSR      SR_OutFile
      *
     C                   ENDIF
      *
     C     @@RTRN        IFEQ      'NOTAX'
     C     @@RTRN        OREQ      'TAXAB'
     C     KJANO         READE     SDJACCLB                               60
     C                   ENDIF
      *
      ** If @@RTRN = Last, end loop
      *
     C     @@RTRN        IFEQ      'LAST'
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSL
      *
     C     ENDDVT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  COUPON - Subroutine to produce Coupon Account Keys and/or    *
      *           Position Settlements.                               *
      *                                                               *
      *****************************************************************
      *
     C     COUPON        BEGSR                                                  ** COUPON **
      *
     C                   Z-ADD     P_PDUD        WDATE             5 0
     C**********         Z-ADD     P_PCPY        WPCPY                                235320 CSD027A
     C                   Eval      WPCPY = P_PCPY                                            CSD027A
     C                   Z-ADD     P_PAMD        WPAMD                                        235320
      *
      ** Get Purchased interest on position by accessing ETCPOSND
      *
     C                   CALL      'SEETCPRTV'
     C                   PARM                    WRTCD            10
     C                   PARM                    P_PBCA
     C*****              PARM                    P_PCPY                                       235320
     C                   PARM                    WPCPY                                        235320
     C                   PARM                    P_PSSH
     C                   PARM      P_PTFR        WPTFR             4
     C                   PARM      P_PMAR        WMKT              1
     C                   PARM                    WDATE
     C                   PARM                    ETCPOS
      *
      ** If Purchased interest is from a date prior to last coupon date
      *  then zero-ize it.
      *
     C                   EVAL      ZECD = P_PDUD
     C                   EXSR      SRZLCD
     C     CSDA          IFLT      ZZLCD
     C                   Z-ADD     0             CSPI
     C                   ENDIF
      *****                                                                                   235320
      ***Taxable*amount*is*amount*due*minus*purchased*interest                                235320
      *****                                                                                   235320
     C*****P_PAMD        SUB       CSPI          P_PAMD                                       235320
      *
     C                   EXSR      SRZNCD                                                     235320
      *                                                                                       235320
     C                   EVAL      WAMT = CSNV                                                235320
      *                                                                                       235320
     C                   EVAL      WCURRKEY = S_NMCY                                          235320
     C                   EXSR      SRRtvCurrDet                                               235320
                                                                                              236042
     C                   EVAL      Indx = 5 - S_NMDP + A6NBDP                                 236042
                                                                                              236042
     C                   EVAL(H)   WAMT = (WAMT * POWER9(Indx))                               236042
                                                                                              236042
     C**********         DO        A6NBDP                                              235320 236042
     C**********         EVAL      WAMT = WAMT * 10                                    235320 236042
     C**********         ENDDO                                                         235320 236042
      *                                                                                       235320
     C                   EVAL      IRATE = S_CPNR                                             235320
      *                                                                                       235320
     C                   IF        APDT < EWEDT1 AND EWTRT1 = '1'                             235320
     C                   EVAL      WSTART = EWEDT1                                            235320
     C                   ELSE                                                                 235320
     C                   EVAL      WSTART = APDT                                              235320
     C                   ENDIF                                                                235320
                                                                                              235320
      ** Compute for the accrued coupon                                                       235320
                                                                                              235320
     C                   CALLB     'ZACCR'                                                    235320
     C                   PARM                    WAMT                                         235320
     C                   PARM                    IRATE                                        235320
     C                   PARM                    WSTART                                       235320
     C                   PARM                    ZECD                                         235320
     C                   PARM                    SECT                                         235320
     C                   PARM                    S_IADJ                                       235320
     C                   PARM                    ZZNCD                                        235320
     C                   PARM                    S_NMDP                                       235320
     C                   PARM                    PROT                                         235320
     C                   PARM                    BJDFIN                                       235320
                                                                                              235320
      ** Output                                                                               235320
                                                                                              235320
     C                   PARM                    ZZACINT1                                     235320
     C                   PARM                    ZZACINT2                                     235320
     C                   PARM                    ZRP                                          235320
     C                   PARM                    NODAYS1                                      235320
     C                   PARM                    NODAYS2                                      235320
                                                                                              235320
     C                   EVAL      P_PAMD = ZZACINT1                                          235320
                                                                                              235320
     C                   IF        P_PAMD > WPAMD                                             236453
     C                   EVAL      P_PAMD = WPAMD                                             236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   EXSR      SRCalc_Tax
     C*
     C     ENDCPN        ENDSR                                                  ** ENDCPN**
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRZLCD - Compute Last Coupon Date                             *
      *                                                               *
      *****************************************************************
 
     C     SRZLCD        BEGSR
 
     C                   CALLB     'ZLCD'
     C                   PARM                    S_ISSD
     C                   PARM                    S_ITLD
     C                   PARM                    S_FCPN
     C                   PARM                    S_MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    S_LCPN                                     BUG11164
      *
      ** Event Control Date
      ** Date Format
     C                   PARM                    ZECD              5 0
     C                   PARM                    BJDFIN
 
      ** Nominal Currency
      ** Security Investment Type
      ** Effect on Holidays on Coupon Dates
     C                   PARM                    S_NMCY
     C                   PARM                    S_SITP
     C                   PARM                    S_BCNV
     C                   PARM                    S_HCY1                                       237063
     C                   PARM                    S_HCY2                                       237063
     C                   PARM                    S_HCY3                                       237063
     C                   PARM                    S_HCY4                                       237063
     C                   PARM                    S_HCY5                                       237063
     C                   PARM                    S_HCY6                                       237063
     C                   PARM                    S_HCY7                                       237063
     C                   PARM                    S_HCY8                                       237063
     C                   PARM                    S_HCY9                                       237063
 
      * OUTPUTS
      ** Last Coupon Date before Control Date
     C                   PARM                    ZZLCD             5 0
 
     C                   ENDSR
      *****************************************************************                       235320
     C/EJECT                                                                                  235320
      *****************************************************************                       235320
      *                                                               *                       235320
      * SRZNCD - Compute Next Coupon Date                             *                       235320
      *                                                               *                       235320
      *****************************************************************                       235320
                                                                                              235320
     C     SRZNCD        BEGSR                                                                235320
                                                                                              235320
     C                   CALLB     'ZNCD'                                                     235320
     C                   PARM                    S_ITLD                                       235320
     C                   PARM                    S_FCPN                                       235320
     C                   PARM                    S_MATY                                       235320
     C                   PARM                    CDArr                                        235320
     C                   PARM                    CRArr                                        235320
      *                                                                                       235320
      ** Event Control Date                                                                   235320
      ** Date Format                                                                          235320
     C                   PARM                    ZECD                                         235320
     C                   PARM                    BJDFIN                                       235320
                                                                                              235320
      ** Nominal Currency                                                                     235320
      ** Security Investment Type                                                             235320
      ** Effect on Holidays on Coupon Dates                                                   235320
     C                   PARM                    S_NMCY                                       235320
     C                   PARM                    S_SITP                                       235320
     C                   PARM                    S_BCNV                                       235320
     C                   PARM                    ZZLCD             5 0                        237063
     C                   PARM                    S_HCY1                                       237063
     C                   PARM                    S_HCY2                                       237063
     C                   PARM                    S_HCY3                                       237063
     C                   PARM                    S_HCY4                                       237063
     C                   PARM                    S_HCY5                                       237063
     C                   PARM                    S_HCY6                                       237063
     C                   PARM                    S_HCY7                                       237063
     C                   PARM                    S_HCY8                                       237063
     C                   PARM                    S_HCY9                                       237063
     C                   PARM                    ZZNCD                                        235320
                                                                                              235320
     C                   ENDSR                                                                235320
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MORTPY - Subroutine to produce Mortgage Payment Account Keys *
      *           and/or Position Settlements.                        *
      *                                                               *
      *****************************************************************
      *
     C     MORTPY        BEGSR                                                  ** MORTPY **
      *
      ** if Issue Price is 100, (i.e. not dicsount or premium),
      ** no tax is calculated.
      *
     C     S_ISSP        IFNE      100
      *
      ** Get Fiscal Price at Event Date
      *
     C* get redemption price
     C                   Z-ADD     0             SDRP
     C                   Z-ADD     S_MATY        SDED
     C                   MOVE      'RC'          SDET
     C*
     C** CHECK FILE FOR EITHER 'RC' TYPE OR 'RP' TYPE IN KEY FIELD
     C*
     C                   EXSR      SECEDI
     C     *IN78         IFEQ      '1'
     C                   MOVE      'RP'          SDET
     C                   EXSR      SECEDI
     C                   END
     C     *IN78         IFEQ      '1'
     C*
     C** IF NEITHER RC NOR RP USE 100 IF PRICE BASIS IS P,ELSE 1 (U)
     C** Or if RP/RC record found AND price is zero and S01509 is
     C** active, use 100 if price basis is P, else 1
     C*
     C     *IN78         OREQ      '0'
     C     SDRP          ANDEQ     0
     C     S01509        ANDEQ     'Y'
     C*
     C     S_SPBS        IFEQ      'P'
     C                   Z-ADD     100           SDRP
     C                   END
     C     PROT          IFEQ      '1'
     C     S_SPBS        ANDEQ     'U'
     C                   Z-ADD     1             SDRP
     C                   ENDIF
     C                   END
      ** If Country of Tax is not Switzerland, use straight line basis
      *
     C                   Z-ADD     S_ISSP        WIssp
     C                   Z-ADD     S_ISSD        WIssd
     C                   Z-ADD     S_MATY        WMaty
     C                   Z-ADD     P_PDUD        WTdvd
     C                   Z-ADD     100           WPram
      *
     C     EWCTRT        IFNE      'CH'
     C                   CALL      'ZAINTPL2'
     C                   PARM                    WIssd             5 0
     C                   PARM                    WTdvd             5 0
     C                   PARM                    WMaty             5 0
     C                   PARM                    WIssp            15 8
     C                   PARM                    WPram            15 8
     C                   PARM                    WFspr            15 8
      *
      ** If Country of Tax is Switzerland, use analytical interpolation
      *
     C                   ELSE
     C                   CALL      'ZAACTUAR'
     C                   PARM      *BLANK        WRTCD            10
     C                   PARM                    WIssd
     C                   PARM                    WIssp
     C                   PARM                    WMaty
     C                   PARM                    WPram
     C                   PARM                    S_DYBS
     C                   PARM                    S_DVBS
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    S_LCPN                                     BUG11164
     C                   PARM                    WTdvd
     C                   PARM                    WFspr
     C                   ENDIF
      *
      ** Get Average Fiscal Price of Position
      *
     C                   Z-ADD     P_PDUD        WDATE             5 0
     C**********         Z-ADD     P_PCPY        WPCPY                                236453 CSD027A
     C                   Eval      WPCPY = P_PCPY                                            CSD027A
     C                   Z-ADD     P_PAMD        WPAMD                                        236453
      *
      ** Access Customer Position
      *
     C                   CALL      'SEETCPRTV'
     C                   PARM                    WRTCD            10
     C                   PARM                    P_PBCA
     C**********         PARM                    P_PCPY                                       236453
     C                   PARM                    WPCPY                                        236453
     C                   PARM                    P_PSSH
     C                   PARM      P_PTFR        WPTFR             4
     C                   PARM      P_PMAR        WMKT              1
     C                   PARM                    WDATE
     C                   PARM                    ETCPOS
      *
     C                   Z-ADD     AVFP          WAVFP            15 8
      *
     C* taxable amount is the difference between Fiscal Price and average
     C*  Fiscal price x Payment Amount (amount due PAMD)
     C*
     C     WFspr         SUB       WAVFP         WFISC            15 8
     C*
     C     S_SPBS        IFEQ      'P'
     C                   DIV(H)    100           WFISC
     C                   END
     C     P_PAMD        MULT      WFISC         WFSCA            15 0
     C*
     C* Now do comparison with profit on mortgage repayment, if country
     C*  of tax is not Switzerland, and take the lower figure as the
     C* the taxable amount
     C*
     C* bit about CH is added and removed by this change control
     C* it is left in the code in case the situation changes again.
     C*
     C*  If average price is greater than 100 then there is no profit and so
     C*  not tax (mortage repayments deemed to be at price 100)
     C     WAVPR         IFGT      100
     C                   Z-ADD     0             WNEGA            15 0
     C                   ELSE
     C     100           SUB       LAVP          WAVPR            15 8
     C*
     C     S_SPBS        IFEQ      'P'
     C                   DIV(H)    100           WAVPR
     C                   END
     C*
     C     P_PAMD        MULT      WAVPR         WPRFA            15 0
     C     WPRFA         IFLT      WFSCA
     C                   Z-ADD     WPRFA         WNEGA
     C                   ELSE
     C                   Z-ADD     WFSCA         WNEGA
     C                   ENDIF
     C                   ENDIF
      *
      *   if Switzerland then just take "fiscal" amount
      *
     C     WNEGA         IFGT      0
      *
     C                   EVAL      P_PAMD = WNEGA
     C                   EXSR      SRCalc_Tax
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MATURE - Subroutine to produce Maturity Position Settlements.*
      *                                                               *
      *****************************************************************
      *
     C     MATURE        BEGSR                                                  ** MATURE **
      *
      ** Calculate Tax Amount for the Maturity
      *
     C     S_ISSP        IFNE      100
      *
      ** Get Average Fiscal Price of Position
      *
      ** Access Customer Position
      *
     C                   Z-ADD     P_PDUD        WDATE                                        236453
     C**********         Z-ADD     P_PCPY        WPCPY                                236453 CSD027A
     C                   Eval      WPCPY = P_PCPY                                            CSD027A
     C                   Z-ADD     P_PAMD        WPAMD                                        236453
     C                   Z-ADD     P_PDUD        WDATE             5 0
      *
      ** Access Customer Position
      *
     C                   CALL      'SEETCPRTV'
     C                   PARM                    WRTCD            10
     C                   PARM                    P_PBCA
     C**********         PARM                    P_PCPY                                       236453
     C                   PARM                    WPCPY                                        236453
     C                   PARM                    P_PSSH
     C                   PARM      P_PTFR        WPTFR             4
     C                   PARM      P_PMAR        WMKT              1
     C                   PARM                    WDATE
     C                   PARM                    ETCPOS
      *
     C     P_PAMD        SUB       CSAV          P_PAMD
      *
     C     S_ISSP        IFGE      100
     C     S_SPBS        OREQ      'U'
     C                   Z-ADD     *ZERO         @@TAXA
     C                   ELSE
     C                   EXSR      SRCalc_Tax
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_OutFile - Output result file                               *
      *                                                               *
      *****************************************************************
 
     C     SR_OutFile    BEGSR
 
      ** Initialize fields of PF/SDCSINPD
 
     C                   EXSR      SRInitFields
 
      ** Tax calculation Date
 
     C**********         EVAL      TSRDNB = BJRDNB                                            236453
     C                   EVAL      TSRDNB = BJRDNB - 1                                        236453
     C                   EVAL      TSEDAT = P_PDUD
 
      ** Tax year and month
 
     C                   EVAL      ZDAYNO = TSEDAT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZDATE         WMMDD
     C                   MOVE      ZDATE         WYear1
 
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     WMMDD         WMonth
     C                   ELSE
     C                   MOVE      WMMDD         WMonth
     C                   ENDIF
 
     C                   EVAL      WYear2 = '20' + Wyear1
     C                   MOVEL     WYear2        TSTAXY
     C                   EVAL      TSTAXM = WMonth
 
      ** Country of tax
      ** Booking branch code
      ** Joint account number
      ** Customer number
      ** Non-account holder reference
      ** Investment type
      ** Residence country code
 
     C                   EVAL      TSCTRT = @@CTAX
     C                   EVAL      TSBRCA = P_PBCA
     C                   MOVEL     @@JANO        TSJOIN
     C************       MOVE      P_PCPY        TSCUST
     C                   MOVE      @@CUST        TSCUST
     C                   EVAL      TSNAHO = @@NARF
     C                   EVAL      TSINVP = @@INVP
     C                   EVAL      TSRCTR = @@COLC
 
      ** Customer Status
 
     C                   SELECT
     C     @@STAT        WHENEQ    'DISCL'
     C                   EVAL      TSSTAT = 'D'
     C     @@STAT        WHENEQ    'SELF'
     C                   EVAL      TSSTAT = 'S'
     C     @@STAT        WHENEQ    'TAXAB'
     C                   EVAL      TSSTAT = 'T'
     C                   ENDSL
 
     C     @@NARF        IFNE      *BLANK
 
      ** Retrieve non account holder details
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      @@NARF        @PNAHO
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = @PNAHO
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   MOVEL     '914'         DBASE
     C                   EXSR      *PSSR
 
     C                   ELSE
      ** Family name
      ** First name
      ** Street
      ** Zip code
      ** City
      ** Tax identification number
      ** Date of birth
      ** Country code of birth
     C                   EVAL      TSFAMN = NHIDE1
     C                   EVAL      TSFIRN = NHIDE2
     C                   EVAL      TSSTRT = NHIDE3 + ' ' + NHIDE4
     C                   EVAL      TSZIPC = NHZIPC
     C                   EVAL      TSCITY = NHCITY
     C                   EVAL      TSRTIN = NHTINO
     C                   EVAL      TSDBTH = NHDBTH
     C                   EVAL      TSTBTH = NHBTHT
     C                   EVAL      TSCBTH = NHBTHC
     C                   ENDIF
 
     C                   ELSE
     C     @@CUST        IFNE      *BLANK
 
      ** Retrieve additional customer details.
 
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      @@CUST        @PCUST
     C     SDACUS        PARM      SDACUS        DSSDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = @PCUST
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   MOVEL     '913'         DBASE
     C                   EXSR      *PSSR
 
     C                   ELSE
      ** Family name
      ** First name
      ** Street
      ** Zip code
      ** City
      ** Tax identification number
      ** Date of birth
      ** Country code of birth
     C                   EVAL      TSFAMN = E5CNA1
     C                   EVAL      TSFIRN = E5CNA2
     C                   EVAL      TSSTRT = E5CNA3 + ' ' + E5CNA4
     C                   EVAL      TSZIPC = E5ZIPC
     C                   EVAL      TSCITY = E5CITY
     C                   EVAL      TSRTIN = E5TINO
     C                   EVAL      TSDBTH = E5DBTH
     C                   EVAL      TSTBTH = E5BTHT
     C                   EVAL      TSCBTH = E5BTHC
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Interest payment date
 
     C                   CALLB     'ZDATE9'
     C                   PARM                    P_PDUD
     C                   PARM                    WDATEYYYY
     C                   PARM                    RetCodeIn
     C                   EVAL      TSIPDT = WDATEYYYY
 
      ** Tax basket
      ** Eu withholding tax code
 
     C                   MOVEL     @@TXBS        TSTXBS
     C                   EVAL      TSWTAC = @@WTAC
 
      ** Original currency code
 
     C                   EVAL      TSOCCY = P_PNCY
     C                   EVAL      WCURRKEY = TSOCCY
 
      ** Retrieve currency details of original currency
 
     C                   EXSR      SRRtvCurrDet
 
      ** Original currency spot rate
 
     C     A6MDIN        IFEQ      'D'
     C                   EVAL      TSOCSR = A6SPRT
     C                   ELSE
     C                   EVAL      TSOCSR = 1 / A6SPRT
     C                   ENDIF
 
      ** Original currency multiply/divide
      ** Original currency decimal places
 
     C                   EVAL      TSOCMD = 'D'
     C                   EVAL      TSOCDP = A6NBDP
     C                   EVAL      ZADEC  = A6NBDP
 
      ** Settlement currency code
 
     C                   EVAL      TSSCCY = P_PSCU
     C                   EVAL      WCURRKEY = TSSCCY
 
      ** Retrieve currency details of settlement currency
 
     C                   EXSR      SRRtvCurrDet
 
      ** Settlement currency spot rate
 
     C     A6MDIN        IFEQ      'D'
     C                   EVAL      TSSCSR = A6SPRT
     C                   ELSE
     C                   EVAL      TSSCSR = 1 / A6SPRT
     C                   ENDIF
 
      ** Settlement currency multiply/divide
      ** Settlement currency decimal places
 
     C                   EVAL      TSSCMD = 'D'
     C                   EVAL      TSSCDP = A6NBDP
 
      ** Tax currency code
 
     C                   EVAL      TSTXCY = @@TXCY
     C                   EVAL      WCURRKEY = TSTXCY
 
      ** Retrieve currency details of tax currency
 
     C                   EXSR      SRRtvCurrDet
 
      ** Tax currency spot rate
 
     C     A6MDIN        IFEQ      'D'
     C                   EVAL      TSTCSR = A6SPRT
     C                   ELSE
     C                   EVAL      TSTCSR = 1 / A6SPRT
     C                   ENDIF
 
      ** Tax currency multiply/divide
      ** Tax currency decimal places
 
     C                   EVAL      TSTCMD = 'D'
     C                   EVAL      TSTCDP = A6NBDP
 
      ** Original/settlement currency exchange rate
 
     C                   EVAL      TSXROS = 1
 
      ** Retrieve currency exchange rate
 
     C                   EVAL      ZRATE1 = TSSCSR
     C                   EVAL      ZRATE2 = TSTCSR
     C                   EVAL      ZMDI1 = TSSCMD
     C                   EVAL      ZMDI2 = TSTCMD
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM      *ZERO         ZRATEX
     C                   PARM      *BLANK        ZMDIX
 
      ** Settlement/tax currency exchange rate
      ** Original/settlement cross rate multiply/divide
      ** Settlement/tax cross rate multiply /divide
 
     C                   EVAL      TSXRST = ZRATEX
     C                   EVAL      TSOSMD = 'M'
     C                   EVAL      TSSTMD = ZMDIX
 
      ** Module identifier
 
     C                   EVAL      TSMODI = 'S'
 
      ** Deal Type/Trade type
      ** Deal sub-type/trade sub-type
      ** Deal number/trade number
 
     C                   EVAL      TSTRTP = '  '
     C                   EVAL      TSTRST = '  '
     C                   Z-ADD     *ZERO         TSDLLN
 
      ** Account code
      ** Account sequence
      ** IBAN number
 
     C                   EVAL      TSACOD = 0
     C                   EVAL      TSACSQ = 0
     C                   EVAL      TSIBAN = *BLANK
 
      ** Principal amount in original currency
      ** Gross interest amount in original currency
 
     C*****              EVAL      TSPAMT = P_PNMP                                            235320
     C                   EVAL      TSPAMT = WPAMD                                             235320
     C                   EVAL      TSGINT = @@TOTO
 
      ** Tax rate
      ** Tax deducted at source in original currency
 
     C     TSSTAT        IFEQ      'T'
     C                   EVAL      TSTXRT = @@TXR1
     C                   EVAL      TSTXSR = @@TAXA
     C                   ENDIF
 
      ** Net interest amount in original ccy
 
     C                   EVAL      TSNINT = TSGINT - TSTXSR
 
      ** Principal amount in settlement currency
 
     C     TSOCCY        IFEQ      TSSCCY
     C                   EVAL      TSPAMS = TSPAMT
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSPAMT        ZAMTCI
     C                   PARM      TSXROS        ZEXCH
     C                   PARM      TSOSMD        ZMD
     C                   PARM      TSOCCY        ZCCYI
     C                   PARM      TSSCCY        ZCCYO
     C                   PARM      TSOCDP        ZCDPI
     C                   PARM      TSSCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSPAMS = ZAMTCO
     C                   ENDIF
 
      ** Gross interest amount in settlement currency
 
     C     TSOCCY        IFEQ      TSSCCY
     C                   EVAL      TSGINS = @@TOTO
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      @@TOTO        ZAMTCI
     C                   PARM      TSXROS        ZEXCH
     C                   PARM      TSOSMD        ZMD
     C                   PARM      TSOCCY        ZCCYI
     C                   PARM      TSSCCY        ZCCYO
     C                   PARM      TSOCDP        ZCDPI
     C                   PARM      TSSCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSGINS = ZAMTCO
     C                   ENDIF
 
      ** Tax deducted at source in settlement currency
 
     C     TSOCCY        IFEQ      TSSCCY
     C                   EVAL      TSTXSS = @@TAXA
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      @@TAXA        ZAMTCI
     C                   PARM      TSXROS        ZEXCH
     C                   PARM      TSOSMD        ZMD
     C                   PARM      TSOCCY        ZCCYI
     C                   PARM      TSSCCY        ZCCYO
     C                   PARM      TSOCDP        ZCDPI
     C                   PARM      TSSCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSTXSS = ZAMTCO
     C                   ENDIF
 
      ** Net interest amount in settlement currency
      ** Principal amount in tax currency
 
     C                   EVAL      TSNINS = TSGINS - TSTXSS
     C     TSTXCY        IFEQ      TSSCCY
     C                   EVAL      TSPAMC = TSPAMS
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSPAMS        ZAMTCI
     C                   PARM      TSXRST        ZEXCH
     C                   PARM      TSSTMD        ZMD
     C                   PARM      TSSCCY        ZCCYI
     C                   PARM      TSTXCY        ZCCYO
     C                   PARM      TSSCDP        ZCDPI
     C                   PARM      TSTCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSPAMC = ZAMTCO
     C                   ENDIF
 
      ** Gross interest amount in tax currency
 
     C     TSTXCY        IFEQ      TSSCCY
     C                   EVAL      TSGINC = TSGINS
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSGINS        ZAMTCI
     C                   PARM      TSXRST        ZEXCH
     C                   PARM      TSSTMD        ZMD
     C                   PARM      TSSCCY        ZCCYI
     C                   PARM      TSTXCY        ZCCYO
     C                   PARM      TSSCDP        ZCDPI
     C                   PARM      TSTCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSGINC = ZAMTCO
     C                   ENDIF
 
      ** Tax deducted at source in tax currency
 
     C     TSTXCY        IFEQ      TSSCCY
     C                   EVAL      TSTXSC = TSTXSS
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSTXSS        ZAMTCI
     C                   PARM      TSXRST        ZEXCH
     C                   PARM      TSSTMD        ZMD
     C                   PARM      TSSCCY        ZCCYI
     C                   PARM      TSTXCY        ZCCYO
     C                   PARM      TSSCDP        ZCDPI
     C                   PARM      TSTCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSTXSC = ZAMTCO
     C                   ENDIF
 
      ** Net interest amount in tax currency
 
     C                   EVAL      TSNINC = TSGINC - TSTXSC
 
      ** Retrieve currency details of bank currency
 
     C                   EVAL      WCURRKEY = BJCYCD
     C                   EXSR      SRRtvCurrDet
 
      ** Principal amount in base currency
 
     C     BJCYCD        IFEQ      TSSCCY
     C                   EVAL      TSPAMB = TSPAMS
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSPAMS        ZAMTCI
     C                   PARM      TSSCSR        ZEXCH
     C                   PARM      TSSTMD        ZMD
     C                   PARM      TSSCCY        ZCCYI
     C                   PARM      BJCYCD        ZCCYO
     C                   PARM      TSSCDP        ZCDPI
     C                   PARM      A6NBDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSPAMB = ZAMTCO
     C                   ENDIF
 
      ** Gross interest amount in base currency
 
     C     BJCYCD        IFEQ      TSSCCY
     C                   EVAL      TSGINB = TSGINS
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSGINS        ZAMTCI
     C                   PARM      TSSCSR        ZEXCH
     C                   PARM      TSSTMD        ZMD
     C                   PARM      TSSCCY        ZCCYI
     C                   PARM      BJCYCD        ZCCYO
     C                   PARM      TSSCDP        ZCDPI
     C                   PARM      A6NBDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSGINB = ZAMTCO
     C                   ENDIF
 
      ** Tax deducted at source in base currency
 
     C     BJCYCD        IFEQ      TSSCCY
     C                   EVAL      TSTXSB = TSTXSS
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSTXSS        ZAMTCI
     C                   PARM      TSSCSR        ZEXCH
     C                   PARM      TSSTMD        ZMD
     C                   PARM      TSSCCY        ZCCYI
     C                   PARM      BJCYCD        ZCCYO
     C                   PARM      TSSCDP        ZCDPI
     C                   PARM      A6NBDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSTXSB = ZAMTCO
     C                   ENDIF
 
      ** Net interest amount in base currency
 
     C                   EVAL      TSNINB = TSGINB - TSTXSB
 
     C                   EVAL      TSETYP = P_PEVT
     C                   EVAL      TSSESN = P_PSSH
     C                   MOVEL     S_ISNO        TSISIN
     C                   MOVEL     S_SRPN        TSSRPN
 
     C                   SELECT
     C     TSETYP        WHENEQ    'CP'
     C     TSSESN        CAT       WINST1        TSINST
     C     TSETYP        WHENEQ    'DV'
     C     TSSESN        CAT       WINST2        TSINST
     C     TSETYP        WHENEQ    'MT'
     C     TSSESN        CAT       WINST3        TSINST
     C     TSETYP        WHENEQ    'MP'
     C     TSSESN        CAT       WINST4        TSINST
     C                   ENDSL
 
      ** Customer income processed
 
     C                   EVAL      TSINPR = 'N'
 
      ** Get transaction no of last update, one for every trade number
 
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PTSTNLU
 
     C                   EVAL      TSTNLU = PTSTNLU
 
     C                   WRITE     SDCSIND0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInitFields - Initialise PF/SDCSINPD                         *
      *****************************************************************
     C     SRInitFields  BEGSR
 
     C                   EVAL      TSTAXY = 0
     C                   EVAL      TSTAXM = 0
     C*****              EVAL      TSJOIN = 0                                                CSD027A
     C                   EVAL      TSJOIN = *BLANK                                           CSD027A
     C                   EVAL      TSNAHO = *BLANK
     C                   EVAL      TSINVP = *BLANK
     C                   EVAL      TSSTAT = *BLANK
     C                   EVAL      TSFAMN = *BLANK
     C                   EVAL      TSFIRN = *BLANK
     C                   EVAL      TSSTRT = *BLANK
     C                   EVAL      TSZIPC = *BLANK
     C                   EVAL      TSCITY = *BLANK
     C                   EVAL      TSRTIN = *BLANK
     C                   EVAL      TSDBTH = *BLANK
     C                   EVAL      TSTBTH = *BLANK
     C                   EVAL      TSCBTH = *BLANK
     C                   EVAL      TSTXRT = 0
     C                   EVAL      TSTXSR = 0
     C                   EVAL      TSNINT = 0
     C                   EVAL      TSPAMS = 0
     C                   EVAL      TSGINT = 0                                                 236453
     C                   EVAL      TSGINS = 0
     C                   EVAL      TSTXSS = 0
     C                   EVAL      TSNINS = 0
     C                   EVAL      TSPAMC = 0
     C                   EVAL      TSGINC = 0
     C                   EVAL      TSTXSC = 0
     C                   EVAL      TSNINC = 0
     C                   EVAL      TSPAMB = 0
     C                   EVAL      TSGINB = 0
     C                   EVAL      TSTXBS = 0
     C                   EVAL      TSNINB = 0
     C                   EVAL      TSTNLU = 0
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   EVAL      TSSTXB = *ZEROS                                            CER048
     C                   EVAL      TSSTAC = *ZEROS                                            CER048
     C                   EVAL      TSSTRT = *ZEROS                                            CER048
     C                   EVAL      TSSTDO = *ZEROS                                            CER048
     C                   EVAL      TSSTDS = *ZEROS                                            CER048
     C                   EVAL      TSSTDT = *ZEROS                                            CER048
     C                   EVAL      TSSTDB = *ZEROS                                            CER048
     C                   EVAL      TSPTHU = *ZEROS                                            CER048
     C                   EVAL      TSPTUT = *ZEROS                                            CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvCurrDet - Retrieve Currency Details                      *
      *****************************************************************
     C     SRRtvCurrDet  BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCURRKEY      PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = PCURR
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   MOVEL     '915'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SECEDI - Subroutine to get Security Diary Event record.      *
      *                                                               *
      *****************************************************************
      *
     C     SECEDI        BEGSR                                                  ** SECEDI **
     C*
     C** CHAIN FOR SECURITY EVENT RECORD AND DATA BASE ERROR
     C*
     C     SECDKY        CHAIN     SEDEVDF                            7877
     C     *IN78         IFNE      '1'
     C     RECI          COMP      '*'                                    78
     C                   END
     C     *IN77         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SEDEV'       DBFILE                         ***************
     C                   MOVEL     P_PSSH        DBKEY                          * DB ERROR 06 *
     C                   Z-ADD     6             DBASE                          ***************
     C                   SETON                                        U7U8
     C                   DUMP
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '1'           DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
     C** Check if Value currency is installed
     C*
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01509'      @SARD             6
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01509            1
     C                   ELSE
     C                   MOVE      'N'           S01509
     C                   END
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     @OPTN                                        CER048
     C                   PARM      'CER048'      @SARD                                        CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   END                                                                  CER048
      *
      ** Define key list for file
      *
     C*  - SECURITY DIARY EVENTS
     C     SEDKEY        KLIST
     C                   KFLD                    P_PSSH
     C                   KFLD                    P_PEVT
     C                   KFLD                    P_PDUD
     C*
     C* SECURITY EVENTS -                        LF/SEDEV
     C*
     C     SECDKY        KLIST
     C                   KFLD                    P_PSSH
     C                   KFLD                    P_PDUD
     C                   KFLD                    P_PEVT
     C*
     C     SECTKY        KLIST
     C                   KFLD                    P_PSSH
     C*
     C*
      ** Get Tax Calculation Method - LF/SDTXCML1 (PF/SDTXCMPD)
      *
     C     KTXCM         KLIST
     C                   KFLD                    KCSIS             2
     C                   KFLD                    KCTRT             2
      *
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
**  POWER9 - ARRAY OF POWERS FOR CURRENCY CONVERSION                                          236042
000000001                                                                                     236042
000000010                                                                                     236042
000000100                                                                                     236042
000001000                                                                                     236042
000010000                                                                                     236042
000100000                                                                                     236042
001000000                                                                                     236042
010000000                                                                                     236042
100000000                                                                                     236042
