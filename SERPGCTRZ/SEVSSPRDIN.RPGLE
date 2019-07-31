     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate the Spread Indicator on Screen 4')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSSPRDIN - Screen 4:  Validate Spread Indicator            *
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
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
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
      ** DS for the Spread Indicators
     D WSSPIN          S              1A   DIM(10)
      *
      ** DS for the Applicable Date
     D WSAPDT          S              6A   DIM(10)
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
      ** Index for Spread Rate
     D Wx              S              2P 0
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
      ** Load Spread Indicators array
      *
     C                   MOVE      DDSI01        WSSPIN(1)
     C                   MOVE      DDSI02        WSSPIN(2)
     C                   MOVE      DDSI03        WSSPIN(3)
     C                   MOVE      DDSI04        WSSPIN(4)
     C                   MOVE      DDSI05        WSSPIN(5)
     C                   MOVE      DDSI06        WSSPIN(6)
     C                   MOVE      DDSI07        WSSPIN(7)
     C                   MOVE      DDSI08        WSSPIN(8)
     C                   MOVE      DDSI09        WSSPIN(9)
     C                   MOVE      DDSI10        WSSPIN(10)
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
      ** Validate Spread Inidcator
      *
     C                   EXSR      SRValSprdIn
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKSI01 <> 'Y' OR OKSI02 <> 'Y' OR
     C                             OKSI03 <> 'Y' OR OKSI04 <> 'Y' OR
     C                             OKSI05 <> 'Y' OR OKSI06 <> 'Y' OR
     C                             OKSI07 <> 'Y' OR OKSI08 <> 'Y' OR
     C                             OKSI09 <> 'Y' OR OKSI10 <> 'Y'
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
     C                   MOVE      DDSI01        S1SI01
     C                   MOVE      DDSI02        S1SI02
     C                   MOVE      DDSI03        S1SI03
     C                   MOVE      DDSI04        S1SI04
     C                   MOVE      DDSI05        S1SI05
     C                   MOVE      DDSI06        S1SI06
     C                   MOVE      DDSI07        S1SI07
     C                   MOVE      DDSI08        S1SI08
     C                   MOVE      DDSI09        S1SI09
     C                   MOVE      DDSI10        S1SI10
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSPRDIN - Validation Spread Indicators                   *
      *                                                               *
      *****************************************************************
     C     SRValSprdIn   BEGSR
      *
     C                   DOW       Wx <= 10
      *
     C                   IF        WSSPIN(Wx) <> *BLANKS
      *
      ** A Spread Indicator may only be entered if the Applicable Date has
      *  been entered.
      *
     C                   IF        WSAPDT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      SRSprdInErr
     C                   MOVE      'SEA0512'     MsgIDXAr(IDx)
     C                   ENDIF
      *
      ** Valid Entries are:
      **  A - Add to base Rate
      *   S - Subtract from the Base Rate
      *   P - Percentage of the Base Rate.
      *
     C                   IF        WSSPIN(Wx) <> 'A' AND
     C                             WSSPIN(Wx) <> 'S' AND
     C                             WSSPIN(Wx) <> 'P'
     C                   ADD       1             IDx
     C                   EXSR      SRSprdInErr
     C                   MOVE      'SEA0513'     MsgIDXAr(IDx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If the Spread Indicator is not entered then it is defaulted to 'A'.
      *
     C                   IF        WSSPIN(Wx) = *BLANKS  AND
     C                             WSAPDT(Wx) <> *BLANKS
     C                   EXSR      SRSprdInDft
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
      *  SRSPRDINDFT - Default Spread Indicator.                      *
      *                                                               *
      *****************************************************************
     C     SRSprdInDft   BEGSR
      *
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   MOVE      'A'           DDSI01
      *
     C                   WHEN      Wx = 2
     C                   MOVE      'A'           DDSI02
      *
     C                   WHEN      Wx = 3
     C                   MOVE      'A'           DDSI03
      *
     C                   WHEN      Wx = 4
     C                   MOVE      'A'           DDSI04
      *
     C                   WHEN      Wx = 5
     C                   MOVE      'A'           DDSI05
      *
     C                   WHEN      Wx = 6
     C                   MOVE      'A'           DDSI06
      *
     C                   WHEN      Wx = 7
     C                   MOVE      'A'           DDSI07
      *
     C                   WHEN      Wx = 8
     C                   MOVE      'A'           DDSI08
      *
     C                   WHEN      Wx = 9
     C                   MOVE      'A'           DDSI09
      *
     C                   WHEN      Wx = 10
     C                   MOVE      'A'           DDSI10
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSPRDInERR - Spread Indicator field in Error.               *
      *                                                               *
      *****************************************************************
     C     SRSprdInErr   BEGSR
      *
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   MOVE      'N'           OKSI01
     C                   MOVEL     'DDSI01'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 2
     C                   MOVE      'N'           OKSI02
     C                   MOVEL     'DDSI02'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 3
     C                   MOVE      'N'           OKSI03
     C                   MOVEL     'DDSI03'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 4
     C                   MOVE      'N'           OKSI04
     C                   MOVEL     'DDSI04'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 5
     C                   MOVE      'N'           OKSI05
     C                   MOVEL     'DDSI05'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 6
     C                   MOVE      'N'           OKSI06
     C                   MOVEL     'DDSI06'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 7
     C                   MOVE      'N'           OKSI07
     C                   MOVEL     'DDSI07'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 8
     C                   MOVE      'N'           OKSI08
     C                   MOVEL     'DDSI08'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 9
     C                   MOVE      'N'           OKSI09
     C                   MOVEL     'DDSI09'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 10
     C                   MOVE      'N'           OKSI10
     C                   MOVEL     'DDSI10'      FldNamXAr(IDx)
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
      ** Securities screen 2 details from incoming transaction
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
      ** Securities screen 2 error indicators
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
