     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate interest rate calendar amounts')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS ILE Module                                   *
      *                                                               *
      *  IRVIRCAMT - Validate Interest Rate Calendar Amounts          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Function:  This module validates interest rate calendar      *
      *             amounts (Cash Flow and Principal Change).         *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CAP043   *CREATE   Date 02May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
     D WFldNmAlp       C                   CONST('SAMT')
     D WFldNmAlp2      C                   CONST('SIND')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** Amounts (14chars) received from calling module
     D AmountIn1DS     DS
     D  SAmt1                        14A   DIM(82) INZ(*BLANKS) ASCEND
 
      ** Amounts (16chars) received from calling module
     D AmountIn2DS     DS
     D  SAmt2                        16A   DIM(82) INZ(*BLANKS) ASCEND
 
      ** Output amount
  109D OutAmt1DS       DS
     D  WDummy1                1    267
     D  WOutAmt1                     13P 0 DIM(82) INZ(*ZEROS)
     D  WAmt1Char            268    841
 
      ** Output amount
  109D OutAmt2DS       DS
     D  WDummy2                1    267
     D  WOutAmt2                     15P 0 DIM(82) INZ(*ZEROS)
     D  WAmt2Char            268    923
 
      ** Work amount field
     D WAmount         DS
     D WAmount14               1     14A
     D WAmount16               1     16A
 
      ** Increase/Decrease indicator received from calling module
     D IncDecIndDS     DS
     D  IDInd                         1A   DIM(82) INZ(*BLANKS) ASCEND
 
      ** Currency Details Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Data Structure used by Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Amounts to be validated (max 82)
     D PAmount1        S           1148A
 
      ** Amounts to be validated (max 82)
     D PAmount2        S           1312A
 
      ** Output amounts
     D PNAmount1       S            574A
     D PNAmount2       S            656A
 
      ** Work fields for Amounts to be validated
     D X               S              2P 0
     D Y               S              2P 0
     D WFldNmNum       S              2A
     D PZALIGNOK       S              1A
     D PZFIELD         S             16A
     D PZADIG          S              2  0
     D PZADEC          S              1  0
     D PCURR           S              3A
     D PCurrency       S              3A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PIncDecInd      S             82A
     D PValType        S              1A
     D PBGN2ST         S              1A
     D WZAmount        S             16S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
 
      ** Initialization
 
     C                   CLEAR                   WAmount
     C                   CLEAR                   OutAmt1DS
     C                   CLEAR                   OutAmt2DS
     C                   EVAL      ErrorFound = 'N'
     C                   EVAL      RetCodeIn = *BLANK
     C                   EVAL      X = 1
     C                   EVAL      Y = 1
 
      ** Access currency details to get the number of decimal places using the
      ** received parameter
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PCurrency     PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCURR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      PValType = 'C'
     C                   EVAL      PZADIG = 13 - A6NBDP
     C                   MOVEL     PAmount1      AmountIn1DS
     C     *BLANKS       LOOKUP    SAmt1(X)                               40
 
     C                   WHEN      PValType = 'P'
     C                   EVAL      PZADIG = 15 - A6NBDP
     C                   MOVEL     PAmount2      AmountIn2DS
     C                   MOVEL     PIncDecInd    IncDecIndDS
     C     *BLANKS       LOOKUP    SAmt2(X)                               40
     C                   IF        PBGN2ST = 'Y'
     C     *BLANKS       LOOKUP    IDInd(Y)                               41
     C                   ENDIF
 
     C                   ENDSL
 
     C                   EVAL      PZADEC = A6NBDP
 
      ** If blank element found check further for non blank elements
      ** If any found then embedded blanks exist so report error and
      ** skip further processing (amount)
 
     C                   IF        *IN40 = *ON
 
      ** Save array number of the blank element to be use later
 
     C                   MOVE      X             WFldNmNum
 
     C                   EVAL      *IN40 = *OFF
 
     C                   SELECT
     C                   WHEN      PValType = 'C'
     C     *BLANKS       LOOKUP    SAmt1(X)                           40
     C                   WHEN      PValType = 'P'
     C     *BLANKS       LOOKUP    SAmt2(X)                           40
     C                   ENDSL
 
     C                   IF        *IN40 = *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDArr(Idx) = 'DLM1019'
     C                   EVAL      FldNameArr(Idx) = WFldNmAlp + WFldNmNum
     C                   GOTO      ErrorTag
     C                   ENDIF
     C                   ENDIF
 
      ** If blank element found check further for non blank elements
      ** If any found then embedded blanks exist so report error and
      ** skip further processing (increase/decrease)
 
     C                   IF        (*IN41 = *ON) AND (PBGN2ST = 'Y') AND
     C                             (PValType = 'P')
 
      ** Save array number of the blank element to be use later
 
     C                   MOVE      Y             WFldNmNum
 
     C                   EVAL      *IN41 = *OFF
 
     C     *BLANKS       LOOKUP    IDInd(Y)                           41
 
     C                   IF        *IN41 = *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDArr(Idx) = 'DLM1020'
     C                   EVAL      FldNameArr(Idx) = WFldNmAlp2 + WFldNmNum
     C                   GOTO      ErrorTag
     C                   ENDIF
     C                   ENDIF
 
      ** Validate each non-blank element until either
      ** a) a blank amount is encountered or
      ** b) 10 errors have been found or
      ** c) all 82 amounts have been processed
 
     C                   EVAL      X = 1
 
     C                   SELECT
     C                   WHEN      PValType = 'C'
     C                   MOVEA     SAmt1(X)      WAmount14
     C                   WHEN      PValType = 'P'
     C                   MOVEA     SAmt2(X)      WAmount16
     C                   ENDSL
 
     C                   DOW       (WAmount <> *BLANK) AND (Idx < 10) AND
     C                             (X < 83)
     C                   EXSR      SRValidate
     C                   ENDDO
 
      ** If no errors found write the array of valid amounts to the
      ** output parameter, after filling any remaining array elements
      ** with zeros
 
     C                   IF        ErrorFound = 'N'
 
     C                   DOW       X < 83
     C                   SELECT
     C                   WHEN      PValType = 'C'
     C                   Z-ADD     *ZEROS        WOutAmt1(X)
     C                   WHEN      PValType = 'P'
     C                   Z-ADD     *ZEROS        WOutAmt2(X)
     C                   ENDSL
     C                   EVAL      X = X + 1
     C                   ENDDO
 
     C                   SELECT
     C                   WHEN      PValType = 'C'
     C                   MOVE      WAmt1Char     PNAmount1
     C                   WHEN      PValType = 'P'
     C                   MOVE      WAmt2Char     PNAmount2
     C                   ENDSL
 
     C                   ENDIF
 
     C     ErrorTag      TAG
 
      ** Error found, set return code parameter
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Amount and Increase/Decrease Ind.       *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
 
      ** Save array number of the blank element to be use later
 
     C                   MOVE      X             WFldNmNum
 
      ** Check amount if numeric
 
     C                   MOVE      WAmount       PZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZALIGNOK
     C                   PARM                    PZFIELD
     C                   PARM                    PZADEC
     C                   PARM                    PZADIG
 
      ** Amount not valid
 
     C                   IF        (PZALIGNOK = 'N') OR (PZFIELD = *ALL'0')
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDArr(Idx) = 'DLM0149'
     C                   EVAL      FldNameArr(Idx) = WFldNmAlp + WFldNmNum
     C                   GOTO      ValidEnd
     C                   ENDIF
 
      ** Invalid Increase/Decrease indicator (must be 'I' or 'D')
 
     C                   IF        (PValType = 'P') AND (PBGN2ST = 'Y')
     C                   IF        (IDInd(X) <> 'I') AND (IDInd(X) <> 'D') AND
     C                             (IDInd(X) <> *BLANK)
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDArr(Idx) = 'DLM1021'
     C                   EVAL      FldNameArr(Idx) = WFldNmAlp2 + WFldNmNum
     C                   GOTO      ValidEnd
     C                   ENDIF
     C                   ENDIF
 
     C     ValidEnd      TAG
 
      ** If no error, move amount to a numeric field
 
     C                   IF        ErrorFound = 'N'
     C                   MOVE      PZFIELD       WZAmount
     C                   SELECT
     C                   WHEN      PValType = 'C'
     C                   Z-ADD     WZAmount      WOutAmt1(X)
     C                   WHEN      PValType = 'P'
     C                   Z-ADD     WZAmount      WOutAmt2(X)
     C                   ENDSL
     C                   ENDIF
 
      ** Read in the next amount if less than maximum (82)
 
     C                   EVAL      X = X + 1
 
     C                   IF        (X <= 82)
     C                   SELECT
     C                   WHEN      PValType = 'C'
     C                   MOVEA     SAmt1(X)      WAmount14
     C                   WHEN      PValType = 'P'
     C                   MOVEA     SAmt2(X)      WAmount16
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PBGN2ST
     C                   PARM                    PValType
     C                   PARM                    PCurrency
     C                   PARM                    PAmount1
     C                   PARM                    PAmount2
     C                   PARM                    PIncDecInd
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    PNAmount1
     C                   PARM                    PNAmount2
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
