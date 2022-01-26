     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058068
/*STD *  RPGSQLBND                                                    *                     MD058068
/*EXI *  TEXT('Midas BoE Negotiable Assets Purchased Window')         *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  BYNASPW0 - Negotiable Assets Purchased Maintanance Window    *
      *                                                               *
      *  (c) Finastra International Limited 2000                      *
      *                                                               *
      *  Last Amend No. MD058068           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN016 *Create     Date 12May00               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058068 - Deliverable Data Split for Bank of England        *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN016 - Upgrade BoE to DBAR3.                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *        S U B R O U T I N E    S U M M A R Y                   *
      *                                                               *
      *  #LMAIN - Main Processing                                     *
      *  #LVALD - Validation                                          *
      *  #LUPDT - Update                                              *
      *  #LRSET - Reset Values                                        *
      *  #LEXIT - Cmd/3 Processing                                    *
      *  #LPREV - Cmd/12 Processing                                   *
      *  #LTERM - Program Termination                                 *
      *  *PSSR  - Error Handling                                      *
      *  *INZSR - Initialisation                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *        I N D I C A T O R   S U M M A R Y                      *
      *                                                               *
      *  03  -   F3 Pressed Exit Program                              *
      *  12  -   F12 Pressed - Previous Sceen                         *
      *  20  -   Protect Fields In Enquire Mode                       *
      *  21  -   Underline Fields in Amend Mode                       *
      *  47  -   Field Error: Guarantee Code                          *
      *  48  -   Field Error: Qualifying Flag                         *
      *  49  -   Field Error: Final Maturity Date                     *
      *  50  -   Validation Error - Display Messages                  *
      *  86  -   CHAIN to file BYGTEEPP (validation)                  *
      *  87  -   CHAIN to file BYNASPY0(initial READ)                 *
      *  88  -   CHAIN to file BYNASPY0(delete)                       *
      *  89  -   CHAIN to file BYNASPY0(update)                       *
      *                                                               *
      *****************************************************************
      *
      * Guarantee Codes - retrieval
     F*BYGTEEPP* IF   E           K DISK    INFSR(*PSSR)                                    MD058068
      *
      ** Negotiable Assets Purchase Extension File
     FBYNASPY0  UF A E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS1)
     F                                     COMMIT
      ** Negotiable Assets Purchased Window File
     FBYNASP#0  CF   E             WORKSTN
     F                                     INFSR(*PSSR)
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *COPY*ZSRSRC,ZDATE2Z1                                                                 MD058068
      /COPY ZSRSRC,ZDATE2Z1LE                                                               MD058068
      *
      ** File information data structure (for database files only)
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      *
      ** Externally defined data structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally defined data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Externally defined data structure(long)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Externally defined data structure(long)
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
     D BYGTEE        E DS                  EXTNAME(BYGTEJW0)                                MD058068
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      *
      *
      ** Deal Number and Maturity Date
     D DATA            DS          1024
     D  ULDLNO               301    306
     D  ULMDAT               307    312
      *
     D** Data passed from Main Program -
     D ULMSGF          C                   CONST('GBBYUSRMSG')
      *
     C/EJECT
      *
      **   Parameter list for window manager
     C     *ENTRY        PLIST
     C                   PARM                    ACTN              1            Action code
     C                   PARM                    DATA                           Transaction data
     C                   PARM                    W0RTN             7            Return code
     C                   PARM                    WLEN              3 0          Window length
     C                   PARM                    WWID              3 0          Window width
     C                   PARM                    SROW              3 0          Starting row
     C                   PARM                    SCOL              3 0          Starting column
     C                   PARM                    TITLE             7            Window title
     C                   PARM                    SPAREX          256            For future use...
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls:     #LMAIN, #LTERM                                     *
      *                                                               *
      *****************************************************************
      *
      ** Main Processing
     C                   EXSR      #LMAIN
      *
      ** Termination Processing
     C                   EXSR      #LTERM
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      * SR/#LMAIN - Main Processing                                   *
      *                                                               *
      * Called by:  Main Processing                                   *
      *                                                               *
      * Calls:  #LRSET, #LEXIT, #LPREV, #LTERM, #LVALD, #LUPDT        *
      *                                                               *
      *****************************************************************
     C     #LMAIN        BEGSR                                                  ** SR/#LMAIN**
      *
     C                   MOVE      'N'           ULVALD
      *
      ** Display screen until valid
     C     ULVALD        DOWEQ     'N'
      *
      ** Display window with messages if any
     C     *IN50         IFEQ      *ON
     C                   WRITE     #MSGCTL
     C                   ENDIF
      *
     C                   EXFMT     WINDOWF
      *
      ** Reset work fields and indicators and Clear Messages
     C                   EXSR      #LRSET
     C                   EXSR      #LCLMG
      *
      ** Cmd/3 - Exit program
     C     *IN03         IFEQ      *ON
     C                   EXSR      #LEXIT
     C                   ENDIF
      *
      ** Cmd/12 - Previous screen
     C     *IN12         IFEQ      *ON
     C                   EXSR      #LPREV
     C                   ENDIF
      *
      ** Enquiry Mode - Exit Program after display
     C     ACTN          IFEQ      'E'
     C                   EXSR      #LTERM
     C                   ENDIF
      *
      ** Delete Mode - Exit Program after deletion
     C     ACTN          IFEQ      'D'
     C                   EXSR      #LDLT
     C                   ENDIF
      *
      ** Validate screen and update if valid
     C     ACTN          IFEQ      'A'
     C     ACTN          OREQ      'I'
     C                   EXSR      #LVALD
     C                   ENDIF
      *
      ** Update details if valid
     C     ULVALD        IFEQ      'Y'
     C                   EXSR      #LUPDT
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      * SR/#LRSET   Reset Values                                      *
      *                                                               *
      * Called by:  #LMAIN                                            *
      *                                                               *
      * Calls:      None                                              *
      *                                                               *
      *****************************************************************
     C     #LRSET        BEGSR
      *
      ** Reset work fields and  indicators
     C                   MOVE      *OFF          *IN50                          Error in Validation
     C                   MOVE      *OFF          *IN47
     C                   MOVE      *OFF          *IN48
     C                   MOVE      *OFF          *IN49
     C                   MOVE      'N'           ULVALD
     C                   Z-ADD     0             ULFMAT            5 0
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SR/#LVALD - Validate Screen Field                             *
      *                                                               *
      * Called by:  #LMAIN                                            *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     #LVALD        BEGSR
      *
      ** Validate Guarantee Code
     C     L#GTEE        IFNE      *BLANK                                       B001
     C*****L#GTEE        CHAIN     BYGTEEPP                           86                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYGTEE                                                                        MD058068
     C+ from BYGTEJW0                                                                       MD058068
     C+ where LGTEE  = :L#GTEE                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN86         IFEQ      *ON                                          B002        MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   MOVEL     'BYM0203'     ZAMSID
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN48
     C                   EXSR      #LSNMG
     C                   ENDIF                                                  E002
     C                   ENDIF                                                  E001
      *
      ** Validate Qualifying Flag
     C     L#QUAL        IFNE      ' '                                          B001
     C     L#QUAL        ANDNE     '0'
     C     L#QUAL        ANDNE     '1'
     C     L#QUAL        ANDNE     '2'
     C     L#QUAL        ANDNE     '3'
     C                   MOVEL     'BYM0204'     ZAMSID
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN47
     C                   EXSR      #LSNMG
     C                   ENDIF                                                  E001
      *
      ** Check Final Maturity Date
     C     L#FMAT        IFNE      *BLANK                                       B001
     C                   MOVE(P)   L#FMAT        ZDATE
     C                   EXSR      ZDATE1
     C                   MOVE(P)   ZDAYNO        ULFMAT
      *
      ** Date not valid DDMMYY format
     C     *IN99         IFEQ      '1'                                          B002
     C                   MOVEL     'BYM0208'     ZAMSID
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN49
     C                   EXSR      #LSNMG
     C                   ELSE                                                   X002
      ** Final Maturity Date must be on or after the maturity date
      ** of the deal
     C     ULFMAT        IFLT      ULMDTE                                       B003
     C                   MOVEL     'BYM0209'     ZAMSID
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN49
     C                   EXSR      #LSNMG
     C                   ENDIF                                                  E003
      *
     C                   ENDIF                                                  E002
      *
     C                   ENDIF                                                  E001
      *
      ** Set valid flag if no error in validation
     C     *IN50         IFEQ      *OFF
     C                   MOVE      'Y'           ULVALD
     C                   ENDIF
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      * SR/#LUPDT - Update Extension File FCLTYX9                     *
      *                                                               *
      * Called by:  #LMAIN - Amend & Insert mode                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     #LUPDT        BEGSR
      *
      ** Check if record exists or not
     C     KEY1          CHAIN     BYNASPY0                           89
      *
      ** Move values into extension file fields
     C                   MOVE      ULDEAL        LDLNO
     C                   MOVE      L#GTEE        LGTEE
     C                   MOVE      L#QUAL        LQUAL
     C                   MOVE      ULFMAT        LFMAT
     C     LFMAT         IFEQ      0
     C                   MOVE      *BLANKS       LFMAT
     C                   ENDIF
     C     LQUAL         IFEQ      *BLANK
     C                   MOVE      '0'           LQUAL
     C                   ENDIF
     C     LGTEE         IFEQ      *BLANK
     C                   MOVE      '00'          LGTEE
     C                   ENDIF
      *
      * Update/Write into extension file
     C     *IN89         IFEQ      *OFF
     C                   UPDATE    BYNASPD0
     C                   ELSE
     C                   WRITE     BYNASPD0
     C                   ENDIF
      *
     C                   ENDSR
      **************************************************************************
      * #LSNMG - Send Message to Program Message Queue                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      **************************************************************************
      *
     C     #LSNMG        BEGSR
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      ##PGM         ZAPGMQ           10            ProgramQueue
     C                   PARM      '*SAME'       ZAPGRL            5            Rel. Queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM      ULMSGF        ZAMSGF           10            Message File
     C                   PARM                    ZAMSDA          132            Message Data
     C                   PARM                    ZAMSTP            7            Message Type
      *
     C                   ENDSR
      **************************************************************************
      * #LCLMG - Clear Program Message Queue                          *
      *                                                               *
      * Called by: #LMAIN                                             *
      *                                                               *
      * Calls:  CL program Y2CLMSC                                    *
      **************************************************************************
     C     #LCLMG        BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ##PGM                          ProgramQueue
     C                   PARM      '*SAME'       ZAPGRL                         Rel. Queue
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SR/#LDLT  - Delete Extension File record                      *
      *                                                               *
      * Called by:  #LMAIN - Delete mode only                         *
      *                                                               *
      * Calls: #LTERM                                                 *
      *                                                               *
      *****************************************************************
     C     #LDLT         BEGSR
      *
     C     KEY1          CHAIN     BYNASPY0                           88
      *
      * Delete extension file record if one exists and exit program
     C     *IN88         IFEQ      *OFF
     C                   DELETE    BYNASPD0
     C                   ENDIF
      *
      * Terminate program
     C                   EXSR      #LTERM
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SR/#LEXIT - Cmd/3 Processing                                  *
      *                                                               *
      * Called by:  #LMAIN                                            *
      *                                                               *
      * Calls:  #LTERM                                                *
      *                                                               *
      *****************************************************************
     C     #LEXIT        BEGSR
      *
      ** Set Cmd/3 return code and end program
     C                   MOVE      'Y2U9999'     W0RTN
     C                   EXSR      #LTERM
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SR/#LPREV - Cmd/12 Processing                                 *
      *                                                               *
      * Called by:  #LMAIN                                            *
      *                                                               *
      * Calls:  #LTERM                                                *
      *                                                               *
      *****************************************************************
     C     #LPREV        BEGSR
      *
      ** Set Cmd/12 return code and end program
     C                   MOVE      'USR0790'     W0RTN
     C                   EXSR      #LTERM
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SR/#LDEFN - Define Fields                                     *
      *                                                               *
      * Called by:  None                                              *
      *                                                               *
      * Calls:      None                                              *
      *                                                               *
      *****************************************************************
     C     #LDEFN        BEGSR
      *
      ** Define the LDA for error handling
     C     *DTAARA       DEFINE                  LDA
      *
      ** Copyright
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialise Validation Flag
     C                   MOVE      'N'           ULVALD            1
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  -   Error handling subroutine                         *
      *                                                               *
      *  Called by: Automatically when error occurs                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
     C     ULERRF        IFNE      'Y'
     C                   MOVE      'Y'           ULERRF            1
     C                   DUMP
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SR/#LTERM   Program Termination                               *
      *                                                               *
      * Called by:  Main Processing, #LMAIN, #LEXIT, #LPREV           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     #LTERM        BEGSR
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SR/*INZSR - Initialisation                                    *
      *                                                               *
      * Called by:  Automatically at invocation                       *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Only process action code I,A,E or D
     C     ACTN          IFNE      'I'
     C     ACTN          ANDNE     'A'
     C     ACTN          ANDNE     'E'
     C     ACTN          ANDNE     'D'
     C                   EXSR      #LTERM
     C                   ENDIF
      *
      ** Calling AOSARDR0 to check if the switchable feature is on
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ULRTCD            7
     C                   PARM      '*VERIFY'     ULOPTN            7
     C                   PARM      '      '      ULSARD            6
     C                   PARM      *BLANKS       DSFDY
      *
      ** return code if blanks, terminate the program
     C     ULRTCD        IFNE      *BLANKS
     C                   EXSR      #LTERM
     C                   ENDIF
      *
      ** Calling AOBANKR0 for Date Format Indicator
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     ULRTCD            7
     C                   PARM      '*FIRST '     ULOPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     ULRTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      '*READ'       DBKEY                          *************
     C                   MOVEL     '081'         DBASE                          * DBERR 081 *
     C                   MOVE      'SDBANKPD'    DBFILE                         *************
     C                   MOVE      'BYNASPW0'    DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Check system date format, DDMMYY or MMDDYY.
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      '0'           *IN98                          DDMMYY
     C                   ELSE
     C                   MOVE      '1'           *IN98                          MMDDYY
     C                   ENDIF
      *
     C                   MOVE      ULDLNO        ULDEAL            6 0
     C     KEY1          KLIST
     C                   KFLD                    ULDEAL
      *
      ** Define window position
     C                   Z-ADD     SROW          SWROW
     C                   Z-ADD     SCOL          SWCOL
      *
      ** Protect input fields if enquiry mode
     C     ACTN          IFEQ      'E'
     C                   MOVE      *ON           *IN20
     C                   ENDIF
      *
      ** Get extension file details for initial display
     C     KEY1          CHAIN     BYNASPY0                           87
      *
      ** Convert Maturity Date to Midas number
     C                   MOVE(P)   ULMDAT        ZDATE
     C                   EXSR      ZDATE1
     C                   MOVE(P)   ZDAYNO        ULMDTE            5 0
      *
      ** Initialise blank screen if record not found
     C     ACTN          IFEQ      'I'
     C     *IN87         OREQ      *ON
     C                   MOVE      *BLANKS       LFMAT
     C                   MOVE      *BLANKS       L#GTEE
     C                   MOVE      *BLANK        L#QUAL
      *
      ** Amend or Enquire - Format field details for display
     C                   ELSE
     C     LFMAT         IFNE      *ZERO
     C                   Z-ADD     LFMAT         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         L#FMAT
     C                   ELSE
     C                   MOVE      *BLANKS       L#FMAT
     C                   ENDIF
     C                   MOVE      LGTEE         L#GTEE
     C                   MOVE      LQUAL         L#QUAL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *COPY*ZSRSRC,ZDATE1Z2                                                                 MD058068
      /COPY ZSRSRC,ZDATE1Z2LE                                                               MD058068
      *COPY*ZSRSRC,ZDATE2Z2                                                                 MD058068
      /COPY ZSRSRC,ZDATE2Z2LE                                                               MD058068
** CPY@
(c) Finastra International Limited 2000
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
