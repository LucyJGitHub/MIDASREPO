     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate last coupon date')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSLSTCD - Validate Last Coupon Date.                       *
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
      *  Prev Amend No. BUG11215           Date 18May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031  *CREATE    Date 16Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BUG11215 - SEFRN Wrong First Coupon Date/LCPN defaulted by   *
      *             FRN Business Day Convention                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
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
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D BJRDNB          S              5P 0
     D BJDFIN          S              1
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *                                                                                     BUG11215
      ** Parameters for ZDATE2                                                              BUG11215
     D PDaynoOut       S              5P 0                                                  BUG11215
     D PZDate          S              6P 0                                                  BUG11215
     D PZaDate         S              7A                                                    BUG11215
                                                                                            BUG11215
      *                                                                                     BUG11215
      ** Parameters for ZFWDT                                                               BUG11215
     D PDaysFwd        S              2P 0                                                  BUG11215
                                                                                            BUG11215
      ** Parameters for ZCHKH                                                               BUG11215
     D PDateIn         S              5P 0                                                  BUG11215
     D PCurrency       S              3A                                                    BUG11215
     D PLocation       S              3A                                                    BUG11215
     D PHolInd         S              1A                                                    BUG11215
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
      ** Validate Last Coupon Date
      *
     C                   EXSR      SRValLastCD
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKLCPN = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKLCPN <> 'N'
     C                   EVAL      S1LCPN = ZDAYNO
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValFixDy - Validation for Last Coupon Date.                *
      *                                                               *
      *****************************************************************
     C     SRValLastCD   BEGSR
      *
      ** Last Coupon Date: Must be in a valid date format (DDMMYY or MMDDYY)
      ** and be earlier than the system run date.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDLCPN        ZFIELD
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
      ** If either ZALIGN and ZDATE1 errors
      *
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'N'           OKLCPN
     C                   ADD       1             IDx
     C                   MOVEL     'DDLCPN'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0502'     MsgIdXAr(IDx)
      *
     C                   ELSE
     C                   IF        S1BCNV <> 'N'                                            BUG11215
     C                   EXSR      SRChkHol                                                 BUG11215
     C                   ENDIF                                                              BUG11215
     C                   IF        ZDAYNO > BJRDNB AND S1ORED = BJRDNB AND
     C                             S1ITLD < BJRDNB OR
     C                             ZDAYNO >= BJRDNB AND S1ORED <> BJRDNB AND
     C                             S1ITLD < BJRDNB
     C                   MOVE      'N'           OKLCPN
     C                   ADD       1             IDx
     C                   MOVEL     'DDLCPN'      FldNamXAr(IDx)
     C                   MOVEL     'SEA0503'     MsgIdXAr(IDx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
                                                                                            BUG11215
      *****************************************************************                     BUG11215
      *                                                               *                     BUG11215
      *  SRChkHol - Check if Last Coupon Date is Holiday              *                     BUG11215
      *                                                               *                     BUG11215
      *****************************************************************                     BUG11215
                                                                                            BUG11215
     C     SRChkHol      BEGSR                                                              BUG11215
      *                                                                                     BUG11215
      ** If the last coupon date is a holiday in nominal currency                           BUG11215
      ** then update it to be the next working day.                                         BUG11215
      *                                                                                     BUG11215
     C                   CALLB     'ZCHKH'                                                  BUG11215
     C                   PARM      ZDAYNO        PDateIn                                    BUG11215
     c                   PARM      S1NMCY        PCurrency                                  BUG11215
     C                   PARM      *BLANKS       PLocation                                  BUG11215
     C                   PARM                    PHolInd                                    BUG11215
                                                                                            BUG11215
     C                   IF        PHolInd = 'H'                                            BUG11215
                                                                                            BUG11215
     C                   Z-ADD     1             PDaysFwd                                   BUG11215
     C                   CALLB     'ZFWDT'                                                  BUG11215
     C                   PARM                    PDateIn                                    BUG11215
     C                   PARM                    PDaysFwd                                   BUG11215
     C                   PARM                    PDaynoOut                                  BUG11215
     C                   PARM                    PCurrency                                  BUG11215
     C                   PARM                    PLocation                                  BUG11215
                                                                                            BUG11215
     C                   CALLB     'ZDATE2'                                                 BUG11215
     C                   PARM                    PDaynoOut                                  BUG11215
     C                   PARM                    BJDFIN                                     BUG11215
     C                   PARM                    PZDate                                     BUG11215
     C                   PARM                    PZaDate                                    BUG11215
                                                                                            BUG11215
     C                   MOVE      PZDate        DDLCPN                                     BUG11215
     C                   MOVE      PDaynoOut     S1LCPN                                     BUG11215
     C                   MOVE      PDaynoOut     ZDAYNO                                     BUG11215
     C                   ENDIF                                                              BUG11215
                                                                                            BUG11215
     C                   ENDSR                                                              BUG11215
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
(c) Misys International Banking Systems Ltd. 2001
