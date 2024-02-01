     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB Dependency relations maintenance')            *
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Module                             *
      *                                                               *
      *  CB0410M - Dependency Relations maintenance.                  *
      *                                                               *
      *  Function:  This program allows the user to maintain the      *
      *             Dependency Relations file.                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061162           Date 30Jan24               *      
      *  Prev Amend No. MD058986           Date 11Oct21               *
      *                 MD055891           Date 01Sep20               *
      *                 MD046248           Date 27Oct17               *
      *                 CCB020C            Date 16May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CCB008             Date 12Oct98               *
      *                 105705             Date 12JUL96               *
      *                 090416             Date 12JUL95               *
      *                 S01459             Date 12JUL95               *
      *                 S01417             Date 24AUG93               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061162 - Avoid duplicate key error when deleting records   *
      *             by making sure the unique no. (DIDRUN) is unique  *
      *             whether records are logically deleted or not      *     
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB020C - COB Restructure - Secondary COB Infrastructure     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - File removed from CB model.                       *
      *  105705 - Processing errors occur if the lowest value of      *
      *           'Unique Number' is not '001'.                       *
      *  090416 - 1. Standardise the header/footer.                   *
      *           2. Remove 'components depends-on unique No' from    *
      *              the screen and generate it in the background.    *
      *           3. Create both sides of the mutually exclusive      *
      *              record.                                          *
      *           4. Addition of help.                                *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *  S01417 - Add 1A function input parameter to indicate         *
      *              successful update made to master file            *
      *                                                               *
      *****************************************************************
     FCB0410M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas CB Dependency relations maintenance
      *
     F*CBDPRLL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(INFDS1)                                    MD055891
     F*********                            INFSR(*PSSR)                                     MD055891
      * RTV : Midas CB Dependency relations retrieval
      *
     F*CBCMPNL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0001)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Midas CB Components retrieval
      *
     F*CBCMPNL0* UF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0002)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * UPD : Midas CB Components update
      *
     F*CBDPRLL0* UF A E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0003)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * UPD : Midas CB Dependency relations update
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
     D*@1DBRC***     E DS                  EXTNAME(CBDPRLL0)                                MD055891
     D @1DBRC        E DS                  EXTNAME(CBDPRJW0)                                MD055891
     D                                     PREFIX(Y)                                        MD055891
      * UPD : Midas CB Dependency relations update
      * Current/previous master file format fields for change control
      *
     D*QCBCM1***     E DS                  EXTNAME(CBCMPNL0)                                MD055891
     D QCBCM1        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     D                                     PREFIX(X)                                        MD055891
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     D CBDPRL        E DS                  EXTNAME(CBDPRJW0)                                MD055891
     D TotRow          S             13  0                                                  MD055891
      * UPD : Midas CB Components update
     D YARDCS          DS           262
     D YBRDCS          DS           262
     D YCRDCS          DS            34
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
     D ID0003          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * B :  Successful Update Made
     D  P1SUPD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Member Name
     D  ZA0001                 1     10
      * Message data for 'Compnt/depended on exists'
      * Component Depends-on Name
     D  ZA0002                 1     10
      * Compnt Depends-on Seq No
     D  ZA0003                11     15
      * Compnt Depended-on Name
     D  ZA0004                16     25
      * Compnt Depended-on Seq No
     D  ZA0005                26     30
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1SUPD        PARM      P1SUPD        WP0001            1            Successful Upda
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
      * USER: Initialize subfile header
      * Start of 090416
      * Footer for edit file - Dependency Relations  *
     C*****************************************************************
     C*  Set up the function key footer text
     C*
     C                   MOVEL     'CBUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If program mode is ADD:
     C*
     C     W0PMD         IFEQ      'ADD'
     C* Setup footer text:
     C* F3=Main Menu   F5=Refresh   F9=Go to 'Change' Mode
     C                   MOVEL     'CBM0197'     WUMSID            7            Message Identifier
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
     C                   ELSE
     C*
     C* Setup footer text:
     C* D=Delete   F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode
     C                   MOVEL     'CBM0198'     WUMSID            7            Message Identifier
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
     C                   END
      * End of 090416
      *................................................................
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #2DSON        WZDSON
     C                   MOVEL     #2DSON        WZDSON                         Component Depen
     C     *LIKE         DEFINE    #2DSOS        WZDSOS
     C                   MOVEL     #2DSOS        WZDSOS                         Compnt Depends-
     C     KPOS          KLIST
     C                   KFLD                    DIDSON                         Component Depen
     C                   KFLD                    DIDSOS                         Compnt Depends-
     C                   KFLD                    DIDRUN                         Comp Depends-on
      * Setup key
     C                   MOVEL     #2DSON        DIDSON                         Component Depen
     C                   MOVEL     #2DSOS        DIDSOS                         Compnt Depends-
     C                   MOVEL     #2DRUN        DIDRUN                         Comp Depends-on
                                                                                            MD055891
      * 82=EOF
     C*****KPOS*         SETLL     @DIREGK                            82        *           MD055891
      * 82=EOF
     C**N82*****         READ      @DIREGK                              9182    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ACursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBDPRJW0                                                              MD055891
     C+ where DIDSON >= :DIDSON and DIDSOS >= :DIDSOS                                       MD055891
     C+ and DIDRUN >= DIDRUN                                                                MD055891
     C+ order by DIDSON, DIDSOS, DIDRUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close ACursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ACursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       82                    MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        82                    MD055891
     C                   ENDIF                                                              MD055891
     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      * Load subfile page
     C                   EXSR      BBLDSF
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
     C**N82*****         READP     @DIREGK                                90    *           MD055891
     C**N82*****         READ      @DIREGK                                90    *           MD055891
     C                   If        *IN82 = '0'                                              MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch prior from ACursor into :CBDPRL                                               MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   Endif                                                              MD055891
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0            5
     C                   MOVE      *ALL'1'       WKIND1            5
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
     C                   DOW       SQLCODE = 0                                              MD055891
     C                             and ##RROK < ##SFLN                                      MD055891
     C**N82##RROK        DOWLT     ##SFLN                                       DO          MD055891
     C                   ADD       1             ##RR
     C                   MOVEA     WKIND0        *IN(33)
     C                   SETOFF                                       87        *
      * Clear subfile fields
     C                   EXSR      MAIZ#1
      * If CHANGE mode, load subfile fields
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      * Validate subfile record and calculate derived fields
     C                   EXSR      DFV2RC
     C                   END
      * Output to subfile
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   WRITE     #SFLRCD
     C     W0PMD         IFNE      'ADD'
      * 82=EOF
     C**********         READ      @DIREGK                                82    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
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
      * Check Compnt Depends-on Seq No is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #2DSOS               90  90    *
     C   90              MOVE      #2DSOS        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#2DSOS        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #2DSOS        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
     C                   END
     C                   MOVEL     XG90          *IN90
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      *................................................................
      * Change of position specified
     C     WZDSON        CASNE     #2DSON        FBRQRL                         Component Depen
     C     WZDSOS        CASNE     #2DSOS        FBRQRL                         Compnt Depends-
     C                   END
     C                   END
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
      * USER: Process command keys
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
     C                   MOVEA     WKIND0        *IN(33)
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
     C     #1DSON        CABNE     *BLANK        DDEXIT                         Component Depen
     C     #1DSOS        CABNE     *BLANK        DDEXIT                         Compnt Depends-
     C     #1DDON        CABNE     *BLANK        DDEXIT                         Compnt Depended
     C     #1DDOS        CABNE     *BLANK        DDEXIT                         Compnt Depended
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * Check Compnt Depends-on Seq No is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #1DSOS               90  90    *
     C   90              MOVE      #1DSOS        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#1DSOS        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #1DSOS        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9835      *
     C                   END
     C                   MOVEL     XG90          *IN90
      * Check Compnt Depended-on Seq No is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #1DDOS               90  90    *
     C   90              MOVE      #1DDOS        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#1DDOS        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #1DDOS        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9837      *
     C                   END
     C                   MOVEL     XG90          *IN90
      * USER: Validate subfile record fields
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     #1DRUN        WUJ8ST                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUJ8ST        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     '?INVAL'      W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     #1DSON        ZA0001                         Component Depen
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start of 090416
      * Component depends on name & Seq no / depended on name & seq
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     'N'           WUERCD                         Err Code
      * Does record exist ? - Dependency Relations  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1DSON        ZA0002                         Component Depen
     C                   MOVEL     #1DSOS        ZA0003                         Compnt Depends-
     C                   MOVEL     #1DDON        ZA0004                         Compnt Depended
     C                   MOVEL     #1DDOS        ZA0005                         Compnt Depended
      * Send message 'Compnt/depended on exists'
     C                   MOVEL     'CBM0150'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983435    *
     C                   SETON                                        3637      *
      *
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of 090416
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * Component Depends-on Name required
     C     #1DSON        IFEQ      *BLANK                                       IF
     C                   SETON                                        9834      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Compnt Depends-on Seq No required
     C     #1DSOS        IFEQ      *BLANK                                       IF
     C                   SETON                                        9835      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Compnt Depended-on Name required
     C     #1DDON        IFEQ      *BLANK                                       IF
     C                   SETON                                        9836      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Compnt Depended-on Seq No required
     C     #1DDOS        IFEQ      *BLANK                                       IF
     C                   SETON                                        9837      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *                                                                                      CCB020C
      ** Main Cob component cannot be dependent on a                                         CCB020C
      ** Secondary Cob component                                                             CCB020C
      *                                                                                      CCB020C
     C     #1DSON        IFNE      *BLANK
     C     #1DSOS        ANDNE     *BLANK
     C     #1DDON        ANDNE     *BLANK
     C     #1DDOS        ANDNE     *BLANK
     C                   MOVEL     #1DSOS        W#DSOS            1
     C                   MOVEL     #1DDOS        W#DDOS            1
     C     W#DDOS        IFEQ      '2'
     C     W#DSOS        ANDNE     '2'
     C                   MOVEL     'CBM0317'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983435
     C                   SETON                                        3637
     C                   ENDIF
     C                   ENDIF
      *================================================================
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   DFV2RC        BEGSR
      *================================================================
      * Validate subfile record relations
      *================================================================
      * Check reference to Components
     C                   EXSR      VACKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983435    *
     C                   END
      * Check reference to Components
     C                   EXSR      VBCKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983637    *
     C                   END
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
     C                   MOVEA     WKIND0        *IN(33)
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
      * Start of 090416
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     'N'           WUERCD                         Err Code
      * Does record exist ? - Dependency Relations  *
     C                   EXSR      SBRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Not Found
     C     WUERCD        IFEQ      'N'                                          *IF
     C                   Z-ADD     *ZERO         WUWRUN                         Comp depends on
     C                   MOVEL     '001'         WUDRUN                         Comp Depends-on
      * Create record & gen No. - Dependency Relations  *
      *
     C     *IN98         IFNE      '1'
     C                   SETOFF                                         9190
      *
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DIDSON        WQDSON                         Component Name
     C     *LIKE         DEFINE    DIDSOS        WQDSOS                         Component Seque
      *
      * Define keylist
     C     KDPRL         KLIST
     C                   KFLD                    WQDSON                         Component Name
     C                   KFLD                    WQDSOS                         Component Seque
      *                                                                   105705
      * Define keylist2                                                   105705
     C     KDPRL2        KLIST                                                                 10570
     C                   KFLD                    WQDSON                         Component Name 10570
     C                   KFLD                    WQDSOS                         Component Seque10570
     C                   KFLD                    WQDRUN            3            Component Uniqu10570
      *
      * Move fields to key list
     C                   MOVEL     #1DSON        WQDSON                         Component Name
     C                   MOVEL     #1DSOS        WQDSOS                         Component Seque
      *
     C*****KDPRL         SETLL     @DIREGK                                      *           MD055891
     C*****KDPRL         READE     @DIREGK                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare CDCursor insensitive scroll cursor for                                      MD055891
     C**select** from CBDPRJW0                                                     MD055891 MD061162
     C+ select * from CBDPRJW1                                                              MD061162
     C+ where DIDSON = :WQDSON and DIDSOS = :WQDSOS                                         MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open CDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ get diagnostics :TotRow  = db2_number_rows                                          MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from CDCursor into :CBDPRL                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   IF        TotRow  = 0                                              MD055891
     C                   seton                                        90                    MD055891
     C                   else                                                               MD055891
     C                   setoff                                       90                    MD055891
     C                   endif                                                              MD055891
      *
     C     *IN90         IFEQ      '1'
      * Data record not found
      * Processing if Data record not found
     C                   Z-ADD     001           WUSUNR            3 0
      * Move all fields to @DHREGJ
     C                   MOVEL     #1DSON        DIDSON                         Component Name
     C                   MOVEL     #1DSOS        DIDSOS                         Component Seque
     C*********          MOVEL     WUSUNR        DIDRUN                                     MD055891
     C                   MOVE      WUSUNR        DIDRUN                                     MD055891
     C                   MOVEL     #1DDON        DIDDON
     C                   MOVEL     #1DDOS        DIDDOS
      *
     C**********         WRITE     @DIREGJ                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBDPRBTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DIDSON                                                                            MD055891
     C+  ,DIDSOS                                                                            MD055891
     C+  ,DIDRUN                                                                            MD055891
     C+  ,DIDDON                                                                            MD055891
     C+  ,DIDDOS                                                                            MD055891
     C+  ,DICDST                                                                            MD055891
     C+  ,DIMODE                                                                            MD055891
     C+  ,DILOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1DSON                                                                           MD055891
     C+  ,:#1DSOS                                                                           MD055891
     C+  ,:DIDRUN                                                                           MD055891
     C+  ,:#1DDON                                                                           MD055891
     C+  ,:#1DDOS                                                                           MD055891
     C+  ,' '                                                                               MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBDPRXTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DIDSON                                                                            MD055891
     C+  ,DIDSOS                                                                            MD055891
     C+  ,DIDRUN                                                                            MD055891
     C+  ,DIDDON                                                                            MD055891
     C+  ,DIDDOS                                                                            MD055891
     C+  ,DIMODE                                                                            MD055891
     C+  ,DILOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1DSON                                                                           MD055891
     C+  ,:#1DSOS                                                                           MD055891
     C+  ,:DIDRUN                                                                           MD055891
     C+  ,:#1DDON                                                                           MD055891
     C+  ,:#1DDOS                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C                   If        (SQLCODE <> 0)                                           MD055891
     C                   seton                                        91                    MD055891
     C                   else                                                               MD055891
     C                   setoff                                       91                    MD055891
     C                   endif                                                              MD055891
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
      *
     C                   ELSE
      *
      *
      * Move 'Y' into parameter if DBF update complete
      *
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      *
     C                   END
     C                   END
      *
      *
     C**********           MOVE WUDRUN    WUWRUN                          105705
     C                   Z-ADD     0             WRKRUN            3 0                         10570
     C                   MOVE      WRKRUN        WQDRUN                                        10570
      *
     C******IN90         DOWEQ     '0'                                                      MD055891
     C     *IN90         IFEQ      '0'                                                      MD055891
      *
      * Process Data record
      *
     C********** WUDRUN    IFEQ DIDRUN                     *IF            105705
      *
     C**********           ADD  001       WUWRUN                          105705
     C**********           MOVE WUWRUN    WUDRUN                          105705
     C**********           MOVE DIDRUN    WUSUNR                          105705
     C**********           ADD  001       WUSUNR                          105705
     C*********          ADD       001           WRKRUN                               10570 MD055891
     C                   ADD       001           TotRow                                     MD055891
     C                   Z-ADD     TotRow        WRKRUN                                     MD055891
     C                   MOVE      WRKRUN        WQDRUN                                        10570
     C                   MOVE      WRKRUN        WUSUNR                                        10570
     C*****KDPRL2        SETLL     @DIREGK                                            10570 MD055891
     C*****KDPRL2        CHAIN     @DIREGK                            90              10570 MD055891
     C                   MOVEL     'Y'           WUCRRC            1            Create record f
      *
     C**********           END                             *FI            105705
     C********** KDPRL     READE@DIREGK                  90*              105705
      *
     C                   END                                                    *FI
      *
     C/EXEC SQL                                                                             MD055891
     C+ close CDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C     WUCRRC        IFEQ      'Y'
      * Move all fields to @DIREGJ
     C                   MOVEL     #1DSON        DIDSON                         Component Name
     C                   MOVEL     #1DSOS        DIDSOS                         Component Seque
     C*********          MOVEL     WUSUNR        DIDRUN                                     MD055891
     C                   MOVE      WUSUNR        DIDRUN                                     MD055891
     C                   MOVEL     #1DDON        DIDDON
     C                   MOVEL     #1DDOS        DIDDOS
      *
     C**********         WRITE     @DIREGJ                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBDPRBTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DIDSON                                                                            MD055891
     C+  ,DIDSOS                                                                            MD055891
     C+  ,DIDRUN                                                                            MD055891
     C+  ,DIDDON                                                                            MD055891
     C+  ,DIDDOS                                                                            MD055891
     C+  ,DICDST                                                                            MD055891
     C+  ,DIMODE                                                                            MD055891
     C+  ,DILOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1DSON                                                                           MD055891
     C+  ,:#1DSOS                                                                           MD055891
     C+  ,:DIDRUN                                                                           MD055891
     C+  ,:#1DDON                                                                           MD055891
     C+  ,:#1DDOS                                                                           MD055891
     C+  ,' '                                                                               MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBDPRXTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DIDSON                                                                            MD055891
     C+  ,DIDSOS                                                                            MD055891
     C+  ,DIDRUN                                                                            MD055891
     C+  ,DIDDON                                                                            MD055891
     C+  ,DIDDOS                                                                            MD055891
     C+  ,DIMODE                                                                            MD055891
     C+  ,DILOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1DSON                                                                           MD055891
     C+  ,:#1DSOS                                                                           MD055891
     C+  ,:DIDRUN                                                                           MD055891
     C+  ,:#1DDON                                                                           MD055891
     C+  ,:#1DDOS                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C                   If        (SQLCODE <> 0)                                           MD055891
     C                   seton                                        91                    MD055891
     C                   else                                                               MD055891
     C                   setoff                                       91                    MD055891
     C                   endif                                                              MD055891
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
      *
     C                   ELSE
      *
      * Move 'Y' into parameter if DBF update complete
      *
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      *
     C                   END
     C                   END                                                    *FI
      *
     C                   END
      * Change for Dep-Relations - Components  *
     C                   EXSR      SCCHRC
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of 090416
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Dependency Relatio - Dependency Relations  *
     C                   EXSR      SDCRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
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
      * Delete Dependency Relatio - Dependency Relations  *
     C                   EXSR      SEDLRC
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
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
      * Change Dependency Relatio - Dependency Relations  *
     C                   EXSR      SGCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
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
     C                   MOVEL     *IN87         *IN78
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     *IN87         *IN77
     C     W0PMD         IFEQ      'CHG'                                        *IF
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
     C                   MOVEL     *BLANK        #1DRUN                         Comp Depends-on
     C                   MOVEL     *BLANK        #1CDST                         Component Depen
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1DSON                         Component Depen
     C                   MOVEL     *BLANK        #1DSOS                         Compnt Depends-
     C                   MOVEL     *BLANK        #1DDON                         Compnt Depended
     C                   MOVEL     *BLANK        #1DDOS                         Compnt Depended
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @DIREGK fields to subfile
      *================================================================
     C                   MOVEL     DIDRUN        #1DRUN                         Comp Depends-on
     C                   MOVEL     DICDST        #1CDST                         Component Depen
     C                   MOVEL     DIDSON        #1DSON                         Component Depen
     C                   MOVEL     DIDSOS        #1DSOS                         Compnt Depends-
     C                   MOVEL     DIDDON        #1DDON                         Compnt Depended
     C                   MOVEL     DIDDOS        #1DDOS                         Compnt Depended
      * Hold current record image for change detection
     C                   eval      @1DBRC = CBDPRL                                          MD055891
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2DRUN                         Comp Depends-on
     C                   MOVEL     *BLANK        #2DSON                         Component Depen
     C                   MOVEL     *BLANK        #2DSOS                         Compnt Depends-
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Does record exist ? - Dependency Relations  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DIDSON        WQSA01                         Component Depen
     C     *LIKE         DEFINE    DIDSOS        WQSA02                         Compnt Depends-
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    WQSA01                         Component Depen
     C                   KFLD                    WQSA02                         Compnt Depends-
      * Move fields to key list
     C                   MOVEL     #1DSON        WQSA01                         Component Depen
     C                   MOVEL     #1DSOS        WQSA02                         Compnt Depends-
     C*****KRSSA         SETLL     @DIREGK                                      *           MD055891
     C*****KRSSA         READE     @DIREGK                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare CCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBDPRJW0                                                              MD055891
     C+ where DIDSON = :WQSA01 and DIDSOS = :WQSA02                                         MD055891
     C+ order by DIDSON, DIDSOS, DIDRUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open CCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from CCursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0499'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * CASE:
      *  - c1 AND c2
      *   |- c1    : PAR.Compnt Depended-on Name EQ DB1.Compnt Depended-o
      *   |- c2    : PAR.Compnt Depended-on Seq No EQ DB1.Compnt Depended
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1DDON        IFEQ      DIDDON                                       *IF
     C     #1DDOS        IFEQ      DIDDOS                                       *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END                                                    *FI
     C*****KRSSA         READE     @DIREGK                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from CCursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   END
     C/EXEC SQL                                                                             MD055891
     C+ close CCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * Does record exist ? - Dependency Relations  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DIDSON        WQSB01                         Component Depen
     C     *LIKE         DEFINE    DIDSOS        WQSB02                         Compnt Depends-
      * Define keylist
     C     KRSSB         KLIST
     C                   KFLD                    WQSB01                         Component Depen
     C                   KFLD                    WQSB02                         Compnt Depends-
      * Move fields to key list
     C                   MOVEL     #1DSON        WQSB01                         Component Depen
     C                   MOVEL     #1DSOS        WQSB02                         Compnt Depends-
     C*****KRSSB         SETLL     @DIREGK                                      *           MD055891
     C*****KRSSB         READE     @DIREGK                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare DCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBDPRJW0                                                              MD055891
     C+ where DIDSON = :WQSB01 and DIDSOS = :WQSB02                                         MD055891
     C+ order by DIDSON, DIDSOS, DIDRUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open DCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from DCursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0499'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * CASE:
      *  - c1 AND c2
      *   |- c1    : PAR.Compnt Depended-on Name EQ DB1.Compnt Depended-o
      *   |- c2    : PAR.Compnt Depended-on Seq No EQ DB1.Compnt Depended
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1DDON        IFEQ      DIDDON                                       *IF
     C     #1DDOS        IFEQ      DIDDOS                                       *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END                                                    *FI
     C*****KRSSB         READE     @DIREGK                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from DCursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   END
     C/EXEC SQL                                                                             MD055891
     C+ close DCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Change for Dep-Relations - Components  *
      *================================================================
      * Clear all neither parameters
     C                   MOVEL     *BLANK        WN0001            1            Component Statu
     C                   Z-ADD     *ZERO         WN0002            1 0          Scheduling Prio
     C                   Z-ADD     *ZERO         WN0003            2 0          Execution Prior
     C                   Z-ADD     *ZERO         WN0004           11 0          Timeslice
     C                   MOVEL     *BLANK        WN0005            1            FCOOB Error Acc
     C                   MOVEL     *BLANK        WN0006           60            Component Text
     C                   MOVEL     *BLANK        WN0007          100            Execution Param
     C                   MOVEL     *BLANK        WN0008            1            Sel for Today's
     C                   MOVEL     *BLANK        WN0009            2            Module
     C                   MOVEL     *BLANK        WN0010            1            Complex Module
     C                   MOVEL     *BLANK        WN0011            1            Restart Flag
     C                   Z-ADD     *ZERO         WN0012            5 0          No.Outstndng De
     C                   MOVEL     *BLANK        WN0013            1            Mut.Exclusive C
     C                   MOVEL     *BLANK        WN0014            2            Run Conditions
     C                   Z-ADD     *ZERO         WN0015            5 0          Start Date
     C                   Z-ADD     *ZERO         WN0016            6 0          Start Time
     C                   Z-ADD     *ZERO         WN0017            5 0          End Date
     C                   Z-ADD     *ZERO         WN0018            6 0          End Time
     C                   MOVEL     *BLANK        WN0019            1            Halt Before
     C                   MOVEL     *BLANK        WN0020            1            Halt After
     C                   MOVEL     *BLANK        WN0021            1            Component Faile
     C                   Z-ADD     *ZERO         WN0022            6 0          End of Day Run
     C                   Z-ADD     *ZERO         WN0023            6 0          End of Month Ru
     C                   Z-ADD     *ZERO         WN0024            6 0          Begin of Month
     C                   Z-ADD     *ZERO         WN0025            6 0          End of Year Run
     C                   Z-ADD     *ZERO         WN0026            6 0          End of Day CPU
     C                   Z-ADD     *ZERO         WN0027            6 0          End of Month CP
     C                   Z-ADD     *ZERO         WN0028            6 0          Begin of Month
     C                   Z-ADD     *ZERO         WN0029            6 0          End of Year CPU
     C                   MOVEL     *BLANK        WN0030            1            Allow Bypass in
     C                   MOVEL     *BLANK        WN0031            8            COB Stream Name
     C                   MOVEL     *BLANK        WN0032            1            Task Split Job
     C                   Z-ADD     *ZERO         WN0033            3 0          Number of Task
      *
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @DHREGG
     C                   MOVEL     #1DSON        DHCOTT                         Component Name
     C                   MOVEL     #1DSOS        DHCSEQ                         Component Seque
      *
     C     KLCHSC        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
     C*****KLCHSC        CHAIN     @DHREGG                            9091      *
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :#1DSON and DHCSEQ = :#1DSOS                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   SETOFF                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
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
      * Store record data for null update check
     C                   eval      QCBCM1 = CBCMPN                                          MD055891
     C                   MOVE      QCBCM1        YARDCS
      * USER: Processing after Data read
     C                   ADD       1             DHCODP                         No.Outstndng De
     C                   Z-ADD     DHCODP        WDHCODP           5 0                      MD055891
      *
      * Set PGM.*Record Data Changed flag
     C     QCBCM1        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C**********         UPDATE    @DHREGG                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBCMPXTD                                                                     MD055891
     C+  SET DHCODP = :WDHCODP                                                              MD055891
     C+ where DHCOTT = :#1DSON and DHCSEQ = :#1DSOS                                         MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
     C                   SETON                                        91                    MD055891
     C                   Else                                                               MD055891
     C                   SETOFF                                       91                    MD055891
     C                   ENDIF                                                              MD055891
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    CBCMPNL0                             91      *           MD055891
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCRRC        BEGSR
      *================================================================
      * Create Dependency Relatio - Dependency Relations  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @DIREGJ
     C                   MOVEL     #1DSON        DIDSON                         Component Depen
     C                   MOVEL     #1DSOS        DIDSOS                         Compnt Depends-
     C                   MOVEL     #1DRUN        DIDRUN                         Comp Depends-on
     C                   MOVEL     #1DDON        DIDDON                         Compnt Depended
     C                   MOVEL     #1DDOS        DIDDOS                         Compnt Depended
     C                   MOVEL     *BLANK        DICDST                         Component Depen
      *
      * USER: Processing before Data update
      * Start of 090416
     C                   GOTO      SDEXIT                                       *QUIT
      * End of 090416
     C     KLCRSD        KLIST
     C                   KFLD                    DIDSON                         Component Depen
     C                   KFLD                    DIDSOS                         Compnt Depends-
     C                   KFLD                    DIDRUN                         Comp Depends-on
      * Check for duplicate primary key
     C*****KLCRSD        SETLL     @DIREGJ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare EDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBDPRJW0                                                              MD055891
     C+ where DIDSON = :#1DSON and DIDSOS = :#1DSOS and DIDRUN = :#1DRUN                    MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open EDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ get diagnostics :TotRow  = db2_number_rows                                          MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close EDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
                                                                                            MD055891
     C                   IF        TotRow  = 0                                              MD055891
     C                   seton                                        90                    MD055891
     C                   else                                                               MD055891
     C                   setoff                                       90                    MD055891
     C                   endif                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0500'     W0RTN             7
      * Send message 'Dependency Relations   EX'
     C                   MOVEL     'USR0500'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C**********         WRITE     @DIREGJ                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBDPRBTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DIDSON                                                                            MD055891
     C+  ,DIDSOS                                                                            MD055891
     C+  ,DIDRUN                                                                            MD055891
     C+  ,DIDDON                                                                            MD055891
     C+  ,DIDDOS                                                                            MD055891
     C+  ,DICDST                                                                            MD055891
     C+  ,DIMODE                                                                            MD055891
     C+  ,DILOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1DSON                                                                           MD055891
     C+  ,:#1DSOS                                                                           MD055891
     C+  ,:WUSUNR                                                                           MD055891
     C+  ,:#1DDON                                                                           MD055891
     C+  ,:#1DDOS                                                                           MD055891
     C+  ,' '                                                                               MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBDPRXTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DIDSON                                                                            MD055891
     C+  ,DIDSOS                                                                            MD055891
     C+  ,DIDRUN                                                                            MD055891
     C+  ,DIDDON                                                                            MD055891
     C+  ,DIDDOS                                                                            MD055891
     C+  ,DIMODE                                                                            MD055891
     C+  ,DILOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1DSON                                                                           MD055891
     C+  ,:#1DSOS                                                                           MD055891
     C+  ,:WUSUNR                                                                           MD055891
     C+  ,:#1DDON                                                                           MD055891
     C+  ,:#1DDOS                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C                   If        (SQLCODE <> 0)                                           MD055891
     C                   seton                                        91                    MD055891
     C                   else                                                               MD055891
     C                   setoff                                       91                    MD055891
     C                   endif                                                              MD055891
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
      * Start of 090416
      * Moved 'change components file for dependencies'
      * to after the user source in which the record is written
      * to the dependencies file. (in the main body of the program).
      * End of 090416
      * Start of S01417
      * Move 'Y' into parameter if DBF update complete
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SEDLRC        BEGSR
      *================================================================
      * Delete Dependency Relatio - Dependency Relations  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @DIREGJ
     C                   MOVEL     #1DSON        DIDSON                         Component Depen
     C                   MOVEL     #1DSOS        DIDSOS                         Compnt Depends-
     C                   MOVEL     #1DRUN        DIDRUN                         Comp Depends-on
      *
     C     KLDLSE        KLIST
     C                   KFLD                    DIDSON                         Component Depen
     C                   KFLD                    DIDSOS                         Compnt Depends-
     C                   KFLD                    DIDRUN                         Comp Depends-on
     C*****KLDLSE        CHAIN     @DIREGJ                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBDPRL                                                                        MD055891
     C+ from CBDPRJW0                                                                       MD055891
     C+ where DIDSON = :#1DSON and DIDSOS = :#1DSOS and DIDRUN = :#1DRUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   SETOFF                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 0 and SQLCODE <> 100                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '1'
      * Record already deleted
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
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SEEXIT
     C                   END
      *
      * Do not allow deletion of core dependencies                                          MD055891
     C*****DIMODE        IFEQ      'C'                                             MD055891 MD058986
     C**********                                                                   MD055891 MD058986
      **Send*message 'Deletion of Core dependency is not allowed'                  MD055891 MD058986
     C**********         MOVEL     'USR0541'     ZAMSID                            MD055891 MD058986
     C**********         MOVEL     'CBUSRMSG'    ZAMSGF                            MD055891 MD058986
     C**********         EXSR      ZASNMS                                          MD055891 MD058986
     C**********         MOVEL     'USR0541'     W0RTN                             MD055891 MD058986
     C**********         GOTO      SEEXIT                                          MD055891 MD058986
     C**********         ENDIF                                                     MD055891 MD058986
                                                                                            MD055891
      * Check for changed record
     C                   eval      @1DBRC = CBDPRL                                          MD055891
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C*****KLDLSE        SETLL     @DIREGJ                            9091      *           MD055891
     C                   GOTO      SEEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C**********         DELETE    @DIREGJ                              91      *           MD055891
      * Logical deletion is now allowed for both core and bespoke                           MD058986
     C/EXEC SQL                                                                             MD055891
     C**delete*from CBDPRBTD                                                       MD055891 MD058986
     C**where*DIDSON = :#1DSON and DIDSOS = :#1DSOS and DIDRUN = :#1DRUN           MD055891 MD058986
     C*END-EXEC*                                                                   MD055891 MD058986
     C*EXEC*SQL*                                                                   MD055891 MD058986
     C**delete*from CBDPRXTD                                                       MD055891 MD058986
     C+ update CBDPRXTD                                                                     MD058986
     C+ set DILOGD = 'Y'                                                                    MD058986
     C+ where DIDSON = :#1DSON and DIDSOS = :#1DSOS and DIDRUN = :#1DRUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE <> 0                                             MD055891
     C                   SETON                                        91                    MD055891
     C                   else                                                               MD055891
     C                   SETOff                                       91                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * Change for Dep-Relations - Components  *
     C                   EXSR      SFCHRC
      * Start of S01417
      * Move 'Y' into parameter if DBF update complete
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change for Dep-Relations - Components  *
      *================================================================
      * Clear all neither parameters
     C                   MOVEL     *BLANK        WN0034            1            Component Statu
     C                   Z-ADD     *ZERO         WN0035            1 0          Scheduling Prio
     C                   Z-ADD     *ZERO         WN0036            2 0          Execution Prior
     C                   Z-ADD     *ZERO         WN0037           11 0          Timeslice
     C                   MOVEL     *BLANK        WN0038            1            FCOOB Error Acc
     C                   MOVEL     *BLANK        WN0039           60            Component Text
     C                   MOVEL     *BLANK        WN0040          100            Execution Param
     C                   MOVEL     *BLANK        WN0041            1            Sel for Today's
     C                   MOVEL     *BLANK        WN0042            2            Module
     C                   MOVEL     *BLANK        WN0043            1            Complex Module
     C                   MOVEL     *BLANK        WN0044            1            Restart Flag
     C                   Z-ADD     *ZERO         WN0045            5 0          No.Outstndng De
     C                   MOVEL     *BLANK        WN0046            1            Mut.Exclusive C
     C                   MOVEL     *BLANK        WN0047            2            Run Conditions
     C                   Z-ADD     *ZERO         WN0048            5 0          Start Date
     C                   Z-ADD     *ZERO         WN0049            6 0          Start Time
     C                   Z-ADD     *ZERO         WN0050            5 0          End Date
     C                   Z-ADD     *ZERO         WN0051            6 0          End Time
     C                   MOVEL     *BLANK        WN0052            1            Halt Before
     C                   MOVEL     *BLANK        WN0053            1            Halt After
     C                   MOVEL     *BLANK        WN0054            1            Component Faile
     C                   Z-ADD     *ZERO         WN0055            6 0          End of Day Run
     C                   Z-ADD     *ZERO         WN0056            6 0          End of Month Ru
     C                   Z-ADD     *ZERO         WN0057            6 0          Begin of Month
     C                   Z-ADD     *ZERO         WN0058            6 0          End of Year Run
     C                   Z-ADD     *ZERO         WN0059            6 0          End of Day CPU
     C                   Z-ADD     *ZERO         WN0060            6 0          End of Month CP
     C                   Z-ADD     *ZERO         WN0061            6 0          Begin of Month
     C                   Z-ADD     *ZERO         WN0062            6 0          End of Year CPU
     C                   MOVEL     *BLANK        WN0063            1            Allow Bypass in
     C                   MOVEL     *BLANK        WN0064            8            COB Stream Name
     C                   MOVEL     *BLANK        WN0065            1            Task Split Job
     C                   Z-ADD     *ZERO         WN0066            3 0          Number of Task
      *
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @DHREGG
     C                   MOVEL     DIDSON        DHCOTT                         Component Name
     C                   MOVEL     DIDSOS        DHCSEQ                         Component Seque
      *
     C     KLCHSF        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
     C*****KLCHSF        CHAIN     @DHREGG                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :DIDSON and DHCSEQ = :DIDSOS                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SFEXIT
     C                   END
      *
      * Store record data for null update check
     C                   eval      QCBCM1 = CBCMPN                                          MD055891
     C                   MOVE      QCBCM1        YBRDCS
      * USER: Processing after Data read
     C                   ADD       -1            DHCODP                         No.Outstndng De
     C                   Z-ADD     DHCODP        WDHCODP           5 0                      MD055891
      *
      * Set PGM.*Record Data Changed flag
     C     QCBCM1        IFNE      YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   END
      * If changed update record otherwise release record
     C     YBRDC         IFEQ      'Y'
     C**********         UPDATE    @DHREGG                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBCMPXTD                                                                     MD055891
     C+  SET DHCODP = :WDHCODP                                                              MD055891
     C+ where DHCOTT = :DIDSON and DHCSEQ = :DIDSOS                                         MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
     C                   SETON                                        91                    MD055891
     C                   Else                                                               MD055891
     C                   SETOFF                                       91                    MD055891
     C                   ENDIF                                                              MD055891
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    CBCMPNL0                             91      *           MD055891
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGCHRC        BEGSR
      *================================================================
      * Change Dependency Relatio - Dependency Relations  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @DIREGJ
     C                   MOVEL     #1DSON        DIDSON                         Component Depen
     C                   MOVEL     #1DSOS        DIDSOS                         Compnt Depends-
     C                   MOVEL     #1DRUN        DIDRUN                         Comp Depends-on
      *
     C     KLCHSG        KLIST
     C                   KFLD                    DIDSON                         Component Depen
     C                   KFLD                    DIDSOS                         Compnt Depends-
     C                   KFLD                    DIDRUN                         Comp Depends-on
     C*****KLCHSG        CHAIN     @DIREGJ                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBDPRL                                                                        MD055891
     C+ from CBDPRJW0                                                                       MD055891
     C+ where DIDSON = :#1DSON and DIDSOS = :#1DSOS and DIDRUN = :#1DRUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 0 and SQLCODE <> 100                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SGEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SGEXIT
     C                   END
      *
      * Check for changed record
     C                   eval      @1DBRC = CBDPRL                                          MD055891
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C**********         UNLOCK    CBDPRLL0                             91      *           MD055891
     C                   GOTO      SGEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YCRDCS
      * Move non-key fields to @DIREGJ
     C                   MOVEL     #1DDON        DIDDON                         Compnt Depended
     C                   MOVEL     #1DDOS        DIDDOS                         Compnt Depended
     C                   MOVEL     #1CDST        DICDST                         Component Depen
      *
      * Set PGM.*Record Data Changed flag
     C                   eval      @1DBRC = CBDPRL                                          MD055891
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C**********         UPDATE    @DIREGJ                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBDPRBTD                                                                     MD055891
     C+  SET DICDST = :#1CDST                                                               MD055891
     C+ where DIDSON = :#1DSON and DIDSOS = :#1DSOS and DIDRUN = :#1DRUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE <> 0                                             MD055891
     C                   SETON                                        91                    MD055891
     C                   ELSE                                                               MD055891
     C                   SETOFF                                       91                    MD055891
     C                   ENDIF                                                              MD055891
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    CBDPRLL0                             91      *           MD055891
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   eval      @1DBRC = CBDPRL                                          MD055891
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
      * USER: Processing after Data update
      * Start of S01417
      * Move 'Y' to parameter if DBF update complete
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Check reference to Components
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Name search required?
     C                   MOVEL     #1DSON        WK1X01            1
     C                   MOVEL     #1DSOS        WK1X02            1
     C     WK1X01        IFEQ      '?'                                          Component Name
     C     WK1X02        OREQ      '?'                                          Component Seque
     C                   CALL      'CB0404S'                            90      Select Componen
     C                   PARM      *BLANK        W0RTN             7
     C     #1DSON        PARM      #1DSON        WQ0001           10            Component Name
     C     #1DSOS        PARM      #1DSOS        WQ0002            5            Component Seque
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
     C                   SETON                                        983435    *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
      * No value selected, exit
     C     W0RTN         IFNE      *BLANK
     C                   GOTO      VAEXIT
     C                   END
     C                   END
      *................................................................
      * If all low order keys not entered, exit
     C     #1DSON        IFEQ      *BLANK                                       Component Name
     C     #1DSOS        ANDEQ     *BLANK                                       Component Seque
     C                   GOTO      VAEXIT
     C                   END
      *
     C     KLVADH        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Setup key
     C                   MOVEL     #1DSON        DHCOTT                         Component Name
     C                   MOVEL     #1DSOS        DHCSEQ                         Component Seque
     C*****KLVADH        CHAIN     @DHREGH                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :#1DSON and DHCSEQ = :#1DSOS                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VAEXIT
     C                   END
      * Send message 'Components             NF'
     C                   MOVEL     'USR0497'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'USR0497'     W0RTN
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   VBCKRL        BEGSR
      *================================================================
      * Check reference to Components
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Name search required?
     C                   MOVEL     #1DDON        WK1X01            1
     C                   MOVEL     #1DDOS        WK1X02            1
     C     WK1X01        IFEQ      '?'                                          Component Name
     C     WK1X02        OREQ      '?'                                          Component Seque
     C                   CALL      'CB0404S'                            90      Select Componen
     C                   PARM      *BLANK        W0RTN             7
     C     #1DDON        PARM      #1DDON        WQ0003           10            Component Name
     C     #1DDOS        PARM      #1DDOS        WQ0004            5            Component Seque
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
     C                   SETON                                        983637    *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
      * No value selected, exit
     C     W0RTN         IFNE      *BLANK
     C                   GOTO      VBEXIT
     C                   END
     C                   END
      *................................................................
      * If all low order keys not entered, exit
     C     #1DDON        IFEQ      *BLANK                                       Component Name
     C     #1DDOS        ANDEQ     *BLANK                                       Component Seque
     C                   GOTO      VBEXIT
     C                   END
      *
     C     KLVBDH        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Setup key
     C                   MOVEL     #1DDON        DHCOTT                         Component Name
     C                   MOVEL     #1DDOS        DHCSEQ                         Component Seque
     C*****KLVBDH        CHAIN     @DHREGH                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :#1DDON and DHCSEQ = :#1DDOS                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VBEXIT
     C                   END
      * Send message 'Components             NF'
     C                   MOVEL     'USR0497'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'USR0497'     W0RTN
      *================================================================
     CSR   VBEXIT        ENDSR
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
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
     C/EXEC SQL                                                                             MD055891
     C+ close ACursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
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
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUJ8ST            1
      * Obtain default message file
     C     *DTAARA       DEFINE    CBMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Err Code
     C                   MOVEL     *BLANK        WUERCD            1
      * Define work field Comp depends on numeric
     C                   Z-ADD     *ZERO         WUWRUN            3 0
      * Define work field Comp Depends-on Unique No
     C                   MOVEL     *BLANK        WUDRUN            3
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
     C                   OPEN      CB0410M#
     C**********         OPEN      CBDPRLL1                                                 MD055891
     C**********         OPEN      CBCMPNL1                                                 MD055891
     C**********         OPEN      CBCMPNL0                                                 MD055891
     C**********         OPEN      CBDPRLL0                                                 MD055891
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
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
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of S01459
      * Remove the creation parameters and last amend box functions
      * CB0410M precompiler - Dependency Relations  *
      * End of S01459
      * Copyright Statement 1988 - Standard functions  *
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
     C/COPY WNCPYSRC,CB0410MPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0410MPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD055891
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055891
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0410MPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001
