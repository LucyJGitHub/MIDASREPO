     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Create Postings from Stamp Tax keys')         *
     F*****************************************************************
     F*                                                               *
     F*  Midas - General Ledger                                       *
     F*                                                               *
     F*  GL008110 - Create Postings from Stamp Tax Keys               *
     F*                                                               *
     F*  (c) Finastra International Limited 2010                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD040971           Date 30Aug16               *
      *                 CLE148             Date 23Jul12               *
      *                 AR864045           Date 20Nov11               *
      *                 AR821972           Date 07Sep11               *
      *                 CER049  *CREATE    Date 06Dec10               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD040971 - GL0600 dumps due to account code set to zero.     *
      *             Call AOACODR0 with DSSFY instead as SDACODPD      *
      *             length is greated that 200.                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR864045 - Component GLC008140 00001 failed                  *
/*    *  AR821972 - Stamp tax on debit interest did not generate      *
/*    *             amount in GLVCLSIN (Recompile)                    *
     F*  CER049 - Stamp Tax                                           *
     F*                                                               *
     F*****************************************************************
     FGLVCLSL0  IP   E           K DISK
      *
      ** Extra Keys for Stamp Tax
      *
     FACKEY     IF   E           K DISK
     F                                     IGNORE(ACKEYAKF)
      *
      ** Account Keys File
      *
     FGLVCPSPD  UF A E             DISK
      *
      ** Extra postings for Stamp Tax
      *
     FGLPSUMPD  UF A E             DISK
     F                                     RENAME(APOSTPDF:@PSUMPPF)
      *
     FGLSTGEPD  O    E             DISK
     FGL008110P1O    E             PRINTER INFDS(SPOOL1)
      *
      ** Extra postings for Stamp Tax Summary
      *
      ********************************************************************
      *
      * ID C  F  H  L    Function of indicators
      *
      *    90            General Error
      *    91            End of Dealing Account Keys
      * U7U8LR           DB error
      *
     F********************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              copyright
     D/COPY ZSRSRC,ZSEDITZ1LE
      *
     D/EJECT
      *
      ** Data structure for ouput parameter
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      **  Data structure for bank file
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      **  Data structure for customer file
      *
     D SDBRCH        E DS                  OCCURS(10) EXTNAME(SDBRCHPD)
      **  Data structure for branch file
     D QQDFAC2       E                     EXTFLD(QQDFAC)
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      **  Data structure for general ledger details
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      **  Data structure for trading details
     D QQACCD2       E                     EXTFLD(QQACCD)
      *
     D SDACOD        E DS                  OCCURS(6) EXTNAME(SDACODPD)
      **  Data structure for trading details
     D QQACCD3       E                     EXTFLD(QQACCD)
      *
     D SDACCT        E DS                  OCCURS(5) EXTNAME(ACCNTAB)
      **  Data structure for Account details
     D  ACBRCA       E                     EXTFLD(BRCA)
     D  ACCNUM       E                     EXTFLD(CNUM)
     D  ACCCY        E                     EXTFLD(CCY)
     D  ACACOD       E                     EXTFLD(ACOD)
     D  ACACSQ       E                     EXTFLD(ACSQ)
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      **  Data structure for nostro details
     D QQACCD4       E                     EXTFLD(QQACCD)
      *
     D SDCURR        E DS                  OCCURS(2) EXTNAME(SDCURRPD)
      *
      **  Data structure for currency details
      *
     D SDNARR        E DS                  EXTNAME(SDNARRPD)
      **  Data structure for narrative details
      *
     D CGPNAR        E DS                  EXTNAME(CGPNARPD)
      ** UDC Multi Language Narrative data structure
      *
     D                 DS
     D  WORK15                 1     15  0
     D ##PRM1          DS
      **  Data Structure for Customer and Branch
      *
     D  A#CUST                 1      6
     D  A#BRCA                 7      9
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      **  Data structure for module ICD file
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      **  Data structure for switchable feature
     D  SCLCD        E                     EXTFLD(LCD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structure for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access programs
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      **  Local data area
      *
      **  Key details
      *
     D DACOD           DS            60
      ** Account codes
     D  ACD1                   1     10  0
     D  ACD2                  11     20  0
     D  ACD3                  21     30  0
     D  ACD4                  31     40  0
     D  ACD5                  41     50  0
     D  ACD6                  51     60  0
     D  ACD                    1     60  0
     D                                     DIM(6)
     D DNARR           DS            12
      ** Narrative codes
     D  NCD1                   1      2
     D  NCD2                   3      4
     D  NCD3                   5      6
     D  NCD4                   7      8
     D  NCD5                   9     10
     D  NCD6                  11     12
     D  NCD                    1     12
     D                                     DIM(6)
     D DPRF            DS             6
      ** Posting references
     D  PRF1                   1      1  0
     D  PRF2                   2      2  0
     D  PRF3                   3      3  0
     D  PRF4                   4      4  0
     D  PRF5                   5      5  0
     D  PRF6                   6      6  0
     D  PRF                    1      6  0
     D                                     DIM(6)
      *
     D DACSQ           DS            12
      ** Account Sequence Numbers
     D  ASQ1                   1      2
     D  ASQ2                   3      4
     D  ASQ3                   5      6
     D  ASQ4                   7      8
     D  ASQ5                   9     10
     D  ASQ6                  11     12
     D  ACS                    1     12
     D                                     DIM(6)
     D SPOOL1          DS
      *
      **  DS FOR P1 SPOOL FILE NAME
      *
     D  SFILE1                83     92
     D  SFNUM                123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D @OTAC           DS
     D  @OBRCA                 1      3
     D  @OCNUM                 4      9
     D  @OCCY                 10     12
     D  @OACOD                13     22
     D  @OACSQ                23     24
      *
     D OTACDS          DS
     D  OBRCA                  1      3
     D  FIL1                   4      4
     D  OCNUM                  5     10
     D  FIL2                  11     11
     D  OCCY                  12     14
     D  FIL3                  15     15
     D  OACOD                 16     25  0
     D  FIL4                  26     26
     D  OACSQ                 27     28  0
      *
      ** Parameter fields
      *
     D P0MODE          S              1
     D P0PSUM          S              1
     D U#DATE          S              5  0
     D U#FMT           S              1
     D U#DYNB          S              6  0
     D U#DMY           S              7
     D YEVDT           S              7
     D ##ACID          S             10
     D ##CUST          S              6
     D ##ACSN          S              2
     D ##BRCD          S              3
     D ##NONB          S              2
     D ##CSSN          S             10
     D ##PNOI          S              1
     D ##RTN           S              7
     D ##OPT           S              7
     D ##KCST          S             10
     D ##STS           S              7
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ##MGID          S              7
     D ##NARR          S             50
     D #DAYNO          S              5  0
     D #CCY            S              3
     D #LOC            S              3
     D #NRDYS          S              2  0
     D #DYNBR          S              5  0
     D @RTCD           S              7
     D @OPTN           S              7
     D @SARD           S              6
     D SEQNO           S              5
     D ENTY            S              3
     D ZSERR           S              1
      *
      ** Work fields
      *
     D #MKEY           S              1
     D #X              S              5  0
     D ##SUSP          S              1
     D ##RETA          S              1
     D ##TCR           S             18  0
     D ##TCRC          S             18  0
     D ##TDR           S             18  0
     D ##TDRC          S             18  0
     D W#NDAT          S              5  0
     D P#SDAT          S              5  0
     D W#SDAT          S              5  0
     D BIS@            S             80
     D REPNAR          S              1
     D ZSNUM           S              6  0
     D #FIRST          S              1
      *
      ** Currency Imbalance
      *
     D ##IMB           C                   CONST('Currency Imbalance')
     D ##INTB          C                   CONST('Interbranch Settle')
     I/EJECT
      *
      ** Define level break processing
      *
     I@VCLSV0
     I                                          BRCA          L3
     I                                          ECCY          L2
     I                                          AKEY          L1
      *
      ** Redefine account fields
      *
     IAPOSTPDF
     I              BRCA                        PSBRCA
     I              CNUM                        PSCNUM
     I              CCY                         PSCCY
     I              ACOD                        PSACOD
     I              ACSQ                        PSACSQ
     I              ACKEY                       PSACKY
     I@PSUMPPF
     I              BRCA                        PSBRCA
     I              CNUM                        PSCNUM
     I              CCY                         PSCCY
     I              ACOD                        PSACOD
     I              ACSQ                        PSACSQ
     I              ACKEY                       PSACKY
      *
      ** Redefine used fields
      *
     IACKEYALF
     I              RECI                        AKRECI
     I              AKEY                        AKAKEY
      *****************************************************************
      *                   Index to subroutines                        *
      *   main process                                                *
      *   SRINIT  - initial process                                   *
      *   SRDTYP  - Check Deal Type sub-type combination              *
      *   SRNKEY  - Create New keys                                   *
      *   *PSSR - error handling                                      *
      *****************************************************************
     C/EJECT
      *
     C     *ENTRY        PLIST
     C                   PARM                    P0MODE
     C                   PARM                    P0PSUM
      *
     C                   MOVE      '-'           FIL1
     C                   MOVE      '-'           FIL2
     C                   MOVE      '-'           FIL3
     C                   MOVE      '-'           FIL4
      *
     C     *LIKE         DEFINE    BRCA          K#BRCA
     C                   MOVEL     BRCA          K#BRCA
      *
      ** Main process
      *
     C     #FIRST        IFNE      'Y'
     C                   EXSR      SRINIT
     C                   ENDIF
      *
      ** If new key get key details
      *
     C     *INL1         IFEQ      *ON
     C                   EXSR      SRNKEY
     C                   ENDIF
      *
      ** If new currency get currency details
      *
     C     *INL2         IFEQ      *ON
     C                   EXSR      SRNCCY
     C                   ENDIF
      *
      ** If new branch get branch details
      *
     C     *INL3         IFEQ      *ON
     C                   EXSR      SRNBRC
     C                   ENDIF
      *
      ** Print Account Key Details
      *
     C                   EXSR      PRTDT2
      *
      ** Process records
      *
     C     #MKEY         IFEQ      'N'
     C                   EXSR      SRPOST
     C                   ENDIF
      *
      ** If change of currency see if balanced
      *
     CL2                 EXSR      SRLCCY
      *
      ** If change of branch see if balanced
      *
     CL3                 EXSR      SRLBRC
      *
      ** If last record update trailer
      *
     CLR                 EXSR      SREND
      *
      ** End Main process
      *
     C/EJECT
      *****************************************************************
      *   SRNKEY - Process new key                                    *
      *****************************************************************
      *
     C     SRNKEY        BEGSR
      *
      **  Set missing account key flag to yes
      *
     C                   MOVEL     'Y'           #MKEY
      *
      **  Access account key details
      *
     C     KAKEY         KLIST
     C                   KFLD                    #AKEY
     C     *LIKE         DEFINE    AKEY          #AKEY
      *
     C                   MOVEL     AKEY          #AKEY
     C     KAKEY         CHAIN     ACKEYALF                           90
      *
      ** If Account found set missing key to no
      *
     C     *IN90         IFEQ      *OFF
     C     AKRECI        ANDEQ     'D'
     C                   MOVEL     'N'           #MKEY
     C                   ENDIF
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   SRNCCY - Process new currency                               *
      *****************************************************************
      *
     C     SRNCCY        BEGSR
      *
      **  Access currency details
      *
     C     1             OCCUR     SDCURR
      *
     C     *LIKE         DEFINE    A6CYCD        ##CYCD
     C                   MOVEL     ECCY          ##CYCD
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##CYCD
     C     SDCURR        PARM      *BLANK        DSSDY
      *
      ** If no record is found on sdcurrpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '001'         DBASE
     C                   MOVEL     ##CYCD        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   SRNBRC - Process New Branch                                 *
      *****************************************************************
      *
     C     SRNBRC        BEGSR
      *
      **  Access Branch Details
      *
     C     10            OCCUR     SDBRCH
      *
     C     *LIKE         DEFINE    BRCA          ##BRCA
     C                   MOVEL     BRCA          ##BRCA
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##BRCA
     C     SDBRCH        PARM      *BLANK        DSSDY
      *
     C     1             OCCUR     SDBRCH
      *
      ** If no record is found on sdcurrpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '002'         DBASE
     C                   MOVEL     ##BRCA        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   PRTDT2 - Print Report GL008110P1 - Record DETLP21           *
      *****************************************************************
      *
     C     PRTDT2        BEGSR
      *
     C     PRTLN1        IFGE      57
     C                   WRITE     HEADP1
     C                   END
      *
     C                   CLEAR                   ORIGAC
     C*****LNNO*         IFEQ      *ZEROS                                                     CLE148
     C     LNNO          IFEQ      *BLANKS                                                    CLE148
     C     DLNO          ANDEQ     *ZEROS
     C                   MOVE      OTAC          @OTAC
     C                   MOVE      @OBRCA        OBRCA
     C                   MOVE      @OCNUM        OCNUM
     C                   MOVE      @OCCY         OCCY
     C                   MOVE      @OACOD        OACOD
     C                   MOVE      @OACSQ        OACSQ
     C                   MOVE      OTACDS        ORIGAC
     C                   END
      *
     C                   MOVE      #MKEY         SMISS
      *
      ** Midas Conv. Day to Date - Standard functions  *
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      EDAT          U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        YEVDT
      *
     C                   Z-ADD     EAMT          ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR864045
     C                   CALL      'ZSEDIT'                                                 AR864045
     C                   PARM                    ZFLD15                                     AR864045
     C                   PARM                    ZDECS                                      AR864045
     C                   PARM                    ZECODE                                     AR864045
     C                   PARM                    ZOUT21                                     AR864045
     C                   MOVE      ZOUT21        EDEVAM
      *
     C                   MOVE      ECCY          EVCY
     C                   MOVE      REVI          RVRS
      *
     C                   WRITE     DETLP21
      *
      ** Output Record to GLSTGEPD if account key is missing, else
      **   GLSTGEPD will be output by SR/PRTDT3
      *
     C     #MKEY         IFEQ      'Y'
     C                   CLEAR                   GLSTGED0
     C                   MOVE      'D'           E8RECI
     C**********         MOVE      AKEY          E8AKEY                                     AR864045
     C                   MOVEL     AKEY          E8AKEY                                     AR864045
     C                   MOVE      DLNO          E8DLNO
     C                   MOVE      LNNO          E8LNNO
     C                   MOVE      OTAC          E8OTAC
     C                   MOVE      EDAT          E8EDAT
     C                   MOVE      ECCY          E8ECCY
     C                   MOVE      EAMT          E8EAMT
     C                   MOVE      REVI          E8REVI
     C                   MOVE      'Y'           E8MISS
     C                   WRITE     GLSTGED0
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
      *   PRTDT3 - Print Report GL008110P1 - Record DETLP31           *
      *****************************************************************
      *
     C     PRTDT3        BEGSR
      *
     C     PRTLN1        IFGE      57
     C                   WRITE     HEADP1
     C                   END
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      PSTD          U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        PPSTD
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      VALD          U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        PVALD
      *
     C                   Z-ADD     PSTA          ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR864045
     C                   CALL      'ZSEDIT'                                                 AR864045
     C                   PARM                    ZFLD15                                     AR864045
     C                   PARM                    ZDECS                                      AR864045
     C                   PARM                    ZECODE                                     AR864045
     C                   PARM                    ZOUT21                                     AR864045
     C                   MOVE      ZOUT21        PPSTA
      *
     C                   MOVE      PSBRCA        P1BRCA
     C                   MOVE      PSCNUM        P1CNUM
     C                   MOVE      PSCCY         P1CCY
     C                   MOVE      PSACOD        P1ACOD
     C                   MOVE      PSACSQ        P1ACSQ
     C     DRCR          IFEQ      1
     C                   MOVE      'CR'          PDRCR
     C                   ELSE
     C                   MOVE      'DR'          PDRCR
     C                   END
      *
     C                   WRITE     DETLP31
      *
      ** Output Record to GLSTGEPD
      ** Set account key details
      *
     C                   CLEAR                   GLSTGED0
     C                   MOVE      'D'           E8RECI
     C**********         MOVE      AKEY          E8AKEY                                     AR864045
     C                   MOVEL     AKEY          E8AKEY                                     AR864045
     C                   MOVE      DLNO          E8DLNO
     C                   MOVE      LNNO          E8LNNO
     C                   MOVE      OTAC          E8OTAC
     C                   MOVE      EDAT          E8EDAT
     C                   MOVE      ECCY          E8ECCY
     C                   MOVE      EAMT          E8EAMT
     C                   MOVE      REVI          E8REVI
     C                   MOVE      'N'           E8MISS
      *
      ** Set Posting details
      *
     C                   MOVE      PSBRCA        E8BRCA
     C                   MOVE      PSCNUM        E8CNUM
     C                   MOVE      PSCCY         E8CCY
     C                   MOVE      PSACOD        E8ACOD
     C                   MOVE      PSACSQ        E8ACSQ
     C                   MOVE      PSTA          E8PSTA
     C                   MOVE      PSTD          E8PSTD
     C                   MOVE      VALD          E8VALD
     C                   MOVE      PNAR          E8PNAR
     C                   MOVE      PDRCR         E8DRCR
      *
      ** Output File
      *
     C                   WRITE     GLSTGED0
      *
     C                   ENDSR
      *
      *****************************************************************
      *   SRPOST - Create Postings                                    *
      *****************************************************************
      *
     C     SRPOST        BEGSR
      *
      **  If Other account details set then get information
      *
     C                   MOVEL     *BLANKS       S#BRCD
     C                   MOVEL     *BLANKS       S#CUST
     C                   MOVEL     *BLANKS       S#CYCD
     C                   MOVEL     *BLANKS       S#ACCD
     C                   MOVEL     *BLANKS       S#ACSN
     C                   Z-ADD     0             S#ACNO
      *
     C     OTAC          IFNE      *BLANKS
      *
     C                   MOVEL     *BLANK        ##ACID
     C     6             SUBST     OTAC:4        ##CUST
     C     3             SUBST     OTAC:10       ##CYCD
     C     10            SUBST     OTAC:13       ##ACCD
     C     2             SUBST     OTAC:23       ##ACSN
     C     3             SUBST     OTAC:1        ##BRCD
      *
      ** Call to Access Program - AOACCTR0 Check Account Number
      ** Access Account Details file for the file fields
      *
     C                   CALL      'AOACCTR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##ACID
     C                   PARM                    ##CUST
     C                   PARM                    ##CYCD
     C                   PARM                    ##ACCD
     C                   PARM                    ##ACSN
     C                   PARM                    ##BRCD
     C     SDACCT        PARM      *BLANK        DSSDY
      *
      ** If found remember
      *
     C     @RTCD         IFEQ      *BLANKS
     C     *LIKE         DEFINE    ##BRCA        S#BRCD
     C     *LIKE         DEFINE    ##CUST        S#CUST
     C     *LIKE         DEFINE    ##CYCD        S#CYCD
     C     *LIKE         DEFINE    ##ACCD        S#ACCD
     C     *LIKE         DEFINE    ##ACSN        S#ACSN
     C     *LIKE         DEFINE    ACNO          S#ACNO
     C                   MOVEL     ACBRCA        S#BRCD
     C                   MOVEL     ACCNUM        S#CUST
     C                   MOVEL     ACCCY         S#CYCD
     C                   MOVEL     ACACOD        S#ACCD
     C                   MOVEL     ACACSQ        S#ACSN
     C                   Z-ADD     ACNO          S#ACNO
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Loop round account codes, narratives and posting refs
      *
     C     1             DO        6             #X
      *
      ** Set work variables
      *
     C     *LIKE         DEFINE    ACD1          ##ACOD
     C     *LIKE         DEFINE    NCD1          ##NARC
     C     *LIKE         DEFINE    PRF1          ##PRF
     C     *LIKE         DEFINE    ASQ1          ##ACSQ
      *
     C                   MOVEA     ACD(#X)       ##ACOD
     C                   MOVEA     NCD(#X)       ##NARC
     C                   MOVEA     PRF(#X)       ##PRF
     C                   MOVEA     ACS(#X)       ##ACSQ
     C     ##ACSQ        IFEQ      *BLANKS
     C                   MOVEL     '01'          ##ACSQ
     C                   ENDIF
      *
      **  Call generate posting only if reference stated
      *
     C     ##PRF         IFNE      0
     C                   EXSR      SRGENP
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   SRGENP - Generate Posting                                   *
      *****************************************************************
      *
     C     SRGENP        BEGSR
      *
      ** Set suspense account entry to blanks
      *
     C                   MOVEL     *BLANKS       ##SUSP
      *
      ** Set up account if posting reference is 1 or 4
      *
     C                   SELECT
     C     ##PRF         WHENEQ    1
     C     ##PRF         OREQ      4
      *
     C     10            OCCUR     SDBRCH
      *
     C                   MOVEL     K#BRCA        PSBRCA
     C                   MOVEL     A8BICN        PSCNUM
     C                   MOVEL     ECCY          PSCCY
     C                   Z-ADD     ##ACOD        PSACOD
     C                   Z-ADD     01            PSACSQ
      *
      ** If sequence non-blank use
      *
     C     ##ACSQ        IFNE      *BLANKS
     C                   MOVEL     ##ACSQ        PSACSQ
     C                   ENDIF
      *
     C     1             OCCUR     SDBRCH
      *
     C     ##PRF         WHENEQ    2
      *
      ** Get Account details
      *
     C                   EXSR      SRACC
      *
     C     ##PRF         WHENEQ    3
      *
     C                   MOVEL     K#BRCA        PSBRCA
     C                   MOVEL     CNUMA         PSCNUM
     C                   MOVEL     ECCY          PSCCY
     C                   Z-ADD     ##ACOD        PSACOD
     C     ACSQ          IFEQ      0
     C                   Z-ADD     01            PSACSQ
     C                   ELSE
     C                   Z-ADD     ACSQ          PSACSQ
     C                   ENDIF
      *
     C                   OTHER
      *
      ** Reference not processed
      *
     C     *LOCK         IN        LDA
     C                   MOVE      '003'         DBASE
     C                   MOVEL     ##PRF         DBKEY
     C                   MOVEL     'NO PRF  '    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDSL
      *
      **  Get Account code details
      *
      ** Set occurrence to new location
      *
     C     2             OCCUR     SDACOD
      *
     C                   MOVEL     PSACOD        ##ACCD
      *
      ** Call access object to get data
      *
     C                   CALL      'AOACODR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##ACCD
     C*****SDACOD        PARM      *BLANK        DSFDY                                      MD040971
     C     SDACOD        PARM      *BLANK        DSSDY                                      MD040971
      *
      ** If no record is found on sdacodpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '004'         DBASE
     C                   MOVEL     ##ACCD        DBKEY
     C                   MOVEL     'SDACODPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C     2             OCCUR     SDACOD
      *
      ** If Account is retail check that it is still open
      *
     C     A5ACTY        IFEQ      'R'
      *
      ** Set up Parameters for call to AOACCTR0
      *
     C     2             OCCUR     SDACCT
      *
     C                   MOVEL     *BLANK        ##ACID
     C                   MOVEL     PSCNUM        ##CUST
     C                   MOVEL     PSCCY         ##CYCD
     C                   MOVEL     PSACOD        ##ACCD
     C                   MOVEL     PSACSQ        ##ACSN
     C                   MOVEL     PSBRCA        ##BRCD
      *
      ** Call to Access Program - AOACCTR0 Check Account Number
      ** Access Account Details file for the file fields
      *
     C                   CALL      'AOACCTR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##ACID
     C                   PARM                    ##CUST
     C                   PARM                    ##CYCD
     C                   PARM                    ##ACCD
     C                   PARM                    ##ACSN
     C                   PARM                    ##BRCD
     C     SDACCT        PARM      *BLANK        DSSDY
      *
      ** If no record is found or closed error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         OREQ      *BLANKS
     C     RECI          ANDNE     'D'
     C     ECCY          ORNE      ACCCY
     C     *LOCK         IN        LDA
     C                   MOVE      '005'         DBASE
     C     *LIKE         DEFINE    DBKEY         ##KEY
     C                   MOVEL(P)  PSCNUM        ##KEY
     C                   CAT       PSCCY:0       ##KEY
     C                   CAT       ##ACCD:0      ##KEY
     C                   CAT       ##ACSN:0      ##KEY
     C                   CAT       PSBRCA:0      ##KEY
     C                   MOVEL     ##KEY         DBKEY
     C                   MOVEL     'ACCNT   '    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Save retail bits and number and date account opened
      *
     C     *LIKE         DEFINE    RETB          ##RETB
     C                   MOVEL     RETB          ##RETB
     C     *LIKE         DEFINE    ACNO          ##ACNO
     C                   Z-ADD     ACNO          ##ACNO
     C     *LIKE         DEFINE    DACO          ##DACO
     C                   Z-ADD     DACO          ##DACO
     C     *LIKE         DEFINE    RRNM          ##RRNM
     C                   Z-ADD     RRNM          ##RRNM
      *
     C                   ENDIF
      *
     C     1             OCCUR     SDACCT
      *
      **  If retail account check not blocked
      **  or not open before date
      *
     C                   MOVEL     *BLANKS       ##RETA
     C     A5ACTY        IFEQ      'R'
      *
     C                   MOVEL     *OFF          *IN90
      *
     C     #X            IFLT      3
     C                   TESTB     '2'           ##RETB                   90
     C                   MOVEL     '2'           ##RETA
     C                   ELSE
     C                   TESTB     '3'           ##RETB                   90
     C                   MOVEL     '3'           ##RETA
     C                   ENDIF
      *
     C     EDAT          IFLT      ##DACO
     C                   MOVEL     *ON           *IN90
     C                   ENDIF
      *
      **  If blocked send to suspense
      *
     C     *IN90         IFEQ      *ON
      *
     C                   MOVEL     'Y'           ##SUSP
      *
     C     6             OCCUR     SDACOD
     C     10            OCCUR     SDBRCH
     C                   MOVEL     K#BRCA        PSBRCA
     C                   MOVEL     A8BICN        PSCNUM
     C                   MOVEL     ECCY          PSCCY
     C                   MOVEL     A5ACCD        PSACOD
     C                   Z-ADD     01            PSACSQ
      *
     C     1             OCCUR     SDBRCH
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Get Posting Narrative
      *
     C     *LIKE         DEFINE    ##NARC        ##NVCD
     C                   MOVEL     ##NARC        ##NVCD
     C                   CALL      'AONARRR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##NVCD
     C     SDNARR        PARM      *BLANK        DSFDY
      *
      ** If no record is found on sdnarrpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '006'         DBASE
     C                   MOVEL     ##NARC        DBKEY
     C                   MOVEL     'SDNARRPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Assign work field to file field values.
      *
     C     *LIKE         DEFINE    PNAR          #UPNAR
     C                   MOVEL     ALDON         PNAR
      *
      ** Set up fields for APOSTPDF
      *
     C                   MOVEL(P)  'GB'          ##MGID
     C                   CAT       ##NARC:0      ##MGID
     C                   CAT       '000':0       ##MGID
      *
     C                   EXSR      SRSETF
      *
      ** Set up posting narrative
      *
     C                   EXSR      SRNARR
      *
      ** Create new postings
      *
     C     P0PSUM        IFNE      'Y'
     C     ##PRF         ORNE      4
     C                   WRITE     APOSTPDF
     C                   ELSE
     C                   WRITE     @PSUMPPF
     C                   ENDIF
      *
      ** Print Account Key Details
      *
     C                   EXSR      PRTDT3
      *
      ** Add to sub-totals
      *
     C     DRCR          IFEQ      1
     C                   ADD       PSTA          ##TCR
     C                   ADD       PSTA          ##TCRC
     C                   ELSE
     C                   ADD       PSTA          ##TDR
     C                   ADD       PSTA          ##TDRC
     C                   ENDIF
      *
      ** If interbranch settlement
      *
     C     PSBRCA        IFNE      K#BRCA
     C                   EXSR      SRINTB
     C                   ENDIF
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   SRACC  - Get Account Details                                *
      *****************************************************************
      *
     C     SRACC         BEGSR
      *
      **  Get Account details depending on settlement method
      *
      **  When settlement type
      *
     C                   SELECT
      *
      **  Send to suspense
      *
     C     SETP          WHENEQ    0
      *
     C     6             OCCUR     SDACOD
     C     10            OCCUR     SDBRCH
     C                   MOVEL     BRCA          PSBRCA
     C                   MOVEL     A8BICN        PSCNUM
     C                   MOVEL     ECCY          PSCCY
     C                   MOVEL     A5ACCD        PSACOD
     C                   Z-ADD     01            PSACSQ
      *
     C     2             OCCUR     SDACOD
     C     1             OCCUR     SDBRCH
      *
      **  Nostro Account
      *
     C     SETP          WHENEQ    01
     C     SETP          OREQ      08
      *
      ** Set up Parameters for call to AONOSTR0
      *
     C                   MOVEL     *BLANKS       ##CUST
     C                   MOVEL     ECCY          ##CYCD
     C                   MOVEL     *BLANKS       ##ACCD
     C                   MOVEL     *BLANKS       ##ACSN
     C                   MOVEL     OSAC          ##NONB
     C                   MOVEL     *BLANKS       ##BRCD
      *
      ** Access Nostro Details file for the file fields
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##CUST
     C                   PARM                    ##CYCD
     C                   PARM                    ##ACCD
     C                   PARM                    ##ACSN
     C                   PARM                    ##NONB
     C                   PARM                    ##BRCD
     C                   PARM      *BLANK        ##CSSN
     C                   PARM      *BLANK        ##PNOI
     C     SDNOST        PARM      *BLANK        DSFDY
      *
      ** If no record is found on sdnostpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '007'         DBASE
     C     ##NONB        CAT       ECCY:0        DBKEY
     C                   MOVEL     'SDNOSTPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Assign work field to file field values.
      *
     C                   MOVEL     A7CYCD        PSCCY
     C                   MOVEL     A7ACCD        PSACOD
     C                   MOVEL     A7CUST        PSCNUM
     C                   MOVEL     A7ACSN        PSACSQ
     C                   MOVEL     A7BRCD        PSBRCA
      *
      **  Retail Settlement
      *
     C     SETP          WHENEQ    14
      *
      ** Set up Parameters for call to AOACCTR0
      *
     C     3             OCCUR     SDACCT
      *
     C                   MOVEL     OSAC          ##ACID
     C                   MOVEL     *BLANKS       ##CUST
     C                   MOVEL     *BLANKS       ##CYCD
     C                   MOVEL     *BLANKS       ##ACCD
     C                   MOVEL     *BLANKS       ##ACSN
     C                   MOVEL     *BLANKS       ##BRCD
      *
      ** Call to Access Program - AOACCTR0 Check Account Number
      ** Access Account Details file for the file fields
      *
     C                   CALL      'AOACCTR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##ACID
     C                   PARM                    ##CUST
     C                   PARM                    ##CYCD
     C                   PARM                    ##ACCD
     C                   PARM                    ##ACSN
     C                   PARM                    ##BRCD
     C     SDACCT        PARM      *BLANK        DSSDY
      *
      ** If no record is found or closed error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         OREQ      *BLANKS
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   MOVE      '008'         DBASE
     C                   MOVEL     ##ACID        DBKEY
     C                   MOVEL     'ACCNT   '    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     ACBRCA        PSBRCA
     C                   MOVEL     ACCNUM        PSCNUM
     C                   MOVEL     ACCCY         PSCCY
     C                   MOVEL     ACACOD        PSACOD
     C                   Z-ADD     ACACSQ        PSACSQ
      *
     C     2             OCCUR     SDACCT
      *
      **  Internal Settlement
      *
     C     SETP          WHENEQ    05
     C                   MOVEL     OSBR          PSBRCA
     C                   MOVEL     OSAC          PSCNUM
     C                   MOVEL     ECCY          PSCCY
     C     10            SUBST     OSAC:7        ##ACCD
     C                   MOVEL     ##ACCD        PSACOD
     C                   MOVE      OSAC          PSACSQ
     C                   OTHER
      *
      ** Unrecognised settlement
      *
     C     *LOCK         IN        LDA
     C                   MOVE      '009'         DBASE
     C                   MOVEL     SETP          DBKEY
     C                   MOVEL     'SETP    '    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSL
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   SRSETF - Set Account Posting fields                         *
      *****************************************************************
      *
     C     SRSETF        BEGSR
      *
      ** Movel fields
      *
     C                   MOVEL     'P'           RECI
     C                   MOVEL     *BLANKS       IPDN
      *
     C                   Z-ADD     0             ACNO
     C     A5ACTY        IFEQ      'R'
     C                   Z-ADD     ##ACNO        ACNO
     C                   ENDIF
      *
     C                   Z-ADD     BJRDNB        PSTD
      *
      ** Call subroutine SRPSTD to determine correct posting date
      ** Only run if mode is S
      *
     C     P0MODE        IFEQ      'S'
     C                   EXSR      SRPSTD
     C                   END
     C                   Z-ADD     EDAT          VALD
      *
     C                   Z-ADD     60001         TRAT
     C     MODC          IFEQ      'BT'
     C     BTTRAT        ANDNE     0
     C                   Z-ADD     BTTRAT        TRAT
     C                   ENDIF
      *
     C                   Z-ADD     EAMT          PSTA
     C                   SELECT
      *
      ** If reversal of debit
      *
     C     #X            WHENLE    3
     C     REVI          ANDEQ     1
     C                   Z-ADD     1             DRCR
     C                   Z-ADD     1             VOIN
      *
      ** If reversal of credit
      *
     C     #X            WHENGT    3
     C     REVI          ANDEQ     1
     C                   Z-ADD     0             DRCR
     C                   Z-ADD     1             VOIN
      *
      ** If debit
      *
     C     #X            WHENLE    3
     C                   Z-ADD     0             DRCR
      *
      ** else credit
      *
     C                   OTHER
     C                   Z-ADD     1             DRCR
     C                   ENDSL
      *
      ** If posting amount negative invert with DRCR
      *
     C     PSTA          IFLT      0
     C     DRCR          IFEQ      0
     C                   Z-SUB     PSTA          PSTA
     C                   Z-ADD     1             DRCR
     C                   ELSE
     C                   Z-SUB     PSTA          PSTA
     C                   Z-ADD     0             DRCR
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     CNUMA         ASOC
     C                   Z-ADD     0             CHQN
      *
     C                   MOVEL     '  GE-FS'     SPOS
     C                   MOVEL     '8'           GETP
      *
     C                   Z-ADD     0             RIND
     C     A5ACTY        IFEQ      'R'
     C                   Z-ADD     1             RIND
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       REJC
     C                   MOVEL     *BLANKS       DPMT
      *
     C                   Z-ADD     0             RRNM
     C     A5ACTY        IFEQ      'R'
     C                   Z-ADD     ##RRNM        RRNM
     C                   ENDIF
     C                   MOVEL     A5ACTY        ATYP
      *
     C                   BITOFF    '01234567'    PRIN
     C     A5ACTY        IFEQ      'R'
     C                   BITON     '0'           PRIN
     C                   ENDIF
      *
     C                   Z-ADD     235959        PTIM
     C                   Z-ADD     0             VOIN
     C                   MOVEL     A5ACSC        ACSC
      *
     C     MODC          IFEQ      'LE'
     C                   MOVEL     LNNO          SWCR
     C                   MOVEL     MODC          DLREF
     C                   MOVE      LNNO          DLREF
     C                   ENDIF
      *
     C     MODC          IFEQ      'FL'
     C                   MOVEL     PREF          SWCR
     C     PREF          CAT       MODC:0        DLREF
     C                   ENDIF
      *
     C     MODC          IFEQ      'RE'
     C                   MOVEL     PREF          SWCR
     C                   MOVEL     MODC          DLREF
     C                   MOVE      'STAMPT'      DLREF
     C                   ENDIF
      *
     C     MODC          IFEQ      'DL'
     C                   MOVEL     DLNO          SWCR
     C                   MOVEL     MODC          DLREF
     C                   MOVE      DLNO          DLREF
     C                   ENDIF
      *
     C     MODC          IFEQ      'BT'
     C                   MOVEL     BTSWCR        SWCR
     C                   MOVEL     BTPNAR        PNAR
     C                   ENDIF
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   SRNARR - Set up posting narrative                           *
      *****************************************************************
      *
     C     SRNARR        BEGSR
      *
      **  Set up posting narrative
      *
      ** Define the data structure parameter:
      *
     C     *LIKE         DEFINE    CGPNAR        ##PNAR
      *
      ** If the facility is switched off or unavailable,
      ** or UDC is not installed, exit this subroutine:
      *
     C     REPNAR        IFNE      'Y'
     C                   GOTO      EXPNAR
     C                   ENDIF
      *
     C                   CLEAR                   CGPNAR
     C                   CLEAR                   ##PRM1
      *
      ** Determine the customer's name:
      *
     C                   MOVEL(P)  CNUMA         ##KCST
     C*
     C                   CALL      'AOCUSTR0'
     C                   PARM                    ##RTN
     C                   PARM      '*KEY   '     ##OPT
     C                   PARM                    ##KCST
     C                   PARM                    ##STS
     C     SDCUST        PARM      SDCUST        DSSDY
     C*
     C     ##RTN         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '010'         DBASE
     C                   MOVEL     ##KEY         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *...................................................................
      ** Determine the value for the posting narrative using AOPNARR0:
      *
     C                   MOVE      MODC          MNMODI
     C                   MOVE      PSBRCA        MNBRCA
     C                   MOVE      PSCNUM        MNCUST
     C                   MOVE      PSCCY         MNCYCD
     C                   MOVE      PSACOD        MNACCD
     C                   MOVE      PSACSQ        MNACSQ
     C                   MOVE      ACNO          MNRACN
      *
      ** If other account information then use
      *
     C     S#BRCD        IFNE      *BLANKS
      *
     C                   SELECT
     C     S#BRCD        WHENEQ    MNBRCA
     C     S#CUST        ANDEQ     MNCUST
     C     S#CYCD        ANDEQ     MNCYCD
     C     S#ACCD        ANDEQ     MNACCD
     C     S#ACSN        ANDEQ     MNACSQ
      ** Do nothing to the message id
     C     S#ACNO        WHENNE    0
     C                   MOVE      '1'           ##MGID
     C                   OTHER
     C                   MOVE      '2'           ##MGID
     C                   ENDSL
      *
     C                   MOVE      S#BRCD        MNBRCA
     C                   MOVE      S#CUST        MNCUST
     C                   MOVE      S#CYCD        MNCYCD
     C                   MOVE      S#ACCD        MNACCD
     C                   MOVE      S#ACSN        MNACSQ
     C                   MOVE      S#ACNO        MNRACN
      *
     C                   ENDIF
      *
     C                   MOVE      SWCR          MNTRNO
     C                   MOVE      ASOC          MNASOC
     C                   MOVE      CHQN          MNCHNB
     C                   MOVE      BOKC          MNBOKC
     C                   MOVE      BBCRNM        MNCRNM
     C                   MOVEL(P)  PNAR          MNNARR
     C                   MOVEL     OTHC          MNOCCY
      *
      ** Format dates
      *
     C     VDAT          IFNE      0
      *
      ** Midas Conv. Day to Date - Standard functions  *
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      VDAT          U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        U#DMY
      *
      ** Fill date
      *
     C                   MOVEL     U#DMY         MNSDTE
      *
     C                   ENDIF
      *
     C     MDAT          IFNE      0
      *
      ** Midas Conv. Day to Date - Standard functions  *
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      MDAT          U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        U#DMY
      *
      ** Fill date
      *
     C                   MOVEL     U#DMY         MNDUED
      *
     C                   ENDIF
      *
      ** Format extra dates
      *
     C     STDT          IFNE      0
      *
      ** Midas Conv. Day to Date - Standard functions  *
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      STDT          U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        U#DMY
      *
      ** Fill date
      *
     C     *LIKE         DEFINE    U#DMY         ##STDT
     C                   MOVEL     U#DMY         ##STDT
      *
     C                   ENDIF
      *
     C     SLID          IFNE      0
      *
      ** Midas Conv. Day to Date - Standard functions  *
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      SLID          U#DATE
     C                   PARM      BJDFIN        U#FMT
     C                   PARM      *ZERO         U#DYNB
     C                   PARM      *BLANK        U#DMY
      *
      ** Fill date
      *
     C     *LIKE         DEFINE    U#DMY         ##SLID
     C                   MOVEL     U#DMY         ##SLID
      *
     C                   ENDIF
      *
     C     OTHA          IFNE      0
      *
     C                   MOVE      OTHA          ZFIELD
      *
     C     2             OCCUR     SDCURR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      OTHC          ##CYCD
     C     SDCURR        PARM      *BLANK        DSSDY
      *
     C                   CALL      'ZEDIT'                              9090
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
      *
     C                   MOVE      ZFIELD        MNOAMT
      *
     C     1             OCCUR     SDCURR
      *
     C                   ENDIF
      *
     C                   MOVEL     K#BRCA        A#BRCA
     C                   MOVEL     ASOC          A#CUST
      *
     C                   CALL      'AOPNARR0'
     C                   PARM                    ##RTN
     C                   PARM                    ##MGID
     C                   PARM                    ##PRM1
     C     CGPNAR        PARM      CGPNAR        ##PNAR
     C                   PARM                    ##NARR
     C*
     C     ##RTN         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'CGPNARPD'    DBFILE
     C                   MOVEL     '011'         DBASE
     C                   MOVEL     MNCUST        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C                   MOVEL(P)  ##NARR        PNAR
     C*
     C     EXPNAR        TAG
      *
     C     REVI          IFEQ      1
     C                   MOVE      '*'           PNAR
     C                   END
      *
     C                   SELECT
     C     ##RETA        WHENEQ    '2'
     C     ##SUSP        ANDEQ     'Y'
     C                   MOVE      'Cr Blck'     PNAR
     C     ##RETA        WHENEQ    '3'
     C     ##SUSP        ANDEQ     'Y'
     C                   MOVE      'Dr Blck'     PNAR
     C                   ENDSL
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   SRINTB - Interbranch Settlement                             *
      *****************************************************************
      *
     C     SRINTB        BEGSR
      *
      **  Create interbranch settlement
      *
      **  Get Settle branch information
      *
     C     2             OCCUR     SDBRCH
     C                   MOVEL     PSBRCA        ##BRCA
     C                   MOVEL     PSBRCA        S#BRCA
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##BRCA
     C     SDBRCH        PARM      *BLANK        DSSDY
      *
      ** If no record is found on sdcurrpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '012'         DBASE
     C                   MOVEL     ##BRCA        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Construct booking branch posting
      *
     C                   MOVEL     K#BRCA        PSBRCA
     C                   MOVEL     A8BICN        PSCNUM
      *
     C     10            OCCUR     SDBRCH
     C                   MOVEL     ECCY          PSCCY
     C     DRCR          IFEQ      1
     C                   MOVEL     A8DTAC        PSACOD
     C                   ELSE
     C                   MOVEL     A8DTAC        PSACOD
     C                   ENDIF
     C                   Z-ADD     01            PSACSQ
      *
     C     1             OCCUR     SDBRCH
      *
      **  Get Account code details
      *
      ** Set occurrence to new location
      *
     C     3             OCCUR     SDACOD
      *
     C                   MOVEL     PSACOD        ##ACCD
      ** Call access object to get data
     C                   CALL      'AOACODR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##ACCD
     C*****SDACOD        PARM      *BLANK        DSFDY                                      MD040971
     C     SDACOD        PARM      *BLANK        DSSDY                                      MD040971
      *
      ** If no record is found on sdacodpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '013'         DBASE
     C                   MOVEL     ##ACCD        DBKEY
     C                   MOVEL     'SDACODPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  If Account is retail check that it is still open
      *
     C     A5ACTY        IFEQ      'R'
      *
      ** Set up Parameters for call to AOACCTR0
      *
     C     2             OCCUR     SDACCT
      *
     C                   MOVEL     *BLANK        ##ACID
     C                   MOVEL     PSCNUM        ##CUST
     C                   MOVEL     PSCCY         ##CYCD
     C                   MOVEL     PSACOD        ##ACCD
     C                   MOVEL     PSACSQ        ##ACSN
     C                   MOVEL     PSBRCA        ##BRCD
      *
      ** Call to Access Program - AOACCTR0 Check Account Number
      ** Access Account Details file for the file fields
      *
     C                   CALL      'AOACCTR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##ACID
     C                   PARM                    ##CUST
     C                   PARM                    ##CYCD
     C                   PARM                    ##ACCD
     C                   PARM                    ##ACSN
     C                   PARM                    ##BRCD
     C     SDACCT        PARM      *BLANK        DSSDY
      *
      ** If no record is found or closed error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         OREQ      *BLANKS
     C     RECI          ANDNE     'D'
     C     ECCY          ORNE      ACCCY
     C     *LOCK         IN        LDA
     C                   MOVE      '014'         DBASE
     C                   MOVEL(P)  PSCNUM        ##KEY
     C                   CAT       PSCCY:0       ##KEY
     C                   CAT       ##ACCD:0      ##KEY
     C                   CAT       ##ACSN:0      ##KEY
     C                   CAT       PSBRCA:0      ##KEY
     C                   MOVEL     ##KEY         DBKEY
     C                   MOVEL     'ACCNT   '    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Save retail bits and number and date account opened
      *
     C                   MOVEL     RETB          ##RETB
     C                   Z-ADD     ACNO          ##ACNO
     C                   Z-ADD     DACO          ##DACO
     C                   Z-ADD     RRNM          ##RRNM
      *
     C                   ENDIF
      *
      ** Set up fields for APOSTPDF
      *
     C                   MOVEL     'GB00420'     ##MGID
     C                   MOVEL(P)  ##INTB        PNAR
     C                   MOVEL     *BLANKS       ##RETA
      *
     C                   EXSR      SRSETF
      *
      ** Set up posting narrative
      *
     C                   EXSR      SRNARR
      *
      ** Create new postings
      *
     C     P0PSUM        IFNE      'Y'
     C                   WRITE     APOSTPDF
     C                   ELSE
     C                   WRITE     @PSUMPPF
     C                   ENDIF
      *
      ** Print Account Key Details
      *
     C                   EXSR      PRTDT3
      **  Settle branch entry
      *
      **  Construct settle branch posting
      *
     C     *LIKE         DEFINE    PSBRCA        S#BRCA
     C                   MOVEL     S#BRCA        PSBRCA
     C     10            OCCUR     SDBRCH
     C                   MOVEL     A8BICN        PSCNUM
      *
     C                   MOVEL     ECCY          PSCCY
     C     DRCR          IFEQ      1
     C                   MOVEL     A8DTAC        PSACOD
     C                   ELSE
     C                   MOVEL     A8DTAC        PSACOD
     C                   ENDIF
     C                   Z-ADD     01            PSACSQ
      *
     C     1             OCCUR     SDBRCH
      *
      **  Get Account code details
      *
      ** Set occurrence to new location
      *
     C     4             OCCUR     SDACOD
      *
     C                   MOVEL     PSACOD        ##ACCD
      *
      ** Call access object to get data
      *
     C                   CALL      'AOACODR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##ACCD
     C*****SDACOD        PARM      *BLANK        DSFDY                                      MD040971
     C     SDACOD        PARM      *BLANK        DSSDY                                      MD040971
      *
      ** If no record is found on sdacodpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '015'         DBASE
     C                   MOVEL     ##ACCD        DBKEY
     C                   MOVEL     'SDACODPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  If Account is retail check that it is still open
      *
     C     A5ACTY        IFEQ      'R'
      *
      ** Set up Parameters for call to AOACCTR0
      *
     C     2             OCCUR     SDACCT
      *
     C                   MOVEL     *BLANK        ##ACID
     C                   MOVEL     PSCNUM        ##CUST
     C                   MOVEL     PSCCY         ##CYCD
     C                   MOVEL     PSACOD        ##ACCD
     C                   MOVEL     PSACSQ        ##ACSN
     C                   MOVEL     PSBRCA        ##BRCD
      *
      ** Call to Access Program - AOACCTR0 Check Account Number
      ** Access Account Details file for the file fields
      *
     C                   CALL      'AOACCTR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##ACID
     C                   PARM                    ##CUST
     C                   PARM                    ##CYCD
     C                   PARM                    ##ACCD
     C                   PARM                    ##ACSN
     C                   PARM                    ##BRCD
     C     SDACCT        PARM      *BLANK        DSSDY
      *
      ** If no record is found or closed error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         OREQ      *BLANKS
     C     RECI          ANDNE     'D'
     C     ECCY          ORNE      ACCCY
     C     *LOCK         IN        LDA
     C                   MOVE      '016'         DBASE
     C                   MOVEL(P)  PSCNUM        ##KEY
     C                   CAT       PSCCY:0       ##KEY
     C                   CAT       ##ACCD:0      ##KEY
     C                   CAT       ##ACSN:0      ##KEY
     C                   CAT       PSBRCA:0      ##KEY
     C                   MOVEL     ##KEY         DBKEY
     C                   MOVEL     'ACCNT   '    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Save retail bits and number and date account opened
      *
     C                   MOVEL     RETB          ##RETB
     C                   Z-ADD     ACNO          ##ACNO
     C                   Z-ADD     DACO          ##DACO
     C                   Z-ADD     RRNM          ##RRNM
      *
     C                   ENDIF
      *
      **  Set up fields for APOSTPDF
      *
     C                   MOVEL     'GB00420'     ##MGID
     C                   MOVEL(P)  ##INTB        PNAR
     C                   MOVEL     *BLANKS       ##RETA
      *
     C                   EXSR      SRSETF
      *
      **  Set up posting narrative
      *
     C                   EXSR      SRNARR
      *
     C     DRCR          IFEQ      0
     C                   Z-ADD     1             DRCR
     C                   ELSE
     C                   Z-ADD     0             DRCR
     C                   ENDIF
      *
      **  Create new postings
      *
     C     P0PSUM        IFNE      'Y'
     C                   WRITE     APOSTPDF
     C                   ELSE
     C                   WRITE     @PSUMPPF
     C                   ENDIF
      *
      ** Print Account Key Details
      *
     C                   EXSR      PRTDT3
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   SRLCCY - Process change of Currency                         *
      *****************************************************************
      *
     C     SRLCCY        BEGSR
      *
      **  Check if out of balance
      *
     C     ##TCRC        IFNE      ##TDRC
      *
      **  Create balancing posting
      *
      **  Construct suspense account
      *
     C     6             OCCUR     SDACOD
     C     10            OCCUR     SDBRCH
     C                   MOVEL     K#BRCA        PSBRCA
     C                   MOVEL     A8BICN        PSCNUM
     C                   MOVEL     ECCY          PSCCY
     C                   MOVEL     A5ACCD        PSACOD
     C                   Z-ADD     01            PSACSQ
      *
     C     1             OCCUR     SDBRCH
      *
      **  If Account is retail check that it is still open
      *
     C     A5ACTY        IFEQ      'R'
      *
      ** Set up Parameters for call to AOACCTR0
      *
     C     2             OCCUR     SDACCT
      *
     C                   MOVEL     *BLANK        ##ACID
     C                   MOVEL     PSCNUM        ##CUST
     C                   MOVEL     PSCCY         ##CYCD
     C                   MOVEL     PSACOD        ##ACCD
     C                   MOVEL     PSACSQ        ##ACSN
     C                   MOVEL     PSBRCA        ##BRCD
      *
      ** Call to Access Program - AOACCTR0 Check Account Number
      ** Access Account Details file for the file fields
      *
     C                   CALL      'AOACCTR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##ACID
     C                   PARM                    ##CUST
     C                   PARM                    ##CYCD
     C                   PARM                    ##ACCD
     C                   PARM                    ##ACSN
     C                   PARM                    ##BRCD
     C     SDACCT        PARM      *BLANK        DSSDY
      *
      ** If no record is found or closed error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         OREQ      *BLANKS
     C     RECI          ANDNE     'D'
     C     ECCY          ORNE      ACCCY
     C     *LOCK         IN        LDA
     C                   MOVE      '017'         DBASE
     C                   MOVEL(P)  PSCNUM        ##KEY
     C                   CAT       PSCCY:0       ##KEY
     C                   CAT       ##ACCD:0      ##KEY
     C                   CAT       ##ACSN:0      ##KEY
     C                   CAT       PSBRCA:0      ##KEY
     C                   MOVEL     ##KEY         DBKEY
     C                   MOVEL     'ACCNT   '    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Save retail bits and number and date account opened
      *
     C                   MOVEL     RETB          ##RETB
     C                   Z-ADD     ACNO          ##ACNO
     C                   Z-ADD     DACO          ##DACO
     C                   Z-ADD     RRNM          ##RRNM
      *
     C                   ENDIF
      *
      ** Set up fields for APOSTPDF
      *
     C                   MOVEL     'GB00010'     ##MGID
     C                   MOVEL(P)  ##IMB         PNAR
     C                   MOVEL     *BLANKS       ##RETA
     C                   Z-ADD     0             REVI
     C                   Z-ADD     0             DRCR
     C                   Z-ADD     0             DLNO
     C**********         Z-ADD     0             LNNO                                         CLE148
     C                   MOVEL     *BLANKS       LNNO                                         CLE148
     C                   MOVEL     'GL'          MODC
     C                   MOVEL     *BLANKS       FACO
     C                   MOVEL     *BLANKS       DLREF
      *
     C     ##TCRC        SUB       ##TDRC        EAMT
     C                   Z-ADD     1             #X
      *
     C                   EXSR      SRSETF
      *
      ** Set up posting narrative
      *
     C                   EXSR      SRNARR
      *
      ** Create new postings
      *
     C                   WRITE     APOSTPDF
      *
      ** Print Account Key Details
      *
     C                   EXSR      PRTDT3
      *
     C                   ENDIF
      *
      ** Process change of currency
      *
     C                   Z-ADD     0             ##TCRC
     C                   Z-ADD     0             ##TDRC
      *
     C                   ENDSR
     C/EJECT
      ********************************************************************
      **
      **   Find correct date for posting if forward valued
      **
      ********************************************************************
     C     SRPSTD        BEGSR
      *
      ** If value date is less than next working day use run date
      *
     C     EDAT          IFLE      BJDNWD
     C                   Z-ADD     BJDNWD        PSTD
     C                   GOTO      EXPSTD
     C                   END
      *
      ** If value date is greater than next working day
      ** use program SZDATE3 to determine correct date
      *
     C                   Z-ADD     EDAT          W#NDAT
     C                   Z-ADD     EDAT          P#SDAT
      *
     C     W#NDAT        DOUEQ     W#SDAT
     C                   Z-ADD     P#SDAT        W#SDAT
     C     P#SDAT        SUB       1             P#SDAT
     C                   CALL      'SZDATE3'
     C                   PARM      P#SDAT        #DAYNO
     C                   PARM      BJLCCY        #CCY
     C                   PARM      *BLANKS       #LOC
     C                   PARM      1             #NRDYS
     C     W#NDAT        PARM                    #DYNBR
     C                   END
      *
     C                   Z-ADD     W#SDAT        PSTD
      *
     C     EXPSTD        ENDSR
     C/EJECT
      *****************************************************************
      *   SRLBRC - Process Change of Branch                           *
      *****************************************************************
      *
     C     SRLBRC        BEGSR
      *
      **  Process Change of Branch
      *
     C                   Z-ADD     0             ##TCR
     C                   Z-ADD     0             ##TDR
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   SREND  - End of program print summary                       *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
     C     PRTLN1        IFGE      54
     C                   WRITE     HEADP1
     C                   END
     C                   WRITE     TRAILP1
      *
      **  Print summary of postings created
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   SRINIT - inital process                                     *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
     C                   MOVEA     CPY@          BIS@
      *
      **  Set up LDA
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'GL008110'    DBPGM
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA
      *
      **  Access SDBANKPD for report title
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If no record is found on sdbankpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '018'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Access SDGELRPD for General Ledger Details
      *
     C                   CALL      'AOGELRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSFDY
      *
      ** If no record is found on sdgelrpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '019'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Access SDTRADPD for Trading Details
      *
     C                   CALL      'AOTRADR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      ** If no record is found on sdtradpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '020'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Get Computer suspense account code
      *
      ** Set occurrance to Computer suspense
      *
     C     6             OCCUR     SDACOD
      *
     C     *LIKE         DEFINE    BKACCD        ##ACCD
     C                   MOVEL     BKACCD        ##ACCD
      ** call access object to get data
     C                   CALL      'AOACODR0'
     C                   PARM                    @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ##ACCD
     C*****SDACOD        PARM      *BLANK        DSFDY                                      MD040971
     C     SDACOD        PARM      *BLANK        DSSDY                                      MD040971
      *
      ** If no record is found on sdacodpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '021'         DBASE
     C                   MOVEL     ##ACCD        DBKEY
     C                   MOVEL     'SDACODPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C     1             OCCUR     SDACOD
      *
      ** Access SDMMODPD for modules available
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** If no record is found on sdmmodpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '022'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SCSARDPD for multilanguage switchable feature
      *
     C                   CALL      'AOSARDR0'
     C                   PARM                    @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'REPNAR'      @SARD
     C     SCSARD        PARM      *BLANKS       DSFDY
      *
      ** If no record is found on sdmmodpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVE      '023'         DBASE
     C                   MOVEL     'REPNAR'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           REPNAR
     C                   ENDIF
      *
      ** Output GL008110P1 Header
     C                   WRITE     HEADP1
      *
      ** Ensure the spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUM         ZSNUM
      *
      ** Call ZSFILE for GL008110P1
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
      ** Dummy read of posting file
      *
     C                   READ      APOSTPDF                               90
     C                   READ      GLPSUMPD                               90
      *
      ** Set initialisation complete
      *
     C                   MOVEL     'Y'           #FIRST
      *
     C                   ENDSR
     C/EJECT
     C/COPY ZSRSRC,ZSEDITZ3LE
      *****************************************************************
      *   *PSSR - error handling                                      *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
** CPY@   **      OBJECT COPYRIGHT
(C) Copyright Finastra International Limited 2010
