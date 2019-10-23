     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBI *: OVRDBF FILE(LEFEEAXX) TOFILE(LEFEEAL2) SHARE(*NO)          : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee settlement update')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFESTUPD -  Fee Settlement Update                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD054354           Date 23Oct19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CLE073             Date 13May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244273             Date 30Mar07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG7029            Date 09Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4478            Date 07Oct04               *
      *                 BUG3760            Date 30Jul04               *
      *                 CRE020             Date 20Jan04               *
      *                 TDA043             Date 22Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 28Feb03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054354 - Settlement of fee accrual for prior period for    *
      *             backdated notional change                         *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  244273 - Add SETTLEINS subroutine.                           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4478 - Do not clear the warning error arrays just         *
      *            prior to the database update.                      *
      *  BUG3760- Compliance Watch (CSD015) changes missing from the  *
      *           Lending APIs.                                       *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  TDA043 - Database error due to decimal data error. Fix is to *
      *           change data structure definition of LEVFESTEXT.     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project                                 *
      *         - Get user name from ZMUSER, not PSDS                 *
      *         - Valid file changed to match LEFEEAD                 *
      *  CLE031 - Lending Enhancements.                               *
      *           LEFEED & LEFEEAD changed  - recompile               *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Fee settlements
     FLEFEEAXX  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     COMMIT

      ** Fee settlements trailer
     FLEFEEAZ   UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CRE020
     FREADVCL2  UF   E           K DISK    USROPN                                             CRE020
     F                                     COMMIT                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref/Seq No                     CRE020
                                                                                              CRE020
      *                                                                                      BUG3760
     FSDCWHTL1  IF   E           K DISK                                                      BUG3760
      ** Compliance Watch Hit List by Function Type/Identifier/Branch                        BUG3760
      *                                                                                      BUG3760

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /SPACE 5
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D OVRDBF1         C                   'OVRDBF FILE(LEFEEAXX)-
     D                                       TOFILE(LEFEEAL2) SHARE(*NO)'

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Watch List Description Compiled Time Array                                          BUG3760
     DWLARR            S             35    DIM(26) CTDATA PERRCD(2)                          BUG3760
                                                                                             BUG3760
      ** Fee Settlement Details in file format
     D LEFEEAD       E DS                  EXTNAME(LEFEEAD)

      ** Valid Fee Settlement Details in file format
     D LEVFESTPD     E DS                  EXTNAME(LEVFESTPD)
     D  LEVFESTOURS  E                     EXTFLD(QQOURS)                                     CGL029
     D**LEVFESTEXT****       772    892                                                CGL029 TDA043
     D**LEVFESTEXT****       771    911                                                TDA043 CAP086
     D  LEVFESTEXT           771    912                                                       CAP086

      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)

      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)

      ** Fee Settlement Details OK indicator
     D FEST_OK       E DS                  EXTNAME(LEEFESTPD)

      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** Customer lending details
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D DSSDY         E DS                  EXTNAME(DSSDY)                                    BUG3760
      ***  First DS for access programs, LONG data structure.                                BUG3760
                                                                                             BUG3760
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG3760
      ** External DS for Customer Details                                                    BUG3760
                                                                                             BUG3760
      ** Midas Functions for Watch List Checking Details File                                BUG3760
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
                                                                                             BUG3760
      ** Data structure for 1st parameter of Watchlist Engine (SDCWLCHK)                     BUG3760
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                 BUG3760
                                                                                             BUG3760
      ** External DS for Watch List Configuration Data File                                  BUG3760
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
                                                                                             BUG3760
      ** Data structure for 2st parameter of SDCWLCHK                                        BUG3760
                                                                                             BUG3760
     D PString         DS         30000                                                      BUG3760

      ** Before image of update to LE position files
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
      ** After image of update to LE position files
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
      ** Work file of update to LE position files
     D Z#WSTS        E DS                  EXTNAME(Z#WST)

     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
                                                                                              CAP084
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                     CAP084
      ** Java user information                                                                CAP084

     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ** Midas API Message Header Format Definition

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D CSC011          S              1A   INZ('N')
     D TRANSDTL        S           5800A
     D WTimestamp      S             26A
     D***PDealNo         S             18A                                                    CGL029
     D***PADealNo        S             18A                                                    CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PFunc           S              8A                                                     BUG3760
     D WDealNo         S              6A
     D RunBefore2      S              1A                                                      CAP084
     D CSD015          S              1A                                                     BUG3760
     D CCF001          S              1A   INZ('N')                                          BUG3760

      ** CRE020 Variables                                                                     CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KSeqNo          S              3A                                                      CRE020
     D KPrgMn          S             10A   INZ('LEFESTUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('Fees                ')                        CRE020
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
     D WNew            S              1A                                                      CRE020
                                                                                             BUG3760
                                                                                             BUG3760
      ** ZACVTDATE Parameters                                                                BUG3760
     D PZARtCd         S             10                                                      BUG3760
     D PZADayNo        S              5                                                      BUG3760
     D PZADDT          S               D                                                     BUG3760
     D PConvtDate      S             10                                                      BUG3760
                                                                                             BUG3760
      ** ZACVTAMT Parameters                                                                 BUG3760
     D PZAAmt          S             15                                                      BUG3760
     D PZACcy          S              3                                                      BUG3760
     D PZOutAmt        S             18  3                                                   BUG3760
     D PZCvtAmt        S             16                                                      BUG3760
                                                                                             BUG3760
      ** SRConvert Parameters                                                                BUG3760
     D PInput          S             35                                                      BUG3760
     D PInput1         S             35                                                      BUG3760
     D PInput2         S             35                                                      BUG3760
     D PInput3         S             35                                                      BUG3760
     D PInput4         S             35                                                      BUG3760
     D PInput5         S             35                                                      BUG3760
     D PInCcy          S              3                                                      BUG3760
     D OutFmt          S            216                                                      BUG3760
     D OutFmt2         S              6                                                      BUG3760
                                                                                             BUG3760
      ** Work Variables                                                                      BUG3760
     D WDDT            S               D                                                     BUG3760
     D WFPDT           S              8F                                                     BUG3760
     D Fld1            S             35                                                      BUG3760
     D Fld2            S             35                                                      BUG3760
     D Fld3            S             35                                                      BUG3760
     D Fld4            S             35                                                      BUG3760
     D Fld5            S             35                                                      BUG3760
     D KFuncType       S              8                                                      BUG3760
     D KIden           S             40                                                      BUG3760
     D KBranch         S              3A                                                     BUG3760
     D WCtrpRpt        S             30                                                      BUG3760
     D WCtrpTyp        S              1                                                      BUG3760
     D PFuncCode       S              8                                                      BUG3760
     D PCustNo         S             10A                                                     BUG3760
     D PErrInf         S              7A                                                     BUG3760
     D WUNCF           S              1A                                                     BUG3760
     D W2LOAN          S              6A                                                     BUG3760
     D W2CNUM          S              6A                                                     BUG3760
     D W2FACL          S              5A                                                     BUG3760
     D W2FSEQ          S              2A                                                     BUG3760
     D U               S              2  0                                                   BUG3760
                                                                                              CRE020
      ** Reference Number Data Structure                                                      CRE020
     D                 DS                                                                     CRE020
     D WRefNo                  1     12                                                       CRE020
     D  WCustNo                1      6                                                       CRE020
     D  WTrnRef                7     12                                                       CRE020
                                                                                              CAP086
     D CAP086          S              1A   INZ('N')                                           CAP086
                                                                                              CAP086
                                                                                              CRE020
     D/COPY WNCPYSRC,LEH01186
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /SPACE 5
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
                                                                                             BUG7029
      * If the user is connected via a browser, the job user name is the data                BUG7029
      * source conection name - the actual user name is stored in ZMUSER                     BUG7029
     C                   IN        ZMUSER                                                    BUG7029
      *
      ** Clear output fields
      *
     C                   MOVEL     *ALL'Y'       FEST_OK
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIDArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
                                                                                             BUG4478
      ** Only clear warning error details if not coming from MidasPlus                       BUG4478
                                                                                             BUG4478
     C     USRID         IFEQ      *BLANKS                                                   BUG4478
     C                   MOVE      *BLANK        WFldNamArr
     C                   MOVE      *BLANK        WMsgIDArr
     C                   MOVE      *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Wx
     C                   ENDIF                                                               BUG4478

      * Initialise loan number (always 0)                                                     CAP084
     C                   IF        CLE073  <> 'Y'                                             CLE073
     C*********          Z-ADD     0             STLOAN                                CAP084 CLE148
     C                   MOVEL     *BLANKS       STLOAN                                       CLE148
     C                   ENDIF                                                                CLE073

      * Set up the key fields to the fee settlements file

     C                   MOVEL     STCNUM        K#CNUM
     C                   MOVEL     STFACL        K#FACL
     C**********         Z-ADD     STLOAN        K#LOAN                                       CLE148
     C                   MOVEL     STLOAN        K#LOAN                                       CLE148
     C                   MOVEL     STFSEQ        K#FSEQ
     C                   Z-ADD     STVDAT        K#VDAT

     C                   SELECT

      **  Write fee settlement record
      **  ===========================

     C     S#ACTN        WHENEQ    'I'
     C                   EXSR      WRITER

      **  Amend fee settlement record
      **  ===========================

     C     S#ACTN        WHENEQ    'A'
     C                   EXSR      AMENDR

      **  Authorise fee settlement record
      **  ===============================

     C     S#ACTN        WHENEQ    'X'
     C                   EXSR      AUTHOR

      **  Delete fee settlement record
      **  ============================

     C     S#ACTN        WHENEQ    'D'
     C                   EXSR      DELETR
      *
     C                   ENDSL

      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   SELECT                                                               CRE020
     C                   WHEN      S#ACTN = 'X' OR                                            CRE020
     C                             S#ACTN = 'D'                                               CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   WHEN      S#ACTN = 'A'                                               CRE020
     C                   EXSR      SRIdxAmd                                                   CRE020
                                                                                              CRE020
     C                   IF        BPFSAU = 'N'                                               CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   WHEN      S#ACTN = 'I'                                               CRE020
     C                   IF        BPFSAU = 'N'                                               CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDSL                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** If 24x7 Midas Availability is installed, write to the standard
      ** log file when support system is active

     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR

      ** Setup Fee settlement support log

     C                   CALLB     'LEFESTLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    S#ACTN
     C                   PARM                    LEFEEAD
     C                   PARM                    TRANSDTL
     C                   PARM                    P_SIGN            1                        MD054354

      ** Write to support database log file

     C                   IF        RetCodeOut = *BLANKS

     C                   EVAL      APTGTTYPE = 'LEFEST'
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   If        USRID  <> *Blank                                           CAP084
     C                   EVAL      APUSERID = USRID                                           CAP084
     C                   Else                                                                 CAP084
     C                   EVAL      APUSERID = PSUser
     C                   EndIf                                                                CAP084
     C                   MOVEL     STFRNT        APFOTRANID
     C                   MOVEL     STAFRT        APFOASOCID
     C                   MOVEL     STCNUM        W@STCNUM          6
     C                   MOVEL     STFACL        W@STFACL          5
     C                   MOVEL     STFSEQ        W@STFSEQ          2
     C                   MOVEL     STVDAT        W@STVDAT          5
     C                   MOVEL     STLOAN        W@STLOAN          6                          CLE073
     C**********         If        STLOAN  = 0                                         CLE073 CLE148
     C                   IF        STLOAN  = *BLANKS                                          CLE148
     C                   EVAL      PDealNo = W@STCNUM + W@STFACL +
     C                                       W@STFSEQ + W@STVDAT
     C                   ELSE                                                                 CLE073
     C                   EVAL      PDealNo = W@STCNUM + W@STLOAN +                            CLE073
     C                                       W@STFSEQ + W@STVDAT                              CLE073
     C                   ENDIF                                                                CLE073
     C                   EVAL      PADealNo = *BLANKS

     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       WTimestamp
     C                   PARM                    PDealNo
     C                   PARM                    PADealNo

     C                   ENDIF

      ** If error occured,

     C                   IF        RetCodeOut <> *BLANKS

     C                   EVAL      RetCodeIn = '*ERROR'

     C                   ENDIF

     C                   ENDIF

      **  Update the trailer if no errors
      **  Else report an error

     C     Ix            IFEQ      0
     C                   EXSR      UPDTRL
     C                   ELSE
     C     RetCodeIn     IFEQ      *BLANK
     C                   MOVEL     '*ERROR    '  RetCodeIn
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN

      /SPACE 5
      *****************************************************************
      * WRITER   : Write fee settlement record                        *
      *****************************************************************
     C     WRITER        BEGSR

      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      ** Access settlement record

     C     FEESK         CHAIN     LEFEEADF                           70

      ** End in error if record has been updated by another workstation

     C     *IN70         IFEQ      *OFF
     C                   MOVE      'N'           S#SADJOK
     C                   ADD       1             Ix
     C                   MOVEL     'S#SADJ      'FldNameArr(Ix)
     C                   MOVEL     'LEP0026'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EWRITER
     C                   ENDIF

     C                   MOVEL     LEVFESTPD     LEFEEAD
     C                   MOVE      LEVFESTEXT    LEFEEAD                                      CGL029
     C                   EVAL      STMP  = TimeStamp

      * Status is authorised if CLE002 is not installed or if
      * authorisation of fee settlement/adjustment is not allowed
      * Otherwise, it will just be complete
      * Transactions in batch mode are always authorised

     C     CLE002        IFEQ      'N'
     C     BPFSAU        OREQ      'N'
     C     P#MODE        OREQ      'B'
     C     STAUTH        OREQ      'Y'                                                        CAP086
     C     CAP086        ANDEQ     'Y'                                                        CAP086
     C                   MOVE      'A'           SSTS
     C                   ELSE
     C                   MOVE      'C'           SSTS
     C                   ENDIF

      * User
     C     P#MODE        IFEQ      'B'
     C     IUSR          IFEQ      *BLANKS
     C                   MOVE      F5IUSR        IUSR
     C                   ENDIF
     C                   ELSE
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   If        USRID  <> *Blank                                           CAP084
     C                   EVAL      IUSR = USRID                                               CAP084
     C                   Else                                                                 CAP084
     C                   MOVE      PsUser        IUSR
     C                   EndIf                                                                CAP084
     C                   ENDIF

      * Participant fee indicator
     C     CLE004        IFEQ      'Y'
     C                   MOVE      W#PTFI        PTFI
     C                   ENDIF
      *                                                                                       244273
      ** Update settlement instructions.                                                      244273
      *                                                                                       244273
     C                   IF        W#PTFI <> 'I'                                              244273
     C                   EXSR      SETTLEINS                                                  244273
     C                   ENDIF                                                                244273

      * If CLE009 is installed

     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRSWRI
     C                   ENDIF
                                                                                             BUG3760
      ** If Compliance Watch is installed, and entry watch list checking                     BUG3760
      ** is being applied, perform Compliance Watch processing.                              BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                           BUG3760
                                                                                             BUG3760
     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                          BUG3760
     C                             OR CSC011 = 'N'                                           BUG3760
     C                   EXSR      SrWatch                                                   BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AUTH = STAUTH                                              CAP086
     C                   ENDIF                                                                CAP086

      * Write a record to settlement file

     C                   WRITE     LEFEEADF
      *
      ** Update shadow files for non-write off fee settlements

     C     STTYPE        IFNE      'W'
     C                   CLEAR                   Z#BSTS
     C                   MOVEL     LEFEEAD       Z#ASTS
     C                   EXSR      SRSHDW
     C                   ENDIF

     C     EWRITER       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * AMENDR   : Amend fee settlement record                        *
      *****************************************************************
     C     AMENDR        BEGSR

      * Access the record

     C     FEESK         CHAIN     LEFEEADF                           80
      *
     C     *IN80         IFEQ      *ON
     C     FATNLU        ORNE      H#TNLU
     C     H#TNLU        IFNE      *ZERO
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LER0071'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EAMENDR
     C                   ENDIF
     C                   ENDIF

      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      * Set 'before status' of record (used in shadow updates)

     C                   MOVEL     LEFEEAD       Z#BSTS

     C                   MOVEL     LEVFESTPD     LEFEEAD
     C                   MOVE      LEVFESTEXT    LEFEEAD                                      CGL029
     C                   EVAL      STMP = TimeStamp

      * Status will be authorised if CLE002 is not installed
      * or if authorisation of fee settlement/adjustment is not allowed
      * Otherwise, it could be complete or requring re-authorisation
      * Transactions in batch mode are always authorised

     C     CLE002        IFEQ      'N'
     C     BPFSAU        OREQ      'N'
     C     P#MODE        OREQ      'B'
     C     STAUTH        OREQ      'Y'                                                        CAP086
     C     CAP086        ANDEQ     'Y'                                                        CAP086
     C                   MOVE      'A'           SSTS
     C                   ELSE
     C     SSTS          IFEQ      'A'
     C     SSTS          OREQ      'R'
     C                   MOVE      'R'           SSTS
     C                   ELSE
     C                   MOVE      'C'           SSTS
     C                   ENDIF
     C                   ENDIF

      * User
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5AUSR        AUSR
     C                   ELSE
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   If        USRID  <> *Blank                                           CAP084
     C                   EVAL      AUSR = USRID                                               CAP084
     C                   Else                                                                 CAP084
     C                   MOVE      PsUser        AUSR
     C                   EndIf                                                                CAP084
     C                   ENDIF
      *                                                                                       244273
      ** Update settlement instructions.                                                      244273
      *                                                                                       244273
     C                   IF        W#PTFI <> 'I'                                              244273
     C                   EXSR      SETTLEINS                                                  244273
     C                   ENDIF                                                                244273

      * If CLE009 is installed

     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRSWRI
     C                   ENDIF

      * Settlement instructions

     C     W#PTFI        IFNE      'I'
     C                   ENDIF

                                                                                             BUG3760
      ** If Compliance Watch is installed, and entry watch list checking                     BUG3760
      ** is being applied, perform Compliance Watch processing for amend mode                BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                           BUG3760
                                                                                             BUG3760
     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                          BUG3760
     C                             OR CSC011 = 'N'                                           BUG3760
                                                                                             BUG3760
     C                   EVAL      KIden = *Blanks                                           BUG3760
     C                   EVAL      W2CNUM = *Blanks                                          BUG3760
     C                   EVAL      W2FACL = *Blanks                                          BUG3760
     C                   EVAL      W2FSEQ = *Blanks                                          BUG3760
     C                   EVAL      W2LOAN= *Blanks                                           BUG3760
                                                                                             BUG3760
     C**********         IF        FALOAN = *Zeros                                    BUG3760 CLE148
     C                   IF        FALOAN = *BLANKS                                           CLE148
     C                   MOVE      FACNUM        W2CNUM                                      BUG3760
     C                   MOVE      FAFACL        W2FACL                                      BUG3760
     C                   MOVE      FAFSEQ        W2FSEQ                                      BUG3760
     C                   EVAL      KIDEN = %TRIM(W2CNUM + W2FACL + W2FSEQ)                   BUG3760
     C                   ELSE                                                                BUG3760
     C                   MOVE      FALOAN        W2LOAN                                      BUG3760
     C                   MOVE      FAFSEQ        W2FSEQ                                      BUG3760
     C                   EVAL      KIDEN = %TRIM(W2LOAN + W2FSEQ)                            BUG3760
     C                   ENDIF                                                               BUG3760
     C                   EVAL      KBranch = FABRCA                                          BUG3760
     C                   EVAL      WUNCF = *Blanks                                           BUG3760
     C                   EVAL      KFuncType = 'LEFEEAD'                                     BUG3760
     C     KCWHT         CHAIN     SDCWHTL1                                                  BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                         BUG3760
     C                             OR NOT %FOUND(SDCWHTL1)                                   BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1)                                          BUG3760
     C                   EVAL      WUNCF = W3UNCF                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EXSR      SrWatch                                                   BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AUTH = STAUTH                                              CAP086
     C                   ENDIF                                                                CAP086

      ** Update fee settlement/adjustment file

     C                   UPDATE    LEFEEADF

      ** Update shadow files for non-write off fee settlements

     C     STTYPE        IFNE      'W'
     C                   MOVEL     LEFEEAD       Z#ASTS
     C                   EXSR      SRSHDW
     C                   ENDIF

     C     EAMENDR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * AUTHOR   : Authorise fee settlement record                    *
      *****************************************************************
     C     AUTHOR        BEGSR

      * Access the record

     C     FEESK         CHAIN     LEFEEADF                           80
      *
     C     *IN80         IFEQ      *ON
     C     FATNLU        ORNE      H#TNLU
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LER0071'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EAUTHOR
     C                   ENDIF

      * Action
     C                   MOVE      S#ACTN        FAACTN

      * TNLU
     C                   EXSR      ZTNLU1
     C                   Z-ADD     NATN          FATNLU

      * Status will be authorised
     C                   MOVE      'A'           SSTS

      * User
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5XUSR        XUSR
     C                   ELSE
                                                                                              CAP084
      * Use the job user name or remote (java) user name as appropriate                       CAP084
     C                   If        USRID  <> *Blank                                           CAP084
     C                   EVAL      XUSR = USRID                                               CAP084
     C                   Else                                                                 CAP084
     C                   MOVE      PsUser        XUSR
     C                   EndIf                                                                CAP084
     C                   ENDIF

      * PC reference
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5TNRF        PCRF
     C                   ENDIF

      * If CLE009 is installed

     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRSWRI
     C                   ENDIF

                                                                                             BUG3760
      ** If Compliance Watch is installed, and entry watch list checking                     BUG3760
      ** is being applied, perform Compliance Watch processing.                              BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                           BUG3760
                                                                                             BUG3760
     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                          BUG3760
     C                             OR CSC011 = 'N'                                           BUG3760
                                                                                             BUG3760
     C                   EVAL      KIden = *Blanks                                           BUG3760
     C                   EVAL      W2CNUM = *Blanks                                          BUG3760
     C                   EVAL      W2FACL = *Blanks                                          BUG3760
     C                   EVAL      W2FSEQ = *Blanks                                          BUG3760
     C                   EVAL      W2LOAN= *Blanks                                           BUG3760
                                                                                             BUG3760
     C**********         IF        FALOAN = *Zeros                                    BUG3760 CLE148
     C                   IF        FALOAN = *BLANKS                                           CLE148
     C                   MOVE      FACNUM        W2CNUM                                      BUG3760
     C                   MOVE      FAFACL        W2FACL                                      BUG3760
     C                   MOVE      FAFSEQ        W2FSEQ                                      BUG3760
     C                   EVAL      KIDEN = %TRIM(W2CNUM + W2FACL + W2FSEQ)                   BUG3760
     C                   ELSE                                                                BUG3760
     C                   MOVE      FALOAN        W2LOAN                                      BUG3760
     C                   MOVE      FAFSEQ        W2FSEQ                                      BUG3760
     C                   EVAL      KIDEN = %TRIM(W2LOAN + W2FSEQ)                            BUG3760
     C                   ENDIF                                                               BUG3760
     C                   EVAL      KBranch = FABRCA                                          BUG3760
     C                   EVAL      WUNCF = *Blanks                                           BUG3760
     C                   EVAL      KFuncType = 'LEFEEAD'                                     BUG3760
     C     KCWHT         CHAIN     SDCWHTL1                                                  BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                         BUG3760
     C                             OR NOT %FOUND(SDCWHTL1)                                   BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1)                                          BUG3760
     C                   EVAL      WUNCF = W3UNCF                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EXSR      SrWatch                                                   BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Update fee settlement/adjustment file

     C                   UPDATE    LEFEEADF
     C/COPY WNCPYSRC,LEH01187

     C     EAUTHOR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * DELETR   : Delete fee settlement record                       *
      *****************************************************************
     C     DELETR        BEGSR

      * Access the record

     C     FEESK         CHAIN     LEFEEADF                           80
      *
     C     *IN80         IFEQ      *ON
     C     FATNLU        ORNE      H#TNLU
     C     H#TNLU        IFNE      *ZERO
     C                   MOVE      'N'           S#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'S#CSSN      'FldNameArr(Ix)
     C                   MOVEL     'LER0071'     MsgIdArr(Ix)
     C                   MOVEL     '*RECUPD   '  RetCodeIn
     C                   GOTO      EDELETR
     C                   ENDIF
     C                   ENDIF

      * Set 'before status' of record (used in shadow updates)

     C                   MOVEL     LEFEEAD       Z#BSTS

      * Record ID
     C                   MOVE      '*'           FARECI

      * Action
     C                   MOVE      S#ACTN        FAACTN

      * TNLU
     C                   EXSR      ZTNLU1
     C                   Z-ADD     NATN          FATNLU

      * Status is authorised
     C                   MOVE      'A'           SSTS

      * PC reference
     C     P#MODE        IFEQ      'B'
     C                   MOVE      F5TNRF        PCRF
     C                   ENDIF

      * If CLE009 is installed

     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRSWRI
     C                   ENDIF
                                                                                             BUG3760
      ** If Compliance Watch is installed, and entry watch list checking                     BUG3760
      ** is being applied, perform Compliance Watch processing.                              BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                           BUG3760
                                                                                             BUG3760
     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                          BUG3760
     C                             OR CSC011 = 'N'                                           BUG3760
                                                                                             BUG3760
     C                   EVAL      KIden = *Blanks                                           BUG3760
     C                   EVAL      W2CNUM = *Blanks                                          BUG3760
     C                   EVAL      W2FACL = *Blanks                                          BUG3760
     C                   EVAL      W2FSEQ = *Blanks                                          BUG3760
     C                   EVAL      W2LOAN= *Blanks                                           BUG3760
                                                                                             BUG3760
     C**********         IF        FALOAN = *Zeros                                    BUG3760 CLE148
     C                   IF        FALOAN = *BLANKS                                           CLE148
     C                   MOVE      FACNUM        W2CNUM                                      BUG3760
     C                   MOVE      FAFACL        W2FACL                                      BUG3760
     C                   MOVE      FAFSEQ        W2FSEQ                                      BUG3760
     C                   EVAL      KIDEN = %TRIM(W2CNUM + W2FACL + W2FSEQ)                   BUG3760
     C                   ELSE                                                                BUG3760
     C                   MOVE      FALOAN        W2LOAN                                      BUG3760
     C                   MOVE      FAFSEQ        W2FSEQ                                      BUG3760
     C                   EVAL      KIDEN = %TRIM(W2LOAN + W2FSEQ)                            BUG3760
     C                   ENDIF                                                               BUG3760
     C                   EVAL      KBranch = FABRCA                                          BUG3760
     C                   EVAL      WUNCF = *Blanks                                           BUG3760
     C                   EVAL      KFuncType = 'LEFEEAD'                                     BUG3760
     C     KCWHT         CHAIN     SDCWHTL1                                                  BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                         BUG3760
     C                             OR NOT %FOUND(SDCWHTL1)                                   BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1)                                          BUG3760
     C                   EVAL      WUNCF = W3UNCF                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EXSR      SrWatch                                                   BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760

      ** Update fee settlement/adjustment file

     C                   UPDATE    LEFEEADF

      ** Update shadow files for non-write off fee settlements

     C     STTYPE        IFNE      'W'
     C                   MOVEL     LEFEEAD       Z#ASTS
     C                   EXSR      SRSHDW
     C                   ENDIF
     C/COPY WNCPYSRC,LEH01188

     C     EDELETR       ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * UPDTRL   : Update trailer                                     *
      *****************************************************************
     C     UPDTRL        BEGSR

      * Update trailer LEFEEAZ

     C     1             CHAIN     LEFEEAZ                            80

      *
     C                   SELECT

      **  Inserts
     C     S#ACTN        WHENEQ    'I'
      *
     C                   ADD       1             FANINT
     C                   ADD       1             FANORE

      **  Amend
     C     S#ACTN        WHENEQ    'A'

     C                   ADD       1             FANAMD

      **  Delete
     C     S#ACTN        WHENEQ    'D'

     C                   ADD       1             FANDEL

     C                   ENDSL

     C     *IN80         IFEQ      *OFF
     C                   UPDATE    LEFEEAZF
     C                   ELSE
     C                   MOVE      'Z'           FARECI
     C                   WRITE     LEFEEAZF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SETTLEINS: Settlement instructions                            *
      *****************************************************************
     C     SETTLEINS     BEGSR

      ** Receive Settlement details

     C     W#PTFI        IFEQ      *BLANK

     C                   MOVE      FLRSTM        FAMETH
     C                   MOVE      FLRONS        FAOURS
     C                   MOVEL     FLRIBN        FATHER
     C                   MOVE      FLROBR        FAOSBR

     C                   MOVE      FLRSTM        RSTM
     C                   MOVE      FLRONS        RONS
     C                   MOVEL     FLRIBN        RIBN
     C                   MOVEL     FLRIBA        RIBA
     C                   MOVE      FLROBN        ROBN
     C                   MOVE      FLROCN        ROCN
     C                   MOVE      FLROBR        OSDB
     C                   MOVE      FLRSCY        FASCCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        FAREXR                                       CLE031
     C                   MOVE      FLREXI        FAREXI                                       CLE031
     C                   ENDIF                                                                CLE031

      ** Payment Settlement details

     C                   ELSE
     C     W#PTFI        IFEQ      'P'
     C     W#PTFI        OREQ      'S'                                                        CLE106
     C     W#PTFI        OREQ      'R'                                                        CLE106

     C                   MOVE      FLPSTM        FAMETH
     C                   MOVE      FLPONS        FAOURS
     C                   MOVE      FLPIBN        FATHER
     C                   MOVE      FLPOBR        FAOSBR
      *
     C                   MOVE      FLPSTM        PSTM
     C                   MOVE      FLPONS        PONS
     C                   MOVE      FLPIBN        PIBN
     C                   MOVE      FLPIBA        PIBA
     C                   MOVE      FLPOBN        POBN
     C                   MOVE      FLPOCN        POCN
     C                   MOVE      FLRCRN        RCRN
     C                   MOVE      FLRCRA        RCRA
     C                   MOVE      FLRVNO        RVNO
     C                   MOVEL     FLAWBN        AWBN
     C                   MOVE      FLAWBA        AWBA
     C                   MOVEL     FLBENN        BENN
     C                   MOVE      FLBENA        BENA
     C                   MOVE      FLDTP1        DTP1
     C                   MOVE      FLDTP2        DTP2
     C                   MOVE      FLDTP3        DTP3
     C                   MOVE      FLDTP4        DTP4
     C                   MOVE      FLDCHG        DCHG
     C                   MOVEL     FLBTB1        BTB1
     C                   MOVEL     FLBTB2        BTB2
     C                   MOVEL     FLBTB3        BTB3
     C                   MOVEL     FLBTB4        BTB4
     C                   MOVEL     FLBTB5        BTB5
     C                   MOVEL     FLBTB6        BTB6
     C                   MOVE      FLPOBR        OMDB
     C                   MOVE      FLCVMR        CVMR
     C                   MOVE      FLPSCY        FASCCY
     C                   MOVE      FLIC72        FAICCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLPEXR        FAPEXR                                       CLE031
     C                   MOVE      FLPEXI        FAPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZTNLU1        BEGSR

     C                   CALLB     'ZTNLU1'
     C                   PARM                    RetCodeOut
     C                   PARM                    NATN              5 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRSWRI   : Update fees file                                   *
      *****************************************************************
     C     SRSWRI        BEGSR
      *
      *** If action code is insert
      *
     C     S#ACTN        IFEQ      'I'
     C                   MOVE      *BLANKS       FASTTI
      *
      *** If authorisations switchable feature is off,or authorisations
      *** switchable feature is on and fee settlements authorisations
      *** is not required
      *
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'
     C     BPFSAU        ANDEQ     'N'
     C                   MOVE      *BLANKS       FASWRI
     C                   ELSE
     C                   MOVE      'I'           FASWRI
     C                   ENDIF
     C                   ENDIF
      *
      *** If action code is amend and the settlement date bill/telex
      *** indicator is 'Y' and swift message regeneration indicator is
      *** not 'I' and not 'B'
      *
     C     S#ACTN        IFEQ      'A'
     C     FASTTI        ANDEQ     'Y'
     C     FASWRI        ANDNE     'I'
     C     FASWRI        ANDNE     'B'
      *
      *** If authorisations switchable feature is off,or authorisations
      *** switchable feature is on and fee settlements authorisations
      *** is not required
      *
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'
     C     BPFSAU        ANDEQ     'N'
     C                   MOVE      'A'           FASWRI
     C                   ELSE
     C                   MOVE      'B'           FASWRI
     C                   ENDIF
     C                   ENDIF
      *
      *** If action code is delete and the settlement date bill/telex
      *** indicator is 'Y'
      *
     C     S#ACTN        IFEQ      'D'
     C     FASTTI        ANDEQ     'Y'
     C                   MOVE      'R'           FASWRI
     C                   ENDIF
      *
      *** If action code is authorise
      *
     C     S#ACTN        IFEQ      'X'
      *
     C     FASWRI        IFEQ      'I'
     C                   MOVE      *BLANKS       FASWRI
     C                   ENDIF
      *
     C     FASWRI        IFEQ      'B'
     C                   MOVE      'A'           FASWRI
     C                   ENDIF
      *
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRSHDW   : Update shadow files (PRONO, MEMOS, OLPOS and RSACMTPD)
      *****************************************************************
     C     SRSHDW        BEGSR

      *  Suppress rollback in batch mode

     C     P#MODE        IFEQ      'B'
     C                   MOVE      '*LEBTCH'     P@RTCD
     C                   ELSE
     C                   MOVE      *BLANKS       P@RTCD
     C                   ENDIF

     C                   CALL      'AOOUFAU0'
     C                   PARM                    P@RTCD            7
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS

     C     P@RTCD        IFEQ      '*ERROR*'
     C                   MOVEL     'AOOUFAU0'    DBFILE
     C                   MOVEL     '800'         DBASE
     C                   MOVEL     '*UPDATE'     DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,LEH01189

     C                   ENDSR
      *****************************************************************                       CRE020
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
     C                   MOVE      *BLANKS       KSeqNo                                       CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       WRefNo                                       CRE020
     C                   MOVE      FACNUM        WCustNo                                      CRE020
                                                                                              CRE020
     C**********         IF        FALOAN <> *ZERO                                     CRE020 CLE148
     C                   IF        FALOAN <> *BLANKS                                          CLE148
     C                   MOVEL     FALOAN        WTrnRef                                      CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVEL     FAFACL        WTrnRef                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   MOVEL     WRefNo        KRefNo                                       CRE020
     C                   MOVEL     FAFSEQ        KSeqNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   MOVE      *BLANK        WNew                                         CRE020
                                                                                              CRE020
     C                   OPEN      READVCL2                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL2                                                   CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
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
     C                   IF        FAACTN = ' D'                                              CRE020
     C                   MOVE      'D'           RCHTYP                                       CRE020
     C                   MOVE      'Y'           RSAPIN                                       CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Change type is always 'I' for newly inserted records.                                CRE020
                                                                                              CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute reversal processing if necessary.                                            CRE020
                                                                                              CRE020
     C                   IF        FAACTN = ' D'                                              CRE020
                                                                                              CRE020
      ** Delete the advice index if the current record is a new fee.                          CRE020
      ** Reverse it otherwise.                                                                CRE020
                                                                                              CRE020
     C                   MOVE      'D'           RCHTYP                                       CRE020
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
     C                   IF        FAACTN = ' X'                                              CRE020
     C                   EVAL      RCHTYP = 'A'                                               CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      FAACTN        RCHTYP                                       CRE020
     C                   ENDIF                                                                CRE020
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
     C     KADVC         READE     READVCL2                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************                       CRE020
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxAmd - Handles the advice index during 'A' processing.   *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxAmd      BEGSR                                                                CRE020
                                                                                              CRE020
      ** Initialise key values.                                                               CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       KRefNo                                       CRE020
     C                   MOVE      *BLANKS       KSeqNo                                       CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       WRefNo                                       CRE020
     C                   MOVE      FACNUM        WCustNo                                      CRE020
                                                                                              CRE020
     C**********         IF        FALOAN <> *ZERO                                     CRE020 CLE148
     C                   IF        FALOAN <> *BLANKS                                          CLE148
     C                   MOVEL     FALOAN        WTrnRef                                      CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVEL     FAFACL        WTrnRef                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   MOVEL     WRefNo        KRefNo                                       CRE020
     C                   MOVEL     FAFSEQ        KSeqNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   OPEN      READVCL2                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL2                                                   CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF                                                   CRE020
                                                                                              CRE020
      ** Execute amend processing if necessary.                                               CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'Y' AND                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
     C                   MOVE      'N'           RAUTHI                                       CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1

      * Action Code
     C                   PARM                    S#ACTN            1

      * Fee Settlement Details in file format
     C                   PARM                    LEVFESTPD

      * File Receive instructions
     C                   PARM                    F_REC

      * File Payment instructions
     C                   PARM                    F_PAY

      * Fee currency
     C                   PARM                    S#FCCY            3

      * Value date
     C                   PARM                    W#VDAT            5 0

      * Settlement amount
     C                   PARM                    W#SADJ           13 0

      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0

      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1

      * TNLU of fee settlement record on LEFEEAD
     C                   PARM                    H#TNLU            5 0

      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0

      * Front office inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
     C                   PARM                    F5IUSR           10
     C                   PARM                    F5XUSR           10
     C                   PARM                    F5AUSR           10
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FEST_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0

      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if CLE002 - Lending Authorisations - is Installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'CLE002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CLE002
     C                   ELSE
     C                   MOVEL     'N'           CLE002            1
     C                   ENDIF

      ** Retrieve customer lending data, if CLE002 is Installed

     C     CLE002        IFEQ      'Y'
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

      ** Check if CLE004 - Customer Lending Syndications - is Installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'CLE004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CLE004
     C                   ELSE
     C                   MOVEL     'N'           CLE004            1
     C                   ENDIF

      ** Check if CLE009 - Customer Lending Enhancements - is Installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANKS
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009            1
     C                   ELSE
     C                   MOVE      'N'           CLE009
     C                   ENDIF
     C                   ENDIF

      ** Check if CSC011 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IN        SDSTAT                                                    BUG3760
     C                   IF        PRTCD = *Blanks

     C                   EVAL      CSC011 = 'Y'

     C                   IN        SC24X7
     C**********         IN        SDSTAT                                                    BUG3760

     C                   ELSE

      ** Database error

     C                   IF        PRTCD <> '*NRF'
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF
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
     C                   EVAL      DBase = 101                                                CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      *PSSR                                                      CRE020
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
     C                   EVAL      DBase = 102                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD                                        CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031

      ** Check if CSD015 enhancement is installed.                                           BUG3760
                                                                                             BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRtCd                                       BUG3760
     C                   PARM      '*VERIFY'     POptn                                       BUG3760
     C                   PARM      'CSD015'      PSARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   EVAL      CSD015 = 'N'                                              BUG3760
                                                                                             BUG3760
     C                   IF        PRtCd = *BLANKS                                           BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   IF        PRtCd <> '*NRF'                                           BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 906                                               BUG3760
     C                   EVAL      DBKey = 'CSD015'                                          BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      **  Access SAR details to see if CCF001 is installed.                                  BUG3760
                                                                                             BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRtCd                                       BUG3760
     C                   PARM      '*VERIFY'     POptn                                       BUG3760
     C                   PARM      'CCF001'      PSARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   EVAL      CCF001 = 'N'                                              BUG3760
     C                   IF        PRtCd = *BLANKS                                           BUG3760
     C                   EVAL      CCF001 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
      ** Database error                                                                      BUG3760
                                                                                             BUG3760
     C                   IF        PRtCd <> '*NRF'                                           BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CCF001'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 907                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Check if transactions are being monitored by Compliance Watch.                      BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
                                                                                             BUG3760
     C                   CALL      'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       PRtCd                                       BUG3760
     C                   PARM      '*KEY   '     POptn                                       BUG3760
     C                   PARM      'LENDING '    PFuncCode                                   BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
                                                                                             BUG3760
      ** Database error                                                                      BUG3760
                                                                                             BUG3760
     C                   IF        PRtCd <> *BLANKS AND                                      BUG3760
     C                             PRtCd <> '*NRF'                                           BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'LENDING'                                         BUG3760
     C                   EVAL      DBFile = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBase = 908                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      **  Access the Compliance Watch Configuration Data.                                    BUG3760
                                                                                             BUG3760
     C                   CALL      'AOCWCDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRtCd                                       BUG3760
     C                   PARM      '*FIRST '     POptn                                       BUG3760
     C     SDCWCD        PARM      SDCWCD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRtCd <> *BLANKS                                          BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = @Optn                                             BUG3760
     C                   EVAL      DBFile = 'SDCWCDPD'                                       BUG3760
     C                   EVAL      DBase = 909                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAP086
      ** Check if CAP086 is enabled                                                           CAP086
                                                                                              CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTcd                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ELSE                                                                 CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBase = 910                                                CAP086
     C                   EVAL      DBKey = 'CAP086'                                           CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
      ** Check if CLE073 - Calculation of loan based fees is installed                        CLE073
                                                                                              CLE073
     C                   CALL      'AOSARDR0'                                                 CLE073
     C                   PARM      *BLANKS       @RTCD                                        CLE073
     C                   PARM      '*KEY    '    @OPTN                                        CLE073
     C                   PARM      'CLE073'      @SARD             6                          CLE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE073
                                                                                              CLE073
     C     @RTCD         IFEQ      *BLANKS                                                    CLE073
     C                   MOVEL     'Y'           CLE073                                       CLE073
     C                   ELSE                                                                 CLE073
     C                   MOVEL     'N'           CLE073            1                          CLE073
     C                   ENDIF                                                                CLE073
                                                                                              CLE073
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       @RTCD                                        CSD083
     C                   PARM      '*VERIFY'     @OPTN                                        CSD083
     C                   PARM      'CSD083'      @SARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        @RTCD <> *BLANKS  AND                                      CSD083
     C                             @RTCD <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 911                                                CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        @RTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
     C/COPY WNCPYSRC,LEH01190
                                                                                             BUG3760
      **If*the*user*is*connected*via*a*browser,*the*job*user*name*is*QUSER*-          CAP084 BUG7029
      **the*actual*user*name*is*stored*in*ZMUSER                                      CAP084 BUG7029
     C**********         IN        ZMUSER                                             CAP084 BUG7029

     C     *LIKE         DEFINE    FACNUM        K#CNUM
     C     *LIKE         DEFINE    FAFACL        K#FACL
     C     *LIKE         DEFINE    FALOAN        K#LOAN
     C     *LIKE         DEFINE    FAFSEQ        K#FSEQ
     C     *LIKE         DEFINE    FAVDAT        K#VDAT

      * Key lists

     C     FEESK         KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL
     C                   KFLD                    K#LOAN
     C                   KFLD                    K#FSEQ
     C                   KFLD                    K#VDAT
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
     C                   KFLD                    KSeqNo                                       CRE020

      *                                                                                      BUG3760
      ** Compliance Watch Hit List Key.                                                      BUG3760
      *                                                                                      BUG3760
     C     KCWHT         KLIST                                                               BUG3760
     C                   KFLD                    KFuncType                                   BUG3760
     C                   KFLD                    KIden                                       BUG3760
     C                   KFLD                    KBranch                                     BUG3760
      *                                                                                      BUG3760
      ** OVRDBF LEFEEAL2 to LEFEEAXX then OPEN LEFEEAXX

     C                   EVAL      LENGTH = %SIZE(OVRDBF1)
     C                   CALL      'QCMDEXC'
     C                   PARM      OVRDBF1       QCMD             70
     C                   PARM                    LENGTH           15 5
     C                   OPEN      LEFEEAXX
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      ******/COPY ZACPYSRC,PSSR_ILE                                                           CAP084
      *****************************************************************                       CAP084
      * The following /COPY contains the standard program status                              CAP084
      * subroutine, excluding a bound call to the DBERRCTL module.                            CAP084
      *****************************************************************                       CAP084
     C/COPY ZACPYSRC,PSSR_ILENE                                                               CAP084
                                                                                              CAP084
     C                   IF        RunBefore2 <> 'Y'                                          CAP084
                                                                                              CAP084
     C                   EVAL      RunBefore2 = 'Y'                                           CAP084
                                                                                              CAP084
      ** Load the APDUMP fields                                                               CAP084
     C     *lock         IN        APDUMP                               99                    CAP084
                                                                                              CAP084
      ** If there is an error in reading the APDUMP data area, it                             CAP084
      ** probably doesn't exist, so call the procedure which creates it                       CAP084
      ** and try again.                                                                       CAP084
     C                   IF        *in99                                                      CAP084
                                                                                              CAP084
     C                   CLEAR                   PSSRRetCde                                   CAP084
     C                   CALL      'APCCRTQTO'                                                CAP084
     C                   PARM                    PSSRRetCde       10                          CAP084
                                                                                              CAP084
     C     *lock         IN        APDUMP                                                     CAP084
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   EVAL      ARErrMod = PSProcMod                                       CAP084
     C                   OUT       APDUMP                                                     CAP084
                                                                                              CAP084
     C                   CALLB     'DBERRCTL'                                                 CAP084
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
     C                   If        RetCodeIn = *Blanks                                        CAP084
     C                   EVAL      RetCodeIn = '*ERROR'                                       CAP084
     C                   EndIf                                                                CAP084
     C                   RETURN                                                               CAP084
     C                   ENDSR                                                                CAP084
      *****************************************************************                       CAP084
      /EJECT                                                                                  CAP084
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SrWatch - Perform Midas Watch List processing.                *                      BUG3760
      *                                                               *                      BUG3760
      * Called by: SR/WRITER, SR/AMENDR, SR/AUTHOR, SR/DELETR         *                      BUG3760
      *                                                               *                      BUG3760
      * Calls: None                                                   *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SrWatch       BEGSR                                                               BUG3760
                                                                                             BUG3760
     C                   CLEAR                   SDWLTD                                      BUG3760
     C                   CLEAR                   PString                                     BUG3760
     C                   EVAL      U = *Zeros                                                BUG3760
     C                   EVAL      Fld1 = *Blanks                                            BUG3760
     C                   EVAL      Fld2 = *Blanks                                            BUG3760
     C                   EVAL      Fld3 = *Blanks                                            BUG3760
     C                   EVAL      Fld4 = *Blanks                                            BUG3760
     C                   EVAL      Fld5 = *Blanks                                            BUG3760
     C                   IF        FAPSCY <> *Blanks                                         BUG3760
     C                   EVAL      PInCcy = FAPSCY                                           BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      PInCcy = FAFCCY                                           BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Receipt Nostro                                                                      BUG3760
     C                   IF        RONS <> *Blanks                                           BUG3760
                                                                                             BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  RONS <> STRONS                         BUG3760
     C                   EVAL      Fld1 = RONS                                               BUG3760
     C                   EVAL      U = 1                                                     BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Receipt Ordering Customer                                                           BUG3760
     C**********         IF        ROCN <> *Zeros                                     BUG3760 CSD027
     C                   IF        ROCN <> *Blanks                                            CSD027
                                                                                             BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  ROCN <> STROBN                         BUG3760
     C                   MOVEL     ROCN          Fld1                                        BUG3760
     C                   EVAL      U = 3                                                     BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Receipt Ordering Bank                                                               BUG3760
     C**********         IF        ROBN <> *Zeros                                     BUG3760 CSD027
     C                   IF        ROBN <> *Blanks                                            CSD027
                                                                                             BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  ROBN <> STROBN                         BUG3760
     C                   MOVEL     ROBN          Fld1                                        BUG3760
     C                   EVAL      U = 5                                                     BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Receipt Intermediary Bank                                                           BUG3760
     C                   IF        RIBN <> *Blanks                                           BUG3760
                                                                                             BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  RIBN <> STRIBN OR                      BUG3760
     C                             STACTN = 'A'  AND  RIBA <> STRIBA                         BUG3760
     C                   EVAL      Fld1 = RIBN                                               BUG3760
     C                   EVAL      Fld2 = RIBA                                               BUG3760
     C                   EVAL      U = 7                                                     BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Pay Nostro                                                                          BUG3760
     C                   IF        PONS <> *Blanks                                           BUG3760
                                                                                             BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  PONS <> STPONS                         BUG3760
     C                   EVAL      Fld1 = PONS                                               BUG3760
     C                   EVAL      U = 9                                                     BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Pay Ordering Customer                                                               BUG3760
     C**********         IF        POCN <> *Zeros                                     BUG3760 CSD027
     C                   IF        POCN <> *Blanks                                            CSD027
                                                                                             BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  POCN <> STPOCN                         BUG3760
     C                   MOVEL     POCN          Fld1                                        BUG3760
     C                   EVAL      U = 11                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Pay Ordering Bank                                                                   BUG3760
     C**********         IF        POBN <> *Zeros                                     BUG3760 CSD027
     C                   IF        POBN <> *Blanks                                            CSD027
                                                                                             BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  POBN <> STPOBN                         BUG3760
     C                   MOVEL     POBN          Fld1                                        BUG3760
     C                   EVAL      U = 13                                                    BUG3760
     C                   MOVEL     POCN          Fld1                                        BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Pay Intermediary Bank                                                               BUG3760
     C                   IF        PIBN <> *Blanks                                           BUG3760
                                                                                             BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  PIBN <> STPIBN OR                      BUG3760
     C                             STACTN = 'A'  AND  PIBA <> STPIBA                         BUG3760
     C                   EVAL      Fld1 = PIBN                                               BUG3760
     C                   EVAL      Fld2 = PIBA                                               BUG3760
     C                   EVAL      U = 15                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Receivers Correspondent                                                             BUG3760
     C                   IF        RCRN <> *Blanks                                           BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  RCRN <> STRCRN                         BUG3760
     C                   EVAL      Fld1 = RCRN                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ELSE                                                                BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  RCRA <> STRCRA                         BUG3760
     C                   EVAL      Fld1 = RCRA                                               BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        Fld1 <> *Blanks                                           BUG3760
     C                   EVAL      U = 17                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Receiver Number                                                                     BUG3760
     C                   IF        RVNO <> *Blanks                                           BUG3760
                                                                                             BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  RVNO <> STRVNO                         BUG3760
     C                   EVAL      Fld1 = RVNO                                               BUG3760
     C                   EVAL      U = 19                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Account with Bank                                                                   BUG3760
     C                   IF        AWBN <> *Blanks                                           BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  AWBN <> STAWBN                         BUG3760
     C                   EVAL      Fld1 = AWBN                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ELSE                                                                BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  AWBA <> STAWBA                         BUG3760
     C                   EVAL      Fld1 = AWBA                                               BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        Fld1 <> *Blanks                                           BUG3760
     C                   EVAL      U = 21                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Beneficiary                                                                         BUG3760
     C                   IF        BENN <> *Blanks                                           BUG3760
                                                                                             BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  BENN <> STBENN OR                      BUG3760
     C                             STACTN = 'A'  AND  BENA <> STBENA                         BUG3760
     C                   EVAL      Fld1 = BENN                                               BUG3760
     C                   EVAL      Fld2 = BENA                                               BUG3760
     C                   EVAL      U = 23                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Details of Payment                                                                  BUG3760
     C                   IF        DTP1 <> *Blanks  OR  DTP2 <> *Blanks  OR                  BUG3760
     C                             DTP3 <> *Blanks  OR  DTP4 <> *Blanks                      BUG3760
                                                                                             BUG3760
     C                   IF        STACTN = 'I'  OR  WUNCF = 'Y' OR                          BUG3760
     C                             STACTN = 'A'  AND  DTP1 <> STDTP1  OR                     BUG3760
     C                             STACTN = 'A'  AND  DTP2 <> STDTP2  OR                     BUG3760
     C                             STACTN = 'A'  AND  DTP3 <> STDTP3  OR                     BUG3760
     C                             STACTN = 'A'  AND  DTP4 <> STDTP4                         BUG3760
     C                   EVAL      Fld1 = DTP1                                               BUG3760
     C                   EVAL      Fld2 = DTP2                                               BUG3760
     C                   EVAL      Fld3 = DTP3                                               BUG3760
     C                   EVAL      Fld4 = DTP4                                               BUG3760
     C                   EVAL      U = 25                                                    BUG3760
     C                   EXSR      SRConvert                                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      *                                                                                      BUG3760
      ** If second parameter is not blank, setup first parameter and                         BUG3760
      ** send transaction details to Compliance Watch by calling SDCWLCHK                    BUG3760
      *                                                                                      BUG3760
     C                   IF        PString <> *Blanks                                        BUG3760
                                                                                             BUG3760
     C                   EXSR      SRSet1stParm                                              BUG3760
                                                                                             BUG3760
     C                   CALL      'SDCWLCHK'                                                BUG3760
     C                   PARM                    SDWLTD                                      BUG3760
     C                   PARM                    PString                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRSet1stParm - Setup first parameter of SDCWLCHK.             *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRSet1stParm  BEGSR                                                               BUG3760
                                                                                             BUG3760
      ** Item Type Code                                                                      BUG3760
     C                   EVAL      W4ITEM = 'LEFESA'                                         BUG3760
                                                                                             BUG3760
      ** Identifier                                                                          BUG3760
     C**********         IF        FALOAN = *Zeros                                    BUG3760 CLE148
     C                   IF        FALOAN = *BLANKS                                           CLE148
     C                   EVAL      W4IDEN = *Blanks                                          BUG3760
     C                   MOVEL     FACNUM        W2CNUM                                      BUG3760
     C                   MOVEL     FAFACL        W2FACL                                      BUG3760
     C                   MOVEL     FAFSEQ        W2FSEQ                                      BUG3760
     C                   EVAL      W4IDEN = %TRIM(W2CNUM + W2FACL + W2FSEQ)                  BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4IDEN = *Blanks                                          BUG3760
     C                   MOVEL     FALOAN        W2LOAN                                      BUG3760
     C                   MOVEL     FAFSEQ        W2FSEQ                                      BUG3760
     C                   EVAL      W4IDEN = %TRIM(W2LOAN + W2FSEQ)                           BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Branch                                                                              BUG3760
     C                   EVAL      W4BRCH = FABRCA                                           BUG3760
                                                                                             BUG3760
      ** System                                                                              BUG3760
      ** If Midas 24x7 is installed, use Main system prefix otherwise use system prefix      BUG3760
     C                   IF        CSC011 = 'Y'                                              BUG3760
     C                   EVAL      W4SYSM = S1MAIN                                           BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4SYSM = LIBR                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Function Type                                                                       BUG3760
     C                   EVAL      W4FUNT = 'LEFEEAD'                                        BUG3760
                                                                                             BUG3760
      ** Counterparty Details                                                                BUG3760
     C                   EXSR      SRGetCtrpDet                                              BUG3760
     C                   MOVEL     FACNUM        W4CNUM                                      BUG3760
     C                   EVAL      W4CTYP = WCtrpTyp                                         BUG3760
     C                   EVAL      W4CUST = WCtrpRpt                                         BUG3760
                                                                                             BUG3760
      ** Deal Date                                                                           BUG3760
     C                   MOVE      *Blanks       PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4DDAT = WDDT                                             BUG3760
                                                                                             BUG3760
      ** Value Date                                                                          BUG3760
     C                   MOVE      FASADD        PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4VDAT = WDDT                                             BUG3760
                                                                                             BUG3760
      ** Maturity Date                                                                       BUG3760
     C                   MOVE      *Blanks       PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4MDAT = WDDT                                             BUG3760
                                                                                             BUG3760
      ** Denomination Side 1                                                                 BUG3760
     C                   EVAL      W4DEN1  = FAFCCY                                          BUG3760
                                                                                             BUG3760
      ** Denomination Side 2                                                                 BUG3760
     C                   EVAL      W4DEN2  = *Blanks                                         BUG3760
                                                                                             BUG3760
      ** Amount Side 1                                                                       BUG3760
     C                   EVAL      PZACcy = FAFCCY                                           BUG3760
     C                   MOVE      FASADJ        PZAAmt                                      BUG3760
     C                   EXSR      SRAmtToFPDT                                               BUG3760
     C                   EVAL      W4AMT1 = WFPDT                                            BUG3760
                                                                                             BUG3760
      ** Amount Side 2                                                                       BUG3760
     C                   EVAL      W4AMT2 = *Zeros                                           BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRDateToDDT - Converts a date into Date Data Type format.     *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRDateToDDT   BEGSR                                                               BUG3760
                                                                                             BUG3760
      ** Convert the derived Midas Day Number into Date Data Type.                           BUG3760
                                                                                             BUG3760
     C                   CALL      'ZACVTDATE'                                               BUG3760
     C                   PARM      *BLANKS       PZARtCd                                     BUG3760
     C                   PARM                    PZADayNo                                    BUG3760
     C                   PARM                    PZADDT                                      BUG3760
     C                   PARM                    PConvtDate                                  BUG3760
                                                                                             BUG3760
     C                   EVAL      WDDT = PZADDT                                             BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRAmtToFPDT - Converts an amount into Floating Point Data     *                      BUG3760
      *               Type format.                                    *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRAmtToFPDT   BEGSR                                                               BUG3760
      *                                                                                      BUG3760
      ** Directly convert the given amount into Floating Point format.                       BUG3760
      *                                                                                      BUG3760
     C                   CALL      'ZACVTAMT'                                                BUG3760
     C                   PARM      *BLANKS       PZARtCd                                     BUG3760
     C                   PARM                    PZACcy                                      BUG3760
     C                   PARM                    PZAAmt                                      BUG3760
     C                   PARM                    PZOutAmt                                    BUG3760
     C                   PARM                    PZCvtAmt                                    BUG3760
      *                                                                                      BUG3760
     C                   EVAL      WFPDT = PZOutAmt                                          BUG3760
      *                                                                                      BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRGetCtrpDet - Gets the Counterparty Details given a Customer *                      BUG3760
      *                Number.                                        *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRGetCtrpDet  BEGSR                                                               BUG3760
      *                                                                                      BUG3760
      ** Initialise the relevant variables.                                                  BUG3760
      *                                                                                      BUG3760
     C                   EVAL      WCtrpRpt = *BLANKS                                        BUG3760
     C                   EVAL      WCtrpTyp = *BLANKS                                        BUG3760
     C                   MOVEL     FACNUM        PCustNo                                     BUG3760
      *                                                                                      BUG3760
      ** Get the Customer Detail.                                                            BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOCUSTR0'                                                BUG3760
     C                   PARM      *BLANKS       PRtCd                                       BUG3760
     C                   PARM      '*KEY   '     POptn                                       BUG3760
     C                   PARM                    PCustNo                                     BUG3760
     C                   PARM      *BLANKS       PErrInf                                     BUG3760
     C     SDCUST        PARM      SDCUST        DSSDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        PRtCd = *BLANKS                                           BUG3760
      *                                                                                      BUG3760
      ** Assemble the Counterparty Report information.                                       BUG3760
      *                                                                                      BUG3760
     C     BBCRNM        CAT       BBCRTN        WCtrpRpt                                    BUG3760
      *                                                                                      BUG3760
      ** Determine the Counterparty Type.                                                    BUG3760
      *                                                                                      BUG3760
     C                   IF        CCF001 = 'Y'                                              BUG3760
      *                                                                                      BUG3760
     C                   IF        BBCRPC = 'Y'                                              BUG3760
     C                   EVAL      WCtrpTyp = 'C'                                            BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      WCtrpTyp = 'I'                                            BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ELSE                                                                BUG3760
      *                                                                                      BUG3760
     C                   IF        BBLICD <> *BLANKS AND                                     BUG3760
     C                             BBLICD <> W1IND1  AND                                     BUG3760
     C                             BBLICD <> W1IND2  AND                                     BUG3760
     C                             BBLICD <> W1IND3  AND                                     BUG3760
     C                             BBLICD <> W1IND4  AND                                     BUG3760
     C                             BBLICD <> W1IND5                                          BUG3760
     C                   EVAL      WCtrpTyp = 'C'                                            BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      WCtrpTyp = 'I'                                            BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ELSE                                                                BUG3760
      *                                                                                      BUG3760
      ** Handle Database Errors if any occur.                                                BUG3760
      *                                                                                      BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = POptn                                             BUG3760
     C                   EVAL      DBFile = 'SDCUSTPD'                                       BUG3760
     C                   EVAL      DBase = 21                                                BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRConvert - Subroutine to convert accounts, customer no. to   *                      BUG3760
      *             customer name and address.                        *                      BUG3760
      * Called by: SRWatch                                            *                      BUG3760
      *                                                               *                      BUG3760
      * Calls: SDCWHLCHK                                              *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRConvert     BEGSR                                                               BUG3760
                                                                                             BUG3760
     C                   EVAL      OutFmt = *Blanks                                          BUG3760
     C                   EVAL      PInput = *Blanks                                          BUG3760
     C                   EVAL      PInput1 = *Blanks                                         BUG3760
     C                   EVAL      PInput2 = *Blanks                                         BUG3760
     C                   EVAL      PInput3 = *Blanks                                         BUG3760
     C                   EVAL      PInput4 = *Blanks                                         BUG3760
                                                                                             BUG3760
     C                   CALL      'SDCWLFMT'                                                BUG3760
     C                   PARM      *Blanks       PRtcd                                       BUG3760
     C                   PARM      Fld1          PInput                                      BUG3760
     C                   PARM      Fld2          PInput1                                     BUG3760
     C                   PARM      Fld3          PInput2                                     BUG3760
     C                   PARM      Fld4          PInput3                                     BUG3760
     C                   PARM      Fld5          PInput4                                     BUG3760
     C                   PARM                    PInput5                                     BUG3760
     C                   PARM                    PInCcy                                      BUG3760
     C                   PARM                    OutFmt                                      BUG3760
     C                   PARM                    OutFmt2                                     BUG3760
                                                                                             BUG3760
     C                   EVAL      Fld1 = *Blanks                                            BUG3760
     C                   EVAL      Fld2 = *Blanks                                            BUG3760
     C                   EVAL      Fld3 = *Blanks                                            BUG3760
     C                   EVAL      Fld4 = *Blanks                                            BUG3760
     C                   EVAL      Fld5 = *Blanks                                            BUG3760
                                                                                             BUG3760
     C     PString       CAT       WLARR(U):0    PString                                     BUG3760
     C     PString       CAT       OUTFMT:0      PString                                     BUG3760
     C                   EVAL      U = U+1                                                   BUG3760
     C     PString       CAT(P)    WLARR(U):0    PString                                     BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      ********************************************************************                    CAP084
**  CPY@
(c) Finastra International Limited 2002
** WLArr - Watch List Description Array                                                      BUG3760
<Receipt Nostro>                   </Receipt Nostro>                                         BUG3760
<Receipt Ordering Customer>        </Receipt Ordering Customer>                              BUG3760
<Receipt Ordering Bank>            </Receipt Ordering Bank>                                  BUG3760
<Receipt Intermediary Bank>        </Receipt Intermediary Bank>                              BUG3760
<Pay Nostro>                       </Pay Nostro>                                             BUG3760
<Pay Ordering Customer>            </Pay Ordering Customer>                                  BUG3760
<Pay Ordering Bank>                </Pay Ordering Bank>                                      BUG3760
<Pay Intermediary Bank>            </Pay Intermediary Bank>                                  BUG3760
<Receivers Correspondent>          </Receivers Correspondent>                                BUG3760
<Receiver Number>                  </Receiver Number>                                        BUG3760
<Account with Bank>                </Account with Bank>                                      BUG3760
<Beneficiary>                      </Beneficiary>                                            BUG3760
<Details of Payment>               </Details of Payment>                                     BUG3760
