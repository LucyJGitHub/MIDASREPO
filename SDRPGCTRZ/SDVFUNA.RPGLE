     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate MT3xx Fund Account Number')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVFUNA - Validate MT3xx Fund Account Number                 *
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
      *  Prev Amend No. AR855391           Date 27Oct11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW037A            Date 02May05               *
      *                 BUG6552            Date 10Apr05               *
      *                 CSW037  *CREATE    Date 06Dec04               *
      * Midas Release 4.01 -------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *             (CSD091 - Overrideable Errors Configurability     *
      *             Enabler Phase 2)                                  *
      *  CSW037A- Additional Field extended to 40 chars               *
      *  BUG6552- CSW037 Field 83 (recompile).                        *
      *  CSW037 - Additional Field Data on MT300/MT320.               *
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
      ** Work array variable for Fund ACCOUNT Number
     D*WFUNAAR****     S              1    DIM(24)                                           CSW037A
     D WFUNAAR         S              1    DIM(40)                                           CSW037A
      *
      ** New Customer in File Format
     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPD)
      *
      ** MT3xx BEI details screen error indicators
     D OkCuMT3x      E DS                  EXTNAME(SDECUMTPD)
      *
      ** New Customer in screen format - MT3xx BEI details
     D NwCuMT3x      E DS                  EXTNAME(SDCUMTPD)
     D**WDDFNAC***           250    279                                                      CSW037A
     D**WkCode****           250    255                                                      CSW037A
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
     C                   IF        DDFNAC <> *BLANKS
     C                   EXSR      SrFundA
     C                   ENDIF
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        DDFNACOK <> 'Y'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ELSE
     C                   EVAL      CUFNAC = DDFNAC
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFundA  - Validate Fund Account Number                      *
      *                                                               *
      *****************************************************************
     C     SrFundA       BEGSR
      *
      ** Generate error if not blank and fund Id not defined.
      *                                                                                      CSW037A
     C     *LIKE         DEFINE    DDFNAC        WDDFNAC                                     CSW037A
     C                   MOVEL     DDFNAC        WDDFNAC                                     CSW037A
     C                   MOVEL     DDFNAC        WkCode            6                         CSW037A
      *
     C                   IF        DDFUND = *BLANKS  and
     C                             WDDFNAC <> *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'N'           DDFNACOK
     C                   MOVEL     'DDFNAC'      FldNamXAr(Idx)
     C                   MOVEL     'USR9278'     MsgIdXAr(IDx)
     C                   ENDIF
      *
     C                   IF        WDDFNAC <> *BLANKS
      *
     C                   IF        WkCode <> '/ACCT/'
     C                   ADD       1             Idx
     C                   MOVEL     'N'           DDFNACOK
     C                   MOVEL     'DDFNAC'      FldNamXAr(Idx)
     C                   MOVEL     'USR9279'     MsgIdXAr(IDx)
     C                   ELSE
      *
     C                   MOVEA     DDFNAC        WFUNAAR
     C*****              DO        24            WI                                          CSW037A
     C                   DO        40            WI                                          CSW037A
      *
     C     WFUNAAR(WI)   LOOKUP    ValSwChar(1)                           01
     C                   IF        NOT(*IN01) AND
     C                             WFUNAAr(WI) <> *BLANK
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'N'           DDFNACOK                                   AR855391
     C**********         MOVEL     'DDFNAC'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR9277'     MsgIdXAr(IDx)                              AR855391
     C                   EVAL      WIdx = WIdx + 1                                          AR855391
     C                   EVAL      DDFNACOK = 'W'                                           AR855391
     C                   EVAL      WFldNmXAr(WIdx) = 'DDFNAC'                               AR855391
     C                   EVAL      WMsgIDXAr(WIdx) = 'USR9277'                              AR855391
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
 
     C                   ENDIF
 
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
(c) Finastra International Limited 2004
** Valid swift characters
abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-?:().,'+
