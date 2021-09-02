     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Payment Routing Screen')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0710 - Midas FT Payment Routing Screen                    *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. HVB003             Date 19Oct2011             *
      *                 AR856737           Date 15Jul2011             *
      *                 PNL015             Date 01Dec2005             *
      *                 PNL014             Date 07Dec2005             *
      *                 MM0505             Date 04May2005             *
      *                 Djb004             Date 18Mar2005             *
      *                 ESL038             Date 01Dec2004             *
      *                 EEE065             Date 25Nov2004             *
      *                 DJBF15             Date 18Nov2004             *
      *                 EEE065             Date 04Nov2004             *
      *                 EEE065  *Create    Date 09Apr2004             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  HVB003 - Routing for Target Balance payments                 *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *             Renamed QQDFAC field in SDBRCHPD                  *
      *             Changed length of P@ACCD to 10                    *
      *             Add field DSMSEQ to key list KIndts2a             *
      *             Changed length of #1MDAC and #1MDAO in dsp file   *
      *  PNL015 - Redirection to head office BIC                      *
      *  PNL014 - Time Sensitive Payments                             *
      *  MM0505 - Add Value Date to Routing                           *
      *  Djb004 - Suppress search if Benb filled                      *
      *  ESL038 - ING FT STP Development                              *
      *  EEE065 - Allow Foreign BICs                                  *
      *  DJBF15 - If not routing restore valuse prior to call         *
      *  EEE065 - FT Payment Routing                                  *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FFTP0710DF CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Prompt for selection      Prompt & validate record
      *
     FMEBICDL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : BIC Directory
      *
     FMEBICPV0  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     Rename(@BicPpd:@BicpV0)
      * RTV : BIC Plus by Key
      *
     FFTMSCCV0  UF   E           K DISK
     F                                     COMMIT
     F                                     INFSR(SRFILE)
      * UPD : STP Correspondents
      *
     FFTMSCPV0  UF   E           K DISK
     F                                     COMMIT
     F                                     INFSR(SRFILE)
      * UPD : STP Pay Routes
      *
     FMEINDTS2  IF   E           K DISK
      *
      *  Message Details
      *
     FFTMscsV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : FT Payment Customer specific routes
      *
     FFTMROTV0  UF A E           K DISK
     F                                     INFSR(SRFILE)
      * UPD/ADD : STP Payment Routing Data
      *
     FFTPICDV1  IF   E           K DISK                                                       PNL014
     F                                     INFSR(SRFILE)                                      PNL014
      * RTV : Midas FT Payment Route ICD                                                      PNL014
                                                                                              PNL014
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *  Array containing Copyright statement
      *
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array of QCMDEXC commands
      *
     D EDT             S              1    DIM(80)
      *
      *  Array of QCMDEXC command to edit
      *
     D YA1             S              1    DIM(15)
      *
      *  Array for amount formatting
      *
     D/COPY MECPYSRC,SRERRD_ILE
      *
      *  Copysource for error processing
      *
     D/COPY MECPYSRC,ME1100_ILE
      /EJECT
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
     D ZMUSER        E DS                  EXTNAME(ZMUSER)
      *
      * Get Default User Data
      *
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
      *
      * Modules Data Structure *
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      * Switchable Features Data Structure *
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      * Data Structures for Currency Definition
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFA1        E                     EXTFLD(QQDFAC)                                 AR856737
      *
      * Data Structures for Branches
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      * Data Structures for Country codes
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      * Data Structures for Nostro Details
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB) PREFIX(AC)
      *
      *  Accounts *
      *
     D DsAccounts      DS
     D  W0Account              1     34
     D  W0Brca                             Like(AcBrca)
     D  W0Cnum                             Like(AcCnum)
     D  W0Ccy                              Like(AcCcy )
     D  W0Acod                             Like(AcAcod)
     D  W0Acsq                             Like(AcAcsq)
     D  W0Acno                             Like(AcAcno)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
      *
     D MROTDS        E DS                  EXTNAME(FTMROTP0)
      *
      * Current routing data structure
      *
     D #MROTDS       E DS                  EXTNAME(FTMROTP0) PREFIX(#)
      *
      * Stored routing data structure
      *
     D SMROTDS       E DS                  EXTNAME(FTMROTP0) PREFIX(Sv_)                      DJBF15
                                                                                              DJBF15
      * Stored routing data structure prior to call of FTP0715                                DJBF15
      *                                                                                       DJBF15
      * Parameter declarations
      *
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
      *
      * O : To FTP0715
     D P3PARM          DS          1463
      *
     D O2PARM          DS           256
      * O : Message Reference
     D  O2PGM                  1     10
      * O : Preferential update
     D  O2PCOR                11     11
     D  O2Bicc                12     19
     D  O2Bicb                20     22
     D  O2Pccy                23     25
     D  O2Cbic                26     33
     D  O2Cbib                34     36
     D  O2PREG                37     37
     D  O2PLVP                38     38
     D  O2PLBen               39     39
     D  O2PLSha               40     40
     D  O2PLOur               41     41
      * FTP1150 Selection
     D O4PARM          DS           256
      * O : MAP Customer Id
     D  O4Idks                             Like( CsIdks )
      * O : MAP IBAN
     D  O4Iban                             Like( CsIban )
      * O : MAP Pay Currency
     D  O4PCCY                             Like( CsPccy )
      * O : MAP Reference
     D  O4REF1                             Like( CsRef1 )
     D  O4REF2                             Like( CsRef2 )
      *                                                                                       ESL038
      * O : To FTP0706                                                                        ESL038
      *                                                                                       ESL038
     D P7PARM          DS           256                                                       ESL038
      * O : Beneficiary                                                                       ESL038
     D  P7BENB                 1     11                                                       ESL038
      * O : Beneficiary country                                                               ESL038
     D  P7BENC                12     13                                                       ESL038
     D  P7CLCD                14     48                                                       ESL038
     D  P7IBAN                49     49                                                       ESL038
      *                                                                                       ESL038
     D o7PARM          DS           256                                                       ESL038
      * O : Beneficiary                                                                       ESL038
     D  o7BENB                 1     11                                                       ESL038
      * O : Beneficiary country                                                               ESL038
     D  o7BENC                12     13                                                       ESL038
      *
      * O : To FTP0716
     D POADD           DS
      * Output Data Structure for reformatted address
     D  OADD1                  1     35
     D  OADD2                 36     70
     D  OADD3                 71    105
     D  OADD4                106    140
     D  OADD5                141    175
     D PBICP           DS
      * Output Data Structure for BIC Plus return data
     D  PINST                  1    105
     D  PBNCH                106    175
     D  PADDR                176    315
     D  PCITY                316    350
     D  PZIP                 351    365
     D  PCNTY                366    435
     D  PBIC                 436    446
     D  PNATI                447    457
     D  PCHIP                458    463
     D  PPOBN                464    498
     D  PPOBZ                499    513
     D  PPOBL                514    583
     D  PCTRY                584    585
      *
     D                 DS
      * Message data for 'Invalid Action code (FT)'
     D  ZAMSDA                 1    132
      * Action Code
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     D W#PTHR          S              1
     D W#BENB          S              1
     D W#ACBR          S              1
     D W#RCCO          S              1
     D W#DSTO          S              1
     D W#INTO          S              1
     D W#ACBO          S              1
     D W#DMAO          S              1
     D W#CTHO          S              1
                                                                                              PNL014
     D ZDayNbr         S              5P 0                                                    PNL014
     D ZMDay           S              5P 0                                                    PNL014
     D ZSDate          S              6                                                       PNL014
     D ZSDatc          S              8                                                       PNL014
     D W#DateCcYyMmDd  S              8                                                       PNL014
     D W#DateA         S              6                                                       PNL014
      *
     D Digits          S             10    Inz('1234567890')
      *
      *                                                                                       MM0505
      * Parameters for ZDATE1                                                                 MM0505
     D ZDATIN          S              6A                                                      MM0505
     D ZDAYNO          S              5P 0                                                    MM0505
     D MVDATE          S              5P 0                                                    MM0505
     D ZERR            S              1A                                                      MM0505
      *                                                                                       MM0505
      * O : Value Date Conversion                                                             MM0505
      *                                                                                       MM0505
     D @VDATE          DS             6                                                       MM0505
      * O : Beneficiary                                                                       MM0505
     D  @YY                    1      2                                                       MM0505
     D  @MM                    3      4                                                       MM0505
     D  @DD                    5      6                                                       MM0505
      *                                                                                       MM0505
      *                                                                                       MM0505
     D @@DATE          DS             6                                                       MM0505
      * O : Beneficiary                                                                       MM0505
     D  @@D                    1      2                                                       MM0505
     D  @@M                    3      4                                                       MM0505
     D  @@Y                    5      6                                                       MM0505
      *
      *
     D/EJECT

     I@INDTS2       01
     I@IN35S2       02

      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    PHEAD
     C                   PARM                    PDATA
     C                   PARM      MROTDS        P3PARM                         Message data
      *****************************************************************
     C                   Clear                   MROTDS
     C                   Clear                   #MROTDS
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Conduct screen conversation
     C                   DO        *HIVAL
      * Start new transaction
     C                   MOVEL     'Y'           W0TRN             1
      *
      * User details
     C                   If        P1Actc <> 'R'
     C                   Movel     *off          *In73
     C                   Else
     C                   Movel     *on           *In73
     C                   Endif
      *
      * Top can be entered for routing
     C                   Movel     *on           *In74
     C                   Movel     *off          *In75
     C                   Movel     *on           *In76
      * No F12 at this point
     C                   Movel     *off          *In77
     C                   Movel     *off          *In78
      * Allow F7 to ignore
     C                   Movel     *on           *In79
     C                   Movel     ##Cmdb        ##CMD2
      *                                                                                       EMRMK5
     C                   If        PNwrk = 'MTCASH'                                           EMRMK5
     C                   Eval      P23E = *Blanks                                             EMRMK5
     C                   EndIf                                                                EMRMK5
      *
     C                   Clear                   #1Vdat                                       PNL014
     C                   If        P1Actc = 'R'
      * Default top of screen
     C                   Eval      DSTRAN = PDCA
                                                                                              PNL014
      * Get Date                                                                              PNL014
     C                   If        IcTsRt = 'Y' and ICTsBs = 'C'                              PNL014
     C                   Movel     TVVDAT        W#DateA                                      PNL014
     C                   Select                                                               PNL014
     C                   When      WuDff = 'M'                                                PNL014
     C                   Eval      #1VDat = %Subst(W#DateA:3:2) +                             PNL014
     C                                      %Subst(W#DateA:5:2) +                             PNL014
     C                                      %Subst(W#DateA:1:2)                               PNL014
     C                   When      WuDff = 'D'                                                PNL014
     C                   Eval      #1VDat = %Subst(W#DateA:5:2) +                             PNL014
     C                                      %Subst(W#DateA:3:2) +                             PNL014
     C                                      %Subst(W#DateA:1:2)                               PNL014
     C                   Endsl                                                                PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   Eval      #1Smcy = TVCCY
     C                   Eval      #1Pccy = TVCCY
      *
      * Format amount field (change ',' decimal point to '.').
     C                   MOVEA     *BLANKS       YA1
     C                   MOVEA     TVAMT         YA1
     C                   Z-ADD     1             C                 3 0
      *
     C     C             DOUGT     15
     C     YA1(C)        IFEQ      ','
     C                   MOVE      '.'           YA1(C)
     C                   Z-ADD     16            C
     C                   ELSE
     C                   ADD       1             C
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVEA     YA1           #1Pyama
      *
     C                   Select
      * Mt191 mapping
     C                   When      PMtpy = '191'

     C                   If        P57 <> *Blanks
     C                   Eval      DSTRAN = P57
     C                   Select
     C                   When      %Subst(TMLIN1:1:2) = '/'
     C                   Eval      #1Pthr = TMLIN2
     C                   Other
     C                   Eval      #1Pthr = TMLIN1
     C                   Endsl
     C                   Endif

     C                   Eval      DSTRAN = P58
     C                   Eval      #1Benb = TMLIN1

      * Check if the same BIC
     C                   If        %subst(#1Benb:1:8) = %subst(#1Pthr:1:8)
     C                             and %subst(#1Benb:9:3) = %subst(#1Pthr:9:3)
     C                             or
     C                             %subst(#1Benb:1:8) = %subst(#1Pthr:1:8)
     C                             and %subst(#1Benb:9:3) = 'XXX'
     C                             and %subst(#1Pthr:9:3) = *blanks
     C                             or
     C                             %subst(#1Benb:1:8) = %subst(#1Pthr:1:8)
     C                             and %subst(#1Benb:9:3) = *blanks
     C                             and %subst(#1Pthr:9:3) = 'XXX'
     C                   Eval      #1Pthr = *blanks
     C                   Endif

      * Normal mapping
     C                   Other
     C                   If        P57 <> *Blanks
     C                   Eval      DSTRAN = P57

     C                   Select
      * Clearing code
     C                   When      %Subst(TMLIN1:1:2) = '//'
     C                   Eval      #1Clcd = TMLIN1
      * Account line assumed
     C                   When      %Subst(TMLIN1:1:2) = '/'
     C                   Eval      #1Benb = TMLIN2
      * BIC assumed
     C                   Other
     C                   Eval      #1Benb = TMLIN1
     C                   EndSl
      *
      * Check if BIC Plus key has been supplied
     C                   If        %subst(#1Benb:9:3) = *Blanks
     C                   Eval      BiKey = %subst(#1Benb:1:8)
     C     KBicPV0       Chain     @BicpV0
      *
      * If found replace with Bic Address if any
     C                   Select
     C                   When      %Found and BiBic <> *blanks
     C                   Eval      #1benb = BiBic
     C                   When      %Found and BiBic = *blanks
     C                   Eval      #1Benc = %Subst(#1Benb:1:2)
     C                   Endsl
     C                   Endif
     C                   Endif
     C                   Endsl
      *
     C                   If        P71 <> *Blanks
     C                   Eval      DSTRAN = P71
     C                   Eval      #1Dtch = TMLIN1
     C                   Endif
      * Populate other fields
      * Bank code
     C                   If        P23B <> *Blanks
     C                   Eval      DSTRAN = P23B
     C                   Eval      #MoBnkc = TMLIN
     C                   Endif
     C                   If        #MoBnkc =  *Blanks
     C                   Eval      #MoBnkc = 'CRED'
     C                   Endif
      * Instruction code
     C                   If        P23E <> *Blanks
     C                   Eval      DSTRAN = P23E
     C                   Eval      #MoInsc = TMLIN
     C                   Endif
      * Transaction Type
     C                   If        P26T <> *Blanks
     C                   Eval      DSTRAN = P26T
     C                   Eval      #MoTtyp = TMLIN
     C                   Endif
      * Ordering customer
     C                   If        P50 <> *Blanks
     C                   Eval      DSTRAN = P50
     C                   Eval      #MoOrdc = TMLIN
     C                   If        %Subst(Tmlin1:1:1) = '/'
     C                   Eval      #150K  = TMLIN1
     C                   Endif
     C                   Endif
      * Ordering bank
     C                   If        P52 <> *Blanks
     C                   Eval      DSTRAN = P52
     C                   Eval      #MoOrdb = TMLIN
     C                   Endif
      * Beneficiary customer
     C                   If        P59 <> *Blanks
     C                   Eval      DSTRAN = P59
     C                   Eval      #MoBenf = TMLIN
                                                                                              ESL038
      * Fill clearing                                                                         ESL038
     C                   If        #1clcd = *Blanks and %subst(tmlin1:1:1) = '/'              ESL038
     C                   Eval      #1clcd = TMLIN1                                            ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   Endif
      * Sender to Reciever information
     C                   If        P72 <> *Blanks
     C                   Eval      DSTRAN = P72
     C                   Eval      #MoBtbi = TMLIN
     C                   Endif
      *
     C                   Endif
      *
     C                   If        P1Actc <> 'R'
     C                             and P1Actc <> 'R'
     C                   Eval      #MoBnkc = 'CRED'
      *
     C                   Endif
      *
      * Clear bottom of screen
     C                   Clear                   #1Sncr
     C                   Clear                   #1Rccr
     C                   Clear                   #1Dstr
     C                   Clear                   #1Intr
     C                   Clear                   #1Acbr
     C                   Clear                   #1Dmac
     C                   Clear                   #1Cvrr
     C                   Clear                   #1Cthr
     C                   Clear                   #1Snco
     C                   Clear                   #1Sncd
     C                   Clear                   #1Rcco
     C                   Clear                   #1Rccd
     C                   Clear                   #1Dsto
     C                   Clear                   #1Dstd
     C                   Clear                   #1Into
     C                   Clear                   #1Intd
     C                   Clear                   #1Acbo
     C                   Clear                   #1Acbd
     C                   Clear                   #1Dmao
     C                   Clear                   #1Cvro
     C                   Clear                   #1Ctho
     C                   Clear                   #1Cthd
     C                   Clear                   #1Sett
     C                   Clear                   #1StpF
     C                   Clear                   #1LvpF
     C                   Clear                   #1RegF
     C                   Clear                   #1F72
     C                   Clear                   #1RTCY
     C                   Clear                   #1RTAT
     C                   Clear                   #1RTCD
     C                   Clear                   #1HdnC
     C                   Clear                   #1R910
     C                   Clear                   #1R91o
     C                   Clear                   #1Serv
      * Process current transaction
     C     W0TRN         DOWEQ     'Y'
      * Display screen
     C                   EXSR      CAEXFM
      * Process response
     C   12              Leave
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Ignore routing
     C   07              CAS                     ZXEXPG
      * F10 to route
     C   10              CAS                     SrUpdate
      *
      * Process screen input
     C                   CAS                     DAPRSC
     C                   END
      *
     C                   END
      *
     C                   END
      *****************************************************************
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Update screen time
     C                   TIME                    ##TME
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * Enable PUTOVR
     C                   SETON                                        86
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDDTL1
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPRSC        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * USER: Process command keys
      * Validate screen input
     C                   EXSR      DBVLSC
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * USER: User defined action
      *
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBVLSC        BEGSR
      *================================================================
      * Validate screen input
      *================================================================
      *
      * Validate Branch
     C                   Clear                   W#DateCcYyMmDd                               PNL014
      *
      * If entered then validate by calling 'AOBRCHR0'
     C                   If        #1BRCA <> *blanks
      *
     C                   CALL      'AOBRCHR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      #1BRCA        P@BRCD            3
     C     SDBRCH        PARM      *BLANKS       DSFDY
      *
      * Branch does not exist
     C                   If        P@RTCD <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In49
      *
     C                   MOVEL     'CL10090'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1BRCA        ZAMSDA
     C                   EXSR      ZASNMS
      *
      * If return is different and ? then fill
     C                   Else
     C     '?'           Scan      #1BRCA                                 90
     C                   If        *In90 = *On
     C                   Eval      #1BRCA = A8BRCD
     C                   Eval      *In99 = *On
     C                   Endif                                                  FI
     C                   Endif
      *
      * Else use default branch on data area ZMUSER
     C                   Else
     C                   Eval      #1BRCA = DBRN
     C                   Endif
      *
      * Validate Settlement currency
     C                   If        #1SMCY = *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In31
      *
     C                   MOVEL     'PR10118'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1SMCY        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
      *
     C                   If        #1SMCY <> *blanks
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1SMCY        P@CCY             3            I:Currency
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
     C                   If        P@RTCD <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In31
      *
     C                   MOVEL     'PR10119'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1SMCY        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Else
      * If return is different and ? then fill
     C     '?'           Scan      #1SMCY                                 90
     C                   If        *In90 = *On
     C                   Eval      #1SMCY = A6CYCD
     C                   Eval      *In99 = *On
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      * Validate Pay currency
     C                   If        #1PCCY = *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In35
      *
     C                   MOVEL     'PR10120'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCCY        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
      *
     C                   If        #1PCCY <> *blanks
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1PCCY        P@CCY             3            I:Currency
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
     C                   If        P@RTCD <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In35
      *
     C                   MOVEL     'PR10121'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCCY        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Else
      * If return is different and ? then fill
     C     '?'           Scan      #1PCCY                                 90
     C                   If        *In90 = *On
     C                   Eval      #1PCCY = A6CYCD
     C                   Eval      *In99 = *On
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Default currencies
     C                   If        #1PCCY <> *blanks and #1SMCY = *blanks
     C                             and *In35 = *Off
     C                   Eval      #1SMCY = #1PCCY
     C                   Endif                                                  FI
      *
     C                   If        #1SMCY <> *blanks and #1PCCY = *blanks
     C                             and *In31 = *Off
     C                   Eval      #1PCCY = #1SMCY
     C                   Endif                                                  FI

      * Validate Details of charge
     C                   If        #1DTCH <> *blanks
     C                             and #1DTCH <> 'OUR'
     C                             and #1DTCH <> 'BEN'
     C                             and #1DTCH <> 'SHA'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In47
      *
     C                   MOVEL     'PR10154'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1DTCH        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI

      * Validate Pay Through
     C                   If        #1PTHR <> *blanks
     C                   Eval      W#PTHR = 'Y'
     C                   Eval      W#BICC = #1PTHR
     C                   Exsr      SRBICC
     C                   Eval      W#PTHR = *Blanks
     C                   Eval      #1PTHR = W#BICC
     C                   Endif

      * Validate Beneficiary
     C                   If        #1BENB <> *blanks
     C                   Eval      W#BENB = 'Y'
     C                   Eval      W#BICC = #1BENB
     C                   Exsr      SRBICC
     C                   Eval      W#BENB = *Blanks
     C                   Eval      #1BENB = W#BICC
     C                   Endif

      * Validate country
     C                   If        #1BENC <> *blanks

      * Get currency details
      *
     C                   CALL      'AOCTRYR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1BENC        P@CTRY            2            I:Sub-type
     C     SDCTRY        PARM      *BLANKS       DSSDY
      *
     C                   If        P@RTCD <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In39
      *
     C                   MOVEL     'PR10102'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1BENC        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Else
      * If return is different and ? then fill
     C     '?'           Scan      #1BENC                                 90
     C                   If        *In90 = *On
     C                   Eval      #1BENC = A4CNCD
     C                   Eval      *In99 = *On
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI

     C                   Eval      BiKey = %subst(#1Benb:1:8)
     C     KBicPV0       Chain     @BicpV0
      * Validate country
     C                   If        #1BENB = *blanks
     C                             And #1BENC = *blanks
     C                             And #1CLCD = *blanks
     C                             Or #1BENB <> *blanks
     C                             And #1BENC <> *blanks
     C                             And Not %Found
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In38
     C                   MOVEL     '1'           *In39
      *
     C                   MOVEL     'PR10122'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1BENC        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
      * If settlement currency valid then check amount if entered

     C                   Eval      #1SMAM = 0
     C                   If        *In31 = *Off
      * Get currency details
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1SMCY        P@CCY             3            I:Currency
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
      * Validate settle amount
     C                   Eval      #1SMAM = 0
      *
     C                   If        #1SMAMA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1SMAMA       ZFIELD
     C                   Eval      Zadig = 15 - A6NBDP
     C                   Eval      Zadec = A6NBDP
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In32
      * Send message '*Value required'
     C                   MOVEL     'PR10123'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1SMAM
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SMAM        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:7     #1SMAMA
      *
     C     #1SMAM        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In32
      * Send message '*Value required'
     C                   MOVEL     'PR10124'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      *
      * If pay currency valid then check amount if entered

     C                   Eval      #1PYAM = 0
     C                   If        *In31 = *Off
      * Get currency details
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1PCCY        P@CCY             3            I:Currency
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
      * Validate pay amount
     C                   Eval      #1PYAM = 0
      *
     C                   If        #1PYAMA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1PYAMA       ZFIELD
     C                   Eval      Zadig = 15 - A6NBDP
     C                   Eval      Zadec = A6NBDP
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In36
      * Send message '*Value required'
     C                   MOVEL     'PR10125'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1PYAM
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PYAM        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:7     #1PYAMA
      *
     C     #1PYAM        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In36
      * Send message '*Value required'
     C                   MOVEL     'PR10126'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
     C     #1SMAM        IFLE      0                                            IF
     C     #1PYAM        ANDLE     0
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In32
     C                   MOVEL     '1'           *In36
      * Send message '*Value required'
     C                   MOVEL     'PR10200'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
      *
      * Validate rate
     C                   Eval      #1RATE = 0
      *
     C                   If        #1RATEA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1RATEA       ZFIELD
     C                   Eval      Zadig = 7
     C                   Eval      Zadec = 8
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In34
      * Send message '*Value required'
     C                   MOVEL     'PR10127'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        W3FLD15
     C                   Move      ZFIELD        #1RATE
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      8             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:7     #1RATEA
      *
     C     #1RATE        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In34
      * Send message '*Value required'
     C                   MOVEL     'PR10128'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
                                                                                              ESL038
      * Validate IBAN if more than 15 characters                                              ESL038
     C                   If        %subst(#1Clcd:15:20) <> *blanks                            ESL038
                                                                                              ESL038
     C                   Clear                   U#Iban            1                          ESL038
     C                   Eval      P@Iban = %subst(#1Clcd:2:34)                               ESL038
      *                                                                                       ESL038
     C                   Call      'AOIBANR5'                           90                    ESL038
     C                   Parm      *Blanks       P@Return          7                          ESL038
     C                   Parm                    P@IBAN           34                          ESL038
      *                                                                                       Djb004
      * If beneficiary bank then set as ok                                                    Djb004
     C                   If        #1benb <> *blanks and                                      Djb004
     C                             %subst(#1Clcd:15:20) <> *blanks                            Djb004
     C                   Eval      U#Iban = 'Y'                                               Djb004
     C                   Endif                                                                Djb004
      *                                                                                       ESL038
     C                   If        P@Return <> *blanks                                        ESL038
     C****               SETON                                        99        *       ESL038Djb004
     C                   MOVEL     '1'           *In48                                        ESL038
      * Send message '*Value required'                                                        ESL038
     C                   MOVEL     'PR10426'     ZAMSID                                       ESL038
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       ESL038
     C                   EXSR      ZASNMS                                                     ESL038
     C                   Else                                                                 ESL038
     C                   Eval      U#Iban = 'Y'                                               ESL038
     C                   Endif                                                                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   If        P1Actc <> 'R'                                              ESL038
      * If return is different and ? then fill                                                ESL038
     C     '?'           Scan      #150K                                  90                  ESL038
     C                   If        *In90 = *On                                                ESL038
     C                   Eval      *In99 = *On                                                ESL038
     C                   Eval      ActionCode = 'S'                                           ESL038
      *                                                                                       ESL038
     C                   Clear                   O4parm                                       ESL038
     C                   Eval      O4iban = %subst(#150k:2:33)                                ESL038
     C                   Eval      O4Pccy = #1Pccy                                            ESL038
     C                   Eval      O4Ref1 = #1Benb                                            ESL038
      *                                                                                       ESL038
     C                   CALL      'FTP1150'                                                  ESL038
     C                   PARM                    O4RTN             7                          ESL038
     C                   PARM                    ActionCode        1                          ESL038
     C                   PARM                    O4Parm                                       ESL038
      *                                                                                       ESL038
      **   If data selected then show on screen                                               ESL038
      *                                                                                       ESL038
     C                   If        O4RTN = 'Selectd'                                          ESL038
     C                   Eval      #MoBtbi = '/CSPRT/' + O4Ref1 + O4Ref2                      ESL038
     C                   Eval      #150K   = O4Iban                                           ESL038
     C****  ?????????????????????????????????????????????????????                             ESL038
     C                   Endif                                                  FI            ESL038
     C                   Endif                                                  FI            ESL038
     C                   Endif                                                                ESL038
      *
      * Cross Validations
      *
     C                   IF        *In99 = '0'
     C                   EXSR      SRXVAL
     C                   END

      * Validate Clearing Code
     C                   If        CFT007 = 'Y' and *In99 = '0'
     C                             and #1CLCD <> *Blanks
                                                                                              ESL038
     C                   Clear                   P7Rtn                                        ESL038
     C                   If        #1ClCd <> *blanks                                          ESL038
     C                             and #1Benb = *blanks                                       ESL038
     C                             and %Subst(#1Clcd:1:1) = '/'                               ESL038
      * Parameters                                                                            ESL038
     C                   Eval       P7Benb = #1Benb                                           ESL038
     C                   Eval       P7Benc = #1Benc                                           ESL038
     C                   Eval       P7Clcd = #1Clcd                                           ESL038
     C                   Eval       P7Iban = U#Iban                                           ESL038
      * If clearing code then preprocess                                                      ESL038
     C                   Call      'FTP0706'                                                  ESL038
     C                   PARM                    P7RTN             7                          ESL038
     C                   PARM                    P7Parm                                       ESL038
     C                   PARM                    O7Parm                                       ESL038
     C                   Select                                                               ESL038
     C                   When      P7rtn = '*FBic'                                            ESL038
     C                   Eval      #1Benb = O7Benb                                            ESL038
     C                   Clear                   #1Benc                                       ESL038
     C                   When      P7rtn = '*FBkey'                                           ESL038
     C                   Eval      #1Benb = O7Benb                                            ESL038
     C                   Endsl                                                                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   If        P7rtn <> '*FBic' and                                       ESL038
     C                             U#Iban <> 'Y' and                                          ESL038
     C                             P7rtn <> '*FBkey'                                          ESL038
     C                   MOVE      'P'           PIMODE
     C                   MOVE      #1CLCD        PICRIT
      *
     C                   CALL      'FTP0716'
     C                   PARM                    PIMODE            1
     C                   PARM                    PICRIT           35
     C                   PARM      *BLANKS       POADD           175
     C                   PARM      *BLANKS       POCHIP           10
     C                   PARM      *BLANKS       POUTCD            2
     C                   PARM      *BLANKS       PBICP
     C                   PARM      *BLANKS       PRTCD             7
      *
     C                   MOVEL     *BLANKS       PICRIT
      * Exit
     C                   IF        PRTCD = 'F3'
     C                   EXSR      ZXEXPG
     C                   ENDIF
      *
      * Previous
     C                   IF        PRTCD = 'F12'
     C                   GOTO      DBEXIT
     C                   ENDIF
      *
      * Return data
     C                   IF        PRTCD = *BLANKS
      *
      * If valid BIC code then default
     C                   Select
     C     POUTCD        Wheneq    'A'
     C                   EVAL      #1CLCD = *Blanks
     C                   EVAL      #1BENB = OADD1
     C                   EVAL      #1BENC = *Blanks
     C     POUTCD        Wheneq    'AC'
     C                   EVAL      #1CLCD = OADD1
     C                   EVAL      #1BENB = OADD2
     C                   EVAL      #1BENC = *Blanks
      * Else country default
     C                   Other
     C                   IF        POUTCD = 'C' or POUTCD = 'DC'
     C                   EVAL      #1CLCD = OADD1
     C                   ELSE
     C                   EVAL      #1CLCD = *Blanks
     C                   ENDIF
     C                   EVAL      #1BENB = *Blanks
     C                   EVAL      #1BENC = PCTRY
     C                   Endsl
      *
     C                   ENDIF
      *
     C                   Endif
     C                   Endif                                                                ESL038

      * Validate Receivers Correspondent
     C                   If        #1RCCO <> *blanks and #1RCCO <> '*'
     C                   Eval      W#RCCO = 'Y'
     C                   Eval      W#BICC = #1RCCO
     C                   Exsr      SRBICC
     C                   Eval      W#RCCO = *Blanks
     C                   Eval      #1RCCO = W#BICC
     C                   Endif

      * Validate Destination/Receiver
     C                   If        #1DSTO <> *blanks
     C                   Eval      W#DSTO = 'Y'
     C                   Eval      W#BICC = #1DSTO
     C                   Exsr      SRBICC
     C                   Eval      W#DSTO = *Blanks
     C                   Eval      #1DSTO = W#BICC
     C                   Endif

      * Validate Intermediary
     C                   If        #1INTO <> *blanks and #1INTO <> '*'
     C                   Eval      W#INTO = 'Y'
     C                   Eval      W#BICC = #1INTO
     C                   Exsr      SRBICC
     C                   Eval      W#INTO = *Blanks
     C                   Eval      #1INTO = W#BICC
     C                   Endif

      * Validate A/c With Institution
     C                   If        #1ACBO <> *blanks
     C                   Eval      W#ACBO = 'Y'
     C                   Eval      W#BICC = #1ACBO
     C                   Exsr      SRBICC
     C                   Eval      W#ACBO = *Blanks
     C                   Eval      #1ACBO = W#BICC
     C                   Endif

      * Validate Destination A/c
     C                   If        #1DMAO <> *blanks
     C                   Eval      W#DMAO = 'Y'
     C                   Eval      W0Account = #1DMAO
     C                   Exsr      SrAccount
     C                   Eval      W#DMAO = *Blanks
     C                   Endif

      * Validate Cover Required
     C                   If        #1CVRO <> *blanks and #1CVRO <> 'Y' and
     C                             #1CVRO <> 'N'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In45
      * Send message '*Value required'
     C                   MOVEL     'PR10151'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif

      * Validate Cover Through
     C                   If        #1CVRO = 'Y'
     C                   If        #1CTHO = *Blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In46
      * Send message '*Value required'
     C                   MOVEL     'PR10152'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else
     C                   Eval      W#CTHO = 'Y'
     C                   Eval      W0Account = #1CTHO
     C                   Exsr      SrAccount
     C                   Eval      W#CTHO = *Blanks
     C                   Endif
     C                   Endif
      *
     C                   If        #1CVRO = 'N' and #1CTHO <> *Blanks
     C                             or #1CVRO = *Blanks and #1CTHO <> *Blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In46
      * Send message '*Value required'
     C                   MOVEL     'PR10153'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif
                                                                                              PNL014
      * Validate date                                                                         PNL014
     C                   If        #1VDat <> *blanks                                          PNL014
      *                                                                                       PNL014
      *  Check that date is numeric                                                           PNL014
      *                                                                                       PNL014
     C     Digits        Check     #1Vdat        ##005N            5 0    90                  PNL014
      *                                                                                       PNL014
      *  Convert date to Midas Day no.                                                        PNL014
      *                                                                                       PNL014
     C                   If        *In90 = *Off                                 Valid date    PNL014
     C                   Movel     #1Vdat        W2DATE                                       PNL014
     C                   CALL      'ZDATE1'                             90                    PNL014
     C                   PARM      *BLANKS       P@RTCD                         Return code   PNL014
     C                   PARM                    W2DATE            6 0          Date          PNL014
     C                   PARM      WUDFF         W2DTFM            1            Date Format   PNL014
     C                   PARM                    W2DAYN            5 0          Day No.       PNL014
     C                   ELse                                                                 PNL014
     C                   Eval      P@RTCD = '*NUM'                                            PNL014
     C                   Endif                                                                PNL014
      *                                                                                       PNL014
     C                   If        P@RTCD <> *Blanks                                          PNL014
      * Send message '*No data to display'                                                    PNL014
     C                   MOVEL     'PR23017'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           *In53                                        PNL014
     C                   Eval      *In99 = *On                                                PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Else                                                                 PNL014
     C                   Eval      ZDayNbr = W2DAYN                                           PNL014
                                                                                              PNL014
      * Get Midas date as CcYyMmDd                                                            PNL014
     C                   Call      'ZM0065'                                                   PNL014
     C                   Parm      ZDayNbr       ZMDay                                        PNL014
     C                   Parm      *blanks       ZSDate                                       PNL014
     C                   Parm      *blanks       ZSDatc                                       PNL014
      *                                                                                       PNL014
     C                   Eval      W#DateCcYyMmDd = ZSDatc                                    PNL014
     C                   Endif                                                                PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014

      * Bypass ref file checks if error already detected
     C   99              GOTO      DBEXIT
      *
     C                   Movel     *on           *In75
     C                   Movel     *off          *In76
     C                   Eval      *In77 = *On
     C                   Eval      *In78 = *On
     C                   Eval      *In79 = *Off
     C                   Movel     ##Cmda        ##CMD2
      *
      * Call routing process
     C                   EXSR      SRRoute
      *
      * Call expansion process
     C                   EXSR      SRExpand
      * USER: Validate relations
      *
      *================================================================
     CSR   DBEXIT        ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRBICC   : Validate BIC                                      *
      *                                                               *
      *================================================================
     CSR   SRBICC        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRBICC'      @STK(Q)
      *
     C     *Like         Define    #1PTHR        W#BICC
      *
      * Define key
     C     KBICD         Klist
     C                   Kfld                    BDBICC
     C                   Kfld                    BDBICB
      *
      * Define key
     C     KBicPV0       Klist
     C                   Kfld                    BIKEY
      *
      * Check if BIC Plus key has been supplied
     C                   If        %subst(W#BICC:9:3) = *Blanks
     C                   Eval      BiKey = %subst(W#BICC:1:8)
     C     KBicPV0       Chain     @BicpV0
      *
      * If found replace with Bic Address if any
     C                   Select
     C                   When      %Found and BiBic <> *blanks
     C                   Eval      W#Bicc = BiBic
     C                   When      %Found and BiBic = *blanks
     C                             and #1Benc = *blanks
     C                             and W#benb = 'Y'
     C                   Eval      #1Benc = %Subst(W#Bicc:1:2)
     C                   Goto      ExBicc
     C                   When      %Found and BiBic = *blanks
     C                             and #1Benc = %Subst(W#Bicc:1:2)
     C                             and W#benb = 'Y'
     C                   Goto      ExBicc
     C                   When      %Found and BiBic = *blanks
     C                             and W#Acbr = 'Y'
     C                   Eval      #1Acbd = %Subst(BIINST:1:35)
     C                   Goto      ExBicc
     C                   Endsl
     C                   Endif
      *
      * Set key
     C                   Eval      BDBICC = %subst(W#BICC:1:8)
     C                   Eval      BDBICB = %subst(W#BICC:9:3)
      *
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   Select
     C                   When      Not %Found and BDBICB = *blanks
     C                   Eval      BDBICB = 'XXX'
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        Not %Found
     C                   Select
     C                   When      W#PTHR = 'Y'
     C                   Seton                                        9937      *
     C                   When      W#BENB = 'Y'
     C                   Seton                                        9938      *
     C                   When      W#RCCO = 'Y'
     C                   Seton                                        9940      *
     C                   When      W#DSTO = 'Y'
     C                   Seton                                        9941      *
     C                   When      W#INTO = 'Y'
     C                   Seton                                        9942      *
     C                   When      W#ACBO = 'Y'
     C                   Seton                                        9943      *
     C                   Endsl
      *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10031'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = BDBICB + BDBICB
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
     C                   Move      'XXX'         W#BICC
     C                   Endif                                                  FI
     C                   When      Not %Found
     C                   Select
     C                   When      W#PTHR = 'Y'
     C                   Seton                                        9937      *
     C                   When      W#BENB = 'Y'
     C                   Seton                                        9938      *
     C                   When      W#RCCO = 'Y'
     C                   Seton                                        9940      *
     C                   When      W#DSTO = 'Y'
     C                   Seton                                        9941      *
     C                   When      W#INTO = 'Y'
     C                   Seton                                        9942      *
     C                   When      W#ACBO = 'Y'
     C                   Seton                                        9943      *
     C                   Endsl
      *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10031'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = BDBICB + BDBICB
     C                   EXSR      ZASNMS
     C                   When      %Found
     C                   Endsl
      *
      *  Unwind subroutine stack name
      *
     C     EXBICC        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
      /EJECT
      *================================================================
      *                                                               *
      *  SRXVAL   : Validate Cross Validations                        *
      *                                                               *
      *================================================================
     CSR   SRXVAL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRXVAL'      @STK(Q)
      *
      *  Unwind subroutine stack name
      *
     C     EXXVAL        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
      /EJECT
      *================================================================
      *                                                               *
      *  SRAccount: Validate Account                                  *
      *                                                               *
      *================================================================
     CSR   SRAccount     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRAccount'   @STK(Q)
      *
      * Check for IBAN account
      *
     C                   Call      'AOIBANR4'
     C                   PARM      *blanks       P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM      W0Account     P@IBAN           34            I:Retail key
     C     ACCNT         PARM                    DSSDY                          O:OUTPUT
      *
     C                   If        P@RTCD = *blanks and ACRECI = 'D'
      *
     C                   Eval      W0Brca = ACBrca
     C                   Eval      W0Cnum = ACCnum
     C                   Eval      W0Ccy  = ACCcy
     C                   Eval      W0Acod = ACAcod
     C                   Eval      W0Acsq = ACAcsq
     C                   Eval      W0Acno = ACAcno
      *
     C                   Else
      *
     C     29            SUBST     W0Account:6   ##0029a          29
      *
     C     24            SUBST     W0Account:11  ##0024a          24
      *
     C     16            SUBST     W0Account:19  ##0016a          16
      * Setup key
     C                   select
     C                   When      ##0029a = *blanks
      *
     C     3             Subst     W0Account:1   P@CYCD
     C     2             Subst     W0Account:4   P@NONB
      *
     C                   Call      'AONOSTR0'
     C                   PARM      *Blanks       P@RTCD            7            B:Return code
     C                   PARM      '*KEY'        P@OPTN            7            I:Option
     C                   PARM      *blanks       P@CUST            6            I:Customer No
     C                   PARM                    P@CYCD            3            I:Currency
     C*****              PARM      *blanks       P@ACCD            4            I:A/c Code  AR856737
     C                   PARM      *blanks       P@ACCD           10            I:A/c Code  AR856737
     C                   PARM      *blanks       P@ACSN            2            I:A/c Seq
     C                   PARM                    P@NONB            2            I:Nostro No
     C                   PARM      *blanks       P@BRCD            3            I:Branch Code
     C                   PARM      *blanks       P@CSSN           10            I:Cust ShortN
     C                   PARM      *blanks       P@PNOI            1            I:Prime Nost In
     C     SDNOST        PARM                    DSSDY                          O:Format
      *
     C                   If        P@RTCD = *blanks
     C                   Movel     A7Cust        P@CNUM
     C                   Movel     A7cycd        P@CUCD
     C                   Movel     A7Accd        P@ACCD
     C                   Movel     A7Acsn        P@ACSQ
     C                   Movel     A7Brcd        P@BRCA
      *
      *  Call to access pgm for Accounts
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      *blanks       P@RETL           10            I:Retail key
     C                   PARM                    P@CNUM            6            I:Key field 1
     C                   PARM                    P@CUCD            3            I:Key field 2
     C*****              PARM                    P@ACCD            4          I:Key field 3 AR856737
     C                   PARM                    P@ACCD                         I:Key field AR856737
     C                   PARM                    P@ACSQ            2            I:Key field 4
     C                   PARM                    P@BRCA            3            I:Key field 5  S0111
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C     ACReci        Andeq     'D'
      *
     C                   Eval      W0Brca = ACBrca
     C                   Eval      W0Cnum = ACCnum
     C                   Eval      W0Ccy  = ACCcy
     C                   Eval      W0Acod = ACAcod
     C                   Eval      W0Acsq = ACAcsq
     C                   Eval      W0Acno = ACAcno
      *
     C                   Else
     C                   Select
     C                   When      W#DMAO = 'Y'
     C                   SETON                                        9944      *
     C                   When      W#CTHO = 'Y'
     C                   SETON                                        9946      *
     C                   Endsl
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Else
     C                   Select
     C                   When      W#DMAO = 'Y'
     C                   SETON                                        9944      *
     C                   When      W#CTHO = 'Y'
     C                   SETON                                        9946      *
     C                   Endsl
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   When      ##0024a = *blanks
     C     10            SUBST     W0Account:1   P@Retl
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@RETL           10            I:Retail key
     C                   PARM      *blanks       P@CNUM            6            I:Key field 1
     C                   PARM      *blanks       P@CUCD            3            I:Key field 2
     C*****              PARM      *blanks       P@ACCD            4          I:Key field 3 AR856737
     C                   PARM      *blanks       P@ACCD                         I:Key field AR856737
     C                   PARM      *blanks       P@ACSQ            2            I:Key field 4
     C                   PARM      *blanks       P@BRCA            3            I:Key field 5
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C     ACReci        Andeq     'D'
      *
     C                   Eval      W0Brca = ACBrca
     C                   Eval      W0Cnum = ACCnum
     C                   Eval      W0Ccy  = ACCcy
     C                   Eval      W0Acod = ACAcod
     C                   Eval      W0Acsq = ACAcsq
     C                   Eval      W0Acno = ACAcno
      *
     C                   Else
     C                   Select
     C                   When      W#DMAO = 'Y'
     C                   SETON                                        9944      *
     C                   When      W#CTHO = 'Y'
     C                   SETON                                        9946      *
     C                   Endsl
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   When      ##0016a = *blanks
     C     6             SUBST     W0Account:1   P@CNUM
     C     3             SUBST     W0Account:7   P@CUCD
     C     4             SUBST     W0Account:10  P@ACCD
     C     2             SUBST     W0Account:14  P@ACSQ
     C     3             SUBST     W0Account:16  P@BRCA
      *
      *  Call to access pgm for Accounts
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      *blanks       P@RETL           10            I:Retail key
     C                   PARM                    P@CNUM            6            I:Key field 1
     C                   PARM                    P@CUCD            3            I:Key field 2
     C*****              PARM                    P@ACCD            4          I:Key field 3 AR856737
     C                   PARM                    P@ACCD                         I:Key field AR856737
     C                   PARM                    P@ACSQ            2            I:Key field 4
     C                   PARM                    P@BRCA            3            I:Key field 5  S0111
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C     ACReci        Andeq     'D'
      *
     C                   Eval      W0Brca = ACBrca
     C                   Eval      W0Cnum = ACCnum
     C                   Eval      W0Ccy  = ACCcy
     C                   Eval      W0Acod = ACAcod
     C                   Eval      W0Acsq = ACAcsq
     C                   Eval      W0Acno = ACAcno
      *
     C                   Else
     C                   Select
     C                   When      W#DMAO = 'Y'
     C                   SETON                                        9944      *
     C                   When      W#CTHO = 'Y'
     C                   SETON                                        9946      *
     C                   Endsl
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Other
     C                   Select
     C                   When      W#DMAO = 'Y'
     C                   SETON                                        9944      *
     C                   When      W#CTHO = 'Y'
     C                   SETON                                        9946      *
     C                   Endsl
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endsl

     C                   Endif

      * Account currency must equal payment currency
     C                   If        W0Ccy <> #1PCCY
      * Send message 'Invalid account'
     C                   Select
     C                   When      W#DMAO = 'Y'
     C                   SETON                                        9944      *
     C                   When      W#CTHO = 'Y'
     C                   SETON                                        9946      *
     C                   Endsl
     C                   MOVEL     'PR10081'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Ccy         ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *================================================================
      *
      *  Unwind subroutine stack name
      *
     C     EXAccount     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR

     C/EJECT
      *================================================================
      *                                                               *
      *  SRRoute  : Routing Process                                   *
      *                                                               *
      *================================================================
     CSR   SRRoute       BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRoute'     @STK(Q)
      *
      *  Call Routing program
      *
     C                   Clear                   MROTDS
      *
     C                   Eval      MoReci = 'D'
     C                   Eval      MoBrca = #1Brca
     C                   Eval      MoSmcy = #1Smcy
     C                   Eval      MoSmam = #1Smam
     C                   Eval      MoFxsp = #1Fxsp
     C                   Eval      MoRate = #1Rate
     C                   Eval      MoPccy = #1Pccy
     C                   Eval      MoPyam = #1Pyam
     C                   Eval      MoPthr = #1Pthr
     C                   Eval      BiKey = %subst(#1Benb:1:8)
      *********
      **Only*fill if not a BIC Plus key
     C*****KBicPV0       Chain     @BicPV0
     C*********          If        Not %Found
     C                   Eval      MoBenb = #1Benb
     C*********          Endif

     C                   Eval      MoBenc = #1Benc
     C                   Eval      MoSncr = #1Sncr
     C                   Eval      MoSnco = #1Snco
     C                   Eval      MoRccr = #1Rccr
     C                   Eval      MoRcco = #1Rcco
     C                   Eval      MoDstr = #1Dstr
     C                   Eval      MoDsto = #1Dsto
     C                   Eval      MoIntr = #1Intr
     C                   Eval      MoInto = #1Into
     C                   Eval      MoAcbr = #1Acbr
     C                   Eval      MoAcbo = #1Acbo
     C                   Eval      MoDmac = #1Dmac
     C                   Eval      MoDmao = #1Dmao
     C                   Eval      MoCvrr = #1Cvrr
     C                   Eval      MoCvro = #1Cvro
     C                   Eval      MoCthr = #1Cthr
     C                   Eval      MoCtho = #1Ctho
     C                   Eval      MoDtch = #1Dtch
     C                   Eval      MoAcbd = #1Acbd
     C                   Eval      MoR910 = #1R910
      * Fill extra fields
     C                   Eval      MoBnkc = #MoBnkc
     C                   Eval      MoInsc = #MoInsc
     C                   Eval      MoTtyp = #MoTtyp
     C                   If        P1Actc <> 'R'
     C                   Eval      MoOrdc = #150K
     C                   Else
     C                   Eval      MoOrdc = #MoOrdc
     C                   Endif
     C                   Eval      MoOrdb = #MoOrdb
     C                   If        P1Actc <> 'R'
     C                   Eval      MoBenf = #1Clcd
     C                   Else
     C                   Eval      MoBenf = #MoBenf
     C                   Endif
     C                   Eval      MoBtbi = #MoBtbi
     C                   Eval      MoVDat = W#DateCcYyMmDd                                    PNL014
                                                                                              DJBF15
      * Save before call                                                                      DJBF15
     C                   Eval      SMrotds = Mrotds                                           DJBF15
      *
     C                   Clear                   O2Parm
     C                   Eval      O2Pgm  = ##Pgm
      *
      * Set Value Date if Routed                                                              MM0505
     C                   Z-Add     0             MVDATE                                       MM0505
     C                   If        P1Actc = 'R'                                               MM0505
      *                                                                                       MM0505
     C                   CLEAR                   DSTRAN                                       MM0505
     C                   Movel     PDCA          DSTRAN                                       MM0505
     C                   Movel     TVVDAT        @VDATE                                       MM0505
     C                   Movel     @YY           @@Y                                          MM0505
     C                   Movel     @DD           @@D                                          MM0505
     C                   Movel     @@DATE        ZDATIN                                       MM0505
      *                                                                                       MM0505
     C                   CallB     'ZDATE1'                                                   MM0505
     C                   Parm                    ZDATIN                                       MM0505
     C                   Parm      0             ZDAYNO                                       MM0505
     C                   Parm      'D'           BJDFIN            1                          MM0505
     C                   Parm      ' '           ZERR                                         MM0505
      *                                                                                       MM0505
     C                   Z-Add     ZDAYNO        MVDATE                                       MM0505
      *                                                                                       MM0505
     C                   Endif                                                                MM0505
      *                                                                                       HVB003
     C                   Eval      MoMsgr = PhMsgr                                            HVB003
     C                   If        PhPart <> 0                                                HVB003
     C                   Eval      MoKprt = PhPart                                            HVB003
     C                   Else                                                                 HVB003
     C                   Z-Add     1             MoKprt                                       HVB003
     C                   Endif                                                                HVB003
      *
     C                   CALL      'FTP0715'                            9090
     C                   PARM                    P0RTN             7
     C                   PARM      'R'           P0Action          1
     C                   PARM                    O2Parm
     C                   PARM                    MROTDS
     C                   PARM                    MVDATE                                       MM0505
      *
     C                   If        P0Rtn  <> 'Route'
     C                   Eval      MoBenb = #1Benb
      * Restore before call                                                                   DJBF15
     C                   Eval      Mrotds = SMrotds                                           DJBF15
     C                   Endif
     C                   If        P0Rtn  = 'Route'
                                                                                              PNL014
      *                                                                                       PNL014
     C                   If        MoRRef <> *blanks                                          PNL014
      *                                                                                       PNL014
     C                   MOVEL     'PR23018'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   MOVEL     MoRRef        ZAMSDA                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
      *                                                                                       PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   Eval      #1Reci = MoReci
     C                   Eval      #1Smcy = MoSmcy
     C                   Eval      #1Smam = MoSmam
     C                   Eval      #1Fxsp = MoFxsp
     C                   Eval      #1Rate = MoRate
     C                   Eval      #1Pccy = MoPccy
     C                   Eval      #1Pyam = MoPyam
     C                   Eval      #1Pthr = MoPthr

     C                   Eval      BiKey = %subst(#1Benb:1:8)

      * Only fill is not a BIC Plus key
     C     KBicPV0       Chain     @BicPV0
     C                   Select
     C                   When      Not %Found
     C                   Eval      #1Benb = MoBenb
     C                   When      %Found and MoBenb = *blanks
     C                   Eval      MoBenb = #1Benb
     C                   Other
     C                   Eval      #1Benb = MoBenb
     C                   Endsl

     C                   Eval      #1Benc = MoBenc
     C                   Eval      #1Sncr = MoSncr
     C                   Eval      #1Snco = MoSnco
     C                   Eval      #1Rccr = MoRccr
     C                   Eval      #1Rcco = MoRcco
     C                   Eval      #1Dstr = MoDstr
     C                   Eval      #1Dsto = MoDsto
     C                   Eval      #1Intr = MoIntr
     C                   Eval      #1Into = MoInto
     C                   Eval      #1Acbr = MoAcbr
     C                   Eval      #1Acbo = MoAcbo
     C                   Eval      #1Dmac = MoDmac
     C                   Eval      #1Dmao = MoDmao
     C                   Eval      #1Cvrr = MoCvrr
     C                   Eval      #1Cvro = MOCvro
     C                   Eval      #1Cthr = MOCthr
     C                   Eval      #1Ctho = MOCtho
     C                   Eval      #1Dtch = MODtch
     C                   Eval      #1Acbd = MOAcbd
     C                   Eval      #1Sett = MOSett
     C                   Eval      #1Stpf = MOStpf
     C                   Eval      #1Lvpf = MOLvpf
     C                   Eval      #1Regf = MORegf
     C                   Eval      #1F72  = MOBtbI
     C                   Eval      #1R910 = MOR910
     C                   Eval      #1R91o = MOR91o
     C                   Eval      #1Serv = %Subst(MoPvas:1:3)
                                                                                              PNL014
      * Format date                                                                           PNL014
     C                   Select                                                               PNL014
     C                   When      WuDff = 'M'                                                PNL014
     C                   Eval      #1VDat = %Subst(MoCDat:5:2) +                              PNL014
     C                                      %Subst(MoCDat:7:2) +                              PNL014
     C                                      %Subst(MoCDat:3:2)                                PNL014
     C                   When      WuDff = 'D'                                                PNL014
     C                   Eval      #1VDat = %Subst(MoCDat:7:2) +                              PNL014
     C                                      %Subst(MoCDat:5:2) +                              PNL014
     C                                      %Subst(MoCDat:3:2)                                PNL014
     C                   Endsl                                                                PNL014
      *
     C                   Eval      #1RTCY = MOPCCY
      *
      * Get message details for Hidden Charges
      *
     C     KIndts2a      KLIST
     C                   Kfld                    DSMSGR
     C                   Kfld                    DSPART
     C                   Kfld                    DSMTG
     C                   Kfld                    DSMSEQ                                     AR856737
     C                   Kfld                    DSSEQN
      *
     C     KIndts2b      KLIST
     C                   Kfld                    DSMSGR
     C                   Kfld                    DSPART
     C                   Kfld                    DSMTG
      * Default for hidden charge is N
     C                   Eval      MoHdnC = 'N'
      *
      * Set up key
     C                   If        MoPccy = 'USD' and MoDtch = 'SHA'                          EEE065
     C                   Eval      DSMSGR = PhMSGR
     C                   Eval      DSPART = PhPart
     C                   If        DSPART = 0
     C                   Eval      DSPART = 1
     C                   Endif
     C                   Eval      DSMTG  = ':71I:'
     C                   Eval      DSSEQN = 0
     C                   Eval      DSMSEQ = *Blanks                                         AR856737
      * Reset found indicators
     C                   Movel     *OFF          *In01
     C                   Movel     *OFF          *In02
      *
     C     KIndts2a      Setll     Meindts2
     C     KIndts2b      Reade     Meindts2                               90
      * If found check for 71i, hidden charge
     C                   If        *in90 = *off
      * Hidden charge|
     C                   Eval      MoHdnC = 'Y'
     C                   Endif
     C                   Endif                                                                EEE065
      *
     C                   Eval      #1HdnC = MOHdnc
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1RTCY        P@CCY             3            I:Currency
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
     C                   If        #1Lvpf = 'Y'
     C                   Eval      #1RTCD = MOLvpC
      *
      * Reformat for screen
      *
     C                   Move      MoLvpa        W3FLD15
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     10            Subst     W3OUT21:12    #1RTAT

     C                   Else
     C                   Eval      #1RTCD = MOStdC
      *
      * Reformat for screen
      *
     C                   Move      MoStda        W3FLD15
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     10            Subst     W3OUT21:12    #1RTAT

     C                   Endif
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     EXRoute       TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRExpand : Expansion Process                                 *
      *                                                               *
      *================================================================
     CSR   SRExpand      BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRExpand'    @STK(Q)
      *
      *  Expand Senders Correpondent
     C                   If        #1Sncr <> *Blanks
     C                   Eval      W#BICC = #1Sncr
     C                   Exsr      SRBICC
     C                   Eval      #1Sncd = BDINS1
     C                   Endif
      *
      *  Expand Receivers Correpondent
     C                   If        #1Rccr <> *Blanks
     C                   Eval      W#BICC = #1Rccr
     C                   Exsr      SRBICC
     C                   Eval      #1Rccd = BDINS1
     C                   Endif
      *
      *  Expand Destination/Receiver
     C                   If        #1Dstr <> *Blanks
     C                   Eval      W#BICC = #1Dstr
     C                   Exsr      SRBICC
     C                   Eval      #1Dstd = BDINS1
     C                   Endif
      *
      *  Expand Intermediary
     C                   If        #1Intr <> *Blanks
     C                   Eval      W#BICC = #1Intr
     C                   Exsr      SRBICC
     C                   Eval      #1Intd = BDINS1
     C                   Endif
      *
      *  Expand A/C With Institution
     C                   If        #1Acbr <> *Blanks
     C                   Eval      W#Acbr = 'Y'
     C                   Eval      #1Acbd = *blanks
     C                   Eval      W#BICC = #1Acbr
     C                   Exsr      SRBICC
     C                   Eval      #1Acbd = BDINS1
     C                   Eval      W#Acbr = *blanks
     C                   Endif
      *
      *  Expand Cover Through
     C                   If        #1Cthr <> *Blanks
     C                   Eval      W0Account = #1Cthr
     C                   Exsr      SrAccount
     C                   Eval      #1Cthd = AcAnam
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     EXExpand      TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRUpdate : Update if preferential                            *
      *                                                               *
      *================================================================
     CSR   SRUpdate      BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRUpdate'    @STK(Q)
      * Set up OP routing data if overriden
     C     #1SNCO        Ifne      *Blanks
     C                   Eval      MOSNCO = #1SNCO
     C                   Endif
      *
     C     #1RCCO        Ifne      *Blanks
     C                   Eval      MORCCO = #1RCCO
     C                   Endif
      *
     C     #1DSTO        Ifne      *Blanks
     C                   Eval      MODSTO = #1DSTO
     C                   Endif
      *
     C     #1INTO        Ifne      *Blanks
     C                   Eval      MOINTO = #1INTO
     C                   Endif
      *
     C     #1ACBO        Ifne      *Blanks
     C                   Eval      MOACBO = #1ACBO
     C                   Endif
      *
     C     #1DMAO        Ifne      *Blanks
     C                   Eval      MODMAO = #1DMAO
     C                   Endif
      *
     C     #1CVRO        Ifne      *Blanks
     C                   Eval      MOCVRO = #1CVRO
     C                   Endif
      *
     C     #1CTHO        Ifne      *Blanks
     C                   Eval      MOCTHO = #1CTHO
     C                   Endif
      *
     C     #1R91o        Ifne      *Blanks
     C                   Eval      MOR91o = #1R91o
     C                   Endif
      *
      * Update for preferential correspondent
     C                   If        O2PCOR = 'Y'
     C                             Or
     C                             O2PLBen = 'Y' or
     C                             O2PLSha = 'Y' or
     C                             O2PLOur = 'Y'
      * Define keys
     C     KMsccV0       KLIST
     C                   KFLD                    MCBICC
     C                   KFLD                    MCBICB
     C                   KFLD                    MCPCCY
      * Set and get data
     C                   Eval      MCBICC = O2BICC
     C                   Eval      MCBICB = O2BICB
     C                   Eval      MCPCCY = O2PCCY
     C     KMsccV0       Chain     @MsccV0
     C                   If        %Found
     C                   Select
      * Low value preferential Ben
     C                   When      O2PLBen = 'Y'
     C                   Eval      McSpBn = McSpBn + 1
      * Low value preferential Sha
     C                   When      O2PLSha = 'Y'
     C                   Eval      McSpSn = McSpSn + 1
      * Low value preferential Our
     C                   When      O2PLOur = 'Y'
     C                   Eval      McSpOn = McSpOn + 1
      * Preferential LVP
     C                   When      O2PLvp = 'Y'
     C                   Eval      McPlnb = McPlnb + 1
      * Preferential Regulated
     C                   When      O2PReg = 'Y'
     C                   Eval      McPrnb = McPrnb + 1
     C                   Other
      * Preferential Routing
     C                   Eval      McPnbr = McPnbr + 1
     C                   Endsl
     C                   Update    @MsccV0
     C                   Endif
      * Full key
     C     KMscpV0       KLIST
     C                   KFLD                    MPBICC
     C                   KFLD                    MPBICB
     C                   KFLD                    MPPCCY
     C                   KFLD                    MPCBIC
     C                   KFLD                    MPCBIB
      * Set and get data
     C                   Eval      MpBICC = O2BICC
     C                   Eval      MpBICB = O2BICB
     C                   Eval      MpPCCY = O2PCCY
     C                   Eval      MpCBIC = O2CBIC
     C                   Eval      MpCBIB = O2CBIB
     C     KMscpV0       Chain     @MscpV0
     C                   If        %Found
     C                   Select
      * Low value preferential Ben
     C                   When      O2PLBen = 'Y'
     C                   Eval      MpPbNb = MpPbNb + 1
      * Low value preferential Sha
     C                   When      O2PLSha = 'Y'
     C                   Eval      MpPsNb = MpPsNb + 1
      * Low value preferential Our
     C                   When      O2PLOur = 'Y'
     C                   Eval      MpPoNb = MpPoNb + 1
      * Preferential LVP
     C                   When      O2PLvp = 'Y'
     C                   Eval      MpPlnb = MpPlnb + 1
      * Preferential Regulated
     C                   When      O2PReg = 'Y'
     C                   Eval      MpPrnb = MpPrnb + 1
      * Preferential Routing
     C                   Other
     C                   Eval      MpPnbr = MpPnbr + 1
     C                   Endsl
     C                   Update    @MscpV0
     C                   Endif
      *
     C                   Endif
      *
      *  Set up routing key details
     C                   If        P1Actc <> 'r'
     C                   Eval      MoMsgr = PHMSGR
     C                   Eval      MoKprt = PHPART
     C                   Else
     C                   Z-Sub     ##JNO         MoMsgr
     C                   Z-Sub     1             MoKprt
     C                   Endif
      *
      *  Set up audit stamp
     C                   TIME                    TIME              6 0
      *
     C                   MOVEL     ##JOB         MOAJOB                         Job Name
     C                   MOVEL     ##USR         MOAUSR                         User
     C                   Z-ADD     TIME          MOATIM                         Action Time
     C                   MOVEL     AGMRDT        MOARDT                         Action Date
     C                   Z-ADD     AGRDNB        MORDNB                         Run Day No.
      *
      *  Store payment routing data for updates
     C                   Eval      #MROTDS = MROTDS
      *
      *  Update/Output payment routing data
     C     KMrotV0       Klist
     C************       Kfld                    PHMSGR
     C************       Kfld                    PHPART
     C                   Kfld                    MoMsgr
     C                   Kfld                    MoKprt
      *
     C     KMrotV0       Chain     @Mrotv0
      *
      * If record exists then update accordingly
     C                   If        %Found
     C                   If        MoReci = 'D'
     C                   MOVEL     'A'           #MOAACT
     C                   Else
     C                   MOVEL     'I'           #MOAACT
     C                   Endif
      *
     C                   Eval      MROTDS = #MROTDS
     C                   Update    @MrotV0
      *
      * Else write new record
     C                   Else
     C                   MOVEL     'I'           MOAACT
     C                   Write     @MrotV0
     C                   Endif
      *
      *  Commit changes
     C                   Commit
     C                   Eval      W0TRN  = 'N'
      *
      *  Unwind subroutine stack name
      *
     C     EXUpdate      TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   If        P1Actc <> ' '
     C                   Exsr      ZXEXPG
     C                   Endif
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel & exit program
      *================================================================
      * USER: Exit program processing
      *
      * CASE: CTL.*CMD key is CF03
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   END                                                    *FI
      * CASE: CTL.*CMD key is CF07
     C     *IN07         IFEQ      '1'                                          *IF
     C                   MOVEL     *BLANKS       P0RTN                          *Return code
     C                   END                                                    *FI
      * CASE: CTL.*CMD key is CF10
     C     *IN10         IFEQ      '1'                                          *IF
     C                   MOVEL     '*ROUTE '     P0RTN                          *Return code
     C                   END                                                    *FI
      *
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * Copy any undisplayed messages back to caller
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
      *
      * Exit program
     C                   SETON                                        LR
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      * Initialise indicators for re-entry
     C                   MOVE      '0'           *IN
      *
      * Setup job date/time
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C                   MOVEL     'FTUSRMSG'    ZADFMF           10
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      *
      *  Set up copyright parameter
      *
     C                   MOVEA     CPY@          ACT@             80
      *
      * Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
     C     AGMBIN        IFEQ      'Y'
     C                   MOVE      *ON           *IN71
     C                   ENDIF
      *
      * Get ZMUSER  - Default Branch
      *
     C     *DTAARA       DEFINE    ZMUSER        ZMUSER
     C                   IN        ZMUSER
     C*
     C* Get modules information
     C*
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     MMODDS        PARM      *BLANKS       DSFDY                          O:Module Flg
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     5             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Open file MEBICPV0
      *
     C     FIL001        IFEQ      *BLANKS
      *
      *  Override file MEBicPV0 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'MEBICPV0'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     3             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   OPEN      MEBICPV0
     C                   MOVEL     'Y'           FIL001            1
     C                   END
      *
      * Access SAR details file to see if CFT007 is installed.
      *
     C                   CALLB     'AOSARDR0'                           9090
     C                   Parm      *BLANKS       P@RTCD
     C                   Parm      '*VERIFY'     P@OPTN
     C                   Parm      'CFT007'      P@SARD            6
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        P@RTCD = *Blanks
     C                   Movel     'Y'           CFT007            1
     C                   Else
     C                   Movel     'N'           CFT007
     C                   End
      *
      ** Option Name
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10116'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      ** Command keys
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10117'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C     *Like         Define    ##CMD2        ##CMDA
     C                   MOVEL     #MSTX1        ##CMDA
      *
      ** Command keys
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10146'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C     *Like         Define    ##CMD2        ##CMDB
     C                   MOVEL     #MSTX1        ##CMDB
     C                   MOVEL     #MSTX1        ##CMD2
      *
      ** Set up variables
     C                   Z-ADD     *ZERO         YAFSCH            4 0
     C                   Clear                   #MoBtbi
                                                                                              PNL014
     C     KPicdV1       KLIST                                                                PNL014
     C                   KFLD                    IcKey                                        PNL014
      * Get ICD data                                                                          PNL014
     C                   Clear                   IcKey                                        PNL014
     C     KPicdV1       Setll     @PicdV1                                                    PNL014
     C                   Read      @PicdV1                                                    PNL014
      *
      *================================================================
     CSR   ZZEXIT        ENDSR
      *
      * File and Program Error Processing
      *
     C/COPY MECPYSRC,SRERRC_ILE
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO)
