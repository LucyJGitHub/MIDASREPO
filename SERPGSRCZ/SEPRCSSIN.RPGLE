     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Prices Input')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEPRCSSIN - Securities Prices Screen Input                   *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Securities Prices                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL031             Date 05Jul04               *
      *                 BUG2812            Date 01Jun04               *
      *                 222373             Date 22Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 213558             Date 22Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD010             Date 03May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060  *CREATE    Date 03Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation on Savings Income                          *
      *  BUG2812 - Commitment Control Changes for MidasPlus (CSC022)  *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  213558 - Sec Pric Maintenance Time/Date Stamp amendable      *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *                                                               *
      *****************************************************************
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                             BUG2812
     D WCmtJobArr      S             10A   DIM(10)                                           BUG2812
      ** Array for commitment job names                                                      BUG2812
 
     D CrDlFilFmt    E DS                  EXTNAME(PRICED)
      ** Current Deal in File Format
 
     D NwDlFilFmt    E DS                  EXTNAME(SEVPRCSPD)
     D                                     PREFIX(V)
      ** New Deal in File Format
 
     D NwDlScnFmt    E DS                  EXTNAME(SEPRCSPD)
      ** New Deal in Screen Format
 
     D CrExFilFmt    E DS                  EXTNAME(EXVALD)
     D                                     PREFIX(C_)
      ** Current Extel Details in file format
 
     D NwExFilFmt    E DS                  EXTNAME(SEVEXVLPD)
      ** New Extel Details in file format
 
     D ValidPRXT     E DS                  EXTNAME(SEVPRXTPD)
 
     D ExtData       E DS                  EXTNAME(SEPREXPD)
      ** FX Extra Data - File (D/B) format
 
     D SEEPRD        E DS                  EXTNAME(SEEPRCSPD)
      ** Error indicators
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas Modules details accessed via access program
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** Security Trading Detail
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, long data structure
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD010
     D  SCLCD        E                     EXTFLD(LCD)                                        CSD010
      ** Midas Switchable Features Data Structure                                             CSD010
                                                                                              CSD010
     D @CCI@M          DS
      ** Current Control Indicators for Main Detail Screen
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKC                 3      3
     D  @EINKG                 4      4
     D  @EINKH                 5      5
     D  @EINKJ                 6      6
     D  @EINKL                 7      7
     D  @EINKP                 8      8
 
     D @PCI@M          DS             8
                                                                                             BUG2812
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                  BUG2812
     D  ComitJob               4    103                                                      BUG2812
      ** Midas SC Jobs handling commitment control data area                                 BUG2812
 
      ** Previous Control Indicators for main detail screen
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Profit Centre Switchable Feature
     D CAC005          S              1A
     D CGL031          S              1A                                                      CGL031
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      * Previous Detail fields
     D @ACTN           S                   LIKE(DDACTN )
     D @PSSN           S                   LIKE(DDPSSN )
     D @PCNM           S                   LIKE(DDPCNM )
     D @PMKT           S                   LIKE(DDPMKT )
     D @PBRA           S                   LIKE(DDPBRA )
     D @PBOK           S                   LIKE(DDPBOK )
     D @PRFC           S                   LIKE(DDPRFC )
     D @PPRT           S                   LIKE(DDPPRT )
     D @PTFR           S                   LIKE(DDPTFR )
     D @PACTN          S                   LIKE(DDACTN )
     D @PPSSN          S                   LIKE(DDPSSN )
     D @PPCNM          S                   LIKE(DDPCNM )
     D @PPMKT          S                   LIKE(DDPMKT )
     D @PPBRA          S                   LIKE(DDPBRA )
     D @PPBOK          S                   LIKE(DDPBOK )
     D @PPRFC          S                   LIKE(DDPRFC )
     D @PPPRT          S                   LIKE(DDPPRT )
     D @PPTFR          S                   LIKE(DDPTFR )
 
      * Previous Extel fields
     D @PLPRI          S                   LIKE(DDLPRI )
     D @PUPRI          S                   LIKE(DDUPRI )
     D @PPCEN          S                   LIKE(DDPCEN )
     D @PAPND          S                   LIKE(DDAPND )
     D @PPSRC          S                   LIKE(DDPSRC )
 
      * Re-display Main details screen, in case of amends or inserts
     D REDSPLY         S              1A   INZ('Y')
                                                                                              CGL031
      ** Parameter declarations                                                               CGL031
     D PRtcd           S              7A                                                      CGL031
     D POptn           S              7A                                                      CGL031
                                                                                              CSD010
     D CSD010          S              1A                                                      CSD010
     D HBDPR           S                   LIKE(PRBDPR)                                       CSD010
     D HOFPR           S                   LIKE(PROFPR)                                       CSD010
     D HCLPR           S                   LIKE(PRCLPR)                                       CSD010
     D PRetCode        S              7A                                                      CSD010
     D POption         S              7A                                                      CSD010
     D PSard           S              6A                                                      CSD010
                                                                                              CSD010
     D CSC022          S              1A                                                     BUG2812
                                                                                             BUG2812
     D WCommitSkip     S              1A                                                     BUG2812
      ** Commitment Skip Field                                                               BUG2812
                                                                                             BUG2812
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEPRCSS008
 
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
      *
      /COPY WNCPYSRC,SEPRCSS001
 
      * READ NEXT BROWSE SUBFILE RECORD
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEPRCSS002
 
      * DO WHILE SCREEN: MAIN DETAILS
      *
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   ENDDO
      *
      /COPY WNCPYSRC,SEPRCSS003
 
      * SCREEN: CONFIRMATION OF INPUT
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEPRCSS006
 
      * DO FILE UPDATES
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEPRCSS007
 
      * TERMINATE PROGRAM
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   ENDIF
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SEPRCSS009
 
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      *
      * Update 'previous' key fields & screen control indicator
      *
     C                   MOVEL(P)  DDACTN        @PACTN
     C                   MOVEL(P)  DDPSSN        @PPSSN
     C                   MOVEL(P)  DDPCNM        @PPCNM
     C                   MOVEL(P)  DDPMKT        @PPMKT
     C                   MOVEL(P)  DDPBRA        @PPBRA
     C                   MOVEL(P)  DDPBOK        @PPBOK
     C                   MOVEL(P)  DDPRFC        @PPRFC
     C                   MOVEL(P)  DDPPRT        @PPPRT
     C                   MOVEL(P)  DDPTFR        @PPTFR
     C                   MOVEL(P)  @CCI@M        @PCI@M
      *
      * Update 'previous' EXTEL fields
      *
     C                   MOVEL(P)  DDLPRI        @PLPRI
     C                   MOVEL(P)  DDUPRI        @PUPRI
     C                   MOVEL(P)  DDPCEN        @PPCEN
     C                   MOVEL(P)  DDAPND        @PAPND
     C                   MOVEL(P)  DDPSRC        @PPSRC
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'SEPRCSDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * FIELDS IN ERROR
     C                   PARM                    SEEPRD
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKP
                                                                                              CAS006
      ** SWITCHABLE FEATURES:                                                                 CAS006
      ** ====================                                                                 CAS006
                                                                                              CAS006
      ** Profit Centre Switchable Feature                                                     CAS006
                                                                                              CAS006
     C                   PARM                    CAC005                                       CAS006
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
      * DEAL STATUS
     C                   PARM                    DDSTS             8
      * CLEAR SCREEN
     C                   PARM                    CLRSCRN
      * DISPLAY DETAILS
     C                   PARM                    DSPDTL
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       SEEPRD
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      *
      * If Enter is taken from main screen and key fields are blank, show the browse
      *
     C                   IF        DDACTN = *BLANKS AND
     C                             DDPSSN = *BLANKS AND
     C                             DDPCNM = *BLANKS AND
     C                             DDPMKT = *BLANKS AND
     C                             DDPBRA = *BLANKS AND
     C                             DDPBOK = *BLANKS AND
     C                             DDPRFC = *BLANKS AND
     C                             DDPPRT = *BLANKS AND
     C                             DDPTFR = *BLANKS
      *
      * If function key not selected
      *
     C                   IF        @INKC  <> '1'    AND
     C                             @INKG  <> '1'    AND
     C                             @INKH  <> '1'    AND
     C                             @INKL  <> '1'    AND
     C                             @INKP  <> '1'
     C                   EVAL      @INKP = '1'
     C                   ENDIF
 
     C                   ENDIF
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           SRENDP
      *
      * CK/7 - ROLL BACKWARDS
      *
     C     @INKG         CASEQ     '1'           SRROLL
      *
      * CK/8 - ROLL FORWARDS
      *
     C     @INKH         CASEQ     '1'           SRROLL
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     @INKL         CASEQ     '1'           SRCANC
      *
      * CK/15 - BUILD BROWSE
      *
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     SRVALM
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVALM - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SRVALM        BEGSR
      *
      * Retrieve deal details
      *
     C                   EXSR      SRRTV
 
     C                   IF        DDACTNOK = 'Y' AND
     C                             DDSSNOK  = 'Y' AND
     C                             DDPCNMOK = 'Y' AND
     C                             DDPMKTOK = 'Y' AND
     C                             DDPBRAOK = 'Y' AND
     C                             DDPBOKOK = 'Y' AND
     C                             DDPRFCOK = 'Y' AND
     C                             DDPRTOK  = 'Y' AND
     C                             DDPTFROK = 'Y'
     C                   IF        DDLPRI  = *BLANKS AND
     C                             DDUPRI  = *BLANKS AND
     C                             DDPCEN  = *BLANKS AND
     C                             DDAPND  = *BLANKS AND
     C                             DDPSRC  = *BLANKS
 
      * Default Extel details
     C                   EXSR      SRDFT
 
     C                   ENDIF
     C                   ENDIF
      *
      * If any of key fields are not OK
      * Re-output screen with error messages on it
      *
     C                   IF        DDACTNOK = 'N' OR
     C                             DDSSNOK  = 'N' OR
     C                             DDPCNMOK = 'N' OR
     C                             DDPMKTOK = 'N' OR
     C                             DDPBRAOK = 'N' OR
     C                             DDPBOKOK = 'N' OR
     C                             DDPRFCOK = 'N' OR
     C                             DDPRTOK  = 'N' OR
     C                             DDPTFROK = 'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * If action code is delete, enquire or amend
      * and key fields have changed
      * Put the deal on the main details screen
      *
     C                   IF          DDACTN    =     'D'  OR
     C                               DDACTN    =     'E'  OR
     C                               DDACTN    =     'A'
     C                   IF          DDPSSN    <>    @PPSSN  OR
     C                               DDACTN    <>    @PACTN  OR
     C                               DDPCNM    <>    @PPCNM  OR
     C                               DDPMKT    <>    @PPMKT  OR
     C                               DDPBRA    <>    @PPBRA  OR
     C                               DDPBOK    <>    @PPBOK  OR
     C                               DDPRFC    <>    @PPRFC  OR
     C                               DDPPRT    <>    @PPPRT  OR
     C                               DDPTFR    <>    @PPTFR  OR
     C                               @CCI@M    <>    @PCI@M
     C                   EXSR      SRCVT
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF          DDACTN    =     'I'  OR
     C                               DDACTN    =     'A'
     C                   IF          DDPSSN    <>    @PPSSN  OR
     C                               DDACTN    <>    @PACTN  OR
     C                               DDPCNM    <>    @PPCNM  OR
     C                               DDPMKT    <>    @PPMKT  OR
     C                               DDPBRA    <>    @PPBRA  OR
     C                               DDPBOK    <>    @PPBOK  OR
     C                               DDPRFC    <>    @PPRFC  OR
     C                               DDPPRT    <>    @PPPRT  OR
     C                               DDPTFR    <>    @PPTFR  OR
     C                               @CCI@M    <>    @PCI@M
     C                   EVAL      REDSPLY = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * Update Deal in File Format
      *
     C                   EXSR      SRMVVL
     C                   MOVEL     CrExFilFmt    NwExFilFmt
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * Update Deal in File Format
      *
     C                   EXSR      SRMVVL
     C                   MOVEL     CrExFilFmt    NwExFilFmt
      *
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ENDIF
      *
     C                   GOTO      EVAL@M
     C                   ENDIF
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Deal in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       SEEPRD
     C                   CLEAR                   NwDlFilFmt
     C                   CLEAR                   NwExFilFmt
      * IF AMEND
 
      * Update Deal in File Format
      *
     C                   EXSR      SRMVVL
     C                   MOVEL     CrExFilFmt    NwExFilFmt
 
     C                   IF        REDSPLY = 'Y'
     C                   EVAL      REDSPLY = 'N'
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      * Validate security details
      *
     C                   IF        DDACTN = 'A'                                               213558
      * blank out timestamp and request id when amending via screen                           213558
      * therefore won't show on tolerance report                                              213558
     C                   EVAL      DDDTFR= *BLANKS                                            213558
     C                   EVAL      DDDFTS= *BLANKS                                            213558
     C                   ENDIF                                                                213558
     C                   CALLB     'SEPRCSVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    ExtData
     C                   PARM                    SEEPRD
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwExFilFmt
     C                   PARM                    ValidPRXT
     C                   PARM                    HPPRC
      * CAC005 switchable feature on (Y / N)
     C                   PARM                    CAC005
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
 
      * If errors returned
 
     C                   IF        IDX = 0 AND WIDX = 0
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF
     C                   ENDIF
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      * SRROLL - ROLL BACKWARDS & FORWARDS THROUGH DEALS FILE
      *****************************************************************
     C     SRROLL        BEGSR
      *
      * Default action code to enquiry if not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C                   MOVE      'E'           DDACTN
     C                   ENDIF
      *
      * READ NEXT OR PREVIOUS RECORD ON DEALS FILE
      * ACCORDING TO COMMAND KEY TAKEN (CK/7 OR CK/8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   ENDIF
      *
     C                   CALLB     'SEPRCSRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      * Key fields
     C                   PARM                    DDPSSN           10
     C                   PARM                    DDPCNM           10
     C                   PARM                    DDPMKT            1
     C                   PARM                    DDPBRA            3
     C                   PARM                    DDPBOK            2
     C                   PARM                    DDPRFC            4
     C                   PARM                    DDPPRT            2
     C                   PARM                    DDPTFR            4
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      * ICD
     C                   PARM                    CAC005
     C                   PARM                    BGN4ST
     C                   PARM                    FCR997
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Security Read - Key fields
     C                   PARM                    @PSSN
     C                   PARM                    @PCNM
     C                   PARM                    @PMKT
     C                   PARM                    @PBRA
     C                   PARM                    @PBOK
     C                   PARM                    @PRFC
     C                   PARM                    @PPRT
     C                   PARM                    @PTFR
      *
      * If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EROLL
     C                   ENDIF
      *
      * If deal read
      *
     C     @PSSN         IFNE      *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @PSSN         DDPSSN
     C                   MOVEL     @PCNM         DDPCNM
     C                   MOVEL     @PMKT         DDPMKT
     C                   MOVEL     @PBRA         DDPBRA
     C                   MOVEL     @PBOK         DDPBOK
     C                   MOVEL     @PRFC         DDPRFC
     C                   MOVEL     @PPRT         DDPPRT
     C                   MOVEL     @PTFR         DDPTFR
     C                   EXSR      SRRTV
 
      * Default Extel details
 
     C                   EXSR      SRDFT
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the deal on the main details screen
      *
     C                   EXSR      SRCVT
     C                   ENDIF
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'SEPRCSBRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
     C                   PARM                    DDPSSN           10
     C                   PARM                    DDPCNM           10
     C                   PARM                    DDPMKT            1
     C                   PARM                    DDPBRA            3
     C                   PARM                    DDPBOK            2
     C                   PARM                    DDPRFC            4
     C                   PARM                    DDPPRT            2
     C                   PARM                    DDPTFR            4
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
     C                   PARM                    FCR997            4
      *
      * OUTPUT PARAMETERS
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKI             1
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL
     C                   PARM      *BLANK        @PSSN
     C                   PARM      *BLANK        @PCNM
     C                   PARM      *BLANK        @PMKT
     C                   PARM      *BLANK        @PBRA
     C                   PARM      *BLANK        @PBOK
     C                   PARM      *BLANK        @PRFC
     C                   PARM      *BLANK        @PPRT
     C                   PARM      *BLANK        @PTFR
      *
      * If CK/3 taken in browse, end program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      SRENDP
     C                   GOTO      EBLDBR
     C                   END
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLDBR
     C                   END
      *
      * If CK/12 not taken in browse
      * Read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   GOTO      EBLDBR
     C                   END
      *
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'SEPRCSBRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN
     C                   PARM                    DDPSSN
     C                   PARM                    DDPCNM
     C                   PARM                    DDPMKT
     C                   PARM                    DDPBRA
     C                   PARM                    DDPBOK
     C                   PARM                    DDPRFC
     C                   PARM                    DDPPRT
     C                   PARM                    DDPTFR
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *
      * ICD
     C                   PARM                    FCR997
      *
      * OUTPUT PARAMETERS
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKI
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @PSSN
     C                   PARM      *BLANK        @PCNM
     C                   PARM      *BLANK        @PMKT
     C                   PARM      *BLANK        @PBRA
     C                   PARM      *BLANK        @PBOK
     C                   PARM      *BLANK        @PRFC
     C                   PARM      *BLANK        @PPRT
     C                   PARM      *BLANK        @PTFR
      *
      * IF DEAL READ FROM SUBFILE
      *
     C     @PSSN         IFNE      *BLANK
      *
      * Retrieve deal details
     C                   MOVEL     @PSSN         DDPSSN
     C                   MOVEL     @PCNM         DDPCNM
     C                   MOVEL     @PMKT         DDPMKT
     C                   MOVEL     @PBRA         DDPBRA
     C                   MOVEL     @PBOK         DDPBOK
     C                   MOVEL     @PRFC         DDPRFC
     C                   MOVEL     @PPRT         DDPPRT
     C                   MOVEL     @PTFR         DDPTFR
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     'N'           REDSPLY
 
     C                   EXSR      SRRTV
 
      * Default Extel details
 
     C                   EXSR      SRDFT
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the deal on the main details screen
      *
     C                   EXSR      SRCVT
      *
      * ELSE, RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   ELSE
     C                   MOVEL     *BLANK        @RDNB
     C                   ENDIF
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDFT   - DEFAULTING FOR EXTEL DETAILS
      *****************************************************************
     C     SRDFT         BEGSR
 
     C                   CALLB     'SEPRCSDFT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Security Shortname
     C                   PARM                    DDPSSN           10
      ** Price Type
     C                   PARM                    DDPPRT            2
 
      * Account in file format
     C                   PARM                    CrDlFilFmt
      * ICD
     C                   PARM                    BVEXOP
 
      * OUTPUTS
      * Screen Output
      *
      ** Price Source
     C                   PARM      *BLANKS       DDPSRC            1
      ** Auto-Price Indicator
     C                   PARM      *BLANKS       DDAPND            1
      ** Lower Price Boundary
     C                   PARM      *BLANKS       DDLPRI           16
      ** Upper Price Boundary
     C                   PARM      *BLANKS       DDUPRI           16
      ** Percentage
     C                   PARM      *BLANKS       DDPCEN           10
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    IDX
      ** Security shortname OK flag
     C                   PARM      *BLANK        DDSSNOK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRTV  - RETRIEVE SECURITY
      *****************************************************************
     C     SRRTV         BEGSR
      *
      * RETRIEVE SECURITY
      *
     C                   CALLB     'SEPRCSRTV'
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
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Security
     C                   PARM                    DDPSSN           10
      *
      * Customer Shortname
     C                   PARM                    DDPCNM           10
      *
      * Market
     C                   PARM                    DDPMKT            1
      *
      * Branch
     C                   PARM                    DDPBRA            3
      *
      * Book
     C                   PARM                    DDPBOK            2
      *
      * Profit Centre
     C                   PARM                    DDPRFC            4
      *
      * Price Type
     C                   PARM                    DDPPRT            2
      *
      * Portfolio Reference
     C                   PARM                    DDPTFR            4
      * ICD
      * Extel Indicator
     C                   PARM                    BVEXOP
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    CrDlFilFmt
      * If CAC005 is on, this is the book code the user entered on the screen (file format)
     C                   PARM                    PBCD              2
      * If CAC005 is on, this is the pseudo book ( the book stored on file on PRICED )
      * If CAC005 is off, this is the book the user entered on the screen (file format)
     C                   PARM                    PBOK              2
      * profit centre, in file format
     C                   PARM                    PRFC              4
      * Customer number in file format
     C                   PARM                    PCNM
      * Current Price retrieved, depending on price type
     C                   PARM                    DDCURP           16
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      * OK - Security
     C                   PARM      *BLANK        DDSSNOK
      *
      * OK - Customer Shortname
     C                   PARM      *BLANK        DDPCNMOK
      *
      * OK - Market
     C                   PARM      *BLANK        DDPMKTOK
      *
      * OK - Branch
     C                   PARM      *BLANK        DDPBRAOK
      *
      * OK - Book
     C                   PARM      *BLANK        DDPBOKOK
      *
      * OK - Profit Centre
     C                   PARM      *BLANK        DDPRFCOK
      *
      * OK - Price Type
     C                   PARM      *BLANK        DDPRTOK
      *
      * OK - Portfolio Reference
     C                   PARM      *BLANK        DDPTFROK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C                   PARM      *ZERO         WIdx
     C                   PARM      FCR997        @CR997            4
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCVT  - PUT A DEAL ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     SRCVT         BEGSR
      *
      * Call program to fill screen fields with data from FXDEALPP
      *
     C                   CALLB     'SEPRCSCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    DDSTS
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deal in file format
     C                   PARM                    CrDlFilFmt
      * If CAC005 is on, this is the pseudo book ( the book stored on file on PRICED )
      * If CAC005 is off, this is the book the user entered on the screen (file format)
     C                   PARM                    PBOK
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * OUTPUTS
      *
      * Deal in screen format
     C                   PARM                    NwDlScnFmt
     C                   PARM                    HPPRC
                                                                                              CSD010
      ** Switchable feature CSD010 parameters                                                 CSD010
     C                   PARM                    HBDPR                                        CSD010
     C                   PARM                    HOFPR                                        CSD010
     C                   PARM                    HCLPR                                        CSD010
     C                   PARM                    CSD010                                       CSD010
 
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      * SRMVVL - MOVE DATABASE FIELDS TO VALID FILE
      *****************************************************************
     C     SRMVVL        BEGSR
 
      * Usually, the move of data from the data base file to the valid file
      * can be done in one step:
      **
      ***   e.g.,      MOVEL     CrDlFilFmt    NwDlFilFmt
      **
      * However, if CAC005 is on, two files are updated: SEPRICPD and PRICED.
      * We need to add profit centre and pseudo book to the latter file.
      * We also need these fields to appear on the Valid Errors file, which is compiled
      * with the same format as the Valid file. These fields need to be moved manually.
      *
     C
     C                   MOVE      RECI          VPRRECI
     C                   MOVEL(P)  PSSN          VPRPSSN
     C                   MOVEL(P)  PPRT          VPRPPRT
     C                   Z-ADD     PVDT          VPRPVDT
     C**********         Z-ADD     PCNM          VPRPCNM                                      CSD027
     C                   EVAL      VPRPCNM = PCNM                                             CSD027
     C                   MOVEL     PMKT          VPRPMKT
     C                   MOVEL     PBRA          VPRPBRA
     C                   MOVEL     PBOK          VPRPBOK
     C                   Z-ADD     PPRC          VPRPPRC
     C                   MOVEL     PNTV          VPRPNTV
     C                   Z-ADD     LCD           VPRLCD
     C                   MOVE      CHTP          VPRCHTP
     C                   Z-ADD     TNLU          VPRTNLU
     C                   MOVE      PSRC          VPRPSRC
     C                   MOVE      PBWN          VPRPBWN
     C                   MOVE      PPWN          VPRPPWN
     C                   MOVEL     PTFR          VPRPTFR
     C                   Z-ADD     NPXR          VPRNPXR
     C                   MOVE      NPMD          VPRNPMD
     C                   MOVE      PRTMST        VPRTMESTMP
     C                   Z-ADD     PRDFTS        VPRDFTS
     C                   MOVEL     PRFRNT        VPRFRNT
     C                   MOVEL     PRAFRT        VPRAFRT
     C                   MOVEL     PRREPA        VPRREPA
     C                   MOVEL     PRDTFR        VPRDTFR
     C                   MOVEL     PRTLEX        VPRTLEX
     C                   MOVEL     PRFC          VPRPRFC
     C                   MOVEL     PBCD          VPRPBCD
     C
     C     ENWDL         ENDSR
      /EJECT
      *****************************************************************
      * SFDS@M - SET FIELD STATUS ON MAIN DETAILS SCREEN
      *          ACCORDING TO ACTION CODE
      *****************************************************************
     C     SFDS@M        BEGSR
      *
      * Enable/disable key & detail fields on main details screen
      * (key fields = action code & deal number; detail fields = rest)
      * (Action code can only be 'I', 'A', 'E', 'D', or 'X')
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
 
     C                   ELSE
 
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   ENDIF
 
     C                   MOVEL     'Y'           DSPDTL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKS@M - SET FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
      *          ACCORDING TO ACTION CODE
      *****************************************************************
     C     SFKS@M        BEGSR
      *
      * Enable/disable function keys on main details screen
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   ENDIF
      *
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@M - INITIALIZE FIELD STATUS ON MAIN DETAILS SCREEN
      *****************************************************************
     C     IFDS@M        BEGSR
      *
      * ENABLE KEY & DETAILS FIELDS ON MAIN DETAILS SCREEN
      *
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   MOVEL     'N'           DSPDTL            1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFKS@M - INITIALIZE FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
      *****************************************************************
     C     IFKS@M        BEGSR
      *
      * ENABLE/DISABLE FUNCTION KEYS ON MAIN DETAILS SCREEN
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'Y'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCANC - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     SRCANC        BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      * If input fields are enabled
      * Blank the main details screen
      *
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
      *
      * If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           DDACTNOK
     C                   END
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   MOVE      *ALL'Y'       SEEPRD
      *
      * Validate deal details
      *
     C                   IF        DDACTN = 'A'                                               213558
      * blank out timestamp and request id when amending via screen                           213558
      * therefore won't show on tolerance report                                              213558
     C                   EVAL      DDDTFR= *BLANKS                                            213558
     C                   EVAL      DDDFTS= *BLANKS                                            213558
     C                   ENDIF                                                                213558
     C                   CALLB     'SEPRCSVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwDlScnFmt
     C                   PARM                    ExtData
     C                   PARM                    SEEPRD
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwExFilFmt
     C                   PARM                    ValidPRXT
     C                   PARM                    HPPRC
      * CAC005 switchable feature on (Y / N)
     C                   PARM                    CAC005
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'SEPRCSDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDlScnFmt
      *
      * FIELDS IN ERROR
     C                   PARM                    SEEPRD
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C**********         PARM      'N'           @EINKC                                       222373
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C**********         PARM      'N'           @EINKL                                       222373
     C                   PARM      'N'           @EINKP
                                                                                              CAS006
      ** SWITCHABLE FEATURES:                                                                 CAS006
      ** ====================                                                                 CAS006
                                                                                              CAS006
      ** Profit Centre Switchable Feature                                                     CAS006
                                                                                              CAS006
     C                   PARM                    CAC005                                       CAS006
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
      * DEAL STATUS
     C                   PARM                    DDSTS
      * Clear Screen
     C                   PARM                    CLRSCRN
      * Display details
     C                   PARM                    DSPDTL
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       SEEPRD
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           SRENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * EXIT CONFIRMATION SCREEN
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@M
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@M
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFKS@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
 
     C                   EVAL      VPRCHTP = DDACTN
 
     C                   CALLB     'SEPRCSUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    NwDlFilFmt
     C                   PARM                    NwExFilFmt
     C                   PARM                    ValidPRXT
     C                   PARM                    CAC005
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
      *                                                                                      BUG2812
     C                   If        (CSC022 <> 'Y')                                           BUG2812
     C                   ROLBK
     C                   Else                                                                BUG2812
     C                   If        WCommitSkip <> 'Y'                                        BUG2812
     C                   ROLBK                                                               BUG2812
     C                   Else                                                                BUG2812
     C                   Seton                                        U7U8                   BUG2812
     C                   Endif                                                               BUG2812
     C                   Endif                                                               BUG2812
      *                                                                                      BUG2812
     C     @RTCD         IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                      BUG2812
     C                   ELSE
     C                   If        (CSC022 <> 'Y')                                           BUG2812
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                  BUG2812
     C                   COMMIT
     C                   EndIf                                                               BUG2812
     C                   ENDIF
      *
     C** If update not done due to record being updated by another
     C** workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   MOVEL     'N'           CLRSCRN
     C
     C                   ENDIF
     C
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NwDlScnFmt
     C                   MOVEL     *BLANK        DDSTS
     C                   MOVEL     'Y'           CLRSCRN           1
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRENDP - END PROGRAM
      *****************************************************************
     C     SRENDP        BEGSR
     C                   MOVEL     'T'           @SCRN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEPRCSSIN'   DBPGM
     C     *LIKE         DEFINE    PPRC          HPPRC
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      *  Check if CAC005 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAC005'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAC005
     C                   ELSE
     C                   MOVE      'N'           CAC005
     C                   ENDIF
                                                                                              CSD010
      ** Access switchable features file - Collateralised Lending (CSD010)                    CSD010
                                                                                              CSD010
     C                   CALL      'AOSARDR0'                                                 CSD010
     C                   PARM      *BLANKS       PRetCode                                     CSD010
     C                   PARM      '*VERIFY'     POption                                      CSD010
     C                   PARM      'CSD010'      PSard                                        CSD010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD010
                                                                                              CSD010
     C                   IF        PRetCode <> *BLANKS AND                                    CSD010
     C                             PRetCode <> '*NRF   '                                      CSD010
     C                   EVAL      DBASE = 903                                                CSD010
     C                   EVAL      DBKEY = 'CSD010'                                           CSD010
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD010
     C                   EXSR      *PSSR                                                      CSD010
     C                   ENDIF                                                                CSD010
     C                                                                                        CSD010
     C                   IF        PRetCode = *BLANKS                                         CSD010
     C                   EVAL      CSD010 = 'Y'                                               CSD010
     C                   ELSE                                                                 CSD010
     C                   EVAL      CSD010 = 'N'                                               CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CGL031
      ** Check if CGL031 is on                                                                CGL031
                                                                                              CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSard                                        CGL031
                                                                                              CGL031
     C     PRtcd         IFEQ      *BLANKS                                                    CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
      *
      * Check if EXTEL indicator is on, BVEXOP
 
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      * Start on Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN             1
     C     *LIKE         DEFINE    PPRC          HPPRC
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
      ** Access Switchable Features File, for CSC022                                         BUG2812
      *                                                                                      BUG2812
     C                   Eval      CSC022 = 'N'                                              BUG2812
     C                   CallB     'AOSARDR0'                                                BUG2812
     C                   Parm      *BLANKS       @RTCD                                       BUG2812
     C                   Parm      '*VERIFY'     @OPTN                                       BUG2812
     C                   Parm      'CSC022'      @SARD                                       BUG2812
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2812
      *                                                                                      BUG2812
     C                   If        @RTCD = *Blanks                                           BUG2812
     C                   Eval      CSC022 = 'Y'                                              BUG2812
     C                   Eval      WCommitSkip = 'N'                                         BUG2812
      *                                                                                      BUG2812
     C                   In        SCCMTJOB                                                  BUG2812
     C                   If        ComitNum > 0                                              BUG2812
     C                   MoveA     ComitJob      WCmtJobArr                                  BUG2812
      *                                                                                      BUG2812
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                 BUG2812
     C                   If        *IN87 = *ON                                               BUG2812
     C                   Eval      WCommitSkip = 'Y'                                         BUG2812
     C                   EndIf                                                               BUG2812
     C                   EndIf                                                               BUG2812
      *                                                                                      BUG2812
     C                   Else                                                                BUG2812
      *                                                                                      BUG2812
      ** If return code <> *NRF, call program exception error routine                        BUG2812
      *                                                                                      BUG2812
     C                   If        @RTCD <> '*NRF'                                           BUG2812
     C     *LOCK         IN        LDA                                                       BUG2812
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2812
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG2812
     C                   EVAL      DBASE = 904                                               BUG2812
     C                   OUT       LDA                                                       BUG2812
     C                   Exsr      *PSSR                                                     BUG2812
     C                   EndIf                                                               BUG2812
     C                   EndIf                                                               BUG2812
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEPRCSS010
 
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
