     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB Display dependency relations')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Module                             *
      *                                                               *
      *  CB0410D - COB Dependencies Enquiry Subfile                   *
      *                                                               *
      *  Function:  This program allows the user to enquire on the    *
      *             dependency relationships defined to the system    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058986           Date 11Oct21               *
      *  Prev Amend No. MD055891           Date 01Sep20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CCB008             Date 12Oct98               *
      *                 S01459             Date 02JAN98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split                            *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - File removed from CB model.                       *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *                                                               *
      *****************************************************************
     FCB0410D#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas CB COB dependencies enquiry subfile
      *
     F*CBDPRLL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(INFDS1)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Dependency Relations     ions retrieval
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
     D CBDPRL        E DS                  EXTNAME(CBDPRJW0)                                MD055891
     D WDIDSON         S             10                                                     MD055891
     D WDIDSOS         S              5                                                     MD055891
     D WDIDRUN         S              3                                                     MD055891
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
      * Initialise & load subfile page
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
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise and load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    DIDSON                         Component Depen
     C                   KFLD                    DIDSOS                         Compnt Depends-
     C                   KFLD                    DIDRUN                         Comp Depends-on
      * Setup key
     C                   MOVEL     #2DSON        DIDSON                         Component Depen
     C                   MOVEL     #2DSOS        DIDSOS                         Compnt Depends-
     C                   MOVEL     #2DRUN        DIDRUN                         Comp Depends-on
     C*****KPOS*         SETLL     @DIREGK                                                  MD055891
     C**********         READ      @DIREGK                              8782    *82=EOF     MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ACursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBDPRJW0                                                              MD055891
     C+ where DIDSON >=:DIDSON and DIDSOS >= :DIDSOS                                        MD055891
     C+ and DIDRUN >= :DIDRUN                                                               MD055891
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
      * Save previous selector values
     C     *LIKE         DEFINE    #2DRUN        WZDRUN
     C                   MOVEL     #2DRUN        WZDRUN                         Comp Depends-on
     C     *LIKE         DEFINE    #2CDST        WZCDST
     C                   MOVEL     #2CDST        WZCDST                         Component Depen
     C     *LIKE         DEFINE    #2DSON        WZDSON
     C                   MOVEL     #2DSON        WZDSON                         Component Depen
     C     *LIKE         DEFINE    #2DSOS        WZDSOS
     C                   MOVEL     #2DSOS        WZDSOS                         Compnt Depends-
     C     *LIKE         DEFINE    #2DDON        WZDDON
     C                   MOVEL     #2DDON        WZDDON                         Compnt Depended
     C     *LIKE         DEFINE    #2DDOS        WZDDOS
     C                   MOVEL     #2DDOS        WZDDOS                         Compnt Depended
      * Load subfile page
     C                   Z-ADD     0             ##RROK            5 0
     C                   EXSR      BBLDSF
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page
      *================================================================
      * Re-establish fields in read-ahead record
     C   27              DO
     C**N82****          READP     @DIREGK                                90    *           MD055891
     C**N82****          READ      @DIREGK                                90    *           MD055891
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
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read
     C                   Z-ADD     0             ##RRRD            5 0
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
      * Load next SFL page until SFL page full, or
      * Scan limit reached
     C******IN82         DOWEQ     '0'                                          DO          MD055891
     C*****##RROK        ANDLT     ##SFLN                                                   MD055891
     C*****##RRRD        ANDLT     W0SLM                                                    MD055891
     C                   DOW       SQLCODE = 0                                              MD055891
     C                             and ##RROK < ##SFLN                                      MD055891
     C                             and ##RRRD < W0SLM                                       MD055891
      * Check selection fields - if fail, read next record
     C     #2DSON        IFEQ      *BLANK                                       Component Depen
     C     #2DSOS        OREQ      *BLANK                                       Compnt Depends-
     C     #2DRUN        IFNE      *BLANK                                       Comp Depends-on
     C     DIDRUN        CABNE     #2DRUN        BB020                          Comp Depends-on
     C                   END
     C                   END
     C     #2CDST        IFNE      *BLANK                                       Component Depen
     C     DICDST        CABNE     #2CDST        BB020                          Component Depen
     C                   END
     C     #2DSON        IFEQ      *BLANK                                       Component Depen
     C     #2DSOS        IFNE      *BLANK                                       Compnt Depends-
     C     DIDSOS        CABNE     #2DSOS        BB020                          Compnt Depends-
     C                   END
     C                   END
     C     #2DDON        IFNE      *BLANK                                       Compnt Depended
     C     DIDDON        CABNE     #2DDON        BB020                          Compnt Depended
     C                   END
     C     #2DDOS        IFNE      *BLANK                                       Compnt Depended
     C     DIDDOS        CABNE     #2DDOS        BB020                          Compnt Depended
     C                   END
      * Load SFL fields
     C                   EXSR      MBFL#1
      * Output to subfile
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      * Increment scan check count
     C                   ADD       1             ##RRRD
     C**********         READ      @DIREGK                                82    *82=EOF     MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   END                                                    OD 1 - ##SFPG
      *................................................................
     C     BB900         TAG
      *................................................................
      * If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI ##RR = *ZERO
      *
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
      * If scan limit reached, display error message
     C     ##RRRD        IFGE      W0SLM
      * Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     0             ##RROK
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen
      *================================================================
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * Update screen time
     C                   TIME                    ##TME
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
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
     C                   SETOFF                                         8392    *
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
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * Change of position specified
     C     WZDSON        CASNE     #2DSON        FBRQRL
     C     WZDSOS        CASNE     #2DSOS        FBRQRL
     C     WZDDON        CASNE     #2DDON        FBRQRL
     C     WZDDOS        CASNE     #2DDOS        FBRQRL
     C                   END
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
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
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2DRUN                         Comp Depends-on
     C                   MOVEL     *BLANK        #2CDST                         Component Depen
     C                   MOVEL     *BLANK        #2DSON                         Component Depen
     C                   MOVEL     *BLANK        #2DSOS                         Compnt Depends-
     C                   MOVEL     *BLANK        #2DDON                         Compnt Depended
     C                   MOVEL     *BLANK        #2DDOS                         Compnt Depended
      *================================================================
     CSR   MEEXIT        ENDSR
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
      * Cancel & exit program
      *================================================================
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
     C                   OPEN      CB0410D#
     C**********         OPEN      CBDPRLL1                                                 MD055891
     C                   MOVEL     'N'           W0PMT             1
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
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * CB0410D Precompiler - Dependency Relations  *
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
     C/COPY WNCPYSRC,CB0410DPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0410DPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINT                                                              MD055891
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055891
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0410DPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001
