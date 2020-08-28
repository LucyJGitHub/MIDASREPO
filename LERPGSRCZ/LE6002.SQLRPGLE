     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE APR Calculation - with history')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE6002 - Midas LE APR Calculation - with history             *
      *                                                               *
      *  (c)Finastra International Limited 2016                       *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054017           Date 04Sep19               *
      *                 CER050  *CREATE    Date 16Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD054017-Change on validation of System Value "APR Formula"  *
      *  CER050 - Annualised Percentage Rate (APR)                    *
      *                                                               *
      *****************************************************************
      *                                                               *
     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     FLOAMS     IF   E           K DISK
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSZ1F)
     FHISTR     IF   E           K DISK
     FLEFHSTL1  IF   E           K DISK
     FLEFEEDL2  IF   E           K DISK
     F                                     RENAME(LEFEEDF:LEFEED2)
     FSDFEEL0   IF   E           K DISK
     FSDCURRL0  IF   E           K DISK
     FSDCTRYPD  IF   E           K DISK
     FLEAPRHI0  IF   E           K DISK
     FGLAPRCTD  O    E             DISK    USROPN
     FLEAPRHTD  O    E             DISK
     F                                     RENAME(LEAPRHD0:LEAPRHD1)
      *****************************************************************
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*               S/CLOAN - DETAIL RECORD 'A'
     F*                       - DETAIL RECORD 'B'
     F*       08  -   Chain to LEFEEDL2                               *
     F*       09  -   Chain to SDFEEL0                                *
     F*       10      S01465 IS SWITCHED ON                           *
     F*       13  -   LOKUP of CURR array for from currency           *
     F*       14  -   LOKUP of CURR array for to currency             *
     F*       15  -   Used in accessing Currency                      *
     F*       16  -   Reading Fees History file                       *
     F*       21      MATURITY DATE OF LOAN = 0
     F*       24      NEXT REPAYMENT DATE OF LOAN = 0
     F*       25      ROLLOVER DATE OF LOAN = 0
     F*       26      NEXT INTEREST DATE OF LOAN =0
     F*       27      BASE CCY FOR LIMITS BLANK
     F*       28      SKIP 'START' SUBR - history processed
     F*       29      ACCUMULATING - DO NOT WRITE TO GLAPRCTD
     F*       31      COMPLETE DISPLAYED
     F*       34      NO MORE LOAMS RECORDS
     F*       37      NO MORE HISTR RECORDS
     F*       40      CONDITIONS FIRST CYCLE PROCESSING
     F*       41      WORK INDICATOR - MAIN PROCESSING
     F*       50      EVENT DERIVED FROM LOAN AMENDMENT
     F*       51      REPAYMENT TYPE = 1
     F*       52                     = 2
     F*       53                     = 3
     F*       54      INTEREST TO BE CAPITALIZED
     F*       55      CHAIN FAIL/DETAIL RECORD NOT FOUND
     F*       56      NO (FURTHER) AMENDMENTS FOR GIVEN LOAN
     F*       57      LOKUP RESULT INDICATOR
     F*       59      STOP ACCRUALS INDICATOR SET
     F*       60      RECORDS EXIST ON GLAPRCTD
     F*       64      EVENTS WITH A PORTFOLIO REFERENCE
     F*       65      NEW MATURITY DATE TO BE USED FOR EVENTS
     F*       66      DISCOUNTED LOANS, NO INTEREST CAL. REQD.
     F*       77      MATURITY LOCATION CODE IS DETERMINED
     F*       80      WORK INDICATOR - LOWER LEVEL S/ROUTINES
     F*       81      IN/OUT = I
     F*       82      IN/OUT = O
     F*       83-85    WORK INDICATORS - LOWER LEVEL S/ROUTINES
     F*       87      WORK INDICATOR - EVENTS S/ROUTINES
     F*       U1      EXPOSURE MANAGEMENT MODULE PRESENT
     F*       U7      STANDARD MIDAS USAGE
     F*       U8      STANDARD MIDAS USAGE
      *****************************************************************
     D*
     D*  KEY TO TABLES -
     D*    TAB1 CONTAINS EVENT CODE(PROCESSING TYPE WITH EVENT TYPE)
     D*    TAB2 CONTAINS CORRESPONDING VALUES FOR THOSE OUTPUT FIELDS
     D*    DEPENDENT UPON PROCESSING TYPE - 'OTHER DATE','OTHER AMOUNT',
     D*    'INSTRUCTIONS INDICATOR','INCOMING/OUTGOING INDICATOR'.
     D*    DAT -                               AMT -
     D*    1  ZERO                             1  ZERO
     D*    2  START                            2  PRINCIPAL
     D*    3  MATURITY                         3  INTEREST
     D*    4  NEXT ROLLOVER                    4  PRINCIPAL REPAYMENT
     D*                                        5  INTEREST REPAYMENT
     D*                                        6  DISCOUNT AMOUNT
     D*                                        7  NEW PRINCIPAL AMOUNT
     D*                                        8  ANNUAL PREMIUM
     D*    INSTRUCTION INDS -            I/O INDS -
     D*     0  0                              BLANK
     D*     1  1                          I  I
     D*     2  2                          O  O
     D*     3  3
     D*     4  2/3
      *****************************************************************
     D/COPY ZSRSRC,ZDATE2Z1LE
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)              POWERS OF 10
     D TAB1            S              4    DIM(29) CTDATA PERRCD(1)             IN/OUTPUT FIELDS
     D TAB2            S              4    DIM(29) ALT(TAB1)
      *
     D XCYA            S              3    DIM(150)                             CURRENCIES
     D XDPA            S              1  0 DIM(150)                             DEC. PLACES
     D XSPA            S             13  8 DIM(150)                             SPOT RATES-BASE
     D XMDA            S              1    DIM(150)                             MULT/DIV IND
     D XSSA            S              2  0 DIM(150)                             SORT SEQUENCE
     D XSLA            S             13  8 DIM(150)                             SPOT RATES-LIMITS
      *
     D XCOD            S              2    DIM(400)                             COUNTRY CODES
     D XREG            S              2    DIM(400)                             REGION CODES
      *
     D P@OP01          S             20                                                  MD054017
     D P@VL01          S            200                                                  MD054017
     D P@OP02          S             20                                                  MD054017
     D P@VL02          S            200                                                  MD054017
     D P@OP03          S             20                                                  MD054017
     D P@VL03          S            200                                                  MD054017
     D P@OP04          S             20                                                  MD054017
     D P@VL04          S            200                                                  MD054017
     D P@OP05          S             20                                                  MD054017
     D P@VL05          S            200                                                  MD054017
     D P@OP06          S             20                                                  MD054017
     D P@VL06          S            200                                                  MD054017
     D P@OP07          S             20                                                  MD054017
     D P@VL07          S            200                                                  MD054017
     D P@OP08          S             20                                                  MD054017
     D P@VL08          S            200                                                  MD054017
     D P@OP09          S             20                                                  MD054017
     D P@VL09          S            200                                                  MD054017
     D P@OP10          S             20                                                  MD054017
     D P@VL10          S            200                                                  MD054017
     D SYSVAL1         S              1                                                  MD054017
     D SYSVAL2         S             30                                                  MD054017
     D SYSVAL2A        S             30                                                  MD054017
      *                                                                                  MD054017
     D/COPY ZSRSRC,ZFREQBZ1LE
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      * DATA STRUCTURE FOR S/LVNTX OUTPUT KEYS
     D                 DS
     D  EVCODE                 1      4
     D  PTYP                   1      2  0
     D  EVTYPE                 3      4
     D  KEYDS                  5      8
     D  ED                     5      5  0
     D  EA                     6      6  0
     D  INSIND                 7      7  0
     D  INOUT                  8      8
      *
      * DATA STRUCTURE FOR 'OTHER DATE' ARRAY
     D                 DS
     D  DAT                    1     20  0
     D                                     DIM(4)                               OTHER DATES
     D  ZERO05                 1      5  0
     D  VDAT                   6     10  0
     D  MDAT                  11     15  0
     D  NROD                  16     20  0
      *
      * DATA STRUCTURE FOR 'OTHER AMOUNT' ARRAY
     D                 DS
     D  AMT                    1    104  0
     D                                     DIM(8)                               OTHER AMOUNTS
     D  ZERO13                 1     13  0
     D  CPRINC                14     26  0
     D  INTDUE                27     39  0
     D  REAMT                 40     52  0
     D  REINT                 53     65  0
     D  TOTI                  66     78  0
     D  NPRAM                 79     91  0
     D  ANNPR                 92    104  0
      *
      * DATA STRUCTURE FOR SETTLEMENT DETAILS
     D                 DS
     D  SETTLE                 1     30
     D  SETTYP                 1      2  0
     D  SETAC                  3     20
     D  SETNOS                21     30
      *
      * DATA STRUCTURE FOR ROLLOVER DETAILS
     D                 DS
     D  ROLLOS                 1     30
     D  RDST                   1      2  0
     D  ORVD                   3     20
     D  THRN                  21     30
      *
     D                 DS
      * Redefine fee details.
     D  FEFACL                 5      9  0
     D  FACT                   5      7  0
     D  FCNO                   8      9  0
      *
     D LESTAT        E DS                  EXTNAME(LESTAT)
      * Data Structure to obtain control date
     D  SETUP        E                     EXTFLD(FLSETUP)
     D  HIST         E                     EXTFLD(HSTPROC)
     D  WCODT        E                     EXTFLD(CODT)
      *
      * DATA STRUCTURE FOR START SETTLEMENT DETAILS
     D                 DS
     D  STARTS                 1     30
     D  SDST                   1      2  0
     D  OSDA                   3     20
     D  TSTN                  21     30
      *
      * DATA STRUCTURE FOR MATURITY SETTLEMENT DETAILS
     D                 DS
     D  MATURS                 1     30
     D  MDST                   1      2  0
     D  OMDA                   3     20
     D  TMAN                  21     30
      *
      * DATA STRUCTURE FOR AMENDMENT SETTLEMENT DETAILS
     D                 DS
     D  AMENDS                 1     30
     D  SETP                   1      2  0
     D  OSAC                   3     20
     D  TSEN                  21     30
      *
     D                 DS
      * Redefine PRINRO from HISTSHQ as char
     D  PRINRO                 1     13  0
     D  PRINX                  1     13
      *
     D                 DS
      * Get additional day indicator for matured records
     D  ORTI                   1      7P 0
      *
      * LDA - DIAGNOSTIC FOR PROGRAM ABORT
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * EXTERNAL DS FOR BANK DETAILS
     D  BCCY         E                     EXTFLD(BJCYCD)
     D  DATF         E                     EXTFLD(BJDFIN)
     D  DNWD         E                     EXTFLD(BJDNWD)
     D  RUNA         E                     EXTFLD(BJMRDT)
     D  RUND         E                     EXTFLD(BJRDNB)
     D  TITL         E                     EXTFLD(BJURPT)
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      * EXTERNAL DS FOR BRANCH CODE DETAILS
     D  CMPYM        E                     EXTFLD(A8CMCD)
     D  DFAC         E                     EXTFLD(QQDFAC)
     D  BICN         E                     EXTFLD(A8BICN)
      *
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      * EXTERNAL DS FOR BASE RATE DETAILS
     D  NBRT         E                     EXTFLD(BANBRT)
     D  VDNR         E                     EXTFLD(BAVDNR)
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * EXTERNAL DS FOR CUSTOMER DETAILS
     D  CLOC         E                     EXTFLD(BBCOLC)
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      * EXTERNAL DS FOR DEALING DATA
     D  ACCD         E                     EXTFLD(QQACCD)
     D  BCYL         E                     EXTFLD(BNCYCD)
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      * EXTERNAL DS FOR GENERAL LEDGER DETAILS
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * EXTERNAL DS FOR MIDAS MODULE DETAILS
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      * EXTERNAL DS FOR NOSTRO DETAILS
     D  QACCD        E                     EXTFLD(QQACCD)
     D  CSNM         E                     EXTFLD(A7NOSN)
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * Currency details
      *
     D SDCURR1       E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(A_)
      * Currency details 'From Currency'
      *
     D SDCURR2       E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(B_)
      * Currency details 'To Currency'
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * SAR File Details Accessed via Access Program AOSARDR0
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D DSCSNM          DS            10
      * DATA AREA FOR THE LOCATION CODE IN CUSTOMER SHORTNAME FIELD
     D  NRLC                   8     10
     I/COPY ZSRSRC,ZDAT10Z1LE
     I/COPY ZSRSRC,ZHOLELE
     I/COPY ZSRSRC,ZDATE9Z1LE
     I/COPY ZSRSRC,ZHOLILE
     I/COPY ZSRSRC,ZINTDYZ1LE
     I/COPY ZSRSRC,ZDATE9Z2LE
     I/COPY ZSRSRC,ZCPDZ1ILE
      *
     D F@FAMT          S             15P 0
     D T@CAMT          S             15P 0
     D F@NBDP          S              1P 0
     D T@NBDP          S              1P 0
                                                                                         MD054017
     D LO              C                   'abcdefghijklmnopqrstuvwxyz'                  MD054017
     D UP              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                  MD054017
                                                                                         MD054017
      *
     ICLOANCKF
      * Rename fields on CLOANCK
     I              NLRA                        NLRAZ1
      * CUSTOMER LENDING LOAN AMENDMENTS FILE - DETAIL
      * RENAME FIELDS APPENDED 'LA' TO DISTINGUISH FROM S/CLOAN FLDS
     ILOAMSDKF
     I              LNRF                        LNRFLA
     I              VDAT                        VDATLA
     I              LTYP                        LTYPLA
     I              SUTP                        SUTPLA
     I              PTYP                        PTYPLA
     I              AMTP                        AMTPLA
     I              BRTT                        BRTTLA
     I              RTSP                        RTSPLA
     I              CCY                         CCYLA
     I              PRAM                        PRAMLA
     I              INTA                        INTALA
     I              WTXA                        WTXALA
     I              FEAM                        FEAMLA
     I              TAMT                        TAMTLA
     I              BRCA                        BRCDLA
     I              CNUM                        CNUMLA
     I              REPT                        REPTLA
     I              AUTO                        AUTOLA
     I              FACO                        FACOLA
     I              BRTE                        BRTELA
     I              WTIN                        WTINLA
     I              FCUS                        FCUSLA
     I              FTYP                        FTYPLA
     I              FSEQ                        FSEQLA
     I              ORED                        OREDLA
      *
     I@A6REA4
     I              A6CYCD                      CCYA
     I              A6NBDP                      CDP
     I              A6TXND                      TXND
     I              A6ERLC                      ERLC
     I              A6MDIN                      MDIN
     I              A6SPRT                      SPOT
     I              A6SSNB                      SSNO
     IHISTSHMF
      * Rename history header fields
     I              BRCA                        BRCAH
     I              CNUM                        CNUMH
     I              LNRF                        LNRFH
     I              VDAT                        VDATH
     I              AMTP                        AMTPH
     I              PRAM                        PRAMH
     I              BRTE                        BRTEH
     I              RTSP                        RTSPH
     I              SPIN                        SPINH
     I              REPT                        REPTH
     I              INTC                        INTCH
     I              SUTP                        SUTPH
     I              LCD                         LCDH
     I              CPAM                        CPAMH
     I              AITC                        AITCH
     I              INTR                        INTRH
     I              AIAP                        AIAPH
     I              IPRD                        IPRDH
     I              WTIN                        WTINH
     I              TOTI                        TOTIH
      *
     IHISTSHPF
      * Rename history amount fields
     I              BRCA                        BRCAH
     I              CNUM                        CNUMH
     I              LNRF                        LNRFH
     I              VDAT                        VDATH
     I              AMTP                        AMTPH
     I              PRAM                        PRAMH
     I              INTA                        INTAH
     I              WTXA                        WTXAH
     I              FEAM                        FEAMH
     I              WOIN                        WOINH
     I              SUTP                        SUTPH
     I              LCD                         LCDH
     I              CPAM                        CPAMH
     I              AITC                        AITCH
     I              INTR                        INTRH
     I              AIAP                        AIAPH
     I              IPRD                        IPRDH
     I              MNSG                        MNSGH
     I              GASS                        GASSH
     I              ROLN                        ROLNH
      *
     IHISTSHQF
      * Rename history rate fields
     I              BRCA                        BRCAH
     I              CNUM                        CNUMH
     I              LNRF                        LNRFH
     I              VDAT                        VDATH
     I              CCY                         CCYH
     I              AMTP                        AMTPH
     I              BRTE                        BRTEH
     I              RTSP                        RTSPH
     I              SPIN                        SPINH
     I              STAI                        STAIH
     I              IRCF                        IRCFH
     I              LCD                         LCDH
     I              CPAM                        CPAMH
     I              AITC                        AITCH
     I              INTR                        INTRH
     I              AIAP                        AIAPH
     I              IPRD                        IPRDH
     I              MNSG                        MNSGH
     I              RLCY                        RLCYH
      *
     ISDCTRYD0
     I              A4CNCD                      CCOD
     I              A4RGCD                      REGC
      *
     C                   MOVEA     CPY@          BIS@             80
      ********************************************************************
      *   INITIAL PROCESSING
      *
     C     *ENTRY        PLIST
     C                   PARM                    ERRCOD            7            Error code
     C                   PARM                    INLOAA            6            Loan number
      *
     C                   MOVE      *BLANKS       ERRCOD
     C                   MOVE      INLOAA        INLOAN            6
      *
     C     *DTAARA       DEFINE                  LDA
      *
      * Control date has previously been worked out in LER135
      * and held on data area LESTAT.
     C     *DTAARA       DEFINE                  LESTAT
     C                   IN        LESTAT
      *
      * Define program variables
     C     *LIKE         DEFINE    A_A6SPRT      T@CERT
     C     *LIKE         DEFINE    A_A6MDIN      T@MDIV
     C     *LIKE         DEFINE    FEFCCY        F@FCCY
     C     *LIKE         DEFINE    BCCY          T@CCY
     C     *LIKE         DEFINE    A_A6SPRT      F@SPRT
     C     *LIKE         DEFINE    A_A6MDIN      F@MDIN
     C     *LIKE         DEFINE    B_A6SPRT      T@SPRT
     C     *LIKE         DEFINE    B_A6MDIN      T@MDIN
      *
      * ACCESS BANK DETAILS
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   SETON                                        U7U899
     C     *LOCK         IN        LDA
     C                   MOVE      'LE6002'      DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE                         ***************
     C                   MOVEL     @OPTN         DBKEY                          * DBERROR 01  *
     C                   Z-ADD     1             DBASE                          ***************
     C                   OUT       LDA
     C                   GOTO      END
     C                   ELSE
      *
      * CHECK SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.
     C     DATF          COMP      'M'                                    98    MMDDYY, 98 ON
     C                   END
      *
      * ACCESS GENERAL LEDGER DETAILS
     C                   CALL      'AOGELRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   SETON                                        U7U855    **DATABASE 02**
     C                   Z-ADD     2             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   GOTO      END
     C                   END
      *
      * ACCESS MIDAS MODULE DETAILS
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     @RTCD         IFNE      *BLANK
     C                   SETON                                        U7U8LR    ***************
     C                   Z-ADD     3             DBASE                          * DBERROR 03  *
     C                   MOVEL     'SDMMODPD'    DBFILE                         ***************
     C                   GOTO      END
     C                   END
      *
      * ACCESS DEALING DATA
     C     BGDLFX        IFEQ      'Y'
     C     BGDLMM        OREQ      'Y'
     C                   CALL      'AODEALR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDDEAL        PARM      SDDEAL        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDDEALPD'    DBFILE                         ***************
     C                   MOVEL     @OPTN         DBKEY                          * DEERR 04 ****
     C                   Z-ADD     4             DBASE                          ***************
     C                   GOTO      END
     C                   ELSE
     C     BCYL          COMP      *BLANKS                                27
     C                   END
      *
      * If dealing not installed, use base currency instead
     C                   ELSE
     C                   MOVE      '1'           *IN27
     C                   ENDIF
      *
      * Read switchable features file SCSARDPD using access object
      * to determine if switchable feature (S01465) is switched ON
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       W0RTCD            7
     C                   PARM      '*VERIFY'     W0OPTN            7
     C                   PARM      'S01465'      W0SARD            6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   MOVE      '0'           *IN10
      *
      * If feature is on, set up SAR indicator  (*IN10)
     C     W0RTCD        IFEQ      *BLANKS
     C                   MOVE      '1'           *IN10
     C                   ELSE
      *
      * else, database error (return code other than *NRF)
     C     W0RTCD        IFNE      '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '*VERIFY'     DBKEY                          * DBERR  5 *
     C                   Z-ADD     5             DBASE                          ************
     C                   SETON                                        U7U8LR
     C                   GOTO      END
     C                   END
      *
      * Read switchable features file SCSARDPD to determine whether
      * Citydealer interface for Non-front Office Cashflows is
      * installed (CCM002).
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       W0RTCD            7
     C                   PARM      '*VERIFY'     W0OPTN            7
     C                   PARM      'CCM002'      W0SARD            6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   MOVE      'N'           WCITYD            1
      *
      * If feature is on, set up SAR work flag (WCITYD)
     C     W0RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           WCITYD
     C                   ELSE
      *
      * else, database error (return code other than *NRF)
     C     W0RTCD        IFNE      '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '*VERIFY'     DBKEY                          * DBERR  6 *
     C                   Z-ADD     6             DBASE                          ************
     C                   SETON                                        U7U8LR
     C                   GOTO      END
     C                   END
      *
     C                   END
      *
     C                   END
      *
      * Check if SAR CLE005 is switched *ON.
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005 '     @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005            1
     C                   ELSE
     C                   MOVE      'N'           CLE005
     C     @RTCD         IFNE      '*NRF    '
     C                   SETON                                        U7U8LR
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   Z-ADD     1             DBASE                          * DBERR 01 *
     C                   MOVEL     'CLE005  '    DBKEY                          ************
     C                   ENDIF
     C                   ENDIF
      ** Call Access Program for System Value                                            MD054017
                                                                                         MD054017
     C                   EVAL      SYSVAL1 = *BLANKS                                     MD054017
     C                   EVAL      P@OP01 = 'APRLELoans'                                 MD054017
     C                   Call      'AOSVALR0'                                            MD054017
     C                   Parm      *BLANKS       @RTCD                                   MD054017
     C                   Parm                    P@OP01                                  MD054017
     C                   Parm      *BLANKS       P@VL01                                  MD054017
     C                   Parm                    P@OP02                                  MD054017
     C                   Parm      *BLANKS       P@VL02                                  MD054017
     C                   Parm                    P@OP03                                  MD054017
     C                   Parm      *BLANKS       P@VL03                                  MD054017
     C                   Parm                    P@OP04                                  MD054017
     C                   Parm      *BLANKS       P@VL04                                  MD054017
     C                   Parm                    P@OP05                                  MD054017
     C                   Parm      *BLANKS       P@VL05                                  MD054017
     C                   Parm                    P@OP06                                  MD054017
     C                   Parm      *BLANKS       P@VL06                                  MD054017
     C                   Parm                    P@OP07                                  MD054017
     C                   Parm      *BLANKS       P@VL07                                  MD054017
     C                   Parm                    P@OP08                                  MD054017
     C                   Parm      *BLANKS       P@VL08                                  MD054017
     C                   Parm                    P@OP09                                  MD054017
     C                   Parm      *BLANKS       P@VL09                                  MD054017
     C                   Parm                    P@OP10                                  MD054017
     C                   Parm      *BLANKS       P@VL10                                  MD054017

      ** Handle Database Error

     C                   If        @RTCD <> *BLANKS                                      MD054017
     C                   Eval      DBASE = 42                                            MD054017
     C                   Eval      DBFILE = 'SDSVALPD'                                   MD054017
     C                   Eval      DBKEY = P@OP01                                        MD054017
     C                   Eval      DBPGM = 'AOSVALR0'                                    MD054017
     C                   EXSR      *PSSR                                                 MD054017
     C                   ELSE                                                            MD054017
     C                   EVAL      SYSVAL1 = P@VL01                                      MD054017
     C                   ENDIF                                                           MD054017
                                                                                         MD054017
     C                   EVAL      SYSVAL2 = *BLANKS                                     MD054017
     C                   EVAL      P@OP01 = 'APRFormula'                                 MD054017
     C                   Call      'AOSVALR0'                                            MD054017
     C                   Parm      *BLANKS       @RTCD                                   MD054017
     C                   Parm                    P@OP01                                  MD054017
     C                   Parm      *BLANKS       P@VL01                                  MD054017
     C                   Parm                    P@OP02                                  MD054017
     C                   Parm      *BLANKS       P@VL02                                  MD054017
     C                   Parm                    P@OP03                                  MD054017
     C                   Parm      *BLANKS       P@VL03                                  MD054017
     C                   Parm                    P@OP04                                  MD054017
     C                   Parm      *BLANKS       P@VL04                                  MD054017
     C                   Parm                    P@OP05                                  MD054017
     C                   Parm      *BLANKS       P@VL05                                  MD054017
     C                   Parm                    P@OP06                                  MD054017
     C                   Parm      *BLANKS       P@VL06                                  MD054017
     C                   Parm                    P@OP07                                  MD054017
     C                   Parm      *BLANKS       P@VL07                                  MD054017
     C                   Parm                    P@OP08                                  MD054017
     C                   Parm      *BLANKS       P@VL08                                  MD054017
     C                   Parm                    P@OP09                                  MD054017
     C                   Parm      *BLANKS       P@VL09                                  MD054017
     C                   Parm                    P@OP10                                  MD054017
     C                   Parm      *BLANKS       P@VL10                                  MD054017

      ** Handle Database Error

     C                   If        @RTCD <> *BLANKS                                      MD054017
     C                   Eval      DBASE = 43                                            MD054017
     C                   Eval      DBFILE = 'SDSVALPD'                                   MD054017
     C                   Eval      DBKEY = P@OP01                                        MD054017
     C                   Eval      DBPGM = 'AOSVALR0'                                    MD054017
     C                   EXSR      *PSSR                                                 MD054017
     C                   ELSE                                                            MD054017
     C                   EVAL      SYSVAL2 = P@VL01                                      MD054017
     C                   ENDIF                                                           MD054017
      *
      * LOAD CURRENCY ARRAYS & COUNTRY ARRAYS
     C                   SETOFF                                       96
     C                   EXSR      CCYARS
     C     *IN96         IFEQ      '1'                                          ************
     C                   SETON                                        U7U899    * DBERR  7 *
     C                   Z-ADD     7             DBASE                          ************
     C                   MOVEL     'SR.CCYAR'    XERROR            9
     C                   MOVE      'S'           XERROR
     C                   MOVEL     XERROR        DBKEY
     C                   MOVE      'SDCURRL0'    DBFILE
     C                   GOTO      END
     C                   END
      *
     C                   SETOFF                                       96
     C                   EXSR      CRYARS
     C     *IN96         IFEQ      '1'
     C                   SETON                                        U7U899    * DBERR  8 *
     C                   Z-ADD     8             DBASE
     C                   MOVEL     'SR.CRYAR'    XERROR            9
     C                   MOVE      'S'           XERROR
     C                   MOVEL     XERROR        DBKEY
     C                   MOVE      'SDCTRYPD'    DBFILE
     C                   GOTO      END
     C                   END
      *
      * DETERMINE BASE CURRENCY DETAILS
     C                   MOVE      BCCY          XCCY              3
     C                   EXSR      CCYDSP
     C     *IN99         IFEQ      '1'
     C                   SETON                                        U7U8      * DBERR  9 *
     C                   Z-ADD     9             DBASE
     C                   MOVE      XCCY          DBKEY
     C                   MOVE      'SDCURRL0'    DBFILE
     C                   GOTO      END
     C                   END
      *
     C                   Z-ADD     XDECP         BCCYDP            1 0          DEC.PLACES
      *
      * DETERMINE LIMITS CURRENCY DETAILS
     C  N27              MOVE      BCYL          XCCY
      *
      * IF LIMITS CCY BLANK USE BASE CCY
     C   27              MOVE      BCCY          XCCY
      *
     C                   EXSR      CCYDSP
     C     *IN99         IFEQ      '1'
     C                   SETON                                        U7U8      * DBERR 10 *
     C                   Z-ADD     10            DBASE
     C                   MOVE      XCCY          DBKEY
     C                   MOVE      'SDCURRL0'    DBFILE
     C                   GOTO      END
     C                   END
      *
     C                   Z-ADD     XDECP         LCCYDP            1 0          DEC.PLACES
      *
      * DEFINE STANDARD FIELDS
     C                   Z-ADD     0             FACL              5 0
     C                   Z-ADD     0             ZERO05            5 0
     C                   Z-ADD     0             ZERO13           13 0
     C                   MOVE      ' '           BLK28            28
     C                   MOVE      ' '           BLK38            38
     C                   MOVE      *OFF          *IN60
      *
      * DEFINE KLISTD
     C     AKEY          KLIST
     C                   KFLD                    INLOAN
     C                   KFLD                    KTYP
      *
     C     LMSKEY        KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    RUND
     C                   KFLD                    LMS2              3 0
      *
     C     LEKEY         KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    RUND
      *
     C     KEY001        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    FCKEY1            5 0
     C                   KFLD                    LNRF
      *
      * Keylist for read of Fees History File - LF/LEFHSTL1
     C     KEY002        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    FACL
     C                   KFLD                    LNRF
     C                   KFLD                    HIFSEQ
      *
      * Keys for history and loan files
     C     KEYH          KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    LNRF
      *
     C     KEYHH         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    LNRF
     C                   KFLD                    KSDAT             5 0
     C     KEYH26        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    LNRF
     C                   KFLD                    KSDAT             5 0
     C                   KFLD                    PRS26             2 0
      *
     C     KEYLL         KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    KSDAT
      *
     C                   MOVE      *BLANK        WEXIT             1
      *
     C                   Z-ADD     0             LMS2
      *
      ********************************
      * Start of record processing **
      ********************************
      * Read 'A' record
     C                   MOVE      'A'           KTYP              1
     C     AKEY          CHAIN     CLOAN                              55
     C     *IN55         IFEQ      '1'
     C     RECI          OREQ      'D'
     C     RCDT          ANDNE     'A'
     C     RECI          OREQ      'M'
     C     RCDT          ANDNE     'A'
     C                   SETON                                        U7U8      * DBERR 11 *
     C                   Z-ADD     11            DBASE
     C                   MOVEL     LNRF          DBKEY
     C                   MOVE      'CLOANCL '    DBFILE
     C                   GOTO      END
     C                   ELSE
     C                   MOVE      BRTT          BRTTPH            2 0
      *
     C     PTFR          IFNE      *BLANKS                                      - B2
     C     BGPFMG        ANDEQ     'Y'
     C                   MOVE      '1'           *IN64
     C                   ELSE                                                   - X2
     C                   MOVE      '0'           *IN64
     C                   END                                                    - E2
     C                   END                                                    - E1
      *
     C                   Z-ADD     PREM          ANNPR
     C                   Z-ADD     0             JTAIN            13 0
     C     AITC          ADD       AIAP          JTAIN
     C                   ADD       AIMN          JTAIN
     C                   SUB       IPRD          JTAIN
     C                   SUB       ICTD          JTAIN
     C                   SUB       IWOD          JTAIN
      *
      * Ignore guarantee loans & participations
     C     PTYP          IFNE      61
     C     PTYP          ANDNE     62
     C     PTYP          ANDNE     63
     C                   MOVE      *OFF          *IN60
     C                   GOTO      END
     C                   END
      *
      * Maturity date, etc. checks
     C     MDAT          IFEQ      0
     C                   MOVE      '1'           *IN21
     C                   ELSE
     C                   MOVE      '0'           *IN21
     C                   END
     C     NRPD          IFEQ      0
     C                   MOVE      '1'           *IN24
     C                   ELSE
     C                   MOVE      '0'           *IN24
     C                   END
     C     RLDT          IFEQ      0
     C                   MOVE      '1'           *IN25
     C                   ELSE
     C                   MOVE      '0'           *IN25
     C                   END
     C     NIDT          IFEQ      0
     C                   MOVE      '1'           *IN26
     C                   ELSE
     C                   MOVE      '0'           *IN26
     C                   END
     C*
     C                   SETOFF                                       66
     C                   SETOFF                                       77
      ****************************************************************
      *  For each loan detail 1 record
      *      If the originating branch used indicator is 'Y' access
      *      the company of originating branch for the originating
      *      branch on the detail record otherwise set the company of
      *      originating branch to blank.
      ****************************************************************
      *
     C     BKOBRU        IFEQ      'Y'
      *
      * Access the branch information for the originating branch
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      ORBR          @DSNB             3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @DSNB         DBKEY                          ***************
     C                   MOVEL     'SDBRCHPD'    DBFILE                         * DBERROR 12  *
     C                   Z-ADD     12            DBASE                          ***************
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   END
      *
     C                   END
      *
      * Read 'B' record
     C                   MOVE      'B'           KTYP
     C     AKEY          CHAIN     CLOAN                              55
      *
      * Skip if no 'B' record or if it has been reversed
     C     *IN55         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   MOVE      '0'           *IN60
     C                   GOTO      END
     C                   END
     C     RECI          IFNE      'D'
     C     RCDT          ORNE      'B'
     C                   SETON                                        U7U8      * DBERR 13 *
     C                   Z-ADD     13            DBASE
     C                   MOVEL     LNRF          DBKEY
     C                   MOVE      'CLOANCK '    DBFILE
     C                   GOTO      END
     C                   END
      *
      **********************************
      *   REQUIRED 'B' RECORD PROCESSING - SET UP LOAN DETAILS
      *   IF MAT. DATE = 0(CALL LOAN),SET TO RUN DATE + 15 WORKING DAY S
      *   If Citydealer Non-front Office Cashflows interface is
      *   installed (CCM002), then forward maturity date should be set
      *   to Date of Next Working Day plus number of billing days.
      **********************************
      *
     C     WCITYD        IFEQ      'Y'
      *
     C     BLDY          IFEQ      0
     C                   Z-ADD     1             BLDY
     C                   END
      *
     C     *IN21         IFEQ      '1'
     C                   Z-ADD     BLDY          ZNRDYS
     C                   Z-ADD     DNWD          ZDAYNO
     C                   END
      *
     C                   ELSE
     C   21              Z-ADD     15            ZNRDYS
     C   21              Z-ADD     RUND          ZDAYNO
     C                   END
      *
     C   21              MOVE      CCY           ZCCY
     C   21
     CANN77              EXSR      MATLOC
     C   21              MOVE      W@MDSL        ZLOC
     C   21              EXSR      ZFWDT
      *
      * IF DEMAND LOAN & NO MATURITY DATE, SET TO NEXT INTEREST
      * PAYMENT DATE
     C     PTYP          IFEQ      61
     C     *IN21         ANDEQ     *ON
     C     NIDT          ANDNE     0
     C                   Z-ADD     NIDT          ZDYNBR
     C                   END
      *
      * IF LOAN VALUE DATE DOES NOT LIE WITHIN THIS PERIOD - BYPASS
     C   21VDAT          COMP      ZDYNBR                             41  41
     C   21
     CAN 41              GOTO      END
      *
      * SAVE THIS NOMINAL MATURITY DATE FOR FUTURE USE
     C   21              Z-ADD     ZDYNBR        MATDAT            5 0
      *
      * ACCESS LOAN CURRENCY DETAILS
     C                   MOVE      CCY           XCCY
     C                   EXSR      CCYDSP
     C     *IN99         IFEQ      '1'
     C                   SETON                                        U7U8      * DBERR 14 *
     C                   Z-ADD     14            DBASE
     C                   MOVE      XCCY          DBKEY
     C                   MOVE      'SDCURRL0'    DBFILE
     C                   GOTO      END
     C                   END
      *
     C                   Z-ADD     XDECP         ECCYDP            1 0          DEC.PLACES
     C                   Z-ADD     XSPOT         ECCYSP           13 8          SPOT RATE-BASE
     C                   MOVE      XMDIN         ECCYMD            1            MULT/DIV
     C                   Z-ADD     XSPLM         ECCYSL           13 8          SPOT RATE-LIMIT
      *
      * DETERMINE REGION OF RISK
     C                   MOVE      CRSK          XCRY              2
     C                   EXSR      CRYDET
     C     *IN99         IFEQ      '1'
     C                   SETON                                        U7U8      * DBERR 15 *
     C                   Z-ADD     15            DBASE
     C                   MOVE      XCRY          DBKEY
     C                   MOVE      'SDCTRYPD'    DBFILE
     C                   GOTO      END
     C                   END
      *
      * DETERMINE CUSTOMER DETAILS
     C                   MOVEL     CNUM          CUSKEY           10
     C                   EXSR      SRCUSC
     C     *IN55         IFEQ      '1'
     C                   SETON                                        U7U8      * DBERR 16 *
     C                   Z-ADD     16            DBASE
     C                   GOTO      END
     C                   END
      *
     C                   MOVE      CNUM          CUSNUM            6 0
     C                   MOVE      BBPCNB        CPAR              6 0
      *
      * DETERMINE REGION OF DOMICILE
     C                   MOVE      CLOC          XCRY
     C                   EXSR      CRYDET
     C     *IN99         IFEQ      '1'
     C                   SETON                                        U7U8      * DBERR 18 *
     C                   Z-ADD     18            DBASE
     C                   MOVE      XCRY          DBKEY
     C                   MOVE      'SDCTRYPD'    DBFILE
     C                   GOTO      END
     C                   END
      *
      * DETERMINE PARENT DETAILS
     C     CPAR          COMP      0                                  41
     C   41              MOVEL     CPAR          CUSKEY
     C   41              EXSR      SRCUSC
     C   41
     CAN 55              SETON                                        U7U8      * DBERR 19 *
     C   41
     CAN 55              Z-ADD     19            DBASE
     C   41
     CAN 55              GOTO      END
      *
      * ACCESS THE BRANCH INFORMATION FOR BOOKING BRANCH
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BRCA          @DSNB             3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @DSNB         DBKEY                          ***************
     C                   MOVEL     'SDBRCHPD'    DBFILE                         * DBERROR 20  *
     C                   Z-ADD     20            DBASE                          ***************
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   END
      *
     C                   MOVE      CMPYM         BCMPY             3
     C                   MOVE      BICN          BBICN             6
      *
      * Store the company of the booking branch for output
      * to the lending event file
      * INITIALIZE WORK FIELDS FOR THIS LOAN
     C     AITC          ADD       AIAP          TACINT           13 0          TOT.ACC.INT
     C     TACINT        ADD       AIMN          TACINT
      *
     C                   Z-ADD     CPAM          CPRINC           13 0          CURRENT PRINC.
      *
     C     IPRD          ADD       ICTD          INTPPR           13 0          INT.PD.PRIOR
     C     INTPPR        ADD       IWOD          INTPPR
      *
     C                   Z-ADD     0             INTPD            13 0          INT.PD.THIS RUN
      *
     C                   Z-ADD     BRTELA        BRATE            11 7          BASE RATE
      *
     C                   Z-ADD     RTSP          SPRATE           11 7          SPREAD/RATE
      *
     C                   MOVE      SPIN          SPRIND            1            SPREAD IND.
      *
     C                   Z-ADD     ICBS          INTBAS            1 0          CALC. BASIS
      *
     C                   Z-ADD     INTR          EFFINT           11 7          EFFECTIVE INT.
      *
     C                   Z-ADD     IBDT          INTBD             5 0          INT.BASE DATE
      *
     C                   Z-ADD     RBDT          REPBD             5 0          REP.BASE DATE
      *
     C                   Z-ADD     IACD          LSTEVD            5 0          LAST EVENT DATE
      *
      * DETERMINE REPAYMENT TYPE
     C     REPT          COMP      2                                  535152
      *
      * DETERMINE IF INTEREST TO BE CAPITALIZED
     C     INTC          COMP      'Y'                                    54
      *
      * DETERMINE IF STOP ACCRUALS ON
     C                   MOVE      *BLANK        WSTAC             1
     C                   MOVE      *BLANK        WSUBT             1
      *
      * Calculate interest to todays date, except when stop accruals
      * indicator is on, or loan has not yet started
     C                   TESTB     '3'           LONI                     59
     C     *IN59         IFEQ      '1'
     C                   MOVE      'Y'           WSTAC
     C                   ENDIF
     C     WSTAC         IFEQ      *BLANK
     C     VDAT          ANDLE     RUND
      *
      * If loan has gone past due, add PDIN, AIAP and AIMN to get
      * INOUTX amount.  Skip calculation of interest from IACD to MDAT
     C     RECI          IFEQ      'D'
     C     MDAT          ANDLT     IACD
     C     MDAT          ANDNE     *ZEROS
     C     AIAP          ADD       AIMN          INOUTX
     C     PDIN          ADD       INOUTX        INOUTX
     C                   MOVE      'Y'           WSUBT
     C                   ENDIF
      *
      * Calculate interest when outstanding principal not negative
     C                   Z-ADD     IACD          WLICD             5 0
     C                   Z-ADD     0             ZINTR
     C     CPAM          IFGE      *ZEROS
     C     MDAT          IFEQ      *ZEROS
     C     MDAT          ORNE      *ZEROS
     C     RUND          ANDLT     MDAT
     C                   MOVE      RUND          ZIEND
     C                   ELSE
     C                   MOVE      MDAT          ZIEND
     C                   ENDIF
      *
      * Adjust end date according to 'additional day indicator'
     C                   Z-ADD     MDAT          ZMDAT
     C                   EXSR      ZFLDC
     C                   Z-ADD     MDAT          ZMDAT
     C                   EXSR      ZFLAC
     C                   Z-ADD     CPAM          WCUPR
     C                   Z-ADD     INTR          WCURT
     C                   EXSR      SRINCL
     C                   ENDIF
      *
      * Calculate interest outstanding
     C     ZINTR         ADD(H)    AITC          INOUTX           13 0
     C                   ADD       AIAP          INOUTX
     C                   ADD       AIMN          INOUTX
     C                   MOVE      'Y'           WSUBT
     C                   ENDIF
      *
     C     WSUBT         IFEQ      *BLANK
     C     AITC          ADD       AIAP          INOUTX
     C                   ADD       AIMN          INOUTX
     C                   ENDIF
      *
     C                   SUB       IWOD          INOUTX
     C                   SUB       IPRD          INOUTX
     C                   SUB       ICTD          INOUTX
      *
      * Get currency decimal places
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      CCY           K101              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVE      CCY           DBKEY                          * DBERR 02 *
     C                   Z-ADD     2             DBASE                          ************
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Check for capitalisation
     C     INTC          IFEQ      'Y'
     C                   MOVE      'YES'         SCAPI             3
     C                   ELSE
     C                   MOVE      ' NO'         SCAPI
     C                   ENDIF
      *
      * Determine nostro location for next date calculation
     C                   MOVE      *BLANKS       WNLOC
     C     MDST          IFEQ      01
     C     MDST          OREQ      02
     C     MDST          OREQ      07
     C     MDST          OREQ      08
     C     MDST          OREQ      12
     C                   MOVE      CCY           @KEYB
     C     SCCY          IFNE      *BLANK
     C                   MOVE      SCCY          @KEYB
     C                   ENDIF
     C                   MOVEL     OMDA          @KEYE
     C                   CALL      'AONOSTR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM                    @KEYB             3
     C                   PARM      *BLANKS       @KEYC             4
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM                    @KEYE             2
     C                   PARM      *BLANKS       @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      CSNM          WNLOC             2
     C                   ELSE
     C                   MOVEL     @KEYB         WK5               5
     C                   MOVE      @KEYE         WK5
     C                   MOVE      'SDCUSTPD'    DBFILE                         ************
     C                   MOVEL     WK5           DBKEY                          * DBERR 04 *
     C                   Z-ADD     4             DBASE                          ************
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      * Initialise work fields
     C                   MOVE      *BLANKS       WCDIN             1
     C                   MOVE      *BLANKS       WFRPR             1
     C                   MOVE      *BLANKS       WFRIN             1
     C                   MOVE      *BLANKS       WRPR1             1
     C                   MOVE      *BLANKS       WRIN1             1
     C                   MOVE      SPIN          WCUSI             1
     C                   Z-ADD     RTSP          WCUSP            11 7
     C                   Z-ADD     BRTE          WCUBR            11 7
      *
      * Determine values needed for frequency repayments
     C                   Z-ADD     NIDT          WNIDT             5 0
     C                   Z-ADD     NRPD          WNRPD             5 0
     C                   SELECT
     C     RLDT          WHENNE    *ZEROS
     C                   Z-ADD     RLDT          WENDT             5 0
     C     MDAT          WHENNE    *ZEROS
     C                   Z-ADD     MDAT          WENDT
     C                   OTHER
     C                   Z-ADD     *ZEROS        WENDT
     C                   ENDSL
      *
      * Process history and loan amendments up to today
     C                   EXSR      SRPROC
      *
      * Process fee history
     C                   EXSR      FEEHIS
      *
      * SET LOWER LIMITS TO FIND FIRST(IF ANY) LOAN AMENDMENT
     C     LMSKEY        SETLL     LOAMS
      *
     C                   EXSR      SRREAD
      *
      * PROCESS PAST DUE EVENTS
     C  N56AMTPLA        COMP      'PD'                                   41
     C  N56
     CAN 41              EXSR      PSTDUE
      *
      * IF NEXT ROLLOVER DATE IS ZERO, SET UP A COMPARISON
      * VALUE
     C     RLDT          IFEQ      0
     C     RUND          ADD       30            CKDAT2            5 0
     C                   ELSE
     C                   Z-ADD     RLDT          CKDAT2
     C                   END
      *
      * EVENTS PROCESSING REQUIRED - INITIALIZE DATES FOR SELECTION
     C   21              Z-ADD     MATDAT        VMATUR            5 0
     C  N21
     CANN10              Z-ADD     MDAT          VMATUR                         MATURITY DATE
     C     *IN10         IFEQ      '1'
     C     RLDT          IFEQ      MDAT
     C     NMDT          ANDNE     0
     C                   Z-ADD     NMDT          VMATUR
     C                   ELSE
     C     MDAT          IFNE      0
     C                   Z-ADD     MDAT          VMATUR
     C                   END
     C                   END
     C                   END
      *
      * Next annual premium date
     C     ANNPR         IFEQ      0
     C                   Z-ADD     99999         VAPREM            5 0          EVENT NOT REQD.
     C                   ELSE
     C                   Z-ADD     VDAT          ZINDT             5 0          START DATE
     C                   Z-ADD     1             ZNYR              2 0          ADD 1 YEAR
     C                   Z-ADD     0             ZNMN              2 0
     C                   Z-ADD     0             ZNDY              2 0
     C                   EXSR      ZCPD
     C                   Z-ADD     ZPDNO         VAPREM                         ANNUAL PREMIUM
     C     VAPREM        SUB       KSDAT         VADAYS            5 0
     C                   END
      *
     C   56              Z-ADD     99999         VAMEND            5 0          EVENT NOT REQD.
     C  N56              Z-ADD     VDATLA        VAMEND                         AMEND DATE
      *
     C   26              Z-ADD     99999         VINTR             5 0          EVENT NOT REQD.
     C  N26              Z-ADD     NIDT          VINTR                          INTEREST DATE
      *
     C   24              Z-ADD     99999         VREPAY            5 0          EVENT NOT REQD.
     C  N24              Z-ADD     NRPD          VREPAY                         REPAYMENT DATE
      *
     C   25              Z-ADD     99999         VROLLR            5 0          EVENT NOT REQD.
     C  N25              Z-ADD     RLDT          VROLLR                         ROLLOVER DATE
      *
      * DETERMINE DISCOUNTED LOANS AND SET ROLLOVER DATE.
     C     *IN21         IFNE      '1'
     C     PTYP          ANDEQ     63
     C     NROD          ANDNE     0
     C                   Z-ADD     NROD          VMATUR
     C                   SETON                                        66
     C                   END
      *
      *  Generate events to rolover date not maturity if rollover date exists
     C     RLDT          IFNE      0
     C                   Z-ADD     RLDT          VMATUR
     C                   END
      *
      * GENERATE EVENTS IN CHRONOLOGICAL ORDER.IF TWO OR MORE DATES
      * MATCH,THEN THE ORDER IS:
      * START,AMENDMENT,INTEREST,REPAYMENT,ROLLOVER,ANL.PM,MATURITY.
      * START DATE - only if no history processed
     C     *IN28         IFEQ      '0'
     C                   EXSR      START
     C   U7              GOTO      END
     C                   END
      *
     C     SELECT        TAG                                                    **SELECT TAG**
      *
      * LOAN AMENDMENT DATE
     C     VAMEND        COMP      VINTR                                4141
     C   41VAMEND        COMP      VREPAY                               4141
     C   41VAMEND        COMP      VROLLR                               4141
     C   41VAMEND        COMP      VAPREM                               4141
      *
      * IF EVENT WITH A PORTFOLIO REF. FORCE TEST WITH MATURITY DATE
     C     *IN64         IFEQ      '1'
     C   41VAMEND        COMP      VMATUR                               4141
     C                   ELSE
     C   41VAMEND        COMP      VMATUR                               4141
     C                   END
     C   41              EXSR      AMEND
     C   41
     CAN U7              GOTO      END
     C   41              GOTO      SELECT
      *
      * INTEREST DATE
     C     VINTR         COMP      VREPAY                               4141
     C   41VINTR         COMP      VROLLR                               4141
     C   41VINTR         COMP      VAPREM                               4141
      *
      * IF EVENT WITH A PORTFOLIO REF. FORCE TEST WITH MATURITY DATE
     C     *IN64         IFEQ      '1'
     C   41VINTR         COMP      VMATUR                               4141
     C                   ELSE
     C   41VINTR         COMP      VMATUR                               4141
     C                   END
     C   41              EXSR      INTRST
     C   41
     CAN U7              GOTO      END
     C   41              GOTO      SELECT
      *
      * REPAYMENT DATE
     C     VREPAY        COMP      VROLLR                               4141
     C   41VREPAY        COMP      VAPREM                               4141
      *
      * IF EVENT WITH A PORTFOLIO REF. FORCE TEST WITH MATURITY DATE
     C     *IN64         IFEQ      '1'
     C   41VREPAY        COMP      VMATUR                               4141
     C                   ELSE
     C   41VREPAY        COMP      VMATUR                               4141
     C                   END
      *
     C   41              EXSR      REPAY
     C   41
     CAN U7              GOTO      END
     C   41              GOTO      SELECT
      *
      * ROLLOVER DATE
     C     VROLLR        COMP      VMATUR                               4141
     C   41VROLLR        COMP      VAPREM                               4141
      *
      * IF EVENT WITH A PORTFOLIO REF. FORCE TEST WITH MATURITY DATE
     C     *IN64         IFEQ      '1'
     C     VROLLR        COMP      VMATUR                               4141
     C                   ELSE
     C     VROLLR        COMP      VMATUR                               4141
     C                   END
      *
     C   41              EXSR      ROLLVR
     C   41
     CAN U7              GOTO      END
     C   41              GOTO      SELECT
      *
      * ANNUAL PREMIUM DATE - only LT maturity date
     C     VAPREM        COMP      VMATUR                               41
      *
     C   41              EXSR      ANNPRM
     C   41
     CAN U7              GOTO      END
     C   41              GOTO      SELECT
      *
      * MATURITY DATE
     C                   EXSR      MATUR
      *
      * FEES
     C                   EXSR      PROCES
      *
     C     END           TAG                                                    **END TAG**
      *
      *  When all data written to GLAPRCTD, call GL000050 to get the rate
      *  Only call GL000050 if records have been written to GLAPRCTD.
     C     *IN60         IFEQ      *ON
     C                   CLOSE     GLAPRCTD
      *
      * Set day number basis
     C     ICBS          IFEQ      1
     C     ICBS          OREQ      4
     C                   MOVE      '365'         AEDNB
     C                   END
     C     ICBS          IFEQ      2
     C     ICBS          OREQ      3
     C     ICBS          OREQ      5
     C     ICBS          OREQ      7
     C                   MOVE      '360'         AEDNB
     C                   END
     C     ICBS          IFEQ      6
     C                   MOVE      '366'         AEDNB
     C                   END
      *
     C                   EVAL      AERATE = *BLANKS                                      MD054017
     C                   IF        SYSVAL1 = 'Y' AND SYSVAL2 <> *BLANKS                  MD054017
     C                   EVAL      SYSVAL2A = *BLANKS                                    MD054017
     C                   EVAL      SYSVAL2A = %XLATE(LO:UP:SYSVAL2)                      MD054017
     C                   IF        SYSVAL2A = 'SPAIN'                                    MD054017
      *                                                                                  MD054017
     C                   CALL      'GL000050'
     C                   PARM      *BLANKS       AERATE            6
     C                   PARM                    AEDNB             3
     C                   ENDIF                                                           MD054017
     C                   ENDIF                                                           MD054017
      *
     C                   MOVEL     AERATE        AERATM            1
     C                   MOVE      AERATE        AERATF            5 0
     C     AERATM        IFEQ      '-'                                          -ve rate
     C                   Z-SUB     AERATF        AERATN
     C                   ELSE
     C                   MOVE      AERATE        AERATN            6 0
     C                   END
     C     AERATN        DIV       100           NAERAT            6 2
      *
      * Only write new rate if different to last or no last exists
      * Access rates history file
     C     LEKEY         SETLL     LEAPRHI0
     C                   READ      LEAPRHI0                               55
     C     *IN55         IFEQ      '1'                                          not found
     C     *IN55         OREQ      '0'                                          same loan &
     C     LNRF          ANDEQ     ILLNO                                        date
     C     RUND          ANDEQ     IAPRD                                        different
     C     NAERAT        ANDNE     IAPRR                                        rate
     C     *IN55         OREQ      '0'
     C     LNRF          ANDEQ     ILLNO
     C     RUND          ANDNE     IAPRD
     C     *IN55         OREQ      '0'
     C     LNRF          ANDNE     ILLNO
      *
      * Add sequence number
     C     *IN55         IFEQ      '1'
     C     LNRF          ORNE      ILLNO
     C     RUND          ORNE      IAPRD
     C                   Z-ADD     1             ITSEQ
     C                   ELSE
     C                   ADD       1             ITSEQ
     C                   END
      *
      * Write new rate
     C                   MOVE      LNRF          ILLNO
     C                   Z-ADD     RUND          IAPRD
     C                   Z-ADD     NAERAT        IAPRR
     C                   WRITE     LEAPRHD1
     C                   END
      *
     C                   END
      *
     C                   SETON                                        LR
     C   U7              MOVE      '*ERROR '     ERRCOD
      *
      * LAST RECORD PROCESSING
      * EXECUTE ERROR ROUTINE IF DATABASE ERROR EXISTS
     C     *INU7         IFEQ      '1'
     C     *INU8         ANDEQ     '1'
     C                   EXSR      *PSSR
     C                   END
      ********************************************************************
      /SPACE 3
      ********************************************************************
      * SRREAD - FIND NEXT LIVE LOAN AMENDMENT FOR GIVEN LOAN
      *
      * Called by: Main Processing, SR.AMEND
      * Calls    :
      ********************************************************************
      *
     C     SRREAD        BEGSR                                                  **READ**
      *
     C     FILRD         TAG                                                    **FILRD TAG**
      *
     C                   SETOFF                                       56
     C                   READ      LOAMS                                  56
     C  N56LNRFLA        COMP      LNRF                               56
     C  N56RECI          COMP      'D'                                    83
     C  N56
     CANN83              GOTO      FILRD
      *
     C                   ENDSR
      *
      ********************************************************************
      * SRCUSC - ACCESS S/CLINT RECORD 'A'
      *
      * Called by: Main Processing
      * Calls    :
      ********************************************************************
      *
     C     SRCUSC        BEGSR                                                  **SRCUSC**
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    CUSKEY
     C                   PARM                    KEYSTS            7
     C     SDCUST        PARM      SDCUST        DSSDY
     C     @RTCD         COMP      *BLANKS                            5555
      *
      * SET UP DATABASE DETAILS IF RECORD NOT FOUND
     C   55              MOVE      CUSKEY        DBKEY
     C   55              MOVE      'SDCUSTPD'    DBFILE
      *
     C                   ENDSR
      ********************************************************************
      * SRBRTD - ACCESS SDBSRTPD - BASE RATE DETAILS
      *
      * Called by: SR's AMEND,ROLLVR
      * Calls    :
      ********************************************************************
      *
     C     SRBRTD        BEGSR                                                  **SRBRTD**
      *
     C                   MOVEL     BRTKEY        BKEY2
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CCY           BKEY1             3
     C                   PARM                    BKEY2             2
     C     SDBSRT        PARM      SDBSRT        DSFDY
     C     @RTCD         COMP      *BLANKS                            5555
      *
      * SET UP DATABASE DETAILS IF RECORD NOT FOUND
     C   55              MOVE      BKEY2         DBKEY
     C   55              MOVEL     CCY           DBKEY
     C   55              MOVEL     'SDBSRTPD'    DBFILE
      *
     C                   ENDSR
      ********************************************************************
      * SRXCON - Convert an amount from one currency to another
      *
      * Called by: SR.EQUIV
      * Calls    :
      ********************************************************************
      *
     C     SRXCON        BEGSR                                                  **SRXCON**
      *
      * FIELD Z CHANGED TO W DUE TO THE FIELD Z BEING USED IN THE
      * HOLIDAY SUBROUTINE ZACCH
      *
     C     XDP2          SUB       XDP1          W                 1 0
     C     W             ADD       4             W
      *
     C  N80XMDIV         COMP      'D'                                    80
      *
     C   80POWER(W)      DIV       XSPOT         XEFFRT           15 9
     C  N80POWER(W)      MULT      XSPOT         XEFFRT
      *
     C     XAMNT1        MULT(H)   XEFFRT        XAMNT2           13 0
      *
     C                   ENDSR
      *
     C********************************************************************
      * SREQUI - DETERMINE EQUIVALENT AMOUNTS OF EVENT AMOUNT
      *
      * Called by: SR.PSTDUE,START,AMEND,INTRST,REPAY,MATUR
      * Calls    : SR.SRXCON
     C********************************************************************
      *
     C     SREQUI        BEGSR                                                  **SREQUI**
      *
      *    CONVERT AMOUNT TO 'DEALT BASE EQUIV.'
     C                   Z-ADD     EVAMNT        XAMNT1           13 0
     C                   Z-ADD     BCXR          XSPOT            13 8
     C                   MOVE      BMDI          XMDIV             1
     C                   Z-ADD     ECCYDP        XDP1              1 0
     C                   Z-ADD     BCCYDP        XDP2              1 0
     C                   EXSR      SRXCON
      *
      * CONVERT AMOUNT TO 'SPOT BASE EQUIV.'
     C                   Z-ADD     ECCYSP        XSPOT
     C                   MOVE      ECCYMD        XMDIV
     C                   EXSR      SRXCON
      *
      * CONVERT AMOUNT TO 'SPOT LIMITS EQUIV.'
     C                   Z-ADD     ECCYSL        XSPOT
     C                   Z-ADD     LCCYDP        XDP2
     C                   EXSR      SRXCON
      *
     C                   ENDSR
      *
      ********************************************************************
      * RECOU - OUTPUT EVENT RECORD TO FILE GLAPRCTD
      *
      * Called by: SR's PSTDUE,START,AMEND,INTRST,REPAY,ROLLVR,MATUR
      * Calls    :
      ********************************************************************
      *
     C     RECOUT        BEGSR                                                  **RECOUT**
      *
      * IF NOT IN ACCUMULATION MODE
     C     *IN29         IFEQ      *OFF
      *
      * REVERSE VALUE OF IN/OUT IND. IF EVENT AMOUNT NEGATIVE
     C     EVAMNT        IFLT      0
     C     INOUT         COMP      'I'                                    81
     C     INOUT         COMP      'O'                                    83
     C   81              MOVE      'O'           INOUT             1
     C   83              MOVE      'I'           INOUT
     C                   Z-SUB     EVAMNT        EVAMNT                         143401
     C                   END
      *
      * OUTPUT RECORD TO FILE GLAPRCTD IF 'INOUT' NOT BLANK and
      * THE AMOUNT IS NOT ZERO
     C     INOUT         IFNE      ' '
     C     EVAMNT        ANDNE     0
      * OPEN THE FILE IF *IN60 IS OFF
     C     *IN60         IFEQ      *OFF
     C                   OPEN      GLAPRCTD
     C                   END
     C                   MOVE      INOUT         APRTYP
     C                   MOVE      EVAMNT        APRAMT
     C                   WRITE     GLAPRCD0
     C                   MOVE      '1'           *IN60
     C                   MOVE      '1'           *IN28
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *
      ********************************************************************
      * LEVENT - DETERMINE S/LVNTX SETTINGS DEPENDENT UPON PROCESSING
      *          TYPE - 'OTHER DATE','OTHER AMOUNT',INSTRUCTIONS &
      *          'INCOMING/OUTGOING INDICATOR'
      *
      * Called by: SR's PSTDUE,START,AMEND,INTRST,REPAY,ROLLVR,MATUR
      * Calls    :
      ********************************************************************
      *
     C     LEVENT        BEGSR                                                  **LEVENT**
      *
     C     EVCODE        LOOKUP    TAB1          TAB2                     57
     C  N57              GOTO      LEVEND
     C                   MOVE      TAB2          KEYDS
      *
      * DETERMINE 'OTHER DATE'
     C                   MOVE      DAT(ED)       EVODAT            5 0
      *
      * DETERMINE 'OTHER AMOUNT'
     C                   MOVE      AMT(EA)       EVOAMT           13 0
      *
      * DETERMINE FULL INSTRUCTIONS INDICATOR DEPENDING ON SETTING O   F
      * INSTRUCTIONS INDICATOR
      * NB.IF SETTING = '4',THEN RE-SET TO '3' IF EVENT IS SOURCED F   ROM
      * LOAN AMENDMENT,OTHERWISE RE-SET TO '2'
     C     INSIND        COMP      4                                      83
     C   83
     CAN 50              Z-ADD     3             INSIND
     C   83
     CANN50              Z-ADD     2             INSIND
      *
      * PROCESSING AS PER LEP0480-AA
     C     INSIND        COMP      0                                      83
     C   83              MOVE      ' '           FININD            1            FULL INSTRNS.
     C   83              MOVEL     '00'          SETTLE
     C   83              MOVE      BLK28         SETTLE           30            SETT. INSTRNS.
     C   83              MOVE      *BLANKS       STLBR             3            SETT. BRCH  S.
     C   83              GOTO      LEVEND
      *
     C     INSIND        COMP      5                                      86
     C  N86INSIND        COMP      2                                  858384
      *
     C   83              MOVE      STARTS        SETTLE                         START
     C   84              MOVE      MATURS        SETTLE                         MATURITY
     C   85              MOVE      AMENDS        SETTLE                         AMENDMENT
     C   86              MOVE      ROLLOS        SETTLE                         ROLLOVER
      *
     C   83              MOVE      OSDB          STLBR                          START
     C   84              MOVE      OMDB          STLBR                          MATURITY
     C   85              MOVE      OSBR          STLBR                          AMENDMENT
     C   86              MOVE      RLBR          STLBR                          ROLLOVER
      *
     C     STLBR         IFEQ      *BLANKS
     C                   MOVE      BRCA          STLBR
     C                   END
      *
      * ACCESS THE BRANCH INFORMATION OF THE SETTLEMENT BRANCH
      * IF THE BOOKING BRANCH <> SETTLEMENT BRANCH AND THE
      * SETLLMENT BRANCH IS NON-BLANK
     C     STLBR         IFNE      *BLANKS
     C     STLBR         ANDNE     BRCA
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      STLBR         @DSNB             3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @DSNB         DBKEY                          ***************
     C                   MOVEL     'SDBRCHPD'    DBFILE                         * DBERROR 21  *
     C                   Z-ADD     21            DBASE                          ***************
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   GOTO      LEVEND
     C                   END
      *
     C                   MOVE      CMPYM         SBCMPY            3
      *
     C                   END
      *
     C     SETTYP        COMP      0                                      83
      *
     C     SETTYP        COMP      1                                      84
     C  N84SETTYP        COMP      7                                      84
     C  N84SETTYP        COMP      8                                      84
     C   84SETAC         COMP      ' '                                    83
     C   84
     CANN83SETNOS        COMP      ' '                                    83
      *
     C     SETTYP        COMP      5                                      84
     C  N84SETTYP        COMP      14                                     84
     C  N84SETTYP        COMP      2                                      84
     C  N84SETTYP        COMP      12                                     84
     C   84SETAC         COMP      ' '                                    83
      *
     C     LEVEND        ENDSR                                                  ***LEVEND**
      *
      ********************************************************************
      * INTCAL - MAINTAIN ACCRUED INTEREST & TO DETERMINE IINTEREST DUE
      *
      * Called by: SR's PSTDUE,AMEND,INTRST,REPAY,ROLLVR,MATUR
      * Calls    : SR.GLINTC
      ********************************************************************
      *
     C     INTCAL        BEGSR                                                  **INTCAL**
      *
      * CALCULATE INTEREST FROM LAST EVENT DATE TO THIS VALUE DATE
      * IF PRINCIPAL LE. 0 OR STOP ACCRUALS ON, INTEREST NOT ACCRUED
     C                   Z-ADD     LSTEVD        ZIBEG
     C                   Z-ADD     EVDATE        ZIEND
     C     ADDI          IFEQ      'B'
     C     ZIBEG         ANDEQ     VDAT
     C     ZIEND         ADD       1             ZIEND
     C                   END
     C     ZIEND         SUB       KSDAT         TDAYS             5 0
     C                   Z-ADD     CPRINC        ZIAMT                83
     C                   Z-ADD     INTBAS        ZICALC
     C                   Z-ADD     EFFINT        ZIRATE
      *
     C   83
     CANN59              EXSR      GLINTC
      *
     C  N83
     COR 59              Z-ADD     0             ZINTR
      *
      *  CHECK FOR ROUND DOWN FACILITY.
     C     RDFC          IFEQ      'Y'
     C     TACINT        ADD       ZINTR         TACINT
     C                   ELSE
     C     TACINT        ADD(H)    ZINTR         TACINT
     C                   END
      *
      * DETERMINE INTEREST DUE
     C     TACINT        SUB       INTPPR        INTDUE           13 0
     C     INTDUE        SUB       INTPD         INTDUE
      *
      * IF INTEREST DUE HAS OPPOSITE SIGN TO INTEREST RATE,SET TO 0
     C     EFFINT        COMP      0                                  83
     C   83INTDUE        COMP      0                                    83
     C   83              Z-ADD     0             INTDUE
      *
     C     EFFINT        COMP      0                                    83
     C   83INTDUE        COMP      0                                  83
     C   83              Z-ADD     0             INTDUE
      *
      * UPDATE LAST EVENT DATE
     C                   Z-ADD     EVDATE        LSTEVD
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRINCL  -  Interest calculation                               *
      * Called by: SRLOAN - Set up loan header details                *
      *            SRHIST - Process history records                   *
      *            SRLOAM - Process loan amendment records            *
      *            SRRPAY - Process frequency repayments              *
      * Calls    : None                                               *
      *****************************************************************
      *
     C     SRINCL        BEGSR
      *
      * Do not compute for interest if not greater than 0
     C     WCURT         IFLE      *ZEROS
     C                   Z-ADD     *ZEROS        ZINTR
     C                   ELSE
      *
     C                   Z-ADD     WLICD         ZIBEG
     C                   MOVE      ICBS          ZICALC
     C                   Z-ADD     WCUPR         ZIAMT
     C                   Z-ADD     WCURT         ZIRATE
      *
     C                   EXSR      GLINTC
      *
      * Round down interest if required
     C     RDFC          IFEQ      'Y'
     C                   Z-ADD     ZINTR         RDWORK           13 0
     C                   Z-ADD     RDWORK        ZINTR
     C                   ENDIF
     C                   Z-ADD     ZIEND         WLICD
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRINVR  -  Initialise variables on display of first screen    *
      * Called by: SRPROC - Process enquiry request                   *
      * Calls    : None                                               *
      *****************************************************************
      *
     C     SRINVR        BEGSR
      *
      * Initialise work fields
     C                   MOVE      '0'           *IN28
     C                   MOVE      '0'           *IN31
     C                   MOVE      'Y'           WINIT             1
     C                   Z-ADD     *ZEROS        WLASD             5 0
     C                   Z-ADD     *ZEROS        WSVBL            13 0
     C                   Z-ADD     *ZEROS        WCURT            11 7
     C                   Z-ADD     *ZEROS        WCUPR            13 0
     C                   Z-ADD     *ZEROS        WINCA            13 0
     C                   Z-ADD     *ZEROS        WINPD            13 0
     C                   MOVE      *BLANK        WSVDT             7
     C                   MOVE      *BLANK        WSUBR             1
      *
      * Initialise fields for frequency repayments
     C                   MOVE      'Y'           WRPPR             1
     C                   MOVE      'Y'           WRPIN             1
     C                   MOVE      *BLANKS       WFRPR
     C                   MOVE      *BLANKS       WFRIN
     C                   MOVE      *BLANKS       WRPR1
     C                   MOVE      *BLANKS       WRIN1
     C     WENDT         IFGT      *ZEROS
     C     WNRPD         IFNE      *ZEROS
     C     WNRPD         ANDLE     WENDT
     C                   MOVE      'Y'           WFRPR
     C                   MOVE      'Y'           WRPR1
     C                   Z-ADD     WNRPD         NRPD
     C                   ENDIF
     C     WNIDT         IFNE      *ZEROS
     C     WNIDT         ANDLE     WENDT
     C                   MOVE      'Y'           WFRIN
     C                   MOVE      'Y'           WRIN1
     C                   Z-ADD     WNIDT         NIDT
     C                   Z-ADD     WNIDT         WENDI
     C                   ENDIF
     C                   ENDIF
      *
      * Set start history search: last rollover or value date
     C     LRLD          IFNE      *ZEROS
     C                   Z-ADD     LRLD          KSDAT
     C                   ELSE
     C                   Z-ADD     VDAT          KSDAT
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRPROC  -  Process each enquire request                       *
      * Called by: Main routine                                       *
      * Calls    : SRINVR - Initialise variables                      *
      *            SRHIST - Process history record                    *
      *            SRLOAM - Process loan amendment record             *
      *            SRRPAY - Process repayment frequencies             *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
      * Determine the first records for the loan
      * If no history record, get current values from loan
     C                   EXSR      SRINVR
      *
      * If last rollover date is not 0, find rollover record (seq 26)
     C     LRLD          IFNE      0
     C                   Z-ADD     26            PRS26
     C     KEYH26        SETLL     HISTR
     C                   ELSE
      *
     C     KEYHH         SETLL     HISTR
     C                   ENDIF
     C     KEYH          READE     HISTR                                  37
      *
      * If 1st record is an 'E', last rollover date is in the key and
      * the rollover principal is zero, calculate it from the start
      * and do not write until you catch up (*IN29)
     C     *IN37         IFEQ      '0'
     C     LRLD          ANDEQ     KSDAT
     C     RCDT          ANDEQ     'E'
     C     PRINRO        ANDEQ     0
     C                   MOVE      *ON           *IN29
     C                   Z-ADD     VDAT          KSDAT
     C     KEYHH         SETLL     HISTR
     C     KEYH          READE     HISTR                                  37
     C                   ENDIF
      *
      * Terminate history processing on reaching today
     C     *IN37         IFEQ      '0'
     C     VDATH         ANDGE     RUND
     C                   MOVE      *ON           *IN37
     C                   ENDIF
     C     *IN37         IFEQ      '1'
     C                   Z-ADD     99999         VDATH
     C                   Z-ADD     CPAM          WSVBL
     C                   Z-ADD     CPAM          WCUPR
     C                   Z-ADD     INTR          WCURT
     C                   Z-ADD     BRTE          WCUBR
     C                   Z-ADD     RTSP          WCUSP
     C                   Z-ADD     IACD          WLICD
     C                   Z-ADD     IACD          WLASD
     C                   MOVE      *BLANK        WINIT
     C                   ENDIF
      *
     C     KEYLL         SETLL     LOAMS
     C     *IN34         DOUEQ     '1'
     C     RECI          OREQ      'D'
     C     LNRF          READE     LOAMS                                  34
     C                   ENDDO
      *
      * Terminate amendment processing on reaching today
     C     *IN34         IFEQ      '0'
     C     VDATLA        ANDGE     RUND
     C                   MOVE      *ON           *IN34
     C                   ENDIF
     C     *IN34         IFEQ      '1'
     C                   Z-ADD     99999         VDATLA
     C                   ENDIF
      *
      * If no history or loan amendment record, no action should
      * be displayed, even for forward repayments
     C     *IN37         IFEQ      '1'
     C     *IN34         ANDEQ     '1'
     C                   MOVE      'Y'           WFULL             1
     C                   MOVE      '1'           *IN31
     C                   ELSE
     C                   MOVE      *BLANK        WFULL             1
     C                   ENDIF
      *
      * Build the action records
      * Skip if only final balance is yet to be displayed
      * Processing whichever is earlier between history and loan
      * amendment records
     C     WFULL         DOWEQ     *BLANK
      *
     C     *IN34         IFEQ      '0'
     C     *IN37         OREQ      '0'
     C                   Z-ADD     KSDAT         IACD
     C                   SELECT
     C     VDATH         WHENLE    VDATLA
     C                   EXSR      SRHIST
     C     VDATLA        WHENLE    VDATH
     C                   EXSR      SRLOAM
     C                   ENDSL
      *
      * Process frequency repayments only
     C                   ELSE
     C     WFRPR         IFEQ      'Y'
     C     WFRIN         OREQ      'Y'
     C                   EXSR      SRRPAY
     C                   ENDIF
     C                   ENDIF
      *
      * Exit loop if no action record left to display or page is full
     C     *IN31         IFEQ      '1'
     C     *IN34         OREQ      '1'
     C     *IN37         ANDEQ     '1'
     C                   MOVE      'Y'           WFULL
     C                   ENDIF
     C                   ENDDO
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRHIST  -  Process record read from history file              *
      * Called by: SRPROC - Process enquiry request                   *
      * Calls    : SRRPAY - Process each forward repayment            *
      *            SRINCL - Interest calculation                      *
      *            SROUTH - Format history record for display         *
      *            SRNEWI - Compute for new interest rate             *
      *****************************************************************
      *
     C     SRHIST        BEGSR
      *
      * Process frequency repayments
     C     WFRPR         IFEQ      'Y'
     C     WFRIN         OREQ      'Y'
     C                   Z-ADD     VDATH         WCODT             5 0
     C                   EXSR      SRRPAY
     C                   ENDIF
      *
      * Accumulate interest on change of date
     C     WLASD         IFNE      VDATH
     C     WLASD         ANDNE     *ZEROS
     C     WSTAC         ANDEQ     *BLANK
     C                   Z-ADD     VDATH         ZIEND
     C                   EXSR      SRINCL
     C                   ADD       ZINTR         WINCA
     C                   ENDIF
      *
      * Prepare to display action if selected
     C     VDATH         IFGE      KSDAT
     C     WCDIN         IFEQ      *BLANK
     C     WCDIN         OREQ      'H'
     C                   EXSR      SROUTH
     C                   ENDIF
     C                   ENDIF
      *
      * Maintain current principal, rate and interest paid
     C                   SELECT
     C     AMTPH         WHENEQ    'ST'
     C     AMTPH         OREQ      'MC'
     C                   Z-ADD     PRAMH         WSVBL
     C                   Z-ADD     PRAMH         WCUPR
     C                   Z-ADD     BRTEH         WCUBR
     C                   Z-ADD     RTSPH         WCUSP
     C                   Z-ADD     INTRH         WCURT
     C                   Z-ADD     VDATH         WLICD
      *
     C     AMTPH         WHENEQ    'IN'
     C                   ADD       INTAH         WINPD
     C     SCAPI         IFEQ      'YES'
     C                   ADD       INTAH         WCUPR
     C                   ENDIF
      *
     C     AMTPH         WHENEQ    'RO'
     C     PRINRO        IFNE      *ZEROS
     C                   Z-ADD     PRINRO        WCUPR
     C                   Z-ADD     PRINRO        WSVBL
     C                   ENDIF
     C                   Z-ADD     BRTEH         WCUBR
     C                   Z-ADD     RTSPH         WCUSP
     C                   Z-ADD     INTRH         WCURT
     C                   Z-ADD     VDATH         WLICD
      *
     C     AMTPH         WHENEQ    'PT'
     C     AMTPH         OREQ      'PI'
     C                   ADD       PRAMH         WCUPR
      *
     C     AMTPH         WHENEQ    'PF'
     C                   SUB       PRAMH         WCUPR
      *
     C     AMTPH         WHENEQ    'MR'
     C     AMTPH         OREQ      'RE'
     C     AMTPH         OREQ      'MA'
     C                   ADD       INTAH         WINPD
     C                   SUB       PRAMH         WCUPR
      *
     C     AMTPH         WHENEQ    'BR'
     C     AMTPH         OREQ      'BC'
     C                   Z-ADD     BRTEH         WCUBR
     C                   EXSR      SRNEWI
      *
     C     AMTPH         WHENEQ    'SC'
     C                   Z-ADD     RTSPH         WCUSP
     C                   EXSR      SRNEWI
      *
     C     AMTPH         WHENEQ    'MI'
     C                   ADD       INTAH         WINCA
      *
     C     AMTPH         WHENEQ    'SA'
     C     WSTAC         IFEQ      *BLANK
     C                   Z-ADD     VDATH         WLICD
     C                   ENDIF
     C                   ENDSL
      *
     C     WINIT         IFEQ      'Y'
     C                   Z-ADD     WCUPR         WSVBL
     C                   MOVE      *BLANK        WINIT
     C                   ENDIF
     C                   MOVE      SUTPH         WHSUTP            2
     C                   Z-ADD     VDATH         WLTDT             5 0
     C                   Z-ADD     VDATH         WLASD
      *
      * Read next history record
     C     *IN37         IFEQ      '0'
     C     KEYH          READE     HISTR                                  37
      *
      * Terminate history processing on reaching today
     C     *IN37         IFEQ      '0'
     C     VDATH         ANDGE     RUND
     C                   MOVE      *ON           *IN37
     C                   ENDIF
     C     *IN37         IFEQ      '1'
     C                   Z-ADD     99999         VDATH
     C                   Z-ADD     99999         WCODT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SROUTH  -  Format history record for display                  *
      * Called by: SRHIST - Process history record                    *
      *****************************************************************
      *
     C     SROUTH        BEGSR
      *
      * Set number of days (from start or last rollover)
     C     VDATH         SUB       KSDAT         APRDAY
      *
      * Principal transfer from
     C                   SELECT
     C     AMTPH         WHENEQ    'PF'
     C                   Z-ADD     PRAMH         EVAMNT
     C                   MOVE      'I'           INOUT
     C                   EXSR      RECOUT
      *
      * Principal transfer to
     C     AMTPH         WHENEQ    'PT'
     C                   Z-ADD     PRAMH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
      *
      * Multi-ccy rollover
     C     AMTPH         WHENEQ    'MC'
     C                   Z-ADD     CPAMH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
      *
      * Principal increase
     C     AMTPH         WHENEQ    'PI'
     C                   Z-ADD     PRAMH         EVAMNT
     C                   MOVE      'I'           INOUT
     C                   EXSR      RECOUT
      *
      * Manual Repayment - principal
     C     AMTPH         WHENEQ    'MR'
     C     PRAMH         IFNE      *ZEROS
     C                   Z-ADD     PRAMH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * ... interest
     C     INTAH         IFNE      *ZEROS
     C                   Z-ADD     INTAH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * ... withholding tax
     C     WTXAH         IFNE      *ZEROS
     C     WTIN          IFNE      'G'
     C     WTIN          ANDNE     'N'
     C                   Z-ADD     WTXAH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
     C                   ENDIF
      *
      * ... fee amount
     C     FEAMH         IFNE      *ZEROS
     C                   Z-ADD     FEAMH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * Interest payment/capitalised
     C     AMTPH         WHENEQ    'IN'
     C                   Z-ADD     INTAH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
      *
      * ... withholding tax
     C     WTXAH         IFNE      *ZEROS
     C     WTIN          IFEQ      'R'
     C                   Z-ADD     WTXAH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
     C                   ENDIF
      *
      * Repayments - principal
     C     AMTPH         WHENEQ    'RE'
     C     PRAMH         IFNE      *ZEROS
     C                   Z-ADD     PRAMH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * ... interest
     C     INTAH         IFNE      *ZEROS
     C                   Z-ADD     INTAH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * ... withholding tax
     C     WTXAH         IFNE      *ZEROS
     C                   Z-ADD     WTXAH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * Maturity
     C     AMTPH         WHENEQ    'MA'
     C                   Z-ADD     PRAMH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
      *
      * ... interest/interest capitalised
     C     INTAH         IFNE      *ZEROS
     C                   Z-ADD     INTAH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * ... withholding tax
     C     WTXAH         IFNE      *ZEROS
     C                   Z-ADD     WTXAH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * Manual interest adjustment
      * If Analytical Accounting is present - only display 'MI'
      * amendments when interest adjustment amount is not Zero
     C     AMTPH         WHENEQ    'MI'
     C     BGN0ST        IFNE      'Y'
     C     BGN0ST        OREQ      'Y'
     C     INTAH         ANDNE     *ZERO
     C                   Z-ADD     INTAH         EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * Rollover - base rate
     C     AMTPH         WHENEQ    'RO'
      *
      * ... check if in accumulation mode
     C     *IN29         IFEQ      *ON
     C     PRINRO        ANDEQ     *ZEROS
     C                   Z-ADD     WCUPR         PRINRO
     C                   Z-ADD     LRLD          KSDAT
     C     VDATH         SUB       KSDAT         APRDAY
      *
      * turn accumulator off when last rollover date reached
     C     VDATH         IFGE      LRLD
     C                   MOVE      *OFF          *IN29
     C                   ENDIF
     C                   ENDIF
      *
      * ... principal and discount
     C     PRINX         IFNE      *BLANK
     C     PRINRO        ANDNE     *ZEROS
     C                   Z-ADD     PRINRO        EVAMNT
     C                   MOVE      'I'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
     C     DISCRO        IFNE      *ZEROS
     C                   Z-ADD     DISCRO        EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * Start action
     C     AMTPH         WHENEQ    'ST'
     C                   Z-ADD     PRAMH         EVAMNT
     C                   MOVE      'I'           INOUT
     C                   EXSR      RECOUT
      *
      * ... discount
     C     TOTI          IFGT      *ZEROS
     C                   Z-ADD     TOTI          EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * ... premium
     C     TOTI          IFLT      *ZEROS
     C                   Z-SUB     TOTI          EVAMNT
     C                   MOVE      'I'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRLOAM  -  Process record read from loan amendments file      *
      * Called by: SRPROC - Process enquiry request                   *
      * Calls    : SRRPAY - Process each forward repayment            *
      *            SRINCL - Interest calculation                      *
      *            SROUTL - Format loan amendment for display         *
      *            SRNEWI - Compute for new interest rate             *
      *****************************************************************
      *
     C     SRLOAM        BEGSR
      *
      * Process frequency repayments
     C     WFRPR         IFEQ      'Y'
     C     WFRIN         OREQ      'Y'
     C                   Z-ADD     VDATLA        WCODT
     C                   EXSR      SRRPAY
     C                   ENDIF
      *
      * Accumulate interest on change of date
     C     WLASD         IFNE      VDATLA
     C     WLASD         ANDNE     *ZEROS
     C     WSTAC         ANDEQ     *BLANK
     C                   Z-ADD     VDATLA        ZIEND
     C                   EXSR      SRINCL
     C                   ADD       ZINTR         WINCA
     C                   ENDIF
      *
      * Prepare to display action if selected
     C     VDATLA        IFGE      KSDAT
     C     WCDIN         IFEQ      *BLANK
     C     WCDIN         OREQ      'P'
     C     AMTPLA        ANDEQ     'PD'
     C     WCDIN         OREQ      'B'
     C     VDATLA        ANDLT     RUND
     C     AMTPLA        ANDNE     'PD'
     C     WCDIN         OREQ      'F'
     C     VDATLA        ANDGE     RUND
     C                   EXSR      SROUTL
     C                   ENDIF
     C                   ENDIF
      *
      * Maintain current principal, rate and interest paid
     C                   SELECT
     C     AMTPLA        WHENEQ    'PT'
     C     AMTPLA        OREQ      'PI'
     C                   ADD       PRAMLA        WCUPR
      *
     C     AMTPLA        WHENEQ    'PF'
     C     AMTPLA        OREQ      'RE'
     C     REPTLA        ANDEQ     2
     C                   SUB       PRAMLA        WCUPR
      *
     C     AMTPLA        WHENEQ    'MR'
     C                   ADD       INTALA        WINPD
     C                   SUB       PRAMLA        WCUPR
      *
      * For repayment types 1 and 3, compute for the separate
      * principal and interest repayments from the repayment made
     C     AMTPLA        WHENEQ    'RE'
     C     REPTLA        IFEQ      3
     C     ZINTR         IFLE      TAMTLA
     C     TAMTLA        SUB(H)    ZINTR         WPRAM            13 0
     C                   Z-ADD     ZINTR         WINTA            13 0
     C                   ELSE
     C                   Z-ADD     *ZEROS        WPRAM
     C                   Z-ADD     TAMTLA        WINTA
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     PRAMLA        WPRAM
     C                   Z-ADD     ZINTR         WINTA
     C                   ENDIF
     C                   SUB       WPRAM         WCUPR
     C                   ADD       WINTA         WINPD
      *
     C     AMTPLA        WHENEQ    'BC'
     C                   Z-ADD     BRTELA        WCUBR
     C                   EXSR      SRNEWI
      *
     C     AMTPLA        WHENEQ    'SC'
     C                   Z-ADD     RTSPLA        WCUSP
     C                   EXSR      SRNEWI
      *
     C     AMTPLA        WHENEQ    'SA'
     C     WSTAC         IFEQ      *BLANK
     C                   Z-ADD     VDATLA        WLICD
     C                   ENDIF
      *
     C     AMTPLA        WHENEQ    'PD'
     C     INTALA        IFNE      *ZEROS
     C                   ADD       INTALA        WINPD
     C                   ENDIF
     C                   ENDSL
      *
     C     WINIT         IFEQ      'Y'
     C                   Z-ADD     WCUPR         WSVBL
     C                   MOVE      *BLANK        WINIT
     C                   ENDIF
     C                   MOVE      SUTP          WLSUTP            2
     C                   Z-ADD     VDATLA        WLTDT
     C                   Z-ADD     VDATLA        WLASD
      *
      * Read next live loan amendment record
     C     *IN34         IFEQ      '0'
     C     *IN34         DOUEQ     '1'
     C     RECI          OREQ      'D'
     C     LNRF          READE     LOAMS                                  34
     C                   ENDDO
      *
      * Terminate amendment processing on reaching today
     C     *IN34         IFEQ      '0'
     C     VDATLA        ANDGE     RUND
     C                   MOVE      *ON           *IN34
     C                   ENDIF
     C     *IN34         IFEQ      '1'
     C                   Z-ADD     99999         VDATLA
     C                   Z-ADD     99999         WCODT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SROUTL  -  Format loan amendment for display                  *
      * Called by: SRLOAM - Process loan amendment record             *
      *****************************************************************
     C     SROUTL        BEGSR
      *
      * Set number of days (from start or last rollover)
     C     VDATLA        SUB       KSDAT         APRDAY
      *
      * Principal transfer from
     C                   SELECT
     C     AMTPLA        WHENEQ    'PF'
     C                   Z-ADD     PRAMLA        EVAMNT
     C                   MOVE      'I'           INOUT
     C                   EXSR      RECOUT
      *
      * Principal transfer to
     C     AMTPLA        WHENEQ    'PT'
     C                   Z-ADD     PRAMLA        EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
      *
      * Manual Repayment - principal
     C     AMTPLA        WHENEQ    'MR'
     C     PRAMLA        IFNE      *ZEROS
     C                   Z-ADD     PRAMLA        EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * ... interest
     C     INTALA        IFNE      *ZEROS
     C                   Z-ADD     INTALA        EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * ... withholding tax
     C     WTXALA        IFNE      *ZEROS
     C                   Z-ADD     WTXALA        EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * ... fee amount
     C     FEAMLA        IFNE      *ZEROS
     C                   Z-ADD     FEAMLA        EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
     C                   ENDIF
      *
      * Past Due
     C     AMTPLA        WHENEQ    'PD'
     C                   Z-ADD     TAMTLA        EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
      *
      * Principal increase
     C     AMTPLA        WHENEQ    'PI'
     C                   Z-ADD     PRAMLA        EVAMNT
     C                   MOVE      'I'           INOUT
     C                   EXSR      RECOUT
      *
      * Repayments - principal
     C     AMTPLA        WHENEQ    'RE'
     C     REPTLA        IFLT      3
     C                   Z-ADD     PRAMLA        EVAMNT
     C                   ELSE
     C                   Z-ADD     TAMTLA        EVAMNT
     C                   ENDIF
     C                   MOVE      'O'           INOUT
     C                   EXSR      RECOUT
      *
     C                   ENDSL
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRNEWI  -  Compute for new interest rate                      *
      * Called by: SRHIST - Process history record                    *
      *            SRLOAM - Process loan amendment record             *
      * Calls    : None                                               *
      *****************************************************************
      *
     C     SRNEWI        BEGSR
      *
      * Reflect spread to effective interest
     C                   SELECT
     C     WCUSI         WHENEQ    'A'
     C     WCUBR         ADD       WCUSP         WCURT
     C     WCUSI         WHENEQ    'S'
     C     WCUBR         SUB       WCUSP         WCURT
     C     WCUSI         WHENEQ    'P'
     C     WCUSP         DIV       100           WWORK            11 9
     C     WCUBR         MULT      WWORK         WCURT
     C                   ENDSL
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRRPAY  -  Process each forward repayment                     *
      * Called by: SRHIST - Process history record                    *
      *            SRLOAM - Process loan amendment record             *
      * Calls    : SRDISI - Display interest repayment                *
      *            SRDISR - Display principal repayment               *
      *            SRINCL - Interest calculation                      *
      *****************************************************************
      *
     C     SRRPAY        BEGSR
      *
      * Calculate for next interest date until rollover date or
      * maturity date, if previous interest date processed
     C     WRPIN         IFEQ      'Y'
     C     WRIN1         IFEQ      *BLANK
     C     IPFR          ANDNE     *BLANK
     C     NIDT          ANDNE     0
     C                   Z-ADD     NIDT          ZDAYNO
     C                   MOVE      IPFR          ZFREQ
     C                   Z-ADD     IFDY          ZMDAY
     C                   MOVE      CCY           ZCCY
     C                   MOVE      WNLOC         ZLOC
      *
      * If CLE005 is installed, take into consideration payment due
      * date, thus allowing end date to fall on a holiday
     C     CLE005        IFEQ      'Y'
     C                   EXSR      ZFRQB3
     C                   Z-ADD     *ZEROS        ZNRDYS
     C                   SELECT
     C     PDDI          WHENEQ    'P'
     C                   EXSR      ZBKDT
     C     PDDI          WHENEQ    'N'
     C     PDDI          OREQ      *BLANK
     C                   EXSR      ZFWDT
     C     PDDI          WHENEQ    'A'
     C                   Z-ADD     ZDAYNO        ZDYNBR
     C                   ENDSL
     C                   Z-ADD     ZDYNBR        WENDI
      *
      * Also, when interest is not capitalised, compute for the date
      * when payment is to be taken if due date, falls on a holiday
     C     SCAPI         IFEQ      ' NO'
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   SELECT
     C     PTDI          WHENEQ    'P'
     C                   EXSR      ZBKDT
     C     PTDI          WHENEQ    'N'
     C                   EXSR      ZFWDT
     C                   ENDSL
     C                   ENDIF
      *
      * CLE005 is not installed, next interest date calculated
      * should fall on a working day
     C                   ELSE
      *
     C                   EXSR      ZFREQB
     C                   Z-ADD     *ZEROS        ZNRDYS
     C                   EXSR      ZFWDT
     C                   Z-ADD     ZDYNBR        WENDI             5 0
     C                   ENDIF
      *
      * If computed date later than rollover/maturity, do not process
     C     ZDYNBR        IFGT      WENDT
     C                   MOVE      *BLANK        WFRIN
     C                   Z-ADD     99999         NIDT
     C                   ELSE
     C                   Z-ADD     ZDYNBR        NIDT
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *BLANK        WRIN1
     C                   ENDIF
      *
      * Calculate for next repayment date until rollover date or
      * maturity date, if previous repayment date processed
     C     WRPPR         IFEQ      'Y'
     C     WRPR1         IFEQ      *BLANK
     C     RFRQ          ANDNE     *BLANK
     C     NRPD          ANDNE     0
     C                   Z-ADD     NRPD          ZDAYNO
     C                   MOVE      RFRQ          ZFREQ
     C                   Z-ADD     RDYN          ZMDAY
     C                   MOVE      CCY           ZCCY
     C                   MOVE      WNLOC         ZLOC
      *
     C                   EXSR      ZFREQB
     C                   Z-ADD     *ZEROS        ZNRDYS
     C                   EXSR      ZFWDT
      *
     C     ZDYNBR        IFGT      WENDT
     C                   MOVE      *BLANK        WFRPR
     C                   Z-ADD     99999         NRPD
     C                   ELSE
     C                   Z-ADD     ZDYNBR        NRPD
     C                   MOVE      *BLANK        WSUBR
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *BLANK        WRPR1
     C                   ENDIF
      *
      * Process next interest date if valid and earlier than
      * history, loan amendment and principal repayment record
     C                   MOVE      *BLANK        WRPIN
     C     NIDT          IFLT      WCODT
     C     WFRIN         ANDEQ     'Y'
     C     NIDT          ANDLE     NRPD
     C     NRPD          ANDNE     *ZEROS
     C                   Z-ADD     NIDT          WLTDT
     C                   MOVE      'Y'           WRPIN
     C                   Z-ADD     *ZEROS        WINTR            13 0
      *
      * Calculate interest until this period, yet to be paid
     C     NIDT          IFNE      WLASD
     C     WLASD         ANDNE     *ZEROS
     C     WSTAC         ANDEQ     *BLANK
     C                   Z-ADD     WENDI         ZIEND
     C                   EXSR      SRINCL
     C                   ADD       ZINTR         WINCA
     C                   ENDIF
     C     WINCA         SUB       WINPD         WINTR
     C                   ADD       WINTR         WINPD
      *
      * Prepare to display action if selected and interest GT zero
      * Then maintain current principal for capitalised interest
     C     NIDT          IFGE      KSDAT
     C     WINTR         ANDGT     *ZEROS
     C     WCDIN         IFEQ      *BLANK
     C     WCDIN         OREQ      'B'
     C     NIDT          ANDLT     RUND
     C     WCDIN         OREQ      'F'
     C     NIDT          ANDGE     RUND
     C                   EXSR      SRDISI
     C                   ENDIF
     C                   ENDIF
     C     SCAPI         IFEQ      'YES'
     C                   ADD       WINTR         WCUPR
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Process next repayment date if valid and earlier than
      * history, loan amendment and interest payment record
     C                   MOVE      *BLANK        WRPPR
     C     NRPD          IFLT      WCODT
     C     WFRPR         ANDEQ     'Y'
     C     NRPD          ANDLE     NIDT
     C     NIDT          ANDNE     *ZEROS
      *
     C                   MOVE      'Y'           WRPPR
     C                   Z-ADD     NRPD          WLTDT
     C                   Z-ADD     *ZEROS        WPRAM
     C                   Z-ADD     *ZEROS        WINTA
      *
      * Continue accruing interest
     C     NRPD          IFNE      WLASD
     C     WLASD         ANDNE     *ZEROS
     C     WSTAC         ANDEQ     *BLANK
     C                   Z-ADD     NRPD          ZIEND
     C                   EXSR      SRINCL
     C                   ADD       ZINTR         WINCA
     C                   ENDIF
      *
      * For repayment type 2, repayment is wholly for principal
     C                   SELECT
     C     REPT          WHENEQ    2
     C                   Z-ADD     RAMT          WPRAM
      *
      * For repayment types 1 and 3, compute for separate principal
      * and interest repayments for the repayment made
     C     REPT          WHENEQ    1
     C     REPT          OREQ      3
     C     REPT          IFEQ      3
     C     ZINTR         IFLE      RAMT
     C     RAMT          SUB(H)    ZINTR         WPRAM
     C                   Z-ADD     ZINTR         WINTA
     C                   ELSE
     C                   Z-ADD     *ZEROS        WPRAM
     C                   Z-ADD     RAMT          WINTA
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     RAMT          WPRAM
     C                   Z-ADD     ZINTR         WINTA
     C                   ENDIF
     C                   ENDSL
      *
      * Prepare to display action if selected
     C     NRPD          IFGE      KSDAT
     C     WCDIN         IFEQ      *BLANK
     C     WCDIN         OREQ      'B'
     C     NRPD          ANDLT     RUND
     C     WCDIN         OREQ      'F'
     C     NRPD          ANDGE     RUND
      *
      * ... repayment of principal
     C     WPRAM         IFNE      *ZEROS
     C                   Z-ADD     WPRAM         EVAMNT
     C                   EXSR      SRDISR
     C                   ENDIF
      *
      * ... repayment of interest
     C     WINTA         IFNE      *ZEROS
     C                   Z-ADD     WINTA         EVAMNT
     C                   EXSR      SRDISR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * ... maintain current principal
     C     WSUBR         IFEQ      *BLANK
     C                   SUB       WPRAM         WCUPR
     C                   ADD       WINTA         WINPD
     C                   MOVE      'Y'           WSUBR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRDISI  -  Display interest repayment                         *
      * Called by: SRRPAY - Process each forward repayment            *
      * Calls    : RECOUT - Write detail line                         *
      *****************************************************************
      *
     C     SRDISI        BEGSR
      *
      * Set number of days (from start or last rollover)
     C     NIDT          SUB       KSDAT         APRDAY
      *
      * Determine narrative and amount
     C                   Z-ADD     WINTR         EVAMNT
     C                   MOVE      'O'           INOUT
      *
      * Write detail line
     C                   EXSR      RECOUT
     C                   MOVE      *BLANK        WRPIN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRDISR  -  Display a forward repayment                        *
      * Called by: SRRPAY - Process each forward repayment            *
      * Calls    : RECOUT - Write detail line                         *
      *****************************************************************
      *
     C     SRDISR        BEGSR
      *
      * Set number of days (from start or last rollover)
     C     NRPD          SUB       KSDAT         APRDAY
     C                   MOVE      'O'           INOUT
      *
      * Write detail line
     C                   EXSR      RECOUT
      *
      * Determine if interest action is yet to be output on next page
     C     WINTA         IFNE      *ZEROS
     C                   MOVE      *BLANK        WRPPR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *
      *****************************************************************
      *                                                               *
      *  FEEHIS - Subroutine to retrieve history fee details          *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:     CONV                                              *
      *                                                               *
      *****************************************************************
      *
     C     FEEHIS        BEGSR
      *
      *  Retrieve details of any matured fees
     C                   Z-ADD     0             HIFSEQ            2 0
      *
     C     KEY002        SETLL     LEFHSTF
     C                   READ      LEFHSTF                                16
      *
      * Only continue processing if a record has been read from
      * the fees history file and the key details are the same as
      * the details in the loan
     C     *IN16         DOWEQ     '0'
     C     HIBRCA        ANDEQ     BRCA
     C     HICNUM        ANDEQ     CNUM
     C     HILNRF        ANDEQ     LNRF
      *
      * Settlement date must be GE start date for calculation
     C     HIHDAT        IFGE      KSDAT
      *
      * Convert settlement to loan currency equivalent for output
     C                   MOVE      HIFCCY        INCCY                          Fee CCY
     C                   MOVE      CCY           OUTCCY                         Loan CCY
     C                   Z-ADD     HIAMTS        WEAMT
      *
     C                   EXSR      CONV
      *
     C                   Z-ADD     WEAMT         EAMT
      *
      * Only write non-zero records
     C     EAMT          IFNE      0
      *
     C     EAMT          IFLT      0
     C                   MOVE      'I'           INOUT
     C                   Z-SUB     EAMT          EVAMNT
     C                   ELSE
     C                   MOVE      'O'           INOUT
     C                   Z-ADD     EAMT          EVAMNT
     C                   END
      *
      * Calculate number of days
     C     HIHDAT        SUB       KSDAT         APRDAY
      *
      * Write the output event.
     C                   EXSR      RECOUT
      *
     C                   END
      *
     C                   END
      *
      *  Read next record
     C                   READ      LEFHSTF                                16
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      ********************************************************************
      * NEWINT - UPDATE EFFECTIVE INTEREST RATE
      *
      * Called by: SR's AMEND,ROLLVR
      * Calls    :
      ********************************************************************
      *
     C     NEWINT        BEGSR                                                  **NEWINT**
      *
     C     SPRIND        COMP      'A'                                    83
     C   83BRATE         ADD       SPRATE        EFFINT
      *
     C     SPRIND        COMP      'S'                                    83
     C   83BRATE         SUB       SPRATE        EFFINT
      *
     C     SPRIND        COMP      'P'                                    83
     C   83SPRATE        DIV       100           WORK             11 9
     C   83BRATE         MULT(H)   WORK          EFFINT
      *
     C                   ENDSR
      ********************************************************************
      * SUBROUTINE TO GENERATE PAST DUE EVENT
      *
      * Called by: MAIN PROCESSING
      * Calls    : SR's INTCAL,LEVENT,EQUIV,RECOUT
      *
     C     PSTDUE        BEGSR                                                  **PSTDUE**
      *
      * PERFORM INTEREST CALCULATIONS
     C                   Z-ADD     RUND          EVDATE            5 0          EVENT DATE
     C                   EXSR      INTCAL
      *
      * FORMAT EVENT AS PER P/LEVENT
     C                   MOVE      'D1'          EVTYPE            2            EVENT TYPE
     C                   EXSR      LEVENT
     C  N57              SETON                                        U7U8      * DBERR 22 *
     C  N57              Z-ADD     22            DBASE
     C  N57              MOVE      EVCODE        DBKEY
     C   U7
     CAN U8              GOTO      PSTEND
      *
     C                   Z-ADD     CPAM          EVAMNT           13 0          EVENT AMOUNT
      *
      * DETERMINE EQUIVALENT AMOUNTS
     C                   EXSR      SREQUI
      *
      * OUTPUT RECORD TO FILE
     C                   Z-ADD     TDAYS         APRDAY
     C                   EXSR      RECOUT
      *
     C     PSTEND        ENDSR                                                  **PSTEND**
      *
      ********************************************************************
      * START - GENERATE START EVENT(S)
      *
      * Called by: MAIN PROCESSING
      * Calls    : SR's LEVENT, SREQUI, RECOUT
      ********************************************************************
      *
     C     START         BEGSR                                                  **START**
      *
      * FORMAT EVENT AS PER P/LEVENT
     C                   MOVE      'V1'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C  N57              SETON                                        U7U8      * DBERR 23 *
     C  N57              Z-ADD     23            DBASE
     C  N57              MOVE      EVCODE        DBKEY
     C   U7
     CAN U8              GOTO      STREND
      *
     C                   Z-ADD     VDAT          EVDATE                         EVENT DATE
     C                   Z-ADD     CPRINC        EVAMNT                         EVENT AMOUNT
      *
      * DETERMINE EQUIVALENT AMOUNTS
     C                   EXSR      SREQUI
      *
      * SWITCH OFF ACCUMULATOR IF ON
     C     *IN29         IFEQ      '1'
     C                   MOVE      *OFF          *IN29
     C                   ENDIF
      *
      * OUTPUT RECORD TO FILE
     C     EVDATE        SUB       VDAT          APRDAY
     C                   EXSR      RECOUT
      *
      * DETERMINE IF SECOND EVENT REQUIRED
     C                   MOVE      'V2'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C   U7
     CAN U8              GOTO      STREND
     C   57              Z-ADD     TOTI          EVAMNT                         EVENT AMOUNT
      *
      * DETERMINE EQUIVALENT AMOUNTS
     C   57              EXSR      SREQUI
      *
      * OUTPUT RECORD TO FILE
     C   57EVDATE        SUB       VDAT          APRDAY
     C   57              EXSR      RECOUT
      *
      * UPDATE LAST EVENT DATE
     C                   Z-ADD     IACD          LSTEVD                         LAST EVENT DATE
      *
      * DETERMINE IF FOURTH EVENT REQUIRED (1st Annual premium)
     C                   MOVE      'V4'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C   U7
     CAN U8              GOTO      STREND
     C   57              Z-ADD     EVOAMT        EVAMNT                         EVENT AMOUNT
      *
      * DETERMINE EQUIVALENT AMOUNTS
     C   57              EXSR      SREQUI
      *
      * OUTPUT RECORD TO FILE
     C   57EVODAT        SUB       VDAT          APRDAY
     C   57              EXSR      RECOUT
      *
     C     STREND        ENDSR                                                  **STREND**
      *
      ********************************************************************
      * AMEND - GENERATE AMENDMENT EVENT
      *
      * Called by: MAIN PROCESSING
      * Calls    : SR's INTCAL, SRBRTD, NEWINT, LEVENT, SREQUIV,
      *            RECOUT, SRREAD
      ********************************************************************
      *
     C     AMEND         BEGSR                                                  **AMEND**
      *
      * NO EVENT TO BE GENERATED IF AMENDMENT IS PAST DUE
     C     AMTPLA        COMP      'PD'                                   87
     C   87              GOTO      FILERD
      *
      * PERFORM INTEREST CALCULATIONS
     C                   Z-ADD     VAMEND        EVDATE                         EVENT DATE
     C                   EXSR      INTCAL
      *
      * FOR SPREAD/BASE RATE AMENDMENTS NO EVENT IS REQUIRED,BUT
      * EFFECTIVE INTEREST RATE IS TO BE UPDATED
     C     AMTPLA        COMP      'BC'                                   87
     C  N87              GOTO      SPREAD
     C     BRTTLA        COMP      0                                  87
     C   87              MOVE      BRTTLA        BRTKEY            2 0
     C   87              EXSR      SRBRTD
     C   87
     CAN 55              SETON                                        U7U8      * DBERR 24 *
     C   87
     CAN 55              Z-ADD     24            DBASE
     C   87
     CAN 55              GOTO      ENDAM
      *
     C   87              Z-ADD     BRTELA        BRATE                          BASE RATE
     C  N87              Z-ADD     0             BRATE                          BASE RATE
     C                   EXSR      NEWINT
     C                   GOTO      FILERD
      *
     C     SPREAD        TAG                                                    **SPREAD TAG**
     C     AMTPLA        COMP      'SC'                                   87
     C   87              Z-ADD     RTSPLA        SPRATE                         SPREAD RATE
     C   87              EXSR      NEWINT
     C   87              GOTO      FILERD
      *
      * GENERATE EVENT FOR PRINCIPAL INCREASE
     C     AMTPLA        COMP      'PI'                                   50
     C  N50              GOTO      REPAYT
      *
      * FORMAT EVENT AS PER P/LEVENT
     C                   MOVE      'V3'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C  N57              SETON                                        U7U8      * DBERR 25 *
     C  N57              Z-ADD     25            DBASE
     C  N57              MOVE      EVCODE        DBKEY
     C   U7
     CAN U8              GOTO      ENDAM
      *
     C                   Z-ADD     PRAMLA        EVAMNT                         EVENT AMOUNT
      *
      * DETERMINE EQUIVALENT AMOUNTS
     C                   EXSR      SREQUI
      *
      * OUTPUT RECORD TO FILE
     C                   Z-ADD     TDAYS         APRDAY
     C                   EXSR      RECOUT
      *
      * UPDATE CURRENT PRINCIPAL
     C     CPRINC        ADD       PRAMLA        CPRINC                         CURRENT PRINC.
     C                   GOTO      FILERD
      *
      * GENERATE EVENT(S) FOR REPAYMENTS
     C     REPAYT        TAG                                                    **REPAYT TAG**
     C     AMTPLA        COMP      'RE'                                   50
     C   50              EXSR      REPAY
     C     FILERD        TAG                                                    **FILERD TAG**
      *
      * READ NEXT LOAN AMENDMENT RECORD
     C                   EXSR      SRREAD
     C   56              Z-ADD     99999         VAMEND                         EVENT NOT REQD.
     C  N56              Z-ADD     VDATLA        VAMEND                         AMEND DATE
      *
      * RESET LOAN AMEND. INDICATOR
     C                   SETOFF                                       50
      *
     C     ENDAM         ENDSR                                                  **ENDAM**
      ********************************************************************
      * INTRST - GENERATE INTEREST EVENT
      *
      * Called by: MAIN PROCESSING
      * Calls    : SR's INTCAL, LEVENT, SREQUI, RECOUT, FREQB, ZFWDT
      *            FREQB, ZFWDT
      ********************************************************************
      *
     C     INTRST        BEGSR                                                  **INTRST**
      *
      * PERFORM INTEREST CALCULATIONS
     C                   Z-ADD     VINTR         EVDATE                         EVENT DATE
     C                   EXSR      INTCAL
      *
      * FORMAT EVENT AS PER P/LEVENT
      * IF INTEREST IS CAPITALISED USE EVENT TYPE 'X2' INSTEAD
     C     *IN54         IFEQ      '0'
     C                   MOVE      'I2'          EVTYPE                         EVENT TYPE
     C                   ELSE
     C                   MOVE      'X2'          EVTYPE
     C                   END
     C                   EXSR      LEVENT
     C  N57              SETON                                        U7U8      * DBERR 26 *
     C  N57              Z-ADD     26            DBASE
     C  N57              MOVE      EVCODE        DBKEY
     C   U7
     CAN U8              GOTO      INTEND
      *
     C                   Z-ADD     INTDUE        EVAMNT                         EVENT AMOUNT
      *
      * DETERMINE EQUIVALENT AMOUNTS
     C                   EXSR      SREQUI
      *
      * OUTPUT RECORD TO FILE
     C                   Z-ADD     TDAYS         APRDAY
     C                   EXSR      RECOUT
      *
      * UPDATE CURRENT PRINCIPAL IF INTEREST TO BE CAPITALIZED
      * UPDATE INTEREST PAID THIS RUN
     C   54CPRINC        ADD       INTDUE        CPRINC                         CURRENT PRINC.
      *
     C     INTPD         ADD       INTDUE        INTPD                          INT.PD.THIS RUN
      *
      * UPDATE NEXT INTEREST DATE & BASE DATE
     C     IPFR          COMP      ' '                                    87
     C   87              Z-ADD     99999         VINTR                          INTEREST DATE
     C   87              GOTO      INTEND
     C                   MOVE      IPFR          ZFREQ
     C                   Z-ADD     INTBD         ZDAYNO
     C                   Z-ADD     IFDY          ZMDAY
     C                   MOVE      CCY           ZCCY
     C  N77              EXSR      MATLOC
     C                   MOVE      W@MDSL        ZLOC
      *
     C                   EXSR      ZFREQB
     C   99              SETON                                        U7U8      * DBERR 27 *
     C   99              Z-ADD     27            DBASE
     C   99              GOTO      INTEND
      *
     C                   Z-ADD     *ZERO         ZNRDYS
     C                   EXSR      ZFWDT
      *
     C                   Z-ADD     ZDAYNO        INTBD                          INT.BASE DATE
     C                   Z-ADD     ZDYNBR        VINTR                          INTEREST DATE
      *
     C     INTEND        ENDSR                                                  **INTEND**
      *
      ********************************************************************
      * REPAY - GENERATE REPAYMENT EVENT(S)
      *
      * Called by: MAIN PROCESSING
      * Calls    : SR's INTCAL, LEVENT, SREQUI, RECOUT,
      *            FREQB, ZFWDT
      ********************************************************************
      *
     C     REPAY         BEGSR                                                  **REPAY**
      *
      * PERFORM INTEREST CALCULATIONS
     C   50              Z-ADD     VAMEND        EVDATE                         EVENT DATE
     C  N50              Z-ADD     VREPAY        EVDATE
     C  N50              EXSR      INTCAL
      *
      * DETERMINE REPAYMENT & INTEREST AMOUNTS
      * NEED TO DISTINGUISH BETWEEN REPAYMENTS DERIVED FROM AMENDMEN   T
      * RECORDS & THOSE FROM LOANS RECORDS - INDICATOR 50
      *
      *  REPAYMENT TYPE '1'
     C   51
     CAN 50              Z-ADD     PRAMLA        REAMT            13 0          REPAY AMOUNT
     C   51
     CANN50              Z-ADD     RAMT          REAMT
      *
      * SHOULD NOT GO ON GENERATING EVENTS FOR FULL PRINCIPAL REPAYMENT
      * AMOUNT WHEN OUTSTANDING CURRENT PRINCIPAL IS LESS THAN IT.
     C   51
     CANN50CPRINC        IFLT      0
     C                   Z-ADD     0             REAMT
     C                   END
      *
     C   51              Z-ADD     INTDUE        REINT            13 0          INTEREST AMOUNT
      *
      * REPAYMENT TYPE '2'
     C   52
     CAN 50              Z-ADD     TAMTLA        REAMT
     C   52
     CANN50              Z-ADD     RAMT          REAMT
      *
      * SHOULD NOT GO ON GENERATING EVENTS FOR FULL PRINCIPAL REPAYMENT
      * AMOUNT WHEN OUTSTANDING CURRENT PRINCIPAL IS LESS THAN IT.
     C   52
     CANN50RAMT          COMP      CPRINC                             87
     C   52
     CANN50
     CAN 87              Z-ADD     CPRINC        REAMT
     C   52
     CANN50CPRINC        IFLT      0
     C                   Z-ADD     0             REAMT
     C                   END
      *
     C   52              Z-ADD     0             REINT
      *
      * REPAYMENT TYPE '3'
     C   53
     CAN 50              Z-ADD     TAMTLA        TOTAL            13 0
     C   53
     CANN50              Z-ADD     RAMT          TOTAL
      *
      * SHOULD NOT GO ON GENERATING EVENTS FOR FULL PRINCIPAL REPAYMENT
      * AMOUNT WHEN OUTSTANDING CURRENT PRINCIPAL IS LESS THAN IT.
     C   53
     CANN50CPRINC        IFLT      0
     C                   Z-ADD     0             TOTAL
     C                   ELSE
     C     CPRINC        IFLT      RAMT
     C                   Z-ADD     CPRINC        TOTAL
     C                   END
     C                   END
      *
     C   53INTDUE        COMP      TOTAL                                8787
     C   53
     CAN 87              Z-ADD     INTDUE        REINT
     C   53
     CAN 87TOTAL         SUB       INTDUE        REAMT
     C   53
     CAN 87CPRINC        IFLT      REAMT
     C                   Z-ADD     CPRINC        REAMT
     C                   END
      *
     C   53
     CANN87              Z-ADD     TOTAL         REINT
     C   53
     CANN87              Z-ADD     0             REAMT
      *
      * FORMAT EVENT AS PER P/LEVENT
     C                   MOVE      'R1'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C  N57              SETON                                        U7U8      * DBERR 28 *
     C  N57              Z-ADD     28            DBASE
     C  N57              MOVE      EVCODE        DBKEY
     C   U7
     CAN U8              GOTO      REPEND
      *
     C                   Z-ADD     REAMT         EVAMNT                         EVENT AMOUNT
      *
     C                   MOVEA     '000'         *IN(11)
     C   51
     COR 52CPRINC        COMP      REAMT                              111213
     C     *IN12         IFEQ      '1'
     C                   Z-ADD     CPRINC        EVAMNT
     C                   Z-ADD     CPRINC        REAMT
     C                   END
      *
      *    DETERMINE EQUIVALENT AMOUNTS
     C                   EXSR      SREQUI
      *
      * OUTPUT RECORD TO FILE
     C                   Z-ADD     TDAYS         APRDAY
     C                   EXSR      RECOUT
      *
      * FOR REPAYMENT TYPES 1 OR 3,GENERATE EVENT FOR INTEREST AMOUNT
     C  N51
     CANN53              GOTO      REP01
      *
      * FORMAT EVENT AS PER P/LEVENT
     C                   MOVE      'R2'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C  N57              SETON                                        U7U8      * DBERR 29 *
     C  N57              Z-ADD     29            DBASE
     C  N57              MOVE      EVCODE        DBKEY
     C   U7
     CAN U8              GOTO      REPEND
      *
     C                   Z-ADD     REINT         EVAMNT                         EVENT AMOUNT
      *
      * DETERMINE EQUIVALENT AMOUNTS
     C                   EXSR      SREQUI
      *
      * OUTPUT RECORD TO FILE
     C                   Z-ADD     TDAYS         APRDAY
     C                   EXSR      RECOUT
     C     REP01         TAG                                                    **REP01 TAG**
      *
      * UPDATE CURRENT PRINCIPAL & INTEREST PAID THIS RUN
     C     CPRINC        SUB       REAMT         CPRINC                         CURRENT PRINC.
     C     INTPD         ADD       REINT         INTPD                          INT.PD.THIS RUN
     C   50              GOTO      REPEND
      *
      * FOR LOAN-DERIVED REPAYMENTS,UPDATE NEXT REPAYMENT DATE
     C     RFRQ          COMP      ' '                                    87
      *
      * FOR -VE/ZERO PRINCIPAL, SHOULD NO LONGER GENERATE REPAYMENTS
     C  N87CPRINC        COMP      0                                    8787
     C  N87CPRINC        COMP      0                                      87
     C   87              Z-ADD     99999         VREPAY
     C   87              GOTO      REPEND
      *
     C     *IN12         IFEQ      '1'
     C     *IN13         OREQ      '1'
     C     RFRQ          OREQ      ' '
     C                   Z-ADD     99999         VREPAY
     C                   GOTO      REPEND
     C                   END
      *
      *
     C                   MOVE      RFRQ          ZFREQ
     C                   Z-ADD     REPBD         ZDAYNO
     C                   Z-ADD     RDYN          ZMDAY
     C                   MOVE      CCY           ZCCY
     C  N77              EXSR      MATLOC
     C                   MOVE      W@MDSL        ZLOC
      *
     C                   EXSR      ZFREQB
     C   99              SETON                                        U7U8      * DBERR 30 *
     C   99              Z-ADD     30            DBASE
     C   99              GOTO      REPEND
      *
     C                   Z-ADD     *ZERO         ZNRDYS
     C                   EXSR      ZFWDT
      *
     C                   Z-ADD     ZDAYNO        REPBD                          REPAY BASE DATE
     C                   Z-ADD     ZDYNBR        VREPAY                         REPAYMENT DATE
      *
     C     REPEND        ENDSR                                                  **REPEND**
      ********************************************************************
      * ROLLVR - GENERATE ROLLOVER EVENT
      *
      * Caleld by: MAIN PROCESSING
      * Calls: SR's INTCAL, LEVENT, RECOUT, SRBRTD, NEWINT
      ********************************************************************
      *
     C     ROLLVR        BEGSR                                                  **ROLLVR**
      *
      * PERFORM INTEREST CALCULATIONS
     C                   Z-ADD     VROLLR        EVDATE                         EVENT DATE
      *
      * ROLLOVER PROCESSING FOR DISCOUNTED LOANS.
     C     *IN66         IFEQ      '1'
     C                   EXSR      ROLDIS
     C                   GOTO      ROLEND
     C                   END
     C                   EXSR      INTCAL
      *
      * FORMAT EVENT AS PER P/LEVENT
     C                   MOVE      'R5'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C  N57              SETON                                        U7U8      * DBERR 31 *
     C  N57              Z-ADD     31            DBASE
     C  N57              MOVE      EVCODE        DBKEY
     C   U7
     CAN U8              GOTO      ROLEND
      *
      * CURRENT PRINCIPAL OUTPUT ON ROLLOVER EVENTS FOR
      * FINANCIAL LOANS DIARY REPORT ONLY.
     C                   Z-ADD     CPRINC        EVAMNT                         EVENT AMOUNT
      *
      * CHECK IF NEW BASE RATE APPLICABLE
     C     CHIN          COMP      'R'                                    88
     C     NBRA          COMP      0                                  87
     C   88              MOVE      BRTT          BRTKEY
     C     *IN88         Ifeq      *On
     C     Brtkey        andeq     0
     C                   Move      BRTTPH        BRTKEY
     C                   Endif
     C   87              MOVE      NBRA          BRTKEY
     C  N88
     CANN87              GOTO      TAG1
     C                   EXSR      SRBRTD
     C   55              SETON                                        U7U8      * DBERR 32 *
     C   55              Z-ADD     32            DBASE
     C   55              GOTO      ROLEND
     C     VDNR          COMP      0                                      86
     C  N86              Z-ADD     NBRT          BRATE
     C     TAG1          TAG                                                    **TAG1 TAG**
      *
      * PICK UP NEW ROLLOVER DETAILS IF PRESENT
     C     NCAS          COMP      0                                      82
     C   82              GOTO      TAG2
     C                   Z-ADD     NRTS          SPRATE                         SPREAD/RATE
     C                   MOVE      NSIN          SPRIND                         SPREAD IND.
     C                   MOVE      NCAS          INTBAS                         CALC. BASIS
      *
     C     TAG2          TAG                                                    ** TAG2 TAG **
     C                   EXSR      NEWINT
      *
      * OUTPUT RECORD TO FILE
     C                   Z-ADD     TDAYS         APRDAY
     C                   EXSR      RECOUT
     C                   Z-ADD     99999         VROLLR                         ROLLOVER DATE
     C     ROLEND        ENDSR                                                  **ROLEND**
      *
      ********************************************************************
      * ROLDIS - GENERATE ROLLOVER EVENTS FOR DISC. LOAN
      *
      * Called by: ROLLVR
      * Calls    : SR's SREQUI, NEWINT, RECOUT, LEVENT
      ********************************************************************
      *
     C     ROLDIS        BEGSR                                                  **ROLDIS**
      *
      * FORMAT EVENT AS PER P/LEVENT
     C                   MOVE      'R5'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C  N57              SETON                                        U7U8      * DBERR 33 *
     C  N57              Z-ADD     33            DBASE
     C  N57              MOVE      EVCODE        DBKEY
     C  N57              GOTO      DISEND
      *
     C                   Z-ADD     NDAM          EVAMNT                         NEW PRINCIPAL
      *
      * DETERMINE EQUIVALENT AMOUNTS
     C                   EXSR      SREQUI
      *
      * CHECK IF NEW BASE RATE APPLICABLE
     C     CHIN          COMP      'R'                                    88
     C     NBRA          COMP      0                                  87
     C   88              MOVE      BRTT          BRTKEY
     C   87              MOVE      NBRA          BRTKEY
     C  N88
     CANN87              GOTO      TAGR1
     C                   EXSR      SRBRTD
     C   55              SETON                                        U7U8      * DBERR 34 *
     C   55              Z-ADD     34            DBASE
     C   55              GOTO      DISEND
     C     VDNR          COMP      0                                      86
     C  N86              Z-ADD     NBRT          BRATE
     C     TAGR1         TAG                                                    **TAGR1 TAG**
      *
      * PICK UP NEW ROLLOVER DETAILS IF PRESENT
     C     NCAS          COMP      0                                      82
     C   82              GOTO      TAGR2
     C                   Z-ADD     NRTS          SPRATE                         SPREAD/RATE
     C                   MOVE      NSIN          SPRIND                         SPREAD IND.
     C                   MOVE      NCAS          INTBAS                         CALC. BASIS
      *
     C     TAGR2         TAG                                                    **TAGR2 TAG**
     C                   EXSR      NEWINT
      *
      * OUTPUT RECORD TO FILE
     C     EVDATE        SUB       KSDAT         APRDAY
     C                   EXSR      RECOUT
      *
     C                   Z-ADD     EFFINT        SAVINT           11 7          SAVE EFFINT
     C                   Z-ADD     INTR          EFFINT                         CURR INT RATE
      *
     C                   MOVE      'R4'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C  N57              SETON                                        U7U8      * DBERR 35 *
     C  N57              Z-ADD     35            DBASE
     C  N57              MOVE      EVCODE        DBKEY
     C  N57              GOTO      DISEND
      *
     C                   Z-ADD     CPRINC        EVAMNT                         CURRENT PRINC
      *
     C                   EXSR      SREQUI
      *
     C     EVDATE        SUB       IACD          APRDAY
     C                   EXSR      RECOUT
      *
     C                   Z-ADD     SAVINT        EFFINT                         RESTORE FIELD
      *
     C                   MOVE      'R3'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C  N57              SETON                                        U7U8      * DBERR 36 *
     C  N57              Z-ADD     36            DBASE
     C  N57              MOVE      EVCODE        DBKEY
     C  N57              GOTO      DISEND
     C                   Z-ADD     NPRAM         EVAMNT
      *
     C                   EXSR      SREQUI
      *
     C     EVDATE        SUB       IACD          APRDAY
     C                   EXSR      RECOUT
      *
     C                   Z-ADD     99999         VROLLR
      *
     C     DISEND        ENDSR
      *
      ********************************************************************
      * ANNPRM - GENERATE ANNUAL PREMIUM EVENT
      *
      * Called by: MAIN PROCESSING
      * Calls: SR's LEVENT,RECOUT
      ********************************************************************
      *
     C     ANNPRM        BEGSR                                                  **ANNPRM**
      *
     C                   Z-ADD     VAPREM        EVDATE                         EVENT DATE
      *
      * FORMAT EVENT AS PER P/LEVENT
     C                   MOVE      'V4'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C  N57              Z-ADD     99999         VAPREM
     C  N57              GOTO      ANNEND                                       NOT NEEDED
      *
     C                   Z-ADD     ANNPR         EVAMNT                         EVENT AMOUNT
      *
      * CALCULATE DAYS IN PERIOD
     C                   Z-ADD     VADAYS        APRDAY
      *
      * OUTPUT RECORD TO FILE
     C                   EXSR      RECOUT
      *
      *    CHECK NEXT PERIOD
     C                   Z-ADD     VAPREM        ZINDT                          START DATE
     C                   Z-ADD     1             ZNYR                           ADD 1 YEAR
     C                   Z-ADD     0             ZNMN
     C                   Z-ADD     0             ZNDY
     C                   EXSR      ZCPD
     C     ZPDNO         IFLT      VMATUR                                       ANNUAL PREMIUM
     C     ZPDNO         SUB       VAPREM        VADAYS
     C                   Z-ADD     ZPDNO         VAPREM
     C                   ELSE
     C                   Z-ADD     99999         VAPREM                         PREMIUM DATE
     C                   END
      *
     C     ANNEND        ENDSR                                                  ** ANNEND **
      *
      ********************************************************************
      * MATUR - GENERATE MATURITY EVENT(S)
      *
      * Called by: MAIN PROCESSING
      * Calls    : SR's INTCAL, LEVENT, SREQUIV, RECOUT
      ********************************************************************
      *
     C     MATUR         BEGSR                                                  **MATUR**
      *
      * PERFORM INTEREST CALCULATIONS
     C                   Z-ADD     VMATUR        EVDATE                         EVENT DATE
     C                   EXSR      INTCAL
      *
      * FOR CALL LOANS WITH MAT. DATE=0,NOMINAL MAT. DATE(RUN DATE+1   5)
      * IS REQUIRED ONLY FOR SELECTION OF EVENTS & CALC. OF INTEREST   -
      * HENCE RESET EVENT DATE HERE TO ACTUAL MAT. DATE
     C  N10              Z-ADD     MDAT          EVDATE
     C     *IN10         IFEQ      '1'
     C     RLDT          IFEQ      MDAT
     C     NMDT          ANDNE     0
     C                   Z-ADD     NMDT          VMATUR
     C                   ELSE
     C                   Z-ADD     MDAT          VMATUR
     C                   END
     C                   END
     C     *IN66         IFEQ      '1'
     C                   Z-ADD     VMATUR        EVDATE
     C                   END
      *
      * FORMAT EVENT AS PER P/LEVENT
     C                   MOVE      'M1'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C  N57              SETON                                        U7U8      * DBERR 37 *
     C  N57              Z-ADD     37            DBASE
     C  N57              MOVE      EVCODE        DBKEY
     C   U7
     CAN U8              GOTO      MATEND
      *
     C                   Z-ADD     CPRINC        EVAMNT                         EVENT AMOUNT
     C     *IN66         IFEQ      '1'
     C                   Z-ADD     NPRAM         EVAMNT
     C                   END
      *
      * FOR EARLY MATURITY OF DISCOUNTED LOAN, THE EVENT AMOUNT
      * SHOULD BE PRINCIPAL MINUS REBATE
     C     PTYP          IFEQ      63
     C     ORMD          IFNE      0
     C     ORTI          SUB       TOTI          REBATE           13 0
     C     CPRINC        SUB       REBATE        EVAMNT
     C                   END
     C                   END
      *
      * DETERMINE EQUIVALENT AMOUNTS
     C                   EXSR      SREQUI
      *
      * OUTPUT RECORD TO FILE
     C                   Z-ADD     TDAYS         APRDAY
      *
     C                   EXSR      RECOUT
      *
      * DETERMINE IF SECOND EVENT REQUIRED
     C                   MOVE      'M2'          EVTYPE                         EVENT TYPE
     C                   EXSR      LEVENT
     C   U7
     CAN U8              GOTO      MATEND
      *
     C   57INTDUE        SUB       JTAIN         EVAMNT                         EVENT AMOUNT
      *
      * DETERMINE EQUIVALENT AMOUNTS
     C   57              EXSR      SREQUI
      *
      * SWITCH OFF ACCUMULATOR
     C     *IN57         IFEQ      '1'
     C     *IN29         ANDEQ     '1'
     C                   MOVE      *OFF          *IN29
     C                   ENDIF
      *
      * OUTPUT RECORD TO FILE
     C   57              Z-ADD     TDAYS         APRDAY
     C   57              EXSR      RECOUT
      *
     C     MATEND        ENDSR                                                  **MATEND**
      *
      *****************************************************************
      *  PROCES - SUBROUTINE TO PERFORM FEE PROCESSING.               *
      *                                                               *
      *  Called By: MAIN PROCESSING                                   *
      *  Calls:     EVENT, FEES, ZFWDT, AOCURRR0, NONCAL              *
      *****************************************************************
      *
     C     PROCES        BEGSR
      *
      ***************************
      * Processing for Loan Fee *
      ***************************
      *
      * Access loan record
     C                   Z-ADD     0             FCKEY1
      *
      * This processing picks up fees on both live & matured loans
     C     KEY001        SETLL     LEFEEDL2
     C                   READ      LEFEEDL2                               08
      *
      * Check length of discount loans - must be gt 15
     C     *IN08         IFEQ      '0'
     C     PTYP          ANDEQ     63
     C     MDAT          ANDNE     0
     C     MDAT          SUB       VDAT          FEPWKD            5 0
     C     FEPWKD        IFLT      16
     C                   MOVE      *ON           *IN08
     C                   END
     C                   END
      *
     C     *IN08         DOWEQ     '0'                                          ***B001
     C     FECNUM        ANDEQ     CNUM
     C     FEFACL        ANDEQ     FCKEY1
     C     FELOAN        ANDEQ     LNRF
      *
      * Access fee extension record
     C                   MOVE      FEFCOD        FEFCOA            2
     C     FEFCOA        CHAIN     SDFEEL0                            09
     C     *IN09         IFEQ      '0'                                          ***B002
      *
      * Must be specified as included in APR calculation
     C     AUIAPR        ANDEQ     'Y'
     C     FERECI        ANDEQ     'D'
      *
      * Covert amount to base currency equivalent if Fee currency is not in base currency
     C     FEFCCY        IFNE      BCCY
     C                   Eval      F@FAMT = FEFAMT
     C                   Eval      F@FCCY = FEFCCY
     C                   Eval      T@CCY = BCCY
     C                   EXSR      CVTBCY
     C                   ENDIF
      *
      * Must be above a minimum if requested
     C     AUMINF        IFNE      0                                            ***B003
     C     FEFAMT        ANDGT     AUMINF
     C     FEFCCY        ANDEQ     BCCY
      *
     C     AUMINF        ORNE      0
     C     FEFCCY        ANDNE     BCCY
     C     T@CAMT        ANDGT     AUMINF
      *
     C     AUMINF        OREQ      0
      *
     C                   MOVEL     FEFCCY        CURKEY            3
     C     CURKEY        CHAIN     SDCURRL0                           15
     C     *IN15         IFEQ      *ON                                          ***B004
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE6002  '    DBPGM
     C                   MOVE      'SDCURRL0'    DBFILE                         ************
     C                   MOVE      FEFCCY        DBKEY                          * DBERR 38 *
     C                   Z-ADD     38            DBASE                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                    ***E004
      *
     C                   Z-ADD     TXND          ZNRDYS
     C                   Z-ADD     FESTTL        WKSTLL            2 0
     C                   MOVEL     FEOURS        WKOUR            12
      *
      * Check if fee due this run
     C                   EXSR      NONCAL
      *
     C                   END                                                    ***E003
     C                   END                                                    ***E002
      *
      * Get next record
     C                   READ      LEFEEDL2                               08
      *
     C                   END                                                    ***E001
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/CVTBCY
      *****************************************************************
      *  CVTBCY - SUBROUTINE TO CONVERT CURRENCY TO BASE CURRENCY     *
      *           EQUIVALENT                                          *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:     ZCCYCN                                            *
      *****************************************************************
      *
     C     CVTBCY        BEGSR
      *
     C                   Z-ADD     1             X
     C     F@FCCY        LOOKUP    XCYA(X)                                14
     C     *IN14         IFEQ      '1'
     C                   Eval      F@SPRT = XSPA(X)
     C                   Eval      F@MDIN = XMDA(X)
     C                   Eval      F@NBDP = XDPA(X)
     C                   ENDIF
      *
     C                   Z-ADD     1             X
     C     T@CCY         LOOKUP    XCYA(X)                                14
     C     *IN14         IFEQ      '1'
     C                   Eval      T@SPRT = XSPA(X)
     C                   Eval      T@MDIN = XMDA(X)
     C                   Eval      T@NBDP = XDPA(X)
     C                   ENDIF
      *
     C                   CALL      'ZCCYCN'
      * Amount in 'FROM' currency (15P 0)                                      *
      * From Currency (3A)                                                     *
      * TO currency (3A)                                                       *
      * Spot Rate for 'FROM' currency (13P 8)                                  *
      * Spot Rate for 'TO' currency (13P 8)                                    *
      * Multiply/Divide Indicator for 'FROM' currency  (1A)                    *
      * Multiply/Divide Indicator for 'TO' currency (1A)                       *
      * Currency Decimal places for 'FROM' currency (1P 0)                     *
      * Currency Decimal places for 'TO' currency (1P 0)
     C                   PARM                    F@FAMT
     C                   PARM                    F@FCCY
     C                   PARM                    T@CCY
     C                   PARM                    F@SPRT
     C                   PARM                    T@SPRT
     C                   PARM                    F@MDIN
     C                   PARM                    T@MDIN
     C                   PARM                    F@NBDP
     C                   PARM                    T@NBDP

      ** Returned parameters
      ** -------------------
      * Amount in 'TO' Currency (i.e. Converted Amount) (15P 0)                *
      * Cross Exchange Rate (13P 8)
      * Cross Rate Multiply/Divide Indicator (1A)

     C                   PARM                    T@CAMT
     C                   PARM                    T@CERT
     C                   PARM                    T@MDIV
     C
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/NONCAL
      *****************************************************************
      *  NONCAL - SUBROUTINE TO CHECK IF NON-CALCULATED OR            *
      *           LOAN FEES DUE THIS RUN                              *
      *                                                               *
      *  Called By: PROCESS                                           *
      *  Calls:     FEEPAY                                            *
      *****************************************************************
      *
     C     NONCAL        BEGSR
      *
      * Set generation date to end of book
     C                   Z-ADD     0             WFEE             15 0
     C                   Z-ADD     0             ENAR2             5 0
      *
     C                   Z-ADD     FEPEND        ENAR2
      *
      * Bullet fees have no end date and are due on start date.
     C     FEPEND        IFEQ      0
     C     FEPYON        ANDEQ     ' '
     C                   Z-ADD     FEPSTD        ENAR2
     C                   END
      *
      * If payment on indicator (FEPYON) is blank, fee should be
      * settled in full on start date;  if FEPYON is 'S' fee
      *  is amortised so is paid up front, i.e., start date.
     C     FEPYON        IFEQ      *BLANKS                                      ***B001
     C     FEPSTD        ANDNE     0
     C     FEPYON        OREQ      'S'
     C     FEPSTD        ANDNE     0
     C                   Z-ADD     FEPSTD        PAYDAT            5 0
     C     FEFAMT        SUB       FEAMTS        WFEE
     C                   EXSR      FEEPAY
      *
     C                   END                                                    ***E001
      *
      * If payment on indicator (FEPYON) is 'E' fee is to be
      * accrued and settled on end date.
     C     FEPYON        IFEQ      'E'                                          ***B001
     C     FEPEND        ANDNE     0
     C                   MOVE      FEPEND        PAYDAT
     C     FEFAMT        SUB       FEAMTS        WFEE
     C                   EXSR      FEEPAY
      *
     C                   END                                                    ***E001
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/FEEPAY
      *****************************************************************
      *  FEEPAY - FEE PAYMENT EVENT                                   *
      *                                                               *
      *  Called By: NONCAL                                            *
      *  Calls:     CONV                                              *
      *****************************************************************
      *
     C     FEEPAY        BEGSR
      *
      * Set up fields for output of the fee event
      *
      * Convert to loan currency equivalent for output
     C                   MOVE      FEFCCY        INCCY             3            Fee CCY
     C                   MOVE      CCY           OUTCCY            3            Loan CCY
     C                   Z-ADD     WFEE          WEAMT            13 0
      *
     C                   EXSR      CONV
      *
     C                   Z-ADD     PAYDAT        EDAT              5 0
     C                   Z-ADD     WEAMT         EAMT             13 0
      *
      * Only write non-zero records
     C     EAMT          IFNE      0
      *
     C     EAMT          IFLT      0
     C                   MOVE      'I'           INOUT
     C                   Z-SUB     EAMT          EVAMNT
     C                   ELSE
     C                   MOVE      'O'           INOUT
     C                   Z-ADD     EAMT          EVAMNT
     C                   END
      *
     C     EDAT          SUB       KSDAT         APRDAY
      *
     C                   EXSR      RECOUT
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/CONV
      *****************************************************************
      *  CONV   - SUBROUTINE TO CONVERT EVENT AMOUNTS INTO            *
      *           FACILITY CURRENCY                                   *
      *                                                               *
      *  Called By: EVENT                                             *
      *  Calls:     ZXRATE, ZCONV                                     *
      *****************************************************************
      *
     C     CONV          BEGSR
      *
      * If currencies are the same retrieve relevant currency
      * details, but if currencies are different it is necessary
      * to first obtain the cross exchange rate between the two
      * currencies and use this to convert to appropriate
      * currency
     C     INCCY         IFEQ      OUTCCY                                       ***B001
     C                   Z-ADD     1             X
     C     INCCY         LOOKUP    XCYA(X)                                14
     C     *IN14         IFEQ      '1'                                          ***B002
     C                   MOVE      XMDA(X)       ZMDI1             1
     C                   Z-ADD     XSPA(X)       ZRATE1           13 8
     C                   Z-ADD     XDPA(X)       ZNBDP1            1 0
     C                   ELSE                                                   ***X002
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE6002  '    DBPGM
     C                   MOVE      'SDCURRL0'    DBFILE                         ************
     C                   Z-ADD     39            DBASE                          * DBERR 39 *
     C                   MOVE      INCCY         DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                    ***E002
     C                   END                                                    ***E001
      *
     C     INCCY         IFNE      OUTCCY                                       ***B001
     C                   Z-ADD     1             X
     C     INCCY         LOOKUP    XCYA(X)                                13
     C     *IN13         IFEQ      '1'                                          ***B002
     C                   MOVE      XMDA(X)       ZMDI1             1
     C                   Z-ADD     XSPA(X)       ZRATE1           13 8
     C                   Z-ADD     XDPA(X)       ZNBDP1            1 0
     C                   ELSE                                                   ***X002
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE6002  '    DBPGM
     C                   MOVE      'SDCURRL0'    DBFILE                         ************
     C                   Z-ADD     40            DBASE                          * DBERR 40 *
     C                   MOVE      INCCY         DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                    ***E002
      *
     C                   Z-ADD     1             X
     C     OUTCCY        LOOKUP    XCYA(X)                                14
     C     *IN14         IFEQ      '1'                                          ***B002
     C                   MOVE      XMDA(X)       ZMDI2             1
     C                   Z-ADD     XSPA(X)       ZRATE2           13 8
     C                   Z-ADD     XDPA(X)       ZNBDP2            1 0
     C                   ELSE                                                   ***X002
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE6002  '    DBPGM
     C                   MOVE      'SDCURRL0'    DBFILE                         ************
     C                   Z-ADD     41            DBASE                          * DBERR 41 *
     C                   MOVE      OUTCCY        DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                    ***E002
      *
      * Obtain cross exchange rate & cross multiply/divide indicator
     C                   EXSR      ZXRATE
      *
      * Set up input fields for conversion SR
     C                   Z-ADD     ZRATEX        ZEXCH            13 8
     C                   MOVE      ZMDIX         ZMD               1
      *
     C                   Z-ADD     WEAMT         ZAMTCI           15 0
     C                   MOVE      INCCY         ZCCYI             3
     C                   MOVE      OUTCCY        ZCCYO             3
     C                   Z-ADD     ZNBDP1        ZCDPI             1 0
     C                   Z-ADD     ZNBDP2        ZCDPO             1 0
      *
     C                   EXSR      ZCONV
      *
     C                   Z-ADD     ZAMTCO        WEAMT
      *
     C                   END                                                    ***E001
      *
     C                   ENDSR
      *
      ********************************************************************
      * CCYARS - SET UP AN ARRAY OF CURRENCIES AND ARRAYS OF DECIMAL
      *          PLACES,SPOT RATES AND SORT SEQ'S  FOR THOSE CURRENCIES
      *
      * Called by: MAIN PROCESSING
      * Calls    :
      ********************************************************************
      *
     C     CCYARS        BEGSR                                                  *** CCYARS  ***
      *
      * SET OFF ERROR INDICATOR
     C                   SETOFF                                       99
      *
      * SET ARRAY INDEX TO ZERO.
     C                   Z-ADD     0             X                 3 0
      *
      * SET LOWER LIMIT AND READ SDCURRL0
      *
      * LOOP TO READ CURRENCY DETAIL RECORDS.
     C     XLOOP         TAG                                                    ** XLOOP TAG **
     C                   READ      @A6REA4                                99
      *
      * END IF ALL CURRENCY RECORDS PROCESSED
     C   99              GOTO      XCAEND
      *
      * INCREMENT ARRAY INDEX.
     C     X             ADD       1             X
      *
      * MOVE DATA INTO ARRAYS.
     C                   MOVE      CCYA          XCYA(X)
     C                   MOVE      CDP           XDPA(X)
     C                   MOVE      SPOT          XSPA(X)
     C                   MOVE      MDIN          XMDA(X)
     C                   MOVE      SSNO          XSSA(X)
     C                   MOVE      ERLC          XSLA(X)
      *
      * CHECK FOR FULL ARRAY.96 ON IF FULL.
     C     X             COMP      300                                    96
      *
      * GO TO READ NEXT RECORD.
     C  N96              GOTO      XLOOP
      *
     C     XCAEND        ENDSR                                                  ** XCAEND **
      *
      ********************************************************************
      * CCYDSP - OBTAIN CURRENCY DETAILS
      *
      * Called by: MAIN PROCESSING
      * Calls    :
      ********************************************************************
      *
     C     CCYDSP        BEGSR                                                  *** CCYDSP  ***
      *
      * BLANK CURRENCY CODE IS INVALID
     C     XCCY          COMP      '   '                                  99
     C   99              GOTO      XCDEND
      *
      * SET ARRAY INDEX TO ONE
     C                   Z-ADD     1             X
      *
      * INITIALIZE INPUT-OUTPUT FIELDS.
     C                   Z-ADD     0             XDECP             1 0
     C                   Z-ADD     0             XSPOT            13 8
     C                   MOVE      'D'           XMDIN             1
     C                   Z-ADD     0             XSORT             2 0
     C                   Z-ADD     0             XSPLM            13 8
     C                   MOVE      XCCY          XCCY              3
      *
      * LOOK UP CURRENCY DETAILS
      * 99 SETON FOR INVALID CURRENCY.
     C     XCCY          LOOKUP    XCYA(X)                                95
     C   95              MOVE      XDPA(X)       XDECP
     C   95              MOVE      XSPA(X)       XSPOT
     C   95              MOVE      XMDA(X)       XMDIN
     C   95              MOVE      XSSA(X)       XSORT
     C   95              MOVE      XSLA(X)       XSPLM
     C  N95              SETON                                        99
      *
     C     XCDEND        ENDSR                                                  ** XCDEND **
      *
      ********************************************************************
      * CRYARS - SET UP AN ARRAY OF COUNTRIES AND AN ARRAY OF REGIONS
      *          FOR THOSE COUNTRIES
      *
      * Called by: MAIN PROCESSING
      * Calls    :
      ********************************************************************
      *
     C     CRYARS        BEGSR                                                  *** CRYARS  ***
      *
      * SET OFF ERROR INDICATOR
     C                   SETOFF                                       99
      *
      * SET ARRAY INDEX TO ZERO
     C                   Z-ADD     0             X                 3 0
      *
      * LOOP TO READ COUNTRY DETAIL RECORDS
     C     XREAD         TAG                                                    ** XREAD TAG **
     C                   READ      SDCTRYD0                               99
      *
      * END IF ALL COUNTRY RECORDS PROCESSED
     C   99              GOTO      XCEND
      *
      * IGNORE DELETED RECORDS
      * INCREMENT ARRAY INDEX
     C     X             ADD       1             X
      *
      * Error if number of records exceeds 400
     C     X             COMP      400                                96
     C     *IN96         IFEQ      '0'
      *
      * MOVE DATA INTO ARRAYS.
     C                   MOVE      CCOD          XCOD(X)
     C                   MOVE      REGC          XREG(X)
      *
      * CHECK FOR FULL ARRAY.96 ON IF FULL.
     C                   GOTO      XREAD
     C                   END
      *
     C     XCEND         ENDSR                                                  ** XCEND **
      *
      ********************************************************************
      * CRYDET - OBTAIN REGION FOR A COUNTRY.
      *
      * Called by: MAIN PROCESSING
      * Calls    :
      ********************************************************************
      *
     C     CRYDET        BEGSR                                                  *** CRYDET  ***
      *
      * BLANK COUNTRY CODE IS INVALID
     C     XCRY          COMP      '  '                                   99
     C   99              GOTO      XDEND
      *
      * SET ARRAY INDEX TO ONE
     C                   Z-ADD     1             X
      *
      * INITIALIZE INPUT-OUTPUT FIELDS.
     C                   MOVE      '  '          XREGN             2
     C                   MOVE      XCRY          XCRY              2
      *
      * LOOK UP REGION FOR COUNTRY.
      * 99 SETON FOR INVALID COUNTRY.
     C     XCRY          LOOKUP    XCOD(X)                                95
     C   95              MOVE      XREG(X)       XREGN
     C  N95              SETON                                        99
      *
     C     XDEND         ENDSR                                                  ** XDEND **
      *
      ********************************************************************
      * MATLOC - GET MATURITY LOCATION
      *
      * Called by: Main processing; SR's INTRST, REPAY
      ********************************************************************
      *
     C     MATLOC        BEGSR                                                  ***  MATLOC ***
      *
      * SET ON INDICATOR TO INDICATE THE ROUTINE HAS BEEN CALLED
     C                   SETON                                        77
      *
      * INITIALIZE WORKING VARIABLE - SETTLEMENT BRANCH LOCATION
     C     *LIKE         DEFINE    NRLC          W@MDSL
     C                   MOVE      *BLANKS       W@MDSL
      *
      * FOR TYPE 01,02,07,08 OR 12, SETTLEMENT LOCATION IS DETERMINED
      * BY THE NOSTRO BRANCH.
     C     MDST          IFEQ      01                                           *B1
     C     MDST          OREQ      02
     C     MDST          OREQ      07
     C     MDST          OREQ      08
     C     MDST          OREQ      12
      *
     C                   MOVEL     OMDA          SNOS              2
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      CCY           @KEYB             3
     C                   PARM      *BLANKS       @KEYC             4
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      SNOS          @KEYE             2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
      *
      * MOVE THE LAST 3 CHARACTERS OF CUSTOMER SHORT CODE (WHICH
      * IS THE LOCATION CODE) TO START LOCATION CODE FIELD
     C                   MOVE      CSNM          DSCSNM
     C                   MOVE      NRLC          W@MDSL
     C                   END
      *
     C                   END                                                    *E1
      *
     C                   ENDSR
      *
      /EJECT
      ********************************************************************
      *
      * *PSSR - HANDLE ABNORMAL ERROR CONDITIONS
      *
      ********************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR **
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INU7
     C                   MOVE      '*ERROR '     ERRCOD
      *
     C                   ENDSR                                                  ** *PSSR **
     C********************************************************************
     C/COPY ZSRSRC,ZFLACZ2ILE
     C/COPY ZSRSRC,ZFRQB3_ILE
     C/COPY ZSRSRC,ZDATE1Z2LE
     C/COPY ZSRSRC,ZDATE2Z4LE
     C/COPY ZSRSRC,ZACCHLE
     C/COPY ZSRSRC,ZFWDT_ILE
     C/COPY ZSRSRC,ZCHKHLE
     C/COPY ZSRSRC,ZBKDT_ILE
     C/COPY ZSRSRC,GLINTCZ1LE
     C/COPY ZSRSRC,ZSAVEZ1LE
     C/COPY ZSRSRC,ZRSTORZ1LE
     C/COPY ZSRSRC,ZFREQBZ2LE
      /EJECT
     C/COPY ZSRSRC,ZINTDYZ2LE
      /EJECT
     C/COPY ZSRSRC,ZDATE9Z3LE
     C/COPY ZSRSRC,ZCPDZ2ILE
     C/COPY ZSRSRC,ZDAT10Z2LE
      /EJECT
      /TITLE SR/ZCONV
     C/COPY ZSRSRC,ZCONVZ1ILE
      /TITLE SR/ZXRATEZ1LE
     C/COPY ZSRSRC,ZXRATEZ1LE
      ********************************************************************
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   POWER - ARRAY OF POWERS OF 10 FOR CURRENCY CONVERSIONS
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**   TAB1/TAB2
61V1311I
61V4282O
61I2112O
61X2112O
61R1154O
61R2144O
61V3113I
61M1232O
61M2122O
61R5110
61D1130
62V1311I
62V3113I
62V4282O
62I2112O
62X2112O
62R1154O
62R2144O
62M1232O
62M2122O
62R5110
62D1130
63V1361I
63R3425I
63R4115O
63R5475O
63V2321O
63M1262O
63D1260
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2016
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
