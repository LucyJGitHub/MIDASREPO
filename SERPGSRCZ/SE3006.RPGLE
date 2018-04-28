     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Bulk trade input LUX screen')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE3006 - Bulk Trades Input - Lux Screen                      *
      *                                                               *
      *  Function:  This program maintains the Lux extra fields       *
      *                                                               *
      *  Called By: SE3002  - Review trades for bulk input            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BUG10629           Date 21Feb06               *
      *                 BUG10589           Date 16Feb06               *
      *                 CER001  *CREATE    Date 11Aug05               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10629 - Error msg for transaction time is missing         *
      *             (Recompile)                                       *
      *  BUG10589 - (Bulk Input - Insert) Transaction could not       *
      *             proceed. A database error appeared.               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *   The following routines CANNOT be changed :
      *   ========================================
      *
      *   (Main processing)
      *   SRINS
      *   SRAMD
      *   SRDEL
      *   SRENQ
      *   SRSCRN
      *   SRRTRN
      *   SRSCRN
      *   SRREC
      *   SRUPD
      *   SRWRT
      *   SRDELR
      *   SRALOC
      *   SRCOMP
      *
      *   The following routines can be changed :
      *   =====================================
      *
      *   SRINIT for specific initialization
      *   SRDBER to handle database errors
      *   SRVAL  to initialize error indicators and control validation
      *          of more/less fields
      *   SRINZ  to setup fields with defaults
      *   SRFTOS to move additional fields to the screen fields
      *   SRSTOF to move additional fields to the file fields
      *
      *
      * - Changes to the existing code should be reduced to a minimum,
      *   using separate subroutines in order to preserve the program
      *   structure as defined in the skeleton, thus reducing
      *   maintenance efforts.
      *
      * - Moreover, no functionality should be added unless specifically
      *   required. In this case, it should be very well documented
      *   in the header box.
      *
      * - The data structure used to save the before image of the
      *   record is called SVRCD.
      *   Only the length should be changed.
      *
      * - The data structure used to access the current record
      *   via the DS name is called NWRCD.
      *   Only the file name should be changed.
      *
      * - The files must have their record formats renamed to:
      *      RTVIDX for the retrieve index
      *      UPDIDX for the update index
      *      SCREEN for the screen format
      *   Any file/screen access will be done through the renamed format
      *   so that these routines remain unchanged.
      *
      *-------------------------------------------------------------- *
      *
      *   Naming conventions
      *   ==================
      *
      * - Work fields used in the program should start with WW or WU
      *   i.e. WWPLEX or WUPLEX
      *
      * - Screen fields should start with #0 (for 1st screen format),
      *   i.e. #0PLEX
      *
      * - Key fields should start with K ,i.e. KCUST
      *   (Also for fields used in KLIST's)
      *
      * - Subroutines should start with SR, i.e. SRVAL for validation,
      *   SRINIT for initial routine , etc...
      *
      *-------------------------------------------------------------- *
      *  Use of indicators:
      *
      *  (Screen field error indicators should start with 20 in
      *   ascending order)
      *
      *  *IN15  -  On=Delete/Enquiry, Protect field.
      *            Off=Insert/Amend, Underline field.
      *  *IN60  -  Extension record not found via update index
      *  *IN61  -  Unable to allocate record via update index
      *  *IN68  -  Error occured during DBF update
      *  *IN69  -  SFLEND control
      *  *IN75  -  General error indicator. Used to condition output
      *            of error messages and redisplay screen.
      *  *IN81  -  Call to DBERRCTL ended in error
      *  *IN89  -  Extension record not found via retrieval index
      *
      *  *INKJ  -  F10 pressed, enable delete
      *  *INKL  -  F12 pressed, exit
      *  *INLR  -  End processing
      *
      *  *INU7  -  :  Data-base
      *  *INU8  -  :  error control
      *
      *================================================================
      *
     FSETRX1L0  IF   E           K DISK
     F                                     RENAME(TRADSDD6:RTVIDX)
      ** Trades                            Retrieval index
      *
     FSETRX1PD  UF A E           K DISK    COMMIT
     F                                     USROPN
     F                                     RENAME(TRADSDD6:UPDIDX)
      ** Trades                            Update index
      *
     FSE3006DF  CF   E             WORKSTN
     F                                     RENAME(SE3006DD:SCREEN)
      ** European Reporting                Display file
      *
      /EJECT
      *
      ** Standard D-specs
      *
 
      *  The following /COPY line includes the LDA layout,
      *  the copyright array definition,
      *  and the following named constants:
      *     True       logical = *on (for indcator processing)
      *     False      logical = *off (for indcator processing)
      *     DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      *                                     handler)
      *  and the following variables:
      *     RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Standard D specifications
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** PSDS Layout
      *
      /EJECT
      *----------------------------------------------------------------
 
     D Rundat          DS
      ** Midas SD rundate data area
     D  MRDT                   1      7
     D                         8     13
      *
     D ULX004          S              1                                         ULX004 is present ?
     D ULX008          S              1                                         ULX008 is present ?
      *
     D WWAGSD          S              5S 0
      *
     D     Msg1        S                   LIKE(#MsgID)
      *
      /EJECT
      *----------------------------------------------------------------
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Dummy Record Formats for access to Midas Modules Details
      *
     D NWRCD         E DS                  EXTNAME(SETRX1PD)
      ** Current/previous master file fields
      *
      /EJECT
      *================================================================
     D SVRCD           DS            26
      ** Stored master file fields
      *
     D                 DS
      ** Program variables
     D ACTION          S              1A
     D WWRTRN          S              7A
     D WWBFIL          S                   LIKE(DBFILE)
     D WWBKEY          S                   LIKE(DBKEY)
     D WWBASE          S                   LIKE(DBASE)
     D WWEXTF          S                   LIKE(DBFILE)
     D WWMTCH          S              1A
      /EJECT
      *
      ** Data structure passed from calling program
      *
     D PDATA           DS          1024
     D  PETDRF                 1      6
     D  UTDBK                  7      8
     D  UVTCNR                 9     14
     D  #1TDVD                15     19  0
     D  #1TDDT                20     24  0
     D  #1ISSD                25     29  0
     D  #1MATY                30     34  0
      *
      /EJECT
      *****************************************************************
      * Main processing
      *****************************************************************
      *
      ** Execute initial routine
      *
     C                   EXSR      SRINIT
      *
      ** Execute specific routine depending on action
      *
     C                   SELECT
     C                   WHEN      ACTION  = 'I'
     C                   EXSR      SRINS
     C                   WHEN      ACTION  = 'D'
     C                   EXSR      SRDEL
     C                   WHEN      ACTION  = 'A'
     C                   EXSR      SRAMD
     C                   WHEN      ACTION  = 'E'
     C                   EXSR      SRENQ
     C                   ENDSL
      *
      ** Execute routine to setup return code and exit program
      *
     C                   EXSR      SRRTRN
      *
      /EJECT
      *****************************************************************
      * SRINS - Routine to handle 'INSERT' action
      *****************************************************************
      *
     C     SRINS         BEGSR
      *
      ** Check whether record exists
      *
     C                   EXSR      SRREC
      *
      ** If record found,
      *
     C                   IF        *IN89 = '0'
      *
      ** In case of 'Insert over Deleted Record'
      ** Save before image
      *
     C                   EXSR      SRSAVE
      *
     C                   ENDIF
      *
      ** Initialize fields
      *
     C                   EXSR      SRINZ
      *
      ** Display and handle screen until no more errors or F12
      *
     C                   DOU       *IN75 = '0' OR *INKL = '1'
     C                             OR *INKC = *ON
      *
     C                   EXSR      SRSCRN
      *
      ** Validate input
      *
     C                   EXSR      SRVAL
      *
      ** No errors
      *
     C                   IF        *IN75   = '0'
      *
      ** In case of 'Insert over Deleted Record'
      *
     C                   IF        *IN89   = '0'
      *
      ** Allocate record via update index
      *
     C                   EXSR      SRALOC
      *
      ** If record on file and allocated, compare record images,
      ** else, screen will be redisplayed
      *
     C                   IF        *IN60  = '0' AND *IN61 = '0'
      *
     C                   EXSR      SRCOMP
      *
      ** If images do not match, screen will be redisplayed with
      ** relevant message
      *
     C                   IF        WWMTCH  = 'Y'
      *
      ** Move blanks to all file fields
      *
     C                   EXSR      SRSTOF
      *
      ** Update record
      *
     C                   EXSR      SRUPD
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Move screen fields to file fields
      *
     C                   EXSR      SRSTOF
      *
      ** Write new record
      *
     C                   EXSR      SRWRT
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAMD - Routine to handle 'AMEND' action
      *****************************************************************
      *
     C     SRAMD         BEGSR
      *
      ** Check whether record exists
      *
     C                   EXSR      SRREC
      *
      ** If record not found,
      ** set DB error indicator, setup message, display screen, exit
      *
     C                   IF        *IN89   = '1'
      *
     C                   EVAL      *IN69   = '1'
     C                   EVAL      ZAMSID  = 'ER99920'
     C                   EXSR      SRSMSG
      * Display screen
     C                   EXSR      SRSCRN
      *
      ** Execute DB error routine
      *
     C                   MOVEL     WWEXTF        WWBFIL                         ************
     C                   Z-ADD     2             WWBASE                         * DBER 002 *
     C                   MOVEL     KTDRF         WWBKEY                         ************
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ** Enable fields for Amend
      *
     C                   EVAL      *IN15   = '0'
      *
      ** Record found,
      ** set file fields to screen fields and save before image
      *
     C                   EXSR      SRFTOS
     C                   EXSR      SRSAVE
      *
      ** Display and handle screen until record can be allocated and
      ** record on file and no errors left or F12 pressed
      *
     C                   DOU       *IN61  = '0' AND *IN60 = '0' AND
     C                             *IN75  = '0' OR  *INKL = '1'
     C                             OR *INKC = *ON
      *
     C                   EXSR      SRSCRN
      *
      ** Bypass any further validation if previous DB error or F12 or F3
      *
     C                   IF        *IN69  = '0' And *INKL = '0'
     C                             AND *INKC = *OFF
      *
      ** Validate input
      *
     C                   EXSR      SRVAL
      *
      ** No errors
      *
     C                   IF        *IN75   = '0'
      *
      ** Allocate record via update index
      *
     C                   EXSR      SRALOC
      *
      ** If record on file and allocated, compare record images,
      ** else, screen will be redisplayed
      *
     C                   IF        *IN60   = '0' And *IN61 = '0'
      *
     C                   EXSR      SRCOMP
      *
      ** If images do not match, screen will be redisplayed with
      ** relevant message
      *
     C                   IF        WWMTCH  = 'Y'
      *
      ** Images match, move screen values to file fields
      *
     C                   EXSR      SRSTOF
      *
      ** Update record
      *
     C                   EXSR      SRUPD
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDEL - Routine to handle 'DELETE' action
      *****************************************************************
      *
     C     SRDEL         BEGSR
      *
      ** Set indicators on for 'DELETE' mode to protect fields
      *
     C                   EVAL      *IN15   = '1'
      *
      ** Check whether record exists
      *
     C                   EXSR      SRREC
      *
      ** If record not found,
      ** set DB error indicator, setup message, display screen, exit
      *
     C                   IF        *IN89   = '1'
      *
     C                   EVAL      *IN69   = '1'
     C                   EVAL      ZAMSID  = 'ER99916'
     C                   EXSR      SRSMSG
      *
      ** Execute DB error routine
      *
     C                   MOVEL     WWEXTF        WWBFIL                         ************
     C                   Z-ADD     3             WWBASE                         * DBER 003 *
     C                   MOVEL     KTDRF         WWBKEY                         ************
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ** Record found,
      ** save before image
      *
     C                   EXSR      SRSAVE
      *
      ** Allocate record via update index
      *
     C                   EXSR      SRALOC
      *
      ** If record on file and allocated, compare record images,
      ** else, screen will be redisplayed
      *
     C                   IF        *IN60   = '0' And *IN61 = '0'
      *
     C                   EXSR      SRCOMP
      *
      ** If images do not match, screen will be redisplayed with
      ** relevant message
      *
     C                   IF        WWMTCH  = 'Y'
      *
      ** Images match, delete record
      *
     C                   EXSR      SRDELR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRENQ - Routine to handle 'ENQUIRY' action
      *****************************************************************
      *
     C     SRENQ         BEGSR
      *
      ** Set indicators on for 'ENQUIRY' mode to protect fields
      *
     C                   EVAL      *IN15   = '1'
      *
      ** Check whether record exists
      *
     C                   EXSR      SRREC
      *
      ** If record not found,
      ** set DB error indicator, setup message, display screen, exit
      *
     C                   IF        *IN89   = '1'
      *
     C                   EVAL      *IN69   = '1'
     C                   EVAL      ZAMSID  = 'ER99917'
     C                   EXSR      SRSMSG
      *
      ** Display screen
      *
     C                   EXSR      SRSCRN
      *
      ** Execute DB error routine
      *
     C                   MOVEL     WWEXTF        WWBFIL                         ************
     C                   Z-ADD     4             WWBASE                         * DBER 004 *
     C                   MOVEL     KTDRF         WWBKEY                         ************
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ** Record found, set file fields to screen fields
      *
     C                   EXSR      SRFTOS
      *
      ** Display and handle screen
      *
     C                   EXSR      SRSCRN
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRSMSG - Routine to send messages to message subfile.        *
      *  Called by: Main processing, SRAMD,. SRDEL, SRENQ             *
      *  Calls: SRREC, SRSMSG, SRSCRN, SRFTOS                         *
      *****************************************************************
     C     SRSMSG        BEGSR
      *
     C                   IF        ZAMSGF  = *Blanks
     C**********         EVAL      ZAMSGF  = 'STUSRMSG'                                     BUG10589
     C                   EVAL      ZAMSGF  = 'SEUSRMSG'                                     BUG10589
     C                   ENDIF
     C                   CALL      'SNDERMSG'
     C                   PARM      PSProcName    ZAPGM            10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
      ** Clear all fields for default mechanism next time.
      *
     C                   EVAL      ZAPGRL  = *Blank
     C                   EVAL      ZAMSID  = *Blank
     C                   EVAL      ZAMSDA  = *Blank
     C                   EVAL      ZAMSTP  = *Blank
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCMSG - Routine to clear program's message queue.           *
      *  Called by: SRAMD                                             *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRCMSG        BEGSR
      *
     C                   CALL      'CLRERMSG'
     C                   PARM      PSProcName    ZAPGM
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRREC - Routine to access file via retrieve index
      *****************************************************************
      *
     C     SRREC         BEGSR
      *
     C     KTDRF         CHAIN     RTVIDX                             89
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRALOC - Routine to access record via update index
      *****************************************************************
      *
     C     SRALOC        BEGSR
      *
     C     KTDRF         CHAIN     UPDIDX                             6061
      *
      ** If record not on file, setup message 'Record deleted'
      *
     C                   IF        *IN60   = '1'
     C                   EVAL      ZAMSID  = 'ER99918'
     C                   EXSR      SRSMSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPD - Routine to update file.
      *****************************************************************
      *
     C     SRUPD         BEGSR
      *
     C                   UPDATE    UPDIDX                               68
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRWRT - Routine to write a new record to the file.
      *****************************************************************
      *
     C     SRWRT         BEGSR
      *
     C                   WRITE     UPDIDX                               68
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDELR - Routine to delete a record
      *****************************************************************
      *
     C     SRDELR        BEGSR
      *
     C                   DELETE    UPDIDX                               68
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCOMP - Routine to compare before/after image of records
      *****************************************************************
      *
     C     SRCOMP        BEGSR
      *
     C                   IF        SVRCD   = NWRCD
     C                   EVAL      WWMTCH  = 'Y'
     C                   ELSE
     C                   EVAL      WWMTCH  = 'N'
     C                   EVAL      ZAMSID  = 'ER99919'
     C                   EXSR      SRSMSG
      *
      ** Use SETLL to release record lock
      *
     C     KTDRF         SETLL     UPDIDX
      *
      ** Set condition to redisplay screen
      *
     C                   EVAL      *IN60   = '1'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSAVE - Routine to save before image of record via DS
      *****************************************************************
      *
     C     SRSAVE        BEGSR
      *
     C                   MOVEL     NWRCD         SVRCD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRTRN - Routine to set up return code for calling program
      *****************************************************************
      *
     C     SRRTRN        BEGSR
      *
     C                   SELECT
      *
      ** DBF update error
      *
     C                   WHEN      *IN69   = '1'
     C                   EVAL      WWRTRN  = 'Y2U0004'
      *
      ** Database / Screen error
      *
     C                   WHEN      *IN68   = '1'
     C                   EVAL      WWRTRN  = 'USR0563'
      *
      ** F3 pressed
      *
     C                   WHEN      *INKC   = '1'
     C                   EVAL      WWRTRN  = 'Y2U9999'
      *
      ** F12 pressed
      *
     C                   WHEN      *INKL   = '1'
     C                   EVAL      WWRTRN  = 'USR0790'
      *
      ** No errors
      *
     C                   OTHER
     C                   EVAL      WWRTRN  = *Blank
     C                   ENDSL
      *
     C                   CLOSE     SETRX1PD                             99
      *
      ** Exit program
      *
     C                   EVAL      *INLR   = '1'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSCRN - Routine to clear program's message queue.
      *****************************************************************
      *
     C     SRSCRN        BEGSR
      *
      ** Display messages
      *
     C                   WRITE     #MSGCTL
      *
      ** Display main screen
      *
     C                   EXFMT     SCREEN
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRVAL - Routine to control validation of each field.
      *================================================================
      *
     C     SRVAL         BEGSR
      *
     C                   EXSR      SRCMSG
      *
      *
      ** Initialize error condition indicators
      *
     C                   EVAL      *IN75   = '0'
     C                   MOVEA     '0000'        *IN(23)
      *
     C                   EXSR      SRTIME
     C                   EXSR      SRCABR
     C                   EXSR      SRMTRD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAGSD - Routine to validate CCAGSD
      *****************************************************************
     C     SRAGSD        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SEVCCAGSD'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    #6LXAGSD
     C                   PARM                    WWAGSD
     C                   PARM                    #1ISSD
     C                   PARM                    #1MATY
     C                   PARM                    #1TDDT
     C                   PARM                    #1TDVD
      *
     C     MSG1          IFNE      *BLANK
     C                   EVAL      *IN75   = '1'
     C                   EVAL      *IN23   = '1'
     C                   EVAL      ZAMSID  = MSG1
     C**********         EVAL      ZAMSGF  = 'STUSRMSG'                                     BUG10589
     C                   EVAL      ZAMSGF  = 'SEUSRMSG'                                     BUG10589
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTIME - Routine to validate WNTIME
      *****************************************************************
     C     SRTIME        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SEVWNTIME'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    #6LXTTIM
      *
     C     MSG1          IFNE      *BLANK
     C                   EVAL      *IN75   = '1'
     C                   EVAL      *IN24   = '1'
     C                   EVAL      ZAMSID  = MSG1
     C**********         EVAL      ZAMSGF  = 'STUSRMSG'                                     BUG10589
     C                   EVAL      ZAMSGF  = 'SEUSRMSG'                                     BUG10589
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCABR - Routine to validate WNCABR
      *****************************************************************
     C     SRCABR        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SEVWNCABR'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    #6LXCABR
      *
     C     MSG1          IFNE      *BLANK
     C                   EVAL      *IN75   = '1'
     C                   EVAL      *IN25   = '1'
     C                   EVAL      ZAMSID  = MSG1
     C**********         EVAL      ZAMSGF  = 'STUSRMSG'                                     BUG10589
     C                   EVAL      ZAMSGF  = 'SEUSRMSG'                                     BUG10589
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMTRD - Routine to validate CCMTRD
      *****************************************************************
     C     SRMTRD        BEGSR
      *
      ** Reset variables updated by each module before each call
      *
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'SEVCCMTRD'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    #6LXMTRD
      *
     C     MSG1          IFNE      *BLANK
     C                   EVAL      *IN75   = '1'
     C                   EVAL      *IN26   = '1'
     C                   EVAL      ZAMSID = MSG1
     C**********         EVAL      ZAMSGF  = 'STUSRMSG'                                     BUG10589
     C                   EVAL      ZAMSGF  = 'SEUSRMSG'                                     BUG10589
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINZ - Routine to initialize screen fields with defaults
      *****************************************************************
      *
     C     SRINZ         BEGSR
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFTOS - Routine to move file fields to screen fields
      *****************************************************************
      *
     C     SRFTOS        BEGSR
      *
     C                   MOVE      CCAGSD        #6LXAGSD
     C                   MOVE      CCTIME        #6LXTTIM
     C                   MOVE      CCCABR        #6LXCABR
     C                   MOVE      CCMTRD        #6LXMTRD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSTOF - Routine to move screen fields to file fields
      *****************************************************************
      *
     C     SRSTOF        BEGSR
      *
      ** Move key field to file field
      *
     C                   MOVE      PETDRF        CCTDRF
      *
      ** Move data fields to file fields
      *
     C                   MOVE      #6LXAGSD      CCAGSD
     C                   MOVE      #6LXTTIM      CCTIME
     C                   MOVE      #6LXCABR      CCCABR
     C                   MOVE      #6LXMTRD      CCMTRD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - Routine to handle initial processing
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Get parameters from calling program
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTION
     C                   PARM                    PDATA
     C                   PARM                    WWRTRN            7
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       WRTCD             7
     C                   PARM      '*VERIFY'     WOPTN             7
     C                   PARM      'ULX004'      WSARD             6
     C                   PARM                    DSFDY
      *
     C                   SELECT
      *
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           ULX004
      *
     C                   WHEN      WRTCD = '*NRF   '
     C                   MOVE      'N'           ULX004
     C                   OTHER
      *
     C                   MOVEL     'SCSARDPD'    WWBFIL
     C                   MOVEL     '01'          WWBASE
     C                   MOVEL     WOPTN         WWBKEY
     C                   EXSR      *PSSR
      *
     C                   ENDSL
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       WRTCD             7
     C                   PARM      '*VERIFY'     WOPTN             7
     C                   PARM      'ULX008'      WSARD             6
     C                   PARM                    DSFDY
      *
     C                   SELECT
      *
     C                   WHEN      WRTCD = *BLANKS
     C                   MOVE      'Y'           ULX008
     C                   MOVE      '1'           *IN70
      *
     C                   WHEN      WRTCD = '*NRF   '
     C                   MOVE      'N'           ULX008
     C                   MOVE      '0'           *IN70
     C                   OTHER
      *
     C                   MOVEL     'SCSARDPD'    WWBFIL
     C                   MOVEL     '01'          WWBASE
     C                   MOVEL     WOPTN         WWBKEY
     C                   EXSR      *PSSR
      *
     C                   ENDSL
      *
      ** Get rundate
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   EVAL      BJMRDT  = MRDT
     C                   EVAL      SPGM    = 'SE3006'
     C                   EVAL      SUSER   = PSUser
     C                   EVAL      SJOB    = PSJobName
      *
      ** Setup file value used in database error during access to
      ** retrieval index
      *
     C                   EVAL      WWEXTF  = 'SETRX1PD'
      *
      ** Initialise error indicators
      *
     C                   MOVEA     '0000'        *IN(23)
     C                   Eval      *IN75   = '0'
      *
      ** Call Access Program for Midas Modules Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDMMODPD'    WWBFIL                          *************
     C                   MOVEL     '02'          WWBASE                          *DBERROR 099*
     C                   MOVEL     @OPTN         WWBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        (BGLRIN <> 'Y') OR (ULX004 <> 'Y')
     C                   EVAL      WWRTRN  = *Blank
     C                   EVAL      *INLR   = '1'
     C                   RETURN
     C                   ELSE
     C                   OPEN      SETRX1PD
     C                   ENDIF
      *
      ** Setup key values using transaction data passed from caller
      *
     C                   MOVE      PETDRF        KTDRF             6
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDMSG - Send message to program's message queue.
      *****************************************************************
     C     SNDMSG        BEGSR
      *
      ** Send message to program's message queue.
      *
     C                   IF        ZAPGMQ  = *BLANK
     C                   EVAL      ZAPGMQ  = SPGM
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
      ** Clear all fields for default mechanism next time.
      *
     C                   EVAL      ZAPGM   = *Blank
     C                   EVAL      ZAPGRL  = *Blank
     C                   EVAL      ZAMSID  = *Blank
     C                   EVAL      ZAMSGF  = *Blank
     C                   EVAL      ZAMSDA  = *Blank
     C                   EVAL      ZAMSTP  = *Blank
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR
      *
     C                   RESET                   Msg1
 
     C                   EVAL      ReturnCode = *Blanks
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR -  ERROR PROCESSING                                    *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Update data area LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM   = 'SD3006'
     C                   EVAL      DBFILE  = WWBFIL
     C                   EVAL      DBKEY   = WWBKEY
     C                   EVAL      DBASE   = WWBASE
     C                   OUT       LDA
      *
     C                   DUMP
      *
     C                   EVAL      *INU7   = *On
     C                   EVAL      *INU8   = *On
     C                   EVAL      *INLR   = *On
      *
      ** Call standard DB error handler
      *
     C                   CALL      'DBERRCTL'                           81
      *
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
