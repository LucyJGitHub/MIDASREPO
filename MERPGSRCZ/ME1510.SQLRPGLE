     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas ME Msg content translation table maintenance')   *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1510 - Edit Message Translation  Edit record(1 screen)     *
      *                                                               *
      *  Function:  This program controls the display and update      *
      *             of MEDECDPD records                               *
      *                                                               *
      *  Called By: ME1500  - Display Message Translation Records     *
      *  Calls : MEC1150 - Extract message information                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD060008           Date 11May21               *
      *  Prev Amend No. MD058830           Date 01Oct21               *
      *                 MD056560           Date 31Aug20               *
      *                 CSD103             Date 10Aug20               *
      *                 261990             Date 09Mar12               *
      *                 CMG008             Date 20Feb20               *
      *                 MD049278           Date 12Jan18               *
      *                 MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3339            Date 23Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013             Date 29Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 162075             Date 27Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 162607             Date 01Jul99               *
      *                 162335             Date 10Jun99               *
      *                 162079             Date 09Jun99               *
      *                 CFT002  *Create    Date 23Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060008 - Deliverable Data Split for Standing Data 2        *
      *  MD058830 - Deliverable Data Split for SDNWRKPD               *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  261990 - FT STP. Translation set up not allowed. Ensure      *
      *           that fix 162335 validation will only be done for    *
      *           non-blank message tag.                              *
      *           Applied for AR919970 (Child: AR920115)              *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD049278 - MIDAS Equivalent field doesn't accept alpha-      *
      *             numeric characters.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3339 - Addition to changes introduced by CGL029(Increase  *
      *            of account code from 4 to 10.)
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CGL013 - MT94x Messages Generation (Recompile over new layout*
      *                                      of SDNWRKPD)             *
      *  162075 - Correct cursor positioning                          *
      *  162607 - Enhancement to 162079.  Replace the error message   *
      *           with a warning                                      *
      *  162335 - Translation cross validity checking                 *
      *  162079 - Cross validity check  between Currencies            *
      *  CFT002 - Incorporate Into Core                               *
      *           Based on ME1510 original references HUB001/S01489   *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  03    Cancel and exit                                        *
      *  05    Reset screen field                                     *
      *  10    Delete record                                          *
      *  12    Redisplay previous screen                              *
      *  31,...,35 Error indicator for screen field                   *
      *  36    Position cursor on message field tag                   *   162075
      *  37    Position cursor on message type                        *   162075
      *  38    Position cursor on currency                            *   162075
      *  39    Position cursor on network                             *   162075
      *  77    Allow delete                                           *
      *  78    Protect key field                                      *
      *  79    Protect key field on detail screen                     *
      *  86    Putover                                                *
      *  89    Add mode                                               *
      *  90    Error indicator                                        *
      *  91    Record locked                                          *
      *  99    General error indicators                               *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *   ZZINIT - Initialization                                     *
      *   FACKPM - Check passed parameters                            *
      *   BADSKY - Display and process key screen                     *
      *   ZXEXPG - Cancel and exit from key screen                    *
      *   MDIZ#K - Initialise key screen                              *
      *   MAIZ#1 - Initialise record - except for key fields          *
      *   BBEXFM - Display key screen and process HELP requests       *
      *   BEPRKY - Process key screen input                           *
      *   GADSAK - Set key screen conditioning indicators             *
      *   BFVLKY - Validate key fields                                *
      *   MBFL#1 - Move @DECDL1 fields to screen                      *
      *   CADSDAy- Display and process detail screen                  *
      *   VBCKRL - Check reference to BIS¦Midas¦ABS Message Net       *
      *   VCCKRL - Check reference to BIS¦Midas¦ABS Message Typ       *
      *   VECKRL - Check reference to BIS¦Midas¦ABS Currency File     *
      *   CBEXFM - Display screen and process HELP requests           *
      *   GBDSAD - Set detail screen conditioning indicators          *
      *   SRWIND - Control Window Processing                          *
      *   EBPR## - Process record                                     *
      *   VFCKME - Check MIDAS equivalent (A/C or Cust No)            *
      *   SACRRC - Create Record - Incoming Msg Translation           *
      *   SCCHRC - Delete Record - Incoming Msg Translation           *
      *   SDCHRC - Change Inc Msg Trans - Incoming Msg Translation    *
      *   SBCHRC - Change Record - Incoming Msg Translation           *
      *   BDHMKY - Process HOME key                                   *
      *   BEPRKY - Process key screen input                           *
      *   CCDSPV - Redisplay previous screen                          *
      *   CFPRSC - Validate record                                    *
      *   DCVLDL - Validate details                                   *
      *   EDDLRQ - Process delete request                             *
      *   ECADRQ - Process add request                                *
      *   EECHRQ - Process update request                             *
      *                                                               *
      *****************************************************************
      *EDTRCD: Cpysrc Templates Initialise Program F-spec
     F/COPY WNCPYSRC,ME1510DFPG
     FME1510DF  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Edit Message Translation  Edit record(1 screen)
      *
     FMEDECDL1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : Incoming Msg Translation  Retrieval index
      *
     FMEDECDL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Incoming Msg Translation  Seacrh index
      *
     FMEDECDL0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFSR(SRFILE)
      * UPD : Incoming Msg Translation  Update index
      *
     F*SDMTAGL1* IF   E           K DISK    INFSR(SRFILE)                                   MD056560
     F**********                           RENAME(@EFREJ5:@MTAGL1)                          MD056560
      * RTV : BIS¦Midas¦ABS Message Fie Retrieval index
      *
     FSDCURRL3  IF   E           K DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@A6REA5:@CURRL3)
      *
      * RTV : BIS¦Midas¦ABS SWIFT Currencies
      *
     FMETAGTL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Incoming Msg Translation X-ref  Seacrh index                                    162335
      *                                                                                       162335
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *------------------------------
     D*  Array containing Copyright statement
     D***************** FIRST COMPILE TIME ARRAY *********************
      **                                                                                      CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      **                                                                                      CSC022
     D WCMT            S             10    DIM(10)
     D*
     D*COPY*MECPYSRC,SRERRE                                                                 MD056560
     D/COPY MECPYSRC,SRERRELE                                                               MD056560
     D*
     D*  Copysource for error processing
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program E-spec
     D/COPY WNCPYSRC,ME1510DEPG
     D*COPY*MECPYSRC,SRERRI                                                                 MD056560
     D/COPY MECPYSRC,SRERRILE                                                               MD056560
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program I-spec
     D/COPY WNCPYSRC,ME1510DIPG
      /EJECT
      * Data structures:
     D DATA            DS          1024
      * Data to be passed to window processing
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
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D @1DBRC        E DS                  EXTNAME(MEDECDL0)
      * UPD : Incoming Msg Translation  Update index
      * Current/previous master file format fields for change control
      *
     D****#1DBRC      DS                            272                                      BUG3339
     D #1DBRC          DS           278                                                            B
      * Increase data structure due to increased length of account codes                     BUG3339
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D*
     D* Modules Data Structure *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D* Data Structures used by Access Programs
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D*
     D* Data Structures used by Access Programs
     D*
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * @CUST - Customer record format data structure
      *
     D P@ACCT        E DS                  EXTNAME(ACCNTAB)
      * ACCNTABF - Account details record format data structure
     D  @ACCK1                 2     16
      *
      *
     D*DSNWRK***     E DS                  EXTNAME(SDNWRKPD)                                MD058830
     D DSNWRK        E DS                  EXTNAME(SDNWKJW0)                                MD058830
     D*
     D* Data Structures for Network definition
     D*
     D*DSMTPY***     E DS                  EXTNAME(SDMTPYPD)                                MD060008
     D DSMTPY        E DS                  EXTNAME(SDMTYJW0)                                MD060008
     D*
     D* Data Structures for Message Type Definition
     D*
     D*DSMTAG***     E DS                  EXTNAME(SDMTAGPD)                                MD056560
     D DSMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
     D*
     D* Data Structures for Message Tag Definition
     D*
     D DSCURR        E DS                  EXTNAME(SDCURRPD)
     D*
     D* Data Structures for Currency Definition
     D*
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D*
     D* Data Structures for Nostro Details
     D*
      **                                                                                      CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
      ** Switchable Features File                                                             CSC022
     D SCCMT           DS           256
     D  WCMTNO                 1      3  0
     D  WCJOBS                 4    103
      ** Commitment Control dataarea                                                          CSC022
      **                                                                                      CSC022
      *
      * Template of key fields entered
      *
     D DSTMPL          DS
     D  #TNWRK                 1      1
     D  #TMTAG                 2      2
     D  #TMTPY                 3      3
     D  #TCYCD                 4      4
     D  #TSNDR                 5      5
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS           215
      * KEY: Incoming Msg Translation  Retrieval index
      * I : MAP Network
     D  P2NWRK                 1      6
      * I : MAP Message Field Tag
     D  P2MTAG                 7     11
      * I : MAP Currency
     D  P2CYCD                12     14
      * I : MAP Sender
     D  P2SNDR                15     34
      * I : MAP Message type
     D  P2MTPY                35     37
      * I : MAP Message Sequence No
     D  P2SQNO                38     40P 0
      * I : MAP Incoming field data
     D  P2INDA                41    215
     D  P2IND1                41     75
     D  P2IND2                76    110
     D  P2IND3               111    145
     D  P2IND4               146    180
     D  P2IND5               181    215
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Invalid Action code (FT)'
      * Action Code
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
      * Data Structure redefining Address fields
      *
     D                 DS
     D  ADDRSS                 1    210
     D  ADCHK1                 1     35
     D  ADCHK2                36     70
     D  ADCHK3                71    105
     D  ADCHK4               106    140
     D  ADCHK5               141    175
     D  ADCHK6               176    210
      *
      * Blank Line Analysis data structure
      *
     D  ADCH26                36    210
     D  ADCH36                71    210
      *
      * SWIFT Address Analysis data structure
      *
     D  ADSLSH                 1      1
     D  ADSWFT                 1     11
     D  ADEXSW                12     35
     D  ADSLS2                36     36
     D  ADSWF2                36     46
     D  ADEXS2                47     70
      *
      * Customer Analysis data structure
      *
     D  ADCUST                 1     10
     D  ADEXCS                11     35
     D  ADCNUM                 1      6
     D  ADEXCN                 7     35
     D  ADCUS2                36     45
     D  ADXCS2                46     70
     D  ADCNM2                36     41
     D  ADXCN2                42     70
      *
      * Account Analysis data structure FULL Account
      *
     D  ADGCNM                 1      6
     D  ADGCCY                 7      9
     D**********                             10  13 ADGACD                                    CGL029
     D**********                             14  15 ADGASQ                                    CGL029
     D**********                             16  18 ADGBRC                                    CGL029
     D**********                             16  35 ADEXG1                                    CGL029
     D**********                             19  35 ADEXGL                                    CGL029
     D  ADGACD                10     19
     D  ADGASQ                20     21
     D  ADGBRC                22     24
     D  ADEXG1                22     35
     D  ADEXGL                25     35
      *
      * Partial Account Analysis data structure
      *
     D  ADPCNM                 1      6
     D**********                              7  10 ADPACD                                    CGL029
     D**********                             11  12 ADPASQ                                    CGL029
     D**********                             13  15 ADPBRC                                    CGL029
     D**********                             13  35 ADEXP1                                    CGL029
     D**********                             16  35 ADEXPA                                    CGL029
     D  ADPACD                 7     16
     D  ADPASQ                17     18
     D  ADPBRC                19     21
     D  ADEXP1                19     35
     D  ADEXPA                22     35
      *
      * Nostro Number Account Analysis data structure
      *
     D  ADNOSN                 1      2
     D  ADEXNN                 3     35
      *
      * Nostro Account Analysis data structure
      *
     D  ADFNOS                 1      5
     D  ADFCCY                 1      3
     D  ADFNNB                 4      5
     D  ADFNEX                 6     35
      *
      * Retail Account Analysis data structure
      *
     D  ADACNO                 1     10
     D  ADEXAC                11     35
     D                 DS
      *
      * Data Structure redefining Partial Account
      *
     D**********                              1  12 PTACCT                                    CGL029
     D  PTACCT                 1     18
     D  PTCNUM                 1      6
     D**********                              7  10 PTACOD                                    CGL029
     D**********                             11  12 PTACSQ                                    CGL029
     D  PTACOD                 7     16
     D  PTACSQ                17     18
      *
      *  Defined Constants
      *
      *
     D DIGITS          C                   CONST('0123456789')
      *
      *
      /EJECT
      *
      * Data to be passed to window processing
      *
     I/COPY QWINDSRC,ME1510WDTA
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: Incoming M
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
      * Check passed parameters
     C                   EXSR      FACKPM
      * Perform once if all passed, else repeat
     C     W0RPT         DOUEQ     'N'
      * Display and process key screen
     C                   EXSR      BADSKY
     C                   END
      * Terminate program
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BEGSR
      *================================================================
      * Display and process key screen
      *================================================================
      * Initialise key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction
     C                   MOVEL     'Y'           W0TRN             1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1NWRK        IFEQ      *BLANK                                       Network
      * One or more key fields is blank
     C                   MOVEL     'N'           W0BYP
     C                   END
     C                   END
      * Bypass key screen
     C     W0BYP         IFNE      'Y'
      * Display key screen
     C                   EXSR      BBEXFM
     C                   END
      * Cancel key screen bypass
     C                   MOVEL     'N'           W0BYP
      * Process response to key screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
     C   12              CAS                     ZXEXPG
      * HOME: Reset screen fields
     C   05              CAS                     BDHMKY
      * Process key screen input
     C                   CAS                     BEPRKY
     C                   END
     C     W0TRN         DOWEQ     'R'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      BEPRKY
     C                   END
      *
     C                   END
     C                   END
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBEXFM        BEGSR
      *================================================================
      * Display key screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GADSAK
      * Update screen time
     C                   TIME                    ##TME
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   BDHMKY        BEGSR
      *================================================================
      * Process HOME key
      *================================================================
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   BDEXIT        ENDSR
      /EJECT
     CSR   BEPRKY        BEGSR
      *================================================================
      * Process key screen input
      *================================================================
      * Validate key fields
     C                   EXSR      BFVLKY
      * If A,E,D ignore key field validation
     C     P1ACTC        IFEQ      'D'
     C     P1ACTC        OREQ      'E'
     C     P1ACTC        OREQ      'A'
     C                   SETOFF                                       99
     C                   MOVE      '0000'        *IN(31)
     C                   MOVE      *BLANK        W0RTN
     C                   END
      *
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    DCNWRK                         Network
     C                   KFLD                    DCMTAG                         Message Field T
     C                   KFLD                    DCMTPY                         Message type
     C                   KFLD                    DCCYCD                         Currency
     C                   KFLD                    DCSNDR                         Sender
     C                   KFLD                    DCSQNO                         Sequence No
      * Setup key
     C                   MOVEL     #1NWRK        DCNWRK                         Network
     C                   MOVEL     #1CYCD        DCCYCD                         Currency
     C                   MOVEL     #1SNDR        DCSNDR                         Sender
     C                   MOVEL     #1MTPY        DCMTPY                         Message Type
     C                   MOVEL     #1MTAG        DCMTAG                         Message Field T
     C                   Z-ADD     P2SQNO        DCSQNO                         Sequence No
     C     KRTV          CHAIN     @DECDL1                            9091      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        993132    *
     C                   SETON                                        3334      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, flip to add mode
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ADD'         W0PMD
      * USER: Initialise detail screen (new record)
      * EDTRCD: Init. det. scr NW - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl New Rcd
     C/COPY WNCPYSRC,ME1510DISN
     C                   ELSE
      *
      * If insert then send record already exists
      *
     C     P1ACTC        IFEQ      'I'
     C     P2INDA        ANDEQ     *BLANKS
     C                   MOVEA     '11111'       *IN(31)
     C                   MOVEL     '1'           *IN99
      * Send message 'Already exists'
     C*                    MOVEL'MIN0066' ZAMSID
     C*                    EXSR ZASNMS
     C                   MOVEL     'MIN0066'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      BEEXIT
     C                   END
      * If record does exist, flip to change mode
     C                   MOVEL     'CHG'         W0PMD
      * Load screen fields from DBF
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,ME1510DCDF
      * USER: Initialise detail screen (existing record)
      * EDTRCD: Init. det. scr EX - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,ME1510DISE
     C                   END
      *..................................................
     C   99              GOTO      BEEXIT
      *
      * No error: Display and process details
     C                   EXSR      CADSDA
      *
      *================================================================
     CSR   BEEXIT        ENDSR
      /EJECT
     CSR   BFVLKY        BEGSR
      *================================================================
      * Validate key fields
      *================================================================
      *
      * Check that key is valid
      *
     C                   MOVEL     'NNNNN'       DSTMPL
     C     #1NWRK        IFNE      *BLANK
     C                   MOVEL     'Y'           #TNWRK
     C                   END
     C     #1MTAG        IFNE      *BLANK
     C                   MOVEL     'Y'           #TMTAG
     C                   END
     C     #1MTPY        IFNE      *BLANK
     C                   MOVEL     'Y'           #TMTPY
     C                   END
     C     #1CYCD        IFNE      *BLANK
     C                   MOVEL     'Y'           #TCYCD
     C                   END
     C     #1SNDR        IFNE      *BLANK
     C                   MOVEL     'Y'           #TSNDR
     C                   END
      *
      * Check that keys filled are valid
      *
     C     P1ACTC        IFEQ      'I'
     C     DSTMPL        ANDNE     'YYYYY'
     C     DSTMPL        ANDNE     'YYYYN'
     C     DSTMPL        ANDNE     'YYYNN'
     C     DSTMPL        ANDNE     'YYNNN'
     C     DSTMPL        ANDNE     'YYNYN'
     C     DSTMPL        ANDNE     'YNNYN'
     C     DSTMPL        ANDNE     'YNNNN'
     C                   MOVEA     '11111'       *IN(31)
     C                   MOVEL     '1'           *IN99
     C                   MOVEL     'MIN0317'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
      * To test if any ? are entered in screen fields
     C                   MOVEL     'N'           W0PMT             1
      * Check relations
      * Check reference to BIS¦Midas¦ABS Message Net
     C                   EXSR      VBCKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9931      *
     C                   END
      * Check reference to BIS¦Midas¦ABS Message Fie
     C                   EXSR      VDCKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9933      *
     C                   END
      * Check reference to BIS¦Midas¦ABS Message Typ
     C                   EXSR      VCCKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9932      *
     C                   END
      * Check reference to BIS¦Midas¦ABS Currency File
     C                   EXSR      VECKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9934      *
     C                   END
      * USER: Validate key screen
      *
      * Make sure MTPY is not ALL
      *
     C     #1MTPY        IFEQ      'ALL'                                        IF
     C                   SETON                                        9932      *
      * Send message 'ALL message type not valid'
     C                   MOVEL     'MIN0085'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
      * EDTRCD: Valid key screen - R10 Copy source templates  *
     C/COPY WNCPYSRC,ME1510DVKS
      * Network required
     C     #1NWRK        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * If insert then record full must not exist
      *
     C     P1ACTC        IFEQ      'I'
     C     P2INDA        ANDNE     *BLANKS
      * Check for existing record
     C     KRTV1         KLIST
     C                   KFLD                    DCNWRK                         Network
     C                   KFLD                    DCMTAG                         Message Field T
     C                   KFLD                    DCMTPY                         Message type
     C                   KFLD                    DCCYCD                         Currency
     C                   KFLD                    DCSNDR                         Sender
     C                   KFLD                    DCIND1                         Text
     C                   KFLD                    DCIND2                         Text
     C                   KFLD                    DCIND3                         Text
     C                   KFLD                    DCIND4                         Text
     C                   KFLD                    DCIND5                         Text
      * Setup key
     C                   MOVEL     #1NWRK        DCNWRK                         Network
     C                   MOVEL     #1CYCD        DCCYCD                         Currency
     C                   MOVEL     #1SNDR        DCSNDR                         Sender
     C                   MOVEL     #1MTPY        DCMTPY                         Message Type
     C                   MOVEL     #1MTAG        DCMTAG                         Message Field T
     C                   MOVEL     P2IND1        DCIND1                         Text
     C                   MOVEL     P2IND2        DCIND2                         Text
     C                   MOVEL     P2IND3        DCIND3                         Text
     C                   MOVEL     P2IND4        DCIND4                         Text
     C                   MOVEL     P2IND5        DCIND5                         Text
     C     KRTV1         CHAIN     @DECDL2                            90        *
      * Send message 'Already exists'
      *
     C     *IN90         IFEQ      '0'
     C                   MOVEL     'MIN0066'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     DCSQNO        P2SQNO
     C                   END
     C                   END
      *================================================================
     CSR   BFEXIT        ENDSR
      /EJECT
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process detail screen
      *================================================================
      * Conduct detail screen conversation
      * - repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      * Display detail screen
     C                   EXSR      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      * Process detail screen input
     C                   CAS                     CFPRSC
     C                   END
     C     W0TRN         IFEQ      'R'
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      MAIZ#1
     C                   END
     C                   END
      *
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSAD
      * Update screen time
     C                   TIME                    ##TME
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * USER: Process key screen request
      * EDTRCD: Process key req. - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Process Key Screen Rqst
     C/COPY WNCPYSRC,ME1510DPKR
     C   05              MOVEL     'R'           W0TRN
      *
      * If insert go to key screen else exit
      *
     C     *IN12         IFEQ      '1'
     C     P1ACTC        IFEQ      'I'
     C   12              MOVEL     'K'           W0TRN
     C                   ELSE
     C                   EXSR      ZXEXPG
     C                   END
     C                   END
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * If delete is not pending....
      * Validate details
     C     P1ACTC        IFEQ      'I'
     C     P1ACTC        OREQ      'A'
     C  N10              CAS                     DCVLDL
     C                   END
     C                   END
      *
      *  Call window processing
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      SRWIND
     C                   END
      * QUIT if error:
     C   99              GOTO      CFEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * No error: update record
     C     P1ACTC        IFEQ      'A'
     C     P1ACTC        OREQ      'I'
     C     P1ACTC        OREQ      'D'
     C     *IN10         ANDEQ     '1'
     C                   EXSR      EBPR##
     C                   END
      *
     C     P1ACTC        IFEQ      'D'                                          Cancel delete
     C     *IN10         ANDNE     '1'
     C                   MOVEL     'N'           W0TRN
     C                   END
      *
      * Exit if enquire
      *
     C     P1ACTC        IFEQ      'E'
     C                   MOVEL     'N'           W0RPT
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
      * USER: Validate detail screen fields
      * EDTRCD: Valid det. scrn - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Detail Screen
     C/COPY WNCPYSRC,ME1510DVSF
      *
      * To test if any ? are entered in screen fields
     C                   MOVEL     'N'           W0PMT             1
      * Check Midas Equivalent
     C                   EXSR      VFCKME
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,ME1510DSFF
      * USER: Validate detail screen relations
      *
      * If insert then record full must not exist
      *
     C     P1ACTC        IFEQ      'I'
     C     P2INDA        ANDEQ     *BLANKS
      * Setup key
     C                   MOVEL     #1NWRK        DCNWRK                         Network
     C                   MOVEL     #1CYCD        DCCYCD                         Currency
     C                   MOVEL     #1SNDR        DCSNDR                         Sender
     C                   MOVEL     #1MTPY        DCMTPY                         Message Type
     C                   MOVEL     #1MTAG        DCMTAG                         Message Field T
     C                   MOVEL     #1IND1        DCIND1                         Text
     C                   MOVEL     #1IND2        DCIND2                         Text
     C                   MOVEL     #1IND3        DCIND3                         Text
     C                   MOVEL     #1IND4        DCIND4                         Text
     C                   MOVEL     #1IND5        DCIND5                         Text
     C     KRTV1         CHAIN     @DECDL2                            90        *
      * Send message 'Already exists'
      *
     C     *IN90         IFEQ      '0'
     C                   MOVEL     '1'           *IN99
     C                   MOVEL     'MIN0066'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
     C                   END
      * EDTRCD: Detail scrn rels - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Screen Relns
     C/COPY WNCPYSRC,ME1510DVSR
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * Process delete request
     C   10              CAS                     EDDLRQ
      * Process add request
     C     W0PMD         CASEQ     'ADD'         ECADRQ
      * Process update request
     C     W0PMD         CASNE     'ADD'         EECHRQ
     C                   END
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C     CSC022        IFEQ      'N'
     C                   ROLBK
     C                   ELSE
     C     WCRSKP        IFEQ      'N'
     C                   ROLBK
     C                   ELSE
     C                   SETON                                        U7U8
     C                   ENDIF
     C                   ENDIF
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     WCRSKP        ANDEQ     'N'
     C                   COMMIT
     C                   ENDIF
     C                   END
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * EDTRCD: Process cmds - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Process Command Keys
     C/COPY WNCPYSRC,ME1510DPCK
     C     W0PMD         IFEQ      'ADD'
     C     P2INDA        ANDEQ     *BLANKS
      * Exit after successful add
     C                   MOVEL     'R'           W0RPT
     C                   END
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Record - Incoming Msg Translation  *
     C                   EXSR      SACRRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record added'
     C                   MOVEL     'Y2U0011'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Record - Incoming Msg Translation  *
     C                   EXSR      SCCHRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C                   MOVEL     'Y2U0013'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Incoming Msg Trans - Incoming Msg Translation  *
     C                   EXSR      SDCHRC
     C     W0RTN         IFNE      *BLANK
      * DBF update error
      * Reset screen fields if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * Send message '*Record changed'
     C                   MOVEL     'Y2U0012'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters
      *================================================================
      * Is full key present?
     C     P2NWRK        IFEQ      *BLANK
      * Not every key field passed - loop program
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
      * Full key passed, so single shot program
     C                   MOVEL     'N'           W0RPT
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GADSAK        BEGSR
      *================================================================
      * Set key screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect key fields on detail screen
     C                   SETON                                        88        *
     C                   MOVEL     '0'           *IN79
     C     P1ACTC        IFEQ      'E'                                          *IF
     C     P1ACTC        OREQ      'D'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
      * Enable key screen
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields
      *================================================================
     C                   MOVEL     *BLANK        #1RECI                         Record Identifi
     C                   MOVEL     *BLANK        #1AJOB                         Job name
     C                   MOVEL     *BLANK        #1AACT                         Action Type
     C                   Z-ADD     *ZERO         #1RDNB                         Run day number
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C     P2INDA        IFNE      *BLANKS
     C                   MOVEL     P2IND1        #1IND1                         In Data Line 1
     C                   MOVEL     P2IND2        #1IND2                         In Data Line 2
     C                   MOVEL     P2IND3        #1IND3                         In Data Line 3
     C                   MOVEL     P2IND4        #1IND4                         In Data Line 4
     C                   MOVEL     P2IND5        #1IND5                         In Data Line 5
     C                   ELSE
     C                   MOVEL     *BLANK        #1IND1                         In Data Line 1
     C                   MOVEL     *BLANK        #1IND2                         In Data Line 2
     C                   MOVEL     *BLANK        #1IND3                         In Data Line 3
     C                   MOVEL     *BLANK        #1IND4                         In Data Line 4
     C                   MOVEL     *BLANK        #1IND5                         In Data Line 5
     C                   END
     C                   MOVEL     *BLANK        #1MDEQ                         MIDAS Equivalent
     C                   MOVEL     *BLANK        #1MDE1                         MIDAS Equivalent
     C                   MOVEL     *BLANK        #1AUSR                         User name
     C                   MOVEL     *BLANK        #1ARDT                         Action Date
     C                   Z-ADD     *ZERO         #1ATIM                         Action Time
      *
      * Fill Command lines and narrative text from messages
      *
     C                   SELECT
      *
      * Insert screen
      *
     C     P1ACTC        WHENEQ    'I'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0309'     #MSGID
     C                   PARM      'MEMSG   '    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       ##CMD1
      *
      * Function keys
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0061'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      * Enquiry screen
      *
     C     P1ACTC        WHENEQ    'E'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0308'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       ##CMD1
      *
      * Function keys
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0061'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      *
      * Amendment screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0309'     #MSGID
     C                   PARM      'MEMSG   '    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       ##CMD1
      *
      * Function keys
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0061'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      *
      * Delete screen
      *
     C     P1ACTC        WHENEQ    'D'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0309'     #MSGID
     C                   PARM      'MEMSG   '    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       ##CMD1
      *
      * Function keys and allow delete key
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0065'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   MOVEL     '1'           *IN77
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
     C                   ENDSL
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @DECDL1 fields to screen
      *================================================================
     C                   MOVEL     DCRECI        #1RECI                         Record Identifi
     C                   MOVEL     DCAJOB        #1AJOB                         Job name
     C                   MOVEL     DCAACT        #1AACT                         Action Type
     C                   Z-ADD     DCRDNB        #1RDNB                         Run day number
     C                   MOVEL     DCNWRK        #1NWRK                         Network
     C                   MOVEL     DCMTAG        #1MTAG                         Message Field T
     C                   MOVEL     DCCYCD        #1CYCD                         Currency
     C                   MOVEL     DCSNDR        #1SNDR                         Sender
     C                   MOVEL     DCMTPY        #1MTPY                         Message type
     C                   MOVEL     DCIND1        #1IND1                         In Data Line 1
     C                   MOVEL     DCIND2        #1IND2                         In Data Line 2
     C                   MOVEL     DCIND3        #1IND3                         In Data Line 3
     C                   MOVEL     DCIND4        #1IND4                         In Data Line 4
     C                   MOVEL     DCIND5        #1IND5                         In Data Line 5
     C                   MOVEL     DCMDEQ        #1MDEQ                         MIDAS Equivalent
     C                   MOVEL     DCMDID        #1MDID                         MIDAS Equivalent
     C                   MOVEL     DCAUSR        #1AUSR                         User name
     C                   MOVEL     DCARDT        #1ARDT                         Action Date
     C                   Z-ADD     DCATIM        #1ATIM                         Action Time
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialise key screen
      *================================================================
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     P2NWRK        #1NWRK                         Network
     C                   MOVEL     P2MTAG        #1MTAG                         Message Field T
     C                   MOVEL     P2CYCD        #1CYCD                         Currency
     C                   MOVEL     P2SNDR        #1SNDR                         Sender
     C                   MOVEL     P2MTPY        #1MTPY                         Message type
     C                   MOVEL     *BLANKS       #1SCFD                         Msg Tag Desc.
     C                   MOVEL     *BLANKS       #1MTPD                         Msg Typ Desc.
     C                   MOVEL     *BLANKS       #1NETD                         Network Desc.
     C                   MOVEL     *BLANKS       #1CYNM                         Currency Name
      * USER: Initialise key screen
      * Option Name
     C                   SELECT
      * Insert screen
     C     P1ACTC        WHENEQ    'I'
     C                   MOVEL     '1'           *IN77
     C                   MOVEL     'MIN0309'     #MSGID
      * Enquiry screen
     C     P1ACTC        WHENEQ    'E'
     C                   MOVEL     'MIN0308'     #MSGID
      * Amendment screen
     C     P1ACTC        WHENEQ    'A'
     C                   MOVEL     'MIN0309'     #MSGID
      * Delete screen
     C     P1ACTC        WHENEQ    'D'
     C                   MOVEL     'MIN0309'     #MSGID
     C                   ENDSL
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM                    #MSGID
     C                   PARM      'MEMSG   '    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONKY
      * Action codes
     C                   MOVEL     *BLANKS       #KCMD1
      * Function keys
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0061'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #KCMD2
      * EDTRCD: Init. key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Key Screen
     C/COPY WNCPYSRC,ME1510DIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Record - Incoming Msg Translation  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @DECDL0
     C                   MOVEL     #1NWRK        DCNWRK                         Network
     C                   MOVEL     #1MTAG        DCMTAG                         Message Field T
     C                   MOVEL     #1CYCD        DCCYCD                         Currency
     C                   MOVEL     #1SNDR        DCSNDR                         Sender
     C                   MOVEL     #1MTPY        DCMTPY                         Message type
      *
      * Find sequence number for next put
      *
     C     KRTV2         KLIST
     C                   KFLD                    DCNWRK                         Network
     C                   KFLD                    DCMTAG                         Message Field T
     C                   KFLD                    DCMTPY                         Message type
     C                   KFLD                    DCCYCD                         Currency
     C                   KFLD                    DCSNDR                         Sender
     C     KRTV2         SETGT     @DECDL0
     C                   READP(N)  @DECDL0                                90
     C     *IN90         IFEQ      '0'
     C     #1NWRK        ANDEQ     DCNWRK                                       Network
     C     #1MTAG        ANDEQ     DCMTAG                                       Message Field T
     C     #1CYCD        ANDEQ     DCCYCD                                       Currency
     C     #1SNDR        ANDEQ     DCSNDR                                       Sender
     C     #1MTPY        ANDEQ     DCMTPY                                       Message type
     C     DCSQNO        ADD       1             P2SQNO
     C                   ELSE
     C                   Z-ADD     1             P2SQNO
     C                   END
      *
     C                   MOVEL     #1NWRK        DCNWRK                         Network
     C                   MOVEL     #1MTAG        DCMTAG                         Message Field T
     C                   MOVEL     #1CYCD        DCCYCD                         Currency
     C                   MOVEL     #1SNDR        DCSNDR                         Sender
     C                   MOVEL     #1MTPY        DCMTPY                         Message type
     C                   Z-ADD     P2SQNO        DCSQNO                         Sequence No
     C                   MOVEL     #1IND1        DCIND1                         In Data Line 1
     C                   MOVEL     #1IND2        DCIND2                         In Data Line 2
     C                   MOVEL     #1IND3        DCIND3                         In Data Line 3
     C                   MOVEL     #1IND4        DCIND4                         In Data Line 4
     C                   MOVEL     #1IND5        DCIND5                         In Data Line 5
     C                   MOVEL     #1MDEQ        DCMDEQ                         MIDAS Equivalent
     C                   MOVEL     #1MDID        DCMDID                         MIDAS Equivalent
     C                   MOVEL     'D'           DCRECI                         Record Identifi
     C                   MOVEL     ##JOB         DCAJOB                         Job name
     C                   MOVEL     ##USR         DCAUSR                         User name
     C                   Z-ADD     ##JTM         DCATIM                         Action Time
     C                   MOVEL     WUMRDT        DCARDT                         Action Date
     C                   MOVEL     'I'           DCAACT                         Action Type
     C                   Z-ADD     WURDNB        DCRDNB                         Run day number
      *
     C     KLCRSA        KLIST
     C                   KFLD                    DCNWRK                         Network
     C                   KFLD                    DCMTAG                         Message Field T
     C                   KFLD                    DCMTPY                         Message Type
     C                   KFLD                    DCCYCD                         Currency
     C                   KFLD                    DCSNDR                         Sender
     C                   KFLD                    DCSQNO                         Sequence No
      * Check for duplicate primary key
     C     KLCRSA        SETLL     @DECDL0                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CCS0093'     W0RTN             7
      * USER: Processing if DBF record already exists
      * Change Record - Incoming Msg Translation  *
     C                   EXSR      SBCHRC
     C                   GOTO      SAEXIT
     C                   END
      *
     C                   WRITE     @DECDL0                              91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF write successful
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Record - Incoming Msg Translation  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @DECDL0
     C                   MOVEL     #1NWRK        DCNWRK                         Network
     C                   MOVEL     #1MTAG        DCMTAG                         Message Field T
     C                   MOVEL     #1CYCD        DCCYCD                         Currency
     C                   MOVEL     #1SNDR        DCSNDR                         Sender
     C                   MOVEL     #1MTPY        DCMTPY                         Message type
     C                   Z-ADD     P2SQNO        DCSQNO                         Sequence No
      *
     C     KLCHSB        KLIST
     C                   KFLD                    DCNWRK                         Network
     C                   KFLD                    DCMTAG                         Message Field T
     C                   KFLD                    DCMTPY                         Message type
     C                   KFLD                    DCCYCD                         Currency
     C                   KFLD                    DCSNDR                         Sender
     C                   KFLD                    DCSQNO                         Sequence No
     C     KLCHSB        CHAIN     @DECDL0                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
     C                   END
      *
      * Move non-key fields to @DECDL0
     C                   MOVEL     'D'           DCRECI                         Record Identifi
     C                   MOVEL     #1IND1        DCIND1                         In Data Line 1
     C                   MOVEL     #1IND2        DCIND2                         In Data Line 2
     C                   MOVEL     #1IND3        DCIND3                         In Data Line 3
     C                   MOVEL     #1IND4        DCIND4                         In Data Line 4
     C                   MOVEL     #1IND5        DCIND5                         In Data Line 5
     C                   MOVEL     #1MDEQ        DCMDEQ                         MIDAS Equivalent
     C                   MOVEL     #1MDID        DCMDID                         MIDAS Equivalent
     C                   MOVEL     ##JOB         DCAJOB                         Job name
     C                   MOVEL     ##USR         DCAUSR                         User name
     C                   Z-ADD     ##JTM         DCATIM                         Action Time
     C                   MOVEL     WUMRDT        DCARDT                         Action Date
     C                   MOVEL     'I'           DCAACT                         Action Type
     C                   Z-ADD     WURDNB        DCRDNB                         Run day number
      *
     C                   UPDATE    @DECDL0                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF change successful
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Delete Record - Incoming Msg Translation  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @INFML0
     C                   MOVEL     #1NWRK        DCNWRK                         Network
     C                   MOVEL     #1MTAG        DCMTAG                         Message Field T
     C                   MOVEL     #1CYCD        DCCYCD                         Currency
     C                   MOVEL     #1SNDR        DCSNDR                         Sender
     C                   MOVEL     #1MTPY        DCMTPY                         Message type
     C                   Z-ADD     P2SQNO        DCSQNO                         Sequence No
      *
     C     KLCHSC        KLIST
     C                   KFLD                    DCNWRK                         Network
     C                   KFLD                    DCMTAG                         Message Field T
     C                   KFLD                    DCMTPY                         Message type
     C                   KFLD                    DCCYCD                         Currency
     C                   KFLD                    DCSNDR                         Sender
     C                   KFLD                    DCSQNO                         Sequence No
     C     KLCHSC        CHAIN     @DECDL0                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C     KLCHSC        SETLL     @DECDL0                            9091      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before DBF update
     C                   MOVEL     'D'           DCAACT                         Action Type
     C                   MOVEL     '*'           DCRECI                         Record Identifi
     C                   MOVEL     ##JOB         DCAJOB                         Job name
     C                   MOVEL     ##USR         DCAUSR                         User name
     C                   Z-ADD     ##JTM         DCATIM                         Action Time
     C                   MOVEL     WUMRDT        DCARDT                         Action Date
     C                   Z-ADD     WURDNB        DCRDNB                         Run day number
     C                   UPDATE    @DECDL0                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF change successful
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Incoming Msg Trans - Incoming Msg Translation  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @DECDL0
     C                   MOVEL     #1NWRK        DCNWRK                         Network
     C                   MOVEL     #1MTAG        DCMTAG                         Message Field T
     C                   MOVEL     #1CYCD        DCCYCD                         Currency
     C                   MOVEL     #1SNDR        DCSNDR                         Sender
     C                   MOVEL     #1MTPY        DCMTPY                         Message type
     C                   Z-ADD     P2SQNO        DCSQNO                         Sequence No
      *
     C     KLCHSD        KLIST
     C                   KFLD                    DCNWRK                         Network
     C                   KFLD                    DCMTAG                         Message Field T
     C                   KFLD                    DCMTPY                         Message type
     C                   KFLD                    DCCYCD                         Currency
     C                   KFLD                    DCSNDR                         Sender
     C                   KFLD                    DCSQNO                         Message type
     C     KLCHSD        CHAIN     @DECDL0                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SDEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C     KLCHSD        SETLL     @DECDL0                            9091      *
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      * Move non-key fields to @DECDL0
     C                   MOVEL     #1IND1        DCIND1                         In Data Line 1
     C                   MOVEL     #1IND2        DCIND2                         In Data Line 2
     C                   MOVEL     #1IND3        DCIND3                         In Data Line 3
     C                   MOVEL     #1IND4        DCIND4                         In Data Line 4
     C                   MOVEL     #1IND5        DCIND5                         In Data Line 5
     C                   MOVEL     #1MDEQ        DCMDEQ                         MIDAS Equivalent
     C                   MOVEL     #1MDID        DCMDID                         MIDAS Equivalent
     C                   MOVEL     'D'           DCRECI                         Record Identifi
     C                   MOVEL     ##JOB         DCAJOB                         Job name
     C                   MOVEL     ##USR         DCAUSR                         User name
     C                   Z-ADD     ##JTM         DCATIM                         Action Time
     C                   MOVEL     WUMRDT        DCARDT                         Action Date
     C                   MOVEL     'A'           DCAACT                         Action Type
     C                   Z-ADD     WURDNB        DCRDNB                         Run day number
      *
     C                   UPDATE    @DECDL0                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF change successful
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   VBCKRL        BEGSR
      *================================================================
      * Check reference to BIS¦Midas¦ABS Message Net
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     *BLANKS       #1NETD                         Network Desc.
      * If all low order keys not entered, exit
     C     #1NWRK        IFEQ      *BLANK                                       Network
     C                   GOTO      VBEXIT
     C                   END
      *
     C                   MOVEL     #1NWRK        WQM               1
     C     WQM           IFEQ      '?'
     C                   MOVEL(P)  '?'           #1NWRK
     C                   MOVEL     'Y'           W0PMT
     C                   MOVEL     '1'           *IN99
     C                   MOVE      *ON           *IN39                                         16207
     C                   END
      *
     C                   CALL      'AONWRKR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1NWRK        P@NWRK            6            I:Key field
     C                   PARM      *BLANKS       DSFDY                          O:Format
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found - move back any virtuals
     C                   MOVEL     DSFDY         DSNWRK
      *
      * If Network that on screen - delay
      *
     C     EDNWRK        IFNE      #1NWRK                                                   .
     C                   MOVEL     '1'           *IN99
     C                   END
     C                   MOVEL     EDNETD        #1NETD                         Network Desc.
     C                   MOVEL     EDNWRK        #1NWRK                                     .
     C                   GOTO      VBEXIT
     C                   END
      *
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'Y'
     C                   GOTO      VBEXIT
     C                   END
      *
      * Send message 'BIS¦Midas¦ABS M1101395'
     C                   MOVEL     'MIN0084'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0084'     W0RTN
      *================================================================
     CSR   VBEXIT        ENDSR
      /EJECT
     CSR   VDCKRL        BEGSR
      *================================================================
      * Check reference to BIS¦Midas¦ABS Message Fie
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     *BLANKS       #1SCFD                         Msg Tag Desc.
      * If all low order keys not entered, exit
     C     #1MTAG        IFEQ      *BLANK                                       Message Field T
     C*********************GOTO VDEXIT                                                        162335
     C                   GOTO      VDFOLW
     C                   END
      *
     C                   MOVEL     #1MTAG        WQM               1
     C     WQM           IFEQ      '?'
     C                   MOVEL(P)  '?'           #1MTAG
     C                   MOVEL     'Y'           W0PMT
     C                   MOVEL     '1'           *IN99
     C                   MOVE      *ON           *IN36                                         16207
     C                   END
      *
      * Selection processing
      *
     C     ' ?'          CHECK     #1MTAG                                 90
     C     *IN90         IFEQ      '0'
     C                   CALL      'AOMTAGR0'                           9090    Msg tag desc
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1MTAG        P@MTAG            5            I:Key field
     C                   PARM      #1MTPY        P@MTPY            3            I:Key field
     C                   PARM      *BLANKS       DSFDY                          O:Format
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found - move back any virtuals
     C                   MOVEL     DSFDY         DSMTAG
      *
      * If Message tag not that on screen - delay
      *
     C     EFMTAG        IFNE      #1MTAG                                                   .
     C                   MOVEL     '1'           *IN99
     C                   END
     C                   MOVEL     EFSCFD        #1SCFD                         Msg Tag Desc.
     C                   MOVEL     EFMTAG        #1MTAG                         Msg Tag     .
     C*********************GOTO VDEXIT                                                        162335
     C                   GOTO      VDFOLW
     C                   END
      *
     C                   END
      *
     C     KLVDEF        KLIST
     C                   KFLD                    EFMTAG                         Message Field T
     C                   KFLD                    EFMTPY                         Message type
      * Setup key
     C                   MOVEL     #1MTAG        EFMTAG                         Message Field T
     C                   MOVEL     #1MTPY        EFMTPY                         Message type
     C*****KLVDEF        CHAIN     @MTAGL1                            90        *           MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY                                         MD056560
     C/END-EXEC                                                                             MD056560
     C******IN90         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         EFMTPY                         Message type
     C*****KLVDEF        CHAIN     @MTAGL1                            90        *           MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY                                         MD056560
     C/END-EXEC                                                                             MD056560
     C                   END
     C******IN90         IFEQ      '0'                                                      MD056560
     C                   IF        SQLCODE = 0                                              MD056560
      * Record found - move back any virtuals
     C                   MOVEL     EFSCFD        #1SCFD                         Msg Tag Desc.
     C*********************GOTO VDEXIT                                                        162335
     C                   GOTO      VDFOLW
     C                   END
      *
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'Y'
     C*********************GOTO VDEXIT                                                        162335
     C                   GOTO      VDFOLW
     C                   END
      *
      * Send message 'BIS¦Midas¦ABS Message  NF'
     C                   MOVEL     'MIN0059'     ZAMSID
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0059'     W0RTN
      ** Further checkings                                                                    162335
     C     VDFOLW        TAG
      ** To check existence of general X-ref translations                                     162335
      ** (we don't allow for the type)                                                        162335
     C     KTAGT1        KLIST
     C                   KFLD                    #1MTAG
      ** To check existence of one specific X-ref translation                                 162335
     C     KTAGT2        KLIST
     C                   KFLD                    #1MTAG
     C                   KFLD                    #1MTPY
     C     #1MTAG        IFNE      *BLANK
     C     #1MTPY        IFEQ      *BLANK
     C     KTAGT1        SETLL     METAGTL2                               90
     C                   ELSE
     C     KTAGT2        SETLL     METAGTL2                               90
     C                   END
     C     *IN90         IFEQ      '0'
      *                                                                                       162335
      ** When ? is entered we perform no validity checks                                      162335
     C     W0PMT         IFNE      'Y'
      *                                                                                       162335
      ** Send message 'This combination isn't defined in Translation                          162335
      ** X-Ref                                                                                162335
     C                   MOVEL     'MIN0324'     ZAMSID
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0324'     W0RTN
      ** Highlight the message type                                                           162335
     C                   SETON                                        32
     C                   END
     C                   END
     C                   ENDIF
      *================================================================
     CSR   VDEXIT        ENDSR
      /EJECT
     CSR   VECKRL        BEGSR
      *================================================================
      * Check reference to BIS¦Midas¦ABS Currency File
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     *BLANKS       #1CYNM                         Msg Typ Desc.
      * If all low order keys not entered, exit
     C     #1CYCD        IFEQ      *BLANK                                       Message type
     C                   GOTO      VEEXIT
     C                   END
      *
     C                   MOVEL     #1CYCD        WQM               1
     C     WQM           IFEQ      '?'
     C                   MOVEL(P)  '?'           #1CYCD
     C                   MOVEL     '1'           *IN99
     C                   MOVEL     'Y'           W0PMT
     C                   MOVE      *ON           *IN38                                         16207
     C                   END
      *
      ** Access Currencies file via access program
     C                   CALL      'AOCURRR0'                           9090    *1
     C                   PARM      *BLANKS       P@RTCD            7            *1
     C                   PARM      '*KEY   '     P@OPTN            7            *1
     C                   PARM      #1CYCD        P@CYCD            3            *1
     C     DSCURR        PARM      *BLANK        DSSDY
      *
      * If currency changed i.e. select use new ccy
      * also defer confirm.
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
     C     #1CYCD        ANDNE     A6CYCD
     C                   MOVEL     A6CYCD        #1CYCD                         Currency Name
     C                   MOVEL     '1'           *IN99
     C                   GOTO      VEEXIT
     C                   END
      *
      * If not found, find again using SWIFT currency code
      *
     C     #1NWRK        IFEQ      'SWIFT '
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDNE     *BLANKS
      *
      * Open file if not already open
      *
     C     FIL003        IFNE      'Y'
     C                   OPEN      SDCURRL3
     C                   MOVEL     'Y'           FIL003            1
     C                   END
      *
      * look SWIFT currency
      *
     C     #1CYCD        CHAIN     @CURRL3                            9090
     C     *IN90         IFEQ      '0'
     C                   MOVEL     *BLANKS       P@RTCD
     C                   END
     C                   END
     C                   END
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found - move back any virtuals
     C                   MOVEL     A6CYNM        #1CYNM                         Currency Name
     C                   GOTO      VEEXIT
     C                   END
      *
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'Y'
     C                   GOTO      VEEXIT
     C                   END
      *
      *
      * Only reject currency if from SWIFT message
      *
      * Send message 'Currency code not found'
     C     #1NWRK        IFEQ      'SWIFT '
     C                   MOVEL     'MIN0311'     ZAMSID
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0311'     W0RTN
     C                   END
      *================================================================
     CSR   VEEXIT        ENDSR
      /EJECT
     CSR   VCCKRL        BEGSR
      *================================================================
      * Check reference to BIS¦Midas¦ABS Message Typ
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     *BLANKS       #1MTPD                         Msg Typ Desc.
      * If all low order keys not entered, exit
     C     #1MTPY        IFEQ      *BLANK                                       Message type
     C                   GOTO      VCEXIT
     C                   END
      *
     C                   MOVEL     #1MTPY        WQM               1
     C     WQM           IFEQ      '?'
     C                   MOVEL(P)  '?'           #1MTPY
     C                   MOVEL     '1'           *IN99
     C                   MOVEL     'Y'           W0PMT
     C                   MOVE      *ON           *IN37                                         16207
     C                   END
      *
     C                   CALL      'AOMTPYR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1MTPY        P@MTPY            3            I:Key field
     C                   PARM      *BLANKS       DSFDY                          O:Format
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found - move back any virtuals
     C                   MOVEL     DSFDY         DSMTPY
      *
      * If Message type not that on screen - delay
      *
     C     EEMTPY        IFNE      #1MTPY                                                   .
     C                   MOVEL     '1'           *IN99
     C                   END
     C                   MOVEL     EEMTPY        #1MTPY                         Message type
     C                   MOVEL     EEMTPD        #1MTPD                         Msg Typ Desc.
     C                   GOTO      VCEXIT
     C                   END
      *
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'Y'
     C                   GOTO      VCEXIT
     C                   END
      *
      * Send message 'BIS¦Midas¦ABS M1101260'
     C                   MOVEL     'MIN0058'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0058'     W0RTN
      *================================================================
     CSR   VCEXIT        ENDSR
      /EJECT
     CSR   VFCKME        BEGSR
      *================================================================
      * Check MIDAS equivalent (A/C or Cust No)
      *================================================================
     C                   SETOFF                                       34
      *
      * Set valid Midas equivalent flag
      *
     C                   MOVEL     *BLANKS       #1MDID            1
      *
      * Move data to address structure
      *
     C     WUMBIN        IFNE      'Y'                                          Multi Branched ?
     C                   MOVEL     #1MDE1        #1MDEQ
     C                   END
      *
     C                   MOVEL     *BLANKS       ADDRSS
     C                   MOVEL     #1MDEQ        ADDRSS
      *
     C                   MOVEL     ADDRSS        WQM               1
     C                   MOVEL     ADDRSS        WQM2              2
     C     WQM           IFEQ      '?'
     C     WQM2          IFEQ      '??'
     C                   MOVEL(P)  '??'          ADDRSS
     C                   MOVEL(P)  '??'          #1MDEQ
     C                   ELSE
     C                   MOVEL(P)  '?'           ADDRSS
     C                   MOVEL(P)  '?'           #1MDEQ
     C                   END
     C                   MOVEL     'Y'           W0PMT
     C                   MOVEL     '1'           *IN99
     C                   END
      *
      *  If first 5 Character are not blank but rest is blank
      *  validate as a full nostro
      *
     C     ADFNOS        IFNE      *BLANKS
     C     ADFNEX        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     ADDRSS        OREQ      '??'
     C     ADEXNN        ANDEQ     *BLANKS
      *
      * Look up Nostro via Access Object
      *
     C     ADDRSS        IFEQ      '??'
     C                   MOVEL     '?  '         ADFCCY
     C                   MOVEL     '? '          ADFNNB
     C                   END
      *
      * Look up Nostro via Access Object
      *
     C                   CALL      'AONOSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      *BLANKS       P@CUST
     C                   PARM      ADFCCY        P@CYCD
     C                   PARM      *BLANKS       P@ACCD
     C                   PARM      *BLANKS       P@ACSN
     C                   PARM      ADFNNB        P@NONB            2
     C                   PARM      *BLANKS       P@BRCD
     C                   PARM      *BLANKS       P@CSSN           10
     C                   PARM      *BLANKS       P@PNOI            1
     C     SDNOST        PARM      *BLANKS       DSFDY
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AONOSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Nostro found mark as full nostro and get GL information
      *
     C     P@RTCD        IFEQ      *BLANKS
      *
      * If selected then defer confirm
      *
     C                   MOVEL     '1'           *IN99
     C                   MOVEL     'A'           #1MDID
      *
      *  Move account fields into ADDRSS
      *
     C                   MOVEL     A7CUST        ADGCNM
     C                   MOVEL     A7CYCD        ADGCCY
     C                   MOVEL     A7ACCD        ADGACD
     C                   MOVEL     A7ACSN        ADGASQ
     C                   MOVEL     A7BRCD        ADGBRC
     C                   MOVEL     ADDRSS        #1MDEQ
     C                   MOVEL     #1MDEQ        #1MDE1
      *
     C                   END
      *
     C                   END
      *
      *  If first 6 Characters are numeric but rest is blank
      *  validate as a customer reference
      *
      *  Only validate if #1MDID is blank
      *
     C     ADCNUM        IFNE      *BLANKS
     C     ADEXCN        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     #1MDID        ANDEQ     *BLANKS
     C     ADDRSS        ANDNE     '??'
      *
      *  Check first 6 characters are numeric and rest is blank
      *
     C                   MOVEL     *BLANKS       I#FLD
     C                   MOVEL     ADDRSS        I#FLD            35
     C     DIGITS        CHECK     I#FLD         Y#                3 0    90
      *
      *  6 digits allowed
      *
     C     *IN90         IFEQ      '1'
     C     Y#            ANDEQ     7
      *
     C                   CALL      'AOCUSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      ADCNUM        P@KEY1           10
     C                   PARM      *BLANKS       P@KYST            7
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOCUSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 02 *
     C                   Z-ADD     2             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Customer not found
      *
     C     P@RTCD        IFNE      *BLANKS
     C     P@KYST        ORNE      '*CNUM  '
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3299
      * Send message 'Customer no. not found'
     C                   MOVEL     'MIN0313'     ZAMSID
     C                   MOVEL     #1MDEQ        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0313'     W0RTN
     C                   END
     C                   GOTO      VFEXIT
     C                   END
      *
      *  Customer found mark as Customer
      *
     C                   MOVEL     'C'           #1MDID
      *
     C                   END
      *
     C                   END
      *
      *  If first 10 Characters are numeric but rest is blank
      *  validate as a retail account
      *
      *  Only validate if #1MDID is blank
      *
     C     ADACNO        IFNE      *BLANKS
     C     ADEXAC        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     #1MDID        ANDEQ     *BLANKS
      *
      *  Check first 10 characters are numeric and rest is blank
      *
     C                   MOVEL     *BLANKS       I#FLD
     C                   MOVEL     ADDRSS        I#FLD            35
     C     DIGITS        CHECK     I#FLD         Y#                3 0    90
      *
      *  10 digits allowed
      *
     C     *IN90         IFEQ      '1'
     C     Y#            ANDEQ     11
      *
      *  Check account is on ACCNTAB
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD                         B:Return code
     C                   PARM      '*KEY   '     P@OPTN                         I:Option
     C                   PARM      ADACNO        P@RETL                         I:Retail key
     C                   PARM      *BLANKS       P@CUST                         I:Key field 1
     C                   PARM      *BLANKS       P@CYCD                         I:Key field 2
     C                   PARM      *BLANKS       P@ACCD                         I:Key field 3
     C                   PARM      *BLANKS       P@ACSN                         I:Key field 4
     C                   PARM      *BLANKS       P@BRCD                         I:Key field 5
     C                   PARM                    P@ACCT                         O:OUTPUT
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOACCTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 03 *
     C                   Z-ADD     3             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Account not found
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDNE     *BLANKS
     C     RECI          ORNE      'D'
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3299
      * Send message 'Account  no. not found'
     C                   MOVEL     'MIN0314'     ZAMSID
     C                   MOVEL     #1MDEQ        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0314'     W0RTN
     C                   END
     C                   GOTO      VFEXIT
     C                   END
      *
      *  Retail Account found mark as GL Account
      *
     C                   MOVEL     '1'           *IN99
     C                   MOVEL     'A'           #1MDID
      *
      *  Move account fields into ADDRSS
      *
     C                   MOVEL     CNUM          ADGCNM
     C                   MOVEL     CCY           ADGCCY
     C                   MOVEL     ACOD          ADGACD
     C                   MOVEL     ACSQ          ADGASQ
     C                   MOVEL     BRCA          ADGBRC
     C                   MOVEL     ADDRSS        #1MDEQ
     C                   MOVEL     #1MDEQ        #1MDE1
      *
     C                   END
      *
     C                   END
      *
      *  If first 10 Characters are non blank but rest is blank
      *  validate as a customer shortname
      *
      *  Only validate if #1MDID is blank
      *
     C     ADCUST        IFNE      *BLANKS
     C     ADEXCS        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     #1MDID        ANDEQ     *BLANKS
      *
      * Check if name exists
      *
     C                   CALL      'AOCUSTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      ADCUST        P@KEY1
     C                   PARM      *BLANKS       P@KYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOCUSTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 04 *
     C                   Z-ADD     4             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFNE      *BLANKS
     C********** P@KYST    OREQ '*CNUM  '                                                   MD049278
     C********** *IN99     ANDEQ'0'                                                         MD049278
     C********** P@KYST    ORNE '*CSHT  '                                                   MD049278
     C     P@KYST        ORNE      '*CNUM  '
     C     P@KYST        ANDNE     '*CSHT  '
     C     *IN99         ANDEQ     '0'
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3299
      * Send message 'Customer no. not found'
     C                   MOVEL     'MIN0313'     ZAMSID
     C                   MOVEL     #1MDEQ        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0313'     W0RTN
     C                   END
     C                   GOTO      VFEXIT
     C                   END                                                    X001
      *
      *  Customer found mark as Customer
      *
     C                   MOVEL     'C'           #1MDID
     C                   MOVEL     *BLANKS       #1MDEQ
     C                   MOVEL     BBCUST        #1MDEQ
     C                   MOVEL     #1MDEQ        #1MDE1
      *
     C                   END
      *
      *  If 18 chars have been entered and multi branched , or
      *  15 long and single branch , is a full account.
      *
     C     ADCHK1        IFNE      *BLANKS
     C     ADEXGL        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     WUMBIN        ANDEQ     'Y'
     C     #1MDID        ANDNE     'C'
     C     ADCHK1        ORNE      *BLANKS
     C     ADEXG1        ANDEQ     *BLANKS
     C     ADCH26        ANDEQ     *BLANKS
     C     WUMBIN        ANDEQ     'N'
     C     #1MDID        ANDNE     'C'
      *
      *  Customer number, account code and account sequence must be
      *  numeric
      *
     C                   MOVEL     ADGCNM        PTCNUM
     C                   MOVEL     ADGACD        PTACOD
     C                   MOVEL     ADGASQ        PTACSQ
      *
      *  Check first 12 characters are numeric
      *
     C                   MOVEL     *BLANKS       I#FLD
     C                   MOVEL     PTACCT        I#FLD            35
     C     DIGITS        CHECK     I#FLD         Y#                3 0    90
      *
      ***12*digits*allowed*************************************************                  BUG3339
      ** 18 digits allowed now since account code has been increased to 10                   BUG3339
      *
     C     *IN90         IFEQ      '1'
     C********** Y#        ANDNE13                                                           BUG3339
     C     Y#            ANDNE     19
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3299
      * Send message 'Account  no. not found'
     C                   MOVEL     'MIN0314'     ZAMSID
     C                   MOVEL     #1MDEQ        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0314'     W0RTN
     C                   END
     C                   GOTO      VFEXIT
     C                   END
      *
      *  Set up branch depending on multibranching
      *
     C     WUMBIN        IFNE      'Y'
     C                   MOVEL     BJSBRC        ADGBRC
     C                   END
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      *BLANKS       P@RETL           10            I:Retail key
     C                   PARM      ADGCNM        P@CUST            6            I:Key field 1
     C                   PARM      ADGCCY        P@CYCD            3            I:Key field 2
     C**********           PARM ADGACD    P@ACCD  4        I:Key field 3                      CGL029
     C                   PARM      ADGACD        P@ACCD           10
     C                   PARM      ADGASQ        P@ACSN            2            I:Key field 4
     C                   PARM      ADGBRC        P@BRCD            3            I:Key field 5
     C                   PARM                    P@ACCT                         O:OUTPUT
      *
      *  If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOACCTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 05 *
     C                   Z-ADD     5             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Account not found
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDNE     *BLANKS
     C     RECI          ORNE      'D'
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3299
      * Send message 'Account  no. not found'
     C                   MOVEL     'MIN0314'     ZAMSID
     C                   MOVEL     #1MDEQ        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0314'     W0RTN
     C                   END
     C                   GOTO      VFEXIT
     C                   END
      *
      *  Retail Account found mark as GL Account
      *
     C                   MOVEL     'A'           #1MDID
      *
      *  Move account fields into ADDRSS
      *
     C                   MOVEL     CNUM          ADGCNM
     C                   MOVEL     CCY           ADGCCY
     C                   MOVEL     ACOD          ADGACD
     C                   MOVEL     ACSQ          ADGASQ
     C                   MOVEL     BRCA          ADGBRC
     C                   MOVEL     ADDRSS        #1MDEQ
     C                   MOVEL     #1MDEQ        #1MDE1
      *
     C                   END
      *                                                                                       162079
      * If the value of the field has been converted into a                                   162079
      * full general ledger account, we ensure the account currency                           162079
      * is the same as the message currency (if specified)                                    162079
      *                                                                                       162079
     C     ADGCCY        IFNE      *BLANKS
     C     #1CYCD        ANDNE     *BLANKS
     C     ADGCCY        IFNE      #1CYCD
     C     W0PMT         IFEQ      'N'
     C     WWNCCY        IFNE      'Y'
     C                   MOVEL     'Y'           WWNCCY            1
     C                   SETON                                        34
     C                   SETON                                        3299
      *
     C                   MOVEL     'MIN0323'     ZAMSID
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0323'     W0RTN
     C                   ELSE
     C                   MOVEL     'N'           WWNCCY
     C                   END
     C                   END
     C                   GOTO      VFEXIT
     C                   END
     C                   END
      *
      * If still not valid report error
      *
     C     #1MDID        IFEQ      *BLANKS
      * When ? is entered we perform no validity checks
     C     W0PMT         IFEQ      'N'
     C                   SETON                                        3299
      * Send message 'Customer no. not found'
     C                   MOVEL     'MIN0313'     ZAMSID
     C                   MOVEL     #1MDEQ        ZAMSDA
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0313'     W0RTN
     C                   END
     C                   END
      *================================================================
     CSR   VFEXIT        ENDSR
      /EJECT
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
      * Cancel and exit from key screen
      *================================================================
      * USER: Exit program processing
     C                   MOVEL     *BLANK        P0RTN
      *
      * CASE: CTL.*CMD key is CF03
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   END                                                    *FI
      * CASE: CTL.*CMD key is CF12
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   END                                                    *FI
      *
      * EDTRCD: Exit program - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Exit Program Processing
     C/COPY WNCPYSRC,ME1510DEPP
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C     CSC022        IFEQ      'N'
     C                   ROLBK                                          90
     C                   ELSE
     C     WCRSKP        IFEQ      'N'
     C                   ROLBK
     C                   ELSE
     C                   SETON                                        U7U8
     C                   ENDIF
     C                   ENDIF
      *
      * Copy any undisplayed messages back to caller
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      * Initialise indicators for re-entry
     C                   MOVE      '0'           *IN
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C                   MOVEL     'MEMSG   '    ZADFMF           10
      * Define work field Action Code
     C                   MOVEL     *BLANK        WUACTC            1
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
     C                   Z-ADD     0             Q                 5 0
     C                   MOVEL     '0'           *IN77
      * Open files first time only
     C     W0OPN         IFEQ      *BLANK
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C                   OPEN      MEDECDL0
      * Signal that files are now open
     C                   MOVE      'Y'           W0OPN             1
     C                   END
      * Select initial mode
     C     @1NROP        IFEQ      *ZERO
      * Add mode
     C                   MOVEL     'ADD'         W0PMD             3
     C                   ELSE
      * Change mode
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialise program
      * Retrieve Midas Date - R10 Standard Functions  *
     C*
     C*  Set up copyright parameter
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C* Get Rundate - Rundate  *
     C*
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Set multi-branch indicator
      *
     C     WUMBIN        IFNE      'Y'                                          Multi Branched ?
     C                   MOVEL     '0'           *IN75
     C                   ELSE
     C                   MOVEL     '1'           *IN75
     C                   END
      *
      *  Extract bank details
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     SDBANK        PARM      *BLANKS       DSFDY
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     6             W0ERNB                         * DB ERROR 06 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
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
     C                   Z-ADD     7             W0ERNB                         * DB ERROR 07 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      **                                                                                      CSC022
      ** Initialize CSC022 and Skip Commit/Rollback flags                                     CSC022
      **                                                                                      CSC022
     C                   MOVE      'N'           CSC022            1
     C                   MOVE      'N'           WCRSKP            1
      **                                                                                      CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      **                                                                                      CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSC022'      @SARD             7
     C     SCSARD        PARM      SCSARD        DSFDY
      **                                                                                      CSC022
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT
     C                   IN        SCCMT
      **                                                                                      CSC022
     C     WCMTNO        IFGT      0
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MOVEA     WCJOBS        WCMT
      ** Verify if job running exists in array                                                CSC022
     C     ##JOB         LOOKUP    WCMT                                   50
     C     *IN50         IFEQ      *ON
     C                   MOVE      'Y'           WCRSKP
     C                   ENDIF
     C                   ENDIF
      **                                                                                      CSC022
     C                   ELSE
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C     @RTCD         IFNE      '*NRF'
     C                   MOVEL     'CSC022'      W0KEY
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   Z-ADD     8             W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      **                                                                                      CSC022
     C                   ENDIF
      ** For copysource SRERRC                                                                CSC022
     C                   MOVE      WCRSKP        WCMTSK            1
      **                                                                                      CSC022
      * EDTRCD: Initialise prog - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Program C-spec
     C/COPY WNCPYSRC,ME1510DCPG
      *================================================================
     CSR   ZZEXIT        ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRWIND   : Control Window Processing                         *
      *                                                               *
      *================================================================
     CSR   SRWIND        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRWIND'      @STK(Q)
      *
      * If window processing call WN0010
      *
     C     BGWDPR        IFEQ      'Y'
      *
      *    /copy to move data into the data structure fields passed
      *     as a parameter to the window controller
      *
      /COPY WNCPYSRC,ME1510MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,ME1510MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,ME1510MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,ME1510MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,ME1510MOV5
     C                   ENDSL
      *
     C                   CALL      'WN0010'
     C                   PARM      ##PGM         O#PGM            10
     C                   PARM      *BLANKS       O#CMD             2
     C                   PARM      P1ACTC        O#ACTN            1
     C                   PARM                    DATA
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM                    EXTRA           256
      *
      *   /copy to move data back from the data structure fields passed
      *    as a parameter to the window controller and control user
      *    defined processing.
      *
      /COPY WNCPYSRC,ME1510MOV6
      *
     C     *LIKE         DEFINE    O#RTN         R#RTN
     C     R#RTN         CABEQ     *BLANKS       EXWIND
      *
      *  Check return code and send message on action
      *  - set no update as some action has been specified.
      *
     C                   MOVEL     'Y'           W0DCF
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C     CSC022        IFEQ      'N'
     C                   ROLBK
     C                   ELSE
     C     WCRSKP        IFEQ      'N'
     C                   ROLBK
     C                   ELSE
     C                   SETON                                        U7U8
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
      *
      * *Return code is *User QUIT requested
      *
     C     R#RTN         WHENEQ    'Y2U9999'
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   MOVEL     'Y2U9999'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   EXSR      ZYEXPG
      *
      * *Return code is WN Window Error
      *
     C     R#RTN         WHENEQ    'USR0563'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
      * *Return code is *DBF update error
      *
     C     R#RTN         WHENEQ    'USR0567'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
      * *Return code is *Previous Screen
      *
     C     R#RTN         WHENEQ    'USR0790'
     C                   MOVEL     'MIN0001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDSL
      *
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXWIND        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
     C*
     C* File and Program Error Processing
     C*
     C*COPY*MECPYSRC,SRERRC                                                                 MD056560
     C/COPY MECPYSRC,SRERRCLE                                                               MD056560
     O*EDTRCD: Cpysrc Templates Initialise Program O-spec
     O/COPY WNCPYSRC,ME1510DOPG
**  CPY@
(c) Finastra International Limited 2001
