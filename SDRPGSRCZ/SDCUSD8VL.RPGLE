     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer MT3xx BEI and Fund Info')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCUSD8VL - Customer Input Validation Controller for         *
      *              MT3xx BEI and Fund Information                   *
      *                                                               *
      *  Function: This module validates MT3xx BEI and Fund Info      *
      *            details for output into the Midas database.        *
      *                                                               *
      *  Component of: SDCUSDSIN                                      *
      *                SDCUSDCTL                                      *
      *                SDCUSDRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD024046           Date 11Dec13               *
      *  Prev Amend No. MD023456           Date 14Nov13               *
      *                 MD022557A          Date 03Oct13               *
      *                 CSW213             Date 03Jun13               *
      *                 AR855391           Date 27Oct11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW024  *CREATE    Date 31Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024046 -  Invalid LEI Accepted in MT3xx Receiver Party     *
      *              Information Field                                *
      *  MD023456 -  Error and warning descriptions were displayed    *
      *              twice in MT3xx BEI and Fund Details              *
      *  MD022557A - Incorrect validation in MT3xx receiver party     *
      *             information and LEI (Reopen)                      *
      *  CSW213 - SWIFT Changes 2013                                  *
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
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUDFV001
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
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
      ** Data Structure for SAR Details                                                       CSW037
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSW037
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                    CSW037
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSW037
      *
      ** New Customer in File Format
     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPD)
      *
      ** MT3xx BEI details screen error indicators
     D*OkCuMT3x****  E DS                  EXTNAME(SDECUSEPD)                                CSW037A
     D OkCuMT3x      E DS                  EXTNAME(SDECUMTPD)                                CSW037A
     D  WDDRINFOK              3      7                                                       CSW213
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
     D Idx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Index for update of error arrays
     D Ix              S              3  0
      *
      ** Response Mode
     D PRespMode       S              1A
      ** Fields defined for Enhancement CSW037                                                CSW037
                                                                                              CSW037
     D PRtCd           S              7A                                                      CSW037
     D POptn           S              7A                                                      CSW037
     D PSard           S              6A                                                      CSW037
     D CSW213          S              1A                                                      CSW213
     D WLEIC           S             20A                                                      CSW213
     D OKLEIC          S              1A                                                      CSW213
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SDCUDFV002
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
      /COPY WNCPYSRC,SDCUDFV003
      *
      ** MT3xx BEI Flag validation.
      *
      /COPY WNCPYSRC,SDCUDFV004
 
     C                   EXSR      SRBEIFlg
 
      /COPY WNCPYSRC,SDCUDFV005
      *
      ** Corporate BEI validation.
      *
      /COPY WNCPYSRC,SDCUDFV006
 
     C                   EXSR      SRCorBEI
 
      /COPY WNCPYSRC,SDCUDFV007
      *
      ** MT3xx Receiver Party Information validation.
      *
      /COPY WNCPYSRC,SDCUDFV008
 
     C                   EXSR      SRRecInf
                                                                                              CSW213
     C                   IF        CSW213 = 'Y'                                               CSW213
     C                             AND DDRI03 <> *BLANKS                                      CSW213
     C                   EXSR      SRLEIC                                                     CSW213
     C                   ENDIF                                                                CSW213
 
      /COPY WNCPYSRC,SDCUDFV009
      *
      ** Fund Identification validation.
      *
      /COPY WNCPYSRC,SDCUDFV010
 
     C                   EXSR      SRFunInf
 
      /COPY WNCPYSRC,SDCUDFV011
                                                                                              CSW037
     C     CSW037        IFEQ      'Y'                                                        CSW037
     C                   EXSR      SRFunAcN                                                   CSW037
     C                   ENDIF                                                                CSW037
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SDCUDFV012
 
      *****************************************************************
      *                                                               *
      *  SRBEIFlg - MT3xx BEI Flag validation                         *
      *                                                               *
      *****************************************************************
 
     C     SRBEIFlg      BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SDVCORP'
      *                             =======
      ** Return code
      *
     C                   PARM                    RetCodeOut
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
      ** MT3xx BEI details screen error indicators
     C                   PARM                    OkCuMT3x
      *
      ** New Customer in file format
     C                   PARM                    NwCuFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCorBEI - Corporate BEI validation                          *
      *                                                               *
      *****************************************************************
 
     C     SRCorBEI      BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SDVCBEI'
      *                             =======
      ** Return code
      *
     C                   PARM                    RetCodeOut
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
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRecInf - MT3xx Receiver Party Information validation       *
      *                                                               *
      *****************************************************************
 
     C     SRRecInf      BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SDVRINF'
      *                             =======
      ** Return code
      *
     C                   PARM                    RetCodeOut
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
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFunInf - Fund Identification validation                    *
      *                                                               *
      *****************************************************************
 
     C     SRFunInf      BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SDVFUND'
      *                             =======
      ** Return code
      *
     C                   PARM                    RetCodeOut
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
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
                                                                                              CSW213
      *****************************************************************                       CSW213
      /EJECT                                                                                  CSW213
      *****************************************************************                       CSW213
      *                                                               *                       CSW213
      *  SRLEIC   - LEI code validation                               *                       CSW213
      *                                                               *                       CSW213
      *****************************************************************                       CSW213
                                                                                              CSW213
     C     SRLEIC        BEGSR                                                                CSW213
      *                                                                                       CSW213
      ** Reset fields.                                                                        CSW213
      *                                                                                       CSW213
     C                   EXSR      SRResetErrs                                                CSW213
                                                                                              CSW213
     C                   IF        %SUBST(DDRI03:1:6) <> '/LEIC/'                             CSW213
     C                             OR %SUBST(DDRI03:7:20) = *BLANKS                           CSW213
     C                             OR %SUBST(DDRI03:27:14) <> *BLANKS                         CSW213
                                                                                              CSW213
     C                   ADD       1             Idx                                          CSW213
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)                               CSW213
     C                   MOVEL     '5046094'     MsgIDXAr(Idx)                                CSW213
     C                   MOVEL     'ERROR'       RetCodeOut                                   CSW213
     C                   MOVEL     *ALL'N'       WDDRINFOK                                  MD024046
     C                   EXSR      SRUpdatErrs                                              MD024046
                                                                                              CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      WLEIC = %SUBST(DDRI03:7:20)                                CSW213
                                                                                              CSW213
      *                                                                                       CSW213
      ** Call validation module.                                                              CSW213
      *                                                                                       CSW213
     C                   CALLB     'SDVLEIC'                                                  CSW213
      *                             =======                                                   CSW213
      ** Return code                                                                          CSW213
      *                                                                                       CSW213
     C                   PARM                    RetCodeOut                                   CSW213
      *                                                                                       CSW213
      ** LEI Code                                                                             CSW213
     C                   PARM                    WLEIC                                        CSW213
      *                                                                                       CSW213
      ** OUTPUT                                                                               CSW213
      ** ======                                                                               CSW213
      *                                                                                       CSW213
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW213
     C                   PARM                    FldNamXAr                                    CSW213
     C                   PARM                    MsgIDXAr                                     CSW213
     C                   PARM                    MsgDtaXAr                                    CSW213
      *                                                                                       CSW213
      ** LEI Code screen error indicators                                                     CSW213
     C                   PARM                    OkLEIC                                       CSW213
      *                                                                                       CSW213
     C**********         ENDIF                                                       CSW213 MD023456
      *                                                                                       CSW213
      ** Update error information.                                                            CSW213
      *                                                                                       CSW213
     C                   IF        RetCodeOut <> *BLANKS                                      CSW213
     C                   EVAL      FldNamXAr(1) = 'DDRI01'                                 MD022557A
     C                   MOVEL     *ALL'N'       WDDRINFOK                                    CSW213
     C                   EXSR      SRUpdatErrs                                                CSW213
     C                   ENDIF                                                                CSW213
     C                   ENDIF                                                              MD023456
                                                                                              CSW213
     C                   ENDSR                                                                CSW213
 
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW037
      *                                                               *                       CSW037
      *  SRFunAcN - Fund Account Number                               *                       CSW037
      *                                                               *                       CSW037
      *****************************************************************                       CSW037
                                                                                              CSW037
     C     SRFunAcN      BEGSR                                                                CSW037
      *                                                                                       CSW037
      ** Reset fields.                                                                        CSW037
      *                                                                                       CSW037
     C                   EXSR      SRResetErrs                                                CSW037
      *                                                                                       CSW037
      ** Call validation module.                                                              CSW037
      *                                                                                       CSW037
     C                   CALLB     'SDVFUNA'                                                  CSW037
      *                             =======                                                   CSW037
      ** Return code                                                                          CSW037
      *                                                                                       CSW037
     C                   PARM                    RetCodeOut                                   CSW037
      *                                                                                       CSW037
      ** New Customer in screen format - MT3xx BEI details                                    CSW037
     C                   PARM                    NwCuMT3x                                     CSW037
      *                                                                                       CSW037
      ** OUTPUT                                                                               CSW037
      ** ======                                                                               CSW037
      *                                                                                       CSW037
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW037
     C                   PARM                    FldNamXAr                                    CSW037
     C                   PARM                    MsgIDXAr                                     CSW037
     C                   PARM                    MsgDtaXAr                                    CSW037
                                                                                            AR855391
     C                   PARM                    WFldNmXAr                                  AR855391
     C                   PARM                    WMsgIDXAr                                  AR855391
     C                   PARM                    WMsgDtXAr                                  AR855391
      *                                                                                       CSW037
      ** MT3xx BEI details screen error indicators                                            CSW037
     C                   PARM                    OkCuMT3x                                     CSW037
      *                                                                                       CSW037
      ** New Customer in file format                                                          CSW037
     C                   PARM                    NwCuFilFmt                                   CSW037
      *                                                                                       CSW037
      ** Update error information.                                                            CSW037
      *                                                                                       CSW037
     C                   IF        RetCodeOut <> *BLANKS                                      CSW037
     C                   EXSR      SRUpdatErrs                                                CSW037
     C                   ENDIF                                                                CSW037
                                                                                              CSW037
     C                   ENDSR                                                                CSW037
                                                                                              CSW037
      *****************************************************************                       CSW037
      /EJECT                                                                                  CSW037
      *****************************************************************
      *                                                               *
      *  SRResetErrs - Reset error information that is received back  *
      *                from each validation module.                   *
      *                                                               *
      *****************************************************************
 
     C     SRResetErrs   BEGSR
 
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
 
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdatErrs - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
 
     C     SRUpdatErrs   BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     FldNamXar     FldNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set error index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FLDNAMEARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             IDX
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(Ix)
     C                   MOVE      *BLANKS       MSGIDARR(Ix)
     C                   MOVE      *BLANKS       MSGDTAARR(Ix)
     C                   Eval      IDX = ArrayMax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFldNamArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(Ix)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(Ix)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set warning index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFLDNAMARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             WIDX
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(Ix)
     C                   MOVE      *BLANKS       WMSGIDARR(Ix)
     C                   MOVE      *BLANKS       WMSGDTAARR(Ix)
     C                   Eval      WIDX = ArrayMax - 1
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
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** New Customer in screen format - MT3xx BEI details
     C                   PARM                    NwCuMT3x
      *
      ** OUTPUT
      ** ======
      *
      ** MT3xx BEI details screen error indicators
     C                   PARM                    OkCuMT3x
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** New Customer in file format
     C                   PARM                    NwCuFilFmt
      *                                                                                       CSW213
      ** Check if SWIFT 2013 is installed                                                     CSW213
      *                                                                                       CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       PRTCD                                        CSW213
                                                                                              CSW213
     C                   IF        PRTCD   = 'CSW2013'                                        CSW213
     C                   EVAL      CSW213 = 'Y'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      CSW213 = 'N'                                               CSW213
     C                   ENDIF                                                                CSW213
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SDCUDFV013
 
      ** Check if CSW037 is installed                                                         CSW037
     C                   EVAL      CSW037 = 'N'                                               CSW037
                                                                                              CSW037
     C                   CALLB     'AOSARDR0'                                                 CSW037
     C                   PARM      *BLANKS       PRtCd                                        CSW037
     C                   PARM      '*VERIFY'     POptn                                        CSW037
     C                   PARM      'CSW037'      PSard                                        CSW037
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW037
                                                                                              CSW037
      ** Database error                                                                       CSW037
                                                                                              CSW037
     C                   IF        (PRtCd <> *BLANKS) and                                     CSW037
     C                             (PRtCd <> '*NRF   ')                                       CSW037
     C                   EVAL      DBKEY = 'CSW037'                                           CSW037
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW037
     C                   EVAL      DBASE = 001                                                CSW037
     C                   EXSR      *PSSR                                                      CSW037
     C                   ENDIF                                                                CSW037
                                                                                              CSW037
     C                   IF        PRtCd = *BLANKS                                            CSW037
     C                   MOVEL     'Y'           CSW037            1                          CSW037
     C                   ENDIF                                                                CSW037
                                                                                              CSW037
     C                   ENDSR
 
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
