     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Movements Enquiry')                 *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL008170 - Stamp Tax Movements Enquiry                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd 2010             *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. AR888911           Date 26Jan12               *
      *                 AR879983           Date 21Dec11               *
      *                 AR863954           Date 14Nov11               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR888911 - In reversing a deal, REV column in Stamp Tax      *
      *             Movements Enquiry is not changing from N to Y     *
      *           - Applied for AR944923                              *
      *  AR879983 - Add stamp tax exchange rate                       *
      *  AR863954 - Stamp Tax Movements Enquiry screen is not         *
      *             displayed (Recompile)                             *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
     FGL008170DFCF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
 
      * Stamp Tax Details File
     FSDSTMDL7  IF   E           K DISK    INFDS(INFDS1)
     F                                     INFSR(SRFILE)
     FSDSTMDL8  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FSDSTMDL9  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FSDSTMDLA  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FSDSTMDLB  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FSDSTMDLC  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FGLACNTL3  IF   E           K DISK    INFSR(SRFILE)
     FDLDLDCL3  IF   E           K DISK    INFSR(SRFILE)
     FCLONCLL1  IF   E           K DISK    INFSR(SRFILE)
     FLEFCLTLH  IF   E           K DISK    INFSR(SRFILE)
     FLEFEEQL1  IF   E           K DISK    INFSR(SRFILE)
     FTRADSQL0  IF   E           K DISK    INFSR(SRFILE)
     FINPAYQL0  IF   E           K DISK    INFSR(SRFILE)
     FOTPAYQL0  IF   E           K DISK    INFSR(SRFILE)
     FCQCOCQL0  IF   E           K DISK    INFSR(SRFILE)
     FCQPACQL0  IF   E           K DISK    INFSR(SRFILE)
     FPOSETDYL  IF   E           K DISK    INFSR(SRFILE)
     FGL008170P1O    E             PRINTER INFDS(SPOOL1) USROPN
      *
      * ***************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
 
     D EDT             S              1    DIM(80)
      ** Array of QCMDEXC commands
 
     D @STK            S             10    DIM(100)
     D @REC            S              3  0 DIM(100)
      ** Array of QCMDEXC command to edit
 
     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)
      ** Subroutine stack
 
     D SPOOL1          DS
      ** Program data structure
     D  SFILE1                83     92
     D  SFNUM                123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      ** DS FOR P1 SPOOL FILE NAME
 
     D LDA           E DS           256    EXTNAME(LDA)
 
     D ERDTA         E DS                  EXTNAME(CGERDTA)
      ** Send message data structure
 
     D M#DTA           DS           256
 
     D  #MSGTX                 1     80
     D  ##MSGD                81    256
      ** Message Data - Action field
 
     D DTDTA           DS
     D DT12                    1      2  0
     D DT34                    3      4  0
     D DT56                    5      6  0
 
     D                 DS
     D TYAVGB                  1     21    INZ('  Dr Average Balance ')
     D TYINTR                 22     42    INZ('  Dr Interest Amount ')
 
     D                 DS
     D SOACCN                  1      7    INZ('Account')
     D SODATE                  8     14    INZ('Date   ')
 
     D A#FACI          DS
 
     D A2FCNM                  1      6
     D                         7      7    INZ('-')
     D A2FACT                  8     10  0
     D                        11     11    INZ('-')
     D A2FCNO                 12     13  0
 
     D A#CHEQ          DS
 
     D A2PREF                  1     15
     D                        16     16    INZ('-')
     D A2CQSQ                 17     18
 
     D A#FEES          DS
 
     D A2FSEQ                  1      2
     D                         3      3    INZ('-')
     D A2ORED                  4     10
 
     D A#ACCD          DS
 
     D A2BRCA                  1      3
     D                         4      4    INZ('-')
     D A2CNUM                  5     10
     D                        11     11    INZ('-')
     D A2CCY                  12     14
     D                        15     15    INZ('-')
     D A2ACOD                 16     25  0
     D                        26     26    INZ('-')
     D A2ACSQ                 27     28  0
 
     D A#POSS          DS
 
     D A2PBRC                  1      3
     D A2PSSH                  4     13
     D A2PCPT                 14     19
     D A2PDUD                 20     26
     D A2PEVT                 27     28
 
     D                 DS
     D ZOUT15                  1     25
     D ZOUT0                   1     21
     D ZOUT1                   2     23
     D ZOUT2                   3     24
     D ZOUT3                   5     25
 
     D JBDTTM          DS
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      ** Job date/time
 
     D ##DATE          DS
     D  ##DD                   1      2
     D  ##MM                   3      4
     D  ##YY                   5      6
      ** DATE in DDMMYY format
 
     D #DATE           DS
     D  #MM                    1      2
     D  #CC                    3      4
     D  #YY                    5      6
      ** DATE in MMCCYY format
 
     D W#DATA          DS          1024
 
     D W#KEY                   1     10
     D W#LNRF                 11     16
     D W#FCNM                 17     22
     D W#FACT                 23     25
     D W#FCNO                 26     27
     D W#FSEQ                 28     29
     D W#ORED                 30     34  0
     D W#DLNO                 35     40
     D W#TDRF                 41     46
     D W#BRCA                 47     49
     D W#CNUM                 50     55
     D W#CCY                  56     58
     D W#ACOD                 59     68
     D W#ACSQ                 69     70
     D W#PREF                 71     85
     D W#CQSQ                 86     87
     D W#PBRC                 88     90
     D W#PSSH                 91    100
     D W#PCPT                101    106
     D W#PDUD                107    111  0
     D W#PEVT                112    113
      ** Key details
 
     D W#DACC                114    141
      ** Dr account details
 
     D W#PSDT                142    148
     D W#VLDT                149    155
      ** Posting Date and Value Date
 
     D W#GROS                156    176
      ** Gross Amount
 
     D W#TAXE                177    197
     D W#CCYE                198    200
      ** Tax Amount in Transaction/Account Ccy
 
     D W#TAXD                201    221
     D W#CCYD                222    224
      ** Tax Amount in Debit Account Ccy
 
     D W#TAXS                225    245
     D W#CCYS                246    248
      ** Tax Amount in Stamp Tax  Ccy
 
     D W#TAXA                249    269
     D W#TAXI                270    290
      ** Total Tax on Average
 
     D W#TTYP                291    291
      ** Type of Tax enquired (Interest/Average)
 
     D W#PRTF                292    292
      ** Print Flag
 
     D W#TXRT                293    313
      ** Tax Rate
 
     D W#STDT                314    318  0
     D W#EDAT                319    323  0
      **Start/End date (Midas day nr)
 
     D W#SDT                 324    329  0
     D W#EDT                 330    335  0
      ** Start/End Date
 
     D W#OPNB                336    356
     D W#CLOB                357    377
 
     D W#STP                 378    384
     D W#ENP                 385    391
      ** Start/End Period
 
     D W#AKEY                391    405
     D W#ETYP                406    407
     D W#REVI                408    408
      ** account key/event/reverse indicator
 
     D W#KAMT                409    429
     D W#KCCY                430    432
      ** account key amount/ccy
 
     D W#VDAT                433    439
     D W#MDAT                440    446
     D W#MNTH                447    451  0
     D W#DSPR                452    472
     D W#TREF                473    503
     D W#DRAC                504    531
     D W#VDTF                532    538
     D W#VDTT                539    545
     D W#PDTF                546    552
     D W#PDTT                553    559
     D W#MODU                560    562
     D W#FILE                563    572
     D W#PFRM                573    577  0
     D W#PTO                 578    582  0
     D W#SELE                583    583
     D W#DBRC                584    586
     D W#DCST                587    592
     D W#DCCY                593    595
     D W#DACD                596    605
     D W#DASQ                606    607
     D W#STFB                608    608
     D W#STFF                609    609
     D W#STFI                610    610
     D W#STFC                611    611
     D W#SBRC                612    614
     D W#SCUS                615    620
     D W#SCCY                621    623
     D W#SACD                624    633
     D W#SASQ                634    635
      ** value/maturity Date/nr of month
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
 
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
 
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      ** Get Rundate - Rundate  *
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFAC2       E                     EXTFLD(QQDFAC)
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data Structures used by Access Programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data Structures used by Access Programs
 
      /EJECT
 
      ** Parameter declarations
 
     D P1PARM          DS
     D  P1ACTC                 1      1
     D P2PARM          DS           100
     D  P2KEY                  1     10
     D  P2BRCA                11     13
     D  P2CUST                14     19
     D  P2CTRY                20     21
     D  P2ACCD                22     31
     D  P2DTYP                32     33
     D  P2DSTP                34     35
     D  P2LTYP                36     37
     D  P2LSTP                38     39
     D  P2FTYP                40     42
     D  P2LFTP                43     44
 
     D O2PARM          DS           100
     D  O2KEY                  1     10
     D  O2BRCA                11     13
     D  O2CUST                14     19
     D  O2CTRY                20     21
     D  O2ACCD                22     31
     D  O2DTYP                32     33
     D  O2DSTP                34     35
     D  O2LTYP                36     37
     D  O2LSTP                38     39
     D  O2FTYP                40     42
     D  O2LFTP                43     44
 
     D                 DS
     D  ZAMSDA                 1    132
     D  ZA0001                 1      1
 
     D DSMTR           DS
 
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      ** Define fields for message transalation
 
     D W0DATA          DS           256
      ** Define data structure used to pass parameters
 
     D  B#BRCA                 1      3
     D  O#ACTD                 4      4
     D  O#CPGM                 5     14
 
      /EJECT
      *****************************************************************
      * Main Processing
      *****************************************************************
      ** Initialize
 
     C                   EXSR      ZZINIT
 
     C                   DO        *HIVAL
 
      ** Initialise & load subfile page
 
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
 
      ** Display screen until reload requested
 
     C     W0RSF         DOWEQ     'N'
 
      ** Display screen
 
     C                   EXSR      CAEXFM
 
      ** Process response
      ** Cancel & exit program
 
     C   03              CAS                     ZXEXPG
     C   12              CAS                     ZXEXPG
 
      ** HOME: Request subfile reload
 
     C   05              CAS                     FBRQRL
 
      ** Display next SFL page
 
     C   27              CAS                     BBLDSF
 
      ** Process screen input
 
     C                   CAS                     ENTR##
     C                   ENDCS
 
     C                   ENDDO
     C                   ENDDO
      *****************************************************************
      /EJECT
      *****************************************************************
      * Initialise and load subfile page
      *****************************************************************
     CSR   BAIZSF        BEGSR
 
      ** Clear subfile
 
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
 
      ** Reset no of records in subfile
 
     C                   Z-ADD     *ZERO         ##RRMX            5 081
     C                   MOVEL     *BLANK        W0RSL             1
 
      ** Translate search mask for text field
 
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
 
      ** Load subfile page
 
     C                   Z-ADD     0             ##RROK            5 0
 
     C                   SETOFF                                         8782
 
      ** position/read file SDSTMDLx
 
     C     #FILE         IFEQ      'SDSTMDL7'
     C     KPOSAB        SETLL     @STMDVA
     C     KPAB          READE     @STMDVA                              8782
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDL8'
     C     KPOSAB        SETLL     @STMDVB
     C     KPAB          READE     @STMDVB                              8782
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDL9'
     C     T#DATE        SETLL     @STMDVC
     C                   READ      @STMDVC                              8782
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDLA'
     C     T#DATE        SETLL     @STMDVD
     C                   READ      @STMDVD                              8782
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDLB'
     C     KPOSEF        SETLL     @STMDVE
     C     KPEF          READE     @STMDVE                              8782
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDLC'
     C     KPOSEF        SETLL     @STMDVF
     C     KPEF          READE     @STMDVF                              8782
     C                   ENDIF
 
     C                   EXSR      BBLDSF
 
     CSR   BAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Load subfile page
      *****************************************************************
     CSR   BBLDSF        BEGSR
 
     C                   CLEAR                   DATE1
     C                   CLEAR                   DATE2
 
     C     #FILE         IFEQ      'SDSTMDL7'
     C     #FILE         OREQ      'SDSTMDL9'
     C     #FILE         OREQ      'SDSTMDLB'
     C                   EVAL      DATE1 = 'Val Dat'
     C                   EVAL      DATE2 = 'Post Dt'
     C                   ELSE
     C                   EVAL      DATE1 = 'Post Dt'
     C                   EVAL      DATE2 = 'Val Dat'
     C                   ENDIF
 
      ** Re-establish fields in read-ahead record
 
     C   27              DO
 
      ** Process File according to the selection made
 
     C     #FILE         IFEQ      'SDSTMDL7'
     C  N82KPAB          READPE    @STMDVA                                90
     C  N82KPAB          READE     @STMDVA                                90
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDL8'
     C  N82KPAB          READPE    @STMDVB                                90
     C  N82KPAB          READE     @STMDVB                                90
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDL9'
     C  N82              READP     @STMDVC                                90
     C  N82              READ      @STMDVC                                90
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDLA'
     C  N82              READP     @STMDVD                                90
     C  N82              READ      @STMDVD                                90
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDLB'
     C  N82KPEF          READPE    @STMDVE                                90
     C  N82KPEF          READE     @STMDVE                                90
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDLC'
     C  N82KPEF          READPE    @STMDVF                                90
     C  N82KPEF          READE     @STMDVF                                90
     C                   ENDIF
 
     C                   ENDDO
 
      ** Setof record error indicators
 
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(37)
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     ##RRMX        ##RR              5 0
 
      ** Reset count of DBF records read
 
     C                   Z-ADD     0             ##RRRD            5 0
 
      ** Set required pages based on *Set Cursor or *Subfile Pages
 
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   ENDIF
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   ENDIF
 
      ** Compute lines required based on pages
 
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   ENDIF
 
      ** Load sfile
      ** Load next SFL page until SFL page full, or
      ** Scan limit reached
 
     C     *IN82         DOWEQ     '0'
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
 
      ** If Type of transaction selected
 
     C     #3KEY         IFNE      *BLANKS
 
     C     #3KEY         IFEQ      'ACC'
     C     T2KEY         CABNE     'ACCOUNT'     BB020
     C                   ENDIF
 
     C     #3KEY         IFEQ      'LOA'
     C     T2KEY         CABNE     'LOAN   '     BB020
     C                   ENDIF
 
     C     #3KEY         IFEQ      'DEA'
     C     T2KEY         CABNE     'DEAL   '     BB020
     C                   ENDIF
 
     C     #3KEY         IFEQ      'SEC'
     C     T2KEY         CABNE     'SECURITY'    BB020
     C                   ENDIF
 
     C     #3KEY         IFEQ      'FAC'
     C     T2KEY         CABNE     'FACILITY'    BB020
     C                   ENDIF
 
     C     #3KEY         IFEQ      'FEE'
     C     T2KEY         CABNE     'FEE     '    BB020
     C                   ENDIF
 
     C     #3KEY         IFEQ      'PAY'
     C     T2KEY         IFNE      'IPAY    '
     C     T2KEY         ANDNE     'OPAY    '
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
 
     C     #3KEY         IFEQ      'CHE'
     C     T2KEY         IFNE      'CHEQC   '
     C     T2KEY         ANDNE     'CHEQP   '
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
 
     C     #3KEY         IFEQ      'POS'
     C     T2KEY         CABNE     'POSSET  '    BB020
     C                   ENDIF
 
     C                   ENDIF
 
      ** If Start Date not blank, then select date >= selected
 
     C     #3CDTE        IFNE      *BLANKS
     C     WVDATF        ANDGT     0
     C     T2VALD        CABLT     WVDATF        BB020
     C                   ENDIF
 
      ** If End Date not blank, then select date <= selected
 
     C     #3EDTE        IFNE      *BLANKS
     C     WVDATT        ANDGT     0
     C     T2VALD        CABGT     WVDATT        BB020
     C                   ENDIF
 
      ** If Posting Dates are not blank, check if record is within the
      ** From/To Date
 
     C     #3FPSD        IFNE      *BLANKS
     C     WPSDTF        ANDGT     0
     C     T2PSDT        CABLT     WPSDTF        BB020
     C                   ENDIF
     C     #3EPSD        IFNE      *BLANKS
     C     WPSDTT        ANDGT     0
     C     T2PSDT        CABGT     WPSDTT        BB020
     C                   ENDIF
 
      ** If Dr Customer selected, select only records where customer =
 
     C     #3CUST        IFNE      *BLANKS
     C                   MOVE      T2DCST        WACNUM            6
     C     WACNUM        CABNE     #3CUST        BB020
     C                   ENDIF
 
      ** If Customer selected, select only records where customer =
 
     C     CUSTOM        IFNE      *BLANKS
     C                   MOVE      T2CNUM        WACNUM
     C     WACNUM        CABNE     CUSTOM        BB020
     C                   ENDIF
 
      ** If Dr Ccy selected, select only ccy >= selected
 
     C     #3CCY         IFNE      *BLANKS
     C     T2DCCY        CABNE     #3CCY         BB020
     C                   ENDIF
 
      ** If Ccy selected, select only ccy = selected
 
     C     CCY           IFNE      *BLANKS
     C     T2CCY         CABNE     CCY           BB020
     C                   ENDIF
 
      ** If Dr Acod selected, select only Acod >= selected
 
     C     #3ACOD        IFNE      *BLANKS
     C                   MOVE      T2DACD        WAACOD           10
     C     WAACOD        CABNE     #3ACOD        BB020
     C                   ENDIF
 
      ** If Acod selected, select only Acod >= selected
 
     C     ACOD          IFNE      *BLANKS
     C                   MOVE      T2ACOD        WAACOD
     C     WAACOD        CABNE     ACOD          BB020
     C                   ENDIF
 
      ** If Dr Ac Seq selected, select only Acseq = selected
 
     C     #3ACSQ        IFNE      *BLANKS
     C                   MOVE      T2DASQ        WAACSQ            2
     C     WAACSQ        CABNE     #3ACSQ        BB020
     C                   ENDIF
 
      ** If Ac Seq selected, select only Acseq = selected
 
     C     SEQU          IFNE      *BLANKS
     C                   MOVE      T2ACSQ        WAACSQ
     C     WAACSQ        CABNE     SEQU          BB020
     C                   ENDIF
 
      ** If Dr Branch selected, select only Branch >= selected
 
     C     #3BRCA        IFNE      *BLANKS
     C     T2DBRC        CABNE     #3BRCA        BB020
     C                   ENDIF
 
      ** If Branch selected, select only Branch >= selected
 
     C     BRANCH        IFNE      *BLANKS
     C     T2BRCA        CABNE     BRANCH        BB020
     C                   ENDIF
 
      ** Select only records with Tax Paid Y
 
     C     T2TPAY        CABNE     'Y'           BB020
     C     T2RCTP        CABNE     'T'           BB020
 
      ** Load SFL fields
 
     C                   EXSR      MBFL#1
 
      ** Allow for possible *Set Cursor processing
 
     C                   ADD       1             ##RR
     C                   SUB       1             ##RR
     C                   MOVEL     'Y'           W0RSL             1
 
      ** Allow for possible *Set Cursor processing
 
     C                   ADD       1             ##RR
 
      ** USER: Initialize subfile record from DBF record
 
     C                   SUB       1             ##RR
 
      ** DBF record not selected
 
     C     W0RSL         CABNE     'Y'           BB020
 
      ** Output to subfile
 
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81
 
      ** If SFLRCD invalid, note that errors present
 
     C   98
     CANN99              SETON                                        99
     C                   WRITE     #SFLRCD
     C     BB020         TAG
 
      ** Increment scan check count
      ** read next record
 
     C     #FILE         IFEQ      'SDSTMDL7'
     C     KPAB          READE     @STMDVA                                82
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDL8'
     C     KPAB          READE     @STMDVB                                82
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDL9'
     C                   READ      @STMDVC                                82
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDLA'
     C                   READ      @STMDVD                                82
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDLB'
     C     KPEF          READE     @STMDVE                                82
     C                   ENDIF
 
     C     #FILE         IFEQ      'SDSTMDLC'
     C     KPEF          READE     @STMDVF                                82
     C                   ENDIF
 
     C                   ENDDO
 
     C     BB900         TAG
 
      ** If no DBF records found, display error message
 
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
 
      ** Send message '*No data to display'
 
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** Save highest SFL record load can continue at end point
 
     C     ##RR          IFGT      ##RRMX
 
      ** Calculate top line
 
     C     ##RROK        DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
     C     ##SLIN        IFGT      0
     C     ##RR          SUB       ##SLIN        ##SFRC
     C                   ELSE
     C     ##RR          SUB       ##SFPG        ##SFRC
     C                   ENDIF
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   ENDIF
 
      ** If scan limit reached, display error message
 
     C     ##RRRD        IFGE      W0SLM
 
      ** Send message '*Scan limit reached'
 
     C                   MOVEL     'Y2U0017'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     0             ##RROK
     C                   ENDIF
     CSR   BBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Display screen
      *****************************************************************
     CSR   CAEXFM        BEGSR
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
 
      ** Reset Action taken
 
     C                   MOVEL     *BLANKS       #ENTER            1
 
      ** Update screen time
 
     C                   TIME                    ##TME
 
      ** PUTOVR unless conditioned fields change
 
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   ENDIF
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
 
      ** Maintain subfile position where possible
 
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   ENDIF
 
      ** Update job time
 
     C                   TIME                    ##JTM
 
      ** Clear messages from program message queue
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
      ** Reset first message only flag
 
     C                   MOVEL     'Y'           ZAFSMS            1      99
     C                   SETOFF                                         8392
 
     CSR   CAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Process enter
      *****************************************************************
     CSR   ENTR##        BEGSR
 
      ** Confirm/update is not deferred
 
     C                   MOVEL     'N'           W0DCF             1
     C                   SETOFF                                       983132
     C                   SETOFF                                       333435
     C                   SETOFF                                       363839
     C                   SETOFF                                       424344
     C                   SETOFF                                       454647
     C                   SETOFF                                       484950
     C                   SETOFF                                       515253
     C                   SETOFF                                       545556
     C                   SETOFF                                       575859
     C                   SETOFF                                       416061
     C                   SETOFF                                       626364
     C                   CLEAR                   ZDAYNO
     C                   CLEAR                   WNCDTE
     C                   CLEAR                   WVDATF
     C                   CLEAR                   WVDATT
     C                   CLEAR                   WPSDTF
     C                   CLEAR                   WPSDTT
 
     C                   CLEAR                   WVDTF7            7
     C                   CLEAR                   WVDTT7            7
     C                   CLEAR                   WPDTF7            7
     C                   CLEAR                   WPDTT7            7
 
      ** Check/convert Value date (From)
 
     C     #3CDTE        IFNE      *BLANKS
 
     C                   MOVE      #3CDTE        WNCDTE            6 0
     C                   CALL      'ZDATE1'                             90
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM                    WNCDTE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO            5 0
 
      ** Error on Date input
 
     C     *IN(90)       IFEQ      '1'
     C     P@RTCD        ORNE      *BLANK
     C                   SETON                                        36
     C                   MOVEL     'USR9458'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     c                   ELSE
     C                   MOVE      ZDAYNO        WVDATF            5 0
 
      ** Convert to ddmmmyy
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        WVDTF7
     C                   ENDIF
     C                   ENDIF
 
      ** Check/convert Value date (To)
 
     C     #3EDTE        IFNE      *BLANKS
 
     C                   MOVE      #3EDTE        WNEDTE            6 0
     C                   CALL      'ZDATE1'                             90
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM                    WNEDTE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO            5 0
 
      ** Error on Date input
 
     C     *IN(90)       IFEQ      '1'
     C     P@RTCD        ORNE      *BLANK
     C                   SETON                                        41
     C                   MOVEL     'USR9458'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
     C                   MOVE      ZDAYNO        WVDATT            5 0
 
      ** Convert to ddmmmyy
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        WVDTT7
     C                   ENDIF
     C                   ENDIF
 
      ** Check/convert Posting date (From)
 
     C     #3FPSD        IFNE      *BLANKS
 
     C                   MOVE      #3FPSD        WNCDTE            6 0
     C                   CALL      'ZDATE1'                             90
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM                    WNCDTE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO            5 0
 
      ** Error on Date input
 
     C     *IN(90)       IFEQ      '1'
     C     P@RTCD        ORNE      *BLANK
     C                   SETON                                        42
     C                   MOVEL     'USR9458'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
     C                   MOVE      ZDAYNO        WPSDTF            5 0
 
      ** convert to ddmmmyy
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        WPDTF7
     C                   ENDIF
     C                   ENDIF
 
      ** Check/convert Posting date (To)
 
     C     #3EPSD        IFNE      *BLANKS
 
     C                   MOVE      #3EPSD        WNEDTE            6 0
     C                   CALL      'ZDATE1'                             90
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM                    WNEDTE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO            5 0
 
      ** Error on Date input
 
     C     *IN(90)       IFEQ      '1'
     C     P@RTCD        ORNE      *BLANK
     C                   SETON                                        43
     C                   MOVEL     'USR9458'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     c                   ELSE
     C                   MOVE      ZDAYNO        WPSDTT            5 0
 
      ** convert to ddmmmyy
 
     C                   Call      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        WPDTT7
     C                   ENDIF
     C                   ENDIF
 
      ** Module
 
     C     #3KEY         IFNE      *BLANKS
     C     #3KEY         ANDNE     'ACC'
     C     #3KEY         ANDNE     'SEC'
     C     #3KEY         ANDNE     'LOA'
     C     #3KEY         ANDNE     'DEA'
     C     #3KEY         ANDNE     'FEE'
     C     #3KEY         ANDNE     'PAY'
     C     #3KEY         ANDNE     'CHE'
     C     #3KEY         ANDNE     'FAC'
     C     #3KEY         ANDNE     'POS'
     C                   SETON                                        58
     C                   MOVEL     'USR9473'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
     C                   CLEAR                   @SEL
 
      ** Check Customer
 
     C     #3CUST        IFNE      *BLANKS
     C                   MOVE      '1'           @SEL
     C                   MOVEL     #3CUST        @CNUM            10
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    @CNUM
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        31
     C                   MOVEL     'USR9459'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
 
      ** Check currency
 
     C     #3CCY         IFNE      *BLANKS
     C                   MOVE      '1'           @SEL
 
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      #3CCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSFDY
 
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        32
     C                   MOVEL     'USR9460'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
 
      ** Check Account Code
 
     C     #3ACOD        IFNE      *BLANKS
     C                   MOVE      '1'           @SEL
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      #3ACOD        @ACOD            10
     C     SDACOD        PARM      SDACOD        DSFDY
 
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        33
     C                   MOVEL     'USR9461'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
 
      ** Check Branch Code
 
     C     #3BRCA        IFNE      *BLANKS
     C                   MOVE      '1'           @SEL
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      #3BRCA        @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        35
     C                   MOVEL     'USR9462'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
 
      ** If Dr account selected, check if module also selected
 
     C     @SEL          IFEQ      '1'
     C     #3KEY         ANDNE     *BLANKS
     C     #3KEY         ANDNE     'ACC'
     C                   SETON                                        343332
     C                   SETON                                        313558
     C                   MOVEL     'USR9472'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
      ** Check Account fields: Customer
 
     C     @SEL          IFNE      *BLANKS
 
     C     CUSTOM        IFNE      *BLANKS
     C     CCY           ORNE      *BLANKS
     C     ACOD          ORNE      *BLANKS
     C     SEQU          ORNE      *BLANKS
     C     BRANCH        ORNE      *BLANKS
     C                   SETON                                        98
     C                   MOVEL     'USR9470'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C     BRANCH        IFNE      *BLANKS
     C                   SETON                                        44
     C                   ENDIF
     C     CUSTOM        IFNE      *BLANKS
     C                   SETON                                        52
     C                   ENDIF
     C     ACOD          IFNE      *BLANKS
     C                   SETON                                        54
     C                   ENDIF
     C     CCY           IFNE      *BLANKS
     C                   SETON                                        53
     C                   ENDIF
     C     SEQU          IFNE      *BLANKS
     C                   SETON                                        55
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     @SEL          IFEQ      *BLANKS
 
     C     CUSTOM        IFNE      *BLANKS
     C                   MOVE      '2'           @SEL
     C                   MOVEL     CUSTOM        @CNUM
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    @CNUM
     C                   PARM      *BLANKS       @CNST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        52
     C                   MOVEL     'USR9459'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
 
      ** Check currency
 
     C     CCY           IFNE      *BLANKS
     C                   MOVE      '2'           @SEL
 
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      CCY           @CCY
     C     SDCURR        PARM      SDCURR        DSFDY
 
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        53
     C                   MOVEL     'USR9460'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
 
      ** Check Account Code
 
     C     ACOD          IFNE      *BLANKS
     C                   MOVE      '2'           @SEL
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      ACOD          @ACOD
     C     SDACOD        PARM      SDACOD        DSFDY
 
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        54
     C                   MOVEL     'USR9461'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
 
      ** Check Branch  Code
 
     C     BRANCH        IFNE      *BLANKS
     C                   MOVE      '2'           @SEL
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      BRANCH        @BRCH
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        44
     C                   MOVEL     'USR9462'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** If account selected, check if module also selected
 
     C     @SEL          IFEQ      '2'
     C     #3KEY         ANDNE     *BLANKS
     C     #3KEY         ANDNE     'ACC'
     C                   SETON                                        445253
     C                   SETON                                        545558
     C                   MOVEL     'USR9472'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
      ** Check other selection fields
 
     C     DEALN         IFNE      *BLANKS
 
     C     @SEL          IFNE      *BLANKS
     C                   SETON                                        9845
     C                   MOVEL     'USR9470'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
     C                   MOVE      '3'           @SEL
     C                   ENDIF
     C                   ENDIF
 
      ** If deal selected, check if module also selected
 
     C     @SEL          IFEQ      '3'
     C     #3KEY         ANDNE     *BLANKS
     C     #3KEY         ANDNE     'DEA'
     C                   SETON                                        4558
     C                   MOVEL     'USR9472'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
     C     LOANNR        IFNE      *BLANKS
 
     C     @SEL          IFNE      *BLANKS
     C                   SETON                                        9846
     C                   MOVEL     'USR9470'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
     C                   MOVE      '4'           @SEL
     C                   ENDIF
     C                   ENDIF
 
      ** If loan selected, check if module also selected
 
     C     @SEL          IFEQ      '4'
     C     #3KEY         ANDNE     *BLANKS
     C     #3KEY         ANDNE     'LOA'
     C                   SETON                                        4658
     C                   MOVEL     'USR9472'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
     C     TRADEN        IFNE      *BLANKS
 
     C     @SEL          IFNE      *BLANKS
     C                   SETON                                        9847
     C                   MOVEL     'USR9470'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
     C                   MOVE      '5'           @SEL
     C                   ENDIF
     C                   ENDIF
 
      ** If trade selected, check if module also selected
 
     C     @SEL          IFEQ      '5'
     C     #3KEY         ANDNE     *BLANKS
     C     #3KEY         ANDNE     'SEC'
     C                   SETON                                        4758
     C                   MOVEL     'USR9472'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
     C                   MOVE      *ZEROS        WOREDT            5 0
     C     FEESEQ        IFNE      *BLANKS
     C     FEEDAT        ORNE      *BLANKS
 
     C     @SEL          IFNE      *BLANKS
     C                   SETON                                        984859
     C                   MOVEL     'USR9470'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
     C     FEESEQ        IFEQ      *BLANKS
     C                   SETON                                        9848
     C                   MOVEL     'USR9471'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C     FEEDAT        IFEQ      *BLANKS
     C                   SETON                                        9859
     C                   MOVEL     'USR9471'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
      ** Check/convert Original Entry date
 
     C     FEEDAT        IFNE      *BLANKS
 
     C                   MOVE      FEEDAT        WNCDTE            6 0
     C                   CALL      'ZDATE1'                             90
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM                    WNCDTE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO            5 0
 
      ** Error on Date input
 
     C     *IN(90)       IFEQ      '1'
     C     P@RTCD        ORNE      *BLANK
     C                   SETON                                        59
     C                   MOVEL     'USR9458'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
     C                   MOVE      ZDAYNO        WOREDT            5 0
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      '6'           @SEL
     C                   ENDIF
     C                   ENDIF
 
      ** If Fee selected, check if module also selected
 
     C     @SEL          IFEQ      '6'
     C     #3KEY         ANDNE     *BLANKS
     C     #3KEY         ANDNE     'FEE'
     C                   SETON                                        485859
     C                   MOVEL     'USR9472'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
     C     @SEL          IFNE      *BLANK
     C     FCUST         IFNE      *BLANK
     C     FTYPE         ORNE      *BLANK
     C     FNUM          ORNE      *BLANK
     C                   SETON                                        98
     C                   MOVEL     'USR9470'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C     FCUST         IFNE      *BLANK
     C                   SETON                                        49
     C                   ENDIF
     C     FTYPE         IFNE      *BLANK
     C                   SETON                                        56
     C                   ENDIF
     C     FNUM          IFNE      *BLANK
     C                   SETON                                        57
     C                   ENDIF
     C                   ENDIF
 
     C     @SEL          IFEQ      *BLANK
 
     C     FCUST         IFNE      *BLANK
     C                   MOVE      '7'           @SEL
     C                   MOVEL     FCUST         @CNUM
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    @CNUM
     C                   PARM      *BLANKS       @CNST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        49
     C                   MOVEL     'USR9459'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
     C     FTYPE         IFNE      *BLANK
     C                   MOVE      '7'           @SEL
     C                   ENDIF
     C     FNUM          IFNE      *BLANK
     C                   MOVE      '7'           @SEL
     C                   ENDIF
 
     C                   ENDIF
 
      ** If Facility selected, check if module also selected
 
     C     @SEL          IFEQ      '7'
     C     #3KEY         ANDNE     *BLANKS
     C     #3KEY         ANDNE     'FAC'
     C                   SETON                                        495856
     C                   SETON                                        57
     C                   MOVEL     'USR9472'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
     C     @SEL          IFNE      *BLANK
     C     PAYCHQ        IFNE      *BLANK
     C     CHQSEQ        ORNE      *BLANK
     C                   SETON                                        98
     C                   MOVEL     'USR9470'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C     PAYCHQ        IFNE      *BLANK
     C                   SETON                                        50
     C                   ENDIF
     C     CHQSEQ        IFNE      *BLANK
     C                   SETON                                        51
     C                   ENDIF
     C                   ENDIF
 
     C     @SEL          IFEQ      *BLANK
     C     CHQSEQ        ANDNE     *BLANK
     C     PAYCHQ        ANDEQ     *BLANK
     C                   SETON                                        9850
     C                   MOVEL     'USR9471'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
     C     @SEL          IFEQ      *BLANK
     C     PAYCHQ        ANDNE     *BLANK
     C                   MOVE      '8'           @SEL
     C                   ENDIF
 
      ** If Payment/Cheque selected, check if module also selected
 
     C     @SEL          IFEQ      '8'
     C     #3KEY         ANDNE     *BLANKS
     C     #3KEY         ANDNE     'PAY'
     C     #3KEY         ANDNE     'CHE'
     C     @SEL          OREQ      '8'
     C     #3KEY         ANDEQ     'PAY'
     C     CHQSEQ        ANDNE     *BLANK
     C                   SETON                                        505851
     C                   MOVEL     'USR9472'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
     C     @SEL          IFNE      *BLANKS
 
     C     PSBRCA        IFNE      *BLANKS
     C     PSSESH        ORNE      *BLANKS
     C     PSCPTY        ORNE      *BLANKS
     C     PSDUED        ORNE      *BLANKS
     C     PSEVNT        ORNE      *BLANKS
     C                   SETON                                        98
     C                   MOVEL     'USR9470'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C     PSBRCA        IFNE      *BLANKS
     C                   SETON                                        60
     C                   ENDIF
     C     PSSESH        IFNE      *BLANKS
     C                   SETON                                        61
     C                   ENDIF
     C     PSCPTY        IFNE      *BLANKS
     C                   SETON                                        62
     C                   ENDIF
     C     PSDUED        IFNE      *BLANKS
     C                   SETON                                        63
     C                   ENDIF
     C     PSEVNT        IFNE      *BLANKS
     C                   SETON                                        64
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     @SEL          IFEQ      *BLANKS
 
      ** Check Branch Code
 
     C     PSBRCA        IFNE      *BLANKS
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      PSBRCA        @BRCH
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        60
     C                   MOVEL     'USR9462'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
 
     C     PSSESH        IFNE      *BLANKS
     C                   MOVE      '9'           @SEL
     C                   ENDIF
 
      ** Check Counterparty
 
     C     PSCPTY        IFNE      *BLANKS
     C                   MOVE      '9'           @SEL
     C                   MOVEL     PSCPTY        @CNUM
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    @CNUM
     C                   PARM      *BLANKS       @CNST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        62
     C                   MOVEL     'USR9459'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
 
      ** Check/convert Due date
 
     C     PSDUED        IFNE      *BLANKS
 
     C                   MOVE      PSDUED        WNPDUE            6 0
     C                   CALL      'ZDATE1'                             90
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM                    WNPDUE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO
 
      ** Error on Date input
 
     C     *IN(90)       IFEQ      '1'
     C     P@RTCD        ORNE      *BLANK
     C                   SETON                                        63
     C                   MOVEL     'USR9458'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
     C                   MOVE      ZDAYNO        WODUDT            5 0
     C                   ENDIF
     C                   ENDIF
 
     C     PSEVNT        IFNE      *BLANKS
     C                   MOVE      '9'           @SEL
     C                   ENDIF
 
     C                   ENDIF
 
      ** If position settlement selected, check if module also selected
 
     C     @SEL          IFEQ      '9'
     C     #3KEY         ANDNE     *BLANKS
     C     #3KEY         ANDNE     'POS'
     C                   SETON                                        606162
     C                   SETON                                        636458
     C                   MOVEL     'USR9472'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
      ** set file name
 
     C                   CLEAR                   #FILE
     C                   CLEAR                   T#BRCA
     C                   CLEAR                   T#CNUM
     C                   CLEAR                   T#CCY
     C                   CLEAR                   T#ACOD
     C                   CLEAR                   T#ACSQ
     C                   CLEAR                   T#FCNM
     C                   CLEAR                   T#FACT
     C                   CLEAR                   T#FCNO
     C                   CLEAR                   T#FSEQ
     C                   CLEAR                   T#ORED
     C                   CLEAR                   T#TDRF
     C                   CLEAR                   T#PREF
     C                   CLEAR                   T#CQSQ
     C                   CLEAR                   T#DLNO
     C                   CLEAR                   T#LNRF
     C                   CLEAR                   T#ASEQ
     C                   CLEAR                   T#TYPE
     C                   CLEAR                   T#DATE
     C                   CLEAR                   T#DAT2
     C                   CLEAR                   T#PBRC
     C                   CLEAR                   T#PSSH
     C                   CLEAR                   T#PCPY
     C                   CLEAR                   T#PDUD
     C                   CLEAR                   T#PEVT
     C     #3CDTE        IFNE      *BLANKS
     C     #3FPSD        OREQ      *BLANKS
     C                   MOVEL     'SDSTMDL9'    #FILE
     C                   MOVE      WVDATF        T#DATE
     C                   ELSE
     C                   MOVEL     'SDSTMDLA'    #FILE
     C                   MOVE      WPSDTF        T#DATE
     C                   ENDIF
 
      ** Selection is for Debit account
 
     C     @SEL          IFEQ      '1'
     C     #3BRCA        IFNE      *BLANKS
     C     #3CUST        ANDNE     *BLANKS
     C     #3CCY         ANDNE     *BLANKS
     C     #3ACOD        ANDNE     *BLANKS
     C     #3ACSQ        ANDNE     *BLANKS
     C                   MOVE      #3BRCA        T#BRCA
     C                   MOVE      #3CUST        T#CNUM
     C                   MOVE      #3CCY         T#CCY
     C                   MOVE      #3ACOD        T#ACOD
     C                   MOVE      #3ACSQ        T#ACSQ
     C     #FILE         IFEQ      'SDSTMDLA'
     C                   MOVEL     'SDSTMDL8'    #FILE
     C                   ELSE
     C                   MOVEL     'SDSTMDL7'    #FILE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** selection is for account
 
     C     @SEL          IFEQ      '2'
     C     BRANCH        IFNE      *BLANKS
     C     CUSTOM        ANDNE     *BLANKS
     C     CCY           ANDNE     *BLANKS
     C     ACOD          ANDNE     *BLANKS
     C     SEQU          ANDNE     *BLANKS
     C                   MOVE      BRANCH        T#BRCA
     C                   MOVE      CUSTOM        T#CNUM
     C                   MOVE      CCY           T#CCY
     C                   MOVE      ACOD          T#ACOD
     C                   MOVE      SEQU          T#ACSQ
     C                   ELSE
     C                   CLEAR                   @SEL
     C                   ENDIF
     C                   ENDIF
 
      ** selection is for Deal
 
     C     @SEL          IFEQ      '3'
     C     DEALN         IFNE      *BLANKS
     C                   MOVE      DEALN         T#DLNO
     C                   ELSE
     C                   CLEAR                   @SEL
     C                   ENDIF
     C                   ENDIF
 
      ** Loan Selection
 
     C     @SEL          IFEQ      '4'
     C     LOANNR        IFNE      *BLANKS
     C                   MOVE      LOANNR        T#LNRF
     C                   ELSE
     C                   CLEAR                   @SEL
     C                   ENDIF
     C                   ENDIF
 
      ** Trade Selection
 
     C     @SEL          IFEQ      '5'
     C     TRADEN        IFNE      *BLANKS
     C                   MOVE      TRADEN        T#TDRF
     C                   ELSE
     C                   CLEAR                   @SEL
     C                   ENDIF
     C                   ENDIF
 
      ** Fee
 
     C     @SEL          IFEQ      '6'
     C     FEESEQ        IFNE      *BLANKS
     C     FEEDAT        ANDNE     *BLANKS
     C                   MOVE      FEESEQ        T#FSEQ
     C                   MOVE      WOREDT        T#ORED
     C                   ELSE
     C                   CLEAR                   @SEL
     C                   ENDIF
     C                   ENDIF
 
      ** Facility
 
     C     @SEL          IFEQ      '7'
     C     FCUST         IFNE      *BLANKS
     C     FTYPE         ANDNE     *BLANKS
     C     FNUM          ANDNE     *BLANKS
     C                   MOVE      FCUST         T#FCNM
     C                   MOVE      FTYPE         T#FACT
     C                   MOVE      FNUM          T#FCNO
     C                   ELSE
     C                   CLEAR                   @SEL
     C                   ENDIF
     C                   ENDIF
 
      ** Payment/Cheque
 
     C     @SEL          IFEQ      '8'
     C     PAYCHQ        IFNE      *BLANKS
     C                   MOVE      PAYCHQ        T#PREF
     C                   MOVE      CHQSEQ        T#CQSQ
     C                   ELSE
     C                   CLEAR                   @SEL
     C                   ENDIF
     C                   ENDIF
 
      ** Position Settlement
 
     C     @SEL          IFEQ      '9'
     C     PSBRCA        IFNE      *BLANKS
     C     PSSESH        ANDNE     *BLANKS
     C     PSCPTY        ANDNE     *BLANKS
     C     PSDUED        ANDNE     *BLANKS
     C     PSEVNT        ANDNE     *BLANKS
     C                   MOVE      PSBRCA        T#PBRC
     C                   MOVE      PSSESH        T#PSSH
     C                   MOVE      PSCPTY        T#PCPY
     C                   MOVE      WODUDT        T#PDUD
     C                   MOVE      PSEVNT        T#PEVT
     C                   ELSE
     C                   CLEAR                   @SEL
     C                   ENDIF
     C                   ENDIF
 
     C     @SEL          IFNE      '1'
     C     @SEL          ANDNE     *BLANKS
     C     #FILE         IFEQ      'SDSTMDLA'
     C                   MOVEL     'SDSTMDLC'    #FILE
     C                   ELSE
     C                   MOVEL     'SDSTMDLB'    #FILE
     C                   ENDIF
     C                   ENDIF
 
      ** Check if report has been requested
 
     C     *IN17         IFEQ      *ON
 
     C                   CLEAR                   W#DATA
 
      ** Set Fields for screen 2
 
     C                   MOVE      #3KEY         W#MODU
     C                   MOVE      #FILE         W#FILE
     C                   MOVE      T#CNUM        W#CNUM
     C                   MOVE      T#BRCA        W#BRCA
     C                   MOVE      T#CCY         W#CCY
     C                   MOVE      T#ACOD        W#ACOD
     C                   MOVE      T#ACSQ        W#ACSQ
     C                   MOVE      T#DLNO        W#DLNO
     C                   MOVE      T#LNRF        W#LNRF
     C                   MOVE      T#TDRF        W#TDRF
     C                   MOVE      T#FSEQ        W#FSEQ
     C                   MOVE      T#ORED        W#ORED
     C                   MOVE      T#FCNM        W#FCNM
     C                   MOVE      T#FACT        W#FACT
     C                   MOVE      T#FCNO        W#FCNO
     C                   MOVE      T#PREF        W#PREF
     C                   MOVE      T#CQSQ        W#CQSQ
     C                   MOVE      T#PBRC        W#PBRC
     C                   MOVE      T#PSSH        W#PSSH
     C                   MOVE      T#PCPY        W#PCPT
     C                   MOVE      T#PDUD        W#PDUD
     C                   MOVE      T#PEVT        W#PEVT
     C                   MOVE      @SEL          W#SELE
 
     C                   Z-ADD     WVDATF        W#STDT
     C                   Z-ADD     WVDATT        W#EDAT
     C                   Z-ADD     WPSDTF        W#PFRM
     C                   Z-ADD     WPSDTT        W#PTO
     C                   MOVE      WVDTF7        W#VDTF
     C                   MOVE      WVDTT7        W#VDTT
     C                   MOVE      WPDTF7        W#PDTF
     C                   MOVE      WPDTT7        W#PDTT
     C                   MOVE      #3CUST        W#DCST
     C                   MOVE      #3BRCA        W#DBRC
     C                   MOVE      #3CCY         W#DCCY
     C                   MOVE      #3ACOD        W#DACD
     C                   MOVE      #3ACSQ        W#DASQ
     C                   MOVE      CUSTOM        W#SCUS
     C                   MOVE      BRANCH        W#SBRC
     C                   MOVE      CCY           W#SCCY
     C                   MOVE      ACOD          W#SACD
     C                   MOVE      SEQU          W#SASQ
 
     C     #3CDTE        IFNE      *BLANKS
     C                   MOVE      #3CDTE        W#SDT
     C                   ENDIF
 
     C                   Z-ADD     WVDATT        W#EDAT
     C     #3EDTE        IFNE      *BLANKS
     C                   MOVE      #3EDTE        W#EDT
     C                   ENDIF
 
      ** Set up Data to be passed to print pgm
 
     C                   CALL      'GL008172'
     C                   PARM                    W#DATA
     C                   MOVEL     'USR9474'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      **  Process subfile
 
     C                   CLEAR                   #REDIS
     C     W0RSL         CASEQ     'Y'           DBPRSF
     C                   ENDCS
 
      ** Reload subfile
 
     C     #REDIS        CASEQ     ' '           BAIZSF
     C                   ENDCS
 
     CSR   DAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Process modified subfile record
      *****************************************************************
     CSR   DBPRSF        BEGSR
 
      ** Read first changed slf record
 
     C                   READC     #SFLRCD                                92
     C     *IN92         DOWEQ     '0'
 
      ** Action taken
 
     C                   MOVEL     'Y'           #ENTER
 
      ** Process subfile record
 
     C                   EXSR      DCPRSR
     C                   UPDATE    #SFLRCD
 
      ** If F12 then redisplay screen with action code
      ** Or action did not complete
 
     C     P0RTN         IFNE      *BLANKS
     C                   MOVEL     *BLANKS       P0RTN
     C                   GOTO      DBEXIT
     C                   ENDIF
 
     C                   READC     #SFLRCD                                92
     C                   ENDDO
     CSR   DBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACTD - Check Action code                                    *
      *                                                               *
      * Called by: DCPRSR                                             *
      *                                                               *
      *****************************************************************
     CSR   SRACTD        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SRACTD'      @STK(Q)
 
      ** Check all valid actions
      ** CASE: RCD.*SFLSEL is not valid
 
     C     #2SEL         IFEQ      ' '
     C                   GOTO      EXACTD
     C                   ENDIF
 
     C     #2SEL         IFNE      'E'
     C     #2SEL         ANDNE     'P'
     C                   MOVEL     #2SEL         ZA0001
     C                   MOVEL     'USR9456'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        40
 
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
      ** Unwind subroutine stack name
 
     C     EXACTD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRSET - Record Changed                                       *
      *                                                               *
      * Called by: DCPRSR                                             *
      *                                                               *
      *****************************************************************
     CSR   SRRSET        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SRRSET'      @STK(Q)
 
      ** Skip to end if not enquire action taken
 
     C     #2SEL         IFNE      'E'
     C     #2SEL         ANDNE     'P'
     C                   GOTO      EXRSET
     C                   ENDIF
 
      ** Clear Parameter DS
 
     C                   CLEAR                   W#DATA
 
      ** Retrieve Date From Header File
 
     C*****#2KEY         IFEQ      'ACCOUNT'                                                AR888911
     C*****KACCNT        KLIST                                                              AR888911
     C**********         KFLD                    #2CNUM                                     AR888911
     C**********         KFLD                    #2CCY                                      AR888911
     C**********         KFLD                    #2ACOD                                     AR888911
     C**********         KFLD                    #2ACSQ                                     AR888911
     C**********         KFLD                    #2BRCA                                     AR888911
     C*****KACCNT        CHAIN     GLACNTL3                           90                    AR888911
      *********                                                                             AR888911
     C******IN90         IFEQ      '1'                                                      AR888911
     C**********         MOVEL     'GLACNTL3'    W0FILE                                     AR888911
     C**********         MOVE      *BLANKS       W0KEY                                      AR888911
     C**********         MOVEL     #2BRCA        ACCNKY           24                        AR888911
     C**********         MOVEL     #2CNUM        CUSCCY            9                        AR888911
     C**********         MOVE      #2CCY         CUSCCY                                     AR888911
     C**********         MOVEL     #2ACOD        CODSEQ           12                        AR888911
     C**********         MOVE      #2ACSQ        CODSEQ                                     AR888911
     C**********         MOVEL     CUSCCY        ACCKY2           21                        AR888911
     C**********         MOVE      CODSEQ        ACCKY2                                     AR888911
     C**********         MOVE      ACCKY2        ACCNKY                                     AR888911
     C**********         MOVEL     ACCNKY        W0KEY                                      AR888911
     C**********         Z-ADD     11            W0ERNB                                     AR888911
     C**********         MOVEL     'MEM5004'     W0MSGD                                     AR888911
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     AR888911
     C**********         EXSR      SRERR                                                    AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C*****#2KEY         IFEQ      'DEAL'                                                   AR888911
     C**********         MOVEL     #2DLNO        W#DLNO                                     AR888911
     C*****W#DLNO        CHAIN     DLDLDCL3                           90                    AR888911
      **********                                                                            AR888911
     C******IN90         IFEQ      '1'                                                      AR888911
     C**********         MOVEL     'DLDLDCL3'    W0FILE                                     AR888911
     C**********         MOVE      *BLANKS       W0KEY                                      AR888911
     C**********         MOVEL     W#DLNO        W0KEY                                      AR888911
     C**********         Z-ADD     2             W0ERNB                                     AR888911
     C**********         MOVEL     'MEM5004'     W0MSGD                                     AR888911
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     AR888911
     C**********         EXSR      SRERR                                                    AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C*****#2KEY         IFEQ      'LOAN'                                                   AR888911
     C*****#2LNRF        CHAIN     CLONCLL1                           90                    AR888911
      **********                                                                            AR888911
     C******IN90         IFEQ      '1'                                                      AR888911
     C**********         MOVEL     'CLONCLL1'    W0FILE                                     AR888911
     C**********         MOVE      *BLANKS       W0KEY                                      AR888911
     C**********         MOVEL     #2LNRF        W0KEY                                      AR888911
     C**********         Z-ADD     12            W0ERNB                                     AR888911
     C**********         MOVEL     'MEM5004'     W0MSGD                                     AR888911
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     AR888911
     C**********         EXSR      SRERR                                                    AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C*****#2KEY         IFEQ      'SECURITY'                                               AR888911
     C*****#2TDRF        CHAIN     TRADSQL0                           90                    AR888911
      **********                                                                            AR888911
     C******IN90         IFEQ      '1'                                                      AR888911
     C**********         MOVEL     'TRADSQL0'    W0FILE                                     AR888911
     C**********         MOVE      *BLANKS       W0KEY                                      AR888911
     C**********         MOVEL     #2TDRF        W0KEY                                      AR888911
     C**********         Z-ADD     13            W0ERNB                                     AR888911
     C**********         MOVEL     'MEM5004'     W0MSGD                                     AR888911
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     AR888911
     C**********         EXSR      SRERR                                                    AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C*****#2KEY         IFEQ      'FEE'                                                    AR888911
     C*****KFEED         KLIST                                                              AR888911
     C**********         KFLD                    #2FCNM                                     AR888911
     C**********         KFLD                    TYPNUM                                     AR888911
     C**********         KFLD                    #2LNRF                                     AR888911
     C**********         KFLD                    #2FSEQ                                     AR888911
     C**********         KFLD                    #2ORED                                     AR888911
     C**********         MOVEL     #2FACT        TYPNUM            5 0                      AR888911
     C**********         MOVE      #2FCNO        TYPNUM                                     AR888911
     C*****KFEED         CHAIN     LEFEEQL1                           90                    AR888911
      **********                                                                            AR888911
     C******IN90         IFEQ      '1'                                                      AR888911
     C**********         MOVEL     'LEFEEQL1'    W0FILE                                     AR888911
     C**********         MOVE      *BLANKS       W0KEY                                      AR888911
     C**********         MOVEL     #2FSEQ        SEQDAT            8                        AR888911
     C**********         MOVE      #2ORED        SEQDAT                                     AR888911
     C**********         MOVEL     SEQDAT        W0KEY                                      AR888911
     C**********         Z-ADD     14            W0ERNB                                     AR888911
     C**********         MOVEL     'MEM5004'     W0MSGD                                     AR888911
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     AR888911
     C**********         EXSR      SRERR                                                    AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C*****#2KEY         IFEQ      'FACILITY'                                               AR888911
     C*****KFCLT         KLIST                                                              AR888911
     C**********         KFLD                    #2FCNM                                     AR888911
     C**********         KFLD                    WFACT                                      AR888911
     C**********         KFLD                    WFCNO                                      AR888911
     C**********         MOVEL     #2FACT        WFACT             3                        AR888911
     C**********         MOVEL     #2FCNO        WFCNO             2                        AR888911
     C*****KFCLT         CHAIN     LEFCLTLH                           90                    AR888911
      **********                                                                            AR888911
     C******IN90         IFEQ      '1'                                                      AR888911
     C**********         MOVEL     'LEFCLTLH'    W0FILE                                     AR888911
     C**********         MOVE      *BLANKS       W0KEY                                      AR888911
     C**********         MOVEL     #2FCNM        FCLTKY           11                        AR888911
     C**********         MOVEL     WFACT         FCLTTP            5                        AR888911
     C**********         MOVE      WFCNO         FCLTTP                                     AR888911
     C**********         MOVE      FCLTTP        FCLTKY                                     AR888911
     C**********         MOVE      FCLTKY        W0KEY                                      AR888911
     C**********         Z-ADD     15            W0ERNB                                     AR888911
     C**********         MOVEL     'MEM5004'     W0MSGD                                     AR888911
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     AR888911
     C**********         EXSR      SRERR                                                    AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C*****#2KEY         IFEQ      'IPAY'                                                   AR888911
     C*****#2PREF        CHAIN     INPAYQL0                           90                    AR888911
      **********                                                                            AR888911
     C******IN90         IFEQ      '1'                                                      AR888911
     C**********         MOVEL     'INPAYQL0'    W0FILE                                     AR888911
     C**********         MOVE      *BLANKS       W0KEY                                      AR888911
     C**********         MOVEL     #2PREF        W0KEY                                      AR888911
     C**********         Z-ADD     16            W0ERNB                                     AR888911
     C**********         MOVEL     'MEM5004'     W0MSGD                                     AR888911
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     AR888911
     C**********         EXSR      SRERR                                                    AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C*****#2KEY         IFEQ      'OPAY'                                                   AR888911
     C*****#2PREF        CHAIN     OTPAYQL0                           90                    AR888911
      **********                                                                            AR888911
     C******IN90         IFEQ      '1'                                                      AR888911
     C**********         MOVEL     'OTPAYQL0'    W0FILE                                     AR888911
     C**********         MOVE      *BLANKS       W0KEY                                      AR888911
     C**********         MOVEL     #2PREF        W0KEY                                      AR888911
     C**********         Z-ADD     17            W0ERNB                                     AR888911
     C**********         MOVEL     'MEM5004'     W0MSGD                                     AR888911
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     AR888911
     C**********         EXSR      SRERR                                                    AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C*****#2KEY         IFEQ      'CHEQC'                                                  AR888911
     C*****KCHEQ         KLIST                                                              AR888911
     C**********         KFLD                    #2PREF                                     AR888911
     C**********         KFLD                    #2CQSQ                                     AR888911
     C*****KCHEQ         CHAIN     CQCOCQL0                           90                    AR888911
      **********                                                                            AR888911
     C******IN90         IFEQ      '1'                                                      AR888911
     C**********         MOVEL     'CQCOCQL0'    W0FILE                                     AR888911
     C**********         MOVE      *BLANKS       W0KEY                                      AR888911
     C**********         MOVEL     #2PREF        CHQKEY           17                        AR888911
     C**********         MOVE      #2CQSQ        CHQKEY                                     AR888911
     C**********         MOVEL     CHQKEY        W0KEY                                      AR888911
     C**********         Z-ADD     18            W0ERNB                                     AR888911
     C**********         MOVEL     'MEM5004'     W0MSGD                                     AR888911
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     AR888911
     C**********         EXSR      SRERR                                                    AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C*****#2KEY         IFEQ      'CHEQP'                                                  AR888911
     C*****KCHEQ         CHAIN     CQPACQL0                           90                    AR888911
      **********                                                                            AR888911
     C******IN90         IFEQ      '1'                                                      AR888911
     C**********         MOVEL     'CQPACQL0'    W0FILE                                     AR888911
     C**********         MOVE      *BLANKS       W0KEY                                      AR888911
     C**********         MOVEL     #2PREF        CHQKEY                                     AR888911
     C**********         MOVE      #2CQSQ        CHQKEY                                     AR888911
     C**********         MOVEL     CHQKEY        W0KEY                                      AR888911
     C**********         Z-ADD     19            W0ERNB                                     AR888911
     C**********         MOVEL     'MEM5004'     W0MSGD                                     AR888911
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     AR888911
     C**********         EXSR      SRERR                                                    AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C*****#2KEY         IFEQ      'POSSET'                                                 AR888911
     C*****KPSETT        KLIST                                                              AR888911
     C**********         KFLD                    #2PBRC                                     AR888911
     C**********         KFLD                    #2PSSH                                     AR888911
     C**********         KFLD                    #2PCPY                                     AR888911
     C**********         KFLD                    #2PDUD                                     AR888911
     C**********         KFLD                    #2PEVT                                     AR888911
     C*****KPSETT        CHAIN     POSETDYL                           90                    AR888911
      **********                                                                            AR888911
     C******IN90         IFEQ      '1'                                                      AR888911
     C**********         MOVEL     'POSETDYL'    W0FILE                                     AR888911
     C**********         MOVE      *BLANKS       W0KEY                                      AR888911
     C**********         MOVEL     #2PBRC        POSSKY           27                        AR888911
     C**********         MOVEL     #2PSSH        SSHCPT           16                        AR888911
     C**********         MOVE      #2PCPY        SSHCPT                                     AR888911
     C**********         MOVEL     #2PDUD        DUDETP            8                        AR888911
     C**********         MOVE      #2PEVT        DUDETP                                     AR888911
     C**********         MOVEL     SSHCPT        POSKY2           24                        AR888911
     C**********         MOVE      DUDETP        POSKY2                                     AR888911
     C**********         MOVE      POSKY2        POSSKY                                     AR888911
     C**********         MOVEL     POSSKY        W0KEY                                      AR888911
     C**********         Z-ADD     20            W0ERNB                                     AR888911
     C**********         MOVEL     'MEM5004'     W0MSGD                                     AR888911
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     AR888911
     C**********         EXSR      SRERR                                                    AR888911
     C**********         ENDIF                                                              AR888911
      **********                                                                            AR888911
     C**********         ENDIF                                                              AR888911
 
      ** Set Fields for screen 2
 
     C                   MOVE      T2KEY         W#KEY
     C                   MOVE      T2LNRF        W#LNRF
     C                   MOVE      T2FCNM        W#FCNM
     C                   MOVE      T2FACT        W#FACT
     C                   MOVE      T2FCNO        W#FCNO
     C                   MOVE      T2FSEQ        W#FSEQ
     C                   MOVE      T2ORED        W#ORED
     C                   MOVE      T2DLNO        W#DLNO
     C                   MOVE      T2TDRF        W#TDRF
     C                   MOVE      T2BRCA        W#BRCA
     C                   MOVE      T2CNUM        W#CNUM
     C                   MOVE      T2CCY         W#CCY
     C                   MOVE      T2ACOD        W#ACOD
     C                   MOVE      T2ACSQ        W#ACSQ
     C                   MOVE      T2PREF        W#PREF
     C                   MOVE      T2CQSQ        W#CQSQ
     C                   MOVE      T2PBRC        W#PBRC
     C                   MOVE      T2PSSH        W#PSSH
     C                   MOVE      T2PCPY        W#PCPT
     C                   MOVE      T2PDUD        W#PDUD
     C                   MOVE      T2PEVT        W#PEVT
 
     C                   MOVE      #2STFB        W#STFB
     C                   MOVE      #2STFI        W#STFI
     C                   MOVE      #2STFF        W#STFF
     C                   MOVE      #2STFC        W#STFC
 
      ** Set Dr Account
 
     C                   MOVE      T2DBRC        A2BRCA
     C                   MOVE      T2DCST        A2CNUM
     C                   MOVE      T2DCCY        A2CCY
     C                   MOVE      T2DACD        A2ACOD
     C                   MOVE      T2DASQ        A2ACSQ
     C                   MOVEL     A#ACCD        W#DACC
 
      ** Posting Date
 
     C     #2PSDT        IFNE      *ZEROS
     C                   CALL      'ZDATE2'
     C                   PARM      #2PSDT        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        W#PSDT
     C                   ENDIF
 
      ** Value Date
 
     C     #2VALD        IFNE      *ZEROS
     C                   CALL      'ZDATE2'
     C                   PARM      #2VALD        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        W#VLDT
     C                   ENDIF
 
      ** Gross Amount
 
     C                   MOVEL     #2GROS        W#GROS
 
      ** Tax Amount in Transaction ccy
 
     C                   MOVEL     #2STAX        W#TAXD
     C                   MOVE      #2DCCY        W#CCYD
 
      ** Tax Amount in Dr Account Ccy
 
     C                   MOVE      #2ECCY        W#CCYE
 
     C     #2TAXE        IFNE      *ZEROS
 
      ** Retrieve Account Nr of decimal places
 
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      W#CCYE        @CCY              3
     C     SDCURR        PARM      SDCURR        DSFDY
 
      ** If return with an error (LR seton in called program) then
      ** process for database error.
 
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    w0file
     C                   MOVE      *BLANKS       w0key
 
     C                   MOVEL     'PARM:'       w0k10            10
     C                   MOVE      W#CCYE        w0k10
     C                   MOVEL     '*CALL'       w0key
     C                   MOVE      W0K10         w0key
 
     C                   Z-ADD     3             w0ernb
     C                   MOVEL     'MEM5003'     w0msgd
     C                   MOVEL     'MIDAS  '     w0msgF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   MOVE      A6NBDP        zdecs
     C                   MOVE      'J'           zecode
 
      ** Format amount
 
     C                   MOVE      #2TAXE        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#TAXE
     C                   ENDIF
 
     C                   MOVE      #2DCCY        W#CCYD
 
     C     #2TADC        IFNE      *ZEROS
 
      ** Retrieve Account Nr of decimal places
 
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      W#CCYD        @CCY              3
     C     SDCURR        PARM      SDCURR        DSFDY
 
      ** If return with an error (LR seton in called program) then
      ** process for database error.
 
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    w0file
     C                   MOVE      *BLANKS       w0key
 
     C                   MOVEL     'PARM:'       w0k10            10
     C                   MOVE      T2DCCY        w0k10
     C                   MOVEL     '*CALL'       w0key
     C                   MOVE      W0K10         w0key
 
     C                   Z-ADD     3             w0ernb
     C                   MOVEL     'MEM5003'     w0msgd
     C                   MOVEL     'MIDAS  '     w0msgF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   MOVE      A6NBDP        zdecs
     C                   MOVE      'J'           zecode
 
      ** Format amount
 
     C                   MOVE      #2TADC        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#TAXD
     C                   ENDIF
 
      ** Opening Balance
 
     C     #2STBL        IFNE      *ZEROS
 
      ** Format amount
 
     C                   MOVE      #2STBL        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#OPNB
     C                   ENDIF
 
      ** Closing Balance
 
     C     #2ENBL        IFNE      *ZEROS
 
      ** Format amount
 
     C                   MOVE      #2ENBL        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#CLOB
     C                   ENDIF
 
      ** Tax Amount in Stamp Tax Ccy
 
     C                   MOVE      #2SCCY        W#CCYS
 
     C     #2TASC        IFNE      *ZEROS
 
      ** Retrieve Account Nr of decimal places
 
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      #2SCCY        @CCY              3
     C     SDCURR        PARM      SDCURR        DSFDY
 
      ** If return with an error (LR seton in called program) then
      ** process for database error.
 
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    w0file
     C                   MOVE      *BLANKS       w0key
 
     C                   MOVEL     'PARM:'       w0k10            10
     C                   MOVE      #2SCCY        w0k10
     C                   MOVEL     '*CALL'       w0key
     C                   MOVE      W0K10         w0key
 
     C                   Z-ADD     4             w0ernb
     C                   MOVEL     'MEM5003'     w0msgd
     C                   MOVEL     'MIDAS  '     w0msgF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   MOVE      A6NBDP        zdecs
     C                   MOVE      'J'           zecode
 
      ** Format amount
 
     C                   MOVE      #2TASC        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#TAXS
     C                   ENDIF
 
      ** Type of Enquire
      ** Tax Rate
 
     C                   Z-ADD     8             zdecs
     C                   MOVE      'J'           zecode
 
      ** Format amount
 
     C     #2TXRB        IFNE      *ZEROS
     C                   MOVE      #2TXRB        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#TXRT
     C                   ENDIF
 
     C                   Z-ADD     WVDATF        W#STDT
 
     C     #3CDTE        IFNE      *BLANKS
     C                   MOVE      #3CDTE        W#SDT
     C                   ELSE
     C                   MOVE      *ZEROS        W#SDT
     C                   ENDIF
 
     C                   Z-ADD     WVDATT        W#EDAT
     C     #3EDTE        IFNE      *BLANKS
     C                   MOVE      #3EDTE        W#EDT
     C                   ELSE
     C                   MOVE      *ZEROS        W#EDT
     C                   ENDIF
 
      ** Start/End Period for Average
 
     C     #2STDT        IFNE      *ZEROS
     C                   CALL      'ZDATE2'
     C                   PARM      #2STDT        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        W#STP
     C                   ENDIF
 
      ** Value Date
 
     C     #2ENDT        IFNE      *ZEROS
     C                   CALL      'ZDATE2'
     C                   PARM      #2ENDT        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        W#ENP
     C                   ENDIF
 
     C                   MOVEL     #2AKEY        W#AKEY
     C                   MOVEL     #2ETYP        W#ETYP
     C                   MOVEL     #2REVI        W#REVI
     C                   MOVEL     #2TREF        W#TREF
     C                   MOVEL     #2DRAC        W#DRAC
     C                   MOVEL     #2KCCY        W#KCCY
     C                   Z-ADD     #2MNTH        W#MNTH
 
      ** Value Date
 
     C     #2VDAT        IFNE      *ZEROS
     C                   CALL      'ZDATE2'
     C                   PARM      #2VDAT        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        W#VDAT
     C                   ENDIF
 
      ** Maturity Date
 
     C     #2MDAT        IFNE      *ZEROS
     C                   CALL      'ZDATE2'
     C                   PARM      #2MDAT        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        W#MDAT
     C                   ENDIF
 
     C                   Z-ADD     8             zdecs
     C                   MOVE      'J'           zecode
 
      ** Format amount
 
     C     #2DSPR        IFNE      *ZEROS
     C                   MOVE      #2DSPR        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#DSPR
     C                   ENDIF
 
      ** Account Key amount
      *
     C     #2KAMT        IFNE      *ZEROS
     C     #2KCCY        ANDNE     *BLANKS
 
      ** Retrieve Account Nr of decimal places
 
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      #2KCCY        @CCY              3
     C     SDCURR        PARM      SDCURR        DSFDY
 
      ** If return with an error (LR seton in called program) then
      ** process for database error.
 
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    w0file
     C                   MOVE      *BLANKS       w0key
 
     C                   MOVEL     'PARM:'       w0k10            10
     C                   MOVE      #2KCCY        w0k10
     C                   MOVEL     '*CALL'       w0key
     C                   MOVE      W0K10         w0key
 
     C                   Z-ADD     5             w0ernb
     C                   MOVEL     'MEM5003'     w0msgd
     C                   MOVEL     'MIDAS  '     w0msgF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   MOVE      A6NBDP        zdecs
     C                   MOVE      'J'           zecode
 
      ** Format amount
 
     C                   MOVE      #2KAMT        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#KAMT
     C                   ENDIF
 
     C                   CLEAR                   OBBCN1
     C                   CLEAR                   OBBCN3
     C                   CLEAR                   OBBCN4
     C     #2CNUM        IFNE      *BLANKS
     C                   MOVEL     #2CNUM        @CNUM
     C                   ELSE
     C                   MOVEL     #2DCUS        @CNUM
     C                   ENDIF
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    @CNUM            10
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   MOVEL     BBCNA1        OBBCN1
     C                   MOVEL     BBCNA3        OBBCN3
     C                   MOVEL     BBCNA4        OBBCN4
     C                   MOVEL     @CNUM         O#CNUM
     C                   MOVEL     #2TREF        OREFT
     C                   MOVEL     #2DRAC        OREFD
     C                   MOVEL     W#STP         ODATI
     C                   MOVEL     W#ENP         ODATF
 
     C     EXRSET        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Process subfile record
      *****************************************************************
     CSR   DCPRSR        BEGSR
 
      ** Setof error indicators and SFLNXTCHG
 
     C                   MOVEA     WKIND0        *IN(40)
 
      ** USER: Process subfile record (Pre-confirm)
      ** Check action code is valid, if invalid exit.
 
     C                   EXSR      SRACTD
 
     C     *IN40         IFEQ      '1'
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      DCENDT
     C                   ENDIF
      *
      ** Retrieve data from Header files and set fields
      *
     C                   EXSR      SRRSET
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      DCENDT
     C                   END
 
      ** Print advice
 
     C     #2SEL         IFEQ      'P'
     C                   OPEN      GL008170P1
     C                   WRITE     HEADP1
 
      ** Ensure the spool file is recorded by RCF
 
     C                   Z-ADD     SFNUM         ZSNUM             6 0
 
      ** Call ZSFILE for GL008170P1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO             5
     C                   PARM      *BLANKS       ENTY              3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
 
      ** If error in ZSFILE, exit via *PSSR
 
     C     ZSERR         IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CLOSE     GL008170P1
     C                   ENDIF
 
      ** Display Screen 2
 
     C     #2SEL         IFEQ      'E'
     C                   MOVE      ##SFRC        ##RR
     C                   MOVE      'Y'           #REDIS            1
     C                   MOVE      *BLANKS       W#RTRN            7
     C                   MOVEL     'GL008170'    W#PGM            10
 
     C                   CALL      'GL008171'
     C                   PARM      'E'           W#ACTI            1
     C                   PARM                    W#DATA
     C                   PARM      *BLANKS       W#RTRN            7
     C                   PARM      'USR9476'     TITLE             7
     C                   PARM      *BLANKS       W#SPARE         256
 
     C     W#RTRN        IFNE      *BLANKS
     C                   SETON                                        98
     C                   MOVEL     'WN0010  '    W0FILE
     C                   MOVE      *BLANKS       W0KEY
 
     C                   MOVEL     'GL008171'    W0KEY
 
     C                   Z-ADD     6             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
 
      ** Print Movement
 
     C     DCENDT        TAG
     C     *IN40         IFEQ      '1'
     C  N99              Z-ADD     ##RR          ##SFRC               99
     C                   SETON                                        84
     C                   ELSE
     C                   SETOFF                                       84
     C                   MOVEL     *BLANK        #2SEL
     C                   ENDIF
 
     CSR   DCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Request subfile reload
      *****************************************************************
     CSR   FBRQRL        BEGSR
     C                   MOVEL     'Y'           W0RSF
     CSR   FBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Move @STPDV2 fields to subfile
      *****************************************************************
     CSR   MBFL#1        BEGSR
     C                   MOVEL     T2KEY         #2KEY
     C                   MOVEL     T2LNRF        #2LNRF
     C                   MOVEL     T2FCNM        #2FCNM
     C                   MOVEL     T2FACT        #2FACT
     C                   MOVEL     T2FCNO        #2FCNO
     C                   MOVEL     T2FSEQ        #2FSEQ
     C                   MOVEL     T2ORED        #2ORED
     C                   MOVEL     T2DLNO        #2DLNO
     C                   MOVEL     T2TDRF        #2TDRF
     C                   MOVEL     T2BRCA        #2BRCA
     C                   MOVEL     T2CNUM        #2CNUM
     C                   MOVEL     T2DCST        #2DCUS
     C                   MOVEL     T2CCY         #2CCY
     C                   MOVEL     T2ACOD        #2ACOD
     C                   MOVEL     T2ACSQ        #2ACSQ
     C                   MOVEL     T2PREF        #2PREF
     C                   MOVEL     T2CQSQ        #2CQSQ
     C                   MOVEL     T2PBRC        #2PBRC
     C                   MOVEL     T2PSSH        #2PSSH
     C                   MOVEL     T2PCPY        #2PCPY
     C                   MOVEL     T2PDUD        #2PDUD
     C                   MOVEL     T2PEVT        #2PEVT
     C                   MOVEL     T2CDTE        #2CDTE
 
     C                   MOVEL     T2STDT        #2STDT
     C                   MOVEL     T2ENDT        #2ENDT
     C                   MOVEL     T2PSDT        #2PSDT
     C                   MOVEL     T2VALD        #2VALD
     C                   MOVEL     T2ECCY        #2ECCY
     C                   MOVEL     T2SCCY        #2SCCY
     C                   MOVEL     T2TASC        #2TASC
     C                   MOVEL     T2TADC        #2TADC
     C                   MOVEL     T2TATC        #2TAXE
     C                   MOVEL     T2STBL        #2STBL
     C                   MOVEL     T2ENBL        #2ENBL
     C     T2STFB        IFEQ      'Y'
     C     T2TXRB        MULT      100           #2TXRB
     C                   ELSE
     C     T2TXRT        MULT      100           #2TXRB
     C                   ENDIF
     C                   MOVEL     T2STFB        #2STFB
     C                   MOVEL     T2STFC        #2STFC
     C                   MOVEL     T2STFF        #2STFF
     C                   MOVEL     T2STFI        #2STFI
     C                   MOVEL     T2AKEY        #2AKEY
     C                   MOVEL     T2MNTH        #2MNTH
     C                   MOVEL     T2VDAT        #2VDAT
     C                   MOVEL     T2MDAT        #2MDAT
     C                   MOVEL     T2KCCY        #2KCCY
     C                   MOVEL     T2ETYP        #2ETYP
     C                   MOVEL     T2REVI        #2REVI
     C                   MOVEL     T2XRAT        #2DSPR                                     AR879983
 
     C     T2VALD        IFNE      *ZERO
     C                   CALL      'ZDATE2'
     C                   PARM      T2VALD        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   MOVE      ZDATE         ##DATE
     C                   MOVE      ##MM          #MM
     C                   MOVE      '20'          #CC
     C                   MOVE      ##YY          #YY
     C     #FILE         IFEQ      'SDSTMDL7'
     C     #FILE         OREQ      'SDSTMDL9'
     C     #FILE         OREQ      'SDSTMDLB'
     C                   MOVEL     ZADATE        #2DAT1
     C                   ELSE
     C                   MOVEL     ZADATE        #2DAT2
     C                   ENDIF
     C                   ENDIF
 
      ** Format Posting Date
 
     C     T2PSDT        IFNE      *zero
     C                   CALL      'ZDATE2'
     C                   PARM      T2PSDT        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   MOVE      ZDATE         ##DATE
     C                   MOVE      ##MM          #MM
     C                   MOVE      '20'          #CC
     C                   MOVE      ##YY          #YY
     C     #FILE         IFEQ      'SDSTMDL7'
     C     #FILE         OREQ      'SDSTMDL9'
     C     #FILE         OREQ      'SDSTMDLB'
     C                   MOVEL     ZADATE        #2DAT2
     C                   ELSE
     C                   MOVEL     ZADATE        #2DAT1
     C                   ENDIF
     C                   ENDIF
 
     C                   CLEAR                   #2REF1
     C                   CLEAR                   #2ROW2
     C                   MOVE      *BLANKS       #REFX            28
     C                   CLEAR                   #2REVE
     C     T2REVI        IFEQ      '0'
     C                   MOVE      'N'           #2REVE
     C                   ENDIF
     C     T2REVI        IFEQ      '1'
     C                   MOVE      'Y'           #2REVE
     C                   ENDIF
 
      ** set dr account
 
     C                   MOVE      T2DBRC        A2BRCA
     C                   MOVE      T2DCST        A2CNUM
     C                   MOVE      T2DCCY        A2CCY
     C                   MOVE      T2DACD        A2ACOD
     C                   MOVE      T2DASQ        A2ACSQ
 
     C                   MOVE      A#ACCD        #2ROW2
     C                   MOVE      #2ROW2        #2DRAC
     C                   CLEAR                   #2TKEY
 
      ** Set transaction field
 
     C     T2KEY         IFEQ      'ACCOUNT'
     C                   MOVEL     'Account'     #2TKEY
     C                   MOVE      T2BRCA        A2BRCA
     C                   MOVE      T2CNUM        A2CNUM
     C                   MOVE      T2CCY         A2CCY
     C                   MOVE      T2ACOD        A2ACOD
     C                   MOVE      T2ACSQ        A2ACSQ
     C                   MOVE      A#ACCD        #REFX
     C                   ENDIF
 
     C     T2KEY         IFEQ      'LOAN'
     C                   MOVEL     'Loan'        #2TKEY
     C                   MOVEL     T2LNRF        #REFX
     C                   ENDIF
 
     C     T2KEY         IFEQ      'DEAL'
     C                   MOVEL     'Deal'        #2TKEY
     C                   MOVEL     T2DLNO        #REFX
     C                   ENDIF
 
     C     T2KEY         IFEQ      'SECURITY'
     C                   MOVEL     'Security'    #2TKEY
     C                   MOVEL     T2TDRF        #REFX
     C                   ENDIF
 
     C     T2KEY         IFEQ      'IPAY'
     C     T2KEY         OREQ      'OPAY'
     C                   MOVEL     'Payment'     #2TKEY
     C                   MOVEL     T2PREF        #REFX
     C                   ENDIF
 
     C     T2KEY         IFEQ      'CHEQC'
     C     T2KEY         OREQ      'CHEQP'
     C                   MOVEL     'Cheque'      #2TKEY
     C                   MOVEL     T2PREF        A2PREF
     C                   MOVEL     T2CQSQ        A2CQSQ
     C                   MOVEL     A#CHEQ        #REFX
     C                   ENDIF
 
     C     T2KEY         IFEQ      'FACILITY'
     C                   MOVEL     'Facility'    #2TKEY
     C                   MOVEL     T2FCNM        A2FCNM
     C                   MOVEL     T2FACT        A2FACT
     C                   MOVEL     T2FCNO        A2FCNO
     C                   MOVEL     A#FACI        #REFX
     C                   ENDIF
 
     C     T2KEY         IFEQ      'FEE'
     C                   MOVEL     'Fee'         #2TKEY
     C                   MOVEL     T2FSEQ        A2FSEQ
     C                   CALL      'ZDATE2'
     C                   PARM      T2ORED        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        A2ORED
     C                   MOVEL     A#FEES        #REFX
     C                   ENDIF
 
     C     T2KEY         IFEQ      'POSSET'
     C                   MOVEL     'Pos Set'     #2TKEY
     C                   MOVE      T2PBRC        A2PBRC
     C                   MOVE      T2PSSH        A2PSSH
     C                   MOVE      T2PCPY        A2PCPT
     C                   CALL      'ZDATE2'
     C                   PARM      T2PDUD        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVE      ZADATE        A2PDUD
     C                   MOVE      T2PEVT        A2PEVT
     C                   MOVEL     A#POSS        #REFX
     C                   ENDIF
 
     C                   MOVE      #REFX         #2TREF
     C                   MOVE      #REFX         #2REF1
 
      ** Transaction Key
 
     C                   CLEAR                   #WGROS
     C     T2STFB        IFEQ      'Y'
     C                   Z-ADD     T2AVBL        #WGROS
     C                   ELSE
     C                   Z-ADD     T2GROS        #WGROS
     C                   ENDIF
     C                   MOVE      T2ECCY        #2GCCY
 
     C     T2KAMT        IFNE      0
     C                   Z-ADD     T2KAMT        #WGROS
     C                   MOVE      T2KCCY        #2GCCY
     C                   ENDIF
 
      ** Edit Average Balance
 
     C     #WGROS        IFNE      *zero
 
      ** Retrieve Account Nr of decimal places
 
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      #2GCCY        @CCY              3
     C     SDCURR        PARM      SDCURR        DSFDY
 
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    W0FILE
     C                   MOVE      *BLANKS       W0KEY
 
     C                   MOVEL     'PARM:'       W0K10            10
     C                   MOVE      #2GCCY        W0K10
     C                   MOVEL     '*CALL'       W0KEY
     C                   MOVE      W0K10         W0KEY
 
     C                   Z-ADD     7             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   MOVE      A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
 
     C                   MOVE      #WGROS        ZFLD15
 
     C                   EXSR      FMTAMT
     C                   MOVEL     ZOUT21        #2GROS
     C                   ELSE
     C                   CLEAR                   #2GROS
     C                   ENDIF
 
      ** Edit Tax amount
 
     C                   MOVE      T2DCCY        #2DCCY
     C     T2TADC        IFNE      *ZERO
     C     T2DCCY        ANDNE     *BLANKS
 
      ** Retrieve Account Nr of decimal places
 
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      T2DCCY        @CCY              3
     C     SDCURR        PARM      SDCURR        DSFDY
 
      ** If return with an error (LR seton in called program) then
      ** process for database error.
 
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    W0FILE
     C                   MOVE      *BLANKS       W0KEY
 
     C                   MOVEL     'PARM:'       W0K10            10
     C                   MOVE      T2DCCY        W0K10
     C                   MOVEL     '*CALL'       W0KEY
     C                   MOVE      W0K10         W0KEY
 
     C                   Z-ADD     8             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   MOVE      A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
 
     C                   MOVE      T2TADC        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVEL     ZOUT21        #2STAX
     C                   ELSE
     C                   CLEAR                   #2stax
     C                   MOVE      '0'           #2stax
     C                   ENDIF
 
      ** Stamp tax type
 
     C                   CLEAR                   #2TAXT
     C     T2STFF        IFEQ      'Y'
     C                   EVAL      #2TAXT = 'F'
     C                   ENDIF
     C     T2STFB        IFEQ      'Y'
     C                   EVAL      #2TAXT = 'B'
     C                   ENDIF
     C     T2STFC        IFEQ      'Y'
     C                   EVAL      #2TAXT = 'C'
     C                   ENDIF
     C     T2STFI        IFEQ      'Y'
     C                   EVAL      #2TAXT = 'I'
     C                   ENDIF
 
     C                   MOVEL     *BLANK        #2SEL
 
     CSR   MBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CALC: Format Amount fields
      *****************************************************************
     CSR   FMTAMT        BEGSR
 
     C                   MOVE      *BLANKS       ZOUT21           21
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT21
     CSR   FMTXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Initialise subfile control
      *****************************************************************
     CSR   MEIZ#2        BEGSR
     C                   MOVEL     P1ACTC        #PACTC
 
      ** Fill Command lines and narrative text from messages
 
     C                   CALL      'SDC008190'                          9090
     C                   PARM      'USR9469'     #MSGID
     C                   PARM      'GLUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
 
     C                   MOVEL     #MSTX1        ##CMD1
 
     C                   MOVEL     'USR9468'     #UFKEY
 
     C     *LIKE         DEFINE    #MSGID        #UFKEY
     C                   CALL      'SDC008190'                          9090
     C                   PARM      #UFKEY        #MSGID
     C                   PARM      'GLUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
 
     C                   MOVEL     #MSTX1        ##CMD2
 
     CSR   MEEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Send message to program's message queue
      *****************************************************************
     CSR   ZASNMS        BEGSR
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
 
      ** If no message file specified, use default
 
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   ENDIF
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
      ** Clear all fields for default mechanism next time
 
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
 
     CSR   ZAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Cancel & exit program
      *****************************************************************
     CSR   ZXEXPG        BEGSR
 
      ** USER: Exit program processing
      ** CASE: CTL.*CMD key is CF03
 
     C     *IN03         IFEQ      '1'
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   ENDIF
 
      ** CASE: CTL.*CMD key is CF12
 
     C     *IN12         IFEQ      '1'
     C                   MOVEL     'USR0790'     P0RTN
     C                   ENDIF
 
     C                   EXSR      ZYEXPG
     CSR   ZXEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Exit program: Direct
      *****************************************************************
     CSR   ZYEXPG        BEGSR
 
      ** Copy any undisplayed messages back to caller
 
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
     C                   MOVEL     '1'           *INLR
     C                   RETURN
 
     CSR   ZYEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Initialisation
      *****************************************************************
     CSR   ZZINIT        BEGSR
 
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   ENDIF
     C                   MOVE      *BLANK        P0RTN             7
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
 
      ** Initialise indicators for re-entry
 
     C                   MOVE      '0'           *IN
 
      ** Setup job date/time
 
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
 
      ** Update screen time
 
     C                   TIME                    ##TME             6 0
 
      ** Obtain default message file
 
     C                   MOVEL     'GLUSRMSG'    ZADFMF           10
     C                   Z-ADD     6             ##SFPG            3 0
     C                   Z-ADD     1             ##SFRC
 
      ** Maximum record number
 
     C                   Z-ADD     *ZERO         ##RRMX
 
      ** Scan limit
 
     C                   Z-ADD     500           W0SLM             5 0
 
      ** Subfile pages
 
     C                   Z-ADD     1             W0SPG             3 0
 
      ** Processed Subfile record
 
     C                   Z-ADD     0             W0RR0             4 0
 
     C                   MOVEL     *BLANK        W0GRP             1
     C                   Z-ADD     0             Q                 5 0
     C                   MOVEA     '00'          *IN(77)
 
      ** USER: Initialize program
 
     C                   MOVEA     CPY@          ACT@             80
 
      ** Get Rundate - Rundate  *
 
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7
     C                   MOVE      AGMRDT        WUMRDT            7
     C                   MOVE      AGRDNB        WURDNB            5 0
     C                   MOVE      AGSUC         WUSUC             1
     C                   MOVE      AGDFF         WUDFF             1
     C                   MOVE      AGMBIN        WUMBIN            1
 
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If return with an error (LR seton in called program) then
      ** process for database error.
 
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     9             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   MOVE      0             WPSDTF            5 0
     C                   MOVE      0             WPSDTT            5 0
 
      ** Convert Run date to ddmmyy
 
     C                   CALL      'ZDATE2'
     C                   PARM      BJRDNB        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   Z-ADD     BJRDNB        WVDATF
     C                   MOVE      ZDATE         DTDTA
     C                   MOVE      ZDATE         #3EDTE
 
      ** Find first day of month ddmmyy
 
     C     BJDFIN        IFEQ      'D'
     C                   Z-ADD     1             DT12
     C                   ELSE
     C                   Z-ADD     1             DT34
     C                   ENDIF
 
      ** Convert start of month to day nr
 
     C                   MOVE      DTDTA         WNCDTE            6 0
     C                   CALL      'ZDATE1'                             90
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM                    WNCDTE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO            5 0
 
      ** Start of month
 
     C                   Z-ADD     ZDAYNO        WVDATF
     C                   Z-ADD     ZDAYNO        T#DATE
 
      ** Convert End of previous month  to ddmmyy
 
     C                   CALL      'ZDATE2'
     C                   PARM      WVDATF        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   MOVE      ZDATE         #3CDTE
 
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     MMODDS        PARM      *BLANKS       DSFDY
 
      ** If return with an error (LR seton in called program) then
      ** process for database error.
 
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     10            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
 
      ** Allow function key 12 if lower case action
 
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     'E'           P1ACTC
 
     C                   MOVE      *BLANKS       @SEL              1
     C     *LIKE         DEFINE    T2KEY         T#KEY
     C     *LIKE         DEFINE    T2TYPE        T#TYPE
     C     *LIKE         DEFINE    T2LNRF        T#LNRF
     C     *LIKE         DEFINE    T2FCNM        T#FCNM
     C     *LIKE         DEFINE    T2FACT        T#FACT
     C     *LIKE         DEFINE    T2FCNO        T#FCNO
     C     *LIKE         DEFINE    T2FSEQ        T#FSEQ
     C     *LIKE         DEFINE    T2ORED        T#ORED
     C     *LIKE         DEFINE    T2DLNO        T#DLNO
     C     *LIKE         DEFINE    T2TDRF        T#TDRF
     C     *LIKE         DEFINE    T2BRCA        T#BRCA
     C     *LIKE         DEFINE    T2CNUM        T#CNUM
     C     *LIKE         DEFINE    T2CCY         T#CCY
     C     *LIKE         DEFINE    T2ACOD        T#ACOD
     C     *LIKE         DEFINE    T2ACSQ        T#ACSQ
     C     *LIKE         DEFINE    T2PREF        T#PREF
     C     *LIKE         DEFINE    T2CQSQ        T#CQSQ
     C     *LIKE         DEFINE    T2PBRC        T#PBRC
     C     *LIKE         DEFINE    T2PCPY        T#PCPY
     C     *LIKE         DEFINE    T2PSSH        T#PSSH
     C     *LIKE         DEFINE    T2PDUD        T#PDUD
     C     *LIKE         DEFINE    T2PEVT        T#PEVT
     C     *LIKE         DEFINE    T2RCTP        T#RCTP
     C     *LIKE         DEFINE    T2CDTE        T#CDTE
     C     *LIKE         DEFINE    T2ASEQ        T#ASEQ
 
     C     *LIKE         DEFINE    T2DBRC        T#DBRC
     C     *LIKE         DEFINE    T2DCST        T#DCST
     C     *LIKE         DEFINE    T2DCCY        T#DCCY
     C     *LIKE         DEFINE    T2DACD        T#DACD
     C     *LIKE         DEFINE    T2DASQ        T#DASQ
     C     *LIKE         DEFINE    T2PSDT        T#DATE
     C     *LIKE         DEFINE    T2PSDT        T#DAT2
 
     C                   CLEAR                   T#BRCA
     C                   CLEAR                   T#CNUM
     C                   CLEAR                   T#CCY
     C                   CLEAR                   T#ACOD
     C                   CLEAR                   T#ACSQ
     C                   CLEAR                   T#ACOD
     C                   CLEAR                   T#ACSQ
     C                   CLEAR                   T#FCNM
     C                   CLEAR                   T#FACT
     C                   CLEAR                   T#FCNO
     C                   CLEAR                   T#FSEQ
     C                   CLEAR                   T#ORED
     C                   CLEAR                   T#TDRF
     C                   CLEAR                   T#PREF
     C                   CLEAR                   T#CQSQ
     C                   CLEAR                   T#DLNO
     C                   CLEAR                   T#LNRF
     C                   CLEAR                   T#ASEQ
     C                   CLEAR                   T#TYPE
     C                   CLEAR                   T#DAT2
 
      ** USER: Initialize subfile control
      ** Position on file SDSTMDL7 - SDSTMDL8
 
     C     KPOSAB        KLIST
     C                   KFLD                    T#BRCA
     C                   KFLD                    T#CNUM
     C                   KFLD                    T#CCY
     C                   KFLD                    T#ACOD
     C                   KFLD                    T#ACSQ
     C                   KFLD                    T#DATE
 
     C     KPAB          KLIST
     C                   KFLD                    T#BRCA
     C                   KFLD                    T#CNUM
     C                   KFLD                    T#CCY
     C                   KFLD                    T#ACOD
     C                   KFLD                    T#ACSQ
 
      ** Position on file SDSTMDLB - SDSTMDLC
 
     C     KPOSEF        KLIST
     C                   KFLD                    T#BRCA
     C                   KFLD                    T#CNUM
     C                   KFLD                    T#CCY
     C                   KFLD                    T#ACOD
     C                   KFLD                    T#ACSQ
     C                   KFLD                    T#FCNM
     C                   KFLD                    T#FACT
     C                   KFLD                    T#FCNO
     C                   KFLD                    T#FSEQ
     C                   KFLD                    T#ORED
     C                   KFLD                    T#TDRF
     C                   KFLD                    T#PREF
     C                   KFLD                    T#CQSQ
     C                   KFLD                    T#DLNO
     C                   KFLD                    T#LNRF
     C                   KFLD                    T#PBRC
     C                   KFLD                    T#PSSH
     C                   KFLD                    T#PCPY
     C                   KFLD                    T#PDUD
     C                   KFLD                    T#PEVT
     C                   KFLD                    T#ASEQ
     C                   KFLD                    T#TYPE
     C                   KFLD                    T#DATE
     C                   KFLD                    T#DAT2
 
     C     KPEF          KLIST
     C                   KFLD                    T#BRCA
     C                   KFLD                    T#CNUM
     C                   KFLD                    T#CCY
     C                   KFLD                    T#ACOD
     C                   KFLD                    T#ACSQ
     C                   KFLD                    T#FCNM
     C                   KFLD                    T#FACT
     C                   KFLD                    T#FCNO
     C                   KFLD                    T#FSEQ
     C                   KFLD                    T#ORED
     C                   KFLD                    T#TDRF
     C                   KFLD                    T#PREF
     C                   KFLD                    T#CQSQ
     C                   KFLD                    T#DLNO
     C                   KFLD                    T#LNRF
     C                   KFLD                    T#PBRC
     C                   KFLD                    T#PSSH
     C                   KFLD                    T#PCPY
     C                   KFLD                    T#PDUD
     C                   KFLD                    T#PEVT
 
      ** Header File SDSTMPL0
 
     C     KPOST         KLIST
     C                   KFLD                    #2KEY
     C                   KFLD                    #2LNRF
     C                   KFLD                    #2FCNM
     C                   KFLD                    #2FACT
     C                   KFLD                    #2FCNO
     C                   KFLD                    #2FSEQ
     C                   KFLD                    #2ORED
     C                   KFLD                    #2DLNO
     C                   KFLD                    #2TDRF
     C                   KFLD                    #2BRCA
     C                   KFLD                    #2CNUM
     C                   KFLD                    #2CCY
     C                   KFLD                    #2ACOD
     C                   KFLD                    #2ACSQ
     C                   KFLD                    #2PREF
     C                   KFLD                    #2CQSQ
     C                   MOVEL     'SDSTMDL9'    #FILE            10
 
      ** Initialise subfile control
 
     C                   EXSR      MEIZ#2
 
     CSR   ZZEXIT        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * PSSR Processing
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C     @@PSSR        IFNE      *BLANK
     C                   SETON                                        H1  LR
     C                   RETURN
     C                   ENDIF
 
      ** Flag routine as started; define action code:
 
     C                   MOVE      'Y'           @@PSSR            1
     C                   MOVE      W0ACT         W0ACT             8
 
     C                   MOVE      ##PGM         ERPGM
     C                   MOVE      ##RTVN        ERFILE
     C     ##MSID        CAT(P)    ##SQNO        ERKEY
     C                   Z-ADD     998           ERERNB
     C                   MOVEL     ##MSWK        ERNARR
 
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
 
     C                   MOVEA     @STK          #@STK           100
 
     C                   SETON                                        U7U8LR
     C                   MOVE      '*ERROR*'     W0RTN             7
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRFILE   : *PSSR routine for all files                       *
      *                                                               *
      *  CALLED BY: IBM controlled - invalid access to file           *
      *                                                               *
      *  CALLS    : CGZERROR                                          *
      *                                                               *
      * In the INIT sub-routine, the fields W0MSGD and W0MSGF should  *
      * be set to the default message I.D and message file that are   *
      * used for the module. If not, the defaults of MEM5002 and MIDAS*
      * will be used.                                                 *
      *                                                               *
      *****************************************************************
     CSR   SRFILE        BEGSR
 
     C                   DUMP
     C     @@FILE        IFNE      *BLANKS
     C                   MOVEL     '1'           *INLR
     C                   RETURN
     C                   ENDIF
 
     C                   MOVEL     'Y'           @@FILE            1
 
     C                   MOVEL     *BLANKS       ERDTA
     C                   MOVEL     ##PGM         ERPGM
 
     C     Q             IFGT      1
     C     Q             ANDLT     101
     C                   MOVEL     @STK(Q)       ERSTK
     C                   ELSE
     C                   MOVEL     '*Nostkin'    ERSTK
     C                   ENDIF
 
     C                   MOVEL     ##ERST        ERKEY
     C                   Z-ADD     999           ERERNB
     C                   MOVEL     ##ERFL        ERFILE
     C                   MOVEL     W0PREF        ERPREF
 
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      'MEM5002'     #MSGID
     C                   PARM      'MIDAS   '    #MSGF
     C                   PARM      *BLANKS       #MSGTX
 
     C                   MOVEL     #MSGTX        ERNARR
 
     C                   CALL      'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID            7
     C                   PARM      'MIDAS  '     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      ERDTA         #MSGDT          256
     C                   PARM      '*PRV'        #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MOPERQ '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
 
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
 
     C                   SETON                                        U7U8LR
     C                   MOVEL     '*ERROR*'     W0RTN             7
 
     C                   MOVEA     @STK          #@STK           100
 
     C                   RETURN
 
     CSR   EXFILE        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRERR    : Report error and close down program               *
      *                                                               *
      *  CALLED BY: All subroutines                                   *
      *                                                               *
      *  CALLS    : CGZERROR                                          *
      *                                                               *
      * In the INIT sub-routine, the fields W0MSGD and W0MSGF should  *
      * be set to the default message I.D and message file that are   *
      * used for the module. If not, the defaults of MEM5001 and MIDAS*
      * will be used.                                                 *
      *                                                               *
      *****************************************************************
     CSR   SRERR         BEGSR
 
     C     *LIKE         DEFINE    T2AVBL        #WGROS
     C     *LIKE         DEFINE    ERKEY         W0KEY
     C     *LIKE         DEFINE    ERERNB        W0ERNB
     C     *LIKE         DEFINE    ERFILE        W0FILE
     C     *LIKE         DEFINE    ERPREF        W0PREF
     C     *LIKE         DEFINE    #MSGID        W0MSGD
     C     *LIKE         DEFINE    #MSGF         W0MSGF
 
     C                   Z-ADD     Q             Q                 5 0
     C                   DUMP
     C                   MOVEL     *BLANKS       ERDTA
     C                   MOVEL     ##PGM         ERPGM
 
     C     Q             IFGT      1
     C     Q             ANDLT     101
     C                   MOVEL     @STK(Q)       ERSTK
     C                   ELSE
     C                   MOVEL     '*Nostkin'    ERSTK
     C                   ENDIF
 
     C                   MOVEL     W0KEY         ERKEY
     C                   Z-ADD     W0ERNB        ERERNB
     C                   MOVEL     W0FILE        ERFILE
     C                   MOVEL     W0PREF        ERPREF
 
      ** Get message for message code. If the msg code or the msg file
      ** have not been set up then use the defaults.
 
     C     W0MSGD        IFEQ      *BLANKS
     C                   MOVEL     'MEM5001'     C#FMSG            7
     C                   ELSE
     C                   MOVEL     W0MSGD        C#FMSG
     C                   ENDIF
 
     C     W0MSGF        IFEQ      *BLANKS
     C                   MOVEL     'MIDAS   '    C#FMSF           10
     C                   ELSE
     C                   MOVEL     W0MSGF        C#FMSF
     C                   ENDIF
 
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      C#FMSG        #MSGID
     C                   PARM      C#FMSF        #MSGF
     C                   PARM      *BLANKS       #MSGTX
 
     C                   MOVEL     #MSGTX        ERNARR
 
     C                   CALL      'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID            7
     C                   PARM      'MIDAS  '     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      ERDTA         #MSGDT          256
     C                   PARM      '*PRV '       #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MOPERQ '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
 
     C                   SETON                                        U7U8LR
     C                   MOVEL     '*ERROR*'     W0RTN             7
 
      ** Provide a fuller report:
 
     C                   MOVEA     @STK          #@STK           100
     C                   RETURN
 
     CSR   EXERR         ENDSR
      *****************************************************************
      * End of /COPY SRERRC                                           *
      *****************************************************************
**  CPY@
(C) Copyright Misys International Banking Systems Ltd. 2010
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
