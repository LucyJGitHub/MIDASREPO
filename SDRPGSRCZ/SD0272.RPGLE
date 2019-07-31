     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Facility Type - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting - Luxembourt                      *
      *                                                               *
      *  SD0272 - ER LUX Facility Type window                         *
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
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *
      *   The following routines CANNOT be changed :
      *   ========================================
      *
      *   (Main processing)
      *   SRINS
      *   SRAMD
      *   SRDEL
      *   SRENQ
      *   SRSMSG
      *   SRCMSG
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
      *----------------------------------------------------------------
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
      * - Key fields should start with K ,i.e. KFACT
      *   (Also for fields used in KLIST's)
      *
      * - Subroutines should start with SR, i.e. SRVAL for validation,
      *   SRINIT for initial routine , etc...
      *
      *----------------------------------------------------------------
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
      *  *IN82  -  Plexus capital currency in error
      *  *IN89  -  Extension record not found via retrieval index
      *
      *  *INKJ  -  F10 pressed, enable delete
      *  *INKL  -  F12 pressed, exit
      *  *INLR  -  End processing
      *
      *  *INU7  -  :    Data-base
      *  *INU8  -  :  error control
      *
      *----------------------------------------------------------------
      *
     FSDFCX1L0  IF   E           K DISK
     F                                     RENAME(SDFACTF6:RTVIDX)
      ** Extended Deal Sub-type - Retrieval index
      *
     FSDFCX1PD  UF A E           K DISK    COMMIT
     F                                     USROPN
     F                                     RENAME(SDFACTF6:UPDIDX)
      ** Extended Deal Sub-type - Update index
      *
     FSD0272DF  CF   E             WORKSTN
     F                                     RENAME(SD0272F1:SCREEN)
      ** ER Facility Type - Display file
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
     D DATA            DS          1024
     D   #1FCTY                1      3A
 
     D Rundat          Ds
      ** Midas SD rundate data area
      *
     D  MRDT                   1      7
     D                         8     13
      /EJECT
      *----------------------------------------------------------------
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First Ds for access programs, short data structure
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Dummy record formats for access to midas modules details
      *
     D NWRCD         E DS                  EXTNAME(SDFCX1PD)
      ** Current/previous master file fields
      *
     D SVRCD           DS             5
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
      *
      *----------------------------------------------------------------
      *
      /EJECT
      *****************************************************************
      *  Main processing                                              *
      *  Calls: SRINIT, SRINS, SRDEL, SRAMD, SRENQ, SRRTRN            *
      *****************************************************************
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
      *  SRINS - Routine to handle 'INSERT' action                    *
      *  Called by: Main processing                                   *
      *  Calls: SRREC, SRSVE, SRINZ, SRSCRN, SRALOC, SRCOMP           *
      *         SRSTOF, SRUPD, SRWRT                                  *
      *****************************************************************
     C     SRINS         BEGSR
      *
      ** Check whether record exists
      *
     C                   EXSR      SRREC
      *
      ** If record found,
      *
     C                   IF        *IN89   = '0'
      *
      ** In case of 'Insert over Deleted Record', save before image
      *
     C                   EXSR      SRSAVE
      *
     C                   ENDIF
      *
      ** Initialize fields
      *
     C                   EXSR      SRINZ
      *
      ** Display and handle screen until no more errors, F3 or F12
      *
     C                   DoU       *IN75 = '0' Or *INKL = '1'
     C                             OR *INKC=*ON
      *
      ** Clear messages for redisplay
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
     C                   IF        *IN60  = '0' And *IN61 = '0'
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
      *****************************************************************
      *  SRAMD - Routine to handle 'AMEND' action                     *
      *  Called by: Main processing                                   *
      *  Calls: SRREC, SRSMSG, SRSCRN, SRFTOS, SRSAVE,                *
      *         SRCMSG, SRVAL, SRALOC, SRCOMP, SRSTOF, SRUPD          *
      *****************************************************************
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
      *
      ** Protect fields for display
      *
     C                   EVAL      *IN15   = '1'
      *
      ** Display screen
      *
     C                   EXSR      SRSCRN
      *
      ** Execute DB error routine
      *
     C                   MOVEL     WWEXTF        WWBFIL
     C                   Z-ADD     2             WWBASE
     C                   MOVEL     KFACT         WWBKEY
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ** Record found,
      ** set file fields to screen fields and save before image
      *
     C                   EXSR      SRFTOS
     C                   EXSR      SRSAVE
      *
      ** Display and handle screen until record can be allocated and
      ** record on file and no errors left or F12 pressed or F3
      *
     C                   DOU       *IN61  = '0' And *IN60 = '0' And
     C                             *IN75  = '0' Or  *INKL = '1'
     C                             OR *INKC=*ON
      *
     C                   EXSR      SRSCRN
      *
      ** Bypass any further validation if previous DB error or F12 or F3
      *
     C                   IF        *IN69  = '0' And *INKL = '0'
     C                             AND *INKC=*OFF
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
      /EJECT
      *****************************************************************
      *  SRDEL - Routine to handle 'DELETE' action                    *
      *  Called by: Main processing                                   *
      *  Calls: SRREC, SRSMSG, SRSVAE, SRALOC, SRCOMP, SRDELR         *
      *****************************************************************
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
     C                   MOVEL     WWEXTF        WWBFIL
     C                   Z-ADD     3             WWBASE
     C                   MOVEL     KFACT         WWBKEY
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ** Record found, save before image
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
      /EJECT
      *****************************************************************
      *  SRENQ - Routine to handle 'ENQUIRY' action                   *
      *  Called by: Main processing                                   *
      *  Calls: SRREC, SRSMSG, SRSCRN, SRFTOS                         *
      *****************************************************************
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
     C                   MOVEL     WWEXTF        WWBFIL
     C                   Z-ADD     4             WWBASE
     C                   MOVEL     KFACT         WWBKEY
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
     C                   EVAL      ZAMSGF  = 'SDUSRMSG'
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
      *****************************************************************
      *  SRREC - Routine to access file via retrieve index            *
      *  Called by: Main processing, SRDEL, SRENQ, SRSMSG             *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRREC         BEGSR
      *
     C     KFACT         CHAIN     RTVIDX                             89
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRALOC - Routine to access record via update index           *
      *  Called by: SRINS, SRAMD, SRDEL, SRENQ, SRSMSG                *
      *  Calls: SRSMSG                                                *
      *****************************************************************
     C     SRALOC        BEGSR
      *
     C     KFACT         CHAIN     UPDIDX                             6061
      *
      ** If record not on file, setup message 'Record deleted'
      *
     C                   IF        *IN60   = '1'
     C                   EVAL      ZAMSID  = 'ER99918'
     C                   EXSR      SRSMSG
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRUPD - Routine to update file.                              *
      *  Called by: SRINS, SRAMD                                      *
      *  Calls: None                                                  *
      *****************************************************************
      *
     C     SRUPD         BEGSR
      *
     C                   UPDATE    UPDIDX                               68
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRWRT - Routine to write a new record to the file.           *
      *  Called by: SRINS                                             *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRWRT         BEGSR
      *
     C                   WRITE     UPDIDX                               68
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRDELR - Routine to delete a record                          *
      *  Called by: SRDEL                                             *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRDELR        BEGSR
      *
     C                   DELETE    UPDIDX                               68
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRCOMP - Routine to compare before/after image of records    *
      *  Called by: SRINS, SRAMD, SRDEL                               *
      *  Calls: None                                                  *
      *****************************************************************
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
     C     KFACT         SETLL     UPDIDX
      *
      ** Set condition to redisplay screen
      *
     C                   EVAL      *IN60   = '1'
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRSAVE - Routine to save before image of record via DS       *
      *  Called by: SRINS, SRAMD, SRDEL                               *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRSAVE        BEGSR
      *
     C                   MOVEL     NWRCD         SVRCD
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRRTRN - Routine to set up return code for calling program   *
      *  Called by: Main Processing                                   *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRRTRN        BEGSR
      *
     C                   SELECT
      *
      ** DBF update error
      *
     C                   WHEN      *IN69   = '1'
     C                   EVAL      WWRTRN  = 'Y2U0004'
      *
      ** Database / Window error
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
     C                   CLOSE     SDFCX1PD                             99
      *
      ** Exit program
      *
     C                   EVAL      *INLR   = '1'
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRSCRN - Routine to handle screen and validation             *
      *  Called by: SRINS, SRAMD, SRENQ                               *
      *  Calls: SRMOBC, SRPMOB                                        *
      *****************************************************************
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
      *****************************************************************
      *  SRVAL - Routine to control validation of each field.         *
      *  Called by: SRVAL                                             *
      *  Calls: SRMOBC, SRPMOB                                        *
      *****************************************************************
     C     SRVAL         BEGSR
      *
     C                   EXSR      SRCMSG
      *
      ** Initialize error condition indicators
      *
     C                   EVAL      *IN75   = '0'
     C                   MOVEA     '00'          *IN(23)
     C                   EXSR      SRMOBC
     C                   EXSR      SRPMOB
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRMOBC - Validation of Mobilisable                           *
      *  Called by: SRVAL                                             *
      *  Calls: SNDMSG                                                *
      *****************************************************************
     C     SRMOBC        BEGSR
      *
     C                   IF        #0MOBC < 0 Or #0MOBC > 2
     C                   EVAL      *IN75   = '1'
     C                   EVAL      *IN23   = '1'
     C                   EVAL      ZAMSID  = 'ER25201'
     C                   EVAL      ZAMSGF  = 'SDUSRMSG'
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *  SRPMOB - Validation of Possibility of Mobilisation           *
      *  Called by: SRVAL                                             *
      *  Calls: SNDMSG                                                *
      *****************************************************************
     C     SRPMOB        BEGSR
      *
     C                   IF        #0PMOB  < 0 Or #0PMOB > 2
     C                   EVAL      *IN75   = '1'
     C                   EVAL      *IN24   = '1'
     C                   EVAL      ZAMSID  = 'ER25202'
     C                   EVAL      ZAMSGF  = 'SDUSRMSG'
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *  SRINZ - Routine to initialize screen fields with defaults    *
      *  Called by: SRIN                                              *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRINZ         BEGSR
      *
     C                   Z-ADD     0             #0PMOB
     C                   Z-ADD     0             #0MOBC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRFTOS - Routine to move file fields to screen fields        *
      *  Called by: SRAMD, SRENQ                                      *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRFTOS        BEGSR
      *
     C                   Z-ADD     VOMOBC        #0MOBC
     C                   Z-ADD     VOPMOB        #0PMOB
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRSTOF - Routine to move screen fields to file fields        *
      *  Called by: SRINS                                             *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRSTOF        BEGSR
      *
      ** Move key field to file field
      *
     C                   MOVE      KFACT         VOFACT
      *
      ** Move data fields to file fields
      *
     C                   Z-ADD     #0PMOB        VOPMOB
     C                   Z-ADD     #0MOBC        VOMOBC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRINIT - Routine to handle initial processing                *
      *  Called by: Main Processing                                   *
      *  Calls:                                                       *
      *****************************************************************
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
     C                   EVAL      SPGM    = 'SD0272'
     C                   EVAL      SUSER   = PSUser
     C                   EVAL      SJOB    = PSJobName
      *
      ** Setup file value used in database error during access to
      ** retrieval index
      *
     C                   EVAL      WWEXTF  = 'SDFCX1PD'
      *
      ** Initialise error indicators
      *
     C                   MOVEA     '000'         *IN(23)
     C                   Eval      *IN75   = '0'
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG    '    WRTCD
     C                   PARM      '*FIRST  '    WOPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C                   IF        WRTCD  <> *Blank
     C                   MOVEL     'SDMMODPD'    WWBFIL
     C                   MOVEL     '02'          WWBASE
     C                   MOVEL     WOPTN         WWBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        (BGLRIN <> 'Y') OR (ULX004 <> 'Y')
     C                   EVAL      WWRTRN  = *Blank
     C                   EVAL      *INLR   = '1'
     C                   RETURN
     C                   ELSE
     C                   OPEN      SDFCX1PD
     C                   ENDIF
      *
      ** Setup key values using transaction data passed from caller
      *
     C                   MOVE      #1FCTY        KFACT             3 0
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SNDMSG - Send Message                                        *
      *  Called by: SRMOBC, SRPMOB                                    *
      *  Calls: None                                                  *
      *****************************************************************
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
      *  *PSSR - Error processing                                     *
      *  Called by:                                                   *
      *  Calls: None                                                  *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Update data area LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM   = 'SD0272'
     C                   EVAL      DBFILE  = WWBFIL
     C                   EVAL      DBKEY   = WWBKEY
     C                   EVAL      DBASE   = WWBASE
     C                   OUT       LDA
      *
     C                   DUMP
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
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2005
