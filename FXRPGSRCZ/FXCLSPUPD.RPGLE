     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CLS Pay-in Schedule Database Update')            *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXCLSPUPD - FX CLS Pay-in Schedule                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 03Mar10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5671            Date 31Jan05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 02Jul03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 187923             Date 20Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5671- Add Sequence number to detail record                *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  187923 - 2 tier authorisation for CLS pay-in schedules       *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
     FFXCLSPSHL3UF A E           K DISK
     F                                     COMMIT
     FFXCLSPSDL2UF A E           K DISK
     F                                     COMMIT
 
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK                                                       CSD015
                                                                                              CSD015
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
 
      ** Timestamp for the transaction
     D Timestamp       S               Z
      *
      ** Externally Described Data Structure for Valid Pay-in Schedule
     D NPyInHFilFmt  E DS                  EXTNAME(FXVCLSPHPD)
 
      *
      ** Externally Described Data Structure for Valid Pay-in Schedule
     D NPyInDFilFmt  E DS                  EXTNAME(FXVCLSPDPD)
     D                                     PREFIX(D)
 
      * Data Structures for use with Access Programs
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** External DS for Nostro Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
                                                                                              CSD015
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD015
      ** Second DS for Access Programs, Long Data Structure                                   CSD015
                                                                                              CSD015
      ** SD data area                                                                         CSC015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
                                                                                              CSD015
      ** 24X7 status data area                                                                CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
                                                                                              CSD015
      ** Data Structure for SAR Details                                                       CSD015
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD015
                                                                                              CSD015
      ** External DS for Customer Details                                                     CSD015
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
                                                                                              CSD015
      ** External DS for Compliance Watch Transaction Details                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** Watch List Transaction Details Data Structure                                        CSD015
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
                                                                                              CSD015
      ** External DS for Watch List Configuration Data                                        CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
                                                                                              CSD015
      ** Compliance Engine Free Format String Parameter                                       CSD015
     D PFreeFmtStr     S          30000A                                                      CSD015
                                                                                              CSD015
      ** Array Size Definition                                                                CSD015
     D Elements        C                   CONST(5)                                           CSD015
                                                                                              CSD015
      ** XML Opening Tags for the Compliance Engine                                           CSD015
     D XOT             S             25A   DIM(Elements) PERRCD(1) CTDATA                     CSD015
                                                                                              CSD015
      ** XML Closing Tags for the Compliance Engine                                           CSD015
     D XCT             S             25A   DIM(Elements) PERRCD(1) CTDATA                     CSD015
                                                                                              CSD015
      ** Watch List Fields Array.                                                             CSD015
     D WLF             S             18A   DIM(Elements)                                      CSD015
                                                                                              CSD015
 
     D C#DTA           DS           256
     D  C#ATYP                 1      1
     D***C#ACCT*                2     19                                                      CGL029
     D**C#CNU1**               2      7  0                                                    CSD027
     D  C#CNU1                 2      7                                                       CSD027
     D  C#CCY1                 8     10
     D***C#ACO1*               11     14  0                                                   CGL029
     D  C#ACS1                15     16  0
     D  C#BRC1                17     19
     D  C#NOSN                 2      3  0
     D  C#NOS                  2      6
     D  C#ACNO                 2     11  0
     D**C#CNUM**               2      7  0                                                    CSD027
     D  C#CNUM                 2      7                                                       CSD027
     D***C#ACOD*                 8     11  0                                                  CGL029
     D  C#ACSQ                12     13  0
     D  C#BRCA                14     16
     D  C#IO                  24     24
     D  C#CCY                 25     27
     D  C#TRYP                28     29
     D  C#NARR                30     59
     D  C#CHQN                60     67  0
     D  C#PREF                68     82
     D  C#TRN                 83     88
     D  C#AMT                 89     96P 0
     D  C#PRON                97     97
     D  C#OLPS                98     98
     D  C#MEMS                99     99
     D  C#RSAC               100    100
     D  C#MOD                101    102
     D  C#OLRC               103    104
     D  C#FTOV               105    105
     D  C#VDAT               106    108P 0
     D  C#PSTD               109    111P 0
     D  C#PSTO               112    112
     D  C#RPST               113    113
     D  C#RPNB               114    116  0
     D  C#RTYP               117    117
     D  C#BBRN               118    120
     D  C#ACO1               121    130  0                                                    CGL029
     D  C#ACOD               131    140  0                                                    CGL029
     D  C#OTR1               141    160                                                       CAP204
     D  C#MTYP               161    161                                                       CAP205
      *                                                                                       CLE134
      ** Exception Reference Id/Number                                                        CLE134
      *                                                                                       CLE134
     D  C#XRFI               162    164                                                       CLE134
     D  C#XRFN               165    174  0                                                    CLE134
      *  Calling parameter data structure for AOSPOSU0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D***P#ACCD          S              4A                                                   CGL029
     D P#ACCD          S             10A                                                      CGL029
     D P#ACSN          S              2A
     D P#BRCD          S              3A
     D P#CSSN          S             10A
     D P#CUST          S              6A
     D P#CYCD          S              3A
     D P#NONB          S              2A
     D P#PNOI          S              1A
 
     D CSC011          S              1                                                       CSD015
     D CSD015          S              1                                                       CSD015
     D CCF001          S              1                                                       CSD015
                                                                                              CSD015
     D WFuncType       S              8                                                       CSD015
     D WIdntifier      S             40                                                       CSD015
     D WBranch         S              3                                                       CSD015
                                                                                              CSD015
     D WCUST           S              6                                                       CSD015
     D WIDEN1          S              5                                                       CSD015
     D WIDEN2          S              2                                                       CSD015
     D WXMLPacket      S            310                                                       CSD015
     D WData           S            216                                                       CSD015
     D WDDT            S               D                                                      CSD015
                                                                                              CSD015
     D Ctr             S              2P 0                                                    CSD015
     D PRetCode        S              7                                                       CSD015
     D POption         S              7                                                       CSD015
     D PCUST           S             10                                                       CSD015
     D PSTKey          S              7                                                       CSD015
     D PSard           S              6A                                                      CSD015
     D PFunc           S              8                                                       CSD015
     D ConvertedAmt    S             18P 3                                                    CSD015
     D PAmt            S             15                                                       CSD015
     D PDummy6         S              6                                                       CSD015
     D PDummy16        S             16                                                       CSD015
     D PDummy35        S             35                                                       CSD015
                                                                                              CSD015
      ** ZACVTDATE Parameters                                                                 CSD015
     D PZARtCd         S              7                                                       CSD015
     D PZADayNo        S              5                                                       CSD015
     D PZADDT          S               D                                                      CSD015
     D PZACvtDt        S             10                                                       CSD015
                                                                                              CSD015
      ** Parameters for SFC000026                                                             CAP084
     D PUser           S             10A                                                      CAP084
                                                                                              CAP086
      ** Define variable for switchable CAP086                                                CAP086
     D CAP086          S              1A                                                      CAP086
      ** Define variable for switchable CAP205                                                CAP205
     D CAP205          S              1A                                                      CAP205
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Body                                              *
      *                                                               *
      *****************************************************************
      *
      ** Clear stored values
      *
     C                   EXSR      SRCLR
     C                   MOVE      *BLANK        WRVRS             1
 
     C     P@ACTN        CASEQ     'I'           SRCINS
     C     P@ACTN        CASEQ     'A'           SRCAMD
     C     P@ACTN        CASEQ     'X'           SRCAUT
     C     P@ACTN        CASEQ     'D'           SRCDEL
     C                   ENDCS
      *
     C                   RETURN
      *
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRCINS - Insert CLS Pay-in Schedule                          *
      ****************************************************************
     C     SRCINS        BEGSR
      *
      ** Set header file fields
      *
     C     @HDRDTL       IFEQ      'H'
     C                   EXSR      SETHDR
                                                                                              CSD015
      ** Execute SRWTCH if compliance watch is installed, watch list checking                 CSD015
      ** is applied and in the main system.                                                   CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'N' OR (CSC011 = 'Y'                              CSD015
     C                             AND LIBR = S1MAIN)                                         CSD015
                                                                                              CSD015
     C                   EVAL      P#CYCD = PYCCY                                             CSD015
     C                   EVAL      P#NONB = PYNOST                                            CSD015
     C                   EXSR      SrNOST                                                     CSD015
     C                   EVAL      WLF(1) = A7CUST                                            CSD015
     C                   MOVEL     A7CLSM        WLF(3)                                       CSD015
     C                   MOVEL     A7CLSM        WLF(4)                                       CSD015
     C                   MOVEL     A7CLSC        WLF(5)                                       CSD015
                                                                                              CSD015
     C                   EVAL      P#NONB = A7LPR                                             CSD015
     C                   EXSR      SrNOST                                                     CSD015
     C                   EVAL      WCUST  = A7CUST                                            CSD015
     C                   EVAL      WLF(2) = A7CUST                                            CSD015
                                                                                              CSD015
     C                   EXSR      SrWTCH                                                     CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *
      ** Write Header record to FXCLSPSH
      *
     C                   WRITE     FXCLPHD0
     C                   ENDIF
                                                                                              CAP084
      ** If Detail fields are blank, this is called from the API Wrapper                      CAP084
                                                                                              CAP084
     C                   IF        @HdrDtl = 'H' AND @PayRcv = 'R' AND                        CAP084
     C                             DCLCCY = *BLANKS AND DCLNOST = *BLANKS                     CAP084
     C                             AND DCLVDAT = *ZERO AND DCLSEQN = *ZERO                    CAP084
     C                   GOTO      ESrCIns                                                    CAP084
     C                   ENDIF                                                                CAP084
      *
      ** Set detail file fields
      ** Additional condition is for the API Wrapper                                          CAP084
      *
     C     @HDRDTL       IFEQ      'D'
     C     @PayRcv       ANDEQ     'P'
     C     @HDRDTL       OREQ      'H'
     C     @PayRcv       ANDEQ     'R'
     C     @HDRDTL       OREQ      'D'                                                        CAP084
     C     @PayRcv       ANDEQ     'R'                                                        CAP084
     C                   EXSR      SETDTL
      *
      ** Write Detail record to FXCLSPSD
      *
     C                   WRITE     FXCLPDD0
     C                   ENDIF
      *
      ** Add Shadow postings
      *
     C     @HDRDTL       IFEQ      'S'
     C                   EVAL      P#CYCD = PYCCY
     C                   EVAL      P#NONB = PYNOST
     C                   EXSR      SRNOST
      *
     C     PYTOTR        IFNE      0
     C                   MOVEL     'C'           C#RTYP
     C                   Z-SUB     PYTOTR        C#AMT
     C                   ELSE
     C                   MOVEL     'D'           C#RTYP
     C                   Z-ADD     PYTOTP        C#AMT
     C                   ENDIF
     C                   EXSR      SRADDS
      *
      ** Real nostro
      *
     C                   MOVE      A7LPR         P#NONB
     C                   EXSR      SRNOST
     C     PYTOTR        IFNE      0
     C                   MOVEL     'D'           C#RTYP
     C                   Z-ADD     PYTOTR        C#AMT
     C                   ELSE
     C                   MOVEL     'C'           C#RTYP
     C                   Z-SUB     PYTOTP        C#AMT
     C                   ENDIF
     C                   EXSR      SRADDS
      *
     C                   EXSR      SRUPD
     C                   ENDIF
      *
     C**********         ENDSR                                                                CAP084
     C     ESrCIns       ENDSR                                                                CAP084
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRCAMD - Amend on CLS Pay-in Schedule                        *
      ****************************************************************
     C     SRCAMD        BEGSR
      *
      ** Access CLS Pay-in Schedule
      *
     C                   EVAL      KCCY = CLCCY
     C                   EVAL      KNOST = CLNOST
     C                   EVAL      KVDAT = CLVALD
     C                   EVAL      KSEQN = CLSEQN
      *
      ** Chain to Header file
      *
     C     @HDRDTL       IFEQ      'H'
     C     KyPayD        CHAIN     FXCLPHD0                           99
      *
      ** Database Error
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      KVDAT         WVDAT             5
     C                   MOVE      KSEQN         WSEQN             2
     C                   EVAL      DBKEY = KCCY + KNOST + WVDAT + WSEQN
     C                   MOVEL     'FXCLSPSH'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      SRERR
     C                   ELSE
      *
      ** Check if record was updated by another workstation using timestamp
      *
     C                   EXSR      CHKUPD
      *
     C     PYTOTR        IFNE      0
     C                   Z-ADD     PYTOTR        WTOTAM           17 0
     C                   ELSE
     C                   Z-ADD     PYTOTP        WTOTAM
     C                   ENDIF
     C                   EXSR      SETHDR
                                                                                              CSD015
      ** Execute SRWTCH if compliance watch is installed, watch list checking                 CSD015
      ** is applied and in the main system.                                                   CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'N' OR                                            CSD015
     C                             CSC011 = 'Y' AND LIBR = S1MAIN                             CSD015
                                                                                              CSD015
     C                   EVAL      P#CYCD = CLCCY                                             CSD015
     C                   EVAL      P#NONB = CLNOST                                            CSD015
     C                   EXSR      SrNOST                                                     CSD015
     C                   EVAL      WLF(1) = A7CUST                                            CSD015
     C                   MOVEL     A7CLSM        WLF(3)                                       CSD015
     C                   MOVEL     A7CLSM        WLF(4)                                       CSD015
     C                   MOVEL     A7CLSC        WLF(5)                                       CSD015
                                                                                              CSD015
     C                   EVAL      P#NONB = A7LPR                                             CSD015
     C                   EXSR      SrNOST                                                     CSD015
     C                   EVAL      WLF(2) = A7CUST                                            CSD015
     C                   EVAL      WCUST  = A7CUST                                            CSD015
                                                                                              CSD015
     C                   EVAL      WFuncType  = 'FXCLSPSH'                                    CSD015
     C                   EVAL      WBranch    = A7BRCD                                        CSD015
     C                   MOVE      PYVALD        WIDEN1                                       CSD015
     C                   MOVE      PYSEQN        WIDEN2                                       CSD015
     C                   EVAL      WIdntifier = PYCCY + PYNOST +                              CSD015
     C                                          WIDEN1 + WIDEN2                               CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                          CSD015
     C                   EXSR      SrWTCH                                                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   UPDATE    FXCLPHD0
     C                   ENDIF
      *
      ** Set file pointer of the detail file for the next read
      *
     C     KyPayD        SETLL     FXCLPDD0
     C
     C                   ENDIF
                                                                                              CAP084
      ** If Detail fields are blank, this is called from the API Wrapper                      CAP084
      ** and detail record was already written                                                CAP084
                                                                                              CAP084
     C                   IF        @HdrDtl = 'H' AND @PayRcv = 'R' AND                        CAP084
     C                             DCLCCY = *BLANKS AND DCLNOST = *BLANKS                     CAP084
     C                             AND DCLVDAT = *ZERO AND DCLSEQN = *ZERO                    CAP084
     C                   GOTO      ESrCAmd                                                    CAP084
     C                   ENDIF                                                                CAP084
      *
      ** Chain to Detail file
      *
     C     @HDRDTL       IFEQ      'D'
     C     @PayRcv       ANDEQ     'P'
     C     @HDRDTL       OREQ      'H'
     C     @PayRcv       ANDEQ     'R'
     C     KyPayD        READE     FXCLPDD0                               99
      *
     C     @UpdRest      IFEQ      'N'
     C     *IN99         IFEQ      '1'
     C                   EXSR      SETDTL
      *
      ** Write Detail record to FXCLSPSD
      *
     C                   WRITE     FXCLPDD0
     C                   ELSE
     C                   EXSR      SETDTL
     C                   UPDATE    FXCLPDD0
     C                   ENDIF
     C                   ELSE
      *
      ** Delete remaining records
      *
     C     *IN99         DOWEQ     '0'
     C                   DELETE    FXCLPDD0
     C     KyPayD        READE     FXCLPDD0                               99
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
      ** Update shadow postings
      *
     C     @HDRDTL       IFEQ      'S'
     C                   EVAL      P#CYCD = PYCCY
     C                   EVAL      P#NONB = PYNOST
     C                   EXSR      SRNOST
                                                                                              CAP084
      ** If Pay/Rcv Total Amount are both zero, this was called from                          CAP084
      ** the API Wrapper, and all detail records have been deleted.                           CAP084
      ** Therefore just cancel the previous value.                                            CAP084
                                                                                              CAP084
     C                   IF        PYTOTP = *ZERO AND PYTOTR = *ZERO                          CAP084
     C                   EXSR      SrCancPrev                                                 CAP084
                                                                                              CAP084
     C                   ELSE                                                                 CAP084
      *
      ** Cancel the previous value - dummy
      *
     C     PYTOTR        IFNE      0
     C                   MOVEL     'D'           C#RTYP
     C                   Z-ADD     WTOTAM        C#AMT
     C                   ELSE
     C                   MOVEL     'C'           C#RTYP
     C                   Z-SUB     WTOTAM        C#AMT
     C                   ENDIF
     C                   MOVE      '*'           WRVRS
     C                   EXSR      SRADDS
      *
      ** Cancel the previous value - real nostro
      *
     C                   MOVE      A7LPR         P#NONB
     C                   EXSR      SRNOST
     C     PYTOTR        IFNE      0
     C                   MOVEL     'C'           C#RTYP
     C                   Z-SUB     WTOTAM        C#AMT
     C                   ELSE
     C                   MOVEL     'D'           C#RTYP
     C                   Z-ADD     WTOTAM        C#AMT
     C                   ENDIF
     C                   EXSR      SRADDS
      *
      ** Use the total amended value for shadow posting
      *
     C                   EVAL      P#NONB = PYNOST
     C                   EXSR      SRNOST
     C     PYTOTR        IFNE      0
     C                   MOVEL     'C'           C#RTYP
     C                   Z-SUB     PYTOTR        C#AMT
     C                   ELSE
     C                   MOVEL     'D'           C#RTYP
     C                   Z-ADD     PYTOTP        C#AMT
     C                   ENDIF
     C                   MOVE      *BLANK        WRVRS
     C                   EXSR      SRADDS
      *
      ** Real nostro
      *
     C                   MOVE      A7LPR         P#NONB
     C                   EXSR      SRNOST
     C     PYTOTR        IFNE      0
     C                   MOVEL     'D'           C#RTYP
     C                   Z-ADD     PYTOTR        C#AMT
     C                   ELSE
     C                   MOVEL     'C'           C#RTYP
     C                   Z-SUB     PYTOTP        C#AMT
     C                   ENDIF
     C                   EXSR      SRADDS
      *
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   EXSR      SRUPD
     C                   ENDIF
      *
     C**********         ENDSR                                                                CAP084
     C     ESrCAmd       ENDSR                                                                CAP084
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRCAUT - Authorise CLS Pay-in Schedule                       *
      ****************************************************************
     C     SRCAUT        BEGSR
      *
      ** Access CLS Pay-in Schedule - Header record
      *
     C                   EVAL      KCCY = CLCCY
     C                   EVAL      KNOST = CLNOST
     C                   EVAL      KVDAT = CLVALD
     C                   EVAL      KSEQN = CLSEQN
      *
      ** Chain to Header file
      *
     C     KyPayD        CHAIN     FXCLPHD0                           99
      *
      ** Database Error
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      KVDAT         WVDAT
     C                   MOVE      KSEQN         WSEQN
     C                   EVAL      DBKEY = KCCY + KNOST + WVDAT + WSEQN
     C                   MOVEL     'FXCLSPSH'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      SRERR
     C                   ELSE
      *
      ** Check if record was updated by another workstation using timestamp
      *
     C                   EXSR      CHKUPD
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      PYAUTH = CLAUTH                                            CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   EVAL      PYSNTF = 'Y'
     C                   UPDATE    FXCLPHD0
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRCDEL - Delete CLS Pay-in Schedule                          *
      ****************************************************************
     C     SRCDEL        BEGSR
      *
      ** Access CLS Pay-in Schedule - Header record
      *
     C                   EVAL      KCCY = CLCCY
     C                   EVAL      KNOST = CLNOST
     C                   EVAL      KVDAT = CLVALD
     C                   EVAL      KSEQN = CLSEQN
      *
      ** Chain to Header file
      *
     C     @HDRDTL       IFEQ      'H'
     C     KyPayD        CHAIN     FXCLPHD0                           99
      *
      ** Database Error
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      KVDAT         WVDAT
     C                   MOVE      KSEQN         WSEQN
     C                   EVAL      DBKEY = KCCY + KNOST + WVDAT + WSEQN
     C                   MOVEL     'FXCLSPSH'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      SRERR
     C                   ELSE
      *
      ** Check if record was updated by another workstation using timestamp
      *
     C                   EXSR      CHKUPD
     C                   EVAL      PYRECI = '*'
     C                   UPDATE    FXCLPHD0
     C                   ENDIF
      *
      ** Detail file
      *
     C     KyPayD        SETLL     FXCLPDD0
     C     KyPayD        READE     FXCLPDD0                               99
     C                   DOW       NOT *IN99
     C                   EVAL      PYRECI = '*'
     C                   UPDATE    FXCLPDD0
     C     KyPayD        READE     FXCLPDD0                               99
     C                   ENDDO
     C                   ENDIF
                                                                                              CAP084
      ** Delete detail record (API Wrapper project)                                           CAP084
                                                                                              CAP084
     C                   IF        @HDRDTL = 'D'                                              CAP084
     C     KyPayD        CHAIN     FXCLPHD0                           81                      CAP084
                                                                                              CAP084
     C                   IF        *IN81 = *ON                                                CAP084
     C                   EVAL      DBASE = 004                                                CAP084
     C                   MOVE      KVDAT         WVDAT                                        CAP084
     C                   MOVE      KSEQN         WSEQN                                        CAP084
     C                   EVAL      DBKEY = KCCY + KNOST + WVDAT + WSEQN                       CAP084
     C                   MOVEL     'FXCLSPSH'    DBFILE                                       CAP084
     C                   EXSR      SRERR                                                      CAP084
                                                                                              CAP084
     C                   ELSE                                                                 CAP084
                                                                                              CAP084
     C     KyPayD        SETLL     FXCLPDD0                                                   CAP084
     C                   DOU       *IN81 = *ON OR                                             CAP084
     C                             *IN81 = *OFF AND PYRECI = 'D' AND                          CAP084
      *****************************PYLTIM = DCLLTIM AND PYAMT = DCLAMT                CAP084 BUG5671
     C                             PYLTIM = DCLLTIM AND PYAMT = DCLAMT AND                   BUG5671
     C                             PYDSEQ = DCLDSEQ                                          BUG5671
     C     KyPayD        READE     FXCLPDD0                               81                  CAP084
     C                   ENDDO                                                                CAP084
                                                                                              CAP084
     C                   IF        *IN81 = *OFF AND PYRECI = 'D' AND                          CAP084
      *****************************PYLTIM = DCLLTIM AND PYAMT = DCLAMT                CAP084 BUG5671
     C                             PYLTIM = DCLLTIM AND PYAMT = DCLAMT AND                   BUG5671
     C                             PYDSEQ = DCLDSEQ                                          BUG5671
     C                   EVAL      PYRECI = '*'                                               CAP084
     C                   UPDATE    FXCLPDD0                                                   CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
      *
      ** Update shadow postings
      *
     C     @HDRDTL       IFEQ      'S'
     C                   EVAL      P#CYCD = PYCCY
     C                   EVAL      P#NONB = PYNOST
     C                   EXSR      SRNOST
      *
      ** Cancel the previous value
      *
     C     PYTOTR        IFNE      0
     C                   MOVEL     'D'           C#RTYP
     C                   Z-ADD     PYTOTR        C#AMT
     C                   ELSE
     C                   MOVEL     'C'           C#RTYP
     C                   Z-SUB     PYTOTP        C#AMT
     C                   ENDIF
     C                   MOVE      '*'           WRVRS
     C                   EXSR      SRADDS
      *
      ** Real Nostro
      *
     C                   MOVE      A7LPR         P#NONB
     C                   EXSR      SRNOST
     C     PYTOTR        IFNE      0
     C                   MOVEL     'C'           C#RTYP
     C                   Z-SUB     PYTOTR        C#AMT
     C                   ELSE
     C                   MOVEL     'D'           C#RTYP
     C                   Z-ADD     PYTOTP        C#AMT
     C                   ENDIF
     C                   EXSR      SRADDS
      *
     C                   EXSR      SRUPD
     C                   ENDIF
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SETHDR - Set Header File fields                              *
      *                                                              *
      ****************************************************************
     C     SETHDR        BEGSR
      *
      ** Header fields
      *
     C                   EVAL      PYRECI = 'D'
     C                   EVAL      PYCCY  = CLCCY
     C                   EVAL      PYNOST = CLNOST
     C                   EVAL      PYVALD = CLVALD
     C                   EVAL      PYSEQN = CLSEQN
     C                   EVAL      PYPRFC = CLPRFC
     C                   EVAL      PYTIMD = CLTIMD
     C                   EVAL      PYTOTP = CLTOTP
     C                   EVAL      PYTOTR = CLTOTR
     C                   EVAL      PYNSBP = CLNSBP
     C                   EVAL      PYNSBR = CLNSBR
     C                   EVAL      PYSNTF = 'N'
     C                   EVAL      PYPOST = 'N'
     C**********         EVAL      PYUSER = PSUser                                     187923 CAP084
     C                   EXSR      SrGetUser                                                  CAP084
     C                   EVAL      PYUSER = PUser                                             CAP084
      *
      ** Generate a timestamp for this transaction
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      PYTIMS = TimeStamp
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SETDTL - Set Detail File fields                              *
      *                                                              *
      ****************************************************************
     C     SETDTL        BEGSR
      *
      ** Detail Fields
      *
     C                   EVAL      PYRECI = 'D'
     C                   EVAL      PYCCY  = DCLCCY
     C                   EVAL      PYNOST = DCLNOST
     C                   EVAL      PYVDAT = DCLVDAT
     C                   EVAL      PYSEQN = DCLSEQN
     C                   EVAL      PYPRFC = DCLPRFC
     C                   EVAL      PYLTIM = DCLLTIM
     C                   EVAL      PYTIMD = DCLSTIM
     C                   EVAL      PYGENT = 'N'
      *
      ** Set detail fields depending on Pay/Rcv indicator
      *
     C                   IF        @PayRcv = 'P'
     C                   EVAL      PYAMT  = DCLAMT
     C                   ELSE
     C                   EVAL      PYAMT  = CLTOTR
     C                   ENDIF
      *
      ** Generate a timestamp for this transaction
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      PYTIMS = TimeStamp
      *
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * CHKUPD - Check if updated by another workstation             *
      ****************************************************************
     C     CHKUPD        BEGSR
      *
     C     PYTIMS        IFNE      CLTIMS
     C                   MOVEL     '*RECUPD '    @@RTCD
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRERR - Exception Errors                                     *
      ****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'FXCLSPUPD'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      ** Terminate the Program
      *
     C                   RETURN
     C*
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                       CSD015
      * SRWTCH - Set-up parameter and send transaction details to     *                       CSD015
      *          Compliance Watch by calling the Engine program       *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWTCH        BEGSR                                                                CSD015
                                                                                              CSD015
      ** Set-up first parameter for Compliance Engine                                         CSD015
                                                                                              CSD015
     C                   CLEAR                   SDWLTD                                       CSD015
                                                                                              CSD015
     C                   EVAL      W4ITEM = 'FXCLSP'                                          CSD015
                                                                                              CSD015
     C                   MOVEL     PYVALD        WIDEN1                                       CSD015
     C                   MOVEL     PYSEQN        WIDEN2                                       CSD015
     C                   EVAL      W4IDEN  = PYCCY + PYNOST +                                 CSD015
     C                                       WIDEN1 + WIDEN2                                  CSD015
                                                                                              CSD015
     C                   EVAL      W4BRCH = A7BRCD                                            CSD015
                                                                                              CSD015
      ** Get Main System Prefix from data area SC24X7 if enhancement                          CSD015
      ** CSC011 is installed, else get it from SDSTAT                                         CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4FUNT = 'FXCLSPSH'                                        CSD015
                                                                                              CSD015
      ** Determine Counterparty Type                                                          CSD015
      ** Access customer details file for Counter Party details                               CSD015
     C                   EVAL      PCUST = WCUST                                              CSD015
     C                   EXSR      SRCUST                                                     CSD015
                                                                                              CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
                                                                                              CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        BBLICD <> *BLANKS                                          CSD015
     C                             AND BBLICD <> W1IND1                                       CSD015
     C                             AND BBLICD <> W1IND2                                       CSD015
     C                             AND BBLICD <> W1IND3                                       CSD015
     C                             AND BBLICD <> W1IND4                                       CSD015
     C                             AND BBLICD <> W1IND5                                       CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Access customer details file for Counter Party (Midas Report                         CSD015
      ** Name + Customer Report Town)                                                         CSD015
                                                                                              CSD015
     C                   EVAL      W4CNUM = WCUST                                             CSD015
     C     BBCRNM        CAT       BBCRTN        W4CUST                                       CSD015
                                                                                              CSD015
      ** Value Date                                                                           CSD015
     C                   MOVE      PYVALD        PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4VDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Denomination Side                                                                    CSD015
     C                   EVAL      W4DEN1 = PYCCY                                             CSD015
     C                   EVAL      W4DEN2 = *BLANKS                                           CSD015
                                                                                              CSD015
      ** Amount Side                                                                          CSD015
     C                   IF        PYTOTP <> 0                                                CSD015
     C                   MOVE      PYTOTP        PAMT                                         CSD015
     C                   ELSE                                                                 CSD015
     C                   MOVE      PYTOTR        PAMT                                         CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   CALLB     'ZACVTAMT'                                                 CSD015
     C                   PARM                    PRetCode                                     CSD015
     C                   PARM                    PYCCY                                        CSD015
     C                   PARM                    PAMT                                         CSD015
     C                   PARM                    ConvertedAmt                                 CSD015
     C                   PARM                    PDummy16                                     CSD015
                                                                                              CSD015
     C                   MOVE      ConvertedAmt  W4AMT1                                       CSD015
     C                   EVAL      W4AMT2 = *ZERO                                             CSD015
                                                                                              CSD015
      ** Build the free format string.                                                        CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   EVAL      PFreeFmtStr = *BLANKS                                      CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
                                                                                              CSD015
     C                   DOU       Ctr > Elements                                             CSD015
                                                                                              CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
     C                             AND WLF(Ctr) <> '000000'                                   CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM                    PRetCode                                     CSD015
     C                   PARM                    WLF(Ctr)                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PYCCY                                        CSD015
     C                   PARM                    WData                                        CSD015
     C                   PARM                    PDummy6                                      CSD015
                                                                                              CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WData:0       WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
                                                                                              CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
     C                   ENDDO                                                                CSD015
                                                                                              CSD015
      ** Send transaction details to Compliance Watch                                         CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    SDWLTD                                       CSD015
     C                   PARM                    PFreeFmtStr                                  CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRDateToDDT - Converts a date into Date Data Type format.     *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRDateToDDT   BEGSR                                                                CSD015
                                                                                              CSD015
      ** Convert the derived Midas Day Number into Date Data Type.                            CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM      *Blanks       PZARtCd                                      CSD015
     C                   PARM                    PZADayNo                                     CSD015
     C                   PARM                    PZADDT                                       CSD015
     C                   PARM                    PZACvtDt                                     CSD015
                                                                                              CSD015
     C                   EVAL      WDDT = PZADDT                                              CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *  SRCUST   : Retrieve customer details                                                 CSD015
      *****************************************************************                       CSD015
     C     SRCUST        BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALLB     'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*KEY'        POption                                      CSD015
     C                   PARM                    PCUST                                        CSD015
     C                   PARM      *BLANKS       PSTKEY                                       CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS                                        CSD015
     C                   EVAL      DBKEY = POption                                            CSD015
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CSD015
     C                   EVAL      DBASE = 911                                                CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *  SRNOST   : Retrieve nostro details
      *****************************************************************
     CSR   SRNOST        BEGSR
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       P#CUST
     C                   PARM                    P#CYCD
     C                   PARM      *BLANKS       P#ACCD
     C                   PARM      *BLANKS       P#ACSN
     C                   PARM                    P#NONB
     C                   PARM      *BLANKS       P#BRCD
     C                   PARM      *BLANKS       P#CSSN
     C                   PARM      *BLANKS       P#PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     CSR                 ENDSR
     C****************************************************************
     C/EJECT
      *****************************************************************
      *  SRCLR    : Clear all positions in store                      *
      *****************************************************************
     CSR   SRCLR         BEGSR
      *
      ** Clear arrays in AOSPOSU0
      *
     C                   CLEAR                   C#DTA
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM      '*CLEAR  '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     C#RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOSPOSU0'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     '*CALL   '    DBKEY
     C                   EXSR      SRERR
     C                   END
 
     CSR                 ENDSR
     C****************************************************************
     C/EJECT
      *****************************************************************
      *  SRADDS   : Add shadow positions to store                     *
      *****************************************************************
     C     SRADDS        BEGSR
      *
      ** Map data
      *
     C                   MOVEL     'N'           C#ATYP
     C                   MOVEL     A7NONB        C#NOSN
     C                   MOVE      A7CYCD        C#NOS
     C                   EVAL      C#VDAT = PYVALD
     C                   MOVEL     A7CYCD        C#CCY
      *
     C                   IF        PYTOTR <> 0
     C                   EVAL      C#NARR = 'CLS RCV' + ' ' + WRVRS
     C                   ENDIF
      *
     C                   IF        PYTOTP <> 0
     C                   EVAL      C#NARR = 'CLS PAY' + ' ' + WRVRS
     C                   ENDIF
      *
     C                   MOVE      *BLANK        C#IO
     C                   MOVEL     '999999'      C#TRN
     C                   MOVEL     'DL'          C#MOD
     C                   MOVEL     '01'          C#OLRC
     C                   EVAL      C#PSTD = PYVALD
     C                   MOVEL     'Y'           C#RPST
     C                   Z-ADD     20            C#RPNB
     C                   MOVE      A7BRCD        C#BBRN
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'S'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
      *
      *  Call AOSPOSU0
      *
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM      '*ADD    '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     C#RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOSPOSU0'    DBKEY
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   EXSR      SRERR
     C                   ENDIF
 
     CSR                 ENDSR
     C****************************************************************
     C/EJECT
      *****************************************************************
      *  SRUPD    : Update database w/ shadow postings in store       *
      *****************************************************************
     C     SRUPD         BEGSR
      *
      *  Call AOSPOSU0
      *
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       C#RTCD            7
     C                   PARM      '*UPDATE '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     C#RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOSPOSU0'    DBKEY
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT                                                                                  CAP084
      *****************************************************************                       CAP084
      *  SrCancPrev - Cancel previous postings                        *                       CAP084
      *****************************************************************                       CAP084
     C     SrCancPrev    BEGSR                                                                CAP084
                                                                                              CAP084
     C                   EVAL      WRVRS = '*'                                                CAP084
     C                   IF        PYNSBR <> *ZERO                                            CAP084
     C                   EVAL      C#RTYP = 'D'                                               CAP084
     C                   Z-ADD     WTOTAM        C#AMT                                        CAP084
     C                   EVAL      C#NARR = 'CLS RCV' + ' ' + WRVRS                           CAP084
     C                   ELSE                                                                 CAP084
     C                   EVAL      C#RTYP = 'C'                                               CAP084
     C                   Z-SUB     WTOTAM        C#AMT                                        CAP084
     C                   EVAL      C#NARR = 'CLS PAY' + ' ' + WRVRS                           CAP084
     C                   ENDIF                                                                CAP084
     C                   EXSR      SRADDS                                                     CAP084
                                                                                              CAP084
     C                   MOVE      A7LPR         P#NONB                                       CAP084
     C                   EXSR      SRNOST                                                     CAP084
     C                   IF        PYNSBR <> *ZERO                                            CAP084
     C                   EVAL      C#RTYP = 'C'                                               CAP084
     C                   Z-SUB     WTOTAM        C#AMT                                        CAP084
     C                   EVAL      C#NARR = 'CLS RCV' + ' ' + WRVRS                           CAP084
     C                   ELSE                                                                 CAP084
     C                   EVAL      C#RTYP = 'D'                                               CAP084
     C                   Z-ADD     WTOTAM        C#AMT                                        CAP084
     C                   EVAL      C#NARR = 'CLS PAY' + ' ' + WRVRS                           CAP084
     C                   ENDIF                                                                CAP084
     C                   EXSR      SRADDS                                                     CAP084
                                                                                              CAP084
     C     ESrCancPrev   ENDSR                                                                CAP084
      *****************************************************************                       CAP084
      /EJECT                                                                                  CAP084
      *****************************************************************                       CAP084
      *  SrGetUser - Get web browser user                             *                       CAP084
      *****************************************************************                       CAP084
     C     SrGetUser     BEGSR                                                                CAP084
                                                                                              CAP084
     C                   CALL      'SFC000026'                                                CAP084
     C                   PARM      *BLANKS       PUser                                        CAP084
                                                                                              CAP084
     C                   IF        PUser = *BLANKS                                            CAP084
     C                   EVAL      PUser = PSUser                                             CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDSR                                                                CAP084
      *****************************************************************                       CAP084
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
      ** Program Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    P@ACTN            1
     C                   PARM                    @PayRcv           1
     C                   PARM                    NPyInHFilFmt
     C                   PARM                    NPyInDFilFmt
     C                   PARM                    @HdrDtl           1
     C                   PARM                    @UpdRest          1
      *
     C     KYPayD        KLIST
     C                   KFLD                    KCCY              3
     C                   KFLD                    KNOST             2
     C                   KFLD                    KVDAT             5 0
     C                   KFLD                    KSEQN             2 0
                                                                                              CSD015
     C     KCwFld        KLIST                                                                CSD015
     C                   KFLD                    WFuncType                                    CSD015
     C                   KFLD                    WIdntifier                                   CSD015
     C                   KFLD                    WBranch                                      CSD015
                                                                                              CSD015
      ** Check if CSC011 is installed                                                         CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSC011'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRetCode <> '*NRF') and                                   CSD015
     C                             (PRetCode <> *Blanks)                                      CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSC011'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 904                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *Blanks                                         CSD015
     C                   EVAL      CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      CSC011 = 'N'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      *
      ** Check if Compliance Watch Enhancement - Watch List Checking                          CSD015
      ** (CSD015) is on.                                                                      CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRetCode <> *BLANKS) AND                                  CSD015
     C                             (PRetCode <> '*NRF   ')                                    CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *BLANKS                                         CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if Concord Interface Development(CCF001) is installed.                         CSD015
                                                                                              CSD015
     C                   EVAL      CCF001 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CCF001'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRetCode <> *BLANKS) AND                                  CSD015
     C                             (PRetCode <> '*NRF   ')                                    CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CCF001'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 910                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *BLANKS                                         CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
      **  Access Compliance Watch Configuration file.                                         CSD015
     C                   CALLB     'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*FIRST'      POption                                      CSD015
     C     SDCWCD        PARM      SDCWCD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database Error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS                                        CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = POption                                            CSD015
     C                   EVAL      DBFILE = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBASE = 909                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Check if function code is being monitored by compliance watch.                      CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*KEY    '    POption                                      CSD015
     C                   PARM      'DEALING '    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database Error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS                                        CSD015
     C                             AND PRetCode <> '*NRF'                                     CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = PFunc                                              CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 908                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRetCode                                     CAP086
     C                   PARM      '*VERIFY'     POption                                      CAP086
     C                   PARM      'CAP086'      PSARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRetCode <> *BLANKS AND                                    CAP086
     C                             PRetCode <> '*NRF'                                         CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'GLBITHUPD'                                        CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 8                                                 CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      SRERR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        PRetCode = *BLANKS                                         CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      **  Determine if SAR CAP205 is installed                                                CAP205
                                                                                              CAP205
     C                   EVAL      CAP205 = 'N'                                               CAP205
     C                   CALL      'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       PRetCode                                     CAP205
     C                   PARM      '*VERIFY'     POption                                      CAP205
     C                   PARM      'CAP205'      PSARD                                        CAP205
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP205
                                                                                              CAP205
     C                   IF        PRetCode <> *BLANKS AND                                    CAP205
     C                             PRetCode <> '*NRF'                                         CAP205
     C     *LOCK         IN        LDA                                                        CAP205
     C                   EVAL      DBKEY = 'CAP205'                                           CAP205
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP205
     C                   EVAL      DBASE  = 9                                                 CAP205
     C                   OUT       LDA                                                        CAP205
     C                   EXSR      SRERR                                                      CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C                   IF        PRetCode = *BLANKS                                         CAP205
     C                   EVAL      CAP205 = 'Y'                                               CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCode                                     CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRetCode <> *BLANKS AND                                    CSD083
     C                             PRetCode <> '*NRF'                                         CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSD083
     C                   EVAL      DBASE  = 10                                                CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      SRERR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRetCode = *BLANKS                                         CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   ENDSR
      ****************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** CTDATA XOT - XML Opening Tags for the Compliance Engine.                                   CSD015
<CLS Nostro>                                                                                  CSD015
<Destination>                                                                                 CSD015
<Ordering Bank>                                                                               CSD015
<Beneficiary>                                                                                 CSD015
<A/C with Bank>                                                                               CSD015
** CTDATA XCT - XML Closing Tags for the Compliance Engine.                                   CSD015
</CLS Nostro>                                                                                 CSD015
</Destination>                                                                                CSD015
</Ordering Bank>                                                                              CSD015
</Beneficiary>                                                                                CSD015
</A/C with Bank>                                                                              CSD015
