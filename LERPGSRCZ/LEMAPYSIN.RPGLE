     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual Repayment input - Input')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEMAPYSIN - LE Manual Repayment input                        *
      *                                                               *
      *  Function:  This is the screens input function for            *
      *             Manual Repayment                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD036070           Date 19Oct15               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 AR830785           Date 07May13               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 14Feb07               *
      *                 245082             Date 29Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG4351            Date 23Sep04               *
      *                 BUG3114            Date 08Aug04               *
      *                 CLE025             Date 20May04               *
      *                 CDL018             Date 03Feb04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE005             Date 14Jan03               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  AR830785 - Looping on insert of accrued interest adjustment  *
      *             Extended core fix 263533. (Child: AR830786)       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  244636 - If no settlement details for a MAPY are entered     *
      *           then default settlement details from related loan   *
      *  245082 - Corrected processing for ADDI = 'B' to treat it as  *
      *           First day from start date and to add 1 day on       *
      *           maturity date.                                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG4351 - Remove the use of work fields to suppress warning  *
      *            errors being re-displayed when data unchanged.     *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE005 - Reservation ID                                      *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************
      ***  FILES  ***
      *
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Facility Details file
     F                                     Include(FCLTYFMF)
     F                                     Prefix(FC_)
     FLELOAML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(LOAMSDKF:LOAMRPY)
      ***  Midas Loan Amendment File (Live Record)
     F                                     PREFIX(RPY_)
      *
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      *
      ***  Compile time Array
     D POWER           S              7S 3 DIM(7) CTDATA PERRCD(1)
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D CrMaPyFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Current Manual Repayment File Format
     D                                     PREFIX(L)
      *
     D PDLoAmFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Past Due/Repayment Scheduled Loan Amendment Details in file Format  (from RTV)
     D                                     PREFIX(PD_)
      *
     D CrMaPyScnFmt  E DS                  EXTNAME(LEMAPYPD)
      ***  (Current) Manual Repayment input in Screen format
     D                                     PREFIX(@)
      *
     D NwMaPyFilFmt  E DS                  EXTNAME(LEVMAPYPD)
      ***  New Manual Repayment input in file format
     D**MR_REC**              321    389                                                      CGL029
     D**MR_PAY**              390    948                                                      CGL029
     D MR_REC                335    389                                                       CGL029
     D MR_PAY                404    948                                                       CGL029
     D MR_RECEx             1195   1212                                                       CGL029
     D MR_PAYEx             1213   1230                                                       CGL029
      *
     D NwMaPyScnFmt  E DS                  EXTNAME(LEMAPYPD)
      ***  New Manual Repayment input in Screen Format
      *
     D ErrorMaPy     E DS                  EXTNAME(LEEMAPYPD)
      ***  Error indicators Screen 1
      *
      **********************************
      ** Settlement instructions part **
      **********************************
      *
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ***  File Receive Instructions
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
      *
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      ***  File Payment Instructions
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
      *
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ***  File FRA/IRS Instructions
      *
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ***  Screen Receive Instructions
      *
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ***  Screen Payment Instructions
      *
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ***  Screen FRA/IRS Instructions
      *
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) Prefix(WrkLn)
      ***  Loan PAyment/receipt instructions
     D***LoanRecInst          459    527                                                      CGL029
     D***LoanPayInst          528   1086                                                      CGL029
     D  LoanRecInst          473    527                                                       CGL029
     D  LoanPayInst          542   1086                                                       CGL029
     D  LoanRecInstEx       1597   1614                                                       CGL029
     D  LoanPayInstEx       1615   1632                                                       CGL029
      *
 
     D @CCI@           DS
      ***  Current control indicators for details screens 1
      *
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3                                         F7
     D  @EINKH                 4      4                                         F8
     D  @EINKJ                 5      5                                         F10
     D  @EINKN                 6      6                                         F14
     D  @EINKP                 7      7                                         F15
     D  @EINKQ                 8      8                                         F16
      *
     D @PCI@           DS             8
      ***  Previous control indicators for details screen
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Midas Cust. Lending ICD accessed via access program
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ***  Midas SE Trading ICD accessed via access program
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ***  Midas General Ledger ICD accessed via access program
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D QQACCD2       E                     EXTFLD(QQACCD)                                     CGL029
      ***  Midas Retail ICD accessed via access program
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details accessed via access program
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  Midas Feature details accessed via access program
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
      *
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for access programs, long data structure
      *
     D ExtData       E DS                  EXTNAME(LEMAEXPD)
      ***  LE (MAPY) Extra Data - File (D/B) format
      *
     D***NewSettlDS     DS            34                                                      CGL029
     D  NewSettlDS     DS            40                                                       CGL029
      ***  New settlement details for Loan Amendments
     D  WTYPE                  1      2
     D***WOURS**                3     14                                                      CGL029
     D***WTHRS**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D  WOURS                  3     20                                                       CGL029
     D  WTHRS                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
      *
      *
     D***OldSettlDS     DS            34                                                      CGL029
     D  OldSettlDS     DS            40                                                       CGL029
      ***  Current Settlement details for Loan Amendment
      *
     D  OSETP                  1      2  0
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
      *
      *
      *
     D                 DS
      ***  Last change data - LOAMS
     D  WLCD                   1      5  0
     D  WCHTP                  6      6
     D  WTNLU                  7     11  0
     D  WLSTC                  1     11
      *
      ** Work array for warning message Ids
     D*WPrvWarnAr****  S                   Dim(ArrayMax)                                     BUG4351
     D**********                           Like(WMsgIDArr)                                   BUG4351
     D WReDisplay      S              1A
     D*WiX******       S              3P 0                                                   BUG4351
 
     D PassDtaDS       DS           512
     D CLE002                  1      1A
     D CLE003                  2      2A
     D CLE004                  3      3A
     D CLE005                  4      4A
     D CLE007                  5      5A
     D CLE009                  6      6A
     D CLE014                  7      7A
     D CLE023                  8      8A
     D CEU004                  9      9A
     D CDE001                 10     10A
     D WrkDDESEQ              11     13A
     D WrkDDPASD              14     14A
     D WrkCntrMR              15     15  0
     D WrkReactFacil          16     16
      *
     D  ZOUT22         DS            22
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
     D  ZNEG                  21     21
      *                                                                                      BUG3114
      ** Data structure to define variables used in holiday sub-routines                     BUG3114
      *                                                                                      BUG3114
     D  ZIND           S              1                                                      BUG3114
     D  ZDAYNO         S              5  0                                                   BUG3114
     D  ZCCY           S              3                                                      BUG3114
     D  ZLOC           S              3                                                      BUG3114
      *
     D                 DS
     D  TmpLPAM                1     13 00
     D  TmpRATE1               1     13 07
      *
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ***  Response Mode, passed as a constant parameter to the VAL module
      ***  This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('2')
      *
      ***  Work variables for F7 and F8 processing.
      *
     D WKLNRF          S                   Like(DDLNRF)
     D WKVALD          S                   Like(DDVALD)
     D WKSEQN          S                   Like(DDSEQN)
     D WKFRTN          S                   Like(DDFRTN)
     D WKACTN          S                   Like(DDACTN)
     D WKEVAL          S                   Like(DDEVAL)
     D WKESEQ          S                   Like(DDESEQ)
     D WKCUST          S                   Like(DDCUST)
     D WOSAC           S             18A                                                      CGL029
      *
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CSC022
      ** Parameter for LERPSCRTV to retrive Extended settlement intruction                    244636
     D***PRcvParm        S             92                                            244636  CSF011A
     D PRcvParm        S            335                                                      CSF011A
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
      *                                                                                       244636
      ** Parameters for calling AOSVALR0 (System Value Access Object)                         CLE148
      *                                                                                       CLE148
     D PRetCode        S              7A                                                      CLE148
     D PSysValK1       S             20A                                                      CLE148
     D PSysVal1        S            200A                                                      CLE148
     D PSysValK2       S             20A                                                      CLE148
     D PSysVal2        S            200A                                                      CLE148
     D PSysValK3       S             20A                                                      CLE148
     D PSysVal3        S            200A                                                      CLE148
     D PSysValK4       S             20A                                                      CLE148
     D PSysVal4        S            200A                                                      CLE148
     D PSysValK5       S             20A                                                      CLE148
     D PSysVal5        S            200A                                                      CLE148
     D PSysValK6       S             20A                                                      CLE148
     D PSysVal6        S            200A                                                      CLE148
     D PSysValK7       S             20A                                                      CLE148
     D PSysVal7        S            200A                                                      CLE148
     D PSysValK8       S             20A                                                      CLE148
     D PSysVal8        S            200A                                                      CLE148
     D PSysValK9       S             20A                                                      CLE148
     D PSysVal9        S            200A                                                      CLE148
     D PSysValK10      S             20A                                                      CLE148
     D PSysVal10       S            200A                                                      CLE148
      *                                                                                       CLE148
     D wLoanAlpha      S              1A                                                      CLE148
     D @ERRDTA         S              2A                                                      CLE148
      *                                                                                       CLE148
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ***  Read next browse subfile record
 
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
 
      ***  Read next browse subfile record
 
     C     @SCRN         IFEQ      'B'
     C                   EXSR      BLDBRW
     C                   ENDIF
 
      ***  Do while screen: Screen details
 
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   ENDDO
 
      ***  Do while screen: Settlement details
 
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   ENDDO
 
      ***  Screen: Confirmation of input
 
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   ENDIF
 
      ***  Do file updates
 
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
 
      ***  Terminate program
 
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      * SCRN@M - Process details screen                               *
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      ***  Update 'previous' Manual Repayment  input & screen control indicator
      *
     C                   MOVEL     DDACTN        @PACTN            1            Action
     C                   MOVEL     DDLNRF        @PLNRF            6            Loan Number
     C                   MOVEL     DDVALD        @PVALD            6            Value Date
     C                   MOVEL     DDSEQN        @PSEQN            3             Seq
     C                   MOVEL     DDEVAL        @PEVAL            6            Exp. Value Date
     C                   MOVEL     DDESEQ        @PESEQ            3            Exp.  Seq
     C                   MOVEL     WRKLNADIF     @ADIF             1            Int Ref      BUG3114
     C                   MOVEL     WRKLNADCF     @ADCF             1            Chg Ref      BUG3114
     C                   MOVEL     WRKLNPTYP     WrkProcTypLoan    2 0          Loan Typ     BUG3114
      *
      *
      ***  Write/Read display screen
      *
     C                   CALLB     'LEMAPYDSP'
      *
      ***  Input parameters
      *
     C                   PARM      *BLANKS       RetCodeOut                     Ret code
     C                   PARM                    NwMaPyScnFmt                   Man. Repayment Scrn
      ***  Fields in error
     C                   PARM                    ErrorMaPy
      ***  Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Enabled key & detail fields
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      ***  Enabled function keys
     C                   PARM                    @EINKG                         enable F7
     C                   PARM                    @EINKH                                F8
     C                   PARM                    @EINKJ                                F10
     C                   PARM                    @EINKN                                F14
     C                   PARM                    @EINKP                                F15
     C                   PARM                    @EINKQ                                F16
      ***  Activated Features
     C                   PARM                    @EIN67            1            Cust OK
     C                   PARM                    CLE005                         Feature
     C                   PARM      CLE003        @EIN88            1
     C                   PARM      CLE007        @EIN89            1
     C                   PARM                    WrkExpAmdTp       2            PD/RE Amend Type
     C                   PARM                    WrkRepayTp        1 0          Loan Repay. Type
     C                   PARM                    WrkProcTypLoan    2 0          Loan Proc. Type
      *
      ***  Succesful insert
     C                   PARM                    @LSSQ             3
     C                   PARM                    @LNRF             6
     C                   PARM                    @VDAT             6
      ***  Add on Interest/Charge flag                                                       BUG3114
     C                   PARM                    @ADIF                                       BUG3114
     C                   PARM                    @ADCF                                       BUG3114
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
     C                   PARM      *OFF          @INKC             1            F3
     C                   PARM      *OFF          @INKG             1            F7
     C                   PARM      *OFF          @INKH             1            F8
     C                   PARM      *OFF          @INKJ             1            F10
     C                   PARM      *OFF          @INKL             1            F12
     C                   PARM      *OFF          @INKN             1            F14
     C                   PARM      *OFF          @INKP             1            F15
     C                   PARM      *OFF          @INKQ             1            F16
     C                   PARM      'N'           WriteOnly         1
      *
      ***  Keep Warning Array
      *
     C**********         MOVEA     WMsgIDArr     WPrvWarnAr                                  BUG4351
      *
      ***  Reset errors file and check function keys
      *
     C                   MOVE      *ALL'Y'       ErrorMaPy
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  If F15 (browse) first need to change screen flag to 'B'
      *
     C                   IF        @INKP = *ON
     C                   EVAL      @SCRN = 'B'
     C                   ENDIF
      *
     C                   IF        @EKYFD = 'Y'
     C                   EVAL      WREDISPLAY = *BLANKS
     C                   ENDIF
      *
      ***  F3 - End program
      *
     C     @INKC         CASEQ     *ON           ENDP
      *
      ***  F7 - Roll Backwards
      *
     C     @INKG         CASEQ     *ON           ROLL
      *
      ***  F8 - Roll Forwards
      *
     C     @INKH         CASEQ     *ON           ROLL
      *
      ***  F12 - Cancel
      *
     C     @INKL         CASEQ     *ON           CANC@M
      *
      ***  F15 - Browse
      *
     C     @INKP         CASEQ     *ON           BLDBRW
      *
      ***  Validate input to details screen
      *
     C                   CAS                     VAL@M
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - Validate input to details screen                     *
      *****************************************************************
     C     VAL@M         BEGSR
      *
      ***  If action code, loan number , value date, Sequence
      ***                 Expected date, Sequence are left blanks
      ***  ==> Re-output screen
      *
     C     DDACTN        IFEQ      *BLANKS
     C     DDLNRF        ANDEQ     *BLANKS
     C     DDVALD        ANDEQ     *BLANKS
     C     DDSEQN        ANDEQ     *BLANKS
     C                   Eval      @EIN67 = 'N'                                 Reset Cust. OK
     C                   END
      *
      ***  Retrieve Manual Repayment details, while key is not validated
      *
     C                   if        @EKYFD = 'Y'                                 key fld not valid
     C                             or DDACTN = 'X' and @RDNB = 'Y'
 
     C     DDACTN        IFNE      @PACTN
     C     DDLNRF        ORNE      @PLNRF
     C     DDVALD        ORNE      @PVALD
     C     DDSEQN        ORNE      @PSEQN
     C     DDEVAL        ORNE      @PEVAL
     C     DDESEQ        ORNE      @PESEQ
     C                   EVAL      WKLNRF = DDLNRF
     C                   EVAL      WKVALD = DDVALD
     C                   EVAL      WKSEQN = DDSEQN
     C                   EVAL      WKFRTN = DDFRTN
     C                   EVAL      WKACTN = DDACTN
     C                   EVAL      WKEVAL = DDEVAL
     C                   EVAL      WKESEQ = DDESEQ
     C                   EVAL      WKCUST = DDCUST
      *
     C                   MOVE      *BLANKS       NwMaPyScnFmt
      *
     C                   EVAL      DDLNRF = WKLNRF
     C                   EVAL      DDVALD = WKVALD
     C                   EVAL      DDSEQN = WKSEQN
     C                   EVAL      DDFRTN = WKFRTN
     C                   EVAL      DDACTN = WKACTN
     C                   EVAL      DDEVAL = WKEVAL
     C                   EVAL      DDESEQ = WKESEQ
 
     C                   IF        DDACTN = 'I'
     C                   EVAL      DDCUST = WKCUST
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      RTVMAPY
     C                   Endif
      *
      ***  Check if Screen redisplayed after Amendment of Settlement Details
      *
     C                   If        Warning_2VL = 'Y'
     C                   MOVE      'N'           Warning_2VL       1            Settlement
      *
      ***  Read in subfile next record
      *
     C                   eval      @SCRN = 'C'
     C                   eval      Widx = 0
      *
     C                   GOTO      EVAL@B
     C                   Endif
      *
      ***  Check if must be redisplayed
      *
     C**********         if        IDX = 0                                                   BUG4351
     C**********                   AND WReDisplay = *BLANK                                   BUG4351
 
     C**********         Z-ADD     1             WiX                                         BUG4351
 
     C**********         DOW       WiX <= WIDx AND WReDisplay = *BLANK                       BUG4351
 
     C**********         IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)                         BUG4351
     C                   EVAL      WReDisplay = 'Y'
     C**********         ELSE                                                                BUG4351
     C**********         EVAL      WiX = WiX + 1                                             BUG4351
     C**********         ENDIF                                                               BUG4351
 
     C**********         ENDDO                                                               BUG4351
      *
     C                   IF        WRedisplay =  'Y'
     C                   EXSR      PUTD@M
     C                   GOTO      EVAL@B
     C                   Else                                                   Clean Error
     C                   EXSR      SRResetErr
     C                   ENDIF
     C**********         Endif                                                  Idx          BUG4351
      *
      ***  If 1 of the key fields is not OK
      ***  ==> Re-Output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C     DDVALDOK      OREQ      'N'
     C     DDSEQNOK      OREQ      'N'
     C     DDEVALOK      OREQ      'N'
     C     DDESEQOK      OREQ      'N'
     C                   Eval      @EIN67 = 'N'                                 Reset Cust. OK
     C                   GOTO      EVAL@B
     C                   END
      *
      ***  Set field and function key status on details screen
      ***  (according to action code)
      *
     C                   EXSR      SFKS@M
      *
      ***  If key details has been changed, Refresh Amendable Details to blanks
      *
     C     DDACTN        IFNE      @PACTN
     C     DDLNRF        ORNE      @PLNRF
     C     DDVALD        ORNE      @PVALD
     C     DDSEQN        ORNE      @PSEQN
     C     DDEVAL        ORNE      @PEVAL
     C     DDESEQ        ORNE      @PESEQ
     C     DDACTN        IFEQ      'I'
     C                   Eval      @EIN67 = 'N'                                 Reset Cust. OK
     C                   Endif
      *
     C                   EXSR      PUTD@M
     C                   MOVE      *BLANKS       @PEVAL                         to redisplay
     C                   MOVE      *BLANKS       @PESEQ                         to redisplay
     C                   Endif
      *
      *----------------------------------------------------------------
      ***  If delete
      *
     C     DDACTN        IFEQ      'R'
      *
      ***  Update Manual Repayment input in File Format
      *
     C                   MOVEL     CrMaPyFilFmt  NwMaPyFilFmt
      *
      ***  If CF10 taken, go onto updates
      *
     C     @INKJ         IFEQ      *ON
     C                   eval      NewSettlDS = OldSettlDS                      Settlement Instruct
     C                   MOVEL     'U'           @SCRN                          Updtae
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
     C                   Endif
      *
     C                   if        @EKYFD = 'Y'
     C                   MOVE      'N'           @EKYFD                         Key entered OK
     C                   eval      @scrn = 'M'                                  Redisplay same
     C                   Endif
     C                   GOTO      EVAL@B                                       Redisplay
     C                   END
      *----------------------------------------------------------------
      *
      ***  If enquire
      *
     C     DDACTN        IFEQ      'E'
      *
      ***  Update Manual Repayment input in File Format
      *
     C                   MOVEL     CrMaPyFilFmt  NwMaPyFilFmt
      *
      ***  If F14 taken, continue to settlements screen
      ***  If browse outstanding, read next browse subfile record
      *
     C     @INKN         IFEQ      *ON
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ENDIF
     C                   ENDIF
      *
     C                   if        @EKYFD = 'Y'
     C                   MOVE      'N'           @EKYFD                         Key entered OK
     C                   eval      @scrn = 'M'                                  Redisplay same
     C                   goto      EVAL@B
     C                   else
     C                   GOTO      EVAL@M
     C                   Endif
     C                   ENDIF
      *----------------------------------------------------------------
      *
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
      *
      ***  Update Manual Repayment input in File Format
      *
     C                   MOVEL     CrMaPyFilFmt  NwMaPyFilFmt
      *
     C     @EINKQ        IFEQ      'Y'                                          F16 needed
      *
     C     @INKQ         IFEQ      *ON                                          F16 taken
     C                   MOVEL     'S'           @SCRN                             Update
     C                   Else
     C                   MOVE      'M'           @SCRN                          Redisplay
     C                   Endif
      *
     C                   ELSE                                                   F16 not needed
      *
      ***  Continue to settlements screen
      *
     C     @EKYFD        IFEQ      'N'
     C                   MOVEL     'S'           @SCRN
     C                   Else
     C                   MOVE      'M'           @SCRN
     C                   Endif
     C                   Endif
     C                   MOVE      'N'           @EKYFD
      *
     C                   GOTO      EVAL@B
      *
     C                   Endif
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ***  Update Manual Repayment input in File Format
      *
     C                   MOVEL     CrMaPyFilFmt  NwMaPyFilFmt
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      ***  and clear Manual Repayment in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
      *
     C                   MOVE      *ALL'Y'       ErrorMaPy
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C     DDACTN        IFEQ      'A'                                          Amend No change
      *
      ***  As Protected, no chnage but use by CTL and RPR
      *
     C                   CALLB     'LEMAPYAMD'
      *
      ***  Inputs
      *
     C                   PARM      *BLANK        RetCodeOut                     Return Code
     C                   PARM                    NwMaPyScnFmt                   New MR in Screen fmt
     C                   PARM                    CrMaPyScnFmt                   Cur MR in Screen fmt
      *
      ***  Outputs
      *
     C                   PARM                    ErrorMaPy                      OK FLags
     C                   PARM                    FldNameArr                     Error Fields Array
     C                   PARM                    MsgIdArr                             Msg Ids
     C                   PARM                    MsgDtaArr                            Msg Data
     C                   PARM                    Idx                                  Idx
      *
     C                   PARM      'Y'           @@RSTE            1            Reset Fld in error
      *
     C                   Endif
 
     C     DDACTN        IFEQ      'I'
      *
      ***  Validate Manual Repayment input details
      *
     C                   CALLB     'LEMAPYVAL'
      *
      ***  Inputs
      *
     C                   PARM                    RespMode                       Response mode
     C                   PARM                    NwMaPyScnFmt                   Nw MR in Screen Fmt
     C                   PARM                    PDLoAmFilFmt                   Past Due/Repay. Sche
     C                   PARM                    WrkLnDetails                   Loan Details
     C                   PARM                    WrkReactFacil                  Reactivated facility
     C                   PARM                    WrkOutPrinc                    Outstanding Princ.
     C                   PARM                    WrkRemainInt                   Loan Remaining int.
     C                   PARM                    WPTYP72                        Expected on type 72
     C                   PARM                    CLE005                         Feature
     C                   PARM                    CLE007                         Feature
     C                   PARM                    ExtData                        Addt Data
      *
      ***  Outputs
      *
     C                   PARM                    ErrorMaPy                      OK flags
     C                   PARM                    FldNameArr                     Error Fields Array
     C                   PARM                    MsgIdArr                             Msg Ids
     C                   PARM                    MsgDtaArr                            Msg Data
     C                   PARM                    Idx                                  Index
     C                   PARM                    WFldNamArr                     Warning Flds Array
     C                   PARM                    WMsgIdArr                              Msg Ids
     C                   PARM                    WMsgDtaArr                             Msg Data
     C                   PARM                    WIdx                                   Index
     C                   PARM                    NwMaPyFilFmt                   Nw MR in File Fmt
      *
      ***  Check if Customer is OK, For Display
      *
     C                   Eval      @EIN67 = DDCUSTOK
     C                   Endif
      *
     C                   MOVE      'N'           @EKYFD                         Key entered OK
      *
      ***  Update Manual Repayment Input in file format
      *
     C                   MOVEL     NwMaPyFilFmt  CrMaPyFilFmt
      *
     C                   END
      *
      ***  Check that input is possible, if not Redisplay
      *
     C                   if        DDACTN = 'I' and @EDTFD = 'N' and @EIN67='Y'
     C                   eval      @EDTFD = 'Y'                                 Redisplay
     C                   goto      EVAL@B
     C                   Endif
      *
     C     EVAL@M        TAG
      *
      ***  If errors returned
      *
     C     Idx           IFNE      0
     C     WIdx          ORNE      0
     C     WREDISPLAY    ANDEQ     *BLANKS
     C                   GOTO      EVAL@B
     C                   END
      *
      ***  if Key fields with new value
      ***  ==> Reopen the main screen, else
      ***  ==> settlement Screen
      *
     C     DDACTN        IFEQ      @PACTN
     C     DDLNRF        ANDEQ     @PLNRF
     C     DDVALD        ANDEQ     @PVALD
     C     DDSEQN        ANDEQ     @PSEQN
     C     DDEVAL        ANDEQ     @PEVAL
     C     DDESEQ        ANDEQ     @PESEQ
     C     DDACTN        IFNE      'E'                                          Except 'E'nquire
     C     DDACTN        ANDNE     'R'                                          Except 'R'everse
     C     DDACTN        ANDNE     'X'                                          Except Authorize 'X'
     C                   MOVEL     'S'           @SCRN
     C                   MOVE      'Y'           WrkDftSettl       1            def Settl instr. 'I'
     C                   Else
      *
      ***  Clear screen when key fields haven't been changed
      *
     C                   if        @RDNB <> 'Y'
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
     C                   eval      @EIN67 = 'N'
     C                   Endif
     C                   Endif
     C                   ENDIF
      *
      *----------------------------------------------------------------
     C     EVAL@B        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@S  - Additional validation                                *
      *****************************************************************
     C     VAL@S         BEGSR
      *
     C     DDACTN        IFNE      'X'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'R'
     C                   CALLB     'LEMAPY2VL'
     C                   PARM                    RespMode                       Response mode (1A),
     C                   PARM                    NwMaPyFilFmt                   Valid Manual Repayme
     C                   PARM                    ##PAYF                         Payment instructions
     C                   PARM                    ##RECF                         Receive instructions
     C                   PARM                    WTYPE                          Settl Methode
     C                   PARM                    PassDtaDS
     C                   PARM                    ErrorMaPy                      Field OK flags
      *
      ***  Warning fields/message IDs/message data (arrays)
     C                   PARM      *BLANKS       WFldNamArr
     C                   PARM      *BLANKS       WMsgIdArr
     C                   PARM      *BLANKS       WMsgDtaArr
      ***  Array index
     C                   PARM      0             WIdx
     C                   Endif
      *
     C     WIdx          IFNE      *ZERO
     C                   MOVEL     'M'           @SCRN
     C                   MOVE      'Y'           Warning_2VL                    Settlement
     C                   ELSE
     C                   EXSR      EXIT@S
     C                   ENDIF
      *
      *----------------------------------------------------------------
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - Roll backwards & forwards through Manual Repayment
      *         file
      *****************************************************************
     C     ROLL          BEGSR
      *
      ***  Read next or previous record on Manual Repayment file
      ***  according to command key taken (F7 or F8)
      *
     C     @INKG         IFEQ      *ON
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'LEMAPYRED'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
     C                   PARM                    DDACTN                         Action code
     C                   PARM                    DDLNRF                         Loan number pointer
     C                   PARM                    DDVALD                         Value date pointer
     C                   PARM                    DDSEQN                         Sequence no. pointer
     C                   PARM                    DDFRTN           20            Front Office ID
     C                   PARM                    @RDFWD            1            Read forwards
     C                   PARM                    @RDBCK            1            Read backwards
      *
      ***  Output parameters
      *
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM      *BLANK        @ERRMS            7            Error message
     C                   PARM      *BLANK        @ERRDTA                                      CLE148
     C                   PARM      *BLANK        @LNRED            6            Loan number read
     C                   PARM      *BLANK        @VDRED            6            Value date read
     C                   PARM      *BLANK        @SQRED            3            Sequence no. read
     C                   PARM      *BLANK        @FTRED           20            Front Office ID READ
      *
      ***  If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EROLL
     C                   ELSE
 
      *
      ***  Save pointers clear last screen fields then set pointers
      ***  again.
      *
     C                   EVAL      WKLNRF = DDLNRF
     C                   EVAL      WKVALD = DDVALD
     C                   EVAL      WKSEQN = DDSEQN
     C                   EVAL      WKFRTN = DDFRTN
     C                   EVAL      WKACTN = DDACTN
      *
     C                   MOVE      *BLANKS       NwMaPyScnFmt
      *
     C                   EVAL      DDLNRF = WKLNRF
     C                   EVAL      DDVALD = WKVALD
     C                   EVAL      DDSEQN = WKSEQN
     C                   EVAL      DDFRTN = WKFRTN
     C                   EVAL      DDACTN = WKACTN
      *
      ***  Default action code to enquiry if not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'R'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'E'           DDACTN
     C                   ENDIF
     C                   END
      *
      ***  If Manual Repayment Read
      *
     C     @LNRED        IFNE      *BLANKS
     C     @VDRED        ANDNE     *BLANKS
     C     @SQRED        ANDNE     *BLANKS
      *
      ***  Retrieve Manual Repayment details
      *
     C                   MOVEL     @LNRED        DDLNRF
     C                   MOVEL     @VDRED        DDVALD
     C                   MOVEL     @SQRED        DDSEQN
     C                   MOVEL     *BLANKS       DDCUST                         new customer
     C                   MOVEL     *BLANKS       DDEVAL                         Expected Val. date
     C                   MOVEL     *BLANKS       DDESEQ                         Expected Seq.
      *
     C                   EXSR      RTVMAPY
      *
      ***  If error message returned from rtv
      *
     C                   IF        Idx <> 0
     C                   GOTO      EROLL
     C                   ENDIF
      *
      ***  Set field and function key status on main details screen
      ***  (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      ***  Put the Manual Repayment on the details screen
      *
     C                   EXSR      PUTD@M
      *
      ***  Go to details screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   MOVEL     'Y'           WrkDftSettl
     C                   END
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - Build browse subfile                                 *
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      *
      ***  Do not do if F12 has been pressed - build from 1st rec.
      ***  or F5.
      ***  or F15.                                                                            ING121
      *
     C     @INKL         IFNE      '1'
     C     @INKE         ANDNE     '1'
     C     @INKP         ANDNE     '1'
     C                   MOVEL     DDACTN        @PACTN
     C                   MOVEL     DDLNRF        @PLNRF
     C                   MOVEL     DDVALD        @PVALD
     C                   MOVEL     DDSEQN        @PSEQN
     C                   ELSE
     C                   EVAL      @PACTN = *BLANK
     C                   EVAL      @PLNRF = *BLANK
     C                   EVAL      @PVALD = *BLANK
     C                   EVAL      @PSEQN = *BLANK
     C                   ENDIF
      *
      ***  Reset read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ***  Build browse subfile
      *
     C                   CALLB     'LEMAPYBRW'
      *
      ***  Input parameters
      *
     C                   PARM      *BLANK        RetCodeOut                     Return code
     C                   PARM                    @PACTN            1            Action code
     C                   PARM                    @PLNRF            6            Loan number
     C                   PARM                    @PVALD            6            Value date
     C                   PARM                    @PSEQN            3            Sequence no.
     C                   PARM      'Y'           @BDSFL            1            Build subfile
     C                   PARM      *BLANK        @RDSFL            1            Read subfile record
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Output parameters
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM      *BLANK        @ERRMS            7            Error message
     C                   PARM      *BLANK        @ERRDTA                                      CLE148
     C                   PARM      *BLANK        @OPSEL            1            Option selected
     C                   PARM      *BLANKS       @LNSEL            6            Loan number selected
     C                   PARM      *BLANKS       @VDSEL            6            Value date selected
     C                   PARM      *BLANKS       @SQSEL            3            Sequence no. selecte
     C                   PARM      *OFF          @INKC             1            Command keys
     C                   PARM      *OFF          @INKE             1
     C                   PARM      *OFF          @INKI             1
     C                   PARM      *OFF          @INKL             1
     C                   PARM                    CLE005                         Feature CLE005
      *
      ** Reset all error fields
     C                   EXSR      SRResetErr
      *
      ***  If F3 taken in browse, end program
      *
     C     @INKC         IFEQ      *ON
     C                   EXSR      ENDP
     C                   GOTO      EBLDBR
     C                   END
      *
      ***  If F5 taken in browse, rebuild sfl
      *
     C     @INKE         IFEQ      *ON
     C                   EVAL      @PACTN = *BLANKS
     C                   EVAL      @PLNRF = *BLANKS
     C                   EVAL      @PVALD = *BLANKS
     C                   EVAL      @PSEQN = *BLANKS
     C                   GOTO      EBLDBR
     C                   END
      *
      * If F12 taken in browse, return to key screen
     C                   IF        @INKL = '1'
     C                   EVAL      @RDSFL = ' '
     C                   EVAL      @BDSFL = ' '
     C                   EVAL      @EKYFD = 'Y'
     C                   EVAL      @EDTFD = 'N'
     C                   EVAL      @SCRN = 'M'
     C                   CLEAR                   NwMaPyScnFmt
     C                   GOTO      EBLDBR
     C                   ENDIF
 
      * If Insert (F9) selected from browse, go to key screen
     C                   IF        @OPSEL = 'I'
      *
      ** Enable F12 on key screen
     C                   EVAL      @SCRN = 'M'
     C                   CLEAR                   NwMaPyScnFmt
     C                   EVAL      DDACTN = 'I'
     C                   EVAL      @EKYFD = 'Y'
     C                   EVAL      @EINKN = 'N'
     C                   GOTO      EBLDBR
     C                   ENDIF
      *
      ***  If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLDBR
     C                   END
      *
      ***  If F12 not taken in browse
      ***  Read next browse subfile record
      *
     C     @INKL         IFNE      *ON
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   Else
      *
      ***  Redisplay first screen
      *
     C                   eval      @SCRN = 'M'
     C                   MOVE      *BLANKS       NwMapyScnfmt
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
     C                   eval      @EIN67 = 'N'
     C                   END
      *
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - Read next browse subfile record                      *
      *****************************************************************
     C     RDNBRW        BEGSR
      *
     C                   MOVEL     DDACTN        @PACTN
     C                   MOVEL     DDLNRF        @PLNRF
     C                   MOVEL     DDVALD        @PVALD
     C                   MOVEL     DDSEQN        @PSEQN
     C                   MOVEL     DDEVAL        @PEVAL
     C                   MOVEL     DDESEQ        @PESEQ
      *
      ***  Read next subfile record
      *
     C                   CALLB     'LEMAPYBRW'
      *
      ***  Input parameters
     C                   PARM      *BLANK        RetCodeOut                     Return code
     C                   PARM                    @PACTN            1            Action code
     C                   PARM                    @PLNRF            6            Loan number pointer
     C                   PARM                    @PVALD            6            Value date pointer
     C                   PARM                    @PSEQN            3            Sequence no. pointe
     C                   PARM      *BLANK        @BDSFL            1            Build subfile
     C                   PARM      'Y'           @RDSFL            1            Read subfile record
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Output parameters
      *
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM      *BLANK        @ERRMS            7            Error message
     C                   PARM      *BLANK        @ERRDTA                                      CLE148
     C                   PARM      *BLANK        @OPSEL            1            Option selected
     C                   PARM      *BLANK        @LNSEL            6            Loan number selected
     C                   PARM      *BLANKS       @VDSEL            6            Value date selected
     C                   PARM      *BLANKS       @SQSEL            3            Sequence no. selecte
     C                   PARM      *OFF          @INKC             1            Command keys
     C                   PARM      *OFF          @INKE             1
     C                   PARM      *OFF          @INKI             1
     C                   PARM      *OFF          @INKL             1
     C                   PARM                    CLE005                         Feature CLE005
      *
      *
      ***  If Manual Repayment read from subfile
      *
     C     @LNSEL        IFNE      *BLANKS
     C     @VDSEL        ANDNE     *BLANKS
     C     @SQSEL        ANDNE     *BLANKS
     C     @OPSEL        ANDNE     *BLANKS
      *
      ***  Retrieve Manual Repayment details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @LNSEL        DDLNRF
     C                   MOVEL     @VDSEL        DDVALD
     C                   MOVEL     @SQSEL        DDSEQN
     C                   MOVEL     *BLANKS       DDEVAL                         Avoid RTV Problem
     C                   MOVEL     *BLANKS       DDESEQ
     C                   EXSR      RTVMAPY
      *
      ***  Check if not error
      *
     C     DDACTNOK      IFNE      'Y'
     C     DDLNRFOK      ORNE      'Y'
     C     DDVALDOK      ORNE      'Y'
     C     DDSEQNOK      ORNE      'Y'
     C     DDEVALOK      ORNE      'Y'
     C     DDESEQOK      ORNE      'Y'
     C                   if        DDACTN <> 'X'
     C                   MOVEL     'E'           @OPSEL
     C                   MOVEL     'E'           DDACTN
     C                   Endif
     C                   ENDIF
      *
      ***  If error then return to sfl screen and put out message
      ***  donot go to detail.
      *
     C                   IF        Idx <> 0
     C                   EVAL      @SCRN = 'B'
     C                   EVAL      DDACTN = ' '
     C                   GOTO      EndRDNBRW
     C                   ENDIF
      *
      ***  Set field and function key status
      ***  (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      ***  Put the Manual Repayment on the details screen
      *
     C                   EXSR      PUTD@M
      *
      ***  Go to on details screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
      *
      ***  Else, reset read next browse subfile record
      *
     C
     C                   MOVEL     *BLANK        NwMaPyScnFmt                   Clear Screen
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
     C                   MOVEL     'N'           @EIN67
     C                   EXSR      BLDBRW                                       Rebuild subfile
     C                   END
      *
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *****************************************************************
     C     RTVMAPY       BEGSR
      *
      ***  Retrieve Manual Repayment
      *
     C                   Z-ADD     0             WrkCntrMR         1 0
      *
     C                   CALLB     'LEMAPYRTV'
      *
      ***  Inputs
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
     C                   PARM      'S'           @@RSMD            1            Response mode Sec
     C                   PARM                    DDACTN                         Action Code
     C                   PARM                    FOTRID           20            Front Office Id
     C                   PARM                    DDLNRF                         Midas Loan Ref
     C                   PARM                    DDVALD                         Midas Value Date
     C                   PARM                    DDSEQN                         Midas Sequ. no
     C                   PARM                    DDEVAL                         Midas Expected Date
     C                   PARM                    DDESEQ                         Midas Expected Seq
      *** Feature indicator
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005
     C                   PARM                    CLE007
     C                   PARM                    CLE009
     C                   PARM                    CLE014
      *
      ***  Outputs
      *
      ***  (Current) Manual Repayment in file format
     C                   PARM      *BLANKS       CrMaPyFilFmt
     C                   PARM      *BLANK        DDACTNOK                       OK Actn code
     C                   PARM      *BLANK        DDLNRFOK                       OK Loan ref
     C                   PARM      *BLANK        DDVALDOK                       OK Value Date
     C                   PARM      *BLANK        DDSEQNOK                       OK Sequence
     C                   PARM      *BLANK        DDEVALOK                       OK Expected Date
     C                   PARM      *BLANK        DDESEQOK                       OK Expected Sequence
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Indicators for display
     C                   PARM                    WWHoldTaxRat     11 7          W/hold Tax Rate
     C                   PARM      ' '           WExpectType       1            Expected LOAM type
     C                   PARM      ' '           WPTYP72           1            Expected on type 72
     C                   PARM      '  '          WrkExpAmdTp       2            PD/RE Amend Type
     C                   PARM      0             WrkRepayTp        1 0          Loan Repay. Type
     C                   PARM                    WrkReactFacil     1            React. Matured
     C                   PARM                    WrkCntrMR                      Counter MR (UPD)
     C                   PARM                    PDLoAmFilFmt                   Past Due/Repay. Sche
     C                   PARM                    WrkLnDetails                   Loan details
      ***  Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C                   PARM      *ZERO         WIdx
     C                   PARM                    PRcvParm                                     244636
      *
      ***  Save the settlement details for update (OLDSettlDS)
      *
     C                   MOVE      LSETP         OSETP
     C                   MOVEL     LOSAC         OOSAC
     C                   MOVEL     LTSEN         OTSEN
     C                   MOVEL     LFACO         OFACO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - Put a Manual Repayment on the details screen         *
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      ***  Call program to fill screen fields with data from LOAMSDK
      *
     C                   IF        DDACTN <> 'I'
     C                   CALLB     'LEMAPYCVT'
      *
      ***  Inputs
      *
     C                   PARM      *BLANKS       RetCodeOut                     Return Code
     C                   PARM                    CrMaPyFilFmt                   MR in File format
     C                   PARM                    PDLoAmFilFmt                   PD/RE in File format
     C                   PARM                    CLE005                         Feature
     C                   PARM                    CLE007                         Feature
     C                   PARM                    CLE023                         Feature
     C                   PARM                    WrkReactFacil                  Reactivated facility
      *
      ***  Outputs
      *
     C                   PARM                    NwMaPyScnFmt                   MR in screen format
     C                   PARM                    WrkProcTypLoan                 Loan Proc Type
     C                   PARM      0             WrkOutPrinc      13 0          Outstanding Princ.
     C                   PARM      0             WrkRemainInt     13 0          Loan Remaining int.
     C                   ELSE
 
      ** If action code is insert, set up relevant screen fields
     C                   EXSR      SetupIns
     C                   ENDIF
      *
      ***  Update 'Current' Manual Repayment with
      ***  Manual Repayment in screen format
      *
     C                   MOVEL     NwMaPyScnFmt  CrMaPyScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@M - Set field status on details screens                  *
      *****************************************************************
     C     SFDS@M        BEGSR
      *
      ***  Enable/disable key & detail fields on details screen
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD                          disable key
     C                   MOVEL     'N'           @EDTFD                          *IN70
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKS@M - Set function key status on details screen            *
      *****************************************************************
     C     SFKS@M        BEGSR
      *
      ***  Enable/disable function keys on details screen
      *
      ***  KG = Command key 07 = Previous
      *
     C     @SCRN         IFEQ      'M'
     C     DDACTN        IFNE      'I'
     C                   MOVEL     'Y'           @EINKG
      *
      ***  KH = Command key 08 = Next
      *
     C                   MOVEL     'Y'           @EINKH
     C                   ELSE
     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH
     C                   Endif
     C                   END
     C                   MOVEL     'N'           @EINKJ
      *
      ***  KQ = Command Key 16 = Authorized
      *
     C     DDACTN        IFEQ      'X'
      *
      ***  Required Authorisation
      *
     C     BPAURV        IFEQ      'Y'
     C                   MOVEL     'N'           @EINKQ
     C                   ELSE
     C                   MOVEL     'Y'           @EINKQ
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL     'N'           @EINKQ
     C                   ENDIF
      *
      ***  KN = Command key 14 = Settlement details
      ***  (Action code I display settlement details automatically)
      *
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'R'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'X'
     C                   MOVEL     'Y'           @EINKN
     C                   ELSE
     C                   MOVEL     'N'           @EINKN
     C                   END
      *
      ***  KP = Command key 15 = Browse
      *
     C                   if        DDACTN = 'I'
     C                   MOVE      'N'           @EINKP
     C                   ELSE
     C                   MOVEL     'Y'           @EINKP
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@M - Initialize field status on details screen            *
      *****************************************************************
     C     IFDS@M        BEGSR
      *
      ***  Enable key & details fields
      *
     C                   MOVEL     'Y'           @EKYFD
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'I'
     C     DDACTN        OREQ      *BLANKS
     C                   MOVEL     'N'           @EDTFD
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFKS@M - Initialize function key status on details screen     *
      *****************************************************************
     C     IFKS@M        BEGSR
      *
      ***  Enable/disable function keys on details screens
      *
      * KG = Command key 07 = Read previous
      * KH = Command key 08 = Read next
      * KJ = Command key 10 = Delete
      * KN = Command key 14 = Settlement details
      * KP = Command key 15 = Browse
      * KQ = Command key 16 = Authorise
      *
     C     @SCRN         IFEQ      'M'
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   END
      *
     C     DDACTN        IFNE      'E'
     C     DDACTN        ANDNE     'A'
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'N'           @EINKN
     C                   MOVEL     'Y'           @EINKP
     C                   MOVEL     'N'           @EINKQ
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IOTI@M - Initialize Other Indicator                           *
      *****************************************************************
     C     IOTI@M        BEGSR
      *
      ***  These will be Changed after RTV module or VAL Module (Insert)
      *
     C                   MOVEL     'N'           @EIN67
     C                   Z-ADD     0             WrkProcTypLoan
     C                   MOVEL     'Y'           WrkDftSettl
      *
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      * CANC@M - Cancel on details screen                             *
      *****************************************************************
     C     CANC@M        BEGSR
      *
      ***  Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     'N'           @EIN67
      *
      ***  If input fields are enabled
      ***  Blank the first details screen
      *
     C     @EKYFD        IFEQ      'Y'                                          key flds available
     C     @EDTFD        ANDEQ     'N'                                          but not details
     C     @SCRN         IFEQ      'M'
     C                   MOVEL     *BLANK        NwMaPyScnFmt
     C                   END
     C                   END
      *
      ***  Initialize field and function key status on details screen
      *
     C     @SCRN         IFEQ      'M'
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
     C                   END
      *
      ***  Update 'previous' Manual Repayment  input & screen control indicator
      *
      ***  If the detail screen was selected from the sfl then F12 was ndicator
      ***  pressed cancel other selections and rebuild sfl.
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EVAL      @SCRN = 'B'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - Send a message to details screen                     *
      *****************************************************************
     C     SNDM@M        BEGSR
      *
      * Check of key .....
      *
      ***  If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'LEL0602'
     C                   MOVE      'N'           DDACTNOK
     C                   END
      *
      ***  Loan number on screen must be blank or numeric for pointer
      *
     C*****@ERRMS        IFEQ      'LES0608'                                                  CLE148
     C**********         MOVE      'N'           DDLNRFOK                                     CLE148
     C**********         END                                                                  CLE148
     C     @ERRMS        IFEQ      '5045550'                                                  CLE148
     C     wLoanAlpha    ANDEQ     'N'                                                        CLE148
     C     @ERRMS        OREQ      '5045548'                                                  CLE148
     C     wLoanAlpha    ANDEQ     'Y'                                                        CLE148
     C                   MOVE      'N'           DDLNRFOK                                     CLE148
     C                   ENDIF                                                                CLE148
      *
      ***  Value date on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'LES0610'
     C                   MOVE      'N'           DDVALDOK
     C                   END
      *
      ***  Sequence number on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'LES0609'
     C                   MOVE      'N'           DDSEQNOK
     C                   END
      *
      ***  Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
     C                   MOVEL     @ERRDTA       MsgDtaArr(E)                                 CLE148
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - Process screen: Settlement details evoked for        *
      *          inserts, amends, enquiries & authorizations          *
      *****************************************************************
     C     SCRN@S        BEGSR
      ***  Determinate protect fields in settlement instructions
      *
     C                   MOVEL     'N'           ##PPAY
     C                   MOVEL     'N'           ##PREC
      *
      ***  Set up payment instructions from Repayment schedule
      ***  (on insertions, these fields will be zero/blank)
      *
     C**********         MOVEL     MR_PAY        ##PAYF                                       CGL029
     C                   MOVEL     MR_PAY        FLPAY                                        CGL029
     C                   MOVEL     MR_PAYEx      FLPONS                                       CGL029
     C                   MOVEL     MRPSTM        FLPSTM                                       CGL029
     C                   MOVEL     MRCVMR        FLCVMR
     C                   MOVEL     MRSCCY        FLPSCY
     C                   MOVEL     MRICCY        FLIC72
      *
      ***  Set up receive instructions from Repayment schedule
      ***  (on insertions, these fields will be zero/blank)
      *
     C**********         MOVEL     MR_REC        ##RECF                                       CGL029
     C                   MOVEL     MR_REC        FLREC                                        CGL029
     C                   MOVEL     MR_RECEx      FLRONS                                       CGL029
     C                   MOVEL     MRRSTM        FLRSTM                                       CGL029
     C                   MOVEL     MRSCCY        FLRSCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     MRREXR        FLREXR                                       CLE031
     C                   Z-ADD     MRPEXR        FLPEXR                                       CLE031
     C                   MOVE      MRREXI        FLREXI                                       CLE031
     C                   MOVE      MRPEXI        FLPEXI                                       CLE031
     C                   MOVE      MRSCCY        FLRSCY                                       CLE031
     C                   MOVE      MRPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ***  Determine parameters for settlement details input
      *
     C                   EXSR      DETP@S
      *
     C                   CALLB     'ZASETINCVT'
      *
      ***  Inputs                                                               File Fmt
      *
     C                   PARM                    ##PAYF                         File paym settl inst
     C                   PARM                    ##RECF                         File Recei Sett Inst
     C                   PARM      *BLANK        ##FRIF                         FRA/IRS Settl. Instr
      *
      ***  Outputs                                                              Screen Fmt
      *
     C                   PARM      *BLANK        ##PAYS                         Paym settl. inst Scr
     C                   PARM      *BLANK        ##RECS                         Recei settl inst Scr
     C                   PARM      *BLANK        ##FRIS                         FRA/IRS Sett inst
     C                   PARM      DDSCCY        #TRCCY                                      CSF011A
     C                   PARM      DDSCCY        #TPCCY                                      CSF011A
      *
      *
      ***  Settlement instructions input
      *
     C                   CALLB     'ZASETINSIN'
      *
      ***  Inputs
      *
     C                   PARM      *BLANK        ##RTCD           10            Return Code
     C                   PARM      DDACTN        ##ACTN            1            Action code
     C                   PARM      DDLNRF        ##LNRF            6            Loan number
     C                   PARM                    ##PPAY            1            Protect Payment
     C                   PARM                    ##PREC            1            Protect Receive
     C                   PARM      'LEND'        ##CALP            4            Calling program
     C                   PARM      DDSCCY        ##PCCY            3            Payment currency
     C                   PARM      DDSCCY        ##RCCY            3            Receive currency
     C                   PARM      DDCUST        ##CSNM           10            Customer Shortname
     C                   PARM                    ##TTYP            2            Transaction Type
     C                   PARM      *BLANK        ##FFND            1            Federal Funds Ind.
     C                   PARM                    ##BRCA            3            booking Branch
     C                   PARM      MRVDAT        ##DATR            5 0          Receipt Date
     C                   PARM      MRVDAT        ##DATP            5 0          Payment Date
      *
      ***  input Screen Fmt
      *
     C                   PARM                    ##PAYS                         Payment Instructions
     C**********         PARM                    ##RECS                        Receipt Instru 244636
     C                   PARM      PRcvParm      ##RECS                                       244636
     C                   PARM                    ##FRIS                         FRA/IRS Instructions
      *
      ***  Outputs - File Fmt
      *
     C                   PARM                    ##PAYF                         Payment Instructions
     C                   PARM                    ##RECF                         Receipt Instructions
     C                   PARM                    ##FRIF                         FRA/IRS Instructions
      *
      ***  Function keys
      *
     C                   PARM      *OFF          @INKC             1
      *
     C                   PARM      *OFF          @INKK             1                        MD036070
     C                   PARM      *OFF          @INKL             1
      *
      ***  Save the new settlement details for update
      *
     C     MRPTYP        IFEQ      66
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     72
     C                   MOVEL     FLPSTM        WSETP             2
     C**********         MOVEL     FLPONS        WOSAC            12                          CGL029
     C                   MOVEL     FLPONS        WOSAC                                        CGL029
     C                   MOVEL     FLPOBR        WOBBR             3
     C                   MOVEL     FLPOBR        WOSBR             3
     C                   MOVEL     FLPIBN        WTSEN            10
      *
     C                   ELSE
     C                   MOVEL     FLRSTM        WSETP             2
     C**********         MOVEL     FLRONS        WOSAC            12                          CGL029
     C                   MOVEL     FLRONS        WOSAC                                        CGL029
     C                   MOVEL     FLROBR        WOBBR             3
     C                   MOVEL     FLROBR        WOSBR             3
     C                   MOVEL     FLRIBN        WTSEN            10
      *
     C                   Endif
      *
      ***  Save old values for shadow posting
      *
     C                   MOVE      LSETP         WTYPE
     C                   MOVE      LOSAC         WOURS
     C                   MOVE      LTSEN         WTHRS
     C                   MOVE      LFACO         WFACO
     C                   MOVE      NewSettlDS    OldSettlDS
     C                   MOVE      *BLANKS       NewSettlDS
     C                   MOVE      WSETP         WTYPE
     C                   MOVEL     WOSAC         WOURS
     C                   MOVEL     WTSEN         WTHRS
     C                   MOVEL     FLBENN        WFACO
     C**********         MOVE      FLROBN        WNumOldROBN       6 0                        CSD027
     C**********         MOVE      FLROCN        WNumOldROCN       6 0                        CSD027
     C**********         MOVE      FLPOBN        WNumOldPOBN       6 0                        CSD027
     C**********         MOVE      FLPOCN        WNumOldPOBN       6 0                        CSD027
     C                   MOVE      FLROBN        WNumOldROBN       6                          CSD027
     C                   MOVE      FLROCN        WNumOldROCN       6                          CSD027
     C                   MOVE      FLPOBN        WNumOldPOBN       6                          CSD027
     C                   MOVE      FLPOCN        WNumOldPOCN       6                          CSD027
      *
      ***  Update Manual Repayment in file format
      *
     C     DDACTN        IFNE      'R'
     C     DDACTN        ANDNE     'E'
     C**********         MOVEL     ##PAYF        MR_PAY                                       CGL029
     C**********         MOVEL     ##RECF        MR_REC                                       CGL029
     C                   MOVEL     FLREC         MR_REC                                       CGL029
     C                   MOVEL     FLRONS        MR_RECEx                                     CGL029
     C                   MOVEL     FLRSTM        MRRSTM                                       CGL029
     C                   MOVEL     FLPAY         MR_PAY                                       CGL029
     C                   MOVEL     FLPONS        MR_PAYEx                                     CGL029
     C                   MOVEL     FLPSTM        MRPSTM                                       CGL029
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        MRREXR                                       CLE031
     C                   Z-ADD     FLPEXR        MRPEXR                                       CLE031
     C                   MOVE      FLREXI        MRREXI                                       CLE031
     C                   MOVE      FLPEXI        MRPEXI                                       CLE031
     C                   MOVE      FLRSCY        MRSCCY                                       CLE031
     C                   MOVE      FLPSCY        MRPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
     C                   MOVEL     NwMaPyFilFmt  CrMaPyFilFmt
      *
      ***  KJ = Command Key 10 = Delete
      *
     C     DDACTN        IFEQ      'R'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
     C     DDACTN        IFEQ      'E'
     C                   MOVEL     'N'           @EKYFD
     C                   ENDIF
      *
      ***  F3 - End program
      *
     C     @INKC         CASEQ     *ON           ENDP
      *
      ***  F12 - Cancel on settlement details
      *
     C     @INKK         CASEQ     *ON           CANC@S                                     MD036070
     C     @INKL         CASEQ     *ON           CANC@S
      *
      ***  Perform the additional validation
      *
     C                   CAS                     VAL@S
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - Determine parameters for settlement details screen   *
      *****************************************************************
     C     DETP@S        BEGSR
      *
     C                   MOVE      DDACTN        WWACTN            1
      *
      ***  Determine if pay & receive settlement screen will be protected
      *
     C     DDACTN        IFEQ      'R'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'Y'           ##PPAY
     C                   ELSE
     c     MRPTYP        Ifeq      66
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     72
     C                   MOVE      'Y'           ##PREC
     C                   MOVE      'N'           ##PPAY
     C                   Else
     C                   MOVE      'N'           ##PREC
     C                   MOVE      'Y'           ##PPAY
     C                   Endif
     C                   Endif
      *
      ***  If amend, enquire, authorize or reverse
      ***  move settlement file fields to screen fields
      ***  Else clear settlement screen fields
 
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'R'
     C     DDACTN        OREQ      'I'
     C     WrkDftSettl   ANDEQ     'N'
      *
      ***  SET UP PAYMENT INSTRUCTIONS FROM LOAN Amendments
      *** (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVE      MR_PAY        ##PAYF                                       CGL029
     C                   MOVE      MR_PAY        FLPAY                                        CGL029
     C                   MOVE      MR_PAYEx      FLPONS                                       CGL029
     C                   MOVE      MRPSTM        FLPSTM                                       CGL029
     C                   MOVE      MROSBR        FLPOBR
     C                   if        CEU004 = 'Y'
     C                   MOVEL     MRSCCY        FLPSCY
     C                   MOVEL     WrkLnICCy     FLIC72
     C                   Endif
      *
      *** SET UP RECEIVE INSTRUCTIONS FROM Loan Amendment
      *** (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     MR_REC        ##RECF                                       CGL029
     C                   MOVEL     MR_REC        FLREC                                        CGL029
     C                   MOVEL     MR_RECEx      FLRONS                                       CGL029
     C                   MOVEL     MRRSTM        FLRSTM                                       CGL029
     C                   MOVE      MROSBR        FLROBR
     C                   if        CEU004 = 'Y'
     C                   MOVEL     MRSCCY        FLRSCY
     C                   endif
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     MRREXR        FLREXR                                       CLE031
     C                   Z-ADD     MRPEXR        FLPEXR                                       CLE031
     C                   MOVE      MRREXI        FLREXI                                       CLE031
     C                   MOVE      MRPEXI        FLPEXI                                       CLE031
     C                   MOVE      MRSCCY        FLRSCY                                       CLE031
     C                   MOVE      MRPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   if        MRPTYP = 66 or MRPTYP = 69 and CLE005 = 'Y'
     C                             or MRPTYP = 72 and CLE005 = 'Y'
     C                   MOVE      *blanks       FLROBR
     C                   else
     C                   MOVE      *blanks       FLPOBR
     C                   endif
      *
     C                   Else                                                   when Insert
      *
      ***  Defaults settlement details
      *
     C                   IF        MRPTYP = 64 or MRPTYP = 65 or MRPTYP = 68
     C                             or MRPTYP = 71
     C                   MOVEL     WrkLnOLNO     ##CSNM
     C                   else
     C                   MOVEL     MRCNUM        ##CSNM
     C                   Endif
      *
     C                   CALLB     'ZASETINDFT'
      *
      ***  Inputs
      *
     C                   PARM      'LEND'        ##CALP            4            Calling program
     C                   PARM      DDSCCY        ##PCCY            3            Payment currency
     C                   PARM      DDSCCY        ##RCCY            3            Receive currency
     C                   PARM                    ##CSNM           10            Customer shortname
     C                   PARM      *BLANKS       ##TTYP            2            Loan Type
     C                   PARM      *BLANK        ##FFND            1            Federal Funds Ind.
     C                   PARM                    BQISDA            4            Version of ISDA Rule
     C                   PARM                    BQAGTY            6            Type of ISDA agreeme
     C                   PARM                    BQAGDT            6            Date of ISDA Agreeme
     C                   PARM                    BQAGVV            2            Version ISDA Agreeme
     C                   PARM                    Blank2            2            ISDA Agree. century
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ***  OUTPUTS
      *
     C                   PARM                    ##PAYF                         Payment instructions
     C                   PARM                    ##RECF                         Receive instructions
     C                   PARM                    ##FRIF                         FRA/IRS instructions
     C                   Endif
      *
      ***  Check details defaulted depending Proc.type
      *
     C                   if        MRPTYP = 66 or MRPTYP = 69 and CLE005 = 'Y'
     C                             or MRPTYP = 72 and CLE005 = 'Y'
      *
      ***  For Participation sold, Payment part
      *
     C     CLE031        IFNE      'Y'                                                        CLE031
     C                   if        CEU004 = 'Y'
     C                   move      *BLANKS       FLRSCY
     C                   if        DDSCCY = BKEURO
     C                   MOVE      *BLANKS       FLPSCY
     C                   MOVE      WrkLnICCY     FLIC72
     C                   Else
     C                   MOVE      *BLANKS       FLPSCY
     C                   Endif
     C                   Endif
     C                   ELSE                                                                 CLE031
     C                   MOVEL     *BLANKS       FLPSCY                                       CLE031
     C                   MOVEL     *BLANKS       FLRSCY                                       CLE031
     C                   MOVEL     *BLANKS       FLPEXI                                       CLE031
     C                   MOVEL     *BLANKS       FLREXI                                       CLE031
     C                   Z-ADD     *ZEROS        FLPEXR                                       CLE031
     C                   Z-ADD     *ZEROS        FLREXR                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   Reset                   ##RECF
     C                   Move      *BLANKS       FLROBR
      *
      *
      *** if no details, (check FLPSTM) setup with Loan details
      *
     C                   if        FLPSTM = 0  and DDACTN = 'I' and
     C                             WrkDftSettl <> 'N'
     C**********         Movel     LoanPayInst   ##PAYF                                       CGL029
     C                   Movel     LoanPayInst   FLPAY                                        CGL029
     C                   Movel     LoanPayInstEx FLPONS                                       CGL029
     C                   Movel     WrkLnPSTM     FLPSTM                                       CGL029
     C                   movel(p)  WrkLnOSDB     FLPOBR                         Our start Settl Brch
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVEL     WrkLnPSCY     FLPSCY                                       CLE031
     C                   Z-ADD     WrkLnPEXR     FLPEXR                                       CLE031
     C                   MOVEL     WrkLnPEXI     FLPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   endif
      *
     C                   else
      *
      ***  for loans other than Participation sold,  Receipt Part
      *
     C     CLE031        IFNE      'Y'                                                        CLE031
     C                   if        CEU004 = 'Y'
     C                   move      *BLANKS       FLPSCY
     C                   MOVE      *blanks       FLIC72
     C                   MOVE      *BLANKS       FLRSCY
     C                   Endif
     C                   ELSE                                                                 CLE031
     C                   MOVEL     *BLANKS       FLPSCY                                       CLE031
     C                   MOVEL     *BLANKS       FLRSCY                                       CLE031
     C                   MOVEL     *BLANKS       FLPEXI                                       CLE031
     C                   MOVEL     *BLANKS       FLREXI                                       CLE031
     C                   Z-ADD     *ZEROS        FLPEXR                                       CLE031
     C                   Z-ADD     *ZEROS        FLREXR                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   Reset                   ##PAYF
     C                   Move      *BLANKS       FLPOBR
      *
      *** if no details, (check FLRSTM) setup with Loan details
      *
     C                   if        FLRSTM = 0  and DDACTN = 'I' and
     C                             WrkDftSettl <> 'N'
     C**********         Movel     LoanRecInst   ##RECF                                       CGL029
     C                   Movel     LoanRecInst   FLREC                                        CGL029
     C                   Movel     LoanRecInstEx FLRONS                                       CGL029
     C                   Movel     WrkLnRSTM     FLRSTM                                       CGL029
     C                   movel(p)  WrkLnOMDB     FLROBR                         Our start Settl Brch
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVEL     WrkLnSCCY     FLRSCY                                       CLE031
     C                   Z-ADD     WrkLnREXR     FLREXR                                       CLE031
     C                   MOVEL     WrkLnREXI     FLREXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   endif
      *
     c                   MOVE      'N'           WrkDftSettl       1
     C                   ENDIF
      *
      *** pay/receive branch setup when multi-branching is on.
      *
     C                   if        DDACTN <> 'E'
     C                   If        BGMBIN = 'Y'
     C                   if        FLRSTM <> 05 and ##PREC = 'N'
     C                   move      *BLANKS       FLROBR
     C                   endif
      *
     C                   if        FLPSTM <> 05 and ##PPAY = 'N'
     C                   move      *BLANKS       FLPOBR
     C                   endif
      *
     C                   Endif
     C                   Endif
      *
      ***  now ready to convert Loan amendment or Default details
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - Cancel on settlement details screen                  *
      *****************************************************************
     C     CANC@S        BEGSR
      *
      ***  Return to the details screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - Exit from settlement details screen                  *
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      ***  If settlement details invalid
      *
     C     ##RTCD        IFEQ      '*ERRORS'
      *
      ***  Return to details screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
      *
      ***  Continue, confirm in insert and/Authorize 'X' when F16 is necessary.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'X'
     C     @EINKQ        ANDEQ     'N'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'C'           @SCRN
     C                   ELSE
     C                   MOVEL     'U'           @SCRN
     C                   Endif
      *
      ***  Update valid Manual Repayment: payment settlement instructions
      *
     C**********         MOVEL     ##PAYF        MR_PAY                                       CGL029
     C                   MOVEL     FLPAY         MR_PAY                                       CGL029
     C                   MOVEL     FLPONS        MR_PAYEx                                     CGL029
     C                   MOVEL     FLPSTM        MRPSTM                                       CGL029
     C                   if        MRPTYP = 66 or MRPTYP = 69 and CLE005 = 'Y'
     C                             or MRPTYP = 72 and CLE005 = 'Y'
     C                   MOVEL     FLPOBR        MROSBR
     C                   Else
     C                   MOVEL     FLROBR        MROSBR
     C                   Endif
      *
     C                   MOVEL     FLCVMR        MRCVMR
      *
      ***  Update valid Manual Repayment: receipt settlement instructions
      *
     C**********         MOVEL     ##RECF        MR_REC                                       CGL029
     C                   MOVEL     FLREC         MR_REC                                       CGL029
     C                   MOVEL     FLRONS        MR_RECEx                                     CGL029
     C                   MOVEL     FLRSTM        MRRSTM                                       CGL029
     C                   MOVEL     FLROBR        MRROBR
      *
      ***  Update valid Manual Repayment: settlement currency & 'IN' ccy in field 72
      *
     C                   MOVEL     FLPSCY        MRSCCY
     C                   MOVEL     FLIC72        MRICCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        MRREXR                                       CLE031
     C                   Z-ADD     FLPEXR        MRPEXR                                       CLE031
     C                   MOVE      FLREXI        MRREXI                                       CLE031
     C                   MOVE      FLPEXI        MRPEXI                                       CLE031
     C                   MOVE      FLRSCY        MRSCCY                                       CLE031
     C                   MOVE      FLPSCY        MRPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - Process screen: Confirmation of input                *
      *          evoked for inserts, amends & authorizations          *
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      ***  Output message 'Press enter to accept'
      *
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LEL0665'     MsgIdArr(1)
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LEMAPYDSP'
      *
      ***  Input parameters
      *
     C                   PARM      *BLANKS       RetCodeOut                      Ret code
     C                   PARM                    NwMaPyScnFmt                    Manual Repayment Sc
     C                   PARM                    ErrorMaPy                       Fields in error
      ***  Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Enabled key & detail fields
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      ***  Enabled function keys
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKN
     C                   PARM      'N'           @EINKP
     C                   PARM      'N'           @EINKQ
      ***  Activated Features
     C                   PARM                    @EIN67            1            Cust OK
     C                   PARM                    CLE005                         Feature
     C                   PARM      CLE003        @EIN88            1
     C                   PARM      CLE007        @EIN89            1
      ***  Details from RTV module
     C                   PARM                    WrkExpAmdTp       2            PD/RE Amend Type
     C                   PARM                    WrkRepayTp        1 0          Loan Repay. Type
     C                   PARM                    WrkProcTypLoan    2 0          Loan Proc. Type
      ***  Succesful insert
     C                   PARM                    @LSSQ
     C                   PARM                    @LNRF
     C                   PARM                    @VDAT
      ***  Add on Interest/Charge flag                                                       BUG3114
     C                   PARM                    @ADIF                                       BUG3114
     C                   PARM                    @ADCF                                       BUG3114
      *
      ***  Output parameters
      *
      ***  Function keys
     C                   PARM      *OFF          @INKC                          F3
     C                   PARM      *OFF          @INKG                          F12
     C                   PARM      *OFF          @INKH
     C                   PARM      *OFF          @INKJ
     C                   PARM      *OFF          @INKL
     C                   PARM      *OFF          @INKN
     C                   PARM      *OFF          @INKP
     C                   PARM      *OFF          @INKQ
     C                   PARM      'N'           WriteOnly
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       ErrorMaPy
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  F3 - End program
      *
     C     @INKC         CASEQ     *ON           ENDP
      *
      ***  F12 - Cancel on confirmation screen
      *
     C     @INKL         CASEQ     *ON           CANC@C
      *
      ***  Exit confirmation screen
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - Cancel on confirmation screen                        *
      *****************************************************************
     C     CANC@C        BEGSR
      *
      ***  Return to details screen
      *
     C                   MOVEL     'M'           @SCRN
      *
      ***  Initialize field status on details screen
      *
     C                   if        DDACTN = 'I'                                 Release amend Fields
     C                   Eval      @EDTFD = 'Y'
     C                   Endif
      *
      ***  Set function key status on details screen
      ***  (according to action code)
      *
     C                   EXSR      SFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - Exit from confirmation screen                        *
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      ***  If no errors in validation
      *
     C     Idx           IFEQ      *ZERO
     C     WIdx          ANDEQ     *ZERO
      *
      ***  Continue with updates
      *
     C                   MOVEL     'U'           @SCRN
      *
      ***  else, return to first details screen
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
      *
      ***  Initialize field status on details screen
      *
     C                   EXSR      IFDS@M
      *
      ***  Set function key status on details screen
      ***  (according to action code)
      *
     C                   EXSR      SFKS@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - Updates                                              *
      *****************************************************************
     C     UPDATS        BEGSR
      *
      ***  Update valid Manual Repayment: Last action code
      *
     C                   MOVEL     DDACTN        MRCHTP
     C                   MOVEL     DDESEQ        WrkDDESEQ
     C                   MOVEL     DDPASD        WrkDDPASD
      *
      ***  Manual Repayment updates
      *
     C                   CALLB     'LEMAPYUPD'
      *
     C                   PARM                    @RTCD                          Return Code
      ***  New Manual Repayment in file format
     C                   PARM                    NwMaPyFilFmt
      ***  Past Due/Repayment Scheduled in file format
     C                   PARM                    PDLoAmFilFmt
      ***  Loan in File Fmt
     C                   PARM                    WrkLnDetails
      ***  Old settlement details
     C                   PARM                    OldSettlDS
      ***  New settlement details
     C                   PARM                    NewSettlDS
      ***  Passed Data
     C                   PARM                    PassDtaDS
     C                   PARM                    ErrorMaPy                      Field OK flags (DS)
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Reservation ID                                                          CDE005
     C                   PARM      *BLANKS       ResrvId          10            CDE005
      *
      ***  If there were any errors in the update functions ROLLBACK any
      ***  updates and end this program. Otherwise, COMMIT the updates
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*RECUPD'
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
     C     MRCHTP        IFEQ      'I'
     C                   MOVEL     MRLASN        @LSSQ
     C                   MOVEL     MRLNRF        @LNRF
      *
     C                   MOVE      MRVDAT        ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
     C                   MOVE      ZDateFmt6     @VDAT
     C                   END
     C                   END
      *
      ***  If update not done due to record being updated by another
      ***  workstation send message to screen.
      *
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LEL0666'     MsgIdArr(1)
     C
     C                   END
     C
      *
      ***  Blank all detail screens
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     *BLANKS       NwMaPyScnFmt
     C                   MOVE      *ALL'Y'       ErrorMaPy
     C                   MOVE      'N'           @EIN67
     C                   ENDIF
      *
      ***  Initialize field and function key status on details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
      ***  If records are still to be read from the subfile, read them
      *
     C     @RDNB         IFEQ      'Y'
     C     @PACTN        ANDNE     'I'                                          Previous Update = I
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ***  Else, return to the details screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupIns - Set up relevant screen fields for insert mode      *
      *****************************************************************
     C     SetupIns      BEGSR
 
      **  Key to retrieve Facilty loan Details
     C     KEYLoanFac    KLIST
     C*****              KFLD                    K@CNUM            6 0                        CSD027
     C                   KFLD                    K@CNUM            6                          CSD027
     C                   KFLD                    K@FACT            3 0
     C                   KFLD                    K@FCNO            2 0
 
      **  Retrieve Facility details
     C                   EVAL      K@CNUM = WRKLNFCUS
     C                   EVAL      K@FACT = WRKLNFTYP
     C                   EVAL      K@FCNO = WRKLNFSEQ
 
     C     KEYLoanFac    CHAIN     FCLTY
      ** Date
     C                   MOVE      DDVALD        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        LVDAT
     C                   Z-ADD     ZDAYNO        WrkValDate        5 0
 
      ** Currency
     C                   EVAL      DDSCCY = WRKLNCCY
 
      ** Amount
     C                   MOVEL     DDSCCY        @CURR             3
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
 
     C                   MOVE      A6NBDP        CrNBDP            1 0          current Dec. places
 
     C                   Z-ADD     WRKLNCPAM     ZFLD15           15 0          Current Principal
     C                   Z-Add     CrNBDP        ZDECS             1 0
     C                   MOVE      'J'           ZECODE
 
     C                   EXSR      ZFRPED
      *
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDCURP
     C                   else
     C                   MOVE      Zout20        DDCURP
     C                   endif
      *
      ***  Calculate Outstanding Interest
      *
     C                   EXSR      OutstInt
      *
     C                   Z-ADD     WrkOutIntr    ZFLD15                         O/S interest
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED
 
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDINTD
     C                   else
     C                   MOVE      ZOUT20        DDINTD
     C                   endif
      *                                                                                      BUG3114
      ***  For flat rate personal loans, calculate interest refunded and                     BUG3114
      ***  charges refunded                                                                  BUG3114
      *                                                                                      BUG3114
     C                   If        CLE028 = 'Y' and WrkLnPTYP = 80                           BUG3114
     C                   EXSR      SRRFND                                                    BUG3114
      *                                                                                      BUG3114
      ***  Add charges and/or interest to the principal where these                          BUG3114
      ***  have been added on, but only if the loan hasn't started                           BUG3114
      *                                                                                      BUG3114
     C                   If        WrkLnORED = BJRDNB                                        BUG3114
     C                             or WrkLnORED < WrkLnVDAT                                  BUG3114
     C                   if        WrkLnADIF = 'Y'                                           BUG3114
     C                   ADD       WrkLnFLTI     WrkOutPrinc                                 BUG3114
     C                   ADD       WrkLnFLTI     WrkLnCPAM                                   BUG3114
     C                   endif                                                               BUG3114
     C                   if        WrkLnADCF = 'Y'                                           BUG3114
     C                   ADD       WrkLnCHGA     WrkOutPrinc                                 BUG3114
     C                   ADD       WrkLnCHGA     WrkLnCPAM                                   BUG3114
     C                   endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   Endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   Endif                                                               BUG3114
      *                                                                                      BUG3114
      ***  Calculate Expected Loan Details
      ***  Use details of DS PDLoAmFilFmt passed in PARM (Prefix PD_)
      *
     C                   Z-ADD     0             WrkExpPrin       13 0
     C                   if        PD_VDAT <> 0                                 Expected Details
      *
     C                   MOVE      PD_VDAT       ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum
     C                   PARM                    ZDateFmtInd
     C                   PARM                    ZDateFmt6
     C                   PARM                    ZDateFmt7
     C                   MOVE      ZDateFmt6     DDEVAL
      *
     C                   MOVE      PD_LASN       DDESEQ
      *
      ***  Use details of DS PDLoAmFilFmt passed in PARM (Prefix PD_)
      *
      ***  Expected Principal Amount
      *
     C                   if        DDESEQ = 'LN '
     C                   Z-ADD     WRKLNRAMT     WrkExpPrin                     Rebate Amount
     C                   Else
     C                   Z-ADD     PD_PRAM       WrkExpPrin                     PD/RE Princ. Amnt
     C                   Endif
     C                   Z-ADD     WrkExpPrin    ZFLD15                         Expected Princ.
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDEPRI
     C                   else
     C                   MOVE      ZOUT20        DDEPRI
     C                   endif
      *
      ***  Expected Interest/Withholding tax Amounts
      *
     C                   Z-ADD     PD_INTA       WrkExpInt        13 0
     C                   Z-ADD     PD_WTXA       WrkExpWtx        13 0
     C                   Z-ADD     WrkExpInt     ZFLD15                         Expected Interest
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDEINT
     C                   else
     C                   MOVE      ZOUT20        DDEINT
     C                   endif
     C                   Z-ADD     WrkExpWtx     ZFLD15                         Expected WTax .
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDWHTX
     C                   else
     C                   MOVE      ZOUT20        DDWHTX
     C                   endif
      *
      ***  Expected Total
      *
     C                   IF        DDESEQ = 'LN '
     C                   Z-ADD     WRKLNRAMT     WrkExpTot        13 0          Loan Rebate Amnt
     C                   Else
     C                   Z-add     PD_TAMT       WrkExpTot                      MR Total Amnt
     C                   endif
     C                   Z-ADD     WrkExpTot     ZFLD15                         Expected Total
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDETOT
     C                   else
     C                   MOVE      ZOUT20        DDETOT
     C                   endif
      *
      ***  Calculated Expected Penality
      *
     c                   Z-ADD     0             WrkExpPen        13 0
     C                   IF        LVDAT > PD_VDAT and PD_AMTP = 'PD'
     C                   EXSR      SRPNAM
      *
     C                   Z-ADD     WrkExpPen     ZFLD15                         Expected Penality
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZFRPED
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDEPEN
     C                   else
     C                   MOVE      ZOUT20        DDEPEN
     C                   endif
     C                   Endif
      *
     C                   Endif                                                  PD_VDAT <> 0
     C                   MOVE      WRKLNWTIN     DDWTTP
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * ZFRPED -                                                      *
      *****************************************************************
     C     ZFRPED        BEGSR
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE            1
     C                   PARM      *BLANKS       ZOUT22           22
     C                   PARM      *BLANKS       ZOUT25           25
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * OutstInt    - Calculate Outstanding Interest                  *
      *****************************************************************
     C     OutstInt      BEGSR
      *
      ***  Calculate Amounts to be displayed : Outstanding Interest
      ***  Calculate Evaluate Principal (WrkOutPrinc) and Evaluate Interest (WrkRemainInt)
      *
     C                   Z-ADD     WRKLNCPAM     WrkOutPrinc      13 0          O/s Principal
     C                   Z-ADD     0             WrkMRIntr        13 0          MR Interest
     C                   Z-ADD     0             WrkOutIntr       13 0          O/s Interest
      *
      ***  Read all live Loan Amendments to know Active Repayments
      *
     C**********         MOVE      DDLNRF        K@LNRF            6 0                        CLE148
     C                   MOVE      DDLNRF        K@LNRF            6                          CLE148
     C     k@LNRF        SetLL     LOAMRPY                                      RPY_RPY = 'D'
     C     k@LNRF        READE     LOAMRPY                                99    RPY_RPY = 'D'
     C                   DoW       *IN99= *OFF
      *
     C                   select
     C                   when      RPY_AMTP = 'MR'
      *
      ***  Manual Repayment
      *
     c                   Eval      WrkOutPrinc = WrkOutPrinc - RPY_PRAM
     c                   Eval      WrkMRIntr = WrkMRIntr + RPY_INTA
      *
     C                   when      RPY_AMTP = 'RE' and RPY_AUTO = 'Y'
      *
      ***  Repayment schedule
      ***  if Currency is not = To current Details, Convert
      *
     C                   if        RPY_CCY <> WRKLNCCY
     C                   MOVEL     RPY_CCY       @CURR             3
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
      *
     C                   Z-Add     0             WrkAmnt          19 3
     C                   Z-ADD     A6NBDP        WrNBDP            1 0
     C                   Eval(H)   WrkAmnt = (RPY_PRAM)
     C                                      * power((CrNBDP-WrNBDP)+4)
     C                   if        WRKLNFMDI = 'D'                              PRAM in Loan CCY
     C                   Eval(H)   RPY_PRAM = Wrkamnt*WRKLNFCXR
     C                   else
     C                   Eval(H)   RPY_PRAM = Wrkamnt/WRKLNFCXR
     C                   endif
     C                   Endif
      *
     c                   Eval      WrkOutPrinc = WrkOutPrinc - RPY_PRAM
     c                   Eval      WrkMRIntr = WrkMRIntr + RPY_INTA
      *
     C                   when      RPY_AMTP = 'PF'
      *
      ***  Principal F.....
      *
     c                   Eval      WrkOutPrinc = WrkOutPrinc - RPY_PRAM
     c                   Eval      WrkMRIntr = WrkMRIntr + RPY_INTA
      *
     C                   when      RPY_AMTP = 'PI' or RPY_AMTP = 'PT'
      *
      ***  Principal Increase or Principal T....
      *
     C                   if        RPY_VDAT < WrkValDate
     c                   Eval      WrkOutPrinc = WrkOutPrinc + RPY_PRAM
     C                   Endif
     C                   Endsl
      *
     C     k@LNRF        ReadE     LOAMRPY                                99    RPY_RPY = 'D'
      *
     C                   Enddo
      *
      ***  Recalculate Interest on period : Setup Fields for GLINTC
      *
     C                   if        WrkValDate > BJRDNB and CLE005 = 'Y'
     c                   Z-ADD     WrkValDate    ZIEND             5 0
     C                   else
     C                   Z-ADD     BJRDNB        ZIEND
     C                   endif
      *
     C                   if        WRKLNMDAT <> 0 and WRKLNMDAT < BJRDNB
     C                   Z-ADD     WRKLNMDAT     ZIEND
     C                   endif
      *
     C                   if        WrkReactFacil = 'Y' and CLE007 = 'Y'
     C                   Z-ADD     0             ZINTR
     c                   Else
      *
      *** Add 1 day to End Date depending on Loan Add Day indicator
      *
     c                   Z-ADD     WRKLNIACD     ZIBEG
     C**********         if        WRKLNADDI = 'B' and ZIBEG = WrkValDate                     245082
     C                   if        WrkLnADDI = 'B' and ZIEND = WrkLnMDAT                      245082
     C                             and WrkLnORED < WrkLnMDAT                                  245082
     C                   Eval      ZIEND = ZIEND + 1
     C                   Endif
      *
      ***  if Original entry Date is after Maturity Date
      *
     C                   if        WRKLNADDI = 'B' and WRKLNORED >= WRKLNMDAT
     C                   Eval      ZIEND = ZIEND + 1
     C                   Endif
      *
     C                   MOVE      WRKLNICBS     ZICALC
     C                   MOVE      WRKLNINTR     ZIRATE
     C                   Z-ADD     WRKLNCPAM     ZIAMT
      *
     C                   If        CLE028 = 'Y' and WrkLnPTYP = 80                           BUG3114
     C                   EXSR      SROSIN                                                    BUG3114
     C                   Z-ADD     ZINTR         WrkOutIntr                                  BUG3114
     C                   else                                                                BUG3114
     C                   EXSR      GLINTC
     C                   Endif                                                               BUG3114
      *
      ***  Round interest if defined so.
      *
     C**********         IF        WRKLNRDFC = 'Y'                                           BUG3114
     C                   IF        WRKLNRDFC = 'Y'                                           BUG3114
     C                             and WrkLnPTYP <> 80                                       BUG3114
     C                   Z-ADD     ZINTR         WrkIntRound      13 0
     C                   Z-ADD     WrkIntRound   ZINTR
     C                   Endif
      *
     C                   endif
      *
      ***  Compute interest paid
      *
     C                   Z-ADD     0             WrkPaidInt       13 0          Paid Interest
      *
     C                   if        WRKLNMDAT < WRKLNIACD and WRKLNMDAT <> 0
     C                             and WRKLNRECI = 'D'
     C                   Eval      WrkPaidInt=WRKLNAIAP+WRKLNAIMN+WRKLNPDIN
      *
     C                   Else
      *
      ***  Check if Stop Accrual is true
      *
     C                   TESTB     '3'           WRKLNLONI                99
     C                   If        *IN99 = *ON
     C                   Eval(h)   WrkPaidInt=WRKLNAITC+WRKLNAIAP+WRKLNAIMN
     C                   Else
     C                   if        CLE028 = 'N' or CLE028 = 'Y'                              BUG3114
     C                             and WrkLnPTYP <> 80                                       BUG3114
     C                   Eval(h)   WrkPaidInt=ZINTR+WRKLNAITC                                BUG3114
     C                   endif                                                               BUG3114
     C**********         Eval(h)   WrkPaidInt=ZINTR+WRKLNAITC+WRKLNAIAP                      BUG3114
     C**********                   +WRKLNAIMN                                                BUG3114
     C                   Eval(h)   WrkPaidInt=WRKLNAIAP+WRKLNAIMN                            BUG3114
     C                   Endif
     C                   endif
      *
      ***  Substract Interest already paid
      *
     C                   If        CLE028 = 'N' or (CLE028 = 'Y'                             BUG3114
     C                             and WrkLnPTYP <> 80) or (CLE028 = 'Y'                     BUG3114
     C                             and WrkLnPTYP = 80 and WrkLnADIF <> 'Y')                  BUG3114
     C                   Eval      WrkPaidInt=WrkPaidInt-WRKLNIPRD                           BUG3114
     C**********         Eval      WrkPaidInt=WrkPaidInt-WRKLNIPRD-WRKLNICTD                 BUG3114
     C**********                   -WRKLNIWOD                                                BUG3114
     C                   Endif                                                               BUG3114
     C                   Eval      WrkPaidInt=WrkPaidInt-WRKLNICTD                           BUG3114
     C                             -WRKLNIWOD                                                BUG3114
      *
     C                   if        ZIRATE = 0 and WrkPaidInt > 0
     C                             or ZIRATE <> 0 and WrkPaidInt < 0
     C                   Eval      WrkPaidInt = 0
     C                   Endif
      *
      ***  Outstanding = Interest - Paid Interest
      *
     C                   Eval      WrkOutIntr = WrkPaidInt
      *
      ***  Remaining interest = (Interest - Paid interest) - "MR" interest
      *
     C                   Z-ADD     0             WrkRemainInt     13 0
     C                   Eval      WrkRemainInt = WrkOutintr - WrkMRIntr
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPNAM - Calculate Expected penality                          *
      *****************************************************************
     C     SRPNAM        BEGSR
      *
      ***  Calcul are working with Facilty details
      *
      ***  If Late Payment type is 'A', expected penalty will be
      ***  equal to the late payment amount
      *
     C     FC_LPTP       IFEQ      'A'
     C     FC_FCCY       IFEQ      WRKLNCCY
     C                   Z-ADD     FC_LPAM       WrkExpPen
     C                   else
     C     WRKLNFMDI     Ifeq      'M'
     C                   Eval      WrkExpPen = FC_LPAM / WRKLNFCXR
     C                   Else
     C                   Eval      WrkExpPen = FC_LPAM * WRKLNFCXR
     C                   Endif                                                  FMDI = 'M'
     C                   Endif                                                  FCCY <> CCY
     C                   Endif                                                  LPTP = 'A'
      *
      ***  If Late Payment Type is 'P' , use base rate
      *
     C     FC_LPTP       IFEQ      'P'
     C                   MOVEL     FC_LPBR       TmpLPBR           2
     C                   Z-ADD     FC_LPAM       TmpLPAM                        ==> TmpRATE1 (13,7)
      *
      ***  Determine rate
      *
     C                   if        FC_LPBR <> 0                                 Late Penality B Rate
      *
      ***  Read Base rate details
      *
     C                   CallB     'AOBSRTR0'
     C                   parm      *BLANKS       @RTCD
     C                   parm      '*KEY   '     @OPTN
     C                   parm      FC_FCCY       PCCY              3
     C                   parm      TmpLPBR       PBSRT             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C     FC_LPPS       IFEQ      '+'
     C     BACBSR        Add       TmpRATE1      WrkRATE          11 7
     C                   else
     C     BACBSR        Sub       TmpRATE1      WrkRATE
     C                   Endif
     C                   Endif
      *
     C                   Else
      *
      ***  if Late Penality Base rate is not 'P',
      *
     C                   Z-ADD     TmpRATE1      WrkRate
     C                   Endif
      *
      ***  Compute penality
      *
     C                   Z-ADD     PD_VDAT       ZIBEG                          Expect date
     C                   Z-ADD     LVDAT         ZIEND                          Value date
     C                   Z-ADD     WRKLNICBS     ZICALC                         Int. Calc Basis
     C                   Z-ADD     WrkExpTot     ZIAMT                          Exp. Tot
     C                   Z-ADD     WrkRATE       ZIRATE                         Calc. Rate
     C                   EXSR      GLINTC
     C                   Z-ADD     ZINTR         WrkExpPen                      Exp. Penality
     C                   Endif
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * GLINTC - Calculate Interest on period                         *
      *****************************************************************
     C     GLINTC        BEGSR
      *
     C                   CALLB     'GLINTC'
     C                   PARM                    ZIBEG             5 0       STARTING DATE
     C                   PARM                    ZIEND             5 0       FINISHING DATE
     C                   PARM                    ZICALC            1 0       CALC. BASIS
     C                   PARM                    ZIAMT            15 0       PRINCIPAL
     C                   PARM                    ZIRATE           11 7       RATE OF INTRST
     C                   PARM                    ZINTR            30 9       INTEREST
      *
     C                   ENDSR
      *****************************************************************                      BUG3114
      /EJECT                                                                                 BUG3114
      *****************************************************************                      BUG3114
      * SRRFND - Calculate Interest Refunded and Charges Refunded     *                      BUG3114
      *****************************************************************                      BUG3114
     C     SRRFND        BEGSR                                                               BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     WrkLnVDAT     W78VDT            5 0                       BUG3114
     C                   Z-ADD     WrkLnMDAT     W78MDT            5 0                       BUG3114
     C                   Z-ADD     WrkLnFLTI     W78FLT           15 0                       BUG3114
     C                   MOVE      WrkLnRFRQ     W78RPF            1                         BUG3114
     C                   Z-ADD     WrkLnFRPD     W78FRD            5 0                       BUG3114
     C                   Z-ADD     WrkLnRDYN     W78RPM            2 0                       BUG3114
     C                   MOVE      WrkLnCCY      W78CCY            3                         BUG3114
     C                   MOVE      *BLANKS       W78LCN            3                         BUG3114
     C                   If        ZDAYNO = WrkLnMDAT                                        BUG3114
     C                   Z-ADD     WrkLnMDAT     W78BEG            5 0                       BUG3114
     C                   ELSE                                                                BUG3114
     C                   eval      W78BEG = ZDAYNO + 1                                       BUG3114
     C                   EndIf                                                               BUG3114
     C                   Z-ADD     WrkLnMDAT     W78END            5 0                       BUG3114
     C                   MOVE      'A'           W78ROA            1                         BUG3114
     C                   EXSR      RULE78                                                    BUG3114
      *                                                                                      BUG3114
      ** Compute for interest refunded if manual payment is for early                        BUG3114
      ** pay-offs and Add on interest is 'Y'                                                 BUG3114
      *                                                                                      BUG3114
     C                   if        DDESEQ = ' ' and WrkLnADIF = 'Y'                          BUG3114
     C                   Z-SUB(H)  W78INT        WINRF            13 0                       BUG3114
     C                   MOVE      *BLANKS       ZFLD15                                      BUG3114
     C                   MOVE      WINRF         ZFLD15                                      BUG3114
     C                   Z-Add     CrNBDP        ZDECS             1 0                       BUG3114
     C                   MOVE      'J'           ZECODE                                      BUG3114
     C                   CALLb     'ZFRPED'                                                  BUG3114
     C                   PARM                    ZFLD15                                      BUG3114
     C                   PARM                    ZDECS                                       BUG3114
     C                   PARM                    ZECODE                                      BUG3114
     C                   PARM      *BLANKS       ZOUT22           22                         BUG3114
     C                   PARM      *BLANKS       ZOUT25           25                         BUG3114
      *                                                                                      BUG3114
     C                   if        ZNEG = '-'                                                BUG3114
     C                   MOVE      ZOUT21        DDINRF                                      BUG3114
     C                   else                                                                BUG3114
     C                   MOVE      ZOUT20        DDINRF                                      BUG3114
     C                   endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
      ** Compute for charges refunded if manual payment is for early                         BUG3114
      ** pay-offs and Add on charges is 'Y'                                                  BUG3114
      *                                                                                      BUG3114
     C                   if        DDESEQ = ' ' and WrkLnADCF = 'Y'                          BUG3114
      *                                                                                      BUG3114
      ** Compute for charge amount per payment                                               BUG3114
      *                                                                                      BUG3114
     C                   if        W78NPY <> 0                                               BUG3114
     C     WrkLnCHGA     DIV       W78NPY        WCHGPY           30 9                       BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
      ** Compute for number of months for charges to be refunded                             BUG3114
      ** if value date is not equal to rundate.                                              BUG3114
      *                                                                                      BUG3114
     C     ZDAYNO        IFLT      WrkLnMDAT                                                 BUG3114
     C     W78NPY        SUB       W78NTH        WMOSRF            5 0                       BUG3114
     C                   ADD       2             WMOSRF                                      BUG3114
     C     WCHGPY        MULT      WMOSRF        WCHGRF           30 9                       BUG3114
     C                   Z-SUB(H)  WCHGRF        WCGRF            13 0                       BUG3114
     C                   ELSE                                                                BUG3114
     C                   Z-ADD     *ZERO         WCGRF                                       BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   MOVE      *BLANKS       ZFLD15                                      BUG3114
     C                   MOVE      WCGRF         ZFLD15                                      BUG3114
     C                   Z-Add     CrNBDP        ZDECS             1 0                       BUG3114
     C                   MOVE      'J'           ZECODE                                      BUG3114
     C                   CALLb     'ZFRPED'                                                  BUG3114
     C                   PARM                    ZFLD15                                      BUG3114
     C                   PARM                    ZDECS                                       BUG3114
     C                   PARM                    ZECODE                                      BUG3114
     C                   PARM      *BLANKS       ZOUT22           22                         BUG3114
     C                   PARM      *BLANKS       ZOUT25           25                         BUG3114
      *                                                                                      BUG3114
     C                   if        ZNEG = '-'                                                BUG3114
     C                   MOVE      ZOUT21        DDCGRF                                      BUG3114
     C                   else                                                                BUG3114
     C                   MOVE      Zout20        DDCGRF                                      BUG3114
     C                   endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   ENDSR                                                               BUG3114
      *****************************************************************                      BUG3114
      /EJECT                                                                                 BUG3114
      *****************************************************************                      BUG3114
      * SROSIN - Calculate Outstanding Interest via Rule of 78        *                      BUG3114
      *****************************************************************                      BUG3114
     C     SROSIN        BEGSR                                                               BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     WrkLnVDAT     W78VDT            5 0                       BUG3114
     C                   Z-ADD     WrkLnMDAT     W78MDT            5 0                       BUG3114
     C                   Z-ADD     WrkLnFLTI     W78FLT           15 0                       BUG3114
     C                   MOVE      WrkLnRFRQ     W78RPF            1                         BUG3114
     C                   Z-ADD     WrkLnFRPD     W78FRD            5 0                       BUG3114
     C                   Z-ADD     WrkLnRDYN     W78RPM            2 0                       BUG3114
     C                   MOVE      WrkLnCCY      W78CCY            3                         BUG3114
     C                   MOVE      *BLANKS       W78LCN            3                         BUG3114
     C                   Z-ADD     WrkLnVDAT     W78BEG            5 0                       BUG3114
     C                   Z-ADD     ZIEND         W78END            5 0                       BUG3114
     C                   MOVE      'A'           W78ROA            1                         BUG3114
      *                                                                                      BUG3114
     C                   EXSR      RULE78                                                    BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     W78INT        ZINTR                                       BUG3114
      *                                                                                      BUG3114
     C                   ENDSR                                                               BUG3114
      *****************************************************************                      BUG3114
      /EJECT                                                                                 BUG3114
      *****************************************************************                      BUG3114
      * RULE78 - Calculate Outstanding interest for a given period    *                      BUG3114
      *          based on Rule of 78                                  *                      BUG3114
      *****************************************************************                      BUG3114
     C     RULE78        BEGSR                                                               BUG3114
      *                                                                                      BUG3114
      ** Define input and output fields                                                      BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     W78VDT        W78VDT            5 0                       BUG3114
     C                   Z-ADD     W78MDT        W78MDT            5 0                       BUG3114
     C                   Z-ADD     W78FLT        W78FLT           15 0                       BUG3114
     C                   MOVE      W78RPF        W78RPF            1                         BUG3114
     C                   Z-ADD     W78FRD        W78FRD            5 0                       BUG3114
     C                   Z-ADD     W78RPM        W78RPM            2 0                       BUG3114
     C                   MOVE      W78CCY        W78CCY            3                         BUG3114
     C                   MOVE      W78LCN        W78LCN            3                         BUG3114
     C                   Z-ADD     W78BEG        W78BEG            5 0                       BUG3114
     C                   Z-ADD     W78END        W78END            5 0                       BUG3114
     C                   MOVE      W78ROA        W78ROA            1                         BUG3114
     C                   Z-ADD     *ZERO         W78INT           30 9                       BUG3114
     C                   Z-ADD     *ZERO         W78SUM            6 0                       BUG3114
     C                   Z-ADD     *ZERO         W78NPY            5 0                       BUG3114
     C                   Z-ADD     *ZERO         W78NTH            3 0                       BUG3114
     C                   Z-ADD     *ZERO         W78PRD            3 0                       BUG3114
      *                                                                                      BUG3114
      ** Save fields, may be used in other programs                                          BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     ZDAYNO        WZDAYN            6 0                       BUG3114
     C                   MOVE      ZFREQ         WZFREQ            1                         BUG3114
     C                   Z-ADD     ZMDAY         WZMDAY            2 0                       BUG3114
     C                   MOVE      ZCCY          WZCCY             3                         BUG3114
     C                   MOVE      ZLOC          WZLOC             3                         BUG3114
      *                                                                                      BUG3114
      ** Compute for the total number of payments during the life of                         BUG3114
      ** the loan, depending on the repayment frequency                                      BUG3114
      *                                                                                      BUG3114
     C     W78RPF        IFEQ      *BLANKS                                                   BUG3114
     C                   GOTO      ERUL78                                                    BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     1             W78NPY                                      BUG3114
     C                   Z-ADD     W78FRD        ZDAYNO                                      BUG3114
     C                   MOVE      W78RPF        ZFREQ                                       BUG3114
     C                   Z-ADD     W78RPM        ZMDAY                                       BUG3114
     C                   MOVE      W78CCY        ZCCY                                        BUG3114
     C                   MOVE      W78LCN        ZLOC                                        BUG3114
     C                   EXSR      ZFREQB                                                    BUG3114
     C     ZDAYNO        DOWLT     W78MDT                                                    BUG3114
     C     ZDAYNO        ANDGE     W78FRD                                                   AR830785
     C                   ADD       1             W78NPY                                      BUG3114
     C                   EXSR      ZFREQB                                                    BUG3114
     C                   ENDDO                                                               BUG3114
      *                                                                                      BUG3114
      ** Add 1 to total number of payments to include repayment on                           BUG3114
      ** maturity date                                                                       BUG3114
      *                                                                                      BUG3114
     C                   ADD       1             W78NPY                                      BUG3114
      *                                                                                      BUG3114
      ** Compute for the sum of digits                                                       BUG3114
      *                                                                                      BUG3114
     C     W78NPY        ADD       1             WKSUM             8 2                       BUG3114
     C                   DIV       2             WKSUM                                       BUG3114
     C     WKSUM         MULT      W78NPY        W78SUM                                      BUG3114
      *                                                                                      BUG3114
      ** If first repayment date is a holiday, move to next working day                      BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     W78FRD        ZDAYNO                                      BUG3114
     C                   MOVE      W78CCY        ZCCY                                        BUG3114
     C                   MOVE      W78LCN        ZLOC                                        BUG3114
     C                   MOVE      *BLANKS       ZIND                                        BUG3114
     C     ZIND          DOUNE     'H'                                                       BUG3114
     C                   CALLB     'ZCHKH'                                                   BUG3114
     C                   PARM                    ZDAYNO                                      BUG3114
     C                   PARM                    ZCCY                                        BUG3114
     C                   PARM                    BJSLCD                                      BUG3114
     C                   PARM                    ZIND                                        BUG3114
     C     ZIND          IFEQ      'H'                                                       BUG3114
     C                   ADD       1             ZDAYNO                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   ENDDO                                                               BUG3114
      *                                                                                      BUG3114
      ** Compute for the Nth payment for interest for a given period                         BUG3114
      *                                                                                      BUG3114
     C     W78ROA        IFEQ      'A'                                                       BUG3114
     C     W78VDT        IFEQ      W78BEG                                                    BUG3114
     C                   Z-ADD     1             W78NTH                                      BUG3114
     C                   ELSE                                                                BUG3114
     C                   Z-ADD     2             W78NTH                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   ELSE                                                                BUG3114
     C     W78BEG        IFLT      ZDAYNO                                                    BUG3114
     C     W78BEG        IFEQ      W78END                                                    BUG3114
     C                   Z-ADD     ZDAYNO        W78END                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   Z-ADD     ZDAYNO        W78BEG                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   Z-ADD     1             W78NTH                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   MOVE      W78RPF        ZFREQ                                       BUG3114
     C                   Z-ADD     W78RPM        ZMDAY                                       BUG3114
     C                   MOVE      W78CCY        ZCCY                                        BUG3114
     C                   MOVE      W78LCN        ZLOC                                        BUG3114
     C                   MOVE      ZDAYNO        TDAYNO            5 0                      AR830785
     C     ZDAYNO        DOWLT     W78BEG                                                    BUG3114
     C     ZDAYNO        ANDGE     TDAYNO                                                   AR830785
     C                   EXSR      ZFREQB                                                    BUG3114
     C                   ADD       1             W78NTH                                      BUG3114
      *                                                                                      BUG3114
      ** If next  repayment date is a holiday, move to next working day                      BUG3114
      *                                                                                      BUG3114
     C     ZIND          DOUNE     'H'                                                       BUG3114
     C                   CALLB     'ZCHKH'                                                   BUG3114
     C                   PARM                    ZDAYNO                                      BUG3114
     C                   PARM                    ZCCY                                        BUG3114
     C                   PARM                    BJSLCD                                      BUG3114
     C                   PARM                    ZIND                                        BUG3114
     C     ZIND          IFEQ      'H'                                                       BUG3114
     C                   ADD       1             ZDAYNO                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   ENDDO                                                               BUG3114
     C                   ENDDO                                                               BUG3114
      *                                                                                      BUG3114
      ** If end date < start date, OR amortisation date same or after                        BUG3114
      ** maturity date, OR repayment date is after maturity date,                            BUG3114
      ** OR repayment date earlier than the first repayment date                             BUG3114
      ** - zeroise the interest amount                                                       BUG3114
      *                                                                                      BUG3114
     C     W78END        IFLT      W78BEG                                                    BUG3114
     C     W78BEG        ORGE      W78MDT                                                    BUG3114
     C     W78ROA        ANDEQ     'A'                                                       BUG3114
     C     W78BEG        ORLT      W78VDT                                                    BUG3114
     C     W78ROA        ANDEQ     'A'                                                       BUG3114
     C     W78BEG        ORGT      W78MDT                                                    BUG3114
     C     W78ROA        ANDEQ     'R'                                                       BUG3114
     C     W78BEG        ORLT      W78FRD                                                    BUG3114
     C     W78END        ANDLT     W78FRD                                                    BUG3114
     C     W78ROA        ANDEQ     'R'                                                       BUG3114
     C                   Z-ADD     *ZERO         W78INT                                      BUG3114
     C                   GOTO      ERUL78                                                    BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     W78NTH        WKSAV             3 0                       BUG3114
      *                                                                                      BUG3114
      ** Compute for outstanding interest for the period                                     BUG3114
      ** until given end date or until                                                       BUG3114
      *                                                                                      BUG3114
     C     ZDAYNO        DOUGT     W78END                                                    BUG3114
     C     W78NTH        ORGT      W78NPY                                                    BUG3114
     C     W78NPY        SUB       W78NTH        WINTPD           30 9                       BUG3114
     C                   ADD       1             WINTPD                                      BUG3114
     C                   MULT      W78FLT        WINTPD                                      BUG3114
     C                   DIV       W78SUM        WINTPD                                      BUG3114
     C                   ADD       WINTPD        W78INT                                      BUG3114
      *                                                                                      BUG3114
      ** Do not process frequency date calculation on first payment                          BUG3114
      ** date, i.e., beginning date is less than FRPD                                        BUG3114
      *                                                                                      BUG3114
     C     W78NTH        IFNE      1                                                         BUG3114
     C     W78ROA        ANDEQ     'A'                                                       BUG3114
     C     W78ROA        OREQ      'R'                                                       BUG3114
     C                   EXSR      ZFREQB                                                    BUG3114
      *                                                                                      BUG3114
      ** If next  repayment date is a holiday, move to next working day                      BUG3114
      *                                                                                      BUG3114
     C     ZIND          DOUNE     'H'                                                       BUG3114
     C                   CALLB     'ZCHKH'                                                   BUG3114
     C                   PARM                    ZDAYNO                                      BUG3114
     C                   PARM                    ZCCY                                        BUG3114
     C                   PARM                    BJSLCD                                      BUG3114
     C                   PARM                    ZIND                                        BUG3114
     C     ZIND          IFEQ      'H'                                                       BUG3114
     C                   ADD       1             ZDAYNO                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   ENDDO                                                               BUG3114
      *                                                                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   ADD       1             W78NTH                                      BUG3114
     C                   ADD       1             W78PRD                                      BUG3114
     C                   ENDDO                                                               BUG3114
     C                   SUB       1             W78PRD                                      BUG3114
     C                   Z-ADD     WKSAV         W78NTH            3 0                       BUG3114
      *                                                                                      BUG3114
      ** Restore fields, may be used in other programs                                       BUG3114
      *                                                                                      BUG3114
     C     ERUL78        TAG                                                                 BUG3114
     C                   Z-ADD     WZDAYN        ZDAYNO                                      BUG3114
     C                   MOVE      WZFREQ        ZFREQ                                       BUG3114
     C                   Z-ADD     WZMDAY        ZMDAY                                       BUG3114
     C                   MOVE      WZCCY         ZCCY                                        BUG3114
     C                   MOVE      WZLOC         ZLOC                                        BUG3114
      *                                                                                      BUG3114
     C                   ENDSR                                                               BUG3114
      *****************************************************************                      BUG3114
      /EJECT                                                                                 BUG3114
      *****************************************************************                      BUG3114
      *                                                               *                      BUG3114
      * ZFREQB - Calc day num of next pymnt frq from curr dayno       *                      BUG3114
      *                                                               *                      BUG3114
      *****************************************************************                      BUG3114
     C     ZFREQB        BEGSR                                                               BUG3114
                                                                                             BUG3114
     C                   CallB     'ZFREQB'                                                  BUG3114
     C                   Parm      *blanks       RetCodeIn                                   BUG3114
     C                   Parm                    ZFREQ             1                         BUG3114
     C                   Parm                    ZDAYNO            5 0                       BUG3114
     C                   Parm                    ZCCY              3                         BUG3114
     C                   PARM                    ZLOC                                       AR702741
     C                   Parm                    ZMDAY             2 0                       BUG3114
     C                   Parm                    BJDFIN                                      BUG3114
     C                   Parm      SDGELR        SDGELR                                      BUG3114
                                                                                             BUG3114
     C                   ENDSR                                                               BUG3114
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErr - Reset error fields                              *
      *                                                               *
      *****************************************************************
 
     C     SRResetErr    BEGSR
      *
      ***  Reset error fields.
      *
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   IdX
 
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIdX
      *
      ***  Initialise screen fields error indicators.
      *
     C                   MOVE      *ALL'Y'       ErrorMaPy
 
     C     ESRResetErr   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End program                                            *
      *****************************************************************
     C     ENDP          BEGSR
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEMAPYSIN'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access Customer Lending data
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Access Trading Data
      *
     C                   CALLB     'AOTRADR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDTRADPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '004'         DBASE                          * DBERR 004 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
 
     C                   MOVEL     BGMBIN        MBIN              1
      *
      ***  Access General Ledger
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '005'         DBASE                          * DBERR 005 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
     C                   If        BGRTBN = 'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
 
     C                   endif
      *
      ***  Determine if Customer Lending Enhancements - Authorization
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - BackValuation
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE003            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE003
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - Syndication
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE004'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE004
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - other features
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - other features (T3)
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE007            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE007
      *
      ***  Determine if Customer Lending Enhancements - other features (T3)
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE009            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009
     C                   END
     C                   END
      *
      ***  Determine if Customer Lending Enhancements -
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE014            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014
     C                   END
      *
      ***  Determine if CEU004 is activated
      *
     C                   MOVE      'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   END
      *
      ***  Determine if CDE001 is activated - Data Export for CCRM limits
      *
     C                   MOVE      'N'           CDE001            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDE001
     C                   END
      *
      ***  Determine if CLE023 is activated - LE enh: History improvement
      *
     C                   MOVE      'N'           CLE023            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE023
     C                   END
      *                                                                                      BUG3114
      ** Access Switchable SAR details for the existence of CLE028                           BUG3114
      *                                                                                      BUG3114
     C                   CALLB     'AOSARDR0'                                                BUG3114
     C                   PARM      *BLANK        @RTCD                                       BUG3114
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3114
     C                   PARM      'CLE028'      @SARD                                       BUG3114
      *                                                                                      BUG3114
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3114
     C                   MOVE      'Y'           CLE028            1                         BUG3114
     C                   ELSE                                                                BUG3114
     C                   MOVE      'N'           CLE028                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                       CSC022
      ** Determine if enhancement CSC022 is switched on                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD             7                          CSC022
     C                   PARM      '*VERIFY'     POPTN             7                          CSC022
     C                   PARM      'CSC022'      PSARD             6                          CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      * Initialize work fields                                                                CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      *                                                                                       CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        COMITNUM <> 0                                              CSC022
     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
     C                   If        WPos > 0                                                   CSC022
     C                   Eval      WSkpCom = 'Y'                                              CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Else                                                                 CSC022
      ** An NRF (No Record Found) return code is valid.                                       CSC022
      ** Issue database error only for error return codes.                                    CSC022
     C                   If        PRTCD <> '*NRF'                                            CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   Eval      DBASE = 006                                                CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD                                        CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE148
      ** Parameter list for calling AOSVALR0                                                  CLE148
      *                                                                                       CLE148
     C     P_AOSVALR0    PLIST                                                                CLE148
      *                                                                                       CLE148
      ** Return Code (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PRetCode                                     CLE148
      *                                                                                       CLE148
      ** System Value to be retrieved (Input)                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PSysValK1                                    CLE148
      *                                                                                       CLE148
      ** Value returned (Output)                                                              CLE148
      *                                                                                       CLE148
     C                   PARM                    PSysVal1                                     CLE148
     C                   PARM                    PSysValK2                                    CLE148
     C                   PARM                    PSysVal2                                     CLE148
     C                   PARM                    PSysValK3                                    CLE148
     C                   PARM                    PSysVal3                                     CLE148
     C                   PARM                    PSysValK4                                    CLE148
     C                   PARM                    PSysVal4                                     CLE148
     C                   PARM                    PSysValK5                                    CLE148
     C                   PARM                    PSysVal5                                     CLE148
     C                   PARM                    PSysValK6                                    CLE148
     C                   PARM                    PSysVal6                                     CLE148
     C                   PARM                    PSysValK7                                    CLE148
     C                   PARM                    PSysVal7                                     CLE148
     C                   PARM                    PSysValK8                                    CLE148
     C                   PARM                    PSysVal8                                     CLE148
     C                   PARM                    PSysValK9                                    CLE148
     C                   PARM                    PSysVal9                                     CLE148
     C                   PARM                    PSysValK10                                   CLE148
     C                   PARM                    PSysVal10                                    CLE148
      *                                                                                       CLE148
      ** Retrieve System Value 'LoanAlphaAllow'                                               CLE148
      *                                                                                       CLE148
     C                   EVAL      PRetCode = *BLANKS                                         CLE148
     C                   EVAL      PSysValK1 = 'LoanAlphaAllow'                               CLE148
     C                   EVAL      PSysVal1 = *BLANKS                                         CLE148
      *                                                                                       CLE148
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                   CLE148
      *                                                                                       CLE148
      ** If Error retrieving the System values                                                CLE148
      *                                                                                       CLE148
     C                   IF        %ERROR OR PRetCode <> *BLANKS                              CLE148
     C                             OR (*INU7 = *ON AND *INU8 = *ON)                           CLE148
     C     *LOCK         IN        LDA                                                        CLE148
     C                   EVAL      DBFILE = 'AOSVALR0'                                        CLE148
     C                   EVAL      DBASE = 8                                                  CLE148
     C                   EVAL      DBKEY = 'LoanAlpha(Allow/Chksum)'                          CLE148
     C                   EVAL      DBPGM = PsProcPgm                                          CLE148
     C                   OUT       LDA                                                        CLE148
     C                   EXSR      *PSSR                                                      CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   MOVEL     PSysVal1      wLoanAlpha                                   CLE148
      *
      ***  Start with the details screen
      *
     C                   MOVEL     'M'           @SCRN             1
      *
      ***  Initialise field and function key status on details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
      ***  Initialise other Indicator
      *
     C                   EXSR      IOTI@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  POWER
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**  CPY@
(c) Finastra International Limited 2002
