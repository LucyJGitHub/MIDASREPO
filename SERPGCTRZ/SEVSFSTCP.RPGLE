     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate first coupon date')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSFSTCP - Validate First Coupon Date                       *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 05Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
      *  CSD006 - Market Data Feeds (recompile)                       *
      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
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
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *                                                                                       CSE071
      ** Securities screen 6 details from incoming transaction                                CSE071
      ** - screen format                                                                      CSE071
     D NwSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                  CSE071
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** DS for the coupon/rate days
     D WSCD            S              4A   DIM(12)
      *
      ** DS for the coupon/rate indicators array
     D WSCR            S              1A   DIM(12)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of Warning error message ids, etc.
     D WIx             S              3P 0
      *
      ** Index for Coupon/Rate Days Array
     D Wx              S              2P 0
      *
      ** Parameters for ZDATE1
 
     D PDate           S              6A
     D PDaynoOut       S              5P 0
     D ErrorFlag       S              1A
 
      ** Parameters for ZCHKH
     D PDateIn         S              5P 0
     D PCurrency       S              3A
     D PLocation       S              3A
     D PHolInd         S              1A
      *
      ** Parameters for ZFWDT
     D PDaysFwd        S              2P 0
      *
      ** Parameters for ZDATE2
     D PZDate          S              6P 0
     D PZaDate         S              7A
      *
      ** Parameters for ZNCD
     D  PFCPN          S              5P 0
     D  PCDArr         S             48A
     D  PCRArr         S             12A
     D  PEvtCd         S              5P 0
     D  PNxtCd         S              5P 0
 
     D WFstCpn         S              5P 0
     D WKFCPN          S              4A
     D PCpnRt          S             15P 0
     D PPROT           S              1A
     D CSE005          S              1A
     D CSE031          S              1A                                                      CSE031
     D CSE071          S              1A                                                      CSE071
     D BJDFIN          S              1A
     D WLoop           S              1A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
     C                   EVAL      WIx = 0
     C                   EVAL      WFstCpn = 0
      *
      ** Load array
      *
     C                   MOVE      DDCD01        WSCD(1)
     C                   MOVE      DDCD02        WSCD(2)
     C                   MOVE      DDCD03        WSCD(3)
     C                   MOVE      DDCD04        WSCD(4)
     C                   MOVE      DDCD05        WSCD(5)
     C                   MOVE      DDCD06        WSCD(6)
     C                   MOVE      DDCD07        WSCD(7)
     C                   MOVE      DDCD08        WSCD(8)
     C                   MOVE      DDCD09        WSCD(9)
     C                   MOVE      DDCD10        WSCD(10)
     C                   MOVE      DDCD11        WSCD(11)
     C                   MOVE      DDCD12        WSCD(12)
 
     C                   MOVE      DDCR01        WSCR(1)
     C                   MOVE      DDCR02        WSCR(2)
     C                   MOVE      DDCR03        WSCR(3)
     C                   MOVE      DDCR04        WSCR(4)
     C                   MOVE      DDCR05        WSCR(5)
     C                   MOVE      DDCR06        WSCR(6)
     C                   MOVE      DDCR07        WSCR(7)
     C                   MOVE      DDCR08        WSCR(8)
     C                   MOVE      DDCR09        WSCR(9)
     C                   MOVE      DDCR10        WSCR(10)
     C                   MOVE      DDCR11        WSCR(11)
     C                   MOVE      DDCR12        WSCR(12)
      *
      ** Validate first coupon date
      *
     C                   EXSR      SRValFCpnDt
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKFCPN <> 'Y'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKFCPN <> 'N'
     C                   Z-ADD     WFstCpn       S1FCPN
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALFCPNDT - Validation for Fisrt Coupon Date               *
      *                                                               *
      *****************************************************************
 
     C     SRValFCpnDt   BEGSR
      *
      ** Validate if not equal to blanks
      *
     C                   IF        DDFCPN <> *BLANKS
      *
      ** If coupon rate is zero, entry is not allowed
      *
     C                   IF        PCpnRt = *ZEROS
     C                   MOVE      'W'           OKFCPN
     C                   ADD       1             WIx
     C                   MOVEL     'DDFCPN'      WFldNmXAr(WIx)
     C                   MOVEL     'SEA0181'     WMsgIdXAr(WIx)
     C                   ENDIF
      *
      ** Check valid date
      *
     C                   TESTN                   DDFCPN               01
 
     C                   IF        *IN01 = *OFF
     C                   MOVE      'N'           OKFCPN
     C                   ADD       1             IDx
     C                   MOVEL     'DDFCPN'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0182'     MsgIdXAr(IDx)
     C                   GOTO      EValFCpnDt
     C                   ENDIF
 
     C                   MOVE      *BLANKS       PDate
     C                   MOVE      DDFCPN        PDate
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM      *ZEROS        PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag
 
     C                   IF        ErrorFlag = 'Y'
     C                   MOVE      'N'           OKFCPN
     C                   ADD       1             IDx
     C                   MOVEL     'DDFCPN'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0182'     MsgIdXAr(IDx)
     C                   GOTO      EValFCpnDt
     C                   ENDIF
 
     C                   Z-ADD     PDaynoOut     WFstCpn
      *
      ** If processing type is 3 and switch CSE005 is on
      ** then ensure that first coupon is not holiday
      *  OR                                                                                   CSE031
      ** If processing type is 8 and switch CSE005 and CSE031 are on                          CSE031
      ** then ensure that first coupon is not holiday                                         CSE031
      *  OR                                                                                   CSE071
      ** If CSE005 and CSE071 are switched on and processing type is                          CSE071
      ** 1, 3, 5, 6, 8, 9 then count the number of entries in CR array                        CSE071
      *
     C********           IF        PPROT = '3' AND                                            CSE031
     C********                     CSE005 = 'Y'                                               CSE031
     C                   IF        PPROT = '3' AND CSE005 = 'Y' OR                            CSE031
     C                             PPROT = '8' AND CSE005 = 'Y' AND                           CSE031
     C                             CSE031 = 'Y'                                               CSE031
     C                             OR CSE071 = 'Y' AND CSE005 = 'Y' AND                       CSE071
     C                             (PPROT = '1' OR PPROT = '3' OR PPROT = '5' OR              CSE071
     C                             PPROT = '6' OR PPROT = '8' OR PPROT = '9')                 CSE071
     C                   IF        S1BCNV <> 'N'                                              CSE031
     C                   EXSR      SRChkHol
     C                   ENDIF                                                                CSE031
     C                   ENDIF
      *
      ** Must be after initial date and before maturity date
      *
     C                   IF        WFstCpn <= S1ITLD OR
     C                             WFstCpn > S1MATY
     C                   MOVE      'N'           OKFCPN
     C                   ADD       1             IDx
     C                   MOVEL     'DDFCPN'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0183'     MsgIdXAr(IDx)
     C                   ENDIF
      *
      ** Day/month must correspond to 1 coupon rate/day entered
      ** The first coupon date doesn't need to correspond to a
      ** coupon date from the array, therefore warning message
      *
     C                   Z-ADD     1             Wx
     C                   MOVEL     DDFCPN        WKFCPN
     C                   MOVEL     'N'           WLoop
 
     C                   DOW       Wx <= 12 AND WLoop = 'N'
 
     C                   IF        WKFCPN = WSCD(Wx) AND
     C                             WSCR(Wx) <> 'R'
     C                   EVAL      WLoop = 'Y'
     C                   ENDIF
 
     C                   ADD       1             Wx
     C                   ENDDO
 
     C                   IF        WLoop = 'N'
     C                   MOVE      'W'           OKFCPN
     C                   ADD       1             WIx
     C                   MOVEL     'DDFCPN'      WFldNmXAr(WIx)
     C                   MOVEL     'SEA0181'     WMsgIdXAr(WIx)
     C                   ENDIF
 
     C                   ELSE
      *
      ** If first coupon date not entered, get next coupon date after
      ** the initial date.
 
     C                   IF        PCpnRt <> *ZEROS AND OKITLD <> 'N' AND
     C                             OKMATY1 <> 'N' AND OKMATY2 <> 'N' AND
     C                             OKBCNV <> 'N'  AND
 
     C                             OKCD01 <> 'N' AND OKCD02 <> 'N' AND
     C                             OKCD03 <> 'N' AND OKCD04 <> 'N' AND
     C                             OKCD05 <> 'N' AND OKCD06 <> 'N' AND
     C                             OKCD07 <> 'N' AND OKCD08 <> 'N' AND
     C                             OKCD09 <> 'N' AND OKCD10 <> 'N' AND
     C                             OKCD11 <> 'N' AND OKCD12 <> 'N' AND
      *
     C                             OKCR01 <> 'N' AND OKCR02 <> 'N' AND
     C                             OKCR03 <> 'N' AND OKCR04 <> 'N' AND
     C                             OKCR05 <> 'N' AND OKCR06 <> 'N' AND
     C                             OKCR07 <> 'N' AND OKCR08 <> 'N' AND
     C                             OKCR09 <> 'N' AND OKCR10 <> 'N' AND
     C                             OKCR11 <> 'N' AND OKCR12 <> 'N'
 
     C                   EVAL      PEvtCd = S1ITLD + 1
     C                   MOVEA     WSCD          PCDArr
     C                   MOVEA     WSCR          PCRArr
 
     C                   CALLB     'ZNCD'
     C                   PARM                    S1ITLD
     C                   PARM      *ZEROS        PFCPN
     C                   PARM                    S1MATY
     C                   PARM                    PCDArr
     C                   PARM                    PCRArr
     C                   PARM                    PEvtCd
     C                   PARM                    BJDFIN
     C                   PARM                    S1NMCY
     C                   PARM                    S1SITP
     C                   PARM                    S1BCNV
     C                   PARM                    LCPN              5 0                        CSE031
     C                   PARM                    DDHCY1                                       CSE071
     C                   PARM                    DDHCY2                                       CSE071
     C                   PARM                    DDHCY3                                       CSE071
     C                   PARM                    DDHCY4                                       CSE071
     C                   PARM                    DDHCY5                                       CSE071
     C                   PARM                    DDHCY6                                       CSE071
     C                   PARM                    DDHCY7                                       CSE071
     C                   PARM                    DDHCY8                                       CSE071
     C                   PARM                    DDHCY9                                       CSE071
     C                   PARM                    PNxtCd
 
     C                   Z-ADD     PNxtCd        WFstCpn
     C                   ENDIF
 
     C                   ENDIF
 
     C     EValFCpnDt    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkHol - Check if First Coupon Date is Holiday             *
      *                                                               *
      *****************************************************************
 
     C     SRChkHol      BEGSR
      *
      ** If the first coupon date is a holiday in nominal currency
      ** then update it to be the next working day.
      *
     C                   CALLB     'ZCHKH'
     C                   PARM      WFstCpn       PDateIn
     c                   PARM      S1NMCY        PCurrency
     C                   PARM      *BLANKS       PLocation
     C                   PARM                    PHolInd
 
     C                   IF        PHolInd = 'H'
 
     C                   Z-ADD     1             PDaysFwd
     C                   CALLB     'ZFWDT'
     C                   PARM                    PDateIn
     C                   PARM                    PDaysFwd
     C                   PARM                    PDaynoOut
     C                   PARM                    PCurrency
     C                   PARM                    PLocation
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    PZDate
     C                   PARM                    PZaDate
 
     C                   MOVE      PZDate        DDFCPN
     C                   MOVE      PDaynoOut     WFstCpn
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *                                                                                       CSE071
      ** Securities screen 6 details from incoming transaction                                CSE071
      ** - screen format                                                                      CSE071
     C                   PARM                    NwSE6ScnFmt                                  CSE071
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Work variable for coupon rate
     C                   PARM                    PCpnRt
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on FRN coupon date
     C                   PARM                    CSE005
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
      *
      ** STANDING DATA
      ** =============
      *
      ** Date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
