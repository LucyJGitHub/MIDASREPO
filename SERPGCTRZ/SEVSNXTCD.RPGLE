     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Next Coupon Date')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSLNXCD - Validate Next Coupon Date.                       *
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
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248763             Date 24Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10847R          Date 24Mar06               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031 *Create     Date 04Dec01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248763 - Passing blank fields to ZNCD in insert mode.        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10847R- Incorrect Last and Next Coupon Dates              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
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
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Coupon/Rate days
     D  CDArr                183    230
      ** Coupon/Rate inds
     D  CRArr                231    242
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D BJRDNB          S              5P 0
     D BJDFIN          S              1
     D PNCD            S              5P 0
      *
      ** Parameter list for ZDATE2
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
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
      *
      ** Validate Next Coupon Date
      *
     C                   EXSR      SRValNextCD
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKNCD = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKNCD <> 'N'
     C                   EVAL      S1NCD = ZDAYNO
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValNextCD - Validation for Next Coupon Date.               *
      *                                                               *
      *****************************************************************
     C     SRValNextCD   BEGSR
      *
      ** Recalculate the Next Coupon Date if the Business Day
      *  Convention has been changed.
      *
     C     DDBCNV        IFNE      BCNV
      *                                                                                    BUG10847R
      ** Since action variable is not passed as parameter, BCNV being *BLANKS is           BUG10847R
      *  the same as that current action being done is in INSERT mode                      BUG10847R
      *                                                                                    BUG10847R
     C     BCNV          ANDNE     *BLANKS                                                 BUG10847R
     C                   MOVE      *BLANKS       DDNCD
     C                   ENDIF
      *
      ** Recalculate the Next Coupon Date if it has been blanked out.
      *
     C     DDNCD         IFNE      *BLANKS
      *
      ** Next Coupon Date: Must be in a valid date format (DDMMYY or MMDDYY)
      *  and be later than the system run date and less than Maturity Date.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDNCD         ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
     C                   END
      *
      * If either ZALIGN and ZDATE1 errors
      *
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'N'           OKNCD
     C                   ADD       1             IDx
     C                   MOVEL     'DDNCD'       FldNamXAr(IDx)
     C                   MOVEL     'SEA0514'     MsgIdXAr(IDx)
     C                   ELSE
      *
     C                   IF        ZDAYNO < BJRDNB OR
     C                             ZDAYNO > S1MATY
     C                   MOVE      'N'           OKNCD
     C                   ADD       1             IDx
     C                   MOVEL     'DDNCD'       FldNamXAr(IDx)
     C                   MOVEL     'SEA0515'     MsgIdXAr(IDx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   Z-ADD     *ZEROS        PNCD
      *
     C                   CALLB     'ZNCD'
     C**********         PARM                    ITLD                                         248763
     C                   PARM                    S1ITLD                                       248763
     C                   PARM                    FCPN
     C**********         PARM                    MATY                                         248763
     C                   PARM                    S1MATY                                       248763
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C**********         PARM                    NMCY                                         248763
     C**********         PARM                    SITP                                         248763
     C                   PARM                    S1NMCY                                       248763
     C                   PARM                    S1SITP                                       248763
     C                   PARM                    DDBCNV
     C                   PARM                    LCPN
     C                   PARM                    DDHCY1                                       CSE071
     C                   PARM                    DDHCY2                                       CSE071
     C                   PARM                    DDHCY3                                       CSE071
     C                   PARM                    DDHCY4                                       CSE071
     C                   PARM                    DDHCY5                                       CSE071
     C                   PARM                    DDHCY6                                       CSE071
     C                   PARM                    DDHCY7                                       CSE071
     C                   PARM                    DDHCY8                                       CSE071
     C                   PARM                    DDHCY9                                       CSE071
     C                   PARM                    PNCD
      *
     C                   IF        PNCD <> *ZEROS
     C                   Z-ADD     PNCD          ZDAYNO
      *
      ** Repopulate the screen field with the new calculated
      *  Next Coupon date.
      *
     C                   Z-ADD     PNCD          PDateIn
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut
 
     C                   MOVEL     PDateOut      DDNCD
      *
     C                   ELSE
     C                   Z-ADD     *ZEROS        ZDAYNO
     C                   ENDIF
      *
     C                   ENDIF
      *
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
      *                                                                                       CSE071
      ** Securities screen 6 details from incoming transaction                                CSE071
      ** - screen format                                                                      CSE071
     C                   PARM                    NwSE6ScnFmt                                  CSE071
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Runday number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date format indicator
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
(c) Finastra International Limited 2001
