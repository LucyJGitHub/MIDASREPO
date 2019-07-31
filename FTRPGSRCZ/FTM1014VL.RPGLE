     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate RFT Credit Detail screen 2')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1014VL - Validate MT101 Credit detail screen 2            *
      *                                                               *
      *  Function: This module validates screen 2 of the RFT Credit   *
      *            transaction maintenance function (FTM1011DP).      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10602           Date 16Feb06               *
      *                 221761             Date 02Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 29Oct99               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  185107 - Mapping of details from swift message - Recompile   *
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
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      * OK Flags for second screen
     D OKFlagDS      E DS                  EXTNAME(FTE101S2PD)
 
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
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FT101CV201
 
      **************   Call Validation Modules in Sequence   **************
 
     C                   If        ActionCode <> 'R'
      ** Transfer Amount/Currency
 
      /COPY WNCPYSRC,FT101CV202
 
     C                   EXSR      @TrnAmt
 
      /COPY WNCPYSRC,FT101CV203
 
      ** Exchange Rate/Override Indicator, Payment Amount and Payment Ccy
 
      /COPY WNCPYSRC,FT101CV204
 
     C                   EXSR      @XRatePayAmt
 
      /COPY WNCPYSRC,FT101CV205
 
      * FX Deal Ref
 
      /COPY WNCPYSRC,FT101CV208
 
     C                   Exsr      @DealRef
 
      /COPY WNCPYSRC,FT101CV209
 
      ** Original Amount/Currency
 
      /COPY WNCPYSRC,FT101CV202
 
     C                   EXSR      @OrAmCcy
 
      /COPY WNCPYSRC,FT101CV203
 
      ** Credit Value Date
 
      /COPY WNCPYSRC,FT101CV202
 
     C                   EXSR      @CrdVDate
 
      /COPY WNCPYSRC,FT101CV203
 
      ** Charges Account
 
      /COPY WNCPYSRC,FT101CV202
 
     C                   EXSR      @ChgAcc
 
      /COPY WNCPYSRC,FT101CV203
 
      ** Details of Charges
 
      /COPY WNCPYSRC,FT101CV202
 
     C                   EXSR      @DetChg
 
      /COPY WNCPYSRC,FT101CV203
 
      ** Receiver's Charges and Currency
 
      /COPY WNCPYSRC,FT101CV202
 
     C                   EXSR      @RecChgCcy
 
      /COPY WNCPYSRC,FT101CV203
 
      ** Default Receiver's Charges in Trnasfer Currency
 
      /COPY WNCPYSRC,FT101CV202
 
     C                   EXSR      @RecChgTfr
 
      /COPY WNCPYSRC,FT101CV203
 
      ** Default Receiver's Charges in Payment Currency
 
      /COPY WNCPYSRC,FT101CV202
 
     C                   EXSR      @RecChgPay
 
     C                   Endif
 
      /COPY WNCPYSRC,FT101CV203
 
 
      * Return
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @TrnAmt - Validate Transaction Amount/Currency
      *****************************************************************
     C     @TrnAmt       BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PTRNAMT'
 
      ** Validate
     C                   CALLB     'FTVAMCY01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @DealRef - Validate FX Deal Reference
      *****************************************************************
     C     @DealRef      BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PFXDREF'
 
      ** Validate
     C                   CALLB     'FTVFXDL01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @OrAmtCcy - Validate Original Amount/Currency
      *****************************************************************
     C     @OrAmCcy      BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PTOCCY'
 
      ** Validate
     C                   CALLB     'FTVORAM01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @XRatePayAmt - Validate Exchange Rate/Override Indicator and
      **                Payment Amount and Currency
      *****************************************************************
     C     @XRatePayAmt  BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PXRATE'
 
      ** Validate
     C                   CALLB     'FTVEXRT01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @CrdVDate - Validate Credit Value Date
      *****************************************************************
     C     @CrdVDate     BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PCRDVDT'
 
      ** Validate
     C                   CALLB     'FTVCRVL01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @ChgAcc - Validate Charges Account
      *****************************************************************
     C     @ChgAcc       BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PCHGACC'
 
      ** Validate
     C                   CALLB     'FTVCHAC01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @DetChg - Validate Details of Charges
      *****************************************************************
     C     @DetChg       BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PTDCHGS'
 
      ** Validate
     C                   CALLB     'FTVDECH01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @RecChgCcy - Validate Receiver's Charges/Currency
      *****************************************************************
     C     @RecChgCcy    BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PRCHCCY'
 
      ** Validate
     C                   CALLB     'FTVRECH03'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @RecChgTfr - Validate Receiver's Charges in Transfer Currency
      *****************************************************************
     C     @RecChgTfr    BEGSR
 
      ** Default
     C                   CALLB     'FTVCHTR01'   P#List
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @RecChgPay - Validate Receiver's Charges in Payment Currency
      *****************************************************************
     C     @RecChgPay    BEGSR
 
      ** Default
     C                   CALLB     'FTVCHPY01'   P#List
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RtnCodeIn        10
      * Response mode (1A), from source system common header (A or S)
     C                   PARM                    RespMode          1
      * Action Code
     C                   PARM                    ActionCode        1
 
      * Header information (DS) from source system in screen format
     C                   PARM                    HdrRcdIn
      * Detail information (DS) from source system in screen format
     C                   PARM                    DtlRcdIn
 
      * OK Flags Data Structure - Screen 2 only
     C                   PARM                    OkFlagDS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIx
 
 
      ** Set up the name of the MSGF from which the message handler
      ** will get the messages.
     C                   Eval      #MsgFile = 'FTUSRMSG'
 
 
      ** General parameter list
     C     P#List        PLIST
 
      * INPUTS
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode
      *  Header record in screen format
      *  Detail record in screen format
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlagDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset work error arrays.  Called before each      *
      *             low-level validation module (CTR modules).        *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
     C                   EVAL      DDSName = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      WFldNmXAr = *Blanks
     C                   EVAL      WMsgIDXAr = *Blanks
     C                   EVAL      WMsgDtXAr = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *             from each validation module.                      *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     FldNamXar     FldNameArr(#I)
     C                   Movea     MsgIDXAr      MsgIdArr(#I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(#I)
     C                   Endif
      *
      * Set Error Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   Eval      Idx = #I - 1
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     WFldNmXAr     WFldNamArr(#I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(#I)
     C                   Movea     WMsgDtXAr     WMsgDtaArr(#I)
     C                   Endif
      *
      * Set Warning Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   Eval      WIx = #I - 1
      *
     C                   ENDSR
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
