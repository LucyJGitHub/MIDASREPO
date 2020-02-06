     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Institution Codes - Ecosectors')
      *****************************************************************
      *                                                               *
      *  Midas - Institution Codes Module                             *
      *                                                               *
      *  SD0092 - Institution Codes - Screen  No. 6 (ECOSECTORS)      *
      *                                                               *
      *  Function:  This program maintains the economic sector codes  *
      *                                                               *
      *  Called By: SD0091R - Local Institution Maintenance           *
      *             SD0091E - Local Institution Enquiry               *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
      * - Moreover, no functionality should be added unless
      *   specifically required. In this case, it should be very well
      *   documented in the header box.
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
      *   Any file/screen access will be done through the renamed
      *   format so that these routines remain unchanged.
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
      *  *IN88  -  Chain to SDECOSLXPD
      *  *IN89  -  Extension record not found via retrieval index
      *
      *  *INKL  -  F12 pressed, exit
      *  *INLR  -  End processing
      *
      *  *INU7  -  :    Data-base
      *  *INU8  -  :  error control
      *
      *================================================================
      *
     FSDINX1L0  IF   E           K DISK
     F                                     RENAME(SDINSTF6:RTVIDX)
      *
      ** Extended Institution Codes      Retrieval index
      *
     FSDNCOSPD  IF   E           K DISK
      *
      ** New Economic Sectors            Retrieval index
      *
     FSDECOSLXPDIF   E           K DISK
      *
      ** Economic Sectors                Retrieval index
      *
     FSDINX1PD  UF A E           K DISK    COMMIT
     F                                     USROPN
     F                                     RENAME(SDINSTF6:UPDIDX)
      *
      ** Extended Institution Codes      Update index
      *
     FSD0092DF  CF   E             WORKSTN
     F                                     RENAME(SD0092F6:SCREEN)
      *                                Display file
      /EJECT
      *
      ** Standard D-specs
      *
 
      *  The following /COPY line includes the LDA layout,
      *  the copyright array definition,
      *  and the following named constants:
      *     True       logical = *on (for indcator processing)
      *     False      logical = *off (for indcator processing)
      *     DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      *                                     error handler)
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
     D DATA            DS          1024
     D   #1LINC                1      2A
 
     D Rundat          DS
      *
      ** Midas SD rundate data area
      *
     D  MRDT                   1      7
     D                         8     13
      /EJECT
      *----------------------------------------------------------------
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for Access Programs, Short Data Structure
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Dummy Record Formats for access to Midas Modules Details
      *
     D NWRCD         E DS                  EXTNAME(SDINX1PD)
      *
      ** Current/previous master file fields
      *
      /EJECT
      *================================================================
     D SVRCD           DS            26
      *
      ** Stored master file fields
      *
     D                 DS
      *
      ** Program variables
      *
     D ACTION          S              1A
     D WWRTRN          S              7A
     D WWBFIL          S                   LIKE(DBFILE)
     D WWBKEY          S                   LIKE(DBKEY)
     D WWBASE          S                   LIKE(DBASE)
     D WWEXTF          S                   LIKE(DBFILE)
     D WWMTCH          S              1A
      /EJECT
      *
      ** Get the data structure passed from calling program
      *
      /COPY QWINDSRC,SD0092GDTA
      /EJECT
      *================================================================
      * Main processing
      *================================================================
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
      *================================================================
      * SRINS - Routine to handle 'INSERT' action
      *================================================================
      *
     C     SRINS         BEGSR
      *
      ** Check whether record exists
      *
     C                   EXSR      SRREC
      *
      ** If record found,
      *
     C     *IN89         IFEQ      *OFF
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
     C     *IN75         DOUEQ     *OFF
     C     *INKL         OREQ      *ON
      *
     C                   EXSR      SRSCRN
      *
      ** Validate input
      *
     C                   EXSR      SRVAL
      *
      ** No errors
      *
     C     *IN75         IFEQ      *OFF
      *
      ** In case of 'Insert over Deleted Record'
      *
     C     *IN89         IFEQ      *OFF
      *
      ** Allocate record via update index
      *
     C                   EXSR      SRALOC
      *
      ** If record on file and allocated, compare record images,
      ** else, screen will be redisplayed
      *
     C     *IN60         IFEQ      *OFF
     C     *IN61         ANDEQ     *OFF
      *
     C                   EXSR      SRCOMP
      *
      ** If images do not match, screen will be redisplayed with
      ** relevant message
      *
     C     WWMTCH        IFEQ      'Y'
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
      /EJECT
      *================================================================
      * SRAMD - Routine to handle 'AMEND' action
      *================================================================
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
     C     *IN89         IFEQ      *ON
      *
     C                   EVAL      *IN69   = *ON
     C                   EVAL      ZAMSID  = 'ER99920'
     C                   EXSR      SRSMSG
      * Display screen
     C                   EXSR      SRSCRN
      *
      ** Execute DB error routine
      *
     C                   MOVEL     WWEXTF        WWBFIL
     C                   Z-ADD     2             WWBASE
     C                   MOVEL     KINST         WWBKEY
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ** Enable fields for Amend
      *
     C                   EVAL      *IN15   = *OFF
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
     C     *IN61         DOUEQ     *OFF
     C     *IN60         ANDEQ     *OFF
     C     *IN75         ANDEQ     *OFF
     C     *INKL         OREQ      *ON
      *
     C                   EXSR      SRSCRN
      *
      ** Bypass any further validation if previous DB error or F12 or
      ** F3.
      *
     C                   IF        *IN69  = *OFF And *INKL = *OFF
      *
      ** Validate input
      *
     C                   EXSR      SRVAL
      *
      ** No errors
      *
     C                   IF        *IN75   = *OFF
      *
      ** Allocate record via update index
      *
     C                   EXSR      SRALOC
      *
      ** If record on file and allocated, compare record images,
      ** else, screen will be redisplayed
      *
     C                   IF        *IN60   = *OFF And *IN61 = *OFF
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
      /EJECT
      *================================================================
      * SRDEL - Routine to handle 'DELETE' action
      *================================================================
      *
     C     SRDEL         BEGSR
      *
      ** Set indicators on for 'DELETE' mode to protect fields
      *
     C                   EVAL      *IN15   = *ON
      *
      ** Check whether record exists
      *
     C                   EXSR      SRREC
      *
      ** If record not found,
      ** set DB error indicator, setup message, display screen, exit
      *
     C                   IF        *IN89   = *ON
      *
     C                   EVAL      *IN69   = *ON
     C                   EVAL      ZAMSID  = 'ER99916'
     C                   EXSR      SRSMSG
      *
      ** Execute DB error routine
      *
     C                   MOVEL     WWEXTF        WWBFIL
     C                   Z-ADD     3             WWBASE
     C                   MOVEL     KINST         WWBKEY
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
     C                   IF        *IN60   = *OFF And *IN61 = *OFF
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
      /EJECT
      *================================================================
      * SRENQ - Routine to handle 'ENQUIRY' action
      *================================================================
      *
     C     SRENQ         BEGSR
      *
      ** Set indicators on for 'ENQUIRY' mode to protect fields
      *
     C                   EVAL      *IN15   = *ON
      *
      ** Check whether record exists
      *
     C                   EXSR      SRREC
      *
      ** If record not found,
      ** set DB error indicator, setup message, display screen, exit
      *
     C                   IF        *IN89   = *ON
      *
     C                   EVAL      *IN69   = *ON
     C                   EVAL      ZAMSID  = 'ER99917'
     C                   EXSR      SRSMSG
      *
      ** Display screen
      *
     C                   EXSR      SRSCRN
      *
      ** Execute DB error routine
      *
     C                   MOVEL     WWEXTF        WWBFIL
     C                   Z-ADD     4             WWBASE
     C                   MOVEL     KINST         WWBKEY
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
     C                   EVAL      ZAMSGF  = 'STUSRMSG'
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
      /EJECT
      *================================================================
      * SRREC - Routine to access file via retrieve index
      *================================================================
      *
     C     SRREC         BEGSR
      *
     C     KINST         CHAIN     RTVIDX                             89
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRALOC - Routine to access record via update index
      *================================================================
      *
     C     SRALOC        BEGSR
      *
     C     KINST         CHAIN     UPDIDX                             6061
      *
      ** If record not on file, setup message 'Record deleted'
      *
     C                   IF        *IN60   = *ON
     C                   EVAL      ZAMSID  = 'ER99918'
     C                   EXSR      SRSMSG
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRUPD - Routine to update file.
      *================================================================
      *
     C     SRUPD         BEGSR
      *
     C                   UPDATE    UPDIDX                               68
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRWRT - Routine to write a new record to the file.
      *================================================================
      *
     C     SRWRT         BEGSR
      *
     C                   WRITE     UPDIDX                               68
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRDELR - Routine to delete a record
      *================================================================
      *
     C     SRDELR        BEGSR
      *
     C                   DELETE    UPDIDX                               68
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRCOMP - Routine to compare before/after image of records
      *================================================================
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
     C     KINST         SETLL     UPDIDX
      *
      ** Set condition to redisplay screen
      *
     C                   EVAL      *IN60   = *ON
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRSAVE - Routine to save before image of record via DS
      *================================================================
      *
     C     SRSAVE        BEGSR
      *
     C                   MOVEL     NWRCD         SVRCD
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRRTRN - Routine to set up return code for calling program
      *================================================================
      *
     C     SRRTRN        BEGSR
      *
     C                   SELECT
      *
      ** DBF update error
      *
     C                   WHEN      *IN69   = *ON
     C                   EVAL      WWRTRN  = 'Y2U0004'
      *
      ** Database / Screen error
      *
     C                   WHEN      *IN68   = *ON
     C                   EVAL      WWRTRN  = 'USR0563'
      *
      ** F12 pressed
      *
     C                   WHEN      *INKL   = *ON
     C                   EVAL      WWRTRN  = 'USR0790'
      *
      ** No errors
      *
     C                   OTHER
     C                   EVAL      WWRTRN  = *Blank
     C                   ENDSL
      *
     C                   CLOSE     SDINX1PD                             99
      *
      ** Exit program
      *
     C                   EVAL      *INLR   = *ON
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRSCRN - Routine to clear program's message queue.
      *================================================================
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
      ** Clear messages for redisplay
      *
     C                   EXSR      SRCMSG
      *
      ** Initialize error condition indicators
      *
     C                   EVAL      *IN75   = *OFF
     C                   MOVEA     '000'         *IN(20)
     C                   MOVEA     '000'         *IN(23)
      *
     C                   EXSR      SRECOS
     C                   EXSR      SRNCOS
      *
     C                   ENDSR
      *
      /EJECT
      *================================================================
      * SRECOS - Validate Economic Sector Codes
      *================================================================
     C     SRECOS        BEGSR
      *
     C     #0ECOL        IFNE      0
     C     #0ECOL        CHAIN     SDECOSLXPD                         88
      *
     C     *IN88         IFEQ      *ON
     C     VGCNLU        ORNE      'Y'
     C                   MOVE      *ON           *IN75
     C                   MOVE      *ON           *IN20
     C                   EVAL      ZAMSID  = 'ER00112'
     C                   EVAL      ZAMSGF  = 'STUSRMSG'
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDIF
      *
     C     #0ECOB        IFNE      0
     C     #0ECOB        CHAIN     SDECOSLXPD                         88
      *
     C     *IN88         IFEQ      *ON
     C     VGCNBE        ORNE      'Y'
     C                   MOVE      *ON           *IN75
     C                   MOVE      *ON           *IN21
     C                   EVAL      ZAMSID  = 'ER00112'
     C                   EVAL      ZAMSGF  = 'STUSRMSG'
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDIF
      *
     C     #0ECOO        IFNE      0
     C     #0ECOO        CHAIN     SDECOSLXPD                         88
      *
     C     *IN88         IFEQ      *ON
     C     VGCNOT        ORNE      'Y'
     C                   MOVE      *ON           *IN75
     C                   MOVE      *ON           *IN22
     C                   EVAL      ZAMSID  = 'ER00112'
     C                   EVAL      ZAMSGF  = 'STUSRMSG'
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRNCOS - Validate New Economic Sector Codes
      *================================================================
     C     SRNCOS        BEGSR
      *
     C     #0NCOL        IFNE      0
     C     #0NCOL        CHAIN     SDNCOSPD                           88
      *
     C     *IN88         IFEQ      *ON
     C     VNCNLU        ORNE      'Y'
     C                   MOVE      *ON           *IN75
     C                   MOVE      *ON           *IN23
     C                   EVAL      ZAMSID  = 'ER00112'
     C                   EVAL      ZAMSGF  = 'STUSRMSG'
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     #0NCOE        IFNE      0
     C     #0NCOE        CHAIN     SDNCOSPD                           88
      *
     C     *IN88         IFEQ      *ON
     C     VNCNEM        ORNE      'Y'
     C                   MOVE      *ON           *IN75
     C                   MOVE      *ON           *IN24
     C                   EVAL      ZAMSID  = 'ER00112'
     C                   EVAL      ZAMSGF  = 'STUSRMSG'
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     #0NCOO        IFNE      0
     C     #0NCOO        CHAIN     SDNCOSPD                           88
      *
     C     *IN88         IFEQ      *ON
     C     VNCNOT        ORNE      'Y'
     C                   MOVE      *ON           *IN75
     C                   MOVE      *ON           *IN25
     C                   EVAL      ZAMSID  = 'ER00112'
     C                   EVAL      ZAMSGF  = 'STUSRMSG'
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *================================================================
      * SRINZ - Routine to initialize screen fields with defaults
      *================================================================
      *
     C     SRINZ         BEGSR
      *
     C                   Z-ADD     4000          #0ECOL
     C                   Z-ADD     4000          #0ECOB
     C                   Z-ADD     4000          #0ECOO
     C                   Z-ADD     9000          #0NCOL
     C                   Z-ADD     9000          #0NCOE
     C                   Z-ADD     9000          #0NCOO
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRFTOS - Routine to move file fields to screen fields
      *================================================================
      *
     C     SRFTOS        BEGSR
      *
     C                   Z-ADD     AOECOL        #0ECOL
     C                   Z-ADD     AOECOB        #0ECOB
     C                   Z-ADD     AOECOO        #0ECOO
     C                   Z-ADD     AONCOL        #0NCOL
     C                   Z-ADD     AONCOE        #0NCOE
     C                   Z-ADD     AONCOO        #0NCOO
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRSTOF - Routine to move screen fields to file fields
      *================================================================
      *
     C     SRSTOF        BEGSR
      *
      ** Move key field to file field
      *
     C                   MOVE      KINST         AOLINC
      *
      ** Move data fields to file fields
      *
     C     #0ECOL        IFNE      0
     C                   Z-ADD     #0ECOL        AOECOL
     C                   ELSE
     C                   Z-ADD     4000          AOECOL
     C                   ENDIF
      *
     C     #0ECOB        IFNE      0
     C                   Z-ADD     #0ECOB        AOECOB
     C                   ELSE
     C                   Z-ADD     4000          AOECOB
     C                   ENDIF
      *
     C     #0ECOO        IFNE      0
     C                   Z-ADD     #0ECOO        AOECOO
     C                   ELSE
     C                   Z-ADD     4000          AOECOO
     C                   ENDIF
      *
     C     #0NCOL        IFNE      0
     C                   Z-ADD     #0NCOL        AONCOL
     C                   ELSE
     C                   Z-ADD     9000          AONCOL
     C                   ENDIF
      *
     C     #0NCOE        IFNE      0
     C                   Z-ADD     #0NCOE        AONCOE
     C                   ELSE
     C                   Z-ADD     9000          AONCOE
     C                   ENDIF
      *
     C     #0NCOO        IFNE      0
     C                   Z-ADD     #0NCOO        AONCOO
     C                   ELSE
     C                   Z-ADD     9000          AONCOO
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *================================================================
      * SRINIT - Routine to handle initial processing
      *================================================================
      *
     C     SRINIT        BEGSR
      *
      ** Get parameters from calling program
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTION
     C                   PARM                    DATA
     C                   PARM                    WWRTRN            7
     C                   PARM                    DUMMY1            3 0
     C                   PARM                    DUMMY2            3 0
     C                   PARM                    DUMMY3            3 0
     C                   PARM                    DUMMY4            3 0
     C                   PARM                    DUMMY5           10
     C                   PARM                    WSPARE          256
      *
     C     *LIKE         DEFINE    AOLINC        #1LINC
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       WRTCD             7
     C                   PARM      '*VERIFY'     WOPTN             7
     C                   PARM      'ULX004'      WSARD             6
     C                   PARM                    DSFDY
     C                   SELECT
     C                   WHEN      WRTCD=*BLANKS
     C                   MOVE      'Y'           ULX004            1
     C                   WHEN      WRTCD='*NRF   '
     C                   MOVE      'N'           ULX004
     C                   OTHER
     C                   MOVEL     'SCSARDPD'    WWBFIL
     C                   MOVEL     '01'          WWBASE
     C                   MOVEL     WOPTN         WWBKEY
     C                   EXSR      *PSSR
     C                   ENDSL
      *
      ** Get rundate
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   EVAL      BJMRDT  = MRDT
     C                   EVAL      SPGM    = 'SD0092'
     C                   EVAL      SUSER   = PSUser
     C                   EVAL      SJOB    = PSJobName
      *
      ** Setup file value used in database error during access to
      ** retrieval index
      *
     C                   EVAL      WWEXTF  = 'SDINX1PD'
      *
      ** Initialise error indicators
      *
     C                   MOVEA     '000'         *IN(20)
     C                   MOVEA     '000'         *IN(23)
     C                   Eval      *IN75   = *OFF
      *
      ** Call Access Program for Midas Modules Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDMMODPD'    WWBFIL
     C                   MOVEL     '02'          WWBASE
     C                   MOVEL     @OPTN         WWBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        (BGLRIN <> 'Y') OR (ULX004 <> 'Y')
     C                   EVAL      WWRTRN  = *Blank
     C                   EVAL      *INLR   = *ON
     C                   RETURN
     C                   ELSE
     C                   OPEN      SDINX1PD
     C                   ENDIF
      *
      ** Setup key values using transaction data passed from caller
      *
     C                   MOVE      #1LINC        KINST             2
      *
     C                   ENDSR
      *================================================================
      * SNDMSG - Send message to program's message queue.
      *================================================================
     C     SNDMSG        BEGSR
      *
      ** Send message to program's message queue.
      *
     C                   IF        ZAPGM   = *Blank
     C                   EVAL      ZAPGM   = PSProcName
     C                   ENDIF
      *
     C                   CALL      'SNDERMSG'
     C                   PARM                    ZAPGM            10
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
      /EJECT
      *****************************************************************
      *  *PSSR -  ERROR PROCESSING                                    *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Update data area LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM   = 'SD0092'
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
     C                   CALL      'DBERRCTL'
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2005
