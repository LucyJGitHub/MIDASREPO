     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas ME Outgoing messages status report')             *
      *****************************************************************
      *                                                               *
      *  Midas - MESSAGE MANAGEMENT                                   *
      *                                                               *
      *  ME0841 - Outgoing message status report                      *
      *                                                               *
      *  c) Finastra International Limited 2019                       *
      *                                                               *
      *  Last Amend No. MD051728*CREATE    Date 13Mar19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD051728 - Midas ME Outgoing Message Status (ME0840P1)       *
      *             report is still reporting/capturing messages      *
      *              from the previous days                           *
      *                                                               *
      *****************************************************************
     FMGOREFL0  IF   E           K DISK
     F                                     RENAME(MGOREFD0:MGOREF)
     FME0840AU  O    E             PRINTER INFDS(SPOOLA)
     F                                     OFLIND(*IN62)
     F                                     USROPN
     FME0840P1  O    E             PRINTER INFDS(SPOOLP)
     F                                     OFLIND(*IN61)
     F                                     USROPN
      ****************************************************************
      * ID C  F  H  L    Function of indicaators                     *
      * 01               DSRUN (DATA AREA) not found indicator       *
      * 99               Read & Chain fail indicator                 *
      * 87               Multibranch environment                     *
      * 88               Read & Chain fail indicator                 *
      * 44               Used to control output in printer ME0810P1  *
      * 45               From and To dates are blank                 *
      * 52               LOKUP to ARRA                               *
      * 11               Used in ARRAY search                        *
      * 20               Prevent output of release time              *
      * 61               Over flow indicator                         *
      * 62               ME0840AU over flow indicator                *
      * 97               CHAIN fail on MGOREFL0                      *
      * 98               End of file indicator                       *
      * U7U8LR           DB error                                    *
      **------------------------------------------------------------**
      ** The following /COPY line includes all the defined fields in *
      ** the Program Status Data Structures.  They have meaningful   *
      ** names, prefixed by 'PS'.                                    *
      **------------------------------------------------------------**
     D/COPY WNCPYSRC,ME0840EEP1
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D ARR             S             16    DIM(2000)
     D PAG             S              4  0 DIM(2000)
     D ASTS            S             40    DIM(6) CTDATA PERRCD(1)
     D/COPY WNCPYSRC,ME0840E001
     D TABCD           S              4    DIM(48) CTDATA PERRCD(1)
     D TABNAR          S             35    DIM(48) ALT(TABCD)
     D/COPY WNCPYSRC,ME0840E002
     D DELN            S             12    DIM(3) CTDATA PERRCD(1)
     D TABMM           S              2    DIM(12) CTDATA PERRCD(1)
     D TABMON          S              3    DIM(12) ALT(TABMM)
     D ARRA            S              3    DIM(100)
     D ARRB            S              3  0 DIM(100)
     D ARRC            S              3  0 DIM(100)
     D SPOOLA          DS
     D  AFILE                 83     92
     D  AFNUM                123    124B 0
     D SPOOLP          DS
     D  PFILE                 83     92
     D  PFNUM                123    124B 0
     D  LINE                 367    368B 0

     D wSqlStr         s           2000a   inz(*blanks)
     D RefFile       e ds                  extname(MGOREFPD)
     D TransactDS      ds                  likeds(RefFile)
     D                                     dim(30000)
     D CurIndex        s             10s 0 inz(*zeros)
     D wRowsReturned   s             10s 0 inz(*zeros)
     D MAX_ARRAY       s              8s 0 inz(0)
     D Loop            s              1a   inz('1')
      *
      **  File information data structure
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      **  Local data area data structure
      *
     D DSRUN           DS
     D  RDAT                   1      7
     D  @DD                    1      2
     D  @MMM                   3      5
     D  @YY                    6      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      *
      **  RUNDAT data area data structure (date format -ddmmmyy)
      *
     D @RPARM          DS
     D  @@LVL                  1      1
     D  @@BCH                  2      4
     D  @@RPRM                 5    104
     D  @NTWRK                 5     10
     D  @MODID                11     12
     D  @EXSYI                13     18
     D  @FMDAT                19     24
     D  @@FMYY                19     20
     D  @@FMMM                21     22
     D  @@FMDD                23     24
     D  @TODAT                25     30
     D  @@TOYY                25     26
     D  @@TOMM                27     28
     D  @@TODD                29     30
     D  @MSGST                31     34
     D  @A                    31     31
     D  @B                    32     32
     D  @C                    33     33
     D  @D                    34     34
     D  @PTY                  35     35
      *
      **  Parameters for &RPARM - 100 long string passed to RCF
      *
     D STS             DS            70    OCCURS(5)
     D  STS1                   1     13
     D  STS2                  14     53
     D  STS3                  55     62
     D  STS4                  64     64
      *
      **  Mult data structure for message status
      *
     D FMDAT           DS
     D  FMDM                   1      4
     D  FMYY                   5      6
      *
      **  Data structure for FROM date (ddmmyy or mmddyy)
      *
     D TODAT           DS
     D  TODM                   1      4
     D  TOYY                   5      6
      *
      **  Data structure for TO date (ddmmyy or mmddyy)
     D                 DS
     D  RELTX                  1      6  0
     D  @@HH                   1      2
     D  @@MM                   3      4
     D  @@SS                   5      6
      **  Data structure for release TIME
      *
     D                 DS
     D  @RELT                  1      8
     D  @HH                    1      2
     D  @                      3      3    INZ(':')
     D  @MM                    4      5
     D  @@                     6      6    INZ(':')
     D  @SS                    7      8
      **  Data structure for expanded time
      *
     D                 DS
     D  MGDEX                  1      6  0
     D  MGDEY                  1      2
     D  MGDEM                  3      4
     D  MGDED                  5      6
      *
     D                 DS
     D  MGDEF                  1      7
     D  DAY                    1      2
     D  MONTH                  3      5
     D  YEAR                   6      7
     D/COPY WNCPYSRC,ME0840I001
      *
      ** MGDE & MGDEF are used to convert date from yymmdd to ddmmmyy
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      **  MMOD details
      *
     D SDBANK        E DS                  EXTNAME(SDSBNKTD)
      *
      **  Bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+
     D EQUAL           c                   const(0)
     D HIGH            c                   const(1)
     D IGNORE_ERROR    c                   const(30)
     D LOW             c                   const(-1)
     D MAX_TABLE       c                   const(7)
     D MAX_EXTR        c                   const(3)
     D MAX_COLS        c                   const(34)
     D NOT_EXIST       c                   const(-204)
     D NO_ERROR        c                   const(0)
     D NO_RECORD       c                   const(100)
     D NOT_ALL_GRANT   c                   const(570)
     D NOT_FOUND       c                   const(-204)
     D QUO             c                   const('''')
     D START           c                   const(1)
     D TABLE_CREATED   c                   const(7905)
     D TABLE_IS_OPEN   c                   const(-501)
      *
     D POP01           S             20A
     D PVL01           S            200A
     D POP02           S             20A
     D PVL02           S            200A
     D POP03           S             20A
     D PVL03           S            200A
     D POP04           S             20A
     D PVL04           S            200A
     D POP05           S             20A
     D PVL05           S            200A
     D POP06           S             20A
     D PVL06           S            200A
     D POP07           S             20A
     D PVL07           S            200A
     D POP08           S             20A
     D PVL08           S            200A
     D POP09           S             20A
     D PVL09           S            200A
     D POP10           S             20A
     D PVL10           S            200A
      *
      **  First data structure for access program, Short data structure
      *
     C/EJECT
      *
      ** Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      **  Parameters passed from RCF & ME0835
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RSEQ            5
     C     @@LVL         PARM                    @@LVLP            1
     C     @@BCH         PARM                    @@BCHP            3
     C     @@RPRM        PARM                    @@PRMP          100
     C                   PARM                    @@ALLP          500
      *
      **  Parameters passed to AOMMODR0
      *
     C     PLIST1        PLIST
     C                   PARM      '*DBMSG  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      **  Parameters passed to AOBANKR0
      *
     C     PLIST5        PLIST
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      **  Parameters passed to ZSFILE
      *
     C     PLIST4        PLIST
     C                   PARM                    @@RSEQ
     C                   PARM      BRCA2         @PARM             3
     C                   PARM                    SFILE            10
     C                   PARM                    ZSNUM             6 0
     C                   PARM                    ZSERR             1
      *
     C     *DTAARA       DEFINE                  LDA
      *
      *******************************************************************
      *                   Index to subroutines                          *
      *   MAIN   - Main process                                         *
      *   INIT   - Initial process                                      *
      *   DETLP  - Detail processing                                    *
      *   SPLF  -  Ensure Spool File recorded by RCF                    *
      *   SYSLVL - System level processing                              *
      *   ALLBCH - all branches processing                              *
      *   SNGBCH - single branch processing                             *
      *   *PSSR  - Error handling                                       *
      *******************************************************************
     C/EJECT
      *******************************************************************
      *   MAIN   - Main process                                         *
      *   Calls  - INIT - Init process                                  *
      *            DETLP - Detail processing                            *
      *******************************************************************
      *
      **  Perform initial process

     C                   EVAL      @RTCD = *BLANKS
     C                   EVAL      POP01 = 'ME0840CacheSize'
     C                   EVAL      PVL01 = *BLANKS

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    POP01
     C                   PARM                    PVL01
     C                   PARM      *BLANKS       POP02
     C                   PARM      *BLANKS       PVL02
     C                   PARM      *BLANKS       POP03
     C                   PARM      *BLANKS       PVL03
     C                   PARM      *BLANKS       POP04
     C                   PARM      *BLANKS       PVL04
     C                   PARM      *BLANKS       POP05
     C                   PARM      *BLANKS       PVL05
     C                   PARM      *BLANKS       POP06
     C                   PARM      *BLANKS       PVL06
     C                   PARM      *BLANKS       POP07
     C                   PARM      *BLANKS       PVL07
     C                   PARM      *BLANKS       POP08
     C                   PARM      *BLANKS       PVL08
     C                   PARM      *BLANKS       POP09
     C                   PARM      *BLANKS       PVL09
     C                   PARM      *BLANKS       POP10
     C                   PARM      *BLANKS       PVL10
      *
     C                   IF        @RTCD  <>  *BLANKS
     C                   MOVEL     'SDSVALPD'    DBFILE
     C                   Z-ADD     103           DBASE                U7U8
     C                   MOVEL     POP01         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      MAX_ARRAY = %DEC(PVL01: 5: 0)
      *
      **  Open cursor for processing
      *
     C                   EXSR      OpenCursor
      *
      **  Perform        initialisation
      *
     C                   EXSR      INIT
      *
      **  Perform        process
      *
     C                   EXSR      DETLP
      *
      **  Close all cursors
      *
     C                   EXSR      CloseCursor
      *
      **  Set on LR
      *
     C                   SETON                                        LR
     C/EJECT
      *******************************************************************
      *   INIT   - Initial process                                      *
      *   Called by main process                                        *
      *******************************************************************
     C     INIT          BEGSR

      *
      *
      **  Access sdmmodpd (via aommodr0)
      *
     C                   CALL      'AOMMODR0'    PLIST1
      *
      **  Error handling for access object
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'ME0840  '    DBPGM
     C                   MOVE      '01'          DBASE
     C                   MOVE      'AOMMODR0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Access data area DSRUN to find date & multbranch indicator
      *
     C     *DTAARA       DEFINE    RUNDAT        DSRUN
     C     *LOCK         IN        DSRUN
     C                   OUT       DSRUN
     C     MBIN          COMP      'Y'                                    87
      *
      **  If data area not found then perform database error processing
      *
     C     RDAT          IFEQ      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'ME0840  '    DBPGM
     C                   MOVE      '02'          DBASE
     C                   MOVE      'RUNDAT'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Access sdbanktd (via AOSBNKR0) & verify date format
      *
     C                   CALL      'AOSBNKR0'    PLIST5
      *
      **  Error handling for access object
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'ME0840  '    DBPGM
     C                   MOVE      '04'          DBASE
     C                   MOVE      'AOBANKR0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      BJMRDT        RDAT
     C                   ENDIF
     C*
     C**  Access SAR details file to see if S01518 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'S01518'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01518            1
     C                   ELSE
      *
     C     @RTCD         IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'ME0840  '    DBPGM
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '*VERIFY'     DBKEY
     C                   Z-ADD     05            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      'N'           S01518
     C                   END
     C                   END
      *
      **  Date convertion process from (yymmdd) to (mmddyy or ddmmyy)
      *
     C                   MOVE      @@FMYY        FMYY
     C                   MOVE      @@TOYY        TOYY
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     @@FMMM        FMDM
     C                   MOVE      @@FMDD        FMDM
     C                   MOVEL     @@TOMM        TODM
     C                   MOVE      @@TODD        TODM
     C                   ELSE
     C                   MOVEL     @@FMDD        FMDM
     C                   MOVE      @@FMMM        FMDM
     C                   MOVEL     @@TODD        TODM
     C                   MOVE      @@TOMM        TODM
     C                   END
      **  Check to see if the dates are blank
      *
     C     FMDAT         IFEQ      *BLANKS
     C     TODAT         ANDEQ     *BLANKS
     C                   SETON                                        45
     C                   END
      *
      **  Read outgoing message file PF/MGOREFPD
      *
     C                   EXSR      READVR
      *
      **  Setting up index & variable
      *
     C                   Z-ADD     0             X                 4 0
     C                   Z-ADD     0             PA                5 0
     C                   MOVE      BRCA          BCHWK3            3
      *
      **  Set up mult data structure STS
      *
     C                   Z-ADD     1             Y                 1 0
     C     Y             OCCUR     STS
      *
     C                   MOVEA     ASTS(1)       STS1
     C                   MOVEA     ASTS(2)       STS3
     C                   MOVE      @PTY          STS4
      *
     C     @A            IFNE      *BLANKS
     C     Y             OCCUR     STS
     C                   MOVEA     ASTS(3)       STS2
     C                   ADD       1             Y
     C                   END
      *
     C     @B            IFNE      *BLANKS
     C     Y             OCCUR     STS
     C                   MOVEA     ASTS(4)       STS2
     C                   ADD       1             Y
     C                   END
      *
     C     @C            IFNE      *BLANKS
     C     Y             OCCUR     STS
     C                   MOVEA     ASTS(5)       STS2
     C                   ADD       1             Y
     C                   END
      *
     C     @D            IFNE      *BLANKS
     C     Y             OCCUR     STS
     C                   MOVEA     ASTS(6)       STS2
     C                   ADD       1             Y
     C                   END
      *
     C     Y             OCCUR     STS
     C                   MOVE      *BLANKS       STS
     C/COPY WNCPYSRC,ME0840C001

     C                   ENDSR
     C/EJECT
      *******************************************************************
      *   DETLP  - Detail processing                                    *
      *   Called by main process                                        *
      *******************************************************************
     C     DETLP         BEGSR
      *
      **  If no record found on the file FP/MGOREFPD
      *
     C     *IN98         IFEQ      '1'
      *
      **  Open Audit printer file PRTF/ME0810AU & call ZSFILE via SPLF
      *
     C                   OPEN      ME0840AU
     C                   MOVE      AFILE         SFILE            10
     C                   Z-ADD     AFNUM         ZSNUM             6 0
      *
     C                   EXSR      SPLF
      *
      **  Write 'no records to report'
      *
     C                   WRITE     AU1
     C                   WRITE     RR0
     C                   WRITE     RR0C
      *
     C     1             DO        Y             Z                 1 0
     C     Z             OCCUR     STS
     C                   WRITE     SSTLN
     C                   END
      *
     C                   WRITE     AU1
     C                   WRITE     RR02
      *
      **  Close Audit printer file PRTF/ME0840AU
      *
     C                   CLOSE     ME0840AU
      *
      **  Else records present to process
      *
     C                   ELSE
      *
      **  If level selected is system ( @@LVL = 'S')
      **  Process messages at system level
      *
     C     @@LVL         IFEQ      'S'
     C                   EXSR      SYSLVL
     C                   END
      *
      **  If level selected is system ( @@LVL = 'B')
      **  and selected branch is 'ALL' ( @@BCH = 'ALL')
      **  Process messages for all branches
      *
     C     @@LVL         IFEQ      'B'
     C     @@BCH         ANDEQ     'ALL'
     C                   EXSR      ALLBCH
     C                   END
      *
      **  If level selected is system ( @@LVL = 'B')
      **  and selected branch is  NOT 'ALL' ( @@BCH NOT = 'ALL')
      **  Process messages as for single branch
      *
     C     @@LVL         IFEQ      'B'
     C     @@BCH         ANDNE     'ALL'
     C                   EXSR      SNGBCH
     C                   END
      *
     C     S01518        IFEQ      'Y'
     C     ARRA(1)       ANDNE     *BLANKS
      **  Open Audit printer file PRTF/ME0810AU & call ZSFILE via SPLF
      *
     C                   OPEN      ME0840AU
     C                   MOVE      'Y'           FILOPN            1
     C                   MOVE      AFILE         SFILE            10
     C                   Z-ADD     AFNUM         ZSNUM             6 0
      *
     C                   EXSR      SPLF
      *
      **  Print message count
     C                   WRITE     AU1
     C                   WRITE     R07
     C                   Z-ADD     1             L
     C                   MOVEL     'MT'          MSGTPX
     C     ARRA(L)       DOWNE     *BLANKS
     C                   MOVE      ARRA(L)       MSGTPX
     C                   MOVE      ARRC(L)       MSCNTX
      *
      **  IF end of page - throw a page and print headings R01
      *
     C     *IN62         IFEQ      '1'
     C                   WRITE     AU1
     C                   WRITE     R07
     C                   SETOFF                                       62
     C                   END
     C                   WRITE     R08
     C                   ADD       1             L
     C                   END
     C*
     C                   END
     C                   END
      *
     C                   ENDSR
     C/EJECT
      *******************************************************************
      *   SYSLVL - System level processing                              *
      *   Called by detlp process                                       *
      *******************************************************************
     C     SYSLVL        BEGSR
      *
      **  Open printer file PRTF/ME0840P1
      *
     C                   OPEN      ME0840P1
     C                   MOVE      PFILE         SFILE
     C                   Z-ADD     PFNUM         ZSNUM
      *
      **  Call ZSFILE via SPLF
      *
     C                   EXSR      SPLF
      *
      **  Print report title
      *
     C                   WRITE     R01
     C                   ADD       1             PA
     C                   WRITE     R00
     C                   WRITE     R00C
      *
     C     1             DO        Y             Z                 1 0
     C     Z             OCCUR     STS
     C                   WRITE     STATUS
     C                   END
      *
      **  Write Headings
     C                   WRITE     R01
     C                   WRITE     R011
      *
      **  Do while NOT = eof (MGOREFPD)
     C     *IN98         DOWEQ     '0'
      *
      **  Do until branch (BRCA ON PF/MGOREFPD) changes
      *
     C     BCHWK3        DOWEQ     BRCA
     C     *IN98         ANDEQ     '0'
      *
      **  Print message processing
      *
     C                   EXSR      PRTM
      *
      **  Execute message type count if S01518 on
      *
     C     S01518        IFEQ      'Y'
     C                   EXSR      MSGCNT
     C                   END
      *
      **  Read next record from PF/MGOREFPD
      *
     C                   EXSR      READVR
      *
     C                   END
      *
      **  Write end of report for Branch - R03
      *
     C     MBIN          IFEQ      'Y'
     C*
     C     LINE          IFGT      55
     C                   WRITE     R01
     C                   ADD       1             PA
     C                   END
     C*
     C                   WRITE     R03
     C                   SETON                                        61
     C                   END
      *
     C                   MOVE      BRCA          BCHWK3
      *
     C                   END
      *
      **  Write end of report - R04
      *
     C     MBIN          IFEQ      'N'
     C                   SETON                                        44
     C                   WRITE     R01
     C                   SETOFF                                       44
     C                   ADD       1             PA
     C                   WRITE     R04
     C                   END
      *
      **  Close printer file PRTF/ME0840P1
      *
     C                   CLOSE     ME0840P1
      *
     C                   ENDSR
     C/EJECT
      *******************************************************************
      *   ALLBCH - all branches processing                              *
      *   Called by detlp process                                       *
      *******************************************************************
     C     ALLBCH        BEGSR
      *
      **  Do while NOT = eof (MGOREFPD)
      *
     C     *IN98         DOWEQ     '0'
      *
      **  Open printer file PRTF/ME0840P1
      *
     C                   OPEN      ME0840P1
     C                   MOVE      PFILE         SFILE
     C                   Z-ADD     PFNUM         ZSNUM
      *
      **  Reset the ARRAY & the INDEX to blank & 0 respectively
      **  (Every time the Branch changes)
      *
     C                   MOVEA     *BLANKS       ARR
     C                   MOVEA     *ZERO         PAG
     C                   Z-ADD     0             X
     C                   Z-ADD     0             PA
      *
      **  Call ZSFILE via SPLF
      *
     C                   EXSR      SPLF
      *
      **  Print report title - R00
      *
     C                   WRITE     R01
     C                   ADD       1             PA
     C                   WRITE     R00
      *
     C                   WRITE     R00C
      *
     C     1             DO        Y             Z
     C     Z             OCCUR     STS
     C                   WRITE     STATUS
     C                   END
      *
      ** Write Headings
     C                   WRITE     R01
     C                   WRITE     R011
      *
      **  Do until branch (BRCA ON PF/MGOREFPD) changes
     C     BCHWK3        DOWEQ     BRCA
     C     *IN98         ANDEQ     '0'
      *
      **  Print message processing
      *
     C                   EXSR      PRTM
      *
      **  Execute message type count IF S01518 on
      *
     C     S01518        IFEQ      'Y'
     C                   EXSR      MSGCNT
     C                   END
      *
      **  Read next record from PF/MGOREFPD
      *
     C                   EXSR      READVR
      *
     C                   END
      *
      **  Write end of report for Branch - R03
      *
     C     MBIN          IFEQ      'Y'
     C     *IN61         IFEQ      '1'
     C                   WRITE     R01
     C                   SETOFF                                       61
     C                   END
     C                   ADD       1             PA
     C*
      **  Write message type count if S01518 on
     C     S01518        IFEQ      'Y'
     C                   EXSR      MSGPRT
     C                   END
     C*
     C     *IN61         IFEQ      '1'
     C                   WRITE     R01
     C                   ADD       1             PA
     C                   SETOFF                                       61
     C                   END
     C                   WRITE     R03
     C                   END
      *
     C                   MOVE      BRCA          BCHWK3
      *
      **  Close printer file PRTF/ME0840P1
      *
     C                   CLOSE     ME0840P1
      *
     C                   END
      *
     C                   ENDSR
     C/EJECT
      *******************************************************************
      *   SNGBCH - single branch processing                             *
      *   Called by detlp process                                       *
      *******************************************************************
     C     SNGBCH        BEGSR
      *
      **  Open printer file PRTF/ME0840P1
      *
     C                   OPEN      ME0840P1
     C                   MOVE      PFILE         SFILE
     C                   Z-ADD     PFNUM         ZSNUM
      *
      **  Call ZSFILE via SPLF
      *
     C                   EXSR      SPLF
      *
      **  Print report title - R00
      *
     C                   WRITE     R01
     C                   ADD       1             PA
     C                   WRITE     R00
     C                   WRITE     R00C
      *
     C     1             DO        Y             Z
     C     Z             OCCUR     STS
     C                   WRITE     STATUS
     C                   END
      *
      ** Write Headings
     C                   WRITE     R01
     C                   WRITE     R011
      *
      **  Do until branch (BRCA ON PF/MGOREFPD) changes
      *
     C     *IN98         DOWEQ     '0'
      *
      **  Print message processing
      *
     C                   EXSR      PRTM
      *
      **  Execute message type count IF S01518 on
      *
     C     S01518        IFEQ      'Y'
     C                   EXSR      MSGCNT
     C                   END
      *
      **  Read next record from PF/MGOREFPD
      *
     C                   EXSR      READVR
      *
     C                   END
      *
     C                   MOVE      BRCA          BCHWK3
      *
      **  Write end of report for Branch - R04
      *
     C     MBIN          IFEQ      'N'
     C     *IN61         IFEQ      '1'
     C                   SETON                                        44
     C                   WRITE     R01
     C                   SETOFF                                       44
     C                   SETOFF                                       61
     C                   END
     C                   ADD       1             PA
     C                   WRITE     R04
     C                   END
      *
      **  Close printer file PRTF/ME0840P1
      *
     C                   CLOSE     ME0840P1
      *
     C                   ENDSR
     C/EJECT
      *******************************************************************
      *   PRTM   - Print message processing                             *
      *   Called by syslvl,allbch & sngbch processing                   *
      *******************************************************************
     C     PRTM          BEGSR
      *
      ** Change date from YYMMDD to DDMMMYY
     C                   MOVE      MGDEY         YEAR
     C                   MOVE      MGDED         DAY
     C     MGDEM         LOOKUP    TABMM         TABMON                   50
     C                   MOVE      TABMON        MONTH
     C/COPY WNCPYSRC,ME0840C002
      *
     C                   MOVEL     *BLANKS       NWRKF
     C                   MOVEL     NWRK          NWRKF
      *
      ** If not released set on flag to prevent output of release time
     C     RELT          IFEQ      *ZERO
     C                   SETON                                        20
     C                   ELSE
      *
      ** Format release time using data structures
     C                   MOVE      @@HH          @HH
     C                   MOVE      @@MM          @MM
     C                   MOVE      @@SS          @SS
     C                   END
      *
      **  Use delivery status if present on MGOREFPD for status descr
     C                   MOVE      *BLANKS       MSTT
     C     DYST          IFNE      *BLANKS
     C     DYST          IFEQ      '07'
     C                   MOVEL     DELN(1)       MSTT
     C/COPY WNCPYSRC,ME0840C003
     C                   ELSE
     C     DYST          IFEQ      '08'
     C                   MOVEL     DELN(2)       MSTT
     C/COPY WNCPYSRC,ME0840C004
     C                   ELSE
     C                   MOVEL     DELN(3)       MSTT
     C/COPY WNCPYSRC,ME0840C005
     C                   END
     C                   END
      *
      **  Otherwise use message status to obtain status description
     C                   ELSE
     C     MGST          LOOKUP    TABCD         TABNAR                   51
     C     *IN51         IFEQ      '1'
     C                   MOVEL     TABNAR        MSTT
     C/COPY WNCPYSRC,ME0840C006
     C                   ELSE
      *
     C/COPY WNCPYSRC,ME0840CCP1
      *
     C                   MOVEL     MGST          MSTT
     C/COPY WNCPYSRC,ME0840C007
     C                   END
      *
     C/COPY WNCPYSRC,ME0840CCP2
      *
     C                   END
      *
      ** Save status description
     C                   MOVEL     MSTT          SAVST            12
      *
      ** If part deleted, set printed description to DEL/PART
      ** (ie. deleted part)
     C     PTST          IFEQ      'D'
     C                   MOVEL     'Del/part'    MSTT
     C                   ENDIF
      *
      ** Obtain delivery notification and non del warning flags
     C                   MOVE      'N'           DLNOT
     C                   MOVE      'N'           NDELW
      *
     C     DELC          IFEQ      '1'
     C                   MOVE      'Y'           NDELW
     C                   END
      *
     C     DELC          IFEQ      '2'
     C                   MOVE      'Y'           DLNOT
     C                   END
      *
     C     DELC          IFEQ      '3'
     C                   MOVE      'Y'           DLNOT
     C                   MOVE      'Y'           NDELW
     C                   END
      *
      *
      **  IF end of page - throw a page and print headings R01
      *
     C     *IN61         IFEQ      '1'
     C                   WRITE     R01
     C                   WRITE     R011
     C                   ADD       1             PA
     C                   SETOFF                                       61
     C                   END
      *
      **  Output line of message detail
      *
     C                   WRITE     DETL
      *
      **  If this is a multiple, print status of parts
     C     TRNM          DOWNE     *BLANKS
     C     TRNM          CHAIN     MGOREFL0                           77
      *
      **  Database error if msg part not found.
     C     *IN77         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     TRNM          DBKEY
     C                   MOVEL     'ME0810  '    DBPGM
     C                   MOVE      '08'          DBASE
     C                   MOVE      'MGOREFL0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     TRNO          @PTRN
     C     PTST          IFEQ      'D'
     C                   MOVEL     'Del/part'    @PST
     C                   ELSE
     C                   MOVEL     SAVST         @PST
     C                   END
     C     *IN61         IFEQ      '1'
     C                   WRITE     R01
     C                   WRITE     R011
     C                   ADD       1             PA
     C                   SETOFF                                       61
     C                   END
     C                   WRITE     @PART
     C                   ENDDO
     C                   SETOFF                                       20
      *
     C                   ENDSR
     C/EJECT
      *******************************************************************
      *   SPLF  - Ensure Spool File recorded by RCF                     *
      *   Called by - detlp,syslvl,allbch, & sngbch processing          *
      *******************************************************************
      *
     C     SPLF          BEGSR
      *
      **  Set up key
      *
     C     @@BCH         IFEQ      'ALL'
     C                   MOVEL     BRCA          BRCA2
     C                   ELSE
     C                   MOVE      @@BCH         BRCA2             3
     C                   END
      *
     C                   CALL      'ZSFILE'      PLIST4
      *
     C     ZSERR         IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *
     C/EJECT
      *******************************************************************
      *   READVR - read a valid record                                  *
      *   Called by -                                                   *
      *******************************************************************
      *
     C     READVR        BEGSR
     C                   EVAL      *IN98 = '0'
     C     Loop          DOWEQ     '1'
     C                   EVAL      CurIndex = Curindex + 1
     C     CurIndex      IFGT      wRowsReturned
     C                   EXSR      ReadCursor
     C     *IN98         IFEQ      *ON
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      RefFile = TransactDS(CurIndex)
     C                   MOVE      MGDE          MGDEX
     C                   MOVE      RELT          RELTX
     C                   EXSR      ELIG
     C     OK            IFEQ      'Y'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDDO
     C                   ENDSR
      *
     C/EJECT
      *******************************************************************
      *   ELIG - check message is eligible for printing                 *
      *   Called by - READVR                                            *
      *******************************************************************
      *
     C     ELIG          BEGSR
      *
      **  Initially flag message as OK
     C                   MOVE      'Y'           OK                1
      *
      **  If message is part of a multiple, access header part to check
      **  that any amendments (which only update the header) have not
      **  rendered the message ineligible for reporting according to
      **  the user's selection criteria.
     C     TRNF          IFNE      *BLANKS                                                B1
      *
      **  Save this TRN
     C                   MOVEL     TRNO          WK16             16
      *
     C     TRNF          CHAIN     MGOREFL0                           97
      *
      **  Database error if header not found
     C     *IN97         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     TRNF          DBKEY
     C                   MOVEL     'ME0810  '    DBPGM
     C                   MOVE      '06'          DBASE
     C                   MOVE      'MGOREFL0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Check all amendable fields meet selection criteria
     C     MGSG          IFEQ      '1'
     C     @A            ANDEQ     *BLANKS
     C                   MOVE      'N'           OK
     C                   END
     C     MGSG          IFEQ      '2'
     C     @B            ANDEQ     *BLANKS
     C                   MOVE      'N'           OK
     C                   END
     C     MGSG          IFEQ      '3'
     C     @C            ANDEQ     *BLANKS
     C                   MOVE      'N'           OK
     C                   END
     C     MGSG          IFEQ      '4'
     C     @D            ANDEQ     *BLANKS
     C                   MOVE      'N'           OK
     C                   END
      *
     C     @NTWRK        IFNE      NWRK
     C     @NTWRK        ANDNE     *BLANKS
     C                   MOVE      'N'           OK
     C                   END
      *
     C     @PTY          IFNE      MPRY
     C     @PTY          ANDNE     *BLANKS
     C                   MOVE      'N'           OK
     C                   END
      *
      **  Re-access part
     C     WK16          CHAIN     MGOREFL0                           97
      *
     C                   END
      *
     C                   ENDSR
     C/EJECT
      *******************************************************************
      *   MSGCNT -  Count message type read                             *
      *   Called by - SYSLVL, ALLBCH, SNGBCH                            *
      *******************************************************************
      *
     C     MSGCNT        BEGSR
     C*
     C                   Z-ADD     1             L                 3 0
     C     MTPY          LOOKUP    ARRA(L)                                52
     C*  If found, add to count
     C     *IN52         IFEQ      '1'
     C                   ADD       1             ARRB(L)
     C                   ADD       1             ARRC(L)
     C                   ELSE
     C                   ADD       1             M                 3 0
     C                   MOVE      MTPY          ARRA(M)
     C                   ADD       1             ARRB(M)
     C                   ADD       1             ARRC(M)
     C                   END
     C*
     C                   ENDSR
     C/EJECT
      *******************************************************************
      *   MSGPRT -  Print number of outgoing message types by branch    *
      *             and include overall figure for the report           *
      *   Called by - SYSLVL, ALLBCH, SNGBCH                            *
      *******************************************************************
      *
     C     MSGPRT        BEGSR
     C*
     C                   Z-ADD     1             L
     C                   MOVEL     'MT'          MSGTP             5
     C                   WRITE     R05
     C     ARRA(L)       DOWNE     *BLANKS
     C     ARRB(L)       IFNE      0
     C                   MOVE      ARRA(L)       MSGTP
     C                   Z-ADD     ARRB(L)       MSCNT
     C                   Z-ADD     0             ARRB(L)
     C     *IN61         IFEQ      '1'
     C                   WRITE     R01
     C                   WRITE     R05
     C                   ADD       1             PA
     C                   SETOFF                                       61
     C                   END
     C                   WRITE     R06
     C                   END
     C                   ADD       1             L
     C                   END
     C*
     C                   ENDSR
     C/EJECT
      ********************************************************************
      *   *PSSR - error handling                                         *
      *   Called by - main,init,prtm & splf processing                   *
      ********************************************************************
      *
      *
     C     *PSSR         BEGSR
      *
      **  Write database error to report
      *
     C     FILOPN        IFNE      'Y'
     C                   OPEN      ME0840AU
     C                   END
     C                   WRITE     AU1
     C                   WRITE     DBERROR
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *******************************************************************
      *   OpenCursor - Open SQL Cursor                                  *
      *   Called by -  Main Processing                                  *
      *******************************************************************
      /free
       begsr OpenCursor;
            wSQLStr= 'select * from MGOREFPD where ' +
                      %TRIM(@@ALLP) + ' order by BRCA, MGDE, TRNO';

                   exec sql prepare P1 from :wSQLStr;
                   exec sql declare P1 cursor for P1;
                   exec sql open P1;
                   exec sql fetch next from P1 for :MAX_ARRAY
                   rows into :TransactDS;
                   wRowsReturned = SqlErrd(3);
                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBkey = *Blanks;
                      dBfile = 'MGOREFPD';
                      dBase = 101;
                      dBpgm  = 'ME0841';
                      exsr *pssr;
                   endif;
                   CurIndex = 0;
       endsr;

       //**************************************************************//
       // ReadCursor - Read next sets of data from table               //
       // Called by -  READVR                                          //
       //**************************************************************//

       begsr ReadCursor;

                   exec sql fetch next from P1 for :MAX_ARRAY
                   rows into :TransactDS;
                   wRowsReturned = SqlErrd(3);
                   select;
                   when sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBfile = 'MGOREFPD';
                      dBase = 102;
                      dBpgm  = 'ME0841';
                      exsr *pssr;
                   when sqlcod = NO_RECORD;
                      *in98 = '1';
                   other;
                      CurIndex = 1;
                   endsl;

       endsr;

       //**************************************************************//
       // CloseCursor - Close P1                                       //
       // Called by -  Main Processing                                 //
       //**************************************************************//

       begsr CloseCursor;
                   exec sql close P1;
       endsr;

      /end-free
      ********************************************************************

     X/COPY WNCPYSRC,ME0840X001
** CPY@   **      Object copyright
(c) Finastra International Limited 2019
**  ASTS
Status
Priority
UNRELEASED
RELEASED INCOMPLETE
RELEASED COMPLETE
CANCELLED/RELEASED/UNDELIVERED
** TABCD/TABNAR - Table of Status/Narrative
CRTDCreated
AMNDAmended
DLTDDeleted
RSNDRdy to send
PENDPending Trans
TRANTransmitted
EFMTFormat error
ELAULgl Auth err
ESEQInp seq err
ETIDTerm ID err
ELENMsg lgth err
EAUTSW auth err
QRDQRDYQ error
QVRQVRYQ error
LACKLogical ack
NACKNegative ack
EBL1Err basic hd
EBL2Err applc hd
EBL4Err in text
EBL5Err trailer
PRTDPrinted
RRTDRe-routed
TSNTSent                                                                  066991
TOUTPending Tx                                                            066991
TCANCancelled                                                             066991
TRTYIn retry                                                              066991
TACTActive                                                                081505
TSENSent                                                                  081505
THLEHeld - error                                                          066991
THLOHeld/Oper.                                                            081505
TBOXAt Telex box                                                          066991
TCNRCancel req.                                                           066991
TRELHeld on TlxQ                                                          081505
TWTGWaiting                                                               081505
TRTSRdy to send                                                           066991
TDESIn despatch                                                           066991
TONQOn Tlx queue                                                          066991
TCMPComplete                                                              081505
TUNKUnknown                                                               066991
TRRTRe-route Q                                                            066991
TDLTDeleted                                                               081505
TSPVSupervisor                                                            081561
THORHeld by Originator                                                    CMT001
THTCHeld Time Constraints                                                 CMT001
TCARAt Carrier                                                            CMT001
THOPHeld by Operator                                                      CMT001
TIRSItem Reset                                                            CMT001
TCNAComplete not accounted yet                                            CMT001
     X/COPY WNCPYSRC,ME0840X002
** DELN - DELIVERY STATUS
No Del Atmpt
Not del/ed
Delivered
**  Months MM/MMM format
01JAN
02FEB
03MAR
04APR
05MAY
06JUN
07JLY
08AUG
09SEP
10OCT
11NOV
12DEC
