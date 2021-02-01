     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056890
/*STD *  RPGSQLBND                                                    *                     MD056890
/*EXI *  TEXT('Midas SD Edit mandatory window')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0441R - Mandatory Window Maintenance                       *
      *                                                               *
      *  Function:  This program maintains the window programs        *
      *             records.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056890           Date 11Oct20               *
      *  Prev Amend No. MD055681           Date 31Jul20               *
      *               . MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CPK018             Date 19Mar05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CLE004             Date 13JAN98               *
      *                 CSD003             Date 06JAN98               *
      *                 S01516             DATE 25AUG94               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056890 - Deliverable Data Split for SDMREFPD               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPK018 - Change to make windows switchable. Replace use of   *
      *           - Replace use of SDMREFL1 with SDMREFJ0.            *
      *  CLE004 - Lending Enhancements - Syndications                 *
      *           Add field                                           *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  S01516 - New maintenance program.                            *
      *                                                               *
      *****************************************************************
     F*Edit mandatory Window    Initialise Program F-spec
     F/COPY WNCPYSRC,SD0441RFPG
     FSD0441R#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Edit mandatory window
      *
     F*SDMREFL1IF*E*******    K        DISK                           UC                      CPK018
     F*SDMREFJ0* IF   E           K DISK    USROPN                                          MD056890
     F**********                           INFDS(INFDS1)                                    MD056890
     F**********                           INFSR(*PSSR)                                     MD056890
      * RTV : Midas SD Mandatory window ref file retrieval
      *
     F*SDMREFL0* UF A E           K DISK    USROPN                                          MD056890
     F**********                           COMMIT                                           MD056890
     F**********                           INFDS(ID0001)                                    MD056890
     F**********                           INFSR(*PSSR)                                     MD056890
      * UPD : Midas SD Mandatory window ref. file update
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*Edit mandatory Window    Initialise Program E-spec
     D/COPY WNCPYSRC,SD0441REPG
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*Edit mandatory Window    Initialise Program I-spec
     D/COPY WNCPYSRC,SD0441RIPG
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
     D*@1DBRC***     E DS                  EXTNAME(SDMREFL0)                                MD056890
     D @1DBRC        E DS                  EXTNAME(SDMRFJW0)                                MD056890
     D                                     PREFIX(@)                                        MD056890
     D SDMREF        E DS                  EXTNAME(SDMRFJW0)                                MD056890
     D SDMREFJ       E DS                  EXTNAME(SDMRFJW1)                                MD056890
     D                                     PREFIX(J)                                        MD056890
     D NullInds        s              5i 0 dim(17)                                          MD056890
      * UPD : Midas SD Mandatory window ref. file update
      * Current/previous master file format fields for change control
      *
     D*#1DBRC*****DS                             96                       CLE004
     D #1DBRC          DS           100                                         CLE004
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D*YARDCS*****DS                             96                       CLE004
     D YARDCS          DS           100                                         CLE004
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
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
     D P1PARM          DS            12
      * KEY: Midas SD Mandatory window ref file retrieval
      * I : MAP Name Of Calling Program
     D  P1NMCP                 1     10
      * I : MAP Sequence Number
     D  P1SQNB                11     12
     D P2PARM          DS
      * I :  Action Code
     D  P2ANCD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'IBM'
      * Message data for 'IBM'
      * Message data for 'Non IBM'
      * Message data for 'Question Mark Invalid'
      * Key Field
     D  ZA0001                 1     10
      * Message data for 'Sequence Number Not Numer'
      * Sequence Number
     D  ZA0002                 1      2
      * Message data for 'Pgm name & Seq exists'
      * Name Of Calling Program
     D  ZA0003                 1     10
      * Sequence Number
     D  ZA0004                11     12
      * Message data for 'Program text is required'
      * Program Text
     D  ZA0005                 1     50
      * Message data for 'Window Ctler is required.'
      * Window Controller Name
     D  ZA0006                 1     10
      * Message data for 'Window Title is invalid'
      * Title of Window
     D  ZA0007                 1      7
      * Message data for 'Window Title is required.'
      * Title of Window
     D  ZA0008                 1      7
      * Message data for 'Window length is required'
      * Window Length SCR
     D  ZA0009                 1      3
      * Message data for 'Window length numeric'
      * Window Length SCR
     D  ZA0010                 1      3
      * Message data for 'Length invalid'
      * Window Length SCR
     D  ZA0011                 1      3
      * Message data for 'Window width is required'
      * Window Width SCR
     D  ZA0012                 1      3
      * Message data for 'Window width must be Nbr'
      * Window Width SCR
     D  ZA0013                 1      3
      * Message data for 'width of window invalid'
      * Window Width SCR
     D  ZA0014                 1      3
      * Message data for 'Starting Row is required'
      * Starting line SCR
     D  ZA0015                 1      3
      * Message data for 'Staring line must be Nbr'
      * Starting line SCR
     D  ZA0016                 1      3
      * Message data for 'Starting Row Invalid'
      * Starting line SCR
     D  ZA0017                 1      3
      * Message data for 'Starting column is reqd'
      * Starting Column SCR
     D  ZA0018                 1      3
      * Message data for 'Starting Column must Nbr'
      * Starting Column SCR
     D  ZA0019                 1      3
      * Message data for 'Starting Column Invalid'
      * Starting Column SCR
     D  ZA0020                 1      3
      * Message data for 'Window length is required'
      * Window Length SCR
     D  ZA0021                 1      3
      * Message data for 'Window length numeric'
      * Window Length SCR
     D  ZA0022                 1      3
      * Message data for 'Invalid window length'
      * Window Length SCR
     D  ZA0023                 1      3
      * Message data for 'Window width is required'
      * Window Width SCR
     D  ZA0024                 1      3
      * Message data for 'Window width must be Nbr'
      * Window Width SCR
     D  ZA0025                 1      3
      * Message data for 'Window too narrow for del'
      * Window Width SCR
     D  ZA0026                 1      3
      * Message data for 'Window width range invald'
      * Window Width SCR
     D  ZA0027                 1      3
      * Message data for 'Starting Row is required'
      * Starting line SCR
     D  ZA0028                 1      3
      * Message data for 'Staring line must be Nbr'
      * Starting line SCR
     D  ZA0029                 1      3
      * Message data for 'Starting Row Invalid'
      * Starting line SCR
     D  ZA0030                 1      3
      * Message data for 'Starting column is reqd'
      * Starting Column SCR
     D  ZA0031                 1      3
      * Message data for 'Starting Column must Nbr'
      * Starting Column SCR
     D  ZA0032                 1      3
      * Message data for 'Invalid starting column'
      * Starting Column SCR
     D  ZA0033                 1      3
      * Message data for 'Window Not allowed'
      * Starting line SCR
     D  ZA0034                 1      3
      * Starting Column SCR
     D  ZA0035                 4      6
      * Message data for 'Too many lines for screen'
      * Window Length SCR
     D  ZA0036                 1      3
      * Starting line SCR
     D  ZA0037                 4      6
      * Message data for 'Window too Wide for Scree'
      * Window Width SCR
     D  ZA0038                 1      3
      * Starting Column SCR
     D  ZA0039                 4      6
      * Message data for 'Window Not allowed'
      * Starting line SCR
     D  ZA0040                 1      3
      * Starting Column SCR
     D  ZA0041                 4      6
      * Message data for 'Window will not fit'
      * Window Length SCR
     D  ZA0042                 1      3
      * Starting line SCR
     D  ZA0043                 4      6
      * Message data for 'Window is too wide'
      * Window Width SCR
     D  ZA0044                 1      3
      * Starting Column SCR
     D  ZA0045                 4      6
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         KEY: Mandatory
     C     P2ANCD        PARM                    WP0001            1            Action Code
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
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1NMCP        IFEQ      *BLANK                                       Name Of Calling
     C     #1SQNB        OREQ      *BLANK                                       Sequence Number
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
      * Switch between *ADD/*CHANGE modes
     C   09              CAS                     BCCHMD
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
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
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
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   BCCHMD        BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'CHG'         W0PMD             3
     C                   ELSE
     C                   MOVEL     'ADD'         W0PMD
     C                   END
      *================================================================
     CSR   BCEXIT        ENDSR
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
     C                   KFLD                    DLNMCP                         Name Of Calling
     C                   KFLD                    DLSQNB                         Sequence Number
      * Setup key
     C                   MOVEL     #1NMCP        DLNMCP                         Name Of Calling
     C                   MOVEL     #1SQNB        DLSQNB                         Sequence Number
     C********** KRTV      CHAIN@DLREGT              9091  *                                  CPK018
     C*****KRTV          CHAIN     @MREFJ0                            9091      *           MD056890
     C/EXEC SQL                                                                             MD056890
     C+ SELECT *                                                                            MD056890
     C+ into :SDMREFJ :NullInds                                                             MD056890
     C+ from SDMRFJW1                                                                       MD056890
     C+ where DLNMCP = :DLNMCP and DLSQNB = :DLSQNB                                         MD056890
     C/END-EXEC                                                                             MD056890
     C                   setoff                                       9091                  MD056890
     C                   If        SQLCODE = 100                                            MD056890
     C                   seton                                        90                    MD056890
     C                   Endif                                                              MD056890
     C                   If        SQLCODE <> 0  and SQLCODE <> 100                         MD056890
     C                   seton                                        91                    MD056890
     C                   Endif                                                              MD056890
                                                                                            MD056890
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        993132    *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
     C                   eval      SDMREF = SDMREFJ                                         MD056890
      * If record does not exist, flip to add mode
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ADD'         W0PMD
      * USER: Initialize detail screen (new record)
      * Set up DTL screen footer - Mandatory Window Ref File  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
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
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
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
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
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
      * Setup message data for message
      * Retrieve message IBM
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2605'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DIBMS        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     'I'           #1WINT                         Window Type
      * 00/Copy member SD0441RISN - Mandatory Window Ref File  *
     C*Edit mandatory Window    Initialise Dtl New Rcd
     C/COPY WNCPYSRC,SD0441RISN
     C                   ELSE
      * If record does exist, flip to change mode
     C                   MOVEL     'CHG'         W0PMD
      * Load screen fields from DBF
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * 00/Copy member SD0441RSFF - Mandatory Window Ref File  *
     C*Edit mandatory Window    Calc Detail Function Flds
     C/COPY WNCPYSRC,SD0441RSFF
      * USER: Initialize detail screen (existing record)
      * Set up DTL screen footer - Mandatory Window Ref File  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
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
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
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
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
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
      * CASE: DB1.Window Type is IBM Window
     C     DLWINT        IFEQ      'I'                                          *IF
      * Setup message data for message
      * Retrieve message IBM
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2605'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DIBMS        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
      * Retrieve message Non IBM
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2606'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DIBMS        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     DLLGWD        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0001            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0002           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0003            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0004            2 0          ZALIGN No Of Di
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0006           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0007            1 0          ZALIGN No Of De
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
      * Zalign Window length - Mandatory Window Ref File  *
     C*
     C                   MOVE      WUZASF        #DWLSC
     C*
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     DLWDWD        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0008            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0009           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0010            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0011            2 0          ZALIGN No Of Di
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0013           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0014            1 0          ZALIGN No Of De
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
      * Zalign Window Width - Mandatory Window Ref File  *
     C*
     C                   MOVE      WUZASF        #DWWSC
     C*
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     DLSRWD        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0015            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0016           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0017            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0018            2 0          ZALIGN No Of Di
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0020           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0021            1 0          ZALIGN No Of De
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
      * Zalign Starting Line - Mandatory Window Ref File  *
     C*
     C                   MOVE      WUZASF        #DSLSC
     C*
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     DLSCWD        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0022            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0023           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0024            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0025            2 0          ZALIGN No Of Di
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0027           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0028            1 0          ZALIGN No Of De
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
      * Zalign Starting Column - Mandatory Window Ref File  *
     C*
     C                   MOVE      WUZASF        #DSCSC
     C*
      * 00/Copy member SD0441RISE - Mandatory Window Ref File  *
     C*Edit mandatory Window    Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,SD0441RISE
     C                   END
      *..................................................
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
     C     W0PMD         IFNE      'ADD'
      * Select existing record
     C                   EXSR      VACKRL
     C                   END
      * USER: Validate key screen
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   MOVEL     #1NMCP        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1NMCP        ZA0001                         Name Of Calling
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      * Sequence number
      * CASE: KEY.Sequence Number is Entered
     C     #1SQNB        IFNE      *BLANK                                       *IF
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #1SQNB        WUZASF                         ZALIGN Screen F
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0031            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0032           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0033            1 0          ZALIGN No Of De
     C                   PARM      2             WQ0034            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0035           16            ZALIGN File Fie
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
      * Setup message data for message
     C                   MOVEL     #1SQNB        ZA0002                         Sequence Number
      * Send message 'Sequence Number Not Numer'
     C                   MOVEL     'USR0551'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Set field for ZALIGN - Mandatory Window Ref File  *
     C* MOVE TO THE ZALIGN FILE FIELD INTO THE RECORD SEQUENCE NUMBER
     C*********************MOVE #IDNCD    #OD4CD                          S01229
     C                   MOVE      WUZAFF        #1SQNB                                        S0122
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Does recored exist ? - Mandatory Window Ref File  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1NMCP        ZA0003                         Name Of Calling
     C                   MOVEL     #1SQNB        ZA0004                         Sequence Number
      * Send message 'Pgm name & Seq exists'
     C                   MOVEL     'USR2598'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        993132    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0441RVKS - Mandatory Window Ref File  *
     C*Edit mandatory Window    Validate Key Screen
     C/COPY WNCPYSRC,SD0441RVKS
      * Name Of Calling Program required
     C     #1NMCP        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Sequence Number required
     C     #1SQNB        IFEQ      *BLANK                                       IF
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
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y1SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
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
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
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
      * 00/Copy member SD0441RPKR - Mandatory Window Ref File  *
     C*Edit mandatory Window    Process Key Screen Rqst
     C/COPY WNCPYSRC,SD0441RPKR
      * F12 processing
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Set up KEY screen footer - Mandatory Window Ref File  *
     C*
     C* KEY LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'USR3345'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
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
     C*
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C   05              MOVEL     'R'           W0TRN
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
      * If delete is not pending....
      * Validate details
     C  N10              CAS                     DCVLDL
     C                   END
      * QUIT if error:
     C   99              GOTO      CFEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * No error: update record
     C                   EXSR      EBPR##
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
      * USER: Validate detail screen fields
      * Disable 'ENTER' in Delete mode.
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * Send message 'F3/F10/F12 only valid opt'
     C                   MOVEL     'USR0536'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
      * Program text
      * CASE: DTL.Program Text is Blank
     C     #1PGMT        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1PGMT        ZA0005                         Program Text
      * Send message 'Program text is required'
     C                   MOVEL     'USR2599'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      * Window Controller Name
      * CASE: DTL.Window Controller Name is Blank
     C     #1WNCN        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1WNCN        ZA0006                         Window Controll
      * Send message 'Window Ctler is required.'
     C                   MOVEL     'USR2574'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
      * CASE: DTL.Window Type is IBM Window
     C     #1WINT        IFEQ      'I'                                          *IF
      * Window Title
      * CASE: DTL.Title of Window is Entered
     C     #1TTWD        IFNE      *BLANK                                       *IF
      * Split the window title - Mandatory Window Ref File  *
     C*
     C                   MOVEL     #1TTWD        WUWKAF            3
     C                   MOVE      #1TTWD        WUWAFN            4
     C*
     C                   MOVEL     *BLANK        WUWRTC                         Work Return cod
     C                   MOVEL     'N'           WUERCD                         Err Code
      * Check for embedded or trailing blanks.
     C                   MOVEL     *BLANK        WUFTPR                         field text para
     C                   MOVEL     #1TTWD        WUFTPR                         field text para
      * Check for alphanumerics - Standard Functions  *
     C                   CALL      'SD0811'                             90      Check for alpha
     C                   PARM      WUFTPR        WQ0036          256            field text para
     C                   PARM      7             WQ0037            3 0          Field length
     C     WUWRTC        PARM      *BLANK        WQ0038            5            Work Return cod
     C                   PARM      'N'           WQ0039            1            Allow Embedded
     C                   PARM      'ANONLY'      WQ0040            6            String Validati
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0811'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * CASE: WRK.Work Return code is Invalid entry
     C     WUWRTC        IFEQ      'INVAL'                                      *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   END                                                    *FI
      * Check for characters only.
     C                   MOVEL     *BLANK        WUFTPR                         field text para
     C                   MOVEL     WUWKAF        WUFTPR                         field text para
      * Check for alphanumerics - Standard Functions  *
     C                   CALL      'SD0811'                             90      Check for alpha
     C                   PARM      WUFTPR        WQ0041          256            field text para
     C                   PARM      3             WQ0042            3 0          Field length
     C     WUWRTC        PARM      *BLANK        WQ0043            5            Work Return cod
     C                   PARM      'N'           WQ0044            1            Allow Embedded
     C                   PARM      'ALPHA'       WQ0045            6            String Validati
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0811'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * CASE: WRK.Work Return code is Invalid entry
     C     WUWRTC        IFEQ      'INVAL'                                      *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     WUWAFN        WUZASF                         ZALIGN Screen F
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0046            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0047           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0048            1 0          ZALIGN No Of De
     C                   PARM      4             WQ0049            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0050           16            ZALIGN File Fie
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
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1TTWD        ZA0007                         Title of Window
      * Send message 'Window Title is invalid'
     C                   MOVEL     'USR2575'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1TTWD        ZA0008                         Title of Window
      * Send message 'Window Title is required.'
     C                   MOVEL     'USR2576'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   END                                                    *FI
      * Window Length
      * CASE: DTL.Window Length SCR is Blank
     C     #DWLSC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DWLSC        ZA0009                         Window Length S
      * Send message 'Window length is required'
     C                   MOVEL     'USR2577'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DWLSC        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0051            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0052           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0053            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0054            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0055           16            ZALIGN File Fie
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0056           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0057            1 0          ZALIGN No Of De
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
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DWLSC        ZA0010                         Window Length S
      * Send message 'Window length numeric'
     C                   MOVEL     'USR2578'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1LGWD                         Length of Windo
      * Zalign Window length - Mandatory Window Ref File  *
     C*
     C                   MOVE      WUZASF        #DWLSC
     C*
      * Valid range
      * CASE: DTL.Length of Window is Valid Length
     C     #1LGWD        IFGE      6                                            *IF
     C     #1LGWD        ANDLE     18
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DWLSC        ZA0011                         Window Length S
      * Send message 'Length invalid'
     C                   MOVEL     'USR1735'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Window Width
      * CASE: DTL.Window Width SCR is Blank
     C     #DWWSC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DWWSC        ZA0012                         Window Width SC
      * Send message 'Window width is required'
     C                   MOVEL     'USR2579'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DWWSC        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0058            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0059           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0060            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0061            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0062           16            ZALIGN File Fie
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0063           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0064            1 0          ZALIGN No Of De
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
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DWWSC        ZA0013                         Window Width SC
      * Send message 'Window width must be Nbr'
     C                   MOVEL     'USR2580'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1WDWD                         Width of Window
      * Zalign Window Width - Mandatory Window Ref File  *
     C*
     C                   MOVE      WUZASF        #DWWSC
     C*
      * Valid width
      * CASE: DTL.Width of Window is Valid width
     C     #1WDWD        IFGE      24                                           *IF
     C     #1WDWD        ANDLE     74
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DWWSC        ZA0014                         Window Width SC
      * Send message 'width of window invalid'
     C                   MOVEL     'USR1738'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Window Starting Row
      * CASE: DTL.Starting line SCR is Blank
     C     #DSLSC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DSLSC        ZA0015                         Starting line S
      * Send message 'Starting Row is required'
     C                   MOVEL     'USR2581'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DSLSC        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0065            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0066           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0067            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0068            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0069           16            ZALIGN File Fie
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0070           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0071            1 0          ZALIGN No Of De
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
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DSLSC        ZA0016                         Starting line S
      * Send message 'Staring line must be Nbr'
     C                   MOVEL     'USR2582'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1SRWD                         Starting Row of
      * Zalign Starting Line - Mandatory Window Ref File  *
     C*
     C                   MOVE      WUZASF        #DSLSC
     C*
      * Valid Starting Row
      * CASE: DTL.Starting Row of Window is Valid range
     C     #1SRWD        IFGE      1                                            *IF
     C     #1SRWD        ANDLE     18
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DSLSC        ZA0017                         Starting line S
      * Send message 'Starting Row Invalid'
     C                   MOVEL     'USR1741'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Window Starting Column
      * CASE: DTL.Starting Column SCR is Blank
     C     #DSCSC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DSCSC        ZA0018                         Starting Column
      * Send message 'Starting column is reqd'
     C                   MOVEL     'USR2583'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DSCSC        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0072            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0073           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0074            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0075            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0076           16            ZALIGN File Fie
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0077           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0078            1 0          ZALIGN No Of De
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
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DSCSC        ZA0019                         Starting Column
      * Send message 'Starting Column must Nbr'
     C                   MOVEL     'USR2584'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1SCWD                         Starting column
      * Zalign Starting Column - Mandatory Window Ref File  *
     C*
     C                   MOVE      WUZASF        #DSCSC
     C*
      * Valid Starting column
      * CASE: DTL.Starting column of Window is Valid column
     C     #1SCWD        IFGE      1                                            *IF
     C     #1SCWD        ANDLE     53
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DSCSC        ZA0020                         Starting Column
      * Send message 'Starting Column Invalid'
     C                   MOVEL     'USR1743'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Window Length
      * CASE: DTL.Window Length SCR is Blank
     C     #DWLSC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DWLSC        ZA0021                         Window Length S
      * Send message 'Window length is required'
     C                   MOVEL     'USR2577'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DWLSC        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0079            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0080           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0081            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0082            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0083           16            ZALIGN File Fie
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0084           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0085            1 0          ZALIGN No Of De
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
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DWLSC        ZA0022                         Window Length S
      * Send message 'Window length numeric'
     C                   MOVEL     'USR2578'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1LGWD                         Length of Windo
      * Zalign Window length - Mandatory Window Ref File  *
     C*
     C                   MOVE      WUZASF        #DWLSC
     C*
      * Valid Length
      * CASE: DTL.Length of Window is Valid range
     C     #1LGWD        IFGE      1                                            *IF
     C     #1LGWD        ANDLE     18
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DWLSC        ZA0023                         Window Length S
      * Send message 'Invalid window length'
     C                   MOVEL     'USR2610'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Window Width
      * CASE: DTL.Window Width SCR is Blank
     C     #DWWSC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DWWSC        ZA0024                         Window Width SC
      * Send message 'Window width is required'
     C                   MOVEL     'USR2579'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DWWSC        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0086            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0087           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0088            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0089            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0090           16            ZALIGN File Fie
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0091           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0092            1 0          ZALIGN No Of De
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
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DWWSC        ZA0025                         Window Width SC
      * Send message 'Window width must be Nbr'
     C                   MOVEL     'USR2580'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1WDWD                         Width of Window
      * Zalign Window Width - Mandatory Window Ref File  *
     C*
     C                   MOVE      WUZASF        #DWWSC
     C*
      * Valid width
      * CASE: DTL.Width of Window is Valid width range
     C     #1WDWD        IFGE      22                                           *IF
     C     #1WDWD        ANDLE     75
      * The width of the window is less than 31.
      * CASE: DTL.Width of Window is Less than 31
     C     #1WDWD        IFLT      31                                           *IF
      * CASE: DTL.Width of Window NE WRK.Width of Window
     C     #1WDWD        IFNE      WUWDWD                                       *IF
      * Setup message data for message
     C                   MOVEL     #DWWSC        ZA0026                         Window Width SC
      * Send message 'Window too narrow for del'
     C                   MOVEL     'USR2613'     ZAMSID
     C                   MOVEL     '*INFO  '     ZAMSTP                         Message type
     C                   EXSR      ZASNMS
      *
     C                   Z-ADD     #1WDWD        WUWDWD                         Width of Window
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DWWSC        ZA0027                         Window Width SC
      * Send message 'Window width range invald'
     C                   MOVEL     'USR2611'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Window Starting Row
      * CASE: DTL.Starting line SCR is Blank
     C     #DSLSC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DSLSC        ZA0028                         Starting line S
      * Send message 'Starting Row is required'
     C                   MOVEL     'USR2581'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DSLSC        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0093            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0094           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0095            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0096            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0097           16            ZALIGN File Fie
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0098           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0099            1 0          ZALIGN No Of De
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
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DSLSC        ZA0029                         Starting line S
      * Send message 'Staring line must be Nbr'
     C                   MOVEL     'USR2582'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1SRWD                         Starting Row of
      * Zalign Starting Line - Mandatory Window Ref File  *
     C*
     C                   MOVE      WUZASF        #DSLSC
     C*
      * Valid Starting Row
      * CASE: DTL.Starting Row of Window is Valid range
     C     #1SRWD        IFGE      1                                            *IF
     C     #1SRWD        ANDLE     18
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DSLSC        ZA0030                         Starting line S
      * Send message 'Starting Row Invalid'
     C                   MOVEL     'USR1741'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Window Starting Column
      * CASE: DTL.Starting Column SCR is Blank
     C     #DSCSC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DSCSC        ZA0031                         Starting Column
      * Send message 'Starting column is reqd'
     C                   MOVEL     'USR2583'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DSCSC        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0100            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0101           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0102            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0103            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0104           16            ZALIGN File Fie
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
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0105           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0106            1 0          ZALIGN No Of De
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
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DSCSC        ZA0032                         Starting Column
      * Send message 'Starting Column must Nbr'
     C                   MOVEL     'USR2584'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1SCWD                         Starting column
      * Zalign Starting Column - Mandatory Window Ref File  *
     C*
     C                   MOVE      WUZASF        #DSCSC
     C*
      * Valid Starting column
      * CASE: DTL.Starting column of Window is Valid column range
     C     #1SCWD        IFGE      1                                            *IF
     C     #1SCWD        ANDLE     75
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DSCSC        ZA0033                         Starting Column
      * Send message 'Invalid starting column'
     C                   MOVEL     'USR2612'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0441RVSF - Mandatory Window Ref File  *
     C*Edit mandatory Window    Validate Detail Screen
     C/COPY WNCPYSRC,SD0441RVSF
      * CALC: Detail screen function fields
      * 00/Copy member SD0441RSFF - Mandatory Window Ref File  *
     C*Edit mandatory Window    Calc Detail Function Flds
     C/COPY WNCPYSRC,SD0441RSFF
      * USER: Validate detail screen relations
      * CASE: DTL.Window Type is IBM Window
     C     #1WINT        IFEQ      'I'                                          *IF
      * Position 1,1 of the screen has a special character, and a
      * window can not start at this position
      * Check that the window does not start at 1,1.
      * CASE: DTL.Starting Row of Window is One
     C     #1SRWD        IFEQ      1                                            *IF
      * CASE: DTL.Starting column of Window is One
     C     #1SCWD        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DSLSC        ZA0034                         Starting line S
     C                   MOVEL     #DSCSC        ZA0035                         Starting Column
      * Send message 'Window Not allowed'
     C                   MOVEL     'USR1744'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        993637    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     #1LGWD        ADD       #1SRWD        WUWLGT                         Window Length T
      * Window length is greater than 24.
      * CASE: WRK.Window Length Total is Greater than 24
     C     WUWLGT        IFGT      24                                           *IF
      * CASE: WRK.Saved window length Total EQ WRK.Window Length Total
     C     WUSWLT        IFEQ      WUWLGT                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DWLSC        ZA0036                         Window Length S
     C                   MOVEL     #DSLSC        ZA0037                         Starting line S
      * Send message 'Too many lines for screen'
     C                   MOVEL     'USR0564'     ZAMSID
     C                   MOVEL     '*INFO  '     ZAMSTP                         Message type
     C                   EXSR      ZASNMS
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   Z-ADD     WUWLGT        WUSWLT                         Saved window le
     C                   END                                                    *FI
     C     #1WDWD        ADD       #1SCWD        WUWWDT                         Window Width To
      * Window width is greater than 80.
      * CASE: WRK.Window Width Total is Greater than 80
     C     WUWWDT        IFGT      80                                           *IF
      * CASE: WRK.Saved window width Total EQ WRK.Window Width Total
     C     WUSWWT        IFEQ      WUWWDT                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DWWSC        ZA0038                         Window Width SC
     C                   MOVEL     #DSCSC        ZA0039                         Starting Column
      * Send message 'Window too Wide for Scree'
     C                   MOVEL     'USR0565'     ZAMSID
     C                   MOVEL     '*INFO  '     ZAMSTP                         Message type
     C                   EXSR      ZASNMS
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   Z-ADD     WUWWDT        WUSWWT                         Saved window wi
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Validation changed so that if all the fields specific to non-DDS
      * windows remain zero then they will be optional.
      * Position 1,1 of the screen has a special character, and a
      * window can not start at this position
      * Check that the window does not start at 1,1.
      * CASE: DTL.Starting Row of Window is One
     C     #1SRWD        IFEQ      1                                            *IF
      * CASE: DTL.Starting column of Window is One
     C     #1SCWD        IFEQ      1                                            *IF
      * Setup message data for message
     C                   MOVEL     #DSLSC        ZA0040                         Starting line S
     C                   MOVEL     #DSCSC        ZA0041                         Starting Column
      * Send message 'Window Not allowed'
     C                   MOVEL     'USR1744'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        993637    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     #1LGWD        ADD       #1SRWD        WUWLGT                         Window Length T
      * Window length is greater than 18.
      * CASE: WRK.Window Length Total is Greater than 18
     C     WUWLGT        IFGT      18                                           *IF
      * Setup message data for message
     C                   MOVEL     #DWLSC        ZA0042                         Window Length S
     C                   MOVEL     #DSLSC        ZA0043                         Starting line S
      * Send message 'Window will not fit'
     C                   MOVEL     'USR2608'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        993436    *
      *
     C                   END                                                    *FI
     C     #1WDWD        ADD       #1SCWD        WUWWDT                         Window Width To
      * Window width is greater than 75.
      * CASE: WRK.Window Width Total is Greater than 75
     C     WUWWDT        IFGT      75                                           *IF
      * Setup message data for message
     C                   MOVEL     #DWWSC        ZA0044                         Window Width SC
     C                   MOVEL     #DSCSC        ZA0045                         Starting Column
      * Send message 'Window is too wide'
     C                   MOVEL     'USR2609'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        993537    *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0441RVSR - Mandatory Window Ref File  *
     C*Edit mandatory Window    Validate Screen Relns
     C/COPY WNCPYSRC,SD0441RVSR
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
      * 00/Copy member SD0441RPCK - Mandatory Window Ref File  *
     C*Edit mandatory Window    Process Command Keys
     C/COPY WNCPYSRC,SD0441RPCK
      * CASE: DTL.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C     W0PMD         IFEQ      'ADD'
      * Exit after successful add
     C                   MOVEL     'N'           W0RPT
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
      * Create Object    Edit Rec - Mandatory Window Ref File  *
     C                   EXSR      SBCRRC
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
      * Delete Object    Edit Rec - Mandatory Window Ref File  *
     C                   EXSR      SCDLRC
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
      * Change Object    Edit Rec - Mandatory Window Ref File  *
     C                   EXSR      SDCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
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
     C     P1NMCP        IFEQ      *BLANK                                       Name Of Calling
     C     P1SQNB        OREQ      *BLANK                                       Sequence Number
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
     C                   MOVEL     *BLANK        #1WINT                         Window Type
     C                   Z-ADD     *ZERO         #1LGWD                         Length of Windo
     C                   Z-ADD     *ZERO         #1WDWD                         Width of Window
     C                   Z-ADD     *ZERO         #1SRWD                         Starting Row of
     C                   Z-ADD     *ZERO         #1SCWD                         Starting column
     C                   MOVEL     *BLANK        #1PGMT                         Program Text
     C                   MOVEL     *BLANK        #DIBMS                         IBM Window Scre
     C                   MOVEL     *BLANK        #1WNCN                         Window Controll
     C                   MOVEL     *BLANK        #1TTWD                         Title of Window
     C                   MOVEL     *BLANK        #DWLSC                         Window Length S
     C                   MOVEL     *BLANK        #DWWSC                         Window Width SC
     C                   MOVEL     *BLANK        #DSLSC                         Starting line S
     C                   MOVEL     *BLANK        #DSCSC                         Starting Column
     C                   MOVEL     *BLANK        #1MSGT                         Message Type
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      **Move*@DLREGT*fields*to*screen**********************************                       CPK018
      * Move @MREFJ0 fields to screen                                                         CPK018
      *================================================================
     C                   Z-ADD     DLLCD         #1LCD                          Last Change Dat
     C                   MOVEL     DLTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     DLWINT        #1WINT                         Window Type
     C                   Z-ADD     DLLGWD        #1LGWD                         Length of Windo
     C                   Z-ADD     DLWDWD        #1WDWD                         Width of Window
     C                   Z-ADD     DLSRWD        #1SRWD                         Starting Row of
     C                   Z-ADD     DLSCWD        #1SCWD                         Starting column
     C                   MOVEL     DLNMCP        #1NMCP                         Name Of Calling
     C                   MOVEL     DLSQNB        #1SQNB                         Sequence Number
     C                   MOVEL     DLPGMT        #1PGMT                         Program Text
     C                   MOVEL     DLWNCN        #1WNCN                         Window Controll
     C                   MOVEL     DLTTWD        #1TTWD                         Title of Window
     C                   MOVEL     DLMSGT        #1MSGT                         Message Type
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1NMCP        #1NMCP                         Name Of Calling
     C                   MOVEL     P1SQNB        #1SQNB                         Sequence Number
      * USER: Initialize key screen
      * Set up KEY screen footer - Mandatory Window Ref File  *
     C*
     C* KEY LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'USR3345'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
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
     C*
      * 00/Copy member SD0441RIKS - Mandatory Window Ref File  *
     C*Edit mandatory Window    Initialise Key Screen
     C/COPY WNCPYSRC,SD0441RIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Does recored exist ? - Mandatory Window Ref File  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    DLNMCP                         Name Of Calling
     C                   KFLD                    DLSQNB                         Sequence Number
      * Move fields to key list
     C                   MOVEL     #1NMCP        DLNMCP                         Name Of Calling
     C                   MOVEL     #1SQNB        DLSQNB                         Sequence Number
     C********** KRSSA     CHAIN@DLREGT              90    *                                  CPK018
     C*****KRSSA         CHAIN     @MREFJ0                            90        *           MD056890
     C/EXEC SQL                                                                             MD056890
     C+ SELECT *                                                                            MD056890
     C+ into :SDMREFJ :NullInds                                                             MD056890
     C+ from SDMRFJW1                                                                       MD056890
     C+ where DLNMCP = :DLNMCP and DLSQNB = :DLSQNB                                         MD056890
     C/END-EXEC                                                                             MD056890
     C                   setoff                                       9091                  MD056890
     C                   If        SQLCODE = 100                                            MD056890
     C                   seton                                        90                    MD056890
     C                   Endif                                                              MD056890
                                                                                            MD056890
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0557'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCRRC        BEGSR
      *================================================================
      * Create Object    Edit Rec - Mandatory Window Ref File  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @DLREGS
     C                   MOVEL     #1NMCP        DLNMCP                         Name Of Calling
     C                   MOVEL     #1SQNB        DLSQNB                         Sequence Number
     C                   Z-ADD     WURDNB        DLLCD                          Last Change Dat
     C                   MOVEL     'I'           DLTYLC                         Type of Last Ch
     C                   MOVEL     #1WNCN        DLWNCN                         Window Controll
     C                   Z-ADD     #1LGWD        DLLGWD                         Length of Windo
     C                   Z-ADD     #1WDWD        DLWDWD                         Width of Window
     C                   MOVEL     #1TTWD        DLTTWD                         Title of Window
     C                   Z-ADD     #1SRWD        DLSRWD                         Starting Row of
     C                   Z-ADD     #1SCWD        DLSCWD                         Starting column
     C                   MOVEL     #1PGMT        DLPGMT                         Program Text
     C                   MOVEL     #1WINT        DLWINT                         Window Type
     C                   MOVEL     #1MSGT        DLMSGT                         Message Type
      *
      * USER: Processing before Data update
      * 00/Copy member SD0441RCBU - Mandatory Window Ref File  *
     C*Edit mandatory Window    Processing Before Create
     C/COPY WNCPYSRC,SD0441RCBU
     C     KLCRSB        KLIST
     C                   KFLD                    DLNMCP                         Name Of Calling
     C                   KFLD                    DLSQNB                         Sequence Number
      * Check for duplicate primary key
     C*****KLCRSB        SETLL     @DLREGS                                90    *           MD056890
     C/EXEC SQL                                                                             MD056890
     C+ SELECT *                                                                            MD056890
     C+ into :SDMREF                                                                        MD056890
     C+ from SDMRFJW0                                                                       MD056890
     C+ where DLNMCP = :DLNMCP and DLSQNB = :DLSQNB                                         MD056890
     C/END-EXEC                                                                             MD056890
     C                   setoff                                       90                    MD056890
     C                   If        SQLCODE = 0                                              MD056890
     C                   seton                                        90                    MD056890
     C                   Endif                                                              MD056890
                                                                                            MD056890
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0558'     W0RTN             7
      * Send message 'Mandatory Window Ref F EX'
     C                   MOVEL     'USR0558'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C**********         WRITE     @DLREGS                              91      *           MD056890
     C/EXEC SQL                                                                             MD056890
     C+ insert into SDMRFBTD                                                                MD056890
     C+ (                                                                                   MD056890
     C+   DLNMCP                                                                            MD056890
     C+ , DLSQNB                                                                            MD056890
     C+ , DLLCD                                                                             MD056890
     C+ , DLTYLC                                                                            MD056890
     C+ , DLWNCN                                                                            MD056890
     C+ , DLLGWD                                                                            MD056890
     C+ , DLWDWD                                                                            MD056890
     C+ , DLTTWD                                                                            MD056890
     C+ , DLSRWD                                                                            MD056890
     C+ , DLSCWD                                                                            MD056890
     C+ , DLPGMT                                                                            MD056890
     C+ , DLWINT                                                                            MD056890
     C+ , DLMSGT                                                                            MD056890
     C+ , DLMODE                                                                            MD056890
     C+ )                                                                                   MD056890
     C+ Values                                                                              MD056890
     C+ (                                                                                   MD056890
     C+   :DLNMCP                                                                           MD056890
     C+ , :DLSQNB                                                                           MD056890
     C+ , :DLLCD                                                                            MD056890
     C+ , :DLTYLC                                                                           MD056890
     C+ , :DLWNCN                                                                           MD056890
     C+ , :DLLGWD                                                                           MD056890
     C+ , :DLWDWD                                                                           MD056890
     C+ , :DLTTWD                                                                           MD056890
     C+ , :DLSRWD                                                                           MD056890
     C+ , :DLSCWD                                                                           MD056890
     C+ , :DLPGMT                                                                           MD056890
     C+ , :DLWINT                                                                           MD056890
     C+ , :DLMSGT                                                                           MD056890
     C+ , 'B'                                                                               MD056890
     C+ )                                                                                   MD056890
     C/END-EXEC                                                                             MD056890
     C/EXEC SQL                                                                             MD056890
     C+ insert into SDMRFXTD                                                                MD056890
     C+ (                                                                                   MD056890
     C+   DLNMCP                                                                            MD056890
     C+ , DLSQNB                                                                            MD056890
     C+ , DLLCD                                                                             MD056890
     C+ , DLTYLC                                                                            MD056890
     C+ , DLWNCN                                                                            MD056890
     C+ , DLLGWD                                                                            MD056890
     C+ , DLWDWD                                                                            MD056890
     C+ , DLTTWD                                                                            MD056890
     C+ , DLSRWD                                                                            MD056890
     C+ , DLSCWD                                                                            MD056890
     C+ , DLPGMT                                                                            MD056890
     C+ , DLWINT                                                                            MD056890
     C+ , DLMSGT                                                                            MD056890
     C+ , DLMODE                                                                            MD056890
     C+ )                                                                                   MD056890
     C+ Values                                                                              MD056890
     C+ (                                                                                   MD056890
     C+   :DLNMCP                                                                           MD056890
     C+ , :DLSQNB                                                                           MD056890
     C+ , :DLLCD                                                                            MD056890
     C+ , :DLTYLC                                                                           MD056890
     C+ , :DLWNCN                                                                           MD056890
     C+ , :DLLGWD                                                                           MD056890
     C+ , :DLWDWD                                                                           MD056890
     C+ , :DLTTWD                                                                           MD056890
     C+ , :DLSRWD                                                                           MD056890
     C+ , :DLSCWD                                                                           MD056890
     C+ , :DLPGMT                                                                           MD056890
     C+ , :DLWINT                                                                           MD056890
     C+ , :DLMSGT                                                                           MD056890
     C+ , 'B'                                                                               MD056890
     C+ )                                                                                   MD056890
     C/END-EXEC                                                                             MD056890
      *
     C******IN91         IFEQ      '1'                                                      MD056890
     C                   IF        SQLCODE <> 0                                             MD056890
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
      * 00/Copy member SD0441RCAU - Mandatory Window Ref File  *
     C*Edit mandatory Window    Processing After Create
     C/COPY WNCPYSRC,SD0441RCAU
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCDLRC        BEGSR
      *================================================================
      * Delete Object    Edit Rec - Mandatory Window Ref File  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
      * 00/Copy member SD0441RDBU - Mandatory Window Ref File  *
     C*Edit mandatory Window    Processing Before Delete
     C/COPY WNCPYSRC,SD0441RDBU
      * Move key fields to @DLREGS
     C                   MOVEL     #1NMCP        DLNMCP                         Name Of Calling
     C                   MOVEL     #1SQNB        DLSQNB                         Sequence Number
      *
     C     KLDLSC        KLIST
     C                   KFLD                    DLNMCP                         Name Of Calling
     C                   KFLD                    DLSQNB                         Sequence Number
     C*****KLDLSC        CHAIN     @DLREGS                            9091      *           MD056890
     C/EXEC SQL                                                                             MD056890
     C+ SELECT *                                                                            MD056890
     C+ into :SDMREF                                                                        MD056890
     C+ from SDMRFJW0                                                                       MD056890
     C+ where DLNMCP = :DLNMCP and DLSQNB = :DLSQNB                                         MD056890
     C/END-EXEC                                                                             MD056890
     C                   setoff                                       9091                  MD056890
     C                   If        SQLCODE = 100                                            MD056890
     C                   seton                                        90                    MD056890
     C                   Endif                                                              MD056890
     C                   If        SQLCODE <> 0  and SQLCODE <> 100                         MD056890
     C                   seton                                        90                    MD056890
     C                   Endif                                                              MD056890
                                                                                            MD056890
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
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
      * Release record lock
     C*****KLDLSC        SETLL     @DLREGS                            9091      *           MD056890
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C**********         DELETE    @DLREGS                              91      *           MD056890
     C/EXEC SQL                                                                             MD056890
     C+ DELETE from SDMRFBTD                                                                MD056890
     C+ where DLNMCP = :DLNMCP and DLSQNB = :DLSQNB                                         MD056890
     C/END-EXEC                                                                             MD056890
     C/EXEC SQL                                                                             MD056890
     C+ DELETE from SDMRFXTD                                                                MD056890
     C+ where DLNMCP = :DLNMCP and DLSQNB = :DLSQNB                                         MD056890
     C/END-EXEC                                                                             MD056890
     C******IN91         IFEQ      '1'                                                      MD056890
     C                   If        SQLCODE <> 0                                             MD056890
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * 00/Copy member SD0441RDAU - Mandatory Window Ref File  *
     C*Edit mandatory Window    Processing After Delete
     C/COPY WNCPYSRC,SD0441RDAU
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Object    Edit Rec - Mandatory Window Ref File  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @DLREGS
     C                   MOVEL     #1NMCP        DLNMCP                         Name Of Calling
     C                   MOVEL     #1SQNB        DLSQNB                         Sequence Number
      *
     C     KLCHSD        KLIST
     C                   KFLD                    DLNMCP                         Name Of Calling
     C                   KFLD                    DLSQNB                         Sequence Number
     C*****KLCHSD        CHAIN     @DLREGS                            9091      *           MD056890
     C/EXEC SQL                                                                             MD056890
     C+ SELECT *                                                                            MD056890
     C+ into :SDMREF                                                                        MD056890
     C+ from SDMRFJW0                                                                       MD056890
     C+ where DLNMCP = :DLNMCP and DLSQNB = :DLSQNB                                         MD056890
     C/END-EXEC                                                                             MD056890
     C                   setoff                                       9091                  MD056890
     C                   If        SQLCODE = 100                                            MD056890
     C                   seton                                        90                    MD056890
     C                   Endif                                                              MD056890
     C                   If        SQLCODE <> 0  and SQLCODE <> 100                         MD056890
     C                   seton                                        90                    MD056890
     C                   Endif                                                              MD056890
                                                                                            MD056890
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
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
      * Release record lock
     C**********         UNLOCK    SDMREFL0                             91      *           MD056890
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YARDCS
      * Move non-key fields to @DLREGS
     C                   Z-ADD     WURDNB        DLLCD                          Last Change Dat
     C                   MOVEL     'A'           DLTYLC                         Type of Last Ch
     C                   MOVEL     #1WNCN        DLWNCN                         Window Controll
     C                   Z-ADD     #1LGWD        DLLGWD                         Length of Windo
     C                   Z-ADD     #1WDWD        DLWDWD                         Width of Window
     C                   MOVEL     #1TTWD        DLTTWD                         Title of Window
     C                   Z-ADD     #1SRWD        DLSRWD                         Starting Row of
     C                   Z-ADD     #1SCWD        DLSCWD                         Starting column
     C                   MOVEL     #1PGMT        DLPGMT                         Program Text
     C                   MOVEL     #1WINT        DLWINT                         Window Type
     C                   MOVEL     #1MSGT        DLMSGT                         Message Type
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * USER: Processing before Data update
      * 00/Copy member SD0441RBDU - Mandatory Window Ref File  *
     C*Edit mandatory Window    Processing Before Update
     C/COPY WNCPYSRC,SD0441RBDU
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C**********         UPDATE    @DLREGS                              91      *           MD056890
     C/EXEC SQL                                                                             MD056890
     C+ update SDMRFBTD SET                                                                 MD056890
     C+    DLLCD  = :DLLCD                                                                  MD056890
     C+  , DLTYLC = :DLTYLC                                                                 MD056890
     C+  , DLWNCN = :DLWNCN                                                                 MD056890
     C+  , DLLGWD = :DLLGWD                                                                 MD056890
     C+  , DLWDWD = :DLWDWD                                                                 MD056890
     C+  , DLTTWD = :DLTTWD                                                                 MD056890
     C+  , DLSRWD = :DLSRWD                                                                 MD056890
     C+  , DLSCWD = :DLSCWD                                                                 MD056890
     C+  , DLPGMT = :DLPGMT                                                                 MD056890
     C+  , DLWINT = :DLWINT                                                                 MD056890
     C+  , DLMSGT = :DLMSGT                                                                 MD056890
     C+ where DLNMCP = :DLNMCP and DLSQNB = :DLSQNB                                         MD056890
     C/END-EXEC                                                                             MD056890
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDMREFL0                             91      *           MD056890
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
      * USER: Processing after Data update
      * 00/Copy member SD0441RADU - Mandatory Window Ref File  *
     C*Edit mandatory Window    Processing After Update
     C/COPY WNCPYSRC,SD0441RADU
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record
      *================================================================
      * Name search required?
     C                   MOVEL     #1NMCP        WK1X01            1
     C                   MOVEL     #1SQNB        WK1X02            1
     C     WK1X01        IFEQ      '?'                                          Name Of Calling
     C     WK1X02        OREQ      '?'                                          Sequence Number
     C                   CALL      'WN0460S'                            90      Select Mandator
     C                   PARM      *BLANK        W0RTN             7
     C     #1NMCP        PARM      #1NMCP        WQ0029           10            Name Of Calling
     C     #1SQNB        PARM      #1SQNB        WQ0030            2            Sequence Number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'WN0460S'     W0CLPG
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
     C                   SETON                                        993132    *
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
      * 00/Copy member SD0441REPP - Mandatory Window Ref File  *
     C*Edit mandatory Window    Exit Program Processing
     C/COPY WNCPYSRC,SD0441REPP
      * Fast Exit processing
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
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
      *
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
      * Define work field ZALIGN Screen Fun Field
     C                   MOVEL     *BLANK        WUZASF           16
      * Define work field ZALIGN File Field
     C                   MOVEL     *BLANK        WUZAFF           16
      * Define work field Err Code
     C                   MOVEL     *BLANK        WUERCD            1
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field Work alpha field
     C                   MOVEL     *BLANK        WUWKAF            3
      * Define work field Work alpha field for numb
     C                   MOVEL     *BLANK        WUWAFN            4
      * Define work field Work Return code
     C                   MOVEL     *BLANK        WUWRTC            5
      * Define work field field text parameter
     C                   MOVEL     *BLANK        WUFTPR          256
      * Define work field Width of Window
     C                   Z-ADD     *ZERO         WUWDWD            3 0
      * Define work field Window Length Total
     C                   Z-ADD     *ZERO         WUWLGT            3 0
      * Define work field Saved window length Total
     C                   Z-ADD     *ZERO         WUSWLT            3 0
      * Define work field Window Width Total
     C                   Z-ADD     *ZERO         WUWWDT            3 0
      * Define work field Saved window width Total
     C                   Z-ADD     *ZERO         WUSWWT            3 0
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Open files
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
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
     C                   OPEN      SD0441R#
     C**********           OPEN SDMREFL1                                                      CPK018
     C**********         OPEN      SDMREFJ0                                                 MD056890
     C**********         OPEN      SDMREFL0                                                 MD056890
     C                   MOVEL     'N'           W0PMT             1
      * Select initial mode
     C     @1NROP        IFEQ      *ZERO
      * Add mode
     C                   MOVEL     'ADD'         W0PMD             3
     C                   ELSE
      * Change mode
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * SD0441R precompiler - Mandatory Window Ref File  *
      * Copyright Statement 1994 - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Program Mode processing
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   MOVEL     'ADD'         W0PMD                          *Program mode
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'CHG'         W0PMD                          *Program mode
     C                   END                                                    *FI
      * 00/Copy member SD0441RFPG - Mandatory Window Ref File  *
      * 00/Copy member SD0441REPG - Mandatory Window Ref File  *
      * 00/Copy member SD0441RIPG - Mandatory Window Ref File  *
      * 00/Copy member SD0441RCPG - Mandatory Window Ref File  *
     C*Edit mandatory Window    Initialise Program C-spec
     C/COPY WNCPYSRC,SD0441RCPG
      * 00/Copy member SD0441ROPG - Mandatory Window Ref File  *
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
     C/COPY WNCPYSRC,SD0441RPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0441RPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD056890
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD056890
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0441RPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O*Edit mandatory Window    Initialise Program O-spec
     O/COPY WNCPYSRC,SD0441ROPG
**CTDATA CPY@
(c) Finastra International Limited 2001
