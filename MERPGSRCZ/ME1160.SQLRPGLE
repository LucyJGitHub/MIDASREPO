     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas ME Message translation maintenance')             *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Message Management Module
     F*                                                               *
     F*  ME1160 - Edit Message Translation  Edit record(1 screen)     *
     F*                                                               *
     F*  Function:  This program controls the display and update      *
     F*             of MEINFMPD records                               *
     F*                                                               *
     F*  Called By: ME1150  - Display Message Translation Records     *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD056752           Date 20Sep20               *
      *  Prev Amend No. MD056560           Date 31Aug20               *
      *                 CMG008             Date 20Feb20               *
      *                 CSW218             Date 19Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24704           Date 30Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSC022             Date 24Feb04               *
      *                 CGL013             Date 29Mar02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204989             Date 27May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006             Date 02Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CRT002             Date 01Dec95               *
     F*  Prev Amend No. CPK001             Date 03MAY94               *
     F*                 069250             DATE 03MAY94               *
     F*                 S01435             DATE 29JUL93               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD056752 - Deliverable Data Split for MEINFMPD               *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  CSW218 - SWIFT Changes 2018                                  *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  BUG24704 - Invalid field being highlighted                   *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  CGL013 - MT94x Messages Generation (Recompile over new layout*
      *                                      of SDNWRKPD)             *
      *  204989 - Add field name 'MSG IND/TL'.                        *
      *  CFT014 - Straight-through processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
     F*  CFT006 - MT101/2 message addtion for outgoing/incoming RFT   *
     F*  CRT002 - Retail Branch Access.                               *
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
     F/COPY WNCPYSRC,ME1160DFPG
     FME1160DF  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Edit Message Translation  Edit record(1 screen)
      *
     F*MEINFML1* IF   E           K DISK                                                    MD056752
     F**********                           INFDS(INFDS1)                                    MD056752
     F**********                           INFSR(SRFILE)                                    MD056752
      * RTV : Incoming Msg Translation  Retrieval index
      *
     F*MEINFML0* UF A E           K DISK    USROPN                                          MD056752
     F**********                           COMMIT                                           MD056752
     F**********                           INFSR(SRFILE)                                    MD056752
      * UPD : Incoming Msg Translation  Update index
      *
     F*SDMTAGL1* IF   E           K DISK    INFSR(SRFILE)                                   MD056560
     F**********                           RENAME(@EFREJ5:@MTAGL1)                          MD056560
      * RTV : Midas Message Fie Retrieval index
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*  Array containing Copyright statement
     D***************** FIRST COMPILE TIME ARRAY *********************
      *
      *  Multiple message line details
      *
     D********************#FT     1  15 10   #FTM    7                    CRT002
     D********************#FT     1  18 10   #FTM    7              CRT002CFT006
     D***********         #FT     1  52 10   #FTM    7             CFT006 CFT014
     D**********          #FT     1  55 10   #FTM    7                                 CFT014 204989
     D**********          #FT     1  56 10   #FTM    7                                 204989 CSW209
     D**********          #FT     1  69 10   #FTM    7                                 CSW209 CER030
     D**********          #FT     1  70 10   #FTM    7                                 CER030 CSW218
     D #FT             S             10    DIM(72) CTDATA PERRCD(1)
     D #FTM            S              7    DIM(72) ALT(#FT)
     D P#FT            S             10    DIM(200)                                              CFT
     D P#FTM           S              7    DIM(200)                                              CFT
     D*
     D*COPY*MECPYSRC,SRERRE                                                                 MD056560
     D/COPY MECPYSRC,SRERRELE                                                               MD056560
     D*
     D*  Copysource for error processing
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program E-spec
     D/COPY WNCPYSRC,ME1160DEPG
     D*COPY*MECPYSRC,SRERRI                                                                 MD056560
     D/COPY MECPYSRC,SRERRILE                                                               MD056560
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program I-spec
     D/COPY WNCPYSRC,ME1160DIPG
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
     D*@1DBRC**      E DS                  EXTNAME(MEINFML0)                                MD056752
     D @1DBRC        E DS                  EXTNAME(MEINFJW0)                                MD056752
     D                                     PREFIX(@)                                        MD056752
     D MEINFM        E DS                  EXTNAME(MEINFJW0)                                MD056752
      * UPD : Incoming Msg Translation  Update index
      * Current/previous master file format fields for change control
      *
     D***#1DBRC*     DS                            100                                        CSW209
     D #1DBRC          DS           103
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
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D* Data Structures used by Access Programs
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D*
     D* Data Structures used by Access Programs
     D*
     D DSNWRK        E DS                  EXTNAME(SDNWRKPD)
     D*
     D* Data Structures for Network definition
     D*
     D DSMTPY        E DS                  EXTNAME(SDMTPYPD)
     D*
     D* Data Structures for Message Type Definition
     D*
     D*DSMTAG***     E DS                  EXTNAME(SDMTAGPD)                                MD056560
     D DSMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
     D*
     D* Data Structures for Message Tag Definition
     D*
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D***P2PARM*     DS                             24                                        CSW209
     D P2PARM          DS            27
      * KEY: Incoming Msg Translation  Retrieval index
      * I : MAP Network
     D  P2NWRK                 1      6
      * I : MAP Message type
     D  P2MTPY                 7      9
      * I : MAP Message Sequence                                                              CSW209
     D  P2MSEQ                10     12
      * I : MAP Message Field Tag
     D**********                             10  14 P2MTAG                                    CSW209
     D  P2MTAG                13     17
      * I : MAP FT Field Name
     D**********                             15  24 P2FTFD                                    CSW209
     D  P2FTFD                18     27
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
      /EJECT
      *
      * Data to be passed to window processing
      *
     I*****/COPY WNCPYSRC,ME1160WDTA                                      CPK001
     I*COPY*QWINDSRC,ME1160WDTA                                           CPK001            MD056752
     I/COPY QWINDSRC,ME1160WDTL                                                             MD056752
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: Incoming M
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
     C     #1MTAG        OREQ      *BLANK                                       Message Field T
     C     #1FTFD        OREQ      *BLANK                                       FT Field Name
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
     C                   KFLD                    FMNWRK                         Network
     C                   KFLD                    FMMTPY                         Message type
     C                   KFLD                    FMMSEQ                         Message Seq
     C                   KFLD                    FMMTAG                         Message Field T
     C                   KFLD                    FMFTFD                         FT Field Name
      * Setup key
     C                   MOVEL     #1NWRK        FMNWRK                         Network
     C                   MOVEL     #1MTPY        FMMTPY                         Message type
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     #1MSEQ        FMMSEQ                         MESSAGE SEQ
     C                   ELSE
     C                   MOVEL     *BLANKS       FMMSEQ
     C                   ENDIF
      *                                                                                       CSW209
     C                   MOVEL     #1MTAG        FMMTAG                         Message Field T
     C                   MOVEL     #1FTFD        FMFTFD                         FT Field Name
     C*****KRTV*         CHAIN     @INFML1                            9091      *           MD056752
     C/EXEC SQL                                                                             MD056752
     C+ SELECT *                                                                            MD056752
     C+ into :MEINFM                                                                        MD056752
     C+ from MEINFJW0                                                                       MD056752
     C+ where FMNWRK = :FMNWRK and FMMTPY = :FMMTPY and FMMSEQ = :FMMSEQ                    MD056752
     C+ and FMMTAG = :FMMTAG and FMFTFD = :FMFTFD and FMRECI = 'D'                          MD056752
     C/END-EXEC                                                                             MD056752
     C******IN91         IFEQ      '1'                                                      MD056752
     C     SQLCODE       IFLT      0                                                        MD056752
      * Record locked
     C                   SETON                                        993132    *
     C                   SETON                                        3334      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, flip to add mode
     C******IN90         IFEQ      '1'                                                      MD056752
     C     SQLCODE       IFEQ      100                                                      MD056752
     C                   MOVEL     'ADD'         W0PMD
      * USER: Initialise detail screen (new record)
      * EDTRCD: Init. det. scr NW - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl New Rcd
     C/COPY WNCPYSRC,ME1160DISN
     C                   ELSE
      *
      * If not insert then send record already exists
      *
     C     P1ACTC        IFEQ      'I'
     C                   MOVEA     '1111'        *IN(31)
     C                   MOVEL     '1'           *IN99
      * Send message 'Already exists'
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
     C/COPY WNCPYSRC,ME1160DCDF
      * USER: Initialise detail screen (existing record)
      * EDTRCD: Init. det. scr EX - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,ME1160DISE
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
      * Check reference to Midas Message Fie
     C                   EXSR      VDCKRL
     C     W0RTN         IFNE      *BLANK
     C     CSW209        IFEQ      'Y'
     C**********           SETON                     9935                            CSW209 BUG24704
     C                   SETON                                        993533
     C                   ELSE
     C**********           SETON                     9933  *                                BUG24704
     C                   SETON                                        993335    *
     C                   ENDIF
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
      *
      * Check FT Field Name is valid
      *
     C     '?'           SCAN      #1FTFD                                 90            CFT006
     C     *IN90         IFEQ      '1'                                                  CFT006
     C     *LIKE         DEFINE    #1FTFD        P#FTFD                                 CFT006
     C                   CALL      'ME1320'                                             CFT006
     C                   PARM                    P#FT                                   CFT006
     C                   PARM                    P#FTM                                  CFT006
     C                   PARM                    P#FTFD                                 CFT006
     C     P#FTFD        IFNE      *BLANK                                               CFT006
     C                   MOVEL     P#FTFD        #1FTFD                                 CFT006
     C                   ENDIF                                                          CFT006
     C                   ENDIF                                                          CFT006
      *                                                            CFT006
     C                   MOVEL     *BLANKS       #1FTFN
     C                   Z-ADD     1             X                 5 0
     C     #1FTFD        LOOKUP    #FT(X)                                 90
     C/COPY WNCPYSRC,ME1160C001
     C     *IN90         IFEQ      '0'                                          IF
     C                   SETON                                        9934      *
      * Send message 'FT Field is not valid'
     C*********************MOVEL'MIN0067' ZAMSID                   CFT006
     C                   MOVEL     'MIN0370'     ZAMSID                                 CFT006
     C                   EXSR      ZASNMS
     C                   ELSE
      *
      * Extract Text for option
      *
     C                   MOVEL     #FTM(X)       #MSGID
     C                   CALL      'MEC1150'                            9090
     C                   PARM                    #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #1FTFN
     C                   END                                                    FI
      * EDTRCD: Valid key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Key Screen
     C/COPY WNCPYSRC,ME1160DVKS
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
      * Message Field Tag required
     C     #1MTAG        IFEQ      *BLANK                                       IF
     C                   SETON                                        9933      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * FT Field Name required
     C     #1FTFD        IFEQ      *BLANK                                       IF
     C                   SETON                                        9934      *
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
     C/COPY WNCPYSRC,ME1160DPKR
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
      * USER: Validate detail screen fields
      * EDTRCD: Valid det. scrn - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Detail Screen
     C/COPY WNCPYSRC,ME1160DVSF
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,ME1160DSFF
      * USER: Validate detail screen relations
      * EDTRCD: Detail scrn rels - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Screen Relns
     C/COPY WNCPYSRC,ME1160DVSR
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
     C/COPY WNCPYSRC,ME1160DPCK
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
     C     P2NWRK        IFEQ      *BLANK                                       Network
     C     P2MTPY        OREQ      *BLANK                                       Message type
     C     P2MTAG        OREQ      *BLANK                                       Message Field T
     C     P2FTFD        OREQ      *BLANK                                       FT Field Name
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
     C                   MOVEL     *BLANK        #1FTSP                         Special Instruc
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
     C                   PARM      'MIN0060'     #MSGID
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
      * Enquiry screen
      *
     C     P1ACTC        WHENEQ    'E'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0062'     #MSGID
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
     C                   PARM      'MIN0063'     #MSGID
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
      * Delete screen
      *
     C     P1ACTC        WHENEQ    'D'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0064'     #MSGID
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
      * Move @INFML1 fields to screen
      *================================================================
     C                   MOVEL     FMRECI        #1RECI                         Record Identifi
     C                   MOVEL     FMAJOB        #1AJOB                         Job name
     C                   MOVEL     FMAACT        #1AACT                         Action Type
     C                   Z-ADD     FMRDNB        #1RDNB                         Run day number
     C                   MOVEL     FMNWRK        #1NWRK                         Network
     C                   MOVEL     FMMTPY        #1MTPY                         Message type
     C                   MOVEL     FMMTAG        #1MTAG                         Message Field T
     C                   MOVEL     FMFTFD        #1FTFD                         FT Field Name
     C                   MOVEL     FMFTSP        #1FTSP                         Special Instruc
     C                   MOVEL     FMNARR        #1NARR                         Narrative
     C                   MOVEL     FMAUSR        #1AUSR                         User name
     C                   MOVEL     FMARDT        #1ARDT                         Action Date
     C                   Z-ADD     FMATIM        #1ATIM                         Action Time
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
     C                   MOVEL     P2MTPY        #1MTPY                         Message type
     C                   MOVEL     P2MSEQ        #1MSEQ                         FT Message seq
     C                   MOVEL     P2MTAG        #1MTAG                         Message Field T
     C                   MOVEL     P2FTFD        #1FTFD                         FT Field Name
     C                   MOVEL     *BLANKS       #1SCFD                         Msg Tag Desc.
     C                   MOVEL     *BLANKS       #1MTPD                         Msg Typ Desc.
     C                   MOVEL     *BLANKS       #1NETD                         Network Desc.
     C                   MOVEL     *BLANKS       #1FTFN                         Ft Field Dsc.
      * USER: Initialise key screen
      *
      * Option Name
      *
     C                   MOVEL     '1'           *IN77
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0060'     #MSGID
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
     C                   PARM      'MIN0061'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #KCMD2
      * EDTRCD: Init. key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Key Screen
     C/COPY WNCPYSRC,ME1160DIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Record - Incoming Msg Translation  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @INFML0
     C                   MOVEL     #1NWRK        FMNWRK                         Network
     C                   MOVEL     #1MTPY        FMMTPY                         Message type
     C                   MOVEL     #1MTAG        FMMTAG                         Message Field T
     C                   MOVEL     #1FTFD        FMFTFD                         FT Field Name
     C                   MOVEL     #1FTSP        FMFTSP                         Special Instruc
     C                   MOVEL     #1NARR        FMNARR                         Narrative
     C                   MOVEL     'D'           FMRECI                         Record Identifi
     C                   MOVEL     ##JOB         FMAJOB                         Job name
     C                   MOVEL     ##USR         FMAUSR                         User name
     C                   Z-ADD     ##JTM         FMATIM                         Action Time
     C                   MOVEL     WUMRDT        FMARDT                         Action Date
     C                   MOVEL     'I'           FMAACT                         Action Type
     C                   Z-ADD     WURDNB        FMRDNB                         Run day number
      *
     C     KLCRSA        KLIST
     C                   KFLD                    FMNWRK                         Network
     C                   KFLD                    FMMTPY                         Message type
     C                   KFLD                    FMMSEQ                         Message seq
     C                   KFLD                    FMMTAG                         Message Field T
     C                   KFLD                    FMFTFD                         FT Field Name
      * Check for duplicate primary key
     C*****KLCRSA        SETLL     @INFML0                                90    *           MD056752
     C/EXEC SQL                                                                             MD056752
     C+ SELECT *                                                                            MD056752
     C+ into :MEINFM                                                                        MD056752
     C+ from MEINFJW0                                                                       MD056752
     C+ where FMNWRK = :FMNWRK and FMMTPY = :FMMTPY and FMMSEQ = :FMMSEQ                    MD056752
     C+ and FMMTAG = :FMMTAG and FMFTFD = :FMFTFD                                           MD056752
     C/END-EXEC                                                                             MD056752
     C******IN90         IFEQ      '1'                                                      MD056752
     C                   IF        SQLCODE = 0                                              MD056752
     C                   MOVEL     'CCS0093'     W0RTN             7
      * USER: Processing if DBF record already exists
      * Change Record - Incoming Msg Translation  *
     C                   EXSR      SBCHRC
     C                   GOTO      SAEXIT
     C                   END
      *
     C**********         WRITE     @INFML0                              91      *           MD056752
     C/EXEC SQL                                                                             MD056752
     C+ insert into MEINFBTD                                                                MD056752
     C+ (                                                                                   MD056752
     C+   FMNWRK                                                                            MD056752
     C+ , FMMTPY                                                                            MD056752
     C+ , FMMTAG                                                                            MD056752
     C+ , FMFTFD                                                                            MD056752
     C+ , FMFTSP                                                                            MD056752
     C+ , FMNARR                                                                            MD056752
     C+ , FMRECI                                                                            MD056752
     C+ , FMAJOB                                                                            MD056752
     C+ , FMAUSR                                                                            MD056752
     C+ , FMATIM                                                                            MD056752
     C+ , FMARDT                                                                            MD056752
     C+ , FMAACT                                                                            MD056752
     C+ , FMRDNB                                                                            MD056752
     C+ , FMMSEQ                                                                            MD056752
     C+ , FMMODE                                                                            MD056752
     C+ )                                                                                   MD056752
     C+ Values                                                                              MD056752
     C+ (                                                                                   MD056752
     C+   :FMNWRK                                                                           MD056752
     C+ , :FMMTPY                                                                           MD056752
     C+ , :FMMTAG                                                                           MD056752
     C+ , :FMFTFD                                                                           MD056752
     C+ , :FMFTSP                                                                           MD056752
     C+ , :FMNARR                                                                           MD056752
     C+ , :FMRECI                                                                           MD056752
     C+ , :FMAJOB                                                                           MD056752
     C+ , :FMAUSR                                                                           MD056752
     C+ , :FMATIM                                                                           MD056752
     C+ , :FMARDT                                                                           MD056752
     C+ , :FMAACT                                                                           MD056752
     C+ , :FMRDNB                                                                           MD056752
     C+ , :FMMSEQ                                                                           MD056752
     C+ , 'B'                                                                               MD056752
     C+ )                                                                                   MD056752
     C/END-EXEC                                                                             MD056752
     C/EXEC SQL                                                                             MD056752
     C+ insert into MEINFXTD                                                                MD056752
     C+ (                                                                                   MD056752
     C+   FMNWRK                                                                            MD056752
     C+ , FMMTPY                                                                            MD056752
     C+ , FMMTAG                                                                            MD056752
     C+ , FMFTFD                                                                            MD056752
     C+ , FMFTSP                                                                            MD056752
     C+ , FMNARR                                                                            MD056752
     C+ , FMRECI                                                                            MD056752
     C+ , FMAJOB                                                                            MD056752
     C+ , FMAUSR                                                                            MD056752
     C+ , FMATIM                                                                            MD056752
     C+ , FMARDT                                                                            MD056752
     C+ , FMAACT                                                                            MD056752
     C+ , FMRDNB                                                                            MD056752
     C+ , FMMSEQ                                                                            MD056752
     C+ , FMMODE                                                                            MD056752
     C+ )                                                                                   MD056752
     C+ Values                                                                              MD056752
     C+ (                                                                                   MD056752
     C+   :FMNWRK                                                                           MD056752
     C+ , :FMMTPY                                                                           MD056752
     C+ , :FMMTAG                                                                           MD056752
     C+ , :FMFTFD                                                                           MD056752
     C+ , :FMFTSP                                                                           MD056752
     C+ , :FMNARR                                                                           MD056752
     C+ , :FMRECI                                                                           MD056752
     C+ , :FMAJOB                                                                           MD056752
     C+ , :FMAUSR                                                                           MD056752
     C+ , :FMATIM                                                                           MD056752
     C+ , :FMARDT                                                                           MD056752
     C+ , :FMAACT                                                                           MD056752
     C+ , :FMRDNB                                                                           MD056752
     C+ , :FMMSEQ                                                                           MD056752
     C+ , 'B'                                                                               MD056752
     C+ )                                                                                   MD056752
     C/END-EXEC                                                                             MD056752
      *
     C******IN91         IFEQ      '1'                                                      MD056752
     C                   IF        SQLCODE <> 0                                             MD056752
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
      * Move key fields to @INFML0
     C                   MOVEL     #1NWRK        FMNWRK                         Network
     C                   MOVEL     #1MTPY        FMMTPY                         Message type
     C                   MOVEL     #1MTAG        FMMTAG                         Message Field T
     C                   MOVEL     #1FTFD        FMFTFD                         FT Field Name
      *
     C     KLCHSB        KLIST
     C                   KFLD                    FMNWRK                         Network
     C                   KFLD                    FMMTPY                         Message type
     C                   KFLD                    FMMSEQ                         Message seq
     C                   KFLD                    FMMTAG                         Message Field T
     C                   KFLD                    FMFTFD                         FT Field Name
     C*****KLCHSB        CHAIN     @INFML0                            9091      *           MD056752
     C/EXEC SQL                                                                             MD056752
     C+ SELECT *                                                                            MD056752
     C+ into :MEINFM                                                                        MD056752
     C+ from MEINFJW0                                                                       MD056752
     C+ where FMNWRK = :FMNWRK and FMMTPY = :FMMTPY and FMMSEQ = :FMMSEQ                    MD056752
     C+ and FMMTAG = :FMMTAG and FMFTFD = :FMFTFD                                           MD056752
     C/END-EXEC                                                                             MD056752
      *
     C******IN90         IFEQ      '1'                                                      MD056752
     C                   IF        SQLCODE = 100                                            MD056752
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C******IN91         IFEQ      '1'                                                      MD056752
     C                   IF        SQLCODE < 0                                              MD056752
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
     C                   END
      *
      * Move non-key fields to @INFML0
     C                   MOVEL     #1FTSP        FMFTSP                         Special Instruc
     C                   MOVEL     #1NARR        FMNARR                         Narrative
     C                   MOVEL     'D'           FMRECI                         Record Identifi
     C                   MOVEL     ##JOB         FMAJOB                         Job name
     C                   MOVEL     ##USR         FMAUSR                         User name
     C                   Z-ADD     ##JTM         FMATIM                         Action Time
     C                   MOVEL     WUMRDT        FMARDT                         Action Date
     C                   MOVEL     'I'           FMAACT                         Action Type
     C                   Z-ADD     WURDNB        FMRDNB                         Run day number
      *
     C**********         UPDATE    @INFML0                              91      *           MD056752
     C/EXEC SQL                                                                             MD056752
     C+ update MEINFXTD SET                                                                 MD056752
     C+    FMFTSP = :FMFTSP                                                                 MD056752
     C+  , FMNARR = :FMNARR                                                                 MD056752
     C+  , FMRECI = :FMRECI                                                                 MD056752
     C+  , FMAJOB = :FMAJOB                                                                 MD056752
     C+  , FMAUSR = :FMAUSR                                                                 MD056752
     C+  , FMATIM = :FMATIM                                                                 MD056752
     C+  , FMARDT = :FMARDT                                                                 MD056752
     C+  , FMAACT = :FMAACT                                                                 MD056752
     C+  , FMRDNB = :FMRDNB                                                                 MD056752
     C+ where FMNWRK = :FMNWRK and FMMTPY = :FMMTPY and FMMSEQ = :FMMSEQ                    MD056752
     C+ and FMMTAG = :FMMTAG and FMFTFD = :FMFTFD                                           MD056752
     C/END-EXEC                                                                             MD056752
     C******IN91         IFEQ      '1'                                                      MD056752
     C                   IF        SQLCODE <> 0                                             MD056752
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
     C                   MOVEL     #1NWRK        FMNWRK                         Network
     C                   MOVEL     #1MTPY        FMMTPY                         Message type
     C                   MOVEL     #1MTAG        FMMTAG                         Message Field T
     C                   MOVEL     #1FTFD        FMFTFD                         FT Field Name
      *
     C     KLCHSC        KLIST
     C                   KFLD                    FMNWRK                         Network
     C                   KFLD                    FMMTPY                         Message type
     C                   KFLD                    FMMSEQ                         Message seq
     C                   KFLD                    FMMTAG                         Message Field T
     C                   KFLD                    FMFTFD                         FT Field Name
     C*****KLCHSC        CHAIN     @INFML0                            9091      *           MD056752
     C/EXEC SQL                                                                             MD056752
     C+ SELECT *                                                                            MD056752
     C+ into :MEINFM                                                                        MD056752
     C+ from MEINFJW0                                                                       MD056752
     C+ where FMNWRK = :FMNWRK and FMMTPY = :FMMTPY and FMMSEQ = :FMMSEQ                    MD056752
     C+ and FMMTAG = :FMMTAG and FMFTFD = :FMFTFD                                           MD056752
     C/END-EXEC                                                                             MD056752
      *
     C******IN90         IFEQ      '1'                                                      MD056752
     C                   IF        SQLCODE = 100                                            MD056752
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C******IN91         IFEQ      '1'                                                      MD056752
     C                   IF        SQLCODE < 0                                              MD056752
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
     C*****KLCHSC        SETLL     @INFML0                            9091      *           MD056752
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before DBF update
     C                   MOVEL     'D'           FMAACT                         Action Type
     C                   MOVEL     '*'           FMRECI                         Record Identifi
     C                   MOVEL     ##JOB         FMAJOB                         Job name
     C                   MOVEL     ##USR         FMAUSR                         User name
     C                   Z-ADD     ##JTM         FMATIM                         Action Time
     C                   MOVEL     WUMRDT        FMARDT                         Action Date
     C                   Z-ADD     WURDNB        FMRDNB                         Run day number
     C**********         UPDATE    @INFML0                              91      *           MD056752
     C/EXEC SQL                                                                             MD056752
     C+ update MEINFXTD SET                                                                 MD056752
     C+    FMRECI = :FMRECI                                                                 MD056752
     C+  , FMAJOB = :FMAJOB                                                                 MD056752
     C+  , FMAUSR = :FMAUSR                                                                 MD056752
     C+  , FMATIM = :FMATIM                                                                 MD056752
     C+  , FMARDT = :FMARDT                                                                 MD056752
     C+  , FMAACT = :FMAACT                                                                 MD056752
     C+  , FMRDNB = :FMRDNB                                                                 MD056752
     C+ where FMNWRK = :FMNWRK and FMMTPY = :FMMTPY and FMMSEQ = :FMMSEQ                    MD056752
     C+ and FMMTAG = :FMMTAG and FMFTFD = :FMFTFD                                           MD056752
     C/END-EXEC                                                                             MD056752
     C******IN91         IFEQ      '1'                                                      MD056752
     C                   IF        SQLCODE <> 0                                             MD056752
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
      * Move key fields to @INFML0
     C                   MOVEL     #1NWRK        FMNWRK                         Network
     C                   MOVEL     #1MTPY        FMMTPY                         Message type
     C                   MOVEL     #1MTAG        FMMTAG                         Message Field T
     C                   MOVEL     #1FTFD        FMFTFD                         FT Field Name
      *
     C     KLCHSD        KLIST
     C                   KFLD                    FMNWRK                         Network
     C                   KFLD                    FMMTPY                         Message type
     C                   KFLD                    FMMSEQ                         Message seq
     C                   KFLD                    FMMTAG                         Message Field T
     C                   KFLD                    FMFTFD                         FT Field Name
     C*****KLCHSD        CHAIN     @INFML0                            9091      *           MD056752
     C/EXEC SQL                                                                             MD056752
     C+ SELECT *                                                                            MD056752
     C+ into :MEINFM                                                                        MD056752
     C+ from MEINFJW0                                                                       MD056752
     C+ where FMNWRK = :FMNWRK and FMMTPY = :FMMTPY and FMMSEQ = :FMMSEQ                    MD056752
     C+ and FMMTAG = :FMMTAG and FMFTFD = :FMFTFD                                           MD056752
     C/END-EXEC                                                                             MD056752
      *
     C******IN90         IFEQ      '1'                                                      MD056752
     C                   IF        SQLCODE = 100                                            MD056752
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C******IN91         IFEQ      '1'                                                      MD056752
     C                   IF        SQLCODE < 0                                              MD056752
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
     C*****KLCHSD        SETLL     @INFML0                            9091      *           MD056752
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      * Move non-key fields to @INFML0
     C                   MOVEL     #1FTSP        FMFTSP                         Special Instruc
     C                   MOVEL     #1NARR        FMNARR                         Narrative
     C                   MOVEL     'D'           FMRECI                         Record Identifi
     C                   MOVEL     ##JOB         FMAJOB                         Job name
     C                   MOVEL     ##USR         FMAUSR                         User name
     C                   Z-ADD     ##JTM         FMATIM                         Action Time
     C                   MOVEL     WUMRDT        FMARDT                         Action Date
     C                   MOVEL     'A'           FMAACT                         Action Type
     C                   Z-ADD     WURDNB        FMRDNB                         Run day number
      *
     C***********        UPDATE    @INFML0                              91      *           MD056752
     C/EXEC SQL                                                                             MD056752
     C+ update MEINFXTD SET                                                                 MD056752
     C+    FMFTSP = :FMFTSP                                                                 MD056752
     C+  , FMNARR = :FMNARR                                                                 MD056752
     C+  , FMRECI = :FMRECI                                                                 MD056752
     C+  , FMAJOB = :FMAJOB                                                                 MD056752
     C+  , FMAUSR = :FMAUSR                                                                 MD056752
     C+  , FMATIM = :FMATIM                                                                 MD056752
     C+  , FMARDT = :FMARDT                                                                 MD056752
     C+  , FMAACT = :FMAACT                                                                 MD056752
     C+  , FMRDNB = :FMRDNB                                                                 MD056752
     C+ where FMNWRK = :FMNWRK and FMMTPY = :FMMTPY and FMMSEQ = :FMMSEQ                    MD056752
     C+ and FMMTAG = :FMMTAG and FMFTFD = :FMFTFD                                           MD056752
     C/END-EXEC                                                                             MD056752
     C******IN91         IFEQ      '1'                                                      MD056752
     C                   IF        SQLCODE <> 0                                             MD056752
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
      * If Network that on screen - delay
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
     CSR   VDCKRL        BEGSR
      *================================================================
      * Check reference to Midas Message Fie
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     *BLANKS       #1SCFD                         Msg Tag Desc.
      * If all low order keys not entered, exit
     C     #1MTAG        IFEQ      *BLANK                                       Message Field T
     C                   GOTO      VDEXIT
     C                   END
      *
      * Selection processing
      *
     C     ' ?'          CHECK     #1MTAG                                 90
     C     *IN90         IFEQ      '0'
     C                   CALL      'AOMTAGR0'                           9090
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
     C                   GOTO      VDEXIT
     C                   END
      *
     C                   END
      *                                                                                     BUG24704
      * Check if message type = 101 or 102 and Seq should be blanks                         BUG24704
     C     #1MTPY        IFEQ      '101'
     C     #1MSEQ        ANDNE     *BLANKS
     C     #1MTPY        OREQ      '102'
     C     #1MSEQ        ANDNE     *BLANKS
     C                   SETON                                        3599
      * Send message 'Message Field Seq should be blanks if Message Type 101 or 102         BUG24704
     C                   MOVEL     'MIN0442'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     KLVDEF        KLIST
     C                   KFLD                    EFMTAG                         Message Field T
     C                   KFLD                    EFMTPY                         Message type
     C                   KFLD                    EFMSEQ
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
      *                                                                                       CSW209
      * If all low order keys not entered, exit                                               CSW209
      *                                                                                       CSW209
     C                   MOVEL     #1MTPY        EFMTPY
     C                   MOVEL     #1MTAG        EFMTAG
     C                   MOVEL     #1MSEQ        EFMSEQ
      *                                                                                       CSW209
     C*****KLVDEF        CHAIN     @MTAGL1                            90                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN90         IFEQ      '1'                                                      MD056560
     C                   If        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         EFMTPY
     C*****KLVDEF        CHAIN     @MTAGL1                            90                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN90         IFEQ      '1'                                                      MD056560
     C                   If        SQLCODE = 100                                            MD056560
     C                   MOVEL     #1MTPY        EFMTPY
     C                   MOVEL     *BLANKS       EFMSEQ
     C*****KLVDEF        CHAIN     @MTAGL1                            90                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN90         IFEQ      '1'                                                      MD056560
     C                   If        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         EFMTPY
     C*****KLVDEF        CHAIN     @MTAGL1                            90                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C******IN90         IFNE      '0'                                                      MD056560
     C                   IF        SQLCODE <> 0                                             MD056560
      * Send message 'Midas Message  NF'                                                      CSW209
     C                   MOVEL     'MIN0059'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0059'     W0RTN
     C                   ENDIF
     C                   ELSE
      * Setup key
     C                   MOVEL     #1MTAG        EFMTAG                         Message Field T
     C                   MOVEL     #1MTPY        EFMTPY                         Message type
     C*****KLVDEF        CHAIN     @MTAGL1                            90                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C******IN90         IFEQ      '1'                                                      MD056560
     C                   If        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         EFMTPY                         Message type
     C*****KLVDEF        CHAIN     @MTAGL1                            90                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY and EFMSEQ = :EFMSEQ                    MD056560
     C/END-EXEC                                                                             MD056560
     C                   END
     C******IN90         IFEQ      '0'                                                      MD056560
     C                   IF        SQLCODE = 0                                              MD056560
      * Record found - move back any virtuals
     C                   MOVEL     EFSCFD        #1SCFD                         Msg Tag Desc.
     C                   GOTO      VDEXIT
     C                   END
      * Send message 'Midas Message  NF'
     C                   MOVEL     'MIN0059'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'MIN0059'     W0RTN
     C                   ENDIF
      *================================================================
     CSR   VDEXIT        ENDSR
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
     C/COPY WNCPYSRC,ME1160DEPP
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
     C                   MOVEA     #FT           P#FT                                   CFT006
     C                   MOVEA     #FTM          P#FTM                                  CFT006
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
     C**********         OPEN      MEINFML0                                                 MD056752
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
      *                                                                                       CSW209
      ** Check if SWIFT 2009 is installed                                                     CSW209
      *                                                                                       CSW209
     C                   CALL      'SWIF2009'
     C                   PARM                    P@RTCD
     C     P@RTCD        IFEQ      'CSW2009'
     C                   MOVE      'Y'           CSW209            1
     C                   SETOFF                                       36
     C                   ELSE
     C                   MOVE      'N'           CSW209
     C                   SETON                                        36
     C                   ENDIF
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
      * EDTRCD: Initialise prog - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Program C-spec
     C/COPY WNCPYSRC,ME1160DCPG
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
      /COPY WNCPYSRC,ME1160MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,ME1160MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,ME1160MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,ME1160MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,ME1160MOV5
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
      /COPY WNCPYSRC,ME1160MOV6
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
     C*COPY*MECPYSRC,SRERRC                                                                 MD056560
     C/COPY MECPYSRC,SRERRCLE                                                               MD056560
     O*EDTRCD: Cpysrc Templates Initialise Program O-spec
     O/COPY WNCPYSRC,ME1160DOPG
**  CPY@
(c) Finastra International Limited 2001
**  #FT  / #FTM  Field/ Data Structure Occurrence No.
DTCYAMT :HMIN0399                                                         CFT006
DATECCYAMTMIN0068
SNDR ADDR MIN0069
TRAN REF  MIN0070
RELATE REFMIN0071
ORD CUST:HMIN0400                                                         CFT006
ORDER CU:BMIN0433                                                                             CSW209
ORDER CUSTMIN0072
ORDER BK:BMIN0434                                                                             CSW209
ORD BANK:HMIN0401                                                         CFT006
ORDER BANKMIN0073
SND CORR:HMIN0402                                                         CFT006
SNDR CORR MIN0074
RCV CORR:HMIN0403                                                         CFT006
RECV CORR MIN0075
THIRD REIMMIN0431                                                         CFT014
INTERMED:BMIN0435                                                                             CSW209
INTERMEDY MIN0076
ACC INST:BMIN0436                                                                             CSW209
ACC INST  MIN0077
BENF INST MIN0078
BENFCUST:BMIN0437                                                                             CSW209
BENF CUST MIN0079
PAY DETL:BMIN0438                                                                             CSW209
PAY DETLS MIN0080
PAY CHGS:HMIN0404                                                         CFT006
PAY CHGS  MIN0081
BNKTOBNK:BMIN0439                                                                             CSW209
BNKTOBNK:HMIN0411                                                         CFT006
BANKTOBANKMIN0082
CASHIER   MIN0414                                                   CRT002CFT006
DATECYAMT1MIN0415                                                   CRT002CFT006
DATECYAMT2MIN0416                                                   CRT002CFT006
CUST REF:HMIN0371                                                         CFT006
INST PTY:HMIN0405                                                         CFT006
INSTR PTY MIN0372                                                         CFT006
ACSRVINS:HMIN0406                                                         CFT006
AC SRV IN MIN0373                                                         CFT006
SNDR IN :HMIN0374                                                         CFT006
EXEC DT :HMIN0375                                                         CFT006
AUTHRSN :HMIN0376                                                         CFT006
FX REF    MIN0377                                                         CFT006
INSTR CODEMIN0378                                                         CFT006
BANK OPCD MIN0430                                                         CFT014
REG REPR:HMIN0412                                                         CFT006
REG REPRT MIN0379                                                         CFT006
ORIGCCYAMTMIN0380                                                         CFT006
CHGS ACC  MIN0381                                                         CFT006
FX RATE :HMIN0407                                                         CFT006
FX RATE   MIN0382                                                         CFT006
BANK OPC:HMIN0383                                                         CFT006
TRAN CODE MIN0384                                                         CFT006
TRAN COD:HMIN0413                                                         CFT006
SEND CHG:HMIN0408                                                         CFT006
SEND CHG  MIN0385                                                         CFT006
SND CHG*  MIN0432                                                         CFT014
RECV CHG:HMIN0409                                                         CFT006
RECV CHG  MIN0386                                                         CFT006
SUM TOT :HMIN0387                                                         CFT006
CCYAMT    MIN0389                                                         CFT006
FILE REF:HMIN0392                                                         CFT006
SNDR REF:HMIN0410                                                         CFT006
MSG IND/TLMIN0370                                                                             204989
ORGCCYAM:BMIN0440                                                                             CSW209
VALID FLAGMIN0441                                                                             CSW209
FIN COPY  MIN0350                                                                             CSW209
MUR       MIN0351                                                                             CSW209
BANK PTY  MIN0352                                                                             CSW209
ADDL INFO MIN0353                                                                             CSW209
EXT NARR  MIN0412                                                                             CER030
SRVLVLID  MIN0612                                                                             CSW218
UETR      MIN0613                                                                             CSW218
