     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate CCT credit detail screen 1')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1023VL - Validate MT102 Credit detail screen 1            *
      *                                                               *
      *  Function: This Program Validates screen 1 of the CCT Credit  *
      *            transaction maintenance function (FTM1021DP).      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG24243           Date 16Jun09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
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
      *                 178751             Date 09May00               *
      *                 178183             Date 26Apr00               *
      *                 CFT006  *CREATE    Date 13Oct99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24243 - CCTD ended in database error when Sender charge's *
      *           currency is invalid                                 *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - SWIFT 2007 Changes (Recompiled)                     *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen           *
      *  178751 - Auto generation of references                       *
      *  178183 - Reassign a duplicate record                         *
      *  CFT006 - Funds Transfer - Swift messages MT101/MT102         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTM1023V01
 
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
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      * OK Flags for first screen
     D OKFlagDS1     E DS                  EXTNAME(FTE102S1PD)
 
      * OK Flags for Second screen
     D OKFlagDS2     E DS                  EXTNAME(FTE102S2PD)
 
      * OK Flags for first screen - header
     D OKFlagHS1     E DS                  EXTNAME(FTE102H1PD)
 
      * OK Flags for Second screen - header
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
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FTM1023V02
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      **************   Call Validation Modules in Sequence   **************
 
      ** Customer credit transfer Id (only in 'Reassign' mode)
      /COPY WNCPYSRC,FTM1023V03
 
     C                   IF        ActionCode = 'R'
 
      /COPY WNCPYSRC,FTM1023V04
     C                   EXSR      @CCTId
      /COPY WNCPYSRC,FTM1023V05
      **********                                                          178183178751
      ***Transaction*Reference****************************************    178183178751
      **********                                                          178183178751
     C*******************EXSR      @TrnsRef                               178183178751
      **********                                                          178183178751
     C                   ELSE
                                                                                            BUG24243
      ** Senders Charges and Currency                                                       BUG24243
                                                                                            BUG24243
     C                   EXSR      @SndChgCcy                                               BUG24243
 
      ** Transaction Reference
 
      /COPY WNCPYSRC,FTM1023V06
     C                   EXSR      @TrnsRef
                                                                                184060
      ** Transaction Type Code                                                  184060
                                                                                184060
     C                   EXSR      @TrnTyCd                                     184060
      /COPY WNCPYSRC,FTM1023V07
 
      ** Beneficiary
 
      /COPY WNCPYSRC,FTM1023V08
     C                   EXSR      @Benef
      /COPY WNCPYSRC,FTM1023V09
 
      ** Account with institution
 
      /COPY WNCPYSRC,FTM1023V10
     C                   EXSR      @AWI
      /COPY WNCPYSRC,FTM1023V11
 
 
      ** Ordering Institution
 
      /COPY WNCPYSRC,FTM1023V12
     C                   EXSR      @OrdInst
      /COPY WNCPYSRC,FTM1023V13
 
      ** Ordering Customer
 
      /COPY WNCPYSRC,FTM1023V14
     C                   EXSR      @OrdCust
      /COPY WNCPYSRC,FTM1023V15
 
      ** Details of charges
 
      /COPY WNCPYSRC,FTM1023V16
     C                   EXSR      @DetChg
      /COPY WNCPYSRC,FTM1023V17
 
     C                   IF        HPCCtTyp = 'BI'
 
      ** Transfer Amount and transfer currency
      /COPY WNCPYSRC,FTM1023V18
     C                   EXSR      @TrnAmCCy
      /COPY WNCPYSRC,FTM1023V19
      ** Credit value date
      /COPY WNCPYSRC,FTM1023V20
     C                   EXSR      @CrDate
      /COPY WNCPYSRC,FTM1023V21
      ** Exchange rate and override indicator
      /COPY WNCPYSRC,FTM1023V22
     C                   EXSR      @XrtOvrIn
      /COPY WNCPYSRC,FTM1023V23
      ** Payment amount and currency
      /COPY WNCPYSRC,FTM1023V24
     C                   EXSR      @PayAmCcy
      /COPY WNCPYSRC,FTM1023V25
 
     C                   ELSE
 
      ** Payment amount and currency
      /COPY WNCPYSRC,FTM1023V26
     C                   EXSR      @PayAmCcy
      /COPY WNCPYSRC,FTM1023V27
      ** Credit value date
      /COPY WNCPYSRC,FTM1023V28
     C                   EXSR      @CrDate
      /COPY WNCPYSRC,FTM1023V29
      ** Exchange rate and override indicator
      /COPY WNCPYSRC,FTM1023V30
     C                   EXSR      @XrtOvrIn
      /COPY WNCPYSRC,FTM1023V31
      ** Transfer Amount and transfer currency
      /COPY WNCPYSRC,FTM1023V32
     C                   EXSR      @TrnAmCCy
      /COPY WNCPYSRC,FTM1023V33
 
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @CCTId - Validate CCt Id
      *****************************************************************
      *
     C     @CctID        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PCCTID'
      *
      ** Validate
      *
     C                   CALLB     'FTVCCID01'   P#List
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
      ** @TrnsRef - Validate Transaction Reference
      *****************************************************************
      *
     C     @TrnsRef      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PTRNSID'
      *
      ** Validate
      *
     C                   CALLB     'FTVTHRF01'   P#List
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT                                                                    184060
      *****************************************************************         184060
      ** @TrnTyCd - Validate Transaction Type Code                              184060
      *****************************************************************         184060
      *                                                                         184060
     C     @TrnTyCd      BEGSR                                                  184060
      *                                                                         184060
      ** Reset variables updated by each module                                 184060
      *                                                                         184060
     C                   EXSR      RESETERRS                                    184060
      *                                                                         184060
     C                   EVAL      DDSName = 'PCCTTYC'                          184060
      *                                                                         184060
      ** Validate                                                               184060
      *                                                                         184060
     C                   CALLB     'FTVTTCD01'   P#List                         184060
      *                                                                         184060
      ** Update error info with that returned from the validation module        184060
      *                                                                         184060
     C                   EXSR      UPDATERRS                                    184060
      *                                                                         184060
     C                   ENDSR                                                  184060
      *                                                                         184060
      *****************************************************************         184060
     C/EJECT
      *****************************************************************
      ** @Benef - Validate Beneficiary
      *****************************************************************
      *
     C     @Benef        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PBENF1'
      *
      ** Validate ALL beneficiary fields at once.  If an error in any field,
      ** only PBENF1 is highlighted.
      *
     C                   CALLB     'FTVBEBE02'   P#List
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
      ** @AWI - Validate Account with Institution
      *****************************************************************
      *
     C     @AWI          BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PACCI35'
      *
      ** Validate both fields at once.
      *
     C                   CALLB     'FTVACIS02'   P#List
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
      ** @OrdInst - Validate Ordering Institution
      *****************************************************************
      *
     C     @OrdInst      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PORDI35'
      *
      ** Validate both fields at once
      *
     C                   CALLB     'FTVODIS01'   P#List
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
      ** @OrdCust - Validate Ordering Customer
      *****************************************************************
      *
     C     @OrdCust      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PORDCU1'
      *
      ** Validate all 4 fields at once
      *
     C                   CALLB     'FTVCCDE01'   P#List
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
      ** @DetChg - Validate Details of Charges
      *****************************************************************
      *
     C     @DetChg       BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PCCYCHG'
      *
      ** Validate
      *
     C                   CALLB     'FTVCHDE01'   P#List
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
      ** @CrDate - Validate Credit Value date
      *****************************************************************
      *
     C     @CrDAte       BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PCRDVDT'
      *
      ** Validate
      *
     C                   CALLB     'FTVCRVL02'   P#List
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
      *  @XrtOvrIn - Validate Exchange rate and override indicator
      *****************************************************************
      *
     C     @XrtOvrIn     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
     C                   EVAL      DDSName = 'PXRATE'
      *
      ** Validate
      *
     C                   CALLB     'FTVEXRT02'   P#List
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *
      *****************************************************************                     BUG24243
      ** @SndChgCcy - Validate Sender's Charges/Currency                                    BUG24243
      *****************************************************************                     BUG24243
      *                                                                                     BUG24243
     C     @SndChgCcy    BEGSR                                                              BUG24243
      *                                                                                     BUG24243
      ** Reset variables updated by each module                                             BUG24243
      *                                                                                     BUG24243
     C                   EXSR      RESETERRS                                                BUG24243
      *                                                                                     BUG24243
     C                   EVAL      DDSName = 'PSNDCHG'                                      BUG24243
      *                                                                                     BUG24243
      ** Validate                                                                           BUG24243
      *                                                                                     BUG24243
     C                   CALLB     'FTVSECH03'   P#List                                     BUG24243
      *                                                                                     BUG24243
      ** Update error info with that returned from the validation module                    BUG24243
      *                                                                                     BUG24243
     C                   EXSR      UPDATERRS                                                BUG24243
      *                                                                                     BUG24243
     C                   ENDSR                                                              BUG24243
      *                                                                                     BUG24243
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
 
      ** Response mode (1A), from source system common header (A or S)
     C                   PARM                    RespMode          1
 
      ** Action Code
     C                   PARM                    ActionCode        1
 
      ** Header information (DS) from source system in screen format
     C                   PARM                    HdrRcdIn
 
      ** Detail information (DS) from source system in screen format
     C                   PARM                    DtlRcdIn
 
      ** OK Flags Data Structure - Screen 1 only
     C                   PARM                    OkFlagDS1
     C                   PARM                    OkFlagDS2
     C                   PARM                    OkFlagHS1
     C                   PARM                    OkFlagHS2
 
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
     C                   PARM                    WIx
 
      *
      ** Set up the name of the MSGF from which the message handler
      ** will get the messages.
      *
     C                   Eval      #MsgFile = 'FTUSRMSG'
      *
      ** General parameter list.
      *
     C     P#List        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode
      ** Header record in screen format
      ** Detail record in screen format
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
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
     C     UPDATERRS     BEGSR
      *
      ** Update error fields/message IDs/message data (arrays)
      *
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     FldNamXar     FldNameArr(#I)
     C                   Movea     MsgIDXAr      MsgIdArr(#I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(#I)
     C                   Endif
      *
      ** Set Error Index
      *
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   Eval      Idx = #I - 1
      *
      ** Update warning fields/message IDs/message data (arrays)
      *
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     WFldNmXAr     WFldNamArr(#I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(#I)
     C                   Movea     WMsgDtXAr     WMsgDtaArr(#I)
     C                   Endif
      *
      ** Set Warning Index
      *
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   Eval      WIx = #I - 1
      *
     C                   ENDSR
      *
      /COPY WNCPYSRC,FTM1023V34
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
(c) Finastra International Limited 2001
