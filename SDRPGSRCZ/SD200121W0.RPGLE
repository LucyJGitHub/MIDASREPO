     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD - Network Extended Data - Window')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200121W0 - SD - Nextwork Extended data - window      *
      *                                                               *
      *  Function:  This program prompts a new window on the Network  *
      *                                                               *
      *  (phase(s)) Input Cycle                                       *
      *                                                               *
      *  Called By: SD200121 - Network Description - screen 1         *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. EML104 *CREATE     Date 05Feb20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML104 - Upgrade EML010 to FB Midas 2.1 SP21                 *
      *           Structured field :86:                               *
      *                                                               *
      *****************************************************************
     FSDNWRKY0  IF   E           K DISK
     F                                     RENAME(SDNWRK0X:RTVIDX)
      ***  SD Network Extended data
      *
     FSDNWRKX0  UF A E           K DISK    COMMIT
     F                                     USROPN
     F                                     RENAME(SDNWRK0X:UPDIDX)
      ***  SD Network Extended data
      *
     FSD200121#0CF   E             WORKSTN
     F                                     RENAME(WINDOWF:SCREEN)
      *                                Display file        Prefix #0
      /EJECT
      *-------------------------------------------------------------------------
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              COPYRIGHT  ARRAY
      /EJECT
      *-------------------------------------------------------------------------
     D                SDS
      * Get program name from PSDS
     D  ##PGM            *PROC
      /EJECT
      *-------------------------------------------------------------------------
     D DLDA            DS           256
      * Data structure for data-base processing
     D  DBFILE               132    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      /EJECT
      *-------------------------------------------------------------------------
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      **  Data Structure for Network Details.

     D DSLDY         E DS                  EXTNAME(DSLDY)
      **  Third DS for access programs, very long data structure.

     D NWRCD         E DS                  EXTNAME(SDNWRKX0)
      ***  Current/previous master file fields
      *
      /EJECT
      *-------------------------------------------------------------------------
     D SVRCD           DS            12
      *
      ***  Stored master file fields
      *
      /EJECT
      *-------------------------------------------------------------------------
      *
      ***  Get the data structure passed from calling program
      *
      /COPY QWINDSRC,SD200121DT
      /EJECT
      *-------------------------------------------------------------------------
      * Main processing
      *-------------------------------------------------------------------------
      ***  Execute initial routine
      *
     C                   EXSR      SRINIT
      *
      ***  Test if Window needed
      *
     C     *IN12         IFEQ      '1'
      *
      ***  Execute specific routine depending on action
      *
     C                   SELECT
      *
     C     ACTION        WHENEQ    'E'
     C                   EXSR      SRENQ
      *
     C     ACTION        WHENEQ    'D'
     C                   EXSR      SRDEL
      *
     C     ACTION        WHENEQ    'I'
      *
      ***  Check whether record exists
      *
     C                   EXSR      SRREC
      *
     C     *IN89         IFEQ      *ON
     C                   EXSR      SRINS
     C                   ELSE
     C                   EXSR      SRAMD
     C                   ENDIF
      *
     C     ACTION        WHENEQ    'A'
      *
      ***  Check whether record exists
      *
     C                   EXSR      SRREC
      *
     C     *IN89         IFEQ      *OFF
     C                   EXSR      SRAMD
     C                   ELSE
     C                   EXSR      SRINS
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
      ***  Execute routine to setup return code and exit program
      *
     C                   EXSR      SRRTRN
      *
      /EJECT
      *-------------------------------------------------------------------------
      * SRINS - Routine to handle 'INSERT' action
      *-------------------------------------------------------------------------
      *
     C     SRINS         BEGSR
      *
      ***  Initialize fields
      *
     C                   EXSR      SRINZ
      *
     C     *IN68         DOWEQ     *OFF
     C     *IN69         ANDEQ     *OFF
     C     *IN70         ANDEQ     *OFF
      *
      ***  Display and handle screen
      *
     C                   EXSR      SRSCRN
      *
      ***  Clear messages
      *
     C                   EXSR      SRCMSG
      *
      ***  Refresh
      *
     C     *INKE         IFEQ      *ON
      *
      ***  Initialize fields
      *
     C                   EXSR      SRINZ
      *
      ***  Initialize error condition indicators
      *
     C                   MOVEL     *OFF          *IN75
     C                   MOVEA     '0'           *IN(50)
      *
     C                   ITER
      *
     C                   ENDIF
      *
      ***  Previous or exit
      *
     C     *INKC         IFEQ      *ON
     C     *INKL         OREQ      *ON
      *
     C                   LEAVE
      *
     C                   ENDIF
      *
      ***  Validate input
      *
     C                   EXSR      SRVAL
      *
      ***  If no errors,
      *
     C     *IN75         IFEQ      *OFF
      *
      ***  Move screen fields to file fields
      *
     C                   EXSR      SRSTOF
      *
      ***  Write a new record to the file
      *
     C                   EXSR      SRWRT
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRAMD - Routine to handle 'AMEND' action
      *-------------------------------------------------------------------------
      *
     C     SRAMD         BEGSR
      *
      ***  Save before image
      *
     C                   EXSR      SRSAVE
      *
      ***  Set file fields to screen fields
      *
     C                   EXSR      SRFTOS
      *
     C     *IN68         DOWEQ     *OFF
     C     *IN69         ANDEQ     *OFF
     C     *IN70         ANDEQ     *OFF
      *
      ***  Display and handle screen
      *
     C                   EXSR      SRSCRN
      *
      ***  Clear messages
      *
     C                   EXSR      SRCMSG
      *
      ***  Refresh
      *
     C     *INKE         IFEQ      *ON
      *
      ***  Set file fields to screen fields
      *
     C                   EXSR      SRFTOS
      *
      ***  Initialize error condition indicators
      *
     C                   MOVE      '0'           *IN75
     C                   MOVEA     '0'           *IN(50)
      *
     C                   ITER
      *
     C                   ENDIF
      *
      ***  Previous or exit
      *
     C     *INKC         IFEQ      *ON
     C     *INKL         OREQ      *ON
      *
     C                   LEAVE
      *
     C                   ENDIF
      *
      ***  Validate input
      *
     C                   EXSR      SRVAL
      *
      ***  If no errors,
      *
     C     *IN75         IFEQ      *OFF
      *
      ***  Allocate record via update index
      *
     C                   EXSR      SRALOC
      *
      ***  If record on file and allocated, compare record images,
      ***  else, screen will be redisplayed
      *
     C     *IN60         IFEQ      '0'
     C     *IN61         ANDEQ     '0'
      *
     C                   EXSR      SRCOMP
      *
      ***  If images do not match, screen will be redisplayed with
      ***  relevant message
      *
     C     WWMTCH        IFEQ      'Y'
      *
      ***  Images match, move screen values to file fields
      *
     C                   EXSR      SRSTOF
      *
      ***  Update record
      *
     C                   EXSR      SRUPD
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRDEL - Routine to handle 'DELETE' action
      *-------------------------------------------------------------------------
      *
     C     SRDEL         BEGSR
      *
      ***  Set indicators on for 'DELETE' mode to protect fields
      *
     C                   MOVE      '1'           *IN10
      *
      ***  Check whether record exists
      *
     C                   EXSR      SRREC
      *
      ***  If record not found,
      ***  set DB error indicator, setup message, display screen, exit
      *
     C     *IN89         IFEQ      '1'
      *
     C                   ELSE
      *
      ***  Record found,
      ***  save before image
      *
     C                   EXSR      SRSAVE
      *
      ***  Allocate record via update index
      *
     C                   EXSR      SRALOC
      *
      ***  If record on file and allocated, compare record images,
      ***  else, screen will be redisplayed
      *
     C     *IN60         IFEQ      '0'
     C     *IN61         ANDEQ     '0'
      *
     C                   EXSR      SRCOMP
      *
      ***  If images do not match, screen will be redisplayed with
      ***  relevant message
      *
     C     WWMTCH        IFEQ      'Y'
      *
      ***  Images match, delete record
      *
     C                   EXSR      SRDELR
      *
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRENQ - Routine to handle 'ENQUIRY' action
      *-------------------------------------------------------------------------
      *
     C     SRENQ         BEGSR
      *
      ***  Set indicators on for 'ENQUIRY' mode to protect fields
      *
     C                   MOVE      '1'           *IN10
      *
      ***  Check whether record exists
      *
     C                   EXSR      SRREC
      *
      ***  If record not found,
      ***  set DB error indicator, setup message, display screen, exit
      *
     C     *IN89         IFEQ      '1'
      *
     C                   ELSE
      *
      ***  Record found, set file fields to screen fields
      *
     C                   EXSR      SRFTOS
      *
      ***  Display and handle screen
      *
     C                   EXSR      SRSCRN
      *
     C                   END
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRSMSG - Routine to send messages to message subfile.
      *-------------------------------------------------------------------------
      *
     C     SRSMSG        BEGSR
      *
     C     ZAMSGF        IFEQ      *BLANKS
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   END
     C                   CALL      'SNDERMSG'
     C                   PARM      ##PGM         ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      *
      ***  Clear all fields for default mechanism next time.
      *
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRCMSG - Routine to clear program's message queue.
      *-------------------------------------------------------------------------
      *
     C     SRCMSG        BEGSR
      *
     C                   CALL      'CLRERMSG'
     C                   PARM      ##PGM         ZAPGM
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRREC - Routine to access file via retrieve index
      *-------------------------------------------------------------------------
      *
     C     SRREC         BEGSR
      *
     C     KNWRK         CHAIN     RTVIDX                             89
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRALOC - Routine to access record via update index
      *-------------------------------------------------------------------------
      *
     C     SRALOC        BEGSR
      *
     C     KNWRK         CHAIN     UPDIDX                             6061
      *
      ***  If record not on file, setup message 'Record deleted'
      *
     C     *IN60         IFEQ      '1'
     C                   MOVEL     'EML1042'     ZAMSID
     C                   EXSR      SRSMSG
     C                   END
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRUPD - Routine to update file.
      *-------------------------------------------------------------------------
      *
     C     SRUPD         BEGSR
      *
     C                   UPDATE    UPDIDX                               68
     C  N68              MOVEL     *ON           *IN70
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRWRT - Routine to write a new record to the file.
      *-------------------------------------------------------------------------
      *
     C     SRWRT         BEGSR
      *
     C                   WRITE     UPDIDX                               68
     C  N68              MOVEL     *ON           *IN70
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRDELR - Routine to delete a record
      *-------------------------------------------------------------------------
      *
     C     SRDELR        BEGSR
      *
     C                   DELETE    UPDIDX                               68
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRCOMP - Routine to compare before/after image of records
      *-------------------------------------------------------------------------
      *
     C     SRCOMP        BEGSR
      *
     C     SVRCD         IFEQ      NWRCD
     C                   MOVE      'Y'           WWMTCH            1
     C                   ELSE
     C                   MOVE      'N'           WWMTCH
     C                   MOVEL     'EML1043'     ZAMSID
     C                   EXSR      SRSMSG
      *
      ***  Use SETLL to release record lock
      *
     C     KNWRK         SETLL     UPDIDX
      *
      ***  Set condition to redisplay screen
      *
     C                   MOVE      '1'           *IN60
      *
     C                   END
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRSAVE - Routine to save before image of record via DS
      *-------------------------------------------------------------------------
      *
     C     SRSAVE        BEGSR
      *
     C                   MOVEL     NWRCD         SVRCD
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRRTRN - Routine to set up return code for calling program
      *-------------------------------------------------------------------------
      *
     C     SRRTRN        BEGSR
      *
      ***  DBF update error
      *
     C     *IN69         IFEQ      '1'
     C                   MOVE      'Y2U0004'     WWRTRN
     C                   ELSE
      *
      ***  Database / Window error
      *
     C     *IN68         IFEQ      '1'
     C                   MOVE      'USR0563'     WWRTRN
     C                   ELSE
      *
      ***  F12 pressed
      *
     C     *INKL         IFEQ      '1'
     C                   MOVE      'USR0790'     WWRTRN
     C                   ELSE
      *
      ***  F3 pressed
      *
     C     *INKC         IFEQ      '1'
     C                   MOVE      'Y2U9999'     WWRTRN
     C                   ELSE
      *
      ***  No errors
      *
     C                   MOVE      *BLANKS       WWRTRN
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   CLOSE     SDNWRKX0                             99
      *
      ***  Exit program
      *
     C                   MOVE      '1'           *INLR
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRDBER - Routine to handle database errors
      *-------------------------------------------------------------------------
      *
     C     SRDBER        BEGSR
      *
      ***  Update data area LDA
      *
     C     *DTAARA       DEFINE    LDA           DLDA
     C     *LOCK         IN        DLDA
     C                   MOVEL     'SD200121W0'  DBPGM
     C                   MOVE      WWBFIL        DBFILE
     C                   MOVE      WWBKEY        DBKEY
     C                   MOVE      WWBASE        DBASE
     C                   OUT       DLDA
      *
      ***  Set on data-base error indicators
      *
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *IN69
      *
      ***  Dump program
      *
     C                   DUMP
      *
      ***  Call standard DB error handler
      *
     C                   CALL      'DBERRCTL'                           81
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRSCRN - Routine to handle screen and validation
      *-------------------------------------------------------------------------
      *
     C     SRSCRN        BEGSR
      *
      ***  Display messages
      *
     C                   WRITE     #MSGCTL
      *
      ***  Display main screen
      *
     C                   EXFMT     SCREEN
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * The routines that can be changed start here...
      *-------------------------------------------------------------------------
      * SRVAL - Routine to control validation of each field.
      *-------------------------------------------------------------------------
      *
     C     SRVAL         BEGSR
      *
      ***  Initialize error condition indicators
      *
     C                   MOVE      '0'           *IN75
     C                   MOVEA     '0'           *IN(50)
      *
      ***  Validate fields
      *
     C                   EXSR      SRONWK
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRONWK - Routine to validate Output network
      *-------------------------------------------------------------------------
      *
     C     SRONWK        BEGSR
      *
      ***  Validate field
      *
     C     #0ONWK        IFNE      *BLANK
     C     #0ONWK        ANDNE     #1NWRK
      *
      ***  Check whether Network exist
      *
     C                   CALL      'AONWRKR0'
     C                   PARM      *BLANKS       PRtcd             7            Return Code
     C                   PARM      '*KEY'        POptn             7            Option
     C                   PARM      #0ONWK        PNwrk             6            Network
     C     SDNWRK        PARM      SDNWRK        DSLDY
      *
     C     PRTCD         IFEQ      '*NRF   '
     C     EDTYLC        OREQ      'D'
     C                   MOVEL     'EML1044'     ZAMSID
     C                   MOVE      '1'           *IN75
     C                   MOVE      '1'           *IN50
     C                   EXSR      SRSMSG
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRINZ - Routine to initialize screen fields with defaults
      *-------------------------------------------------------------------------
      *
     C     SRINZ         BEGSR
      *
     C                   MOVEL     *BLANKS       #0ONWK
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRFTOS - Routine to move file fields to screen fields
      *-------------------------------------------------------------------------
      *
     C     SRFTOS        BEGSR
      *
     C                   MOVEL     X0ONWK        #0ONWK
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRSTOF - Routine to move screen fields to file fields
      *-------------------------------------------------------------------------
      *
     C     SRSTOF        BEGSR
      *
      ***  Move key field to file field
      *
     C                   MOVEL     KNWRK         X0NWRK
      *
      ***  Move data fields to file fields
      *
     C                   MOVEL     #0ONWK        X0ONWK
      *
     C                   ENDSR
      /EJECT
      *-------------------------------------------------------------------------
      * SRINIT - Routine to handle initial processing
      *-------------------------------------------------------------------------
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ***  Get parameters from calling program
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTION            1
     C                   PARM                    DATA
     C                   PARM                    WWRTRN            7
     C                   PARM                    WWLEN             3 0
     C                   PARM                    WWID              3 0
     C                   PARM                    WWROW             3 0
     C                   PARM                    WWCOL             3 0
     C                   PARM                    DUMMY5           10
      *
      ***  The following parameter is needed from PTF16 on.
      ***  Every PTF level below should omit this parameter
      *
     C                   PARM                    SPARE           256
      *
      ***  Setup key values using transaction data passed from caller
      *
     C     *LIKE         DEFINE    X0NWRK        KNWRK
     C                   MOVE      #1NWRK        KNWRK
      *
      ***  Redefine data-base error fields for program
      *
     C     *LIKE         DEFINE    DBFILE        WWBFIL
     C     *LIKE         DEFINE    DBKEY         WWBKEY
     C     *LIKE         DEFINE    DBASE         WWBASE
      *
      ***  Setup file value used in database error during access to
      ***  retrieval index
      *
     C     *LIKE         DEFINE    DBFILE        WWEXTF
     C                   MOVEL     'SDNWRKX0'    WWEXTF
      *
      ***  Initialise display mode indicators
      *
     C     ACTION        IFEQ      'I'
     C     ACTION        OREQ      'A'
     C                   MOVEL     *OFF          *IN20
     C                   ELSE
     C                   MOVEL     *ON           *IN20
     C                   ENDIF
      *
      ***  Initialise window positions
      *
     C                   Z-ADD     WWROW         SWROW
     C                   Z-ADD     WWCOL         SWCOL
      *
      ***  Initialise error indicators
      *
     C                   MOVEA     '0'           *IN(50)
     C                   MOVEL     *OFF          *IN75
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'EML104'      PSARD             6
      *
     C                   IF        PRTCD = *blanks
     C                   OPEN      SDNWRKX0
     C                   MOVE      '1'           *IN12
      *
     C                   MOVEL     SPARE         SP246           246
     C                   MOVE      SP246         F12               1                    F12
      *
     C                   MOVE      *BLANK        F12                                    F12
     C                   MOVE      F12           SP246
     C                   MOVEL     SP246         SPARE
      *
     C                   ELSE
      *
     C                   MOVEL     *OFF          *IN12
      *
     C                   MOVEL     SPARE         SP246           246
     C                   MOVE      SP246         F12               1                    F12
      *
     C     F12           IFEQ      'R'                                                  F12
     C                   MOVE      'USR0790'     WWRTRN
     C                   MOVE      *BLANK        F12                                    F12
     C                   MOVE      F12           SP246
     C                   MOVEL     SP246         SPARE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2011
