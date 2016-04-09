     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax A/C Keys - Interest/Flat')          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL008130 - Stamp Tax Account Keys - Interest/Flat            *
      *                                                               *
      *           This function generates Stamp Tax on Interest and   *
      *           Flat Stamp Tax postings. It runs daily and on an    *
      *           accrual day followed by a non-working day.          *
      *           It processes DL, LE, FT, Fees, Facilities and       *
      *           Securities a/c keys. A driving input parameter      *
      *           identifies which a/c key file is to be processed.   *
      *                                                               *
      *           The Stamp Tax postings are output to the same a/c   *
      *           key file processed in input with the exception of   *
      *           Facilities postings which are output to the Fees    *
      *           a/c Keys file.                                      *
      *                                                               *
      *           The Stamp Tax Summary file is updated when the Tax  *
      *           posting is on an Interest amount: The field Tax on  *
      *           Interest on the Summary file is updated to include  *
      *           the amount posted. A record is output to the detail *
      *           Stamp Tax file to store the details of the Stamp    *
      *           Tax on Interest postings.                           *
      *                                                               *
      *           The Stamp Tax on Interest is calculated on the      *
      *           amount of Interest being paid. Reversal postings are*
      *           linked to the reversal of the Interest a/c key.     *
      *                                                               *
      *           The Flat Stamp Tax amount to be posted is retrieved *
      *           from the Historic/Detail file on the record where   *
      *           the Control Date is zero and the tax paid indicator *
      *           is blank. The tax paid ind. is then set to Y once   *
      *           the posting has been generated. No reverse process  *
      *           is done on Flat Tax.                                *
      *                                                               *
      *           An input parameter (set a Cob component level)      *
      *           drives the update of the a/c keys files.            *
      *           After GL008130 has run, a copy of the account key   *
      *           files is taken to workfile and if the Update flag   *
      *           is not 'Y' the original account keys file are       *
      *           restored from Savf. The workfiles that contain the  *
      *           a/c keys are: STTyynnnnn                            *
      *           (where yy is the module LE/FE/FC/DL/SE/FT           *
      *           and nnnnn is the cob component sequence)            *
      *                                                               *
      *           Tax files are always updated regardless of the      *
      *           Update flag.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd 2010             *
      *                                                               *
      *  Called From: LEC0820, LEC0821, LEC0822, DLC0820, FTC0820     *
      *               SEC0820                                         *
      *                                                               *
      *  Last Amend No. AR1084524          Date 13Feb13               *
      *  Prev Amend No. AR1056323          Date 14Nov12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR942839A          Date 16Apr12               *
      *                 AR947998           Date 11Apr12               *
      *                 AR879983A          Date 08Feb12               *
      *                 AR941869A          Date 30Mar12               *
      *                 AR888911           Date 26Jan12               *
      *                 AR942819           Date 29Mar12               *
      *                 AR864714B          Date 28Mar12               *
      *                 AR891654           Date 16Jan12               *
      *                 AR871641           Date 06Jan12               *
      *                 AR864714A          Date 04Jan12               *
      *                 AR863957A          Date 03Jan12               *
      *                 AR881680           Date 22Dec11               *
      *                 AR879983           Date 21Dec11               *
      *                 AR877145           Date 16Dec11               *
      *                 AR871666           Date 08Dec11               *
      *                 AR871632           Date 30Nov11               *
      *                 AR863957           Date 28Nov11               *
      *                 AR864714           Date 17Nov11               *
      *                 AR864206           Date 17Nov11               *
      *                 CLE147             Date 30Sep11               *
      *                 AR853257           Date 04Nov11               *
      *                 AR824338           Date 07Sep11               *
      *                 AR821875           Date 06Sep11               *
      *                 AR824335           Date 05Sep11               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1084524 - Performance issue on IPAY & OPAY listview        *
      *              (Recompile)                                      *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR942839A - No movement is posted in Stamp Tax Movement      *
      *              enquiry for Position Settlements                 *
      *  AR947998 - No additional stamp tax movement for principal    *
      *             increase events                                   *
      *  AR879983A - Add stamp tax exchange rate (Reopen)             *
      *  AR941869A - Erroneous stamp tax on interest                  *
      *  AR888911 - In reversing a deal, REV column in Stamp Tax      *
      *             Movements Enquiry is not changing from N to Y     *
      *           - Applied for AR944923                              *
      *  AR942819 - Reversal Indicator was not change to Y            *
      *  AR864714B - No movement is posted in Stamp Tax Movement      *
      *              enquiry for Position Settlements                 *
      *            - Applied for AR942839                             *
      *  AR891654 - LEC000820 failed, LEC000820 - CPF4128 appeared    *
      *             during OPEN for file LEFCLTLH                     *
      *  AR871641 - Charge field on the enquries for OPAY is the      *
      *             stamp tax amount                                  *
      *  AR864714A - No movement is posted in Stamp Tax Movement      *
      *              enquiry for Position Settlements                 *
      *  AR863957A- SEC0610 File out of balance on SE2450AU (Reopen)  *
      *  AR881680 - No GL008130P1 (Lending Stamp Tax_Fees) report     *
      *             was generated after COB                           *
      *  AR879983 - Add stamp tax exchange rate                       *
      *  AR877145 - SEC000820 00001 Database Error                    *
      *  AR871666 - In the stamp tax movements enquiry, reversal      *
      *             indicator of various reversed trade purchase      *
      *             and trade sale is still N.                        *
      *  AR871632 - No Stamp Tax on Interest for Call or Demand Loan  *
      *             Generated in Stamp Tax                            *
      *  AR863957 - SEC0610 File out of balance on SE2450AU           *
      *  AR864714 - No Movements is posted for position settlement    *
      *  AR864206 - Stamp Tax Movement Enquiry Screen_System returns  *
      *             to Main Screen upon "Enter"                       *
      *  CLE147 - Aggregate Facility (Recompile)                      *
      *  AR853257 - Account Keys for FT were not generated            *
      *  AR824338 - Stamp tax computation did not consider            *
      *             effective dates                                   *
      *  AR821875 - Component LEC06A 10014 failed                     *
      *  AR824335 - Various error on Flat stamp tax computation       *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *
      * Lending Interest Account Keys
     FLKEY1DL0  IF A E           K DISK    USROPN
     FLKEY1ZZ   UF   E             DISK    USROPN
     F*
      * Lending Fees Account Keys file
     FLKEYFED   IF A E             DISK    USROPN
     FLKEYFEZ   UF   E             DISK    USROPN
      *
      * Dealing Account Keys
     FDKEYSDP   IF A E             DISK    USROPN
     FDKEYSZZ   UF   E             DISK    USROPN
      *
      * Funds Transfer
     FFPKEYDD   IF A E             DISK    USROPN
     FFPKEYZZ   UF   E             DISK    USROPN
      *
      * Securities
     FSEKEY     IF A E           K DISK    USROPN
     FSEKEYA    UF   E             DISK    USROPN
      *
      * Facility
     FFCLTY1    IF   E             DISK    USROPN
      *
     FPOSET1    IF   E           K DISK    PREFIX(P_)                                       AR864714
      *                                                                                     AR864714
      * Stamp Tax Summary Transactions files
     FDLDLDCL3  UF   E           K DISK
     FCLONCLL1  UF   E           K DISK
     F***LEFCLTLH  UF   E           K DISK                                                  AR891654
     FLEFCLTLH  IF   E           K DISK                                                     AR891654
     FLEFEEQL1  UF   E           K DISK
     FTRADSQL0  UF   E           K DISK
     FINPAYQL0  UF   E           K DISK
     FOTPAYQL0  UF   E           K DISK
     FCQCOCQL0  UF   E           K DISK
     FCQPACQL0  UF   E           K DISK
     FPOSETDYL  UF   E           K DISK
      *
      * Stamp Tax Historic/Details file
     FSDSTMDL0  UF A E           K DISK
     FSDSTMDL6  UF   E           K DISK
     FSDSTMDL1  IF   E           K DISK                                                     AR888911
      *
      * Loans file
     FCLOAN     IF   E           K DISK    USROPN
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     FSDSTTPL0  IF   E           K DISK
      *
     FLEFEEDL1  IF   E           K DISK                                                     AR853257
      *                                                                                     AR853257
      * Report
     FGL008130AUO    E             PRINTER INFDS(SPOOLA)
     F                                     USROPN
     FGL008130P1O    E             PRINTER INFDS(SPOOL1)
     FGL008130P2O    E             PRINTER INFDS(SPOOL2)
     F                                     USROPN
      *
      *****************************************************************
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      * 75            Work Ind
      * 40            Read Ind
      * 41            Read Ind
      * 90-99         Standard Routines
      *
      *****************************************************************
     D/COPY ZSRSRC,ZDATE9Z1LE
     D/COPY ZSRSRC,ZSEDITZ1LE
     D/COPY ZSRSRC,ZDATE2Z1LE
     D/COPY ZSRSRC,ZPOWERZ1IL
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D FIL@            S             10    DIM(7) CTDATA PERRCD(7)
     D KEY@            S             10    DIM(7) CTDATA PERRCD(7)
     D NAR@            S             40    DIM(7) CTDATA PERRCD(1)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *   External DS for Bank Details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *   External DS for General Ledger Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  External DS for Midas Currency Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for branch name details
      *
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      ** External DS for loan type details
      *
     D STAMDA          DS
     D  TAKEON                 1      5  0
     D  DATRAT                 6     10  0
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *   SAR File Details Accessed via Access Program AOSARDR0
      *
     D SDSTPD        E DS                  EXTNAME(SDSTPDPD)
      *   Stamp Tax tax details  - parameter to SD008141
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Fisrt DS for Access Programs, Short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access Programs, Long data structure
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D FEES            DS
     D  FEE16                  1      6
     D  FEE1                   1      1
     D  FEE2                   2      4
     D  FEE3                   5      6
      *
     D PRF             DS
     D  PREF                   1     15
     D  PAYTYP                12     13
      *
     D SETTLE          DS
     D  SEAC                   1     24
     D  S@CNUM                 1      6
     D  S@CCCY                 7      9
     D  S@ACOD                10     19
     D  S@ACSQ                20     21
     D  S@BRCD                22     24
     D                 DS
     D  STLA                   1     18
     D  STCNUM                 1      6
     D  STACOD                 7     16
     D  STACSQ                17     18
      *
      * a/c keys : all modules except securities
     D AKY             DS
     D  AKEY                   1     14
     D  AKF12                  1      2
     D  AKLNTY                 1      2
     D  AKLNST                 4      5
     D  AKLNCL                11     14
     D  AKF13                  1      3
     D  AKF15                  1      5
     D  AKFCCY                 6      8
     D  AKF89                  8      9
     D  AKF910                 9     10
     D  AKEVEN                 3      3
     D  AKFLD4                 4      4
     D  AKF45                  4      5
     D  AKFLD5                 5      5
     D  AKFLD6                 6      6
     D  AKFLD7                 7      7
     D  AKFLD8                 8      8
     D  AKFLD9                 9      9
     D  AKTYPE                10     10
      *
      * securities a/c key
     D SAKY            DS
     D  SAKEY                  1     20
     D  SAKF14                 1      4
     D  SAKF89                 8      9
     D  SAKCCY                10     12
     D  SAKEVE                 4      4
     D  SAKTYP                19     20
     D  SAKCHA                11     12
      * Base ccy a/c key - debit ccy
     D                 DS
     D  AKDS                   1     14
     D  AKDSCY                 6      8
     D  AKDS8                  8      8
     D  AKDS9                  9      9
     D  AKDS10                10     10
      *
      * Base ccy a/c key
     D                 DS
     D  SAKDS                  1     20
     D  SKDS89                 8      9
     D  SAKDSC                10     12
      *
      * OSAC
     D @OVACC          DS
     D  OVCUST                 1      6
     D  OVACOD                 7     16
     D  OVACSQ                17     18
      *
     D @DEBIT          DS
     D  @DBRCA                 1      3
     D  @DCUST                 4      9
     D  @DCCY                 10     12
     D  @DACOD                13     22
     D  @DACSQ                23     24
      *                                                                                     AR864206
      **------------ Start of parameters for ZAGETSETAC -------------**                     AR864206
      **  -------                                                                           AR864206
      **  Outputs                                                                           AR864206
      **  -------                                                                           AR864206
     D ReturnCode      S              7A                                                    AR864206
     D AccCode         S             10S 0                                                  AR864206
     D AccSeq          S              2S 0                                                  AR864206
     D MemosInd        S              1A                                                    AR864206
     D PronoInd        S              1A                                                    AR864206
      **  ------------                                                                      AR864206
      **  Input/output                                                                      AR864206
      **  ------------                                                                      AR864206
     D Branch          S              3A                                                    AR864206
     D CustNo          S              6A                                                    AR864206
     D Currency        S              3A                                                    AR864206
      **  ------                                                                            AR864206
      **  Inputs                                                                            AR864206
      **  ------                                                                            AR864206
     D SettleType      S              2S 0                                                  AR864206
     D SettleAcc       DS            18                                                     AR864206
     D   WW_AccNum             1      6                                                     AR864206
     D   WW_AccCode            7     16                                                     AR864206
     D   WW_AccSeq            17     18                                                     AR864206
      **------------- End of parameters for ZAGETSETAC --------------**                     AR864206
      *
      **  DS FOR P1 SPOOL FILE NAME
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM                123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      **  DS FOR P2 SPOOL FILE NAME
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
      *
      **  DS FOR AU SPOOL FILE NAME
     D SPOOLA          DS
     D  SFILEA                83     92
     D  SFNUMA               123    124B 0
     D  OFLLNA               188    189B 0
     D  PRTLNA               367    368B 0
     D                 DS
     D  WORK15                 1     15  0
     D*
     D/COPY ZSRSRC,ZDATE9Z2LE
      *
     D W0RTN           S              7                                                     AR864206
     D W0MSG           S            256                                                     AR864206
      *                                                                                     AR864206
     D ##DLEXT         S              1                                                     AR888911
     IFCLTYF
     I              RECI                        RECIF
     I              FCCY                        ECCY
      *
     ICLOANCLF
     I              RECI                        RECIL
      *
     ISEKEYDF
     I              ACKY                        SAKEY
     I              EVCY                        ECCY
     I              EVAM                        EAMT
     I              STLT                        SETP
      *
     ILKEYFEDF
     I              LKRECI                      RECI
     I              LKEAMT                      EAMT
     I              LKEDAT                      EDAT
     I              LKECCY                      ECCY
     I              LKAKEY                      AKEY
     I              LKOTHA                      OTHA
     I              LKOTHC                      OTHC
     I              LKSETP                      SETP
     I              LKCNUM                      CNUM
     I              LKBRCD                      BRCA
     I              LKOSAC                      OSAC
      *
     IDKEYSZZF
     I              RECI                        RECIT
     ILKEY1ZZF
     I              RECI                        RECIT
      *
     ILKEYFEZF
     I              LKRECI                      LKRECT
      *
     IFPKEYZZF
     I              RECI                        RECIT
      *****************************************************************
      * MAIN
      *****************************************************************
      *
      * Initial Process
      *
     C                   EXSR      SRINIT
      *
      * STAMP TAX: Lending
      *
     C     @FILEN        CASEQ     'STLEIN  '    STLEIN
     C     @FILEN        CASEQ     'STLEFE  '    STLEFE
     C     @FILEN        CASEQ     'STLEFC  '    STLEFC
      *
      * STAMP TAX: Money Market Interest Account keys
      *
     C     @FILEN        CASEQ     'STDLIN  '    STDLIN
     C                   ENDCS
      *
      * STAMP TAX: Funds Transfer A/C Keys
      *
     C     @FILEN        CASEQ     'STFTIN  '    STFTIN
     C                   ENDCS
      *
      * STAMP TAX: Securities A/C Keys
      *
     C     @FILEN        CASEQ     'STSEIN  '    STSEIN
     C                   ENDCS
      *
      * End Process
      *
     C                   EXSR      SRTERM
      *
     C/EJECT
      *****************************************************************
      * STLEIN - Stamp Tax: Lending - Interest Account Keys
      *
      * Called From: MAIN
      *
      * Calls:       SRERRT Error on Trailer file
      *              STCALL Call SD008140
      *              STSTAX Calculate Stamp Tax
      *              STACKY Output New A/C Keys for Stamp Tax
      *****************************************************************
      *
     C     STLEIN        BEGSR
      *
      *  Set a/c keys for Base ccy conversion
      *
      *  .....AKEYF =  Debit ccy: STVTX----F---- for all module except FT and SE
      *
     C                   MOVE      *BLANKS       AKEYF            14
     C                   MOVEL     'STVTX'       AKEYF
     C                   MOVE      'F    '       AKEYF
      *
      *  .....AKEYS =  Stamp Tax ccy: STVTX----S----
      *
     C                   MOVE      *BLANKS       AKEYS            14
     C                   MOVEL     'STVTX'       AKEYS
     C                   MOVE      'S    '       AKEYS
      *
      * BASE CURRENCY
      *  .....AKEYA = STVTXsss-A---- (where sss is debit account ccy)
     C                   MOVE      *BLANKS       AKEYA            14
     C                   MOVEL     'STVTX'       AKEYA
     C                   MOVE      'A    '       AKEYA
      *
      * Base Ccy amount
      *   ....AKEYB =  STVTXccc-B---- (where ccc is stamp tax ccy)
      *
     C                   MOVE      *BLANKS       AKEYB            14
     C                   MOVEL     'STVTX'       AKEYB
     C                   MOVE      'B    '       AKEYB
      *
      * Lending A/C Keys Trailer File
      *
     C                   READ      LKEY1ZZF                               41
     C     *IN41         IFEQ      *OFF
     C                   Z-ADD     NORE          @NORE
     C                   Z-ADD     VLRF          @TOTI
     C                   Z-ADD     VLRL          @TOTD
     C                   ELSE
     C                   EXSR      SRERRT
     C                   ENDIF
      *
      * Read all Account Keys records:
      *
     C                   READ      LKEY1DPF                               40
     C     *IN40         DOWEQ     *OFF
      *
     C                   MOVE      *BLANKS       @SEL              1
     C                   MOVE      'N'           @FIXED            1
      *
      *   get loan processing type
      *
     C                   MOVEL     AKLNTY        PLNTY
     C                   MOVEL     AKLNST        PLNST
     C                   MOVEL     AKLNCL        PLNCL
     C                   MOVEL     AKLNCL        WLNCL             4                        AR821875
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    PLNTY             2
     C                   PARM                    PLNST             2
     C                   PARM                    PLNCL             4
     C                   PARM                    SDLOAN
     C     @RTCD         IFNE      *BLANKS
     C                   CLEAR                   SDLOAN
     C                   ENDIF
      *
      * check type of stamp tax for loan type/subtype
      *
     C                   CLEAR                   KC1KEY
     C                   CLEAR                   LC1TFF
     C                   CLEAR                   LC1TFC
     C                   CLEAR                   LC1TFI
     C                   CLEAR                   LC1TFB
     C                   MOVEL     'LOAN'        KC1KEY
     C                   MOVEL     AKLNTY        KC1TTP
     C                   MOVEL     AKLNST        KC1STP
     C     KLCSTP        CHAIN     SDSTTPL0                           91
      *
      *   determine whether record is to be selected:
      *   Interest:
      *   a/c key = xxRyy-rs-I---- or xxRyy-rs-C----
      *
     C     AKEVEN        IFEQ      'R'
      *
     C     AKEVEN        OREQ      'V'
     C     AKF910        ANDEQ     ' D'
      *
     C     AKF910        IFEQ      ' I'
     C     LC1TFI        ANDEQ     'Y'
     C     AKF910        OREQ      ' C'
     C     LC1TFI        ANDEQ     'Y'
     C     AKF910        OREQ      ' D'
     C     LC1TFI        ANDEQ     'Y'
      *
     C     AKFLD7        IFEQ      ' '
     C     AKFLD7        OREQ      'R'
      *
     C     AKFLD8        IFEQ      ' '
     C     AKFLD8        OREQ      'S'
     C                   MOVE      'Y'           @SEL
     C                   MOVE      'I'           PRINFL            1                        AR871632
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *  Start of Term Loan
      *  a/c key = xxVyy----A----
      *
     C                   MOVEL     *BLANKS       @PRIN             1
     C                   MOVEL     *BLANKS       @PERD             1
     C     @SEL          IFEQ      *BLANKS
     C     AKEVEN        ANDEQ     'V'
     C     AKF910        ANDEQ     ' A'
     C     AKFCCY        ANDEQ     *BLANKS
     C     @SEL          OREQ      *BLANKS
     C     AKEVEN        ANDEQ     'V'
     C     AKF910        ANDEQ     'IA'
     C     AKFCCY        ANDEQ     *BLANKS
     C     LC1TFF        IFEQ      'Y'
     C                   MOVE      'Y'           @SEL
     C                   MOVE      'Y'           @FIXED
     C                   MOVEL     'Y'           @PRIN
     C                   MOVE      'P'           PRINFL                                     AR871632
     C                   ENDIF
     C                   ENDIF
      *
      * Record Selected
      * ----------------
      *
     C     @SEL          IFEQ      'Y'
      *
      *
      * Set Debit ccy and Stamp Tax account keys
      *
     C                   MOVE      AKEY          AKDS             14
     C                   MOVE      'F'           AKDS9
      *
      *   Stamp Tax Interest/Capitalisation account key
      *   ---------------------------------------------
      *   AKEYDR = a/c key = xxRyy-rsFI---- or xxRyy-rsFC---- in Debit Account ccy
     C                   MOVE      AKDS          AKEYDR           14
      *
      *   AKEYST = a/c key = xxRyy-rsSI---- or xxRyy-rsSC---- in Stamp Tax currency
      *
     C                   MOVE      'S'           AKDS9
     C                   MOVE      AKDS          AKEYST           14
      *
      * If principal key then reset 10th character to an L
      *
     C     @PRIN         IFEQ      'Y'
     C                   MOVE      'L    '       AKEYDR
     C                   MOVE      'L    '       AKEYST
     C                   ENDIF
      *
      * Access record on Stamp Tax - Transactions ext. file
      *
     C                   MOVEL     LNNO          @T1LNR                                     AR824335
     C                   MOVE      *BLANKS       LQTAX
     C     LNNO          CHAIN     CLONCLL1                           75
      *
     C     *IN75         IFEQ      *OFF
     C     LQTAX         ANDEQ     'Y'
     C*****LQPDTE        ANDLE     BJRDNB                                          AR824338 AR871632
     C*****LQPDTE        ANDNE     *ZEROS                                          AR824338 AR871632
     C                   EXSR      SRINCL                                                   AR871632
     C                   IF        STINCL = 'Y'                                             AR871632
      *
      * Retrieve Settlement Branch Details
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      LQDBRC        @DSNB             3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      * ....error
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     LQDBRC        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     052           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C**********         ENDIF                                                              AR824338
      *
     C                   MOVE      'LOAN      '  T#KEY            10
     C                   MOVEL     'LOAN      '  @T1KEY                                     AR942819
     C**********         Z-ADD     LNNO          T#LNRF            6 0                        CLE148
     C                   MOVE      LNNO          T#LNRF            6                          CLE148
     C                   MOVE      *BLANKS       T#FCNM            6
     C                   Z-ADD     0             T#FACT            3 0
     C                   Z-ADD     0             T#FCNO            2 0
     C                   Z-ADD     0             T#FSEQ            2 0
     C                   Z-ADD     0             T#ORED            5 0
     C                   Z-ADD     0             T#DLNO            6 0
     C                   MOVE      *BLANKS       T#TDRF            6
     C                   MOVE      *BLANKS       T#BRCA            3
     C                   MOVE      *BLANKS       T#CNUM            6
     C                   MOVE      *BLANKS       T#CCY             3
     C                   Z-ADD     0             T#ACOD           10 0
     C                   Z-ADD     0             T#ACSQ            2 0
     C                   MOVE      *BLANKS       T#PREF           15
     C                   Z-ADD     0             T#CQSQ            2 0
     C                   MOVE      *BLANKS       T#PBRC            3
     C                   MOVE      *BLANKS       T#PSSH           10
     C                   MOVE      *BLANKS       T#PCPY            6
     C                   Z-ADD     0             T#PDUD            5 0
     C                   MOVE      *BLANKS       T#PEVT            2
     C                   MOVE      LQDCST        T#DCST            6
     C                   MOVE      LQDCCY        T#DCCY            3
     C                   MOVE      LQDACD        T#DACD           10
     C                   MOVE      LQDASC        T#DASQ            2
     C                   MOVE      LQDBRC        T#DBRC            3
     C                   Z-ADD     0             @T1ORD                                     AR853257
     C                   MOVEL     LQLTYP        @T2TYP                                     AR853257
     C                   MOVE      LQLSTP        @T2TYP                                     AR853257
     C                   EXSR      STCALL
      *
      * Get Stamp Tax CCY details
      *
     C     @TXRAT        IFEQ      0
     C                   MOVE      'N'           LQTAX
     C                   ELSE
      *
     C                   MOVE      @TXCCY        @AJCD
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATET
     C                   MOVE      A6MDIN        ZMDIT
     C                   MOVE      A6INCY        ZINCYT
     C                   MOVE      A6NBDP        ZNBDPT
     C                   ENDIF
      *
     C     LQTAX         IFEQ      'Y'
      *
      * Calculate/Set Tax amount + get ccy details + post stamp tax
      *
     C                   EXSR      STSTAX
      *
      * If principal key then set period as read from SDSTMDL0
      *
     C     @PRIN         IFEQ      'Y'
     C                   MOVEL     AKEYDR        AKDS
     C                   MOVEL     @PERD         AKDS8
     C                   MOVEL     AKDS          AKEYDR
     C                   MOVEL     AKEYST        AKDS
     C                   MOVEL     @PERD         AKDS8
     C                   MOVEL     AKDS          AKEYST
     C                   ENDIF
      *
      * Output Keys to Lending Account Keys File
      *
     C     @TAXE         CASNE     *ZEROS        STACKY
     C                   ENDCS
      *
     C                   ENDIF
     C                   ENDIF                                                              AR871632
     C                   ENDIF                                                              AR824338
      *
     C                   ENDIF
      *
     C                   READ      LKEY1DPF                               40
     C                   ENDDO
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************                     AR871632
      * SRINCL - Check if current record is to be included in stamp tax                     AR871632
      *                                                                                     AR871632
      * Called From: STLEIN, STLEFE, STLEFC & STDLIN                                        AR871632
      *                                                                                     AR871632
      * Calls:       NONE                                                                   AR871632
      *****************************************************************                     AR871632
      *                                                                                     AR871632
     C     SRINCL        BEGSR                                                              AR871632
      *                                                                                     AR871632
     C                   MOVE      'Y'           STINCL            1                        AR871632
      *                                                                                     AR871632
     C                   IF        @FILEN = 'STLEIN'                                        AR871632
      *                                                                                     AR871632
     C                   SELECT                                                             AR871632
     C                   WHEN      PRINFL = 'P'                                             AR871632
      *                                                                                     AR871632
     C                   IF        (LQPRIN <> 'Y')  OR                                      AR871632
     C                             NOT(LQPDTE = 0) AND                                      AR871632
     C                             (LQPDTE > BJRDNB)                                        AR871632
     C                   MOVE      'N'           STINCL                                     AR871632
     C                   GOTO      EXIT                                                     AR871632
     C                   ENDIF                                                              AR871632
      *                                                                                     AR871632
     C                   WHEN      PRINFL = 'I'                                             AR871632
      *                                                                                     AR871632
     C                   IF        (LQSINT <> 'Y') OR                                       AR871632
     C                             NOT(LQIDTE = 0) AND                                      AR871632
     C                             (LQIDTE > BJRDNB)                                        AR871632
     C                   MOVE      'N'           STINCL                                     AR871632
     C                   GOTO      EXIT                                                     AR871632
     C                   ENDIF                                                              AR871632
      *                                                                                     AR871632
     C                   OTHER                                                              AR871632
     C                   MOVE      'N'           STINCL                                     AR871632
     C                   ENDSL                                                              AR871632
      *                                                                                     AR871632
     C                   ELSEIF    @FILEN = 'STDLIN'                                        AR871632
      *                                                                                     AR871632
     C                   SELECT                                                             AR871632
     C                   WHEN      PRINFL = 'P'                                             AR871632
      *                                                                                     AR871632
     C                   IF        (F1PRIN <> 'Y') OR                                       AR871632
     C                             NOT(F1PDTE = 0) AND                                      AR871632
     C                             (F1PDTE > BJRDNB)                                        AR871632
     C                   MOVE      'N'           STINCL                                     AR871632
     C                   GOTO      EXIT                                                     AR871632
     C                   ENDIF                                                              AR871632
      *                                                                                     AR871632
     C                   WHEN      PRINFL = 'I'                                             AR871632
      *                                                                                     AR871632
     C                   IF        (F1SINT <> 'Y') OR                                       AR871632
     C                             NOT(F1IDTE = 0) AND                                      AR871632
     C                             (F1IDTE > BJRDNB)                                        AR871632
     C                   MOVE      'N'           STINCL                                     AR871632
     C                   GOTO      EXIT                                                     AR871632
     C                   ENDIF                                                              AR871632
      *                                                                                     AR871632
     C                   OTHER                                                              AR871632
     C                   MOVE      'N'           STINCL                                     AR871632
     C                   ENDSL                                                              AR871632
      *                                                                                     AR871632
     C                   ELSEIF    @FILEN = 'STLEFE'                                        AR871632
      *                                                                                     AR871632
     C                   IF        (FQHFLF <> 'Y') OR                                       AR871632
     C                             NOT(FQHDTE = 0) AND                                      AR871632
     C                             (FQHDTE > BJRDNB)                                        AR871632
     C                   MOVE      'N'           STINCL                                     AR871632
     C                   GOTO      EXIT                                                     AR871632
     C                   ENDIF                                                              AR871632
      *                                                                                     AR871632
     C                   ELSEIF    @FILEN = 'STLEFC'                                        AR871632
      *                                                                                     AR871632
     C                   IF        (FCPRIN <> 'Y') OR                                       AR871632
     C                             NOT(FCPDTE = 0) AND                                      AR871632
     C                             (FCPDTE > BJRDNB)                                        AR871632
     C                   MOVE      'N'           STINCL                                     AR871632
     C                   GOTO      EXIT                                                     AR871632
     C                   ENDIF                                                              AR871632
     C                   ELSE                                                               AR871632
     C                   MOVE      'N'           STINCL                                     AR871632
      *                                                                                     AR871632
     C                   ENDIF                                                              AR871632
      *                                                                                     AR871632
     C     EXIT          TAG                                                                AR871632
     C                   ENDSR                                                              AR871632
      *                                                                                     AR871632
      *****************************************************************
      * STLEFE - Stamp Tax: Lending - Fees Account Keys
      *
      * Called From: MAIN
      *
      * Calls:       SRERRT Error on Trailer file
      *              STCALL Call SD008140
      *              STSTAX Calculate Stamp Tax
      *              STACKY Generate Stamp Tax a/c keys
      *****************************************************************
      *
     C     STLEFE        BEGSR
      *
      *  Set a/c keys for Base ccy conversion
      *
      *  .....AKEYF =  Debit ccy: STVTX----F---- for all module except FT and SE
      *
     C                   MOVE      *BLANKS       AKEYF
     C                   MOVEL     'STVTX'       AKEYF
     C                   MOVE      'F    '       AKEYF
      *
      *  .....AKEYS =  Stamp Tax ccy: STVTX----S---- for all modules except FT and SE
      *
     C                   MOVE      *BLANKS       AKEYS
     C                   MOVEL     'STVTX'       AKEYS
     C                   MOVE      'S    '       AKEYS
      *
      * BASE CURRENCY
      *  .....AKEYA = STVTXsss-A---- (where sss is debit account ccy) except FT and SE
     C                   MOVE      *BLANKS       AKEYA
     C                   MOVEL     'STVTX'       AKEYA
     C                   MOVE      'A    '       AKEYA
      *
      * Base Ccy amount
      *   ....AKEYB =  STVTXccc-B---- (where ccc is stamp tax ccy)
      *
     C                   MOVE      *BLANKS       AKEYB
     C                   MOVEL     'STVTX'       AKEYB
     C                   MOVE      'B    '       AKEYB
      *
      * Lending Fees A/C Keys Trailer File
      *
     C                   READ      LKEYFEZF                               41
     C     *IN41         IFEQ      *OFF
     C                   Z-ADD     LKNORE        @NORE
     C                   Z-ADD     LKVLRF        @TOTI
     C                   Z-ADD     LKVLRL        @TOTD
     C                   ELSE
     C                   EXSR      SRERRT
     C                   ENDIF
      *
      * Read all Account Keys records:
      *
     C                   READ      LKEYFED                                40
     C     *IN40         DOWEQ     *OFF
      *
      *   determine whether record is to be selected:
      *
     C                   MOVE      *BLANKS       @SEL
     C                   MOVE      'N'           @FIXED
      *
      *   FACILITY/LOANS FEE Start/End Dates:
      *
      *   a/c key = xxRyySrnnF---- - xxRyy-rnnF---- (Loans)
      *             where xx is Loan type; yy is Loan subtype
      *
      *   a/c key = fffR-S-nnF---- - fffR---nnF---- (Facility)
      *             where fff is the facility type
      *
     C     AKEVEN        IFEQ      'R'
     C     AKEVEN        ORGE      '0'
     C     AKFLD4        ANDEQ     'R'
      *
     C     AKFLD6        IFEQ      'S'
     C     AKFLD6        OREQ      ' '
      *
     C     AKFLD7        IFEQ      ' '
     C     AKFLD7        OREQ      'R'
      *
      * Position 9 must not contain 'F' as this is a Stamp Tax account
      * key.
      *
     C     AKFLD9        IFNE      'F'
     C     AKTYPE        ANDEQ     'F'
     C                   MOVE      'Y'           @SEL
     C**********         MOVE      'N'           @FIXED                                     AR881680
     C                   MOVE      'Y'           @FIXED                                     AR881680
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * Record Selected
      *
     C     @SEL          IFEQ      'Y'
      *
      *
      *   Stamp Tax Start and End Fees Date
      *   ---------------------------------
      *   AKEYDR = a/c key = xxRyySr-FF---- or xxRyySr-SF---- in Debit Account ccy
      *   AKEYDR = a/c key = xxRyy-r-FF---- or xxRyySr-SF---- in Debit Account ccy
      *
     C                   MOVE      AKEY          AKDS
     C                   MOVE      ' '           AKDS8
     C                   MOVE      'F'           AKDS9
     C                   MOVE      AKDS          AKEYDR
      *
      *   AKEYST = a/c key = xxRyySrsSF---- or xxRyySrsSF---- in Stamp Tax currency
      *   AKEYST = a/c key = xxRyy-rsSF---- or xxRyy-rsSF---- in Stamp Tax currency
      *
     C                   MOVE      'S'           AKDS9
     C                   MOVE      AKDS          AKEYST
      *
      * Access record on Stamp Tax - Transactions ext. file
      *
     C                   MOVE      *BLANKS       FQTAX
      *
     C     KFEE          KLIST
     C                   KFLD                    @T1FCU
     C                   KFLD                    @T1FCT
     C                   KFLD                    @T1LNR
     C                   KFLD                    @T1FSQ
     C                   KFLD                    @T1ORD
     C     KFEE1         KLIST                                                              AR853257
     C                   KFLD                    @T1FCU                                     AR853257
     C                   KFLD                    @T1FCT                                     AR853257
     C                   KFLD                    @T1LNR                                     AR853257
     C                   KFLD                    @T1FSQ                                     AR853257
      *
     C                   MOVE      LKLNNO        FEE16
     C                   MOVEL     *ZEROS        @T1FCT                                     AR824335
     C     RECI          IFEQ      'F'
     C**********         MOVE      CNUM          @T1FCU                                     AR824335
     C                   MOVEL     FEE2          @T1FCT
     C                   MOVE      FEE3          @T1FCT
     C                   ELSE
     C                   MOVE      LKLNNO        @T1LNR
     C                   ENDIF
     C                   MOVE      CNUM          @T1FCU                                     AR824335
     C                   MOVE      FEFSEQ        @T1FSQ
     C                   MOVE      FEORED        @T1ORD
      *
     C     KFEE          CHAIN     LEFEEQL1                           75
     C     KFEE1         CHAIN     LEFEEDL1                           76                    AR853257
      *
     C     *IN75         IFEQ      *OFF
     C     *IN76         ANDEQ     *OFF                                                     AR853257
     C     FQTAX         ANDEQ     'Y'
     C*****FQHDTE        ANDLE     BJRDNB                                          AR824338 AR871632
     C*****FQHDTE        ANDNE     *ZEROS                                          AR824338 AR871632
     C                   EXSR      SRINCL                                                   AR871632
     C                   IF        STINCL = 'Y'                                             AR871632
      *
      * Retrieve Settlement Branch Details
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FQDBRC        @DSNB
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      * ....error
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     FQDBRC        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     060           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C**********         ENDIF                                                              AR824338
      *
     C                   MOVE      'FEE       '  T#KEY
     C**********         Z-ADD     LKLNNO        T#LNRF                                       CLE148
     C                   MOVE      LKLNNO        T#LNRF                                       CLE148
     C                   MOVE      CNUM          T#FCNM
     C                   MOVEL     FEE2          T#FACT
     C                   MOVEL     FEE3          T#FCNO
     C                   Z-ADD     FEFSEQ        T#FSEQ
     C                   Z-ADD     FEORED        T#ORED
     C                   Z-ADD     0             T#DLNO
     C                   MOVE      *BLANKS       T#TDRF
     C                   MOVE      *BLANKS       T#BRCA
     C                   MOVE      *BLANKS       T#CNUM
     C                   MOVE      *BLANKS       T#CCY
     C                   Z-ADD     0             T#ACOD
     C                   Z-ADD     0             T#ACSQ
     C                   MOVE      *BLANKS       T#PREF
     C                   Z-ADD     0             T#CQSQ
     C                   MOVE      *BLANKS       T#PBRC
     C                   MOVE      *BLANKS       T#PSSH
     C                   MOVE      *BLANKS       T#PCPY
     C                   Z-ADD     0             T#PDUD
     C                   MOVE      *BLANKS       T#PEVT
     C                   MOVE      FQDCST        T#DCST
     C                   MOVE      FQDCCY        T#DCCY
     C                   MOVE      FQDACD        T#DACD
     C                   MOVE      FQDASC        T#DASQ
     C                   MOVE      FQDBRC        T#DBRC
     C                   MOVEL (P) FEFCOD        @T2TYP                                     AR853257
     C                   EXSR      STCALL
      *
      * Get Stamp Tax CCY details
      *
     C     @TXRAT        IFEQ      0
     C                   MOVE      'N'           FQTAX
     C                   ELSE
      *
     C                   MOVE      @TXCCY        @AJCD
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATET
     C                   MOVE      A6MDIN        ZMDIT
     C                   MOVE      A6INCY        ZINCYT
     C                   MOVE      A6NBDP        ZNBDPT
     C                   ENDIF
      *
     C     FQTAX         IFEQ      'Y'
      *
      * Calculate/Set Tax amount + get ccy details
      *
     C                   EXSR      STSTAX
      *
      * Output Keys to Lending Fees Account Keys File
      *
     C     @TAXE         CASNE     *ZEROS        STACKY
     C                   ENDCS
      *
     C                   ENDIF
     C                   ENDIF                                                              AR871632
     C                   ENDIF                                                              AR824338
      *
     C                   ENDIF
      *
     C                   READ      LKEYFEDF                               40
     C                   ENDDO
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STLEFC - Stamp Tax: Lending - Facilities A/C Keys
      *
      * Called From: MAIN
      *
      * Calls:       SRERRT Error on Trailer file
      *              STCALL Call SD008140
      *              STSTAX Calculate Stamp Tax
      *              STACKY Generate Stamp Tax a/c keys
      *****************************************************************
      *
     C     STLEFC        BEGSR
      *
      *  Set a/c keys for Base ccy conversion
      *
      *  .....AKEYF =  Debit ccy: STVTX----F---- for all module except FT and SE
      *
     C                   MOVE      *BLANKS       AKEYF
     C                   MOVEL     'STVTX'       AKEYF
     C                   MOVE      'F    '       AKEYF
      *
      *  .....AKEYS =  Stamp Tax ccy: STVTX----S---- for all modules except FT and SE
      *
     C                   MOVE      *BLANKS       AKEYS
     C                   MOVEL     'STVTX'       AKEYS
     C                   MOVE      'S    '       AKEYS
      *
      * BASE CURRENCY
      *  .....AKEYA = STVTXsss-A---- (where sss is debit account ccy) except FT and SE
     C                   MOVE      *BLANKS       AKEYA
     C                   MOVEL     'STVTX'       AKEYA
     C                   MOVE      'A    '       AKEYA
      *
      * Base Ccy amount
      *   ....AKEYB =  STVTXccc-B---- (where ccc is stamp tax ccy)
      *
     C                   MOVE      *BLANKS       AKEYB
     C                   MOVEL     'STVTX'       AKEYB
     C                   MOVE      'B    '       AKEYB
      *
      * Clear a/ck output file
     C                   CLEAR                   LKEYFEDF
      *
      * Lending Fees A/C Keys Trailer File
      *
     C                   READ      LKEYFEZF                               41
     C     *IN41         IFEQ      *OFF
     C                   Z-ADD     LKNORE        @NORE
     C                   Z-ADD     LKVLRF        @TOTI
     C                   Z-ADD     LKVLRL        @TOTD
     C                   ELSE
     C                   EXSR      SRERRT
     C                   ENDIF
      *
      * Read Facilities file
      *
     C                   READ      FCLTY1                                 40
     C     *IN40         DOWEQ     *OFF
      *
      *   determine whether record is to be selected:
      *
     C                   MOVE      *BLANKS       @SEL
     C                   MOVE      'Y'           @FIXED
      *
      *   Facility Start
      *
     C     DTAP          IFGE      BJRDNB
     C     DTAP          ANDLE     ECD
      *
     C     DTAP          ORLT      BJRDNB
     C     ORED          ANDEQ     BJRDNB
     C                   MOVE      'Y'           @SEL
     C                   ENDIF
      *
      * Record Selected
      *
     C     @SEL          IFEQ      'Y'
      *
      *
      * move facilities fields to a/c key fields
      *
     C                   MOVE      'F'           RECI
     C                   MOVE      *BLANKS       AKEY
     C                   MOVE      FACT          AKF13
     C                   MOVE      'R'           AKFLD4
     C                   MOVE      'S'           AKFLD6
      *
      *   AKEYDR = a/c key = fffR-S--FG---- in Debit account currency
     C                   MOVE      'FG'          AKF910
     C                   MOVE      AKEY          AKEYDR
      *
      *   AKEYST = a/c key = fffR-S--SG---- in Stamp Tax currency
     C                   MOVE      'SG'          AKF910
     C                   MOVE      AKEY          AKEYST
      *
     C                   Z-ADD     ECD           EDAT
     C                   Z-ADD     FAMT          LKFAMT
      *
      * Access record on Stamp Tax - Transactions ext. file
      *
     C                   MOVE      *BLANKS       FCTAX
      *
     C     KFCLT         KLIST
     C                   KFLD                    @T1FCU
     C                   KFLD                    @T#FAC
     C                   KFLD                    @T#FCN
      *
     C                   MOVE      CNUM          @T1FCU
     C                   MOVE      FACT          @T1FAC
     C                   MOVE      FCNO          @T1FCN
     C                   MOVE      FACT          @T#FAC            3
     C                   MOVE      FCNO          @T#FCN            2
      *
     C     KFCLT         CHAIN     LEFCLTLH                           75
      *
     C     *IN75         IFEQ      *OFF
     C     FCTAX         ANDEQ     'Y'
     C*****FCPDTE        ANDLE     BJRDNB                                          AR824338 AR871632
     C*****FCPDTE        ANDNE     *ZEROS                                          AR824338 AR871632
     C                   EXSR      SRINCL                                                   AR871632
     C                   IF        STINCL = 'Y'                                             AR871632
      *
      * Retrieve Settlement Branch Details
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FCDBRC        @DSNB
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      * ....error
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     FCDBRC        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     061           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C**********         ENDIF                                                              AR824338
      *
     C                   MOVE      'FACILITY  '  T#KEY
     C**********         Z-ADD     0             T#LNRF                                       CLE148
     C                   MOVE      *BLANKS       T#LNRF                                       CLE148
     C                   MOVE      CNUM          T#FCNM
     C                   Z-ADD     FACT          T#FACT
     C                   Z-ADD     FCNO          T#FCNO
     C                   Z-ADD     0             T#FSEQ
     C                   Z-ADD     0             T#ORED
     C                   Z-ADD     0             T#DLNO
     C                   MOVE      *BLANKS       T#TDRF
     C                   MOVE      *BLANKS       T#BRCA
     C                   MOVE      *BLANKS       T#CNUM
     C                   MOVE      *BLANKS       T#CCY
     C                   Z-ADD     0             T#ACOD
     C                   Z-ADD     0             T#ACSQ
     C                   MOVE      *BLANKS       T#PREF
     C                   Z-ADD     0             T#CQSQ
     C                   MOVE      *BLANKS       T#PBRC
     C                   MOVE      *BLANKS       T#PSSH
     C                   MOVE      *BLANKS       T#PCPY
     C                   Z-ADD     0             T#PDUD
     C                   MOVE      *BLANKS       T#PEVT
     C                   MOVE      FCDCST        T#DCST
     C                   MOVE      FCDCCY        T#DCCY
     C                   MOVE      FCDACD        T#DACD
     C                   MOVE      FCDASC        T#DASQ
     C                   MOVE      FCDBRC        T#DBRC
     C                   EXSR      STCALL
      *
      * Get Stamp Tax CCY details
      *
     C     @TXRAT        IFEQ      0
     C                   MOVE      'N'           FCTAX
     C                   ELSE
      *
     C                   MOVE      @TXCCY        @AJCD
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATET
     C                   MOVE      A6MDIN        ZMDIT
     C                   MOVE      A6INCY        ZINCYT
     C                   MOVE      A6NBDP        ZNBDPT
     C                   ENDIF
      *
     C     FCTAX         IFEQ      'Y'
      *
      * Calculate/Set Tax amount + get ccy details
      *
     C                   EXSR      STSTAX
      *
      * Output Keys to Lending Fees Account Keys File
      *
     C     @TAXE         CASNE     *ZEROS        STACKY
     C                   ENDCS
      *
      * If reversal has been done, output new flat amount
      *
     C                   ENDIF
     C                   ENDIF                                                              AR871632
     C                   ENDIF                                                              AR824338
      *
     C                   ENDIF
      *
     C                   READ      FCLTY1                                 40
     C                   ENDDO
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STDLIN - Stamp Tax: Money Market - Interest Account Key
      *
      * Called From: MAIN
      *
      * Calls:       SRERRT Error on Trailer file
      *              STCHAI - Access to DLDLDCL3
      *              STSTAX - Calculate tax
      *              STACKY - Generate Stamp Tax a/c Keys
      *****************************************************************
      *
     C     STDLIN        BEGSR
      *
      *  Set a/c keys for Base ccy conversion
      *
      *  .....AKEYF =  Debit ccy: STVTX----F---- for all module except FT and SE
      *
     C                   MOVE      *BLANKS       AKEYF
     C                   MOVEL     'STVTX'       AKEYF
     C                   MOVE      'F    '       AKEYF
      *
      *  .....AKEYS =  Stamp Tax ccy: STVTX----S---- for all modules except FT and SE
      *
     C                   MOVE      *BLANKS       AKEYS
     C                   MOVEL     'STVTX'       AKEYS
     C                   MOVE      'S    '       AKEYS
      *
      * BASE CURRENCY
      *  .....AKEYA = STVTXsss-A---- (where sss is debit account ccy) except FT and SE
     C                   MOVE      *BLANKS       AKEYA
     C                   MOVEL     'STVTX'       AKEYA
     C                   MOVE      'A    '       AKEYA
      *
      * Base Ccy amount
      *   ....AKEYB =  STVTXccc-B---- (where ccc is stamp tax ccy)
      *
     C                   MOVE      *BLANKS       AKEYB
     C                   MOVEL     'STVTX'       AKEYB
     C                   MOVE      'B    '       AKEYB
      *
      * Dealing A/C Keys Trailer File
      *
     C                   READ      DKEYSZZF                               41
     C     *IN41         IFEQ      *OFF
     C                   Z-ADD     NORE          @NORE
     C                   Z-ADD     HRWN          @TOTI
     C                   Z-ADD     HRDC          @TOTD
     C                   ELSE
     C                   EXSR      SRERRT
     C                   ENDIF
      *
      * Read all Account Keys records:
      *
     C                   READ      DKEYSDPF                               40
     C     *IN40         DOWEQ     *OFF
      *
      *   determine whether record is to be selected:
      *
     C                   MOVE      *BLANKS       @SEL
     C                   MOVE      'N'           @FIXED
      *
      *   Up Front Interest Amount:
      *   a/c key = xxVyy----I----
      *
     C     AKEVEN        IFEQ      'V'
     C     AKFCCY        ANDEQ     *BLANKS
     C     AKF910        ANDEQ     ' I'
     C                   MOVE      'Y'           @SEL
     C                   MOVE      'I'           PRINFL                                     AR871632
     C                   ENDIF
      *
      *   Interest Due Amount:
      *   a/c key = xxIyy----I----
      *
     C     AKEVEN        IFEQ      'I'
     C     AKFCCY        ANDEQ     *BLANKS
     C     AKF910        ANDEQ     ' I'
     C                   MOVE      'Y'           @SEL
     C                   MOVE      'I'           PRINFL                                     AR871632
     C                   ENDIF
      *
      *   Net Int. to be capitalised:
      *   a/c key = xxIyy----C----
      *
     C     AKEVEN        IFEQ      'I'
     C     AKFCCY        ANDEQ     *BLANKS
     C     AKF910        ANDEQ     ' C'
     C                   MOVE      'Y'           @SEL
     C                   MOVE      'I'           PRINFL                                     AR871632
     C                   ENDIF
      *
      *   Gross Interest due at Maturity:
      *   a/c key = xxMyy----I----
      *
     C     AKEVEN        IFEQ      'M'
     C     AKFCCY        ANDEQ     *BLANKS
     C     AKF910        ANDEQ     ' I'
     C                   MOVE      'Y'           @SEL
     C                   MOVE      'I'           PRINFL                                     AR871632
     C                   ENDIF
      *
      *  Start of Term Loan:
      *  a/c key = xxVyy----A----
      *
     C     @SEL          IFEQ      *BLANKS
     C     AKEVEN        ANDEQ     'V'
     C     AKF910        ANDEQ     ' A'
     C     AKFCCY        ANDEQ     *BLANKS
     C                   MOVE      'Y'           @SEL
     C                   MOVE      'Y'           @FIXED
     C                   MOVE      'P'           PRINFL                                     AR871632
     C                   ENDIF
      *                                                                                     AR824335
      *  Principal Increase:                                                                AR824335
      *  a/c key = xxVyy---IA----                                                           AR824335
      *                                                                                     AR824335
     C     @SEL          IFEQ      *BLANKS                                                  AR824335
     C     AKEVEN        ANDEQ     'V'                                                      AR824335
     C     AKF910        ANDEQ     'IA'                                                     AR824335
     C     AKFCCY        ANDEQ     *BLANKS                                                  AR824335
     C                   MOVE      'Y'           @SEL                                       AR824335
     C                   MOVE      'Y'           @FIXED                                     AR824335
     C                   MOVE      'P'           PRINFL                                     AR871632
     C                   ENDIF                                                              AR824335
      *
      * Record Selected
      *
     C     @SEL          IFEQ      'Y'
      *          -----------------                         ----------
      *
      * Set Debit ccy and Stamp Tax account keys
      *
     C                   MOVE      AKEY          AKDS
     C                   MOVE      'F'           AKDS9
      *
      *   AKEYDR = a/c key = xxVyy---FI---- or xxIyy---FI---- or
      *   xxIyy---FC---- or xxMyy---FI---- in Dr ccy
     C                   MOVE      AKDS          AKEYDR
      *
      *   AKEYST = a/c key = xxVyy---SI---- or xxIyy---SI---- or
      *   xxIyy---SC---- or xxMyy---SI---- in Stamp ccy
     C                   MOVE      'S'           AKDS9
     C                   MOVE      AKDS          AKEYST
      *
      * Access record on Stamp Tax - Transactions ext. file
      *
     C                   MOVE      *BLANKS       F1TAX
     C                   MOVE      DLNO          @T1DLN                                     AR824335
     C                   MOVE      DLNO          DLNOA             6
      *
     C     DLNOA         CHAIN     DLDLDCL3                           75
      *
     C     *IN75         IFEQ      *OFF
     C     F1TAX         ANDEQ     'Y'
     C*****F1PDTE        ANDLE     BJRDNB                                          AR824338 AR871632
     C*****F1PDTE        ANDNE     *ZEROS                                          AR824338 AR871632
     C                   EXSR      SRINCL                                                   AR871632
     C                   IF        STINCL = 'Y'                                             AR871632
      *
      * Retrieve Settlement Branch Details
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      F1DBRC        @DSNB
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      * ....error
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     F1DBRC        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     062           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C**********         ENDIF                                                              AR824338
      *
     C                   MOVE      'DEAL      '  T#KEY
     C                   MOVE      'DEAL      '  @T1KEY                                     AR942819
     C**********         Z-ADD     0             T#LNRF                                       CLE148
     C                   MOVE      *BLANKS       T#LNRF                                       CLE148
     C                   MOVE      *BLANKS       T#FCNM
     C                   Z-ADD     0             T#FACT
     C                   Z-ADD     0             T#FCNO
     C                   Z-ADD     0             T#FSEQ
     C                   Z-ADD     0             T#ORED
     C                   Z-ADD     DLNO          T#DLNO
     C                   MOVE      *BLANKS       T#TDRF
     C                   MOVE      *BLANKS       T#BRCA
     C                   MOVE      *BLANKS       T#CNUM
     C                   MOVE      *BLANKS       T#CCY
     C                   Z-ADD     0             T#ACOD
     C                   Z-ADD     0             T#ACSQ
     C                   MOVE      *BLANKS       T#PREF
     C                   Z-ADD     0             T#CQSQ
     C                   MOVE      *BLANKS       T#PBRC
     C                   MOVE      *BLANKS       T#PSSH
     C                   MOVE      *BLANKS       T#PCPY
     C                   Z-ADD     0             T#PDUD
     C                   MOVE      *BLANKS       T#PEVT
     C                   MOVE      F1DCST        T#DCST
     C                   MOVE      F1DCCY        T#DCCY
     C                   MOVE      F1DACD        T#DACD
     C                   MOVE      F1DASC        T#DASQ
     C                   MOVE      F1DBRC        T#DBRC
     C                   Z-ADD     0             @T1ORD                                     AR853257
     C                   MOVEL     F1DTYP        @T2TYP                                     AR853257
     C                   MOVE      F1DSTP        @T2TYP                                     AR853257
     C                   EXSR      STCALL
      *
      * Get Stamp Tax CCY details
      *
     C     @TXRAT        IFEQ      0
     C                   MOVE      'N'           F1TAX
     C                   ELSE
      *
     C                   MOVE      @TXCCY        @AJCD
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATET
     C                   MOVE      A6MDIN        ZMDIT
     C                   MOVE      A6INCY        ZINCYT
     C                   MOVE      A6NBDP        ZNBDPT
     C                   ENDIF
      *
     C     F1TAX         IFEQ      'Y'
      *
      * Calculate/Set Tax amount + get ccy details
      *
     C                   EXSR      STSTAX
      *
      * Generate Dealing A/C keys
      *
     C     @TAXE         CASNE     *ZEROS        STACKY
     C                   ENDCS
      *
     C                   ENDIF
     C                   ENDIF                                                              AR871632
     C                   ENDIF                                                              AR824338
      *
     C                   ENDIF
      *
     C                   READ      DKEYSDPF                               40
     C                   ENDDO
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STFTIN - Stamp Tax: Funds Transfer Account Keys
      *
      * Called From: MAIN
      *
      * Calls:       SRERRT - Error on Trailer file
      *              STCHAI - Access to SDSTMPPD
      *              STSTAX - Calculate tax
      *              STACKY - Generate Stamp Tax a/c Keys
      *****************************************************************
      *
     C     STFTIN        BEGSR
     C                   MOVE      *BLANKS       WMISC                                      AR871641
      *
      *  .....AKEYF =   debit ccy: STVFT----F---- if FT
      *
     C                   MOVE      *BLANKS       AKEYF
     C                   MOVEL     'STVFT'       AKEYF
     C                   MOVE      'F    '       AKEYF
      *
      *  .....AKEYS =   stamp tax: STVFT----S---- if FT
      *
     C                   MOVE      *BLANKS       AKEYS
     C                   MOVEL     'STVFT'       AKEYS
     C                   MOVE      'S    '       AKEYS
      *
      * BASE CURRENCY
      *  .....AKEYA = STVFTsss-A     (where sss is dr acc ccy)
     C                   MOVE      *BLANKS       AKEYA
     C                   MOVEL     'STVFT'       AKEYA
     C                   MOVE      'A    '       AKEYA
      *
      * Base Ccy amount
      *  .....AKEYB = STVFTccc-B---- (where ccc is stamp tax ccy)
      *
     C                   MOVE      *BLANKS       AKEYB
     C                   MOVEL     'STVFT'       AKEYB
     C                   MOVE      'B    '       AKEYB
      *
      * FT A/C Keys Trailer File
      *
     C                   READ      FPKEYZZF                               41
     C     *IN41         IFEQ      *OFF
     C                   Z-ADD     NORE1         @NORE
     C                   Z-ADD     HRWN          @TOTI
     C                   Z-ADD     HRDC          @TOTD
     C                   ELSE
     C                   EXSR      SRERRT
     C                   ENDIF
      *
      * Read all Account Keys records:
      *
     C                   READ      FPKEYDDF                               40
     C     *IN40         DOWEQ     *OFF
      *
      *   determine whether record is to be selected:
      *
     C                   MOVE      *BLANKS       @SEL
     C                   MOVE      'C'           @FIXED
      *
      *   Miscellaneous charges
      *   a/c key = INRyy----M---- & INRyy----3----
      *
     C     AKEVEN        IFEQ      'R'
     C     AKF12         ANDEQ     'IN'
      *
     C     AKTYPE        IFEQ      'M'
     C     AKTYPE        OREQ      '3'
     C                   MOVE      'Y'           @SEL
     C**********         MOVEL     'I/OPAY'      @T1KEY                                     AR824335
     C                   MOVEL     'IPAY      '  @T1KEY                                     AR824335
     C                   Z-ADD     0             @T1ORD                                     AR853257
     C                   MOVE      'Y'           WMISC                                      AR871641
     C                   ENDIF
      *
     C                   ENDIF
      *
      *   Miscellaneous charges
      *   a/c key = OPPyy----M---- & OPPyy----3----
      *
     C     AKEVEN        IFEQ      'P'
     C     AKF12         ANDEQ     'OP'
      *
     C     AKTYPE        IFEQ      'M'
     C     AKTYPE        OREQ      '3'
     C                   MOVE      'Y'           @SEL
     C**********         MOVEL     'I/OPAY'      @T1KEY                                     AR824335
     C                   MOVEL     'OPAY      '  @T1KEY                                     AR824335
     C                   Z-ADD     0             @T1ORD                                     AR853257
     C                   MOVE      'Y'           WMISC             1                        AR871641
     C                   ENDIF
      *
     C                   ENDIF
      *
      *   Costs abroad
      *   a/c key = CPPyy----C---- & CPPyy----Z----
      *
     C     AKEVEN        IFEQ      'P'
     C     AKF12         ANDEQ     'CP'
      *
     C     AKTYPE        IFEQ      'C'
     C     AKTYPE        OREQ      'Z'
     C                   MOVE      'Y'           @SEL
     C**********         MOVEL     'I/OCHEQ   '  @T1KEY                                     AR824335
     C                   MOVEL     'CHEQP     '  @T1KEY                                     AR824335
     C                   Z-ADD     0             @T1ORD                                     AR853257
     C                   ENDIF
      *
     C                   ENDIF
      *
      *   Costs abroad
      *   a/c key = CCRyy----C---- & CCRyy----Z----
      *
     C     AKEVEN        IFEQ      'R'
     C     AKF12         ANDEQ     'CC'
      *
     C     AKTYPE        IFEQ      'C'
     C     AKTYPE        OREQ      'Z'
     C                   MOVE      'Y'           @SEL
     C**********         MOVEL     'I/OCHEQ   '  @T1KEY                                     AR824335
     C                   MOVEL     'CHEQC     '  @T1KEY                                     AR824335
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Record Selected
      *
     C     @SEL          IFEQ      'Y'
      *
      * Access record on Stamp Tax - Transactions ext. file
      *
     C                   MOVE      *BLANKS       IPTAX
     C                   MOVE      *BLANKS       OTTAX
     C                   MOVE      *BLANKS       QCTAX
     C                   MOVE      *BLANKS       QPTAX
     C                   MOVE      *BLANKS       @T1TAX            1
     C                   MOVE      PREF          @T1PRF
     C                   MOVE      CQSQ          @T1QSQ
      *
     C     KCHQ          KLIST
     C                   KFLD                    @T1PRF
     C                   KFLD                    @T1QSQ
      *
     C     PAYTYP        IFEQ      'OP'
     C     PREF          CHAIN     OTPAYQL0                           75
     C     *IN75         IFEQ      *OFF
     C                   MOVE      OTTAX         @T1TAX
     C                   MOVE      'OPAY      '  T#KEY
     C                   ENDIF
     C                   ENDIF
      *
     C     PAYTYP        IFEQ      'IN'
     C     PREF          CHAIN     INPAYQL0                           75
     C     *IN75         IFEQ      *OFF
     C                   MOVE      IPTAX         @T1TAX
     C                   MOVE      'IPAY      '  T#KEY
     C                   ENDIF
     C                   ENDIF
      *
     C     PAYTYP        IFEQ      'CC'
     C     KCHQ          CHAIN     CQCOCQL0                           75
     C     *IN75         IFEQ      *OFF
     C                   MOVE      QCTAX         @T1TAX
     C                   MOVE      'CHEQC     '  T#KEY
     C                   ENDIF
     C                   ENDIF
      *
     C     PAYTYP        IFEQ      'CP'
     C     KCHQ          CHAIN     CQPACQL0                           75
     C     *IN75         IFEQ      *OFF
     C                   MOVE      QPTAX         @T1TAX
     C                   MOVE      'CHEQP     '  T#KEY
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN75         IFEQ      *OFF
     C     @T1TAX        ANDEQ     'Y'
     C**********         Z-ADD     0             T#LNRF                                       CLE148
     C                   MOVE      *BLANKS       T#LNRF                                       CLE148
     C                   MOVE      *BLANKS       T#FCNM
     C                   Z-ADD     0             T#FACT
     C                   Z-ADD     0             T#FCNO
     C                   Z-ADD     0             T#FSEQ
     C                   Z-ADD     0             T#ORED
     C                   Z-ADD     0             T#DLNO
     C                   MOVE      *BLANKS       T#TDRF
     C                   MOVE      *BLANKS       T#BRCA
     C                   MOVE      *BLANKS       T#CNUM
     C                   MOVE      *BLANKS       T#CCY
     C                   Z-ADD     0             T#ACOD
     C                   Z-ADD     0             T#ACSQ
     C                   MOVE      PREF          T#PREF
     C                   Z-ADD     CQSQ          T#CQSQ
     C                   MOVE      *BLANKS       T#PBRC
     C                   MOVE      *BLANKS       T#PSSH
     C                   MOVE      *BLANKS       T#PCPY
     C                   Z-ADD     0             T#PDUD
     C                   MOVE      *BLANKS       T#PEVT
     C                   MOVE      S@CNUM        T#DCST            6
     C                   MOVE      S@CCCY        T#DCCY            3
     C                   MOVE      S@ACOD        T#DACD           10
     C                   MOVE      S@ACSQ        T#DASQ            2
     C                   MOVE      S@BRCD        T#DBRC            3
      *
      * Retrieve Settlement Branch Details
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      T#DBRC        @DSNB
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      * ....error
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     T#DBRC        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     064           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EXSR      STCALL
      *
      * Get Stamp Tax CCY details
      *
     C     @TXRAT        IFEQ      0
     C                   MOVE      'N'           @T1TAX
     C                   ELSE
      *
     C                   MOVE      @TXCCY        @AJCD
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATET
     C                   MOVE      A6MDIN        ZMDIT
     C                   MOVE      A6INCY        ZINCYT
     C                   MOVE      A6NBDP        ZNBDPT
     C                   ENDIF
      *
     C     @T1TAX        IFEQ      'Y'
      *
      * Calculate/Set Tax amount + get ccy details
      *
     C                   EXSR      STSTAX
      *
      * Generate Account Keys
      *
     C     @TAXE         CASNE     *ZEROS        STACKY
     C                   ENDCS
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      FPKEYDDF                               40
     C                   ENDDO
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STSEIN - Stamp Tax: Securities
      *
      * Called From: MAIN
      *
      * Calls        SRERRT - Error on Trailer file
      *              STCHAI - Access to SDSTMPPD
      *              STSTAX - Calculate tax
      *              STACKY - Generate Stamp Tax a/c Keys
      *****************************************************************
      *
     C     STSEIN        BEGSR
      *
      * Set conversion keys
      *
     C                   MOVE      *BLANKS       AKEYF
     C                   MOVE      *BLANKS       AKEYS
     C                   MOVE      *BLANKS       SAKEYA           20
     C                   MOVE      *BLANKS       SAKEYB           20
     C                   MOVE      *BLANKS       SAKDS
      *
      * SE A/C Keys Trailer File
      *
     C                   READ      SEKEYA                                 41
     C     *IN41         IFEQ      *OFF
     C                   Z-ADD     NORE          @NORE
     C                   Z-ADD     HRWN          @TOTI
     C                   Z-ADD     HRDC          @TOTD
     C                   ELSE
     C                   Z-ADD     0             @NORE
     C                   Z-ADD     0             @TOTI
     C                   Z-ADD     0             @TOTD
     C                   ENDIF
      *
      * Read all Account Keys records:
      *
     C                   READ      SEKEY                                  40
     C     *IN40         DOWEQ     *OFF
     C     SETP          ANDNE     *ZERO                                                    AR877145
     C     STLA          ANDNE     *BLANKS                                                  AR877145
      *
      *   determine whether record is to be selected:
      *
     C                   MOVE      *BLANKS       @SEL
     C                   MOVE      'C'           @FIXED
      *
      *   Charges receivable
      *   a/c key = iiiTt-bbyyccmv----FR
      *   a/c key = iiiVt-bbyyccmv----FR
      *   a/c key = iiiPt-bbyyccmv----FR                                                    AR853257
      *   a/c key = iiiCt-bbyyccmv----FR                                                    AR853257
      *   a/c key = iiiHt-bbyyccmv----FR                                                    AR853257
      *   a/c key = iiiRt-bbyyccmv----FR                                                    AR853257
      *   a/c key = iiiMt-bbyyccmv----FR                                                    AR853257
      *   a/c key = iiiXt-bbyyccmv----FR/CR                                                 AR864714
      *
     C     SAKEVE        IFEQ      'T'
     C     SAKEVE        OREQ      'V'
     C     SAKEVE        OREQ      'P'                                                      AR853257
     C     TRFR          ANDEQ     0                                                        AR853257
     C     SAKEVE        OREQ      'C'                                                      AR853257
     C     TRFR          ANDEQ     0                                                        AR853257
     C     SAKEVE        OREQ      'H'                                                      AR853257
     C     TRFR          ANDEQ     0                                                        AR853257
     C     SAKEVE        OREQ      'R'                                                      AR853257
     C     TRFR          ANDEQ     0                                                        AR853257
     C     SAKEVE        OREQ      'M'                                                      AR853257
     C     TRFR          ANDEQ     0                                                        AR853257
     C     SAKEVE        OREQ      'X'                                                      AR864714
     C     TRFR          ANDEQ     0                                                        AR864714
      *
     C     SAKTYP        IFEQ      'FR'
     C     SAKTYP        OREQ      'CR'                                                     AR864714
     C                   MOVE      'Y'           @SEL
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Record Selected
      *
     C     @SEL          IFEQ      'Y'
      *
      *
      * Set  conversion keys
      *
      *  SAKEYA = STAMPTAXdsss-------A  (where sss is debit account currency)
      *  SAKEYB = STAMPTAXdccc-------B  (where ccc is stamp tax currency)
      *  AKEYDR = a/c key:  STAMPTAXT----------F  or STAMPTAXV----------F
      *  AKEYST = a/c key:  STAMPTAXT----------S  or STAMPTAXV----------S
      *
     C                   MOVE      *BLANKS       AKEYF
     C                   MOVE      *BLANKS       AKEYS
     C                   MOVE      *BLANKS       SAKEYA
     C                   MOVE      *BLANKS       SAKEYB
     C                   MOVE      *BLANKS       SAKDS
     C                   MOVEL     'STAMPTAX'    SAKDS
     C                   MOVE      SAKEVE        SKDS89
     C                   MOVE      SAKDS         SAKEYA
     C                   MOVE      SAKDS         SAKEYB
     C                   MOVE      SAKDS         SAKYDR           20
     C                   MOVE      SAKDS         SAKYST           20
     C                   MOVE      'A'           SAKEYA
     C                   MOVE      'B'           SAKEYB
     C                   MOVE      'F'           SAKYDR
     C                   MOVE      'S'           SAKYST
      *
      * Access record on Stamp Tax - Transactions ext. file
      *
     C                   MOVE      *BLANKS       TQTAX
     C                   MOVE      *BLANKS       P3TAX
     C                   MOVE      *BLANKS       @T1TAX
     C**********         MOVE      BRHA          @T1BRC            3                        AR824335
     C**********         MOVE      SESH          @T1SSH           10                        AR824335
     C**********         MOVE      CSTN          @T1CPT            6                        AR824335
     C**********         MOVE      EVDT          @T1DUD            5 0                      AR824335
     C**********         MOVE      PEV1          @T1EVT            2                        AR824335
     C                   MOVE      *BLANKS       @T1PBR                                     AR824335
     C                   MOVE      *BLANKS       @T1PSH                                     AR824335
     C                   MOVE      *BLANKS       @T1PCP                                     AR824335
     C                   MOVE      *ZEROS        @T1PDU                                     AR824335
     C                   MOVE      *BLANKS       @T1PEV                                     AR824335
     C     TRFR          IFEQ      0                                                        AR824335
     C                   MOVEl     BRHA          @T1PBR                                     AR824335
     C                   MOVEl     SESH          @T1PSH                                     AR824335
     C                   MOVEl     CSTN          @T1PCP                                     AR824335
     C                   IF        S01512 = 'Y'  AND                                       AR942839A
     C                             STLAQQ <> *BLANKS                                       AR942839A
     C                   MOVEL     STLAQQ        EVDT                                      AR942839A
     C                   ENDIF                                                             AR942839A
     C                   MOVEl     EVDT          @T1PDU                                     AR824335
     C                   MOVEl     PEV1          @T1PEV                                     AR824335
     C                   MOVEL     *BLANKS       @T1TDR                                     AR824335
     C                   ELSE                                                               AR864714
     C                   MOVEL     TRFR          @T1TDR                                     AR864714
     C                   ENDIF                                                              AR824335
     C**********         MOVEL     TRFR          @T1TDR                            AR824335 AR864714
     C                   Z-ADD     0             @T1ORD                                     AR853257
      *
     C     KPOSET        KLIST
     C**********         KFLD                    @T1BRC                                     AR824335
     C**********         KFLD                    @T1SSH                                     AR824335
     C**********         KFLD                    @T1CPT                                     AR824335
     C**********         KFLD                    @T1DUD                                     AR824335
     C**********         KFLD                    @T1EVT                                     AR824335
     C                   KFLD                    @T1PBR                                     AR824335
     C                   KFLD                    @T1PSH                                     AR824335
     C                   KFLD                    @T1PCP                                     AR824335
     C                   KFLD                    @T1PDU                                     AR824335
     C                   KFLD                    @T1PEV                                     AR824335
      *
     C     TRFR          IFNE      0
     C                   MOVE      TRFR          TRFRA             6
     C     TRFRA         CHAIN     TRADSQL0                           75
     C     *IN75         IFEQ      *OFF
     C                   MOVE      TQTAX         @T1TAX
     C                   MOVE      'SECURITY  '  T#KEY
     C                   MOVE      'SECURITY  '  @T1KEY                                     AR824335
     C                   ENDIF
      *
     C                   ELSE
     C     KPOSET        CHAIN     POSETDYL                           75
     C     *IN75         IFEQ      *OFF
     C                   MOVE      P3TAX         @T1TAX
     C                   MOVE      'POSSET    '  T#KEY
     C                   MOVE      'POSSET    '  @T1KEY                                     AR824335
     C     KPOSET        CHAIN     POSET1                             75                    AR864714
     C     *IN75         IFEQ      *OFF                                                     AR864714
     C                   EVAL      EAMT = P_PCHA + P_PCAM                                   AR864714
     C                   ENDIF                                                              AR864714
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN75         IFEQ      *OFF
     C     @T1TAX        ANDEQ     'Y'
     C**********         Z-ADD     0             T#LNRF                                       CLE148
     C                   MOVE      *BLANKS       T#LNRF                                       CLE148
     C                   MOVE      *BLANKS       T#FCNM
     C                   Z-ADD     0             T#FACT
     C                   Z-ADD     0             T#FCNO
     C                   Z-ADD     0             T#FSEQ
     C                   Z-ADD     0             T#ORED
     C                   Z-ADD     0             T#DLNO
     C                   MOVE      TRFR          T#TDRF
     C                   MOVE      *BLANKS       T#BRCA
     C                   MOVE      *BLANKS       T#CNUM
     C                   MOVE      *BLANKS       T#CCY
     C                   Z-ADD     0             T#ACOD
     C                   Z-ADD     0             T#ACSQ
     C                   MOVE      *BLANKS       T#PREF
     C                   Z-ADD     0             T#CQSQ
     C                   MOVE      BRHA          T#PBRC
     C                   MOVE      SESH          T#PSSH
     C                   MOVE      CSTN          T#PCPY
     C                   Z-ADD     EVDT          T#PDUD
     C                   MOVE      PEV1          T#PEVT
     C**********         MOVE      STCNUM        T#DCST                                     AR864206
     C**********         MOVE      ECCY          T#DCCY                                     AR864206
     C**********         MOVE      STACOD        T#DACD                                     AR864206
     C**********         MOVE      STACSQ        T#DASQ                                     AR864206
     C**********         MOVE      SEBR          T#DBRC                                     AR864206
      * Retrieve settlement details, this will be used to default the                       AR864206
      * Debit Account Details                                                               AR864206
     C                   EXSR      SRSETTLE                                                 AR864206
     C                                                                                      AR864206
      *
      * Retrieve Settlement Branch Details
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      T#DBRC        @DSNB
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      * ....error
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     T#DBRC        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     065           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      EVDT          EDAT
     C                   EXSR      STCALL
      *
      * Get Stamp Tax CCY details
      *
     C     @TXRAT        IFEQ      0
     C                   MOVE      'N'           @T1TAX
     C                   ELSE
      *
     C                   MOVE      @TXCCY        @AJCD
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATET
     C                   MOVE      A6MDIN        ZMDIT
     C                   MOVE      A6INCY        ZINCYT
     C                   MOVE      A6NBDP        ZNBDPT
     C                   ENDIF
      *
     C     @T1TAX        IFEQ      'Y'
     C*****SAKCHA        ANDEQ     U#CSCC                                                  AR864714A
     C*****T#DCCY        ANDNE     @TXCCY                                                   AR853257
     C     TRFR          IFNE      0                                                       AR864714A
     C     SAKCHA        ANDEQ     U#CSCC                                                  AR864714A
     C     TRFR          OREQ      0                                                       AR864714A
      *
      * Calculate/Set Tax amount + get ccy details
      *
     C                   EXSR      STSTAX
      *
      * Generate Account Keys
      *
     C     @TAXE         CASNE     *ZEROS        STACKY
     C                   ENDCS
      *
     C                   ENDIF                                                             AR864714A
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      SEKEY                                  40
     C                   ENDDO
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************                     AR864206
      * SRSETTLE - Retrieve Settlement Details                                              AR864206
      *                                                                                     AR864206
      * Called From: STSEIN                                                                 AR864206
      *                                                                                     AR864206
      * Calls:       Pgm ZAGETSETAC                                                         AR864206
      *****************************************************************                     AR864206
      *                                                                                     AR864206
     C     SRSETTLE      BEGSR                                                              AR864206
      *                                                                                     AR864206
     C                   CLEAR                   ReturnCode                                 AR864206
     C                   CALL      'ZAGETSETAC'                                             AR864206
     C                   PARM                    ReturnCode                                 AR864206
     C                   PARM                    AccCode                                    AR864206
     C                   PARM                    AccSeq                                     AR864206
     C                   PARM                    MemosInd                                   AR864206
     C                   PARM                    PronoInd                                   AR864206
     C                   PARM                    Branch                                     AR864206
     C                   PARM                    CustNo                                     AR864206
     C                   PARM                    Currency                                   AR864206
     C                   PARM      SETP          SettleType                                 AR864206
     C                   PARM      STLA          SettleAcc                                  AR864206
                                                                                            AR864206
     C                   IF        ReturnCode <> *BLANKS                                    AR864206
     C     *LOCK         IN        LDA                                                      AR864206
     C                   MOVE      *BLANKS       DBKEY                                      AR864206
     C                   EVAL      DBKEY = 'ZAGETSETAC'                                     AR864206
     C                   MOVEL     'CALL'        DBFILE                                     AR864206
     C                   Z-ADD     055           DBASE                                      AR864206
     C                   OUT       LDA                                                      AR864206
     C                   EXSR      *PSSR                                                    AR864206
     C                   ELSE                                                               AR864206
     C                   EVAL      T#DBRC = Branch                                          AR864206
     C                   EVAL      T#DCST = CustNo                                          AR864206
     C                   EVAL      T#DCCY = Currency                                        AR864206
     C                   MOVE      AccCode       T#DACD                                     AR864206
     C                   MOVE      AccSeq        T#DASQ                                     AR864206
     C                   ENDIF                                                              AR864206
                                                                                            AR864206
     C                   ENDSR                                                              AR864206
      *                                                                                     AR864206
      *****************************************************************
      * STCALL - Call program SD008140
      *
      * Called From: STLEIN, STDLIN, STLEFE, STLEFC, STFTIN, STSEIN
      *
      * Calls:       Pgm SD008140
      *****************************************************************
      *
     C     STCALL        BEGSR
      *
      * Call SD008140 to retrieve the rate.
      *
     C                   MOVE      *ZEROS        @TXRAT           13 8
     C                   MOVE      *BLANKS       @TXCCY            3
     C                   Z-ADD     EDAT          U#DATE            5 0
     C                   MOVE      @T2TYP        U#TYPE            4
     C                   MOVE      U#MOD         U#MODL           10
     C                   Z-ADD     *ZEROS        U#CTAX           13 8
     C                   Z-ADD     *ZEROS        U#MTAX           13 8
     C                   MOVE      *BLANKS       U#CCCY            3
     C                   MOVE      *BLANKS       U#MCCY            3
     C                   MOVE      *BLANKS       U#CSCC            2
     C                   MOVE      *BLANKS       U#MSCC            2
     C                   MOVE      *BLANKS       U#TXTY            1
      *
      * if module is ACCOUNT, set it to RETAIL
      *
     C     U#MOD         IFEQ      'ACCOUNT'
     C                   MOVEL     'RETAIL '     U#MODL
     C                   ENDIF
      *
      * Do not retrieve tax rate if Date is earlier than take on date
      *
     C     U#DATE        IFGT      DATRAT
      *
     C                   CALL      'SD008140'
     C                   PARM                    U#DATE
     C                   PARM                    U#MODL
     C                   PARM                    U#TYPE
     C                   PARM                    U#CTAX
     C                   PARM                    U#MTAX
     C                   PARM                    U#CCCY
     C                   PARM                    U#MCCY
     C                   PARM                    U#CSCC
     C                   PARM                    U#MSCC
     C                   PARM                    U#TXTY
      *
      * If module Tax is not defined then use CONTROL tax rate/ccy
     C                   MOVE      U#MTAX        @TXRAT
     C                   MOVE      U#MCCY        @TXCCY
      *
     C     @TXRAT        IFEQ      0
     C                   MOVE      U#CTAX        @TXRAT
     C                   MOVE      U#CCCY        @TXCCY
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STACKY - Output Stamp Tax Account Keys to A/C Keys files
      *
      * Called From: STLEIN, STDLIN, STLEFE, STLEFC, STFTIN, STSEIN
      *
      * Calls:       STPRIN  Report
      *              WRTACK  Write a/c Key
      *              STCNVK  Conversion Account Keys
      *****************************************************************
      *
     C     STACKY        BEGSR
      *
      * ......set Debit Account for report
     C                   MOVE      T#DBRC        @DBRCA
     C                   MOVE      T#DCST        @DCUST
     C                   MOVE      T#DCCY        @DCCY
     C                   MOVE      T#DACD        @DACOD
     C                   MOVE      T#DASQ        @DACSQ
     C                   MOVE      @DEBIT        @DBACC
      *
     C     @FILEN        IFEQ      'STSEIN'
     C     SETP          ANDEQ     14
     C                   MOVEL(P)  STLA          @DBACC
     C                   ENDIF
      * Store original account key data
     C     *LIKE         DEFINE    T2REVI        @KREVI
     C     *LIKE         DEFINE    T2KAMT        @KEAMT
     C     *LIKE         DEFINE    T2VALD        @KVALD
     C     *LIKE         DEFINE    T2REVI        ##REVI
     C                   MOVE      REVI          ##REVI
     C     *LIKE         DEFINE    T2AKEY        ##AKEY
     C                   MOVEL     AKEY          ##AKEY
     C     *LIKE         DEFINE    T2ETYP        ##ETYP
     C                   MOVE      AKEY          ##ETYP
     C     *LIKE         DEFINE    T2KCCY        ##KCCY
     C                   MOVEL     ECCY          ##KCCY
     C     *LIKE         DEFINE    T2KAMT        ##KAMT
     C                   IF        WMISC = ' '                                              AR871641
     C                   Z-ADD     EAMT          ##KAMT
     C                   ELSE                                                               AR871641
     C                   EVAL      ##KAMT = EAMT / @TXRAT                                   AR871641
     C                   ENDIF                                                              AR871641
     C     *LIKE         DEFINE    T2VALD        ECD
      *
      * Print a/c key on which Stamp Tax is calculated if it is not
      * Facility (as Facility do not have driving a/c key)
      *
     C     @FILEN        IFNE      'STLEFC'
      *
      *  .....save tax amount
     C                   Z-ADD     EAMT          @EAMTS
      *
      *  .....tax amount set to zero as not printed for orignal key
     C                   Z-ADD     *ZEROS        EAMT
      *
      * print record
     C                   EXSR      STPRIN
      *
      * clear fields that are reported only in original a/c key
     C                   MOVE      *BLANKS       @DBACC
     C                   Z-ADD     *ZEROS        @GROSS
      *
      * reset Tax amount
     C                   Z-ADD     @EAMTS        EAMT
      *
     C                   ENDIF
      *
      * GENERATE STAMP TAX A/C KEYS:
      *
      * set Stamp Tax a/c key fields
     C                   Z-ADD     *ZEROS        OTHA
     C                   MOVE      *BLANKS       STLA
     C                   MOVE      *BLANKS       OTHC
     C                   MOVE      '05'          SETP
     C                   MOVE      T#DCST        OVCUST
     C                   MOVE      T#DACD        OVACOD
     C                   MOVE      T#DASQ        OVACSQ
     C                   MOVE      @OVACC        OSAC
     C                   MOVE      T#DBRC        OSBR
      *
      * Set a/c key for Tax Amount in DR A/C ccy
      *
     C                   MOVE      AKEYDR        AKEY
     C                   MOVE      SAKYDR        SAKEY
      *
      * WRITE TAX AMOUNT IN DR Ccy only if not FT
     C     @FILEN        IFNE      'STFTIN'
     C                   MOVE      T#DCCY        ECCY
     C     @FILEN        IFEQ      'STLEIN'
     C                   MOVE      *BLANKS       SCCY
     C                   ELSE
     C                   MOVE      T#DCCY        SCCY
     C                   ENDIF
     C                   Z-ADD     @TAXD         EAMT
     C                   EXSR      WRTACK
      *
      * Print record
     C                   EXSR      STPRIN
     C                   ENDIF
      *
      * Tax Amount in Stamp Tax Ccy a/c key
      *
     C                   MOVE      AKEYST        AKEY
     C                   MOVE      SAKYST        SAKEY
      *
      * Write Tax Amount in Stamp Tax currency
     C     @FILEN        IFNE      'STFTIN'
     C                   MOVE      @TXCCY        ECCY
     C     @FILEN        IFEQ      'STLEIN'
     C                   MOVE      *BLANKS       SCCY
     C                   ELSE
     C                   MOVE      @TXCCY        SCCY
     C                   ENDIF
     C                   Z-ADD     @TAXS         EAMT
     C                   EXSR      WRTACK
      *
      * Print record
     C                   EXSR      STPRIN
     C                   ENDIF
      *
      * Generates Conversion Account Keys if DR Ccy and Stamp Tax Ccy
      * are different
      *
     C     T#DCCY        CASNE     @TXCCY        STCNVK
     C                   ENDCS
      *
      * UPDATE STAMP TAX FILES:
      *
      * Summary File: Add Stamp Tax posted to Tax on Interest if
      * ------------- posting was generated on Interest.
      *
     C     @FIXED        IFEQ      'N'
     C     @FILEN        IFEQ      'STLEIN  '
     C     PLNST         ANDNE     '63'                                                    AR941869A
     C                   ADD       @TAXE         LQSTAI
     C                   EXCEPT    UPDLO
     C                   ENDIF
      *
     C     @FILEN        IFEQ      'STDLIN  '
     C                   ADD       @TAXE         F1STAI
     C                   EXCEPT    UPDDL
     C                   ENDIF
     C                   ENDIF
      *
      * Hist/Details file: Update Tax Paid Indicator, Tax Posted/Value
      * ------------------ Date if the posting is on Flat Tax
      *                    (Flat/Charge Tax)
      *
     C     @FIXED        IFEQ      'Y'
     C     @FIXED        OREQ      'C'
     C                   Z-ADD     @TAXD         T2TADC
     C                   Z-ADD     @TAXS         T2TASC
      *
      * Add Spot Rate
     C                   Z-ADD     ZRATEE        T2ESPR
     C                   Z-ADD     ZRATET        T2SSPR
     C                   Z-ADD     ZRATED        T2DSPR
      *
     C                   Z-ADD     0             T2GROS
     C                   MOVE      'Y'           T2TPAY
     C                   Z-ADD     EDAT          T2VALD
     C                   Z-ADD     ECD           T2PSDT
     C                   MOVE      @ACTDT        T2DATE
     C                   Z-ADD     ECD           T2LCD
     C                   MOVE      'A'           T2TYLC
      * Set key data
     C                   MOVEL     ##REVI        T2REVI
     C                   MOVEL     ##AKEY        T2AKEY
     C                   MOVEL     ##ETYP        T2ETYP
     C                   MOVEL     ##KCCY        T2KCCY
     C                   Z-ADD     ##KAMT        T2KAMT
     C                   MOVE      @TXCCY        T2SCCY                                     AR864206
     C                   MOVEL     @XRATE        T2XRAT                                    AR864714B
     C                   SETOFF                                       50                    AR864206
     C                   IF        @FILEN = 'STFTIN' OR                                     AR864206
     C                             @FILEN = 'STSEIN'                                        AR864206
      * Set Debit Account                                                                   AR864206
     C                   MOVE      T#DBRC        T2DBRC                                     AR864206
     C                   MOVE      T#DCST        T2DCST                                     AR864206
     C                   MOVE      T#DCCY        T2DCCY                                     AR864206
     C                   MOVE      T#DACD        T2DACD                                     AR864206
     C                   MOVE      T#DASQ        T2DASQ                                     AR864206
     C                   SETON                                        50                    AR864206
     C                   ENDIF                                                              AR864206
     C                   Z-ADD     @XRATE        T2XRAT                                    AR879983A
      *
     C     ##REVI        IFNE      '1'
     C                   EXCEPT    UPDSTD
     C                   ELSE
     C     ##RECF        IFEQ      'Y'
     C                   EXCEPT    UPDST6
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Hist/Details file: Output a record with the details of the
      * ------------------ Stamp Tax on Interest postings
      *
     C     @FIXED        IFNE      'Y'
     C     @FIXED        ANDNE     'C'
                                                                                            AR942819
     C                   IF        REVI = 0                                                 AR942819
      *
     C                   CLEAR                   @STMDV0
      *
     C                   MOVE      @ECCY         T2ECCY
     C                   MOVE      @TXCCY        T2SCCY
     C                   MOVE      T#KEY         T2KEY
     C                   MOVE      T#LNRF        T2LNRF
     C                   MOVE      T#FCNM        T2FCNM
     C                   MOVE      T#FACT        T2FACT
     C                   MOVE      T#FCNO        T2FCNO
     C                   MOVE      T#FSEQ        T2FSEQ
     C                   MOVE      T#ORED        T2ORED
     C                   MOVE      T#DLNO        T2DLNO
     C                   MOVE      T#TDRF        T2TDRF
     C                   MOVE      T#BRCA        T2BRCA
     C                   MOVE      T#CNUM        T2CNUM
     C                   MOVE      T#CCY         T2CCY
     C                   MOVE      T#ACOD        T2ACOD
     C                   MOVE      T#ACSQ        T2ACSQ
     C                   MOVE      T#PREF        T2PREF
     C                   MOVE      T#CQSQ        T2CQSQ
     C                   MOVE      T#PBRC        T2PBRC
     C                   MOVE      T#PSSH        T2PSSH
     C                   MOVE      T#PCPY        T2PCPY
     C                   MOVE      T#PDUD        T2PDUD
     C                   MOVE      T#PEVT        T2PEVT
      *
     C                   MOVE      'T'           T2RCTP
     C                   Z-ADD     ECD           T2CDTE
     C                   MOVE      'Y'           T2TPAY
     C                   MOVE      'Y'           T2TCAL
     C                   Z-ADD     @TXRAT        T2TXRT
     C                   Z-ADD     ECD           T2PSDT
     C                   Z-ADD     EDAT          T2VALD
     C                   Z-ADD     @ACTDT        T2DATE
     C                   Z-ADD     @TAXE         T2TATC
     C                   Z-ADD     @GROSS        T2GROS
     C                   Z-ADD     @TAXS         T2TASC
     C                   Z-ADD     @TAXD         T2TADC
     C                   MOVE      'Y'           T2STFI
     C                   Z-ADD     ECD           T2LCD
     C                   MOVE      'I'           T2TYLC
      * Set UDF Flag
     C                   MOVE      *BLANKS       T2UDCF
      *
      * Set Debit Account
     C                   MOVE      T#DBRC        T2DBRC
     C                   MOVE      T#DCST        T2DCST
     C                   MOVE      T#DCCY        T2DCCY
     C                   MOVE      T#DACD        T2DACD
     C                   MOVE      T#DASQ        T2DASQ
      * Set key data
     C                   MOVEL     ##REVI        T2REVI
     C                   MOVEL     ##AKEY        T2AKEY
     C                   MOVEL     ##ETYP        T2ETYP
     C                   MOVEL     ##KCCY        T2KCCY
     C                   Z-ADD     ##KAMT        T2KAMT
     C                   MOVEL     @T2TYP        T2TYPE                                     AR864206
     C                   MOVEL     @XRATE        T2XRAT                                     AR879983
      *
     C                   WRITE     @STMDV0
      *
     C                   ELSE                                                               AR942819
                                                                                            AR942819
     C                   MOVE      'T'           @T2RCT                                     AR942819
     C                   MOVE      @EAMTS        @KEAMT                                     AR942819
     C                   MOVE      EDAT          @KVALD                                     AR942819
     C                   MOVE      'Y'           @T2FFT                                     AR942819
     C                   MOVE      'Y'           @T2PAY                                     AR942819
     C                   MOVE      '0'           @KREVI                                     AR942819
     C     STKEYR        CHAIN     SDSTMDL6                                                 AR942819
     C                   IF        %FOUND(SDSTMDL6)                                         AR942819
     C                   EVAL      T2REVI = '1'                                             AR942819
     C                   UPDATE    @STMDV6                                                  AR942819
     C                   ENDIF                                                              AR942819
     C                   ENDIF                                                              AR942819
                                                                                            AR942819
     C                   ENDIF
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * WRTACK - Output Stamp Tax A/C Keys records
      *
      * Called From: STACKY
      *              STCNVK
      *
      * Calls:       SRHASH  Hash Total
      *****************************************************************
      *
     C     WRTACK        BEGSR
      *
     C                   EXSR      SRHASH
      *
      * Records are output to the account keys file being processed
      *
      * ....Lending: Interest
     C     @FILEN        IFEQ      'STLEIN'
     C     AKF13         IFNE      'STV'                                                    AR821875
     C                   MOVE      WLNCL         AKLNCL                                     AR821875
     C                   ENDIF                                                              AR821875
     C                   WRITE     LKEY1DPF
     C                   ENDIF
      *
      * ....Dealing: Interest
     C     @FILEN        IFEQ      'STDLIN'
     C                   WRITE     DKEYSDPF
     C                   ENDIF
      *
      * ....Fees & Facilities
     C     @FILEN        IFEQ      'STLEFE'
     C     @FILEN        OREQ      'STLEFC'
     C                   WRITE     LKEYFEDF
     C                   ENDIF
      *
      * ....Funds Transfer
     C     @FILEN        IFEQ      'STFTIN'
     C                   WRITE     FPKEYDDF
     C                   ENDIF
      *
      * ....Securities
     C     @FILEN        IFEQ      'STSEIN'
     C                   WRITE     SEKEYDF
     C                   ENDIF
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STSTAX - Stamp Tax: Calculate/Set Tax amount
      *
      * Called From: STLEIN - Lending Interest
      *              STDLIN - Money Market
      *              STLEFE - Fees
      *              STLEFC - Facility
      *              STFTIN - Funds Transfer
      *              STSEIN - Securities
      *
      * Calls:       STCCYD - get CCY details
      *              STSFXD - Retrieve Flat Tax amount for 'FIXED'
      *              XCAMT  - Convert amount
      *****************************************************************
      *
     C     STSTAX        BEGSR
      *
      * Get Event/DR ccy details
      *
     C                   EXSR      STCCYD
      *
     C                   Z-ADD     EAMT          @GROSS
     C                   Z-ADD     *ZEROS        @TAXE
     C                   Z-ADD     *ZEROS        @TAXB
     C                   Z-ADD     *ZEROS        @TAXD
     C                   Z-ADD     *ZEROS        @TAXS
     C                   Z-ADD     1             @XRATE                                     AR879983
      *
      * Flat Stamp Tax: @FIXED is 'Y' or 'C' (Charges). Both for
      * --------------  Fixed and Charge Stamp Tax, the amount to
      *                 be posted is available in the Historic/Detail
      *                 Stamp Tax file (SDSTMDPD) in the record where
      *                 the Control Date is zero and the Tax Paid Ind
      *                 is blank.
      *
     C     @FIXED        IFEQ      'Y'
     C     @FIXED        OREQ      'C'
      *
     C                   IF        @FILEN = 'STSEIN'                                        AR871666
     C                   MOVE      RVRS          ##REVI                                     AR871666
     C                   MOVE      RVRS          REVI                                       AR871666
     C                   ELSEIF    @FILEN = 'STLEFE'                                        AR871666
     C                   MOVE      LKREVI        ##REVI                                     AR871666
     C                   MOVE      LKREVI        REVI                                       AR871666
     C                   ENDIF                                                              AR871666
      *                                                                                     AR871666
     C                   EXSR      STSFXD
      *
     C                   ELSE
      *
      * Interest Stamp Tax: @FIXED is 'N'. The tax amount is calculated
      * ------------------  on the amount of Interest being paid. The
      *                     tax rate is the effective rate at the Date
      *                     of the Interest Payment.
      *
     C     EAMT          IFNE      0
     C     @TXRAT        ANDNE     0
     C     EAMT          MULT(H)   @TXRAT        @TAXE
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Set Amounts for currencies that match
      *
     C     @TAXE         IFNE      *ZEROS
      *
     C                   Z-ADD     @TAXE         @TAXD
      *
      * Convert From Event CCY (@TAXE ) to Debit Account CCY (@TAXD)
      *
     C     ECCY          IFNE      T#DCCY
      *
      * .....move Event CCY details
     C                   MOVE      ECCY          CCYFR
     C                   Z-ADD     ZRATEE        ZRATFR
     C                   MOVE      ZINCYE        ZINCFR
     C                   MOVE      ZNBDPE        ZNBDFR
     C                   MOVE      ZMDIE         ZMDIFR
      *
      * .....move Debit CCY details
     C                   MOVE      T#DCCY        CCYTO
     C                   Z-ADD     ZRATED        ZRATTO
     C                   MOVE      ZINCYD        ZINCTO
     C                   MOVE      ZNBDPD        ZNBDTO
     C                   MOVE      ZMDID         ZMDITO
      * .... Convert Routine
     C                   Z-ADD     @TAXE         P@FRAM
     C                   EXSR      XCAMT
     C                   MOVE      P@OUTA        @TAXD
      *
     C                   ENDIF
      *
      * Convert DrCCy Tax Amount in Tax CCY (@TXCCY)
      *
     C                   Z-ADD     @TAXD         @TAXS
     C     T#DCCY        IFNE      @TXCCY
      *
      * .....move Debit CCY details
     C                   MOVE      T#DCCY        CCYFR
     C                   Z-ADD     ZRATED        ZRATFR
     C                   MOVE      ZINCYD        ZINCFR
     C                   MOVE      ZNBDPD        ZNBDFR
     C                   MOVE      ZMDID         ZMDIFR
      *
      * .....move Tax CCY details
     C                   MOVE      @TXCCY        CCYTO
     C                   Z-ADD     ZRATET        ZRATTO
     C                   MOVE      ZINCYT        ZINCTO
     C                   MOVE      ZNBDPT        ZNBDTO
     C                   MOVE      ZMDIT         ZMDITO
      *
      * Convert Routine
      *
     C                   Z-ADD     @TAXD         P@FRAM
     C                   EXSR      XCAMT
     C                   MOVE      P@OUTA        @TAXS
      *                                                                                     AR879983
      ** Save exchange rate                                                                 AR879983
      *                                                                                     AR879983
     C                   Z-ADD     ZRATEX        @XRATE           13 8                      AR879983
      *
     C                   ENDIF
      *
      * Convert From Tax CCY (@TAXS) to Base CCY  (@TAXB)
      *
     C                   Z-ADD     @TAXS         @TAXB
     C     @TXCCY        IFNE      BJCYCD
      *
      * .....move Tax CCY details
     C                   MOVE      @TXCCY        CCYFR
     C                   Z-ADD     ZRATET        ZRATFR
     C                   MOVE      ZINCYT        ZINCFR
     C                   MOVE      ZNBDPT        ZNBDFR
     C                   MOVE      ZMDIT         ZMDIFR
      *
      * .....move Base CCY details
     C                   MOVE      BJCYCD        CCYTO
     C                   Z-ADD     ZRATEB        ZRATTO
     C                   MOVE      ZINCYB        ZINCTO
     C                   MOVE      ZNBDPB        ZNBDTO
     C                   MOVE      ZMDIB         ZMDITO
      *
      * Convert Routine
      *
     C                   Z-ADD     @TAXS         P@FRAM
     C                   EXSR      XCAMT
     C                   MOVE      P@OUTA        @TAXB
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      * STCNVK - Generate Conversion Account keys
      *
      * Called From: STACKY
      *
      * Calls:       STPRIN
      *              WRTACK
      *****************************************************************
      *
     C     STCNVK        BEGSR
      *
      * Conversion Account Keys
     C                   MOVE      '00'          SETP
     C                   MOVE      *BLANKS       OSAC
     C                   MOVE      *BLANKS       SEAC
      *
      *  debit ccy:
      *  AKEYF = 'STVTX----F----'  If it is not Fund transfer
      *  AKEYF = 'STVFT----F----'  If Fund transfer
      *
     C     AKEYF         IFNE      *BLANKS
      *
     C                   MOVE      AKEYF         AKEY
     C                   MOVE      T#DCCY        ECCY
     C                   MOVE      T#DCCY        SCCY
     C                   Z-ADD     @TAXD         EAMT
     C                   EXSR      WRTACK
      *
      * Print record
     C                   EXSR      STPRIN
     C                   ENDIF
      *
      *  Stamp Tax CCY:
      *  AKEYS = 'STVTX----S----'  If it is not Fund transfer
      *  AKEYS = 'STVFT----S----'  If Fund transfer
      *
     C     AKEYS         IFNE      *BLANKS
     C                   MOVE      AKEYS         AKEY
     C                   MOVE      @TXCCY        ECCY
     C                   MOVE      @TXCCY        SCCY
     C                   Z-ADD     @TAXS         EAMT
     C                   EXSR      WRTACK
      *
      * Print record
     C                   EXSR      STPRIN
     C                   ENDIF
      *
      * BASE CURRENCY:
      * ---------------
      * From Debit account currency to Base Ccy
      * AKEYA   ....... STVTXsss-A---- (where sss is debit account ccy)
      * AKEYA   ....... STVFTsss-A---- (Funds Transfer)
      * SAKEYA = STAMPTAXdsss-------A  (where sss is debit account currency)
      *
     C                   MOVE      AKEYA         AKDS
     C                   MOVE      T#DCCY        AKDSCY
     C                   MOVE      AKDS          AKEY
      *
      * move securities fields
     C                   MOVE      SAKEYA        SAKDS
     C                   MOVE      T#DCCY        SAKDSC
     C                   MOVE      SAKDS         SAKEY
      *
     C                   MOVE      BJCYCD        ECCY
     C                   MOVE      BJCYCD        SCCY
     C                   Z-ADD     @TAXB         EAMT
      *  write a/ckey
     C                   EXSR      WRTACK
      *
      * Print record
     C                   EXSR      STPRIN
      *
      * BASE CURRENCY:
      * ---------------
      * From Stamp Tax  currency to Base Ccy
      * AKEYB   ....... STVTXccc-B---- (where ccc is stamp tax ccy)
      * AKEYB   ....... STVFTccc-B---- (Funds Transfer)
      * SAKEYB = STAMPTAXdccc-------B  (where sss is stamp tax currency)
      *
     C                   MOVE      AKEYB         AKDS
     C                   MOVE      @TXCCY        AKDSCY
     C                   MOVE      AKDS          AKEY
      *
      * move securities fields
     C                   MOVE      SAKEYB        SAKDS
     C                   MOVE      @TXCCY        SAKDSC
     C                   MOVE      SAKDS         SAKEY
      *
     C                   EXSR      WRTACK
      *
      * Print record
     C                   EXSR      STPRIN
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STPRIN - Print Account Key generated
      *
      * Called From: STACKY
      *              STCNVK
      *
      * Calls:       ZDATE2
      *              ZSEDIT
      *****************************************************************
      *
     C     STPRIN        BEGSR
      *
      * Set Output fields
      *
     C                   MOVE      *BLANKS       @REVIN
     C                   MOVE      *BLANKS       @KEYRF
     C                   MOVE      *BLANKS       @KEYR1
     C                   MOVE      *BLANKS       @KEYR2
     C                   MOVE      *BLANKS       @KEYR3
     C                   MOVE      *BLANKS       @KEYR4
      *
      * ......set a/c key field
     C                   MOVE      *BLANKS       @AKEY
     C                   MOVEL     AKEY          @AKEY
      *
      *  .....if Securities
     C     @FILEN        IFEQ      'STSEIN'
     C                   MOVEL     SAKEY         @AKEY
     C                   ENDIF
      *
      * Lending - Interest
      *
     C     @FILEN        IFEQ      'STLEIN  '
     C                   MOVEL     LNNO          @KEYRF
     C                   ENDIF
      *
      * Money Market - Interest
      *
     C     @FILEN        IFEQ      'STDLIN  '
     C                   MOVEL     DLNO          @KEYRF
     C                   ENDIF
      *
      * Securities - Charges
     C     @FILEN        IFEQ      'STSEIN  '
     C                   MOVEL     TRFR          @KEYRF
     C                   ENDIF
      *
      * Funds Transfer - Charges
     C     @FILEN        IFEQ      'STFTIN  '
     C                   MOVEL     @T1PRF        @KEYRF
     C                   MOVE      @T1QSQ        @KEYRF
     C                   ENDIF
      *
      * Fees - Flat Amount
     C     @FILEN        IFEQ      'STLEFE  '
     C                   MOVEL     LKLNNO        @KEYR1           13
     C                   MOVE      CNUM          @KEYR1
     C                   MOVEL     @KEYR1        @KEYR4           16
     C                   MOVE      @T1FSQ        @KEYR4
     C                   MOVEL     @KEYR4        @KEYRF
     C                   ENDIF
      *
      * Facilities - Flat amount
     C     @FILEN        IFEQ      'STLEFC  '
     C                   MOVEL     @T1FCU        @KEYR2           12
     C                   MOVEL     @T1FAC        @KEYR3            5
     C                   MOVE      @T1FCN        @KEYR3
     C                   MOVE      @KEYR3        @KEYR2
     C                   MOVEL     @KEYR2        @KEYRF
     C                   ENDIF
      *
      * Posting/Value Dates
      *
     C                   Z-ADD     EDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        @VALDT
      *
      * Event Currency
      *
     C                   MOVE      ECCY          @CCY
      *
      * Convert Gross Amount (Event Amount)
      *
     C                   MOVE      *BLANKS       @EAMT
     C                   Z-ADD     @GROSS        ZFLD15
     C     @GROSS        IFNE      *ZEROS
     C                   Z-ADD     ZNBDPE        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR853257
     C                   CALL      'ZSEDIT'                                                 AR853257
     C                   PARM                    ZFLD15                                     AR853257
     C                   PARM                    ZDECS                                      AR853257
     C                   PARM                    ZECODE                                     AR853257
     C                   PARM                    ZOUT21                                     AR853257
     C                   MOVE      ZOUT21        @EAMT
     C                   ENDIF
      *
      * Tax Amount posted
      *
     C                   MOVE      *BLANKS       @TAXO
     C     EAMT          IFNE      *ZEROS
     C                   Z-ADD     EAMT          ZFLD15
     C                   Z-ADD     ZNBDPE        ZDECS
     C                   MOVE      'J'           ZECODE
     C**********         EXSR      ZSEDIT                                                   AR853257
     C                   CALL      'ZSEDIT'                                                 AR853257
     C                   PARM                    ZFLD15                                     AR853257
     C                   PARM                    ZDECS                                      AR853257
     C                   PARM                    ZECODE                                     AR853257
     C                   PARM                    ZOUT21                                     AR853257
     C                   MOVE      ZOUT21        @TAXO
     C                   ENDIF
      *
      * Tax Rate
      *
     C                   Z-ADD     0             @TAXR
     C     @TXRAT        MULT      100           @TAXR
      *
      * Reverse Indicator
      *
     C     REVI          IFEQ      1
     C                   MOVE      'Y'           @REVIN
     C                   ELSE
     C                   MOVE      ' '           @REVIN
     C                   ENDIF
      *
      * Write Report GL008130P1
      *
     C     @PRIN         IFNE      'Y'
     C     PRTLN1        IFGE      58
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   WRITE     DETDP1
      *
     C                   ELSE
      *
      * Write Report GL008130P2
      *
     C     PRTLN2        IFGE      58
     C                   WRITE     HEADP2
     C                   ENDIF
      *
     C     T2TXRT        MULT      100           @TAXR
     C                   WRITE     DETDP2
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * SRINIT - Initial Process
      *
      * Called From: MAIN
      *
      * Calls:       SROPEN
      *              ZDATE9
      *              ZEVCD
      *              *PSSR
      *              Pgm AOxxxxxx
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    @FILEN           10
     C                   PARM                    @PGMCA           10
     C                   PARM                    @UPDFL            1
      *
      * Retrieve SDSTAMPDA where the Take On Date is stored
      *
     C     *DTAARA       DEFINE    SDSTAMPDA     STAMDA
     C                   IN        STAMDA
      *
     C     *LIKE         DEFINE    EAMT          @EAMTS
      *
      * Define Fields for SDSTMPL1 Key
      *
     C                   MOVE      *ALL'-'       TRATT
     C                   MOVE      *BLANKS       U#MOD            10
     C     *LIKE         DEFINE    T2KEY         @T1KEY
     C     *LIKE         DEFINE    T2LNRF        @T1LNR
     C     *LIKE         DEFINE    T2FCNM        @T1FCU
     C     *LIKE         DEFINE    T2FACT        @T1FAC
     C     *LIKE         DEFINE    T2FCNO        @T1FCN
     C     *LIKE         DEFINE    FQFACL        @T1FCT
      * Fee Key
     C     *LIKE         DEFINE    T2FSEQ        @T1FSQ
     C     *LIKE         DEFINE    T2ORED        @T1ORD
      * Deal key
     C     *LIKE         DEFINE    T2DLNO        @T1DLN
      * Securities Trade Reference
     C     *LIKE         DEFINE    T2TDRF        @T1TDR
      * Account Reference
     C     *LIKE         DEFINE    T2BRCA        @K7
     C     *LIKE         DEFINE    T2CNUM        @K8
     C     *LIKE         DEFINE    T2CCY         @K9
     C     *LIKE         DEFINE    T2ACOD        @K10
     C     *LIKE         DEFINE    T2ACSQ        @K11
      * Funds Transfer Payment Reference
     C     *LIKE         DEFINE    T2PREF        @T1PRF
     C     *LIKE         DEFINE    T2CQSQ        @T1QSQ
      * Position Settlement Reference
     C     *LIKE         DEFINE    T2PBRC        @T1PBR
     C     *LIKE         DEFINE    T2PSSH        @T1PSH
     C     *LIKE         DEFINE    T2PCPY        @T1PCP
     C     *LIKE         DEFINE    T2PDUD        @T1PDU
     C     *LIKE         DEFINE    T2PEVT        @T1PEV
      *
     C     *LIKE         DEFINE    EAMT          @GROSS
     C     *LIKE         DEFINE    EAMT          @TAXE
     C     *LIKE         DEFINE    EAMT          @TAXB
     C     *LIKE         DEFINE    EAMT          @TAXD
     C     *LIKE         DEFINE    EAMT          @TAXS
     C     *LIKE         DEFINE    NORE          @NORE
     C     *LIKE         DEFINE    VLRF          @TOTI
     C     *LIKE         DEFINE    VLRL          @TOTD
      *
     C     *LIKE         DEFINE    T2TYPE        @T2TYP
     C     *LIKE         DEFINE    T2RCTP        @T2RCT
     C     *LIKE         DEFINE    T2CDTE        @T2CDT
     C     *LIKE         DEFINE    T2ASEQ        @T2ASE
      *
      * CCY details
      *
     C     *LIKE         DEFINE    A6CYCD        CCYFR
     C     *LIKE         DEFINE    A6CYCD        CCYTO
      *
     C     *LIKE         DEFINE    A6MDIN        ZMDIFR
     C     *LIKE         DEFINE    A6MDIN        ZMDITO
     C     *LIKE         DEFINE    A6SPRT        ZRATFR
     C     *LIKE         DEFINE    A6SPRT        ZRATTO
     C     *LIKE         DEFINE    A6INCY        ZINCFR
     C     *LIKE         DEFINE    A6INCY        ZINCTO
     C     *LIKE         DEFINE    A6NBDP        ZNBDFR
     C     *LIKE         DEFINE    A6NBDP        ZNBDTO
      *
     C     *LIKE         DEFINE    A6MDIN        ZMDI1
     C     *LIKE         DEFINE    A6MDIN        ZMDI2
     C     *LIKE         DEFINE    A6MDIN        ZMDIB
     C     *LIKE         DEFINE    A6MDIN        ZMDIE
     C     *LIKE         DEFINE    A6MDIN        ZMDIT
     C     *LIKE         DEFINE    A6MDIN        ZMDID
      *
     C     *LIKE         DEFINE    A6SPRT        ZRATEE
     C     *LIKE         DEFINE    A6SPRT        ZRATED
     C     *LIKE         DEFINE    A6SPRT        ZRATE1
     C     *LIKE         DEFINE    A6SPRT        ZRATE2
     C     *LIKE         DEFINE    A6SPRT        ZRATEB
     C     *LIKE         DEFINE    A6SPRT        ZRATET
      *
     C     *LIKE         DEFINE    A6INCY        ZINCYD
     C     *LIKE         DEFINE    A6INCY        ZINCYE
     C     *LIKE         DEFINE    A6INCY        ZINCYB
     C     *LIKE         DEFINE    A6INCY        ZINCYT
     C     *LIKE         DEFINE    A6INCY        ZINCY1
     C     *LIKE         DEFINE    A6INCY        ZINCY2
      *
     C     *LIKE         DEFINE    A6NBDP        ZNBDPD
     C     *LIKE         DEFINE    A6NBDP        ZNBDPE
     C     *LIKE         DEFINE    A6NBDP        ZNBDPB
     C     *LIKE         DEFINE    A6NBDP        ZNBDPT
      *
     C     STKEY2        KLIST
     C                   KFLD                    @T1KEY
     C                   KFLD                    @T2TYP
     C                   KFLD                    @T1LNR
     C                   KFLD                    @T1FCU
     C                   KFLD                    @T1FAC
     C                   KFLD                    @T1FCN
     C                   KFLD                    @T1FSQ
     C                   KFLD                    @T1ORD
     C                   KFLD                    @T1DLN
     C                   KFLD                    @T1TDR
     C                   KFLD                    @K7
     C                   KFLD                    @K8
     C                   KFLD                    @K9
     C                   KFLD                    @K10
     C                   KFLD                    @K11
     C                   KFLD                    @T1PRF
     C                   KFLD                    @T1QSQ
     C                   KFLD                    @T1PBR
     C                   KFLD                    @T1PSH
     C                   KFLD                    @T1PCP
     C                   KFLD                    @T1PDU
     C                   KFLD                    @T1PEV
     C                   KFLD                    @T2RCT
     C                   KFLD                    @T2CDT
     C                   KFLD                    @T2ASE
      *
     C     STKEYR        KLIST
     C                   KFLD                    @T1KEY
     C                   KFLD                    @T2TYP
     C                   KFLD                    @T1LNR
     C                   KFLD                    @T1FCU
     C                   KFLD                    @T1FAC
     C                   KFLD                    @T1FCN
     C                   KFLD                    @T1FSQ
     C                   KFLD                    @T1ORD
     C                   KFLD                    @T1DLN
     C                   KFLD                    @T1TDR
     C                   KFLD                    @K7
     C                   KFLD                    @K8
     C                   KFLD                    @K9
     C                   KFLD                    @K10
     C                   KFLD                    @K11
     C                   KFLD                    @T1PRF
     C                   KFLD                    @T1QSQ
     C                   KFLD                    @T1PBR
     C                   KFLD                    @T1PSH
     C                   KFLD                    @T1PCP
     C                   KFLD                    @T1PDU
     C                   KFLD                    @T1PEV
     C                   KFLD                    @T2RCT
     C                   KFLD                    @T2PAY            1
     C                   KFLD                    @T2FFT            1
     C                   KFLD                    @KVALD
     C                   KFLD                    @KEAMT
     C                   KFLD                    @KREVI
      *
     C     *DTAARA       DEFINE                  LDA
     C                   MOVEA     CPY@          BIS@             40
     C                   MOVE      'GL008130'    DBPGM
      *
      * FIL@ - Account Keys to be processed
      * KEY@ - Access Keys for file SDSTMPL1  (T1KEY)
      * NAR@ - Title for Reports
      *
     C                   Z-ADD     1             X@                1 0
     C                   MOVE      *BLANKS       TITLE
     C     @FILEN        LOOKUP    FIL@(X@)                               75
     C     *IN75         IFEQ      *ON
     C                   MOVE      NAR@(X@)      TITLE
     C                   MOVE      KEY@(X@)      @T1KEY
     C                   MOVE      KEY@(X@)      U#MOD
     C     X@            IFEQ      1
     C                   MOVE      NAR@(7)       TITL2
     C                   OPEN      GL008130P2
      *
      * Ensure the P2 spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUM2        ZSNUM             6 0
      *
      * Call ZSFILE for GL008130P2
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO             5
     C                   PARM      *BLANKS       ENTY              3
     C                   PARM                    SFILE2
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      * If error in ZSFILE, exit via *PSSR
      *
     C     ZSERR         IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      *  Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
      * Check System Date Format, DDMMYY OR MMDDYY.
      *
     C     BJDFIN        COMP      'M'                                    98
      *
     C                   ENDIF
      *
      * Convert Run Date to ccyymmdd
      *
     C                   Z-ADD     BJRDNB        @@DAYN            5 0
     C                   EXSR      ZDATE9
     C                   MOVE      @@VDT         @ACTDT            8 0
      *
      ** Access General Ledger Details
      *
     C                   CALL      'AOGELRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Accrual Profit Date
      *
     C                   IF        (BJDNWD - 1) > BKAPDT
     C                   EVAL      ECD = BKAPDT
     C                   ELSE
     C                   EVAL      ECD = BJDNWD - 1
     C                   ENDIF
      *
      ** Check if CAR CER049 is switched *ON.
      *
     C                   MOVE      'N'           CER049            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CER049 '     @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER049
     C                   ENDIF
      *
      * If CAR is switched off, end program
      *
     C     CER049        IFEQ      'N'
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *                                                                                    AR942839A
      ** Check if CAR S01512 is switched *ON.                                              AR942839A
      *                                                                                    AR942839A
     C                   MOVE      'N'           S01512            1                       AR942839A
     C                   CALL      'AOSARDR0'                                              AR942839A
     C                   PARM      *BLANKS       @RTCD                                     AR942839A
     C                   PARM      '*VERIFY'     @OPTN                                     AR942839A
     C                   PARM      'S01512 '     @SARD                                     AR942839A
     C     SCSARD        PARM      SCSARD        DSFDY                                     AR942839A
     C     @RTCD         IFEQ      *BLANKS                                                 AR942839A
     C                   MOVE      'Y'           S01512                                    AR942839A
     C                   ENDIF                                                             AR942839A
      *
      * Open Input Files - Retrieve Tax CCY/Rate
      *
     C                   EXSR      SROPEN
      *
     C                   WRITE     HEADP1
      *
      * Ensure the P1 spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUM         ZSNUM
      *
      * Call ZSFILE for GL008130P1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO
     C                   PARM      *BLANKS       ENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
      *
      * If error in ZSFILE, exit via *PSSR
      *
     C     ZSERR         IFEQ      'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     X@            IFEQ      1
     C                   WRITE     HEADP2
     C                   ENDIF
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * SROPEN - Open input Account Keys files
      *
      * Called From: SRINIT
      *
      * Calls:       AOCCY
      *****************************************************************
      *
     C     SROPEN        BEGSR
      *
      * OPEN INPUT ACCOUNT KEYS FILES:
      *
     C                   MOVE      *BLANKS       @FILET           10
     C                   MOVE      *BLANKS       @FILED           10
      *
      *   Stamp Tax - Lending Interest
      *
     C     @FILEN        IFEQ      'STLEIN  '
     C                   OPEN      LKEY1DL0
     C                   OPEN      LKEY1ZZ
     C                   MOVEL     'LKEY1DL0'    @FILED
     C                   MOVEL     'LKEY1ZZ'     @FILET
     C                   ENDIF
      *
      *   Stamp Tax - Lending Fees
      *
     C     @FILEN        IFEQ      'STLEFE  '
     C                   OPEN      LKEYFED
     C                   OPEN      LKEYFEZ
     C                   MOVEL     'LKEYFED'     @FILED
     C                   MOVEL     'LKEYFEZ'     @FILET
     C                   ENDIF
      *
      *   Stamp Tax - Lending Facilities
      *
     C     @FILEN        IFEQ      'STLEFC  '
     C                   OPEN      LKEYFED
     C                   OPEN      LKEYFEZ
     C                   OPEN      FCLTY1
     C                   MOVEL     'LKEYFED'     @FILED
     C                   MOVEL     'LKEYFEZ'     @FILET
     C                   ENDIF
      *
      *   Stamp Tax - Money Market Facilities
      *
     C     @FILEN        IFEQ      'STDLIN  '
     C                   OPEN      DKEYSDP
     C                   OPEN      DKEYSZZ
     C                   MOVEL     'DKEYSDP'     @FILED
     C                   MOVEL     'DKEYSZZ'     @FILET
     C                   ENDIF
      *
      *   Stamp Tax - Funds Transfer
      *
     C     @FILEN        IFEQ      'STFTIN  '
     C                   OPEN      FPKEYDD
     C                   OPEN      FPKEYZZ
     C                   MOVEL     'FPKEYDD'     @FILED
     C                   MOVEL     'FPKEYZZ'     @FILET
     C                   ENDIF
      *
      *   Stamp Tax - Securities
      *
     C     @FILEN        IFEQ      'STSEIN  '
     C                   OPEN      SEKEYA
     C                   OPEN      SEKEY
     C                   MOVEL     'SEKEYD '     @FILED
     C                   MOVEL     'SEKEYA '     @FILET
     C                   ENDIF
      *
      * Base CY details
      *
     C                   MOVE      BJCYCD        @AJCD
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATEB
     C                   MOVE      A6MDIN        ZMDIB
     C                   MOVE      A6INCY        ZINCYB
     C                   MOVE      A6NBDP        ZNBDPB
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRTERM - Close Input Account Keys file
      *
      * Called By:  MAIN
      *
      * Calls:      None
      *****************************************************************
      *
     C     SRTERM        BEGSR
      *
      * UPDATE TRAILERS FILE:  Trailers are updated only if @UPDFL
      * --------------------   is 'Y'. The Flag is received as input
      *                        paramter and it is set a Cob Component
      *                        level.
      *
     C     @UPDFL        IFEQ      'Y'
      *
      * .....Lending
     C     @FILEN        IFEQ      'STLEIN  '
     C                   Z-ADD     @NORE         NORE
     C                   Z-ADD     @TOTI         VLRF
     C                   Z-ADD     @TOTD         VLRL
     C                   UPDATE    LKEY1ZZF
     C                   ENDIF
      *
      * .....Fees
     C     @FILEN        IFEQ      'STLEFE  '
     C                   Z-ADD     @NORE         LKNORE
     C                   Z-ADD     @TOTI         LKVLRF
     C                   Z-ADD     @TOTD         LKVLRL
     C                   UPDATE    LKEYFEZF
     C                   ENDIF
      *
      * .....Facilities
     C     @FILEN        IFEQ      'STLEFC  '
     C                   Z-ADD     @NORE         LKNORE
     C                   Z-ADD     @TOTI         LKVLRF
     C                   Z-ADD     @TOTD         LKVLRL
     C                   UPDATE    LKEYFEZF
     C                   ENDIF
      *
      * .....Dealing
     C     @FILEN        IFEQ      'STDLIN  '
     C                   Z-ADD     @NORE         NORE
     C                   Z-ADD     @TOTI         HRWN
     C                   Z-ADD     @TOTD         HRDC
     C                   UPDATE    DKEYSZZF
     C                   ENDIF
      *
      * .....Funds Transfer
     C     @FILEN        IFEQ      'STFTIN  '
     C                   Z-ADD     @NORE         NORE1
     C                   Z-ADD     @TOTI         HRWN
     C                   Z-ADD     @TOTD         HRDC
     C                   UPDATE    FPKEYZZF
     C                   ENDIF
      *
      * .....Securities
     C     @FILEN        IFEQ      'STSEIN  '
     C     @NORE         ANDGT     0
     C                   Z-ADD     @NORE         NORE
     C                   Z-ADD     @TOTI         HRWN
     C                   Z-ADD     @TOTD         HRDC
     C                   UPDATE    SEKEYAF
     C                   ENDIF
      *
     C                   ENDIF
      *
      * CLOSE ACCOUNT KEYS FILES:
      *
      * .....Lending
     C     @FILEN        IFEQ      'STLEIN  '
     C                   CLOSE     LKEY1DL0
     C                   CLOSE     LKEY1ZZ
     C                   ENDIF
      *
      * .....Fees
     C     @FILEN        IFEQ      'STLEFE  '
     C                   CLOSE     LKEYFED
     C                   CLOSE     LKEYFEZ
     C                   ENDIF
      *
      * .....Facilities
     C     @FILEN        IFEQ      'STLEFC  '
     C                   CLOSE     LKEYFED
     C                   CLOSE     LKEYFEZ
     C                   CLOSE     FCLTY1
     C                   ENDIF
      *
      * .....Dealing
     C     @FILEN        IFEQ      'STDLIN  '
     C                   CLOSE     DKEYSDP
     C                   CLOSE     DKEYSZZ
     C                   ENDIF
      *
      * .....Funds Transfer
     C     @FILEN        IFEQ      'STFTIN  '
     C                   CLOSE     FPKEYDD
     C                   CLOSE     FPKEYZZ
     C                   ENDIF
      *
      * .....Securities
     C     @FILEN        IFEQ      'STSEIN  '
     C                   CLOSE     SEKEY
     C                   CLOSE     SEKEYA
     C                   ENDIF
      *
      * End of Report
      *
     C     PRTLN1        IFGE      57
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   WRITE     ENDDP1
      *
      * End of Report
      *
     C     X@            IFEQ      1
     C     PRTLN2        IFGE      57
     C                   WRITE     HEADP2
     C                   ENDIF
      *
     C                   WRITE     ENDDP2
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STSFXD - Stamp Tax: Retrive Flat amount from Stamp Tax
      *          actions details file.
      *
      * Called By:  STSFXD
      *
      * Calls:
      *****************************************************************
      *
     C     STSFXD        BEGSR
      *
      * Set Access key to SDSTMDL0
      *
     C                   MOVE      'T'           @T2RCT
     C                   Z-ADD     *ZEROS        @T2CDT
     C                   Z-ADD     *ZEROS        @T2ASE
     C                   Z-ADD     *ZEROS        T2TATC
      * if Reverse - retrieve original Paid stamp tax
     C                   MOVE      *BLANKS       ##RECF            1
     C                   MOVE      *OFF          *IN75
     C     REVI          IFEQ      1
     C                   MOVE      EAMT          @KEAMT
     C                   MOVE      EDAT          @KVALD
     C                   MOVE      'Y'           @T2FFT
     C                   MOVE      'Y'           @T2PAY
     C                   MOVE      '0'           @KREVI
     C     STKEYR        SETLL     SDSTMDL6
     C     *IN75         DOWEQ     *OFF
      *
     C     STKEYR        READE     SDSTMDL6                               75
     C     *IN75         IFEQ      *OFF
     C     T2TPAY        ANDEQ     'Y'
     C     T2REVI        ANDEQ     '0'
     C     T2STFF        ANDEQ     'Y'
     C                   MOVEL     T2PERD        @PERD
     C                   Z-ADD     T2TATC        @TAXE
     C                   MOVE      '1'           T2REVI
     C                   MOVE      'Y'           ##RECF            1
     C                   MOVE      *ON           *IN75
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ELSE
      *
      * Retrieve record where Action Date = 0  and Tax Paid is not Y
      *
     C     STKEY2        CHAIN     SDSTMDL0                           75
     C     *IN75         IFEQ      *OFF
     C     T2TPAY        ANDNE     'Y'
     C     *IN75         OREQ      *OFF
     C     @FIXED        ANDEQ     'C'
     C     T2DATE        ANDEQ     *ZEROS                                                   AR864714
      *
      * Tax Flag must be 'Charge' or 'Flat'
      *
     C     T2STFC        IFEQ      'Y'
     C     T2STFF        OREQ      'Y'
     C                   MOVEL     T2PERD        @PERD
     C                   Z-ADD     T2TATC        @TAXE
     C                   ENDIF
      *
     C                   ENDIF
      *
      * If not found and principal increase then call tax calc for
      * loans
      *
     C     *IN75         IFEQ      *ON
     C     *IN75         OREQ      *OFF
     C     T2TPAY        ANDEQ     'Y'
     C     @PRIN         IFEQ      'Y'
     C     LC1TFF        IFEQ      'Y'
     C     AKEVEN        IFEQ      'V'
     C     AKF910        ANDEQ     'IA'
     C     AKFCCY        ANDEQ     *BLANKS
     C     AKEVEN        OREQ      'V'
     C     AKF910        ANDEQ     ' A'
     C     AKFCCY        ANDEQ     *BLANKS
     C                   EXSR      STPINC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * STPINC - Stamp Tax: Principal increase
      *
      * Called From: STSFXD
      *
      * Calls:
      *****************************************************************
      *
     C     STPINC        BEGSR
      *
     C                   MOVEL     PLNTY         ##TYPE            4
     C                   MOVE      PLNST         ##TYPE
      *
     C                   CALL      'SD008141'
     C                   PARM      EDAT          U#DATE
     C                   PARM      U#MOD         U#ORGN           10
     C                   PARM                    ##TYPE
     C                   PARM                    U#CTAX
     C                   PARM                    U#MTAX
     C                   PARM                    U#CCCY
     C                   PARM                    U#MCCY
     C                   PARM                    U#CSCC
     C                   PARM                    U#MSCC
     C                   PARM                    U#TXTY
     C                   PARM                    SDSTPD
      *
      * If there is a default for the Module use this tax rate and ccy
      * otherwise use the ICD Control defaults.
     C     U#MTAX        IFNE      *ZEROS
     C                   Z-ADD     U#MTAX        U#TAXR           13 8
     C                   MOVE      U#MCCY        U#SCCY            3
     C                   ELSE
     C                   Z-ADD     U#CTAX        U#TAXR
     C                   MOVE      U#CCCY        U#SCCY
     C                   ENDIF
      *
      * Get Loan details
      *
     C     CLOANO        IFEQ      *BLANKS
     C                   OPEN      CLOAN
     C                   MOVEL     'Y'           CLOANO            1
     C                   ENDIF
     C     KLOAN         KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    RCDT
      *
     C     KLCSTP        KLIST
     C                   KFLD                    KC1KEY           10
     C                   KFLD                    KC1TTP            2
     C                   KFLD                    KC1STP            2
      *
     C                   MOVEL     T#LNRF        LNRF
     C                   MOVEL     'A'           RCDT
     C     KLOAN         CHAIN     CLOANCLF                           91
      *
      * Convert dates
      *
      * Value date
     C                   CALL      'ZDATE2'
     C                   PARM      EDAT          ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
      *
     C                   MOVE      ZDATE         U#VDTA
      * Maturity
     C                   CALL      'ZDATE2'
     C                   PARM      MDAT          ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
      *
     C                   MOVE      ZDATE         U#MDTA
      *
      ** If module tax set and
      ** 62 (term loan) or 70 (guarantee issued)
      *
     C                   CALL      'SD008142'
     C                   PARM                    U#VDTA            6
     C                   PARM                    U#MDTA            6
     C                   PARM                    SDSTPD
     C                   PARM                    U#TAXR
     C                   PARM      *BLANKS       U#PERD            1
     C                   PARM                    U#TXBR           13 8
     C                   PARM                    U#MNTH            7 0
     C                   PARM                    U#VDT2            5 0
     C                   PARM                    U#MDT2            5 0
      *
      *  Calculate tax
      *
     C     EAMT          MULT(H)   U#TAXR        U#STAF           13 0
      *
      * Write record to history
      *
     C                   CLEAR                   @STMDV0
      *
     C                   MOVE      @ECCY         T2ECCY
     C                   MOVE      @TXCCY        T2SCCY
     C                   MOVE      T#KEY         T2KEY
     C                   MOVE      T#LNRF        T2LNRF
     C                   MOVE      T#FCNM        T2FCNM
     C                   MOVE      T#FACT        T2FACT
     C                   MOVE      T#FCNO        T2FCNO
     C                   MOVE      T#FSEQ        T2FSEQ
     C                   MOVE      T#ORED        T2ORED
     C                   MOVE      T#DLNO        T2DLNO
     C                   MOVE      T#TDRF        T2TDRF
     C                   MOVE      T#BRCA        T2BRCA
     C                   MOVE      T#CNUM        T2CNUM
     C                   MOVE      T#CCY         T2CCY
     C                   MOVE      T#ACOD        T2ACOD
     C                   MOVE      T#ACSQ        T2ACSQ
     C                   MOVE      T#PREF        T2PREF
     C                   MOVE      T#CQSQ        T2CQSQ
     C                   MOVE      T#PBRC        T2PBRC
     C                   MOVE      T#PSSH        T2PSSH
     C                   MOVE      T#PCPY        T2PCPY
     C                   MOVE      T#PDUD        T2PDUD
     C                   MOVE      T#PEVT        T2PEVT
      *
     C                   MOVE      'T'           T2RCTP
     C                   Z-ADD     ECD           T2CDTE
     C                   Z-ADD     1             T2ASEQ
     C                   MOVE      *BLANKS       T2TPAY
     C                   MOVE      'Y'           T2TCAL
     C                   Z-ADD     U#TAXR        T2TXRT
     C                   Z-ADD     ECD           T2PSDT
     C                   Z-ADD     EDAT          T2VALD
     C                   Z-ADD     @ACTDT        T2DATE
     C                   Z-ADD     U#STAF        T2TATC
     C                   Z-ADD     EAMT          T2GROS
     C                   Z-ADD     U#STAF        T2TASC
     C                   Z-ADD     0             T2TADC
     C                   MOVE      'Y'           T2STFF
     C                   Z-ADD     ECD           T2LCD
     C                   MOVE      'I'           T2TYLC
      * Set UDF Flag
     C                   MOVE      *BLANKS       T2UDCF
      *
      * Set Debit Account
     C                   MOVE      T#DBRC        T2DBRC
     C                   MOVE      T#DCST        T2DCST
     C                   MOVE      T#DCCY        T2DCCY
     C                   MOVE      T#DACD        T2DACD
     C                   MOVE      T#DASQ        T2DASQ
     C                   MOVE      U#PERD        T2PERD
     C                   Z-ADD     U#TXBR        T2TXBR
     C                   Z-ADD     U#MNTH        T2MNTH
     C                   Z-ADD     U#VDT2        T2VDAT
     C                   Z-ADD     U#MDT2        T2MDAT
     C                   MOVEL     @T2TYP        T2TYPE                                     AR947998
      *
     C                   WRITE     @STMDV0
      *
      * Retrieve record where Action Date = 0  and Tax Paid is not Y
      *
     C                   Z-ADD     ECD           @T2CDT
     C                   Z-ADD     1             @T2ASE
     C     STKEY2        SETGT     SDSTMDL0                           75
     C     STKEY2        READPE    SDSTMDL0                               75
     C     *IN75         IFEQ      *OFF
     C     T2TPAY        ANDNE     'Y'
      *
      * Tax Flag must be 'Charge' or 'Flat'
      *
     C     T2STFC        IFEQ      'Y'
     C     T2STFF        OREQ      'Y'
     C                   MOVEL     T2PERD        @PERD
     C                   Z-ADD     T2TATC        @TAXE
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      * STCCYD - Stamp Tax: Get details of currencies involved
      *
      * Called From: STSTAX
      *
      * Calls:       AOCCY
      *****************************************************************
      *
     C     STCCYD        BEGSR
      *
      * Event CCY Details
      *
     C                   MOVE      ECCY          @AJCD
     C                   MOVE      ECCY          @ECCY             3
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATEE
     C                   MOVE      A6MDIN        ZMDIE
     C                   MOVE      A6INCY        ZINCYE
     C                   MOVE      A6NBDP        ZNBDPE
      *
      * Debit Account CCY details
      *
     C                   MOVE      T#DCCY        @AJCD
     C                   EXSR      AOCCY
     C                   Z-ADD     A6SPRT        ZRATED
     C                   MOVE      A6MDIN        ZMDID
     C                   MOVE      A6INCY        ZINCYD
     C                   MOVE      A6NBDP        ZNBDPD
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * SRHASH - Hash Totals
      *
      * Called From: WRTACK
      *
      * Calls:       GLZADD
      *****************************************************************
      *
     C     SRHASH        BEGSR
      *
      * Accumulate Hash Totals for Trailer Files
      *
     C                   ADD       1             @NORE
      *
     C     @FILEN        IFNE      'STSEIN'                                                 AR863957
     C     EAMT          DIV       1000          ZZAMT                  75
     C     *IN75         IFEQ      *ON                                                     AR863957A
     C                   Z-SUB     ZZAMT         ZZAMT                                     AR863957A
     C                   ENDIF                                                             AR863957A
     C                   ELSE                                                               AR863957
     C                   Z-ADD     EAMT          ZZAMT                                      AR863957
     C                   ENDIF                                                              AR863957
     C***75*****         Z-SUB     ZZAMT         ZZAMT                                     AR863957A
     C                   Z-ADD     @TOTI         ZZTOTI
     C                   Z-ADD     @TOTD         ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        @TOTI
     C                   Z-ADD     ZZTOTD        @TOTD
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      *  XCAMT - Convert Amount                                       *
      *                                                               *
      *  Called From: STSTAX                                          *
      *                                                               *
      *  Calls:       ZXRATE                                          *
      *               ZCONV                                           *
      *               Pgm EU0200                                      *
      *****************************************************************
      *
     C     XCAMT         BEGSR
      *
     C                   Z-ADD     *ZEROS        P@OUTA
      *
      * From CCY is not EUR and is not an 'IN' CcY
      * ..OR To CCY is not EUR and is not an 'IN' Ccy
      *
     C     CCYFR         IFNE      'EUR'
     C     ZINCFR        ANDNE     'Y'
      *
     C     CCYTO         ORNE      'EUR'
     C     ZINCTO        ANDNE     'Y'
      *
     C                   Z-ADD     *ZEROS        ZRATEX           13 8
     C     ZMDIFR        IFEQ      ZMDITO
     C     ZRATTO        IFNE      *ZEROS
     C     ZRATFR        DIV(H)    ZRATTO        ZRATEX
     C                   ENDIF
     C                   ELSE
     C     ZRATFR        MULT(H)   ZRATTO        ZRATEX
     C                   END
     C                   MOVE      ZMDIFR        ZMDIX             1
      *
     C                   Z-ADD     ZNBDFR        ZCDPI
     C                   Z-ADD     ZNBDTO        ZCDPO
     C                   Z-ADD     P@FRAM        ZAMTCI
     C                   Z-ADD     *ZEROS        ZAMTCO
     C                   Z-ADD     ZRATEX        ZEXCH
     C                   MOVE      ZMDIX         ZMD
      *
     C                   EXSR      ZCONV
      *
     C                   Z-ADD     ZAMTCO        P@OUTA
      *
      * Conversion between EURO currencies
      *
     C                   ELSE
      *
     C                   MOVE      CCYFR         P@FRCY
     C                   MOVE      CCYTO         P@TOCY
      *
     C                   CALL      'EU0200'
      *                                                    Input:
     C                   PARM      '       '     P@RTCD            7
     C                   PARM                    P@FRAM           18 3
     C                   PARM                    P@FRCY            3
     C                   PARM                    P@TOCY            3
      *                                                    Output:
     C                   PARM                    P@OUTA           15 0
     C                   PARM                    P@INTA           18 3
     C                   PARM                    P@EXRT           15 9
     C                   PARM                    P@MDIN            1
      *
     C     @RTCD         IFNE      *BLANK
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'EU0200  '    DBFILE
     C                   MOVEL     P@FRCY        DBKEY1            6
     C                   MOVE      P@TOCY        DBKEY1
     C                   MOVEL     DBKEY1        DBKEY
     C                   Z-ADD     50            DBASE
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************---
      *  SRERRT - Data Base Error on Trailer File
      *                                                                ---
      *  Called From: STLEIN                                           ---
      *               STDLIN                                           ---
      *               STSEIN                                           ---
      *               STFTIN                                           ---
      *               STLEFE                                           ---
      *               STLEFC                                           ---
      *                                                                ---
      *  Calls        *PSSR                                            ---
      *****************************************************************---
      *
     C     SRERRT        BEGSR
      *
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     @FILET        DBFILE
     C                   Z-ADD     053           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************---
      *  AOCCY - Call AOCURRR0 to retrieve CCY details
      *                                                                ---
      *  Called From: STCHAI                                           ---
      *               SROPEN                                           ---
      *               STCCYD                                           ---
      *                                                                ---
      *  Calls:       Pgm AOCURRR0                                     ---
      *               *PSSR                                            ---
      *****************************************************************---
      *
     C     AOCCY         BEGSR
      *
      * AOCCY  : Call to Access object AOCURRR0 for Currency Details.
      *
     C                   CALL      'AOCURRR0'
      *                                                     Input:
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @AJCD             3
      *                                                     Output:
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** If a record is not found, perform database Error processing.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     @AJCD         DBKEY
     C                   Z-ADD     51            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      * *PSSR  - Program exception processing.                        *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called By: VARIOUS                                           *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Ensure dump is executed only once.
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   SETON                                        U7U8
     C                   DUMP
      *
      ** Produce error report
     C                   OPEN      GL008130AU
     C                   WRITE     GL8130A1
     C                   WRITE     DBFMTAU
      *
      * Ensure the AU spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUMA        ZSNUM
      *
      * Call ZSFILE for GL008130AU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQNO
     C                   PARM      *BLANKS       ENTY
     C                   PARM                    SFILEA
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
      *
     C                   CLOSE     GL008130AU
      *
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      ** Exit program.
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
     C/EJECT
     C/COPY ZSRSRC,ZDATE9Z3LE
     C/EJECT
     C/COPY ZSRSRC,ZSEDITZ3LE
     C/EJECT
     C/COPY ZSRSRC,ZDATE2Z2LE
     C/EJECT
     C/COPY ZSRSRC,ZCONVZ1ILE
      *
     C/EJECT
      *****************************************************************
      * GLZADD -
      *
      * Called From: SRHASH
      *
      * Calls:       GLZSUM
      *****************************************************************
      *
     CSR   GLZADD        BEGSR
      *
     CSR                 Z-ADD     ZZAMT         ZZAMT            15 3    91
     CSR 91              GOTO      ZZAEND
      *
      * SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
     CSR                 Z-ADD     ZZAMT         ZZAMTI           15 0
     CSR                 MOVE      ZZAMT         ZZAMTD            3 0
      * BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
      *
     CSR                 EXSR      GLZSUM
     CSR   ZZAEND        ENDSR
      *
      ********************************************************************
      * SUBROUTINE TO CARRY OUT THE ADDITION FOR SUBROUTINES -
      *                        GLZADD, GLZSUB, GLZCMP.
      *          PARAMETERS PASSED -
      *                     I/P ZZAMTI ZZAMTD
      *                     O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
      ********************************************************************
      *
     CSR   GLZSUM        BEGSR
      *
     CSR                 Z-ADD     ZZTOTI        ZZTOTI           15 0
     CSR                 Z-ADD     ZZTOTD        ZZTOTD            3 0
     CSR                 SETOFF                                       919293
     CSR                 SETOFF                                       949599
      *
      *    DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG
     CSR   ZZAMTI        COMP      0                                    9293
     CSR 93ZZAMTD        COMP      0                                    9293
     CSR 93              GOTO      ZZSEND
      *
      *    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.
     CSR   ZZTOTI        COMP      0                                    9193
     CSR 93ZZTOTD        COMP      0                                    9193
      *
      *    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
     CSR 93              Z-ADD     ZZAMTI        ZZTOTI
     CSR 93              Z-ADD     ZZAMTD        ZZTOTD
     CSR 93              GOTO      ZZSEND
      *    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     CSR 91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
      *
     CSR   ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     CSR   ZZWK2         COMP      999                                93
     CSRN93ZZWK2         COMP      -999                                 93
      *
     CSR 93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0
     CSR 93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     CSR 93ZZTOTI        ADD       ZZWK3         ZZWK3
     CSRN93ZZTOTI        ADD       ZZAMTI        ZZWK3
      *
      * IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED
     CSRN92ZZWK3         COMP      ZZTOTI                               99
     CSR 92ZZWK3         COMP      ZZTOTI                             99
     CSRN99              Z-ADD     ZZWK2         ZZTOTD
     CSRN99              Z-ADD     ZZWK3         ZZTOTI
      *
      * IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
     CSR 99              Z-ADD     0             ZZAMT            15 3
     CSR                 GOTO      ZZSEND
      *
      * THE 'SIGNS' ARE DIFFERENT
     CSR   ZZOFPS        TAG
      * IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT
      *
     CSR 92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     CSR 92              Z-SUB     ZZAMTD        ZZAMTD            3 0
      *
      * IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
      *
     CSR 91              Z-SUB     ZZTOTI        ZZTOTI
     CSR 91              Z-SUB     ZZTOTD        ZZTOTD
      * BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
      *
     CSR   ZZTOTI        COMP      ZZAMTI                             93  95
     CSR 95ZZTOTD        COMP      ZZAMTD                             93  95
      *
      * IF ZZTOT EQ. ZZAMT RETURN ZERO.
     CSR 95              Z-ADD     0             ZZTOTI
     CSR 95              Z-ADD     0             ZZTOTD
     CSR 95              GOTO      ZZSEND
      *
      * IF ZZTOT GT. ZZAMT.
     CSR 93ZZAMTD        COMP      ZZTOTD                             94
     CSR 93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     CSR 93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     CSR 93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     CSR 93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     CSR 93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
      *
      *
      * IF ZZAMT GT. ZZTOT.
     CSRN93ZZTOTD        COMP      ZZAMTD                             94
     CSRN93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     CSRN93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     CSRN93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     CSRN93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     CSRN93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     CSRN93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
      *
      * REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE
     CSR                 SETOFF                                       94
     CSR 93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     CSR 94              Z-SUB     ZZTOTI        ZZTOTI
     CSR 94              Z-SUB     ZZTOTD        ZZTOTD
      **
      **   RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
     CSR 92              Z-SUB     ZZAMTI        ZZAMTI
     CSR 92              Z-SUB     ZZAMTD        ZZAMTD
     CSR   ZZSEND        TAG
      **
      **   IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
     CSR                 SETOFF                                       96
     CSR   ZZTOTD        COMP      0                                      91
     CSR 91ZZTOTI        COMP      0                                    96
     CSR 96              MOVE      '.000-'       ZZNEGD            5
     CSR                 ENDSR
      *
      **************************************************************
      *
      * Summary Stamp Tax file: (CLONCLQD)
     OCLONLQD0  E            UPDLO
     O                       LQSTAI
      *
      * Summary Stamp Tax file: (DLDLDCQD)
     ODLDLDCD0  E            UPDDL
     O                       F1STAI
      *
      * Historic/Details file: (SDSTMDPD)
     O@STMDV0   E            UPDSTD
     O                       T2SCCY                                                         AR864206
     O                       T2TPAY
     O                       T2PSDT
     O                       T2VALD
     O                       T2TYLC
     O                       T2LCD
     O                       T2TASC
     O                       T2TADC
     O                       T2GROS
     O               50      T2DBRC                                                         AR864206
     O               50      T2DCST                                                         AR864206
     O               50      T2DCCY                                                         AR864206
     O               50      T2DACD                                                         AR864206
     O               50      T2DASQ                                                         AR864206
     O                       T2AKEY
     O                       T2ETYP
     O                       T2KCCY
     O                       T2KAMT
     O                       T2REVI
     O                       T2XRAT                                                         AR879983
      *
      * Historic/Details file: (SDSTMDPD)
     O@STMDV6   E            UPDST6
     O                       T2TPAY
     O                       T2PSDT
     O                       T2VALD
     O                       T2TYLC
     O                       T2LCD
     O                       T2TASC
     O                       T2TASC
     O                       T2GROS
     O                       T2AKEY
     O                       T2ETYP
     O                       T2KCCY
     O                       T2KAMT
     O                       T2REVI
      *
     X/COPY ZSRSRC,ZDATE9Z4
     X/COPY ZSRSRC,ZDATE2Z3
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
** CPY@   **      OBJECT COPYRIGHT
(C) Copyright Misys International Banking Systems Ltd. 2010
** FIL@   **
STLEIN    STLEFE    STLEFC    STDLIN    STFTIN    STSEIN
** KEY@   **
LOAN      FEE       FACILITY  DEAL      PAYMENT   SECURITY
** NAR@   **
   LENDING STAMP TAX - LOANS INTEREST
        LENDING STAMP TAX - FEES
     LENDING STAMP TAX - FACILITIES
     MONEY MARKET - LOANS INTEREST
       FUNDS TRANSFER - CHARGES
         SECURITIES - CHARGES
     LENDING STAMP TAX - PRINCIPAL
