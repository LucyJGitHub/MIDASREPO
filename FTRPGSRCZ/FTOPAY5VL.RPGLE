     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments Validation Control 5')      *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAY4VL - Outgoing Payments Validation Control 5           *
      *                                                               *
      *  Function:  This API module will serve as the validation mo   *
      *             dule for all the Margins Info fields. All Margin  *
      *             related information validation from FTOPAY3DP     *
      *             were moved to this module and has no additional   *
      *             processing in relation with this enhancement was  *
      *             added.                                            *
      *                                                               *
      *  Called By: FTOPAY1SN                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 15Nov00               *
      *                 CFT014  *Create    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                       *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
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
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
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
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D TranInFift    E DS                  EXTNAME(FTOPY7PD)
 
      ** FT (OPAY) Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(FTOPEXPD)
 
      ** Valid Payments layout
     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)
     D QQCDROX       E                     EXTFLD(QQCDRO)                                     CGL029
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY5PD)
 
      ** Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER030
      *                                                                                       CER030
     D TranInFiftA   E DS                  EXTNAME(FTOPY7APD)                                 CER030
      *                                                                                       CER030
     D TranInFiftB   E DS                  EXTNAME(FTOPY7BPD)                                 CER030
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** A code to indicate the calling function to the lower level modules
     D OPAY            S              4A   INZ('OPAY')
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
     D I               S              3  0
      *                                                                                       CER030
      ** Variables for CER030 changes                                                         CER030
      *                                                                                       CER030
     D PRtcd           S              7A                                                      CER030
     D POptn           S              7A                                                      CER030
     D PSard           S              6A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CER030          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
      *                                                                                       CER030
     D STRTC           S              3A                                                      CER030
     D O2TTCD          S              3A                                                      CER030
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Validate Margin fields
 
     C                   ExSr      SrMgnInfo
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' OR CGL013 = 'Y'                               CER030
     C                   EXSR      SRTrty                                                     CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        CER031 = 'Y'                                               CER030
     C                   EXSR      SRExtNarr                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
 
      ** Setup outstanding fields for valid file when no error is encoun -
      ** tered
 
     C                   If        Idx = *Zero
     C                   ExSr      SetupValid
     C                   EndIf
 
     C                   Return
 
      *****************************************************************
      /Title Sr/SrMgnInfo
      *****************************************************************
      *                                                               *
      * SR/SrMgnInfo - Validate Margin Info                           *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVMGMG    - Margin Info Validation Module                   *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrMgnInfo     BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Margin Info
 
     C                   CallB     'FTVMGMG'
     C                   Parm                    ReTCodeOut
     C                   Parm                    TranInPrim
     C                   Parm                    TranInFift
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SetupValid
      *****************************************************************
      *                                                               *
      * SR/SetupValid - Set up valid file record                      *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SetupValid    BegSr
 
      ** Setup margin into fields
 
     C                   Eval      OTFXMP = @FXMP
     C                   Eval      OTFXMD = @FXMD
     C                   Eval      OTMSIG = SMSIG
     C                   Eval      OTMAMT = @MAMT
 
     C                   If        SMBSI = 'S'
     C                   Eval      OTMBSI = 'B'
     C                   EndIf
 
     C                   If        SMBSI = 'P'
     C                   Eval      OTMBSI = 'S'
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/*InzSr
      *****************************************************************
      *                                                               *
      * SR/*InzSr     - Program Initialisation Routine                *
      *                                                               *
      * Called By: Automatically executed when program starts.        *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
     C     *Entry        Plist
     C                   PARM                    RespMode
     C                   PARM                    TranInPrim
     C                   PARM                    TranInFift
     C                   PARM                    TranInFiftA                                  CER030
     C                   PARM                    TranInFiftB                                  CER030
     C                   PARM                    STRTC                                        CER030
     C                   PARM                    ExtData
     C                   PARM                    OKFlagsDS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidPmnt
     C                   Parm                    Val@Fields
     C                   PARM                    O2TTCD                                       CER030
 
     C     *LOCK         In        LDA
     C                   Movel     'FTOPAY5VL'   DBPGM
     C                   Out       LDA
 
      ** Access Bank Details via Access Object AOBANKR0
 
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RTCD         IfNe      *BLANKS
     C                   MoveL     'SDBANKPD'    DBFILE
     C                   Z-Add     1             DBASE
     C                   MoveL     @Optn         DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
      *                                                                                       CER030
      ** Check if CER031 is enabled                                                           CER030
      *                                                                                       CER030
     C                   EVAL      CER031 = 'N'                                               CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
      *                                                                                       CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   MOVEL     '002'         DBASE                                        CER030
     C                   MOVEL     'CER031'      DBKEY                                        CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check if CER030 is enabled                                                           CER030
      *                                                                                       CER030
     C                   EVAL      CER030 = 'N'                                               CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
      *                                                                                       CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   MOVEL     '003'         DBASE                                        CER030
     C                   MOVEL     'CER030'      DBKEY                                        CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check if CGL013 is enabled                                                           CER030
      *                                                                                       CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
      *                                                                                       CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   MOVEL     '005'         DBASE                                        CER030
     C                   MOVEL     'CGL013'      DBKEY                                        CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
 
     C                   EVAL      #MsgFile     = 'FTUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/Reseterrs
      *****************************************************************
      *                                                               *
      * SR/Reseterrs  - Reset information that is received back from  *
      *                 each validation module                        *
      *                                                               *
      * Called By: Validation subroutines                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     Reseterrs     BegSr
 
     C                   Eval      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *BlankS
     C                   Eval      WMsgIDXAr = *BlankS
     C                   Eval      WMsgDtXAr = *BlankS
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/Updaterrs
      *****************************************************************
      *                                                               *
      * SR/Updaterrs  - Update error information with that received   *
      *                 back from each validation module              *
      *                                                               *
      * Called By: Validation subroutines                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     Updaterrs     BegSr
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Eval      I = 1
     C     *Blank        Lookup    FldNameArr(I)                          99
     C                   If        *IN99 = True
     C                   Movea     FldNamXar     FldNameArr(I)
     C                   Movea     MsgIDXAr      MsgIdArr(I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(I)
     C                   EndIf
 
      ** Set Error Index
 
     C                   Eval      I = 1
     C     *Blank        Lookup    FldNameArr(I)                          99
     C                   Eval      Idx = I - 1
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Eval      I = 1
     C     *Blank        Lookup    WFldNamArr(I)                          99
     C                   If        *IN99 = True
     C                   Movea     WFldNmXAr     WFldNamArr(I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(I)
     C                   Movea     WMsgDtXAr     WMsgDtaArr(I)
     C                   EndIf
 
      ** Set Warning Index
 
     C                   Eval      I = 1
     C     *Blank        Lookup    WFldNamArr(I)                          99
     C                   Eval      WIdx = I - 1
 
     C                   EndSr
 
      *****************************************************************                       CER030
      /Title Sr/SRTrty                                                                        CER030
      *****************************************************************                       CER030
      *                                                               *                       CER030
      * SR/SRTrty  - Transaction type Validation                      *                       CER030
      *                                                               *                       CER030
      * Called By : Main Routine                                      *                       CER030
      *                                                               *                       CER030
      * Calls : ResetErrs , UpdatErrs                                 *                       CER030
      *                                                               *                       CER030
      *****************************************************************                       CER030
      *                                                                                       CER030
     C     SRTrty        BEGSR                                                                CER030
      *                                                                                       CER030
     C                   EXSR      ResetErrs                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'FTVOTRTYP'                                                CER030
      *                                                                                       CER030
     C                   PARM                    RetCodeOut                                   CER030
      *                                                                                       CER030
      ** Outgoing Payments Transaction type - Screen format                                   CER030
      *                                                                                       CER030
     C                   PARM                    TranInFiftA                                  CER030
      *                                                                                       CER030
      ** Outgoing Payments Transaction Code from screen 2 level 2 for                         CER030
      ** defaulting value of Retail Transaction Type                                          CER030
      *                                                                                       CER030
     C                   PARM                    STRTC                                        CER030
      *                                                                                       CER030
     C                   PARM                    RespMode                                     CER030
      *                                                                                       CER030
      ** OUTPUT                                                                               CER030
      *                                                                                       CER030
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER030
      *                                                                                       CER030
     C                   PARM                    FldNamXAr                                    CER030
     C                   PARM                    MsgIdXAr                                     CER030
     C                   PARM                    MsgDtaXAr                                    CER030
      *                                                                                       CER030
      ** Outgoing Payments Margin info error indicators                                       CER030
      *                                                                                       CER030
     C                   PARM                    OKFlagsDS                                    CER030
      *                                                                                       CER030
      ** Outgoing Payments for file update - file format                                      CER030
      *                                                                                       CER030
     C                   PARM                    ValidPmnt                                    CER030
      *                                                                                       CER030
      ** Extension Valid File Value for Transaction code                                      CER030
      *                                                                                       CER030
     C                   PARM                    O2TTCD                                       CER030
      *                                                                                       CER030
     C                   EXSR      UpdatErrs                                                  CER030
      *                                                                                       CER030
     C                   ENDSR                                                                CER030
      *****************************************************************                       CER030
      /Title Sr/SRExtNarr                                                                     CER030
      *****************************************************************                       CER030
      *                                                               *                       CER030
      * SR/SRExtNarr - Extended Narrative validation                  *                       CER030
      *                                                               *                       CER030
      * Called By : Main Routine                                      *                       CER030
      *                                                               *                       CER030
      * Calls : ResetErrs , UpdatErrs                                 *                       CER030
      *****************************************************************                       CER030
      *                                                                                       CER030
     C     SRExtNarr     BEGSR                                                                CER030
      *                                                                                       CER030
     C                   EXSR      ResetErrs                                                  CER030
      *                                                                                       CER030
      ** Validation of Extended Narrative for Debit and Credit                                CER030
      *                                                                                       CER030
     C                   CALLB     'FTVOEXTNAR'                                               CER030
      *                                                                                       CER030
      ** INPUT                                                                                CER030
      *                                                                                       CER030
     C                   PARM                    RetCodeOut                                   CER030
      *                                                                                       CER030
      ** Outgoing Payments Lvl 1 Scrn details from incoming transaction                       CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    TranInPrim                                   CER030
      *                                                                                       CER030
      ** Outgoing Payments Extended Narratives Debit transaction                              CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    TranInFiftA                                  CER030
      *                                                                                       CER030
      ** Outgoing Payments Extended Narratives Credit transaction                             CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    TranInFiftB                                  CER030
      *                                                                                       CER030
     C                   PARM                    RespMode                                     CER030
      *                                                                                       CER030
      ** OUTPUT                                                                               CER030
      *                                                                                       CER030
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER030
      *                                                                                       CER030
     C                   PARM                    FldNamXAr                                    CER030
     C                   PARM                    MsgIdXAr                                     CER030
     C                   PARM                    MsgDtaXAr                                    CER030
      *                                                                                       CER030
      ** Outgoing Payments Margin info error indicators                                       CER030
      *                                                                                       CER030
     C                   PARM                    OKFlagsDS                                    CER030
      *                                                                                       CER030
      ** Outgoing Payments for file update - file format                                      CER030
      *                                                                                       CER030
     C                   PARM                    ValidPmnt                                    CER030
      *                                                                                       CER030
     C                   EXSR      UpdatErrs                                                  CER030
      *                                                                                       CER030
     C                   ENDSR                                                                CER030
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
