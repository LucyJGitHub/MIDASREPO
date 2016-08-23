     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities amend checking for screen 5')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS5MD - Securities Amend Checking for Screen 5           *
      *                                                               *
      *  Function: This module compares the fields of an amended      *
      *            Security Detail against those currently on         *
      *            file. This program also checks whether all fields  *
      *            amended are amendable, and if not, an error        *
      *            message will be sent to calling module.            *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD000091           Date 17May13               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    71         Interest-Bearing Security Indicator             *
      *    72         Complete Security Indicator                     *
      *                                                               *
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
 
      ** Securities Screen 5 Details From Incoming Transaction
      ** - Screen Format
     D NwSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)
     D                                     PREFIX(A)
 
      ** Securities Screen 5 Details Retrieved From File
      ** - Screen Format
     D CrSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)
 
      ** Securities Details Retrieved From File - File Format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
 
      ** Securities Details From Incoming Transaction - File Format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
 
      ** Securities Screen 5 Error Indicators
     D SEESEC5       E DS                  EXTNAME(SEESEC5PD)
 
      ** Input Rate Array
     D IRATE           S             17A   DIM(2)
 
      ** Output Rate Array
     D ORATE           S             15P 8 DIM(2)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PRetCde         S             10A
     D PPROT           S              1A
     D PResFld         S              1A
     D Idx             S              3P 0
     D PAmdOK          S              1A
 
      ** Switchable Features
     D CAS006          S              1A
 
      ** SEVPCSPDRT Parameters
     D PRetCode        S              7A
     D PFldName        S             10A
     D PSpdRate        S             17A
     D PValSpdRate     S             15P 8
     D PSpdRateOK      S              1A
 
      ** Working Variables
     D WChgFlg         S              1A
     D WCtr            S              2P 0
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Check if the non-amendable fields have been amended.
 
     C                   EXSR      SRAmdChk
 
      ** Set the Amend OK Flag to 'N' if errors were found.
 
     C                   IF        Idx > 0
     C                   EVAL      PAmdOK = 'N'
     C                   ELSE
     C                   EVAL      PAmdOK = 'Y'
     C                   ENDIF
 
      ** Reset all fields in error if necessary.
 
     C                   IF        Idx > 0 AND
     C                             PResFld = 'Y'
     C                   EXSR      SRResFld
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmdChk - Checks whether non-amendable fields have been     *
      *             amended or not.                                   *
      *                                                               *
      *****************************************************************
     C     SRAmdChk      BEGSR
 
     C                   EXSR      SRSetInd
 
      ** Check the Coupon Rate Credit Risk Spread and Coupon Rate
      ** Liquidity Premium display fields if CAS006 is enabled.
 
     C                   IF        CAS006 = 'Y'
 
     C                   IF        *IN71 = *OFF OR
     C                             *IN72 = *ON
 
      ** Credit Risk Spread is not amendable.
 
     C                   EVAL      IRATE(1) = DDCCRK
     C                   EVAL      IRATE(2) = ADDCCRK
     C                   EXSR      SRChkRt
 
     C                   IF        WChgFlg = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDCCRK'
     C                   EVAL      MsgIdArr(Idx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(Idx) = 'Credit Risk Spread'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Credit Risk Spread'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCCRK = 'N'
     C                   ENDIF
 
      ** Liquidity Premium is not amendable.
 
     C                   EVAL      IRATE(1) = DDCLQP
     C                   EVAL      IRATE(2) = ADDCLQP
     C                   EXSR      SRChkRt
 
     C                   IF        WChgFlg = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDCLQP'
     C                   EVAL      MsgIdArr(Idx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(Idx) = 'Liquidity Premium'                     MD000091
     C                   EVAL      MsgDtaTmp = 'Liquidity Premium'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCLQP = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkRt - Checks whether a certain rate has been amended     *
      *            or not.                                            *
      *                                                               *
      *****************************************************************
     C     SRChkRt       BEGSR
 
     C                   EVAL      WChgFlg = 'N'
 
     C                   FOR       WCtr = 1 TO %ELEM(IRATE)
 
     C                   EVAL      PSpdRate = IRATE(WCtr)
     C                   EXSR      SRCvtRt
     C                   EVAL      ORATE(WCtr) = PValSpdRate
 
     C                   ENDFOR
 
     C                   IF        ORATE(1) <> ORATE(2)
     C                   EVAL      WChgFlg = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtRt - Converts string rates into numerical rates via     *
      *            SEVPCSPDRT.                                        *
      *                                                               *
      *****************************************************************
     C     SRCvtRt       BEGSR
 
     C                   CALLB     'SEVPCSPDRT'
      **                 ---------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
      ** Field Name
      ** Spread Rate
 
     C                   PARM      *BLANKS       PRetCode
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetInd - Sets conditioning indicators.                     *
      *                                                               *
      *****************************************************************
     C     SRSetInd      BEGSR
 
      ** Reset all relevant indicators.
 
     C                   EVAL      *IN71 = *OFF
     C                   EVAL      *IN72 = *OFF
 
      ** Determine if the Security is Interest-Bearing.
 
     C                   IF        (S1STBS = 'P' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7') OR
     C                             (S1STBS = 'Y' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7' AND
     C                             PPROT <> '9')
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
 
      ** Return to the calling program if CAS006 is not enabled or the
      ** Security is not Interest-Bearing.
 
     C                   IF        CAS006 <> 'Y' OR
     C                             *IN71 = *OFF
     C                   RETURN
     C                   ENDIF
 
      ** Determine if the Security is complete.
 
     C                   IF        INCS = 'C'
     C                   EVAL      *IN72 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResFld - Resets all fields in error.                       *
      *                                                               *
      *****************************************************************
     C     SRResFld      BEGSR
 
     C                   IF        CAS006 = 'Y' AND
     C                             *IN71 = *ON
 
      ** Credit Risk Spread.
 
     C                   IF        OKCCRK = 'N'
     C                   EVAL      ADDCCRK = DDCCRK
     C                   ENDIF
 
      ** Liquidity Premium.
 
     C                   IF        OKCLQP = 'N'
     C                   EVAL      ADDCLQP = DDCLQP
     C                   ENDIF
 
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
 
      ** Return Code
     C                   PARM                    PRetCde
 
      ** Securities Screen 5 Details From Incoming Transaction
      ** - Screen Format
     C                   PARM                    NwSE5ScnFmt
 
      ** Securities Screen 5 Details Retrieved From File
      ** - Screen Format
     C                   PARM                    CrSE5ScnFmt
 
      ** Securities Details From Incoming Transaction - File Format
     C                   PARM                    NwSEFilFmt
 
      ** Securities Details Retrieved from File - File Format
     C                   PARM                    CrSEFilFmt
 
      ** Investment Processing Type
     C                   PARM                    PPROT
 
      ** Reset of Fields Flag
     C                   PARM                    PResFld
 
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
 
      ** Securities Screen 5 Error Indicators
     C                   PARM                    SEESEC5
 
      ** Amend OK Flag
     C                   PARM                    PAmdOK
 
      ** End Parameter List
      ** ==================
 
      **---------------------------------------------------------------
      ** The following /COPY line sets the Program, Module, and
      ** Procedure names for Database Error Processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
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
** CPY@
(c) Misys International Banking Systems Ltd. 2003
