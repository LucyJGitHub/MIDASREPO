     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate MT3xx Fund Identification')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVFUND - Validate MT3xx Fund Indentification                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR855391           Date 27Oct11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW024   *CREATE   Date 31Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *             (CSD091 - Overrideable Errors Configurability     *
      *             Enabler Phase 2)                                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
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
      *
      ** Valid SWIFT characters
     D ValSwChar       S              1    DIM(72) CTDATA PERRCD(72)
      *
      ** Work array variable for Fund Id
     D WFunAr          S              1    DIM(34)
      *
      ** New Customer in File Format
     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPD)
      *
      ** MT3xx BEI details screen error indicators
     D OkCuMT3x      E DS                  EXTNAME(SDECUMTPD)
      *
      ** New Customer in screen format - MT3xx BEI details
     D NwCuMT3x      E DS                  EXTNAME(SDCUMTPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of error message ids, etc.                                        AR855391
     D WIdx            S              3P 0                                                  AR855391
      *                                                                                     AR855391
      ** Work index
     D WI              S              3P 0
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
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialise work variables.
      *
     C                   EVAL      IDx = 0
      *
      ** Validate Fund Identification
      *
     C                   IF        DDFUND <> *BLANKS
     C                   EXSR      SrFundId
     C                   ENDIF
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        DDFUNDOK <> 'Y'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ELSE
     C                   EVAL      CUFUND = DDFUND
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFundId - Validate Fund Identification                      *
      *                                                               *
      *****************************************************************
     C     SrFundId      BEGSR
      *
     C                   MOVEA     DDFUND        WFunAr
     C                   DO        34            WI
      *
     C     WFunAr(WI)    LOOKUP    ValSwChar(1)                           01
     C                   IF        NOT(*IN01) AND
     C                             WFunAr(WI) <> *BLANK
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'N'           DDFUNDOK                                   AR855391
     C**********         MOVEL     'DDFUND'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR9145'     MsgIdXAr(IDx)                              AR855391
     C                   EVAL      WIdx = WIdx + 1                                          AR855391
     C                   EVAL      DDFUNDOK = 'W'                                           AR855391
     C                   EVAL      WFldNmXAr(WIdx) = 'DDFUND'                               AR855391
     C                   EVAL      WMsgIdXAr(WIDx) = 'USR9145'                              AR855391
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
 
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
      ** New Customer in screen format - MT3xx BEI details
     C                   PARM                    NwCuMT3x
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                            AR855391
     C                   PARM                    WFldNmXAr                                  AR855391
     C                   PARM                    WMsgIDXAr                                  AR855391
     C                   PARM                    WMsgDtXAr                                  AR855391
      *
      ** MT3xx BEI details screen error indicators
     C                   PARM                    OkCuMT3x
      *
      ** New Customer in file format
     C                   PARM                    NwCuFilFmt
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
** Valid swift characters
abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-?:().,'+
