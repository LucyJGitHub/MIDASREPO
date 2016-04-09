     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD LUX Loan Type')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0282 - Loan Type/Sub-Type                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG11548           Date 22Jun06               *
      *  Prev Amend No. CLE042             Date 06Sep05               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG11548 - Error message is displayed when amending LTST     *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *---------------------------------------------------------------*
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
      *-------------------------------------------------------------------------
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
      * - Key fields should start with K ,i.e. KSD
      *   (Also for fields used in KLIST's)
      *
      * - Subroutines should start with SR, i.e. SRVAL for validation,
      *   SRINIT for initial routine , etc...
      *
      *-------------------------------------------------------------------------
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
      *-------------------------------------------------------------------------
     FSDLNX1L0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDLOANF6:RTVIDX)
      *Extended Loan Type/Sub-type     Retrieval index       Prefix VI.
      *
     FSDLNX1PD  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
     F                                     RENAME(SDLOANF6:UPDIDX)
      *Extended Loan Type/Sub-type     Update index          Prefix VI.
      *
     FSD0282DF  CF   E             WORKSTN
     F                                     RENAME(SD0282F5:SCREEN)
      *                                Display file          Prefix #0.
      /EJECT
      *-------------------------------------------------------------------------
   33 ** Array containing Copyright statement
   33D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** API DUMP Information Data Area for database error reporting;
      ** based on external file
     D APDUMP        E DS                  EXTNAME(APDUMP) DTAARA(APDUMP)
 
     D                SDS
      ** Get program name from PSDS
     D  SPGM             *PROC
     D  SJOB                 244    253
     D  SUSER                254    263
     D  PSProcMod            344    353
      /EJECT
      *-------------------------------------------------------------------------
     D DLDA            DS           256
      ** Data structure for data-base processing
     D  DBFILE               132    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D DATALUX         DS          1024
     D  #1LNTY                 1      2
     D  #1LNST                 3      4
     D  #1LNCL                 5      8                                                       CLE042
      *
      /EJECT
      *-------------------------------------------------------------------------
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Midas SD Bank details ICD file
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
     D @MMOD         E DS                  EXTNAME(SDMMODPD)
      ** Dummy record formats for access to Midas modules details
     D NWRCD         E DS                  EXTNAME(SDLNX1PD)
      *
      ** Current/previous master file fields
      *
      /EJECT
      *-------------------------------------------------------------------------
     D***SVRCD**         DS             7                                                   BUG11548
     D SVRCD           DS            11                                                     BUG11548
      *
      ** Stored master file fields
      *
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Whether or not *PSSR has been run previously
     D RunBefore       S              1A
 
      /EJECT
      *-------------------------------------------------------------------------
      * Main processing
      *-------------------------------------------------------------------------
      *
      ** Execute initial routine
      *
     C                   EXSR      SRINIT
      *
      ** Execute specific routine depending on action
      *
     C     ACTION        CASEQ     'I'           SRINS
     C     ACTION        CASEQ     'D'           SRDEL
     C                   ENDCS
      *
     C     ACTION        CASEQ     'A'           SRAMD
     C     ACTION        CASEQ     'E'           SRENQ
     C                   ENDCS
      *
      ** Execute routine to setup return code and exit program
      *
     C                   EXSR      SRRTRN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRINS - Routine to handle 'INSERT' action
      *
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
      ** Bypass any further validation if previous DB error or F12
      *
     C     *IN69         IFEQ      *OFF
     C     *INKL         ANDEQ     *OFF
      *
      ** Clear messages for redisplay
      *
     C                   EXSR      SRCMSG
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
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRAMD - Routine to handle 'AMEND' action
      *
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
     C     *IN89         IFEQ      *ON
      *
     C                   MOVE      *ON           *IN69
     C                   MOVEL     'ER99920'     ZAMSID
     C                   EXSR      SRSMSG
      *
      ** Protect fields for display
      *
     C                   MOVE      *ON           *IN15
      *
      ** Display screen
      *
     C                   EXSR      SRSCRN
      *
      ** Execute DB error routine
      *
     C                   MOVEL     WWEXTF        WWBFIL
     C                   Z-ADD     2             WWBASE
     C                   MOVEL     KLNTY         WWBKEY
     C                   EXSR      SRDBER
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
      ** record on file and no errors left or F12 pressed
      *
     C     *IN61         DOUEQ     *OFF
     C     *IN60         ANDEQ     *OFF
     C     *IN75         ANDEQ     *OFF
     C     *INKL         OREQ      *ON
      *
     C                   EXSR      SRSCRN
      *
      ** Bypass any further validation if previous DB error or F12
      *
     C     *IN69         IFEQ      *OFF
     C     *INKL         ANDEQ     *OFF
      *
      ** Clear messages for redisplay
      *
     C                   EXSR      SRCMSG
      *
      ** Validate input
      *
     C                   EXSR      SRVAL
      *
      ** No errors
      *
     C     *IN75         IFEQ      *OFF
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
      *
      * SRDEL - Routine to handle 'DELETE' action
      *
      *****************************************************************
     C     SRDEL         BEGSR
      *
      ** Set indicators on for 'DELETE' mode to protect fields
      *
     C                   MOVE      *ON           *IN15
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
     C                   MOVE      *ON           *IN69
     C                   MOVEL     'ER99916'     ZAMSID
     C                   EXSR      SRSMSG
      *
      ** Execute DB error routine
      *
     C                   MOVEL     WWEXTF        WWBFIL
     C                   Z-ADD     3             WWBASE
     C                   MOVEL     KLNTY         WWBKEY
     C                   EXSR      SRDBER
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
      *
      * SRENQ - Routine to handle 'ENQUIRY' action
      *
      *****************************************************************
     C     SRENQ         BEGSR
      *
      ** Set indicators on for 'ENQUIRY' mode to protect fields
      *
     C                   MOVE      *ON           *IN15
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
     C                   MOVE      *ON           *IN69
     C                   MOVEL     'ER99917'     ZAMSID
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
     C                   MOVEL     KLNTY         WWBKEY
     C                   EXSR      SRDBER
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
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRSMSG - Routine to send messages to message subfile.
      *
      *****************************************************************
     C     SRSMSG        BEGSR
      *
     C     ZAMSGF        IFEQ      *BLANKS
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   ENDIF
     C                   CALL      'SNDERMSG'
      *
      ** Program queue
      *
     C                   PARM      SPGM          ZAPGM            10
      *
      ** Rel queue
      *
     C                   PARM                    ZAPGRL            5
      *
      ** Message Id
      *
     C                   PARM                    ZAMSID            7
      *
      ** Message File
      *
     C                   PARM                    ZAMSGF           10
      *
      ** Message data
      *
     C                   PARM                    ZAMSDA          132
      *
      ** Message type
      *
     C                   PARM                    ZAMSTP            7
      *
      ** Clear all fields for default mechanism next time.
      *
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRCMSG - Routine to clear program's message queue.
      *
      *****************************************************************
     C     SRCMSG        BEGSR
      *
     C                   CALL      'CLRERMSG'
     C                   PARM      SPGM          ZAPGM
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRREC - Routine to access file via retrieve index
      *
      *****************************************************************
     C     SRREC         BEGSR
      *
     C     KSD           CHAIN     RTVIDX                             89
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRALOC - Routine to access record via update index
      *
      *****************************************************************
     C     SRALOC        BEGSR
      *
     C     KSD           CHAIN     UPDIDX                             6061
      *
      ** If record not on file, setup message 'Record deleted'
      *
     C     *IN60         IFEQ      *ON
     C                   MOVEL     'ER99918'     ZAMSID
     C                   EXSR      SRSMSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRUPD - Routine to update file.
      *
      *****************************************************************
     C     SRUPD         BEGSR
      *
     C                   UPDATE    UPDIDX                               68
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRWRT - Routine to write a new record to the file.
      *
      *****************************************************************
     C     SRWRT         BEGSR
      *
     C                   WRITE     UPDIDX                               68
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRDELR - Routine to delete a record
      *
      *****************************************************************
     C     SRDELR        BEGSR
      *
     C                   DELETE    UPDIDX                               68
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRCOMP - Routine to compare before/after image of records
      *
      *****************************************************************
     C     SRCOMP        BEGSR
      *
     C     SVRCD         IFEQ      NWRCD
     C                   MOVE      'Y'           WWMTCH            1
     C                   ELSE
     C                   MOVE      'N'           WWMTCH
     C                   MOVEL     'ER99919'     ZAMSID
     C                   EXSR      SRSMSG
      *
      ** Use SETLL to release record lock
      *
     C     KSD           SETLL     UPDIDX
      *
      ** Set condition to redisplay screen
      *
     C                   MOVE      *ON           *IN60
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRSAVE - Routine to save before image of record via DS
      *
      *****************************************************************
     C     SRSAVE        BEGSR
      *
     C                   MOVEL     NWRCD         SVRCD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRRTRN - Routine to set up return code for calling program
      *
      *****************************************************************
     C     SRRTRN        BEGSR
      *
      ** DBF update error
      *
     C     *IN69         IFEQ      *ON
     C                   MOVE      'Y2U0004'     WWRTRN
     C                   ELSE
      *
      ** Database / Window error
      *
     C     *IN68         IFEQ      *ON
     C                   MOVE      'USR0563'     WWRTRN
     C                   ELSE
      *
      ** F12 pressed
      *
     C     *INKL         IFEQ      *ON
     C                   MOVE      'USR0790'     WWRTRN
     C                   ELSE
      *
      ** No errors
      *
     C                   MOVE      *BLANKS       WWRTRN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   CLOSE     SDLNX1PD                             99
      *
      ** Exit program
      *
     C                   MOVE      *ON           *INLR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRDBER - Routine to handle database errors
      *
      *****************************************************************
     C     SRDBER        BEGSR
      *
      ** Update data area LDA
      *
     C     *DTAARA       DEFINE    LDA           DLDA
     C     *LOCK         IN        DLDA
     C                   MOVEL     'SD0282'      DBPGM
     C                   MOVE      WWBFIL        DBFILE
     C                   MOVE      WWBKEY        DBKEY
     C                   MOVE      WWBASE        DBASE
     C                   OUT       DLDA
      *
      ** Set on data-base error indicators
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *IN69
      *
      ** Dump program
      *
     C                   DUMP
      *
      ** Call standard DB error handler
      *
     C                   CALL      'DBERRCTL'                           81
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRSCRN - Routine to handle screen and validation
      *
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
      *****************************************************************
      /EJECT
      *****************************************************************
      * The routines that can be changed start here...
      *****************************************************************
      *
      * SRVAL - Routine to control validation of each field.
      *
      *****************************************************************
     C     SRVAL         BEGSR
      *
      ** Initialize error condition indicators
      *
     C                   MOVE      *OFF          *IN75
     C                   MOVEA     '000'         *IN(23)
      *
     C                   EXSR      SRMOBC
     C                   EXSR      SRPMOB
     C                   EXSR      SRDIST
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRMOBC - Validation of mobilisable
      *
      *****************************************************************
     C     SRMOBC        BEGSR
      *
     C     #0MOBC        IFLT      0
     C     #0MOBC        ORGT      2
     C                   MOVE      *ON           *IN75
     C                   MOVE      *ON           *IN23
     C                   MOVEL     'ER25201'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *
      * SRPMOB - VALIDATION OF POSSIBILITY OF MOBILISATION
      *
      *****************************************************************
     C     SRPMOB        BEGSR
      *
     C     #0PMOB        IFLT      0
     C     #0PMOB        ORGT      2
     C                   MOVE      *ON           *IN75
     C                   MOVE      *ON           *IN24
     C                   MOVEL     'ER25202'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *
      * SRDIST - VALIDATION OF DISCOUNT TYPE
      *
      *****************************************************************
     C     SRDIST        BEGSR
      *
     C     #0DIST        IFLT      0
     C     #0DIST        ORGT      3
     C                   MOVE      *ON           *IN75
     C                   MOVE      *ON           *IN25
     C                   MOVEL     'ER25203'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      SNDMSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *
      * SRINZ - Routine to initialize screen fields with defaults
      *
      *****************************************************************
     C     SRINZ         BEGSR
      *
     C                   Z-ADD     0             #0PMOB
     C                   Z-ADD     0             #0DIST
     C                   Z-ADD     0             #0MOBC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFTOS - Routine to move file fields to screen fields
      *****************************************************************
     C     SRFTOS        BEGSR
      *
     C                   Z-ADD     VIPMOB        #0PMOB
     C                   Z-ADD     VIDIST        #0DIST
     C                   Z-ADD     VIMOBC        #0MOBC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRSTOF - Routine to move screen fields to file fields
      *
      *****************************************************************
     C     SRSTOF        BEGSR
      *
      ** Move key field to file field
      *
     C                   MOVE      KLNTY         VILNTY
     C                   MOVE      KLNST         VILNST
     C                   MOVE      KLNCL         VILNCL                                       CLE042
      *
      ** Move data fields to file fields
      *
     C                   Z-ADD     #0PMOB        VIPMOB
     C                   Z-ADD     #0DIST        VIDIST
     C                   Z-ADD     #0MOBC        VIMOBC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRINIT - Routine to handle initial processing
      *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Get parameters from calling program
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTION            1
     C                   PARM                    DATALUX
     C                   PARM                    WWRTRN            7
      *
      ** Setup key values using transaction data passed from caller
      *
     C                   MOVE      #1LNTY        KLNTY             2
     C                   MOVE      #1LNST        KLNST             2
     C                   MOVE      #1LNCL        KLNCL             4                          CLE042
      *
     C     KSD           KLIST
     C                   KFLD                    KLNTY
     C                   KFLD                    KLNST
     C                   KFLD                    KLNCL                                        CLE042
      *
      ** Redefine data-base error fields for program
      *
     C     *LIKE         DEFINE    DBFILE        WWBFIL
     C     *LIKE         DEFINE    DBKEY         WWBKEY
     C     *LIKE         DEFINE    DBASE         WWBASE
      *
      ** Setup file value used in database error during access to
      ** retrieval index
      *
     C     *LIKE         DEFINE    DBFILE        WWEXTF
     C                   MOVEL     'SDLNX1PD'    WWEXTF
      *
      ** Initialise error indicators
      *
     C                   MOVEA     '000'         *IN(23)
     C                   MOVE      *OFF          *IN75
      *
      ** Call access program for Midas modules details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     @MMOD         PARM      @MMOD         DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDMMODPD'    WWBFIL
     C                   MOVEL     '99'          WWBASE
     C                   MOVEL     @OPTN         WWBKEY
     C                   EXSR      SRDBER
     C                   ENDIF
      *
     C     BGLRIN        IFNE      'Y'
     C                   MOVE      *BLANKS       WWRTRN
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ELSE
     C                   OPEN      SDLNX1PD
     C                   ENDIF
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      WRTCD             7
     C                   PARM      '*FIRST'      WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        DLDA
     C                   Z-ADD     001           DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     SPGM          DBPGM
     C                   OUT       DLDA
     C                   EXSR      SRDBER
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SNDMSG - Send Message
      *
      *****************************************************************
     C     SNDMSG        BEGSR
      *
      ** Send message to program's message queue.
      *
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     SPGM          ZAPGM
     C                   ENDIF
     C                   CALL      'SNDERMSG'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      *
      ** Clear all fields for default mechanism next time.
      *
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
      *
     C                   ENDSR
      *****************************************************************
      *
      * *PSSR -  ERROR PROCESSING
      *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   EVAL      *inu7 = *on
     C                   EVAL      *inu8 = *on
     C                   EVAL      *inlr = *on
      *
     C                   IF        RunBefore <> 'Y'
      *
     C                   EVAL      RunBefore = 'Y'
      *
      ** Load the APDUMP fields
      *
     C     *lock         IN        APDUMP                               99
      *
      ** If there is an error in reading the APDUMP data area, it
      ** probably doesn't exist, so call the procedure which creates it
      ** and try again.
      *
     C                   IF        *in99
      *
     C                   CLEAR                   PSSRRetCde
     C                   CALL      'APCCRTQTO'
     C                   PARM                    PSSRRetCde       10
      *
     C     *lock         IN        APDUMP
      *
     C                   ENDIF
      *
     C                   EVAL      ARErrMod = PSProcMod
     C                   OUT       APDUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
