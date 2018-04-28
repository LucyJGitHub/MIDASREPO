     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate CCT Credit Detail screen 2')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1024VL - Validate MT102 Credit detail screen 2            *
      *                                                               *
      *  Function: This module validates screen 2 of the CCT Credit   *
      *            transaction maintenance function (FTM1021DP).      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 29Oct99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - SWIFT 2007 Changes (Recompiled)                     *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT006 - Swift Messages MT101/MT102                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      ** Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      ** OK Flags for second screen
     D OKFlagDS2     E DS                  EXTNAME(FTE102S2PD)
 
      ** OK Flags for First screen
     D OKFlagDS1     E DS                  EXTNAME(FTE102S1PD)
 
      ** OK Flags for FIRST HEADER screen
     D OKFlagHS1     E DS                  EXTNAME(FTE102H1PD)
 
      ** OK Flags for Second HEADER screen
     D OKFlagHS2     E DS                  EXTNAME(FTE102H2PD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
     D #I              S              2  0
                                                                                              CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
     D PRtCd           S              7A                                                      CSW201
                                                                                              CSW201
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      **************   Call Validation Modules in Sequence   **************
 
 
     C                   If        ActionCode <> 'R'
 
      ** Senders Charges and Currency
 
     C                   EXSR      @SndChgCcy
 
      ** Default Senders Charges in Transfer Currency
 
     C                   IF        PSndChg <> *Blanks AND
     C                             PSndCcy <> *Blanks AND
     C                             OKSChg <> 'N' AND OKSCcy <> 'N' AND
     C                             OKCtCCy <> 'N'
                                                                                              CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   IF        OKSChg2 <> 'N' AND OKSCcy2 <> 'N' AND                      CSW201
     C                             OKSChg3 <> 'N' AND OKSCcy3 <> 'N' AND                      CSW201
     C                             OKSChg4 <> 'N' AND OKSCcy4 <> 'N' AND                      CSW201
     C                             OKSChg5 <> 'N' AND OKSCcy5 <> 'N'                          CSW201
                                                                                              CSW201
     C                   EXSR      @SndChgTfr                                                 CSW201
     C                   ENDIF                                                                CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   EXSR      @SndChgTfr
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF
 
      ** Default Sender's Charges in Payment Currency
 
     C                   IF        PSndChg <> *Blanks AND
     C                             PSndCcy <> *Blanks AND
     C                             OKSChg <> 'N' AND OKSCcy <> 'N' AND
     C                             OKPCCy <> 'N'
                                                                                              CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   IF        OKSChg2 <> 'N' AND OKSCcy2 <> 'N' AND                      CSW201
     C                             OKSChg3 <> 'N' AND OKSCcy3 <> 'N' AND                      CSW201
     C                             OKSChg4 <> 'N' AND OKSCcy4 <> 'N' AND                      CSW201
     C                             OKSChg5 <> 'N' AND OKSCcy5 <> 'N'                          CSW201
     C                   EXSR      @SndChgPay                                                 CSW201
     C                   ENDIF                                                                CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   EXSR      @SndChgPay
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF
 
      ** Receiver's Charges and Currency
 
     C                   EXSR      @RecChgCcy
 
      ** Default Receiver's Charges in Transfer Currency
 
     C                   IF        PRcvChg <> *Blanks AND
     C                             PRcvCCy <> *Blanks AND
     C                             OKRchg <> 'N' AND OKRCcy <> 'N' AND
     C                             OKCtCCy <> 'N'
     C                   EXSR      @RecChgTfr
     C                   ENDIF
 
      ** Default Receiver's Charges in Payment Currency
 
     C                   IF        PRcvChg <> *Blanks AND
     C                             PRcvCCy <> *Blanks AND
     C                             OKRchg <> 'N' AND OKRCcy <> 'N' AND
     C                             OKPccy <> 'N'
     C                   EXSR      @RecChgPay
     C                   ENDIF
 
      ** Revalidate/Default transfer amount with any new charges calculated
 
     C                   EXSR      @TrnAmCcy
 
      ** Revalidate/Default Payment amount with any new charges calculated
 
     C                   EXSR      @PayAmCcy
 
      ** Generate Outgoing Payments
 
     C                   EXSR      @GenOutPay
 
      ** Remittance Information
 
     C                   EXSR      @RemInfo
 
      ** Regulatory Reporting
 
     C                   EXSR      @RegRept
 
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @SndChgCcy - Validate Sender's Charges/Currency
      *****************************************************************
      *
     C     @SndChgCcy    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PSNDCHG'
      *
      ** Validate
      *
     C                   CALLB     'FTVSECH03'   P#List
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @SndChgTfr - Default Sender's Charges in Transfer Currency
      *****************************************************************
      *
     C     @SndChgTfr    BEGSR
      *
      ** Default
      *
     C                   CALLB     'FTVSECH02'   P#List
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @SndChgPay - Default Sender's Charges in Payment Currency
      *****************************************************************
      *
     C     @SndChgPay    BEGSR
      *
      ** Default
      *
     C                   CALLB     'FTVSECH01'   P#List
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @RecChgCcy - Validate Receiver's Charges/Currency
      *****************************************************************
      *
     C     @RecChgCcy    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PRCVCHG'
      *
      ** Validate
      *
     C                   CALLB     'FTVCHCY02'   P#List
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @RecChgTfr - Default Receiver's Charges in Transfer Currency
      *****************************************************************
      *
     C     @RecChgTfr    BEGSR
      *
      ** Default
      *
     C                   CALLB     'FTVRECH02'   P#List
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @RecChgPay - Defualt Receiver's Charges in Payment Currency
      *****************************************************************
      *
     C     @RecChgPay    BEGSR
      *
      ** Default
      *
     C                   CALLB     'FTVRECH01'   P#List
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @TrnAmCcy - Validate Transfer Amount (and transfer currency)
      *****************************************************************
      *
     C     @TrnAmCcy     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PCCTAMT'
      *
      ** Validate
      *
     C                   CALLB     'FTVTFCY01'   P#List
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  @PayAmCcy - Validate Payment amount and currency
      *****************************************************************
      *
     C     @PayAmCcy     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PPayAmt'
      *
      ** Validate
      *
     C                   CALLB     'FTVCCPY01'   P#List
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @GenOutPay - Validate Generate Outgoing Payments
      *****************************************************************
      *
     C     @GenOutPay    BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PGOPFLG'
      *
      ** Validate
      *
     C                   CALLB     'FTVOUPY02'   P#List
      *
      ** Update error info with that returned from the validation module
      *
     C                   Exsr      UPDATERRS
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @RemInfo - Validate Remittance Information
      *****************************************************************
      *
     C     @RemInfo      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PREMI1'
      *
      ** Validate
      *
     C                   CALLB     'FTVRMDE01'   P#List
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @RegRept - Validate Regulatory Reporting
      *****************************************************************
      *
     C     @RegRept      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PREGRP1'
      *
      ** Validate
      *
     C                   CALLB     'FTVRERE03'   P#List
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    RtnCodeIn        10
      *
      ** Response mode (1A), from source system common header (A or S)
      *
     C                   PARM                    RespMode          1
      *
      ** Action Code
      *
     C                   PARM                    ActionCode        1
      *
      ** Header information (DS) from source system in screen format
      *
     C                   PARM                    HdrRcdIn
      *
      ** Detail information (DS) from source system in screen format
      *
     C                   PARM                    DtlRcdIn
      *
      ** OK Flags Data Structure - Screen 1 only
      *
     C                   PARM                    OkFlagDS1
      *
      ** OK Flags Data Structure - Screen 2 only
      *
     C                   PARM                    OkFlagDS2
      *
      ** OK Flags Header Data Structure - Screen 1 only
      *
     C                   PARM                    OkFlagHS1
      *
      ** OK Flags Header Data Structure - Screen 2 only
      *
     C                   PARM                    OkFlagHS2
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM                    WIx
      *
      ** Set up the name of the MSGF from which the message handler
      ** will get the messages.
      *
     C                   EVAL      #MsgFile = 'FTUSRMSG'
      *
      ** General parameter list
      *
     C     P#List        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode
      *
      ** Header record in screen format
      ** Detail record in screen format
      *
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlagDS1
     C                   PARM                    OKFlagDS2
     C                   PARM                    OKFlagHS1
     C                   PARM                    OKFlagHS2
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       PRtCd                                        CSW201
      *                                                                                       CSW201
     C                   IF        PRtCd = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset work error arrays.  Called before each      *
      *             low-level validation module (CTR modules).        *
      *****************************************************************
      *
     C     RESETERRS     BEGSR
      *
     C                   EVAL      RetCodeOut = *Blanks
     C                   EVAL      DDSName = *Blanks
      *
      ** Reset error & warning fields/message IDs/message data (arrays)
      *
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      WFldNmXAr = *Blanks
     C                   EVAL      WMsgIDXAr = *Blanks
     C                   EVAL      WMsgDtXAr = *Blanks
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *             from each validation module.                      *
      *****************************************************************
      *
     C     UPDATERRS     BEGSR
      *
      ** Update error fields/message IDs/message data (arrays)
      *
     C                   EVAL      #I = 1
     C     *Blank        LOOKUP    FldNameArr(#I)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     FldNamXar     FldNameArr(#I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(#I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(#I)
     C                   ENDIF
      *
      ** Set Error Index
      *
     C                   EVAL      #I = 1
     C     *Blank        LOOKUP    FldNameArr(#I)                         99
     C                   EVAL      Idx = #I - 1
      *
      ** Update warning fields/message IDs/message data (arrays)
      *
     C                   EVAL      #I = 1
     C     *Blank        LOOKUP    WFldNamArr(#I)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(#I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(#I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(#I)
     C                   ENDIF
      *
      ** Set Warning Index
      *
     C                   EVAL      #I = 1
     C     *Blank        LOOKUP    WFldNamArr(#I)                         99
     C                   EVAL      WIx = #I - 1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
