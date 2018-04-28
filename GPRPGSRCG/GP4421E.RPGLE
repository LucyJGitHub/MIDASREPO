     H DEBUG DATEDIT(*YMD)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Weighting code display')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GP4421E - Midas Weighting code Description Enquiry           *
      *                                                               *
      *  Function:  This program allows the user to enquire from a    *
      *             list of Weighting code sector details.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGP001             Date 08Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 11Oct99               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP001 - Global Processing.                                  *
      *           - SD442* programs renamed to GP442* series.         *
      *           - SDWEIG* files renamed to GPWEIG*.                 *
      *           - AOWEIGR0 renamed to GPAOWEIGR0.                   *
      *           - Converted to ILE.                                 *
      *  CPB001 - 'Private Banking' Module                            *
      *                                                               *
      *****************************************************************
     F/COPY WNCPYSRC,GP4421EFPG
     F*SD4421E#CF*E***                 WORKSTN                        UC                      CGP001
     FGP4421E#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas Weight Code subfile
      *
     F*SDWEIGL1IF*E***        K        DISK                           UC                      CGP001
     FGPWEIGL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas Weight code det retrieval ind
      *
     F*SDMMODL1*IF***E           K DISK    USROPN                                             CGP001
     F*****                                INFDS(ID0001)                                      CGP001
     F*****                                INFSR(*PSSR)                                       CGP001
     D**RTV*:*Midas*SD*Midas*module*flags*retrieval***********************                    CGP001
      *
     D********************************************************************
     D/COPY WNCPYSRC,GP4421EEPG
     D*/COPY*QWINDSRCG,GP4420GDTA*****************************************                    CGP001
     D/COPY WNCPYSRC,GP4421EIPG
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D ID0001          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS             2
      * KEY : Midas Weight Code  det retrieval ind
      * I : RST Weight Code
     D  P1WEIG                 1      2
      *
     D RunBefore       S              1A
      *
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Display and process key screen
     C                   EXSR      BADSKY
      * Terminate program
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BEGSR
      *================================================================
      * Display and process key screen
      *================================================================
      * Initialize key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction
     C                   MOVEL     'Y'           W0TRN             1
      *
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1WEIG        IFEQ      *BLANK                                       Weight Code
      * One or more key fields is blank
     C     *IN05         OREQ      '1'
      * HOME: Reset screen fields
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
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
      * Enable PUTOVR
     C                   SETON                                        86
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
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
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      * Validate key fields
     C                   EXSR      BFVLKY
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    PDWEIG                         Weight Code
      * Setup key
     C                   MOVEL     #1WEIG        PDWEIG                         Weight Code
     C     KRTV          CHAIN     SDWEIGD0                           9091      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        99        *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, then signal error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        99        *
      * Send message 'Weight code     NF'
     C                   MOVEL     'USR4538'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * 00/Copy Member GP4421ESFF - Weight Code Det  *
     C*
     C/COPY WNCPYSRC,GP4421ESFF
     C*
      * USER: Load detail screen from DBF record
      * 00/Copy Member GP4421ELDS - Weight Code  Det  *
     C*
     C/COPY WNCPYSRC,GP4421ELDS
     C*
     C                   END
      *
     C   99              GOTO      BEEXIT
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
      * Check restriction within
     C                   EXSR      VACKRL
      * USER: Validate key screen
      * 00/Copy Member GP4421EVKS - Weight Code Det  *
     C*
     C/COPY WNCPYSRC,GP4421EVKS
     C*
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
     C   03              CAS                     ZXEXPG
      * HOME: Reset screen fields
      * Process detail screen input
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      * Process key screen input
     C                   CAS                     CFPRSC
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
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y1SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
      * Enable PUTOVR
     C                   SETON                                        86
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * USER: Process key screen request
      * 00/Copy Member GP4421EPKR - Weight code Det  *
     C*
     C/COPY WNCPYSRC,GP4421EPKR
     C*
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C   05              MOVEL     'Y'           W0TRN
     C   12              MOVEL     'K'           W0TRN
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
     C                   MOVEL     'Y'           W0TRN
      * Validate details
     C                   EXSR      DCVLDL
      * QUIT if error:
     C   99              GOTO      CFEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * Process record:
     C                   EXSR      EBPR##
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
      * CALC: Detail screen function fields
      * 00/Copy Member GP4421ESFF - Weight Code Det  *
     C*
     C/COPY WNCPYSRC,GP4421ESFF
     C*
      * USER: Validate detail screen
      **CASE:*WRK.Window*processing*requir.*is*Yes*********************                       CGP001
     C*****WUWDPR        IFEQ      'Y'                                          *IF           CGP001
      **WM*call*Window*Manager*-*Window*manager*** ********************                       CGP001
     C*****              CALL      'WN0010'                                                   CGP001
     C*****              PARM      ##PGM         UPGM             10            Program       CGP001
     C*****              PARM      *BLANK        UFKEY             2            Function Key  CGP001
     C*****              PARM      'E'           UACTCD            1            Action        CGP001
     C*****              PARM                    DATA                           Trans Data    CGP001
     C*****              PARM      *BLANK        W0RTN                          Return Code   CGP001
     C*****              PARM                    SPARE           256            Spare Field   CGP001
      **WM*Check*Return************************************************                       CGP001
      **CASE:*PAR.*Return*code*is**User*QUIT*requested*****************                       CGP001
     C*****W0RTN         IFEQ      'Y2U9999'                                    *IF           CGP001
     C*****              MOVEL     W0RTN         P0RTN                          *Return code  CGP001
     C*****              EXSR      ZYEXPG                                                     CGP001
     C*****              ELSE                                                                 CGP001
      **CASE:*PAR.*Return*code*is*WN*Window*Error**********************                       CGP001
     C*****W0RTN         IFEQ      'USR0563'                                    *IF           CGP001
      **Send*message*'WN*Window*Error'*********************************                       CGP001
     C*****              MOVEL     'USR0563'     ZAMSID                                       CGP001
     C*****              EXSR      ZASNMS                                                     CGP001
     C*****              SETON                                        99        *             CGP001
      *****                                                                                   CGP001
     C*****              MOVEL     'Y'           W0DCF                          *Defer confirmCGP001
     C*****              GOTO      DCEXIT                                       *QUIT         CGP001
     C*****              ELSE                                                                 CGP001
      **CASE:*PAR.*Return*code*is**DBF*update*error********************                       CGP001
     C*****W0RTN         IFEQ      'Y2U0004'                                    *IF           CGP001
      **Send*message*'WN*Database*Error'*******************************                       CGP001
     C*****              MOVEL     'USR0567'     ZAMSID                                       CGP001
     C*****              EXSR      ZASNMS                                                     CGP001
     C*****              SETON                                        99        *             CGP001
      *****                                                                                   CGP001
     C*****              MOVEL     'Y'           W0DCF                          *Defer confirmCGP001
     C*****              GOTO      DCEXIT                                       *QUIT         CGP001
     C*****              ELSE                                                                 CGP001
      **CASE:*PAR.*Return*code*is**Previous*Screen*********************                       CGP001
     C*****W0RTN         IFEQ      'USR0790'                                    *IF           CGP001
     C*****              MOVEL     'Y'           W0DCF                          *Defer confirmCGP001
     C*****              GOTO      DCEXIT                                       *QUIT         CGP001
     C*****              END                                                    *FI           CGP001
     C*****              END                                                    *FI           CGP001
     C*****              END                                                    *FI           CGP001
     C*****              END                                                    *FI           CGP001
      * 00/Copy Member GP4421EVSW - Weight Code Det  *
     C*
     C/COPY WNCPYSRC,GP4421EVSW
     C*
     C*****              END                                                    *FI           CGP001
      * 00/Copy Member GP4421EVDS - Weight Code Det  *
     C*
     C/COPY WNCPYSRC,GP4421EVDS
     C*
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * USER: Perform confirmed action
      * 00/Copy Member GP4421EVDS - Weight Code Det  *
     C*
     C/COPY WNCPYSRC,GP4421EVDS
     C*
      * Quit if error signalled
     C   99              GOTO      EBEXIT
      * USER: Process command keys
      * 00/Copy Member GP4421EPCK - Weight Code Det  *
     C*
     C/COPY WNCPYSRC,GP4421EPCK
     C*
      * Quit if error signalled
     C   99              GOTO      EBEXIT
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   GADSAK        BEGSR
      *================================================================
      * Set key screen conditioning indicators
      *================================================================
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
      * Protect key fields on detail screen
     C                   SETON                                        88        *
      * Enable key screen
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1DESC                         Weight Descript
     C                   MOVEL     *BLANK        #1PERC                         Percentage
     C                   MOVEL     *BLANK        #1CUML                         cumulate perc
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move SDWEIGD0 fields to screen
      *================================================================
     C                   Z-ADD     PDLCD         #1LCD                          Last Change Dat
     C                   MOVEL     PDTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     PDWEIG        #1WEIG                         Weight Code
     C                   MOVEL     PDDESC        #1DESC                         Weight Descript
     C                   MOVEL     PDPERC        #1PERC                         Percentage
     C                   MOVEL     PDCUML        #1CUML                         Cumulate perc
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1WEIG        #1WEIG                         Weight Code
      * USER: Load key screen
      * 00/Copy Member GP4421ELKS - Weight Code Det  *
     C*
     C/COPY WNCPYSRC,GP4421ELKS
     C*
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     C*SR**SARVGN        BEGSR                                                                CGP001
      *================================================================                       CGP001
      **Get*'Window*required'*ind*-*MIDAS*Modules*** ******************                       CGP001
      *================================================================                       CGP001
     C*****              MOVEL     *BLANK        W0RTN             7                          CGP001
      **Define*keylist*************************************************                       CGP001
     C*****KRSSA         KLIST                                                                CGP001
     C*****              KFLD                    BGMODS                         Modules       CGP001
      **Move*fields*to*key*list****************************************                       CGP001
     C*****              MOVE      *BLANK        BGMODS                         Modules       CGP001
     C*****              MOVEL     'MMOD'        BGMODS                         Modules       CGP001
     C*****KRSSA         CHAIN     @BGREC8                            90        *             CGP001
      **Data*record*not*found******************************************                       CGP001
     C***90              MOVEL     'USR0096'     W0RTN             7                          CGP001
     C******IN90         IFEQ      '0'                                                        CGP001
      **USER:*Process*Data*record**************************************                       CGP001
      **CASE:*DB1.Window*processing*requir.*is*Yes*********************                       CGP001
     C*****BGWDPR        IFEQ      'Y'                                          *IF           CGP001
     C*****              MOVEL     'Y'           WUWDPR                         Window processCGP001
     C*****              END                                                    *FI           CGP001
     C*****              END                                                                  CGP001
      *================================================================                       CGP001
     C*SR**SAEXIT        ENDSR                                                                CGP001
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Check restriction within
      *================================================================
      * Name search required?
     C                   MOVEL     #1WEIG        WK1X01            1
     C     WK1X01        IFEQ      '?'                                          Weight code
     C**********           CALL 'SD4420S'              90  Select Message                     CGP001
     C                   CALL      'GP4420S'                            90      Select Message
     C                   PARM      *BLANK        W0RTN             7
     C     #1WEIG        PARM      #1WEIG        WQ0001            2            Weight Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD2010S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'Y2U0016'
     C                   SETON                                        99        *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y0EXIT        ENDSR
      /EJECT
     CSR   Y1SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y1EXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C     @#DFMT        IFEQ      '#RCDKEY'
      * KEY Screen
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   END
     C     @#DFMT        IFEQ      '#RCDDTL1'
      * DETAIL Screen
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   END
      *================================================================
     CSR   Y8EXIT        ENDSR
      /EJECT
     CSR   Y9CLR         BEGSR
      *================================================================
      * Clear *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y9EXIT        ENDSR
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
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text
      *================================================================
      * Signal help request
     C                   MOVEL     'Y'           W0HLP             1
      *
      * Extract cursor row and column
     C     @#RWCL        DIV       256           ZHCSRW            5 0          Row
     C                   MVR                     ZHCSCL            5 0          Column
      *
      * Save cursor position for redisplay
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0          Row
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0          Column
      *
      *
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Help text sourc
     C                   PARM      *BLANK        YYHPFL           10            Help text file
     C                   PARM      *BLANK        YYHPLB           10            Help text libra
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10            Help label
     C                   PARM      '*NORMAL'     YYUSOP           10            Options
     C                   PARM      ZHCSRW        YYRW              5 0          Row
     C                   PARM      ZHCSCL        YYCL              5 0          Column
     C                   PARM      1             YYLGCT            5 0          # of grps
     C                   PARM      W0GRP         YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel and exit from key screen
      *================================================================
      * USER: Exit program processing
      * 00/Copy Member GP4421EEPP - Weight Code Det  *
     C/COPY WNCPYSRC,GP4421EEPP
      * CASE: KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * Terminate program
     C                   SETON                                        LR
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
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      **Define*work*field*Window*processing*requir.********************                       CGP001
     C*****              MOVEL     *BLANK        WUWDPR            1                          CGP001
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Define *Synon program work fields
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
      * Open files
     C**********           OPEN SD4421E#                                                      CGP001
     C**********           OPEN SDWEIGL1                                                      CGP001
     C                   OPEN      GP4421E#
     C                   OPEN      GPWEIGL1
     C*****              OPEN      SDMMODL1                                                   CGP001
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * GP4421E Precompiler
      * Copyright Statement 1999 - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      **Get*'Window*required'*ind*-*MIDAS*Modules*** ******************                       CGP001
     C*****              EXSR      SARVGN                                                     CGP001
      * 00/Copy Member GP4421EFPG - Weight Code Det  *
     C/COPY WNCPYSRC,GP4421ECPG
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,GP4421EPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,GP4421EPS1
      *
      * Standard Midas PSSR processing.
      *
     C                   IF        RunBefore = *blanks
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      P0RTN = 'PSSR   '
     C                   DUMP
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,GP4421EPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O/COPY WNCPYSRC,GP4421EOPG
