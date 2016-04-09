     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate ISIN/common code')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSISNCD - Validate ISIN/Common Code                        *
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
      *  Last Amend No. MD000091           Date 15May13               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL014             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
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
      ** Securities by ISIN number
     FSECTYL1   IF   E           K DISK    INFSR(*PSSR)
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
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
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
      ** Work variables
     D WFound          S              1A
     D WISIN           S             12A
     D WIS1            S              1    DIM(12)
     D WIS2            S              1    DIM(12)
     D WWEOSF          S              1A
     D WI              S              2P 0
     D WJ              S              2P 0
      *
      ** Work array for all alphanumerics and blank
     D WAlpha1         S              1    DIM(37) CTDATA PERRCD(37)
      *
      ** Work array for all alphanumerics excluding blank
     D WAlpha2         S              1    DIM(36) CTDATA PERRCD(36)
      *
      ** Switchable feature
     D CSE011          S              1A
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
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
      *
      ** Validate isin/common code
      *
     C                   EXSR      SRValISIN
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKISIN <> 'Y'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKISIN <> 'N'
     C                   MOVEL     DDISIN        S1ISIN
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALISIN - Validation for ISIN/Common Code                  *
      *                                                               *
      *****************************************************************
     C     SRValISIN     BEGSR
      *
      ** Set off validation indicator.
     C                   MOVE      *OFF          *IN01
      *
      ** If the security for isin/common is not blank.
      *
     C                   IF        DDISIN <> *BLANKS
      *
      ** Initialise values used in validation processing.
     C                   MOVE      *OFF          *IN02
     C                   MOVE      'N'           WWEOSF
     C                   Z-ADD     0             WI
     C                   Z-ADD     0             WJ
     C                   MOVEA     DDISIN        WIS1
     C                   MOVEA     *Blanks       WIS2
 
     C                   DOW       WI <= 11 AND
     C                             *IN01 = *OFF
     C                   ADD       1             WI
      *
      ** Check if characters are in array alpha1 (0..9,A..Z,BLANK).
     C     WIS1(WI)      LOOKUP    WAlpha1                                02
      *
      ** If character is not found.
      *
     C                   IF        *IN02 = *OFF
     C                   MOVE      *ON           *IN01
     C                   ELSE
      *
      ** Check if characters are in array alpha2 (0..9,A..Z).
     C     WIS1(WI)      LOOKUP    WAlpha2                                02
      *
      ** If character is found.
     C                   IF        *IN02 = *ON
 
     C                   IF        WWEOSF = 'N'
     C                   ADD       1             WJ
     C                   MOVEA     WIS1(WI)      WIS2(WJ)
     C                   ELSE
     C                   MOVE      *ON           *IN01
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        WJ > 0
     C                   MOVE      'Y'           WWEOSF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
      *
      ** If security code for isin/common is invalid.
     C                   IF        *IN01 = *ON
     C                   MOVE      'N'           OKISIN
     C                   ADD       1             IDx
     C                   MOVEL     'DDISIN'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0136'     MsgIdXAr(IDx)
     C                   ELSE
      *
      ** Else store screen field with leading blanks removed.
     C                   MOVEA     WIS2          DDISIN
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Feature CSE011 is installed
      *
     C                   IF        CSE011 = 'Y'
      *
      ** Check if ISIN number already exists in securities file
     C                   IF        DDISIN <> *BLANK
 
     C                   MOVE      DDISIN        WISIN
     C                   EVAL      WFound = 'N'
     C     WISIN         SETLL     SECTYL1
     C     WISIN         READE     SECTYL1                                03
 
     C                   DOW       *IN03 = *OFF AND
     C                             WFound = 'N'
      *
      ** Check if security shortname is different
     C                   IF        DDSESN <> SESN
     C                   EVAL      WFound = 'Y'
     C                   ENDIF
 
     C     WISIN         READE     SECTYL1                                03
     C                   ENDDO
      *
      ** Isin no. already exist in security file, send warning message
      *
     C                   IF        WFound = 'Y'
     C                   MOVE      'W'           OKISIN
     C                   ADD       1             WIx
     C                   MOVEL     'DDISIN'      WFldNmXAr(WIx)
     C**********         MOVEL     'SEA0252'     WMsgIdXAr(WIx)                             MD000091
     C                   EVAL      WMsgDtXAr(WIx) = ISIN + SESN + '(' +                     MD000091
     C                                              SRPN + ')'                              MD000091
     C                   EVAL      BLen = %Len(%Trim(ISIN))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(ISIN)                     MD000091
     C                   EVAL      BLen = %Len(%Trim(SESN))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %Trim(WMsgDtXAr(WIx))                   MD000091
     C                                            + LenStr +%TRIM(SESN)                     MD000091
     C                   EVAL      MsgDtaTmp = '(' + SRPN + ')'                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %Trim(WMsgDtXAr(WIx))                   MD000091
     C                                            + LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** SWITCHABLE FEATURE
      ** ==================
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
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
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
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
(c) Misys International Banking Systems Ltd. 2001
** CTDATA  WAlpha1
0123456789 ABCDEFGHIJKLMNOPQRSTUVWXYZ
** CTDATA  WAlpha2
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
