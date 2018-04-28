     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Movements Report - Retail')         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL008162  - RE Stamp Tax Movements Report                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
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
      ** Stamp Tax Summary File - Retail
     FGLACNTL3  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      ** Stamp Tax Details File
     FSDSTMDL4  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
      *
      ** Stamp Tax Details File
     FSDSTMDL5  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
      *
      ** Print File
     FGL008162P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(SRFILE)
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array of QCMDEXC commands
     D EDT             S              1    DIM(80)
      *
      ** Array of QCMDEXC command to edit
     D @STK            S             10    DIM(100)
     D @REC            S              3  0 DIM(100)
      *
      ** Subroutine stack
     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)
      *
      ** Program data structure
     D LDA           E DS           256    EXTNAME(LDA)
      *
      *  Local data area for database error details
      *  *LOCK IN LDA immediately before and OUT LDA immediately
      *  after each database error handling.
      *
      *  Rename filler field on LDA
      *  CRT001 changes mean that there is now a field ZZ019 on APOSTPD
      *  and associated PFs, which are held in a DS in some CG programs.
      *  The same field in two DS causes those programs to fail to
      *  compile - hence this version of ZZ019 is renamed.
     D  DBZZ19       E                     EXTFLD(ZZ019)
     D ERDTA         E DS                  EXTNAME(CGERDTA)
     D M#DTA           DS           256
      *
      ** Message Data - Action field
     D  #MSGTX                 1     80
     D  ##MSGD                81    256
      *
      /EJECT
      *
     D DTDTA           DS
     D DT12                    1      2  0
     D DT34                    3      4  0
     D DT56                    5      6  0
      *
     D                 DS
     D TYAVGB                  1     21    INZ('  Dr Average Balance ')
     D TYINTR                 22     42    INZ('  Dr Interest Amount ')
      *
     D                 DS
     D SOACCN                  1      7    INZ('Account')
     D SODATE                  8     14    INZ('Date   ')
      *
     D A#ACCD          DS
     D A2CNUM                  1      6
     D                         7      7    INZ('-')
     D A2CCY                   8     10
     D                        11     11    INZ('-')
     D A2ACOD                 12     21  0
     D                        22     22    INZ('-')
     D A2ACSQ                 23     24  0
     D                        25     25    INZ('-')
     D A2BRCA                 26     28
      *
     D                 DS
     D ZOUT15                  1     25
     D ZOUT0                   1     21
     D ZOUT1                   2     23
     D ZOUT2                   3     24
     D ZOUT3                   5     25
      *
     D SPOOL1          DS
     D SFILE1                 83     92
     D SFNUM                 123    124B 0
     D FLLN1                 188    189B 0
     D PRTLN1                367    368B 0
      *
     D JBDTTM          DS
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      *
     D ##DATE          DS
     D  ##DD                   1      2
     D  ##MM                   3      4
     D  ##YY                   5      6
      *
     D #DATE           DS
     D  #MM                    1      2
     D  #CC                    3      4
     D  #YY                    5      6
      *
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
     D W#EVTP                112    113
     D W#DACC                114    141
     D W#PSDT                142    148
     D W#VLDT                149    155
     D W#GROS                156    176
     D W#TAXE                177    197
     D W#CCYE                198    200
     D W#TAXD                201    221
     D W#CCYD                222    224
     D W#TAXS                225    245
     D W#CCYS                246    248
     D W#TAXA                249    269
     D W#TAXI                270    290
     D W#TTYP                291    291
     D W#PRTF                292    292
     D W#TXRT                293    313
     D W#STDT                314    318  0
     D W#EDAT                319    323  0
     D W#SDT                 324    329  0
     D W#EDT                 330    335  0
     D W#OPNB                336    356
     D W#CLOB                357    377
     D W#STP                 378    384
     D W#ENP                 385    391
     D W#REPO          DS
     D W#PRT                   1      1
     D W#TTY                   2      2
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFAC2       E                     EXTFLD(QQDFAC)
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
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
      ** KEY: Direct Debit mandates     Retrieval index
      ** I : MAP Structure Type
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
      *
     D DSMTR           DS
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     D W0DATA          DS           256
     D  B#BRCA                 1      3
     D  O#ACTD                 4      4
     D  O#CPGM                 5     14
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W#DATA
      *
      ** Initialize
      *
     C                   EXSR      ZZINIT
      *
      ** Read/Print Movements
      **  List of Average/Movements requested
      *
     C     W#REPO        CASEQ     'AA'          BBACAV
     C     W#REPO        CASEQ     'AI'          BBACIN
     C                   CAS                     BBMOVI
     C                   ENDCS
      *
     C                   SETON                                        LR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** BBACAV - List of Tax on Average Movements requested         *
      *****************************************************************
     CSR   BBACAV        BEGSR
      *
      ** Print Header
      *
     C                   WRITE     HEADP1
      *
      ** Ensure the spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUM         ZSNUM             6 0
      *
      ** Call ZSFILE for GL008162P1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO             5
     C                   PARM      *BLANKS       ENTY              3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      ** If error in ZSFILE, exit via *PSSR
      *
     C     ZSERR         IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN82         DOWEQ     '0'
      *
      ** Move numeric fields to alphanumeric for end of file test
      *
     C                   MOVE      T2ACOD        WAACOD           10
     C                   MOVE      T2CNUM        WACNUM            6
     C                   MOVE      T2ACSQ        WAACSQ            2
      *
      ** Check if End of file reached
      *
     C     W#CNUM        IFNE      WACNUM
     C     W#CCY         ORNE      T2CCY
     C     W#ACOD        ORNE      WAACOD
     C     W#ACSQ        ORNE      WAACSQ
     C     W#BRCA        ORNE      T2BRCA
     C     W#EDAT        ORNE      0
     C     W#EDAT        ANDLT     T2VALD
     C                   SETON                                        82
     C                   ENDIF
      * End of file
     C     *IN82         CABEQ     *ON           BB900
      *
      ** If Date not blank, then select date >= selecte
      *
     C     W#STDT        IFNE      0
     C     T2VALD        CABLT     W#STDT        BB020
     C                   ENDIF
      *
      ** Select only Average records and Tax Paid Y
      *
     C     T2STFB        CABNE     'Y'           BB020
     C     T2TPAY        CABNE     'Y'           BB020
      *
     C                   EXSR      CCMOVF
     C     PRTLN1        IFGE      58
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     DETDP1
      *
     C     BB020         TAG
      *
     C                   READ      @STMDV4                                82
     C                   ENDDO
     C     BB900         TAG
      *
      ** Print end of report
      *
     C     PRTLN1        IFGE      56
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     ENDDP1
      *
     CSR   BBEXIT        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** BBACIN - List of Tax on Interest Movements requested         *
      *****************************************************************
     CSR   BBACIN        BEGSR
      *
      ** Print Headaer
      *
     C                   WRITE     HEADP2
      *
     C     *IN82         DOWEQ     '0'
      *
      ** Move numeric fields to alphanumeric for end of file test
      *
     C                   MOVE      T2ACOD        WAACOD
     C                   MOVE      T2CNUM        WACNUM
     C                   MOVE      T2ACSQ        WAACSQ
      *
      ** Check if End of file reached
      *
     C     W#CNUM        IFNE      WACNUM
     C     W#CCY         ORNE      T2CCY
     C     W#ACOD        ORNE      WAACOD
     C     W#ACSQ        ORNE      WAACSQ
     C     W#BRCA        ORNE      T2BRCA
     C     W#EDAT        ORNE      0
     C     W#EDAT        ANDLT     T2VALD
     C                   SETON                                        82
     C                   ENDIF
      * End of file
     C     *IN82         CABEQ     *ON           BB901
      *
      ** If Date not blank, then select date >= selecte
      *
     C     W#STDT        IFNE      0
     C     T2VALD        CABLT     W#STDT        BB021
     C                   ENDIF
      *
      ** Select only Interest Tax record and Tax Paid Y
      *
     C     T2STFI        CABNE     'Y'           BB021
     C     T2TPAY        CABNE     'Y'           BB021
      *
     C                   EXSR      CCMOVF
     C     PRTLN1        IFGE      58
     C                   WRITE     HEADP2
     C                   ENDIF
     C                   WRITE     DETDP2
      *
     C     BB021         TAG
      *
      ** Increment scan check count
      *
     C                   READ      @STMDV5                                82
      *
     C                   ENDDO
     C     BB901         TAG
      *
      ** Print end of report
      *
     C     PRTLN1        IFGE      56
     C                   WRITE     HEADP2
     C                   ENDIF
     C                   WRITE     ENDDP1
      *
      *================================================================
     CSR   BBAIEX        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** BBMOVI - Print single movement                               *
      *****************************************************************
     CSR   BBMOVI        BEGSR
      *
     C                   MOVE      W#PSDT        OPST3
     C                   MOVE      W#VLDT        OVAL3
     C                   MOVE      W#VLDT        OVAL3
     C                   MOVE      W#OPNB        OOPNCL
     C                   MOVE      W#CLOB        OCLOBL
     C                   MOVE      W#GROS        OGROS3
     C                   MOVE      W#TAXE        OTAXE3
     C                   MOVE      W#CCYE        OCCY3
     C                   MOVE      W#TAXD        OTAXD3
     C                   MOVE      W#CCYD        OCCD3
     C                   MOVE      W#TAXS        OTAXS3
     C                   MOVE      W#CCYS        OCCS3
     C                   MOVE      W#TXRT        OTXRT3
     C                   MOVE      W#STP         OSTD3
     C                   MOVE      W#ENP         OCLO3
      *
      ** Print record
      *
     C     W#TTYP        IFEQ      'A'
     C                   SETON                                        20
     C                   ELSE
     C                   SETOFF                                       20
     C                   ENDIF
      *
     C                   WRITE     HEADP3
      *
     CSR                 ENDSR
      *
      *******************************************************************
      /EJECT
      *******************************************************************
      ** CCMOVF - Movement details
      *******************************************************************
     CSR   CCMOVF        BEGSR
      *
     C                   CLEAR                   DETDP1
     C                   CLEAR                   DETDP2
      *
      ** Value Date
      *
     C                   CALL      'ZDATE2'
     C                   PARM      T2VALD        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   MOVE      ZDATE         ##DATE
     C                   MOVE      ##MM          #MM
     C                   MOVE      '20'          #CC
     C                   MOVE      ##YY          #YY
     C                   MOVEL     ZADATE        OVALD
      *
      ** Posting Date
      *
     C                   CALL      'ZDATE2'
     C                   PARM      T2PSDT        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
      *
     C                   MOVE      ZDATE         ##DATE
     C                   MOVE      ##MM          #MM
     C                   MOVE      '20'          #CC
     C                   MOVE      ##YY          #YY
     C                   MOVEL     ZADATE        OPSTD
     C                   SETOFF                                       20
      *
      ** Opening Balance
      *
     C     W#TTYP        IFEQ      'A'
     C                   SETON                                        20
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *blanks       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      W#CCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSFDY
      *
      ** If return with an error (LR seton in called program) then
      ** process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    W0FILE
     C                   MOVE      *BLANKS       W0KEY
     C                   MOVEL     'PARM:'       W0K10            10
     C                   MOVE      W#CCY         W0K10
     C                   MOVEL     '*CALL'       W0KEY
     C                   MOVE      W0K10         W0KEY
     C                   Z-ADD     12            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   exsr      SRERR
     C                   ENDIF
      *
     C                   MOVE      A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
      *
     C                   MOVE      T2STBL        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        OOPNBL
      *
      ** Closing Balance
      *
     C                   MOVE      T2ENBL        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        OCLOBL
     C                   ENDIF
      *
      ** Gross Amount
      *
     C     W#TTYP        IFEQ      'A'
     C                   MOVE      T2AVBL        ZFLD15
     C                   ELSE
     C                   MOVE      T2GROS        ZFLD15
     C                   ENDIF
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        OGROSS
      *
      ** Tax Amount
      *
     C                   MOVE      T2TATC        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        OTAXAM
     C                   MOVE      T2ECCY        OCCY
      *
      ** Tax Rate
      *
     C     W#TTYP        IFEQ      'A'
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
      ** Move fields to DETPAI record
      *
     C                   MOVE      OTAXRT        OTAXRI
     C                   MOVE      OCCY          OCCYI
     C                   MOVE      OGROSS        OGROSI
     C                   MOVE      OTAXAM        OTAXAI
     C                   MOVEL     OPSTD         OPSTI
     C                   MOVEL     OVALD         OVALI
      *
     CSR   CCEXIT        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** ZZINIT - Initialisation routine
      *****************************************************************
     CSR   ZZINIT        BEGSR
      *
     C                   MOVE      W#PRTF        W#PRT
     C                   MOVE      W#TTYP        W#TTY
     C                   MOVE      *ALL'-'       TRATT           132
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVE      '0'           *IN
      *
      ** Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
      ** Update screen time
      *
     C                   TIME                    ##TME             6 0
      *
      ** Obtain default message file
      *
     C                   MOVEL     'XXUSRMSG'    ZADFMF           10
     C                   Z-ADD     10            ##SFPG            3 0
      * Scan limit / subfile pages / processed subfile record
     C                   Z-ADD     500           W0SLM             5 0
     C                   Z-ADD     1             W0SPG             3 0
     C                   Z-ADD     0             W0RR0             4 0
     C                   MOVEL     *BLANK        W0GRP             1
     C                   Z-ADD     0             Q                 5 0
     C                   MOVEA     '00'          *IN(77)
     C                   MOVEA     CPY@          ACT@             80
      *
      ** Get Rundate - Rundate
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7
     C                   MOVE      AGMRDT        WUMRDT            7
     C                   MOVE      AGRDNB        WURDNB            5 0
     C                   MOVE      AGSUC         WUSUC             1
     C                   MOVE      AGDFF         WUDFF             1
     C                   MOVE      AGMBIN        WUMBIN            1
      *
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
      ** Setup key
      *
     C                   MOVEL(P)  'ACCOUNT'     T#KEY
     C                   MOVEL     W#CNUM        T#CNUM
     C                   MOVEL     W#CCY         T#CCY
     C                   MOVEL     W#ACOD        T#ACOD
     C                   MOVEL     W#ACSQ        T#ACSQ
     C                   MOVEL     W#BRCA        T#BRCA
     C                   Z-ADD     W#STDT        T#CDTE
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C                   Z-ADD     0             ##RROK            5 0
     C                   SETOFF                                         8782
      *
      ** Open file SDSTMDL4 for Average
      *
     C     W#TTYP        IFEQ      'A'
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'SDSTMDL4'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     10            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   OPEN      SDSTMDL4
     C                   MOVEL     'Y'           FIL004            1
     C     KPOS          SETLL     @STMDV4
     C                   READ      @STMDV4                              8782
     C                   ENDIF
      *
      ** Open file SDSTMDL5 for Interest
      *
     C     W#TTYP        IFEQ      'I'
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'SDSTMDL5'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     10            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   OPEN      SDSTMDL5
     C                   MOVEL     'Y'           FIL005            1
     C     KPOS          SETLL     @STMDV5
     C                   READ      @STMDV5                              8782
     C                   ENDIF
      *
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
     C     *LIKE         DEFINE    T2PSSH        T#PSSH
     C     *LIKE         DEFINE    T2PCPY        T#PCPY
     C     *LIKE         DEFINE    T2PDUD        T#PDUD
     C     *LIKE         DEFINE    T2PEVT        T#PEVT
     C     *LIKE         DEFINE    T2RCTP        T#RCTP
     C     *LIKE         DEFINE    T2CDTE        T#CDTE
     C     *LIKE         DEFINE    T2ASEQ        T#ASEQ
      *
     C     *LIKE         DEFINE    F1BRCA        #2BRCA
     C     *LIKE         DEFINE    F1CNUM        #2CNUM
     C     *LIKE         DEFINE    F1CCY         #2CCY
     C     *LIKE         DEFINE    F1ACOD        #2ACOD
     C     *LIKE         DEFINE    F1ACSQ        #2ACSQ
      *
      ** USER: Initialize subfile control
      ** Position DBF file
      *
     C     KPOS          KLIST
     C                   KFLD                    T#KEY
     C                   KFLD                    T#TYPE
     C                   KFLD                    T#LNRF
     C                   KFLD                    T#FCNM
     C                   KFLD                    T#FACT
     C                   KFLD                    T#FCNO
     C                   KFLD                    T#FSEQ
     C                   KFLD                    T#ORED
     C                   KFLD                    T#DLNO
     C                   KFLD                    T#TDRF
     C                   KFLD                    T#BRCA
     C                   KFLD                    T#CNUM
     C                   KFLD                    T#CCY
     C                   KFLD                    T#ACOD
     C                   KFLD                    T#ACSQ
     C                   KFLD                    T#PREF
     C                   KFLD                    T#CQSQ
     C                   KFLD                    T#PBRC
     C                   KFLD                    T#PSSH
     C                   KFLD                    T#PCPY
     C                   KFLD                    T#PDUD
     C                   KFLD                    T#PEVT
     C                   KFLD                    T#RCTP
     C                   KFLD                    T#CDTE
     C                   KFLD                    T#ASEQ
      *
      ** Retrieve Header File
      *
     C     KACCT         KLIST
     C                   KFLD                    #2CNUM
     C                   KFLD                    #2CCY
     C                   KFLD                    #2ACOD
     C                   KFLD                    #2ACSQ
     C                   KFLD                    #2BRCA
      *
     C                   MOVEL     W#BRCA        #2BRCA
     C                   MOVEL     W#CNUM        #2CNUM
     C                   MOVEL     W#CCY         #2CCY
     C                   MOVEL     W#ACOD        #2ACOD
     C                   MOVEL     W#ACSQ        #2ACSQ
      *
     C     KACCT         CHAIN     GLACNTL3                           90
      *
     C                   MOVE      F1DBRC        WDBRCA
     C                   MOVE      F1DCST        WDCUST
     C                   MOVE      F1DCCY        WDCCY
     C                   MOVE      F1DACD        WDACOD
     C                   MOVE      F1DASC        WDACSQ
     C                   MOVE      W#SDT         STDAT
     C                   MOVE      W#EDT         ENDAT
     C                   MOVE      W#CNUM        W#CUST
      *
      ** Print Header
      *
     C     W#TTYP        IFEQ      'A'
     C                   SETON                                        20
     C                   ENDIF
      *
      ** Move fields for 'Interest' Header
      *
     C                   MOVE      BJURPT        BJURPI
     C                   MOVE      BJMRDT        BJMRDI
     C                   MOVE      TITLE         TITLEI
     C                   MOVE      W#BRCA        W#BRCI
     C                   MOVE      W#CUST        W#CUSI
     C                   MOVE      W#ACOD        W#ACOI
     C                   MOVE      W#CCY         W#CCYI
     C                   MOVE      W#ACSQ        W#ACSI
     C                   MOVE      WDBRCA        WDBRCI
     C                   MOVE      WDCUST        WDCUSI
     C                   MOVE      WDCCY         WDCCYI
     C                   MOVE      WDACOD        WDACOI
     C                   MOVE      WDACSQ        WDACSI
     C                   MOVE      STDAT         STDATI
     C                   MOVE      ENDAT         ENDATI
     C                   MOVE      TRATT         TRATTI
      *
      ** Move fields for 'Single Movement' Header
      *
     C                   MOVE      BJURPT        BJURP3
     C                   MOVE      BJMRDT        BJMRD3
     C                   MOVE      TITLE         TITLE3
     C                   MOVE      W#BRCA        W#BRC3
     C                   MOVE      W#CUST        W#CUS3
     C                   MOVE      W#ACOD        W#ACO3
     C                   MOVE      W#CCY         W#CCY3
     C                   MOVE      W#ACSQ        W#ACS3
     C                   MOVE      WDBRCA        WDBRC3
     C                   MOVE      WDCUST        WDCUS3
     C                   MOVE      WDCCY         WDCCY3
     C                   MOVE      WDACOD        WDACO3
     C                   MOVE      WDACSQ        WDACS3
      *
      ** Retrieve Customer details
      *
     C                   MOVEL     W#CNUM        @CNUM            10
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    @CNUM            10
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   MOVE      BBCRNM        BBCRN3
      *
     CSR   ZZEXIT        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** FMTAMT - CALC: Format Amount fields                          *
      *****************************************************************
     CSR   FMTAMT        BEGSR
      *
     C                   MOVE      *BLANKS       ZOUT21           21
     C                   Call      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT21
      *
     CSR   FMTXIT        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** PSSR - Error processing                                      *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
      ** If second time through, halt:
      *
     C     @@PSSR        IFNE      *BLANK
     C                   SETON                                        H1  LR
     C                   RETURN
     C                   ENDIF
      *
     C                   MOVE      'Y'           @@PSSR            1
     C                   MOVE      W0ACT         W0ACT             8
     C                   MOVE      ##PGM         ERPGM
     C                   MOVE      ##RTVN        ERFILE
     C     ##MSID        CAT(P)    ##SQNO        ERKEY
     C                   Z-ADD     998           ERERNB
     C                   MOVEL     ##MSWK        ERNARR
      *
      ** Move data to the LDA data area:
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
      *
      ** Provide a fuller report
      *
     C                   MOVEA     @STK          #@STK           100
      *
      ** End the program
      *
     C                   SETON                                        U7U8LR
     C                   MOVE      '*ERROR*'     W0RTN             7
     C                   RETURN
      *
     C                   ENDSR
     ******************************************************************
      /EJECT
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
     C                   MOVEL     'Y'           @@FILE            1
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
     C                   PARM      'MEM5000'     #MSGID            7
     C                   PARM      'MIDAS  '     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      ERDTA         #MSGDT          256
     C                   PARM      '*PRV'        #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MOPERQ '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
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
     C                   MOVEL     '*ERROR*'     W0RTN             7
      *
      ** Provide a fuller report
      *
     C                   MOVEA     @STK          #@STK           100
      *
     C                   RETURN
      *
     CSR   EXFILE        ENDSR
      *****************************************************************
      /EJECT
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
     C     *LIKE         DEFINE    T2AVBL        #WGROS
     C     *LIKE         DEFINE    ERKEY         W0KEY
     C     *LIKE         DEFINE    ERERNB        W0ERNB
     C     *LIKE         DEFINE    ERFILE        W0FILE
     C     *LIKE         DEFINE    ERPREF        W0PREF
     C     *LIKE         DEFINE    #MSGID        W0MSGD
     C     *LIKE         DEFINE    #MSGF         W0MSGF
     C                   Z-ADD     Q             Q                 5 0
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
     C                   MOVEL     'MEM5001'     C#FMSG            7
     C                   ELSE
     C                   MOVEL     W0MSGD        C#FMSG
     C                   ENDIF
      *
     C     W0MSGF        IFEQ      *BLANKS
     C                   MOVEL     'MIDAS   '    C#FMSF           10
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
     C                   PARM      'MEM5000'     #MSGID            7
     C                   PARM      'MIDAS  '     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      ERDTA         #MSGDT          256
     C                   PARM      '*PRV '       #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MOPERQ '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
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
     C                   MOVEL     '*ERROR*'     W0RTN             7
      *
      ** Provide a fuller report
      *
     C                   MOVEA     @STK          #@STK           100
      *
      ** End the program
      *
     C                   RETURN
      *
     CSR   EXERR         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2010
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
