     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate the Spread Rate on Screen 4')        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSSPDRAT - Screen 4:  Validate Spread Rate                 *
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
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031  *CREATE    Date 21Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
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
      ** DS for the Spread Rates
     D WSSPRT          S             12A   DIM(10)
      *
     D WVSPRT          S             15A   DIM(10)
      *
      ** DS for the Applicable Date
     D WSAPDT          S              6A   DIM(10)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for Spread Rate
     D Wx              S              2P 0
      *
      ** Variables for ZASIGN
     D ZASignOk        S              1A
     D ZFLD17          S             17A
     D ZSDIG           S              2P 0
     D ZSDEC           S              1P 0
     D ZSDCSP          S              1A
     D ZOUT15          S             15A
     D ZFSIGN          S              1A
      *
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
      *
      ** Load Spread Rate array
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
      *
      ** Load Applicable Date array
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
      ** Validate base rate spread
      *
     C                   EXSR      SRValSprdRt
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKBS01 <> 'Y' OR OKBS02 <> 'Y' OR
     C                             OKBS03 <> 'Y' OR OKBS04 <> 'Y' OR
     C                             OKBS05 <> 'Y' OR OKBS06 <> 'Y' OR
     C                             OKBS07 <> 'Y' OR OKBS08 <> 'Y' OR
     C                             OKBS09 <> 'Y' OR OKBS10 <> 'Y'
      *
     C                   EVAL      RetCodeIn = 'ERROR'
      *
     C                   ENDIF
      *
     C                   IF        OKBS01 <> 'N' AND  OKBS02 <> 'N' AND
     C                             OKBS03 <> 'N' AND  OKBS04 <> 'N' AND
     C                             OKBS05 <> 'N' AND  OKBS06 <> 'N' AND
     C                             OKBS07 <> 'N' AND  OKBS08 <> 'N' AND
     C                             OKBS09 <> 'N' AND  OKBS10 <> 'N'
      *
     C                   MOVE      WVSPRT(1)     S1BS01
     C                   MOVE      WVSPRT(2)     S1BS02
     C                   MOVE      WVSPRT(3)     S1BS03
     C                   MOVE      WVSPRT(4)     S1BS04
     C                   MOVE      WVSPRT(5)     S1BS05
     C                   MOVE      WVSPRT(6)     S1BS06
     C                   MOVE      WVSPRT(7)     S1BS07
     C                   MOVE      WVSPRT(8)     S1BS08
     C                   MOVE      WVSPRT(9)     S1BS09
     C                   MOVE      WVSPRT(10)    S1BS10
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSPRDRT - Validation Spread Rate                         *
      *                                                               *
      *****************************************************************
     C     SRValSprdRt   BEGSR
      *
     C                   DOW       Wx <= 10
      *
     C                   IF        WSSPRT(Wx) <> *BLANKS
      *
      ** A Spread Rate may only be entered if the Applicable Date has been
      *  entered.
      *
     C                   IF        WSAPDT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      SRSprdRtErr
     C                   MOVE      'SEA0511'     MsgIDXAr(IDx)
     C                   ENDIF
      *
      ** Check for valid number
      *
     C                   EVAL      ZFLD17 = *BLANKS
     C                   MOVEL     WSSPRT(Wx)    ZFLD17
      *
     C                   Z-ADD     4             ZSDIG
     C                   Z-ADD     7             ZSDEC
      *
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASignOk
     C                   PARM                    ZFLD17
     C                   PARM                    ZSDIG
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDCSP
     C                   PARM                    ZOUT15
     C                   PARM                    ZFSIGN
      *
     C                   IF        ZASignOk = 'N'
     C                   ADD       1             IDx
     C                   EXSR      SRSprdRtErr
     C                   MOVE      'SEA0149'     MsgIDXAr(IDx)
     C                   ELSE
     C                   MOVE      *BLANKS       WVSPRT(Wx)
     C                   MOVE      ZOUT15        WVSPRT(Wx)
     C                   ENDIF
      *
     C                   ENDIF
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
      *  SRSPRDRTERR - Spread Rate Field in Error.                    *
      *                                                               *
      *****************************************************************
     C     SRSprdRtErr   BEGSR
      *
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   MOVE      'N'           OKBS01
     C                   MOVEL     'DDBS01'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 2
     C                   MOVE      'N'           OKBS02
     C                   MOVEL     'DDBS02'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 3
     C                   MOVE      'N'           OKBS03
     C                   MOVEL     'DDBS03'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 4
     C                   MOVE      'N'           OKBS04
     C                   MOVEL     'DDBS04'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 5
     C                   MOVE      'N'           OKBS05
     C                   MOVEL     'DDBS05'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 6
     C                   MOVE      'N'           OKBS06
     C                   MOVEL     'DDBS06'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 7
     C                   MOVE      'N'           OKBS07
     C                   MOVEL     'DDBS07'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 8
     C                   MOVE      'N'           OKBS08
     C                   MOVEL     'DDBS08'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 9
     C                   MOVE      'N'           OKBS09
     C                   MOVEL     'DDBS09'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 10
     C                   MOVE      'N'           OKBS10
     C                   MOVEL     'DDBS10'      FldNamXAr(IDx)
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
