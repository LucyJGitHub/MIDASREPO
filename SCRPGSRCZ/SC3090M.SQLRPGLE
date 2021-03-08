     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC Switchable features by init pgms')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC3090M - Switchable Features by Initialisation Program      *
      *                                                               *
      *  Function:  This program allows the user to maintain the      *
      *             switchable feature initialisation program data    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSC007             Date 05Nov98               *
      *                 CCB008             Date 12Oct98               *
      *                 S01459             Date 12Oct98               *
      *                 S01430             Date 07JUL93               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC007 - Enable Swithchable Features to be maintained        *
      *           irrespective of on or off                           *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - File removed from CB model.                       *
      *  S01459 - Addition of Midas Headerbox.                        *
      *  S01430 - Switchability Enhancements Phase 2:                 *
      *           - Inclusion of switchable feature initialisation    *
      *             programs.                                         *
      *                                                               *
      *****************************************************************
     FSC3090M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SC Switchable features by init pgms
      *
     FSCSARPL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas SC Switchable features - init pgm retrieval
      *
     F*SCSARDL1IF**E***********K        DISK                           UC      CSC007
     F*SCSARSL1* IF   E           K DISK    USROPN                                          MD055681
     F**********                           INFDS(ID0001)                                    MD055681
     F**********                           INFSR(*PSSR)                                     MD055681
      * RTV : Midas SC Switchable features in system retrieval
      *
     FSCSARPL0  UF A E           K DISK    USROPN
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * UPD : Midas SC Switchable features - init pgm update
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
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
     D @1DBRC        E DS                  EXTNAME(SCSARPL0)
      * UPD : Midas SC Switchable features - init pgm update
      * Current/previous master file format fields for change control
      *
     D YARDCS          DS            71
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
     D ID0002          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : RST Switchable Feature Number
     D  P1SARN                 1      6
     D P2PARM          DS
      * I : RST Description
     D  P2SARD                 1     50
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Program doesn't exist'
      * Program Name
     D  ZA0001                 1     10
      * Message data for 'Switch F Rept - Init Pgm'
      * Switchable Feature Number
     D  ZA0002                 1      6
      * Message data for 'Program doesn't exist'
      * Program Name
     D  ZA0003                 1     10
      * Message data for 'Program doesn't exist'
      * Program Name
     D  ZA0004                 1     10
      * Message data for 'Press enter to call pgm'
      * Program Name
     D  ZA0005                 1     10
      * Message data for 'WARNING:Pgm called before'
      * Program Name
     D  ZA0006                 1     10
      * Message data for 'Call Program must be Y/N'
      * Call Program ?
     D  ZA0007                 1      1
      * Message data for 'Init pgm call successful'
      * Program Name
     D  ZA0008                 1     10
      * Switchable Feature Number
     D  ZA0009                11     16
      * Message data for 'Init pgm call error'
      * Program Name
     D  ZA0010                 1     10
      * Switchable Feature Number
     D  ZA0011                11     16
     D SCSARS        E DS                  EXTNAME(SCSRSJW0)                                MD055681
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1SARN        PARM                    WP0001            6            Switchable Feat
     C     P2SARD        PARM                    WP0002           50            Description
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise and load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested
     C     W0RSF         DOWEQ     'N'
      * Display screen
     C                   EXSR      CAEXFM
      * Process response
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * HOME: Request subfile reload
     C   05              CAS                     FBRQRL
      * Display next SFL page
     C   27              CAS                     BBLDSF
      * Process screen input
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END
     C                   END
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      *................................................................
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #2PNAM        WZPNAM
     C                   MOVEL     #2PNAM        WZPNAM                         Program Name
     C     KPOS          KLIST
     C                   KFLD                    AKSARN                         Switchable Feat
     C                   KFLD                    AKPNAM                         Program Name
      * Setup key
     C                   MOVEL     #2SARN        AKSARN                         Switchable Feat
     C                   MOVEL     #2PNAM        AKPNAM                         Program Name
      * 82=EOF
     C     KPOS          SETLL     @SARPL1                            82        *
      * 82=EOF
     C     KRST          KLIST
     C                   KFLD                    AKSARN                         Switchable Feat
      * Setup key
     C                   MOVEL     #2SARN        AKSARN                         Switchable Feat
     C  N82KRST          READE     @SARPL1                              9182    *
     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      * Load subfile page
     C                   EXSR      BBLDSF
      * If no records (first time only), switch to add mode and load agai
     C     W0APM         IFEQ      'Y'
     C     ##RR          ANDEQ     *ZERO
     C                   MOVEL     'ADD'         W0PMD
     C                   SETON                                        51
     C                   SETOFF                                       82        *
     C                   EXSR      BBLDSF
     C                   END
     C                   MOVEL     'N'           W0APM             1
      *................................................................
      * If no records found, display error message
     C   82##RR          IFEQ      *ZERO                                        IF
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page (write empty page if add mode)
      *================================================================
     C                   SETOFF                                       84        No SFLNXTCHG
      * Re-establish fields in read-ahead record
     C   27W0PMD         IFNE      'ADD'
     C  N82              READP     @SARPL1                                90    *
     C  N82              READ      @SARPL1                                90    *
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0            3
     C                   MOVE      *ALL'1'       WKIND1            3
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
     C                   Z-ADD     *ZERO         ##RROK            5 0
      * Set required pages based on *Set Cursor or *Subfile Pages
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   END
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
      * Compute lines required based on pages
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   END
      *................................................................
      * Load next subfile page
     C  N82##RROK        DOWLT     ##SFLN                                       DO
     C                   ADD       1             ##RR
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       87        *
      * Clear subfile fields
     C                   EXSR      MAIZ#1
      * If CHANGE mode, load subfile fields
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      * Record will be selected unless overridden
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Initialize subfile record (existing record)
      * Copy program description field from DBF to a hidden screen field
     C                   MOVEL     AKPDSC        #RDESP                         Description of
      * Call Program ? flag is initially set to 'N'
     C                   MOVEL     'N'           #RPCAL                         Call Program ?
     C                   MOVEL     'N'           #RHCAL                         Call Program ?
      * Validate if program exists
     C                   MOVEL     AKPNAM        WUPNAM                         Program Name
     C                   MOVEL     AKPDSC        WUPDSC                         Program Descrip
     C                   MOVEL     *BLANK        WURTCD                         Access Obj Retu
      * Check Init Pgm Existence - Standard functions  *
     C                   CALL      'SCC3091'                            90      Check Init Pgm
     C                   PARM      WUPNAM        WQ0001           10            Program Name
     C     WUPDSC        PARM      WUPDSC        WQ0002           50            Program Descrip
     C     WURTCD        PARM      WURTCD        WQ0003            7            Access Obj Retu
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SCC3091'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error if program does not exist, send error message and
      * do not display 'Call Program Now ?' field
      * CASE: WRK.Access Obj Return Code is Normal - no errors found
     C     WURTCD        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'Y'           #RDCAL                         Display Call Pr
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1PNAM        ZA0001                         Program Name
      * Send message 'Program doesn't exist'
     C                   MOVEL     'CBM0058'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   MOVEL     'N'           #RDCAL                         Display Call Pr
     C                   END                                                    *FI
      * If record dropped...
     C                   SUB       1             ##RR
     C     W0RSL         CABNE     'Y'           BB020
     C                   ADD       1             ##RR
      * Validate subfile record and calculate derived fields
     C                   EXSR      DFV2RC
     C                   ELSE
      * USER: Initialize subfile record (new record)
      * Do not display 'Call Program Now ?' field
     C                   MOVEL     'N'           #RDCAL                         Display Call Pr
     C                   END
      * Output to subfile
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   WRITE     #SFLRCD
     C     BB020         TAG
     C     W0PMD         IFNE      'ADD'
      * 82=EOF
     C     KRST          READE     @SARPL1                                82    *
     C                   END
     C  N82              END
      *................................................................
      * Save highest SFL record load can continue at end point
     C     ##RR          IFGT      ##RRMX
      * Calculate top line
     C     ##RROK        DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
     C     ##SLIN        IFGT      0
     C     ##RR          SUB       ##SLIN        ##SFRC
     C                   ELSE
     C     ##RR          SUB       ##SFPG        ##SFRC
     C                   END
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSA2
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN89         IFNE      CAIN89
     C     *IN81         ORNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN89         CAIN89            1
     C                   MOVE      *IN81         CAIN81            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
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
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      *
     C     W0PMD         IFNE      'ADD'
      * Change of position specified
     C     WZPNAM        CASNE     #2PNAM        FBRQRL                         Program Name
     C                   END
     C                   END
      * USER: Validate subfile control
      * F12=Previous Pressed
      * CASE: CTL.*CMD key is *Cancel
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * F11=Print Pressed
      * CASE: CTL.*CMD key is CF11
     C     *IN11         IFEQ      '1'                                          *IF
      * Print  Switchable F - Ini - Switchable F - Init Pgm  *
     C                   CALL      'SC3090P'                            90      Print  Switchab
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      P1SARN        WQ0004            6            Switchable Feat
     C                   PARM      P2SARD        WQ0005           50            Description
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3090P'     W0CLPG
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
      * Setup message data for message
     C                   MOVEL     P1SARN        ZA0002                         Switchable Feat
      * Send message 'Switch F Rept - Init Pgm'
     C                   MOVEL     'CBM0062'     ZAMSID
     C                   MOVEL     '*INFO  '     ZAMSTP                         Message type
     C                   EXSR      ZASNMS
      *
     C                   END                                                    *FI
      * Quit if reload requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
      *
     C   81              DO
      * No data entered as yet
     C                   MOVEL     'N'           WKIPIN            1
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * Process subfile records
     C                   EXSR      DBPRSF
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * If data entered
     C     WKIPIN        IFEQ      'Y'
      * Update DBF from subfile
     C                   EXSR      EAPRSF
      * If error during update, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END                                                    WKIPIN
     C                   END
      * Switch between *ADD/*CHANGE modes
     C   09              EXSR      FACHMD
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
     C                   EXSR      DCPRSR
     C                   SETOFF                                       87        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(32)
      * No errors
     C                   SETOFF                                       98
      * No SFLNXTCHG
     C                   SETOFF                                       84
     C     W0PMD         IFEQ      'ADD'
      * Check for null record
     C                   EXSR      DDNLRC
     C     W0NLR         IFEQ      'Y'
     C                   GOTO      DCEXIT
     C                   END
      * If not null record, continue
     C                   END
      * Data entered
     C                   MOVEL     'Y'           WKIPIN
      * SFLNXTCHG
     C                   SETON                                        84
      * If delete request, bypass validation
     C     #1SEL         IFEQ      'D'
     C                   GOTO      DCEXIT
     C                   END
      * Validate subfile record
     C                   EXSR      DEV1RC
      * If SFLRCD invalid, note the fact
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99        *
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DDNLRC        BEGSR
      *================================================================
      * Check for null record
      *================================================================
     C                   MOVEL     'N'           W0NLR             1
     C     #1PNAM        CABNE     *BLANK        DDEXIT                         Program Name
     C     #RPCAL        CABNE     *BLANK        DDEXIT                         Call Program ?
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * Validate Call Program ?
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #RPCAL        W0NSRQ            1            Call Program ?
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1103439       Y2LSNO            7 0
     C     #RPCAL        PARM      #RPCAL        W0EXVL           20            Call Program ?
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * USER: Validate subfile record fields
      * Validate program existence
     C                   MOVEL     #1PNAM        WUPNAM                         Program Name
     C                   MOVEL     #1PDSC        WUPDSC                         Program Descrip
     C                   MOVEL     *BLANK        WURTCD                         Access Obj Retu
      * Check Init Pgm Existence - Standard functions  *
     C                   CALL      'SCC3091'                            90      Check Init Pgm
     C                   PARM      WUPNAM        WQ0006           10            Program Name
     C     WUPDSC        PARM      WUPDSC        WQ0007           50            Program Descrip
     C     WURTCD        PARM      WURTCD        WQ0008            7            Access Obj Retu
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SCC3091'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * (in add mode, retrieve the object description)
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
      * If the program exists, then copy
      * (i)   If the object description on the screen is different
      *       from the hidden screen field, then redisplay screen
      * (ii)  copy the program description to the hidden screen field
      * CASE: WRK.Access Obj Return Code is Normal - no errors found
     C     WURTCD        IFEQ      *BLANK                                       *IF
     C                   MOVEL     WUPDSC        #1PDSC                         Program Descrip
      * CASE: RCD.Program Description NE RCD.Description of Program
     C     #1PDSC        IFNE      #RDESP                                       *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   END                                                    *FI
     C                   MOVEL     #1PDSC        #RDESP                         Description of
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1PNAM        ZA0003                         Program Name
      * Send message 'Program doesn't exist'
     C                   MOVEL     'CBM0058'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * (in Change mode)
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'                                        *IF
      * CASE: WRK.Access Obj Return Code is Normal - no errors found
     C     WURTCD        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1PNAM        ZA0004                         Program Name
      * Send message 'Program doesn't exist'
     C                   MOVEL     'CBM0058'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   MOVEL     'N'           #RDCAL                         Display Call Pr
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate Call Program (Y/N) ?
      * (only in Change mode)
      * CASE: WRK.Access Obj Return Code is Normal - no errors found
     C     WURTCD        IFEQ      *BLANK                                       *IF
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'                                        *IF
      * CASE: RCD.Call Program ? is Valid values
     C     #RPCAL        IFEQ      'N'                                          *IF
     C     #RPCAL        OREQ      'Y'
      * If Call Program ? changed, redisplay screen
      * CASE: RCD.Call Program ? NE RCD.Call Program ? Hidden
     C     #RPCAL        IFNE      #RHCAL                                       *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
      * If the program has not previously been called, send info
      * otherwise, it it has been called before, send a warning message
      * CASE: RCD.Call Program ? is Yes
     C     #RPCAL        IFEQ      'Y'                                          *IF
      * CASE: RCD.Call Program ? Hidden is No
     C     #RHCAL        IFEQ      'N'                                          *IF
      * CASE: RCD.Program Previously Called is Not previously called
     C     #1PRVC        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1PNAM        ZA0005                         Program Name
      * Send message 'Press enter to call pgm'
     C                   MOVEL     'CBM0064'     ZAMSID
     C                   MOVEL     '*INFO  '     ZAMSTP                         Message type
     C                   EXSR      ZASNMS
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: RCD.Call Program ? EQ RCD.Program Previously Called
     C     #RPCAL        IFEQ      #1PRVC                                       *IF
      * Setup message data for message
     C                   MOVEL     #1PNAM        ZA0006                         Program Name
      * Send message 'WARNING:Pgm called before'
     C                   MOVEL     'CBM0060'     ZAMSID
     C                   MOVEL     '*INFO  '     ZAMSTP                         Message type
     C                   EXSR      ZASNMS
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Save the last value of 'Call Program ?' to a hidden screen field
     C                   MOVEL     #RPCAL        #RHCAL                         Call Program ?
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #RPCAL        ZA0007                         Call Program ?
      * Send message 'Call Program must be Y/N'
     C                   MOVEL     'CBM0059'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * Program Name required
     C     #1PNAM        IFEQ      *BLANK                                       IF
     C                   SETON                                        9833      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Call Program ? required
     C     #RPCAL        IFEQ      *BLANK
     C     *IN51         ANDEQ     '1'
     C                   MOVE      'N'           #RPCAL
     C                   END                                                    FI
      *
     C     #RPCAL        IFEQ      *BLANK                                       IF
     C                   SETON                                        9834      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *================================================================
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   DFV2RC        BEGSR
      *================================================================
      * Validate subfile record relations
      *================================================================
      *================================================================
     CSR   DFEXIT        ENDSR
      /EJECT
     CSR   EAPRSF        BEGSR
      *================================================================
      * Update DBF from subfile
      *================================================================
      * Initialise subfile reload flag
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   MOVEL     'N'           W0RSF
     C                   END
      * Process all modified subfile records
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process modified subfile record
     C                   EXSR      EBPRSR
     C                   MOVEL     *BLANK        #1SEL
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      * If any errors, cancel reload
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           W0RSF             1
     C                   END
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   EBPRSR        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       98
      *
     C     W0PMD         IFEQ      'ADD'
      * Process add request
     C     #1SEL         IFNE      'D'
     C                   EXSR      DDNLRC
     C     W0NLR         IFNE      'Y'
     C                   EXSR      ECADRQ
     C                   END
     C                   END
     C                   ELSE
     C     #1SEL         IFEQ      'D'
      * Process delete request
     C                   EXSR      EDDLRQ
     C                   ELSE
      * Process change request
     C                   EXSR      EECHRQ
     C                   END
     C                   END
      * If error occurred on update, note the fact
     C     *IN98         IFEQ      '1'
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     ##RR          ##SFRC               99        *
     C                   END
     C                   ELSE
      * USER: Extra processing after DBF update
      * Reset screen values if call to initialisation program successful
      * prior to chgobj
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'                                        *IF
      * CASE: PGM.*Return code is *Normal
     C     W0RTN         IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           #RPCAL                         Call Program ?
     C                   MOVEL     'N'           #RHCAL                         Call Program ?
     C                   MOVEL     'Y'           #1PRVC                         Program Previou
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Switchable F - Ini - Switchable F - Init Pgm  *
     C                   EXSR      SACRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected
      * Screen errors
     C                   MOVEA     WKIND1        *IN(32)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
     C                   ELSE
      * DBF write successful
      * disable entry
     C                   SETON                                        87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete object - Switchable F - Init Pgm  *
     C                   EXSR      SBDLRC
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful
      * Screen errors
     C                   MOVEA     WKIND1        *IN(32)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
      * If record altered, reset subfile record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF delete successful
      * Blank out record and protect from entry
     C                   EXSR      MAIZ#1
      * disable entry
     C                   SETON                                        87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
      * Reload subfile
     C                   MOVEL     'Y'           W0RSF             1
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Call init pgm, and chgobj - Switchable F - Init Pgm  *
     C                   EXSR      SCCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Screen errors
     C                   MOVEA     WKIND1        *IN(32)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
      * Reset subfile record if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF update successful
      * Enable entry
     C                   SETOFF                                       87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACHMD        BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C     W0PMD         IFNE      'ADD'
     C                   MOVEL     'ADD'         W0PMD
     C                   SETON                                        51
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   SETOFF                                       51
     C                   END
     C                   EXSR      FBRQRL
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   GADSA1        BEGSR
      *================================================================
      * Set display attributes for Subfile record
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect keys if change mode or updated record
     C                   SETON                                        88        *
     C   89
     CANN87              SETOFF                                       88        *
     C                   MOVEL     *IN87         *IN78
     C                   MOVEL     '0'           *IN77
     C     #RDCAL        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
     C                   MOVEL     '0'           *IN79
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise subfile record
      *================================================================
      * Previous values
     C                   MOVEL     *BLANK        #1DBRC
     C                   MOVEL     P1SARN        #1SARN                         Switchable Feat
     C                   MOVEL     *BLANK        #RHPGM                         Highlight progr
     C                   MOVEL     *BLANK        #RHCAL                         Call Program ?
     C                   MOVEL     *BLANK        #RDCAL                         Display Call Pr
     C                   MOVEL     *BLANK        #RDESP                         Description of
     C                   MOVEL     *BLANK        #1TYL1                         Type of Last Ch
     C                   Z-ADD     *ZERO         #1LCD                          Last change dat
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1PNAM                         Program Name
     C                   MOVEL     *BLANK        #RPCAL                         Call Program ?
     C                   MOVEL     *BLANK        #1PRVC                         Program Previou
     C                   MOVEL     *BLANK        #1PDSC                         Program Descrip
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @SARPL1 fields to subfile
      *================================================================
     C                   MOVEL     AKSARN        #1SARN                         Switchable Feat
     C                   MOVEL     AKTYL1        #1TYL1                         Type of Last Ch
     C                   Z-ADD     AKLCD         #1LCD                          Last change dat
     C                   MOVEL     AKPNAM        #1PNAM                         Program Name
     C                   MOVEL     AKPRVC        #1PRVC                         Program Previou
     C                   MOVEL     AKPDSC        #1PDSC                         Program Descrip
      * Hold current record image for change detection
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     P1SARN        #2SARN                         Switchable Feat
     C                   MOVEL     P2SARD        #PSARD                         Description
     C                   MOVEL     *BLANK        #2PNAM                         Program Name
      * Check restriction within
     C                   EXSR      VACKRL
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Switchable F - Ini - Switchable F - Init Pgm  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @SARPL0
     C                   MOVEL     #1SARN        AKSARN                         Switchable Feat
     C                   MOVEL     #1PNAM        AKPNAM                         Program Name
     C                   MOVEL     'N'           AKPRVC                         Program Previou
     C                   MOVEL     #1PDSC        AKPDSC                         Program Descrip
     C                   MOVEL     'I'           AKTYL1                         Type of Last Ch
     C                   Z-ADD     WUAKTX        AKLCD                          Last change dat
      *
     C     KLCRSA        KLIST
     C                   KFLD                    AKSARN                         Switchable Feat
     C                   KFLD                    AKPNAM                         Program Name
      * Check for duplicate primary key
     C     KLCRSA        SETLL     @SARPL0                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CBM0057'     W0RTN             7
      * Send message 'Switchable F - Init Pg EX'
     C                   MOVEL     'CBM0057'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
     C                   WRITE     @SARPL0                              91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBDLRC        BEGSR
      *================================================================
      * Delete object - Switchable F - Init Pgm  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @SARPL0
     C                   MOVEL     #1SARN        AKSARN                         Switchable Feat
     C                   MOVEL     #1PNAM        AKPNAM                         Program Name
      *
     C     KLDLSB        KLIST
     C                   KFLD                    AKSARN                         Switchable Feat
     C                   KFLD                    AKPNAM                         Program Name
     C     KLDLSB        CHAIN     @SARPL0                            9091      *
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
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
     C     KLDLSB        SETLL     @SARPL0                            9091      *
     C                   GOTO      SBEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C                   DELETE    @SARPL0                              91      *
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Call init pgm, and chgobj - Switchable F - Init Pgm  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @SARPL0
     C                   MOVEL     #1SARN        AKSARN                         Switchable Feat
     C                   MOVEL     #1PNAM        AKPNAM                         Program Name
      *
     C     KLCHSC        KLIST
     C                   KFLD                    AKSARN                         Switchable Feat
     C                   KFLD                    AKPNAM                         Program Name
     C     KLCHSC        CHAIN     @SARPL0                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
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
     C                   UNLOCK    SCSARPL0                             91      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YARDCS
      * Move non-key fields to @SARPL0
     C                   MOVEL     #1PRVC        AKPRVC                         Program Previou
     C                   MOVEL     #1PDSC        AKPDSC                         Program Descrip
     C                   MOVEL     'A'           AKTYL1                         Type of Last Ch
     C                   Z-ADD     WUAKTX        AKLCD                          Last change dat
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * USER: Processing before Data update
      * Call Initialisation programs if requested to call is 'Y'
      * CASE: PAR.Call Program ? is Yes
     C     #RPCAL        IFEQ      'Y'                                          *IF
     C                   MOVEL     *BLANK        WURTCD                         Access Obj Retu
      * CASE: PAR.Program Previously Called is Not previously called
     C     #1PRVC        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           WUPMOD                         Initialisation
     C                   END                                                    *FI
      * CASE: PAR.Program Previously Called is Previously called
     C     #1PRVC        IFEQ      'Y'                                          *IF
     C                   MOVEL     '2'           WUPMOD                         Initialisation
     C                   END                                                    *FI
      * Call Initialisation Pgm - Standard functions  *
     C                   CALL      'SCC3090'                            90      Call Initialisa
     C                   PARM      AKPNAM        WQ0009           10            Program Name
     C     WURTCD        PARM      WURTCD        WQ0010            7            Access Obj Retu
     C                   PARM      WUPMOD        WQ0011            1            Initialisation
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SCC3090'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * CASE: WRK.Access Obj Return Code is Normal - no errors found
     C     WURTCD        IFEQ      *BLANK                                       *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     'Y'           AKPRVC                         Program Previou
      * Setup message data for message
     C                   MOVEL     AKPNAM        ZA0008                         Program Name
     C                   MOVEL     AKSARN        ZA0009                         Switchable Feat
      * Send message 'Init pgm call successful'
     C                   MOVEL     'CBM0063'     ZAMSID
     C                   MOVEL     '*INFO  '     ZAMSTP                         Message type
     C                   EXSR      ZASNMS
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     '*ERROR'      W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     AKPNAM        ZA0010                         Program Name
     C                   MOVEL     AKSARN        ZA0011                         Switchable Feat
      * Send message 'Init pgm call error'
     C                   MOVEL     'CBM0061'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98        *
      *
     C                   GOTO      SCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C                   UPDATE    @SARPL0                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SCSARPL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Check restriction within
      *================================================================
      *
     C     KLVAAB        KLIST
     C*********************KFLD***********ABSARN           Switchable Feat      CSC007
     C                   KFLD                    AXSARN                         Switchable Feat
      * Setup key
     C*********************MOVEL#2SARN    ABSARN           Switchable Feat      CSC007
     C                   MOVEL     #2SARN        AXSARN                         Switchable Feat
     C***********KLVAAB****CHAIN@SARDL1              9091  *                    CSC007
     C*****KLVAAB        CHAIN     SCSARSD0                           9091      *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARS                                                                        MD055681
     C+ from SCSRSJW0                                                                       MD055681
     C+ where AXSARN = :AXSARN                                                              MD055681
     C/END-EXEC                                                                             MD055681
     C******IN90         IFEQ      '0'                                                      MD055681
     C                   IF        SQLCODE = 0                                              MD055681
      * Record found - move back any virtuals
     C                   GOTO      VAEXIT
     C                   END
      * Restrictor relation not satisfied
      * Send message 'Switchable Features    NF'
     C                   MOVEL     'CBM0004'     ZAMSID
     C                   MOVEL     '*PRV '       ZAPGRL                         Rel queue
     C                   EXSR      ZASNMS
     C                   MOVEL     'CBM0004'     P0RTN
     C                   EXSR      ZYEXPG
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
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
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
     C                   PARM      *ZERO         YYLGCT            5 0          # of grps
     C                   PARM      *BLANK        YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program: Normal
      *================================================================
      * USER: Exit program processing
      * CASE: CTL.*CMD key is *Exit
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
      * Define work field Program Name
     C                   MOVEL     *BLANK        WUPNAM           10
      * Define work field Program Description
     C                   MOVEL     *BLANK        WUPDSC           50
      * Define work field Access Obj Return Code
     C                   MOVEL     *BLANK        WURTCD            7
      * Obtain default message file
     C     *DTAARA       DEFINE    CBMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field run day number
     C                   Z-ADD     *ZERO         WUAKTX            5 0
      * Define work field Initialisation Pgm mode
     C                   MOVEL     *BLANK        WUPMOD            1
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WUAANA            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUAUST            1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUE3ST            1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUF1ST            1
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
     C                   OPEN      SC3090M#
     C                   OPEN      SCSARPL1
     C*********************OPEN SCSARDL1                                        CSC007
     C**********         OPEN      SCSARSL1                                                 MD055681
     C                   OPEN      SCSARPL0
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     03            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      * Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *................................................................
      * Set to *CHANGE mode
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     'Y'           W0APM             1
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * SC3090M Precompiler - Switchable F - Init Pgm  *
      * Copyright Statement 1993 - Standard functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##AANA            7
     C                   MOVE      MRDT          WUAANA
     C                   MOVE      RDNB          WUAKTX
     C                   MOVE      SUC           WUAUST
     C                   MOVE      DFF           WUE3ST
     C                   MOVE      MBIN          WUF1ST
      * Initialise subfile control
     C                   EXSR      MEIZ#2
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
     C/COPY WNCPYSRC,SC3090MPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SC3090MPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD055681
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055681
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SC3090MPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001
