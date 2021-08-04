     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB Display COB components')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Module                             *
      *                                                               *
      *  CB0400E - COB Components Enquiry                             *
      *                                                               *
      *  Function:  This program allows users to enquire on the       *
      *             COB conditions file.                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055891           Date 01Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CCB008             Date 12Oct98               *
      *                 CCB003             Date 28NOV96               *
      *                 090416             Date 12JUL95               *
      *                 S01517             Date 01AUG94               *
      *                 S01491             Date 14JUN94               *
      *                 S01459             Date 14JUN94               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - File removed from CB model.                       *
      *  CCB003 - CoB Task Split Enhancement - 2 fields added:        *
      *           - Task Split Job Ind. &                             *
      *           - Number of Task Split Jobs                         *
      *  090416 - Recompiled over changed display file.               *
      *  S01517 - Addition of 'Allow Component Bypass' field.         *
      *  S01491 - Autocall Project:                                   *
      *           - Amend to allow the display of the new run         *
      *             time fields.                                      *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *                                                               *
      *****************************************************************
     FCB0400E#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas CB COB components enquiry
      *
     F*CBCMPNL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(INFDS1)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Midas CB Components retrieval
      *
     F*CBRUNCL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0001)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : COB Run Conditions
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
      *
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
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D COBP            DS
     D  WUFMT                  1    200
     D  WUCBBF               111    111
     D ID0001          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * FLD: Components
      * I : MAP Component Name
     D  P1COTT                 1     10
      * I : MAP Component Sequence Number
     D  P1CSEQ                11     15
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     D CBRUNC        E DS                  EXTNAME(CBRUNJW0)                                MD055891
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1COTT        PARM                    WP0001           10            Component Name
     C     P1CSEQ        PARM                    WP0002            5            Component Seque
      *****************************************************************
      * Initialize
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
     C     #1COTT        IFEQ      *BLANK                                       Component Name
     C     #1CSEQ        OREQ      *BLANK                                       Component Seque
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
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Setup key
     C                   MOVEL     #1COTT        DHCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DHCSEQ                         Component Seque
     C*****KRTV          CHAIN     @DHREGH                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :#1COTT and DHCSEQ = :#1CSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Endif                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   Seton                                        91                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        993132    *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, then signal error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        993132    *
      * Send message 'Components             NF'
     C                   MOVEL     'USR0497'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EXSR      MBFL#1
      * USER: Load detail screen from DBF record
      * Move input to screen 2 - Components  *
     C                   MOVE      DHCPRM        #DAJNA
     C                   MOVEL     DHCPRM        #DAKNA
      * Start of change S01491.
      * Initialise run time screen fields.
      * Setup end of day run time.
      * CASE: DB1.End of Day Run Time is Zeroes
     C     DHEODT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DEDRA                         End of Day Run
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     DHEODT        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0001            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0002           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0003            1 0          ZALIGN No of De
     C                   PARM      6             WQ0004            2 0          ZALIGN No of Di
     C     WUZAFF        PARM      *BLANK        WQ0005           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0006           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0007            1 0          ZALIGN No of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * ZALIGN EOD Run Time Fld - Components  *
     C                   MOVE      WUZASF        #DEDRA
     C                   END                                                    *FI
      * Setup beginning of month run time.
      * CASE: DB1.Begin of Month Run Time is Zeroes
     C     DHBOMT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DBOMA                         Beg of Mth Run
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     DHBOMT        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0008            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0009           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0010            1 0          ZALIGN No of De
     C                   PARM      6             WQ0011            2 0          ZALIGN No of Di
     C     WUZAFF        PARM      *BLANK        WQ0012           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0013           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0014            1 0          ZALIGN No of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * ZALIGN BOM Run Time Fld - Components  *
     C                   MOVE      WUZASF        #DBOMA
     C                   END                                                    *FI
      * Setup end of month run time.
      * CASE: DB1.End of Month Run Time is Zeroes
     C     DHEOMT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DEOMA                         End of Mth Run
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     DHEOMT        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0015            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0016           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0017            1 0          ZALIGN No of De
     C                   PARM      6             WQ0018            2 0          ZALIGN No of Di
     C     WUZAFF        PARM      *BLANK        WQ0019           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0020           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0021            1 0          ZALIGN No of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * ZALIGN EOM Run Time Fld - Components  *
     C                   MOVE      WUZASF        #DEOMA
     C                   END                                                    *FI
      * Setup end of year run time.
      * CASE: DB1.End of Year Run Time is Zeroes
     C     DHEOYT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DEOYA                         End of Yr Run T
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     DHEOYT        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0022            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0023           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0024            1 0          ZALIGN No of De
     C                   PARM      6             WQ0025            2 0          ZALIGN No of Di
     C     WUZAFF        PARM      *BLANK        WQ0026           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0027           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0028            1 0          ZALIGN No of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * ZALIGN EOY Run Time Fld - Components  *
     C                   MOVE      WUZASF        #DEOYA
     C                   END                                                    *FI
      * Setup run condition text.
      * Retrieve COB Run Condns - COB Run Conditions  *
     C                   EXSR      SARVGN
      * End of change S01491.
      * Start CCB003
      * Set Display Indicator for 'Number of Task Split Jobs'
      * CASE:
      *  - c1 OR c2
      *   |- c1    : DB1.Task Split Job Indicator is No
      *   |- c2    : DB1.Task Split Job Indicator is Blank
      *   '-
     C     DHTASK        IFEQ      'N'                                          *IF
     C     DHTASK        OREQ      *BLANK                                       *OR
     C                   MOVEL     'N'           WUDNSJ                         Display No. tas
     C                   END                                                    *FI
      * End CCB003
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
      * Select existing record
     C                   EXSR      VACKRL
      * Component Name required
     C     #1COTT        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Component Sequence Number required
     C     #1CSEQ        IFEQ      *BLANK                                       IF
     C                   SETON                                        9932      *
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
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * USER: Process command keys
      * Quit if error signalled
     C   99              GOTO      EBEXIT
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters
      *================================================================
      * Is full key present?
     C     P1COTT        IFEQ      *BLANK                                       Component Name
     C     P1CSEQ        OREQ      *BLANK                                       Component Seque
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
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
      * Protect key fields on detail screen
     C                   SETON                                        88        *
     C                   MOVEL     '0'           *IN79
     C     WUVANT        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     WUACBP        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN77
     C     WUDNSJ        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
     C     W0RPT         IFEQ      'N'
      * Disable key screen - not applicable
     C                   SETOFF                                       87        *
     C                   ELSE
      * Enable key screen
     C                   SETON                                        87        *
     C                   END
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   MOVEL     *BLANK        #1CSTS                         Component Statu
     C                   MOVEL     *BLANK        #1CPRM                         Execution Param
     C                   MOVEL     *BLANK        #1CRQD                         Sel for Today's
     C                   MOVEL     *BLANK        #1CRES                         Restart Flag
     C                   Z-ADD     *ZERO         #1CODP                         No.Outstndng De
     C                   Z-ADD     *ZERO         #1CSDE                         Start Date
     C                   Z-ADD     *ZERO         #1CSTI                         Start Time
     C                   Z-ADD     *ZERO         #1CEDE                         End Date
     C                   Z-ADD     *ZERO         #1CETI                         End Time
     C                   MOVEL     *BLANK        #1CHTB                         Halt Before
     C                   MOVEL     *BLANK        #1CHTA                         Halt After
     C                   MOVEL     *BLANK        #1CFAL                         Component Faile
     C                   Z-ADD     *ZERO         #1EODT                         End of Day Run
     C                   Z-ADD     *ZERO         #1EOMT                         End of Month Ru
     C                   Z-ADD     *ZERO         #1BOMT                         Begin of Month
     C                   Z-ADD     *ZERO         #1EOYT                         End of Year Run
     C                   Z-ADD     *ZERO         #1EODC                         End of Day CPU
     C                   Z-ADD     *ZERO         #1EOMC                         End of Month CP
     C                   Z-ADD     *ZERO         #1BOMC                         Begin of Month
     C                   Z-ADD     *ZERO         #1EOYC                         End of Year CPU
     C                   MOVEL     *BLANK        #1CBSN                         COB Stream Name
     C                   Z-ADD     *ZERO         #1CSHP                         Scheduling Prio
     C                   MOVEL     *BLANK        #DEDRA                         End of Day Run
     C                   Z-ADD     *ZERO         #1CEPY                         Execution Prior
     C                   MOVEL     *BLANK        #DBOMA                         Beg of Mth Run
     C                   Z-ADD     *ZERO         #1CTSL                         Timeslice
     C                   MOVEL     *BLANK        #DEOMA                         End of Mth Run
     C                   MOVEL     *BLANK        #1CFOB                         FCOOB Error Acc
     C                   MOVEL     *BLANK        #DEOYA                         End of Yr Run T
     C                   MOVEL     *BLANK        #1CMOD                         Module
     C                   MOVEL     *BLANK        #1CEMI                         Complex Module
     C                   MOVEL     *BLANK        #1ABIC                         Allow Bypass in
     C                   MOVEL     *BLANK        #1CMEF                         Mut.Exclusive C
     C                   MOVEL     *BLANK        #1TASK                         Task Split Job
     C                   MOVEL     *BLANK        #1CFRQ                         Run Conditions
     C                   Z-ADD     *ZERO         #1TSNO                         Number of Task
     C                   MOVEL     *BLANK        #DRUNS                         Run Condition T
     C                   MOVEL     *BLANK        #DAKNA                         Execution param
     C                   MOVEL     *BLANK        #DAJNA                         Execution param
     C                   MOVEL     *BLANK        #1CTXT                         Component Text
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @DHREGH fields to screen
      *================================================================
     C                   MOVEL     DHCSTS        #1CSTS                         Component Statu
     C                   MOVEL     DHCPRM        #1CPRM                         Execution Param
     C                   MOVEL     DHCRQD        #1CRQD                         Sel for Today's
     C                   MOVEL     DHCRES        #1CRES                         Restart Flag
     C                   Z-ADD     DHCODP        #1CODP                         No.Outstndng De
     C                   Z-ADD     DHCSDE        #1CSDE                         Start Date
     C                   Z-ADD     DHCSTI        #1CSTI                         Start Time
     C                   Z-ADD     DHCEDE        #1CEDE                         End Date
     C                   Z-ADD     DHCETI        #1CETI                         End Time
     C                   MOVEL     DHCHTB        #1CHTB                         Halt Before
     C                   MOVEL     DHCHTA        #1CHTA                         Halt After
     C                   MOVEL     DHCFAL        #1CFAL                         Component Faile
     C                   Z-ADD     DHEODT        #1EODT                         End of Day Run
     C                   Z-ADD     DHEOMT        #1EOMT                         End of Month Ru
     C                   Z-ADD     DHBOMT        #1BOMT                         Begin of Month
     C                   Z-ADD     DHEOYT        #1EOYT                         End of Year Run
     C                   Z-ADD     DHEODC        #1EODC                         End of Day CPU
     C                   Z-ADD     DHEOMC        #1EOMC                         End of Month CP
     C                   Z-ADD     DHBOMC        #1BOMC                         Begin of Month
     C                   Z-ADD     DHEOYC        #1EOYC                         End of Year CPU
     C                   MOVEL     DHCBSN        #1CBSN                         COB Stream Name
     C                   MOVEL     DHCOTT        #1COTT                         Component Name
     C                   MOVEL     DHCSEQ        #1CSEQ                         Component Seque
     C                   Z-ADD     DHCSHP        #1CSHP                         Scheduling Prio
     C                   Z-ADD     DHCEPY        #1CEPY                         Execution Prior
     C                   Z-ADD     DHCTSL        #1CTSL                         Timeslice
     C                   MOVEL     DHCFOB        #1CFOB                         FCOOB Error Acc
     C                   MOVEL     DHCMOD        #1CMOD                         Module
     C                   MOVEL     DHCEMI        #1CEMI                         Complex Module
     C                   MOVEL     DHABIC        #1ABIC                         Allow Bypass in
     C                   MOVEL     DHCMEF        #1CMEF                         Mut.Exclusive C
     C                   MOVEL     DHTASK        #1TASK                         Task Split Job
     C                   MOVEL     DHCFRQ        #1CFRQ                         Run Conditions
     C                   Z-ADD     DHTSNO        #1TSNO                         Number of Task
     C                   MOVEL     DHCTXT        #1CTXT                         Component Text
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1COTT        #1COTT                         Component Name
     C                   MOVEL     P1CSEQ        #1CSEQ                         Component Seque
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Retrieve COB Run Condns - COB Run Conditions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    ANRUNC                         COB Run Conditi
      * Move fields to key list
     C                   MOVEL     DHCFRQ        ANRUNC                         COB Run Conditi
     C*****KRSSA         CHAIN     @RUNCL1                            90        *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBRUNC                                                                        MD055891
     C+ from CBRUNJW0                                                                       MD055891
     C+ where ANRUNC = :ANRUNC                                                              MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C******IN90         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE = 100                                            MD055891
      * Data record not found
     C                   MOVEL     'CBM0075'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     ANRUNT        #DRUNS                         COB Run Conditi
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record
      *================================================================
      * Name search required?
     C                   MOVEL     #1COTT        WK1X01            1
     C                   MOVEL     #1CSEQ        WK1X02            1
     C     WK1X01        IFEQ      '?'                                          Component Name
     C     WK1X02        OREQ      '?'                                          Component Seque
     C                   CALL      'CB0404S'                            90      Select Componen
     C                   PARM      *BLANK        W0RTN             7
     C     #1COTT        PARM      #1COTT        WQ0029           10            Component Name
     C     #1CSEQ        PARM      #1CSEQ        WQ0030            5            Component Seque
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CB0404S'     W0CLPG
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
     C     *DTAARA       DEFINE    CBMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field ZALIGN Screen Fun Field
     C                   MOVEL     *BLANK        WUZASF           16
      * Define work field ZALIGN File Field
     C                   MOVEL     *BLANK        WUZAFF           16
      * Define work field Err Code
     C                   MOVEL     *BLANK        WUERCD            1
      * Define work field Display No. task Split Jb
     C                   MOVEL     *BLANK        WUDNSJ            1
      * Define work field S01491
     C                   MOVEL     *BLANK        WUVANT            1
      * Define work field S01517
     C                   MOVEL     *BLANK        WUACBP            1
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WUAANA            7
      * Define work field run day number
     C                   Z-ADD     *ZERO         WUAKTX            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUAUST            1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUE3ST            1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUF1ST            1
      * Define work field Switchable Feature Number
     C                   MOVEL     *BLANK        WUSARN            6
      * Define work field Access Obj Return Code
     C                   MOVEL     *BLANK        WURTCD            7
      * Define work field Access Obj Rec Fmt (200)
     C                   MOVEL     *BLANK        WUFMT           200
      * Define work field COB Bypass Flag
     C                   MOVEL     *BLANK        WUCBBF            1
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
     C                   OPEN      CB0400E#
     C**********         OPEN      CBCMPNL1                                                 MD055891
     C**********         OPEN      CBRUNCL1                                                 MD055891
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of change S01459.
      * CB0400E Precompiler - Components  *
      * End of change S01459.
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##AANA            7
     C                   MOVE      MRDT          WUAANA
     C                   MOVE      RDNB          WUAKTX
     C                   MOVE      SUC           WUAUST
     C                   MOVE      DFF           WUE3ST
     C                   MOVE      MBIN          WUF1ST
      * Copyright Statement 1988 - Standard functions  *
      * Start of change S01491.
      * Setup comp rcd dtl footer - Components  *
     C*
     C*  Detail line command key text
     C*
     C*  If Action Code is Delete :
     C*
     C                   MOVEL     'CBUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C     'E'           IFEQ      'D'
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'CBM0193'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Insert :
     C*
     C     'E'           IFEQ      'I'
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'CBM0194'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Amend :
     C*
     C     'E'           IFEQ      'A'
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'CBM0195'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Enquire :
     C*
     C     'E'           IFEQ      'E'
     C* Setup footer text:
     C* F3=Exit   F5=Refresh Screen
     C                   MOVEL     'CBM0200'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C* Setup footer text:
     C* F3=Exit   F5=Refresh Screen
     C                   MOVEL     'CBM0200'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
      * Check if Autocall is present.
     C                   MOVEL     'S01491'      WUSARN                         Switchable Feat
      * Check for Switchable Feat - Standard functions  *
     C                   CALL      'AOSARDR0'                           90      Check for Switc
     C     WURTCD        PARM      *BLANK        WQ0031            7            Access Obj Retu
     C                   PARM      '*VERIFY'     WQ0032            7            Access Obj Acce
     C                   PARM      WUSARN        WQ0033            6            Switchable Feat
     C     WUFMT         PARM      *BLANK        WQ0034          200            Access Obj Rec
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'AOSARDR0'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Check return code.
      * CASE: WRK.Access Obj Return Code is Normal - no errors found
     C     WURTCD        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'Y'           WUVANT                         S01491
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUVANT                         S01491
     C                   END                                                    *FI
      * End of change S01491.
      * Start of change S01517.
      * Check to see if COB bypass is allowed.
      * SDCOBPPD Data Structure - Standard functions  *
      * SC ICD Access Object - Standard functions  *
     C                   CALL      'AOCOBPR0'                           90      SC ICD Access O
     C     WURTCD        PARM      *BLANK        WQ0035            7            Access Obj Retu
     C                   PARM      '*FIRST'      WQ0036            7            Access Obj Acce
     C     WUFMT         PARM      *BLANK        WQ0037          200            Access Obj Rec
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'AOCOBPR0'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   MOVEL     WUCBBF        WUACBP                         S01517
      * End of change S01517.
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
     C/COPY WNCPYSRC,CB0400EPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0400EPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD055891
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055891
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0400EPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001
