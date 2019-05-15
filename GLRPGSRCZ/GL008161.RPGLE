     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Movements Enquiry - RE Screen 2')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL008161 - Stamp Tax Movements Enquiry RE Screen 2           *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
     FGL008161DFCF   E             WORKSTN
     F                                     INFDS(INFDS#)
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      *  Array of QCMDEXC commands
 
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
      *
     D ACCD            DS
     D ##CNUM                  1      6
     D                         7      7    INZ('-')
     D ##CCY                   8     10
     D                        11     11    INZ('-')
     D ##ACOD                 12     21  0
     D                        22     22    INZ('-')
     D ##ACSQ                 23     24  0
     D                        25     25    INZ('-')
     D ##BRCA                 26     28
      *
     D W#DTA           DS          1024
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
      /EJECT
      ** Data structures
     D                 DS
     D KYACCN                  1     20    INZ('Account             ')
     D KYDES1                 21     41    INZ('Total Tax on Average ')
     D KYDES2                 42     62    INZ('Total Tax on Interest')
     D KYDES3                 63     80    INZ('Average Balance   ')
     D KYDES4                 81     98    INZ('Dr Interest Amount')
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
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
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
      *
     D                 DS
     D  ZAMSDA                 1    132
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      *  Define fields for message transalation
 
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
     C                   PARM                    WACTIO            1
     C                   PARM                    W#DTA
     C                   PARM                    W0RTN             7
     C                   PARM                    TITLE             7
     C                   PARM                    SPARED          256
      *
      ** Initialize
      *
     C                   EXSR      ZZINIT
      *
      ** Display Screen
      *
     C                   EXFMT     SCREENF
      *
      ** Exit
      *
     C                   EXSR      ZXEXPG
      *
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
      *
      ** If no message file specified, use default
      *
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
      *
      ** Clear all fields for default mechanism next time
      *
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *
     CSR   ZAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** ZXEXPG - Cancel & exit program                               *
      *****************************************************************
     CSR   ZXEXPG        BEGSR
      *
      ** USER: Exit program processing
      ** CASE: CTL.*CMD key is CF12
      *
     C     *IN12         IFEQ      '1'
     C                   MOVEL     'USR0790'     W0RTN
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
      ** Copy any undisplayed messages back to caller
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
     ** ZZINIT - Initialisation                                       *
      *****************************************************************
     CSR   ZZINIT        BEGSR
      *
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   ENDIF
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
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
     C                   TIME                    ##TME             6 0
      *
      ** Obtain default message file
      *
     C                   MOVEL     'GLUSRMSG'    ZADFMF           10
     C                   MOVEL     *BLANK        W0GRP             1
     C                   Z-ADD     0             Q                 5 0
     C                   MOVEA     CPY@          ACT@             80
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
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If return with an error (LR seton in called program) then
      ** process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     5             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Get modules information
      *
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     MMODDS        PARM      *BLANKS       DSFDY
      *
      ** If return with an error (LR seton in called program) then
      ** process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     2             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   CLEAR                   #2KEYF
     C                   SELECT
     C     W#KEY         WHENEQ    'ACCOUNT'
     C                   MOVE      W#CNUM        ##CNUM
     C                   MOVE      W#BRCA        ##BRCA
     C                   MOVE      W#ACOD        ##ACOD
     C                   MOVE      W#ACSQ        ##ACSQ
     C                   MOVE      W#CCY         ##CCY
     C                   MOVE      W#CCY         #1CCY1
     C                   MOVE      W#CCY         #1CCY2
     C                   MOVEL     ACCD          #2KEYF
     C                   MOVE      KYACCN        #2KEY
     C     W#TTYP        IFEQ      'A'
     C                   MOVE      KYDES1        #1DES1
     C                   MOVE      W#TAXA        #1STAX
     C                   ELSE
     C                   MOVE      KYDES2        #1DES1
     C                   MOVE      W#TAXI        #1STAX
     C                   ENDIF
     C     #1STAX        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       #1CCY2
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Description of Gross Amount
      *
     C                   SELECT
     C     W#TTYP        WHENEQ    'A'
     C                   MOVEL     KYDES3        #2FLDD
     C     W#TTYP        WHENEQ    'I'
     C                   MOVEL     KYDES4        #2FLDD
     C                   ENDSL
      *
      ** Type of Enquire: Interest/Average
      ** Set Screen Fields
      *
     C                   MOVE      *ALL'-'       #TRATT
      *
      ** Debit Account
      *
     C                   MOVE      W#DACC        #1DACC
      *
      ** Posting Date
      *
     C                   MOVE      W#PSDT        #2PSTD
      *
      ** Value Date
      *
     C                   MOVE      W#VLDT        #2VALD
      *
      ** Gross Amount
      *
     C                   MOVE      W#GROS        #2GROS
     C     #2GROS        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       #1CCY1
     C                   ENDIF
      *
      ** Tax amount in Event Ccy
      *
     C                   MOVE      W#TAXE        #2TAX1
     C                   MOVE      W#CCYE        #2CCY1
      *
      ** Tax in Debit Account ccy (if different from Event Ccy)
      *
     C                   MOVE      W#TAXD        #2TAX2
     C                   MOVE      W#CCYD        #2CCY2
      *
      ** Tax in Stamp Tax  ccy (if different from Event Ccy or Dr Acc ccy)
      *
     C                   MOVE      W#TAXS        #2TAX3
     C                   MOVE      W#CCYS        #2CCY3
     C                   MOVE      W#TXRT        #2TAXR
      *
      ** Retrieve title for screen
      *
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   CALL      'SDRTVTXT'
     C                   PARM                    TITLE
     C                   PARM                    ZAMSGF
     C                   PARM                    TEXT            132
     C                   MOVEL     TEXT          STITL
      *
     CSR   ZZEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *PSSR - PSSR Processing                                      *
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
      ** Provide a fuller report:
      *
     C                   MOVEA     @STK          #@STK           100
      *
      ** End the program:
      *
     C                   SETON                                        U7U8LR
     C                   MOVE      '*ERROR*'     W0RTN             7
     C                   RETURN
      *
     C                   ENDSR
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
      *
      ** Define work variables
      *
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
     C     *DTAARA       DEFINE                  LDA
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
      *
     CSR   EXERR         ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2010
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
