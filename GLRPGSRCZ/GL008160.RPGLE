     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Movements Enquiry - Retail')        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL008160 - Stamp Tax Movements Enquiry - Retail              *
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
     FGL008160DFCF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
     FSDSTMDL2  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
     FSDSTMDL3  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     FSDSTMDL4  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     FSDSTMDL5  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     FGLACNTL3  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      **  Array containing Copyright statement
 
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array of QCMDEXC commands
 
     D EDT             S              1    DIM(80)
      ** Array of QCMDEXC command to edit
 
     D @STK            S             10    DIM(100)
     D @REC            S              3  0 DIM(100)
      ** Subroutine stack
 
     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)
      ** Program data structure
 
     D LDA           E DS           256    EXTNAME(LDA)
     D  DBZZ19       E                     EXTFLD(ZZ019)
     D ERDTA         E DS                  EXTNAME(CGERDTA)
     D M#DTA           DS           256
     D  #MSGTX                 1     80
     D  ##MSGD                81    256
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
     D #2ACCD          DS
     D #XCNUM                  1      6
     D #XCCY                   7      9
     D #XACOD                 10     19  0
     D #XACSQ                 20     21  0
     D #XBRCA                 22     24
      *
     D                 DS
     D ZOUT15                  1     25
     D ZOUT0                   1     21
     D ZOUT1                   2     23
     D ZOUT2                   3     24
     D ZOUT3                   5     25
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
     D W#PEVT                112    113
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
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
 
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
 
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
      *
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
      *
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
      ** Message data for 'Invalid Action code (FT1)'
      ** *SFLSEL
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      ** Define fields for message transalation
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     D W0DATA          DS           256
      ** Define data structure used to pass parameters
     D  B#BRCA                 1      3
     D  O#ACTD                 4      4
     D  O#CPGM                 5     14
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1
      *
      ** Set up primary reference
      *
     C                   MOVEL     P2PARM        W0PREF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Initialize
      *
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
     C     W0RSF         DOWEQ     'N'
      *
     C                   EXSR      CAEXFM
      *
      ** Cancel & exit program
      *
     C   03              CAS                     ZXEXPG
     C   12              CAS                     ZXEXPG
      *
      ** HOME: Request subfile reload
      *
     C   05              CAS                     FBRQRL
      *
      ** Display next SFL page
      *
     C   27              CAS                     BBLDSF
      *
      ** Process screen input
      *
     C                   CAS                     ENTR##
     C                   ENDCS
     C                   ENDDO
     C                   ENDDO
      *****************************************************************
      /EJECT
      *****************************************************************
      ** BAIZSF - Initialise and load subfile page                   *
      *****************************************************************
     CSR   BAIZSF        BEGSR
      *
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
     C                   Z-ADD     *ZERO         ##RRMX            5 081
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL(P)  'ACCOUNT'     T#KEY
     C                   MOVEL     #3CUST        T#CNUM
     C                   MOVEL     #3CCY         T#CCY
     C                   MOVEL     #3ACOD        T#ACOD
     C                   MOVEL     #3ACSQ        T#ACSQ
     C                   MOVEL     #3BRCA        T#BRCA
     C                   Z-ADD     0             T#CDTE
      *
      ** Save previous selector values
      *
     C                   MOVEL     #3ACOD        WPACOD
     C                   MOVEL     #3CDTE        WPCDTE
     C                   MOVEL     #3EDTE        WPEDTE
     C                   MOVEL     #3CUST        WPCUST
     C                   MOVEL     #3CCY         WPCCY
     C                   MOVEL     #3ACSQ        WPACSQ
     C                   MOVEL     #3BRCA        WPBRCA
     C                   MOVEL     #3TTYPE       WPTTYPE
     C                   MOVEL     #3SORTK       WPSORTK
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
      *
      ** Load subfile page
      *
     C                   Z-ADD     0             ##RROK            5 0
      *
     C                   SETOFF                                         8782
      *
      ** IF Sort Key is 'ACCOUNT' then:
      ** Position/read file SDSTMDL4 if Stamp Tax type is AVERAGE
      *
     C     #3SORTK       IFEQ      'A'
      *
     C     #3TTYPE       IFEQ      'A'
     C     KPOS          SETLL     @STMDV4
     C                   READ      @STMDV4                              8782
     C                   ENDIF
      *
      ** Position/read file SDSTMDL5 if Stamp Tax type is INTEREST
      *
     C     #3TTYPE       IFEQ      'I'
     C     FIL005        IFEQ      *BLANKS
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
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   OPEN      SDSTMDL5
     C                   MOVEL     'Y'           FIL005            1
     C                   ENDIF
     C     KPOS          SETLL     @STMDV5
     C                   READ      @STMDV5                              8782
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** IF Sort Key is 'DATE' then open SDSTMDL2
      *
     C     #3SORTK       IFEQ      'D'
      ** Type is Average
     C     #3TTYPE       IFEQ      'A'
     C     FIL002        IFEQ      *BLANKS
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'SDSTMDL2'    U#FILE           10
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
     C                   Z-ADD     2             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   OPEN      SDSTMDL2
     C                   MOVEL     'Y'           FIL002            1
     C                   ENDIF
     C     KPOS2         SETLL     @STMDV2
     C                   READ      @STMDV2                              8782
      *
     C                   ENDIF
      ** Type is Interest
     C     #3TTYPE       IFEQ      'I'
     C     FIL003        IFEQ      *BLANKS
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'SDSTMDL3'    U#FILE           10
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
     C                   Z-ADD     3             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   OPEN      SDSTMDL3
     C                   MOVEL     'Y'           FIL003            1
     C                   ENDIF
     C     KPOS2         SETLL     @STMDV3
     C                   READ      @STMDV3                              8782
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      BBLDSF
      *================================================================
     CSR   BAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** BBLDSF - Load subfile page                                   *
      *****************************************************************
     CSR   BBLDSF        BEGSR
      *
     C   27              DO
      *
      ** Process SDSTMDL4 if sort key is 'A' - Account
      *
     C     #3SORTK       IFEQ      'A'
     C     #3TTYPE       IFEQ      'A'
     C  N82              READP     @STMDV4                                90
     C  N82              READ      @STMDV4                                90
     C                   ENDIF
      *
     C     #3TTYPE       IFEQ      'I'
     C  N82              READP     @STMDV5                                90
     C  N82              READ      @STMDV5                                90
     C                   ENDIF
     C                   ENDIF
      *
      ** Process SDSTMDL2 if sort key is 'D' - Date
      *
     C     #3SORTK       IFEQ      'D'
     C     #3TTYPE       IFEQ      'A'
     C  N82              READP     @STMDV2                                90
     C  N82              READ      @STMDV2                                90
     C                   ENDIF
      *
     C     #3TTYPE       IFEQ      'I'
     C  N82              READP     @STMDV3                                90
     C  N82              READ      @STMDV3                                90
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(37)
     C                   Z-ADD     ##RRMX        ##RR              5 0
     C                   Z-ADD     0             ##RRRD            5 0
      *
      ** Set required pages based on *Set Cursor or *Subfile Pages
      *
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
      *
      ** Compute lines required based on pages
      *
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   ENDIF
      *
      ** IF Stamp Tax type is not 'A' (Average) or 'I' (Interest)
      ** skip to end of SR and do not load record on sfile
      *
     C     *IN38         CABEQ     *ON           BB900
      *
      ** IF Sorting Order field is not 'A' (Account) or 'D' (Date)
      ** skip to end of SR and do not load record on sfile
      *
     C     *IN39         CABEQ     *ON           BB900
      *
      ** Load next SFL page until SFL page full, or
      ** Scan limit reached
      *
     C     *IN82         DOWEQ     '0'
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
      *
     C     T2KEY         CABNE     'ACCOUNT'     BB020
     C     #3CDTE        IFNE      *BLANKS
     C     WNDATE        ANDGT     0
     C     T2VALD        CABLT     WNDATE        BB020
     C                   ENDIF
     C     #3EDTE        IFNE      *BLANKS
     C     WNEDAT        ANDGT     0
     C     T2VALD        CABGT     WNEDAT        BB020
     C                   ENDIF
     C     #3CUST        IFNE      *BLANKS
     C                   MOVE      T2CNUM        WACNUM            6
     C     WACNUM        CABLT     #3CUST        BB020
     C                   ENDIF
     C     #3CCY         IFNE      *BLANKS
     C     T2CCY         CABLT     #3CCY         BB020
     C                   ENDIF
     C     #3ACOD        IFNE      *BLANKS
     C                   MOVE      T2ACOD        WAACOD           10
     C     WAACOD        CABLT     #3ACOD        BB020
     C                   ENDIF
     C     #3ACSQ        IFNE      *BLANKS
     C                   MOVE      T2ACSQ        WAACSQ            2
     C     WAACSQ        CABLT     #3ACSQ        BB020
     C                   ENDIF
     C     #3BRCA        IFNE      *BLANKS
     C     T2BRCA        CABLT     #3BRCA        BB020
     C                   ENDIF
     C     #3TTYPE       IFEQ      'A'
     C     T2STFB        CABNE     'Y'           BB020
     C                   ENDIF
     C     #3TTYPE       IFEQ      'I'
     C     T2STFI        CABNE     'Y'           BB020
     C                   ENDIF
     C     T2TPAY        CABNE     'Y'           BB020
      *
      ** Load SFL fields
      *
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
     C                   ADD       1             ##RRRD
      *
      ** Process SDSTMDL4 if sort key is 'A' - Account
      *
     C     #3SORTK       IFEQ      'A'
     C     #3TTYPE       IFEQ      'A'
     C                   READ      @STMDV4                                82
     C                   ENDIF
      *
     C     #3TTYPE       IFEQ      'I'
     C                   READ      @STMDV5                                82
     C                   ENDIF
     C                   ENDIF
      *
      ** Process SDSTMDL2 if sort key is 'D' - Date
      *
     C     #3SORTK       IFEQ      'D'
     C     #3TTYPE       IFEQ      'A'
     C                   READ      @STMDV2                                82
     C                   ENDIF
      *
     C     #3TTYPE       IFEQ      'I'
     C                   READ      @STMDV3                                82
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C     BB900         TAG
      *
      ** If no DBF records found, display error message
      *
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      ** Save highest SFL record load can continue at end point
      *
     C     ##RR          IFGT      ##RRMX
      ** Calculate Top Line
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
      *
     CSR   BBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** CAEXFM - Display screen                                      *
      *****************************************************************
     CSR   CAEXFM        BEGSR
      *
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVEL     *BLANKS       #ENTER            1
     C                   TIME                    ##TME
      *
      ** PUTOVR unless conditioned fields change
      *
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   ENDIF
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      *
      ** Maintain subfile position where possible
      *
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   ENDIF
     C                   TIME                    ##JTM
      *
      ** Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      ** Reset first message only flag
      *
     C                   MOVEL     'Y'           ZAFSMS            1      99
     C                   SETOFF                                         8392
      *
     CSR   CAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** ENTR## - Process Enter                                       **
      *****************************************************************
     CSR   ENTR##        BEGSR
      *
      ** Confirm/update is not deferred
      *
     C                   MOVEL     'N'           W0DCF             1
     C                   SETOFF                                       983132
     C                   SETOFF                                       333435
     C                   SETOFF                                       363839
     C                   SETOFF                                       41
     C                   CLEAR                   ZDAYNO
     C                   CLEAR                   WNCDTE
     C                   CLEAR                   WNDATE
     C                   CLEAR                   WNEDAT
      *
      ** Process control only if key fields changed
      *
     C                   MOVE      'N'           #MODIF            1
     C     #3BRCA        IFNE      WPBRCA
     C     #3CUST        ORNE      WPCUST
     C     #3ACOD        ORNE      WPACOD
     C     #3ACSQ        ORNE      WPACSQ
     C     #3CCY         ORNE      WPCCY
     C     #3TTYPE       ORNE      WPTTYPE
     C     #3CDTE        ORNE      WPCDTE
     C     #3EDTE        ORNE      WPEDTE
     C     #3SORTK       ORNE      WPSORTK
     C                   MOVE      'Y'           #MODIF            1
     C                   ENDIF
      *
      ** Check/convert date
      *
     C     #3CDTE        IFNE      *BLANKS
      *
     C                   MOVE      #3CDTE        WNCDTE            6 0
     C                   CALL      'ZDATE1'                             90
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM                    WNCDTE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO            5 0
      *
     C     *IN(90)       IFEQ      '1'
     C     P@RTCD        ORNE      *BLANK
     C                   SETON                                        36
     C                   MOVEL     'USR9458'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
     C                   MOVE      ZDAYNO        WNDATE            5 0
     C                   ENDIF
     C                   ENDIF
      *
     C     #3EDTE        IFNE      *BLANKS
     C                   MOVE      #3EDTE        WNEDTE            6 0
     C                   CALL      'ZDATE1'                             90
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM                    WNEDTE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO            5 0
     C     *IN(90)       iFEQ      '1'
     C     P@RTCD        ORNE      *BLANK
     C                   SETON                                        41
     C                   MOVEL     'USR9458'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
     C                   MOVE      ZDAYNO        WNEDAT            5 0
     C                   ENDIF
     C                   ENDIF
      *
     C     #3TTYPE       IFNE      'A'
     C     #3TTYPE       ANDNE     'I'
     C                   SETON                                        38
     C                   MOVEL     'USR9463'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
      *
     C                   CLEAR                   #3TTYDS
     C     #3TTYPE       IFEQ      'A'
     C                   MOVEL     'Average'     #3TTYDS
     C                   MOVEL     TYAVGB        #ODESC
     C                   ENDIF
     C     #3TTYPE       IFEQ      'I'
     C                   MOVEL     'Interest'    #3TTYDS
     C                   MOVEL     TYINTR        #ODESC
     C                   ENDIF
      *
      ** Stamp Sort Key : Account/Date
      *
     C     #3SORTK       IFNE      'A'
     C     #3SORTK       ANDNE     'D'
     C                   SETON                                        39
     C                   MOVEL     'USR9464'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
      *
     C                   CLEAR                   #3SORTD
     C     #3SORTK       IFEQ      'A'
     C                   MOVEL     SOACCN        #3SORTD
     C                   ENDIF
     C     #3SORTK       IFEQ      'D'
     C                   MOVEL     SODATE        #3SORTD
     C                   ENDIF
      *
      * Check Customer
      *
     C     #3CUST        IFNE      *BLANKS
      *
     C                   MOVEL     #3CUST        @CNUM            10
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    @CNUM            10
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        31
     C                   MOVEL     'USR9459'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
      *
      ** Check currency
      *
     C     #3CCY         IFNE      *BLANKS
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      #3CCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        32
     C                   MOVEL     'USR9460'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
      *
      ** Check Account Code
      *
     C     #3ACOD        IFNE      *BLANKS
      *
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      #3ACOD        @ACOD            10
     C     SDACOD        PARM      SDACOD        DSFDY
      *
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        33
     C                   MOVEL     'USR9461'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
      *
      ** Check Branch  Code
      *
     C     #3BRCA        IFNE      *BLANKS
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      #3BRCA        @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C     P@RTCD        IFNE      *BLANK
     C                   SETON                                        35
     C                   MOVEL     'USR9462'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if print was requested (F17)
      *
     C     *IN17         IFEQ      *ON
      ** Account Code must be input
     C     #3BRCA        IFEQ      *BLANKS
     C     #3CUST        OREQ      *BLANKS
     C     #3ACOD        OREQ      *BLANKS
     C     #3CCY         OREQ      *BLANKS
     C     #3ACSQ        OREQ      *BLANKS
     C                   SETON                                        983132
     C                   SETON                                        333435
     C                   MOVEL     'USR9465'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
      *
     C                   CLEAR                   W#DATA
     C                   MOVEL     'ACCOUNT'     W#KEY
     C                   MOVE      #3BRCA        W#BRCA
     C                   MOVE      #3CUST        W#CNUM
     C                   MOVE      #3CCY         W#CCY
     C                   MOVE      #3ACOD        W#ACOD
     C                   MOVE      #3ACSQ        W#ACSQ
     C                   MOVE      #3ACSQ        W#ACSQ
     C                   MOVE      'A'           W#PRTF
     C                   MOVE      #3TTYPE       W#TTYP
     C                   Z-ADD     WNDATE        W#STDT
      *
     C     #3CDTE        IFNE      *BLANKS
     C                   MOVE      #3CDTE        W#SDT
     C                   ENDIF
      *
     C                   Z-ADD     WNEDAT        W#EDAT
     C     #3EDTE        IFNE      *BLANKS
     C                   MOVE      #3EDTE        W#EDT
     C                   ENDIF
      *
      ** Set up Data to be passed to print pgm
      *
     C                   CALL      'GL008162'
     C                   PARM                    W#DATA
     C                   MOVEL     'USR9475'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Process subfile
      *
     C     W0RSL         CASEQ     'Y'           DBPRSF
     C                   ENDCS
      *
      ** Reload subfile
      *
     C                   EXSR      BAIZSF
      *
     CSR   DAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** DBPRSF - Process modified subfile record                     *
      *****************************************************************
     CSR   DBPRSF        BEGSR
      *
      ** Read first changed slf record
      *
     C                   READC     #SFLRCD                                92
     C     *IN92         DOWEQ     '0'
     C                   MOVEL     'Y'           #ENTER
      *
      ** Process subfile record
      *
     C                   EXSR      DCPRSR
     C                   UPDATE    #SFLRCD
      *
      ** If F12 then redisplay screen with action code
      ** Or action did not complete
      *
     C     P0RTN         IFNE      *BLANKS
     C                   MOVEL     *BLANKS       P0RTN
     C                   GOTO      DBEXIT
     C                   ENDIF
      *
     C                   READC     #SFLRCD                                92
     C                   ENDDO
      *================================================================
     CSR   DBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRACTD - Check action code                                   *
      ** Called by: DCPRSR                                            *
      *****************************************************************
     CSR   SRACTD        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRACTD'      @STK(Q)
      ** Check all valid actions
      ** CASE: RCD.*SFLSEL is not valid
     C     #2SEL         IFEQ      ' '
     C                   GOTO      EXACTD
     C                   ENDIF
      *
     C     #2SEL         IFNE      'E'
     C     #2SEL         ANDNE     'P'
      ** Setup message data for message
     C                   MOVEL     #2SEL         ZA0001
      ** Send message 'Invalid Action code'
     C                   MOVEL     'USR9456'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        40
      *
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
      *
      ** Unwind subroutine stack name
      *
     C     EXACTD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRRSET - Record changed                                      *
      ** Called by: DCPRSR                                            *
      *****************************************************************
     CSR   SRRSET        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRSET'      @STK(Q)
      *
      ** Skip to end if not enquire action taken
      *
     C     #2SEL         IFNE      'E'
     C     #2SEL         ANDNE     'P'
     C                   GOTO      EXRSET
     C                   ENDIF
      *
     C                   CLEAR                   W#DATA
      ** Retrieve Date From Header File
      ** Open GLACNTL3, if not opened yet
     C     FIL000        IFEQ      *BLANKS
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'GLACNTL3'    U#FILE           10
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
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   OPEN      GLACNTL3
     C                   MOVEL     'Y'           FIL000            1
     C                   ENDIF
      *
     C     KACCNT        KLIST
     C                   KFLD                    #2CNUM
     C                   KFLD                    #2CCY
     C                   KFLD                    #2ACOD
     C                   KFLD                    #2ACSQ
     C                   KFLD                    #2BRCA
     C     KACCNT        CHAIN     GLACNTL3                           90
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'GLACNTL3'    W0FILE
     C                   MOVE      *BLANKS       W0KEY
     C                   MOVEL     T#KEY         W0KEY
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Set Fields for window
      *
     C                   MOVE      #2KEY         W#KEY
     C                   MOVE      #2LNRF        W#LNRF
     C                   MOVE      #2FCNM        W#FCNM
     C                   MOVE      #2FACT        W#FACT
     C                   MOVE      #2FCNO        W#FCNO
     C                   MOVE      #2FSEQ        W#FSEQ
     C                   MOVE      #2ORED        W#ORED
     C                   MOVE      #2DLNO        W#DLNO
     C                   MOVE      #2TDRF        W#TDRF
     C                   MOVE      #2BRCA        W#BRCA
     C                   MOVE      #2CNUM        W#CNUM
     C                   MOVE      #2CCY         W#CCY
     C                   MOVE      #2ACOD        W#ACOD
     C                   MOVE      #2ACSQ        W#ACSQ
     C                   MOVE      #2PREF        W#PREF
     C                   MOVE      #2CQSQ        W#CQSQ
     C                   MOVE      #2PBRC        W#PBRC
     C                   MOVE      #2PSSH        W#PSSH
     C                   MOVE      #2PCPY        W#PCPT
     C                   MOVE      #2PDUD        W#PDUD
     C                   MOVE      #2PEVT        W#PEVT
      *
      ** Set Dr Account
      *
     C                   MOVE      F1DBRC        A2BRCA
     C                   MOVE      F1DCST        A2CNUM
     C                   MOVE      F1DCCY        A2CCY
     C                   MOVE      F1DACD        A2ACOD
     C                   MOVE      F1DASC        A2ACSQ
     C                   MOVEL     A#ACCD        W#DACC
      *
      ** Posting Date
      *
     C     #2PSDT        IFNE      *ZEROS
     C                   CALL      'ZDATE2'
     C                   PARM      #2PSDT        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        W#PSDT
     C                   ENDIF
      *
      ** Value Date
      *
     C     #2VALD        IFNE      *ZEROS
     C                   CALL      'ZDATE2'
     C                   PARM      #2VALD        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        W#VLDT
     C                   ENDIF
      *
      ** Gross Amount
      *
     C                   MOVE      #2GROS        W#GROS
      *
      ** Tax Amount in Transaction ccy
      *
     C                   MOVE      #2STAX        W#TAXE
     C                   MOVE      #2ECCY        W#CCYE
      *
      ** Tax Amount in Dr Account Ccy
      *
     C                   MOVE      F1DCCY        W#CCYD
      *
     C     #2TADC        IFNE      *ZEROS
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      F1DCCY        @CCY
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        orne      *BLANKS
     C                   MOVEL     'AOCURRR0'    W0FILE
     C                   MOVE      *BLANKS       W0KEY
     C                   MOVEL     'PARM:'       W0K10            10
     C                   MOVE      F1DCCY        W0K10
     C                   MOVEL     '*CALL'       W0KEY
     C                   MOVE      W0K10         W0KEY
     C                   Z-ADD     11            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVE      A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   MOVE      #2TADC        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#TAXD
     C                   ENDIF
      *
      ** Opening Balance
      *
     C     #2STBL        IFNE      *ZEROS
     C                   MOVE      #2STBL        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#OPNB
     C                   ENDIF
      *
      ** Closing Balance
      *
     C     #2ENBL        IFNE      *ZEROS
     C                   MOVE      #2ENBL        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#CLOB
     C                   ENDIF
      *
      ** Tax Amount in Stamp Tax Ccy
      *
     C                   MOVE      #2SCCY        W#CCYS
      *
     C     #2TASC        IFNE      *ZEROS
      *
      ** Retrieve Account Nr of decimal places
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *blanks       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      #2SCCY        @CCY
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    W0FILE
     C                   MOVE      *BLANKS       W0KEY
     C                   MOVEL     'PARM:'       W0K10
     C                   MOVE      #2SCCY        W0K10
     C                   MOVEL     '*CALL'       W0KEY
     C                   MOVE      W0K10         W0KEY
     C                   Z-ADD     12            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVE      A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   MOVE      #2TASC        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#TAXS
     C                   ENDIF
      *
      ** Total Tax on Average
      *
     C     F1STAB        IFNE      *ZEROS
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      F1CCY         @CCY
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    W0FILE
     C                   MOVE      *BLANKS       W0KEY
     C                   MOVEL     'PARM:'       W0K10
     C                   MOVE      F1CCY         W0K10
     C                   MOVEL     '*CALL'       W0KEY
     C                   MOVE      W0K10         W0KEY
     C                   Z-ADD     11            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVE      A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   MOVE      F1STAB        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#TAXA
     C                   ENDIF
      *
      ** Total Tax on Interest
      *
     C     F1STAI        IFNE      *ZEROS
     C                   MOVE      F1STAI        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#TAXI
     C                   ENDIF
      *
      ** Type of Enquire
      *
     C                   MOVE      #3TTYPE       W#TTYP
      *
      ** Tax Rate
      *
     C                   Z-ADD     8             ZDECS
     C                   MOVE      'J'           ZECODE
     C     #2TXRB        IFNE      *ZEROS
     C                   MOVE      #2TXRB        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        W#TXRT
     C                   ENDIF
      *
     C                   Z-ADD     WNDATE        W#STDT
     C     #3CDTE        IFNE      *BLANKS
     C                   MOVE      #3CDTE        W#SDT
     C                   ELSE
     C                   MOVE      *ZEROS        W#SDT
     C                   END
      *
     C                   Z-ADD     WNEDAT        W#EDAT
     C     #3EDTE        IFNE      *BLANKS
     C                   MOVE      #3EDTE        W#EDT
     C                   ELSE
     C                   MOVE      *ZEROS        W#EDT
     C                   ENDIF
      *
      ** Start/End Period for Average
      *
     C     #3TTYPE       IFEQ      'A'
     C     #2STDT        IFNE      *ZEROS
     C                   CALL      'ZDATE2'
     C                   PARM      #2STDT        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        W#STP
     C                   ENDIF
      *
      ** Value Date
      *
     C     #2ENDT        IFNE      *ZEROS
     C                   CALL      'ZDATE2'
     C                   PARM      #2ENDT        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        W#ENP
     C                   ENDIF
     C                   ENDIF
      *
     C     EXRSET        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** DCPRSR - Process subfile record                              *
      *****************************************************************
     CSR   DCPRSR        BEGSR
      *
      ** Setof error indicators and SFLNXTCHG
      *
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
      ** Retrieve data from Header GLACNTL3 and set fields
      *
     C                   EXSR      SRRSET
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      DCENDT
     C                   ENDIF
      *
      ** Display Screen 2
      *
     C     #2SEL         IFEQ      'E'
     C                   MOVE      *BLANKS       W#RTRN            7
     C                   MOVEL     'GL008160'    W#PGM            10
     C                   CALL      'GL008161'
     C                   PARM      'E'           W#ACTI            1
     C                   PARM                    W#DATA
     C                   PARM      *BLANKS       W#RTRN            7
     C                   PARM      'USR9457'     W#TITLE           7
     C                   PARM      *BLANKS       W#SPARE         256
      *
     C     W#RTRN        IFNE      *BLANKS
     C                   SETON                                        98
     C                   MOVEL     'GL008161'    W0FILE
     C                   MOVE      *BLANKS       W0KEY
     C                   MOVEL     'GL008161'    W0KEY
     C                   Z-ADD     5             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Print Movement
      *
     C     #2SEL         IFEQ      'P'
     C                   MOVE      'M'           W#PRTF
     C                   CALL      'GL008162'
     C                   PARM                    W#DATA
     C                   ENDIF
      *
     C     DCENDT        TAG
     C     *IN40         IFEQ      '1'
     C  N99              Z-ADD     ##RR          ##SFRC               99
     C                   SETON                                        84
     C                   ELSE
     C                   SETOFF                                       84
     C                   MOVEL     *BLANK        #2SEL
     C                   ENDIF
      *
     CSR   DCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** FBRQRL - Request subfile reload                              *
      *****************************************************************
     CSR   FBRQRL        BEGSR
      *
     C                   MOVEL     'Y'           W0RSF
      *
     CSR   FBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** MBFL#1 - Move @STPDV2 fields to subfile                      *
      *****************************************************************
     CSR   MBFL#1        BEGSR
      *
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
     C                   MOVEL     T2CCY         #2CCY
     C                   MOVEL     T2ACOD        #2ACOD
     C                   MOVEL     T2ACSQ        #2ACSQ
     C                   MOVEL     T2PREF        #2PREF
     C                   MOVEL     T2CQSQ        #2CQSQ
     C                   MOVEL     T2CDTE        #2CDTE
      *
     C                   MOVEL     T2STDT        #2STDT
     C                   MOVEL     T2ENDT        #2ENDT
     C                   MOVEL     T2PSDT        #2PSDT
     C                   MOVEL     T2VALD        #2VALD
     C                   MOVEL     T2ECCY        #2ECCY
     C                   MOVEL     T2SCCY        #2SCCY
     C                   MOVEL     T2TASC        #2TASC
     C                   MOVEL     T2TADC        #2TADC
     C                   MOVEL     T2STBL        #2STBL
     C                   MOVEL     T2ENBL        #2ENBL
     C     T2TXRB        MULT      100           #2TXRB
      *
      ** Format start date
      *
     C     T2VALD        IFNE      *ZERO
     C                   CALL      'ZDATE2'
     C                   PARM      T2VALD        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVE      ZDATE         ##DATE
     C                   MOVE      ##MM          #MM
     C                   MOVE      '20'          #CC
     C                   MOVE      ##YY          #YY
     C                   MOVEL     ZADATE        #2EDTE
     C                   ENDIF
      *
     C                   CLEAR                   #WGROS
     C     #3TTYPE       IFEQ      'A'
     C                   Z-ADD     T2AVBL        #WGROS
     C                   ENDIF
     C     #3TTYPE       IFEQ      'I'
     C                   Z-ADD     T2GROS        #WGROS
     C                   ENDIF
      *
      ** Edit Average Balance
      *
     C     #WGROS        IFNE      *ZERO
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      T2CCY         @CCY
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    W0FILE
     C                   MOVE      *BLANKS       W0KEY
     C                   MOVEL     'PARM:'       W0K10
     C                   MOVE      T2CCY         W0K10
     C                   MOVEL     '*CALL'       W0KEY
     C                   MOVE      W0K10         W0KEY
     C                   Z-ADD     6             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVE      A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   MOVE      #WGROS        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        #2GROS
     C                   ELSE
     C                   CLEAR                   #2GROS
     C                   Endif
      *
      ** Edit Tax amount
      *
     C     T2TATC        IFNE      *ZERO
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      T2ECCY        @CCY
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    W0FILE
     C                   MOVE      *BLANKS       W0KEY
      *
     C                   MOVEL     'PARM:'       W0K10
     C                   MOVE      T2ECCY        W0K10
     C                   MOVEL     '*CALL'       W0KEY
     C                   MOVE      W0K10         W0KEY
      *
     C                   Z-ADD     7             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVE      A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
      *
      ** Format amount
      *
     C                   MOVE      T2TATC        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        #2STAX
     C                   ELSE
     C                   CLEAR                   #2stax
     C                   ENDIF
      *
      ** Set whole account code
      *
     C                   MOVE      T2BRCA        #XBRCA
     C                   MOVE      T2CNUM        #XCNUM
     C                   MOVE      T2ACOD        #XACOD
     C                   MOVE      T2ACSQ        #XACSQ
     C                   MOVE      T2CCY         #XCCY
      *
     C                   MOVEL     *BLANK        #2SEL
      *
     CSR   MBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** FMTAMT - CALC: Format Amount fields                          *
      *****************************************************************
     CSR   FMTAMT        BEGSR
      *
     C                   Move      *BLANKS       ZOUT21           21
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT21
      *
     CSR   FMTXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** MEIZ#2 - Initialise subfile control                          *
      *****************************************************************
     CSR   MEIZ#2        BEGSR
      *
     C                   MOVEL     P1ACTC        #PACTC
     C     P2PARM        IFNE      *BLANKS
     C                   MOVEL     P2ACCD        #2ACCD
     C                   Else
     C                   MOVEL     *BLANK        #2ACCD
     C                   MOVEL     *BLANK        #2EDTE
     C                   ENDIF
      *
      ** Fill Command lines and narrative text from messages
      *
     C                   SELECT
      ** Enquiry screen
     C     P1ACTC        WHENEQ    'E'
     C     P1ACTC        OREQ      'e'
      ** Option Name
     C                   CALL      'SDC008190'                          9090
     C                   PARM      'USR9457'     #MSGID
     C                   PARM      'GLUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONAM
      ** Action codes
     C                   CALL      'SDC008190'                          9090
     C                   PARM      'USR9467'     #MSGID
     C                   PARM      'GLUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   MOVEL     #MSTX1        ##CMD1
      ** Function keys
     C                   MOVEL     'USR9466'     #UFKEY
     C                   ENDSL
      ** Function keys
     C     *LIKE         DEFINE    #MSGID        #UFKEY
     C                   CALL      'SDC008190'                          9090
     C                   PARM      #UFKEY        #MSGID
     C                   PARM      'GLUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   MOVEL     #MSTX1        ##CMD2
      *
     CSR   MEEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** ZASNMS - Send message to program's message queue             *
      *****************************************************************
     CSR   ZASNMS        BEGSR
      *
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
      *================================================================
     CSR   ZAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** ZXEXPG - Cancel & Exit Program                               *
      *****************************************************************
     CSR   ZXEXPG        BEGSR
      *
      ** USER: Exit program processing
      ** CASE: CTL.*CMD key is CF03
      *
     C     *IN03         IFEQ      '1'
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   ENDIF
      *
      ** CASE: CTL.*CMD key is CF12
      *
     C     *IN12         IFEQ      '1'
     C                   MOVEL     'USR0790'     P0RTN
     C                   ENDIF
      *
     C                   EXSR      ZYEXPG
      *
     CSR   ZXEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** ZYEXPG - Exit program: Direct                                *
      *****************************************************************
     CSR   ZYEXPG        BEGSR
      *
      * Copy any undisplayed messages back to caller
      *
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
      *
      ** Exit program
      *
     C                   MOVEL     '1'           *INLR
     C                   RETURN
      *
     CSR   ZYEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** ZZINIT - Initialisation                                      *
      *****************************************************************
     CSR   ZZINIT        BEGSR
      *
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   ENDIF
     C                   MOVE      *BLANK        P0RTN
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
     C                   Z-ADD     10            ##SFPG            3 0
     C                   Z-ADD     1             ##SFRC
      ** Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      ** Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      ** Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      ** Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *
     C                   MOVEL     *BLANK        W0GRP             1
     C                   Z-ADD     0             Q                 5 0
     C                   MOVEA     '00'          *IN(77)
      ** USER: Initialize program
      ** Retrieve Midas Date - R10 Standard Functions  *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          ACT@             80
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
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
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
      ** Convert Run date to ddmmyy
      *
     C                   CALL      'ZDATE2'
     C                   PARM      BJRDNB        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
      *
     C                   MOVE      ZDATE         DTDTA
     C                   MOVE      ZDATE         #3EDTE
      *
      ** Find first day of month ddmmyy
      *
     C     BJDFIN        IFEQ      'D'
     C                   Z-ADD     1             DT12
     C                   ELSE
     C                   Z-ADD     1             DT34
     C                   ENDIF
      *
      ** Convert start of month to day nr
      *
     C                   MOVE      DTDTA         WNCDTE            6 0
     C                   CALL      'ZDATE1'                             90
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM                    WNCDTE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO            5 0
      *
      ** End of Previous Month
      *
     C     ZDAYNO        SUB       1             WNDATE
      *
      ** Convert End of previous month  to ddmmyy
      *
     C                   CALL      'ZDATE2'
     C                   PARM      WNDATE        ZDAYNO
     C                   PARM      WUDFF         ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
      *
     C                   MOVE      ZDATE         #3CDTE
      *
      ** Get modules information
      *
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     MMODDS        PARM      *BLANKS       DSFDY
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
      ** Open file SDSTMDL4
      *
     C     FIL004        IFEQ      *BLANKS
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
      *
     C                   OPEN      SDSTMDL4
     C                   MOVEL     'Y'           FIL004            1
     C                   ENDIF
      *
      ** Allow function key 12 if lower case action
      *
     C                   SELECT
     C     P1ACTC        WHENEQ    's'
     C     P1ACTC        OREQ      'S'
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     'S'           P1ACTC
     C     P1ACTC        WHENEQ    'e'
     C     P1ACTC        OREQ      'E'
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     'E'           P1ACTC
     C     P1ACTC        WHENEQ    'a'
     C     P1ACTC        OREQ      'A'
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     'A'           P1ACTC
     C                   ENDSL
      *
      ** Set Stamp Tax Type to 'A' - Average
      *
     C                   MOVE      'A'           #3TTYPE
     C                   MOVEL     'Average'     #3TTYDS
     C                   MOVEL     TYAVGB        #ODESC
      *
      ** Set Sort Key to 'A' - Account
      *
     C                   MOVE      'A'           #3SORTK
     C                   MOVEL     SOACCN        #3SORTD
      *
     C     *LIKE         DEFINE    #3BRCA        WPBRCA
     C     *LIKE         DEFINE    #3ACSQ        WPACSQ
     C     *LIKE         DEFINE    #3CCY         WPCCY
     C     *LIKE         DEFINE    #3CUST        WPCUST
     C     *LIKE         DEFINE    #3CDTE        WPCDTE
     C     *LIKE         DEFINE    #3EDTE        WPEDTE
     C     *LIKE         DEFINE    #3ACOD        WPACOD
     C     *LIKE         DEFINE    #3TTYPE       WPTTYPE
     C     *LIKE         DEFINE    #3SORTK       WPSORTK
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
      ** Header File
      *
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
      *
      ** Position DBF file
      *
     C     KPOS2         KLIST
     C                   KFLD                    T#KEY
     C                   KFLD                    T#CDTE
     C                   KFLD                    T#ASEQ
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
      ** Initialise subfile control
      *
     C                   EXSR      MEIZ#2
      *
     CSR   ZZEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *PSSR - Error Processing                                     *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
     C     @@PSSR        IFNE      *BLANK
     C                   SETON                                        H1  LR
     C                   RETURN
     C                   ENDIF
      *
      ** Flag routine as started; define action code:
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
      ** Provide a fuller report and end program
      *
     C                   MOVEA     @STK          #@STK           100
     C                   SETON                                        U7U8LR
     C                   MOVE      '*ERROR*'     W0RTN             7
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
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
      ** Provide a fuller report:
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
      *
     C                   Z-ADD     Q             Q                 5 0
     C                   DUMP
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
     C                   MOVEL     #MSGTX        ERNARR
      *
      * Send message
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
      ** Provide a fuller report:
      *
     C                   MOVEA     @STK          #@STK           100
     C                   RETURN
      *
     CSR   EXERR         ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2010
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
