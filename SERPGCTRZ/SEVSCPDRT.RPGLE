     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate coupon days/rate indicators')        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSCPDRT - Validate Coupon Days/Rate Indicators             *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1077982          Date 28Jan13               *
      *                 AR826623           Date 17Sep12               *
      *                 AR750169           Date 17Sep12               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 05Dec01               *
      *                 197876             Date 26Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1077982 - Blank value for Last Coupon Date triggers error  *
      *  AR826623 - ST: Serious midas error in Securities details.    *
      *             Added the missing parameters on call to ZLCD.     *
      *             (Child: AR826624)                                 *
      *  AR750169 - SE: Unexpectedly big amount of coupon interest    *
      *             accrual for EBRDB02 on 20.01.2011. Checks if the  *
      *             coupon array amended falls on the last coupon     *
      *             date. (Child: AR750194)                           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
      *  197876 - Incorrect values were moved to coupon arrays due to *
      *           wrong fields used after amending the security.  Fix *
      *           is to move validated array WSCD to coupon array     *
      *           instead of WCD.                                     *
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
     FSECEO     IF   E           K DISK    RENAME(SNDEVDF:SNDEVDO)                          AR750169
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
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *                                                                                     AR750169
      ** Securities retrieved from file - file format                                       AR750169
      *                                                                                     AR750169
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)                                  AR750169
     D CDArr                 183    230                                                     AR750169
     D CRArr                 231    242                                                     AR750169
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIx             S              3P 0
      *
      ** Data Structure to hold Coupon/Rate Days array
     D WSCD            S              4A   DIM(12)
      *
      ** Data Structure to hold Coupon/Rate Indicators array
     D WSCR            S              1A   DIM(12)
      *
      ** Data Structure to hold work variable for Coupon Dates
     D WCD             S              4  0 DIM(12)
      *                                                                                     AR750169
      ** Data Structure to hold Previous Coupon/Rate Days array                             AR750169
      *                                                                                     AR750169
     D WPCD            S              4A   DIM(12)                                          AR750169
      *
      ** Work variables
     D Wx              S              2P 0
     D WMonth          S              2A
     D WDay            S              2P 0
     D WCount          S              2P 0
     D WPos            S              2P 0
     D WLDAT           S              4P 0
     D WNDAT           S              4P 0
     D Work48          S             48A
     D PPrCpn          S              1A
      *
      ** Work parameters
     D PPROT           S              1A
     D BJDFIN          S              1A
     D CSE005          S              1A
     D CSE031          S              1A                                                      CSE031
     D CSE071          S              1A                                                      CSE071
     D PCpnRt          S             15P 0
 
     D TABMTH          S              2    DIM(12) CTDATA PERRCD(12)
     D TABDAY          S              2  0 DIM(12) ALT(TABMTH)
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
     C**********         Z-ADD     *ZEROS        WCD                                          197876
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
      *                                                                                     AR750169
     C                   MOVE      CD01          WPCD(1)                                    AR750169
     C                   MOVE      CD02          WPCD(2)                                    AR750169
     C                   MOVE      CD03          WPCD(3)                                    AR750169
     C                   MOVE      CD04          WPCD(4)                                    AR750169
     C                   MOVE      CD05          WPCD(5)                                    AR750169
     C                   MOVE      CD06          WPCD(6)                                    AR750169
     C                   MOVE      CD07          WPCD(7)                                    AR750169
     C                   MOVE      CD08          WPCD(8)                                    AR750169
     C                   MOVE      CD09          WPCD(9)                                    AR750169
     C                   MOVE      CD10          WPCD(10)                                   AR750169
     C                   MOVE      CD11          WPCD(11)                                   AR750169
     C                   MOVE      CD12          WPCD(12)                                   AR750169
      *
      ** Validate coupon rate/days indicator
      *
     C                   IF        (S1STBS = 'P' AND
     C                             PPROT <> '2' AND
     C                             PPROT <> '4' AND
     C                             PPROT <> '7') OR
     C                             (S1STBS = 'Y' AND
     C                             PPROT <> '2' AND
     C                             PPROT <> '4' AND
     C                             PPROT <> '7' AND
     C                             PPROT <> '9')
     C                   IF        PPrCpn <> 'Y'
     C                   EXSR      SRValCpnRtDy
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate dividend payment dates
      *
     C                   IF        PPrCpn <> 'Y'
     C                   IF        PPROT = '4' OR
     C                             PPROT = '7'
     C                   EXSR      SRVALDivPmDt
     C                   ENDIF
     C                   ENDIF
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKCD01 <> 'Y' OR OKCD02 <> 'Y' OR
     C                             OKCD03 <> 'Y' OR OKCD04 <> 'Y' OR
     C                             OKCD05 <> 'Y' OR OKCD06 <> 'Y' OR
     C                             OKCD07 <> 'Y' OR OKCD08 <> 'Y' OR
     C                             OKCD09 <> 'Y' OR OKCD10 <> 'Y' OR
     C                             OKCD11 <> 'Y' OR OKCD12 <> 'Y' OR
 
     C                             OKCR01 = 'N' OR OKCR02 = 'N' OR
     C                             OKCR03 = 'N' OR OKCR04 = 'N' OR
     C                             OKCR05 = 'N' OR OKCR06 = 'N' OR
     C                             OKCR07 = 'N' OR OKCR08 = 'N' OR
     C                             OKCR09 = 'N' OR OKCR10 = 'N' OR
     C                             OKCR11 = 'N' OR OKCR12 = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKCD01 <> 'N' AND  OKCD02 <> 'N' AND
     C                             OKCD03 <> 'N' AND  OKCD04 <> 'N' AND
     C                             OKCD05 <> 'N' AND  OKCD06 <> 'N' AND
     C                             OKCD07 <> 'N' AND  OKCD08 <> 'N' AND
     C                             OKCD09 <> 'N' AND  OKCD10 <> 'N' AND
     C                             OKCD11 <> 'N' AND  OKCD12 <> 'N' AND
 
     C                             OKCR01 <> 'N' AND  OKCR02 <> 'N' AND
     C                             OKCR03 <> 'N' AND  OKCR04 <> 'N' AND
     C                             OKCR05 <> 'N' AND  OKCR06 <> 'N' AND
     C                             OKCR07 <> 'N' AND  OKCR08 <> 'N' AND
     C                             OKCR09 <> 'N' AND  OKCR10 <> 'N' AND
     C                             OKCR10 <> 'N' AND  OKCR12 <> 'N'
     C**********         MOVE      WCD(1)        S1CD01                                       197876
     C**********         MOVE      WCD(2)        S1CD02                                       197876
     C**********         MOVE      WCD(3)        S1CD03                                       197876
     C**********         MOVE      WCD(4)        S1CD04                                       197876
     C**********         MOVE      WCD(5)        S1CD05                                       197876
     C**********         MOVE      WCD(6)        S1CD06                                       197876
     C**********         MOVE      WCD(7)        S1CD07                                       197876
     C**********         MOVE      WCD(8)        S1CD08                                       197876
     C**********         MOVE      WCD(9)        S1CD09                                       197876
     C**********         MOVE      WCD(10)       S1CD10                                       197876
     C**********         MOVE      WCD(11)       S1CD11                                       197876
     C**********         MOVE      WCD(12)       S1CD12                                       197876
      *                                                                                       197876
     C                   MOVE      WSCD(1)       S1CD01                                       197876
     C                   MOVE      WSCD(2)       S1CD02                                       197876
     C                   MOVE      WSCD(3)       S1CD03                                       197876
     C                   MOVE      WSCD(4)       S1CD04                                       197876
     C                   MOVE      WSCD(5)       S1CD05                                       197876
     C                   MOVE      WSCD(6)       S1CD06                                       197876
     C                   MOVE      WSCD(7)       S1CD07                                       197876
     C                   MOVE      WSCD(8)       S1CD08                                       197876
     C                   MOVE      WSCD(9)       S1CD09                                       197876
     C                   MOVE      WSCD(10)      S1CD10                                       197876
     C                   MOVE      WSCD(11)      S1CD11                                       197876
     C                   MOVE      WSCD(12)      S1CD12                                       197876
 
     C                   MOVE      DDCR01        S1CR01
     C                   MOVE      DDCR02        S1CR02
     C                   MOVE      DDCR03        S1CR03
     C                   MOVE      DDCR04        S1CR04
     C                   MOVE      DDCR05        S1CR05
     C                   MOVE      DDCR06        S1CR06
     C                   MOVE      DDCR07        S1CR07
     C                   MOVE      DDCR08        S1CR08
     C                   MOVE      DDCR09        S1CR09
     C                   MOVE      DDCR10        S1CR10
     C                   MOVE      DDCR11        S1CR11
     C                   MOVE      DDCR12        S1CR12
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALCPNRTDY - Validation for Coupon Rate/Days Indicator     *
      *                                                               *
      *****************************************************************
     C     SRValCpnRtDy  BEGSR
      *
      ** Must be entered if security complete and not flat
      *
     C                   MOVEA     '000'         *IN(01)
     C                   MOVEA     WSCD          Work48
 
     C                   IF        Work48 = *BLANKS
 
     C                   IF        S1INCS = 'C'
     C                   IF        PCpnRt <> *ZEROS
     C                   MOVE      'N'           OKCD01
     C                   ADD       1             IDx
     C                   MOVEL     'DDCD01'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0184'     MsgIdXAr(IDx)
     C                   ENDIF
      *
      ** or has a divisor basis of '5'
     C                   IF        DDDVBS2 = '5'
     C                   MOVE      'N'           OKCPNR
     C                   ADD       1             IDx
     C                   MOVEL     'DDCD01'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0184'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     *ZEROS        WLDAT
     C                   Z-ADD     *ZEROS        WNDAT
     C                   Z-ADD     1             Wx
      *                                                                                     AR750169
     C     KESNCP        KLIST                                                              AR750169
     C                   KFLD                    SESN                                       AR750169
     C                   KFLD                    SNET                                       AR750169
     C                   KFLD                    SNDT                                       AR750169
      *                                                                                     AR750169
     C                   MOVE      'CP'          SNET                                       AR750169
     C                   MOVE      *HIVAL        SNDT                                       AR750169
     C     KESNCP        SETLL     SNDEVDO                                                  AR750169
     C                   READ      SNDEVDO                                60                AR750169
     C     *IN60         IFEQ      '0'                                                      AR750169
     C     SNSN          ANDEQ     SESN                                                     AR750169
     C     SNET          ANDEQ     'CP'                                                     AR750169
     C                   Z-ADD     SNDT          TMLCPN            5 0                      AR750169
     C                   ELSE                                                               AR750169
     C     BJRDNB        SUB       1             ZECD                                       AR750169
     C                   EXSR      SRZLCD                                                   AR750169
     C                   ENDIF                                                              AR750169
      *                                                                                     AR750169
     C                   MOVE      TMLCPN        ZDAYNO                                     AR750169
     C                   CALLB     'ZDATE2'                                                 AR750169
     C                   PARM                    ZDAYNO            5 0                      AR750169
     C                   PARM                    BJDFIN                                     AR750169
     C                   PARM                    ZDATE             6 0                      AR750169
     C                   PARM                    ZADATE            7                        AR750169
      *                                                                                     AR750169
     C                   MOVEL     ZDATE         EDLCPN            4                        AR750169
 
     C                   DO        12            Wx
 
     C                   IF        WSCD(Wx) <> *BLANKS
 
     C                   IF        Wx > 1
     C                   SUB       1             Wx
     C                   IF        WSCD(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      SRCpnDyErr
     C                   MOVE      'SEA0185'     MsgIDXAr(IDx)
     C                   ENDIF
     C                   ADD       1             Wx
     C                   ENDIF
      *
      ** Entry made (for Coupon Rate/Days) with a zero coupon rate.
     C                   IF        WSCD(Wx) <> *BLANKS AND
     C                             PCpnRt = *ZEROS
     C                   ADD       1             WIx
     C                   EXSR      SRCpnDyWrn
     C                   MOVE      'SEA0186'     WMsgIDXAr(WIx)
     C                   ENDIF
      *
      ** Check for date format
     C                   IF        BJDFIN = 'M'
     C                   MOVEL     WSCD(Wx)      WMonth
     C                   MOVE      WSCD(Wx)      WDay
     C                   ELSE
     C                   MOVE      WSCD(Wx)      WMonth
     C                   MOVEL     WSCD(Wx)      WDay
     C                   ENDIF
      *
      ** Check entry is valid
     C     WMonth        LOOKUP    TABMTH        TABDAY                   01
 
     C                   IF        *IN01 = *On
     C     WDay          COMP      TABDAY                               0101
     C                   ENDIF
     C                   IF        *IN01 = *On
     C     WDay          COMP      *ZEROS                             01
     C                   ENDIF
     C                   IF        *IN01 = *Off
     C                   ADD       1             IDx
     C                   EXSR      SRCpnDyErr
     C                   MOVE      'SEA0187'     MsgIDXAr(IDx)
     C                   ENDIF
     C                   MOVE      *OFF          *IN01
      *
      ** Cannot be earlier than preceding rate/day
     C                   MOVEL     WMonth        WNDAT
     C                   MOVE      WDay          WNDAT
     C                   IF        WNDAT <= WLDAT
     C                   ADD       1             IDx
     C                   EXSR      SRCpnDyErr
     C                   MOVE      'SEA0188'     MsgIDXAr(IDx)
     C                   ENDIF
     C                   Z-ADD     WNDAT         WLDAT
      *                                                                                     AR750169
      ** Check if Coupon Array amended is the Last Coupon Date.                             AR750169
      *                                                                                     AR750169
     C     CSE005        IFEQ      'N'                                                      AR750169
     C     WPCD(Wx)      IFNE      WSCD(Wx)                                                 AR750169
     C     WPCD(Wx)      ANDEQ     EDLCPN                                                   AR750169
     C     EDLCPN        ANDNE     *ZERO                                                    AR826623
     C                   ADD       1             WIx                                        AR750169
     C                   EXSR      SRCpnDyWrn                                               AR750169
     C                   MOVE      '5045555'     WMsgIDXAr(WIx)                             AR750169
     C                   ENDIF                                                              AR750169
     C                   ENDIF                                                              AR750169
      *
      ** Coupon Rate Indicator
      ** =====================
      *
      ** Must be entered if corresponding rate/day entered
      *
     C                   IF        WSCR(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      SRCpnRtErr
     C                   MOVE      'SEA0190'     MsgIDXAr(IDx)
     C                   ELSE
      *
      ** If processing type not 3, 5 or 8 (FRNs,Yen Bonds,Mortgage Backed)
      ** entry must be 'P'.
     C                   IF        PPROT <> '3' AND
     C                             PPROT <> '5' AND
     C                             PPROT <> '8'
 
     C                   IF        WSCR(Wx) <> 'P'
     C                   ADD       1             IDx
     C                   EXSR      SRCpnRtErr
     C                   MOVE      'SEA0189'     MsgIDXAr(IDx)
     C                   ENDIF
 
     C                   ELSE
      *
      ** Processing type '3','5' and '8'
     C                   IF        WSCR(Wx) <> 'P' AND
     C                             WSCR(Wx) <> 'R' AND
     C                             WSCR(Wx) <> 'C'
     C                   ADD       1             IDx
     C                   EXSR      SRCpnRtErr
     C                   MOVE      'SEA0189'     MsgIDXAr(IDx)
     C                   ENDIF
      *
      ** all entries cannot be 'R'
     C                   IF        WSCR(Wx) = 'R'
     C                   MOVE      *ON           *IN02
     C                   ELSE
     C                   MOVE      *ON           *IN03
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                            AR750169
     C                   ELSE                                                               AR750169
      *                                                                                     AR750169
      ** Check if Coupon Array amended is the Last Coupon Date and                          AR750169
      ** is left blank.                                                                     AR750169
      *                                                                                     AR750169
     C     CSE005        IFEQ      'N'                                                      AR750169
     C     WPCD(Wx)      IFNE      WSCD(Wx)                                                 AR750169
     C     WPCD(Wx)      ANDEQ     EDLCPN                                                   AR750169
     C     EDLCPN        ANDNE     *ZERO                                                    AR826623
     C                   ADD       1             WIx                                        AR750169
     C                   EXSR      SRCpnDyWrn                                               AR750169
     C**********         MOVE      'SEA0532'     WMsgIDXAr(WIx)                   AR750169 AR1077982
     C                   MOVE      '5045555'     WMsgIDXAr(WIx)                            AR1077982
     C                   ENDIF                                                              AR750169
     C                   ENDIF                                                              AR750169
 
     C                   ENDIF
      *
      ** If WSCR,Wx not blank and WSCD,Wx equal 0 it is an error
      *
     C                   IF        WSCR(Wx) <> *BLANK AND
     C                             WSCD(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      SRCpnRtErr
     C                   MOVE      'SEA0190'     MsgIDXAr(IDx)
     C                   ENDIF
     C                   MOVE      WSCD(Wx)      WCD(Wx)
 
     C                   ENDDO
 
     C
     C                   IF        *IN02 = *ON AND
     C                             *IN03 = *OFF
     C                   MOVE      'N'           OKCR01
     C                   ADD       1             IDx
     C                   MOVEL     'DDCR01'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0191'     MsgIDXAr(IDx)
     C                   ENDIF
      *
      ** If CSE005 is switched on and processing type is '3'
      ** then count the number of entries in CR array
      *  OR                                                                                   CSE031
      ** If CSE005 and CSE031 are switched on and processing type is '8'                      CSE031
      ** then count the number of entries in CR array                                         CSE031
      *  OR                                                                                   CSE071
      ** If CSE005 and CSE071 are switched on and processing type is                          CSE071
      ** 1, 3, 5, 6, 8, 9 then count the number of entries in CR array                        CSE071
      *                                                                                       CSE031
     C*********          IF        PPROT = '3' AND                                            CSE031
     C*********                    CSE005 = 'Y'                                               CSE031
     C                   IF        PPROT = '3' AND CSE005 = 'Y' OR                            CSE031
     C                             PPROT = '8' AND CSE005 = 'Y' AND                           CSE031
     C                             CSE031 = 'Y'                                               CSE031
     C                             OR CSE071 = 'Y' AND CSE005 = 'Y' AND                       CSE071
     C                             (PPROT = '1' OR PPROT = '3' OR PPROT = '5' OR              CSE071
     C                             PPROT = '6' OR PPROT = '8' OR PPROT = '9')                 CSE071
     C                   IF        DDBCNV <> 'N'                                              CSE031
     C                   Z-ADD     0             WCount
 
     C     1             DO        12            WPos
     C                   IF        WSCR(WPos) = 'P' OR
     C                             WSCR(WPos) = 'C'
     C                   ADD       1             WCount
     C                   ENDIF
     C                   ENDDO
      *
      ** If no.'P' or 'C' entries is not 1, 2, 4, 6 or 12 then error
     C                   IF        WCount <> 1 AND
     C                             WCount <> 2 AND
     C                             WCount <> 4 AND
     C                             WCount <> 6 AND
     C                             WCount <> 12
     C                   MOVE      'N'           OKCD01
     C                   ADD       1             IDx
     C                   MOVEL     'DDCD01'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0197'     MsgIDXAr(IDx)
     C                   ENDIF
 
     C                   ENDIF                                                                CSE031
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALDIVPMDT - Validation for Dividend Payment Dates         *
      *                                                               *
      *****************************************************************
     C     SRValDivPmDt  BEGSR
      *
      ** Cannot be blank if initial date is not blank
      *
     C                   MOVEA     WSCD          Work48
 
     C                   IF        Work48 = *BLANKS
 
     C                   IF        DDIDIV <> *BLANKS
     C                   MOVE      'N'           OKCD01
     C                   ADD       1             IDx
     C                   MOVEL     'DDCD01'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0199'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     *ZEROS        WLDAT
     C                   Z-ADD     *ZEROS        WNDAT
     C                   Z-ADD     1             Wx
 
     C                   DO        12            Wx
 
     C                   IF        WSCD(Wx) <> *BLANKS
     C                   IF        Wx > 1
     C                   SUB       1             Wx
     C                   IF        WSCD(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      SRCpnDyErr
     C                   MOVE      'SEA0200'     MsgIDXAr(IDx)
     C                   ENDIF
     C                   ADD       1             Wx
     C                   ENDIF
      *
      ** Check for date format
     C                   IF        BJDFIN = 'M'
     C                   MOVEL     WSCD(Wx)      WMonth
     C                   MOVE      WSCD(Wx)      WDay
     C                   ELSE
     C                   MOVE      WSCD(Wx)      WMonth
     C                   MOVEL     WSCD(Wx)      WDay
     C                   ENDIF
      *
      ** Validate month and day
     C     WMonth        LOOKUP    TABMTH        TABDAY                   01
     C                   IF        *IN01 = *OFF OR
     C                             WDay > TABDAY OR
     C                             WDay <= *ZEROS
     C                   ADD       1             IDx
     C                   EXSR      SRCpnDyErr
     C                   MOVE      'SEA0201'     MsgIDXAr(IDx)
     C                   ENDIF
      *
      ** Cannot be earlier than preceding date
     C                   MOVEL     WMonth        WNDAT
     C                   MOVE      WDay          WNDAT
     C                   IF        WNDAT <= WLDAT
     C                   ADD       1             IDx
     C                   EXSR      SRCpnDyErr
     C                   MOVE      'SEA0188'     MsgIDXAr(IDx)
     C                   ENDIF
     C                   Z-ADD     WNDAT         WLDAT
     C                   ENDIF
 
     C                   MOVE      WSCD(Wx)      WCD(Wx)
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCPNDYERR - Select on Coupon Day Field Error                *
      *                                                               *
      *****************************************************************
     C     SRCpnDyErr    BEGSR
 
     C                   SELECT
 
     C                   WHEN      Wx = 1
     C                   MOVE      'N'           OKCD01
     C                   MOVEL     'DDCD01'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 2
     C                   MOVE      'N'           OKCD02
     C                   MOVEL     'DDCD02'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 3
     C                   MOVE      'N'           OKCD03
     C                   MOVEL     'DDCD03'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 4
     C                   MOVE      'N'           OKCD04
     C                   MOVEL     'DDCD04'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 5
     C                   MOVE      'N'           OKCD05
     C                   MOVEL     'DDCD05'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 6
     C                   MOVE      'N'           OKCD06
     C                   MOVEL     'DDCD06'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 7
     C                   MOVE      'N'           OKCD07
     C                   MOVEL     'DDCD07'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 8
     C                   MOVE      'N'           OKCD08
     C                   MOVEL     'DDCD08'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 9
     C                   MOVE      'N'           OKCD09
     C                   MOVEL     'DDCD09'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 10
     C                   MOVE      'N'           OKCD10
     C                   MOVEL     'DDCD10'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 11
     C                   MOVE      'N'           OKCD11
     C                   MOVEL     'DDCD11'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 12
     C                   MOVE      'N'           OKCD12
     C                   MOVEL     'DDCD12'      FldNamXAr(IDx)
 
     C                   ENDSL
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCPNDYWRN - Select on Coupon Day Field Error (Warning)      *
      *                                                               *
      *****************************************************************
     C     SRCpnDyWrn    BEGSR
 
     C                   SELECT
 
     C                   WHEN      Wx = 1
     C                   MOVE      'W'           OKCD01
     C                   MOVEL     'DDCD01'      WFldNmXAr(WIx)
 
     C                   WHEN      Wx = 2
     C                   MOVE      'W'           OKCD02
     C                   MOVEL     'DDCD02'      WFldNmXAr(WIx)
 
     C                   WHEN      Wx = 3
     C                   MOVE      'W'           OKCD03
     C                   MOVEL     'DDCD03'      WFldNmXAr(Wix)
 
     C                   WHEN      Wx = 4
     C                   MOVE      'W'           OKCD04
     C                   MOVEL     'DDCD04'      WFldNmXAr(WIx)
 
     C                   WHEN      Wx = 5
     C                   MOVE      'W'           OKCD05
     C                   MOVEL     'DDCD05'      WFldNmXAr(WIx)
 
     C                   WHEN      Wx = 6
     C                   MOVE      'W'           OKCD06
     C                   MOVEL     'DDCD06'      WFldNmXAr(WIx)
 
     C                   WHEN      Wx = 7
     C                   MOVE      'W'           OKCD07
     C**********         MOVE      'DDCD07'      WFldNmXAr(WIx)                             AR826623
     C                   MOVEL     'DDCD07'      WFldNmXAr(WIx)                             AR826623
 
     C                   WHEN      Wx = 8
     C                   MOVE      'W'           OKCD08
     C                   MOVEL     'DDCD08'      WFldNmXAr(WIx)
 
     C                   WHEN      Wx = 9
     C                   MOVE      'W'           OKCD09
     C                   MOVEL     'DDCD09'      WFldNmXAr(WIx)
 
     C                   WHEN      Wx = 10
     C                   MOVE      'W'           OKCD10
     C                   MOVEL     'DDCD10'      WFldNmXAr(WIx)
 
     C                   WHEN      Wx = 11
     C                   MOVE      'W'           OKCD11
     C                   MOVEL     'DDCD11'      WFldNmXAr(WIx)
 
     C                   WHEN      Wx = 12
     C                   MOVE      'W'           OKCD12
     C                   MOVEL     'DDCD12'      WFldNmXAr(WIx)
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCPNRTERR - Select on Coupon Rate Field Error               *
      *                                                               *
      *****************************************************************
     C     SRCpnRtErr    BEGSR
 
     C                   SELECT
 
     C                   WHEN      Wx = 1
     C                   MOVE      'N'           OKCR01
     C                   MOVEL     'DDCR01'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 2
     C                   MOVE      'N'           OKCR02
     C                   MOVEL     'DDCR02'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 3
     C                   MOVE      'N'           OKCR03
     C                   MOVEL     'DDCR03'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 4
     C                   MOVE      'N'           OKCR04
     C                   MOVEL     'DDCR04'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 5
     C                   MOVE      'N'           OKCR05
     C                   MOVEL     'DDCR05'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 6
     C                   MOVE      'N'           OKCR06
     C                   MOVEL     'DDCR06'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 7
     C                   MOVE      'N'           OKCR07
     C                   MOVEL     'DDCR07'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 8
     C                   MOVE      'N'           OKCR08
     C                   MOVEL     'DDCR08'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 9
     C                   MOVE      'N'           OKCR09
     C                   MOVEL     'DDCR09'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 10
     C                   MOVE      'N'           OKCR10
     C                   MOVEL     'DDCR10'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 11
     C                   MOVE      'N'           OKCR11
     C                   MOVEL     'DDCR11'      FldNamXAr(IDx)
 
     C                   WHEN      Wx = 12
     C                   MOVE      'N'           OKCR12
     C                   MOVEL     'DDCR12'      FldNamXAr(IDx)
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************                     AR750169
      /EJECT                                                                                AR750169
      *****************************************************************                     AR750169
      *                                                               *                     AR750169
      * SRZLCD - Compute Last Coupon Date                             *                     AR750169
      *                                                               *                     AR750169
      * Called by: Main Program                                       *                     AR750169
      *                                                               *                     AR750169
      * Calls: ZLCD                                                   *                     AR750169
      *                                                               *                     AR750169
      *****************************************************************                     AR750169
      *                                                                                     AR750169
     C     SRZLCD        BEGSR                                                              AR750169
      *                                                                                     AR750169
     C                   CALLB     'ZLCD'                                                   AR750169
     C                   PARM                    ISSD                                       AR750169
     C                   PARM                    ITLD                                       AR750169
     C                   PARM                    FCPN                                       AR750169
     C                   PARM                    MATY                                       AR750169
     C                   PARM                    CDArr                                      AR750169
     C                   PARM                    CRArr                                      AR750169
     C                   PARM                    LCPN                                       AR826623
      *                                                                                     AR750169
      ** Event Control Date                                                                 AR750169
      ** Date Format                                                                        AR750169
      *                                                                                     AR750169
     C                   PARM                    ZECD              5 0                      AR750169
     C                   PARM                    BJDFIN                                     AR750169
      *                                                                                     AR750169
      ** Nominal Currency                                                                   AR750169
      ** Security Investment Type                                                           AR750169
      ** Effect on Holidays on Coupon Dates                                                 AR750169
      *                                                                                     AR750169
     C                   PARM                    NMCY              3                        AR750169
     C                   PARM                    SITP              3                        AR750169
     C                   PARM                    BCNV              1                        AR750169
      *                                                                                     AR826623
      ** Effect on Holidays on Coupon dates                                                 AR826623
      *                                                                                     AR826623
     C                   PARM                    HCY1                                       AR826623
     C                   PARM                    HCY2                                       AR826623
     C                   PARM                    HCY3                                       AR826623
     C                   PARM                    HCY4                                       AR826623
     C                   PARM                    HCY5                                       AR826623
     C                   PARM                    HCY6                                       AR826623
     C                   PARM                    HCY7                                       AR826623
     C                   PARM                    HCY8                                       AR826623
     C                   PARM                    HCY9                                       AR826623
      *                                                                                     AR750169
      ** OUTPUTS                                                                            AR750169
      ** Last Coupon Date before Control Date                                               AR750169
      *                                                                                     AR750169
     C                   PARM                    TMLCPN                                     AR750169
      *                                                                                     AR750169
     C                   ENDSR                                                              AR750169
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
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *                                                                                     AR750169
      ** Securities retrieved from file - file format                                       AR750169
      *                                                                                     AR750169
     C                   PARM                    CrSEFilFmt                                 AR750169
      *
      ** Processing type, from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Coupon rate
     C                   PARM                    PCpnRt
      *
      ** Protect coupon rate/days
     C                   PARM                    PPrCpn
      *
      ** STANDING DATA
      ** =============
      *                                                                                     AR750169
      ** SDBANK - Runday number                                                             AR750169
      *                                                                                     AR750169
     C                   PARM                    BJRDNB            5 0                      AR750169
      *
      ** SDBANK - date format indicator
     C                   PARM                    BJDFIN
      *
      ** SWITCHABLE FEATURE
      ** ==================
      *
      ** Effect of holidays on FRN coupon date
     C                   PARM                    CSE005
      *
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
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
(c) Finastra International Limited 2001
**  CTDATA TABMTH/TABDAY     Month No/No of days in month
013102290331043005310630073108310930103111301231
