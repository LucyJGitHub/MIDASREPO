     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees Validate and Update')            *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLFEVU - Dealing Fees Validate and Update                  *
      *                                                               *
      *  Function: This program validates Dealing Fees transaction    *
      *            for input into the Midas database.                 *
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG21121           Date 19Sep08               *
      *                 248530             Date 15Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAS011  *CREATE    Date 16May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG21121 - MT202/MT210 dealing fees                          *
      *  248530 - CPF4293 error occurred in MMEIRDL0 upon input of a  *
      *           DL Fee. Override this file with SHARE(*NO).         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------
 
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
 
      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming transaction in screen format
     D DLFEScnFmt    E DS                  EXTNAME(DLDLFEPD)
 
      ** Valid file layout
     D ValidDLFE     E DS                  EXTNAME(DLVDLFEPD)
     D                                     PREFIX(V_)
     D  VFREC                166    220
     D**VFPAY***             235    289                                                      CSF011A
     D  VFPAY                235    779                                                      CSF011A
 
      ** Current transaction record in file format
     D DLFEFilFmt    E DS                  EXTNAME(DLFEED)
 
      ** Current transaction in screen format
     D CurTrDLFE     E DS                  EXTNAME(DLDLFEPD)
     D                                     PREFIX(CT)
 
      ** Dealing Fees error indicators
     D OKDLFE        E DS                  EXTNAME(DLEDLFEPD)
 
     D DealsDtlC     E DS                  EXTNAME(DEALSDC)
     D                                     PREFIX(C_)
 
     D DealsDtlD     E DS                  EXTNAME(DEALSDD)
     D                                     PREFIX(D_)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SAR_LCD       E                     EXTFLD(LCD)
 
      ** First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** File Receive Instructions
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D  FLREC                 21     75
 
      ** File Payment Instructions
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D  FLPAY                 21    565
 
      ** File FRA/IRS Instructions
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
 
      ** Screen Receive Instructions
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
 
      ** Screen Payment Instructions
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
 
      ** Screen FRA/IRS Instructions
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
 
      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
     D OKPayInsDS      DS
     D  DDPscyOK                      1A   INZ('Y')
     D  DDPstmOK                      1A   INZ('Y')
     D  DDPonxOK                      1A   INZ('Y')
     D  DDRvnoOK                      1A   INZ('Y')
     D  DDCvmrOK                      1A   INZ('Y')
     D  DDPocnOK                      1A   INZ('Y')
     D  DDPobnOK                      1A   INZ('Y')
     D  DDRcrnOK                      1A   INZ('Y')
     D  DDRcraOK                      1A   INZ('Y')
     D  DDPibnOK                      1A   INZ('Y')
     D  DDPibaOK                      1A   INZ('Y')
     D  DDAwbnOK                      1A   INZ('Y')
     D  DDAwbaOK                      1A   INZ('Y')
     D  DDBennOK                      1A   INZ('Y')
     D  DDBenaOK                      1A   INZ('Y')
     D  DDDtp1OK                      1A   INZ('Y')
     D  DDDtp2OK                      1A   INZ('Y')
     D  DDDtp3OK                      1A   INZ('Y')
     D  DDDtp4OK                      1A   INZ('Y')
     D  DDDchgOK                      1A   INZ('Y')
     D  DDIc72OK                      1A   INZ('Y')
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')
 
      ** Flags to indicate whether Receive Settlement instruction fields
      **  are valid
     D OKRecInsDS      DS
     D  DDRscyOK                      1A   INZ('Y')
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')
 
      ** Flags to indicate whether FRA/IRS instruction fields are valid
     D OKFRAInsDS      DS
     D  DDDsr1OK                      1A   INZ('Y')
     D  DDDsr2OK                      1A   INZ('Y')
     D  DDDsr3OK                      1A   INZ('Y')
     D  DDDsr4OK                      1A   INZ('Y')
     D  DDDsr5OK                      1A   INZ('Y')
     D  DDDsr6OK                      1A   INZ('Y')
     D  DDSsr1OK                      1A   INZ('Y')
     D  DDSsr2OK                      1A   INZ('Y')
     D  DDSsr3OK                      1A   INZ('Y')
     D  DDSsr4OK                      1A   INZ('Y')
     D  DDSsr5OK                      1A   INZ('Y')
     D  DDSsr6OK                      1A   INZ('Y')
     D  DDCnd1OK                      1A   INZ('Y')
     D  DDCnd2OK                      1A   INZ('Y')
     D  DDCnd3OK                      1A   INZ('Y')
     D  DDCnd4OK                      1A   INZ('Y')
     D  DDCnd5OK                      1A   INZ('Y')
     D  DDCnd6OK                      1A   INZ('Y')
     D  DDIsdaOK                      1A   INZ('Y')
     D  DDAgtyOK                      1A   INZ('Y')
     D  DDAgdtOK                      1A   INZ('Y')
     D  DDAgvvOK                      1A   INZ('Y')
 
     D PCMD            S            100    DIM(2) CTDATA PERRCD(1)                            248530
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc in amend validation
     D AmIdx           S              3P 0 INZ(0)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
 
      ** Timestamp for the transaction
     D PTimeStamp      S               Z
 
      ** Overall Transaction status, to be passed to the message handler
     D PTranStatus     S              1A
 
     D PRtCd           S              7A
     D POptn           S              7A
     D PStat           S             16A
     D PRespMode       S              1A
     D PAmendOk        S              1A
     D PActnOK         S              1A
     D PDlnoOK         S              1A
     D PDlFSeqOK       S              1A
     D PUpdateYN       S              1A
     D PAPIRetCd       S              1A
     D PModeofOp       S              6A
     D PAPFOTranID     S             20A
     D PResetErrs      S              1A
     D PBuffer         S           6000A
 
     D WrkDftSettl     S              1A
     D FeeBranch       S              3A
 
     D PCMDLEN         S             15  5                                                    248530
                                                                                              248530
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Incoming transaction is broken into 500A fields, so that a common CL
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break these 500A fields by loading them into
      ** the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     DLFEScnFmt
 
      ** Reset variables gradually updated
     C                   EXSR      SrResetCycle
 
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp
 
      ** Validate action code
     C                   EXSR      SrValActCode
 
      ** If error in validation of action code, fail this input
     C                   IF        Idx <> *ZERO
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Processing depends upon action code
     C                   SELECT
 
      ** Processing for inserts
     C                   WHEN      DDACTN = 'I'
 
     C                   EXSR      SrValTranDtls
     C                   EVAL      WrkDftSettl = 'Y'
     C                   EXSR      SrChkSettmts
     C                   EXSR      SrValSettmts
 
      ** Processing for amends or changes
     C                   WHEN      DDACTN = 'A'
     C                   EXSR      SrSetupAmd
     C                   EXSR      SrValTranDtls
     C                   EVAL      WrkDftSettl = 'N'
     C                   EXSR      SrChkSettmts
     C                   EXSR      SrValSettmts
     C                   EXSR      SrValAmend
 
      ** Processing for Authorise
     C                   WHEN      DDACTN = 'X'
     C                   EXSR      SrSetupAmd
     C                   EXSR      SrValTranDtls
     C                   EVAL      WrkDftSettl = 'N'
     C                   EXSR      SrChkSettmts
     C                   ENDSL
 
     C     INVALID       TAG
 
      ** Write to database
     C                   IF        PUpdateYN = 'Y' AND
     C                             Idx = *ZERO
     C                   EXSR      SrSetUpValid
     C                   EXSR      SrUpdatedb
     c                   MOVE      V_DLFSEQ      DDFSEQ
     C                   ENDIF
 
     C                   MOVE      *ON           *INLR
 
      ** Remerge buffer with all relevant data structures
     C                   EVAL      PBuffer = DLFEScnFmt + ##RECS + ##PAYS
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValActCode - Validate action code versus the transaction    *
      *                number provided                                *
      *                                                               *
      *****************************************************************
     C     SrValActCode  BEGSR
 
      ** Validate action code versus transaction IDs supplied
     C                   RESET                   ReturnCode
 
     C                   CALLB     'DLDLFERTV'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS
      ** Return code
     C                   PARM      *BLANK        ReturnCode
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    PModeofOp
 
      ** Response mode
     C                   PARM      'S'           PRespMode
 
      ** Action Code
     C                   PARM                    DDACTN
 
      ** Front Office Transaction ID
     C                   PARM                    PAPFOTranID
 
      ** Deal number
     C                   PARM                    DDDLNO
 
      ** Fee Sequence
     C                   PARM                    DDFSEQ
 
      ** OUTPUTS
      ** Transaction Details in File Format
     C                   PARM                    DLFEFilFmt
 
      ** OK - Action code
     C                   PARM                    PActnOK
 
      ** OK - Deal Number
     C                   PARM                    PDlnoOK
 
      ** OK - Fee sequence
     C                   PARM                    PDlFSeqOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Deals Detail (DEALSDC)
     C                   PARM                    DealsDtlC
 
      * Deals Detail (DEALSDD)
     C                   PARM                    DealsDtlD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetupAmd - Set up fields that are needed in the validation  *
      *              of amendments                                    *
      *                                                               *
      *****************************************************************
     C     SrSetupAmd    BEGSR
 
      ** For amends, put the complete (pre-existing) transaction into the valid
      ** file record - fields in this will be updated during processing
 
     C                   MOVE      DLFEFilFmt    ValidDLFE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValTranDtls - Validate the main transaction details         *
      *                                                               *
      *****************************************************************
     C     SrValTranDtls BEGSR
 
      ** Validate transaction details
     C                   RESET                   ReturnCode
 
     C                   CALLB     'DLDLFEVAL'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
 
      ** INPUTS
      ** Response mode
     C                   PARM      'S'           PRespMode
 
      ** Incoming transaction details (screen format)
     C                   PARM                    DLFEScnFmt
 
      ** OUTPUTS
      ** Field OK flags (DS) from/to caller
     C                   PARM                    OKDLFE
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      ** Valid Dealing Fees Transaction (DS) from/to caller
     C                   PARM                    ValidDLFE
 
      ** Deals Detail (DEALSDC)
     C                   PARM                    DealsDtlC
 
      ** Deals Detail (DEALSDD)
     C                   PARM                    DealsDtlD
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValAmend - Check whether the fields amended are amendable   *
      *                                                               *
      *****************************************************************
     C     SrValAmend    BEGSR
 
     C                   CALLB     'DLDLFECVT'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
 
      ** INPUTS
      ** Return Code
     C                   PARM      *BLANKS       RetCodeIn
 
      ** Transaction Details in File Format
     C                   PARM                    DLFEFilFmt
 
      ** OUTPUTS
      ** Current transaction in screen format
     C                   PARM                    CurTrDLFE
 
      ** Status
     C                   PARM                    PStat
 
 
     C                   CALLB     'DLDLFEAMD'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
 
      ** INPUTS
      ** Return Code
     C                   PARM      *BLANKS       ReturnCode
 
      ** New Deal in screen format (Incoming transaction)
     C                   PARM                    DLFEScnFmt
 
      ** Current Deal details in screen format
     C                   PARM                    CurTrDLFE
 
      ** Current Deal details in file format
     C                   PARM                    DLFEFilFmt
 
      ** OUTPUTS
      ** Field OK flags (DS) from/to caller
     C                   PARM                    OKDLFE
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    AmIdx
 
      ** Amendments OK
     C                   PARM                    PAmendOk
 
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           PResetErrs
 
 
      ** If any errors overwrite previous error information
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrResetCycle - Reset error information that is gradually      *
      *                updated during each run of this program        *
      *                                                               *
      *****************************************************************
     C     SrResetCycle  BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurTrDLFE
 
     C                   MOVE      *ALL'Y'       OKDLFE
 
     C                   CLEAR                   ValidDLFE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetUpValid - Set up additional fields that are needed on    *
      *                the valid file record                          *
      *                                                               *
      *****************************************************************
     C     SrSetUpValid  BEGSR
 
     C                   SELECT
 
     C                   WHEN      DDACTN = 'I'
     C                   EVAL      V_DLRECI = 'D'
 
     C                   WHEN      DDACTN = 'D'
     C                   MOVE      DLFEFilFmt    ValidDLFE
     C                   EVAL      V_DLRECI = 'R'
     C                   EVAL      V_DLLCDT = 'D'
 
     C                   WHEN      DDACTN = 'E'
     C                   MOVE      DLFEFilFmt    ValidDLFE
 
     C                   WHEN      DDACTN = 'X'
     C                   MOVE      DLFEFilFmt    ValidDLFE
     C                   EVAL      V_DLLCDT = 'X'
     C                   ENDSL
 
     C                   EVAL      PTranStatus = 'S'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUpdatedb - Update database                                  *
      *                                                               *
      *****************************************************************
     C     SrUpdatedb    BEGSR
                                                                                              248530
      ** Override MMEIRDL0                                                                    248530
                                                                                              248530
     C                   Z-ADD     32            PCMDLEN                                      248530
     C                   CALL      'QCMDEXC'                                                  248530
     C                   PARM                    PCMD(1)                                      248530
     C                   PARM                    PCMDLEN                                      248530
 
     C                   CALLB     'DLDLFEUPD'
 
     C                   PARM                    RetCodeOut
     C                   PARM                    ValidDLFE
                                                                                              248530
      ** Delete override of MMEIRDL0                                                          248530
                                                                                              248530
     C                   Z-ADD     21            PCMDLEN                                      248530
     C                   CALL      'QCMDEXC'                                                  248530
     C                   PARM                    PCMD(2)                                      248530
     C                   PARM                    PCMDLEN                                      248530
 
      ** If there were any errors in the update functions, rollback any
      ** updates (done in *PSSR) and end this program. Otherwise commit.
 
     C                   IF        RetCodeOut <> *BLANK  AND
     C                             RetCodeOut <> '*RECUPD'
     C                   MOVEL     '0'           PAPIRetCd
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C                   IF        RetCodeOut = '*RECUPD'
     C                   Z-ADD     1             IDx
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM1000'     MsgIdArr(1)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkSettmts - Check settlement instructions                 *
      *                                                               *
      *****************************************************************
     C     SrChkSettmts  BEGSR
 
      ** Determine if pay settlement should be protected
 
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'D'
     C     DDACTN        OREQ      'X'
     C                   MOVE      'Y'           ##PPAY            1
     C                   MOVE      'Y'           ##PREC            1
     C                   ENDIF
 
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVE      'N'           ##PPAY
     C                   MOVE      'N'           ##PREC
     C                   ENDIF
 
     C     DDACTN        IFNE      'I'
     C     WrkDftSettl   OREQ      'Y'
 
      ** Set up payment instructions
      ** (on insertions, these fields will be zero/blank)
     C                   MOVEL     VFPAY         FLPAY
     C                   MOVEL     V_DLPSTM      FLPSTM
     C                   MOVEL     V_DLPONS      FLPONS
     C                   MOVEL     V_DLCVMR      FLCVMR
     C                   MOVEL     V_DLSCCY      FLPSCY
     C                   MOVEL     V_DLICCY      FLIC72
 
      ** Set up receive instructions
      ** (on insertions, these fields will be zero/blank)
 
     C                   MOVEL     VFREC         FLREC
     C                   MOVEL     V_DLRSTM      FLRSTM
     C                   MOVEL     V_DLRONS      FLRONS
     C                   MOVEL     V_DLSCCY      FLRSCY
 
     C                   ENDIF
 
      ** Determine parameters for settlement details input
     C                   EXSR      DETP@S
 
     C     ##PAYS        IFEQ      *BLANK
     C     ##RECS        ANDEQ     *BLANK
 
     C                   CALLB     'ZASETINCVT'
 
      ** INPUTS (File formats)
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM      *BLANK        ##FRIF
 
      ** OUTPUTS (Screen formats)
 
     C                   PARM      *BLANK        ##PAYS
     C                   PARM      *BLANK        ##RECS
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      DDFCCY        InRCCY                                      CSF011A
     C                   PARM      DDFCCY        InPCCY                                      CSF011A
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DETP@S - Determine parameters for settlement details screen  *
      *                                                               *
      *****************************************************************
     C     DETP@S        BEGSR
 
      ** Validate settlement account against Fee payment date
 
     C     V_DLPYON      IFEQ      'S'
     C     V_DLPYON      OREQ      ' '
     C                   MOVE      V_DLPSTD      ##DATR
     C                   MOVE      V_DLPSTD      ##DATP
     C                   ENDIF
 
     C     V_DLPYON      IFEQ      'N'
     C                   MOVE      V_DLNPYD      ##DATR
     C                   MOVE      V_DLNPYD      ##DATP
     C                   ENDIF
 
     C     V_DLPYON      IFEQ      'E'
     C                   MOVE      V_DLPEND      ##DATR
     C                   MOVE      V_DLPEND      ##DATP
     C                   ENDIF
 
      ** If amend, enquire, authorise or delete
      ** move settlement file fields to screen fields
      ** Else clear settlement screen fields
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'D'
 
      ** Set up payment instructions
      ** (on insertions, these fields will be zero/blank)
     C                   MOVEL     VFPAY         FLPAY
     C                   MOVEL     V_DLPSTM      FLPSTM
     C                   MOVEL     V_DLPONS      FLPONS
     C                   MOVE      V_DLOSBR      FLPOBR
     C                   MOVEL     V_DLSCCY      FLPSCY
     C                   MOVEL     V_DLICCY      FLIC72
 
      ** Set up receive instructions
      ** (on insertions, these fields will be zero/blank)
 
     C                   MOVEL     VFREC         FLREC
     C                   MOVEL     V_DLRSTM      FLRSTM
     C                   MOVEL     V_DLRONS      FLRONS
     C                   MOVE      V_DLOSBR      FLROBR
     C                   MOVEL     V_DLSCCY      FLRSCY
 
     C                   ELSE
     C                   MOVEL     *BLANKS       ##RECF
     C                   MOVEL     *BLANKS       ##PAYF
     C                   MOVEL     *BLANKS       ##FRIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValSettmts - Validate settlement instructions               *
      *                                                               *
      *****************************************************************
     C     SrValSettmts  BEGSR
 
      ** The called module requires that the customer number/name is valid,
      ** if it is not, exit from this subroutine.
     C                   IF        OKCUST <> 'Y'
     C                   GOTO      ValSetExit
     C                   ENDIF
 
      ** Validate settlement account against Fee payment date:
     C     V_DLPYON      IFEQ      'S'
     C                   MOVE      V_DLPSTD      ##DATR
     C                   MOVE      V_DLPSTD      ##DATP
     C                   ENDIF
 
     C     V_DLPYON      IFEQ      'N'
     C                   MOVE      V_DLNPYD      ##DATR
     C                   MOVE      V_DLNPYD      ##DATP
     C                   ENDIF
 
     C     V_DLPYON      IFEQ      'E'
     C                   MOVE      V_DLPEND      ##DATR
     C                   MOVE      V_DLPEND      ##DATP
     C                   ENDIF
 
      ** Define Fee branch: If insert mode it comes from deals file
      ** else from fee file
     C                   IF        DDACTN <> 'I'
     C                   EVAL         FeeBranch = DDFCCY
     C                   ELSE
     C                   IF        C_BRCA  <> *BLANKS
     C                   EVAL         FeeBranch = C_BRCA
     C                   ELSE
     C                   EVAL         FeeBranch = D_BRCA
     C                   ENDIF
     C                   ENDIF
 
     C     DDPSTM        IFEQ      *BLANK
     C                   MOVE      '00'          DDPSTM
     C                   ENDIF
 
     C     DDRSTM        IFEQ      *BLANK
     C                   MOVE      '00'          DDRSTM
     C                   ENDIF
 
      ** Validate Extended Settlement Details
     C                   CALLB     'ZASETINVAL'
 
      ** INPUT
      ** Return Code
      ** Calling function type
     C                   PARM                    ReturnCode
     C                   PARM      'DEAM'        ##CALP            4
 
      ** Payment currency (or deal currency if only one currency on deal)
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM      DDFCCY        ##PCCY            3
     C                   PARM      DDFCCY        ##RCCY            3
 
      ** Customer (shortname or number)
      ** Deal type
      ** Federal Funds Ind.
      ** Booking Branch
     C                   PARM      DDCUST        ##CSNM           10
     C                   PARM      *BLANKS       ##TTYP            2
     C                   PARM      *BLANKS       ##FFND            1
     C                   PARM      FeeBranch     ##BRCA            3
 
      ** Receipt Date
      ** Payment Date
     C                   PARM                    ##DATR            5 0
     C                   PARM                    ##DATP            5 0
 
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
     C                   PARM                    ##FRIS
 
      ** Action Code
     C                   PARM      DDACTN        ##ACTN            1
 
      ** Protect Payment Field
      ** Protect Receive Field
     C                   PARM                    ##PPAY
     C                   PARM                    ##PREC
 
      ** OUTPUT
      ** Payment Instruction OK flag
      ** Receive Instruction OK flag
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKPayInsDS
     C                   PARM                    OKRecInsDS
     C                   PARM                    OKFRAInsDS
 
      ** Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Warning Messages
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    ##PAYF
     C                   PARM                    ##RECF
     C                   PARM                    ##FRIF
 
      ** EXTRA INPUT
      ** Action Code used
      ** Validation Iteration
     C                   PARM      DDACTN        ##ACTN            1
     C                   PARM      '1ST'         ##ValIter         3
 
     C                   IF        C_DTYP = 'IT' OR C_DTYP = 'TD' OR                        BUG21121
     C                             C_DTYP = 'CI' OR C_DTYP = 'CD'                           BUG21121
     C                   EVAL      V_DLSTTL = FLPSTM                                        BUG21121
     C                   EVAL      V_DLOURS = FLPONS                                        BUG21121
     C                   EVAL      V_DLOSBR = FLPOBR                                        BUG21121
     C                   EVAL      V_DLTHER = FLPIBN                                        BUG21121
     C                   EVAL      V_DLOMDB = FLPOBR                                        BUG21121
     C                   EVAL      V_DLPIBN = FLPIBN                                        BUG21121
     C                   EVAL      V_DLPIBA = FLPIBA                                        BUG21121
     C                   EVAL      V_DLPOBN = FLPOBN                                        BUG21121
     C                   EVAL      V_DLPOCN = FLPOCN                                        BUG21121
     C                   EVAL      V_DLBTB1 = FLBTB1                                        BUG21121
     C                   EVAL      V_DLBTB2 = FLBTB2                                        BUG21121
     C                   EVAL      V_DLBTB3 = FLBTB3                                        BUG21121
     C                   EVAL      V_DLBTB4 = FLBTB4                                        BUG21121
     C                   EVAL      V_DLBTB5 = FLBTB5                                        BUG21121
     C                   EVAL      V_DLBTB6 = FLBTB6                                        BUG21121
     C                   ELSE                                                               BUG21121
     C                   EVAL      V_DLSTTL = FLRSTM                                        BUG21121
     C                   EVAL      V_DLOURS = FLRONS                                        BUG21121
     C                   EVAL      V_DLOSBR = FLROBR                                        BUG21121
     C                   EVAL      V_DLTHER = FLRIBN                                        BUG21121
     C                   EVAL      V_DLRIBN = FLRIBN                                        BUG21121
     C                   EVAL      V_DLRIBA = FLRIBA                                        BUG21121
     C                   EVAL      V_DLROBN = FLROBN                                        BUG21121
     C                   EVAL      V_DLROCN = FLROCN                                        BUG21121
     C                   ENDIF                                                              BUG21121
      *                                                                                     BUG21121
     C                   MOVEL     FLREC         VFREC
     C                   MOVEL     FLRSTM        V_DLRSTM
     C                   MOVEL     FLRONS        V_DLRONS
     C                   MOVE      FLROBR        V_DLOSDB
 
     C                   MOVEL     FLPAY         VFPAY
     C                   MOVEL     FLPSTM        V_DLPSTM
     C                   MOVEL     FLPONS        V_DLPONS
     C                   MOVE      FLPOBR        V_DLOMDB
     C                   MOVE      FLCVMR        V_DLCVMR
     C                   MOVE      FLPSCY        V_DLSCCY
     C                   MOVE      FLIC72        V_DLICCY
 
     C     ValSetExit    TAG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Common header information (DS) from source system
     C                   PARM                    HeadIn
 
      ** Transaction information
     C                   PARM                    Trans5001
 
      ** Settlement details
     C                   PARM                    ##PAYS
     C                   PARM                    ##RECS
 
      ** Error information
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Warning error information
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Message file
     C                   PARM                    MsgFArray
 
      ** Update Transaction flag
     C                   PARM                    PUpdateYN
 
      ** Output buffer
     C                   PARM                    PBuffer
 
      ** API return code
     C                   PARM                    PAPIRetCd
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'GBDRSMM'
     C                   EVAL      MsgFArray(2) = 'Y2USRMSG'
 
      ** Hook to enable non-core message files to be included
      /COPY WNCPYSRC,DLDLFE001
 
      ** Access bank details via access program
      ** (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,DLDLFE002
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      PAPIRetCd = '0'
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
** PCMD                                                                                       248530
OVRDBF FILE(MMEIRDL0) SHARE(*NO)                                                              248530
DLTOVR FILE(MMEIRDL0)                                                                         248530
