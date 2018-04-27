     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL Nostro Events for FX Nets')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL0405 - Midas DL Events Creation for FX Nets                *
      *                                                               *
      *  Function:  This program is called by GLC0802C to generate    *
      *             Nostro Events for confirmed FX nets.              *
      *                                                               *
      *  Called By: GLC0802C  - Events File Creation                  *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD048346           Date 20Dec17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 MD046325           Date 26Jul17               *
      *                 MD045382           Date 20Apr17               *
      *                 MD036589A          Date 22Feb17               *
      *                 MD036589 *CREATE   Date 14Feb16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD048346 - FX netting ICD against FX nets will not prioritize*
      *             customer branch of the FX nets, instead, it will  *
      *             prioritize (1) system value branch code; if blank,*
      *             (2) settlement branch of FX net; if blank, then   *
      *             revert to (3) customer branch of FX net.          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD046325 - GLC0802C failed due to invalid nostro code.       *
      *             Check settlement first if nostro.                 *
      *  MD045382 - No contra posting on FX netting ICD for nostro    *
      *             settling on a different branch.  Always correctly *
      *             set branch code.                                  *
      *  MD036589A - Reopen.  Project also entries from netting       *
      *              account code.                                    *
      *  MD036589 - New program to create nostro events for FX        *
      *             nets during COB.                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file                                     *
      *    02         No record found                                 *
      *    41         Chain to FXNETML3                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRDBErr - Database error processing                           *
      * SRMapFld - Map net fields to Events file                      *
      * SRWrite  - Write record to Events creation detail file.       *
      * SRUpdTrl - Update/Write Events creation trailer file.         *
      * SRNost -  Access nostro details                               *
      * SRCycd -  Access Currency code details                        *
      * SRCust -  Access Customer details                             *
      * SRBrch -  Access Branch code details                          *
      * SRCtry -  Access Country code details                         *
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
      *
      ** FX Confirmed nets master file
     FFXNETML1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** FX Confirmed nets by net reference
     FFXNETML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXNETMD0:FXNET)
     F                                     PREFIX(B_)
      ** DL Nostro Events Extract trailer
     FNOSEXZZ   UF A E             DISK    INFSR(*PSSR)
      *
      ** DL Nostro Events Extract header
     FNOSEXEC   UF A E             DISK    INFSR(*PSSR)
      *
      ** DL Nostro Events Extract detail
     FNOSEXED   O    E             DISK    INFSR(*PSSR)
      *
      ** Midas DL Nostro Events for FX Nets Audit
     FDL0405AU  O    E             PRINTER

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      ** External DS for general ledger ICD details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  W7ACD1       E                     EXTFLD(QQACCD)
      *
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS for Country code details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** External DS for Branch code details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  W7DFAC       E                     EXTFLD(QQDFAC)
      *
      ** External DS for modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** External DS for account details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A)
      *
      ** External DS for Dealing Details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  W7ACD2       E                     EXTFLD(QQACCD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  NoRecFnd              02     02
      *
      ** Net reference
     D WNETR           DS
     D  W7                     1      7
     D  WCCY                   8     10
     D  W19                   11     19
      *
      ** Settlement account                                                                 MD046325
     D OSAcNo          DS                                                                   MD046325
     D  KCust                  1      6                                                     MD046325
     D  KAccd                  7     16                                                     MD046325
     D  KAcsq                 17     18                                                     MD046325
      *                                                                                     MD046325
      ** Hash totalling fields
     D                 DS
     D  WWAmt                  1     15  3
     D  WWAmtI                16     30  0
     D  WWAmtD                31     33  0
     D  WWTotD                34     36  0
     D  WWTotI                37     51  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work parameters
     D PPNOI           S              1A
     D PAcSn           S              2A
     D PNoNb           S              2A
     D PBrCd           S              3A
     D PCyCd           S              3A
     D PAccn           S             10A
     D PCust           S              6A
     D PRtCd           S              7A
     D POptn           S              7A
     D PCsSn           S             10A
     D PRetl           S             10A
     D PCnum           S             10A
     D PKyst           S              7A
     D PBrch           S              3A
     D PCnCd           S              2A
      *
      ** Work variable
     D WRun            S              1A
     D WDumNostro      S              1A
     D WDecimal        S              4P 0 INZ(*ZEROS)
     D WDecSum         S              4P 0 INZ(*ZEROS)
     D WGenRec         S              5S 0 INZ(*ZEROS)
     D WControlDat     S              5P 0
     D WAmt            S             15P 3
     D WInteger        S             15P 0 INZ(*ZEROS)
     D N               S              1  0
     D WCDP            S              1  0
     D WMDI            S              1
     D Wrk159          S             15P 9
     D WBCXR           S             13P 8
     D WERLC           S             13P 8
     D Vnet            S              1A                                                   MD036589A
     D Netnos          S              2A                                                   MD036589A
     D Evnos           S              1A                                                    MD046325
     D WSetm           S              2  0                                                  MD046325
     D WAcnt           S             10                                                     MD046325
     D WAcCn           S             10                                                     MD046325
     D WAcSn           S              2                                                     MD046325
      *
      ** Pointer for the indicator array
     D IndicatorP      S               *   INZ(%Addr(*IN))

      *                                                                                     MD048346
      ** Variable for System Values                                                         MD048346
     D SVALK1          S             20                                                     MD048346
     D SVAL1           S            200                                                     MD048346
     D SVALK2          S             20                                                     MD048346
     D SVAL2           S            200                                                     MD048346
     D SVALK3          S             20                                                     MD048346
     D SVAL3           S            200                                                     MD048346
     D SVALK4          S             20                                                     MD048346
     D SVAL4           S            200                                                     MD048346
     D SVALK5          S             20                                                     MD048346
     D SVAL5           S            200                                                     MD048346
     D SVALK6          S             20                                                     MD048346
     D SVAL6           S            200                                                     MD048346
     D SVALK7          S             20                                                     MD048346
     D SVAL7           S            200                                                     MD048346
     D SVALK8          S             20                                                     MD048346
     D SVAL8           S            200                                                     MD048346
     D SVALK9          S             20                                                     MD048346
     D SVAL9           S            200                                                     MD048346
     D SVALK0          S             20                                                     MD048346
     D SVAL10          S            200                                                     MD048346
     D SVBRCA          S              3                                                     MD048346
                                                                                            MD048346
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
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Position pointer to the first record.
      *
     C     *LOVAL        SETLL     FXNETML1
      *
      ** Read pay schedule header record.
      *
     C                   READ      FXNETML1                               01
      *
      ** Repeat while valid record.
      *
     C                   DOW       EndOfFile = False

     C                   CLEAR                   NOSEXEDF                                   MD046325
     C                   IF        AMVALD > WControlDat AND AMRECI = 'C'
     C**********                   AND AMOURN <> *BLANKS                                    MD046325
      *
      ** Access nostro details
      *
     C                   EVAL      Evnos = 'N'                                              MD046325
     C**********         EVAL      PNonb = AMOURN                                           MD046325
     C                   EXSR      SRNost
      *
      ** Access currency details
      *
     C                   EVAL      PCyCd = AMCCYD
     C                   EXSR      SRCyCd
      *                                                                                     MD046325
      ** If nostro, generate projections.                                                   MD046325
      *                                                                                     MD046325
     C                   IF        Evnos = 'Y'                                              MD046325
      *
      ** Access Customer details
      *
     C                   MOVE      *BLANKS       PCnum
     C                   MOVE      A7CUST        PCnum
     C                   EXSR      SRCust
      *
      ** Access branch details
      *
     C                   MOVE      *BLANKS       PBrch                                     MD036589A
     C                   MOVE      A7BRCD        PBrch                                     MD036589A
     C                   EXSR      SRBrch
      *
      ** Access Country code details
      *
     C                   EXSR      SRCtry
      *
     C**********         CLEAR                   NOSEXEDF                                   MD046325
      *
      ** Map fields to event file
      *
     C                   EXSR      SRMapFld
      *
      ** Write record to Events file
      *
     C                   EXSR      SRWrite
     C                   ENDIF                                                              MD046325
      *                                                                                    MD036589A
      ** Generate also for neeting ICD account.                                            MD036589A
      *                                                                                    MD036589A
     C                   EXSR      SRNetICD                                                MD036589A
      *
     C                   ENDIF
      ** Read next pay schedule header record.
      *
     C                   READ      FXNETML1                               01

     C                   ENDDO
      *
      ** Update Events creation trailer file.
      *
     C                   EXSR      SRUpdTrl
      *
      ** Write audit report
      *
     C                   EXSR      SRAudit
      *
      ** Terminate program
      *
     C                   EVAL      *INLR = *ON

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMapFld - Map fields to CLS Events file                     *
      *                                                               *
      *****************************************************************
     C     SRMapFld      BEGSR
      *
      ** Record id.
     C                   EVAL      RECI = 'D'
      *
      ** Deal number
     C                   EVAL      DLNO = 999999
      *
      ** Customer number
     C                   EVAL      CNUM = A7CUST
      *
      ** Event type
     C                   IF        AMBSIN = 'B'
     C                   EVAL      ETYP = 'NTV1'
     C                   ELSE
     C                   EVAL      ETYP = 'NTV2'
     C                   ENDIF
      *
      ** Event date
     C                   EVAL      EDAT = AMVALD
      *
      ** Event amount
     C                   EVAL      EAMT = AMDBUY
      *
      ** Event currency
     C                   EVAL      ECCY = AMCCYD
      *
      ** Event Sort sequence
     C                   EVAL      ECSS = A6SSNB
      *
      ** Deal type
     C                   EVAL      DTYP = 'NT'
      *
      ** Deal subtype
     C                   EVAL      DLST = *BLANKS
      *
      ** Branch code
     C                   EVAL      BRCA = A7BRCD
      *
      ** Exchange Rate
     C                   Z-ADD     1             EXRT
      *
      ** Negative interest indicator
     C                   EVAL      NGII = *BLANKS
      *
      ** Notice days
     C                   EVAL      NOTD = 0
      *
      ** Other date, amount currency
     C                   EVAL      OTHD = 0
     C                   EVAL      OTHA = 0
     C                   EVAL      OTHC = *BLANKS
     C                   MOVEL     AMNETR        W7
     C                   MOVE      AMNETR        W19
     C                   IF        AMCCYD <> AMCCY2
     C                   EVAL      WCCY = AMCCY2
     C                   ELSE
     C                   EVAL      WCCY = AMCCY1
     C                   ENDIF
     C     WNETR         CHAIN     FXNETML3                           41
     C                   IF        *IN41 = '0'
     C                   EVAL      OTHD = B_AMVALD
     C                   EVAL      OTHA = B_AMDBUY
     C                   EVAL      OTHC = B_AMCCYD
     C                   ENDIF
      *
      ** Dealt base ccy equivalent of event amount
     C                   EVAL      WCDP = A6NBDP
     C                   EVAL      WMDI = A6MDIN
     C                   EVAL      WBCXR = A6SPRT
     C                   EVAL      WERLC = A6ERLC
     C                   EVAL      PCyCd = BJCYCD
     C                   EXSR      SrCyCd
      *
     C                   IF        ECCY <> BJCYCD
     C                   EVAL      N = WCDP - A6NBDP
     C                   EVAL      N = N + 4
     C                   IF        WMDI = 'M'
     C                   EVAL      WRK159 = WBCXR/POWER(N)
     C                   EVAL      DBCE = EAMT * WRK159
     C                   ELSE
     C                   EVAL      WRK159 = WBCXR * POWER(N)
     C                   EVAL      DBCE = EAMT/WRK159
     C                   ENDIF
     C                   EVAL      BCEQ = DBCE
     C                   ELSE
     C                   Z-ADD     EAMT          DBCE
     C                   Z-ADD     EAMT          BCEQ
     C                   ENDIF
     C                   EVAL      DBCR = WBCXR
      *
      ** Determine Spot Limit ccy equivalent of event amount
     C                   IF        ECCY <> BNCYCD
     C                   EVAL      PCyCd = BNCYCD
     C                   EXSR      SrCyCd
     C                   EVAL      N = WCDP - A6NBDP + 4
     C                   IF        WMDI = 'M'
     C                   EVAL      WRK159 = WERLC/POWER(N)
     C                   EVAL      LCEQ = EAMT * WRK159
     C                   ELSE
     C                   EVAL      WRK159 = WERLC * POWER(N)
     C                   EVAL      LCEQ = EAMT/WRK159
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     EAMT          LCEQ
     C                   ENDIF
      *
      ** Settlement type
     C**********         EVAL      SETP = AMSETM                                            MD046325
     C                   EVAL      SETP = WSetm                                             MD046325
      *
      ** OSAC1
     C**********         EVAL      OSAC1 = AMOURN                                           MD046325
     C                   EVAL      OSAC1 = Netnos                                           MD046325
      *
     C                   MOVEL     AMNTNO        OSACQQ
      *
      ** Their settlement nostro
     C                   EVAL      TSEN = *BLANKS
      *
     C                   EVAL      ZZ001 = *BLANKS
      *
      ** Counter party confirmed ind.
     C                   EVAL      CPCI = *BLANKS
      *
      ** Broker confirmed indicator
     C                   EVAL      BRCI = *BLANKS
      *
      ** Full instruction present indicator
     C                   EVAL      FIPI = 'Y'
      *
      ** Incoming/outgoing indicator
     C                   IF        AMBSIN = 'B'
     C                   EVAL      INOI = 'I'
     C                   ELSE
     C                   EVAL      INOI = 'O'
     C                   ENDIF
      *
      ** Facility type indicator
     C                   EVAL      FCTI = 'N'
      *
      ** Rollover indicator
     C                   EVAL      RLVI = 'N'
      *
      ** Parent Customer Number
     C                   EVAL      CPAR = BBPCNB
      *
      ** Parent Indicator
     C                   IF        BBPAIN = 'P'
     C                   Z-ADD     1             PARI
     C                   ELSE
     C                   Z-ADD     0             PARI
     C                   ENDIF
      *
      ** Customer Report Name
     C                   EVAL      CRNM = BBCRNM
      *
      ** Customer Report Town
     C                   EVAL      CTWN = BBCRTN
      *
      ** Customer Alpha Sort key
     C                   EVAL      CASK = BBCASC
      *
      ** Country of citizenship                                                            MD036589A
     C                   EVAL      CCTZ = BBCNCZ                                           MD036589A
      *                                                                                    MD036589A
      ** Country of location                                                               MD036589A
     C                   EVAL      CLOC = BBCOLC                                           MD036589A
      *                                                                                    MD036589A
      ** Region Code                                                                       MD036589A
     C                   EVAL      REGC = A4RGCD                                           MD036589A
      *
      ** Access Customer details for Parent if not blank for Parent's
      ** report name, town and alpha sort key
      *
     C                   EVAL      PRNM = *BLANKS
     C                   EVAL      PTWN = *BLANKS
     C                   EVAL      PASK = *BLANKS
     C                   IF        BBPCNB <> *BLANKS
     c                   MOVE      *BLANKS       PCnum
     C                   MOVE      BBPCNB        PCnum
     C                   EXSR      SrCust
     C                   EVAL      PRNM = BBCRNM
     C                   EVAL      PTWN = BBCRTN
     C                   EVAL      PASK = BBCASC
     C                   ENDIF
      *
      ***Country*of*citizenship****************************************                    MD036589A
     C**********         EVAL      CCTZ = BBCNCZ                                           MD036589A
      *****************************************************************                    MD036589A
      ***Country*of*location*******************************************                    MD036589A
     C**********         EVAL      CLOC = BBCOLC                                           MD036589A
      *****************************************************************                    MD036589A
      ***Region*Code***************************************************                    MD036589A
     C**********         EVAL      REGC = A4RGCD                                           MD036589A
      ** Deal amendment sequence no.
     C                   EVAL      DASN = 0
      *
      ** Federal Funds Value date
     C                   EVAL      FFVD = AMVALD
      *
      ** Federal funds indicator
     C                   EVAL      FFIN = *BLANKS
      *
      ** Facility type
     C                   EVAL      FACT = 0
      *
      ** Facility number
     C                   EVAL      FCNO = 0
      *
      ** For account of
     C                   EVAL      FACO = *BLANKS
      *
      ** Special instructions
     C                   EVAL      SPI  = *BLANKS
      *
      ** Counterparty Customer
     C                   MOVE      A7CUST        CPCN
      *
      ** 1st/2nd leg swap indicator
     C                   EVAL      FSLI = 0
      *
      ** Internal counterparty int rt
     C                   EVAL      ICIR = 0
      *
      ** Internal contract account
     C                   EVAL      ICAM = 0
      *
      ** Rolled over by deal amount
     C                   EVAL      RBDA = 0
      *
     C                   EVAL      OCFF = *BLANKS
     C                   MOVEL     AMNETR        ZZ023
      *
      ** Taxable indicator
     C                   EVAL      TAXI = *BLANKS
      *
     C                   EVAL      OSAC2 = *BLANKS
      *
      ** Deal Class
     C                   EVAL      CLAS = *BLANKS
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write record to Events file.                       *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
      *
      ** Keep running total of records generated for trailer.
      *
     C                   EVAL      WGenRec = WGenRec + 1
      *
      ** Hash total
      *
     C                   EVAL      WAmt = 0
     C                   EVAL      WAmt = EAMT / 1000
     C                   EVAL      WWAmt = WAmt

     C                   Z-ADD     WInteger      WWTotI
     C                   Z-ADD     WDecimal      WWTotD

     C                   IF        WWAmt < 0
     C                   Z-SUB     WWAmt         WWAmt
     C                   ENDIF

     C                   Z-ADD     WWAmt         WWAmtI
     C                   MOVE      WWAmt         WWAmtD
     C                   ADD       WWAmtD        WWTotD

     C                   IF        WWTotD < WWAmtD
     C                   ADD       1             WWTotI
     C                   ENDIF

     C                   ADD       WWAmtI        WWTotI
     C                   Z-ADD     WWTotI        WInteger
     C                   Z-ADD     WWTotD        WDecimal
      *
      ** Write record to Events creation detail file.
      *
     C                   WRITE     NOSEXEDF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdTrl - Update Events creation file - Trailer.            *
      *                                                               *
      *****************************************************************
     C     SRUpdTrl      BEGSR
      *
      ** Update trailer record if found, otherwise write record.
      *
     C     1             CHAIN     NOSEXZZ                            02

     C                   IF        NoRecFnd = False
     C                   EVAL      NORE = NORE + WGenRec
     C                   EVAL      HRWN  = HRWN  + WInteger
     C                   EVAL      WDecSum = HRDC + WDecimal
      *
      ** If decimal exceeds 1000, carry 1 to integer. Amount in
      ** excess of 1000 is moved back on decimal.
      *
     C                   IF        WDecSum > 1000
     C                   EVAL      HRDC = WDecSum - 1000
     C                   EVAL      HRWN = HRWN + 1
     C                   ELSE
     C                   Z-ADD     WDecSum       HRDC
     C                   ENDIF
      *
     C                   UPDATE    NOSEXZZF
     C                   ELSE
     C                   EVAL      RECI = 'T'
     C                   Z-ADD     WGenRec       NORE
     C                   ADD       2             NORE
     C                   Z-ADD     WInteger      HRWN
     C                   Z-ADD     WDecimal      HRDC
     C                   WRITE     NOSEXZZF
     C                   EVAL      RECI = 'A'
     C                   WRITE     NOSEXECF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNost - Access nostro details                               *
      *                                                               *
      *****************************************************************
     C     SRNost        BEGSR
      *
     C                   IF        AMSETM = 1 or AMSETM = 2                                 MD046325
     C                             or AMSETM = 7 or AMSETM = 8                              MD046325
     C                             or AMSETM = 12                                           MD046325
     C                   EVAL      PNonb = AMOURN                                           MD046325
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PCust
     C                   PARM      AMCCYD        PCyCd
     C                   PARM      *BLANKS       PAccn
     C                   PARM      *BLANKS       PAcSn
     C                   PARM                    PNoNb
     C                   PARM      *BLANKS       PBrCd
     C                   PARM      *BLANKS       PCsSn
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY
     C**********         IF        PRtCd <> *BLANKS                                         MD046325
     C******LOCK         IN        LDA                                                      MD046325
     C**********         EVAL      DBKEY = PCyCd + PNoNb                                    MD046325
     C**********         EVAL      DBFILE = 'SDNOSTPD'                                      MD046325
     C**********         EVAL      DBASE = 005                                              MD046325
     C**********         OUT       LDA                                                      MD046325
     C**********         EXSR      SRDBErr                                                  MD046325
     C                   IF        PRtCd = *BLANKS                                          MD046325
     C                   EVAL      Evnos = 'Y'                                              MD046325
     C                   EVAL      Netnos = A7NONB                                          MD046325
     C                   EVAL      WSetm = AMSETM                                           MD046325
     C                   ENDIF                                                              MD046325
     C                   ENDIF                                                              MD046325
      *                                                                                     MD046325
     C                   IF        AMSETM = 5 or AMSETM = 9                                 MD046325
     C                   EVAL      OSAcNo = AMOURN                                          MD046325
     C                   CALL      'AONOSTR0'                                               MD046325
     C                   PARM      *BLANKS       PRtCd                                      MD046325
     C                   PARM      '*KEY   '     POptn                                      MD046325
     C                   PARM      KCust         PCust                                      MD046325
     C                   PARM      AMCCYD        PCyCd                                      MD046325
     C                   PARM      KAccd         PAccn                                      MD046325
     C                   PARM      KAcsq         PAcSn                                      MD046325
     C                   PARM      *BLANKS       PNoNb                                      MD046325
     C                   PARM      AMONOB        PBrCd                                      MD046325
     C                   PARM      *BLANKS       PCsSn                                      MD046325
     C                   PARM      *BLANKS       PPNOI                                      MD046325
     C     SDNOST        PARM      SDNOST        DSFDY                                      MD046325
     C                   IF        PRtCd = *BLANKS                                          MD046325
     C                   EVAL      Evnos = 'Y'                                              MD046325
     C                   EVAL      Netnos = A7NONB                                          MD046325
     C                   EVAL      WSetm = 8                                                MD046325
     C                   ENDIF                                                              MD046325
     C                   ENDIF                                                              MD046325
      *                                                                                     MD046325
     C                   IF        AMSETM = 4 or AMSETM = 14                                MD046325
     C                   EVAL      WAcnt = %SUBST(AMOURN:1:10)                              MD046325
     C                   CALL      'AOACCTR0'                                               MD046325
     C                   PARM      *BLANKS       @RTCD                                      MD046325
     C                   PARM      '*KEY   '     @OPTN                                      MD046325
     C                   PARM      WAcnt         @RETL            10                        MD046325
     C                   PARM      *BLANKS       @CNUM             6                        MD046325
     C                   PARM      *BLANKS       @CUCD             3                        MD046325
     C                   PARM      *BLANKS       @ACCD            10                        MD046325
     C                   PARM      *BLANKS       @ACSQ             2                        MD046325
     C                   PARM      *BLANKS       @BRCA             3                        MD046325
     C     SDACCT        PARM      SDACCT        DSSDY                                      MD046325
     C                   IF        @RTCD = *BLANKS                                          MD046325
     C                   MOVEL     AACOD         WAcCn                                      MD046325
     C                   MOVEL     AACSQ         WAcSn                                      MD046325
     C                   CALL      'AONOSTR0'                                               MD046325
     C                   PARM      *BLANKS       PRtCd                                      MD046325
     C                   PARM      '*KEY   '     POptn                                      MD046325
     C                   PARM      ACNUM         PCust                                      MD046325
     C                   PARM      ACCY          PCyCd                                      MD046325
     C                   PARM                    WAcCn                                      MD046325
     C                   PARM                    WAcSn                                      MD046325
     C                   PARM      *BLANKS       PNoNb                                      MD046325
     C                   PARM      ABRCA         PBrCd                                      MD046325
     C                   PARM      *BLANKS       PCsSn                                      MD046325
     C                   PARM      *BLANKS       PPNOI                                      MD046325
     C     SDNOST        PARM      SDNOST        DSFDY                                      MD046325
     C                   IF        PRtCd = *BLANKS                                          MD046325
     C                   EVAL      Evnos = 'Y'                                              MD046325
     C                   EVAL      Netnos = A7NONB                                          MD046325
     C                   EVAL      WSetm = 8                                                MD046325
     C                   ENDIF                                                              MD046325
     C                   ENDIF                                                              MD046325
     C                   ENDIF                                                              MD046325
      *                                                                                     MD046325
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCyCd - Access Currency code details                        *
      *                                                               *
      *****************************************************************
     C     SRCyCd        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCyCd
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRtCd <> *BLANKS

     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCyCd
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EXSR      SRDBErr

     C                   ENDIF
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCust - Access Customer details                             *
      *                                                               *
      *****************************************************************
     C     SRCust        BEGSR
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCnum
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        PRtCd <> *BLANKS

     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCnum
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 007
     C                   OUT       LDA
     C                   EXSR      SRDBErr

     C                   ENDIF
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBrch - Access Branch Code details                          *
      *                                                               *
      *****************************************************************
     C     SRBrch        BEGSR
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C**********         PARM      A7BRCD        PBrch                                     MD036589A
     C                   PARM                    PBrch                                     MD036589A
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PBrch
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 008
     C                   OUT       LDA
     C                   EXSR      SRDBErr

     C                   ENDIF
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCtry - Access Country code details                         *
      *                                                               *
      *****************************************************************
     C     SRCtry        BEGSR
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BBCNCZ        PCnCd
     C     SDCTRY        PARM      SDCTRY        DSFDY

     C                   IF        PRtCd <> *BLANKS

     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCnCd
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBASE = 009
     C                   OUT       LDA
     C                   EXSR      SRDBErr

     C                   ENDIF
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Generate audit report processing.                  *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR

     C                   IF        WGenRec <> 0
     C                   Z-ADD     WGenRec       RCOUNT
     C                   Z-ADD     WInteger      RINTEGER
     C                   Z-ADD     WDecimal      RDECIMAL
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     HEADAU
     C                   WRITE     NODTLS
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                               MD036589A
      *****************************************************************                    MD036589A
      *                                                               *                    MD036589A
      *  SRNetICD - Generate for netting ICD                          *                    MD036589A
      *                                                               *                    MD036589A
      *****************************************************************                    MD036589A
     C     SRNetICD      BEGSR                                                             MD036589A
      *
      ** Setup FX Netting Branch for SRChkAcc
      *                                                                                     MD048346
     C     SVBRCA        IFNE      *BLANKS                                                  MD048346
     C                   EVAL      AMBRCA = SVBRCA                                          MD048346
     C                   ELSE                                                               MD048346
     C     ABRCA         IFNE      *BLANKS                                                  MD048346
     C                   EVAL      AMBRCA = ABRCA                                           MD048346
     C                   ELSE                                                               MD048346
     C     BBBRCD        IFNE      *BLANKS                                                  MD048346
     C                   EVAL      AMBRCA = BBBRCD                                          MD048346
     C                   ENDIF                                                              MD048346
     C                   ENDIF                                                              MD048346
     C                   ENDIF                                                              MD048346
      *                                                                                    MD036589A
      ** Check first if we should project for netting ICD account.                         MD036589A
      *                                                                                    MD036589A
     C                   EXSR      SRChkAcc                                                MD036589A
      *                                                                                    MD036589A
      ** If we should project..                                                            MD036589A
      *                                                                                    MD036589A
     C                   If        Vnet = 'Y'                                              MD036589A
      *                                                                                    MD036589A
      ** Set up the fields.                                                                MD036589A
      *                                                                                    MD036589A
     C                   MOVE      *BLANKS       PCnum                                      MD046325
     C                   MOVE      A7CUST        PCnum                                      MD046325
     C                   EXSR      SRCust                                                   MD046325
     C                   MOVE      *BLANKS       PBrch                                      MD046325
     C                   MOVE      A7BRCD        PBrch                                      MD046325
     C                   EXSR      SRBrch                                                   MD046325
     C                   EXSR      SRCtry                                                   MD046325
     C                   EVAL      RECI = 'D'                                               MD046325
     C                   EVAL      DLNO = 999999                                            MD046325
      *                                                                                     MD046325
     C                   IF        AMBSIN = 'B'                                             MD046325
     C                   EVAL      ETYP = 'NTV1'                                            MD046325
     C                   ELSE                                                               MD046325
     C                   EVAL      ETYP = 'NTV2'                                            MD046325
     C                   ENDIF                                                              MD046325
      *                                                                                     MD046325
     C                   EVAL      EDAT = AMVALD                                            MD046325
     C                   EVAL      EAMT = AMDBUY                                            MD046325
     C                   EVAL      ECCY = AMCCYD                                            MD046325
     C                   EVAL      ECSS = A6SSNB                                            MD046325
     C                   EVAL      DTYP = 'NT'                                              MD046325
     C                   EVAL      DLST = *BLANKS                                           MD046325
     C                   Z-ADD     1             EXRT                                       MD046325
     C                   EVAL      NGII = *BLANKS                                           MD046325
     C                   EVAL      NOTD = 0                                                 MD046325
     C                   EVAL      OTHD = 0                                                 MD046325
     C                   EVAL      OTHA = 0                                                 MD046325
     C                   EVAL      OTHC = *BLANKS                                           MD046325
     C                   MOVEL     AMNETR        W7                                         MD046325
     C                   MOVE      AMNETR        W19                                        MD046325
      *                                                                                     MD046325
     C                   IF        AMCCYD <> AMCCY2                                         MD046325
     C                   EVAL      WCCY = AMCCY2                                            MD046325
     C                   ELSE                                                               MD046325
     C                   EVAL      WCCY = AMCCY1                                            MD046325
     C                   ENDIF                                                              MD046325
      *                                                                                     MD046325
     C     WNETR         CHAIN     FXNETML3                           41                    MD046325
     C                   IF        *IN41 = '0'                                              MD046325
     C                   EVAL      OTHD = B_AMVALD                                          MD046325
     C                   EVAL      OTHA = B_AMDBUY                                          MD046325
     C                   EVAL      OTHC = B_AMCCYD                                          MD046325
     C                   ENDIF                                                              MD046325
      *                                                                                     MD046325
     C                   EVAL      WCDP = A6NBDP                                            MD046325
     C                   EVAL      WMDI = A6MDIN                                            MD046325
     C                   EVAL      WBCXR = A6SPRT                                           MD046325
     C                   EVAL      WERLC = A6ERLC                                           MD046325
     C                   EVAL      PCyCd = BJCYCD                                           MD046325
     C                   EXSR      SrCyCd                                                   MD046325
      *                                                                                     MD046325
     C                   IF        ECCY <> BJCYCD                                           MD046325
     C                   EVAL      N = WCDP - A6NBDP                                        MD046325
     C                   EVAL      N = N + 4                                                MD046325
      *                                                                                     MD046325
     C                   IF        WMDI = 'M'                                               MD046325
     C                   EVAL      WRK159 = WBCXR/POWER(N)                                  MD046325
     C                   EVAL      DBCE = EAMT * WRK159                                     MD046325
     C                   ELSE                                                               MD046325
     C                   EVAL      WRK159 = WBCXR * POWER(N)                                MD046325
     C                   EVAL      DBCE = EAMT/WRK159                                       MD046325
     C                   ENDIF                                                              MD046325
      *                                                                                     MD046325
     C                   EVAL      BCEQ = DBCE                                              MD046325
     C                   ELSE                                                               MD046325
     C                   Z-ADD     EAMT          DBCE                                       MD046325
     C                   Z-ADD     EAMT          BCEQ                                       MD046325
     C                   ENDIF                                                              MD046325
      *                                                                                     MD046325
     C                   EVAL      DBCR = WBCXR                                             MD046325
     C                   IF        ECCY <> BNCYCD                                           MD046325
     C                   EVAL      PCyCd = BNCYCD                                           MD046325
     C                   EXSR      SrCyCd                                                   MD046325
     C                   EVAL      N = WCDP - A6NBDP + 4                                    MD046325
      *                                                                                     MD046325
     C                   IF        WMDI = 'M'                                               MD046325
     C                   EVAL      WRK159 = WERLC/POWER(N)                                  MD046325
     C                   EVAL      LCEQ = EAMT * WRK159                                     MD046325
     C                   ELSE                                                               MD046325
     C                   EVAL      WRK159 = WERLC * POWER(N)                                MD046325
     C                   EVAL      LCEQ = EAMT/WRK159                                       MD046325
     C                   ENDIF                                                              MD046325
     C                   ELSE                                                               MD046325
     C                   Z-ADD     EAMT          LCEQ                                       MD046325
     C                   ENDIF                                                              MD046325
      *                                                                                     MD046325
     C                   EVAL      TSEN = *BLANKS                                           MD046325
     C                   EVAL      ZZ001 = *BLANKS                                          MD046325
     C                   EVAL      CPCI = *BLANKS                                           MD046325
     C                   EVAL      BRCI = *BLANKS                                           MD046325
     C                   EVAL      FIPI = 'Y'                                               MD046325
      *                                                                                     MD046325
     C                   IF        AMBSIN = 'B'                                             MD046325
     C                   EVAL      INOI = 'O'                                               MD046325
     C                   ELSE                                                               MD046325
     C                   EVAL      INOI = 'I'                                               MD046325
     C                   ENDIF                                                              MD046325
      *                                                                                     MD046325
     C                   EVAL      FCTI = 'N'                                               MD046325
     C                   EVAL      RLVI = 'N'                                               MD046325
     C                   EVAL      DASN = 0                                                 MD046325
     C                   EVAL      FFVD = AMVALD                                            MD046325
     C                   EVAL      FFIN = *BLANKS                                           MD046325
     C                   EVAL      FACT = 0                                                 MD046325
     C                   EVAL      FCNO = 0                                                 MD046325
     C                   EVAL      FACO = *BLANKS                                           MD046325
     C                   EVAL      SPI  = *BLANKS                                           MD046325
     C                   MOVE      A7CUST        CPCN                                       MD046325
     C                   EVAL      FSLI = 0                                                 MD046325
     C                   EVAL      ICIR = 0                                                 MD046325
     C                   EVAL      ICAM = 0                                                 MD046325
     C                   EVAL      RBDA = 0                                                 MD046325
     C                   EVAL      OCFF = *BLANKS                                           MD046325
     C                   MOVEL     AMNETR        ZZ023                                      MD046325
     C                   EVAL      TAXI = *BLANKS                                           MD046325
     C                   EVAL      OSAC2 = *BLANKS                                          MD046325
     C                   EVAL      CLAS = *BLANKS                                           MD046325
     C                   EVAL      CNUM = A8BICN                                           MD036589A
     C                   EVAL      BRCA = AMBRCA                                            MD045382
     C                   EVAL      SETP = 08                                               MD036589A
     C                   EVAL      OSAC1 = Netnos                                          MD036589A
     C                   EVAL      OSACQQ = *Blanks                                        MD036589A
     C**********         IF        INOI = 'I'                                     MD036589A MD046325
     C**********         EVAL      INOI = 'O'                                     MD036589A MD046325
     C**********         ELSE                                                     MD036589A MD046325
     C**********         EVAL      INOI = 'I'                                     MD036589A MD046325
     C**********         ENDIF                                                    MD036589A MD046325
      *                                                                                    MD036589A
     C                   MOVE      *BLANKS       PCnum                                     MD036589A
     C                   MOVE      A8BICN        PCnum                                     MD036589A
     C                   EXSR      SRCust                                                  MD036589A
     C                   EVAL      CPAR = BBPCNB                                           MD036589A
     C                   IF        BBPAIN = 'P'                                            MD036589A
     C                   Z-ADD     1             PARI                                      MD036589A
     C                   ELSE                                                              MD036589A
     C                   Z-ADD     0             PARI                                      MD036589A
     C                   ENDIF                                                             MD036589A
     C                   EVAL      CRNM = BBCRNM                                           MD036589A
     C                   EVAL      CTWN = BBCRTN                                           MD036589A
     C                   EVAL      CASK = BBCASC                                           MD036589A
     C                   EVAL      CCTZ = BBCNCZ                                           MD036589A
     C                   EVAL      CLOC = BBCOLC                                           MD036589A
     C                   EXSR      SRCtry                                                  MD036589A
     C                   EVAL      REGC = A4RGCD                                           MD036589A
      *                                                                                    MD036589A
     C                   EVAL      PRNM = *Blanks                                          MD036589A
     C                   EVAL      PTWN = *Blanks                                          MD036589A
     C                   EVAL      PASK = *Blanks                                          MD036589A
     C                   IF        BBPCNB <> *BLANKS                                       MD036589A
     c                   MOVE      *BLANKS       PCnum                                     MD036589A
     C                   MOVE      BBPCNB        PCnum                                     MD036589A
     C                   EXSR      SrCust                                                  MD036589A
     C                   EVAL      PRNM = BBCRNM                                           MD036589A
     C                   EVAL      PTWN = BBCRTN                                           MD036589A
     C                   EVAL      PASK = BBCASC                                           MD036589A
     C                   ENDIF                                                             MD036589A
      *                                                                                    MD036589A
     C                   EXSR      SRWrite                                                 MD036589A
      *                                                                                    MD036589A
     C                   ENDIF                                                             MD036589A
      *                                                                                    MD036589A
     C                   ENDSR                                                             MD036589A
      *                                                                                    MD036589A
      *****************************************************************                    MD036589A
      /EJECT                                                                               MD036589A
      *****************************************************************                    MD036589A
      *                                                               *                    MD036589A
      *  SRChkAcc - Check netting ICD account.                        *                    MD036589A
      *                                                               *                    MD036589A
      *****************************************************************                    MD036589A
     C     SRChkAcc      BEGSR                                                             MD036589A
      *                                                                                    MD036589A
      ** Check via nostro.                                                                 MD036589A
      *                                                                                    MD036589A
     C                   Eval      Vnet = 'N'                                              MD036589A
     C                   Eval      Netnos = *Blanks                                        MD036589A
      *                                                                                    MD036589A
      ** Get first customer details from branch.                                           MD036589A
      *                                                                                    MD036589A
     C                   MOVE      *BLANKS       PBrch                                     MD036589A
     C                   MOVE      AMBRCA        PBrch                                     MD036589A
     C                   EXSR      SRBrch                                                  MD036589A
      *                                                                                    MD036589A
     C                   CALL      'AONOSTR0'                                              MD036589A
     C                   PARM      *BLANKS       PRtCd                                     MD036589A
     C                   PARM      '*KEY   '     POptn                                     MD036589A
     C                   PARM      A8BICN        PCust                                     MD036589A
     C**********         PARM      ECCY          PCyCd                            MD036589A MD046325
     C                   PARM      AMCCYD        PCyCd                                      MD046325
     C                   PARM      BNNEAC        PAccn                                     MD036589A
     C                   PARM      '01'          PAcSn                                     MD036589A
     C                   PARM                    PNoNb                                     MD036589A
     C                   PARM      PBrch         PBrCd                                     MD036589A
     C                   PARM      *BLANKS       PCsSn                                     MD036589A
     C                   PARM      *BLANKS       PPNOI                                     MD036589A
     C     SDNOST        PARM      SDNOST        DSFDY                                     MD036589A
                                                                                           MD036589A
     C                   IF        PRtCd = *BLANKS                                         MD036589A
     C                   Eval      Vnet = 'Y'                                              MD036589A
     C                   Eval      Netnos = A7NONB                                         MD036589A
     C                   ENDIF                                                             MD036589A
      *                                                                                    MD036589A
     C                   ENDSR                                                             MD036589A
      *                                                                                    MD036589A
      *****************************************************************                    MD036589A
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

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
      ** Access bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF
      *
      ** Access general ledger ICD details.
      *
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Database error.
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF
      *
      ** Access Dealing Details
      *
     C                   CALL      'AODEALR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
      ** Database Error
      *
     C     PRtcd         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF
      *
      ** Setup control date
      *
     C                   EVAL      WControlDat = BJDNWD - 1
     C                   IF        BKANWD = '2'
     C                   IF        BKAPDT <= WControlDat
     C                   Z-ADD     BKAPDT        WControlDat
     C                   ELSE
     C                   Z-ADD     BJRDNB        WControlDat
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD048346
      ** Access system value                                                                MD048346
      *                                                                                     MD048346
     C                   EVAL      SVALK1 = 'FXnetBranch'                                   MD048346
      * Call Access object:                                                                 MD048346
     C                   CALL      'AOSVALR0'                                               MD048346
     C                   PARM      *BLANKS       PRtCd                                      MD048346
     C                   PARM                    SVALK1                                     MD048346
     C                   PARM                    SVAL1                                      MD048346
     C                   PARM                    SVALK2                                     MD048346
     C                   PARM                    SVAL2                                      MD048346
     C                   PARM                    SVALK3                                     MD048346
     C                   PARM                    SVAL3                                      MD048346
     C                   PARM                    SVALK4                                     MD048346
     C                   PARM                    SVAL4                                      MD048346
     C                   PARM                    SVALK5                                     MD048346
     C                   PARM                    SVAL5                                      MD048346
     C                   PARM                    SVALK6                                     MD048346
     C                   PARM                    SVAL6                                      MD048346
     C                   PARM                    SVALK7                                     MD048346
     C                   PARM                    SVAL7                                      MD048346
     C                   PARM                    SVALK8                                     MD048346
     C                   PARM                    SVAL8                                      MD048346
     C                   PARM                    SVALK9                                     MD048346
     C                   PARM                    SVAL9                                      MD048346
     C                   PARM                    SVALK0                                     MD048346
     C                   PARM                    SVAL10                                     MD048346
                                                                                            MD048346
     C                   IF        PrtCd = *BLANKS                                          MD048346
     C                   MOVEL     SVAL1         SVBRCA                                     MD048346
     C                   ENDIF                                                              MD048346
      *                                                                                     MD048346
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDBErr - Database error processing                          *
      *                                                               *
      *****************************************************************
     C     SRDBErr       BEGSR

     C                   WRITE     HEADAU
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   WRITE     DBERROR

     C                   EXSR      *PSSR

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
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2016
**   POWER - ARRAY OF POWERS OF 10 FOR CURRENCY CONVERSIONS
0000001
0000010
0000100
0001000
0010000
0100000
1000000
