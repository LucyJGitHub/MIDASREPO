     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing data module                                 *
      *                                                               *
      *  SDNAHLSIN1 - SD Non-account Holders Window Program           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CER076  *CREATE    Date 13Feb19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER076   - Update to KWG § 24c interface specification       *
      *             (BaFin version 3.3)                               *
      *                                                               *
      *****************************************************************
 
      ** Midas SD Non-account Holders extension
     FSDNAHOY0  UF A E           K DISK    COMMIT
     F                                     USROPN
      ** Display file.
     FSDNAHLS1DFCF   E             WORKSTN USROPN
     F                                     INFDS(FILEDS)
      /SPACE 5
      *****************************************************************
      ** Copyright array
     D A@CPY           DS
     D  CPY@                   1     80    DIM(1) CTDATA PERRCD(1)              Copyright array
      *****************************************************************
      /SPACE 5
      * Check for Digits field
     D DIGITSDS        DS
     D DIGITS                  1      9    DIM(9)
     D #_DIG           S              1    DIM(10) CTDATA PERRCD(10)
      *****************************************************************
      ** File feedback data structure used to determine cursor location
     D FILEDS          DS
     D  BINROW               370    370
     D  BINCOL               371    371
      ** Data structure used to determine cursor location
     D BINARY          DS
     D  BINVAL                 1      2B 0
      *****************************************************************
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
     D PSDS           SDS
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      *****************************************************************
      ** Data structure for data-base processing.
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
 
      ** First DS for access programs, short data structure.
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure.
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Current/previous extension file record.
     D NWRCD         E DS                  EXTNAME(SDNAHOX0)
 
      * Stored extension file record.
     D SVRCD           DS            30
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Get the data structure passed from calling program.
      /COPY QWINDSRC,SDNAHLGDTA
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
 
      * Execute initial routine
 
     C                   EXSR      SRINIT
 
      * Test if Window needed
 
     C     *IN50         IFEQ      *ON                                          *B1
     C     ACTION        ANDNE     'D'
 
      * Execute specific routine depending on action
 
     C                   SELECT                                                 *B2
 
     C     ACTION        WHENEQ    'E'
     C                   EXSR      SRENQ
 
     C     ACTION        WHENEQ    'X'
     C                   EXSR      SRENQ
 
     C     ACTION        WHENEQ    'D'
     C                   EXSR      SRDEL
 
     C     ACTION        WHENEQ    'I'
 
      * Check whether record exists
 
     C                   EXSR      SRREC
 
     C     *IN89         IFEQ      *ON                                          *B3
     C                   EXSR      SRINS
 
     C                   ELSE                                                   *X3
     C                   EXSR      SRAMD
 
     C                   ENDIF                                                  *E3
 
     C     ACTION        WHENEQ    'A'
 
      * Check whether record exists
 
     C                   EXSR      SRREC
 
     C     *IN89         IFEQ      *OFF                                         *B3
     C                   EXSR      SRAMD
 
     C                   ELSE                                                   *X3
     C                   EXSR      SRINS
 
     C                   ENDIF                                                  *E3
 
     C                   ENDSL                                                  *E2
 
     C                   ENDIF                                                  *E1
 
      * Execute routine to setup return code and exit program
 
     C                   EXSR      SRRTRN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRINS - Routine to handle 'INSERT' action
      *****************************************************************
     C     SRINS         BEGSR
 
    ? * Initialize fields
    ?
     C                   EXSR      SRINZ
 
     C     *IN68         DOWEQ     *OFF                                         *B1
     C     *IN70         ANDEQ     *OFF
 
      * Display and handle screen
 
     C                   EXSR      SRSCRN
 
      * Clear messages
 
     C                   EXSR      SRCMSG
 
      * Invite
 
     C     *INKD         IFEQ      *ON                                          *B2
 
    ? * Display invite
    ?
     C                   EXSR      SRINV
 
     C                   ITER
 
     C                   ENDIF                                                  *E2
 
      * Refresh
 
     C     *INKE         IFEQ      *ON                                          *B2
 
    ? * Initialize fields
    ?
     C                   EXSR      SRINZ
 
      * Initialize error condition indicators
 
     C                   MOVEA     '000'         *IN(30)
 
     C                   ITER
 
     C                   ENDIF                                                  *E2
 
      * Previous or exit
 
     C     *INKC         IFEQ      *ON                                          *B2
     C     *INKL         OREQ      *ON
 
     C                   LEAVE
 
     C                   ENDIF                                                  *E2
 
      * Validate input
 
     C                   EXSR      SRVAL
 
      * If no errors,
 
     C     *IN30         IFEQ      *OFF                                         *B2
 
      * Move screen fields to file fields
 
     C                   EXSR      SRSTOF
 
      * Write a new record to the file
 
     C                   EXSR      SRWRT
 
     C                   ENDIF                                                  *E2
 
     C                   ENDDO                                                  *E1
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRAMD - Routine to handle 'AMEND' action
      *****************************************************************
     C     SRAMD         BEGSR
 
      * Save before image
 
     C                   EXSR      SRSAVE
 
      * Set file fields to screen fields
 
     C                   EXSR      SRFTOS
 
     C     *IN68         DOWEQ     *OFF                                         *B1
     C     *IN70         ANDEQ     *OFF
 
      * Display and handle screen
 
     C                   EXSR      SRSCRN
 
      * Clear messages
 
     C                   EXSR      SRCMSG
 
      * Invite
 
     C     *INKD         IFEQ      *ON                                          *B2
 
    ? * Display invite
    ?
     C                   EXSR      SRINV
 
     C                   ITER
 
     C                   ENDIF                                                  *E2
 
      * Refresh
 
     C     *INKE         IFEQ      *ON                                          *B2
 
      * Set file fields to screen fields
 
     C                   EXSR      SRFTOS
 
      * Initialize error condition indicators
 
     C                   MOVEA     '00'          *IN(30)
 
     C                   ITER
 
     C                   ENDIF                                                  *E2
 
      * Previous or exit
 
     C     *INKC         IFEQ      *ON                                          *B2
     C     *INKL         OREQ      *ON
 
     C                   LEAVE
 
     C                   ENDIF                                                  *E2
 
      * Validate input
 
     C                   EXSR      SRVAL
 
      * If no errors,
 
     C     *IN30         IFEQ      *OFF                                         *B2
 
      * Allocate record via update index
 
     C                   EXSR      SRALOC
 
      * If record on file and allocated, compare record images,
      * else, screen will be redisplayed
 
     C     *IN60         IFEQ      *OFF                                         *B3
     C     *IN61         ANDEQ     *OFF
 
     C                   EXSR      SRCOMP
 
      * If images do not match, screen will be redisplayed with
      * relevant message
 
     C     WWMTCH        IFEQ      'Y'                                          *B4
 
      * Images match, move screen values to file fields
 
     C                   EXSR      SRSTOF
 
      * Update record
 
     C                   EXSR      SRUPD
 
     C                   ENDIF                                                  *E4
 
     C                   ENDIF                                                  *E3
 
     C                   ENDIF                                                  *E2
 
     C                   ENDDO                                                  *E1
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRDEL - Routine to handle 'DELETE' action
      *****************************************************************
     C     SRDEL         BEGSR
 
      * Check whether record exists
 
     C                   EXSR      SRREC
 
      * If record not found, ignore
 
     C     *IN89         IFEQ      *ON                                          *B1
 
     C                   ELSE                                                   *X1
 
      ** If record found, save image before.
 
     C                   EXSR      SRSAVE
 
      * Allocate record via update index
 
     C                   EXSR      SRALOC
 
      * If record on file and allocated, compare record images,
      * else, screen will be redisplayed
 
     C     *IN60         IFEQ      *ON                                          *B2
     C     *IN61         ANDEQ     *ON
 
     C                   EXSR      SRCOMP
 
      * If images do not match, screen will be redisplayed with
      * relevant message
 
     C     WWMTCH        IFEQ      'Y'                                          *B3
 
      * Images match, delete record
 
     C                   EXSR      SRDELR
 
     C                   END                                                    *E3
 
     C                   END                                                    *E2
 
     C                   END                                                    *E1
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRENQ - Routine to handle 'ENQUIRY' action
      *****************************************************************
     C     SRENQ         BEGSR
 
      * Check whether record exists
 
     C                   EXSR      SRREC
 
      * If record not found,
      * set DB error indicator, setup message, display screen, exit
 
     C     *IN89         IFEQ      '1'                                          *B1
 
     C                   ELSE                                                   *X1
 
      * Record found, set file fields to screen fields
 
     C                   EXSR      SRFTOS
 
      * Display and handle screen
 
     C                   EXSR      SRSCRN
 
     C                   END                                                    *E1
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  RSMSG - Routine to send messages to message subfile.
      *****************************************************************
     C     SRSMSG        BEGSR
 
     C     ZAMSGF        IFEQ      *BLANKS                                      *B1
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
 
     C                   END                                                    *E1
 
     C                   CALL      'SNDERMSG'                           9999
     C                   PARM      ##PGM         ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
 
      * Clear all fields for default mechanism next time.
 
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRCMSG - Routine to clear program's message queue.
      *****************************************************************
     C     SRCMSG        BEGSR
 
     C                   CALL      'CLRERMSG'
     C                   PARM      ##PGM         ZAPGM
     C                   PARM      '*SAME'       ZAPGRL
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRREC - Routine to access file via retrieve index
      *****************************************************************
     C     SRREC         BEGSR
 
     C     PKEY          CHAIN     SDNAHOY0                           89
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRALOC - Routine to access record via update index
      *****************************************************************
     C     SRALOC        BEGSR
 
     C     PKEY          CHAIN     SDNAHOY0                           6061
 
      * If record not on file, setup message 'Record deleted'
 
     C     *IN60         IFEQ      *ON
     C                   MOVEL     'WNE9998'     ZAMSID
     C                   MOVEL     'WNMSGF'      ZAMSGF
     C                   EXSR      SRSMSG
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRUPD - Routine to update file.
      *****************************************************************
     C     SRUPD         BEGSR
 
     C                   UPDATE    SDNAHOF0                             68
     C  N68              MOVEL     *ON           *IN70
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRWRT - Routine to write a new record to the file.
      *****************************************************************
     C     SRWRT         BEGSR
 
     C                   WRITE     SDNAHOF0                             68
     C  N68              MOVEL     *ON           *IN70
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRDELR - Routine to delete a record
      *****************************************************************
     C     SRDELR        BEGSR
 
     C                   DELETE    SDNAHOF0                             68
     C  N68              MOVEL     *ON           *IN70
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRCOMP - Routine to compare before/after image of records
      *****************************************************************
     C     SRCOMP        BEGSR
 
     C     SVRCD         IFEQ      NWRCD                                        *B1
     C                   MOVE      'Y'           WWMTCH            1
 
     C                   ELSE                                                   *X1
     C                   MOVE      'N'           WWMTCH
     C                   MOVEL     'WNE9997'     ZAMSID
     C                   MOVEL     'WNMSGF'      ZAMSGF
     C                   EXSR      SRSMSG
 
      * Use SETLL to release record lock
 
     C     PKEY          SETLL     SDNAHOY0
 
      * Set condition to redisplay screen
 
     C                   MOVE      *OFF          *IN70
 
     C                   END                                                    *E1
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRSAVE - Routine to save before image of record via DS
      *****************************************************************
     C     SRSAVE        BEGSR
 
     C                   MOVEL     NWRCD         SVRCD
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRRTRN - Routine to set up return code for calling program
      *****************************************************************
     C     SRRTRN        BEGSR
 
      * Database / Window error.
 
     C     *IN68         IFEQ      *ON
     C                   MOVE      'USR0563'     WWRTRN            7
     C                   ELSE
      ** F12 pressed
     C     *INKL         IFEQ      *ON
     C                   MOVE      'USR0790'     WWRTRN
     C                   ELSE
      ** F3 pressed
     C     *INKC         IFEQ      *ON
     C                   MOVE      'Y2U9999'     WWRTRN
     C                   ELSE
      * No errors
     C                   MOVE      *BLANKS       WWRTRN
     C                   END
     C                   END
     C                   END
 
     C                   CLOSE     SDNAHOY0                             99
 
      ** Exit program
 
     C                   MOVE      *ON           *INLR
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRSCRN - Routine to handle screen and validation
      *****************************************************************
     C     SRSCRN        BEGSR
 
      * Display messages
 
     C                   WRITE     #MSGCTL
 
      * Display main screen
 
     C                   EXFMT     SDNAHLS1F0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRCLOC - Routine to determine cursor location
      *****************************************************************
     C     SRCLOC        BEGSR
 
     C                   MOVEL     ZHEX          ZHEX              1
     C                   Z-ADD     ZHDEC         ZHDEC             3 0
 
     C                   BITOFF    '01234567'    HEX00             1
     C                   MOVEL     HEX00         WWBIN             2
     C                   MOVE      ZHEX          WWBIN
     C                   MOVE      WWBIN         BINARY
     C                   Z-ADD     BINVAL        ZHDEC
 
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      **************************************************************************
      * SRVAL - Routine to validate screen fields.
      *****************************************************************
     C     SRVAL         BEGSR
 
      ** Initialize error condition indicators.
 
     C                   MOVEA     '000'         *IN(30)
 
      * Validate screen fields
 
     C                   EXSR      SREINO
 
     C  N30              MOVEL     *ON           *IN70
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      **************************************************************************
      * SREINO - Routine to validate #0EINO - Economic ID
      **************************************************************************
     C     SREINO        BEGSR
 
      * If country of location is not Germany,
      * Economic ID must not be entered
 
     C                   IF        #1COLC <> 'DE' and
     C                             #0EINO <> *blank
     C                   MOVE      *ON           *IN30
     C                   MOVE      *ON           *IN31
     C                   MOVEL     'USR4850'     ZAMSID
     C                   EXSR      SRSMSG
     C                   ENDIF
 
      * If country of location is Germany,
      * Economic ID is mandatory for corporate customers
      * (and optional for private individuals)
 
     C                   IF        #1COLC = 'DE' and
     C                             #1PIND <> 'Y' and
     C                             #0EINO =  *blank
     C                   MOVE      *ON           *IN30
     C                   MOVE      *ON           *IN31
     C                   MOVEL     'USR4851'     ZAMSID
     C                   EXSR      SRSMSG
     C                   ENDIF
 
      * If entered, Economic ID must be 'DE' + 9 digits
 
     C                   IF        #0EINO <> *blank
     C                   EVAL      DIGITSDS = %SUBST(#0EINO:3:9)
     C                   EXSR      CHK_IF_DIGITS
     C                   IF        %SUBST(#0EINO:1:2) <> 'DE' or
     C                             %SUBST(#0EINO:12:19) <> *blank or
     C                             *IN99 = *OFF
     C                   MOVE      *ON           *IN30
     C                   MOVE      *ON           *IN31
     C                   MOVEL     'USR4852'     ZAMSID
     C                   EXSR      SRSMSG
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      *  Check if number is all digits
      ********************************************************************
     C     CHK_IF_DIGITS BEGSR
     C                   Z-add     1             Idx               2 0
     C                   DOU       Idx > 9 OR
     C                             *IN99 = *OFF
     C     DIGITS(Idx)   LOOKUP    #_DIG                                  99
     C                   ADD       1             Idx
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * SRINZ - Routine to initialize screen fields with defaults
      *****************************************************************
     C     SRINZ         BEGSR
 
     C                   MOVE      *BLANKS       #0EINO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRFTOS - Routine to move file fields to screen fields
      *****************************************************************
     C     SRFTOS        BEGSR
 
     C                   MOVE      NHEINO        #0EINO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRSTOF - Routine to move screen fields to file fields
      *****************************************************************
     C     SRSTOF        BEGSR
 
      ** Move screen fields to file fields.
 
     C                   MOVE      KNAHO         NHNAHO
     C                   MOVE      #0EINO        NHEINO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRINV - Routine to display invite (When F4)
      *****************************************************************
     C     SRINV         BEGSR
 
      * Determine cursor location in screen
 
     C                   MOVE      BINROW        ZHEX
     C                   EXSR      SRCLOC
     C                   Z-ADD     ZHDEC         LINROW            3 0
 
     C                   MOVE      BINCOL        ZHEX
     C                   EXSR      SRCLOC
     C                   Z-ADD     ZHDEC         LINCOL            3 0
 
      * Determine cursor location in window
 
     C     LINROW        SUB       WWROW         LINROW
     C     LINCOL        SUB       WWCOL         LINCOL
     C                   SUB       1             LINCOL
 
      * Select Invite depending cursor location
 
     C                   SELECT                                                 *B1
     C                   OTHER
     C                   Z-ADD     LINROW        CSRROW
     C                   Z-ADD     LINCOL        CSRCOL
     C                   MOVEL     '.......'     ZAMSID                         No invite
     C                   EXSR      SRSMSG
 
     C                   ENDSL                                                  *E1
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRINIT - Routine to handle initial processing
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** Get parameters from calling program
 
     C     *ENTRY        PLIST
     C                   PARM                    ACTION            1
     C                   PARM                    DATA
     C                   PARM      WWRTRN        P0RTN             7
     C                   PARM                    WWLEN             3 0
     C                   PARM                    WWID              3 0
     C                   PARM                    WWROW             3 0
     C                   PARM                    WWCOL             3 0
     C                   PARM                    DUMMY5           10
     C                   PARM                    SPARE           256
 
      * Setup key values using transaction data passed from caller
 
     C     *LIKE         DEFINE    NHNAHO        KNAHO
     C                   MOVE      #1NAHO        KNAHO
 
     C     PKEY          KLIST
     C                   KFLD                    KNAHO
 
      * Redefine data-base error fields for program
 
     C     *LIKE         DEFINE    DBFILE        WWBFIL
     C     *LIKE         DEFINE    DBKEY         WWBKEY
     C     *LIKE         DEFINE    DBASE         WWBASE
 
      * Setup file value used in database error during access to
      * retrieval index
 
     C     *LIKE         DEFINE    DBFILE        WWEXTF
     C                   MOVEL     'SDNAHOY0'    WWEXTF
 
      * Initialise non-display indicators
 
     C                   MOVEL     *OFF          *IN50
 
      * Initialise display mode indicators
 
     C     ACTION        IFEQ      'I'                                          *B1
     C     ACTION        OREQ      'A'
     C                   MOVEL     *ON           *IN20                          Not protect
     C                   ELSE                                                   *X1
     C                   MOVEL     *OFF          *IN20                          Protect
     C                   ENDIF                                                  *E1
 
      * Initialise window positions
 
     C                   Z-ADD     WWROW         SWROW
     C                   Z-ADD     WWCOL         SWCOL
 
      * Initialise error indicators
 
     C                   MOVEA     '000'         *IN(30)
 
      ** Check feature 'CER076' existence.
 
     C                   MOVE      'N'           CER076            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7            B:Return Cd
     C                   PARM      '*VERIFY'     @OPTN             7            I:Option
     C                   PARM      'CER076'      @SARD             6            I:Key field
 
      ** If feature 'CER076' is installed.
 
     C     @RTCD         IFEQ      *BLANKS                                      *B1
     C                   MOVE      'Y'           CER076
     C                   ENDIF                                                  *E1
 
      **  CER076 must be present to display the window.
 
     C     CER076        IFEQ      'N'                                          *B1    Don't display
     C                   MOVE      *OFF          *IN50
 
     C                   MOVE      SPARE         F12               1                    F12
 
     C     F12           IFEQ      'R'                                          *B2     F12
     C                   MOVE      'USR0790'     WWRTRN
     C                   MOVE      *BLANK        F12                                    F12
     C                   MOVE      F12           SPARE
 
     C                   ENDIF                                                  *E2
 
     C                   ELSE                                                   *X1
 
     C                   MOVE      *ON           *IN50
 
      ** Open extension file and display file
 
     C                   OPEN      SDNAHOY0                             99
     C                   OPEN      SDNAHLS1DF
 
     C                   MOVE      SPARE         F12               1
     C                   MOVE      *BLANK        F12
     C                   MOVE      F12           SPARE
 
     C                   ENDIF                                                  *E1
     C                   SETON                                        25
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   MOVE      'PSSR   '     P0RTN
     C                   DUMP
     C                   SETON                                        LR
     C                   CALL      'DBERRCTL'
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2019
**CTDATA #_DIG
0123456789
