     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate MT3xx Corporate BEI')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCBEI - Validate MT3xx Corporate BEI                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD055903           Date 14Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD019970           Date 19Aug14               *
      *                 AR855391           Date 27Oct11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW024  *CREATE    Date 31Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055903 - SD: error while amending Customer details. Added  *
      *             validation for amending customer                  *
      *  MD046248 - Finastra Rebranding                               *
      *  MD019970 - Customer Details Amendment Error. Added validation*
      *             for MT3xx Corporate BEI.                          *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *             (CSD091 - Overrideable Errors Configurability     *
      *             Enabler Phase 2)                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
      ** New Customer in File Format
     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPD)
      *
      ** MT3xx BEI details screen error indicators
     D OkCuMT3x      E DS                  EXTNAME(SDECUMTPD)
      *
      ** New Customer in screen format - MT3xx BEI details
     D NwCuMT3x      E DS                  EXTNAME(SDCUMTPD)
      *
      ** Data structure for counterparty details
     DSDCNST         E DS                  EXTNAME(SDCNSTPD)
      *
      ** Data structure for customer details
     DSDCUST         E DS                  EXTNAME(SDCUSTPD)
     D QQDFA1        E                     EXTFLD(QQDFAC)                                     CGL029
      *
      ** DS for BIC directory details
     DMEBICD         E DS                  EXTNAME(MEBICDPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning message ids, etc.
     D WIx             S              3P 0
      *
      ** Work variables for SD0011U
     D PRTCD           S              7A
     D PCBEI           S             12A
     D PSICL           S              1A
     D PC6NL           S              1A
     D PINVC           S              1A
     D PSIL8           S              1A
     D PEMSP           S              1A
     D PBICL           S              1A
      *
      ** Work variables for ME1400
     D PBICC           S              8A
     D PBICB           S              3A
     D PCUST           S              1A
     D PCNST           S              1A
     D PBICD           S              1A
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
     C                   EVAL      WIx = 0
      *
      ** Validate Corporate BEI Flag if entered.
      *
     C                   IF        DDCBEI <> *BLANKS
     C                   EXSR      SrCorBEI
     C                   ENDIF
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        DDCBEIOK <> 'Y'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        DDCBEIOK <> 'N'
     C                   EVAL      CUCBEI = DDCBEI
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCorBEI - Validate Corporate BEI                            *
      *                                                               *
      *****************************************************************
     C     SrCorBEI      BEGSR
      *
      ** Generate error if not blank and either Corporate Flag
      ** is not 'Y'
      *
     C                   IF        DDCORP <> 'Y' AND
     C                             DDCBEI <> *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'N'           DDCBEIOK
     C                   MOVEL     'DDCORP'      FldNamXAr(Idx)
     C                   MOVEL     'USR9130'     MsgIdXAr(IDx)
     C                   GOTO      EndCorBEI
     C                   ENDIF
      *
      ** Call SD0012U to check if valid SWIFT id if module
      *
     C                   CALL      'SD0011U1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDCBEI        PCBEI
     C                   PARM      *BLANK        PSICL
     C                   PARM      *BLANK        PC6NL
     C                   PARM      *BLANK        PINVC
     C                   PARM      *BLANK        PSIL8
     C                   PARM      *BLANK        PEMSP
     C                   PARM      *BLANK        PBICL
      *
      ** ID may have no embedded spaces
     C     PEMSP         IFEQ      '1'
     C**********         MOVE      'N'           DDCBEIOK                                   AR855391
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'DDCBEI'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR9131'     MsgIdXAr(Idx)                              AR855391
     C**********         GOTO      EndCorBEI                                                AR855391
     C                   MOVE      'W'           DDCBEIOK                                   AR855391
     C                   ADD       1             WIx                                        AR855391
     C                   MOVEL     'DDCBEI'      WFldNmXAr(WIx)                             AR855391
     C                   MOVEL     'USR9131'     WMsgIdXAr(WIx)                             AR855391
     C                   ENDIF
      *
      ** ID must be 8 or 11 characters in length
     C     PSICL         IFEQ      '1'
     C     PSIL8         OREQ      '1'
     C     PBICL         OREQ      '1'
     C                   MOVE      'N'           DDCBEIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCBEI'      FldNamXAr(Idx)
     C                   MOVEL     'USR9132'     MsgIdXAr(Idx)
     C                   GOTO      EndCorBEI
     C                   ENDIF
      *
      ** First 6 characters must be all alpha
     C     PC6NL         IFEQ      '1'
     C**********         MOVE      'N'           DDCBEIOK                                   AR855391
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'DDCBEI'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR9133'     MsgIdXAr(Idx)                              AR855391
     C**********         GOTO      EndCorBEI                                                AR855391
     C                   MOVE      'W'           DDCBEIOK                                   AR855391
     C                   ADD       1             WIx                                        AR855391
     C                   MOVEL     'DDCBEI'      WFldNmXAr(WIx)                             AR855391
     C                   MOVEL     'USR9133'     WMsgIdXAr(WIx)                             AR855391
     C                   ENDIF
      *
      ** No invalid characters may be entered
     C     PINVC         IFEQ      '1'
     C**********         MOVE      'N'           DDCBEIOK                                   AR855391
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'DDCBEI'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR9134'     MsgIdXAr(Idx)                              AR855391
     C**********         GOTO      EndCorBEI                                                AR855391
     C                   MOVE      'W'           DDCBEIOK                                   AR855391
     C                   ADD       1             WIx                                        AR855391
     C                   MOVEL     'DDCBEI'      WFldNmXAr(WIx)                             AR855391
     C                   MOVEL     'USR9134'     WMsgIdXAr(WIx)                             AR855391
     C                   ENDIF
 
     C                   MOVEL     DDCBEI        PBICC
     C                   MOVE      DDCBEI        PBICB
      *
      ** Call program to validate ID
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PBICC
     C                   PARM                    PBICB
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       PCUST
     C                   PARM      *BLANKS       PCNST
     C                   PARM      *BLANKS       PBICD
      *
      ** BEI identifier not found in file
     C     PRTCD         IFEQ      'MIN0244'
     C     PRTCD         OREQ      'MIN0245'
     C     PRTCD         OREQ      'MIN0246'
     C                   MOVE      'W'           DDCBEIOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDCBEI'      WFldNmXAr(WIx)
     C                   MOVEL     'USR9135'     WMsgIdXAr(WIx)
     C                   ENDIF
      *                                                                                     MD019970
      ** MT3xx Corporate BEI already exist in SDCUSTPD                                      MD019970
     C     PRTCD         IFEQ      'MIN0247'                                                MD019970
     C     BBCUST        ANDNE     CUCUST                                                   MD055903
     C                   ADD       1             Idx                                        MD019970
     C                   MOVEL     'N'           DDCBEIOK                                   MD019970
     C                   MOVEL     'DDCBEI'      FldNamXAr(Idx)                             MD019970
     C                   MOVEL     '5047300'     MsgIdXAr(IDx)                              MD019970
     C                   ENDIF                                                              MD019970
 
     C     EndCorBEI     ENDSR
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
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
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
(c) Finastra International Limited 2001
