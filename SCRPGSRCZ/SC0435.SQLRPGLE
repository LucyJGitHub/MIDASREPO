     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC SAR maintenance non-core ADD screen')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC0435  - Duplicate of SC3010M but called in ADD (not CHG)   *
      *            mode                                               *
      *                                                               *
      *  THIS PROGRAM SHOULD BE DELETED AT DBAR3                      *
      *                                                               *
      *  Function:  This function allows non-core to switch on        *
      *             switchable features without using passwords.      *
      *             This program is a duplicate of SC3010M,           *
      *             with the exception  of the amendments             *
      *             under CSC008. It is to be used as a transitional  *
      *             program for those non-core users who do not wish  *
      *             to use passwords to switch on their switchable    *
      *             features. The program is called in ADD mode       *
      *             rather than CHANGE mode, meaning that features    *
      *             and their descriptions must be typed in directly  *
      *             from the keyboard and will be immediately         *
      *             activated. FROM DBAR3 THIS PROGRAM WILL BE        *
      *             REDUNDANT, as non-core will be expected to        *
      *             use passwords by this time.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10771           Date 12Apr06               *
      *                 CPK025             Date 16May06               *
      *                 CSD027             Date 09Dec05               *
      *                 222373             Date 04Nov03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 05Oct01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 180547             Date 21Jun00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSC010             Date 17Jun99               *
      *                 CSC008             Date 15May98               *
      *                 S01486             Date 21OCT94               *
      *                 S01488             Date 08AUG94               *
      *                 S01459             Date 08AUG94               *
      *                 S01430                  07JUL93               *
      *                 S01407                  20JAN93               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG10771 - Re-introduced in MP121 adn upgraded with this fix *
      *             Automatically replicate SFMENUPD to GZSFMENUPD    *
      *             and SCSARDPD to GZSCSARDPD. Then, call APCCRTNDFL.*
      *  CPK025 - MidasPlus 1.3 packaging.  /COPYs have changed.      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  222373 - Parameter Mismatch                                  *
      *  CPK014 - Release 4 packaging:                                *
      *           - Remove references to SC3070M.                     *
      *  180547 - SC0435 fails to add more than 1 non-core switch feat*
      *  CSC008 - This program should be deleted at DBAR3             *
      *           when the password switchable feature ceases to      *
      *           become an option.                                   *
      *  S01486 - Validation added to prevent internal switchable     *
      *           features from being inserted or deleted.            *
      *  S01488 - Addition of switchable features insert/delete       *
      *           precheck.                                           *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *  S01430 - Switchability Enhancements Phase 2:                 *
      *           - Inclusion of switchable feature initialisation    *
      *             programs.                                         *
      *  S01407 - Switchability Enhancements.                         *
      *                                                               *
      *****************************************************************
     FSC3011M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SC Switchable features maintenance
      *
     F*SCSARDL1* IF   E           K DISK    USROPN                                          MD055681
     F**********                           INFDS(INFDS1)                                    MD055681
     F**********                           INFSR(*PSSR)                                     MD055681
      * RTV : Midas SC Switchable features description
      *
     FSCSARPL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Midas SC Switchable f - initialisation pgm
      *
     F*SCSARDL0* UF A E           K DISK    USROPN                                          MD055681
     F**********                           INFDS(ID0002)                                    MD055681
     F**********                           INFSR(*PSSR)                                     MD055681
      * UPD : Midas SC Switchable features description
     F*SCSARZL1* UF A E           K DISK                                         CSC010     MD055681
     F**********                           INFSR(*PSSR)                                     MD055681
      *
     D ARNA            S             78    DIM(2) CTDATA PERRCD(1)
      *
      ** Change mode                                                      S01229
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
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D*@1DBRC***     E DS                  EXTNAME(SCSARDL0)                                MD055681
     D @1DBRC        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D                                     PREFIX(AB)                                       MD055681
      * UPD : Midas SC Switchable features description
      * Current/previous master file format fields for change control
      *
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D YRSW0A          DS          9999
     D YRSW0B          DS          9999
     D YRSW0C          DS          9999
     D YRSW0D          DS          9999
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Internal feature not vald'
      * Switchable Feature Number
     D  ZA0001                 1      6
      * Message data for 'Switch F Rept - One'
      * Switchable Feature Number
     D  ZA0002                 1      6
      * Message data for 'SwitchF Descr not entered'
      * Description
     D  ZA0003                 1     50
      * Message data for 'S/Feature cannot be added'
      * Switchable Feature Number
     D  ZA0004                 1      6
      * Message data for 'S/Feature cannot be delet'
      * Switchable Feature Number
     D  ZA0005                 1      6
      * Message data for 'Internal feature not vald'
      * Switchable Feature Number
     D  ZA0006                 1      6
      * Message data for 'Init pgm call successful'
      * Program Name
     D  ZA0007                 1     10
      * Switchable Feature Number
     D  ZA0008                11     16
      * Message data for 'Init pgm call error'
      * Program Name
     D  ZA0009                 1     10
      * Switchable Feature Number
     D  ZA0010                11     16
      * Message data for 'Init pgm call error once'
      * Switchable Feature Number
     D  ZA0011                 1      6
     D WXFLRN          C                   CONST('ABSENG/DBAR4')                   CSC010
     D WXDOCN          C                   CONST('FEATURE.D02')                    CSC010
     D WXHELP          C                   CONST('NODETAIL')                       CSC010
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D**                                   PREFIX(AB)                                       MD055681
     D SCSARS        E DS                  EXTNAME(SCSRSJW0)                                MD055681
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
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
     C     *LIKE         DEFINE    #2SARN        WZSARN
     C                   MOVEL     #2SARN        WZSARN                         Switchable Feat
     C     KPOS          KLIST
     C                   KFLD                    ABSARN                         Switchable Feat
      * Setup key
     C                   MOVEL     #2SARN        ABSARN                         Switchable Feat
      * 82=EOF
     C*****KPOS*         SETLL     @SARDL1                            82        *
      * 82=EOF                                                                              MD055681
     C**N82*****         READ      @SARDL1                              9182    *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ declare ACursor insensitive scroll cursor for                                       MD055681
     C+ select * from SCSRDJW0                                                              MD055681
     C+ where SARN >= :#2SARN                                                               MD055681
     C+ order by SARN                                                                       MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ open ACursor                                                                        MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from ACursor into :SCSARD                                                MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C                   SETOFF                                       82                    MD055681
     C                   If        SQLCODE = 100                                            MD055681
     C                   SETON                                        82                    MD055681
     C                   Endif                                                              MD055681
     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      * Load subfile page
     C                   EXSR      BBLDSF
      * If no records (first time only), switch to add mode and load agai
     C     W0APM         IFEQ      'Y'
     C     ##RR          ANDEQ     *ZERO
     C                   MOVEL     'ADD'         W0PMD
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
     C**N82*****         READP     @SARDL1                                90    *           MD055681
     C**N82*****         READ      @SARDL1                                90    *           MD055681
     C     *IN82         IFEQ      '0'                                                      MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch prior from ACursor into :SCSARD                                               MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from ACursor into :SCSARD                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   ENDIF                                                              MD055681
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
     C**N82##RROK        DOWLT     ##SFLN                                       DO          MD055681
     C                   DOW       SQLCODE = 0                                              MD055681
     C                             and ##RROK < ##SFLN                                      MD055681
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
      * Load additonal footer text
      * SC3010M Additional Footer - Switchable Features  *
     C     W0PMD         IFNE      'ADD'                                                       S0122
     C                   MOVEA     ARNA(2)       ##ARNA                                        S0122
     C                   ELSE
     C                   MOVE      *BLANKS       ##ARNA                                        S0122
     C                   END
      *
      * If record dropped...
     C                   SUB       1             ##RR
     C     W0RSL         CABNE     'Y'           BB020
     C                   ADD       1             ##RR
      * Validate subfile record and calculate derived fields
     C                   EXSR      DFV2RC
     C                   ELSE
      * USER: Initialize subfile record (new record)
      * Do not load additional footer text
      * SC3010M Additional Footer - Switchable Features  *
     C     W0PMD         IFNE      'ADD'                                                       S0122
     C                   MOVEA     ARNA(2)       ##ARNA                                        S0122
     C                   ELSE
     C                   MOVE      *BLANKS       ##ARNA                                        S0122
     C                   END
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
     C**********         READ      @SARDL1                                82    *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from ACursor into :SCSARD                                                MD055681
     C/END-EXEC                                                                             MD055681
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
     C     WZSARN        CASNE     #2SARN        FBRQRL                         Switchable Feat
     C                   END
     C                   END
      * USER: Validate subfile control
      * F11=Print Pressed
      * CASE: CTL.*CMD key is CF11
     C     *IN11         IFEQ      '1'                                          *IF
      * Print  Switchable F - All - Switchable Features  *
     C                   CALL      'SC3010P'                            90      Print  Switchab
     C                   PARM      *BLANK        W0RTN             7
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3010P'     W0CLPG
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
      * Send message 'Switch F Rept - All'
     C                   MOVEL     'CBM0035'     ZAMSID
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
     C***09****************EXSR FACHMD                                   CSC008
     C   09              EXSR      ZXEXPG                                                     CSC008
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
     C     #1SARN        CABNE     *BLANK        DDEXIT                         Switchable Feat
     C     #1SARD        CABNE     *BLANK        DDEXIT                         Description
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * USER: Validate subfile record fields
      * Start of change S01486.
      * Insert prechecking
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
      * Internal feature numbers may not be inserted by this function.
     C                   Z-ADD     2             YRSW03
     C                   Z-ADD     2             ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00006
     C     ZQ            ORGT      00006
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  #1SARN:ZQ     WUIFCF                 90      Int Feature Che
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
      * Check for an internal feature number.
      * CASE: WRK.Int Feature Check Field is Internal feature list
     C     WUIFCF        IFEQ      'QQ'                                         *IF
      * Setup message data for message
     C                   MOVEL     #1SARN        ZA0001                         Switchable Feat
      * Send message 'Internal feature not vald'
     C                   MOVEL     'CBM0103'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of change S01486.
      * If Select field has a Switchable Feature value
      * CASE: RCD.*SFLSEL is Switchable Features Value
     C     #1SEL         IFEQ      '2'                                          *IF
     C     #1SEL         OREQ      '6'
     C     #1SEL         OREQ      '5'
     C     #1SEL         OREQ      '3'
     C     #1SEL         OREQ      'D'
     C     #1SEL         OREQ      'P'
     C********** #1SEL     OREQ '4'                                                           CPK014
     C     #1SEL         OREQ      '7'
     C     #1SEL         OREQ      '8'
      * Print Switchable Feature - One
      * CASE: RCD.*SFLSEL is Print
     C     #1SEL         IFEQ      'P'                                          *IF
      * Print  Switchable F - One - Switchable Features  *
     C                   CALL      'SC3010P'                            90      Print  Switchab
     C                   PARM      *BLANK        W0RTN             7
     C**********           PARM #1SARN    WQ0001  6        Switchable Feat                    222373
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3010P'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9833      *
     C                   END
      * Setup message data for message
     C                   MOVEL     #1SARN        ZA0002                         Switchable Feat
      * Send message 'Switch F Rept - One'
     C                   MOVEL     'CBM0036'     ZAMSID
     C                   MOVEL     '*INFO  '     ZAMSTP                         Message type
     C                   EXSR      ZASNMS
      *
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
      * Switchable Features by COB Components
      * CASE: RCD.*SFLSEL is COB Components
     C     #1SEL         IFEQ      '2'                                          *IF
      * Switchable F - COB Compnt - Switchable F - COB Compnt  *
     C                   CALL      'SC3020M'                            90      Edit   Switchab
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1SARN        WQ0002            6            Switchable Feat
     C                   PARM      #1SARD        WQ0003           50            Description
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3020M'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983334    *
     C                   END
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
      * Switchable Features by Report Name
      * CASE: RCD.*SFLSEL is Report Names
     C     #1SEL         IFEQ      '3'                                          *IF
      * Edit   Switchable F - Rep - Switchable F - Rep Name  *
     C                   CALL      'SC3030M'                            90      Edit   Switchab
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1SARN        WQ0004            6            Switchable Feat
     C                   PARM      #1SARD        WQ0005           50            Description
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3030M'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983334    *
     C                   END
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
      **Switchable*Features*by*Journal*Files*********************************                 CPK014
      **CASE:*RCD.*SFLSEL*is*Journal*Files***********************************                 CPK014
     C********** #1SEL     IFEQ '4'                        *IF                                CPK014
      **Edit***Switchable*F*-*PF*-*Switchable*F*-*Objects*** ****************                 CPK014
     C**********           CALL 'SC3070M'              90  Edit   Switchab                    CPK014
     C**********           PARM *BLANK    W0RTN   7                                           CPK014
     C**********           PARM #1SARN    WQ0006  6        Switchable Feat                    CPK014
     C**********           PARM #1SARD    WQ0007 50        Description                        CPK014
      **********                                                                              CPK014
     C********** *IN90     IFEQ '1'                                                           CPK014
      **Call*to*program*ended*in*error***************************************                 CPK014
     C**********           MOVEL'Y2U0032' W0RTN                                               CPK014
     C**********           MOVEL*BLANKS   W0CLPG 10                                           CPK014
     C**********           MOVEL'SC3070M' W0CLPG                                              CPK014
      **Send*message*'*Error*occured*on*CALL...'*****************************                 CPK014
     C**********           MOVEL'Y2U0032' ZAMSID                                              CPK014
     C**********           MOVEL'Y2USRMSG'ZAMSGF                                              CPK014
     C**********           MOVELW0CLPG    ZAMSDA           Message data                       CPK014
     C**********           EXSR ZASNMS                                                        CPK014
     C**********           END                                                                CPK014
      **********                                                                              CPK014
      **Error*detected?******************************************************                 CPK014
     C********** W0RTN     IFNE *BLANK                                                        CPK014
     C**********           SETON                     983334*                                  CPK014
     C**********           END                                                                CPK014
      **CASE:*PGM.*Return*code*is**User*QUIT*requested***********************                 CPK014
     C********** W0RTN     IFEQ 'Y2U9999'                  *IF                                CPK014
     C**********           MOVEL*BLANK    W0RTN            *Return code                       CPK014
     C**********           MOVELW0RTN     P0RTN            *Return code                       CPK014
     C**********           EXSR ZYEXPG                                                        CPK014
     C**********           END                             *FI                                CPK014
     C**********           MOVEL'Y'       W0RSF            *Reload subfile                    CPK014
     C**********           END                             *FI                                CPK014
      * Switchable Features by Report Components
      * CASE: RCD.*SFLSEL is Report Components
     C     #1SEL         IFEQ      '5'                                          *IF
      * Switchable F - Rep Compnt - Switchable F - Rep Compnt  *
     C                   CALL      'SC3050M'                            90      Edit   Switchab
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1SARN        WQ0008            6            Switchable Feat
     C                   PARM      #1SARD        WQ0009           50            Description
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3050M'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983334    *
     C                   END
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
      * Switchable Features by Menu Items
      * CASE: RCD.*SFLSEL is Menu Items
     C     #1SEL         IFEQ      '6'                                          *IF
      * Edit   Switchable F - Men - Switchable F - Menu Items  *
     C                   CALL      'SC3060M'                            90      Edit   Switchab
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1SARN        WQ0010            6            Switchable Feat
     C                   PARM      #1SARD        WQ0011           50            Description
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3060M'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983334    *
     C                   END
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
      * Switchable Features by Report Print Files
      * CASE: RCD.*SFLSEL is Report Print Files
     C     #1SEL         IFEQ      '7'                                          *IF
      * Edit   Switchable F -PRTF - Switchable F - Objects  *
     C                   CALL      'SC3080M'                            90      Edit   Switchab
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1SARN        WQ0012            6            Switchable Feat
     C                   PARM      #1SARD        WQ0013           50            Description
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3080M'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983334    *
     C                   END
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
      * //Start of S01430 - Include Initialisation Programs
      * Switchable Features by Initialisation Programs
      * CASE: RCD.*SFLSEL is Initialisation Programs
     C     #1SEL         IFEQ      '8'                                          *IF
      * Edit   Switchable F - Ini - Switchable F - Init Pgm  *
     C                   CALL      'SC3090M'                            90      Edit   Switchab
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1SARN        WQ0014            6            Switchable Feat
     C                   PARM      #1SARD        WQ0015           50            Description
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3090M'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983334    *
     C                   END
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
      * //End of S01430 - Include Initialisation Programs
     C                   END                                                    *FI
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * Switchable Feature Number required
     C     #1SARN        IFEQ      *BLANK                                       IF
     C                   SETON                                        9833      *
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
      * USER: Validate subfile record relations
      * Validate Switchable Feature Description
      * CASE: RCD.Description is Blank
     C     #1SARD        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1SARD        ZA0003                         Description
      * Send message 'SwitchF Descr not entered'
     C                   MOVEL     'CBM0043'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
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
      * //Start of S01430 - Include Initialisation Programs
      * If inserting feature, check if initialisation programs
      * exist for feature. If so, call the maintenance program for
      * the initialisation programs so that the user is prompted to
      * call those programs
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
      * Rtv init pgm - Switchable F - Init Pgm  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Normal
     C     W0RTN         IFEQ      *BLANK                                       *IF
      * Edit   Switchable F - Ini - Switchable F - Init Pgm  *
     C                   CALL      'SC3090M'                            90      Edit   Switchab
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1SARN        WQ0016            6            Switchable Feat
     C                   PARM      #1SARD        WQ0017           50            Description
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3090M'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983334    *
     C                   END
      * If CF3 was pressed, do not exit but return to subfile program
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   END                                                    *FI
     C                   END                                                    *FI
      * //End of S01430 - Include Initialisation Programs
      * Start of change S01488.
      * Validate delete return code.
      * CASE: WRK.*Return code is Refuse
     C     WURTN         IFEQ      'REFUSE'                                     *IF
      * Re-initialise fields - Switchable Features  *
     C                   MOVEL     WWSARN        #1SARN                         Switchable Feat
     C                   MOVEL     WWSARD        #1SARD                         Description
     C                   Z-ADD     WWLCD         #1LCD                          Last change dat
     C                   MOVEL     WWTYLC        #1TYLC                         Type of the Las
     C                   END                                                    *FI
      * End of change S01488.
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Switchable Feature - Switchable Features  *
     C                   EXSR      SBCRRC
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
      * Call initpgm, del feature - Switchable Features  *
     C                   EXSR      SCDLRC
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
      * Change Switchable Feature - Switchable Features  *
     C                   EXSR      SECHRC
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
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
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
     C                   MOVEL     *IN87         *IN79
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise subfile record
      *================================================================
      * Previous values
     C                   MOVEL     *BLANK        #1DBRC
     C                   MOVEL     *BLANK        #RSSAR                         Select Feature
     C                   Z-ADD     *ZERO         #1LCD                          Last change dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of the Las
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1SARN                         Switchable Feat
     C                   MOVEL     *BLANK        #1SARD                         Description
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @SARDL1 fields to subfile
      *================================================================
     C                   Z-ADD     ABLCD         #1LCD                          Last change dat
     C                   MOVEL     ABTYLC        #1TYLC                         Type of the Las
     C                   MOVEL     ABSARN        #1SARN                         Switchable Feat
     C                   MOVEL     ABSARD        #1SARD                         Description
      * Hold current record image for change detection
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2SARN                         Switchable Feat
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Rtv init pgm - Switchable F - Init Pgm  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    AKSARN        WQSA01                         Switchable Feat
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    WQSA01                         Switchable Feat
      * Move fields to key list
     C                   MOVEL     #1SARN        WQSA01                         Switchable Feat
     C     KRSSA         SETLL     @SARPL1                                      *
     C     KRSSA         READE     @SARPL1                                90    *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'CBM0056'     W0RTN             7
      * USER: Processing if Data record not found
      * If no initialisation programs found for the switchable feature
      * then the program return code is 'record not found *NRF'
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     '*NRF'        W0RTN                          *Return code
     C                   GOTO      SAEXIT                                       *QUIT
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * If at least one initialisation program exists for the switchable
      * feature, the program return code is normal
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   GOTO      SAEXIT                                       *QUIT
     C     KRSSA         READE     @SARPL1                                90    *
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCRRC        BEGSR
      *================================================================
      * Create Switchable Feature - Switchable Features  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @SARDL0
     C                   MOVEL     #1SARN        ABSARN                         Switchable Feat
     C                   MOVEL     #1SARD        ABSARD                         Description
     C                   Z-ADD     WUAKTX        ABLCD                          Last change dat
     C                   MOVEL     'I'           ABTYLC                         Type of the Las
      *
      * USER: Processing before Data update
      * Start of change S01486.
      * Internal feature numbers may not be inserted by this function.
     C                   Z-ADD     2             YRSW03
     C                   Z-ADD     2             ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00006
     C     ZQ            ORGT      00006
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  #1SARN:ZQ     WUIFCF                 90      Int Feature Che
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
      * Check for an internal feature number.
      * CASE: WRK.Int Feature Check Field is Internal feature list
     C     WUIFCF        IFEQ      'QQ'                                         *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     'REFUSE'      W0RTN                          *Return code
     C                   END                                                    *FI
      * End of change S01486.
      * Start of change S01488.
      * Save screen fields - Switchable Features  *
     C                   MOVEL     #1SARN        WWSARN            6            Switchable Feat
     C                   MOVEL     #1SARD        WWSARD           50            Description
     C                   Z-ADD     #1LCD         WWLCD             5 0          Last change dat
     C                   MOVEL     #1TYLC        WWTYLC            1            Type of the Las
      * Switchable Feature Prechk - Switchable Features  *
     C                   CALL      'SC3010X'                            90      Switchable Feat
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      'I'           WQ0018            1            Action Code
     C                   PARM      #1SARN        WQ0019            6            Switchable Feat
     C     WUAIDF        PARM      *BLANK        WQ0020            1            Allow INS/DEL o
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3010X'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9833      *
     C                   END
      * Check pre-checks return code.
      * CASE: WRK.Allow INS/DEL of Feature is Refuse insert/delete
     C     WUAIDF        IFEQ      'N'                                          *IF
      * Seton W0RTN for preckecks - Switchable Features  *
     C                   MOVEL     *BLANKS       W0RTN
     C                   MOVEL     'REFUSE'      W0RTN
     C                   MOVEL     *BLANK        WURTN                          *Return code
     C                   MOVEL     'REFUSE'      WURTN                          *Return code
      * Setup message data for message
     C                   MOVEL     #1SARN        ZA0004                         Switchable Feat
      * Send message 'S/Feature cannot be added'
     C                   MOVEL     'CBM0100'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   GOTO      SBEXIT                                       *QUIT
     C                   END                                                    *FI
      * End of change S01488.
     C     KLCRSB        KLIST
     C                   KFLD                    ABSARN                         Switchable Feat
      * Check for duplicate primary key
     C*****KLCRSB        SETLL     @SARDL0                                90    *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = :ABSARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   SETOFF                                       90                    MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C                   SETON                                        90                    MD055681
     C                   ENDIF                                                              MD055681
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CBM0005'     W0RTN             7
      * Send message 'Switchable Features    EX'
     C                   MOVEL     'CBM0005'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C**********         WRITE     @SARDL0                              91      *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRDBTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   SARN                                                                              MD055681
     C+ , SARD                                                                              MD055681
     C+ , LCD                                                                               MD055681
     C+ , TYLC                                                                              MD055681
     C+ , ZONE                                                                              MD055681
     C+ , ENABLD                                                                            MD055681
     C+ , MODE                                                                              MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :ABSARN                                                                           MD055681
     C+ , :ABSARD                                                                           MD055681
     C+ , :ABLCD                                                                            MD055681
     C+ , :ABTYLC                                                                           MD055681
     C+ , ' '                                                                               MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRDXTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   SARN                                                                              MD055681
     C+ , LCD                                                                               MD055681
     C+ , TYLC                                                                              MD055681
     C+ , ZONE                                                                              MD055681
     C+ , ENABLD                                                                            MD055681
     C+ , MODE                                                                              MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :ABSARN                                                                           MD055681
     C+ , :ABLCD                                                                            MD055681
     C+ , :ABTYLC                                                                           MD055681
     C+ , ' '                                                                               MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C                   CALL      'SC0434'                                             CSC010
     C                   PARM                    WXRELL           10                    CSC010
     C                   PARM                    WXIREL            3                    CSC010
     C                   PARM                    PRTN              7                    CSC010
     C*****ABSARN        CHAIN     SCSARZL1                           72             CSC010 MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRSJW0                                                                       MD055681
     C+ where SARN = :ABSARN  and AXMODE = 'B'                                              MD055681
     C/END-EXEC                                                                             MD055681
     C                   MOVEL     ABSARN        AXSARN                                 CSC010
     C                   MOVEL     ABSARD        AXSARD                                 CSC010
     C                   MOVEL     'B'           AXMNTB                                 CSC010
     C                   MOVEL     WXFLRN        AXFLRN                                 CSC010
     C                   MOVEL     WXDOCN        AXDOCN                                 CSC010
     C                   MOVEL     WXHELP        AXHELP                                 CSC010
     C                   MOVEL     WXRELL        AXRELL                                 CSC010
     C                   MOVEL     WXIREL        AXIREL                                 CSC010
     C********** *IN72     IFEQ *OFF                               CSC010  180547
     C**********           UPDATSCSARSD0               73          CSC010  180547
     C**********           ELSE                                    CSC010  180547
     C**********         WRITE     SCSARSD0                             73           CSC010 MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRSBTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   AXSARN                                                                            MD055681
     C+ , AXSARD                                                                            MD055681
     C+ , AXPRIM                                                                            MD055681
     C+ , AXCEMI                                                                            MD055681
     C+ , AXRELL                                                                            MD055681
     C+ , AXIREL                                                                            MD055681
     C+ , AXCLVL                                                                            MD055681
     C+ , AXRSTS                                                                            MD055681
     C+ , AXDFLT                                                                            MD055681
     C+ , AXMNTB                                                                            MD055681
     C+ , AXCHRG                                                                            MD055681
     C+ , AXFLRN                                                                            MD055681
     C+ , AXDOCN                                                                            MD055681
     C+ , AXHELP                                                                            MD055681
     C+ , AXPROT                                                                            MD055681
     C+ , AXMODE                                                                            MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :AXSARN                                                                           MD055681
     C+ , :AXSARD                                                                           MD055681
     C+ , :AXPRIM                                                                           MD055681
     C+ , :AXCEMI                                                                           MD055681
     C+ , :AXRELL                                                                           MD055681
     C+ , :AXIREL                                                                           MD055681
     C+ , :AXCLVL                                                                           MD055681
     C+ , :AXRSTS                                                                           MD055681
     C+ , :AXDFLT                                                                           MD055681
     C+ , :AXMNTB                                                                           MD055681
     C+ , :AXCHRG                                                                           MD055681
     C+ , :AXFLRN                                                                           MD055681
     C+ , :AXDOCN                                                                           MD055681
     C+ , :AXHELP                                                                           MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRSXTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   AXSARN                                                                            MD055681
     C+ , AXMODE                                                                            MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :AXSARN                                                                           MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C**********           ENDIF                                   CSC010  180547
     C********** *IN73     IFEQ *OFF                               CSC010  180547
     C**********           EXSR *PSSR                              CSC010  180547
     C**********           ENDIF                                   CSC010  180547
      *
     C******IN91         IFEQ      '1'                                                      MD055681
     C                   IF        SQLCODE <> 0                                             MD055681
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                     BUG10771
      * Call SCC0430 to replicate SFMENUPD to GZSFMENUPD and                                BUG10771
      *      SCSARDPD to GZSCSARDPD. Then, call APCCRTNDFL.                                 BUG10771
      *                                                                                     BUG10771
     C                   CALL      'SCC0430'
      *                                                                                     BUG10771
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCDLRC        BEGSR
      *================================================================
      * Call initpgm, del feature - Switchable Features  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
      * Start of change S01488.
      * Save screen fields - Switchable Features  *
     C                   MOVEL     #1SARN        WWSARN            6            Switchable Feat
     C                   MOVEL     #1SARD        WWSARD           50            Description
     C                   Z-ADD     #1LCD         WWLCD             5 0          Last change dat
     C                   MOVEL     #1TYLC        WWTYLC            1            Type of the Las
      * Switchable Feature Prechk - Switchable Features  *
     C                   CALL      'SC3010X'                            90      Switchable Feat
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      'D'           WQ0021            1            Action Code
     C                   PARM      #1SARN        WQ0022            6            Switchable Feat
     C     WUAIDF        PARM      *BLANK        WQ0023            1            Allow INS/DEL o
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SC3010X'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9833      *
     C                   END
      * Check pre-checks return code.
      * CASE: WRK.Allow INS/DEL of Feature is Refuse insert/delete
     C     WUAIDF        IFEQ      'N'                                          *IF
     C                   MOVEL     *BLANK        WURTN                          *Return code
     C                   MOVEL     'REFUSE'      WURTN                          *Return code
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     'REFUSE'      W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     #1SARN        ZA0005                         Switchable Feat
      * Send message 'S/Feature cannot be delet'
     C                   MOVEL     'CBM0101'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   GOTO      SCEXIT                                       *QUIT
     C                   END                                                    *FI
      * End of change S01488.
      * Start of change S01486.
      * Internal feature numbers may not be deleted by this function.
     C                   Z-ADD     2             YRSW03
     C                   Z-ADD     2             ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00006
     C     ZQ            ORGT      00006
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  #1SARN:ZQ     WUIFCF                 90      Int Feature Che
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
      * Check for an internal feature number.
      * CASE: WRK.Int Feature Check Field is Internal feature list
     C     WUIFCF        IFEQ      'QQ'                                         *IF
      * Setup message data for message
     C                   MOVEL     #1SARN        ZA0006                         Switchable Feat
      * Send message 'Internal feature not vald'
     C                   MOVEL     'CBM0103'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     'REFUSE'      W0RTN                          *Return code
     C                   GOTO      SCEXIT                                       *QUIT
     C                   END                                                    *FI
      * End of change S01486.
      * //Start of S01430 - Include Initialisation Programs
      * Call Initialisation programs in delete mode before trying
      * to delete the Switchable Feature
      * Rtv and call init pgm - Switchable F - Init Pgm  *
     C                   EXSR      SDRVGN
      * CASE: PGM.*Return code is *Normal
     C     W0RTN         IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1SARN        ZA0011                         Switchable Feat
      * Send message 'Init pgm call error once'
     C                   MOVEL     'CBM0065'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   GOTO      SCEXIT                                       *QUIT
     C                   END                                                    *FI
      * //End of S01430 - Include Initialisation Programs
      * Move key fields to @SARDL0
     C                   MOVEL     #1SARN        ABSARN                         Switchable Feat
      *
     C     KLDLSC        KLIST
     C                   KFLD                    ABSARN                         Switchable Feat
     C*****KLDLSC        CHAIN     @SARDL0                            9091      *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = :ABSARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   SETOFF                                       9091                  MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   SETON                                        90                    MD055681
     C                   ENDIF                                                              MD055681
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055681
     C                   SETON                                        91                    MD055681
     C                   ENDIF                                                              MD055681
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
     C                   eval      @1DBRC = SCSARD                                          MD055681
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C*****KLDLSC        SETLL     @SARDL0                            9091      *           MD055681
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C**********         DELETE    @SARDL0                              91      *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete from SCSRDBTD                                                                MD055681
     C+ where SARN = :ABSARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete from SCSRDXTD                                                                MD055681
     C+ where SARN = :ABSARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C******IN91         IFEQ      '1'                                                      MD055681
     C                   IF        SQLCODE <> 0                                             MD055681
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDRVGN        BEGSR
      *================================================================
      * Rtv and call init pgm - Switchable F - Init Pgm  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    AKSARN        WQSD01                         Switchable Feat
      * Define keylist
     C     KRSSD         KLIST
     C                   KFLD                    WQSD01                         Switchable Feat
      * Move fields to key list
     C                   MOVEL     #1SARN        WQSD01                         Switchable Feat
     C     KRSSD         SETLL     @SARPL1                                      *
     C     KRSSD         READE     @SARPL1                                90    *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'CBM0056'     W0RTN             7
      * USER: Processing if Data record not found
      * If no initialisation programs exist for the switchable feature
      * then ensure the program return code is normal, and quit
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   GOTO      SDEXIT                                       *QUIT
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * Call Initialisation program when deleting a switchable feature;
      * the mode of the Initialisation program is Delete mode
     C                   MOVEL     AKPNAM        WUPNAM                         Program Name
     C                   MOVEL     *BLANK        WURTCD                         Access Obj Retu
     C                   MOVEL     '3'           WUPMOD                         Initialisation
      * Call Initialisation Pgm - Standard functions  *
     C                   CALL      'SCC3090'                            90      Call Initialisa
     C                   PARM      WUPNAM        WQ0024           10            Program Name
     C     WURTCD        PARM      WURTCD        WQ0025            7            Access Obj Retu
     C                   PARM      WUPMOD        WQ0026            1            Initialisation
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
      * Setup message data for message
     C                   MOVEL     AKPNAM        ZA0007                         Program Name
     C                   MOVEL     #1SARN        ZA0008                         Switchable Feat
      * Send message 'Init pgm call successful'
     C                   MOVEL     'CBM0063'     ZAMSID
     C                   MOVEL     '*INFO  '     ZAMSTP                         Message type
     C                   EXSR      ZASNMS
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     AKPNAM        ZA0009                         Program Name
     C                   MOVEL     #1SARN        ZA0010                         Switchable Feat
      * Send message 'Init pgm call error'
     C                   MOVEL     'CBM0061'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     '*ERROR'      W0RTN                          *Return code
     C                   END                                                    *FI
     C     KRSSD         READE     @SARPL1                                90    *
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Switchable Feature - Switchable Features  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @SARDL0
     C                   MOVEL     #1SARN        ABSARN                         Switchable Feat
      *
     C     KLCHSE        KLIST
     C                   KFLD                    ABSARN                         Switchable Feat
     C*****KLCHSE        CHAIN     @SARDL0                            9091      *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = :ABSARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   SETOFF                                       9091                  MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   SETON                                        90                    MD055681
     C                   ENDIF                                                              MD055681
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055681
     C                   SETON                                        91                    MD055681
     C                   ENDIF                                                              MD055681
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SEEXIT
     C                   END
      *
      * Check for changed record
     C                   eval      @1DBRC = SCSARD                                          MD055681
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C*****KLCHSE        SETLL     @SARDL0                            9091      *           MD055681
     C                   GOTO      SEEXIT
     C                   END                                                    FI #1DBRC
      * Move non-key fields to @SARDL0
     C                   MOVEL     #1SARD        ABSARD                         Description
     C                   Z-ADD     WUAKTX        ABLCD                          Last change dat
     C                   MOVEL     'A'           ABTYLC                         Type of the Las
      *
     C**********         UPDATE    @SARDL0                              91      *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ update SCSRCXTD set                                                                 MD055681
     C+   SARD = :ABSARD                                                                    MD055681
     C+ , LCD  = :ABLCD                                                                     MD055681
     C+ , TYLC = :ABTYLC                                                                    MD055681
     C+ where SARN = :ABSARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C******IN91         IFEQ      '1'                                                      MD055681
     C                   IF        SQLCODE <> 0                                             MD055681
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
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
     C/EXEC SQL                                                                             MD055681
     C+ close ACursor                                                                       MD055681
     C/END-EXEC                                                                             MD055681
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
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C     *DTAARA       DEFINE    CBMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Int Feature Check Field
     C                   MOVEL     *BLANK        WUIFCF            2
      * Define work field *Return code
     C                   MOVEL     *BLANK        WURTN             7
      * Define work field run day number
     C                   Z-ADD     *ZERO         WUAKTX            5 0
      * Define work field Allow INS/DEL of Feature
     C                   MOVEL     *BLANK        WUAIDF            1
      * Define work field Program Name
     C                   MOVEL     *BLANK        WUPNAM           10
      * Define work field Access Obj Return Code
     C                   MOVEL     *BLANK        WURTCD            7
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
     C                   Z-ADD     *ZEROS        YRSW00            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW01            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW02            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW03            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW04            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW05            5 0          *Synon (5,0) wo
     C                   MOVEL     *BLANKS       YRSW06            1            *String work fi
     C                   MOVEL     *BLANKS       YRSW07            1            *String work fi
     C                   MOVEL     *BLANKS       YRSW08            7            *Return code
     C                   MOVEL     *BLANKS       YRSW09            1            *String work fi
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0A                         *Synon (9999) w
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0B                         *Synon (9999) w
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0C                         *Synon (9999) w
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0D                         *Synon (9999) w
     C                   MOVEL     *BLANKS       YRSW0E            1            *String work fi
     C                   MOVEL     *BLANKS       YRSW0F            1            *String work fi
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
     C                   OPEN      SC3011M#
     C**********         OPEN      SCSARDL1                                                 MD055681
     C                   OPEN      SCSARPL1
     C**********         OPEN      SCSARDL0                                                 MD055681
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     12            ##SFPG            3 0          SFLPAG
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
     C*********************MOVEL'CHG'     W0PMD   3                       CSC008
     C                   MOVEL     'ADD'         W0PMD             3                           CSC00
     C                   MOVEL     'Y'           W0APM             1
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of change S01459.
      * SC3010M Precompiler - Switchable Features  *
      * Remove Last Amend Box and Creation Parameters functions.
      * End of change S01459.
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
      * Start of PSSR user point.
      *
     C*COPY*CBCPYSRC,SC3010MPS1*                                                              CPK025
     C/COPY WNCPYSRC,SC3010MPS1                                                               CPK025
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD055681
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055681
      *
      * End of PSSR user point.
      *
     C*COPY*CBCPYSRC,SC3010MPS2*                                                              CPK025
     C/COPY WNCPYSRC,SC3010MPS2                                                               CPK025
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA ARNA
2=COB Components  3=Report Names  4=Journal Files  5=Report Components
6=Menu Items  7=Report Print Files  8=Initialisation Programs
**CTDATA CPY@
(c) Finastra International Limited 2001
