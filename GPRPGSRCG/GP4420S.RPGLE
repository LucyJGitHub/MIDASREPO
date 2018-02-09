     H DEBUG DATEDIT(*YMD)
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Select weighting code')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GP4420S - Midas Weighting Code desc selection                *
      *                                                               *
      *  Function:  This sub-file program allows the user to select   *
      *             from a list of Weighting Code details             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 247772             Date 12Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGP001             Date 08Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001   *CREATE   Date 11Oct99               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  247772 - Change LF/GPWEIGL1 by new LF/GPWEIGL2               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP001 - Global Processing.                                  *
      *           - SD442* programs renamed to GP442* series.         *
      *           - SDWEIG* files renamed to GPWEIG*.                 *
      *           - AOWEIGR0 renamed to GPAOWEIGR0.                   *
      *           - Converted to ILE.                                 *
      *  CPB001 - 'Private banking' Module                            *
      *                                                               *
      *****************************************************************
     F*SD4420S#CF*E***                 WORKSTN                        UC                      CGP001
     FGP4420S#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas Weight Code desc selection
      *
     F*SDWEIGL1IF*E***        K        DISK                           UC                      CGP001
     F***GPWEIGL1  IF   E           K DISK    USROPN                                          247772
     FGPWEIGL2  IF   E           K DISK    USROPN                                             247772
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas Weight Code det retrieval ind
      *
     D********************************************************************
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
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * FLD: Weight Code  Det
      * B : MAP Weight Code
     D  P1WEIG                 1      2
      *
     D RunBefore       S              1A
      *
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1WEIG        PARM      P1WEIG        WP0001            2            Weight Code
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL                                       DO
      * Initialise & load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested
     C     W0RSF         DOWEQ     'N'                                          DOW
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
      * Initialise & load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      *................................................................
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    PDWEIG                         Weight Code
      * Setup key
     C                   MOVEL     #2WEIG        PDWEIG                         Weight Code
     C     KPOS          SETLL     SDWEIGD0
     C                   READ      SDWEIGD0                             8782    *
      * Save previous selector values
     C     *LIKE         DEFINE    #2LCD         WZLCD
     C                   MOVEL     #2LCD         WZLCD                          Last Change Dat
     C     *LIKE         DEFINE    #2TYLC        WZTYLC
     C                   MOVEL     #2TYLC        WZTYLC                         Type of Last Ch
     C     *LIKE         DEFINE    #2WEIG        WZWEIG
     C                   MOVEL     #2WEIG        WZWEIG                         Weight Code
     C     *LIKE         DEFINE    #2DESC        WZDESC
     C                   MOVEL     #2DESC        WZDESC                         Weight Descr.
     C     *LIKE         DEFINE    #2PERC        WZPERC
     C                   MOVEL     #2PERC        WZPERC                         Percentage
     C     *LIKE         DEFINE    #2CUML        WZCUML
     C                   MOVEL     #2CUML        WZCUML                         Cumulate Perc
      * Translate search mask for text field
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2DESC        WQDESC                         Weight Code
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      30            WQA5N             5 0
     C                   PARM      #2DESC        WQDESC                         Weight Descr.
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
      * Load subfile page
     C                   Z-ADD     *ZERO         ##RROK            5 0
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
     C  N82              READP     SDWEIGD0                               90    *
     C  N82              READ      SDWEIGD0                               90    *
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKINDS            1
     C                   MOVEA     WKINDS        *IN(33)
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read
     C                   Z-ADD     *ZERO         ##RRRD            5 0
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
      * Load next SFL page until SFL page full,
      * or scan limit reached,
      * or end of file reached
     C     *IN82         DOWEQ     '0'                                          DO
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record
     C     #2LCD         IFNE      *ZERO                                        Last Change Dat
     C     PDLCD         CABNE     #2LCD         CD020                          Last Change Dat
     C                   END
     C     #2TYLC        IFNE      *BLANK                                       Type of Last Ch
     C     PDTYLC        CABNE     #2TYLC        CD020                          Type of Last Ch
     C                   END
     C     #2DESC        IFNE      *BLANK                                       Weight Descr.
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    PDDESC                         Weight Descr.
      * Length
     C                   PARM      30            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQDESC
      * Length
     C                   PARM      30            WQC3N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             CD020
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
      *
     C     CD020         TAG
      * Increment scan check count
     C                   ADD       1             ##RRRD
      * Read next record
     C                   READ      SDWEIGD0                             8782    *
     C                   END                                                    WOD
      *................................................................
      * If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *
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
      *
      * If scan limit reached, display error message
     C     ##RRRD        IFGE      W0SLM
      * Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     *ZERO         ##RROK            5 0
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen
      *================================================================
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
     C                   SETOFF                                         9283    *
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
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   EXSR      DBPRSF
      * If error, exit subroutine:
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END
      * Change of position specified
     C     WZLCD         CASNE     #2LCD         FBRQRL                         Last Change Dat
     C     WZTYLC        CASNE     #2TYLC        FBRQRL                         Type of Last Ch
     C     WZWEIG        CASNE     #2WEIG        FBRQRL                         Weight Code
     C     WZDESC        CASNE     #2DESC        FBRQRL                         Weight Descr.
     C     WZPERC        CASNE     #2PERC        FBRQRL                         Percentage
     C     WZCUML        CASNE     #2CUML        FBRQRL                         Cumulate Perc.
     C                   END
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process subfile record
     C                   EXSR      DCSFRC
     C                   MOVEL     *BLANK        #1SEL
     C                   UPDATE    #SFLRCD
      * Read next record
     C                   READC     #SFLRCD                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCSFRC        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Setof error indicators and SFLNXTCHG
     C                   MOVEA     WKINDS        *IN(33)
     C                   SETOFF                                       84        *
      * Check selection option
     C     #1SEL         CASEQ     '1'           DESLRC
     C                   END
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DESLRC        BEGSR
      *================================================================
      * Select record & return to calling program
      *================================================================
      * Move record values to parameters
     C                   MOVEL     #1WEIG        P1WEIG                         Weight code
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   DEEXIT        ENDSR
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
      * Move SDWEIGD0 fields to #SFLRCD
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   Z-ADD     PDLCD         #1LCD                          Last Change Dat
     C                   MOVEL     PDTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     PDWEIG        #1WEIG                         Weight Code
     C                   MOVEL     PDDESC        #1DESC                         Weight Descr.
     C                   MOVEL     PDPERC        #1PERC                         Percentage
     C                   MOVEL     PDCUML        #1CUML                         Cumulate Perc.
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   Z-ADD     *ZERO         #2LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #2TYLC                         Type of Last Ch
     C                   MOVEL     P1WEIG        #2WEIG                         Weight code
     C                   MOVEL     *BLANK        #2DESC                         Weight Descr.
     C                   MOVEL     *BLANK        #2PERC                         Percentage
     C                   MOVEL     *BLANK        #2CUML                         Cumulate Perc.
      * Drop ? from positioning key fields
     C                   MOVEL     #2WEIG        W0X1              1
     C     W0X1          IFEQ      '?'
     C     *LIKE         DEFINE    #2WEIG        W0WEIG          - 1
     C                   MOVE      #2WEIG        W0WEIG
     C                   MOVEL     W0WEIG        #2WEIG                         Weight Code
     C                   MOVE      ' '           #2WEIG
     C                   END
      *
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
      * Send message '*No value selected'
     C                   MOVEL     'Y2U0016'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     '*PRV '       ZAPGRL                         Rel queue
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y2U0016'     P0RTN
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
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
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
     C**********           OPEN SD4420S#                                                      CGP001
     C**********           OPEN SDWEIGL1                                                      CGP001
     C                   OPEN      GP4420S#
     C**********         OPEN      GPWEIGL1                                                   247772
     C                   OPEN      GPWEIGL2                                                   247772
     C                   MOVEL     'N'           W0PMT             1
      * Program mode
     C                   MOVEL     'SEL'         W0PMD             3
      *
     C                   Z-ADD     14            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      * Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * GP4420S Precompiler - Weight Code Det  *
      * Copyright Statement 1999 - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Clear subfile control fields
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
     C/COPY WNCPYSRC,GP4420SPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,GP4420SPS1
      *
      * Standard Midas PSSR processing.
      *
     C                   IF        RunBefore = *blanks
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      P0RTN = 'PSSR   '
     C                   DUMP
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,GP4420SPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
