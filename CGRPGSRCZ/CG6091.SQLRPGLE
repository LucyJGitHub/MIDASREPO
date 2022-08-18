     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                   *
/*EXI *  TEXT('Midas CG Lending LIBOR confirmation - Extract')       *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG6091 - Lending LIBOR confirmation                          *
      *                                                               *
      *  Function:  This program extracts data for LIBOR confirmation *
      *                                                               *
      *  Called By: CG6090 - Lending LIBOR driver                     *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD059624           Date 20Jul22               *
      *  Prev Amend No. MD059564           Date 14Feb22               *
      *                 MD059552           Date 08Feb22               *
      *                 MD059320 *CREATE   Date 06Dec21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059624 - CCR Rounding parameters for NCCR calculation CC8  *
      *  MD059564 - Adding extract for Next Repay Date and Loan       *
      *             Narrative fields                                  *
      *             And correct error with AllInRate                  *
      *  MD059552 - Adding extract for All-in-rate                    *
      *  MD059320 - CLE172 - LIBOR Lending - Correspondence Manager   *
      *                                                               *
      *****************************************************************

     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     F                                     INFSR(SRFILE)

      *****************************************************************
      /EJECT

      **  Copyright array.
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

     D/COPY CGCPYSRC,CGPACKEILE
     D/COPY CGCPYSRC,SRERRDLE

     D**  Array of Currencies accessed by program
     D ##CY            S              3    DIM(100)

     D CPYR            DS
      **  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80

     D ##SDS           DS
      **  Look-up string for RDE definition Array
     D  ##S                    1   5632
     D #@SDS           DS
     D**  Packed data string.
     D  #@S                 5120   5120
     D*
     D                 DS
     D**  Number Field
     D  ##W                    1     20
     D                                     DIM(20)
     D  ##WNUM                 1     20  0
     D                 DS
     D** Used to convert item reference from character to numeric
     D  ##ITMA                 1      8
     D  ##ITEM                 1      8  0
     D*
     D                 DS
     D  ##NCIT                 1      6
     D  NMCY                   1      3
     D  SITP                   4      6
     D                 DS
     D  ##CCCC                 1      5
     D  ##CCY                  1      3
     D  ##CCD                  4      5
     D*
     D**  Loan details parameter for call to CG99LSET.
     D*
     D PDETLS          DS           256
     D* Currency
     D  ##CCY1                 1      3
     D* Customer Number
     D**********                              4   90##CNUM                                    CSD027
     D  ##CNUM                 4      9
     D* Branch
     D  ##BRCA                10     12
     D* Loan Processing Type
     D  ##PTYP                13     14  0
     D*
     D**  Settlement Instructions Parameter for call to CG99LSET.
     D*
     D P0PARM          DS           768
     D**  Pay - Branch
     D  P0POBR                 1      3
     D**  Receipt - Branch
     D  P0ROBR                 4      6
     D**  Receipt - Settlement Method
     D  P0RSTM                 7      8  0
     D**  Receipt - Our Nostro
     D**********                              9  20 P0RONS                                    CGL029
     D  QQRONS                 9     20
     D**  Receipt - Intermediary Bank
     D  P0RIBN                21     28
     D**  Receipt - Intermediary Bank a/c
     D  P0RIBA                29     63
     D**  Receipt - Ordering Bank No.
     D**********                             64  690P0ROBN                                    CSD027
     D  P0ROBN                64     69
     D**  Receipt - Ordering Customer
     D**********                             70  750P0ROCN                                    CSD027
     D  P0ROCN                70     75
     D**  Pay - Settlement Method
     D  P0PSTM                76     77  0
     D**  Pay - Our Nostro
     D**********                             78  89 P0PONS                                    CGL029
     D  QQPONS                78     89
     D**  Pay - Intermediary Bank
     D  P0PIBN                90     97
     D**  Pay - Intermediary Bank a/c
     D  P0PIBA                98    132
     D**  Pay - Ordering Bank No.
     D**********                            133 1380P0POBN                                    CSD027
     D  P0POBN               133    138
     D**  Pay - Ordering Customer No.
     D**********                            139 1440P0POCN                                    CSD027
     D  P0POCN               139    144
     D**  Receiver Correspondent No.
     D  P0RCRN               145    152
     D**  Receiver Correspondent A/C 1
     D  P0RCRA               153    187
     D**  Receiver Number
     D  P0RVNO               188    195
     D**  A/C with Bank No.
     D  P0AWBN               196    203
     D**  A/C with Bank A/C Line
     D  P0AWBA               204    238
     D**  Beneficiary No.
     D  P0BENN               239    246
     D**  Beneficiary A/C Line
     D  P0BENA               247    281
     D**  Details of Pay 1
     D  P0DTP1               282    316
     D**  Details of Pay 2
     D  P0DTP2               317    351
     D**  Details of Pay 3
     D  P0DTP3               352    386
     D**  Details of Pay 4
     D  P0DTP4               387    421
     D**  Details of Charges
     D  P0DCHG               422    424
     D**  Bank to Bank Info 1
     D  P0BTB1               425    459
     D**  Bank to Bank Info 2
     D  P0BTB2               460    494
     D**  Bank to Bank Info 3
     D  P0BTB3               495    529
     D**  Bank to Bank Info 4
     D  P0BTB4               530    564
     D**  Bank to Bank Info 5
     D  P0BTB5               565    599
     D**  Bank to Bank Info 6
     D  P0BTB6               600    634
     D**  Special Instruction 1
     D  P0SPI1               635    664
     D**  Special Instruction 2
     D  P0SPI2               665    694
     D**  Special Instruction 3
     D  P0SPI3               695    724
     D**  Settlement Currency
     D  P0STCY               725    727
     D**  Pay Settlement Currency
     D  P0PSCY               728    730
     D  P0RONS               731    748
     D  P0PONS               749    766
     D*
     D**  UDC Details
     D*
     D P1PARM          DS           256
     D**  Output Sequence
     D  P1OSEQ                 1      9  0
     D**  UDC item number
     D  P1ITEM                10     17  0
     D**  This bind level
     D  P1TBIN                18     25  0
     D**  Previous bind level
     D  P1PBIN                26     33  0
     D*
     D**  Loan details Parameters for call to CG6001.
     D*
     D P@PARM          DS           256
     D**  Loan Reference
     D  P@LNRF                 1      6
     D**  Cancel/Amend Field
     D  P@CNAM                 7      7
     D*
     D**  Facility details Parameter for call to CG6001
     D*
     D P4PARM          DS           256
     D**  Facility customer
     D  P4FCUS                 1      6
     D**  Facility type
     D  P4FTYP                 7      9  0
     D**  Facility Seq
     D  P4FSEQ                10     11  0
     D*
     D**  For error reporting
     D*
     D**  Named constants
     D*
     D W#PTYP          C                   CONST('LEINTERCNF')
     D W#PST1          C                   CONST('CALL LOAN ')
     D W#PST2          C                   CONST('TERM LOAN ')
     D W#PST3          C                   CONST('TERM PA PU')
     D W#PST4          C                   CONST('TERM PA SL')
     D W#PST5          C                   CONST('FLAT LOAN')
     D W#PST6          C                   CONST('GUAR ISSUE')
     D W#PST7          C                   CONST('DISC LOAN ')
     D W#PST8          C                   CONST('DISC PA PU')
     D W#PST9          C                   CONST('DISC PA SL')
     D W#PSTA          C                   CONST('CALL PA PU')
     D W#PSTB          C                   CONST('CALL PA SL')
     D W#PSTC          C                   CONST('RISK PA PU')
     D W#PSTD          C                   CONST('RISK P SL1')
     D W#PSTE          C                   CONST('RISK P SL2')
     D W#PSTF          C                   CONST('DISC LOAN ')
     D W#PSTG          C                   CONST('DISC PA PU')
     D W#PSTH          C                   CONST('DISC PA SL')
     D W#PSTI          C                   CONST('CALL PA PU')
     D W#PS10          C                   CONST('CALL PA SL')
     D W#PS11          C                   CONST('RISK PA PU')
     D W#PS12          C                   CONST('RISK P SL1')
     D W#PS13          C                   CONST('RISK P SL2')
     D W#PS14          C                   CONST('GUAR ISSUE')

     D XINTA           S             13  0
     D XCINPDT         S              5  0
     D XALLINR         S             17p12                                                  MD059552

     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
      **  External DS for incomplete reference

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External DS for Bank details

     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
      **  External DS for currency details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  External DS for customer details

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      **  External DS for General Ledger details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Second DS for access programs, long data structure

     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
      **  Record format of PF/CGUDTAPD for use as a parameter

     D/COPY CGCPYSRC,CGPACKIILE

      **  DS to store subroutine specific data.
      **  - Saved Path

     D ##PATH          DS                  OCCURS(20)
     D  ##GRPS                 1      6

     D ##BIND          DS                  OCCURS(20)
     D  ##PBIN                 1      6  0 INZ(1)
     D  ##TBIN                 7     12  0 INZ(1)

     D                 DS
     D  #@BIND                 1      6  0 INZ(1)

     D #PDS            DS
     D  P1                     1      3  0 INZ(0)
     D  P2                     4      6  0
     D  P3                     7      9  0
     D  P4                    10     12  0
     D  P5                    13     15  0

     D                 DS
     D  ACUP                   1      7P 0
     D  ##WCUP                 1      7P 2

     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** Temporary DS for SDHSDRTD

     D DlyDS           DS
     D DintStart                      5p 0
     D DintEnd                        5p 0
     D Dintd                          5p 0
     D Dindy                          5p 0
     D Dobdt                          5p 0
     D Dobdy                          5p 0
     D Dbrfr                         17p12
     D Drtap                         17p12
     D Dcalm                          4a
     D Davcr                         17p12
     D Dcmrt                         17p12
     D Dsmav                         17p12

     DWPLON            S              6
     DWSDAT            S              5  0
     D P1LNRF          S              6A

     I/EJECT

     ICLOANCLF
      ** Rename fields of CLOANCL
     I              RECI                        ##RECI
     I              LNRF                        ##LNRF
     I              RCDT                        ##RCDT
     I              MRIN                        ##MRIN
     I              PTYP                        ##PTYP
     I              CNUM                        ##CNUM
     I              BRCA                        ##BRCA
     I              LTYP                        ##LTYP
     I              SUTP                        ##SUTP
     I              DDAT                        ##DDAT
     I              VDAT                        ##VDAT
     I              MDAT                        ##MDAT
     I              LASQ                        ##LASQ
     I              FCUS                        ##FCUS
     I              FTYP                        ##FTYP
     I              FSEQ                        ##FSEQ
     I              CCY                         ##CCY1
     I              CPAM                        ##CPAM
     I              INTC                        ##INTC
     I              INTR                        ##INTR
     I              BRTT                        ##BRTT
     I              BRTE                        ##BRTE
     I              RTSP                        ##RTSP
     I              MARG                        ##MARG
     I              SPIN                        ##SPIN
     I              CHIN                        ##CHIN
     I              WTRT                        ##WTRT
     I              WTIN                        ##WTIN
     I              REPT                        ##REPT
     I              RAMT                        ##RAMT
     I              NRPD                        ##NRPD
     I              RFRQ                        ##RFRQ
     I              RDYN                        ##RDYN
     I              FCCY                        ##FCCY
     I              LIND                        ##LIND
     I              CRSK                        ##CRSK
     I              ACOF                        ##ACOF
     I              NACD                        ##NACD
     I              RELI                        ##RELI
     I              AUTO                        ##AUT1
     I              PSAM                        ##PSAM
     I              BCXR                        ##BCXR
     I              FCXR                        ##FCXR
     I              SDST                        ##SDST
     I              OSDA                        ##OSDA
     I              TSTN                        ##TSTN
     I              MDST                        ##MDST
     I              OMDA                        ##OMDA
     I              TMAN                        ##TMAN
     I              FACO                        ##FACO
     I              RLDT                        ##RLDT
     I              NROD                        ##NROD
     I              RLFQ                        ##RLFQ
     I              RLDY                        ##RLDY
     I              RDFC                        ##RDFC
     I              NBRA                        ##NBRA
     I              NRTS                        ##NRTS
     I              NSIN                        ##NSIN
     I              NCAS                        ##NCAS
     I              AWTP                        ##AWTP
     I              WTRD                        ##WTRD
     I              WTWD                        ##WTWD
     I              IWOD                        ##IWOD
     I              PWOD                        ##PWOD
     I              BMDI                        ##BMDI
     I              FMDI                        ##FMDI
     I              PDIN                        ##PDIN
     I              LSWC                        ##LSWC
     I              LSWS                        ##LSWS
     I              OSDB                        ##OSDB
     I              OMDB                        ##OMDB
     I              ORBR                        ##ORBR
     I              PRFC                        ##PRFC
     I              FCLB                        ##FCLB
     I              MLNR                        ##MLNR
     I              BTIN                        ##BTIN
     I              BLDY                        ##BLDY
     I              OLNO                        ##OLNO
     I              RCSI                        ##RCSI
     I              ICBS                        ##ICBS
     I              IPFR                        ##IPFR
     I              TOTI                        ##TOTI
     I              NIDT                        ##NIDT
     I              IBDT                        ##IBDT
     I              SLID                        ##SLID
     I              AIPD                        ##AIPD
     I              DLRC                        ##DLRC
     I              IACD                        ##IACD
     I              AITC                        ##AITC
     I              TFEP                        ##TFEP
     I              AIAP                        ##AIAP
     I              IPRD                        ##IPRD
     I              IPRM                        ##IPRM
     I              ICTD                        ##ICTD
     I              AIMN                        ##AIMN
     I              RBDT                        ##RBDT
     I              NOPS                        ##NOPS
     I              NCHI                        ##NCHI
     I              IFDY                        ##IFDY
     I              LONI                        ##LONI
     I              CNFI                        ##CNFI
     I              ACEI                        ##ACEI
     I              TLXI                        ##TLXI
     I              CBLI                        ##CBLI
     I              ORED                        ##ORED
     I              LCD                         ##LCD
     I              CHTP                        ##CHTP
     I              TNLU                        ##TNLU
     I              ADDI                        ##ADDI
     I              ORMD                        ##ORMD
     I              ORTI                        ##ORTI
     I              BOKC                        ##BOKC
     I              COCU                        ##COCU
     I              RECE                        ##RECE
     I              OMDT                        ##OMDT
     I              NIPD                        ##NIPD
     I              NMDT                        ##NMDT
     I              APMI                        ##APMI
     I              RSTM                        ##RSTM
     I              RONS                        ##RONS
     I              RIBN                        ##RIBN
     I              RIBA                        ##RIBA
     I              ROBN                        ##ROBN
     I              ROCN                        ##ROCN
     I              PSTM                        ##PSTM
     I              PONS                        ##PONS
     I              PIBN                        ##PIBN
     I              PIBA                        ##PIBA
     I              POBN                        ##POBN
     I              POCN                        ##POCN
     I              RCRN                        ##RCRN
     I              RCRA                        ##RCRA
     I              RVNO                        ##RVNO
     I              AWBN                        ##AWBN
     I              AWBA                        ##AWBA
     I              BENN                        ##BENN
     I              BENA                        ##BENA
     I              DTP1                        ##DTP1
     I              DTP2                        ##DTP2
     I              DTP3                        ##DTP3
     I              DTP4                        ##DTP4
     I              DCHG                        ##DCHG
     I              BTB1                        ##BTB1
     I              BTB2                        ##BTB2
     I              BTB3                        ##BTB3
     I              BTB4                        ##BTB4
     I              BTB5                        ##BTB5
     I              BTB6                        ##BTB6
     I              CVMR                        ##CVMR
     I              PTFR                        ##PTFR
     I              SCCY                        ##STCY
     I              ADIF                        ##ADIF
     I              ADCF                        ##ADCF
     I              CHGA                        ##CHGA
     I              ICIF                        ##ICIF
     I              FLTI                        ##FLTI
     I              FRPD                        ##FRPD
     I              REXR                        ##REXR
     I              REXI                        ##REXI
     I              PSCY                        ##PSCY
     I              PEXR                        ##PEXR
     I              PEXI                        ##PEXI
     I              BASR                        ##BASR
     I              NBSR                        ##NBSR
     I              OCDT                        ##OCDT
     I              EAIR                        ##EAIR
     I              CNSP                        ##CNSP
     I              CNSG                        ##CNSG
     I              RDMT                        ##RDMT
     I              RDFD                        ##RDFD

     ICLOANCKF
      ** Rename fields of CLOANCK
     I              RECI                        ##RECI
     I              LNRF                        ##LNRF
     I              RCDT                        ##RCDT
     I              MRIN                        ##MRIN
     I              NAR1                        ##NAR1
     I              NAR2                        ##NAR2
     I              NAR3                        ##NAR3
     I              NAR4                        ##NAR4
     I              OPAM                        ##OPAM
     I              FRBC                        ##FRBC
     I              YPLN                        ##YPLN
     I              YFLN                        ##YFLN
     I              YWLN                        ##YWLN
     I              ABLN                        ##ABLN
     I              YPLC                        ##YPLC
     I              YFLC                        ##YFLC
     I              YWLC                        ##YWLC
     I              ABLC                        ##ABLC
     I              WWLN                        ##WWLN
     I              IWLN                        ##IWLN
     I              PWLN                        ##PWLN
     I              RDST                        ##RDST
     I              SPI1                        ##SPI1
     I              SPI2                        ##SPI2
     I              SPI3                        ##SPI3
     I              YILN                        ##YILN
     I              F57U                        ##F57U
     I              ORVD                        ##ORVD
     I              THRN                        ##THRN
     I              NPRAM                       ##NPAM
     I              NDAM                        ##NDAM
     I              RLBR                        ##RLBR
     I              ORED                        ##ORED
     I              LCD                         ##LCD
     I              CHTP                        ##CHTP
     I              TNLU                        ##TNLU

      *
      **  Data structure for SAR data.
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Process     :  MAINLINE                                      *
      *  Function    :  Mainline Processing                           *
      *                                                               *
      *****************************************************************

      **  Parameter list for current program invocation.

     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    W0CMT             3
     C                   PARM                    ##COPD            1
     C                   PARM                    XXLNRF            6
     C                   PARM                    XCINPSD           5 0

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)

      **  Initial processing - Once Only.

     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF

      **  Initialisation processing.

     C                   EXSR      SRINZF

      **  Main processing.

     C                   EXSR      SRMAIN

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

      **  Terminate program.

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  SRMAIN                                        *
      *  Function    :  Main Processing                               *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     SRMAIN        BEGSR                                                  ** SRMAIN **

      **  Set up subroutine stack name.

     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)

      **  Obtain Detail Information.

     C                   EXSR      SRDETL

      *
      **  Generate reference number by writing to PF/CGUDCRPD.
      **  If no confirmation to be produced, then bypass.

     C                   MOVE      'N'           ##COPD
     C                   EXSR      SRGENR
     C     ##COPD        CABEQ     'N'           EXMAIN

      **  Extract.

     C                   EXSR      LINTCF

     C     EXMAIN        TAG

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     SRMAI9        ENDSR                                                  ** SRMAI9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  SRDETL                                        *
      *  Function    :  Obtain Detail Information                     *
      *                                                               *
      *****************************************************************

     C     SRDETL        BEGSR                                                  ** SRDETL **

     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'DETAIL'      @STK(Q)
     C*
     C     KCLOAN        KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    RCDT
     C*
     C                   MOVEL     XXLNRF        LNRF              6
     C                   MOVEL     'A'           RCDT
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ************
     C                   MOVEL     LNRF          W0KEY                          * DBERR 01 *
     C                   Z-ADD     1             W0ERNB                         ************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *                                                                                      BUG7960
     C                   MOVE      *BLANK        WOLN70            1
     C     ##PTYP        IFEQ      72
     C                   MOVEL     LNRF          WOLNRF            6
     C                   MOVE      ##OLNO        LNRF
     C                   MOVEL     'A'           RCDT              1
      *                                                                                      BUG7960
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE
     C                   MOVEL     LNRF          W0KEY
     C                   Z-ADD     17            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                      BUG7960
     C     ##PTYP        IFEQ      70
     C                   MOVE      'Y'           WOLN70
     C                   ENDIF
      *                                                                                      BUG7960
      ** Re-chain to get original loan details                                               BUG7960
     C                   MOVEL     WOLNRF        LNRF
     C                   MOVEL     'A'           RCDT              1
      *                                                                                      BUG7960
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE
     C                   MOVEL     LNRF          W0KEY
     C                   Z-ADD     18            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      *BLANK        WOLN70            1
     C     ##PTYP        IFEQ      72
     C                   MOVEL     LNRF          WOLNRF            6
     C                   MOVE      ##OLNO        LNRF
     C                   MOVEL     'A'           RCDT              1
      *
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ************
     C                   MOVEL     LNRF          W0KEY                          * DBERR 14 *
     C                   Z-ADD     14            W0ERNB                         ************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     ##PTYP        IFEQ      70
     C                   MOVE      'Y'           WOLN70
     C                   ENDIF
      *
      ** Rechain CLOANCL to get original loan details
      *
     C                   MOVEL     WOLNRF        LNRF
     C                   MOVEL     'A'           RCDT              1
      *
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ************
     C                   MOVEL     LNRF          W0KEY                          * DBERR 15 *
     C                   Z-ADD     15            W0ERNB                         ************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
     C*
     C                   MOVEL     'B'           RCDT
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ************
     C                   MOVEL     LNRF          W0KEY                          * DBERR 02 *
     C                   Z-ADD     2             W0ERNB                         ************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRDET9        ENDSR                                                  ** SRDET9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRGENR                                        *
     C*  Function    :  Generate reference number by writing to       *
     C*                 PF/CGUDCRPD                                   *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  CG9010 - Create Item Reference Records        *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRGENR        BEGSR                                                  ** SRGENR **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRGENR'      @STK(Q)
     C*
     C**  Generate reference number and check if further processing
     C**  required. Set up all available information in the record
     C**  format before calling.
     C*
     C                   CLEAR                   ##UDCR
     C*
     C**  Booking/Main Branch (Mandatory).
     C*
     C                   MOVEL     ##BRCA        DRBRCA
     C*
     C**  Originating Branch (Optional).
     C*
     C                   MOVEL     ##ORBR        DRORBR
     C*
     C**  Module identifier (Mandatory).
     C*
     C                   MOVEL     'LE'          DRMODI
     C*
     C**  Midas Transaction Number (Mandatory).
     C*
     C                   MOVEL     LNRF          DRMTRN
     C*
     C**  Midas GL Account Reference CNUMCCYACODACSQBRCA  (Optional).
     C*
     C                   MOVEL     *BLANKS       DRMACT
     C*
     C**  Print Type.
     C*
     C                   MOVEL     W#PTYP        DRPTYP
     C*
     C**  Print Sub-type.
     C*
     C                   SELECT
     C     ##PTYP        WHENEQ    61
     C                   MOVEL     W#PST1        DRPSTP
     C     ##PTYP        WHENEQ    62
     C                   MOVEL     W#PST2        DRPSTP
     C     ##PTYP        WHENEQ    64
     C                   MOVEL     W#PST3        DRPSTP
     C     ##PTYP        WHENEQ    66
     C                   MOVEL     W#PST4        DRPSTP
     C     ##PTYP        WHENEQ    70
     C                   MOVEL     W#PST6        DRPSTP
     C     ##PTYP        WHENEQ    63
     C                   MOVEL     W#PST7        DRPSTP
     C     ##PTYP        WHENEQ    65
     C                   MOVEL     W#PST8        DRPSTP
     C     ##PTYP        WHENEQ    67
     C                   MOVEL     W#PST9        DRPSTP
     C     ##PTYP        WHENEQ    68
     C                   MOVEL     W#PSTA        DRPSTP
     C     ##PTYP        WHENEQ    69
     C                   MOVEL     W#PSTB        DRPSTP
     C     ##PTYP        WHENEQ    71
     C                   MOVEL     W#PSTC        DRPSTP
     C     ##PTYP        WHENEQ    72
     C     WOLN70        IFEQ      'Y'
     C                   MOVEL     W#PSTD        DRPSTP
     C                   ELSE
     C                   MOVEL     W#PSTE        DRPSTP
     C                   ENDIF
     C     ##PTYP        WHENEQ    80
     C     CLE028        ANDEQ     'Y'
     C                   MOVEL     W#PST5        DRPSTP
     C     ##PTYP        WHENEQ    70
     C                   MOVEL     W#PS14        DRPSTP
     C     ##PTYP        WHENEQ    63
     C                   MOVEL     W#PSTF        DRPSTP
     C     ##PTYP        WHENEQ    65
     C                   MOVEL     W#PSTG        DRPSTP
     C     ##PTYP        WHENEQ    67
     C                   MOVEL     W#PSTH        DRPSTP
     C     ##PTYP        WHENEQ    68
     C                   MOVEL     W#PSTI        DRPSTP
     C     ##PTYP        WHENEQ    69
     C                   MOVEL     W#PS10        DRPSTP
     C     ##PTYP        WHENEQ    71
     C                   MOVEL     W#PS11        DRPSTP
     C     ##PTYP        WHENEQ    72
     C     WOLN70        IFEQ      'Y'
     C                   MOVEL     W#PS12        DRPSTP
     C                   ELSE
     C                   MOVEL     W#PS13        DRPSTP
     C                   ENDIF
     C                   ENDSL
     C*
     C**  Auto Transmission indicator.
     C*
     C                   MOVEL     'N'           DRATRM
     C*
     C**  Cheque Reference (Optional).
     C*
     C                   MOVEL     *BLANKS       DRCHQR
     C*
     C**  Further Reference (Optional).
     C*
     C                   MOVEL     *BLANKS       DRFREF
     C*
     C**  Customer Number (Mandatory).
     C*
     C                   MOVEL     ##CNUM        ##CUST
     C*
     C                   CALL      'CG9010'
     C                   PARM                    ##RTCD            7
     C                   PARM      '*GEN'        ##MODE           10
     C                   PARM      W0CMT         ##CMT             3
     C                   PARM                    ##CUST            6
     C                   PARM                    ##UDCR
     C                   PARM                    ##ITMA            8
     C*
     C**  Blank return code implies generate correspondence.
     C**  CGD1270 => no error, but suppress output for this transaction.
     C*
     C     ##RTCD        IFEQ      *BLANK
     C*
     C                   MOVE      'Y'           ##COPD
      *
      ** If return code is blank, generate the 'begin' and 'end'
      ** New Extraction Records
      *
     C     DRPTYP        CAT(P)    ':':0         COLON            11
     C     COLON         CAT(P)    DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
     C*
     C                   ELSE
     C*
     C     ##RTCD        IFNE      'CGD1270'
     C                   MOVEL     'CG9010  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY                          ************
     C                   Z-ADD     3             W0ERNB                         * DBERR 03 *
     C                   MOVEL     'CGD1286'     W0MSGD                         ************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     EXGENR        TAG
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRGEN9        ENDSR                                                  ** SRGEN9 **
     C*
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  LINTCF                                        *
      *  Function    :  Lending LIBOR confirmation                    *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     LINTCF        BEGSR                                                  ** LINTCF **

     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LINTCF'      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'lINTCF'      ##GRPS
     C                   EXSR      SRPATH
      *
      ** Push Order (PF/CGUXMGPD)
      *
     C                   EXSR      PSHGRS

      * calling CG6001
     C                   EXSR      LOANA

      * retrieving settlement details
     C                   EXSR      SRSDET
     C                   Z-ADD     ##OSEQ        ##WSEQ
     C                   Z-ADD     ##PBIN        ##WPBN
     C                   Z-ADD     ##TBIN        ##WTBN
     C                   ADD       1             ##OSEQ

      * extracting LIBOR repeating details LIBORD becomes LIBORD
     C                   EXSR      LIBORD
     C                   Z-ADD     ##WSEQ        ##OSEQ
     C                   Z-ADD     ##WPBN        ##PBIN
     C                   Z-ADD     ##WTBN        ##TBIN

      * extracting main loan details
     C                   EXSR      LOANIX

      * extracting main interest details
     C                   EXSR      L@IPY

      **  Decrement Path DS index.

     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Pop Order (PF/CGUXMGPD)
      *
     C                   EXSR      POPGRS

     C**  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     LINTN9        ENDSR                                                  ** LINTN9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  LOANIX                                        *
      *  Function    :  Process Loan Interest Summary                 *
      *                                                               *
      *****************************************************************

     C     LOANIX        BEGSR                                                  ** LOAN   **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'LOAN  '      @STK(Q)

     C                   ADD       1             P1

     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOAN  '      ##GRPS
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS

     C                   Z-ADD     0             R1                3 0

     C**  Base Rate Name.

     C     ##BRTT        IFEQ      *BLANKS
     C                   MOVEL     *BLANKS       ##BSRN           30
     C                   ELSE

     C                   MOVEL     ##BRTT        ##BSRC
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      ##CCY1        ##CYCD            3
     C                   PARM                    ##BSRC            2
     C     SDBSRT        PARM      SDBSRT        DSSDY

     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBSRTPD'    W0FILE
     C     ##CYCD        CAT       ##BSRC        W0KEY                          ************
     C                   Z-ADD     4             W0ERNB                         * DBERR 04 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END

     C                   MOVEL     BABSRN        ##BSRN

     C                   END

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BASERATN'    #@RDE
     C                   MOVE      'AM'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##BSRN        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Base Rate Type.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BASERATT'    #@RDE
     C                   MOVE      'YP'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##BRTT        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Currency Description.

     C                   MOVEL     ##CCY1        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6CYNM        ##WRK            14

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CCY_DESC'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##WRK         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Current Principal (Amount).

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR PRIN'    #@RDE
     C                   MOVE      'CL'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##CPAM        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     ##CCY1        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Currency.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CURRENCY'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##CCY1        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Deal Date.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'DEAL DAT'    #@RDE
     C                   MOVE      'E '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##DDAT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Interest Calculation Basis.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT CALB'    #@RDE
     C                   MOVE      'AS'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##ICBS        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Interest capitalization indicator.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT CAP '    #@RDE
     C                   MOVE      'IN'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##INTC        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Interest Rate.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT RATE'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##INTR        ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Loan Reference.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOAN REF'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LNRF          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Maturity Date.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'MATUR DA'    #@RDE
     C                   MOVE      'TE'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##MDAT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Run date; production time.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RUNDAT  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BJRDNB        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

     C**  Spread.

     C     ##SPIN        IFEQ      'A'
     C                   Z-ADD     ##RTSP        ##SPRD           11 7
     C                   ELSE
     C                   Z-SUB     ##RTSP        ##SPRD
     C                   END

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'SPREAD  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##SPRD        ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Value Date.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'VALUE DA'    #@RDE
     C                   MOVE      'TE'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##VDAT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C

      **  Interest Amount
      **  If loan is matured get INTA from MA record
     C                   eval      XINTA = 0
     C                   if        ##RECI = 'M'
     C/EXEC SQL
     C+ SELECT INTA into :XINTA
     C+ from HISTSHP
     C+ where AMTP = 'MA' and LNRF = :XXLNRF
     C/END-EXEC
     C                   else
      **  If loan is is not matured get INTA from IN record if REPT is 2 or RE record
      **  using CINPDT (retrieved in SR LIBREV) + 1
     C                   if        ##REPT = 2
     C/EXEC SQL
     C+ SELECT INTA into :XINTA
     C+ from HISTSHP
     C+ where AMTP = 'IN' and LNRF = :XXLNRF and VDAT = :BJRDNB
     C/END-EXEC
     C                   else
     C/EXEC SQL
     C+ SELECT INTA into :XINTA
     C+ from HISTSHP
     C+ where AMTP = 'RE' and LNRF = :XXLNRF and VDAT = :BJRDNB
     C/END-EXEC
     C                   endif
     C                   endif

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INTEREST'    #@RDE
     C                   MOVE      ' A'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     XINTA         ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     ##CCY1        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

     C**  Accumulate RDEs and associated data and output to PF/CGUDTPD.

     C                   EXSR      SRADTA
     C                   EXSR      SRODTA

      **  Decrement Path DS index.

     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1

      ** Pop Order (PF/CGUXMGPD)

     C                   EXSR      POPGRS

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     LOANI9        ENDSR                                                  ** LOANI9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  LIBORD                                        *
      *  Function    :  Process Loan Interest Details                 *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     LIBORD        BEGSR                                                  ** LIBORD **

      **  Set up subroutine stack name.
      *
     C                   ADD       1             Q
     C                   MOVEL     'LIBORD'      @STK(Q)

     C                   ADD       1             P1

     C                   MOVE      'Y'           ##WHDR            1

     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LIBORD'      ##GRPS
     C                   EXSR      SRPATH

      ** Push Order (PF/CGUXMGPD)

     C                   EXSR      PSHGRS

     C                   EXSR      SRBIND

     C                   eval      XCINPDT = 0
     C/exec SQL
     C+ declare SDHS cursor for
     C+ select
     C+   CINPSD
     C+ , CINPED
     C+ , CINPDT
     C+ , CINPDY
     C+ , COBPDT
     C+ , COBPDY
     C+ , CPBRFR
     C+ , CRTEAP
     C+ , CCALCM
     C+ , CAVCRT
     C+ , CDCMRT
     C+ , CSMPAV
     C+ from SDHSDRTD
     C+ where
     C+     CMODID = 'LE'
     C+ and CTRNID = :XXLNRF
     C+ and CINPSD = :XCINPSD
     C+ order by
     C+     CINPDT asc
     C/end-exec

     C/exec SQL
     C+ open SDHS
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from SDHS
     C+ into :DlyDS
     C/end-exec

     C                   DOW       SQLCOD <> 100
     C                   eval      XCINPDT = Dintd
     C                   EXSR      LIBOR

     C/exec SQL
     C+ fetch next
     C+ from SDHS
     C+ into :DlyDS
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close SDHS
     C/end-exec

      **  Decrement Path DS index AND recreate path

     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS

     C                   MOVEL(P)  'LIBORD'      ##GRPS
     C                   EXSR      SRPATH

      **  Reset Binding information

     C     P1            OCCUR     ##BIND


      **  Decrement Path DS index.

     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1

      ** Pop Order (PF/CGUXMGPD)

     C                   EXSR      POPGRS

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     LOAND9        ENDSR                                                  ** LOAND9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  LIBOR                                         *
      *  Function    :  Process Loan Events                           *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     LIBOR         BEGSR                                                  ** LIBOR **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'LIBOR '      @STK(Q)

     C                   ADD       1             P1

     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LIBOR '      ##GRPS
     C                   EXSR      SRPATH

      ** Push Order (PF/CGUXMGPD)

     C                   EXSR      PSHGRS

     C                   EXSR      SRBIND
     C                   EXSR      LIBREV

      **  Store summary details in work fields for later use in
      **  Interest summary details extract.

      **  Decrement Path DS index.

     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1

      ** Pop Order (PF/CGUXMGPD)

     C                   EXSR      POPGRS

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     LOANE9        ENDSR                                                  ** LOANE9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  LIBREV                                        *
      *  Function    :  Process Loan Event Details                    *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     LIBREV        BEGSR                                                  ** LOANEV **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'LIBREV'      @STK(Q)

     C                   ADD       1             P1

     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LIBREV'      ##GRPS
     C                   EXSR      SRPATH

      ** Push Order (PF/CGUXMGPD)

     C                   EXSR      PSHGRS

     C                   Z-ADD     0             R1                3 0

      **  Interest Period Start Date

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT PRD '    #@RDE
     C                   MOVE      'ST'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     DintStart     ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Interest Period End Date

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT PRD '    #@RDE
     C                   MOVE      'ED'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     DintEnd       ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Interest Period Date

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT PRD '    #@RDE
     C                   MOVE      'DT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dintd         ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Interest Period Days

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT PRD '    #@RDE
     C                   MOVE      'DS'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dindy         ##DATA
     C                   MOVEL     'Number'      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Observation Period Date

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'OBS PRD '    #@RDE
     C                   MOVE      'DT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dobdt         ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Observation Period Days

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'OBS PRD '    #@RDE
     C                   MOVE      'DS'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dobdy         ##DATA
     C                   MOVEL     'Number'      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Published Risk Free Rate

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RSK FREE'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dbrfr         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '9'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Rate Applied

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RATE APP'    #@RDE
     C                   MOVE      'LD'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Drtap         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '9'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Calculation Method
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CALC MET'    #@RDE
     C                   MOVE      'HD'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dcalm         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Average Compounded Rate

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'AVG CMP '    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Davcr         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '9'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Daily Compounded Rate

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'DLY CMP '    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dcmrt         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '9'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Simple Average

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'SMPL AVR'    #@RDE
     C                   MOVE      'G '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dsmav         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '9'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  All-in-rate                                                                       MD059552
      * If Floor rate is greater than Risk free rate, use Floor, else Risk Free rate        MD059552
     C                   eval      XALLINR = 0                                              MD059552
     C                   if        Flor > Dbrfr                                             MD059552
     C                             and Flor <> 9999.9999999                                 MD059552
     C                   eval      XALLINR = Flor                                           MD059552
     C                   else                                                               MD059552
     C                   eval      XALLINR = Dbrfr                                          MD059552
     C                   endif                                                              MD059552
                                                                                            MD059552
      * then add the Spread                                                                 MD059552
     C     ##SPIN        IFEQ      'A'                                                      MD059552
     C                   eval      XALLINR = XALLINR + ##RTSP                               MD059552
     C                   ELSE                                                               MD059552
     C                   eval      XALLINR = XALLINR - ##RTSP                               MD059552
     C                   END                                                                MD059552
                                                                                            MD059552
      * and finally add Benchmark                                                           MD059552
     C                   eval      XALLINR = XALLINR + BADJ                                 MD059552
                                                                                            MD059552
     C                   ADD       1             R1                                         MD059552
     C                   CLEAR                   R#DATA                                     MD059552
     C                   CLEAR                   R#DEFN                                     MD059552
     C                   CLEAR                   #@RDE                                      MD059552
     C                   MOVEL     'ALLINRAT'    #@RDE                                      MD059552
     C                   MOVE      'E '          #@RDE                                      MD059552
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD059552
     C                   MOVEL     XALLINR       ##DATA                                     MD059552
     C                   MOVEL     'Rate  '      ##RDEC                                     MD059552
     C                   MOVEL     'L'           ##RDET                                     MD059552
     C                   MOVEL     '9'           ##DCPA                                     MD059552
     C                   MOVEL     R#DATA        ##D(R1)                                    MD059552
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD059552
                                                                                            MD059552
      **  Accumulate RDEs and associated data and output to PF/CGUDTPD.

     C                   EXSR      SRADTA
     C                   EXSR      SRODTA

      **  Decrement Path DS index.

     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1

      ** Pop Order (PF/CGUXMGPD)

     C                   EXSR      POPGRS

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     LOANV9        ENDSR                                                  ** LOANV9 **
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  LOANA                                         *
      *  Function    :  Loan Associated Details                       *
      *                                                               *
      *****************************************************************

     C     LOANA         BEGSR                                                  ** LOANA  **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'LOANA '      @STK(Q)

     C                   EXSR      SRPATH

     C                   MOVEL     S#PATH        P2PARM
     C                   Z-ADD     ##OSEQ        P1OSEQ
     C                   Z-ADD     ##ITEM        P1ITEM
     C                   Z-ADD     ##TBIN        P1TBIN
     C                   Z-ADD     ##PBIN        P1PBIN

     C**  Set up data.
     C*
     C                   CLEAR                   P4PARM
     C                   MOVE      *BLANKS       P@CNAM
     C                   MOVE      LNRF          P@LNRF
     C                   CALL      'CG6001'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    W0CMT             3
     C                   PARM                    P1PARM                         UDC Details
     C                   PARM                    P2PARM          140            Path Details
     C                   PARM                    P@PARM                         Loan Details
     C                   PARM                    P4PARM                         Facility Details
     C                   PARM                    ##AUTO            1
     C                   PARM                    ##REFR
     C                   PARM                    P@ICR
     C                   PARM      'N'           ##MAST

      **  Reset Sequence number.

     C                   Z-ADD     P1OSEQ        ##OSEQ

     C     EXXPAY        TAG

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     LOANA9        ENDSR                                                  ** LOANA9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  SRSDET                                        *
      *  Function    :  Set-up settlement details                     *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     SRSDET        BEGSR                                                  ** SRSDET **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'SRSDET'      @STK(Q)

     C                   ADD       1             P1

     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'L_SETL'      ##GRPS
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS

     C                   MOVEL     S#PATH        P2PARM

      **  Setup the parameters for CG99LSET.

     C                   CLEAR                   P0PARM
     C                   MOVEL     ##OSDB        P0POBR
     C                   MOVEL     ##OMDB        P0ROBR
     C                   Z-ADD     ##RSTM        P0RSTM
     C                   MOVEL     ##RONS        P0RONS
     C                   MOVEL     ##RIBN        P0RIBN
     C                   MOVEL     ##RIBA        P0RIBA
     C                   MOVE      ##ROBN        P0ROBN
     C                   MOVE      ##ROCN        P0ROCN
     C                   Z-ADD     ##PSTM        P0PSTM
     C                   MOVEL     ##PONS        P0PONS
     C                   MOVEL     ##PIBN        P0PIBN
     C                   MOVEL     ##PIBA        P0PIBA
     C                   MOVE      ##POBN        P0POBN
     C                   MOVE      ##POCN        P0POCN
     C                   MOVEL     ##RCRN        P0RCRN
     C                   MOVEL     ##RCRA        P0RCRA
     C                   MOVEL     ##RVNO        P0RVNO
     C                   MOVEL     ##AWBN        P0AWBN
     C                   MOVEL     ##AWBA        P0AWBA
     C                   MOVEL     ##BENN        P0BENN
     C                   MOVEL     ##BENA        P0BENA
     C                   MOVEL     ##DTP1        P0DTP1
     C                   MOVEL     ##DTP2        P0DTP2
     C                   MOVEL     ##DTP3        P0DTP3
     C                   MOVEL     ##DTP4        P0DTP4
     C                   MOVEL     ##DCHG        P0DCHG
     C                   MOVEL     ##BTB1        P0BTB1
     C                   MOVEL     ##BTB2        P0BTB2
     C                   MOVEL     ##BTB3        P0BTB3
     C                   MOVEL     ##BTB4        P0BTB4
     C                   MOVEL     ##BTB5        P0BTB5
     C                   MOVEL     ##BTB6        P0BTB6
     C                   MOVEL     ##SPI1        P0SPI1
     C                   MOVEL     ##SPI2        P0SPI2
     C                   MOVEL     ##SPI3        P0SPI3
     C                   MOVEL     ##STCY        P0STCY
     C                   MOVEL     ##STCY        P0PSCY

     C                   Z-ADD     ##OSEQ        P1OSEQ
     C                   Z-ADD     ##ITEM        P1ITEM
     C                   Z-ADD     ##TBIN        P1TBIN
     C                   Z-ADD     ##PBIN        P1PBIN

     C                   CALL      'CG99LSET'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    W0CMT             3
     C                   PARM                    ##COPD
     C                   PARM                    P1PARM
     C                   PARM                    P2PARM          140
     C                   PARM                    PDETLS
     C                   PARM                    P0PARM
     C                   PARM                    ##REFR
     C                   PARM                    P@ICR
     C                   PARM      'N'           ##MAST

     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     'CG99LSET'    W0FILE
     C                   MOVEL     'W0RTN'       W0KEY                          ************
     C                   Z-ADD     4             W0ERNB                         * DBERR 04 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END

      **  Reset Sequence number.

     C                   Z-ADD     P1OSEQ        ##OSEQ

      **  Decrement Path DS index

     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1

     C                   EXSR      POPGRS

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     SRSDE9        ENDSR                                                  ** SRSDE9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  SRINZF                                        *
      *  Function    :  Initialise Fields on Each Invocation          *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     SRINZF        BEGSR                                                  ** SRINZF **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'SRINZF'      @STK(Q)

      **  Initialise work fields.

     C                   Z-ADD     *ZEROS        ##W050            5 0
     C                   Z-ADD     *ZEROS        ##W150           15 0
     C                   Z-ADD     *ZEROS        ##W157           15 7
     C                   Z-ADD     *ZEROS        #1                6 0
     C                   Z-ADD     *ZEROS        #2                6 0
     C                   Z-ADD     *ZEROS        #3                6 0
     C                   MOVE      *BLANKS       S#PATH          256
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
     C     *LIKE         DEFINE    DEOSEQ        ##WSEQ
     C     *LIKE         DEFINE    DEPBIN        ##WPBN
     C     *LIKE         DEFINE    DETBIN        ##WTBN

     C                   MOVE      *OFF          *IN40

      **  Initialise output sequence (to CGUDTAPD).

     C                   Z-ADD     *ZEROS        ##OSEQ

      **  DJU Additions for CG4999 1st version.

     C                   MOVE      *BLANKS       #@RDE            10
     C     *LIKE         DEFINE    ##TBIN        #@TBIN

     C     1             OCCUR     ##BIND
     C                   RESET                   ##BIND
     C                   RESET                   #@BIND
     C                   RESET                   #PDS

      ** Initialise XML increment

     C                   EXSR      INIXML

     C     EXINZ         TAG

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     SRINZ9        ENDSR                                                  ** SRINZ9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  SRINIT                                        *
      *  Function    :  Initial processing - On First Call            *
      *                                                               *
      *****************************************************************

     C     SRINIT        BEGSR                                                  ** SRINIT **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)

      ** Access SAR details file to determine if CEU014 is installed.

     C                   MOVEL     'N'           CEU014            1

     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CEU014'      ##SARD            6

     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU014
     C                   END

      ** Database Error

     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     13            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END

     C     CEU014        IFEQ      'Y'

      **  Call access program for General Ledger details
     C                   CALL      'AOGELRR1'
     C                   PARM      '*MSG   '     ##RTCD
     C                   PARM      '*FIRST '     ##OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      **  Database error
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'AOGELRR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     14            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF

      ** Check if Flat Rate Personal Loans (Rule of 78s) is installed.

     C                   MOVEL     'N'           CLE028            1

     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CLE028'      ##SARD

     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CLE028
     C                   ENDIF

     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CLE028'      W0KEY
     C                   Z-ADD     16            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF

      **  Retrieve Bank details.

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*FIRST  '    ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSSDY

     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBANKPD'    W0FILE
     C                   MOVEL     '*FIRST'      W0KEY                          ************
     C                   Z-ADD     5             W0ERNB                         * DBERR 05 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END

      ** Determine if Correspondence Manager Phase 1 Development
      ** on iSeries is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CCG015'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CCG015            1
     C                   ELSE
     C                   MOVE      'N'           CCG015

     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL(P)  '*CALL'       W0KEY
     C                   Z-ADD     15            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF

     C                   ENDIF

      ** Determine if CLE031 is Installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE031'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE031            1
     C                   ELSE
     C                   MOVE      'N'           CLE031

     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL(P)  '*CALL'       W0KEY
     C                   Z-ADD     15            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF

     C                   ENDIF

      ** Check if CLE143 is ON

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY '    ##OPTN
     C                   PARM      'CLE143'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     ##RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE143            1
     C                   ELSE
     C                   MOVE      'N'           CLE143
     C                   ENDIF

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY '    ##OPTN
     C                   PARM      'CLE005'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     ##RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005            1
     C                   ELSE
     C                   MOVE      'N'           CLE005
     C                   ENDIF

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY '    ##OPTN
     C                   PARM      'CLE036'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     ##RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE036            1
     C                   ELSE
     C                   MOVE      'N'           CLE036
     C                   ENDIF

      ** Check if CER049 is ON

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM      'CER049'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     ##RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           CER049            1
     C                   ELSE
     C                   MOVE      'N'           CER049

     C     ##RTCD        IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CER049'      W0KEY                          *************
     C                   Z-ADD     19            W0ERNB                         * DB ERROR 17
     C                   MOVEL     'MEM5003'     W0MSGD                         *************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF

     C                   ENDIF

      ** Access SAR details file to determine if CER050 is installed.

     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CER050'      ##SARD

     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CER050            1
     C                   ELSE
     C                   MOVEL     'N'           CER050
     C                   END

      ** Access SAR details file to determine if CLE172 is installed.

     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CLE172'      ##SARD

     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CLE172            1
     C                   ELSE
     C                   MOVEL     'N'           CLE172
     C                   END

     C     BJDFIN        COMP      'M'                                    98    MMDDYY, 98 ON

      **  Determine Number of decimal places - Base currency.

     C                   MOVEL     BJCYCD        ##CCY
     C                   EXSR      SRDCDT
     C                   Z-ADD     A6NBDP        BASCDP            1 0

      **  Copyright Statement.

     C                   MOVEA     CPY@          ACT@             80

     C     EXINIT        TAG

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     SRINI9        ENDSR                                                  ** SRINI9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  SRADTA                                        *
      *  Function    :  Accumulate RDEs and Associated Data           *
      *                                                               *
      *****************************************************************

     C     SRADTA        BEGSR                                                  ** SRADTA **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'SRADTA'      @STK(Q)

      **  Reformat RDE data.

     C                   EXSR      SRRFMN

      ** If CCG015 is installed move '*NEWARR' to W0ACT
      ** else move '*PACK'.

     C     CCG015        IFEQ      'Y'
     C                   MOVEL     '*NEWARR '    W0ACT
     C                   MOVEL     S#PATH        W0SPAT
     C                   ELSE
     C                   MOVEL     '*PACK   '    W0ACT
     C                   MOVEL     *BLANK        W0SPAT
     C                   ENDIF

      **  Pack RDEs and associated data into data string.

     C                   CLEAR                   ##SDS
     C                   CALL      'CG3999'
     C                   PARM      *BLANK        ##RTCD
     C                   PARM                    W0ACT
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT           70
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM

     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'CG3999  '    W0FILE                         ************
     C                   MOVEL     ##RTCD        W0KEY                          * DBERR 06 *
     C                   Z-ADD     6             W0ERNB                         ************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF

     C                   EXSR      WRTRDE

      **  Append Data from pack routine.

     C     #@SDS         CAT       ##SDS:0       #@SDS
     C                   MOVEL     *BLANK        ##R
     C                   MOVEL     *BLANK        ##D
     C                   MOVEL     *BLANK        ##S

     C     EXADTA        TAG

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     SRADT9        ENDSR                                                  ** SRADT9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  SRODTA                                        *
      *  Function    :  Output Accumulated Data to CGUDTAPD           *
      *                                                               *
      *****************************************************************

     C     SRODTA        BEGSR                                                  ** SRODTA **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'SRODTA'      @STK(Q)

      **  Initialise Write Format Parameter.

     C                   CLEAR                   W0FMT

      **  Set up Control Information.

     C                   Z-ADD     ##ITEM        DEITEM
     C                   ADD       1             ##OSEQ
     C                   Z-ADD     ##OSEQ        DEOSEQ
     C                   Z-ADD     ##PBIN        DEPBIN
     C                   Z-ADD     ##TBIN        DETBIN
     C                   MOVE      'FR'          DEFSLI
     C                   MOVE      *BLANKS       W0PATH
     C                   MOVEL     S#PATH        W0PATH

      **  Append Data from pack routine.

     C     W0FMT         CAT       #@SDS:0       W0FMT
                                                                                              CCG015
     C     CCG015        IFEQ      'N'

      **  Output PF/CGUDTAPD Record.

     C                   CALL      'CG9020'
     C                   PARM      *BLANK        ##RTCD
     C                   PARM      '*WRITE  '    W0ACT
     C                   PARM                    W0PATH          256
     C                   PARM                    W0FMT
     C                   PARM      *BLANK        W0TITL            7
     C                   PARM      *BLANK        W0ULIN            7
     C                   PARM                    W0CMT

     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'CG9020  '    W0FILE                         ************
     C                   MOVEL     ##RTCD        W0KEY                          * DBERR 07 *
     C                   Z-ADD     7             W0ERNB                         ************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
                                                                                              CCG015
     C                   ENDIF

     C                   CLEAR                   #@SDS

     C     EXODTA        TAG

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     SRODT9        ENDSR                                                  ** SRODT9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  SRBIND                                        *
      *  Function    :  Generate Binding Numbers                      *
      *                                                               *
      *****************************************************************

     C     SRBIND        BEGSR                                                  ** SRBIND **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'SRBIND'      @STK(Q)

     C     P1            SUB       1             P2

     C     P2            OCCUR     ##BIND
     C                   Z-ADD     ##TBIN        #@TBIN

     C     P1            OCCUR     ##BIND
     C                   Z-ADD     #@TBIN        ##PBIN
     C                   ADD       1             #@BIND
     C                   Z-ADD     #@BIND        ##TBIN

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     SRBIN9        ENDSR                                                  ** SRBIN9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  SRPATH                                        *
      *  Function    :  Generate Path String                          *
      *                                                               *
      *****************************************************************

     C     SRPATH        BEGSR                                                  ** SRPATH **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'SRPATH'      @STK(Q)

     C                   CLEAR                   S#PATH

      **  Set up Path.

     C                   DO        P1            P2
     C     P2            OCCUR     ##PATH
     C     S#PATH        CAT       '\':0         S#PATH
     C     S#PATH        CAT       ##GRPS:0      S#PATH
     C                   END

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     SRPAT9        ENDSR                                                  ** SRPAT9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  SRRFMN                                        *
      *  Function    :  Reformat RDE Data                             *
      *                                                               *
      *****************************************************************

     C     SRRFMN        BEGSR                                                  ** SRRFMN **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'SRRFMN'      @STK(Q)

     C                   Z-ADD     0             #1

      **  Loop through RDE's and data.

     C     #1            DOUEQ     20

     C                   ADD       1             #1
     C                   MOVEL     ##R(#1)       R#DEFN
     C                   MOVEL     ##D(#1)       R#DATA

      **  If data present and RDE is edited.

     C     R#DATA        IFNE      *BLANK
     C     ##RDEC        ANDNE     *BLANK

      **  Reformat Amount.

     C                   Z-ADD     1             #2
     C     *BLANK        LOOKUP    ##NUMA(#2)                             99    *
     C                   Z-ADD     20            #3
     C                   Z-ADD     0             ##WNUM

     C     #2            DOWGT     1
     C     #2            ANDLE     20
     C     #3            ANDGT     1
     C                   SUB       1             #2
     C                   MOVEL     ##NUMA(#2)    ##W(#3)
     C                   SUB       1             #3
     C                   ENDDO

      **  Sign the amount.

     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     ##WNUM        ##NUMB
     C                   ELSE
     C                   Z-ADD     ##WNUM        ##NUMB
     C                   END

      **  Default Edit Type.

     C     ##EDTT        IFEQ      *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   END

      **  Default Decimal Places.

     C     ##DCPA        IFEQ      *BLANK
     C                   MOVEL     ##RDED        ##DCPA
     C                   END

      **  New RDE data.

     C                   MOVEL     R#DATA        ##D(#1)

     C                   ENDIF

     C                   ENDDO

     C     EXRFMN        TAG

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     SRRFM9        ENDSR                                                  ** SRRFM9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  SRDCDT                                        *
      *  Function    :  Determine Currency Details                    *
      *                                                               *
      *****************************************************************

     C     SRDCDT        BEGSR                                                  ** SRDCDT **

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'SRDCDT'      @STK(Q)

      **  Access array of Currency Details already loaded.

     C                   Z-ADD     1             C                 3 0
     C     ##CCY         LOOKUP    ##CY(C)                                99

      **  If no match is found determine the next free space in the
      **  loaded currency array.

     C     *IN99         IFEQ      *OFF

     C                   Z-ADD     1             C
     C     *BLANK        LOOKUP    ##CY(C)                                99

      **  If no space is left, set the Currency Data data structure to
      **  the 101st occurrence so that when the new details are
      **  retrieved no existing details are overwritten.

     C     *IN99         IFEQ      *OFF
     C     101           OCCUR     SDCURR

      **  If a space is found, set up the new currency into the array
      **  and position the Currency Data data structure on the
      **  occurrence matching the array index.

     C                   ELSE
     C                   MOVE      ##CCY         ##CY(C)
     C     C             OCCUR     SDCURR
     C                   ENDIF

      **  Retrieve the currency details.

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD                         B:Return Cd
     C                   PARM      '*KEY'        ##OPTN                         I:Option
     C                   PARM      ##CCY         ##CCYP            3            I:Currency Code
     C     SDCURR        PARM      *BLANK        DSSDY                          O:Format

     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     ##CCY         W0KEY                          ************
     C                   Z-ADD     8             W0ERNB                         * DBERR 08 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF

      **  If the currency has been retrieved earlier, position the
      **  Currency Data data structure on the relevant occurrence.

     C                   ELSE
     C     C             OCCUR     SDCURR
     C                   ENDIF

     C     EXDCDT        TAG

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     SRDCD9        ENDSR                                                  ** SRDCD9 **

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  L@IPY                                         *
      *  Function    :  Process Interest Payment details              *
      *                                                               *
     C*****************************************************************

     C     L@IPY         BEGSR                                                  ** L@IPY  **
      *                                                                                     MD059624
      ** Get rounding precision from SDLIBRTD                                               MD059624
      *                                                                                     MD059624
     C                   CALL      'ZAGETRDAPL'                                             MD059624
     C                   PARM                    RFRR                                       MD059624
     C                   PARM      'N'           isRndApplies      1                        MD059624
     C                   IF        isRndApplies = 'Y'                                       MD059624
     C                   MOVEL     'Y'           CCRRA             1                        MD059624
     C                   MOVEL     RRDP          CCRRP             2 0                      MD059624
     C                   Z-ADD     *ZEROS        CCRRD             2 0                      MD059624
     C                   ELSE                                                               MD059624
     C                   MOVEL     'N'           CCRRA                                      MD059624
     C                   MOVEL     RRDP          CCRRD                                      MD059624
     C                   Z-ADD     *ZEROS        CCRRP                                      MD059624
     C                   ENDIF                                                              MD059624

      **  Set up subroutine stack name.

     C                   ADD       1             Q
     C                   MOVEL     'L@IPY '      @STK(Q)

     C                   ADD       1             P1

     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'L_IPY '      ##GRPS
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS

     C                   Z-ADD     0             R1                3 0

      **  Interest Payment Day.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT DAY '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##IFDY        ##DATA
     C                   MOVEL     'Day   '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Interest Payment Frequency.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT FREQ'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##IPFR        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Next Interest Payment Date.

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'NXT IPDA'    #@RDE
     C                   MOVE      'TE'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##NIDT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Risk Free Rate

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RSK FREE'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     RFRR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Lookback days

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOOK BAC'    #@RDE
     C                   MOVE      'K '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LBDY          ##DATA
     C                   MOVEL     'Day   '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Lockout days

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOCK OUT'    #@RDE
     C                   MOVE      ' D'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LODY          ##DATA
     C                   MOVEL     'Day   '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Rate rounding decimals

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RT RDNG '    #@RDE
     C                   MOVE      'DC'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C**********         MOVEL     RRDP          ##DATA                                     MD059624
     C                   MOVEL     CCRRD         ##DATA                                     MD059624
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Day Basis for Average

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'DAYS B A'    #@RDE
     C                   MOVE      'VG'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     DBAV          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Floor

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'FLOOR   '    #@RDE
     C                   MOVE      '  '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FLOR          ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Observation Period Shift

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'OBS PER '    #@RDE
     C                   MOVE      'SH'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     OPSH          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Rates Known Indicator

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RT KWN I'    #@RDE
     C                   MOVE      'ND'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     RTKN          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Benchmark Adjustment

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BENCH AD'    #@RDE
     C                   MOVE      'J '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BADJ          ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Calculation Method
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CALC MET'    #@RDE
     C                   MOVE      'HD'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     CALM          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Next Repayment Date.                                                              MD059564
                                                                                            MD059564
     C                   ADD       1             R1                                         MD059564
     C                   CLEAR                   R#DATA                                     MD059564
     C                   CLEAR                   R#DEFN                                     MD059564
     C                   CLEAR                   #@RDE                                      MD059564
     C                   MOVEL     'NXT RPDA'    #@RDE                                      MD059564
     C                   MOVE      'TE'          #@RDE                                      MD059564
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD059564
     C                   MOVEL     ##NRPD        ##DATA                                     MD059564
     C                   MOVEL     'Date  '      ##RDEC                                     MD059564
     C                   MOVEL     R#DATA        ##D(R1)                                    MD059564
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD059564
      *                                                                                     MD059564
      ** Loan Narrative 1                                                                   MD059564
      *                                                                                     MD059564
     C                   ADD       1             R1                                         MD059564
     C                   CLEAR                   R#DATA                                     MD059564
     C                   CLEAR                   R#DEFN                                     MD059564
     C                   CLEAR                   #@RDE                                      MD059564
     C                   MOVEL(P)  'NARRAT_1'    #@RDE                                      MD059564
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD059564
     C                   MOVEL     ##NAR1        R#DATA                                     MD059564
     C                   MOVEL     R#DATA        ##D(R1)                                    MD059564
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD059564
      *                                                                                     MD059564
      ** Loan Narrative 2                                                                   MD059564
      *                                                                                     MD059564
     C                   ADD       1             R1                                         MD059564
     C                   CLEAR                   R#DATA                                     MD059564
     C                   CLEAR                   R#DEFN                                     MD059564
     C                   CLEAR                   #@RDE                                      MD059564
     C                   MOVEL(P)  'NARRAT_2'    #@RDE                                      MD059564
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD059564
     C                   MOVEL     ##NAR2        R#DATA                                     MD059564
     C                   MOVEL     R#DATA        ##D(R1)                                    MD059564
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD059564
      *                                                                                     MD059564
      ** Loan Narrative 3                                                                   MD059564
      *                                                                                     MD059564
     C                   ADD       1             R1                                         MD059564
     C                   CLEAR                   R#DATA                                     MD059564
     C                   CLEAR                   R#DEFN                                     MD059564
     C                   CLEAR                   #@RDE                                      MD059564
     C                   MOVEL(P)  'NARRAT_3'    #@RDE                                      MD059564
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD059564
     C                   MOVEL     ##NAR3        R#DATA                                     MD059564
     C                   MOVEL     R#DATA        ##D(R1)                                    MD059564
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD059564
      *                                                                                     MD059564
      ** Loan Narrative 4                                                                   MD059564
      *                                                                                     MD059564
     C                   ADD       1             R1                                         MD059564
     C                   CLEAR                   R#DATA                                     MD059564
     C                   CLEAR                   R#DEFN                                     MD059564
     C                   CLEAR                   #@RDE                                      MD059564
     C                   MOVEL(P)  'NARRAT_4'    #@RDE                                      MD059564
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD059564
     C                   MOVEL     ##NAR4        R#DATA                                     MD059564
     C                   MOVEL     R#DATA        ##D(R1)                                    MD059564
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD059564
      *                                                                                     MD059564
      **  ccr Rounding Applies                                                              MD059624
      *                                                                                     MD059624
     C                   ADD       1             R1                                         MD059624
     C                   CLEAR                   R#DATA                                     MD059624
     C                   CLEAR                   R#DEFN                                     MD059624
     C                   CLEAR                   #@RDE                                      MD059624
     C                   MOVEL     'CCR RD A'    #@RDE                                      MD059624
     C                   MOVE      'PL'          #@RDE                                      MD059624
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD059624
     C                   MOVEL     CCRRA         R#DATA                                     MD059624
     C                   MOVEL     R#DATA        ##D(R1)                                    MD059624
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD059624
      *                                                                                     MD059624
      **  ccr Rounding Precision                                                            MD059624
      *                                                                                     MD059624
     C                   ADD       1             R1                                         MD059624
     C                   CLEAR                   R#DATA                                     MD059624
     C                   CLEAR                   R#DEFN                                     MD059624
     C                   CLEAR                   #@RDE                                      MD059624
     C                   MOVEL     'CCR RD P'    #@RDE                                      MD059624
     C                   MOVE      'RC'          #@RDE                                      MD059624
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      MD059624
     C                   MOVEL     CCRRP         R#DATA                                     MD059624
     C                   MOVEL     R#DATA        ##D(R1)                                    MD059624
     C                   MOVEL     R#DEFN        ##R(R1)                                    MD059624
      *                                                                                     MD059624
     C     KLOAM         KLIST
     C                   KFLD                    WPLON
     C                   KFLD                    WSDAT
     C                   eval      WPLON = XXLNRF

      **  Accumulate RDEs and associated data and output to PF/CGUDTPD.

     C                   EXSR      SRADTA
     C                   EXSR      SRODTA

      **  Decrement Path DS index.

     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
     C                   EXSR      POPGRS

      **  Unwind subroutine stack name.

     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C     L@IPY9        ENDSR                                                  ** L@IPY9 **

     C*****************************************************************
     C/EJECT
     C/EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
     C/EJECT
     C/COPY CGCPYSRC,SRERRCLE
     C/EJECT
     C/COPY CGCPYSRC,CGNWEXCILE                                                               CCG015
     C/EJECT                                                                                  CCG015
** ##CPY  **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
