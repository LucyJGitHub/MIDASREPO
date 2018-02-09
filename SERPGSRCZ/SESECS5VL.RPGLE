     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities input validation controller 5')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS5VL - Securities Input Validation Controller 5         *
      *                                                               *
      *  Function: This module validates Securities fields for        *
      *            Screen 5 input into the Midas database.            *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241976             Date 04Oct06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL014             Date 20Oct03               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  241976 - Applied fix 232920.  Zero Net Treasury Rate (Coupon *
      *           Rate +/- Credit Risk Spread +/- Liquidity Premium)  *
      *           should be allowed.                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Hook to enable non-core files to be included.
      /COPY WNCPYSRC,SKFFFFV001
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the Copyright Array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for Error
      ** and Warning Message Arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended Error Arrays, including the named constant giving
      ** the size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Securities Screen 1 Details From Incoming Transaction
      ** - Screen Format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
 
      ** Securities Screen 1 Details Retrieved From File
      ** - Screen Format
     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(O)
 
      ** Securities Screen 5 Details From Incoming Transaction
      ** - Screen Format
     D NwSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)
 
      ** Securities Screen 5 Details Retrieved From File
      ** - Screen Format
     D CrSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)
     D                                     PREFIX(O:1)
 
      ** Securities Details Retrieved From File - File Format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
 
      ** Securities Screen 5 Error Indicators
     D SEESEC5       E DS                  EXTNAME(SEESEC5PD)
 
      ** Securities Details For File Update - File Format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PMode           S              6A
     D PRespMode       S              1A
     D PPROT           S              1A
 
      ** SEVPCSPDRT Parameters
     D PRetCde         S              7A
     D PFldName        S             10A
     D PSpdRate        S             17A
     D PValSpdRate     S             15P 8
     D PSpdRateOK      S              1A
 
      ** Index variables for the Error and Warning Message IDs.
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D Ix              S              3P 0
     D WIx             S              3P 0
     D WUSpdRt         S                   LIKE(PValSpdRate)
 
      ** Switchable Features
     D CAS006          S              1A
 
      ** +--------------------------------------+
      ** ¦ Prototype Declarations               ¦
      ** ¦ ======================               ¦
      ** +--------------------------------------+
 
      ** Spread Rate Overflow Monitor
     D SPSpdRtOvf      PR             1A
     D  PSpdRt                       15P 8 VALUE
 
      ** Spread Rate Significant Decimal Positions Calculator
     D SPGetSpdRtDP    PR             2P 0
     D  PSpdRt                       16A   VALUE
 
      ** Hook for non-core D-specs (all types) and any I-specs
      ** (if necessary).
      /COPY WNCPYSRC,SKFFFFV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      /COPY WNCPYSRC,SKFFFFV003
      /COPY WNCPYSRC,SKFFFFV004
 
      ** Validate the Coupon Rate Credit Risk Spread, Coupon Rate
      ** Liquidity Premium, and Net-Treasury-Rate fields if CAS006
      ** is enabled and the Security is Interest-Bearing.
 
     C                   IF        (S1STBS = 'P' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7') OR
     C                             (S1STBS = 'Y' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7'  AND
     C                             PPROT <> '9')
 
     C                   IF        CAS006 = 'Y'
      /COPY WNCPYSRC,SKFFFFV005
     C                   EXSR      SRVCdtRsk
      /COPY WNCPYSRC,SKFFFFV006
      /COPY WNCPYSRC,SKFFFFV007
     C                   EXSR      SRVLqPrem
      /COPY WNCPYSRC,SKFFFFV008
      /COPY WNCPYSRC,SKFFFFV009
     C                   EXSR      SRVNtTrRt
      /COPY WNCPYSRC,SKFFFFV010
     C                   ENDIF
 
     C                   ENDIF
 
      /COPY WNCPYSRC,SKFFFFV011
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included.
      /COPY WNCPYSRC,SKFFFFV012
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCdtRsk - Validates the Coupon Rate Credit Risk Spread.    *
      *                                                               *
      *****************************************************************
     C     SRVCdtRsk     BEGSR
 
      ** Reset the error indicators.
 
     C                   EXSR      SRRstErrInf
 
      ** Set the Spread Rate to the Coupon Rate Credit Risk Spread.
 
     C                   EVAL      PSpdRate = DDCCRK
 
     C                   EVAL      PFldName = 'DDCCRK'
 
     C                   CALLB     'SEVPCSPDRT'
      **                 ---------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
      ** Field Name
      ** Spread Rate
 
     C                   PARM      *BLANKS       PRetCde
     C                   PARM                    PFldName
     C                   PARM                    PSpdRate
 
      ** Output Parameters
      ** =================
 
      ** Error Fields/Message IDs/Message Data (Arrays) From/To Caller
      ** Validated Spread Rate
      ** Spread Rate OK Indicator
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    PValSpdRate
     C                   PARM                    PSpdRateOK
 
      ** Update the error indicators.
 
     C                   IF        PRetCde <> *BLANKS
     C                   EXSR      SRUpdErrInf
     C                   ELSE
 
      ** Check for storage overflow.
 
     C                   EVAL      WUSpdRt = %ABS(PValSpdRate)
 
     C                   IF        SPSpdRtOvf(WUSpdRt) = 'Y'
     C                   EVAL      PValSpdRate = *ZERO
     C                   EVAL      PSpdRateOK = 'N'
     C                   EXSR      SRUpdErrInf
     C                   ELSE
     C                   EVALR     DDCCRK = %TRIM(DDCCRK)
     C                   ENDIF
 
     C                   ENDIF
 
      ** Receive the Validated Spread Rate and the Spread Rate OK
      ** Indicator.
 
     C                   EVAL      S1CCRK = PValSpdRate
     C                   EVAL      OKCCRK = PSpdRateOK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVLqPrem - Validates the Coupon Rate Liquidity Premium.      *
      *                                                               *
      *****************************************************************
     C     SRVLqPrem     BEGSR
 
      ** Reset the error indicators.
 
     C                   EXSR      SRRstErrInf
 
      ** Set the Spread Rate to the Coupon Rate Liquidity Premium.
 
     C                   EVAL      PSpdRate = DDCLQP
 
     C                   EVAL      PFldName = 'DDCLQP'
 
     C                   CALLB     'SEVPCSPDRT'
      **                 ---------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
      ** Field Name
      ** Spread Rate
 
     C                   PARM      *BLANKS       PRetCde
     C                   PARM                    PFldName
     C                   PARM                    PSpdRate
 
      ** Output Parameters
      ** =================
 
      ** Error Fields/Message IDs/Message Data (Arrays) From/To Caller
      ** Validated Spread Rate
      ** Spread Rate OK Indicator
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    PValSpdRate
     C                   PARM                    PSpdRateOK
 
      ** Update the error indicators.
 
     C                   IF        PRetCde <> *BLANKS
     C                   EXSR      SRUpdErrInf
     C                   ELSE
 
      ** Check for storage overflow.
 
     C                   EVAL      WUSpdRt = %ABS(PValSpdRate)
 
     C                   IF        SPSpdRtOvf(WUSpdRt) = 'Y'
     C                   EVAL      PValSpdRate = *ZERO
     C                   EVAL      PSpdRateOK = 'N'
     C                   EXSR      SRUpdErrInf
     C                   ELSE
     C                   EVALR     DDCLQP = %TRIM(DDCLQP)
     C                   ENDIF
 
     C                   ENDIF
 
      ** Receive the Validated Spread Rate and the Spread Rate OK
      ** Indicator.
 
     C                   EVAL      S1CLQP = PValSpdRate
     C                   EVAL      OKCLQP = PSpdRateOK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVNtTrRt - Validates the Net-Treasury-Rate.                 *
      *                                                               *
      *****************************************************************
     C     SRVNtTrRt     BEGSR
 
      ** Reset the error indicators.
 
     C                   EXSR      SRRstErrInf
 
     C                   IF        OKCCRK = 'Y' AND
     C                             OKCLQP = 'Y'
 
     C                   EVAL      S1CPNN = S1CPNR + S1CCRK + S1CLQP
 
     C**********         IF        S1CPNN <= *ZERO                                            241976
     C                   IF        S1CPNN < *ZERO                                             241976
     C                   EVAL      WIx = 1
     C                   EVAL      FldNamXAr(WIx) = 'DDCCRK'
     C                   EVAL      MsgIdXAr(WIx) = 'SEA0525'
     C                   EVAL      MsgDtaXAr(WIx) = %CHAR(S1CPNN)
     C                   EVAL      OKCCRK = 'N'
     C                   EVAL      OKCLQP = 'N'
 
      ** Update the error indicators.
 
     C                   EXSR      SRUpdErrInf
 
     C                   ELSE
     C                   EVALR     DDCCRK = %TRIM(DDCCRK)
     C                   EVALR     DDCLQP = %TRIM(DDCLQP)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRstErrInf - Resets the error information returned by       *
      *                the validation modules.                        *
      *                                                               *
      *****************************************************************
     C     SRRstErrInf   BEGSR
 
      ** Reset the Error and Warning Fields/Message IDs/Message Data
      ** (arrays).
 
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
 
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdErrInf - Updates the global error information with the  *
      *                ones returned by the validation modules.       *
      *                                                               *
      *****************************************************************
     C     SRUpdErrInf   BEGSR
 
      ** Update the Error Fields/Message IDs/Message Data (Arrays).
 
     C                   EVAL      Ix = %LOOKUP(*BLANK :
     C                             FldNameArr : 1)
 
     C                   IF        Ix <> *ZERO
     C                   MOVEA     FldNamXAr     FldNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   ENDIF
 
      ** Set the Error Index.
 
     C                   EVAL      Ix = %LOOKUP(*BLANK :
     C                             FldNameArr : 1)
 
     C                   IF        Ix <> *ZERO
     C                   EVAL      Idx = Ix - 1
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   EVAL      FldNameArr(Ix) = *BLANKS
     C                   EVAL      MsgIDArr(Ix) = *BLANKS
     C                   EVAL      MsgDtaArr(Ix) = *BLANKS
     C                   EVAL      Idx = ArrayMax - 1
     C                   ENDIF
 
      ** Update the Warning Fields/Message IDs/Message Data (Arrays).
 
     C                   EVAL      Ix = %LOOKUP(*BLANK :
     C                             WFldNamArr : 1)
 
     C                   IF        Ix <> *ZERO
     C                   MOVEA     WFldNmXAr     WFldNamArr(Ix)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(Ix)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(Ix)
     C                   ENDIF
 
      ** Set the Warning Index.
 
     C                   EVAL      Ix = %LOOKUP(*BLANK :
     C                             WFldNamArr : 1)
 
     C                   IF        Ix <> *ZERO
     C                   EVAL      WIdx = Ix - 1
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   EVAL      WFldNamArr(Ix) = *BLANKS
     C                   EVAL      WMsgIDArr(Ix) = *BLANKS
     C                   EVAL      WMsgDtaArr(Ix) = *BLANKS
     C                   EVAL      WIdx = ArrayMax - 1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Begin Parameter List
      ** ====================
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      **      = '      ' (Not Front Office Transaction Interface)
      **      = '*RPR  ' (Repair Function)
      **      = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
 
      ** Response Mode
     C                   PARM                    PRespMode
 
      ** Securities Screen 1 Details From Incoming Transaction
      ** - Screen Format
     C                   PARM                    NwSE1ScnFmt
 
      ** Securities Screen 1 Details Retrieved From File
      ** - Screen Format
     C                   PARM                    CrSE1ScnFmt
 
      ** Securities Screen 5 Details From Incoming Transaction
      ** - Screen Format
     C                   PARM                    NwSE5ScnFmt
 
      ** Securities Screen 5 Details Retrieved From File
      ** - Screen Format
     C                   PARM                    CrSE5ScnFmt
 
      ** Securities Detail Retrieved From File - File Format
     C                   PARM                    CrSEFilFmt
 
      ** Processing Type
     C                   PARM                    PPROT
 
      ** Switchable Features:
 
      ** Hedge Accounting Phase B
     C                   PARM                    CAS006
 
      ** Output Parameters
      ** =================
 
      ** Error Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Error Array Index (3P0) From/To Caller
     C                   PARM                    Idx
 
      ** Warning Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Warning Array Index (3P0) From/To Caller
     C                   PARM                    WIdx
 
      ** Securities Screen 5 Error Indicators
     C                   PARM                    SEESEC5
 
      ** Securities Details For File Update - File Format
     C                   PARM                    NwSEFilFmt
 
      ** End Parameter List
      ** ==================
 
      **---------------------------------------------------------------
      ** The following /COPY line sets the Program, Module, and
      ** Procedure names for Database Error Processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
      ** Hook to enable non-core initial processing to be included.
      /COPY WNCPYSRC,SKFFFFV013
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Error-Handling Routines              ¦
      ** ¦ =======================              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the *PSSR subroutine.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Subprocedure Definitions             ¦
      ** ¦ ========================             ¦
      ** +--------------------------------------+
 
      *****************************************************************
      *                                                               *
      *  SPSpdRtOvf - Checks if the value of a 15P 8 Spread Rate can  *
      *               be successfully assigned to a 11P 7 storage.    *
      *                                                               *
      *****************************************************************
     P SPSpdRtOvf      B
     D SPSpdRtOvf      PI             1A
     D  PSpdRt                       15P 8 VALUE
 
      ** Working Variables
     D WRetCde         S              1A   INZ('N')
     D WPSpdRt         S             11P 7
     D WASpdRt         S             16A
 
      ** Catch any exception that the following assignment may raise.
 
     C                   MONITOR
     C                   EVAL      WPSpdRt = PSpdRt
     C                   ON-ERROR  *ALL
     C                   EVAL      WRetCde = 'Y'
     C                   ENDMON
 
      ** Check the number of significant decimal positions.
 
     C                   IF        WRetCde <> 'Y'
     C                   MOVEL     PSpdRt        WASpdRt
     C                   EVAL      WASpdRt = %REPLACE('.' : WASpdRt :
     C                             8 : 0)
     C                   IF        SPGetSpdRtDP(WASpdRt) > 7
     C                   EVAL      WRetCde = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Return an error message if an overflow occurs.
 
     C                   IF        WRetCde = 'Y'
     C                   EVAL      WIx = 1
     C                   EVAL      FldNamXAr(WIx) = 'PCSPDRT'
     C                   EVAL      MsgIdXAr(WIx) = 'SEA0145'
     C                   EVAL      MsgDtaXAr(WIx) = PSpdRate
     C                   ENDIF
 
     C                   RETURN    WRetCde
 
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SPGetSpdRtDP - Gets the number of (significant) decimal      *
      *                 positions in a given Spread Rate.             *
      *                                                               *
      *****************************************************************
     P SPGetSpdRtDP    B
     D SPGetSpdRtDP    PI             2P 0
     D  PSpdRt                       16A   VALUE
 
      ** Working Variables
     D WSpdRt          S             16A
     D WSpdRtDP        S              2P 0
     D WStart          S              2P 0
     D WLength         S              2P 0
 
     C                   IF        PSpdRt <> *BLANKS
 
      ** Search for a decimal point.
 
     C                   EVAL      WStart = %SCAN('.' : PSpdRt)
 
      ** Calculate the number of decimal positions if possible.
 
     C                   IF        WStart > *ZERO
     C                   EVAL      WLength = %CHECKR('0 ' : PSpdRt)
     C                   IF        WLength >= WStart
     C                   EVAL      WSpdRtDP = WLength - WStart
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN    WSpdRtDP
 
     P                 E
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2003
