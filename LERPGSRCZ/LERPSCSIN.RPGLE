     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments Schedule - Input')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LERPSCSIN - LE Repayments Schedule - Input                   *
      *                                                               *
      *  Function:  This is the screens input function for Repayment  *
      *             Schedule                                          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE154             Date 02Aug12               *
      *                 MD036070           Date 19Oct15               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG8529            Date 28Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG4960            Date 22Dec04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA070             Date 26Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP079  *CREATE    Date 01Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG8529- If no settlements details for a RPSC are entered    *
      *           then default settlement details from related loan   *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086-  Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  BUG4960 - Unable to enter repayment schedule with settlement *
      *            method 04.                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA070 - RPSC (settlement default wrong on Input)            *
      *         - settlement method defaulted 00 instead              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *                                                               *
      *****************************************************************
      ***  FILES  ***
      *
      *
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
     D WArrCmtJob      S             10A   DIM(10)                                            CSC022
      ** Array for Commitment Job Names                                                       CSC022
                                                                                              CSC022
      ** Data structure for SCCMTJOB data area                                                CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITNO                1      3S 0                                                    CSC022
     D  COMITJOBS              4    103                                                       CSC022
      ** External DS for API ICD                                                              CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
                                                                                              CSC022
     D CrRpScFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Current Repayment schedule in File Format
     D                                     PREFIX(L)
      *
     D CrRpScScnFmt  E DS                  EXTNAME(LERPSCPD)
      ***  (Current) Repayment schedule in screen format
     D                                     PREFIX(@)
      *
     D NwRpScFilFmt  E DS                  EXTNAME(LEVRPSCPD)
      ***  New Repayment schedule in file format
     D***RSREC**              321    389                                                      CGL029
     D***RSPAY**              390    948                                                      CGL029
     D  RSREC                335    389                                                       CGL029
     D  RSPAY                404    948                                                       CGL029
     D  RSRECEx             1195   1212                                                       CGL029
     D  RSPAYEx             1213   1230                                                       CGL029
      *
     D NwRpScScnFmt  E DS                  EXTNAME(LERPSCPD)
      ***  New Repayment schedule in Screen Format
      *
     D ErrorRpSc     E DS                  EXTNAME(LEERPSCPD)
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
     D @CCI@           DS
      ***  Current control indicators for details screens 1, 2, 3, and 4
      *
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKJ                 5      5
     D  @EINKK                 6      6
     D  @EINKN                 7      7
     D  @EINKP                 8      8
      *
     D @PCI@           DS             7
      ***  Previous control indicators for details screen
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details accessed via access program
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Customer Lending ICD
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      * LE (LERI) Extra Data - File (D/B) format                                              CAP086
                                                                                              CAP086
     D ExtData       E DS                  EXTNAME(LERPEXPD)
      ***  LE (RPSC) Extra Data - File (D/B) format
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CLE134
      ***  Second DS for access programs, long data structure                                 CLE134
      *                                                                                       CLE134
     D  OldStsDS       DS
      ***  Old settlement details
      *
     D  OSETP                  1      2  0
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D***OLDSET*                1     34                                                      CGL029
     D***OSPI1**               35     64                                                      CGL029
     D***OSPI2**               65     94                                                      CGL029
     D***OSPI3**               95    124                                                      CGL029
     D***OLDSTS*                1    124                                                      CGL029
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
     D  OLDSET                 1     40                                                       CGL029
     D  OSPI1                 41     70                                                       CGL029
     D  OSPI2                 71    100                                                       CGL029
     D  OSPI3                101    130                                                       CGL029
     D  OLDSTS                 1    130                                                       CGL029
      *
     D  NewStsDS       DS
      ***  New settlement details
      *
     D  WSETP                  1      2
     D***WOSAC**                3     14                                                      CGL029
     D***WTSEN**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D***NEWSET*                1     34                                                      CGL029
     D***WSPI1**               35     64                                                      CGL029
     D***WSPI2**               65     94                                                      CGL029
     D***WSPI3**               95    124                                                      CGL029
     D***NEWSTS*                1    124                                                      CGL029
     D  WOSAC                  3     20                                                       CGL029
     D  WTSEN                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
     D  NEWSET                 1     40                                                       CGL029
     D  WSPI1                 41     70                                                       CGL029
     D  WSPI2                 71    100                                                       CGL029
     D  WSPI3                101    130                                                       CGL029
     D  NEWSTS                 1    130                                                       CGL029
      *
     D  PasDtaDS       DS           256
      ***  New settlement details
      *
     D  WSCCY                  1      3
     D  WOBBR                  4      6
     D  WOSBR                  7      9
     D  SAVLC                 10     20
      *
     D                 DS
      ***  Last change data - LOAMS
     D  WLCD                   1      5  0
     D  WCHTP                  6      6
     D  WTNLU                  7     11  0
     D  WLSTC                  1     11
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PSARD           S              6A                                                      CSC022
     D CSC022          S              1A   Inz                                                CSC022
     D WSkipCommit     S              1A   Inz                                                CSC022
     D WPtr            S              2S 0 Inz                                                CSC022
                                                                                              TDA070
      ** Parameter for LERPSCRTV to retrive Extended settlement intruction                    TDA070
     D*PRcvParm********S             91                                              TDA070  BUG8529
     D***PRcvParm        S             92                                            BUG8529 CSF011A
     D***PPayParm        S            594                                            BUG8529 CSF011A
     D PRcvParm        S            335                                                      CSF011A
     D PPayParm        S           1045                                                      CSF011A
      *
      ***  Response Mode, passed as a constant parameter to the VAL module
      ***  This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('2')
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      *                                                                                       CLE148
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
                                                                                              CSD095
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
      *
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
      /COPY WNCPYSRC,LERPSCS001
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
      /COPY WNCPYSRC,LERPSCS002
      *
      ***  Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      /COPY WNCPYSRC,LERPSCS003
      *
      ***  Do while screen: Screen details
      *
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
      /COPY WNCPYSRC,LERPSCS004
      *
      ***  Do while screen: Settlement details
      *
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
      /COPY WNCPYSRC,LERPSCS005
      *
      ***  Screen: Confirmation of input
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      /COPY WNCPYSRC,LERPSCS006
      *
      ***  Do file updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      /COPY WNCPYSRC,LERPSCS007
      *
      ***  Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   END
      *****************************************************************
      *
      ***  Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LERPSCS008
      *
      /EJECT
      *****************************************************************
      * SCRN@M - Process details screen                               *
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      ***  Update 'previous' Repayment schedule  & screen control indicator
      *
     C                   MOVEL     DDLNRF        @PLNRF            6
     C                   MOVEL     DDACTN        @PACTN            1
     C                   MOVEL     DDSEQN        @PSEQN            3
     C                   MOVEL     DDVDAT        @PVDAT
     C                   MOVEL     @CCI@         @PCI@
      *
      ***  Write/Read display screen
      *
     C                   CALLB     'LERPSCDSP'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Repayment schedule (in screen format)
     C                   PARM                    NwRpScScnFmt
      *
      ***  Fields in error
     C                   PARM                    ErrorRpSc
      *
      ***  Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      ***  Enabled function keys
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKK
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      *
      ***  Succesful insert
     C                   PARM                    @LNRF             6
     C                   PARM                    @VDAT             6
     C                   PARM                    @LSSQ             3
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
     C                   PARM      *OFF          @INKC             1
     C                   PARM      *OFF          @INKG             1
     C                   PARM      *OFF          @INKH             1
     C                   PARM      *OFF          @INKJ             1
     C                   PARM      *OFF          @INKK             1
     C                   PARM      *OFF          @INKL             1
     C                   PARM      *OFF          @INKN             1
     C                   PARM      *OFF          @INKP             1
     C                   PARM      'N'           WriteOnly         1
      *
      ***  Reset errors file and check function keys
      *
     C                   MOVE      *ALL'Y'       ErrorRpSc
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     *ON           ENDP
      *
      ***  CK/7 - Roll Backwards
      *
     C     @INKG         CASEQ     *ON           ROLL
      *
      ***  CK/8 - Roll Forwards
      *
     C     @INKH         CASEQ     *ON           ROLL
      *
      ***  CK/12 - Cancel
      *
     C     @INKL         CASEQ     *ON           CANC@M
      *
      ***  CK/15 - Browse
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
      ***  If action code, loan number and sequence are blank
      ***  Re-output screen
      *
     C     DDACTN        IFEQ      *BLANKS
     C     DDLNRF        ANDEQ     *BLANKS
     C     DDSEQN        ANDEQ     *BLANKS
     C                   GOTO      EVAL@B
     C                   END
      *
      ***  Retrieve Repayment schedule details
      *
     C                   EXSR      RTVRPSC
      *
      ***  If action code or Loan number or sequence number are NOT OK
      ***  Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C     DDSEQNOK      OREQ      'N'
     C     DDVDATOK      OREQ      'N'
     C                   MOVEL     'Y'           WERRTV            1
     C                   GOTO      EVAL@B
     C                   ELSE
     C                   MOVEL     'N'           WERRTV
     C                   ENDIF
      *
      ***  Set field and function key status on details screen
      ***  (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      ***  If action code is delete, enquire or authorize
      ***  or action code is amend and loan number has changed
      ***  or action code is amend and sequence number has changed
      ***  Put the Repayment on the details screen
      *
     C     DDLNRF        IFNE      @PLNRF
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ORNE      @PACTN
     C     DDACTN        ANDNE     'I'
     C     DDSEQN        ORNE      @PSEQN
     C     DDACTN        ANDNE     'I'
     C     DDVDAT        ORNE      @PVDAT
     C     DDACTN        ANDNE     'I'
     C                   EXSR      PUTD@M
     C                   END
      *
      *----------------------------------------------------------------
      ***  If delete
      *
     C     DDACTN        IFEQ      'R'
      *
      ***  Update Repayment schedule in File Format
      *
     C                   MOVEL     CrRpScFilFmt  NwRpScFilFmt
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      *ON
     C                   MOVEL     'U'           @SCRN
     C                   GOTO      EVAL@B
     C                   END
     C                   END
      *----------------------------------------------------------------
      *
      ***  If enquire
      *
     C     DDACTN        IFEQ      'E'
      *
      ***  Update Repayment schedule in File Format
      *
     C                   MOVEL     CrRpScFilFmt  NwRpScFilFmt
      *
      ***  If CK/14 taken, continue to settlements screen
      ***  If browse outstanding, read next browse subfile record
      *
     C     @INKN         IFEQ      *ON
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   END
     C                   END
      *
     C                   GOTO      EVAL@M
     C                   END
      *----------------------------------------------------------------
      *
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
      *
      ***  Update Repayment schedule in File Format
      *
     C                   MOVEL     CrRpScFilFmt  NwRpScFilFmt
      *
      ***  If CK/11 taken, go onto updates
      *
     C                   IF        @INKK = *ON
     C                   EVAL      @SCRN = 'U'
     C                   GOTO      EVAL@B
     C                   ENDIF
     C                   END
      *----------------------------------------------------------------
      *
      ***  If insert or amend
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      ***  and clear Repayment schedule in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
      *
     C                   MOVE      *ALL'Y'       ErrorRpSc
      *
      ***  Update Repayment schedule in valid file format
      *
     C                   MOVEL     CrRpScFilFmt  NwRpScFilFmt
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C     DDACTN        IFEQ      'A'
     C                   CALLB     'LERPSCAMD'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  New Repayment schedule in Screen Format
      *
     C                   PARM                    NwRpScScnFmt
      *
      ***  Current Repayment schedule in Screen Format
      *
     C                   PARM                    CrRpScScnFmt
      *
      ***  Outputs
      *
      ***  Field OK flags (DS) from/to caller
      *
     C                   PARM                    ErrorRpSc
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
      *
      ***  Reset of Fields in Error Required (Y/N)
      *
     C                   PARM      'Y'           @@RSTE            1
     C                   END
      *
      ***  Validate Repayments schedule details
      *
     C                   CALLB     'LERPSC1VL'
      *
      ***  Response mode (1A), from source system common header
     C                   PARM                    RespMode
      *
      ***  New Repayment schedule in details screen
     C                   PARM                    NwRpScScnFmt
      *
      ** Interface data                                                                       CAP086
     C                   PARM                    InfData                                      CAP086
                                                                                              CAP086
      ***  Extended data
     C                   PARM                    ExtData
      *
      ***  Field OK flags (DS)
     C                   PARM                    ErrorRpSc
      *
      ***  Error fields/message IDs/message data (arrays)
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index
     C                   PARM                    Idx
      *
      ***  Warning fields/message IDs/message data (arrays)
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index
     C                   PARM                    WIdx
      *
      ***  Valid Repayment schedule
     C                   PARM                    NwRpScFilFmt
      *
      ***  Processing type in CLOANCL file
     C                   PARM      *BLANKS       PTypFilCLOAN      2
      *                                                                                      BUG4960
      ***  Branch in CLOANCL file                                                            BUG4960
     C                   PARM                    BrcaFilCLOAN      3                         BUG4960
      *
      ***  Update Repayment schedule in file format
      *
     C                   MOVEL     NwRpScFilFmt  CrRpScFilFmt
      *
     C                   END
      *
     C     EVAL@M        TAG
      *
      ***  If errors returned
      *
     C     Idx           IFNE      0
     C     WIdx          ORNE      0
     C                   GOTO      EVAL@B
     C                   END
      *
      ***  Continue
      *
      ***  If action code is delete, enquire or authorize
      ***  or action code is amend and loan number has changed
      ***  or action code is amend and sequence number has changed
      ***  Reopen the main screen
      *
     C     DDLNRF        IFEQ      @PLNRF
     C     DDACTN        ANDEQ     @PACTN
     C     DDSEQN        ANDEQ     @PSEQN
     C     DDVDAT        ANDEQ     @PVDAT
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'X'
     C                   MOVEL     'S'           @SCRN
     C                   END
     C                   END
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
     C                   CALLB     'LERPSC2VL'
      *
      ***  Response mode (1A), from source system common header
     C                   PARM                    RespMode
      *
      ***  Valid Repayment schedule
     C                   PARM                    NwRpScFilFmt
      *
      ***  Payment instructions
     C                   PARM                    ##PAYF
      *
      ***  Receive instructions
     C                   PARM                    ##RECF
      *
      ***  Field OK flags (DS)
     C                   PARM                    ErrorRpSc
      *
      ***  Warning fields/message IDs/message data (arrays)
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index
     C                   PARM                    WIdx
      *
     C     WIdx          IFNE      *ZERO
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
     C                   EXSR      EXIT@S
     C                   ENDIF
      *
      *----------------------------------------------------------------
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - Roll backwards & forwards through Repayment schedule
      *         file
      *****************************************************************
     C     ROLL          BEGSR
      *
      ***  Default action code to enquiry if not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'R'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'E'           DDACTN
     C                   END
      *
      ***  Read next or previous record on Repayment schedule file
      ***  according to command key taken (CK/7 OR CK/8)
      *
     C     @INKG         IFEQ      *ON
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'LERPSCRED'
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
      *
      ***  Action code
     C                   PARM                    DDACTN
      *
      ***  Loan number pointer
     C                   PARM                    DDLNRF
      *
      ***  Sequence no. pointer
     C                   PARM                    DDSEQN
      *
      ***  Value date pointer
     C                   PARM                    DDVDAT
      *
      ***  Front Office ID
     C                   PARM                    DDFRTN           20
      *
      ***  Read forwards
     C                   PARM                    @RDFWD            1
      *
      ***  Read backwards
     C                   PARM                    @RDBCK            1
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @ERRDTA                                      CLE148
      *
      ***  Loan number read
     C                   PARM      *BLANK        @LNRED            6
      *
      ***  Sequence no. read
     C                   PARM      *BLANK        @SQRED            3
      *
      ***  Value date read
     C                   PARM      *BLANK        @VDRED            6
      *
      ***  Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
      ***  If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EROLL
     C                   END
      *
      ***  If Repayment schedule read
      *
     C     @LNRED        IFNE      *BLANKS
     C     @VDRED        ANDNE     *BLANKS
     C     @SQRED        ANDNE     *BLANKS
      *
      ***  Retrieve Repayment schedule details
      *
     C                   MOVEL     @LNRED        DDLNRF
     C                   MOVEL     @VDRED        DDVDAT
     C                   MOVEL     @SQRED        DDSEQN
      *
     C                   EXSR      RTVRPSC
      *
      ***  Set field and function key status on main details screen
      ***  (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      ***  Put the Repayment schedule on the details screen
      *
     C                   EXSR      PUTD@M
      *
      ***  Go to details screen
      *
     C                   MOVEL     'M'           @SCRN
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
     C                   MOVEL     DDACTN        @PACTN
     C                   MOVEL     DDLNRF        @PLNRF
     C                   MOVEL     DDSEQN        @PSEQN
     C                   MOVEL     DDVDAT        @PVDAT
      *
      ***  Reset read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ***  Build browse subfile
      *
     C                   CALLB     'LERPSCBRW'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Action code
     C                   PARM                    @PACTN            1
      *
      ***  Loan number
     C                   PARM                    @PLNRF            6
      *
      ***  Sequence no.
     C                   PARM                    @PSEQN            3
      *
      ***  Value date
     C                   PARM                    @PVDAT            6
      *
      ***  Build subfile
     C                   PARM      'Y'           @BDSFL            1
      *
      ***  Read subfile record
     C                   PARM      *BLANK        @RDSFL            1
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @ERRDTA                                      CLE148
      *
      ***  Option selected
     C                   PARM      *BLANK        @OPSEL            1
      *
      ***  Loan number selected
     C                   PARM      *BLANKS       @LNSEL            6
      *
      ***  Sequence no. selected
     C                   PARM      *BLANKS       @SQSEL            3
      *
      ***  Value date selected
     C                   PARM      *BLANKS       @VDSEL            6
      *
      ***  Command keys
     C                   PARM      *OFF          @INKC             1
     C                   PARM      *OFF          @INKL             1
      *
      ***  If CK/3 taken in browse, end program
      *
     C     @INKC         IFEQ      *ON
     C                   EXSR      ENDP
     C                   GOTO      EBLDBR
     C                   END
      *
      ***  If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLDBR
     C                   END
      *
      ***  If CK/12 not taken in browse
      ***  Read next browse subfile record
      *
     C     @INKL         IFNE      *ON
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
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
     C                   MOVEL     DDSEQN        @PSEQN
     C                   MOVEL     DDVDAT        @PVDAT
      *
      ***  Read next subfile record
      *
     C                   CALLB     'LERPSCBRW'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Action code
     C                   PARM                    @PACTN            1
      *
      ***  Loan number pointer
     C                   PARM                    @PLNRF            6
      *
      ***  Sequence no. pointer
     C                   PARM                    @PSEQN            3
      *
      ***  Value date pointer
     C                   PARM                    @PVDAT            6
      *
      ***  Build subfile
     C                   PARM      *BLANK        @BDSFL            1
      *
      ***  Read subfile record
     C                   PARM      'Y'           @RDSFL            1
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @ERRDTA                                      CLE148
      *
      ***  Option selected
     C                   PARM      *BLANK        @OPSEL            1
      *
      ***  Loan number selected
     C                   PARM      *BLANK        @LNSEL            6
      *
      ***  Sequence no. selected
     C                   PARM      *BLANKS       @SQSEL            3
      *
      ***  Value date selected
     C                   PARM      *BLANKS       @VDSEL            6
      *
      ***  Command keys
     C                   PARM      *OFF          @INKC             1
     C                   PARM      *OFF          @INKL             1
      *
      ***  If Repayment schedule read from subfile
      *
     C     @LNSEL        IFNE      *BLANKS
     C     @VDSEL        ANDNE     *BLANKS
     C     @SQSEL        ANDNE     *BLANKS
     C     @OPSEL        ANDNE     *BLANKS
      *
      ***  Retrieve Repayment schedule details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @LNSEL        DDLNRF
     C                   MOVEL     @VDSEL        DDVDAT
     C                   MOVEL     @SQSEL        DDSEQN
     C                   EXSR      RTVRPSC
      *
      ***  Check if not error
      *
     C     DDLNRFOK      IFNE      'Y'
     C     DDACTNOK      ORNE      'Y'
     C     DDVDATOK      ORNE      'Y'
     C     DDSEQNOK      ORNE      'Y'
     C     DDACTN        IFNE      'X'
     C                   MOVEL     'E'           @OPSEL
     C                   MOVEL     'E'           DDACTN
     C                   ELSE
     C                   MOVEL     'Y'           WERRTV
     C                   ENDIF
     C                   ELSE
      *
      ***  Set field and function key status
      ***  (according to action code)
      *
     C                   MOVEL     'N'           WERRTV
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      ***  Put the Repayment schedule on the details screen
      *
     C                   EXSR      PUTD@M
     C                   ENDIF
      *
      ***  Else, reset read next browse subfile record
      *
     C                   ELSE
     C                   MOVEL     *BLANK        @RDNB
     C                   ENDIF
      *
      ***  Go to on details screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVRPSC- Retrieve Repayment schedule                          *
      *****************************************************************
     C     RTVRPSC       BEGSR
      *
      ***  Retrieve Repayment schedule if not the same
      *
     C     S@LNRF        IFNE      DDLNRF
     C     S@ACTN        ORNE      DDVDAT
     C     S@SEQN        ORNE      DDSEQN
     C     S@VDAT        ORNE      DDVDAT
     C     WERRTV        ORNE      'N'
      *
     C                   MOVEL     DDACTN        S@ACTN            1
     C                   MOVEL     DDLNRF        S@LNRF            6
     C                   MOVEL     DDSEQN        S@SEQN            3
     C                   MOVEL     DDVDAT        S@VDAT            6
      *
     C                   CALLB     'LERPSCRTV'
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
      *
      ***  Response mode SECURITY CKECKING
     C                   PARM      'S'           @@RSMD            1
      *
      ***  Action Code
     C                   PARM                    DDACTN
      *
      ***  Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      ***  (Midas) Loan Number
     C                   PARM                    DDLNRF
      *
      ***  (Midas) Sequence no.
     C                   PARM                    DDSEQN
      *
      ***  (Midas) Value date
     C                   PARM                    DDVDAT
      *
      ***  Outputs
      *
      ***  (Current) Repayment schedule in file format
     C                   PARM                    CrRpScFilFmt
      *
      ***  OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      ***  OK - Loan Number
     C                   PARM      *BLANK        DDLNRFOK
      *
      ***  OK - Sequence no.
     C                   PARM      *BLANK        DDSEQNOK
      *
      ***  OK - Value Date
     C                   PARM      *BLANK        DDVDATOK
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
      *
     C                   PARM      *ZERO         Idx
     C                   PARM                    PRcvParm                                     TDA070
     C                   PARM                    PPayParm                                    BUG8529
      *
      ***  Save the settlement details for update
      *
     C                   MOVE      LSETP         OSETP
     C                   MOVEL     LOSAC         OOSAC
     C                   MOVEL     LTSEN         OTSEN
     C                   MOVEL     LFACO         OFACO
     C                   MOVEL     LSPI1         OSPI1
     C                   MOVEL     LSPI2         OSPI2
     C                   MOVEL     LSPI3         OSPI3
      *
      ***  Save the last update for test
      *
     C                   Z-ADD     LLCD          WLCD
     C                   MOVE      LCHTP         WCHTP
     C                   Z-ADD     LTNLU         WTNLU
     C                   MOVE      WLSTC         SAVLC
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - Put a Repayment schedule on the details screen       *
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      ***  Call program to fill screen fields with data from LOAMSDK
      *
     C                   CALLB     'LERPSCCVT'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Repayment schedule in file format
     C                   PARM                    CrRpScFilFmt
      *
      ***  Outputs
      *
      ***  Repayment schedule in screen format
     C                   PARM                    NwRpScScnFmt
      *
      ***  Update 'Current' Repayment schedule with
      ***  Repayment schedule in Screen Format
      *
     C                   MOVEL     NwRpScScnFmt  CrRpScScnFmt
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
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
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
     C                   MOVEL     'Y'           @EINKG
      *
      ***  KH = Command key 08 = Next
      *
     C                   MOVEL     'Y'           @EINKH
     C                   END
      *
      ***  KJ = Command Key 10 = Delete
      *
     C     DDACTN        IFEQ      'R'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      ***  KK = Command Key 11 = Authorize
      *
     C     DDACTN        IFEQ      'X'
     C     BPAURV        ANDEQ     'Y'
     C                   MOVEL     'Y'           @EINKK
     C                   ELSE
     C                   MOVEL     'N'           @EINKK
     C                   END
      *
      ***  KN = Command key 14 = Settlement details
      ***  (Action codes I, A, X display settlement details automatically)
      ***  (No futher screens are available from action code D)
      *
     C     DDACTN        IFEQ      'E'
     C                   MOVEL     'Y'           @EINKN
     C                   ELSE
     C                   MOVEL     'N'           @EINKN
     C                   END
      *
      ***  KP = Command key 15 = Browse
      *
     C                   MOVEL     'Y'           @EINKP
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
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
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
      *
     C     @SCRN         IFEQ      'M'
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   END
      *
     C     DDACTN        IFNE      'E'
     C     DDACTN        ANDNE     'A'
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'N'           @EINKK
     C                   MOVEL     'N'           @EINKN
     C                   MOVEL     'Y'           @EINKP
     C                   END
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
     C************       MOVEL     *BLANK        @RDNB
      *
      ***  If input fields are enabled
      ***  Blank the first details screen
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C     @SCRN         IFEQ      'M'
     C                   MOVEL     *BLANK        NwRpScScnFmt
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
     C     @RDNB         IFEQ      'Y'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     *BLANKS
     C                   MOVEL     'R'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - Send a message to details screen                     *
      *****************************************************************
     C     SNDM@M        BEGSR
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
     C                   END                                                                  CLE148
      *
      ***  Sequence number on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'LES0609'
     C                   MOVE      'N'           DDSEQNOK
     C                   END
      *
      ***  Value date on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'LES0610'
     C                   MOVE      'N'           DDVDATOK
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
      *
      ***  If first time for action code, loan number, currency or customer
      *
     C     DDACTN        IFNE      ##ACTN
     C     DDLNRF        ORNE      ##LNRF
     C     DDVDAT        ORNE      ##VDAT
     C     DDSEQN        ORNE      ##SEQN
      *
     C                   MOVEL     DDVDAT        ##VDAT            6
     C                   MOVEL     DDSEQN        ##SEQN            3
      *
      ***  Determine parameters for settlement details input
      *
     C                   EXSR      DETP@S
     C                   END
      *
      ***  Determinate proctect fields in settlement instructions
      *
     C                   MOVEL     'N'           ##PPAY
     C                   MOVEL     'N'           ##PREC
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'R'
     C                   MOVEL     'Y'           ##PPAY
     C                   MOVEL     'Y'           ##PREC
     C                   ELSE
     C     PTypFilCLOAN  IFEQ      '66'
     C     CLE005        OREQ      'Y'
     C     PTypFilCLOAN  ANDEQ     '69'
     C     CLE005        OREQ      'Y'
     C     PTypFilCLOAN  ANDEQ     '72'
     C                   MOVEL     'Y'           ##PREC
     C                   MOVEL     'N'           ##PPAY
     C                   ELSE
     C                   MOVEL     'N'           ##PREC
     C                   MOVEL     'Y'           ##PPAY
     C                   ENDIF
     C                   ENDIF
      *
      ***  Settlement instructions input
      *
     C                   CALLB     'ZASETINSIN'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        ##RTCD           10
      *
      ***  Action code
      *
     C                   PARM      DDACTN        ##ACTN            1
      *
      ***  Loan number
      *
     C                   PARM      DDLNRF        ##LNRF            6
      *
      ***  Protect Payment
      *
     C                   PARM                    ##PPAY            1
      *
      ***  Protect Receive
      *
     C                   PARM                    ##PREC            1
      *
      ***  Calling program
      *
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
      *
     C                   PARM      DDCURR        ##PCCY            3
      *
      ***  Receive currency
      *
     C                   PARM      DDCURR        ##RCCY            3
      *
      ***  Customer shortname
      *
     C                   PARM      DDCUST        ##CSNM           10
      *
      ***  Transaction Type
      *
     C                   PARM      PTypFilCLOAN  ##TTYP            2
      *
      ***  Federal Funds Ind.
      *
     C                   PARM      *BLANK        ##FFND            1
      *
      ***  Booking branch
      *
     C**********         PARM      RPBRCA        ##BRCA            3                         BUG4960
     C                   PARM      BrcaFilCLOAN  ##BRCA            3                         BUG4960
      *
      ***  Receipt Date
      *
     C                   PARM      RPVDAT        ##DATR            5 0
      *
      ***  Payment Date
      *
     C                   PARM      RPVDAT        ##DATP            5 0
      *
      ***  Payment instructions
      *
     C                   PARM                    ##PAYS
      *
      ***  Receive instructions
      *
     C**********         PARM                    ##RECS                                       TDA070
     C                   PARM      PRcvParm      ##RECS                                       TDA070
      *
      ***  FRA/IRS instructions
      *
     C                   PARM                    ##FRIS
      *
      ***  Outputs
      *
      ***  Payment instructions
      *
     C                   PARM                    ##PAYF
      *
      ***  Receive instructions
      *
     C                   PARM                    ##RECF
      *
      ***  FRA/IRS instructions
      *
     C                   PARM                    ##FRIF
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
     C     PTypFilCLOAN  IFEQ      '66'
     C     CLE005        OREQ      'Y'
     C     PTypFilCLOAN  ANDEQ     '69'
     C     CLE005        OREQ      'Y'
     C     PTypFilCLOAN  ANDEQ     '72'
     C                   MOVEL     FLPSTM        WSETP             2
     C**********         MOVEL     FLPONS        WOSAC            12                          CGL029
     C                   MOVEL     FLPONS        WOSAC                                        CGL029
     C                   MOVEL     FLPOBR        WOBBR             3
     C                   MOVEL     FLPOBR        WOSBR             3
     C                   MOVEL     FLPIBN        WTSEN            10
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVE      FLPSCY        WSCCY             3
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL     FLRSTM        WSETP             2
     C**********         MOVEL     FLRONS        WOSAC            12                          CGL029
     C                   MOVEL     FLRONS        WOSAC                                        CGL029
     C                   MOVEL     FLROBR        WOBBR             3
     C                   MOVEL     FLROBR        WOSBR             3
     C                   MOVEL     FLRIBN        WTSEN            10
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVE      FLRSCY        WSCCY             3
     C                   ENDIF
      *
     C                   END
      *
     C                   MOVEL     FLBENN        WFACO            10
     C                   MOVE      WSETP         WTYPE             2
      *
      *
      ***  Update Repayment schedule in file format
      *
     C**********         MOVEL     ##PAYF        RSPAY                                        CGL029
     C**********         MOVEL     ##RECF        RSREC                                        CGL029
     C                   MOVEL     FLREC         RSREC                                        CGL029
     C                   MOVEL     FLRONS        RSRECEx                                      CGL029
     C                   MOVEL     FLRSTM        RPRSTM                                       CGL029
     C                   MOVEL     FLPAY         RSPAY                                        CGL029
     C                   MOVEL     FLPONS        RSPAYEx                                      CGL029
     C                   MOVEL     FLPSTM        RPPSTM                                       CGL029
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        RPREXR                                       CLE031
     C                   Z-ADD     FLPEXR        RPPEXR                                       CLE031
     C                   MOVE      FLREXI        RPREXI                                       CLE031
     C                   MOVE      FLPEXI        RPPEXI                                       CLE031
     C                   MOVE      FLRSCY        RPSCCY                                       CLE031
     C                   MOVE      FLPSCY        RPPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVEL     NwRpScFilFmt  CrRpScFilFmt
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     *ON           ENDP
      *
      ***  CK/12 - Cancel on settlement details
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
      ***  Set up payment instructions from Repayment schedule
      ***  (on insertions, these fields will be zero/blank)
      *
     C                   MOVEL     RSPAY         FLPAY
     C                   MOVEL     RSPAYEx       FLPONS                                       CGL029
     C                   MOVEL     RPPSTM        FLPSTM                                       CGL029
     C                   MOVEL     RPCVMR        FLCVMR
     C                   MOVEL     RPSCCY        FLPSCY
     C                   MOVEL     RPICCY        FLIC72
      *
      ***  Set up receive instructions from Repayment schedule
      ***  (on insertions, these fields will be zero/blank)
      *
     C                   MOVEL     RSREC         FLREC
     C                   MOVEL     RSRECEx       FLRONS                                       CGL029
     C                   MOVEL     RPRSTM        FLRSTM                                       CGL029
     C                   MOVEL     RPSCCY        FLRSCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     RPREXR        FLREXR                                       CLE031
     C                   Z-ADD     RPPEXR        FLPEXR                                       CLE031
     C                   MOVE      RPREXI        FLREXI                                       CLE031
     C                   MOVE      RPPEXI        FLPEXI                                       CLE031
     C                   MOVE      RPSCCY        FLRSCY                                       CLE031
     C                   MOVE      RPPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C     RPPTYP        IFEQ      66
     C     CLE005        OREQ      'Y'
     C     RPPTYP        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     RPPTYP        ANDEQ     72
     C                   MOVE      RPOSBR        FLPOBR
     C                   MOVE      *BLANKS       FLROBR
     C                   ELSE
     C                   MOVE      RPOSBR        FLROBR
     C                   MOVE      *BLANKS       FLPOBR
     C                   END
      *
      ***  If settlement instructions are not defined,
      ***  and payment/receipt dates are ,no in the past, default them
      *
     C     FLPSTM        IFEQ      *ZERO
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        ANDEQ     *ZERO
     C     ##PREC        ANDNE     'Y'
     C     DDACTN        ANDNE     'E'
      *
     C                   CALLB     'ZASETINDFT'
      *
      ***  Inputs
      *
      ***  Calling program
      *
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
      *
     C                   PARM      DDCURR        ##PCCY            3
      *
      ***  Receive currency
      *
     C                   PARM      DDCURR        ##RCCY            3
      *
      ***  Customer shortname
      *
     C                   PARM      DDCUST        ##CSNM           10
      *
      ***  Loan Type
      *
     C                   PARM      PTypFilCLOAN  ##TTYP            2
      *
      ***  Federal Funds Ind.
      *
     C                   PARM      *BLANK        ##FFND            1
      *
      ***  Version of ISDA Rules govern
      *
     C                   PARM                    BQISDA            4
      *
      ***  Type of ISDA agreement
      *
     C                   PARM                    BQAGTY            6
      *
      ***  Date of ISDA Agreement
      *
     C                   PARM                    BQAGDT            6
      *
      ***  Version of ISDA Agreement
      *
     C                   PARM                    BQAGVV            2
      *
      ***  Version of ISDA Agreement century
      *
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ***  OUTPUTS
      *
      ***  Payment instructions
      *
     C                   PARM                    ##PAYF
      *
      ***  Receive instructions
      *
     C                   PARM                    ##RECF
      *
      ***  FRA/IRS instructions
      *
     C                   PARM                    ##FRIF
      *
     C                   END
      *
      ***  Convert settlement details from file to screen format
      *
     C                   CALLB     'ZASETINCVT'
      *
      ***  Inputs
      *
      ***  File Payment Settlement Instruction
      *
     C                   PARM                    ##PAYF
      *
      ***  File Receipt Settlement Instruction
      *
     C                   PARM                    ##RECF
      *
      ***  File FRA/IRS Settlement Instruction
      *
     C                   PARM      *BLANK        ##FRIF
      *
      ***  Outputs
      ***  Screen Payment Settlement Instruction
      *
     C                   PARM      *BLANK        ##PAYS
      *
      ***  Screen Receipt Settlement Instruction
      *
     C                   PARM      *BLANK        ##RECS
      *
      ***  Screen FRA/IRS Settlement Instruction
      *
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - Cancel on settlement details screen                  *
      *****************************************************************
     C     CANC@S        BEGSR
      /COPY WNCPYSRC,LERPSCS009
      *
      ***  Return to the details screen
      *
     C                   MOVEL     'M'           @SCRN
      /COPY WNCPYSRC,LERPSCS010
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
     C     DDACTN        OREQ      'X'
      *
      ***  Return to details screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
      *
      ***  Continue
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'C'           @SCRN
     C                   ELSE
     C                   MOVEL     'U'           @SCRN
     C                   END
      *
      ***  Update valid Repayment schedule: payment settlement instructions
      *
     C                   MOVEL     FLPAY         RSPAY
     C                   MOVEL     FLPONS        RSPAYEx                                      CGL029
     C                   MOVEL     FLPSTM        RPPSTM                                       CGL029
     C                   MOVEL     FLPOBR        RPOSBR
     C                   MOVEL     FLCVMR        RPCVMR
      *
      ***  Update valid Repayment schedule: receipt settlement instructions
      *
     C                   MOVEL     FLREC         RSREC
     C                   MOVEL     FLRONS        RSRECEx                                      CGL029
     C                   MOVEL     FLRSTM        RPRSTM                                       CGL029
     C                   MOVEL     FLROBR        RPROBR
      *
      ***  Update valid Repayment schedule: settlement currency & 'IN' ccy in field 72
      *
     C                   MOVEL     FLPSCY        RPSCCY
     C                   MOVEL     FLIC72        RPICCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        RPREXR                                       CLE031
     C                   Z-ADD     FLPEXR        RPPEXR                                       CLE031
     C                   MOVE      FLREXI        RPREXI                                       CLE031
     C                   MOVE      FLPEXI        RPPEXI                                       CLE031
     C                   MOVE      FLRSCY        RPSCCY                                       CLE031
     C                   MOVE      FLPSCY        RPPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   END
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
     C                   MOVEL     'LES0611'     MsgIdArr(1)
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LERPSCDSP'
      *
      ***  Input parameters
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Repayment schedule (in screen format)
     C                   PARM                    NwRpScScnFmt
      *
      ***  Fields in error
     C                   PARM                    ErrorRpSc
      *
      ***  Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      ***  Enabled function keys
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKK
     C                   PARM      'N'           @EINKN
     C                   PARM      'N'           @EINKP
      *
      ***  Succesful insert
     C                   PARM                    @LSSQ
     C                   PARM                    @LNRF
     C                   PARM                    @VDAT
      *
      ***  Output parameters
      *
      ***  Function keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKG
     C                   PARM      *OFF          @INKH
     C                   PARM      *OFF          @INKJ
     C                   PARM      *OFF          @INKK
     C                   PARM      *OFF          @INKL
     C                   PARM      *OFF          @INKN
     C                   PARM      *OFF          @INKP
     C                   PARM      'N'           WriteOnly
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       ErrorRpSc
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     *ON           ENDP
      *
      ***  CK/12 - Cancel on confirmation screen
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
     C                   EXSR      IFDS@M
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
      ***  Update valid Repayment schedule: Last action code
      *
     C                   MOVEL     DDACTN        RPCHTP
      *
      ***  Repayment schedule updates
      *
     C                   CALLB     'LERPSCUPD'
      *
      ***  Return code
     C                   PARM      *BLANKS       @RTCD
      *
      ***  New Repayment schedule in file format
     C                   PARM                    NwRpScFilFmt
      *
      ***  Old settlement details
     C                   PARM                    OldStsDS
      *
      ***  New settlement details
     C                   PARM                    NewStsDS
      *
      ***  Pass data
     C                   PARM                    PasDtaDS
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    ErrorRpSc
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Reset the checking key fileds
      *
     C                   MOVEL     *BLANKS       S@LNRF
     C                   MOVEL     *BLANKS       S@VDAT
     C                   MOVEL     *BLANKS       S@SEQN
      *
      ***  If there were any errors in the update functions ROLLBACK any
      ***  updates and end this program. Otherwise, COMMIT the updates
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*RECUPD'
      *   ROLLBACK data if either of the following is true:                                   CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
      *   COMMIT data if either of the following is true:                                     CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C     RPCHTP        IFEQ      'I'
     C                   MOVEL     RPLASN        @LSSQ
     C                   MOVEL     RPLNRF        @LNRF
      *
     C                   MOVE      RPVDAT        ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
     C                   MOVE      ZDateFmt6     @VDAT
     C                   END
      *
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
     C                   MOVEL     *BLANKS       NwRpScScnFmt
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
      * ENDP - End program                                            *
      *****************************************************************
     C     ENDP          BEGSR
      *
     C                   MOVEL     'T'           @SCRN
      /COPY WNCPYSRC,LERPSCS011
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize SAR work flag and Commit flag                                             CSC022
     C                   Eval      CSC022      = 'N'                                          CSC022
     C                   Eval      WSkipCommit = ' '                                          CSC022
      *                                                                                       CSC022
      ** Determine if Commitment Control Changes for MidasPlus                                CSC022
      ** (CSC022) is installed                                                                CSC022
      *                                                                                       CSC022
     C                   Call      'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
      *                                                                                       CSC022
      ** If feature is on, set up SAR work flag                                               CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022      = 'Y'                                          CSC022
     C                   Eval      WSkipCommit = 'N'                                          CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        COMITNO  <> 0                                              CSC022
     C                   MoveA     COMITJOBS     WArrCmtJob                                   CSC022
     C                   Eval      WPtr = %LookUp(PSJobName:WArrCmtJob)                       CSC022
     C                   If        WPtr > 0                                                   CSC022
     C                   Eval      WSkipCommit = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** else, database error (return code other than *NRF)                                   CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF   '                                         CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   MoveL     'LERPSCSIN'   DBPGM                                        CSC022
     C                   MoveL     'SCSARDPD'    DBFILE                                       CSC022
     C                   MoveL     'CSC022'      DBKEY                          ************* CSC022
     C                   Z-Add     900           DBASE                          * DBASE 900 * CSC022
     C                   Out       LDA                                          ************* CSC022
     C                   ExSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      ***  Initialize program name
      *
     C                   MOVEL     'LERPSCSIN'   DBPGM
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
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Determine if Customer Lending Enhancements
      ***  feature is installed
      *
     C                   MOVEL     'N'           CLE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CLE002'      @SARD             6
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
      *
      ***  Access Customer Lending ICD via access program
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
     C                   MOVE      'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   END
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
     C                   EVAL      DBASE = 1                                                  CLE148
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
      ***  Initialize field and function key status on details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
      /COPY WNCPYSRC,LERPSCS012
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
**  CPY@
(c) Finastra International Limited 2002
