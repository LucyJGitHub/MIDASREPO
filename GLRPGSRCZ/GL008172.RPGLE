     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Movements Report SIGNEDOFF')        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL008172 - Stamp Tax Movements Report                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd 2010             *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *
      ** Stamp Tax Details File
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
      ** Print File
     FGL008172P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(SRFILE)
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array of QCMDEXC commands
      *
     D EDT             S              1    DIM(80)
      *
      ** Array of QCMDEXC command to edit
      *
     D @STK            S             10    DIM(100)
     D @REC            S              3  0 DIM(100)
      *
      ** Subroutine stack
      *
     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)
      *
      ** Program data structure
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      *
      ** Rename filler field on LDA
      ** CRT001 changes mean that there is now a field ZZ019 on APOSTPD
      ** and associated PFs, which are held in a DS in some CG programs.
      ** The same field in two DS causes those programs to fail to
      ** compile - hence this version of ZZ019 is renamed.
     D  DBZZ19       E                     EXTFLD(ZZ019)
      *                                     134 141 DBFILE
      *        Defines:                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
     D ERDTA         E DS                  EXTNAME(CGERDTA)
      *
      ** Send message data structure
      *
      *                                       1  10 ERPGM
      *                                      11  20 ERFILE
      *                                      21  50 ERKEY
      *                                      51  550ERERNB
      *                                      56 135 ERNARR
      *                                     136 145 ERSTK
      *                                     146 175 ERPREF
      *
     D M#DTA           DS           256
      *
      ** Message Data - Action field
      *
      *                          Field Text
     D  #MSGTX                 1     80
      *                          Data Text
     D  ##MSGD                81    256
     D*
      /EJECT
      ** Data structures:
      * -------------------------------------------------------------------
     D DTDTA           DS
     D DT12                    1      2  0
     D DT34                    3      4  0
     D DT56                    5      6  0
      *
      * -------------------------------------------------------------------
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
      * -------------------------------------------------------------------
     D A#FACI          DS
      *
     D A2FCNM                  1      6
     D                         7      7    INZ('-')
     D A2FACT                  8     10  0
     D                        11     11    INZ('-')
     D A2FCNO                 12     13  0
      * -------------------------------------------------------------------
     D A#CHEQ          DS
      *
     D A2PREF                  1     15
     D                        16     16    INZ('-')
     D A2CQSQ                 17     18
      * -------------------------------------------------------------------
     D A#FEES          DS
      *
     D A2FSEQ                  1      2
     D                         3      3    INZ('-')
     D A2ORED                  4     10
      * -------------------------------------------------------------------
     D A#POSS          DS
      *
     D A2PBRC                  1      3
     D                         4      4    INZ('-')
     D A2PSSH                  5     14
     D                        15     15    INZ('-')
     D A2PCPT                 16     21
     D                        22     22    INZ('-')
     D A2PDUD                 23     28
     D                        29     29    INZ('-')
     D A2PEVT                 30     31
      * -------------------------------------------------------------------
     D                 DS
     D ZOUT15                  1     25
     D ZOUT0                   1     21
     D ZOUT1                   2     23
     D ZOUT2                   3     24
     D ZOUT3                   5     25
      *
      ** Data structures:
      * -------------------------------------------------------------------
     D SPOOL1          DS
      *
     D SFILE1                 83     92
     D SFNUM                 123    124B 0
     D FLLN1                 188    189B 0
     D PRTLN1                367    368B 0
      *
      * -------------------------------------------------------------------
     D JBDTTM          DS
      ** Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      *
      * -------------------------------------------------------------------
     D ##DATE          DS
      ** DATE in DDMMYY format
     D  ##DD                   1      2
     D  ##MM                   3      4
     D  ##YY                   5      6
      *
      * -------------------------------------------------------------------
     D #DATE           DS
      ** DATE in MMCCYY format
     D  #MM                    1      2
     D  #CC                    3      4
     D  #YY                    5      6
      * -------------------------------------------------------------------
     D W#DATA          DS          1024
      *
      ** Key details
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
      *
      ** Dr account details
     D W#DACC                114    141
      *
      ** Posting Date and Value Date
     D W#PSDT                142    148
     D W#VLDT                149    155
      *
      ** Gross Amount
     D W#GROS                156    176
      *
      ** Tax Amount in Transaction/Account Ccy
     D W#TAXE                177    197
     D W#CCYE                198    200
      *
      ** Tax Amount in Debit Account Ccy
     D W#TAXD                201    221
     D W#CCYD                222    224
      *
      ** Tax Amount in Stamp Tax  Ccy
     D W#TAXS                225    245
     D W#CCYS                246    248
      *
      ** Total Tax on Average
     D W#TAXA                249    269
     D W#TAXI                270    290
      *
      ** Type of Tax enquired (Interest/Average)
     D W#TTYP                291    291
      *
      ** Print Flag
      *
     D W#PRTF                292    292
      *
      ** Tax Rate
      *
     D W#TXRT                293    313
      *
      ** Start/End date (day nr)
      *
     D W#STDT                314    318  0
     D W#EDAT                319    323  0
      *
      ** Start/End Date
      *
     D W#SDT                 324    329  0
     D W#EDT                 330    335  0
      *
     D W#OPNB                336    356
     D W#CLOB                357    377
      *
      ** Start/End Period
      *
     D W#STP                 378    384
     D W#ENP                 385    391
      *
      ** Account key/event/reverse indicator
      *
     D W#AKEY                391    405
     D W#ETYP                406    407
     D W#REVI                408    408
      *
      ** account key amount/ccy
      *
     D W#KAMT                409    429
     D W#KCCY                430    432
      *
      ** value/maturity Date/nr of month
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
      *
      * -------------------------------------------------------------------
     D W#REPO          DS
     D W#PRT                   1      1
     D W#TTY                   2      2
      *
      * -------------------------------------------------------------------
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
      *
      * -------------------------------------------------------------------
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
      *
      * -------------------------------------------------------------------
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      ** Get Rundate - Rundate  *
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFAC2       E                     EXTFLD(QQDFAC)
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
      *
      ** Modules Data Structure *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data Structures used by Access Programs
      *
      /EJECT
      ** Parameter declarations
     D P1PARM          DS
      ** I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS           100
      ** KEY: Direct Debit mandates     Retrieval index
      ** I : MAP Structure Type
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
      *
      ** KEY: Direct Debit mandates     Retrieval index
      ** I : MAP Structure Type
      *
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
      *
      ** Message data for 'Invalid Action code (FT1)'
      ** *SFLSEL
      *
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      *
      ** Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     D W0DATA          DS           256
      *
      ** Define data structure used to pass parameters
      *
     D  B#BRCA                 1      3
     D  O#ACTD                 4      4
     D  O#CPGM                 5     14
      *
      ** Parameter fields
      *
     D ZDAYNO          S              5  0
     D ZDATFM          S              1
     D ZDATE           S              6  0
     D ZADATE          S              7
     D P@RTCD          S              7
     D P@OPTN          S              7
     D @CCY            S              3
     D SEQNO           S              5
     D ENTY            S              3
     D ZSERR           S              1
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D #MSGID          S              7
     D #MSGF           S             10
     D #MSGFL          S             10
     D #MSGDT          S            256
     D #MSGR           S              5
     D #PRGM           S             10
     D #MSGQ           S             10
     D #MSGT           S              7
      *
      ** Work fields
      *
     D WWA2            S              2
     D WWA10           S             10
     D W0K10           S             10
     D WQB10X          S             10
     D TRATT           S            132
     D W0RTN           S              7
     D W0RSL           S              1
     D W0RSF           S              1
     D ##TIME          S              6  0
     D ZADFMF          S             10
     D ##SFPG          S              3  0
     D W0GRP           S              1
     D Q               S              5  0
     D ACT@            S             80
     D ##MRDT          S              7
     D WUMRDT          S              7
     D WURDNB          S              5  0
     D WUSUC           S              1
     D WUDFF           S              1
     D WUMBIN          S              1
     D W@B10X          S             10
     D OSELE1          S             15
     D ZSNUM           S              6  0
     D ZOUT21          S             21
     D @@PSSR          S              1
     D W0ACT           S              8
     D #@STK           S            100
     D @@FILE          S              1
     D C#FMSG          S              7
     D C#FMSF          S             10
     D T#DATE          S                   LIKE(T2PSDT)
     D T#DAT2          S                   LIKE(T2PSDT)
     D T#KEY           S                   LIKE(T2KEY)
     D T#TYPE          S                   LIKE(T2TYPE)
     D T#LNRF          S                   LIKE(T2LNRF)
     D T#FCNM          S                   LIKE(T2FCNM)
     D T#FACT          S                   LIKE(T2FACT)
     D T#FCNO          S                   LIKE(T2FCNO)
     D T#FSEQ          S                   LIKE(T2FSEQ)
     D T#ORED          S                   LIKE(T2ORED)
     D T#DLNO          S                   LIKE(T2DLNO)
     D T#TDRF          S                   LIKE(T2TDRF)
     D T#BRCA          S                   LIKE(T2BRCA)
     D T#CNUM          S                   LIKE(T2CNUM)
     D T#CCY           S                   LIKE(T2CCY)
     D T#ACOD          S                   LIKE(T2ACOD)
     D T#ACSQ          S                   LIKE(T2ACSQ)
     D T#PREF          S                   LIKE(T2PREF)
     D T#CQSQ          S                   LIKE(T2CQSQ)
     D T#PBRC          S                   LIKE(T2PBRC)
     D T#PSSH          S                   LIKE(T2PSSH)
     D T#PCPY          S                   LIKE(T2PCPY)
     D T#PDUD          S                   LIKE(T2PDUD)
     D T#PEVT          S                   LIKE(T2PEVT)
     D T#RCTP          S                   LIKE(T2RCTP)
     D T#ASEQ          S                   LIKE(T2ASEQ)
     D #WGROS          S                   LIKE(T2AVBL)
     D W0KEY           S                   LIKE(ERKEY)
     D W0ERNB          S                   LIKE(ERERNB)
     D W0FILE          S                   LIKE(ERFILE)
     D W0PREF          S                   LIKE(ERPREF)
     D W0MSGD          S                   LIKE(#MSGID)
     D W0MSGF          S                   LIKE(#MSGF)
      /EJECT
      *****************************************************************
      ** Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    W#DATA
      *
      ** Initialize
      *
     C                   EXSR      ZZINIT
      *
     C                   EXSR      ZZPRIN
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   ZZPRIN        BEGSR
      *****************************************************************
      *
     C     *IN82         DOWEQ     '0'
      *
     C     W#FILE        IFEQ      'SDSTMDL7'
     C     KPAB          READE     @STMDVA                                82
     C                   ENDIF
      *
     C     W#FILE        IFEQ      'SDSTMDL8'
     C     KPAB          READE     @STMDVB                                82
     C                   ENDIF
      *
     C     W#FILE        IFEQ      'SDSTMDL9'
     C                   READ      @STMDVC                                82
     C                   ENDIF
      *
     C     W#FILE        IFEQ      'SDSTMDLA'
     C                   READ      @STMDVD                                82
     C                   ENDIF
      *
     C     W#FILE        IFEQ      'SDSTMDLB'
     C     KPEF          READE     @STMDVE                                82
     C                   ENDIF
      *
     C     W#FILE        IFEQ      'SDSTMDLC'
     C     KPEF          READE     @STMDVF                                82
     C                   ENDIF
      *
     C     *IN82         CABEQ     *ON           BB900
      *
      ** If Type of transaction selected
      *
     C     W#MODU        IFNE      *BLANKS
      *
     C     W#MODU        IFEQ      'ACC'
     C     T2KEY         CABNE     'ACCOUNT'     BB020
     C                   ENDIF
      *
     C     W#MODU        IFEQ      'LOA'
     C     T2KEY         CABNE     'LOAN   '     BB020
     C                   ENDIF
      *
     C     W#MODU        IFEQ      'DEA'
     C     T2KEY         CABNE     'DEAL   '     BB020
     C                   ENDIF
      *
     C     W#MODU        IFEQ      'SEC'
     C     T2KEY         CABNE     'SECURITY'    BB020
     C                   ENDIF
      *
     C     W#MODU        IFEQ      'FAC'
     C     T2KEY         CABNE     'FACILITY'    BB020
     C                   ENDIF
      *
     C     W#MODU        IFEQ      'FEE'
     C     T2KEY         CABNE     'FEE     '    BB020
     C                   ENDIF
      *
     C     W#MODU        IFEQ      'POS'
     C     T2KEY         CABNE     'POSSET  '    BB020
     C                   ENDIF
      *
     C     W#MODU        IFEQ      'PAY'
     C     T2KEY         IFNE      'IPAY    '
     C     T2KEY         ANDNE     'OPAY    '
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
      *
     C     W#MODU        IFEQ      'CHE'
     C     T2KEY         IFNE      'CHEQC   '
     C     T2KEY         ANDNE     'CHEQP   '
     C                   GOTO      BB020
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Start Date not blank, then select date >= selected
      *
     C     W#STDT        IFGT      0
     C     T2VALD        CABLT     W#STDT        BB020
     C                   ENDIF
      *
      ** If End Date not blank, then select date <= selected
      *
     C     W#EDAT        IFGT      0
     C     T2VALD        CABGT     W#EDAT        BB020
     C                   ENDIF
      *
      ** If Posting Dates are not blank, check if record is within the
      *    From/To Date
     C     W#PFRM        IFGT      0
     C     T2PSDT        CABLT     W#PFRM        BB020
     C                   ENDIF
     C     W#PTO         IFGT      0
     C     T2PSDT        CABGT     W#PTO         BB020
     C                   ENDIF
      *
      ** If Dr Customer selected, select only records where customer =
      *
     C     W#DCST        IFNE      *BLANKS
     C     T2DCST        CABNE     W#DCST        BB020
     C                   ENDIF
      *
      ** If Customer selected, select only records where customer =
      *
     C     W#SCUS        IFNE      *BLANKS
     C     T2CNUM        CABNE     W#SCUS        BB020
     C                   ENDIF
      *
      ** If Dr Ccy selected, select only ccy >= selected
      *
     C     W#DCCY        IFNE      *BLANKS
     C     T2DCCY        CABNE     W#DCCY        BB020
     C                   ENDIF
      *
      ** If Ccy selected, select only ccy = selected
      *
     C     W#SCCY        IFNE      *BLANKS
     C     T2CCY         CABNE     W#CCY         BB020
     C                   ENDIF
      *
      ** If Dr Acod selected, select only Acod >= selected
      *
     C     W#DACD        IFNE      *BLANKS
     C                   MOVE      T2DACD        WWA10
     C     WWA10         CABNE     W#DACD        BB020
     C                   ENDIF
      *
      ** If Acod selected, select only Acod >= selected
      *
     C     W#SACD        IFNE      *BLANKS
     C                   MOVE      T2ACOD        WWA10
     C     WWA10         CABNE     W#SACD        BB020
     C                   ENDIF
      *
      ** If Dr Ac Seq selected, select only Acseq = selected
      *
     C     W#DASQ        IFNE      *BLANKS
     C                   MOVE      T2DASQ        WWA2
     C     WWA2          CABNE     W#DASQ        BB020
     C                   ENDIF
      *
      ** If Ac Seq selected, select only Acseq = selected
      *
     C     W#SASQ        IFNE      *BLANKS
     C                   MOVE      T2ACSQ        WWA2
     C     WWA2          CABNE     W#SASQ        BB020
     C                   ENDIF
      *
      ** If Dr Branch selected, select only Branch >= selected
      *
     C     W#DBRC        IFNE      *BLANKS
     C     T2DBRC        CABNE     W#DBRC        BB020
     C                   ENDIF
      *
      ** If Branch selected, select only Branch >= selected
      *
     C     W#SBRC        IFNE      *BLANKS
     C     T2BRCA        CABNE     W#SBRC        BB020
     C                   ENDIF
      *
      ** Select only records with Tax Paid Y
      *
     C     T2TPAY        CABNE     'Y'           BB020
      *
      ** Move fields
      *
     C                   EXSR      ZZMOVF
      *
      ** Print record
      *
     C     PRTLN1        IFGE      56
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     DETDP1
      *
     C     BB020         TAG
      *
      ** Read next Record
      *
     C                   ENDDO
      *................................................................
     C     BB900         TAG
      *................................................................
      *
      ** Print end of report
      *
     C     PRTLN1        IFGE      56
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   WRITE     ENDDP1
      *
      *================================================================
     CSR   ZZEPRT        ENDSR
      *
      *******************************************************************
      /EJECT
     CSR   ZZMOVF        BEGSR
      *****************************************************************
      *
     C                   CLEAR                   DETDP1
     C                   CLEAR                   OASTER
      *
     C                   MOVEL     T2KEY         OMODUL
      *
      ** Transaction Reference
      *
     C                   SELECT
     C     T2KEY         WHENEQ    'ACCOUNT'
     C                   MOVE      T2BRCA        A2BRCA
     C                   MOVE      T2CNUM        A2CNUM
     C                   MOVE      T2CCY         A2CCY
     C                   MOVE      T2ACOD        A2ACOD
     C                   MOVE      T2ACSQ        A2ACSQ
     C                   MOVEL     A#ACCD        OREFT
     C     T2BRCA        IFNE      T2DBRC
     C     T2CNUM        ORNE      T2DCST
     C     T2CCY         ORNE      T2DCCY
     C     T2ACOD        ORNE      T2DACD
     C     T2ACSQ        ORNE      T2DASQ
     C                   MOVE      '*'           OASTER
     C                   ENDIF
      *
     C     T2KEY         WHENEQ    'LOAN'
     C                   MOVEL     T2LNRF        OREFT
      *
     C     T2KEY         WHENEQ    'DEAL'
     C                   MOVEL     T2DLNO        OREFT
      *
     C     T2KEY         WHENEQ    'SECURITY'
     C                   MOVEL     T2TDRF        OREFT
      *
     C     T2KEY         WHENEQ    'POSSET'
     C                   MOVE      T2PBRC        A2PBRC
     C                   MOVE      T2PSSH        A2PSSH
     C                   MOVE      T2PCPY        A2PCPT
     C                   CALL      'ZDATE2'
     C                   PARM      T2PDUD        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        A2PDUD
     C                   MOVE      T2PEVT        A2PEVT
     C                   MOVEL     A#POSS        OREFT
      *
     C     T2KEY         WHENEQ    'IPAY'
     C     T2KEY         OREQ      'OPAY'
     C                   MOVEL     T2PREF        OREFT
      *
     C     T2KEY         WHENEQ    'CHEQC'
     C     T2KEY         OREQ      'CHEQP'
     C                   MOVEL     T2PREF        A2PREF
     C                   MOVEL     T2CQSQ        A2CQSQ
     C                   MOVEL     A#CHEQ        OREFT
      *
     C     T2KEY         WHENEQ    'FACILITY'
     C                   MOVEL     T2FCNM        A2FCNM
     C                   MOVEL     T2FACT        A2FACT
     C                   MOVEL     T2FCNO        A2FCNO
     C                   MOVEL     A#FACI        OREFT
      *
     C     T2KEY         WHENEQ    'FEE'
     C                   MOVEL     T2FSEQ        A2FSEQ
     C                   CALL      'ZDATE2'
     C                   PARM      T2ORED        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        A2ORED
     C                   MOVEL     A#FEES        OREFT
     C                   ENDSL
      *
      ** Dr account
      *
     C                   MOVE      T2DBRC        A2BRCA
     C                   MOVE      T2DCST        A2CNUM
     C                   MOVE      T2DCCY        A2CCY
     C                   MOVE      T2DACD        A2ACOD
     C                   MOVE      T2DASQ        A2ACSQ
     C                   MOVEL     A#ACCD        OREFD
      *
      ** Value Date
      *
     C                   CALL      'ZDATE2'
     C                   PARM      T2VALD        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        OVALD
      *
      ** Posting Date
      *
     C                   CALL      'ZDATE2'
     C                   PARM      T2PSDT        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        OPSTD
      *
      ** Event ccy
      *
     C                   Movel     T2ECCY        OCCY
      *
      ** Event Amount
      *
     C     OCCY          IFNE      *BLANKS
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@Rtcd
     C                   PARM      '*KEY   '     P@Optn
     C                   PARM      OCCY          @Ccy
     C     SDCURR        PARM      SDCURR        DSFDY
      *
      ** If return with an error (LR seton in called program) then
      ** process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@Rtcd        ORNE      *Blanks
     C                   MOVEL     'AOCURRR0'    W0file
     C                   MOVE      *BLANKS       W0key
      *
     C                   MOVEL     'PARM:'       W0k10
     C                   MOVE      OCCY          W0k10
     C                   MOVEL     '*CALL'       W0key
     C                   MOVE      W0K10         W0key
      *
     C                   Z-ADD     12            W0ernb
     C                   MOVEL     'MEM5003'     W0msgd
     C                   MOVEL     'MIDAS  '     W0msgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVE      A6NBDP        Zdecs
     C                   MOVE      'J'           Zecode
      *
      ** Format amount
      *
     C     T2GROS        IFEQ      0
     C     T2AVBL        ANDNE     0
     C                   Z-ADD     T2AVBL        T2GROS
     C                   ENDIF
      *
     C     T2GROS        IFEQ      0
     C     T2KAMT        ANDNE     0
     C                   Z-ADD     T2KAMT        T2GROS
     C                   ENDIF
      *
     C                   MOVE      T2GROS        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        OGROSS
     C                   ENDIF
      *
      ** Tax Amount in Dr ccy
      *
     C     T2DCCY        IFNE      *BLANKS
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *Blanks       P@Rtcd
     C                   PARM      '*KEY   '     P@Optn
     C                   PARM      T2DCCY        @Ccy
     C     SDCURR        PARM      SDCURR        DSFDY
      *
      ** If return with an error (LR seton in called program) then
      ** process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@Rtcd        ORNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    W0File
     C                   MOVE      *BLANKS       W0Key
      *
     C                   MOVEL     'PARM:'       W0K10
     C                   MOVE      T2DCCY        W0K10
     C                   MOVEL     '*CALL'       W0Key
     C                   MOVE      W0K10         W0Key
      *
     C                   Z-ADD     12            W0Ernb
     C                   MOVEL     'MEM5003'     W0Msgd
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVE      A6NBDP        Zdecs
     C                   MOVE      'J'           Zecode
      *
     C                   MOVE      T2TADC        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        OTAXAM
     C                   ENDIF
      *
      ** Event Type
      *
     C                   SELECT
     C     T2STFB        WHENEQ    'Y'
     C                   MOVEL     'Average'     OEVENT
     C     T2STFC        WHENEQ    'Y'
     C                   MOVEL     'Charge'      OEVENT
     C     T2STFI        WHENEQ    'Y'
     C                   MOVEL     'Interest'    OEVENT
     C     T2STFF        WHENEQ    'Y'
     C                   MOVEL     'Flat'        OEVENT
     C                   ENDSL
      *
      ** Tax Rate
      *
     C     T2STFB        IFEQ      'Y'
     C                   MULT      100           T2TXRB
     C                   MOVE      T2TXRB        ZFLD15
     C                   ELSE
     C                   MULT      100           T2TXRT
     C                   MOVE      T2TXRT        ZFLD15
     C                   ENDIF
     C                   MOVE      8             ZDECS
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        OTAXRT
      *
      ** Account key
      *
     C                   CLEAR                   OKREV
     C     T2REVI        IFEQ      '0'
     C                   MOVE      'N'           OKREV
     C                   ENDIF
     C     T2REVI        IFEQ      '1'
     C                   MOVE      'Y'           OKREV
     C                   ENDIF
      *================================================================
     CSR   ZZEMOV        ENDSR
      *
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      ** Initialisation
      *================================================================
      *
     C                   MOVE      *ALL'-'       TRATT
     C                   MOVE      *BLANK        W0RTN
     C                   MOVEL     *BLANK        W0RSL
     C                   MOVEL     *BLANK        W0RSF
      *
      ** Initialise indicators for re-entry
      *
     C                   MOVE      '0'           *IN
      *
      ** Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
      ** Update screen time
      *
     C                   TIME                    ##TIME
      *
      ** Obtain default message file
      *
     C                   MOVEL     'XXUSRMSG'    ZADFMF
     C                   Z-ADD     10            ##SFPG
      *
      ** Processed Subfile record
      *................................................................
     C                   MOVEL     *BLANK        W0GRP
     C                   Z-ADD     0             Q
     C                   MOVEA     '00'          *IN(77)
      * USER: Initialize program
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          ACT@
      *
      ** Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT
     C                   MOVE      AGMRDT        WUMRDT
     C                   MOVE      AGRDNB        WURDNB
     C                   MOVE      AGSUC         WUSUC
     C                   MOVE      AGDFF         WUDFF
     C                   MOVE      AGMBIN        WUMBIN
     C*
     C** SDBANKPD
     C*
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If return with an error (LR seton in called program) then
      ** process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     8             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Get modules information
      *
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C     MMODDS        PARM      *BLANKS       DSFDY
      *
      ** If return with an error (LR seton in called program) then
      ** process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     9             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     KPOSAB        KLIST
     C                   KFLD                    T#BRCA
     C                   KFLD                    T#CNUM
     C                   KFLD                    T#CCY
     C                   KFLD                    T#ACOD
     C                   KFLD                    T#ACSQ
     C                   KFLD                    T#DATE
      *
     C     KPAB          KLIST
     C                   KFLD                    T#BRCA
     C                   KFLD                    T#CNUM
     C                   KFLD                    T#CCY
     C                   KFLD                    T#ACOD
     C                   KFLD                    T#ACSQ
      *
      ** Position on file SDSTMDLB - SDSTMDLC
      *
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
      *
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
      *
     C                   MOVEL     W#CNUM        T#CNUM
     C                   MOVEL     W#CCY         T#CCY
     C                   MOVEL     W#ACOD        T#ACOD
     C                   MOVEL     W#ACSQ        T#ACSQ
     C                   MOVEL     W#BRCA        T#BRCA
     C                   MOVEL     W#FCNM        T#FCNM
     C                   MOVEL     W#FACT        T#FACT
     C                   MOVEL     W#FCNO        T#FCNO
     C                   MOVEL     W#FSEQ        T#FSEQ
     C                   MOVEL     W#ORED        T#ORED
     C                   MOVEL     W#TDRF        T#TDRF
     C                   MOVEL     W#PREF        T#PREF
     C                   MOVEL     W#CQSQ        T#CQSQ
     C                   MOVEL     W#DLNO        T#DLNO
     C                   MOVEL     W#LNRF        T#LNRF
     C                   MOVEL     W#PBRC        T#PBRC
     C                   MOVEL     W#PSSH        T#PSSH
     C                   MOVEL     W#PCPT        T#PCPY
     C                   MOVEL     W#PDUD        T#PDUD
     C                   MOVEL     W#PEVT        T#PEVT
     C                   CLEAR                   T#ASEQ
     C                   CLEAR                   T#TYPE
     C     W#FILE        IFEQ      'SDSTMDL7'
     C     W#FILE        OREQ      'SDSTMDL9'
     C     W#FILE        OREQ      'SDSTMDLB'
     C                   MOVE      W#STDT        T#DATE
     C                   MOVE      W#PFRM        T#DAT2
     C                   ELSE
     C                   MOVE      W#PFRM        T#DATE
     C                   MOVE      W#STDT        T#DAT2
     C                   ENDIF
      *
      ** Translate search mask for text field
      *
     C                   MOVEL     'QSYST'       WQB10X
     C                   MOVE      'RNTBL'       WQB10X
      *
     C                   SETOFF                                         8782
      *
      ** Print Header
      *
      ** Check if module selected
      *
     C                   MOVE      *BLANKS       O#MODU
     C     W#MODU        IFNE      *BLANKS
     C                   SELECT
     C     W#MODU        WHENEQ    'ACC'
     C                   MOVEL     'ACCOUNT'     O#MODU
     C     W#MODU        WHENEQ    'LOA'
     C                   MOVEL     'LOAN'        O#MODU
     C     W#MODU        WHENEQ    'DEA'
     C                   MOVEL     'DEAL'        O#MODU
     C     W#MODU        WHENEQ    'SEC'
     C                   MOVEL     'SECURITY'    O#MODU
     C     W#MODU        WHENEQ    'POS'
     C                   MOVEL     'POSSET'      O#MODU
     C     W#MODU        WHENEQ    'FEE'
     C                   MOVEL     'FEE'         O#MODU
     C     W#MODU        WHENEQ    'FAC'
     C                   MOVEL     'FACILITY'    O#MODU
     C     W#MODU        WHENEQ    'PAY'
     C                   MOVEL     'I/O PAYMENT' O#MODU
     C     W#MODU        WHENEQ    'CHE'
     C                   MOVEL     'I/O CHEQUE'  O#MODU
     C                   ENDSL
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       OSELE1
     C                   MOVE      *BLANKS       OSELE2
     C                   MOVE      W#BRCA        A2BRCA
     C                   MOVE      W#CNUM        A2CNUM
     C                   MOVE      W#ACOD        A2ACOD
     C                   MOVE      W#CCY         A2CCY
     C                   MOVE      W#ACSQ        A2ACSQ
     C                   MOVEL     W#ACSQ        A2ACSQ
      *
     C     W#SELE        IFNE      *BLANKS
     C                   SELECT
     C     W#SELE        WHENEQ    '1'
     C                   MOVEL     'Dr Account:' OSELE1
     C                   MOVEL     A#ACCD        OSELE2
      *
     C     W#SELE        WHENEQ    '2'
     C                   MOVEL     'Account:  '  OSELE1
     C                   MOVEL     A#ACCD        OSELE2
      *
     C     W#SELE        WHENEQ    '3'
     C                   MOVEL     'Deal:'       OSELE1
     C                   MOVEL     W#DLNO        OSELE2
      *
     C     W#SELE        WHENEQ    '4'
     C                   MOVEL     'Loan:'       OSELE1
     C                   MOVEL     W#LNRF        OSELE2
      *
     C     W#SELE        WHENEQ    '5'
     C                   MOVEL     'Trade:'      OSELE1
     C                   MOVEL     W#TDRF        OSELE2
      *
     C     W#SELE        WHENEQ    '6'
     C                   MOVEL     'Fee:'        OSELE1
     C                   MOVEL     W#FSEQ        A2FSEQ
     C                   CALL      'ZDATE2'
     C                   PARM      W#ORED        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        A2ORED
     C                   MOVEL     A#FEES        OSELE2
      *
     C     W#SELE        WHENEQ    '7'
     C                   MOVEL     'Facility:'   OSELE1
     C                   MOVEL     W#FCNM        A2FCNM
     C                   MOVEL     W#FACT        A2FACT
     C                   MOVEL     W#FCNO        A2FCNO
     C                   MOVEL     A#FACI        OSELE2
      *
     C     W#SELE        WHENEQ    '8'
     C     W#CQSQ        IFNE      *BLANKS
     C                   MOVEL     'Cheque:'     OSELE1
     C                   ELSE
     C                   MOVEL     'Payment:'    OSELE1
     C                   ENDIF
     C                   MOVEL     W#PREF        A2PREF
     C                   MOVEL     W#CQSQ        A2CQSQ
     C                   MOVEL     A#CHEQ        OSELE2
      *
     C     W#SELE        WHENEQ    '9'
     C                   MOVEL     'Pos Set:'    OSELE1
     C                   MOVEL     W#PBRC        A2PBRC
     C                   MOVEL     W#PSSH        A2PSSH
     C                   MOVEL     W#PCPT        A2PCPT
     C                   CALL      'ZDATE2'
     C                   PARM      W#PDUD        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        A2PDUD
     C                   MOVEL     W#PEVT        A2PEVT
     C                   MOVEL     A#POSS        OSELE2
     C                   ENDSL
     C                   ENDIF
      *
      ** Convert Value/Posting Dates From/To
      *
     C                   CLEAR                   O#VDATF
     C                   CLEAR                   O#VDATT
     C                   CLEAR                   O#PDATF
     C                   CLEAR                   O#PDATT
      *
     C     W#STDT        IFNE      0
     C                   CALL      'ZDATE2'
     C                   PARM      W#STDT        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        O#VDATF
     C                   ENDIF
      *
     C     W#EDAT        IFNE      0
     C                   CALL      'ZDATE2'
     C                   PARM      W#EDAT        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        O#VDATT
     C                   ENDIF
      *
     C     W#PFRM        IFNE      0
     C                   CALL      'ZDATE2'
     C                   PARM      W#PFRM        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        O#PDATF
     C                   ENDIF
      *
     C     W#PTO         IFNE      0
     C                   CALL      'ZDATE2'
     C                   PARM      W#PTO         ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        O#PDATT
     C                   ENDIF
      *
      ** Print Header
      *
     C                   WRITE     HEADP1
      *
      ** Ensure the spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUM         ZSNUM
      *
      ** Call ZSFILE for GL008172P1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO
     C                   PARM      *BLANKS       ENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
      *
      ** If error in ZSFILE, exit via *PSSR
      *
     C     ZSERR         IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Position on File
      *
     C     W#FILE        IFEQ      'SDSTMDL7'
     C     KPOSAB        SETLL     @STMDVA
     C                   ENDIF
      *
     C     W#FILE        IFEQ      'SDSTMDL8'
     C     KPOSAB        SETLL     @STMDVB
     C                   ENDIF
      *
     C     W#FILE        IFEQ      'SDSTMDL9'
     C     T#DATE        SETLL     @STMDVC
     C                   ENDIF
      *
     C     W#FILE        IFEQ      'SDSTMDLA'
     C     T#DATE        SETLL     @STMDVD
     C                   ENDIF
      *
     C     W#FILE        IFEQ      'SDSTMDLB'
     C     KPOSEF        SETLL     @STMDVE
     C                   ENDIF
      *
     C     W#FILE        IFEQ      'SDSTMDLC'
     C     KPOSEF        SETLL     @STMDVF
     C                   ENDIF
      *
      *================================================================
     CSR   ZZEXIT        ENDSR
      *================================================================
     CSR   FMTAMT        BEGSR
      *================================================================
      * CALC: Format Amount fields
      *================================================================
      *
     C                   MOVE      *BLANKS       ZOUT21
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZOUT21
     CSR   FMTXIT        ENDSR
      *================================================================
     C*
     C* PSSR Processing
     C*
     C     *PSSR         BEGSR
     C*
     C                   DUMP
     C*
     C** If second time through, halt:
     C*
     C     @@PSSR        IFNE      *BLANK
     C                   SETON                                        H1  LR
     C                   RETURN
     C                   ENDIF
     C*
     C** Flag routine as started; define action code:
     C*
     C                   MOVE      'Y'           @@PSSR
     C                   MOVE      W0ACT         W0ACT
     C*
     C** Any other mode or type of error.
     C** Set LDA values and format message for MOPERQ:
     C*
     C                   MOVE      ##PGM         ERPGM
     C                   MOVE      ##RTVN        ERFILE
     C     ##MSID        CAT(P)    ##SQNO        ERKEY
     C                   Z-ADD     998           ERERNB
     C                   MOVEL     ##MSWK        ERNARR
     C*
     C** Move data to the LDA data area:
     C*
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
     C*
     C** Provide a fuller report:
     C*
     C                   MOVEA     @STK          #@STK
     C                   SETON                                        U7U8LR
     C                   MOVE      '*ERROR*'     W0RTN
     C                   RETURN
     C*
     C                   ENDSR
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
      *
      ** Dump program
      *
     C                   DUMP
      *
      ** If called again seton LR and return
      *
     C     @@FILE        IFNE      *BLANKS
     C                   MOVEL     '1'           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   MOVEL     'Y'           @@FILE
      *
      ** Send message to MOPERQ
      *
     C                   MOVEL     *BLANKS       ERDTA
     C                   MOVEL     ##PGM         ERPGM
      *
     C     Q             IFGT      1
     C     Q             ANDLT     101
     C                   MOVEL     @STK(Q)       ERSTK
     C                   ELSE
     C                   MOVEL     '*Nostkin'    ERSTK
     C                   ENDIF
      *
     C                   MOVEL     ##ERST        ERKEY
     C                   Z-ADD     999           ERERNB
     C                   MOVEL     ##ERFL        ERFILE
     C                   MOVEL     W0PREF        ERPREF
      *
      ** Get message for sending and place in msg field
      *
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      'MEM5002'     #MSGID
     C                   PARM      'MIDAS   '    #MSGF
     C                   PARM      *BLANKS       #MSGTX
      *
     C                   MOVEL     #MSGTX        ERNARR
      *
      ** Send message
      *
     C                   CALL      'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID
     C                   PARM      'MIDAS  '     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      ERDTA         #MSGDT
     C                   PARM      '*PRV'        #MSGR
     C                   PARM      '*'           #PRGM
     C                   PARM      'MOPERQ '     #MSGQ
     C                   PARM      '*INFO  '     #MSGT
      *
      ** Fill LDA with error data
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
      *
      ** Close down program
      *
     C                   SETON                                        U7U8LR
     C                   MOVEL     '*ERROR*'     W0RTN
     C*
     C** Provide a fuller report:
     C*
     C                   MOVEA     @STK          #@STK
      *
     C                   RETURN
      *
     CSR   EXFILE        ENDSR
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
      *
      ** Define work variables
      *
      *
     C                   Z-ADD     Q             Q
      *
      ** Dump program
      *
     C                   DUMP
      *
      ** Set up the details of the message to be sent to MOPERQ
      *
     C                   MOVEL     *BLANKS       ERDTA
     C                   MOVEL     ##PGM         ERPGM
      *
     C     Q             IFGT      1
     C     Q             ANDLT     101
     C                   MOVEL     @STK(Q)       ERSTK
     C                   ELSE
     C                   MOVEL     '*Nostkin'    ERSTK
     C                   ENDIF
      *
     C                   MOVEL     W0KEY         ERKEY
     C                   Z-ADD     W0ERNB        ERERNB
     C                   MOVEL     W0FILE        ERFILE
     C                   MOVEL     W0PREF        ERPREF
      *
      ** Get message for message code. If the msg code or the msg file
      ** have not been set up then use the defaults.
      *
     C     W0MSGD        IFEQ      *BLANKS
     C                   MOVEL     'MEM5001'     C#FMSG
     C                   ELSE
     C                   MOVEL     W0MSGD        C#FMSG
     C                   ENDIF
      *
     C     W0MSGF        IFEQ      *BLANKS
     C                   MOVEL     'MIDAS   '    C#FMSF
     C                   ELSE
     C                   MOVEL     W0MSGF        C#FMSF
     C                   ENDIF
      *
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      C#FMSG        #MSGID
     C                   PARM      C#FMSF        #MSGF
     C                   PARM      *BLANKS       #MSGTX
      *
     C                   MOVEL     #MSGTX        ERNARR
      *
      ** Send message
      *
     C                   CALL      'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID
     C                   PARM      'MIDAS  '     #MSGF
     C                   PARM      *BLANKS       #MSGFL
     C                   PARM      ERDTA         #MSGDT
     C                   PARM      '*PRV '       #MSGR
     C                   PARM      '*'           #PRGM
     C                   PARM      'MOPERQ '     #MSGQ
     C                   PARM      '*INFO  '     #MSGT
      *
      ** Fill LDA with error data
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
      *
      ** Close down program
      *
     C                   SETON                                        U7U8LR
     C                   MOVEL     '*ERROR*'     W0RTN
     C*
     C** Provide a fuller report:
     C*
     C                   MOVEA     @STK          #@STK
     C** End the program:
     C                   RETURN
      *
     CSR   EXERR         ENDSR
      *****************************************************************
      * End of /COPY SRERRC                                           *
      *****************************************************************
**  CPY@
(C) Copyright Misys International Banking Systems Ltd. 2010
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
