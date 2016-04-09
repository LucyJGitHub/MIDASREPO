     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments validation controller 3')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY5VL - Incoming Payments Validation Controller 5        *
      *                                                               *
      *  Function: This module validates Incoming Payments Margin     *
      *            information fields for input into the Midas        *
      *            database.                                          *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CAP084             Date 25Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Recompiled over changed FTIPY6PD.                   *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTIPY5V001
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
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *
      ** Incoming Payments Margin info from incoming transaction
      ** - screen format
     D NwIP6ScnFmt   E DS                  EXTNAME(FTIPY6PD)
      *                                                                                       CER030
      ** Incoming Payments Extended Narrative incoming transaction                            CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     D NwIP6AScnFmt  E DS                  EXTNAME(FTIPY6APD)                                 CER030
      *
      ** Incoming Payments Margin info error indicators
     D FTEIPY5       E DS                  EXTNAME(FTEIPY5PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER030
      *                                                                                       CER030
      ** Short data structure                                                                 CER030
      *                                                                                       CER030
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER030
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Index for update of error arrays
     D Ix              S              3  0
      *
      ** Response Mode
     D PResponse       S              1A
      *                                                                                       CER030
      ** Fields defined for CER030                                                            CER030
      *                                                                                       CER030
     D CER030          S              1A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
     D PSard           S              6A                                                      CER030
     D POptn           S              7A                                                      CER030
     D PRtcd           S              7A                                                      CER030
      *                                                                                       CER030
     D DDTTCD          S              3A                                                      CER030
     D I2INTTCD        S              3A                                                      CER030
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,FTIPY5V002
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
      /COPY WNCPYSRC,FTIPY5V003
      *
      ** Margin Information Validation.
      *
      /COPY WNCPYSRC,FTIPY5V004
      *
     C                   IF        BGN0ST = 'Y'
     C                   EXSR      SRMINF
     C                   ELSE
     C                   EVAL      DDFXMP = *BLANKS
     C                   EVAL      DDMBSI = *BLANK
     C                   EVAL      DDMSIG = *BLANK
     C                   ENDIF
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' OR CGL013 = 'Y'                               CER030
     C                   EXSR      SRTrty                                                     CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        CER031 = 'Y'                                               CER030
     C                   EXSR      SRExtNarr                                                  CER030
     C                   ENDIF                                                                CER030
      *
      /COPY WNCPYSRC,FTIPY5V005
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,FTIPY5V006
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMINF - Margin Information Validation                       *
      *                                                               *
      *****************************************************************
      *
     C     SRMINF        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIMGNI'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Incoming Payments Margin info from incoming transaction
      ** - screen format
     C                   PARM                    NwIP6ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Margin info error indicators
     C                   PARM                    FTEIPY5
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETERRS - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *                                                               *
      *****************************************************************
      *
     C     SRResetErrs   BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
      *
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDATERRS - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
      *
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
      ** Set Error Index.
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
      ** Set Warning Index.
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
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       CER030
      *                                                               *                       CER030
      *  SRTrty - Transaction Type validation subroutine              *                       CER030
      *                                                               *                       CER030
      *  Called by: Main Processing                                   *                       CER030
      *                                                               *                       CER030
      *  Calls: SRResetErrs , SRUpdatErrs                             *                       CER030
      *                                                               *                       CER030
      *****************************************************************                       CER030
      *                                                                                       CER030
     C     SRTrty        BEGSR                                                                CER030
      *                                                                                       CER030
     C                   EXSR      SRResetErrs                                                CER030
      *                                                                                       CER030
     C                   CALLB     'FTVTRTYP'                                                 CER030
      *                                                                                       CER030
     C                   PARM                    RetCodeOut                                   CER030
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives incoming transaction                           CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    NwIP6AScnFmt                                 CER030
      *                                                                                       CER030
      ** Incoming Payments Transaction Code from screen 2 level 2 for                         CER030
      ** defaulting value of Retail Transaction Type                                          CER030
      *                                                                                       CER030
     C                   PARM                    DDTTCD                                       CER030
      *                                                                                       CER030
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CER030
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CER030
      ** Mode = '*RPR  ' (Repair Function)                                                    CER030
      ** Mode = '*SIN  ' (Screen Input Function)                                              CER030
      *                                                                                       CER030
     C                   PARM                    PMode                                        CER030
      *                                                                                       CER030
      ** OUTPUT                                                                               CER030
      *                                                                                       CER030
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER030
     C                   PARM                    FldNamXAr                                    CER030
     C                   PARM                    MsgIdXAr                                     CER030
     C                   PARM                    MsgDtaXAr                                    CER030
      *                                                                                       CER030
      ** Incoming Payments Margin info error indicators                                       CER030
      *                                                                                       CER030
     C                   PARM                    FTEIPY5                                      CER030
      *                                                                                       CER030
      ** Incoming Payments for file update - file format                                      CER030
      *                                                                                       CER030
     C                   PARM                    NwIPFilFmt                                   CER030
      *                                                                                       CER030
      ** Extension Valid File Value for Transaction code                                      CER030
      *                                                                                       CER030
     C                   PARM                    I2INTTCD                                     CER030
      *                                                                                       CER030
      ** Update error information.                                                            CER030
      *                                                                                       CER030
     C                   IF        RetCodeOut <> *BLANKS                                      CER030
     C                   EXSR      SRUpdatErrs                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDSR                                                                CER030
      *                                                                                       CER030
      *****************************************************************                       CER030
      /EJECT                                                                                  CER030
      *****************************************************************                       CER030
      *                                                               *                       CER030
      *  SRExtNarr -  Extended Narrative validation subroutine        *                       CER030
      *                                                               *                       CER030
      *  Called by: Main Processing                                   *                       CER030
      *                                                               *                       CER030
      *  Calls: SRResetErrs, SRUpdatErrs                              *                       CER030
      *                                                               *                       CER030
      *****************************************************************                       CER030
      *                                                                                       CER030
     C     SRExtNarr     BEGSR                                                                CER030
      *                                                                                       CER030
     C                   EXSR      SRResetErrs                                                CER030
      *                                                                                       CER030
     C                   CALLB     'FTVEXTNAR'                                                CER030
      *                                                                                       CER030
     C                   PARM                    RetCodeOut                                   CER030
      *                                                                                       CER030
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction                       CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    NwIP1ScnFmt                                  CER030
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives incoming transaction                           CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    NwIP6AScnFmt                                 CER030
      *                                                                                       CER030
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CER030
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CER030
      ** Mode = '*RPR  ' (Repair Function)                                                    CER030
      ** Mode = '*SIN  ' (Screen Input Function)                                              CER030
      *                                                                                       CER030
     C                   PARM                    PMode                                        CER030
      *                                                                                       CER030
      ** OUTPUT                                                                               CER030
      *                                                                                       CER030
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER030
      *                                                                                       CER030
     C                   PARM                    FldNamXAr                                    CER030
     C                   PARM                    MsgIdXAr                                     CER030
     C                   PARM                    MsgDtaXAr                                    CER030
      *                                                                                       CER030
      ** Incoming Payments Margin info error indicators                                       CER030
      *                                                                                       CER030
     C                   PARM                    FTEIPY5                                      CER030
      *                                                                                       CER030
      ** Incoming Payments for file update - file format                                      CER030
      *                                                                                       CER030
     C                   PARM                    NwIPFilFmt                                   CER030
      *                                                                                       CER030
      ** Update error information.                                                            CER030
      *                                                                                       CER030
     C                   IF        RetCodeOut <> *BLANKS                                      CER030
     C                   EXSR      SRUpdatErrs                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDSR                                                                CER030
      *                                                                                       CER030
      *****************************************************************                       CER030
      /EJECT                                                                                  CER030
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
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Incoming Payments Margin info from incoming transaction
      ** - screen format
     C                   PARM                    NwIP6ScnFmt
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives incoming transaction                           CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    NwIP6AScnFmt                                 CER030
      *                                                                                       CER030
      ** Incoming Payments Transaction Code from screen 2 level 2 for                         CER030
      ** defaulting value of Retail Transaction Type                                          CER030
      *                                                                                       CER030
     C                   PARM                    DDTTCD                                       CER030
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** OUTPUT
      ** ======
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
      ** Incoming Payments Margin info error indicators
     C                   PARM                    FTEIPY5
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *                                                                                       CER030
      ** Extension Valid File Value for Transaction code                                      CER030
      *                                                                                       CER030
     C                   PARM                    I2INTTCD                                     CER030
      *                                                                                       CER030
      ** Check the switchable feature CER030                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 001                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CER031                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 002                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CGL013                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 003                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,FTIPY5V007
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
