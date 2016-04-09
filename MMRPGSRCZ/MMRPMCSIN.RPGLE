     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Repo margin call input')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMRPMCSIN - REPO MARGIN CALLS SCREEN INPUT                   *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Repo Margin Calls.                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 22Aug05               *
      *                 CDL038             Date 10May05               *
      *                 CMM105             Date 22Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 BUG2804            Date 20May04               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196380             Date 15May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006  *CREATE    DATE 28Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
      *           Change due to additional parameter added to         *
      *           call MMRPDLUPD.                                     *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:MMRPMCSD01,MMRPMCSC01              *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  196380 - Added parameter to MMLDNIRTV call.                  *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CSE006 - Repurchase Agreements                               *
      *                                                               *
      *****************************************************************

     FSDTIX     UF A E           K DISK
     F                                     COMMIT
     F                                     PREFIX(DX)

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
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

     D ##CM            S              1    DIM(58) CTDATA PERRCD(58)
     D ##CF            S              1    DIM(21) CTDATA PERRCD(21)
     D ##OX1           S              1    DIM(78) CTDATA PERRCD(78)
     D ##OX2           S              1    DIM(78) CTDATA PERRCD(78)
     D ##OX3           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX4           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX5           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX6           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX7           S              1    DIM(68) CTDATA PERRCD(68)
     D ##OX8           S              1    DIM(71) CTDATA PERRCD(71)
     D ##OX9           S              1    DIM(71) CTDATA PERRCD(71)
     D ##CN1           S              1    DIM(81) CTDATA PERRCD(81)
     D ##CT1           S              1    DIM(81) CTDATA PERRCD(81)
     D ##CN2           S              1    DIM(78) CTDATA PERRCD(78)
     D ##CT2           S              1    DIM(78) CTDATA PERRCD(78)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D NwMcFilFmt    E DS                  EXTNAME(MMVRPMCPD) PREFIX(P)
      * New Deal in File Format

     D NwMcScnFmt    E DS                  EXTNAME(MMRPMCPD)
      * New Deal in Screen Format

     D CrMcScnFmt    E DS                  EXTNAME(MMRPMCPD) PREFIX(L)
      * Current Deal in Screen Format

     D DeamFilFmt    E DS                  EXTNAME(MMDEAMPP)
      * New Deal in Screen Format

     D NwDlFilFmt    E DS                  EXTNAME(MMVDEAMPD)
      * New Deal in File Format
     D QQDOR1        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR1        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP1        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP1        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON1        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON1        E                     EXTFLD(QQPONS)                                     CGL029
     D  IGREC                300    368
     D  IGPAY                369    927
     D  IGRECEx             1137   1154                                                       CGL029
     D  IGPAYEx             1155   1172                                                       CGL029

     D CrDlFilFmt    E DS                  EXTNAME(MMDELDPP)
      * Current Deal in File Format
     D QQDOR2        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR2        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP2        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP2        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON2        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON2        E                     EXTFLD(QQPONS)                                     CGL029

     D NeDlFilFmt    E DS                  EXTNAME(MMVLDNIPD)
      * New Deal in File Format
     D QQDOR3        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR3        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP3        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP3        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON3        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON3        E                     EXTFLD(QQPONS)                                     CGL029
     D QQINS3        E                     EXTFLD(QQINSA)                                     CGL029

     D CrDlScnFmt    E DS                  EXTNAME(MMLDNIPD) PREFIX(C)
      * (Current) Deal in Screen Format

     D NwDlScnFmt    E DS                  EXTNAME(MMLDNIPD) PREFIX(N)
      * New Deal in Screen Format
                                                                                              CAP087
     D DPTXX         E DS                  EXTNAME(DPTMVDL1) PREFIX(D)                        CAP087
     D**  Data structure of Depot Movement File                                               CAP087

     D MMERPM        E DS                  EXTNAME(MMERPMCPD)
      * Error indicators

     D @CCI@M          DS
      ** Current Control Indicators for main Detail Screen
     D  @EINKJ                 1      1
     D  @EINKL                 2      2
     D  @EINKN                 3      3

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDTypeOK                      1A
     D  DDAmntOK                      1A
     D  DDDlnoOK                      1A
     D  DDCcyOK                       1A

      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0

      ** Warning Index for arrays of of error message ids etc
     D WIdx            S              3P 0

     D                 DS
     D**  Data Structure for screen value date
     D  @VDAT                  1      6
     D  @DSPD                  1      2
     D  @DSPM                  3      4
     D  @DSPY                  5      6

     D                 DS
     D**  Data Structure to format date parameter passed to mm0085
     D  @PDAT                  1      8  0
     D  @PDYY                  1      4  0
     D  @PYEAR                 3      4  0
     D  @PDMM                  5      6  0
     D  @PDDD                  7      8  0
     D*
      **  Time data structure for DTRIX.
     D                 DS
     D  @XTIME                 1      6  0
     D  DXTIM                  1      4  0


     D  DlPtcInd       S              1
     D  DlAcptInd      S              1

     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A
      ** Midas Day number
     D @@DAYN          S              5P 0

      ** Flag to indicate caller of MMRPDLUPD                                                 CAP087
      ** 'Y' - called from Securities module                                                  CAP087
      ** 'N' - called from Money Markey module                                                CAP087
     D DepotPos        S              1A                                                      CAP087
                                                                                              CAP087
      ** Formatted date field for use in the parameter list
     D                 DS
     D DateOut                 1      8  0
     D YrYr                    1      4  0
     D MnMn                    5      6  0
     D DyDy                    7      8  0
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
     D/COPY WNCPYSRC,MMRPMCSD01

      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   Z-ADD     99            ER                2 0

      * Do while ER is equal to 99
     C                   DOW       ER = 99

     C                   IF        DlAcptInd = 'Y'
     C                   EVAL      @EINKL = 'Y'
     C                   ELSE
     C                   EVAL      @EINKL = *Blank
     C                   ENDIF

     C                   CALLB     'MMRPMCDSP'
     C                   PARM                    RetCodeIn
     C                   PARM                    NwMcScnFmt
     C                   PARM                    MMERPM
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EINKL            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'Y'           @EINKP            1
     C                   PARM                    @SIDN             6
     C                   PARM      'N'           DlAmdInd          1
     C                   PARM                    DlPtcInd          1
     C                   PARM                    @INKC             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C                   PARM                    WriteOnly         1
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMERPM
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   Z-ADD     0             Ix
     C*
     C** Process Actions
     C
     C                   SELECT
     C*
     C** F3 Pressed
     C                   WHEN      @INKC = '1'
     C                   EVAL      ER = 0
     C*
     C** F15 Pressed
     C                   WHEN      @INKP = '1'
     C                   EXSR      PROC15
     C*
     C** F12 Pressed
     C                   WHEN      @INKL = '1'
     C                   EVAL      DlAcptInd = *Blank
     C*
     C** Enter Key Pressed
     C                   OTHER
     C*
     C** Validate entry by calling MMRPMCRTV
     C                   CALLB     'MMRPMCRTV'
     C                   PARM                    RetCodeIn
     C                   PARM      *Blanks       ModeofOp          6
     C                   PARM      'S'           RespMode          1
     C                   PARM                    DDACTN            1
     C                   PARM      *Blanks       FOTRID           20
     C                   PARM      *Blanks       FOASID           20
     C                   PARM                    DDDLNO            6
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDCASE            1
     C                   PARM      *Blanks       DDDS38            3
     C                   PARM                    DDAMNT           15
     C                   PARM                    DDTYPE            2
     C                   PARM                    DDRTYP           14
     C                   PARM                    DeamFilFmt
     C                   PARM                    OKACTN            1
     C                   PARM                    OKDLNO            1
     C                   PARM                    OKVDAT            1
     C                   PARM                    OKSEQN            1
     C                   PARM                    OKCASE            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    Ix                3 0
      *
      * If action code, deal number, or value date are okay execute
      * subroutine to process input.
      *
     C     Ix            IFEQ      0
     C                   EXSR      CashSec
     C                   ENDIF
     C
     C                   ENDSL
     C
     C                   EVAL      DlPtcInd = *Blank
     C
     C                   ENDDO
     C
     C                   EVAL      *INLR = '1'
     C                   RETURN
     C
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Proc15 - Process F15 Functions                                *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     Proc15        BEGSR
      *
      ** Ensure that Cash/Securities indicator is set for 'Cash'
     C                   IF        DDCASE = 'C'
     C
     C                   CALLB     'MMRPMCBRW'
     C                   PARM                    RetCodeIn
     C                   PARM      'E'           DDACTN            1
     C                   PARM      *Blanks       DDDLNO            6
     C                   PARM      *Blanks       DDVDAT            6
     C                   PARM                    DDDS38            3
     C                   PARM      'Y'           @BDSFL            1
     C                   PARM      'Y'           @RDSFL            1
     C                   PARM                    @ERRMS            7
     C                   PARM                    @OPSEL            1
     C                   PARM                    @DLSEL            6
     C                   PARM                    @VDSEL            6
     C                   PARM                    @SQSEL            3
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
     C*
     C** Set-up DDACTN according to action code
     C                   IF        @OPSEL = 'A' or @OPSEL = 'X'
     C                             or @OPSEL = 'D'
     C                   MOVE      @OPSEL        DDACTN
     C                   ELSE
     C                   EVAL      DDACTN = 'E'
     C                   ENDIF
     C
     C*
     C** Continue with processing if record is selected
     C                   IF        @INKC = '0' and @INKL = '0'
     C*
     C** Call retrieve module to get deal amendment details
     C                   CALLB     'MMRPMCRTV'
     C                   PARM                    RetCodeIn
     C                   PARM      *Blanks       ModeofOp          6
     C                   PARM      'S'           RespMode          1
     C                   PARM                    DDACTN            1
     C                   PARM      *Blanks       FOTRID           20
     C                   PARM      *Blanks       FOASID           20
     C                   PARM      @DLSEL        DDDLNO            6
     C                   PARM      @VDSEL        DDVDAT            6
     C                   PARM                    DDCASE            1
     C                   PARM      *Blanks       DDDS38            3
     C                   PARM                    DDAMNT           15
     C                   PARM                    DDTYPE            2
     C                   PARM                    DDRTYP           14
     C                   PARM                    DeamFilFmt
     C                   PARM                    OKACTN            1
     C                   PARM                    OKDLNO            1
     C                   PARM                    OKVDAT            1
     C                   PARM                    OKSEQN            1
     C                   PARM                    OKCASE            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         Ix                3 0
     C*
     C** Check for returned errors.
     C                   IF        OKACTN = 'Y' and OKDLNO = 'Y'
     C                             and OKVDAT = 'Y' and OKSEQN = 'Y'
     C*
     C** If Deal number or value date has changed clear fields
     C                   IF        DDDLNO <> SavDlno or DDVDAT <> SavVdat
     C                   EVAL      DDAMNT = *Blanks
     C                   EVAL      DDTYPE = *Blanks
     C                   ENDIF
     C*
     C** Call Convert module to set-up details on screen
     C                   CALLB     'MMRPMCCVT'
     C                   PARM                    RetCodeIn
     C                   PARM                    DeamFilFmt
     C                   PARM                    NwMcScnFmt
     C*
     C** Move Current details into current details file
     C                   MOVEL     NwMcScnFmt    CrMcScnFmt
     C*
     C** Display details until they are valid
     C                   Z-ADD     99            EN                2 0
     C*
     C                   DOW       EN = 99
     C*
     C** If Accept flag is set display message
     C                   IF        DlPtcInd = 'Y'
     C                   MOVEL     'MMA0734'     MsgIdArr(1)
     C                   MOVEL     'DDAMNT'      FldNameArr(1)
     C                   ENDIF

     C                   IF        DDACTN <> 'A' and DDACTN <> 'I'
     C                   EVAL      DlPtcInd = 'Y'
     C                   ENDIF

     C                   CALLB     'MMRPMCDSP'
     C                   PARM                    RetCodeIn
     C                   PARM                    NwMcScnFmt
     C                   PARM                    MMERPM
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'Y'           @EINKL            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM                    @SIDN             6
     C                   PARM      'Y'           DlAmdInd          1
     C                   PARM                    DlPtcInd          1
     C                   PARM                    @INKC             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C                   PARM                    WriteOnly         1
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMERPM
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C*
     C** Save Key fields for comparison
     C                   MOVE      DDDLNO        SavDlno           6
     C                   MOVE      DDVDAT        SavVdat           6
     C*
     C** Do not validate input if F3 or F12 have been pressed
     C                   IF        @INKC <> '1' and @INKL <> '1'
     C*
     C** Call module to validate amendment type and amount
     C                   CALLB     'MMRPMCVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwMcScnFmt
     C                   PARM                    CrMcScnFmt
     C                   PARM                    OKFlagsDS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *Zero         Ix
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwMcFilFmt
     C*
     C                   EVAL      OKTYPE = DDTypeOK
     C                   EVAL      OKAMNT = DDAmntOK
     C
     C                   ENDIF
     C*
     C** If DlPtctInd is 'Y' and Enter pressed then update files else
     C** unprotect Amount and amendment type
     C                   IF        DlPtcInd = 'Y'
     C                   IF        @INKL  = '1' and DDACTN = 'A'
     C                             or @INKL = '1' and DDACTN = 'I'
     C                   EVAL      DlPtcInd = ' '
     C                   ELSE
     C                   EVAL      EN = 0
     C                   EVAL      DlPtcInd = ' '
     C                   ENDIF
     C                   ELSE
     C                   IF        @INKL  = '1'
     C                   EVAL      EN = 0
     C                   ENDIF
     C*
     C** Set DlPtcInd to 'Y' if there are no errors
     C                   IF        Ix = 0 and @INKL <> '1'
     C                   EVAL      DlPtcInd = 'Y'
     C                   ENDIF
     C                   ENDIF
     C*
     C** Set EN to zero if F3 is pressed
     C                   IF        @INKC  = '1'
     C                   EVAL      EN = 0
     C                   ENDIF
     C*
     C** End of Loop
     C                   ENDDO
     C*
     C** Perform Updates if this is not an enquiry
     C                   IF        DDACTN <> 'E' and @INKC <> '1'
     C                             and @INKL <> '1'
     C*
     C** Move DeamFilFmt to NwDlFilFmt an enquiry
     C                   MOVEL     DeamFilFmt    NwDlFilFmt
      *
      * UPDATE VALID DEAM: DEAL NUMBER
     C                   MOVEL     DDDLNO        IGDA38
      *
      * UPDATE VALID DEAM: LAST ACTION CODE
     C                   MOVEL     DDACTN        IGLACT
      *
      * UPDATE VALID DEAM: AMENDMENT AMOUNT
     C                   MOVE      PIGAMNP       IGAMNP
      *
      * UPDATE VALID DEAM: AMENDMENT TYPE
     C                   MOVEL     PIGTYPE       IGMTYP
      *
      * UPDATE VALID DEAM: DATES
     C                   MOVE      DDVDAT        @VDAT
     C                   Z-ADD     0             @PDAT
     C                   MOVE      @DSPY         @PYEAR
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPD         IGVDDD
     C                   ELSE
     C                   MOVE      @DSPD         IGVDMM
     C                   END
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPM         IGVDMM
     C                   ELSE
     C                   MOVE      @DSPM         IGVDDD
     C                   END
     C*
     C** Century
     C     @PDYY         IFGE      72
     C     @PDYY         ADD       1900          @PDYY
     C                   ELSE
     C     @PDYY         ADD       2000          @PDYY
     C                   END
     C                   MOVE      @PDYY         IGVDYY
      *
      * Generate sequence no to prevent database error in MMDEAMSIN
     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDASEQ
     C                   ELSE
     C                   EVAL      IGDS38 = HNDS38
     C                   ENDIF
     C*
     C** Perform Money Market Updates
     C                   CALLB     'MMDEAMUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    NwDlFilFmt
      *
      * Deal Amendment Updates
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMDEAMUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwDlFilFmt
     C                   END
      *
      * If there were any errors in the update functions, Rollback any
      * updates and end this program. Otherwise, commit the updates
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C*
     C** Clear Fields for next input
     C                   CLEAR                   NwMcScnFmt
     C                   END
     C
     C                   ELSE
     C*
     C** Exit if 'F3' pressed
     C                   IF        @INKC = '1'
     C                   EVAL      ER = 0
     C                   ENDIF
     C*
     C** Clear Fields if F12 pressed
     C                   IF        @INKL = '1'
     C                   MOVE      *BLANKS       DDAMNT
     C                   MOVE      *BLANKS       DDRTYP
     C                   ENDIF
     C*
     C                   ENDIF
     C
     C                   ENDIF
     C                   ENDIF
     C*
     C** Send Error message if 'C' is not entered
     C                   ELSE
     C
     C                   ADD       1             Ix
     C                   MOVE      'N'           OKCASE
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'MMA0733'     MsgIdArr(Ix)
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * CashSec - Process Valid entries if enter key pressed          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     CashSec       BEGSR
     C*
     C** If Cash Securites type is 'C'
     C                   IF        DDCASE = 'C'
     C*
     C** Clear amount and type fields
     C                   EVAL      DDAMNT = *Blanks
     C                   EVAL      DDTYPE = *Blanks
     C*
     C** If Action Code is not 'Insert' convert details
     C                   IF        DDACTN <> 'I'
     C                   CALLB     'MMRPMCCVT'
     C                   PARM                    RetCodeIn
     C                   PARM                    DeamFilFmt
     C                   PARM                    NwMcScnFmt
     C                   ENDIF
     C*
     C** Move Current details into current details file
     C                   MOVEL     NwMcScnFmt    CrMcScnFmt
     C*
     C** Display details until they are valid
     C                   Z-ADD     99            EN                2 0
     C*
     C                   DOW       EN = 99

     C** If Accept flag is set display message
     C                   IF        DlPtcInd = 'Y'
     C                   MOVEL     'MMA0734'     MsgIdArr(1)
     C                   MOVEL     'DDAMNT'      FldNameArr(1)
     C                   ENDIF

     C                   IF        DDACTN <> 'A' and DDACTN <> 'I'
     C                   EVAL      DlPtcInd = 'Y'
     C                   ENDIF

     C                   CALLB     'MMRPMCDSP'
     C                   PARM                    RetCodeIn
     C                   PARM                    NwMcScnFmt
     C                   PARM                    MMERPM
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'Y'           @EINKL            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM                    @SIDN             6
     C                   PARM      'Y'           DlAmdInd          1
     C                   PARM                    DlPtcInd          1
     C                   PARM                    @INKC             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C                   PARM                    WriteOnly         1
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       MMERPM
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C*
     C** Save Key fields for comparison
     C                   MOVE      DDDLNO        SavDlno           6
     C                   MOVE      DDVDAT        SavVdat           6
     C*
     C** Do not validate input if F3 or F12 have been pressed
     C                   IF        @INKC <> '1' and @INKL <> '1'
     C*
     C** Call module to validate amendment type and amount
     C                   CALLB     'MMRPMCVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwMcScnFmt
     C                   PARM                    CrMcScnFmt
     C                   PARM                    OKFlagsDS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *Zero         Ix
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwMcFilFmt
     C*
     C                   EVAL      OKTYPE = DDTypeOK
     C                   EVAL      OKAMNT = DDAmntOK
     C
     C                   ENDIF
     C*
     C** If DlAcptInd is 'Y' and Enter pressed then update files else
     C** unprotect Amount and amendment type
     C                   IF        DlPtcInd = 'Y'
     C                   IF        @INKL  = '1' and DDACTN = 'A'
     C                             or @INKL = '1' and DDACTN = 'I'
     C                   EVAL      DlPtcInd = ' '
     C                   ELSE
     C                   EVAL      EN = 0
     C                   EVAL      DlPtcInd = ' '
     C                   ENDIF
     C                   ELSE
     C                   IF        @INKL  = '1'
     C                   EVAL      EN = 0
     C                   ENDIF
     C*
     C** Set DlPtcInd to 'Y' if there are no errors
     C                   IF        Ix = 0 and @INKL <> '1'
     C                   EVAL      DlPtcInd = 'Y'
     C                   ENDIF
     C                   ENDIF
     C*
     C** Set EN to zero if F3 is pressed
     C                   IF        @INKC  = '1'
     C                   EVAL      EN = 0
     C                   ENDIF
     C*
     C** End of Loop
     C                   ENDDO
     C*
     C** Perform Updates if this is not an enquiry and exit has not been
     C** pressed
     C                   IF        DDACTN <> 'E' and @INKC <> '1'
     C                             and @INKL <> '1'
     C*
     C** Move DeamFilFmt to NwDlFilFmt an enquiry
     C                   MOVEL     DeamFilFmt    NwDlFilFmt
      *
      * UPDATE VALID DEAM: DEAL NUMBER
     C                   MOVEL     DDDLNO        IGDA38
      *
      * UPDATE VALID DEAM: LAST ACTION CODE
     C                   MOVEL     DDACTN        IGLACT
      *
      * UPDATE VALID DEAM: AMENDMENT AMOUNT
     C                   MOVEL     PIGAMNP       IGAMNP
      *
      * UPDATE VALID DEAM: AMENDMENT TYPE
     C                   MOVEL     PIGTYPE       IGMTYP
      *
      * UPDATE VALID DEAM: DATES
     C                   MOVE      DDVDAT        @VDAT
     C                   Z-ADD     0             @PDAT
     C                   MOVE      @DSPY         @PYEAR
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPD         IGVDDD
     C                   ELSE
     C                   MOVE      @DSPD         IGVDMM
     C                   END
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPM         IGVDMM
     C                   ELSE
     C                   MOVE      @DSPM         IGVDDD
     C                   END
     C*
     C** Century
     C     @PDYY         IFGE      72
     C     @PDYY         ADD       1900          @PDYY
     C                   ELSE
     C     @PDYY         ADD       2000          @PDYY
     C                   END
     C                   MOVE      @PDYY         IGVDYY
      *
      * Generate sequence no to prevent database error in MMDEAMSIN
     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDASEQ
     C                   ELSE
     C                   EVAL      IGDS38 = HNDS38
     C                   ENDIF
     C*
     C*
     C** Perform Money Market Updates
     C*
     C                   CALLB     'MMDEAMUPM'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    NwDlFilFmt
      *
      * Deal Amendment Updates
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMDEAMUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwDlFilFmt
     C                   END
      *
      * If there were any errors in the update functions, Rollback any
      * updates and end this program. Otherwise, commit the updates
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C*
     C** Clear Fields for next input
     C                   CLEAR                   NwMcScnFmt
     C                   END
     C*
     C                   ELSE
     C                   IF        @INKC = '1'
     C                   EVAL      ER = 0
     C                   ENDIF
     C*
     C                   IF        @INKL = '1'
     C                   MOVE      *BLANKS       DDAMNT
     C                   MOVE      *BLANKS       DDRTYP
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C** If Cash Securites type is 'S'
     C                   IF        DDCASE = 'S'
     C*
     C** Update deal if deal protect indicator is on
     C                   IF        DlAcptInd = 'Y'
      *
      * REPO DELIVERY DETAILS UPDATE
      *
     C*
     C* Override SECRTNTPPD to QTEMP/SECRTNTPPD
     C*
     C                   Z-ADD     78            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
     C*
     C* Override SECRTTTPPD to QTEMP/SECRTTTPPD
     C*
     C                   Z-ADD     78            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX2
     C                   PARM                    MESLEN
     C*
     C* Override DPTMVDL1 to DPTMVDL1 SHARE(*NO)
     C*
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX3
     C                   PARM                    MESLEN
     C*
     C* Override DPTMVDY1 to DPTMVDY1 SHARE(*NO)
     C*
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX4
     C                   PARM                    MESLEN
     C*
     C* Override DPTMVDY2 to DPTMVDY2 SHARE(*NO)
     C*
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX5
     C                   PARM                    MESLEN
     C*
     C* Override SEDMRPX1 to SEDMRPX1 SHARE(*NO)
     C*
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX6
     C                   PARM                    MESLEN
     C*
     C* Override SEDMRPX2 to SEDMRPX2 SHARE(*NO)
     C*
     C                   Z-ADD     68            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX7
     C                   PARM                    MESLEN
     C*
     C* Override SECRTNL1 to SECRTNL1 SHARE(*NO)
     C*
     C                   Z-ADD     71            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX8
     C                   PARM                    MESLEN
     C*
     C* Override SECRTTL1 to SECRTTL1 SHARE(*NO)
     C*
     C                   Z-ADD     71            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX9
     C                   PARM                    MESLEN
      *
      **
     C                   MOVEL     CrDlFilFmt    NeDlFilFmt
     C
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'MMRPDLUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NeDlFilFmt
     C                   PARM                    DPTXX                                        CAP087
     C                   PARM      'N'           DepotPos                                     CAP087
     C                   END
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C*
     C** Update DTRIXDD and header.
     C                   EXSR      WRTDTX
     C                   EXSR      UPDDTH
     C*
     C                   COMMIT
     C                   MOVEL     'MMA0736'     MsgIdArr(1)
     C                   MOVEL     'DDAMNT'      FldNameArr(1)
     C                   EVAL      DlAcptInd = *Blanks
     C                   END
      *
     C                   ELSE
      *
      * Retrieve Deal
      *
     C                   CALLB     'MMLDNIRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM      'E'           P#ACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      *                                                                                       196380
      * (Midas) Depot Movement Reference                                                      196380
     C                   PARM                    DDDDMR            6                          196380
      *
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN            6
      *
      * Booking branch
     C                   PARM                    DDBRCA            3
      *                                                                                       CAP067
      * REPO Flag                                                                             CAP067
     C                   PARM      'N'           RepoFlag          1                          CAP067
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    CrDlFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA            1
      ** Blocked/Unblock Action                                                              BUG2804
     C                   PARM                    BUACT             1                         BUG2804
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
     C/COPY WNCPYSRC,MMRPMCSC01
     C*
     C** Set Value Date to be Value date from ZDATE1
     C*******************EVAL      HKDVSD = HNDVSD
     C*******************EVAL      HKVDYY = HNVDYY
     C*******************EVAL      HKVDMM = HNVDMM
     C*******************EVAL      HKVDDD = HNVDDD
     C                   CALLB     'ZDATE1'
     C                   PARM      DDVDAT        DateIn
     C                   PARM      *Zero         DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C*
     C                   EVAL      HKDVSD = DayNoOut
     C*
     C** Set Value Date to be Value date from ZDATE9
     C                   CALLB     'ZDATE9'
     C                   PARM      HKDVSD        @@DAYN
     C                   PARM      *Zero         DateOut
     C                   PARM      *Blank        RetCodeOut
     C*
     C                   MOVE      YrYr          HKVDYY
     C                   MOVE      MnMn          HKVDMM
     C                   MOVE      DyDy          HKVDDD
      *
      * Call program to fill screen fields with data from MMDELDPP
      *
     C                   CALLB     'MMLDNICVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deal in file format
     C                   PARM                    CrDlFilFmt
      *
      * OUTPUTS
      *
      * Deal in screen format
     C                   PARM                    NwDlScnFmt
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      *
      ** Collateral Status
     C                   PARM                    DDCSTS           10
      *
      * Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NwDlScnFmt    CrDlScnFmt
      *
     C                   IF        DDACTN = 'I'
     C                   EVAL      NDDACTN = 'M'
     C                   ELSE
     C                   EVAL      NDDACTN = 'E'
     C                   ENDIF
     C*
     C* CREATE TEMPORARY FILES FOR CERTIFICATES PROCESSING
     C*
     C                   Z-ADD     78            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CN2
     C                   PARM                    MESLEN

     C                   Z-ADD     78            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CT2
     C                   PARM                    MESLEN

     C*
     C* Override SECRTNTPPD to QTEMP/SECRTNTPPD
     C*
     C                   Z-ADD     78            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
     C*
     C* Override SECRTTTPPD to QTEMP/SECRTTTPPD
     C*
     C                   Z-ADD     78            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##OX2
     C                   PARM                    MESLEN
      *
     C                   CALLB     'MMRPDLSFL'
     C                   PARM                    NwDlScnFmt
     C                   PARM      *BLANKS       OldDlNo           6
     C                   PARM      *BLANKS       ReturnCode
      *
      * DATABASE ERROR
      *
     C     ReturnCode    IFEQ      '*Error '
     C                   MOVEL     'MMRPDLSFL'   DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     DDDLNO        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C
     C                   SELECT
      *
      * F3 Pressed
      *
     C     ReturnCode    WHENEQ    'F3        '
     C                   Z-ADD     0             ER
     C                   EVAL      DlAcptInd = *Blanks
      *
      * F12 Pressed
      *
     C     ReturnCode    WHENEQ    'F12        '
     C                   EVAL      DlAcptInd = *Blanks
      *
      * Enter Pressed
      *
     C                   OTHER
     C*
     C** Set Deal Protect Indicator to be 'on'.
     C                   IF        DDACTN = 'I'
     C                   EVAL      DlAcptInd = 'Y'
     C                   MOVEL     'MMA0734'     MsgIdArr(1)
     C                   MOVEL     'DDAMNT'      FldNameArr(1)
     C                   END
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPDASEQ - Set up Deal Amendment Sequence Number            *
      *              for Inserts.                                     *
      *                                                               *
      *****************************************************************
     C     SETUPDASEQ    BEGSR
     C*
     C**  Load deal number into numeric field passed to MM0085
     C                   MOVE      DDDLNO        DealNo            6 0
     C*
     C** Format Value Date
     C     DDVDAT        IFNE      *BLANKS
     C*
     C** Load value date to numeric keyfield,in YYYYMMDD format
     C                   MOVE      DDVDAT        @VDAT

     C                   Z-ADD     0             @PDAT
     C                   MOVE      @DSPY         @PYEAR
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPD         @PDDD
     C                   ELSE
     C                   MOVE      @DSPD         @PDMM
     C                   END
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPM         @PDMM
     C                   ELSE
     C                   MOVE      @DSPM         @PDDD
     C                   END
     C*
     C** Century
     C     @PYEAR        IFGE      72
     C     @PDYY         ADD       1900          @PDYY
     C                   ELSE
     C     @PDYY         ADD       2000          @PDYY
     C                   END
     C                   ELSE
     C                   Z-ADD     0             @PDAT
     C                   END
     C                   Z-ADD     @PDAT         ValueDate         8 0

      ** Generate DEAM Sequence Number
     C                   CALLB     'MM0085'
     C                   PARM                    Term              1
     C                   PARM                    DealNo
     C                   PARM                    ValueDate
     C                   PARM                    SeqNoPack         3 0
      *
      ** If error returned from MM0085
     C     Term          IFNE      *BLANK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     SeqNoPack     IGDS38
     C                   ENDIF

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
     C     IKRSTM        IFNE      *ZERO
     C     IKPSTM        ORNE      *ZERO
     C                   MOVE      'Y'           @@CNRQ            1
     C                   ELSE
     C                   MOVE      'N'           @@CNRQ
     C                   END
      *
      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD
      *
     C                   MOVE      'D'           DXRECI
     C                   MOVE      'D'           DXRCDT
     C                   Z-ADD     IKDN38        DXDLNO
     C                   Z-ADD     *ZERO         DXVDAT
     C                   Z-ADD     *ZERO         DXDASN
     C                   MOVE      'A'           DXCHTP
     C                   MOVE      @@CNRQ        DXCNRQ
     C                   MOVE      'N'           DXCNPR
     C                   MOVE      ' '           DXREPR
     C                   TIME                    @XTIME
     C                   MOVE      @@PRI1        DXPRI1
     C                   MOVE      @@PRI2        DXPRI2
     C                   MOVE      @@PRI3        DXPRI3
     C                   Z-ADD     0             DXICIN
     C                   MOVEL     IKBRCA        DXBRCA
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
     C                   MOVEL     'DTRIXHF '    DBFILE                               ******
     C                   MOVEL     '004'         DBASE                                R 004*
     C                   EXSR      *PSSR                                              ******
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
     C     IKMTYP        IFEQ      'IT'
     C     IKMTYP        OREQ      'TD'
     C     IKMTYP        OREQ      'CD'
      *
     C     IKRSTM        IFEQ      01
     C     IKRSTM        OREQ      07
     C     IKRSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IKRONS        @NOSTR
     C                   END
      *
     C                   ELSE
      *
     C     IKPSTM        IFEQ      01
     C     IKPSTM        OREQ      07
     C     IKPSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IKPONS        @NOSTR
     C                   END
      *
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI1 if value date is within telex notice period
      *
     C     IKDVSD        IFGE      BJRDNB
     C     IKDVSD        ANDLE     @TLXDU
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
     C     IKMTYP        IFEQ      'IT'
     C     IKMTYP        OREQ      'TD'
     C     IKMTYP        OREQ      'CD'
      *
     C     IKPSTM        IFEQ      01
     C     IKPSTM        OREQ      07
     C     IKPSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IKPONS        @NOSTR
     C                   END
      *
     C                   ELSE
      *
     C     IKRSTM        IFEQ      01
     C     IKRSTM        OREQ      07
     C     IKRSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IKRONS        @NOSTR
     C                   END
      *
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI2 if interest pay date is within telex notice period
      *
     C     IKNIPD        IFNE      *ZERO
     C     IKNIPD        ANDGE     BJRDNB
     C     IKNIPD        ANDLE     @TLXDU
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
     C     IKMTYP        IFEQ      'IT'
     C     IKMTYP        OREQ      'TD'
     C     IKMTYP        OREQ      'CD'
      *
     C     IKPSTM        IFEQ      01
     C     IKPSTM        OREQ      07
     C     IKPSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IKPONS        @NOSTR
     C                   END
      *
     C                   ELSE
      *
     C     IKRSTM        IFEQ      01
     C     IKRSTM        OREQ      07
     C     IKRSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IKRONS        @NOSTR
     C                   END
      *
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI3 if maturity date is within telex notice period
      *
     C     IKMATD        IFGE      BJRDNB
     C     IKMATD        ANDLE     @TLXDU
     C     IKMTYP        ANDNE     'IL'
     C     IKMTYP        ANDNE     'ID'
     C*
     C     IKAURO        IFNE      'Y'
     C     IKAURO        OREQ      'Y'
     C     IKROBY        ANDNE     *BLANKS
     C                   Z-ADD     1             @@PRI3
     C                   END
      *
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
     C     IKSTCY        IFNE      *BLANKS
     C                   MOVEL     IKSTCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     IKCCY         EffSetCcy         3
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
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
     C*
     C* CREATE TEMPORARY DEPOT MOVEMENTS FOR REPOS FILE
     C*
     C                   Z-ADD     58            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CM
     C                   PARM                    MESLEN
     C*
     C* Clear temporary depot movements file
     C*
     C                   Z-ADD     21            MESLEN           15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CF
     C                   PARM                    MESLEN
     C*
     C* CREATE TEMPORARY FILES FOR CERTIFICATES PROCESSING
     C*
     C                   Z-ADD     81            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CN1
     C                   PARM                    MESLEN

     C                   Z-ADD     81            MESLEN
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ##CT1
     C                   PARM                    MESLEN
     C*
      **  Access Bank Details via Access Object
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** ##CM
CPYF FROMFILE(DPTMVD) TOFILE(QTEMP/SEDMRPXX) CRTFILE(*YES)
** ##CF
CLRPFM QTEMP/SEDMRPXX
** ##OX1
OVRDBF FILE(SECRTNTPPD) TOFILE(QTEMP/SECRTNTPPD) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX2
OVRDBF FILE(SECRTTTPPD) TOFILE(QTEMP/SECRTTTPPD) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX3
OVRDBF FILE(DPTMVDL1) TOFILE(DPTMVDL1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX4
OVRDBF FILE(DPTMVDY1) TOFILE(DPTMVDY1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX5
OVRDBF FILE(DPTMVDY2) TOFILE(DPTMVDY2) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX6
OVRDBF FILE(SEDMRPX1) TOFILE(SEDMRPX1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX7
OVRDBF FILE(SEDMRPX2) TOFILE(SEDMRPX2) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX8
OVRDBF FILE(SECRTNL1) TOFILE(SECRTNL1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##OX9
OVRDBF FILE(SECRTTL1) TOFILE(SECRTTL1) OVRSCOPE(*CALLLVL) SHARE(*NO)
** ##CN1
CPYF FROMFILE(SECRTNTPPD) TOFILE(QTEMP/SECRTNTPPD) CRTFILE(*YES) MBROPT(*REPLACE)
** ##CT1
CPYF FROMFILE(SECRTTTPPD) TOFILE(QTEMP/SECRTTTPPD) CRTFILE(*YES) MBROPT(*REPLACE)
** ##CN2
CPYF FROMFILE(SECRTNPD) TOFILE(QTEMP/SECRTNTPPD) CRTFILE(*NO) MBROPT(*REPLACE)
** ##CT2
CPYF FROMFILE(SECRTTPD) TOFILE(QTEMP/SECRTTTPPD) CRTFILE(*NO) MBROPT(*REPLACE)
