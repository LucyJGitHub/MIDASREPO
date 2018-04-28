     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Historic Market Data Collection Program')     *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000019 - Historic Market Data Collection Program           *
      *                                                               *
      *  Called By: ASC00019 - Historic Market Data Collection (CLP)  *
      *                                                               *
      *  Function:  This module collects details from all NPV files   *
      *             and extracts them in new files for historic       *
      *             detail reporting purposes.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CPK024             Date 13Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 227924             Date 11May04               *
      *                 227695             Date 17Jun04               *
      *                 226170             Date 05Apr04               *
      *                 225342             Date 25Mar04               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPK024 - Rename field PEXI for file CLOAN                    *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  227924 - Base date initialised to current collection date at *
      *           start.                                              *
      *  227695 - For MM deals, check liquidity premium instead of    *
      *           base rate and spread rate to determine whether to   *
      *           use all-in-rate or net treasury rate file.          *
      *  226170 - UP/UL amounts for RX deals are already in base ccy. *
      *           Do not convert.                                     *
      *  225342 - Next collection date should be set correctly after  *
      *           the first collection date.                          *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR     - Initialization Processing                        *
      * SRDLAS     - Subroutine that identifies deal type of the      *
      *              linkage transaction.                             *
      * SRMMAS     - Retrieve details from money market NPV files and *
      *              extract them to Dealing collection file.         *
      * SRRSAS     - Retrieve details from single rates NPV file and  *
      *              extract them to Dealing collection file.         *
      * SRRXAS     - Retrieve details from cross rates NPV file and   *
      *              extract them to Dealing collection file.         *
      * SRFRAS     - Retrieve details from FRA NPV file and extract   *
      *              them to Dealing collection file.                 *
      * SRLEAS     - Retrieve details from Lending NPV file and       *
      *              extract them to Dealing collection file.         *
      * SRSEAS     - Retrieve details from Securities NPV file and    *
      *              extract them to Dealing collection file.         *
      * SRCONV     - Retrieve market value and converts them to base  *
      *              currency from different modules.                 *
      * SRChkHdgI  - Check Hedged Items if there is a need to chain   *
      *              the Base Rate version of the NPV files of the    *
      *              current derivative                               *
      * *PSSR      - Error processing                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FASHGLKL4  UF   E           K DISK    INFSR(*PSSR)
     ** Midas AS Hedge linkage file by next collectn date
 
     FSDHGSTL0  IF   E           K DISK    PREFIX(J) INFSR(*PSSR)
     ** Midas SD Hedge Strategy by Shortname Master File
 
     FASHTRNLB  IF   E           K DISK    RENAME(ASHTRND0:ASHTRNDX)
     F                                     PREFIX(X) INFSR(*PSSR)
     ** Midas AS Hedge Transaction File Update by Hedge ID/Indicator
 
     FASHTRNLE  IF   E           K DISK    INFSR(*PSSR)
     ** Midas AS Hedge Transaction File Update by Hedge ID
 
     FPRICM     IF   E           K DISK    INFSR(*PSSR)
     ** Midas SE Market Prices by Security Shortname and Value Date
 
     FCLOAN     IF   E           K DISK    IGNORE(CLOANZ1F) INFSR(*PSSR)
     ** Midas LE Loans File by Loan Number and Record Type
 
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(B2)
      ** Midas SE Book Position Headers
     FDLFRARL4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas DL FRA Rates - Ccy/BRAT/VDAT
 
     FSEMKVLL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Market Values Using Net-Treasury-Prices
 
     FLENPVLL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Revalued Customer Loans by Loan Number
 
     FIRNPVAL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas IR Revalued SIRS File
 
     FIRNPVBL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(IRNPVAD0:IRNPVBD0)
      ** Midas IR Revalued SIRS Using Base Rate
 
     FRXNPVAL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas IR Revalued CIRS File
 
     FRXNPVBL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RXNPVAD0:RXNPVBD0)
      ** Midas IR Revalued CIRS Using Base Rate
 
     FFRNPVAL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas IR Revalued FRA File
 
     FFRNPVLL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FRNPVAD0:FRNPVLD0)
      ** Midas IR Revalued FRA Using Net Treasury File
 
     FMMNPVLL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas MM Revalued Deals by Deal Number
 
     FSDYLDRL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas Yield Rates Master File Update Index by Yield Curve
      ** ,Yield Curve Currency and Yield Int Calc Method
 
     FDEALS     IF   E           K DISK    IGNORE(DEALSDFF) INFSR(*PSSR)
      ** Midas DL Deals file
     FDEALSL    IF   E           K DISK    IGNORE(DEALSDFF) INFSR(*PSSR)
     F                                     RENAME(DEALSDAF:DEALSDAX)
     F                                     RENAME(DEALSDBF:DEALSDBX)
     F                                     RENAME(DEALSDCF:DEALSDCX)
     F                                     RENAME(DEALSDDF:DEALSDDX)
     F                                     RENAME(DEALSDEF:DEALSDEX)
     F                                     RENAME(DEALSDGF:DEALSDGX)
     F                                     PREFIX(Z)
      ** Midas DL Deals file
 
     FASDLHML2  UF   E           K DISK    RENAME(ASDLHMD0:ASDLHMDX)
     F                                     PREFIX(D) INFSR(*PSSR)
      ** Midas AS Dealing Historic Market Data File
      ** by Deal number and Value date - LIVE
 
     FASLEHML2  UF   E           K DISK    RENAME(ASLEHMD0:ASLEHMDX)
     F                                     PREFIX(L) INFSR(*PSSR)
      ** Midas AS Lending Historic Market Data File
      ** by Loan number and value date - LIVE
 
     FASSEHML0  UF   E           K DISK    RENAME(ASSEHMD0:ASSEHMDX)
     F                                     PREFIX(S) INFSR(*PSSR)
      ** Midas AS Securities Historic Market Data File
      ** by Security shortname and Value date - LIVE
 
     FASDLHMPD  UF A E             DISK
      ** Midas AS Dealing Historic Market Data File
 
     FASLEHMPD  UF A E             DISK
      ** Midas AS Lending Historic Market Data File
 
     FASSEHMPD  UF A E             DISK
      ** Midas AS Security Positions Hist Market Data File
 
     ******************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
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
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRun            S              1
     D WKBase          S              1
     D KHedgeIn        S              1
     D PRetCode        S              7A
     D POption         S              7A
     D PCurr           S              3A
     D WToMdin         S              1A
     D WToNbdp         S              1  0
     D WToExcr         S             13  8
     D WFrAmnt         S             15  0
     D WFrNbdp         S              1  0
     D WFrCcy          S              3A
     D WMMUrpl         S             15  0
     D WIRUrpl         S             15  0
     D WLEUrpl         S             15  0
     D WSEUrpl         S             15  0
     D PZAmtCo         S             15  0
     D WKCycd          S              3
     D WkEvCtDt        S              5P 0
     D WBRTT           S              2  0
     D WINFD           S              5  0
     D WFXRT           S             11  7
 
      ** Parameters for ZFREQC
     D PRetCodeIn      S             10A
     D PNxtColDay      S              4A
     D PIncldTday      S              1A
     D PZFreq          S              1A
     D PZDayNo         S              5  0
     D PZCcy           S              3A
     D PZWday          S              3A
     D PZMday          S              2  0
     D PBJDFIN         S              1A
     D PBaseDate       S              5  0
 
      ** Parameters for ZCONVZ1
     D PZInAmt         S             15  0
     D PZExchR         S             13  8
     D PZMdin          S              1A
     D PZCcyFr         S              3A
     D PZCcyTo         S              3A
     D PZDecFr         S              1  0
     D PZDecTo         S              1  0
     D P#OutA          S             15  0
 
      ** Parameters for ZAINTPL
     D PZindat         S              5  0
     D PZibdat         S              5  0
     D PZifdat         S              5  0
     D PZinrat         S             13  9
     D PZifrat         S             13  9
     D PZibrat         S             13  9
 
      ** Keyflds for Yield rates file
     D KYLDC           S              5
     D KYCCY           S              3
     D KYICM           S              1
 
      ** Fields used to define Key List for Midas SE Revalued Security
      ** Positions File
     D KSEsesn         S             10A
     D KSEbrca         S              3A
     D KSEbokc         S              2A
     D KSEmkti         S              1A
     D KSEbhtv         S              1A
                                                                                CPK024
     ICLOANCLF                                                                  CPK024
     I              PEXI                        LPEXI                           CPK024
     ******************************************************************
      *****************************************************************
      *                                                               *
      *  SRMAIN    - Main processing subroutine.                      *
      *                                                               *
      *  Called by: None                                              *
      *                                                               *
      *  Calls: SRDLAS, SRSEAS, SRLEAS, SRINIT                        *
      *                                                               *
      *****************************************************************
 
     C     *LOVAL        SETLL     ASHGLKL4
     C                   READ      ASHGLKL4
 
     C                   DOW       NOT %EOF(ASHGLKL4)
      *
     C                   IF        FSNDTA <= WkEvCtDt  AND FSNDTA <> 0
     C     FSHEDI        SETLL     ASHTRNLE
     C     FSHEDI        READE     ASHTRNLE
 
     C                   DOW       NOT %EOF(ASHTRNLE)
 
     C     FSMOD         CASEQ     'DL'          SRDLAS
     C     FSMOD         CASEQ     'LE'          SRLEAS
     C     FSMOD         CASEQ     'SE'          SRSEAS
     C                   ENDCS
 
     C     FSHEDI        READE     ASHTRNLE
     C                   ENDDO
                                                                                              227924
     C                   IF        FSBDAT = 0                                                 227924
     C                   Z-ADD     FSNDTA        FSBDAT                                       227924
     C                   ENDIF                                                                227924
 
     C                   EVAL      PZFreq = FSDFRQ
     C                   EVAL      PZCcy = BJCYCD
     C                   EVAL      PZDayNo = FSBDAT
     C                   EVAL      PNXTCOLDAY = 'NEXT'
     C                   EVAL      PZMday = FSMNTH
     C                   EVAL      PBJDFIN = BJDFIN
     C                   EVAL      PZWDAY = FSWDAY
     C                   EVAL      PINCLDTDAY = 'N'
     C                   EVAL      PBASEDATE = FSBDAT
      *
     C**********         CALLB     'ZFREQC'                                                   225342
     C                   CALL      'ZFREQC'                                                   225342
     C                   PARM      *BLANKS       PRetCodeIn
     C                   PARM                    PNxtColDay
     C                   PARM                    PIncldTday
     C                   PARM                    PZFreq
     C                   PARM                    PZDayNo
     C                   PARM                    PZCcy
     C                   PARM                    PZWday
     C                   PARM                    PZMday
     C                   PARM                    PBJDFIN
     C                   PARM                    PBaseDate
      *
     C                   EVAL      FSNDTA = PZDayNo
     C                   EVAL      FSBDAT = PBASEDATE
     C                   UPDATE    ASHGLKD0
     C                   ENDIF
 
     C                   READ      ASHGLKL4
     C                   ENDDO
 
     C                   RETURN
     ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRinit    - Initialize keyflds and retrieves standard        *
      *              details from file.                               *
      *                                                               *
      *  Called by: Main Subroutine                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     SESKEY        KLIST
     C                   KFLD                    FSFPSE
     C                   KFLD                    FSBRCA
     C                   KFLD                    FSBKCD
     C                   KFLD                    FSMKTI
     C                   KFLD                    FSBHTV
      *
     C     RXSKEY        KLIST
     C**********         KFLD                    FSDLNO                                       CLE148
     C                   KFLD                    FSDLNO2                                      CLE148
     C                   KFLD                    WKCycd
      *
     C     LEUKEY        KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    FSDLNO
      *
     C     DLUKEY        KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    FSDLNO
      *
     C     YLDKEY        KLIST
     C                   KFLD                    KYLDC
     C                   KFLD                    KYCCY
     C                   KFLD                    KYICM
      *
     C     SEMKEY        KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    FSFPSE
     C                   KFLD                    FSBRCA
     C                   KFLD                    FSBKCD
     C                   KFLD                    FSMKTI
     C                   KFLD                    FSBHTV
      *
     C     KASHTRN       KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    KHedgeIn
 
      ** Key List for Midas SE Revalued Security Positions File
 
     C     KSENPVL       KLIST
     C                   KFLD                    KSEsesn
     C                   KFLD                    KSEbrca
     C                   KFLD                    KSEbokc
     C                   KFLD                    KSEmkti
     C                   KFLD                    KSEbhtv
      *
      **  FRA Rates File: Key1 - Full Key.
      *
     C     KFRAR1        KLIST
     C                   KFLD                    UCUCY
     C                   KFLD                    WBRTT
     C                   KFLD                    VDAT
      *
      **  FRA Rates File: Key2 - Partial Key.
      *
     C     KFRAR2        KLIST
     C                   KFLD                    UCUCY
     C                   KFLD                    WBRTT
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*CALL'
     C                   EVAL      DBASE  = 008
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      BJCYCD        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 006
     C                   EVAL      DBKEY = BJCYCD
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVE      A6MDIN        WToMdin
     C                   MOVE      A6NBDP        WToNbdp
     C                   MOVE      A6SPRT        WToExcr
     C                   ENDIF
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      DBFILE =  'SDGELRPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  008
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set the event control date
 
     C                   EVAL      WkEvCtDt = BJDNWD - 1
     C                   IF        BKAPDT < WkEvCtDt
     C                   EVAL      WkEvCtDt = BKAPDT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDLAS    - Subroutine that identifies deal type of the      *
      *              linkage transaction.                             *
      *                                                               *
      *                                                               *
      *  Called by: Main Program                                      *
      *                                                               *
      *  Calls: SRRSAS, SRRXAS, SRFRAS, SRMMAS                        *
      *                                                               *
      *****************************************************************
     C     SRDLAS        BEGSR
 
     C                   EVAL      XXBRCA = *BLANKS
     C                   EVAL      XXCCY = *BLANKS
     C                   EVAL      XXBKCD = *BLANKS
     C                   EVAL      XXVDAT = 0
     C                   EVAL      XXCHTP = *BLANKS
     C                   EVAL      XXLCD = 0
     C                   EVAL      XXMVAL = 0
     C                   EVAL      XXMVCA = 0
     C                   EVAL      XXMRAT = 0
      *
     C*****FSDLNO        CHAIN     DEALS                                                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2           6 0                        CLE148
     C     FSDLNO2       CHAIN     DEALS                                                      CLE148
      *
     C                   IF        %FOUND(DEALS)
     C     DTYP          CASEQ     'RS'          SRRSAS
     C     DTYP          CASEQ     'RX'          SRRXAS
     C     DTYP          CASEQ     'FR'          SRFRAS
     C                   CAS                     SRMMAS
     C                   ENDCS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMMAS    - Retrieve details from money market NPV files and *
      *              extract them to Dealing collection file.         *
      *                                                               *
      *****************************************************************
     C     SRMMAS        BEGSR
      *
     C*****FSDLNO        CHAIN     MMNPVLL0                                                   CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     MMNPVLL0                                                   CLE148
 
     C                   IF        %FOUND(MMNPVLL0)
 
     C                   IF        MMCYCD <> BJCYCD
     C                   Z-ADD     MMURPL        WFrAmnt
     C                   MOVE      MMCYCD        WFrCcy
     C                   EXSR      SRCONV
     C                   Z-ADD     PZAmtCo       WMMUrpl
     C                   EVAL      MMURPL = WMMUrpl
     C                   ENDIF
 
     C                   Z-ADD     MMURPL        XXMVAL
      *
     C                   IF        FSDTTP = 'R'
     C                   EVAL      PIPYLD = FSOYLC
     C                   EVAL      PIPCCY = MMCYCD
     C                   MOVE      ICBS          PIPINC
     C                   EVAL      PIPRTC = 'YRATE'
     C                   EVAL      PIPFDT = WKEVCTDT
      *
     C                   CALL      'ZADSFRTV'
     C                   PARM      *blanks       PIRTCD            7
     C                   PARM                    PIPRTC            5
     C                   PARM                    PIPYLD            5
     C                   PARM                    PIPCCY            3
     C                   PARM                    PIPINC            1
     C                   PARM                    PIPFDT            5 0
     C                   PARM      *ZERO         PIPDF            13 9
      *
     C                   EVAL      XXMRAT = PIPDF
      *
     C                   IF        PIRTCD = '*ERROR '
     C                   MOVE      'ZADSFRTV'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   MOVEL     PIPYLD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      XXCCY = MMCYCD
     C                   ENDIF
      *
     C     DLUKEY        SETLL     ASDLHML2
     C     DLUKEY        READE     ASDLHML2
      *
     C                   IF        NOT %EOF(ASDLHML2)
     C     XXMVAL        SUB       DXXMVAL       XXMVCA
     C                   ENDIF
      *
     C                   EVAL      XXHEDI = FSHEDI
     C                   EVAL      XXDTAT = 'A'
     C                   EVAL      XXRECI = 'D'
     C                   EVAL      XXDLNO = FSDLNO
     C                   EVAL      XXBRCA = MMBRCA
     C                   EVAL      XXBKCD = MMBKCD
     C                   EVAL      XXVDAT = FSNDTA
     C                   EVAL      XXCHTP = 'I'
     C                   EVAL      XXLCD = BJRDNB
 
     C                   WRITE     ASDLHMD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRSAS    - Retrieve details from single rates NPV file and  *
      *              extract them to Dealing collection file.         *
      *                                                               *
      *                                                               *
      *  Called by: SRDLAS                                            *
      *                                                               *
      *  Calls: SRCHKHDGI                                             *
      *                                                               *
      *****************************************************************
     C     SRRSAS        BEGSR
      *
     C                   EXSR      SRCHKHDGI
 
     C                   IF        WkBase ='Y'
 
     C*****FSDLNO        CHAIN     IRNPVBL0                                                   CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     IRNPVBL0                                                   CLE148
 
     C                   IF        %FOUND(IRNPVBL0)
      *
     C                   IF        IRCYCD <> BJCYCD
     C                   Z-ADD     IRURPL        WFrAmnt
     C                   MOVE      IRCYCD        WFrCcy
     C                   EXSR      SRCONV
     C                   Z-ADD     PZAmtCo       WIRUrpl
     C                   EVAL      IRURPL = WIRUrpl
     C                   ENDIF
      *
     C                   Z-ADD     IRURPL        XXMVAL
      *
     C                   EVAL      XXCCY = IRCYCD
     C                   ENDIF
      *
     C                   ELSE
      *
     C*****FSDLNO        CHAIN     IRNPVAL0                                                   CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     IRNPVAL0                                                   CLE148
     C                   IF        %FOUND(IRNPVAL0)
      *
     C                   IF        IRCYCD <> BJCYCD
     C                   Z-ADD     IRURPL        WFrAmnt
     C                   MOVE      IRCYCD        WFrCcy
     C                   EXSR      SRCONV
     C                   Z-ADD     PZAmtCo       WIRUrpl
     C                   EVAL      IRURPL = WIRUrpl
     C                   ENDIF
      *
     C                   Z-ADD     IRURPL        XXMVAL
      *
     C                   EVAL      XXCCY = IRCYCD
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        FSDTTP = 'R'
     C     FSHGST        CHAIN     SDHGSTL0
      *
     C                   IF        %FOUND(DEALS)
      *
     C                   SELECT
     C                   WHEN      JFSPRTP = 'FV'
     C                   IF        UBRTT = *ZEROS
     C                   EVAL      XXMRAT = UEINR
     C                   ELSE
     C                   EVAL      XXMRAT = TEINR
     C                   ENDIF
      *
     C                   WHEN      JFSPRTP = 'CF'
     C                   IF        UBRTT = *ZEROS
     C                   EVAL      XXMRAT = TEINR
     C                   ELSE
     C                   EVAL      XXMRAT = UEINR
     C                   ENDIF
      *
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
     C     DLUKEY        SETLL     ASDLHML2
     C     DLUKEY        READE     ASDLHML2
      *
     C                   IF        NOT %EOF(ASDLHML2)
     C     XXMVAL        SUB       DXXMVAL       XXMVCA
     C                   ENDIF
      *
     C                   EVAL      XXHEDI = FSHEDI
     C                   EVAL      XXDTAT = 'A'
     C                   EVAL      XXRECI = 'D'
     C                   EVAL      XXDLNO = FSDLNO
     C                   EVAL      XXBRCA = IRBRCA
     C                   EVAL      XXBKCD = IRBOKC
     C                   EVAL      XXVDAT = FSNDTA
     C                   EVAL      XXCHTP = 'I'
     C                   EVAL      XXLCD = BJRDNB
      *
     C                   WRITE     ASDLHMD0
      *
     C                   ENDSR
     ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRXAS    - Retrieve details from cross rates NPV file and   *
      *              extract them to Dealing collection file.         *
      *                                                               *
      *                                                               *
      *  Called by: SRDLAS                                            *
      *                                                               *
      *  Calls: SRCHKHDGI                                             *
      *                                                               *
      *****************************************************************
     C     SRRXAS        BEGSR
      *
     C                   EXSR      SRCHKHDGI
      *
     C                   IF        WkBase ='Y'
      *
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     RXSKEY        CHAIN     RXNPVBL1
      *
     C                   IF        %FOUND(RXNPVBL1)
      *
     C**********         IF        IRCYCD <> BJCYCD                                           226170
     C**********         Z-ADD     IRURPL        WFrAmnt                                      226170
     C**********         MOVE      IRCYCD        WFrCcy                                       226170
     C**********         EXSR      SRCONV                                                     226170
     C**********         Z-ADD     PZAmtCo       WIRUrpl                                      226170
     C**********         EVAL      IRURPL = WIRUrpl                                           226170
     C**********         ENDIF                                                                226170
      *
     C                   Z-ADD     IRURPL        XXMVAL
      *
     C                   IF        FSDTTP = 'R'
     C                   EVAL      PIPYLD = FSOYLC
     C                   EVAL      PIPCCY = IRCYCD
     C                   MOVE      UICBS         PIPINC
     C                   EVAL      PIPRTC = 'YRATE'
     C                   EVAL      PIPFDT = WKEVCTDT
      *
     C                   CALL      'ZADSFRTV'
     C                   PARM      *blanks       PIRTCD            7
     C                   PARM                    PIPRTC            5
     C                   PARM                    PIPYLD            5
     C                   PARM                    PIPCCY            3
     C                   PARM                    PIPINC            1
     C                   PARM                    PIPFDT            5 0
     C                   PARM      *ZERO         PIPDF            13 9
      *
     C                   EVAL      XXMRAT = PIPDF
      *
     C                   IF        PIRTCD = '*ERROR '
     C                   MOVE      'ZADSFRTV'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   MOVEL     PIPYLD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      XXCCY = IRCYCD
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     RXSKEY        CHAIN     RXNPVAL1
     C                   IF        %FOUND(RXNPVAL1)
      *
     C**********         IF        IRCYCD <> BJCYCD                                           226170
     C**********         Z-ADD     IRURPL        WFrAmnt                                      226170
     C**********         MOVE      IRCYCD        WFrCcy                                       226170
     C**********         EXSR      SRCONV                                                     226170
     C**********         Z-ADD     PZAmtCo       WIRUrpl                                      226170
     C**********         EVAL      IRURPL = WIRUrpl                                           226170
     C**********         ENDIF                                                                226170
      *
     C                   Z-ADD     IRURPL        XXMVAL
      *
     C                   IF        FSDTTP = 'R'
     C                   EVAL      PIPYLD = FSOYLC
     C                   EVAL      PIPCCY = IRCYCD
     C                   MOVE      UICBS         PIPINC
     C                   EVAL      PIPRTC = 'YRATE'
     C                   EVAL      PIPFDT = WKEVCTDT
      *
     C                   CALL      'ZADSFRTV'
     C                   PARM      *blanks       PIRTCD            7
     C                   PARM                    PIPRTC            5
     C                   PARM                    PIPYLD            5
     C                   PARM                    PIPCCY            3
     C                   PARM                    PIPINC            1
     C                   PARM                    PIPFDT            5 0
     C                   PARM      *ZERO         PIPDF            13 9
 
     C                   EVAL      XXMRAT = PIPDF
      *
     C                   IF        PIRTCD = '*ERROR '
     C                   MOVE      'ZADSFRTV'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   MOVEL     PIPYLD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      XXCCY = IRCYCD
     C                   ENDIF
     C                   ENDIF
      *
     C     DLUKEY        SETLL     ASDLHML2
     C     DLUKEY        READE     ASDLHML2
      *
     C                   IF        NOT %EOF(ASDLHML2)
     C     XXMVAL        SUB       DXXMVAL       XXMVCA
     C                   ENDIF
      *
     C                   EVAL      XXHEDI = FSHEDI
     C                   EVAL      XXDTAT = 'A'
     C                   EVAL      XXRECI = 'D'
     C                   EVAL      XXDLNO = FSDLNO
     C                   EVAL      XXBRCA = IRBRCA
     C                   EVAL      XXBKCD = IRBOKC
     C                   EVAL      XXVDAT = FSNDTA
     C                   EVAL      XXCHTP = 'I'
     C                   EVAL      XXLCD = BJRDNB
      *
      *
     C                   WRITE     ASDLHMD0
      *
     C                   ENDSR
     ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFRAS    - Retrieve details from FRA NPV file and extract   *
      *              them to Dealing collection file.                 *
      *                                                               *
      *                                                               *
      *  Called by: SRDLAS                                            *
      *                                                               *
      *  Calls: SRCHKHDGI                                             *
      *                                                               *
      *****************************************************************
     C     SRFRAS        BEGSR
      *
      *
     C                   IF        FSDTTP = 'R'
     C                   Z-ADD     0             WFRART
      *
     C                   IF        BYSL = 'B'
     C                   Z-ADD     TBRTT         WBRTT
     C                   Z-ADD     TEINR         WFXRT
     C                   Z-ADD     TINFD         WINFD
     C                   ELSE
     C                   Z-ADD     UBRTT         WBRTT
     C                   Z-ADD     UEINR         WFXRT
     C                   Z-ADD     UINFD         WINFD
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      SRCHKHDGI
     C                   IF        WkBase ='Y'
      *
     C*****FSDLNO        CHAIN     FRNPVLL0                                                   CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     FRNPVLL0                                                   CLE148
 
     C                   IF        %FOUND(FRNPVLL0)
      *
     C                   IF        IRCYCD <> BJCYCD
     C                   Z-ADD     IRURPL        WFrAmnt
     C                   MOVE      IRCYCD        WFrCcy
     C                   EXSR      SRCONV
     C                   Z-ADD     PZAmtCo       WIRUrpl
     C                   EVAL      IRURPL = WIRUrpl
     C                   ENDIF
      *
     C                   Z-ADD     IRURPL        XXMVAL
     C                   EVAL      XXCCY = IRCYCD
      *
     C                   IF        FSDTTP = 'R'
      *
      **  Obtain the revaluation rate from the Current Market Rate if
      **  the fix date has not passed the rundate, otherwise, use the
      **  fixed rate.
     C                   IF        WINFD > BJRDNB OR WFXRT = 0
     C                   EXSR      SrGetRat
     C                   ELSE
     C                   Z-ADD     WFXRT         WFRART
     C                   ENDIF
     C                   EVAL      XXMRAT =  WFRART
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C*****FSDLNO        CHAIN     FRNPVAL0                                                   CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     FRNPVAL0                                                   CLE148
     C                   IF        %FOUND(FRNPVAL0)
     C                   IF        IRCYCD <> BJCYCD
     C                   Z-ADD     IRURPL        WFrAmnt
     C                   MOVE      IRCYCD        WFrCcy
     C                   EXSR      SRCONV
     C                   Z-ADD     PZAmtCo       WIRUrpl
     C                   EVAL      IRURPL = WIRUrpl
     C                   ENDIF
      *
     C                   Z-ADD     IRURPL        XXMVAL
     C                   EVAL      XXCCY =IRCYCD
      *
     C                   IF        FSDTTP = 'R'
     C                   IF        WINFD > BJRDNB OR WFXRT = 0
     C                   EXSR      SrGetRat
     C                   ELSE
     C                   Z-ADD     WFXRT         WFRART
     C                   ENDIF
     C                   Z-ADD     WFRART        XXMRAT
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DLUKEY        SETLL     ASDLHML2
     C     DLUKEY        READE     ASDLHML2
      *
     C                   IF        NOT %EOF(ASDLHML2)
     C     XXMVAL        SUB       DXXMVAL       XXMVCA
     C                   ENDIF
      *
     C                   EVAL      XXHEDI = FSHEDI
     C                   EVAL      XXDTAT = 'A'
     C                   EVAL      XXRECI = 'D'
     C                   EVAL      XXDLNO = FSDLNO
     C                   EVAL      XXBRCA = IRBRCA
     C                   EVAL      XXBKCD = IRBOKC
     C                   EVAL      XXVDAT = FSNDTA
     C                   EVAL      XXCHTP = 'I'
     C                   EVAL      XXLCD = BJRDNB
      *
     C                   WRITE     ASDLHMD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLEAS    - Retrieve details from Lending NPV file and       *
      *              extract them to Dealing collection file.         *
      *                                                               *
      *                                                               *
      *  Called by: Main Program                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRLEAS        BEGSR
      *
     C                   EVAL      XXBRCA = *BLANKS
     C                   EVAL      XXCCY = *BLANKS
     C                   EVAL      XXBKCD = *BLANKS
     C                   EVAL      XXVDAT = 0
     C                   EVAL      XXCHTP = *BLANKS
     C                   EVAL      XXLCD = 0
     C                   EVAL      XXMVAL = 0
     C                   EVAL      XXMVCA = 0
     C                   EVAL      XXMRAT = 0
 
     C     FSDLNO        CHAIN     LENPVLL0
 
     C                   IF        %FOUND(LENPVLL0)
      *
     C                   IF        LECYCD <> BJCYCD
     C                   Z-ADD     LEURPL        WFrAmnt
     C                   MOVE      LECYCD        WFrCcy
     C                   EXSR      SRCONV
     C                   Z-ADD     PZAmtCo       WLEUrpl
     C                   EVAL      LEURPL = WLEUrpl
     C                   ENDIF
      *
     C                   Z-ADD     LEURPL        XXMVAL
      *
     C                   IF        FSDTTP = 'R'
     C     FSDLNO        CHAIN     CLOAN
      *
     C                   IF        %FOUND(CLOAN)
     C                   EVAL      PIPYLD = FSYLDC
     C                   EVAL      PIPCCY = LECYCD
     C                   MOVE      ICBS          PIPINC
     C                   EVAL      PIPRTC = 'YRATE'
     C                   EVAL      PIPFDT = WKEVCTDT
      *
     C                   CALL      'ZADSFRTV'
     C                   PARM      *blanks       PIRTCD            7
     C                   PARM                    PIPRTC            5
     C                   PARM                    PIPYLD            5
     C                   PARM                    PIPCCY            3
     C                   PARM                    PIPINC            1
     C                   PARM                    PIPFDT            5 0
     C                   PARM      *ZERO         PIPDF            13 9
      *
     C                   EVAL      XXMRAT = PIPDF
      *
     C                   IF        PIRTCD = '*ERROR '
     C                   MOVE      'ZADSFRTV'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   MOVEL     PIPYLD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      XXCCY = LECYCD
     C                   ENDIF
      *
     C     LEUKEY        SETLL     ASLEHML2
     C     LEUKEY        READE     ASLEHML2
      *
     C                   IF        NOT %EOF(ASLEHML2)
     C     XXMVAL        SUB       LXXMVAL       XXMVCA
     C                   ENDIF
      *
     C                   EVAL      XXHEDI = FSHEDI
     C                   EVAL      XXDTAT = 'A'
     C                   EVAL      XXRECI = 'D'
     C                   EVAL      XXDLNO = FSDLNO
     C                   EVAL      XXBRCA = LEBRCA
     C                   EVAL      XXBKCD = LEBKCD
     C                   EVAL      XXVDAT = FSNDTA
     C                   EVAL      XXCHTP = 'I'
     C                   EVAL      XXLCD = BJRDNB
      *
     C                   WRITE     ASLEHMD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSEAS    - Retrieve details from Securities NPV file and    *
      *              extract them to Dealing collection file.         *
      *                                                               *
      *                                                               *
      *  Called by: Main Program                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRSEAS        BEGSR
      *
     C                   EVAL      XXBRCA = *BLANKS
     C                   EVAL      XXMKTI = *BLANKS
     C                   EVAL      XXCCY = *BLANKS
     C                   EVAL      XXBKCD = *BLANKS
     C                   EVAL      XXBHTV = *BLANKS
     C                   EVAL      XXVDAT = 0
     C                   EVAL      XXCHTP = *BLANKS
     C                   EVAL      XXLCD = 0
     C                   EVAL      XXMVAL = 0
     C                   EVAL      XXMVCA = 0
     C                   EVAL      XXMRAT = 0
 
     C     SESKEY        CHAIN     SEMKVLL0
 
     C                   IF        %FOUND(SEMKVLL0)
      *
     C                   IF        SECCY <> BJCYCD
     C                   Z-ADD     SEURPL        WFrAmnt
     C                   MOVE      SECCY         WFrCcy
     C                   EXSR      SRCONV
     C                   Z-ADD     PZAmtCo       WSeUrpl
     C                   EVAL      SEURPL = WSeUrpl
     C                   ENDIF
      *
     C                   Z-ADD     SEURPL        XXMVAL
      *
     C                   IF        FSDTTP ='R'
     C     FSFPSE        CHAIN     PRICM
     C                   IF        %FOUND(PRICM)
     C                   ADD       PRLQPR        PPRC
     C                   ADD       PRCRSK        PPRC
     C                   Z-ADD     PPRC          XXMRAT
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      XXCCY = SECCY
     C                   ENDIF
 
     C     SEMKEY        SETLL     ASSEHML0
     C     SEMKEY        READE     ASSEHML0
 
     C                   IF        NOT %EOF(ASSEHML0)
     C     XXMVAL        SUB       SXXMVAL       XXMVCA
     C                   ENDIF
      *
     C                   EVAL      XXHEDI = FSHEDI
     C                   EVAL      XXDTAT = 'A'
     C                   EVAL      XXRECI = 'D'
     C                   EVAL      XXSESN = FSFPSE
     C                   EVAL      XXBRCA = FSBRCA
     C                   EVAL      XXMKTI = FSMKTI
     C                   EVAL      XXBKCD = FSBKCD
     C                   EVAL      XXBHTV = FSBHTV
     C                   EVAL      XXVDAT = FSNDTA
     C                   EVAL      XXCHTP = 'I'
     C                   EVAL      XXLCD = BJRDNB
      *
     C                   WRITE     ASSEHMD0
      *
     C                   ENDSR
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCONV    - Retrieve market value and converts them to base  *
      *              currency from different modules.                 *
      *                                                               *
      *                                                               *
      *  Called by: SRSEAS, SRRSAS, SRLEAS, SRRXAS, SRFRAS            *
      *                                                               *
      *  Calls: ZCONVZ1                                               *
      *                                                               *
      *****************************************************************
     C     SRCONV        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      WFrCcy        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Database Error
      *
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCURRPD'
     C                   EVAL      DBASE =  006
     C                   EVAL      DBKEY =  WFrCcy
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   Z-ADD     0             PZAmtCo
     C                   MOVE      A6NBDP        WFrNbdp
     C                   MOVE      A6MDIN        WToMdin
     C                   MOVE      A6SPRT        WToExcr
      *
     C                   CALL      'ZCONVZ1'
     C                   PARM      WFrAmnt       PZInAmt
     C                   PARM      WToExcr       PZExchR
     C                   PARM      WToMdin       PZMdin
     C                   PARM      WFrCcy        PZCcyFr
     C                   PARM      BJCYCD        PZCcyTo
     C                   PARM      WFrNbdp       PZDecFr
     C                   PARM      WToNbdp       PZDecTo
     C     PZAmtCo       PARM                    P#OutA
      *
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkHdgI - Check Hedged Items if there is a need to chain   *
      *              the Base Rate version of the NPV files of the    *
      *              current derivative                               *
      *                                                               *
      *  Called by: SRRSAS, SRRXAS, SRFRAS                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRChkHdgI     BEGSR
 
     C                   EVAL      KHedgeIn = 'H'
     C                   EVAL      WkBase = 'N'
 
     C     KASHTRN       CHAIN     ASHTRNLB                           26
 
     C                   DOW       *IN26 = *OFF AND WkBase = 'N'
 
     C                   IF        XFSHTID = 'D'
 
     C                   SELECT
 
     C                   WHEN      XFSMOD = 'DL'
      *
     C*****XFSDLNO       CHAIN     DEALSL                                                     CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     DEALSL                                                     CLE148
 
      ** If hedged item is a deal, check spread
 
     C                   IF        %FOUND(DEALS)
 
      ** For Loans and Deposits records, check liquidity premium                              227695
                                                                                              227695
     C                   IF        ZRCDT = 'C'
     C**********         IF        ZRTSP <> 0 AND ZBRTT <> 0                                  227695
     C                   IF        ZFSLQPR <> 0                                               227695
     C                   EVAL      WkBase = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      ** For Negotiable Assets Purchased records, check liquidity premium
      *
     C                   IF        ZRCDT = 'D'
     C                   IF        ZFSLQPR <> 0
     C                   EVAL      WkBase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Store currency code, to be checked later when derivative is a cross
      ** currency swap
 
     C*****XFSDLNO       CHAIN     MMNPVLL0                                                   CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     MMNPVLL0                                                   CLE148
     C                   IF        %FOUND(MMNPVLL0)
     C                   EVAL      WKCycd = MMCYCD
     C                   ELSE
     C                   EVAL      WKCycd = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   WHEN      XFSMOD = 'LE'
 
     C     XFSDLNO       CHAIN     CLOAN
 
      ** If hedged item is a loan, check margin
 
     C                   IF        %FOUND(CLOAN)
 
     C                   IF        MARG <> 0
     C                   EVAL      WkBase = 'Y'
     C                   ENDIF
 
      ** Store currency code, to be checked later when derivative is a cross
      ** currency swap
 
     C     XFSDLNO       CHAIN     LENPVLL0
     C                   IF        %FOUND(LENPVLL0)
     C                   EVAL      WKCycd = LECYCD
     C                   ELSE
     C                   EVAL      WKCycd = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   WHEN      XFSMOD = 'SE'
 
      ** Populate key fields to be used in chaining in the book position file
 
     C                   EVAL      KSEsesn = XFSFPSE
     C                   EVAL      KSEbrca = XFSBRCA
     C                   EVAL      KSEbokc = XFSBKCD
     C                   EVAL      KSEmkti = XFSMKTI
     C                   EVAL      KSEbhtv = XFSBHTV
 
      ** Chain to book position file to get the Latest Average Price and the
      ** Latest Net Treasury Average Price
 
     C     KSENPVL       CHAIN     BKPHD
 
     C                   IF        %FOUND(BKPHD)
 
     C                   DOW       (B2RECI <> 'D') AND (NOT %EOF(BKPHD))
     C     KSENPVL       READE     BKPHD
     C                   ENDDO
 
      ** If the Latest Average Price is not equal to the Latest Net Treasury
      ** Average Price, use base rate file
 
     C                   IF        (NOT %EOF(BKPHD)) AND (B2LAVP <> B2LAVN)
     C                   EVAL      WkBase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Retrieve details from PF/SEMKVLPD for hedged SE book positions
      ** instead of from PF/SENPVLPD.
 
     C     KSENPVL       CHAIN     SEMKVLL0
     C                   IF        %FOUND(SEMKVLL0)
     C                   EVAL      WKCycd = SECCY
     C                   ELSE
     C                   EVAL      WKCycd = *BLANKS
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C     KASHTRN       READE     ASHTRNLB                               26
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetRat  - Subroutine to obtain the FRA Market Rate.        *
      *                                                               *
      *  Called by: SRFRAS
      *                                                               *
      *  Calls: ZAINTPL - Straight LIne Interpolation                 *
      *                                                               *
      *****************************************************************
     C     SrGetRat      BEGSR
      *
      **  Initialise Fields.
      *
     C                   Z-ADD     0             WFRART           11 7
     C                   MOVE      0             *IN71
     C                   MOVE      0             *IN72
     C                   MOVE      0             *IN73
      *
      ** First set Lower Limits using Currency/Base Rate/Value Date.
      *
     C     KFRAR1        SETLL     DLFRARL4                           71
      *
      ** If not EOF, Read Equal the next record of the Currency/Base
      ** Rate.
      *
     C                   IF        *IN71 = *OFF
     C     KFRAR2        READE     DLFRARL4                               72
      *
      ** If a record was read and is the correct date, set up the FRA
      ** Rate and exit.
      *
     C                   IF        *IN72 = *OFF AND FRVMDN = VDAT
     C                   Z-ADD     FRRATE        WFRART
     C                   GOTO      EGetRat
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If a record has not yet been retrieved, reposition the file
      ** and read the last record of the Currency/Base Rate.
      *
     C                   IF         *IN71 = *ON OR *IN72 = *ON
     C     KFRAR1        SETGT     DLFRARL4
      *
      ** If Record found then set up the FRA Rate, else the Currency/
      ** Base Rate is not on File (*IN73 returned).
      *
     C     KFRAR2        READPE    DLFRARL4                               73
     C                   IF         *IN73 = *OFF
     C                   Z-ADD     FRRATE        WFRART
     C                   ENDIF
     C                   GOTO      EGetRat
      *
     C                   ENDIF
      *
      ** If this point has been reached, a record has been found with
      ** a date greater than the one we want and it will probably be
      ** necessary to use interpolation, so set up Far Date and Far
      ** Rate fields (for PGM/ZAINTPL).
      *
     C                   Z-ADD     FRVMDN        PZIFDAT
     C                   Z-ADD     FRRATE        PZIFRAT
      *
      ** Read the Previous record to get the Near Rate. If not found,
      ** (*IN71), then the record already retrieved is the first for
      ** this Currency/Base Rate and that FRA Rate should be used.
      *
     C     KFRAR2        READPE    DLFRARL4                               71
      *
     C                   IF        *IN71 = *ON
     C                   Z-ADD     PZIFRAT       WFRART
     C                   ELSE
      *
      ** Else set up Near Date, Near Rate and Broken Date and then
      ** interpolate the Rate.
      *
     C                   Z-ADD     FRVMDN        PZINDAT
     C                   Z-ADD     FRRATE        PZINRAT
     C                   Z-ADD     VDAT          PZIBDAT
     C                   Z-ADD     0             PZIBRAT
      *
     C                   CALL      'ZAINTPL'
     C                   PARM                    PZINDAT
     C                   PARM                    PZIBDAT
     C                   PARM                    PZIFDAT
     C                   PARM                    PZINRAT
     C                   PARM                    PZIFRAT
     C                   PARM                    PZIBRAT
      *
     C                   Z-ADD     PZIBRAT       WFRART
     C                   ENDIF
      *
     C     EGetRat       ENDSR
      *
      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
      *
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   RETURN
      *
     C                   ENDSR
