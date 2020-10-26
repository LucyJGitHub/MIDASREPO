     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Applicable Date on Screen 4')        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSAPPDT - Validate Applicable Date.                        *
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
      *                 AR875871           Date 06Dec11               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031  *CREATE    Date 15Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  AR875871 - Cannot insert in FRN info tab when base rate is   *
      *             blank and contractual spread is non-blank         *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
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
      ** Securities screen 4 details from incoming transaction
      ** - screen format
     D NwSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 4 error indicators
     D SEESEC4       E DS                  EXTNAME(SEESEC4PD)
      *
      ** DS for the Applicable Date
     D WSAPDT          S              6A   DIM(10)
      *
      ** DS for the Base Rate Code
     D WSBRCD          S              2A   DIM(10)
      *
      ** DS for the Spread Rate
     D WSSPRT          S             12A   DIM(10)
      *                                                                                     AR875871
      ** DS for the Contractual Spread Rate                                                 AR875871
     D WSCNSP          S             12A   DIM(10)                                          AR875871
      *
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
      ** Index for Applicable Date Array
     D Wx              S              2P 0
      *
      *
     D BJDFIN          S              1A
     D CRE073          S              1A                                                    AR875871
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
     C                   EVAL      Wx = 1
     C                   Z-ADD     *ZEROS        WLDAT             5 0          Last Date.
      *
      ** Load Applicable Date array.
      *
     C                   MOVE      DDAD01        WSAPDT(1)
     C                   MOVE      DDAD02        WSAPDT(2)
     C                   MOVE      DDAD03        WSAPDT(3)
     C                   MOVE      DDAD04        WSAPDT(4)
     C                   MOVE      DDAD05        WSAPDT(5)
     C                   MOVE      DDAD06        WSAPDT(6)
     C                   MOVE      DDAD07        WSAPDT(7)
     C                   MOVE      DDAD08        WSAPDT(8)
     C                   MOVE      DDAD09        WSAPDT(9)
     C                   MOVE      DDAD10        WSAPDT(10)
      *
      ** Load Base Rate Code array
      *
     C                   MOVE      DDBR01        WSBRCD(1)
     C                   MOVE      DDBR02        WSBRCD(2)
     C                   MOVE      DDBR03        WSBRCD(3)
     C                   MOVE      DDBR04        WSBRCD(4)
     C                   MOVE      DDBR05        WSBRCD(5)
     C                   MOVE      DDBR06        WSBRCD(6)
     C                   MOVE      DDBR07        WSBRCD(7)
     C                   MOVE      DDBR08        WSBRCD(8)
     C                   MOVE      DDBR09        WSBRCD(9)
     C                   MOVE      DDBR10        WSBRCD(10)
      *
      ** Load Spread Indicator array
      *
     C                   MOVE      DDBS01        WSSPRT(1)
     C                   MOVE      DDBS02        WSSPRT(2)
     C                   MOVE      DDBS03        WSSPRT(3)
     C                   MOVE      DDBS04        WSSPRT(4)
     C                   MOVE      DDBS05        WSSPRT(5)
     C                   MOVE      DDBS06        WSSPRT(6)
     C                   MOVE      DDBS07        WSSPRT(7)
     C                   MOVE      DDBS08        WSSPRT(8)
     C                   MOVE      DDBS09        WSSPRT(9)
     C                   MOVE      DDBS10        WSSPRT(10)
      *                                                                                     AR875871
      ** Load Contractual Spread array                                                      AR875871
      *                                                                                     AR875871
     C                   IF        CRE073 = 'Y'                                             AR875871
     C                   MOVE      DDCNP01       WSCNSP(1)                                  AR875871
     C                   MOVE      DDCNP02       WSCNSP(2)                                  AR875871
     C                   MOVE      DDCNP03       WSCNSP(3)                                  AR875871
     C                   MOVE      DDCNP04       WSCNSP(4)                                  AR875871
     C                   MOVE      DDCNP05       WSCNSP(5)                                  AR875871
     C                   MOVE      DDCNP06       WSCNSP(6)                                  AR875871
     C                   MOVE      DDCNP07       WSCNSP(7)                                  AR875871
     C                   MOVE      DDCNP08       WSCNSP(8)                                  AR875871
     C                   MOVE      DDCNP09       WSCNSP(9)                                  AR875871
     C                   MOVE      DDCNP10       WSCNSP(10)                                 AR875871
     C                   ENDIF                                                              AR875871
      *
      ** Validate Applicable Dates.
      *
     C                   EXSR      SRValAppcDt
      *
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKAD01 <> 'Y' OR OKAD02 <> 'Y' OR
     C                             OKAD03 <> 'Y' OR OKAD04 <> 'Y' OR
     C                             OKAD05 <> 'Y' OR OKAD06 <> 'Y' OR
     C                             OKAD07 <> 'Y' OR OKAD08 <> 'Y' OR
     C                             OKAD09 <> 'Y' OR OKAD10 <> 'Y'

     C                   EVAL      RetCodeIn = 'ERROR'

     C                   ENDIF

     C                   IF        OKAD01 <> 'N' AND  OKAD02 <> 'N' AND
     C                             OKAD03 <> 'N' AND  OKAD04 <> 'N' AND
     C                             OKAD05 <> 'N' AND  OKAD06 <> 'N' AND
     C                             OKAD07 <> 'N' AND  OKAD08 <> 'N' AND
     C                             OKAD09 <> 'N' AND  OKAD10 <> 'N'

     C                   MOVE      DDAD01        S1AD01
     C                   MOVE      DDAD02        S1AD02
     C                   MOVE      DDAD03        S1AD03
     C                   MOVE      DDAD04        S1AD04
     C                   MOVE      DDAD05        S1AD05
     C                   MOVE      DDAD06        S1AD06
     C                   MOVE      DDAD07        S1AD07
     C                   MOVE      DDAD08        S1AD08
     C                   MOVE      DDAD09        S1AD09
     C                   MOVE      DDAD10        S1AD10

     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALAPPCDT - Validation Applicable Date                     *
      *                                                               *
      *****************************************************************

     C     SRValAppcDt   BEGSR
      *
     C                   DOW       Wx <= 10
      *
     C                   IF        WSAPDT(Wx) <> *BLANKS
      *
      ** An entry has been made, but the previous field is blank.
      *
     C                   IF        Wx > 1
     C                   SUB       1             Wx
     C                   IF        WSAPDT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      SRApplcdErr
     C                   MOVE      'SEA0504'     MsgIDXAr(IDx)
     C                   ENDIF
     C                   ADD       1             Wx
     C                   ENDIF
      *
      *
      ** The entered Applicable Date must be in a valid date format
      *  (DDMMYY or MMDDYY).
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     WSAPDT(Wx)    ZFIELD
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
     C                   ADD       1             IDx
     C                   EXSR      SRApplcdErr
     C                   MOVE      'SEA0505'     MsgIDXAr(IDx)
     C                   ELSE
      *
      ** The entered Applicable Date must be after Initial Date and
      *  before Maturity Date.
      *
     C                   IF        ZDAYNO <= S1ITLD OR
     C                             ZDAYNO > S1MATY
     C                   ADD       1             IDx
     C                   EXSR      SRApplcdErr
     C                   MOVE      'SEA0506'     MsgIDXAr(IDx)
     C                   ENDIF
      *
      ** The date entered must not be later than the previous date.
      *
     C                   IF        ZDAYNO <= WLDAT
     C                   ADD       1             IDx
     C                   EXSR      SRApplcdErr
     C                   MOVE      'SEA0507'     MsgIDXAr(IDx)
     C                   ENDIF
      *
     C                   Z-ADD     ZDAYNO        WLDAT
      *
     C                   ENDIF
      *
      *
      ** If a date has been entered, then at least either the corresponding
      *  Base Rate or Spread Rate must be entered.
      *
     C                   IF        CRE073 = 'Y'                                             AR875871
     C                   IF        WSBRCD(Wx) = *BLANKS AND                                 AR875871
     C                             WSCNSP(Wx) = *BLANKS                                     AR875871
     C                   ADD       1             IDx                                        AR875871
     C                   EXSR      SRApplcdErr                                              AR875871
     C                   MOVE      'SEA0933'     MsgIDXAr(IDx)                              AR875871
     C                   ENDIF                                                              AR875871
     C                   ELSE                                                               AR875871
     C                   IF        WSBRCD(Wx) = *BLANKS AND
     C                             WSSPRT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      SRApplcdErr
     C                   MOVE      'SEA0508'     MsgIDXAr(IDx)
     C                   ENDIF
     C                   ENDIF                                                              AR875871
      *
     C                   ENDIF
      *
      ** Applicable Date must be entered if either the Base Rate Code
      *  or the Spread Rate is entered.
      *
     C                   IF        CRE073 = 'Y'                                             AR875871
     C                   IF        WSAPDT(Wx) = *BLANKS AND                                 AR875871
     C                             WSBRCD(Wx) <> *BLANKS OR                                 AR875871
     C                             WSAPDT(Wx) = *BLANKS AND                                 AR875871
     C                             WSCNSP(Wx) <> *BLANKS                                    AR875871
     C                   ADD       1             IDx                                        AR875871
     C                   EXSR      SRApplcdErr                                              AR875871
     C                   MOVE      'SEA0509'     MsgIDXAr(IDx)                              AR875871
     C                   ENDIF                                                              AR875871
     C                   ELSE                                                               AR875871
     C                   IF        WSAPDT(Wx) = *BLANKS AND
     C                             WSBRCD(Wx) <> *BLANKS OR
     C                             WSAPDT(Wx) = *BLANKS AND
     C                             WSSPRT(Wx) <> *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      SRApplcdErr
     C                   MOVE      'SEA0509'     MsgIDXAr(IDx)
     C                   ENDIF
     C                   ENDIF                                                              AR875871
      *
      *
     C                   ADD       1             Wx
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAPPLCDERR - Applicable Date Field in Error.                *
      *                                                               *
      *****************************************************************
     C     SRApplcdErr   BEGSR
      *
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   MOVE      'N'           OKAD01
     C                   MOVEL     'DDAD01'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 2
     C                   MOVE      'N'           OKAD02
     C                   MOVEL     'DDAD02'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 3
     C                   MOVE      'N'           OKAD03
     C                   MOVEL     'DDAD03'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 4
     C                   MOVE      'N'           OKAD04
     C                   MOVEL     'DDAD04'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 5
     C                   MOVE      'N'           OKAD05
     C                   MOVEL     'DDAD05'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 6
     C                   MOVE      'N'           OKAD06
     C                   MOVEL     'DDAD06'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 7
     C                   MOVE      'N'           OKAD07
     C                   MOVEL     'DDAD07'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 8
     C                   MOVE      'N'           OKAD08
     C                   MOVEL     'DDAD08'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 9
     C                   MOVE      'N'           OKAD09
     C                   MOVEL     'DDAD09'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 10
     C                   MOVE      'N'           OKAD10
     C                   MOVEL     'DDAD10'      FldNamXAr(IDx)
      *
     C                   ENDSL
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
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Securities screen 4 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE4ScnFmt
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
      ** Securities screen 4 error indicators
     C                   PARM                    SEESEC4
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *                                                                                     AR875871
      ** Interest Rate Rounding enhancement                                                 AR875871
     C                   PARM                    CRE073                                     AR875871
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
