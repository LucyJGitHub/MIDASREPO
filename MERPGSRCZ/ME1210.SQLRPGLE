     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas ME Edit valid msg record')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Message Management Module
     F*                                                               *
     F*  ME1210   Edit Valid Msg Record     Edit record(1 screen)     *
     F*                                                               *
     F*  Function:  This program controls the display and update      *
     F*             of MEINMVPD records                               *
     F*                                                               *
     F*  Called By: ME1090  - Display Valid Message Control Data      *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD060008           Date 11May21               *
      *  Prev Amend No. MD058830           Date 01Oct21               *
      *                 MD058081           Date 11May21               *
      *                 CMG008             Date 20Feb20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013             Date 29Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 CPK001             Date 03May94               *
     F*                 069250             DATE 03MAY94               *
     F*                 S01435             DATE 29JUL93               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD060008 - Deliverable Data Split for Standing Data 2        *
      *  MD058830 - Deliverable Data Split for SDNWRKPD               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Messages Generation (Recompile over new layout*
      *                                      of SDNWRKPD)             *
     F*  CPK001 - R10.6 packaging. Move non-empty /COPY to QWINDSRC   *
     F*  069250 - Remove dummy OVRDBF command from creation parms.    *
     F*  S01435 - Incoming Message Management                         *
     F*                                                               *
     F*****************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
/****F*:*OVRDBF*(File*in*program)*(file*on*system)******************:**   069250
     F*****************************************************************
     F*EDTRCD: Cpysrc Templates Initialise Program F-spec
     F/COPY WNCPYSRC,ME1210DFPG
     FME1210DF  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Edit Valid Msg Record     Edit record(1 screen)
      *
     F*MEINMVL1* IF   E           K DISK                                                    MD058081
     F**********                           INFDS(INFDS1)                                    MD058081
     F**********                           INFSR(SRFILE)                                    MD058081
      * RTV : Incoming Valid Messages   Retrieval index
      *
     F*MEINMVL0* UF A E           K DISK    USROPN                                          MD058081
     F**********                           COMMIT                                           MD058081
     F**********                           INFSR(SRFILE)                                    MD058081
      * UPD : Incoming Valid Messages   Update index
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*  Array containing Copyright statement
     D***************** FIRST COMPILE TIME ARRAY *********************
     D*
     D*COPY*MECPYSRC,SRERRE                                                                 MD058081
     D/COPY MECPYSRC,SRERRELE                                                               MD058081
     D*
     D*  Copysource for error processing
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program E-spec
     D/COPY WNCPYSRC,ME1210DEPG
     D*COPY*MECPYSRC,SRERRI                                                                 MD058081
     D/COPY MECPYSRC,SRERRILE                                                               MD058081
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program I-spec
     D/COPY WNCPYSRC,ME1210DIPG
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
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D*@1DBRC***     E DS                  EXTNAME(MEINMVL0)                                MD058081
     D @1DBRC        E DS                  EXTNAME(MEIVMJW0)                                MD058081
     D                                     PREFIX(X)                                        MD058081
     D MEINMV        E DS                  EXTNAME(MEIVMJW0)                                MD058081
      * UPD : Incoming Valid Messages   Update index
      * Current/previous master file format fields for change control
      *
     D*#1DBRC***       DS           107                                                     MD058081
     D #1DBRC          DS           108                                                     MD058081
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D*
     D* Branch Data Structure *
     D*
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      * Sar Text details *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
     D*DSNWRK***     E DS                  EXTNAME(SDNWRKPD)                                MD058830
     D DSNWRK        E DS                  EXTNAME(SDNWKJW0)                                MD058830
     D*
     D* Data Structures for Network definition
     D*
     D*DSMTPY**      E DS                  EXTNAME(SDMTPYPD)                                MD060008
     D DSMTPY        E DS                  EXTNAME(SDMTYJW0)                                MD060008
     D*
     D* Data Structures for Message Type Definition
     D*
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS            29
      * KEY: Incoming Valid Messages   Retrieval index
      * I : MAP Network
     D  P2NWRK                 1      6
      * I : MAP Message type
     D  P2MTPY                 7      9
      * I : MAP Sender (key)
     D  P2SNDK                10     29
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
     D  #MPART                 1      2P 0
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      /EJECT
      *
      * Data to be passed to window processing
      *
     I*****/COPY WNCPYSRC,ME1210WDTA                                      CPK001
     I*COPY*QWINDSRC,ME1210WDTA                                           CPK001            MD058081
     I/COPY QWINDSRC,ME1210WDTL                                                             MD058081
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: Incoming V
      *
      *  Set up primary reference
      *
     C                   MOVEL     P2PARM        W0PREF
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
     C     #1MTPY        OREQ      *BLANK                                       Message type
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
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    MVNWRK                         Network
     C                   KFLD                    MVMTPY                         Message type
     C                   KFLD                    MVSNDK                         Sender (key)
      * Setup key
     C                   MOVEL     #1NWRK        MVNWRK                         Network
     C                   MOVEL     #1MTPY        MVMTPY                         Message type
     C                   MOVEL     #1SNDK        MVSNDK                         Sender (key)
     C*****KRTV          CHAIN     @INMVL1                            9091      *           MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINMV                                                                        MD058081
     C+ from MEIVMJW0                                                                       MD058081
     C+ where MVNWRK = :MVNWRK and MVMTPY = :MVMTPY and MVSNDK = :MVSNDK                    MD058081
     C+   and MVRECI = 'D'                                                                  MD058081
     C/END-EXEC                                                                             MD058081
     C                   SETOFF                                       9091                  MD058081
     C                   If        SQLCODE = 100                                            MD058081
     C                   SETON                                        90                    MD058081
     C                   ENDIF                                                              MD058081
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058081
     C                   SETON                                        91                    MD058081
     C                   ENDIF                                                              MD058081
                                                                                            MD058081
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        993132    *
     C                   SETON                                        33        *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, flip to add mode
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ADD'         W0PMD
      * USER: Initialise detail screen (new record)
      * EDTRCD: Init. det. scr NW - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl New Rcd
     C/COPY WNCPYSRC,ME1210DISN
     C                   ELSE
      *
      * If not insert then send record already exists
      *
     C     P1ACTC        IFEQ      'I'
     C                   MOVEA     '111'         *IN(31)
     C                   MOVEL     '1'           *IN99
      * Send message 'Already exists'
     C                   MOVEL     'MIN0198'     ZAMSID
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
     C/COPY WNCPYSRC,ME1210DSFF
      * USER: Initialise detail screen (existing record)
      * EDTRCD: Init. det. scr EX - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,ME1210DISE
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
      * Check relations
      * Check reference to Midas Message Net
     C                   EXSR      VBCKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9931      *
     C                   END
      * Check reference to Midas Message Typ
     C                   EXSR      VCCKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9932      *
     C                   END
      * USER: Validate key screen
      * EDTRCD: Valid key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Key Screen
     C/COPY WNCPYSRC,ME1210DVKS
      *
      * Network required
     C     #1NWRK        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Message type required
     C     #1MTPY        IFEQ      *BLANK                                       IF
     C                   SETON                                        9932      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
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
     C/COPY WNCPYSRC,ME1210DPKR
     C   05              MOVEL     'R'           W0TRN
      *
      * If insert go to key screen else exit
      *
     C     *IN12         IFEQ      '1'
     C     P1ACTC        IFEQ      'I'
     C                   MOVEL     'K'           W0TRN
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
      * EDTRCD: Valid det. scrn - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Detail Screen
     C/COPY WNCPYSRC,ME1210DVSF
      * USER: Validate detail screen fields
      *
      * Access Point invalid
      *
     C     #1ACPT        IFNE      '*ENTRY '                                    IF
     C     #1ACPT        ANDNE     '*FT    '
     C     #1ACPT        ANDNE     '*AUTO  '
     C     #1ACPT        OREQ      '*FT    '                                    IF
     C     BGFDTR        ANDNE     'Y'
     C     #1ACPT        OREQ      '*AUTO  '                                    IF
     C     BGFDTR        ANDNE     'Y'
     C     #1ACPT        OREQ      '*AUTO  '                                    IF
     C     BGFDTR        ANDEQ     'Y'
     C     S01482        ANDNE     'S01482'
     C                   SETON                                        9931      *
     C                   MOVEL     'MIN0205'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Include/Exclude required
      *
     C     #1INEX        IFNE      'I'                                          IF
     C     #1INEX        ANDNE     'E'                                          IF
     C                   SETON                                        9932      *
     C                   MOVEL     'MIN0206'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Validate branch if not blank
      *
     C                   MOVEL     *BLANKS       #1BRNM
      *
     C     #1BRCA        IFNE      *BLANKS                                      IF
      *
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1BRCA        P@BRCD            3            I:Key field
     C********** SDBRCH    PARM           DSFDY            O:Format                           CGL029
     C     SDBRCH        PARM                    DSSDY
      *
      * Branch not found
      *
     C                   SELECT
      *
     C     P@RTCD        WHENNE    *BLANKS
     C     P@RTCD        ANDNE     '*NOSEL '
     C                   SETON                                        9933      *
     C                   MOVEL     'MIN0146'     ZAMSID
     C                   EXSR      ZASNMS
      *
      *  If no selection
      *
     C     P@RTCD        WHENEQ    '*NOSEL '
     C                   SETON                                        9933      *
     C                   MOVEL     'MIN0178'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     *BLANKS       #1BRCA
      *
      * Branch Valid
      *
     C                   OTHER
      *
      *  If screen branch not equal to retrieved branch - defer conf
      *
     C     #1BRCA        IFNE      A8BRCD                                       IF
     C                   MOVEL     'Y'           W0DCF
     C                   END
      *
     C                   MOVEL     A8BRCD        #1BRCA
     C                   MOVEL     A8BRNM        #1BRNM
      *
     C                   ENDSL
      *
     C                   END
      *
      * Validate Pay message indicator
      *
     C     #1PMFG        IFNE      *BLANKS                                      IF
     C     #1PMFG        IFNE      'P'
     C                   SETON                                        9934      *
      * Send message 'Must be P or blank'
     C                   MOVEL     'MIN0211'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END
     C                   END
      *
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,ME1210DSFF
      * Access Point required
     C     #1ACPT        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Include/Exclude required
     C     #1INEX        IFEQ      *BLANK                                       IF
     C                   SETON                                        9932      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * USER: Validate detail screen relations
      * EDTRCD: Detail scrn rels - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Screen Relns
     C/COPY WNCPYSRC,ME1210DVSR
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
     C                   ROLBK
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * EDTRCD: Process cmds - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Process Command Keys
     C/COPY WNCPYSRC,ME1210DPCK
     C     W0PMD         IFEQ      'ADD'
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
      * Create object - Incoming Valid Messages  *
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
      * Delete object - Incoming Valid Messages  *
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
      * Change object - Incoming Valid Messages  *
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
     C     P2NWRK        IFEQ      *BLANK                                       Network
     C     P2MTPY        OREQ      *BLANK                                       Message type
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
     C                   MOVEL     *BLANK        #1ACPT                         Access Point
     C                   MOVEL     *BLANK        #1INEX                         Include/Exclude
     C                   MOVEL     *BLANK        #1BRCA                         Branch Code
     C                   MOVEL     *BLANK        #1BRNM                         Branch Name
     C                   MOVEL     *BLANK        #1PMFG                         Payment Message
     C                   MOVEL     *BLANK        #1NARR                         Narrative
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
     C                   PARM      'MIN0199'     #MSGID
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
     C                   PARM      'MIN0200'     #MSGID
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
     C                   PARM      'MIN0201'     #MSGID
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
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      'MIN0200'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM      *BLANKS       #MSGTX
      *
     C                   MOVEL     #MSGTX        ##CMD2
      *
      *
      * Amendment screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0202'     #MSGID
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
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      'MIN0200'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM      *BLANKS       #MSGTX
      *
     C                   MOVEL     #MSGTX        ##CMD2
      *
      *
      * Delete screen
      *
     C     P1ACTC        WHENEQ    'D'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0203'     #MSGID
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
      * Function keys and allow delete key
      *
     C                   MOVEL     '1'           *IN77
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0204'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
     C                   ENDSL
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @INMVL1 fields to screen
      *================================================================
     C                   MOVEL     MVRECI        #1RECI                         Record Identifi
     C                   MOVEL     MVAJOB        #1AJOB                         Job name
     C                   MOVEL     MVAACT        #1AACT                         Action Type
     C                   Z-ADD     MVRDNB        #1RDNB                         Run day number
     C                   MOVEL     MVNWRK        #1NWRK                         Network
     C                   MOVEL     MVMTPY        #1MTPY                         Message type
     C                   MOVEL     MVSNDK        #1SNDK                         Sender (key)
     C                   MOVEL     MVACPT        #1ACPT                         Access Point
     C                   MOVEL     MVINEX        #1INEX                         Include/Exclude
     C                   MOVEL     MVBRCA        #1BRCA                         Branch Code
     C                   MOVEL     MVPMFG        #1PMFG                         Payment Message
     C                   MOVEL     MVNARR        #1NARR                         Narrative
     C                   MOVEL     MVAUSR        #1AUSR                         User name
     C                   MOVEL     MVARDT        #1ARDT                         Action Date
     C                   Z-ADD     MVATIM        #1ATIM                         Action Time
      *
      * Extract branch name
      *
     C                   MOVEL     *BLANKS       #1BRNM
      *
     C     #1BRCA        IFNE      *BLANKS                                      IF
      *
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1BRCA        P@BRCD            3            I:Key field
     C********** SDBRCH    PARM           DSFDY            O:Format                           CGL029
     C     SDBRCH        PARM                    DSSDY
      *
      * Branch not found
      *
     C     P@RTCD        IFEQ      *BLANKS
      *
     C                   MOVEL     A8BRNM        #1BRNM
     C                   END
     C                   END
      *
      * Hold existing record image
     C                   eval      @1DBRC = MEINMV                                          MD058081
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
     C                   MOVEL     P2MTPY        #1MTPY                         Message type
     C                   MOVEL     P2SNDK        #1SNDK                         Sender (key)
     C                   MOVEL     *BLANKS       #1MTPD                         Msg Typ Desc.
     C                   MOVEL     *BLANKS       #1NETD                         Network Desc.
      * USER: Initialise key screen
      * EDTRCD: Init. key screen - R10 Copy source templates  *
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0199'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONKY
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       #KCMD1
      *
      * Function keys
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0200'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #KCMD2
     C*EDTRCD: Cpysrc Templates Initialise Key Screen
     C/COPY WNCPYSRC,ME1210DIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Record - Incoming Valid Messages  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @INMVL0
     C                   MOVEL     #1NWRK        MVNWRK                         Network
     C                   MOVEL     #1MTPY        MVMTPY                         Message type
     C                   MOVEL     #1SNDK        MVSNDK                         Sender (key)
     C                   MOVEL     'D'           MVRECI                         Record Identifi
     C                   MOVEL     #1ACPT        MVACPT                         Access Point
     C                   MOVEL     #1INEX        MVINEX                         Include/Exclude
     C                   MOVEL     #1BRCA        MVBRCA                         Branch Code
     C                   MOVEL     #1PMFG        MVPMFG                         Payment Message
     C                   MOVEL     #1NARR        MVNARR                         Narrative
     C                   MOVEL     ##JOB         MVAJOB                         Job name
     C                   MOVEL     ##USR         MVAUSR                         User name
     C                   Z-ADD     ##JTM         MVATIM                         Action Time
     C                   MOVEL     WUMRDT        MVARDT                         Action Date
     C                   MOVEL     'I'           MVAACT                         Action Type
     C                   Z-ADD     WURDNB        MVRDNB                         Run day number
      *
     C     KLCRSA        KLIST
     C                   KFLD                    MVNWRK                         Network
     C                   KFLD                    MVMTPY                         Message type
     C                   KFLD                    MVSNDK                         Sender (key)
      * Check for duplicate primary key
     C*****KLCRSA        SETLL     @INMVL0                                90    *           MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINMV                                                                        MD058081
     C+ from MEIVMJW0                                                                       MD058081
     C+ where MVNWRK = :MVNWRK and MVMTPY = :MVMTPY and MVSNDK = :MVSNDK                    MD058081
     C/END-EXEC                                                                             MD058081
     C                   SETOFF                                       90                    MD058081
     C                   If        SQLCODE = 0                                              MD058081
     C                   SETON                                        90                    MD058081
     C                   ENDIF                                                              MD058081
                                                                                            MD058081
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CCS0089'     W0RTN             7
      * USER: Processing if DBF record already exists
      * Change Record - Incoming Valid Messages  *
     C                   EXSR      SBCHRC
     C                   GOTO      SAEXIT
     C                   END
      *
     C**********         WRITE     @INMVL0                              91      *           MD058081
     C/EXEC SQL                                                                             MD058081
     C+ insert into MEIVMBTD                                                                MD058081
     C+ (                                                                                   MD058081
     C+   MVNWRK                                                                            MD058081
     C+  ,MVMTPY                                                                            MD058081
     C+  ,MVSNDK                                                                            MD058081
     C+  ,MVRECI                                                                            MD058081
     C+  ,MVACPT                                                                            MD058081
     C+  ,MVINEX                                                                            MD058081
     C+  ,MVBRCA                                                                            MD058081
     C+  ,MVPMFG                                                                            MD058081
     C+  ,MVNARR                                                                            MD058081
     C+  ,MVAJOB                                                                            MD058081
     C+  ,MVAUSR                                                                            MD058081
     C+  ,MVATIM                                                                            MD058081
     C+  ,MVARDT                                                                            MD058081
     C+  ,MVAACT                                                                            MD058081
     C+  ,MVRDNB                                                                            MD058081
     C+  ,MVMODE                                                                            MD058081
     C+ )                                                                                   MD058081
     C+ Values                                                                              MD058081
     C+ (                                                                                   MD058081
     C+   :MVNWRK                                                                           MD058081
     C+  ,:MVMTPY                                                                           MD058081
     C+  ,:MVSNDK                                                                           MD058081
     C+  ,:MVRECI                                                                           MD058081
     C+  ,:MVACPT                                                                           MD058081
     C+  ,:MVINEX                                                                           MD058081
     C+  ,:MVBRCA                                                                           MD058081
     C+  ,:MVPMFG                                                                           MD058081
     C+  ,:MVNARR                                                                           MD058081
     C+  ,:MVAJOB                                                                           MD058081
     C+  ,:MVAUSR                                                                           MD058081
     C+  ,:MVATIM                                                                           MD058081
     C+  ,:MVARDT                                                                           MD058081
     C+  ,:MVAACT                                                                           MD058081
     C+  ,:MVRDNB                                                                           MD058081
     C+  ,'B'                                                                               MD058081
     C+ )                                                                                   MD058081
     C/END-EXEC                                                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ insert into MEIVMXTD                                                                MD058081
     C+ (                                                                                   MD058081
     C+   MVNWRK                                                                            MD058081
     C+  ,MVMTPY                                                                            MD058081
     C+  ,MVSNDK                                                                            MD058081
     C+  ,MVRECI                                                                            MD058081
     C+  ,MVACPT                                                                            MD058081
     C+  ,MVINEX                                                                            MD058081
     C+  ,MVBRCA                                                                            MD058081
     C+  ,MVPMFG                                                                            MD058081
     C+  ,MVNARR                                                                            MD058081
     C+  ,MVAJOB                                                                            MD058081
     C+  ,MVAUSR                                                                            MD058081
     C+  ,MVATIM                                                                            MD058081
     C+  ,MVARDT                                                                            MD058081
     C+  ,MVAACT                                                                            MD058081
     C+  ,MVRDNB                                                                            MD058081
     C+  ,MVMODE                                                                            MD058081
     C+ )                                                                                   MD058081
     C+ Values                                                                              MD058081
     C+ (                                                                                   MD058081
     C+   :MVNWRK                                                                           MD058081
     C+  ,:MVMTPY                                                                           MD058081
     C+  ,:MVSNDK                                                                           MD058081
     C+  ,:MVRECI                                                                           MD058081
     C+  ,:MVACPT                                                                           MD058081
     C+  ,:MVINEX                                                                           MD058081
     C+  ,:MVBRCA                                                                           MD058081
     C+  ,:MVPMFG                                                                           MD058081
     C+  ,:MVNARR                                                                           MD058081
     C+  ,:MVAJOB                                                                           MD058081
     C+  ,:MVAUSR                                                                           MD058081
     C+  ,:MVATIM                                                                           MD058081
     C+  ,:MVARDT                                                                           MD058081
     C+  ,:MVAACT                                                                           MD058081
     C+  ,:MVRDNB                                                                           MD058081
     C+  ,'B'                                                                               MD058081
     C+ )                                                                                   MD058081
     C/END-EXEC                                                                             MD058081
      *
     C******IN91         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
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
      * Change Record - Incoming Valid Messages  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @INMVL0
     C                   MOVEL     #1NWRK        MVNWRK                         Network
     C                   MOVEL     #1MTPY        MVMTPY                         Message type
     C                   MOVEL     #1SNDK        MVSNDK                         Sender (key)
      *
     C     KLCHSB        KLIST
     C                   KFLD                    MVNWRK                         Network
     C                   KFLD                    MVMTPY                         Message type
     C                   KFLD                    MVSNDK                         Sender (key)
     C*****KLCHSB        CHAIN     @INMVL0                            9091      *           MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINMV                                                                        MD058081
     C+ from MEIVMJW0                                                                       MD058081
     C+ where MVNWRK = :MVNWRK and MVMTPY = :MVMTPY and MVSNDK = :MVSNDK                    MD058081
     C/END-EXEC                                                                             MD058081
     C                   SETOFF                                       9091                  MD058081
     C                   If        SQLCODE = 100                                            MD058081
     C                   SETON                                        90                    MD058081
     C                   ENDIF                                                              MD058081
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058081
     C                   SETON                                        91                    MD058081
     C                   ENDIF                                                              MD058081
                                                                                            MD058081
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
      * Move non-key fields to @INMVL0
     C                   MOVEL     'D'           MVRECI                         Record Identifi
     C                   MOVEL     #1ACPT        MVACPT                         Access Point
     C                   MOVEL     #1INEX        MVINEX                         Include/Exclude
     C                   MOVEL     #1BRCA        MVBRCA                         Branch Code
     C                   MOVEL     #1PMFG        MVPMFG                         Payment Message
     C                   MOVEL     #1NARR        MVNARR                         Narrative
     C                   MOVEL     ##JOB         MVAJOB                         Job name
     C                   MOVEL     ##USR         MVAUSR                         User name
     C                   Z-ADD     ##JTM         MVATIM                         Action Time
     C                   MOVEL     WUMRDT        MVARDT                         Action Date
     C                   MOVEL     'I'           MVAACT                         Action Type
     C                   Z-ADD     WURDNB        MVRDNB                         Run day number
      *
     C**********         UPDATE    @INMVL0                              91      *           MD058081
     C/EXEC SQL                                                                             MD058081
     C+ update MEIVMXTD set                                                                 MD058081
     C+   MVRECI = :MVRECI                                                                  MD058081
     C+  ,MVACPT = :MVACPT                                                                  MD058081
     C+  ,MVINEX = :MVINEX                                                                  MD058081
     C+  ,MVBRCA = :MVBRCA                                                                  MD058081
     C+  ,MVPMFG = :MVPMFG                                                                  MD058081
     C+  ,MVNARR = :MVNARR                                                                  MD058081
     C+  ,MVAJOB = :MVAJOB                                                                  MD058081
     C+  ,MVAUSR = :MVAUSR                                                                  MD058081
     C+  ,MVATIM = :MVATIM                                                                  MD058081
     C+  ,MVARDT = :MVARDT                                                                  MD058081
     C+  ,MVAACT = :MVAACT                                                                  MD058081
     C+  ,MVRDNB = :MVRDNB                                                                  MD058081
     C+ where MVNWRK = :MVNWRK and MVMTPY = :MVMTPY and MVSNDK = :MVSNDK                    MD058081
     C/END-EXEC                                                                             MD058081
     C******IN91*        IFEQ      '1'                                                      MD058081
     C                   IF        SQLCODE <> 0                                             MD058081
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
      * Delete Record - Incoming Valid Messages  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @INMVL0
     C                   MOVEL     #1NWRK        MVNWRK                         Network
     C                   MOVEL     #1MTPY        MVMTPY                         Message type
     C                   MOVEL     #1SNDK        MVSNDK                         Sender (key)
      *
     C     KLCHSC        KLIST
     C                   KFLD                    MVNWRK                         Network
     C                   KFLD                    MVMTPY                         Message type
     C                   KFLD                    MVSNDK                         Sender (key)
     C*****KLCHSC        CHAIN     @INMVL0                            9091      *           MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINMV                                                                        MD058081
     C+ from MEIVMJW0                                                                       MD058081
     C+ where MVNWRK = :MVNWRK and MVMTPY = :MVMTPY and MVSNDK = :MVSNDK                    MD058081
     C/END-EXEC                                                                             MD058081
     C                   SETOFF                                       9091                  MD058081
     C                   If        SQLCODE = 100                                            MD058081
     C                   SETON                                        90                    MD058081
     C                   ENDIF                                                              MD058081
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058081
     C                   SETON                                        91                    MD058081
     C                   ENDIF                                                              MD058081
                                                                                            MD058081
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
     C                   eval      @1DBRC = MEINMV                                          MD058081
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C*****KLCHSC        SETLL     @INMVL0                            9091      *           MD058081
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before DBF update
     C                   MOVEL     '*'           MVRECI                         Record Identifi
     C                   MOVEL     ##JOB         MVAJOB                         Job name
     C                   MOVEL     ##USR         MVAUSR                         User name
     C                   Z-ADD     ##JTM         MVATIM                         Action Time
     C                   MOVEL     WUMRDT        MVARDT                         Action Date
     C                   MOVEL     'D'           MVAACT                         Action Type
     C                   Z-ADD     WURDNB        MVRDNB                         Run day number
     C**********         UPDATE    @INMVL0                              91      *           MD058081
     C/EXEC SQL                                                                             MD058081
     C+ update MEIVMXTD set                                                                 MD058081
     C+   MVRECI = :MVRECI                                                                  MD058081
     C+  ,MVAJOB = :MVAJOB                                                                  MD058081
     C+  ,MVAUSR = :MVAUSR                                                                  MD058081
     C+  ,MVATIM = :MVATIM                                                                  MD058081
     C+  ,MVARDT = :MVARDT                                                                  MD058081
     C+  ,MVAACT = :MVAACT                                                                  MD058081
     C+  ,MVRDNB = :MVRDNB                                                                  MD058081
     C+ where MVNWRK = :MVNWRK and MVMTPY = :MVMTPY and MVSNDK = :MVSNDK                    MD058081
     C/END-EXEC                                                                             MD058081
     C******IN91*        IFEQ      '1'                                                      MD058081
     C                   IF        SQLCODE <> 0                                             MD058081
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
      * Change Record - Incoming Valid Messages  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @INMVL0
     C                   MOVEL     #1NWRK        MVNWRK                         Network
     C                   MOVEL     #1MTPY        MVMTPY                         Message type
     C                   MOVEL     #1SNDK        MVSNDK                         Sender (key)
      *
     C     KLCHSD        KLIST
     C                   KFLD                    MVNWRK                         Network
     C                   KFLD                    MVMTPY                         Message type
     C                   KFLD                    MVSNDK                         Sender (key)
     C*****KLCHSD        CHAIN     @INMVL0                            9091      *           MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINMV                                                                        MD058081
     C+ from MEIVMJW0                                                                       MD058081
     C+ where MVNWRK = :MVNWRK and MVMTPY = :MVMTPY and MVSNDK = :MVSNDK                    MD058081
     C/END-EXEC                                                                             MD058081
     C                   SETOFF                                       9091                  MD058081
     C                   If        SQLCODE = 100                                            MD058081
     C                   SETON                                        90                    MD058081
     C                   ENDIF                                                              MD058081
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058081
     C                   SETON                                        91                    MD058081
     C                   ENDIF                                                              MD058081
                                                                                            MD058081
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
     C                   eval      @1DBRC = MEINMV                                          MD058081
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C*****KLCHSD        SETLL     @INMVL0                            9091      *           MD058081
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      * Move non-key fields to @INMVL0
     C                   MOVEL     #1RECI        MVRECI                         Record Identifi
     C                   MOVEL     #1ACPT        MVACPT                         Access Point
     C                   MOVEL     #1INEX        MVINEX                         Include/Exclude
     C                   MOVEL     #1BRCA        MVBRCA                         Branch Code
     C                   MOVEL     #1PMFG        MVPMFG                         Payment Message
     C                   MOVEL     #1NARR        MVNARR                         Narrative
     C                   MOVEL     ##JOB         MVAJOB                         Job name
     C                   MOVEL     ##USR         MVAUSR                         User name
     C                   Z-ADD     ##JTM         MVATIM                         Action Time
     C                   MOVEL     WUMRDT        MVARDT                         Action Date
     C                   MOVEL     'I'           MVAACT                         Action Type
     C                   Z-ADD     WURDNB        MVRDNB                         Run day number
      *
     C**********         UPDATE    @INMVL0                              91      *           MD058081
     C/EXEC SQL                                                                             MD058081
     C+ update MEIVMXTD set                                                                 MD058081
     C+   MVRECI = :MVRECI                                                                  MD058081
     C+  ,MVACPT = :MVACPT                                                                  MD058081
     C+  ,MVINEX = :MVINEX                                                                  MD058081
     C+  ,MVBRCA = :MVBRCA                                                                  MD058081
     C+  ,MVPMFG = :MVPMFG                                                                  MD058081
     C+  ,MVNARR = :MVNARR                                                                  MD058081
     C+  ,MVAJOB = :MVAJOB                                                                  MD058081
     C+  ,MVAUSR = :MVAUSR                                                                  MD058081
     C+  ,MVATIM = :MVATIM                                                                  MD058081
     C+  ,MVARDT = :MVARDT                                                                  MD058081
     C+  ,MVAACT = :MVAACT                                                                  MD058081
     C+  ,MVRDNB = :MVRDNB                                                                  MD058081
     C+ where MVNWRK = :MVNWRK and MVMTPY = :MVMTPY and MVSNDK = :MVSNDK                    MD058081
     C/END-EXEC                                                                             MD058081
     C******IN91*        IFEQ      '1'                                                      MD058081
     C                   IF        SQLCODE <> 0                                             MD058081
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
      * Check reference to Midas Message Net
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     *BLANKS       #1NETD                         Network Desc.
      * If all low order keys not entered, exit
     C     #1NWRK        IFEQ      *BLANK                                       Network
     C                   GOTO      VBEXIT
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
      * If Network not that on screen - delay
      *
     C     EDNWRK        IFNE      #1NWRK                                                   .
     C                   MOVEL     '1'           *IN99
     C                   END
     C                   MOVEL     EDNETD        #1NETD                         Network Desc.
     C                   MOVEL     EDNWRK        #1NWRK                                     .
     C                   GOTO      VBEXIT
     C                   END
      * Send message 'Midas M1101395'
     C                   MOVEL     'MIN0084'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0084'     W0RTN
      *================================================================
     CSR   VBEXIT        ENDSR
      /EJECT
     CSR   VCCKRL        BEGSR
      *================================================================
      * Check reference to Midas Message Typ
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     *BLANKS       #1MTPD                         Msg Typ Desc.
      * If all low order keys not entered, exit
     C     #1MTPY        IFEQ      *BLANK                                       Message type
     C                   GOTO      VCEXIT
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
      * Send message 'Midas M1101260'
     C                   MOVEL     'MIN0058'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0058'     W0RTN
      *================================================================
     CSR   VCEXIT        ENDSR
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
      * EDTRCD: Exit program - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Exit Program Processing
     C/COPY WNCPYSRC,ME1210DEPP
     C                   MOVEL     *BLANK        P0RTN
      * CASE: CTL.*CMD key is CF03
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   END                                                    *FI
      * CASE: CTL.*CMD key is CF12
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
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
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
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
     C                   MOVEL     'MEMSG'       ZADFMF           10
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
     C**********         OPEN      MEINMVL0                                                 MD058081
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
     C                   MOVEL     '1'           *IN70
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
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Access SAR details file to see if S01482 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*VERIFY'     P@OPTN            7
     C                   PARM      'S01482'      @SARD             6
     C     SCSARD        PARM      *BLANKS       DSFDY
      *
      *  Allow *AUTO processing
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     'S01482'      S01482            6
     C                   END
      * EDTRCD: Initialise prog - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Program C-spec
     C/COPY WNCPYSRC,ME1210DCPG
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
      /COPY WNCPYSRC,ME1210MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,ME1210MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,ME1210MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,ME1210MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,ME1210MOV5
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
      /COPY WNCPYSRC,ME1210MOV6
      *
     C     *LIKE         DEFINE    O#RTN         R#RTN
     C     R#RTN         CABEQ     *BLANKS       EXWIND
      *
      *  Check return code and send message on action
      *  - set no update as some action has been specified.
      *
     C                   MOVEL     'Y'           W0DCF
     C                   ROLBK
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
     C*COPY*MECPYSRC,SRERRC                                                                 MD058081
     C/COPY MECPYSRC,SRERRCLE                                                               MD058081
     O*EDTRCD: Cpysrc Templates Initialise Program O-spec
     O/COPY WNCPYSRC,ME1210DOPG
**  CPY@
(c) Finastra International Limited 2001
