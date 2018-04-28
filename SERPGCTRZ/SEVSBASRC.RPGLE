     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate the base rate code on Screen 4')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSBASRC - Screen 4: Validate Base Rate Code                *
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
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031  *CREATE    Date 21Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      ** External DS for base rate code
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for the Base Rate Code
     D WSBRCD          S              2A   DIM(10)
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
      ** Index for Base Rate Code Array
     D Wx              S              2P 0
      *
      ** Parameters for AOBSRTR0
     D PRtcd           S              7A
     D POptn           S              7A
     D PCycd           S              3A
     D PBsrc           S              2A
 
     D PMode           S              6A
      *
      ** Redisplay screen
     D PReDsp          S              1A
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
      ** Validate base rate code
      *
     C                   EXSR      SRValBsRtCd
      *
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKBR01 <> 'Y' OR OKBR02 <> 'Y' OR
     C                             OKBR03 <> 'Y' OR OKBR04 <> 'Y' OR
     C                             OKBR05 <> 'Y' OR OKBR06 <> 'Y' OR
     C                             OKBR07 <> 'Y' OR OKBR08 <> 'Y' OR
     C                             OKBR09 <> 'Y' OR OKBR10 <> 'Y'
      *
     C                   EVAL      RetCodeIn = 'ERROR'
      *
     C                   ENDIF
      *
     C                   IF        OKBR01 <> 'N' AND  OKBR02 <> 'N' AND
     C                             OKBR03 <> 'N' AND  OKBR04 <> 'N' AND
     C                             OKBR05 <> 'N' AND  OKBR06 <> 'N' AND
     C                             OKBR07 <> 'N' AND  OKBR08 <> 'N' AND
     C                             OKBR09 <> 'N' AND  OKBR10 <> 'N'
      *
     C                   MOVE      DDBR01        S1BR01
     C                   MOVE      DDBR02        S1BR02
     C                   MOVE      DDBR03        S1BR03
     C                   MOVE      DDBR04        S1BR04
     C                   MOVE      DDBR05        S1BR05
     C                   MOVE      DDBR06        S1BR06
     C                   MOVE      DDBR07        S1BR07
     C                   MOVE      DDBR08        S1BR08
     C                   MOVE      DDBR09        S1BR09
     C                   MOVE      DDBR10        S1BR10
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALBSRTCD - Validation for Base Rate Code                  *
      *                                                               *
      *****************************************************************
     C     SRValBsRtCd   BEGSR
      *
     C                   DOW       Wx <= 10
      *
     C                   IF        WSBRCD(Wx) <> *BLANKS
      *
      ** A Base Rate Code may only be entered if the Applicable Date has
      *  been entered.
      *
     C                   IF        WSAPDT(Wx) = *BLANKS
     C                   ADD       1             IDx
     C                   EXSR      SRBasRcdErr
     C                   MOVE      'SEA0510'     MsgIDXAr(IDx)
     C                   ENDIF
      *
      ** Question mark is valid only on repair and i/c screens input.
      *
     C     '?'           SCAN      WSBRCD(Wx)                             25
 
     C                   IF        *IN25 = *ON
 
     C                   IF        PMode = '*FRONT'
     C                   ADD       1             IDx
     C                   EXSR      SRBasRcdErr
     C                   MOVE      'SEA0147'     MsgIDXAr(IDx)
     C                   ENDIF
 
     C                   EVAL      PReDsp = 'Y'
     C                   ENDIF
      *
      ** Must exist on standing data file
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      S1NMCY        PCycd
     C                   PARM      WSBRCD(Wx)    PBsrc
     C     SDBSRT        PARM      SDBSRT        DSFDY
 
     C                   IF        PRtcd <> *BLANKS
 
     C                   IF        PRtcd = '*NOSEL '
     C                   EXSR      SRResetBRCD
     C                   ELSE
     C                   ADD       1             IDx
     C                   EXSR      SRBasRcdErr
     C                   MOVE      'SEA0147'     MsgIDXAr(IDx)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        *IN25 = *ON
     C                   EXSR      SRSelcBRCD
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF
      *
     C                   ENDIF
 
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
      *  SRSELCBRCD - Base Rate Code have been selected.              *
      *                                                               *
      *****************************************************************
     C     SRSelcBRCD    BEGSR
      *
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   MOVE      BABSRC        DDBR01
      *
     C                   WHEN      Wx = 2
     C                   MOVE      BABSRC        DDBR02
      *
     C                   WHEN      Wx = 3
     C                   MOVE      BABSRC        DDBR03
      *
     C                   WHEN      Wx = 4
     C                   MOVE      BABSRC        DDBR04
      *
     C                   WHEN      Wx = 5
     C                   MOVE      BABSRC        DDBR05
      *
     C                   WHEN      Wx = 6
     C                   MOVE      BABSRC        DDBR06
      *
     C                   WHEN      Wx = 7
     C                   MOVE      BABSRC        DDBR07
      *
     C                   WHEN      Wx = 8
     C                   MOVE      BABSRC        DDBR08
      *
     C                   WHEN      Wx = 9
     C                   MOVE      BABSRC        DDBR09
      *
     C                   WHEN      Wx = 10
     C                   MOVE      BABSRC        DDBR10
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBASRCDERR - Base Rate Code Field in Error.                 *
      *                                                               *
      *****************************************************************
     C     SRBasRcdErr   BEGSR
      *
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   MOVE      'N'           OKBR01
     C                   MOVEL     'DDBR01'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 2
     C                   MOVE      'N'           OKBR02
     C                   MOVEL     'DDBR02'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 3
     C                   MOVE      'N'           OKBR03
     C                   MOVEL     'DDBR03'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 4
     C                   MOVE      'N'           OKBR04
     C                   MOVEL     'DDBR04'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 5
     C                   MOVE      'N'           OKBR05
     C                   MOVEL     'DDBR05'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 6
     C                   MOVE      'N'           OKBR06
     C                   MOVEL     'DDBR06'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 7
     C                   MOVE      'N'           OKBR07
     C                   MOVEL     'DDBR07'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 8
     C                   MOVE      'N'           OKBR08
     C                   MOVEL     'DDBR08'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 9
     C                   MOVE      'N'           OKBR09
     C                   MOVEL     'DDBR09'      FldNamXAr(IDx)
      *
     C                   WHEN      Wx = 10
     C                   MOVE      'N'           OKBR10
     C                   MOVEL     'DDBR10'      FldNamXAr(IDx)
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETBRCD - Reset the Base Rate Code.                      *
      *                                                               *
      *****************************************************************
     C     SRResetBRCD   BEGSR
      *
     C                   SELECT
      *
     C                   WHEN      Wx = 1
     C                   MOVE      *BLANKS       DDBR01
      *
     C                   WHEN      Wx = 2
     C                   MOVE      *BLANKS       DDBR02
      *
     C                   WHEN      Wx = 3
     C                   MOVE      *BLANKS       DDBR03
      *
     C                   WHEN      Wx = 4
     C                   MOVE      *BLANKS       DDBR04
      *
     C                   WHEN      Wx = 5
     C                   MOVE      *BLANKS       DDBR05
      *
     C                   WHEN      Wx = 6
     C                   MOVE      *BLANKS       DDBR06
      *
     C                   WHEN      Wx = 7
     C                   MOVE      *BLANKS       DDBR07
      *
     C                   WHEN      Wx = 8
     C                   MOVE      *BLANKS       DDBR08
      *
     C                   WHEN      Wx = 9
     C                   MOVE      *BLANKS       DDBR09
      *
     C                   WHEN      Wx = 10
     C                   MOVE      *BLANKS       DDBR10
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
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMode
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
      ** Redisplay screen indicator
     C                   PARM                    PReDsp
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
