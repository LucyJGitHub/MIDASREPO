     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities input validation controller 6')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS6VL - Securities Input Validation Controller 6         *
      *                                                               *
      *  Function: This module validates Securities fields for        *
      *            Screen 6 input into the Midas database.            *
      *                                                               *
      *  Component of: SESECSVU                                       *
      *                SESECSCTL                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071  *CREATE    Date 26May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Hook to enable non-core files to be included.
      /COPY WNCPYSRC,SESEC6V001
 
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
 
      ** Securities Screen 6 Details From Incoming Transaction
      ** - Screen Format
     D NwSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)
 
      ** Securities Screen 6 Details Retrieved From File
      ** - Screen Format
     D CrSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)
     D                                     PREFIX(O:1)
 
      ** Securities Details Retrieved From File - File Format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
 
      ** Securities Screen 6 Error Indicators
     D SEESEC6       E DS                  EXTNAME(SEESEC6PD)
 
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
 
      ** Index variables for the Error and Warning Message IDs.
     D MsgID1          S                   LIKE(#MsgID)
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D Ix              S              3P 0
     D WIx             S              3P 0
 
      ** Switchable Features
     D CSE071          S              1A
 
      ** Hook for non-core D-specs (all types) and any I-specs
      ** (if necessary).
      /COPY WNCPYSRC,SESEC6V002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      /COPY WNCPYSRC,SESEC6V003
 
      ** Validate the Holiday Currencies if CSE071 is enabled
      ** and the Security is Interest-Bearing.
 
     C                   IF        (S1STBS = 'P' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7') OR
     C                             (S1STBS = 'Y' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7'  AND
     C                             PPROT <> '9')
 
     C                   IF        CSE071 = 'Y'
 
      /COPY WNCPYSRC,SESEC6V004
      *
      ** Validate Holiday Currency 1
      *
     C                   EXSR      SRVHolCcy1
 
      /COPY WNCPYSRC,SESEC6V005
      *
      ** Validate Holiday Currency 2
      *
     C                   EXSR      SRVHolCcy2
 
      /COPY WNCPYSRC,SESEC6V006
      *
      ** Validate Holiday Currency 3
      *
     C                   EXSR      SRVHolCcy3
 
      /COPY WNCPYSRC,SESEC6V007
      *
      ** Validate Holiday Currency 4
      *
     C                   EXSR      SRVHolCcy4
 
      /COPY WNCPYSRC,SESEC6V008
      *
      ** Validate Holiday Currency 5
      *
     C                   EXSR      SRVHolCcy5
 
      /COPY WNCPYSRC,SESEC6V009
      *
      ** Validate Holiday Currency 6
      *
     C                   EXSR      SRVHolCcy6
 
      /COPY WNCPYSRC,SESEC6V010
      *
      ** Validate Holiday Currency 7
      *
     C                   EXSR      SRVHolCcy7
 
      /COPY WNCPYSRC,SESEC6V011
      *
      ** Validate Holiday Currency 8
      *
     C                   EXSR      SRVHolCcy8
 
      /COPY WNCPYSRC,SESEC6V012
      *
      ** Validate Holiday Currency 9
      *
     C                   EXSR      SRVHolCcy9
 
      /COPY WNCPYSRC,SESEC6V013
 
     C                   ENDIF
 
     C                   ENDIF
 
      /COPY WNCPYSRC,SESEC6V014
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included.
      /COPY WNCPYSRC,SESEC6V015
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVHolCcy1 - Validate Holiday Currency 1                     *
      *                                                               *
      *****************************************************************
     C     SRVHolCcy1    BEGSR
 
      ** Reset the error indicators.
 
     C                   EXSR      SRRstErrInf
 
     C                   CALLB     'SEVSHCCY'
      **                 --------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
      ** Holiay Currency 1
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDHCY1
 
      ** Output Parameters
      ** =================
 
      ** Message ID
      ** Holiday Currency OK Indicator
 
     C                   PARM                    MsgID1
     C                   PARM                    OKHCY1
 
      ** Update the error indicators.
 
     C                   IF        RetCodeOut <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDHCY1'
     C                   EVAL      MsgIDArr(Idx) = MsgID1
 
     C                   ELSE
     C                   EVAL      S1HCY1 = DDHCY1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVHolCcy2 - Validate Holiday Currency 2                     *
      *                                                               *
      *****************************************************************
     C     SRVHolCcy2    BEGSR
 
      ** Reset the error indicators.
 
     C                   EXSR      SRRstErrInf
 
     C                   CALLB     'SEVSHCCY'
      **                 --------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
      ** Holiay Currency 2
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDHCY2
 
      ** Output Parameters
      ** =================
 
      ** Message ID
      ** Holiday Currency OK Indicator
 
     C                   PARM                    MsgID1
     C                   PARM                    OKHCY2
 
      ** Update the error indicators.
 
     C                   IF        RetCodeOut <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDHCY2'
     C                   EVAL      MsgIDArr(Idx) = MsgID1
 
     C                   ELSE
     C                   EVAL      S1HCY2 = DDHCY2
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVHolCcy3 - Validate Holiday Currency 3                     *
      *                                                               *
      *****************************************************************
     C     SRVHolCcy3    BEGSR
 
      ** Reset the error indicators.
 
     C                   EXSR      SRRstErrInf
 
     C                   CALLB     'SEVSHCCY'
      **                 --------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
      ** Holiay Currency 3
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDHCY3
 
      ** Output Parameters
      ** =================
 
      ** Message ID
      ** Holiday Currency OK Indicator
 
     C                   PARM                    MsgID1
     C                   PARM                    OKHCY3
 
      ** Update the error indicators.
 
     C                   IF        RetCodeOut <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDHCY3'
     C                   EVAL      MsgIDArr(Idx) = MsgID1
 
     C                   ELSE
     C                   EVAL      S1HCY3 = DDHCY3
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVHolCcy4 - Validate Holiday Currency 4                     *
      *                                                               *
      *****************************************************************
     C     SRVHolCcy4    BEGSR
 
      ** Reset the error indicators.
 
     C                   EXSR      SRRstErrInf
 
     C                   CALLB     'SEVSHCCY'
      **                 --------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
      ** Holiay Currency 4
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDHCY4
 
      ** Output Parameters
      ** =================
 
      ** Message ID
      ** Holiday Currency OK Indicator
 
     C                   PARM                    MsgID1
     C                   PARM                    OKHCY4
 
      ** Update the error indicators.
 
     C                   IF        RetCodeOut <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDHCY4'
     C                   EVAL      MsgIDArr(Idx) = MsgID1
 
     C                   ELSE
     C                   EVAL      S1HCY4 = DDHCY4
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVHolCcy5 - Validate Holiday Currency 5                     *
      *                                                               *
      *****************************************************************
     C     SRVHolCcy5    BEGSR
 
      ** Reset the error indicators.
 
     C                   EXSR      SRRstErrInf
 
     C                   CALLB     'SEVSHCCY'
      **                 --------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
      ** Holiay Currency 5
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDHCY5
 
      ** Output Parameters
      ** =================
 
      ** Message ID
      ** Holiday Currency OK Indicator
 
     C                   PARM                    MsgID1
     C                   PARM                    OKHCY5
 
      ** Update the error indicators.
 
     C                   IF        RetCodeOut <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDHCY5'
     C                   EVAL      MsgIDArr(Idx) = MsgID1
 
     C                   ELSE
     C                   EVAL      S1HCY5 = DDHCY5
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVHolCcy6 - Validate Holiday Currency 6                     *
      *                                                               *
      *****************************************************************
     C     SRVHolCcy6    BEGSR
 
      ** Reset the error indicators.
 
     C                   EXSR      SRRstErrInf
 
     C                   CALLB     'SEVSHCCY'
      **                 --------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
      ** Holiay Currency 6
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDHCY6
 
      ** Output Parameters
      ** =================
 
      ** Message ID
      ** Holiday Currency OK Indicator
 
     C                   PARM                    MsgID1
     C                   PARM                    OKHCY6
 
      ** Update the error indicators.
 
     C                   IF        RetCodeOut <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDHCY6'
     C                   EVAL      MsgIDArr(Idx) = MsgID1
 
     C                   ELSE
     C                   EVAL      S1HCY6 = DDHCY6
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVHolCcy7 - Validate Holiday Currency 7                     *
      *                                                               *
      *****************************************************************
     C     SRVHolCcy7    BEGSR
 
      ** Reset the error indicators.
 
     C                   EXSR      SRRstErrInf
 
     C                   CALLB     'SEVSHCCY'
      **                 --------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
      ** Holiay Currency 7
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDHCY7
 
      ** Output Parameters
      ** =================
 
      ** Message ID
      ** Holiday Currency OK Indicator
 
     C                   PARM                    MsgID1
     C                   PARM                    OKHCY7
 
      ** Update the error indicators.
 
     C                   IF        RetCodeOut <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDHCY7'
     C                   EVAL      MsgIDArr(Idx) = MsgID1
 
     C                   ELSE
     C                   EVAL      S1HCY7 = DDHCY7
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVHolCcy8 - Validate Holiday Currency 8                     *
      *                                                               *
      *****************************************************************
     C     SRVHolCcy8    BEGSR
 
      ** Reset the error indicators.
 
     C                   EXSR      SRRstErrInf
 
     C                   CALLB     'SEVSHCCY'
      **                 --------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
      ** Holiay Currency 8
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDHCY8
 
      ** Output Parameters
      ** =================
 
      ** Message ID
      ** Holiday Currency OK Indicator
 
     C                   PARM                    MsgID1
     C                   PARM                    OKHCY8
 
      ** Update the error indicators.
 
     C                   IF        RetCodeOut <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDHCY8'
     C                   EVAL      MsgIDArr(Idx) = MsgID1
 
     C                   ELSE
     C                   EVAL      S1HCY8 = DDHCY8
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVHolCcy9 - Validate Holiday Currency 9                     *
      *                                                               *
      *****************************************************************
     C     SRVHolCcy9    BEGSR
 
      ** Reset the error indicators.
 
     C                   EXSR      SRRstErrInf
 
     C                   CALLB     'SEVSHCCY'
      **                 --------------------
 
      ** Input Parameters
      ** ================
 
      ** Return Code
      ** Holiay Currency 9
 
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDHCY9
 
      ** Output Parameters
      ** =================
 
      ** Message ID
      ** Holiday Currency OK Indicator
 
     C                   PARM                    MsgID1
     C                   PARM                    OKHCY9
 
      ** Update the error indicators.
 
     C                   IF        RetCodeOut <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDHCY9'
     C                   EVAL      MsgIDArr(Idx) = MsgID1
 
     C                   ELSE
     C                   EVAL      S1HCY9 = DDHCY9
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
 
      ** Securities Screen 6 Details From Incoming Transaction
      ** - Screen Format
     C                   PARM                    NwSE6ScnFmt
 
      ** Securities Screen 6 Details Retrieved From File
      ** - Screen Format
     C                   PARM                    CrSE6ScnFmt
 
      ** Securities Detail Retrieved From File - File Format
     C                   PARM                    CrSEFilFmt
 
      ** Processing Type
     C                   PARM                    PPROT
 
      ** Switchable Features:
 
      ** Multiple Holidays
     C                   PARM                    CSE071
 
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
 
      ** Securities Screen 6%Error Indicators
     C                   PARM                    SEESEC6
 
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
      /COPY WNCPYSRC,SESEC6V016
 
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
(c) Misys International Banking Systems Ltd. 2005
