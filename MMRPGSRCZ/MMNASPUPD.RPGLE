     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Purchased DL Database Update')            *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMNASPUPD - NAS PURCHASED DL DATABASE UPDATE                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056655A          Date 09Oct20               *
      *  Prev Amend No. MD056655           Date 21Sep20               *
      *                 MD031031           Date 13Mar15               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025244           Date 09May14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9711            Date 26Jan06               *
      *                 CDL038             Date 10May05               *
      *                 CAS009             Date 04May04               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG6191            Date 09Mar05               *
      *                 CGL014             Date 20Oct03               *
      *                 NAD002             Date 26Mar04               *
      *                 CRE020             Date 20Jan04               *
      *                 TDA012             Date 18Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 224059             Date 30Dec02               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209895             Date 14Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 155792             Date 03Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056655A - Deal no already exists is encountered when NASP  *
      *              transaction is entered; error in SOAP exists     *
      *  MD056655 - Deal no already exists is encountered when NASP   *
      *             transaction is entered                            *
      *  MD031031 - F1DLNO missing in DLDLDnQD file for LDNI, NASP,   *
      *             NASS, FRA, CIRS and SIRS. Write to extension file *
      *             whether CLE025 is *ON or *OFF.                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD025244 - Added parameter in calling ZADLTRLRUD.            *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG6191- Validate CVMR correctly for changed status.         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  NAD002 - 10-Digit Account Code Errors                        *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  TDA012 - Fix 10-digit account code processing.               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  224059 - Error when authorising deal                         *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  209895 - No confirmation generated during amend if BLL2II    *
      *           is "Y" and settlement instructions are blanks. Make *
      *           sure that CNRQ is "Y" after settlement instructions *
      *           have been changed to certain values.                *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  155792 - Check other amended fields relevant for generation  *
      *           of an amended confirmation.  And default workfield  *
      *           @@CNRQ to 'N' to prevent a blank CNRQ in DTRIXDD.   *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FMMDELULL  UF A E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(DEALSDDF : DEALSDFF)
     FSDTIX     UF A E           K DISK
     F                                     COMMIT
     F                                     PREFIX(DX)
                                                                                              CRE020
     FREADVCL1  UF   E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
     FDLDEALNA  UF A E           K DISK                                                     MD031031
     F                                     COMMIT                                           MD031031
     FDLDEALNB  IF   E           K DISK    PREFIX(WF)                                       MD056655
     F                                     RENAME(DLDLDDD0:DLDLDDD1)                        MD056655
     F                                     RENAME(DLDLDED0:DLDLDED1)                        MD056655
      ** Deals Extension file                                                               MD031031
                                                                                              CRE020
     F/COPY WNCPYSRC,MMNASPDF01
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      *
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID NAS PURCHASED
     D MMVNAP        E DS                  EXTNAME(MMVNASPPD)
     D  @MMREC               463    531
     D  @MMPAY               532   1090
     D**@MMRECEx            1317   1334                                                CGL029 TDA012
     D**@MMPAYEx            1335   1352                                                CGL029 TDA012
     D**@MMRECEx            1332   1349                                                TDA012 NAD002
     D**@MMPAYEx            1350   1367                                                TDA012 NAD002
      *
     D/COPY WNCPYSRC,MMNASPDD01
      **  DEALS FILE - NAS PURCHASED
     D DEALS         E DS                  EXTNAME(DEALSDD)
     D  @DLREC               409    477
     D  @DLPAY               478   1036
     D**@DLRECEx            1218   1235                                                CGL029 TDA012
     D**@DLPAYEx            1236   1253                                                CGL029 TDA012
     D**@DLRECEx            1281   1298                                                TDA012 NAD002
     D**@DLPAYEx            1299   1316                                                TDA012 NAD002
      *
      **  Time data structure for DTRIX.
     D                 DS
     D  @XTIME                 1      6  0
     D  DXTIM                  1      4  0
      *
      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** DATA STRUCTURE FOR BANK DETAILS

     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** External DS for TRADE Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                              CAS001
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS001
     D                                     PREFIX(S_)                                         CAS001
      ** External DS for SAR Details                                                          CAS001
                                                                                              CAS001
      ** Define fields used in CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
     D PRTCD           S              7A                                                      CAS001
     D POPTN           S              7A                                                      CAS001
     D PSARD           S              6A                                                      CAS001

      ** Define fields used in CAS005                                                         CAS005
                                                                                              CAS005
     D CAS005          S              1A                                                      CAS005
     D WNTR            S             11  7                                                    224059
     D WTOTI           S             15  0                                                    224059
                                                                                              CAS005
      ** CRE020 Variables                                                                     CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('MMNASPUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('NAsPurchased        ')                        CRE020
     D PCurSet01       S            200A                                                      CRE020
     D PSysVal02       S             20A                                                      CRE020
     D PCurSet02       S            200A                                                      CRE020
     D PSysVal03       S             20A                                                      CRE020
     D PCurSet03       S            200A                                                      CRE020
     D PSysVal04       S             20A                                                      CRE020
     D PCurSet04       S            200A                                                      CRE020
     D PSysVal05       S             20A                                                      CRE020
     D PCurSet05       S            200A                                                      CRE020
     D PSysVal06       S             20A                                                      CRE020
     D PCurSet06       S            200A                                                      CRE020
     D PSysVal07       S             20A                                                      CRE020
     D PCurSet07       S            200A                                                      CRE020
     D PSysVal08       S             20A                                                      CRE020
     D PCurSet08       S            200A                                                      CRE020
     D PSysVal09       S             20A                                                      CRE020
     D PCurSet09       S            200A                                                      CRE020
     D PSysVal10       S             20A                                                      CRE020
     D PCurSet10       S            200A                                                      CRE020
     D WSysVal01       S              1A                                                      CRE020
     D WEvent          S              8A                                                      CRE020
     D WNew            S              1A                                                      CRE020
                                                                                              CRE020
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
      *
      * EXIT IF NOT INSERTION, AMENDMENT OR REVERSAL
      *
     C     IHCHTP        IFNE      'I'
     C     IHCHTP        ANDNE     'A'
     C     IHCHTP        ANDNE     'R'
     C                   RETURN
     C                   END
      *
     C/COPY WNCPYSRC,MMNASPDC06
      * INSERT, AMEND, OR REVERSE THE DEAL
      *
     C     IHCHTP        CASEQ     'I'           NAPINS
     C     IHCHTP        CASEQ     'A'           NAPAMD
     C     IHCHTP        CASEQ     'R'           NAPDEL
     C                   END
      *
      * SET PAY/RECEIVE INDICATORS TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      PYRCIN
      *
      * WRITE A DTRIX RECORD
      *
     C                   EXSR      WRTDTX
      *
      * UPDATE THE DTRIX HEADER RECORD
      *
     C                   EXSR      UPDDTH
      *
      ** UPDATE THE DEALS FILE TRAILER
      ** ON INSERTS AND REVERSALS
      *
     C     IHCHTP        IFEQ      'I'
     C     IHCHTP        OREQ      'R'
     C                   EXSR      UPDTRL
     C                   END
      *
      * EXIT FROM PROGRAM
      *
     C                   RETURN
     C****************************************************************
      /EJECT
     C/COPY WNCPYSRC,MMNASPDC01
     C****************************************************************
     C*                                                              *
     C* NAPINS - INSERT AN NA PURCHASED                              *
     C*                                                              *
     C****************************************************************
     C     NAPINS        BEGSR
      *
      * SET CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      CNFINS
      *
      * INITIALIZE DEAL
      *
     C                   CLEAR                   DEALS
      *
      * RECORD ID
      *
     C                   MOVEL     'D'           RECI
      *
      * DEAL NUMBER & RECORD TYPE
      *
     C                   Z-ADD     IHDN38        DLNO
     C                   MOVE      'D'           RCDT
      *
      * DEAL RECORD CODE
      *
     C                   Z-ADD     17            RCDC
      *
      *  ISSUED BY CUSTOMER
      *
     C**********         Z-ADD     IHISCN        ISCN                                         CSD027
     C                   EVAL      ISCN = IHISCN                                              CSD027
      *
      * BRANCH
     C                   MOVEL     IHBRCA        BRCA
      *
      * DEAL TYPE
     C                   MOVE      IHMTYP        DTYP
      *
      * DEAL SUB-TYPE
     C                   MOVE      IHSTYP        DLST
      *
      * DEAL DATE
     C                   Z-ADD     IHDDND        DDAT
      *
      * VALUE DATE
     C                   Z-ADD     IHDVSD        VDAT
      *
      * MATURITY DATE
     C                   Z-ADD     IHMATD        MDAT
      *
      * ACCOUNT SEQUENCE
     C                   Z-ADD     IHACSQ        IDAS
      *
      * BROKER CODE
     C                   MOVE      IHBKCD        BRKC
      *
      * BROKERAGE
     C     IHBRKG        IFEQ      *ALL'9'
     C                   Z-ADD     0             BAGE
     C                   ELSE
     C                   Z-ADD     IHBRKG        BAGE
     C                   END
      *
      * CURRENCY
     C                   MOVE      IHCCY         CCY
      *
      * PURCHASE PRICE
      *
     C     IHAMNP        IFLT      *ZERO
     C                   Z-SUB     IHAMNP        PUPR
     C                   ELSE
     C                   Z-ADD     IHAMNP        PUPR
     C                   END
      *
      * YIELD RATE
     C     IHMTYP        IFEQ      'C1'
     C     IHMTYP        OREQ      'C2'
     C     IHMTYP        OREQ      'BP'
     C     IHMTYP        OREQ      'BD'
     C                   Z-ADD     IHINTR        YRAT
     C                   ELSE
     C                   Z-ADD     IHDCRT        YRAT
     C                   END
      *
      * RATE/SPREAD
     C                   Z-ADD     IHFRAT        RTSP
      *
      * INTEREST RATE
     C                   Z-ADD     IHFRAT        INTR
      *
      * REF.NO. OF NA
     C                   MOVE      IHCDRF        RNNA
      *
      * CUSTOMER NA BOUGHT FROM
     C**********         Z-ADD     IHCNUM        CNUM                                         CSD027
     C                   EVAL      CNUM = IHCNUM                                              CSD027
      *
      * FACILITY TYPE
     C                   MOVEL     IHFCLY        FACT
      *
      * FACILITY NUMBER
     C                   MOVE      IHFCLY        FCNO
      *
      * FACE VALUE
     C                   Z-ADD     IHFVAL        FVAL
      *
      * BASE CCY EXCHANGE RATE
     C                   Z-ADD     IHBRAT        BCXR
      *
      * ACCESS DEAL CURRENCY DETAILS
      *
     C                   EXSR      ACSDCY
      *
      * LIMIT CCY EXCHANGE RATE
     C                   Z-ADD     A6ERLC        LCXR
      *
      * START & MATURITY DATE INSTRUCTIONS
      *
     C                   Z-ADD     IHMOPM        SDST
     C                   MOVE      IHMOPI        OSDA
     C                   MOVE      IHMCRI        TSTN
     C                   Z-ADD     IHORCM        MDST
     C                   MOVE      IHMORI        OMDA
     C                   MOVE      IHMCPI        TMAN
      *
      ** Bill Depot ID
     C     IHMTYP        IFEQ      'TB'
     C*****              Z-ADD     IHBDID        BDID                                         CSD027
     C                   MOVEL     IHBDID        BDID                                         CSD027
     C                   ELSE
     C*****              Z-ADD     *ZEROS        BDID                                         CSD027
     C                   MOVEL     *BLANKS       BDID                                         CSD027
     C                   END
      *
      * DISCOUNT AMOUNT
     C                   Z-ADD     IHDCAM        DISA
     C                   Z-ADD     IHDCAM        DSAM                                         CAS009
      *
      * DISCOUNT POSTED
     C                   Z-ADD     *ZERO         DPTD
      *
      * INTEREST CALC BASIS
     C                   MOVE      IHICMT        ICBS
      *
      * INTEREST PAY FREQUENCY
     C                   MOVE      IHIPFQ        IPFR
      *
      * TOTAL INTEREST
     C                   Z-ADD     IHMTTI        TOTI
     C                   Z-ADD     0             FSTOTN                                       224059
     C                   IF        CAS005 = 'Y'                                               224059
     C     TOTI          IFNE      0                                                          224059
     C     IHLQPS        IFEQ      '+'                                                        224059
     C                   EVAL      WNTR = IHINTR + IHLQPR                                     224059
     C                   ELSE                                                                 224059
     C                   EVAL      WNTR = IHINTR - IHLQPR                                     224059
     C                   ENDIF                                                                224059
     C     TOTI          DIV       IHINTR        WTOTI                                        224059
     C     WTOTI         MULT      WNTR          IHTNTR                                       224059
                                                                                              224059
     C                   Z-ADD     IHTNTR        FSTOTN                                       CAS005
     C                   ENDIF                                                                224059
     C                   ENDIF                                                                224059
      *
      * NEXT INT PAY DATE
     C                   Z-ADD     IHNIPD        NIDT
      *
      * INT. BASE DATE
     C                   Z-ADD     IHNIPD        IBDT
      *
      * START/LAST INT DATE
     C     IHMTYP        IFEQ      'C1'
     C                   Z-ADD     IHDVSD        SLID
     C                   ELSE
     C                   Z-ADD     IHSLID        SLID
     C                   END
      *
      * INTEREST ACCRUAL FIELDS
      *
     C                   Z-ADD     *ZERO         AIPD
     C                   Z-ADD     *ZERO         DLRC
     C                   Z-ADD     IHDVSD        IACD
     C                   Z-ADD     *ZERO         AITC
     C                   Z-ADD     *ZERO         AIAN
     C                   Z-ADD     *ZERO         AIAP
     C                   Z-ADD     *ZERO         IPRD
     C                   Z-ADD     *ZERO         IPRM
      *
      * CALCULATE INTEREST DIFFERENCE, AND PUT IT IN AIAN
      *
     C     IHMTYP        IFEQ      'C2'
     C     IHMTYP        OREQ      'BP'
     C     IHMTYP        OREQ      'BD'
     C                   EXSR      CALIDF
     C                   END
      *
      * SALE PRICE
     C                   Z-ADD     *ZERO         SAPR
      *
      * ASSET SALE DEAL NO & SALE DATE
     C                   Z-ADD     *ZERO         ASDN
     C                   Z-ADD     *ZERO         SADT
      *
      * DEAL AMEND VALUE DATE & SEQ
      *
     C                   Z-ADD     *ZERO         DAVD
     C                   Z-ADD     *ZERO         DASN
      *
      * FOR A/C OF & SPECIAL INSTRUCTIONS
      *
     C                   MOVE      IHMFAO        FACO
     C                   MOVE      IHSPEC        SPI
      *
      * INT.DAY IN MONTH
     C                   Z-ADD     IHIPDM        INTF
      *
      * MULT/DIVIDE IND.
     C                   MOVE      IHMMDI        MDBX
      *
      * PURCHASED INTEREST
     C                   Z-ADD     IHMPIT        PINT1
      *
      ** INITIALIZE BITS for static and non static indicators.
      *
     C                   BITOFF    '01234567'    DNSI
     C                   BITOFF    '01234567'    DSTI
     C                   BITOFF    '01234567'    CNFI
     C                   BITOFF    '01234567'    ACEI
     C                   BITOFF    '01234567'    TLXI
      *
      * NON-STATIC BIT
      *
     C                   BITON     '0'           DNSI
      *
      * NON-STATIC BIT = TOTAL INTEREST OVERRIDE
      *
     C     IHMTYP        IFNE      'C1'
     C                   BITON     '2'           DNSI
     C                   END
      *
      * STATIC BIT = BROKERAGE IS ZERO WITH BROKER
      *
     C     IHBKCD        IFNE      'TELX'
     C     IHBKCD        ANDNE     'MAIL'
     C     IHBKCD        ANDNE     'PHON'
     C     IHBKCD        ANDNE     *BLANK
     C     IHBRKG        IFEQ      *ALL'9'
     C                   BITON     '0'           DSTI
     C                   END
     C                   END
      *
      * STATIC BIT = FEDERAL FUNDS
      *
     C     IHFEDF        IFEQ      'Y'
     C     IHCCY         ANDEQ     BLUSCY
     C                   BITON     '3'           DSTI
     C                   END
      *
      * LAST SWIFT SEQUENCES
      *
     C                   Z-ADD     *ZERO         LSWC
     C                   Z-ADD     *ZERO         LSWS
      *
      * ORIGINAL ENTRY DATE, LAST CHANGE DATE & LAST CHANGE TYPE
      *
     C                   Z-ADD     BJRDNB        ORED
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      IHCHTP        CHTP
     C                   Z-ADD     *ZERO         TNLU
      *
      ** BOOK CODE
     C                   MOVE      IHBOKC        BOKC
      *
      ** LINKED DEAL NUMBER
     C                   MOVE      IHLNKN        LNKDN
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMREC        @DLREC
     C                   MOVEL     IHRONS        RONS                                         NAD002
     C**********         MOVEL     @MMRECEx      @DLRECEx                              CGL029 NAD002
      *
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMPAY        @DLPAY
     C                   MOVEL     IHPONS        PONS                                         NAD002
     C**********         MOVEL     @MMPAYEx      @DLPAYEx                              CGL029 NAD002
      *
      * ORIGINATING BRANCH
     C                   MOVEL     IHORBR        ORBR
      *
      * PROFIT CENTRE
     C                   MOVEL     IHPRFC        PRFC
      *
      * OUR REC & PAY SETTLEMENT BRANCHES
      *
     C                   MOVEL     IHROBR        ROBR
     C                   MOVEL     IHPOBR        POBR
      *
      * COVER MESSAGE REQUIRED
      *
     C     IHCVMR        IFNE      'Y'
     C                   MOVE      'N'           CVMR
     C                   ELSE
     C                   MOVE      'Y'           CVMR
     C                   END
      *
      * ROUND DOWN INT
      *
     C                   MOVEL     IHRDFC        JRDFC
      *
      ** Setup parcel fields
      *
     C                   Z-ADD     IHPSZE        NSDD
     C                   MOVE      IHPCLI        PCLI
     C                   Z-ADD     IHPSZE        PSZE
     C                   Z-ADD     IHOPUP        OPUP
     C                   Z-ADD     *ZERO         NSLD
      *
      **  Set up funding information fields
      *
     C                   Z-ADD     IHFSRP        FSRP
     C                   MOVE      IHFSGN        FSGN
     C                   MOVE      IHFPRC        FPRC
     C                   Z-ADD     0             TCOF
     C                   Z-ADD     0             ACPD
     C                   Z-ADD     0             ACDA
     C                   Z-ADD     0             ACAP
     C                   Z-ADD     0             ACAN
     C                   Z-ADD     0             COFD
     C                   Z-ADD     0             COFM
      *
      * Calculate total cost of funds for primary CDs, and put it in TCOF
      *
     C     IHMTYP        IFEQ      'C1'
     C                   EXSR      CALTCOF
     C                   END
      *
      * Calculate if any funding interest difference, and put it in ACAN
      *
     C     IHMTYP        IFEQ      'C2'
     C     IHMTYP        OREQ      'BP'
     C     IHMTYP        OREQ      'BD'
     C                   EXSR      CALIDFFND
     C                   END
      *
      ** EMU Settlement fields
      *
     C                   MOVEL     IHSTCY        STCY
     C                   MOVEL     IHIC72        IC72
                                                                                              CAS001
      ** Yield Curves                                                                         CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                   EVAL      FSOYLC = IHOYLC                                            CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
      ** Liquidity Premium                                                                    CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSLQPR = IHLQPR                                            CAS005
     C                   EVAL      FSLQPS = IHLQPS                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CDL038
      **  Class                                                                               CDL038
     C                   MOVE      IHCLAS        CLAS                                         CDL038
      **  Reference Rate                                                                      CDL049
     C                   MOVE      IHRRAT        FSRRAT                                       CDL049
      *
     C/COPY WNCPYSRC,MMNASPDC02
      * WRITE DEAL
      *
     C                   WRITE     DEALSDDF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C     PSJobName     IFNE      'QZDASOINIT'                                            MD056655A
     C     PSJobName     ANDNE     'QZDASSINIT'                                            MD056655A
     C                   MOVEL     DLNO          PDLNO             6                        MD056655
     C     PDLNO         CHAIN     DLDLDDD1                           75                    MD056655
     C                   IF        *IN75 = *ON                                              MD056655
     C                   MOVE      DLNO          F1DLNO                                     MD031031
     C                   Eval      F1BRCA = BRCA                                            MD031031
     C                   WRITE     DLDLDDD0                                                 MD031031
     C                   ENDIF                                                              MD056655
     C                   ENDIF                                                             MD056655A
     C/COPY WNCPYSRC,MMNASPDC13
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* NAPAMD - AMEND AN NA PURCHASED                               *
     C*                                                              *
     C****************************************************************
     C     NAPAMD        BEGSR
      *
      * ACCESS DEAL
      *
     C     IHDN38        CHAIN     DEALSDDF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IHDN38        DBKEY
     C                   MOVEL     'DEALSDD '    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * SET CONFIRMATION BIT ON DEAL
      * AND CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      CNFAMD
      *
      *  ISSUED BY CUSTOMER
      *
     C**********         Z-ADD     IHISCN        ISCN                                         CSD027
     C                   EVAL      ISCN = IHISCN                                              CSD027
      *
      * BRANCH
     C                   MOVEL     IHBRCA        BRCA
      *
      * DEAL SUB-TYPE
     C                   MOVE      IHSTYP        DLST
      *
      * ACCOUNT SEQUENCE
     C                   Z-ADD     IHACSQ        IDAS
      *
      * BROKER CODE
     C                   MOVE      IHBKCD        BRKC
      *
      * BROKERAGE
     C     IHBRKG        IFEQ      *ALL'9'
     C                   Z-ADD     0             BAGE
     C                   ELSE
     C                   Z-ADD     IHBRKG        BAGE
     C                   END
      *
      * REF.NO. OF NA
     C                   MOVE      IHCDRF        RNNA
      *
      * CUSTOMER NA BOUGHT FROM
     C**********         Z-ADD     IHCNUM        CNUM                                         CSD027
     C                   EVAL      CNUM = IHCNUM                                              CSD027
      *
      * FACILITY TYPE
     C                   MOVEL     IHFCLY        FACT
      *
      * FACILITY NUMBER
     C                   MOVE      IHFCLY        FCNO
      *
      * START & MATURITY DATE INSTRUCTIONS
      *
     C                   Z-ADD     IHMOPM        SDST
     C                   MOVE      IHMOPI        OSDA
     C                   MOVE      IHMCRI        TSTN
     C                   Z-ADD     IHORCM        MDST
     C                   MOVE      IHMORI        OMDA
     C                   MOVE      IHMCPI        TMAN
      *
      ** Bill Depot ID
     C     IHMTYP        IFEQ      'TB'
     C*****              Z-ADD     IHBDID        BDID                                         CSD027
     C                   MOVEL     IHBDID        BDID                                         CSD027
     C                   ELSE
     C*****              Z-ADD     *ZEROS        BDID                                         CSD027
     C                   MOVE      *BLANKS       BDID                                         CSD027
     C                   END
      *
      * INTEREST PAY FREQUENCY
     C                   MOVE      IHIPFQ        IPFR
      *
      * If interest date has been changed, update interest base date
      * also and reset telex ind bit 2
      *
     C     IHNIPD        IFNE      NIDT
     C                   Z-ADD     IHNIPD        NIDT
     C                   Z-ADD     IHNIPD        IBDT
     C                   BITOFF    '2'           TLXI
     C                   END
      *
      * FOR A/C OF & SPECIAL INSTRUCTIONS
      *
     C                   MOVE      IHMFAO        FACO
     C                   MOVE      IHSPEC        SPI
      *
      * INT.DAY IN MONTH
     C                   Z-ADD     IHIPDM        INTF
      *
      * STATIC BIT = FEDERAL FUNDS
      *
     C     IHFEDF        IFEQ      'Y'
     C     IHCCY         ANDEQ     BLUSCY
     C                   BITON     '3'           DSTI
     C                   ELSE
     C                   BITOFF    '3'           DSTI
     C                   END
      *
      * LAST CHANGE DATE & LAST CHANGE TYPE
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      IHCHTP        CHTP
     C                   Z-ADD     *ZERO         TNLU
      *
      ** BOOK CODE
     C                   MOVE      IHBOKC        BOKC
      *
      ** LINKED DEAL NUMBER
     C                   MOVE      IHLNKN        LNKDN
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMREC        @DLREC
     C                   MOVEL     IHRONS        RONS                                         NAD002
     C**********         MOVEL     @MMRECEx      @DLRECEx                              CGL029 NAD002
      *
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMPAY        @DLPAY
     C                   MOVEL     IHPONS        PONS                                         NAD002
     C**********         MOVEL     @MMPAYEx      @DLPAYEx                              CGL029 NAD002
      *
      * ORIGINATING BRANCH
     C                   MOVEL     IHORBR        ORBR
      *
      * PROFIT CENTRE
     C                   MOVEL     IHPRFC        PRFC
      *
      * OUR REC & PAY SETTLEMENT BRANCHES
      *
     C                   MOVEL     IHROBR        ROBR
     C                   MOVEL     IHPOBR        POBR
      *
      * COVER MESSAGE REQUIRED
      *
     C     IHCVMR        IFNE      'Y'
     C                   MOVE      'N'           CVMR
     C                   ELSE
     C                   MOVE      'Y'           CVMR
     C                   END
      *
      **  Set up funding information fields
      *
     C                   Z-ADD     IHFSRP        FSRP
     C                   MOVE      IHFSGN        FSGN
     C                   MOVE      IHFPRC        FPRC
      *
      * Calculate total cost of funds for primary CDs, and put it in TCOF
      *
     C     IHMTYP        IFEQ      'C1'
     C                   EXSR      CALTCOF
     C                   END
      *
      * Calculate if any funding interest difference, and put it in ACAN
      *
     C     IHMTYP        IFEQ      'C2'
     C     IHMTYP        OREQ      'BP'
     C     IHMTYP        OREQ      'BD'
     C                   EXSR      CALIDFFND
     C                   END
      *
      ** EMU Settlement fields
      *
     C                   MOVEL     IHSTCY        STCY
     C                   MOVEL     IHIC72        IC72
                                                                                              CAS001
      ** Yield Curves                                                                         CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                   EVAL      FSOYLC = IHOYLC                                            CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
      ** Liquidity Premium                                                                    CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSLQPR = IHLQPR                                            CAS005
     C                   EVAL      FSLQPS = IHLQPS                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CDL038
      **  Class                                                                               CDL038
     C                   MOVE      IHCLAS        CLAS                                         CDL038
      **  Reference Rate                                                                      CDL049
     C                   MOVE      IHRRAT        FSRRAT                                       CDL049
      *
     C/COPY WNCPYSRC,MMNASPDC03
      * UPDATE DEAL
      *
     C                   UPDATE    DEALSDDF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C/COPY WNCPYSRC,MMNASPDC14
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* NAPDEL - DELETE AN NA PURCHASED                              *
     C*                                                              *
     C****************************************************************
     C     NAPDEL        BEGSR
      *
      * ACCESS DEAL
      *
     C     IHDN38        CHAIN     DEALSDDF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IHDN38        DBKEY
     C                   MOVEL     'DEALSDD '    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * SET CONFIRMATION BIT ON DEAL
      * AND CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      CNFDEL
      *
      * SET RECORD ID TO 'REVERSED'
      *
     C                   MOVE      'R'           RECI
      *
      ** LAST CHANGE DATE & TYPE
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'R'           CHTP
      *
     C/COPY WNCPYSRC,MMNASPDC04
     C                   UPDATE    DEALSDDF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C/COPY WNCPYSRC,MMNASPDC15
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* PYRCIN - DETERMINE PAY/RECEIVE INDICATORS                    *
     C*                                                              *
     C****************************************************************
     C     PYRCIN        BEGSR
      *
     C                   Z-ADD     *ZERO         @@PRI1            1 0
     C                   Z-ADD     *ZERO         @@PRI2            1 0
     C                   Z-ADD     *ZERO         @@PRI3            1 0
      *
      * PAY/RECEIVE INDICATOR 1 = VALUE DATE
      * ------------------------------------
      *
      ** Determine if local or deal currency to be used
      ** in holiday checking
      *
     C                   MOVEL     'L'           @DLOLC
     C                   MOVEL     *BLANK        @NOSTR
      *
     C     IHPSTM        IFEQ      01
     C     IHPSTM        OREQ      07
     C     IHPSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IHPONS        @NOSTR
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI1 if value date is within telex notice period
      *
     C     IHDVSD        IFGE      BJRDNB
     C     IHDVSD        ANDLE     @TLXDU
     C/COPY WNCPYSRC,MMNASPDC08
     C                   Z-ADD     1             @@PRI1
     C                   END
      *
      ** PAY/RECEIVE INDICATOR 2 = INTEREST PAY DATE
      *  -------------------------------------------
      *
      ** Determine if local or deal currency to be used
      ** in holiday checking
      *
     C                   MOVEL     'L'           @DLOLC
     C                   MOVEL     *BLANK        @NOSTR
      *
     C     IHRSTM        IFEQ      01
     C     IHRSTM        OREQ      07
     C     IHRSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IHRONS        @NOSTR
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C/COPY WNCPYSRC,MMNASPDC09
     C                   EXSR      TLXDUE
     C/COPY WNCPYSRC,MMNASPDC10
      *
      * Set PRI2 if interest pay date is within telex notice period
      *
     C     IHNIPD        IFNE      *ZERO
     C     IHNIPD        ANDGE     BJRDNB
     C     IHNIPD        ANDLE     @TLXDU
     C/COPY WNCPYSRC,MMNASPDC11
     C                   Z-ADD     1             @@PRI2
     C                   END
      *
      ** PAY/RECEIVE INDICATOR 3 = MATURITY DATE
      *  ---------------------------------------
      *
      ** Determine if local or deal currency to be used
      ** in holiday checking
      *
     C                   MOVEL     'L'           @DLOLC
     C                   MOVEL     *BLANK        @NOSTR
      *
     C     IHRSTM        IFEQ      01
     C     IHRSTM        OREQ      07
     C     IHRSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IHRONS        @NOSTR
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI3 if maturity date is within telex notice period
      *
     C     IHMATD        IFGE      BJRDNB
     C     IHMATD        ANDLE     @TLXDU
     C/COPY WNCPYSRC,MMNASPDC12
     C                   Z-ADD     1             @@PRI3
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFINS - SET CONFIRMATION INDICATOR ON INSERTION             *
     C*                                                              *
     C****************************************************************
     C     CNFINS        BEGSR
      *
     C                   MOVE      'N'           @@CNRQ            1
      *
      *
      * CONFIRMATION REQUIRED IF SETTLEMENT INSTRUCTIONS PRESENT
      * OR IF 2 LEVEL INPUT NOT PRESENT
      *
     C     IHRSTM        IFNE      *ZERO
     C     IHPSTM        ORNE      *ZERO
     C     BLL2II        OREQ      'N'
     C                   MOVE      'Y'           @@CNRQ
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFAMD - SET CONFIRMATION INDICATOR ON AMENDMENT             *
     C*                                                              *
     C****************************************************************
     C     CNFAMD        BEGSR
      *                                                                                       155792
     C                   MOVE      'N'           @@CNRQ                                       155792
      *
      * IF SETTLEMENT INSTRUCTIONS WERE PREVIOUSLY PRESENT
      * OR IF 2 LEVEL INPUT NOT PRESENT
      *
     C     RSTM          IFNE      *ZERO
     C     PSTM          ORNE      *ZERO
     C     IHRSTM        ORNE      *ZERO                                                      209895
     C     IHPSTM        ORNE      *ZERO                                                      209895
     C     BLL2II        OREQ      'N'
      *
      ** If settlement instruction fields have changed
      *
     C     RSTM          IFNE      IHRSTM
     C     RONS          ORNE      IHRONS
     C     RIBN          ORNE      IHRIBN
     C     RIBA          ORNE      IHRIBA                                                     155792
     C     ROBN          ORNE      IHROBN                                                     155792
     C     ROCN          ORNE      IHROCN                                                     155792
     C     PSTM          ORNE      IHPSTM
     C     PONS          ORNE      IHPONS
     C     PIBN          ORNE      IHPIBN                                                     155792
     C     PIBA          ORNE      IHPIBA                                                     155792
     C     POBN          ORNE      IHPOBN                                                     155792
     C     POCN          ORNE      IHPOCN                                                     155792
     C     RCRN          ORNE      IHRCRN                                                     155792
     C     RCRA          ORNE      IHRCRA                                                     155792
     C     RVNO          ORNE      IHRVNO                                                     155792
     C     AWBN          ORNE      IHAWBN
     C     AWBA          ORNE      IHAWBA                                                     155792
     C     BENN          ORNE      IHBENN
     C     BENA          ORNE      IHBENA                                                     155792
     C     DTP1          ORNE      IHDTP1                                                     155792
     C     DTP2          ORNE      IHDTP2                                                     155792
     C     DTP3          ORNE      IHDTP3                                                     155792
     C     DTP4          ORNE      IHDTP4                                                     155792
     C     DCHG          ORNE      IHDCHG                                                     155792
     C     BTB1          ORNE      IHBTB1
     C     BTB2          ORNE      IHBTB2                                                     155792
     C     BTB3          ORNE      IHBTB3                                                     155792
     C     BTB4          ORNE      IHBTB4                                                     155792
     C     BTB5          ORNE      IHBTB5                                                     155792
     C     BTB6          ORNE      IHBTB6                                                     155792
     C*****CVMR*         ORNE      IHCVMR                                             155792 BUG6191
     C     CVMR          OREQ      'Y'                                                       BUG6191
     C     IHCVMR        ANDNE     'Y'                                                       BUG6191
     C     CVMR          OREQ      'N'                                                       BUG6191
     C     IHCVMR        ANDNE     'N'                                                       BUG6191
     C     IHCVMR        ANDNE     ' '                                                       BUG6191
     C     STCY          ORNE      IHSTCY                                                     155792
     C     IC72          ORNE      IHIC72                                                     155792
      *
      ** or if deal contract fields have changed
      *
     C     NIDT          ORNE      IHNIPD
     C     IPFR          ORNE      IHIPFQ
     C     INTF          ORNE      IHIPDM
     C     FSOYLC        ORNE      IHOYLC                                                     CAS001
     C     CAS001        ANDEQ     'Y'                                                        CAS001
     C     FSLQPR        ORNE      IHLQPR                                                     CAS005
     C     FSLQPS        ANDNE     IHLQPS                                                     CAS005
     C     CAS005        ANDEQ     'Y'                                                        CAS005
      *
      ** Produce a confirmation now
      *
     C                   BITOFF    '0'           CNFI
     C                   MOVE      'Y'           @@CNRQ
      *
      * Set off maturity and interest indicators if past value date
      *
     C     ORED          IFLT      BJRDNB
     C     VDAT          ANDLT     BJRDNB
     C                   BITOFF    '12'          CNFI
     C                   END
      *
     C                   END
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFDEL - SET CONFIRMATION INDICATOR ON DELETION              *
     C*                                                              *
     C****************************************************************
     C     CNFDEL        BEGSR
      *                                                                                       155792
     C                   MOVE      'N'           @@CNRQ                                       155792
      *
      * CONFIRMATION REQUIRED IF ONE PRODUCED PREVIOUSLY
      *
     C                   TESTB     '7'           CNFI                     99
     C     *IN99         IFEQ      '1'
     C                   BITOFF    '0'           CNFI
     C                   MOVE      'Y'           @@CNRQ
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* WRTDTX - WRITE A DTRIX RECORD                                *
     C*                                                              *
     C****************************************************************
     C     WRTDTX        BEGSR
      *
      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD
      *
     C                   MOVE      'D'           DXRECI
     C                   MOVE      'D'           DXRCDT
     C                   Z-ADD     IHDN38        DXDLNO
     C                   Z-ADD     *ZERO         DXVDAT
     C                   Z-ADD     *ZERO         DXDASN
     C                   MOVE      IHCHTP        DXCHTP
     C                   MOVE      @@CNRQ        DXCNRQ
     C                   MOVE      'N'           DXCNPR
     C                   MOVE      ' '           DXREPR
     C                   TIME                    @XTIME
     C                   MOVE      @@PRI1        DXPRI1
     C                   MOVE      @@PRI2        DXPRI2
     C                   MOVE      @@PRI3        DXPRI3
     C                   Z-ADD     0             DXICIN
     C                   MOVEL     IHBRCA        DXBRCA
     C                   Z-ADD     *ZERO         DXTNLU
     C*
     C                   WRITE     DTRIXDF
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDDTH - UPDATE THE DTRIX HEADER RECORD                      *
     C*                                                              *
     C****************************************************************
     C     UPDDTH        BEGSR
      *
      ** Access the header record
      *
     C                   Z-ADD     *ZERO         DXDLNO
     C     DXDLNO        CHAIN     DTRIXHF                            99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     DXDLNO        DBKEY
     C                   MOVEL     'DTRIXHF '    DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * Add 1 to number of deal records (on DTRIXDD)
      *
     C                   ADD       1             DXNDLR
      *
     C                   UPDATE    DTRIXHF
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDTRL- UPDATE THE DEALS FILE TRAILER                        *
     C*                                                              *
     C****************************************************************
     C     UPDTRL        BEGSR
      *
     C                   MOVE      *BLANKS       EAPIC            10                        MD025244
      *                                                                                     MD025244
     C                   CALLB     'ZADLTRLRUD'
      *
      ** Return Code
     C                   PARM      *BLANKS       @@RTCD            7
      *
      ** Change Type
     C                   PARM      IHCHTP        @@CHTP            1
      *
      ** Amount
     C                   PARM      IHAMNP        @@AMNP           15 0
      *
      ** Run Date
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    EAPIC                                      MD025244
      *
      ** DATABASE ERROR
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C                   MOVEL     '999999'      DBKEY
     C                   MOVEL     'DEALSDF '    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* TLXDUE - DETERMINE TELEX DUE DATE                            *
     C*                                                              *
     C****************************************************************
     C     TLXDUE        BEGSR
      *
      * EFFECTIVE SETTLEMENT CURRENCY
      *
     C     IHSTCY        IFNE      *BLANKS
     C                   MOVEL     IHSTCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     IHCCY         EffSetCcy         3
     C                   ENDIF
      *
     C                   CALLB     'ZATLXDUEDT'
      *
      ** Deal or local Currency
     C                   PARM                    @DLOLC            1
      *
      ** Currency
     C                   PARM      EffSetCcy     @CCY              3
      *
      ** Nostro
     C                   PARM                    @NOSTR            2
      *
      ** Date of Next Working Day
     C                   PARM                    BJDNWD            5 0
      *
      ** Local Currency
     C                   PARM                    BJLCCY            3
      *
      ** System Location
     C                   PARM                    BJSLCD            3
      *
      ** Telex Due Date
     C                   PARM      *ZERO         @TLXDU            5 0
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CALIDF - CALCULATE INTEREST DIFFERENCE                       *
     C*                                                              *
     C****************************************************************
     C     CALIDF        BEGSR
     C*
     C* START DATE = LAST INT PAY DATE, END DATE = NEXT INT PAY DATE
     C*
     C                   Z-ADD     SLID          @@BEG
     C                   Z-ADD     NIDT          @@END
     C     @@END         IFEQ      *ZERO
     C                   Z-ADD     MDAT          @@END
     C                   END
     C*
     C* PRINCIPAL, RATE, CALCULATION METHOD, ROUND DOWN INTEREST
     C*
     C                   Z-ADD     IHFVAL        @@AMT            15 0
     C                   Z-ADD     IHFRAT        @@RATE           11 7
     C                   MOVEL     IHICMT        @@CALC            1
     C                   MOVEL     IHRDFC        @@RDFC            1
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG             5 0
     C                   PARM                    @@END             5 0
     C                   PARM                    @@CALC            1
     C                   PARM                    @@AMT            15 0
     C                   PARM                    @@RATE           11 7
     C                   PARM                    @@RDFC            1
     C                   PARM      *ZERO         @@INTR           15 0
     C*
     C* CALCULATE INTEREST FROM VALUE DATE TO MATURITY DATE
     C*
     C                   Z-ADD     @@INTR        AIAN
     C*
     C* CALCULATE INTEREST FROM LAST INT PAY DATE TO VALUE DATE
     C*
     C                   Z-ADD     SLID          @@BEG
     C                   Z-ADD     VDAT          @@END
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG
     C                   PARM                    @@END
     C                   PARM                    @@CALC
     C                   PARM                    @@AMT
     C                   PARM                    @@RATE
     C                   PARM                    @@RDFC
     C                   PARM      *ZERO         @@INTR
      *
     C                   SUB       @@INTR        AIAN
     C*
     C* CALCULATE INTEREST FROM VALUE DATE TO NEXT INT PAY DATE
     C*
     C                   Z-ADD     VDAT          @@BEG
     C                   Z-ADD     NIDT          @@END
     C     @@END         IFEQ      *ZERO
     C                   Z-ADD     MDAT          @@END
     C                   END
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG
     C                   PARM                    @@END
     C                   PARM                    @@CALC
     C                   PARM                    @@AMT
     C                   PARM                    @@RATE
     C                   PARM                    @@RDFC
     C                   PARM      *ZERO         @@INTR
      *
     C                   SUB       @@INTR        AIAN
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CALIDFFND - CALCULATE FUNDING INTEREST DIFFERENCE            *
     C*                                                              *
     C****************************************************************
     C     CALIDFFND     BEGSR
     C*
     C* START DATE = LAST INT PAY DATE, END DATE = NEXT INT PAY DATE
     C*
     C                   Z-ADD     SLID          @@BEG
     C                   Z-ADD     NIDT          @@END
     C     @@END         IFEQ      *ZERO
     C                   Z-ADD     MDAT          @@END
     C                   END
     C*
     C* PRINCIPAL, FUNDING RATE, CALCULATION METHOD, ROUND DOWN INTEREST
     C*
     C                   Z-ADD     IHFVAL        @@AMT
     C                   Z-ADD     IHFSRP        @@RATE
     C                   MOVEL     IHICMT        @@CALC
     C                   MOVEL     IHRDFC        @@RDFC
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG             5 0
     C                   PARM                    @@END             5 0
     C                   PARM                    @@CALC            1
     C                   PARM                    @@AMT            15 0
     C                   PARM                    @@RATE           11 7
     C                   PARM                    @@RDFC            1
     C                   PARM      *ZERO         @@INTR           15 0
     C*
     C* CALCULATE FUNDING INTEREST FROM VALUE DATE TO MATURITY DATE
     C*
     C                   Z-ADD     @@INTR        ACAN
     C*
     C* CALCULATE FUNDING INTEREST FROM LAST INT PAY DATE TO VALUE DATE
     C*
     C                   Z-ADD     SLID          @@BEG
     C                   Z-ADD     VDAT          @@END
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG
     C                   PARM                    @@END
     C                   PARM                    @@CALC
     C                   PARM                    @@AMT
     C                   PARM                    @@RATE
     C                   PARM                    @@RDFC
     C                   PARM      *ZERO         @@INTR
      *
     C                   SUB       @@INTR        ACAN
     C*
     C* CALCULATE FUNDING INTEREST FROM VALUE DATE TO NEXT INT PAY DATE
     C*
     C                   Z-ADD     VDAT          @@BEG
     C                   Z-ADD     NIDT          @@END
     C     @@END         IFEQ      *ZERO
     C                   Z-ADD     MDAT          @@END
     C                   END
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG
     C                   PARM                    @@END
     C                   PARM                    @@CALC
     C                   PARM                    @@AMT
     C                   PARM                    @@RATE
     C                   PARM                    @@RDFC
     C                   PARM      *ZERO         @@INTR
      *
     C                   SUB       @@INTR        ACAN
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CALTCOF - CALCULATE TOTAL COST OF FUNDS                      *
     C*                                                              *
     C****************************************************************
     C     CALTCOF       BEGSR
     C*
     C* START DATE = VALUE DATE, END DATE = MATURITY DATE
     C*
     C                   Z-ADD     VDAT          @@BEG
     C                   Z-ADD     MDAT          @@END
     C*
     C* PRINCIPAL, FUNDING RATE, CALCULATION METHOD, ROUND DOWN INTEREST
     C*
     C                   Z-ADD     IHFVAL        @@AMT
     C                   Z-ADD     IHFSRP        @@RATE
     C                   MOVEL     IHICMT        @@CALC
     C                   MOVEL     IHRDFC        @@RDFC
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG
     C                   PARM                    @@END
     C                   PARM                    @@CALC
     C                   PARM                    @@AMT
     C                   PARM                    @@RATE
     C                   PARM                    @@RDFC
     C                   PARM      *ZERO         @@INTR
     C*
     C* TOTAL COST OF FUNDS
     C*
     C                   Z-ADD     @@INTR        TCOF
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ACSDCY - ACCESS DEAL CURRENCY DETAILS                        *
     C*                                                              *
     C****************************************************************
     C     ACSDCY        BEGSR
      *
      ** Access currency details using deal currency.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      IHCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @AJCD         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '005'         DBASE                          * DBERR 005*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   ENDSR
     C****************************************************************
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
      *             transaction.                                      *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxTrn      BEGSR                                                                CRE020
                                                                                              CRE020
      ** Initialise key values.                                                               CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       KRefNo                                       CRE020
     C                   MOVEL     DLNO          KRefNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   MOVE      *BLANK        WNew                                         CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL1                                                   CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF                                                   CRE020
                                                                                              CRE020
      ** Check first if this is a new advice index.                                           CRE020
                                                                                              CRE020
     C                   IF        WNew = *BLANK                                              CRE020
     C                   IF        RCHTYP = 'I' AND                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
     C                   MOVE      'Y'           WNew                                         CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           WNew                                         CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Set default values if the advice indicator is equal to blank.                        CRE020
                                                                                              CRE020
     C                   IF        RSAPIN = ' '                                               CRE020
                                                                                              CRE020
      ** Change type is always 'I' for newly inserted records.                                CRE020
                                                                                              CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute reversal processing if necessary.                                            CRE020
                                                                                              CRE020
     C                   IF        CHTP = 'R'                                                 CRE020
                                                                                              CRE020
      ** Delete the advice index if the current record is a new deal.                         CRE020
      ** Reverse it otherwise.                                                                CRE020
                                                                                              CRE020
     C                   MOVE      'R'           RCHTYP                                       CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   IF        WNew = 'Y'                                                 CRE020
     C                   MOVE      'Y'           RSAPIN                                       CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute amend processing.                                                            CRE020
                                                                                              CRE020
     C                   IF        WNew = 'Y'                                                 CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
                                                                                              CRE020
      ** Change field values only if the authorise indicator is equal to 'N'.                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   MOVE      CHTP          RCHTYP                                       CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************                       CRE020
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    MMVNAP
     C/COPY WNCPYSRC,MMNASPDC07
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
      ** ACCESS TRADING DETAILS
      *
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   END
                                                                                              CAS001
      ** Access SAR details file to determine if CAS001 is on.                                CAS001
      ** (Net Present Value Accounting)                                                       CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C     *LOCK         IN        LDA                                                        CAS001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 902                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   OUT       LDA                                                        CAS001
     C                   EXSR      SRERR                                                      CAS001
     C                   ENDIF                                                                CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
      ** Access SAR details file to determine if CAS005 is on.                                CAS005
      ** (Enhancements to CAS001, CAS002 and CAS004)                                          CAS005
                                                                                              CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
     C                   IF        PRTCD <> *BLANKS AND                                       CAS005
     C                             PRTCD <> '*NRF   '                                         CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBASE = 903                                                CAS005
     C                   EVAL      DBKEY = 'CAS005'                                           CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      SRERR                                                      CAS005
     C                   ENDIF                                                                CAS005
     C                   IF        PRTCD = *BLANKS                                            CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CRE020
      ** Check if CRE020 is enabled.                                                          CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM      '*VERIFY'     POptn                                        CRE020
     C                   PARM      'CRE020'      PSARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBase = 904                                                CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Check if a System Value exists for this maintenance.                                 CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
                                                                                              CRE020
     C                   CALLB     'AOSVALR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM                    PSysVal01                                    CRE020
     C                   PARM                    PCurSet01                                    CRE020
     C                   PARM                    PSysVal02                                    CRE020
     C                   PARM                    PCurSet02                                    CRE020
     C                   PARM                    PSysVal03                                    CRE020
     C                   PARM                    PCurSet03                                    CRE020
     C                   PARM                    PSysVal04                                    CRE020
     C                   PARM                    PCurSet04                                    CRE020
     C                   PARM                    PSysVal05                                    CRE020
     C                   PARM                    PCurSet05                                    CRE020
     C                   PARM                    PSysVal06                                    CRE020
     C                   PARM                    PCurSet06                                    CRE020
     C                   PARM                    PSysVal07                                    CRE020
     C                   PARM                    PCurSet07                                    CRE020
     C                   PARM                    PSysVal08                                    CRE020
     C                   PARM                    PCurSet08                                    CRE020
     C                   PARM                    PSysVal09                                    CRE020
     C                   PARM                    PCurSet09                                    CRE020
     C                   PARM                    PSysVal10                                    CRE020
     C                   PARM                    PCurSet10                                    CRE020
                                                                                              CRE020
     C                   EVAL      WSysVal01 = 'N'                                            CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBase = 905                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                    MD056655A
     C                   CALLB     'ZACRTVJOBA'                         90                 MD056655A
     C                   PARM                    PSJobName                                 MD056655A
     C                   PARM                    PSUser                                    MD056655A
     C                   PARM                    PSJobNo                                   MD056655A
     C                   PARM                    JobType           5                       MD056655A
      *                                                                                    MD056655A
     C     *IN90         IFEQ      '1'                                                     MD056655A
     C                   EVAL      DBFile = 'ZACRTVJOBA'                                   MD056655A
     C                   EVAL      DBase = 906                                             MD056655A
     C                   EVAL      DBKey = '*CALL'                                         MD056655A
     C                   EXSR      SRERR                                                   MD056655A
     C                   ENDIF                                                             MD056655A
     C*
     C/COPY WNCPYSRC,MMNASPDC05
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'MMNASPUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
**  CPY@
(c) Finastra International Limited 2001
