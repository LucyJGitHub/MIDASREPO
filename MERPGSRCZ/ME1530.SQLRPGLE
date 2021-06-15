     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas ME Message tag translation x-ref maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1530 - Edit Message Tag Translation X-ref Record           *
      *                                                               *
      *  Function:  This program controls the display and update      *
      *             of METAGTPD records.                              *
      *                                                               *
      *  Called By: ME1520 - Display Message Tag Translation          *
      *                      X-ref Records                            *
      *                                                               *
      *  Calls    : MEC1150 - Extract message information             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056560           Date 31Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 162075             Date 02Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 162671             Date 23Jun99               *
      *                 CFT002  *CREATE    Date 23Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  162075 - Correct cursor positioning                          *
      *  162671 - New field : default translation                     *
      *  CFT002 - Straight Through Processing Phase 1                 *
      *           Based on ME1530 original references HUB001/S01489   *
      *                                                               *
      *****************************************************************
      *EDTRCD: Cpysrc Templates Initialise Program F-spec
     F/COPY WNCPYSRC,ME1530DFPG
     FME1530DF  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      ** DSP : Edit Message Tag Translation X-ref record (1 screen)
      *
     FMETAGTL1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      ** RTV : Message Tag Translation X-ref Retrieval index
      *
     FMETAGTL0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFSR(SRFILE)
     F                                     RENAME(@TAGTPD:@TAGTP0)
      ** UPD : Message Tag Translation X-ref Update index
      *
     F*SDMTAGL1* IF   E           K DISK    INFSR(SRFILE)                                   MD056560
     F**********                           RENAME(@EFREJ5:@MTAGL1)                          MD056560
      * RTV : BIS危idas再BS Message File Retrieval index
      *
     F/EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   03  -  Exit program  (Command 3)                            *
      *   05  -  Refresh screen (Command 5)                           *
      *   10  -  Delete function (Command 10)                         *
      *   12  -  Previous screen (Command 12)                         *
      *   25  -  OVRDTA and OVRATR indicator                          *
      *   31  -  Invalid: #1MTPY                                      *
      *   32  -  Invalid: #1MTAG                                      *
      *   35  -  Position cursor on message type                      *   162075
      *   36  -  Position cursor on message field tag                 *   162075
      *                                                               *
      *   77  -  Insert function                                      *
      *   78  -  Add function                                         *
      *   79  -  Delete function                                      *
      *   86  -  Enable PUTOVR                                        *
      *   87  -  Enable key screen                                    *
      *   88  -  Protect key fields                                   *
      *   89  -  Add mode                                             *
      *                                                               *
      *   90  -  End of file indicator/chain fail (METAGTL1/METAGTL0) *
      *   91  -  Chain error on METAGTL1/METAGTL0                     *
      *   98  -  Force input format                                   *
      *   99  -  General error indicator                              *
      *   U7  -  Database error                                       *
      *   U8  -  Database error                                       *
      *                                                               *
      *****************************************************************
     F/EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *   BADSKY   - Display and process key screen                   *
      *   BBEXFM   - Display key screen and process HELP requests     *
      *   BDHMKY   - Process HOME key                                 *
      *   BEPRKY   - Process key screen input                         *
      *   BFVLKY   - Validate key fields                              *
      *   CADSDA   - Display and process detail screen                *
      *   CBEXFM   - Display screen and process HELP requests         *
      *   CCDSPV   - Redisplay previous screen                        *
      *   CFPRSC   - Validate record                                  *
      *   DCVLDL   - Validate details                                 *
      *   EBPR##   - Process record                                   *
      *   ECADRQ   - Process add request                              *
      *   EDDLRQ   - Process delete request                           *
      *   FACKPM   - Check passed parameters                          *
      *   GADSAK   - Set key screen conditioning indicators           *
      *   GBDSAD   - Set detail screen conditioning indicators        *
      *   MAIZ#1   - Initialise record - except for key fields        *
      *   MBFL#1   - Move @TAGTL1 fields to screen                    *
      *   MDIZ#K   - Initialise key screen                            *
      *   SCCHRC   - Delete record - Message Tag Translation          *
      *   SRWIND   - Control Window Processing                        *
      *   VDCKRL   - Check reference to message file                  *
      *   VCCKRL   - Check reference to message type                  *
      *   ZASNMS   - Send message to program's message queue          *
      *   ZXEXPG   - Cancel and exit from key screen                  *
      *   ZYEXPG   - Exit program: direct                             *
      *   ZZINIT   - Initialisation                                   *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *  Array containing Copyright statement
      *
      ***** FIRST COMPILE TIME ARRAY *****
      *
      ** Multiple message line details
      *
      *                   #FT     1  15 10   #FTM    7
      *
     D*COPY*MECPYSRC,SRERRE                                                                 MD056560
     D/COPY MECPYSRC,SRERRELE                                                               MD056560
      ** Copysource for error processing
      *
      *
     D/EJECT
      *
      *EDTRCD: Cpysrc Templates Initialise Program E-spec
     D/COPY WNCPYSRC,ME1530DEPG
     D*COPY*MECPYSRC,SRERRI                                                                 MD056560
     D/COPY MECPYSRC,SRERRILE                                                               MD056560
      ** End of Program Error Processing copysource
      *
      *
      *EDTRCD: Cpysrc Templates Initialise Program I-spec
     D/COPY WNCPYSRC,ME1530DIPG
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
      * ABO Define large string for CL Cmd
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D @1DBRC        E DS                  EXTNAME(METAGTL0)
      * UPD : Message Tag Translation X-ref Update index
      * Current/previous master file format fields for change control
      *
     D**#1DBRC****DS                             44                                           162671
     D #1DBRC          DS            45
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
      *
      * Modules Data Structure *
      *
     D DSMTPY        E DS                  EXTNAME(SDMTPYPD)
      *
      * Data Structures for Message Type Definition
      *
     D*DSMTAG***     E DS                  EXTNAME(SDMTAGPD)                                MD056560
     D DSMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
      *
      * Data Structures for Message Tag Definition
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
      *
      *
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS             8
      * KEY: Msg Tag Translation X-ref Retrieval index
      * I : MAP Message type
     D  P2MTPY                 1      3
      * I : MAP Message Field Tag
     D  P2MTAG                 4      8
     D                 DS
     D  ZAMSDA                 1    132
      *
      * Message data for 'Invalid Action code (FT)'
      * Action Code
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      *
      *  Define fields for message translation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
      /EJECT
      *
      * Data to be passed to window processing
      *
     I/COPY QWINDSRC,ME1530WDTA
     C/EJECT
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
      *
      * Perform once if all passed, else repeat
     C     W0RPT         DOUEQ     'N'
      *
      * Display and process key screen
     C                   EXSR      BADSKY
     C                   END
      *
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
      *
      * Bypass first display of key screen is possible
     C                   MOVEL     'Y'           W0BYP             1
      *
      * Signal start of transaction
     C                   MOVEL     'Y'           W0TRN             1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      *
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      *
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      *
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      *
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1MTAG        IFEQ      *BLANK                                       Message tag
     C     #1MTPY        OREQ      *BLANK                                       Message type
      *
      * One or more key fields is blank
     C                   MOVEL     'N'           W0BYP
     C                   END
     C                   END
      *
      * Bypass key screen
     C     W0BYP         IFNE      'Y'
      *
      * Display key screen
     C                   EXSR      BBEXFM
     C                   END
      *
      * Cancel key screen bypass
     C                   MOVEL     'N'           W0BYP
      *
      * Process response to key screen
      *
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
     C   12              CAS                     ZXEXPG
      *
      * HOME: Reset screen fields
     C   05              CAS                     BDHMKY
      *
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
      *
      * Update screen time
     C                   TIME                    ##TME
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      *
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
      *
      * Update job time
     C                   TIME                    ##JTM
      *
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      *
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
      *
      * If 'D' ignore key field validation
     C     P1ACTC        IFEQ      'D'
     C                   SETOFF                                       99
     C                   MOVE      '00'          *IN(31)
     C                   MOVE      '0'           *IN34
     C                   MOVE      *BLANK        W0RTN
     C                   END
      *
     C     *IN99         CABEQ     '1'           BEEXIT
      *
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    TGMTPY                         Message type
     C                   KFLD                    TGMTAG                         Message Tag
      * Setup key
     C                   MOVEL     #1MTPY        TGMTPY                         Message Type
     C                   MOVEL     #1MTAG        TGMTAG                         Message Tag
      *
     C     KRTV          CHAIN     @TAGTPD                            9091      *
     C     *IN91         IFEQ      '1'
      *
      * Record locked
     C                   SETON                                        993132    *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, flip to add mode
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ADD'         W0PMD
      *
      * USER: Initialise detail screen (new record)
      * EDTRCD: Init. det. scr NW - R10 Copy source templates  *
      *EDTRCD: Cpysrc Templates Initialise Dtl New Rcd
     C/COPY WNCPYSRC,ME1530DISN
      *
     C                   ELSE
      *
      * If insert, then send 'Record already exists'
      *
     C     P1ACTC        IFEQ      'I'
     C                   MOVEA     '11'          *IN(31)
     C                   MOVEL     '1'           *IN99
      *
      * Send message 'Already exists'
     C                   MOVEL     'MIN0304'     ZAMSID
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      BEEXIT
     C                   END
      *
      * Load screen fields from DBF
     C                   EXSR      MBFL#1
      *
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
      *EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,ME1530DCDF
      *
      * USER: Initialise detail screen (existing record)
      * EDTRCD: Init. det. scr EX - R10 Copy source templates  *
      *EDTRCD: Cpysrc Templates Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,ME1530DISE
      *
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
      *
      * To test if any ? are entered in screen fields
     C                   MOVEL     'N'           W0PMT             1
      *
      * Check reference to BIS危idas再BS Message Type
     C                   EXSR      VCCKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9931      *
     C                   END
      *
      * Check reference to BIS危idas再BS Message File
     C                   EXSR      VDCKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9932      *
     C                   END
      *                                                                                       162671
      * Check default translation                                                             162671
     C                   EXSR      VDDFLT
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9934      *
     C                   END
      *
      * USER: Validate key screen
      *
      * Make sure MTPY is not ALL
      *
     C     #1MTPY        IFEQ      'ALL'                                        IF
     C     W0PMT         IFEQ      'Y'
     C                   SETON                                        99
     C                   ELSE
     C                   SETON                                        9931      *
      *
      * Send message 'ALL message type not valid'
     C                   MOVEL     'MIN0085'     ZAMSID
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
     C                   END
      *
      * EDTRCD: Valid key screen - R10 Copy source templates  *
     C/COPY WNCPYSRC,ME1530DVKS
      *
      * Message type required  (Mandatory)
     C     #1MTPY        IFEQ      *BLANK                                       IF
     C     W0PMT         IFEQ      'Y'
     C                   SETON                                        99
     C                   ELSE
     C                   SETON                                        9931      *
      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
     C                   END                                                    FI
      *
      * Message Field Tag required
     C     #1MTAG        IFEQ      *BLANK                                       IF
     C     W0PMT         IFEQ      'Y'
     C                   SETON                                        99
     C                   ELSE
     C                   SETON                                        9932      *
      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
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
      *
      * Display detail screen
     C                   EXSR      CBEXFM
      *
      * Process response to detail screen
      *
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      *
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      *
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      *
      * Process detail screen input
     C                   CAS                     CFPRSC
     C                   END
      *
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
      *
      * Update screen time
     C                   TIME                    ##TME
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      *
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
      *
      * Update job time
     C                   TIME                    ##JTM
      *
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      *
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
      *EDTRCD: Cpysrc Templates Process Key Screen Rqst
     C/COPY WNCPYSRC,ME1530DPKR
      *
     C   05              MOVEL     'R'           W0TRN
      *
      * If insert go to key screen else exit
      *
     C     *IN12         IFEQ      '1'
     C                   MOVE      *BLANKS       BBIN89
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
      *
      * If delete is not pending....
      * Validate details
     C     P1ACTC        IFEQ      'I'
     C  N10              CAS                     DCVLDL
     C                   END
     C                   END
      *
      *  Call window processing
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      SRWIND
     C                   END
      *
      * QUIT if error:
     C   99              GOTO      CFEXIT
      *
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
      *
      * No error: update record
     C     P1ACTC        IFEQ      'I'
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
      * USER: Validate detail screen fields
      * EDTRCD: Valid det. scrn - R10 Copy source templates  *
      *EDTRCD: Cpysrc Templates Validate Detail Screen
     C/COPY WNCPYSRC,ME1530DVSF
      *
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
      *EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,ME1530DSFF
      *
      * USER: Validate detail screen relations
      * EDTRCD: Detail scrn rels - R10 Copy source templates  *
      *EDTRCD: Cpysrc Templates Validate Screen Relns
     C/COPY WNCPYSRC,ME1530DVSR
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * Process delete request
     C   10              CAS                     EDDLRQ
      *
      * Process add request
     C     W0PMD         CASEQ     'ADD'         ECADRQ
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
      *
      * Error: ROLLBACK any DBF changes
     C                   ROLBK
     C                   GOTO      EBEXIT
     C                   ELSE
      *
      * Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
      *
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * EDTRCD: Process cmds - R10 Copy source templates  *
      *EDTRCD: Cpysrc Templates Process Command Keys
     C/COPY WNCPYSRC,ME1530DPCK
      *
     C     W0PMD         IFEQ      'ADD'
      *
      * Exit after successful add
     C                   MOVEL     'R'           W0RPT
     C                   END
      *
      * Exit after successful delete
     C     *IN10         IFEQ      '1'
     C                   MOVEL     'N'           W0RPT
     C                   END
      *
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
      *
      * Create Record - Message Tag Translation  *
     C                   EXSR      SACRRC
     C     W0RTN         IFEQ      *BLANK
      *
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
      *
      * Delete Record - Message Tag Translation  *
     C                   EXSR      SCCHRC
     C     W0RTN         IFEQ      *BLANK
      *
      * Send message '*Record deleted'
     C                   MOVEL     'Y2U0013'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters
      *================================================================
      * Is full key present?
     C     P2MTAG        IFEQ      *BLANK                                       Message tag
     C     P2MTPY        OREQ      *BLANK                                       Message type
      *
      * Not every key field passed - loop program
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
      *
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
      *
      * Protect key fields on detail screen
     C                   SETON                                        88        *
     C                   MOVEL     '0'           *IN79
     C     P1ACTC        IFEQ      'D'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
      *
      * Enable key screen
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields
      *================================================================
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     *BLANK        #1RECI                         Record Identifi
     C                   MOVEL     *BLANK        #1AACT                         Action Type
     C                   Z-ADD     *ZERO         #1RDNB                         Run day number
     C                   MOVEL     *BLANK        #1AJOB                         Job name
     C                   MOVEL     *BLANK        #1AUSR                         User name
     C                   MOVEL     *BLANK        #1ARDT                         Action Date
     C                   Z-ADD     *ZERO         #1ATIM                         Action Time
      *
      * Fill Command lines and narrative text from messages
      *
     C                   SELECT
      *
      * Enquiry screen
      *
     C     P1ACTC        WHENEQ    'E'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0300'     #MSGID
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
     C                   PARM      'MIN0043'     #MSGID
     C                   PARM      'MEMSG   '    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      * Insert screen
      *
     C     P1ACTC        WHENEQ    'I'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0305'     #MSGID
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
     C                   PARM      'MIN0043'     #MSGID
     C                   PARM      'MEMSG   '    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      * Delete screen
      *
     C     P1ACTC        WHENEQ    'D'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0305'     #MSGID
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
      * Move METAGTL1 fields to screen
      *================================================================
     C                   MOVEL     TGRECI        #1RECI                         Record Identifi
     C                   MOVEL     TGAJOB        #1AJOB                         Job name
     C                   MOVEL     TGAACT        #1AACT                         Action Type
     C                   Z-ADD     TGRDNB        #1RDNB                         Run day number
     C                   MOVEL     TGMTAG        #1MTAG                         Message Tag
     C                   MOVEL     TGMTPY        #1MTPY                         Message type
     C                   MOVEL     TGAUSR        #1AUSR                         User name
     C                   MOVEL     TGARDT        #1ARDT                         Action Date
     C                   Z-ADD     TGATIM        #1ATIM                         Action Time
     C                   MOVEL     TGDFLT        #1DFLT                         Default Trns
      *
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialise key screen
      *================================================================
     C                   MOVEL     P2MTAG        #1MTAG                         Message Tag
     C                   MOVEL     P2MTPY        #1MTPY                         Message type
     C                   MOVEL     *BLANKS       #1SCFD                         Msg Tag Desc.
     C                   MOVEL     *BLANKS       #1MTPD                         Msg Typ Desc.
     C                   MOVEL     'N'           #1DFLT                         Default Trns
      *
      * USER: Initialise key screen
      * Option Name
     C                   SELECT
      *
      * Insert screen
     C     P1ACTC        WHENEQ    'I'
     C                   MOVEL     '1'           *IN77
     C                   MOVEL     'MIN0305'     #MSGID
      *
      * enquiry screen
     C     P1ACTC        WHENEQ    'E'
     C                   MOVEL     'MIN0300'     #MSGID
      *
      * Delete screen
     C     P1ACTC        WHENEQ    'D'
     C                   MOVEL     'MIN0305'     #MSGID
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
      *
      * Action codes
     C                   MOVEL     *BLANKS       #KCMD1
      *
      * Function keys
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0043'     #MSGID
     C                   PARM      'MEMSG   '    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #KCMD2
      * EDTRCD: Init. key screen - R10 Copy source templates  *
      *EDTRCD: Cpysrc Templates Initialise Key Screen
     C/COPY WNCPYSRC,ME1530DIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Record - Message Tag Translation  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      *
      * Move all fields to METAGTL0
     C                   MOVEL     #1MTAG        TGMTAG                         Message tag
     C                   MOVEL     #1MTPY        TGMTPY                         Message type
     C                   MOVEL     #1DFLT        TGDFLT                         Default Trns
     C                   MOVEL     'D'           TGRECI                         Record Identifi
     C                   MOVEL     ##JOB         TGAJOB                         Job name
     C                   MOVEL     ##USR         TGAUSR                         User name
     C                   Z-ADD     ##JTM         TGATIM                         Action Time
     C                   MOVEL     WUMRDT        TGARDT                         Action Date
     C                   MOVEL     'I'           TGAACT                         Action Type
     C                   Z-ADD     WURDNB        TGRDNB                         Run day number
      *
     C     KLCRSA        KLIST
     C                   KFLD                    TGMTPY                         Message Type
     C                   KFLD                    TGMTAG                         Message tag
      *
      * Check for duplicate primary key
     C     KLCRSA        SETLL     @TAGTP0                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CCS0093'     W0RTN             7
      * USER: Processing if DBF record already exists
      * Change Record - Incoming Msg Translation  *
     C                   EXSR      SBCHRC
     C                   GOTO      SAEXIT
     C                   END
      *
     C                   WRITE     @TAGTP0                              91      *
      *
     C     *IN91         IFEQ      '1'
      *
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   END
      *
      * DBF write successful
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Record - Message Tag Translation  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to METAGTL0
     C                   MOVEL     #1MTAG        TGMTAG                         Message tag
     C                   MOVEL     #1MTPY        TGMTPY                         Message type
      *
     C     KLCRSA        CHAIN     @TAGTP0                            9091      *
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
      * USER: Processing if DBF record already exists
      *
     C     *IN90         IFEQ      '1'
     C     TGRECI        ANDEQ     'D'
     C                   MOVEA     '11'          *IN(31)
     C                   MOVEL     '1'           *IN99
      *
      * Send message 'Already exists'
     C                   MOVEL     'MIN0304'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
      * Move non-key fields to METAGTL0
     C                   MOVEL     #1MTAG        TGMTAG                         Message tag
     C                   MOVEL     #1MTPY        TGMTPY                         Message type
     C                   MOVEL     #1DFLT        TGDFLT                         Default trns
     C                   MOVEL     'D'           TGRECI                         Record Identifi
     C                   MOVEL     ##JOB         TGAJOB                         Job name
     C                   MOVEL     ##USR         TGAUSR                         User name
     C                   Z-ADD     ##JTM         TGATIM                         Action Time
     C                   MOVEL     WUMRDT        TGARDT                         Action Date
     C                   MOVEL     'I'           TGAACT                         Action Type
     C                   Z-ADD     WURDNB        TGRDNB                         Run day number
      *
     C                   UPDATE    @TAGTP0                              91      *
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
      * Delete Record - Message Tag Translation  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      *
      * Move key fields to METAGTL0
     C                   MOVEL     #1MTAG        TGMTAG                         Message tag
     C                   MOVEL     #1MTPY        TGMTPY                         Message type
      *
     C     KLCHSC        KLIST
     C                   KFLD                    TGMTPY                         Message type
     C                   KFLD                    TGMTAG                         Message tag
      *
     C     KLCHSC        CHAIN     @TAGTP0                            9091      *
      *
     C     *IN90         IFEQ      '1'
      *
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      *
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      *
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      *
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
      * Use SETLL to release record lock
     C     KLCHSC        SETLL     @TAGTP0                            9091      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * Logically delete record
     C                   MOVEL     '*'           TGRECI                         Record Identifi
     C                   MOVEL     ##JOB         TGAJOB                         Job name
     C                   MOVEL     ##USR         TGAUSR                         User name
     C                   Z-ADD     ##JTM         TGATIM                         Action Time
     C                   MOVEL     WUMRDT        TGARDT                         Action Date
     C                   MOVEL     'D'           TGAACT                         Action Type
     C                   Z-ADD     WURDNB        TGRDNB                         Run day number
     C                   UPDATE    @TAGTP0
      *
     C     *IN91         IFEQ      '1'
      *
      * Delete record detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Delete operation successful
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   VDCKRL        BEGSR
      *================================================================
      * Check reference to BIS危idas再BS Message File
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     *BLANKS       #1SCFD                         Msg Tag Desc.
      *
      * If all low order keys not entered, exit
     C     #1MTAG        IFEQ      *BLANK                                       Message tag
     C                   GOTO      VDEXIT
     C                   END
      *
     C                   MOVEL     #1MTAG        WQM               1
     C     WQM           IFEQ      '?'
     C                   MOVEL(P)  '?'           #1MTAG
     C                   MOVEL     '1'           *IN99
     C                   MOVEL     'Y'           W0PMT
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
      *
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
     C                   END
      *
     C                   END
      *
     C     W0PMT         IFEQ      'Y'
     C                   GOTO      VDEXIT
     C                   END
      *
     C     KLVDEF        KLIST
     C                   KFLD                    EFMTAG                         Message tag
     C                   KFLD                    EFMTPY                         Message type
      * Setup key
     C                   MOVEL     #1MTAG        EFMTAG                         Message tag
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
      *
      * Record found - move back any virtuals
     C                   MOVEL     EFSCFD        #1SCFD                         Msg Tag Desc.
     C                   GOTO      VDEXIT
     C                   END
      *
      * Send message 'BIS危idas再BS Message Not Found'
     C                   MOVEL     'MIN0059'     ZAMSID
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0059'     W0RTN
      *================================================================
     CSR   VDEXIT        ENDSR
      /EJECT
     CSR   VCCKRL        BEGSR
      *================================================================
      * Check reference to BIS危idas再BS Message Type
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     *BLANKS       #1MTPD                         Msg Typ Desc.
      *
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
     C                   MOVE      *ON           *IN35                                         16207
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
      *
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
     C                   END
      *
     C     W0PMT         IFEQ      'Y'
     C                   GOTO      VCEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
     C                   GOTO      VCEXIT
     C                   END
      *
      * Send message 'BIS危idas再BS M1101260'
     C                   MOVEL     'MIN0058'     ZAMSID
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0058'     W0RTN
      *================================================================
     CSR   VCEXIT        ENDSR
      /EJECT
     CSR   VDDFLT        BEGSR
      *================================================================                       162671
      * Check default translation                                                             162671
      *================================================================                       162671
     C                   MOVEL     *BLANK        W0RTN             7
      *                                                                                       162671
      * If all low order keys not entered, exit                                               162671
     C     #1MTPY        IFEQ      *BLANK
     C     #1MTAG        OREQ      *BLANK
     C                   GOTO      DFEXIT
     C                   END
      *                                                                                       162671
     C     #1DFLT        IFNE      'Y'
     C     #1DFLT        ANDNE     'N'
     C     W0PMT         IFNE      'Y'
      *                                                                                       162671
      * Send message 'Value required Y or N'                                                  162671
     C                   MOVEL     'MIN0330'     ZAMSID
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0330'     W0RTN
     C                   GOTO      DFEXIT
     C                   END
     C                   END
      *                                                                                       162671
     C     #1DFLT        IFEQ      'Y'
     C     1             SUBST     #1MTAG:4      WTGTYP            1
     C     #1MTAG        IFNE      'SNDR'
     C     WTGTYP        ANDNE     'A'
     C     W0PMT         IFNE      'Y'
      *                                                                                       162671
      * Send message 'Default translation is not possible'                                    162671
     C                   MOVEL     'MIN0331'     ZAMSID
     C                   MOVEL     'MEMSG   '    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0331'     W0RTN
     C                   GOTO      DFEXIT
     C                   END
     C                   END
     C                   END
      *                                                                                       162671
      *================================================================                       162671
     CSR   DFEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      *
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
      *
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
     C                   MOVE      *BLANKS       BBIN89
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   END                                                    *FI
      *
      * EDTRCD: Exit program - R10 Copy source templates  *
      *EDTRCD: Cpysrc Templates Exit Program Processing
     C/COPY WNCPYSRC,ME1530DEPP
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
      *
      * Initialise indicators for re-entry
     C                   MOVE      '0'           *IN
      *
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
      * Update screen time
     C                   TIME                    ##TME             6 0
      *
      * Obtain default message file
     C                   MOVEL     'MEMSG   '    ZADFMF           10
      *
      * Define work field Action Code
     C                   MOVEL     *BLANK        WUACTC            1
      *
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
     C                   Z-ADD     0             Q                 5 0
     C                   MOVEL     '0'           *IN77
      *
      * Open files first time only
     C     W0OPN         IFEQ      *BLANK
      *
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C                   OPEN      METAGTL0
      *
      * Signal that files are now open
     C                   MOVE      'Y'           W0OPN             1
     C                   END
      *
      * Select initial mode
     C     @1NROP        IFEQ      *ZERO
      *
      * Add mode
     C                   MOVEL     'ADD'         W0PMD             3
     C                   END
      *
     C                   MOVEL     *BLANK        W0GRP             1
      *
      * USER: Initialise program
      * Retrieve Midas Date - R10 Standard Functions  *
      *
      *  Set up copyright parameter
      *
     C                   MOVEA     CPY@          BIS@             80
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
      * Get modules information
      *
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
      * EDTRCD: Initialise prog - R10 Copy source templates  *
      *EDTRCD: Cpysrc Templates Initialise Program C-spec
     C/COPY WNCPYSRC,ME1530DCPG
      *================================================================
     CSR   ZZEXIT        ENDSR
     C/EJECT
     CSR   SRWIND        BEGSR
      *================================================================
      *  SRWIND   : Control Window Processing                         *
      *================================================================
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
      /COPY WNCPYSRC,ME1530MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,ME1530MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,ME1530MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,ME1530MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,ME1530MOV5
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
      /COPY WNCPYSRC,ME1530MOV6
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
     C                   MOVEL     'MEMSG   '    ZAMSGF
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
      *
      * File and Program Error Processing
      *
     C*COPY*MECPYSRC,SRERRC                                                                 MD056560
     C/COPY MECPYSRC,SRERRCLE                                                               MD056560
      *
      *
     O*EDTRCD: Cpysrc Templates Initialise Program O-spec
     O/COPY WNCPYSRC,ME1530DOPG
**  CPY@
(c) Finastra International Limited 2001
