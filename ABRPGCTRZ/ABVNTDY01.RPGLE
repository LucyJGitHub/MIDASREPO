     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate FUND Notice Days')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABVNTDY01 - Validate FUND Notice Days                        *
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
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 218957             Date 26May06               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  218957 - Internal Funding deal input with a maturity date    *
      *           of a Bank Holiday is showing on the Interest        *
      *           Accruals report (DL0521P1) with maturity date of    *
      *           'CALL'.  Fix is to set notice days to -999 when     *
      *           maturity date is input for the deal.                *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRValNTCE - Validate Notice Days                              *
      * SRZAlign  - Validate numeric fields                           *
      * *INZSR    - Initialise                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
 
      /COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     Prefix(DD:2)
 
      ** Internal funding deals error indicator file
     D OkFlags       E DS                  EXTNAME(ABEFUNDPD)
 
      ** New Deal in File Format of main deal
     D NwDlFilFmt1   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N1:2)
     D  N1DORIQQ     E                     EXTFLD(QQDORI)                                     CGL029
     D  N1MORIQQ     E                     EXTFLD(QQMORI)                                     CGL029
     D  N1DOPIQQ     E                     EXTFLD(QQDOPI)                                     CGL029
     D  N1MOPIQQ     E                     EXTFLD(QQMOPI)                                     CGL029
     D  N1RONSQQ     E                     EXTFLD(QQRONS)                                     CGL029
     D  N1PONSQQ     E                     EXTFLD(QQPONS)                                     CGL029
     D  N1INSAQQ     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** New Deal in File Format of associated deal
     D NwDlFilFmt2   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N2:2)
     D  N2DORIQQ     E                     EXTFLD(QQDORI)                                     CGL029
     D  N2MORIQQ     E                     EXTFLD(QQMORI)                                     CGL029
     D  N2DOPIQQ     E                     EXTFLD(QQDOPI)                                     CGL029
     D  N2MOPIQQ     E                     EXTFLD(QQMOPI)                                     CGL029
     D  N2RONSQQ     E                     EXTFLD(QQRONS)                                     CGL029
     D  N2PONSQQ     E                     EXTFLD(QQPONS)                                     CGL029
     D  N2INSAQQ     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Current Deal in File Format of main deal
     D CrDlFilFmt1   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D1:2)
     D  D1DORIQQ     E                     EXTFLD(QQDORI)                                     CGL029
     D  D1MORIQQ     E                     EXTFLD(QQMORI)                                     CGL029
     D  D1DOPIQQ     E                     EXTFLD(QQDOPI)                                     CGL029
     D  D1MOPIQQ     E                     EXTFLD(QQMOPI)                                     CGL029
     D  D1RONSQQ     E                     EXTFLD(QQRONS)                                     CGL029
     D  D1PONSQQ     E                     EXTFLD(QQPONS)                                     CGL029
     D  D1INSAQQ     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
 
      ** Index for arrays of warning message ids, etc.
     D WIDx            S              3P 0
 
      ** Work Parameters
     D PMatDate        S              5P 0
     D BJRDNB          S              5P 0
 
      ** Work Variables
     D WNtceDay        S              3  0
     D WVXX1           S              6  0
     D PValFlg         S              1A
 
      ** Parameters for ZALIGN
     D ZAlignOk        S              1A
     D ZField          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initialise work variables
 
     C                   EVAL      IDx = 0
     C                   EVAL      WIDx = 0
     C                   EVAL      WNtceDay = 0
     C                   EVAL      WVXX1 = 0
 
     C                   EXSR      SRValNTCE
 
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
 
     C                   IF        OKNTCE <> 'Y' OR
     C**********                   OKMDAT <> 'Y'                                              218957
     C                             OKMDAT <> 'Y' AND                                          218957
     C                             OKMDAT <> 'W'                                              218957
 
     C                   EVAL      RetCodeIn = 'ERROR'
 
     C                   ELSE
 
     C                   EVAL      N1NTCE = WNtceDay
     C                   EVAL      N2NTCE = WNtceDay
 
      **  If Notice Days have been entered, set Call/Notice indicator
 
     C                   IF        WNtceDay = 0
 
     C                   EVAL      N1CNTI = 'C'
     C                   EVAL      N2CNTI = 'C'
 
     C                   ELSE
 
     C                   IF        WNtceDay > 0
 
     C                   EVAL      N1CNTI = 'N'
     C                   EVAL      N2CNTI = 'N'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      *                  ======
     C                   RETURN
      *                  ======
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValVDAT - Validate Value Date                              *
      *                                                               *
      *****************************************************************
 
     C     SRValNTCE     BEGSR
 
      ** Blank Notice Days is invalid if Maturity Date has not
      ** been inserted
 
     C                   IF        DDMDAT = *Blanks AND
     C                             DDNTCE = *Blanks
 
     C                   EVAL      OKNTCE = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1NTCE'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0587'
     C                   GOTO      ENDValNTCE
 
     C                   ENDIF
 
      ** Entry days must be numeric
 
     C                   IF        DDNTCE <> *Blanks
 
     C                   MOVE      *Blanks       ZField
     C                   MOVE      DDNTCE        ZField
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   EXSR      SRZAlign
 
     C                   IF        ZAlignOk = 'N'
 
     C                   EVAL      OKNTCE = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1NTCE'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0139'
     C                   GOTO      ENDValNTCE
 
     C                   ELSE
 
     C                   MOVE      ZField        WNtceDay
     C                   MOVE      ZField        DDNTCE
 
     C                   ENDIF
 
     C                   SELECT
 
      ** If amending, check Maturity Date entered is less than the
      ** transaction date plus notice days, otherwise Warning Message
 
     C                   WHEN      DDACTN = 'A'
 
     C                   IF        DDMDAT <> *Blanks
 
     C     WNtceDay      ADD       BJRDNB        WVXX1
     C                   Z-SUB     999           WNtceDay
 
     C                   IF        WVXX1 > PMatDate
 
     C                   EVAL      OKMDAT = 'W'
     C                   EVAL      WIDx = WIDx + 1
     C                   EVAL      WFldNmXAr(WIDx)= '#1MDAT'
     C                   EVAL      WMsgIDxAr(WIDx)= 'MMM0584'
     C                   GOTO      ENDValNTCE
 
     C                   ELSE
 
     C                   EVAL      DDNTCE = *Blanks
     C                   EVAL      PValFlg = 'Y'
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Otherwise inserting, and if the maturity date and notice
      ** days have been inserted, this is invalid
 
     C                   WHEN      DDACTN = 'I'
 
     C                   IF        DDMDAT <> *Blanks
 
     C                   EVAL      OKNTCE = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1NTCE'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0586'
     C                   GOTO      ENDValNTCE
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ELSE
 
     C                   Z-SUB     999           WNtceDay
 
     C                   ENDIF
      *                                                                                       218957
      ** If the maturity Date has been set, in all cases set the                              218957
      ** notice days to -999.                                                                 218957
      *                                                                                       218957
     C                   IF        DDMDAT <> *Blanks                                          218957
     C                   Eval      WNtceDay = -999                                            218957
     C                   ENDIF                                                                218957
      *                                                                                       218957
 
     C     EndValNTCE    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAlign - Validate numeric fields                           *
      *                                                               *
      *****************************************************************
 
     C     SRZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZField
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT
      ** =====
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Current Deal in File Format of main deal
     C                   PARM                    CrDlFilFmt1
 
      ** Standing Data
      ** =============
 
      ** SDBANK: Run Day Number
     C                   PARM                    BJRDNB
 
      ** Maturity Date in Midas Day no. format
     C                   PARM                    PMatDate
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Notice Days
     C                   PARM                    WNtceDay
 
      ** Amended by validation module flag
 
     C                   PARM                    PValFlg
 
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
(c) Finastra International Limited 2001
