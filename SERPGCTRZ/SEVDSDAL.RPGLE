     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Average Life Date')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVDSDAL - Validate Average Life Date                        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 233188             Date 04May05               *
      *                 CSE065  *CREATE    Date 08Nov04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  233188 - Disable the validation which compares the newly     *
      *           inserted average life date with the previous one.   *
      *  CSE065 - Constant Yield Amortisation on Mortgage Backed      *
      *           Assets                                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Use for testing of numeric field                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRAvlDat - Validate Average Life date                        *
      *  SRZChkH - Check whether date is holiday for currency.        *
      *  SRZDate11 - Validate and convert date to day number          *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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
 
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(D1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
 
      ** Index for arrays of warning message ids, etc.
     D WIDx            S              3P 0
 
      ** Work variables
     D WkALDT          S              5P 0
     D WDateIso        S               D   DATFMT(*ISO)
     D WDateIso#       S              8  0
     D W#ALDT          S              6  0
 
      ** Parameters for ZDATE11
     D PDateAIn        S              8A
     D PDaynoOut       S              5P 0
     D PErrorFlag      S              1A
     D BJDFIN          S              1A
 
      ** Parameters for ZCHKH
     D PDateNIn        S              5P 0
     D PCurrency       S              3A
     D PLocation       S              3A
     D PHolInd         S              1A
 
      ** Input fields
      ** ------------
     D DDALDT          S              8A
 
      ** Output(s) fields
      ** ----------------
     D PALDT           S              5P 0
     D DDALDTOK        S              1A
 
     D ZDayIn          S              5  0
     D ZDayOut         S              6  0
     D ZDate           S              7A
     D WkDate          S              6A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initialise work variables.
 
     C                   EVAL      IDx = 0
     C                   EVAL      WIDx = 0
     C                   EVAL      WkALDT = 0
 
     C                   EXSR      SRAvlDat
 
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
 
     C                   IF        DDALDTOK <> 'Y'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        DDALDTOK <> 'N'
     C                   Z-ADD     WkALDT        PALDT
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAvlDat - Validate Average Life date                        *
      *                                                               *
      *****************************************************************
     C     SRAvlDat      BEGSR
 
      ** Default average life to the Security's Maturity date if
      ** average life is blank.
 
     C                   IF        DDALDT = *Blanks
     C                   EVAL      WkALDT = D1MATY
 
      ** Convert to Display file format
 
     C                   CALL      'ZDATE2'
     C                   PARM      WkALDT        ZDayIn
     C                   PARM                    BJDFIN
     C                   PARM                    ZDayOut
     C                   PARM                    ZDate
 
     C                   MOVE      ZDayOut       WkDate
     C                   EVAL      DDALDT = WkDate
 
     C                   ELSE
 
      ** Convert input date (DDMMYY) to (YYYYMMDD)
     C                   MOVEL     DDALDT        W#ALDT
      *
     C                   IF        BJDFIN = 'D'
     C     *DMY          MOVE      W#ALDT        WDateIso
     C     *EUR          MOVE      WDateIso      WDateIso#
     C                   ELSE
     C     *MDY          MOVE      W#ALDT        WDateIso
     C     *USA          MOVE      WDateIso      WDateIso#
     C                   ENDIF
 
      ** Validate date for format and convert to Midas day number
     C                   MOVE      WDateIso#     PDateAIn
     C                   EXSR      SRZDate11
 
     C                   SELECT
 
      ** Error found in date validation and conversion
     C                   WHEN      PErrorFlag = 'Y'
     C                   EVAL      DDALDTOK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= 'DDALDT'
     C                   EVAL      MsgIdXAr(IDx) = 'SEA0530'
 
      ** Average life date must be less than or equal to maturity date.
     C                   WHEN      PDaynoOut > D1MATY
     C                   EVAL      DDALDTOK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= 'DDALDT'
     C                   EVAL      MsgIdXAr(IDx) = 'SEA0531'
 
      ** Average life date must be greater than Initial date.
     C                   WHEN      PDaynoOut < D1ITLD
     C                   EVAL      DDALDTOK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= 'DDALDT'
     C                   EVAL      MsgIdXAr(IDx) = 'SEA0528'
 
      ** New Average life date should always be greater than the latest
      ** Average life date
     C**********         WHEN      PDaynoOut <= D1ALDT                                        233188
     C**********         EVAL      DDALDTOK = 'N'                                             233188
     C**********         EVAL      IDx = IDx + 1                                              233188
     C**********         EVAL      FldNamXAr(IDx)= 'DDALDT'                                   233188
     C**********         EVAL      MsgIdXAr(IDx) = 'SEA0565'                                  233188
     C                   ENDSL
 
      ** Check if average life date is holiday in value currency
      ** (nominal if blank).
 
     C                   IF        DDALDTOK <> 'N'
     C                   IF        D1VLCY <> *BLANKS
     C                   MOVE      D1VLCY        PCurrency
     C                   ELSE
     C                   MOVE      D1NMCY        PCurrency
     C                   ENDIF
 
     C                   Z-ADD     PDaynoOut     PDateNIn
     C                   EXSR      SRZChkH
 
     C                   IF        PHolInd = 'H'
     C                   EVAL      DDALDTOK = 'W'
     C                   EVAL      WIDx = WIDx + 1
     C                   EVAL      WFldNmXAr(WIDx)= 'DDALDT'
     C                   EVAL      WMsgIDxAr(WIDx)= 'SEA0529'
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     PDaynoOut     WkALDT
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZChkH - Check whether date is holiday for currency.        *
      *                                                               *
      *****************************************************************
     C     SRZChkH       BEGSR
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    PDateNIn
     c                   PARM                    PCurrency
     C                   PARM      *BLANKS       PLocation
     C                   PARM      *BLANK        PHolInd
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate11 - Validate and convert date to day number          *
      *                                                               *
      *****************************************************************
     C     SRZDate11     BEGSR
 
     C                   CALL      'ZDATE11'
     C                   PARM                    PDateAIn
     C                   PARM      *ZERO         PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
 
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
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT
      ** =====
 
      ** Return code
     C                   PARM                    RetCodeIn
 
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
 
     C                   PARM                    DDALDT
 
      ** Externally described DS for security details
 
     C                   PARM                    PSectyd
 
      ** STANDING DATA
      ** =============
 
      ** SDBANK - Date format indicator
 
     C                   PARM                    BJDFIN
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
 
      ** Average Life OK Flag
 
     C                   PARM                    DDALDTOK
 
      ** SE Average Life file format
 
     C                   PARM                    PALDT
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2004
