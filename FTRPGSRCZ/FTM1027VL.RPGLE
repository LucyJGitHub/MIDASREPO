     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate 102 header screen 2')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1027VL - Validate MT102 header record (Screen 2)          *
      *                                                               *
      *  Function: This Program Validates FT MT102 Records for        *
      *            input to the Midas database.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 BUG15270           Date 07Nov07               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 CAP084             Date 15Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 17Nov99               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15270 - SOSE not declared at OMFM but accepted at CCTD    *
      *  CSW207 - SWIFT 2007 Changes (Recompiled)                     *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen           *
      *  CFT006 - Funds Transfer/Swift Messages MT101/MT102           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTM1027V01
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
 
     D OKFlags       E DS                  EXTNAME(FTE102H2PD)
 
     D  @@Arr          S              1    DIM(4)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D GenOkFlag3      S              1    Export
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
     D #I              S              2  0
                                                                                              CSW209
     D CSW209          S              1A                                                      CSW209
     D Prtcd           S              7A                                                      CSW209
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FTM1027V02
 
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization subroutine                                                            CSW209
     C                   ExSR      SrInit                                                     CSW209
                                                                                              CSW209
      **Reset the OkFlagDS to be 'Y' each time it is called.
      * Reset the OkFlagS to be 'Y' each time it is called.
     C                   Reset                   OkFlags
 
     C**********         Eval      FldNameArr  =  *Blanks                                   BUG15270
     C**********         Eval      MsgIDArr    =  *Blanks                                   BUG15270
     C**********         Eval      MsgDtaArr   =  *Blanks                                   BUG15270
     C**********         Eval      Idx         =  *Zeros                                    BUG15270
     C**********         Eval      WFldNamArr  =  *Blanks                                   BUG15270
     C**********         Eval      WMsgIDArr   =  *Blanks                                   BUG15270
     C**********         Eval      WMsgDtaArr  =  *Blanks                                   BUG15270
     C**********         Eval      WIdx        =  *Zeros                                    BUG15270
 
      ** Call Validation Modules in Sequence if action code <> 'E'
     C                   If         ActionCode = 'I' or  ActionCode = 'A' or
     C                              ActionCode = 'X'
 
      /COPY WNCPYSRC,FT102HV043
      ** Validate Detail of Charges
     C                   Exsr      SrChrg
      /COPY WNCPYSRC,FT102HV044
                                                                                184060
      ** Transaction Type Code                                                  184060
                                                                                184060
     C                   EXSR      @TrnTyCd                                     184060
 
      /COPY WNCPYSRC,FT102HV045
      ** Validate Regulatory Reporting
     C                   Exsr      SrRgRt
      /COPY WNCPYSRC,FT102HV046
 
     C                   Exsr      SrBop
 
      /COPY WNCPYSRC,FT102HV047
 
      /COPY WNCPYSRC,FT102HV048
 
     C                   Exsr      SrAtxt
 
                                                                                              CSW209
     C                   If        CSW209 = 'Y'                                               CSW209
                                                                                              CSW209
                                                                                              CSW209
      **    Validate network                                                                  CSW209
     C                   Exsr      SrNtwrk                                                    CSW209
                                                                                              CSW209
      **    Validate message type                                                             CSW209
     C                   Exsr      SrMsgTy                                                    CSW209
                                                                                              CSW209
      **    Validate incoming validation flag                                                 CSW209
     C                   Exsr      SrIVlFlg                                                   CSW209
                                                                                              CSW209
     C                   EndIf                                                                CSW209
 
      /COPY WNCPYSRC,FT102HV049
 
     C                   Endif
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrChrg - Validate Detail of Charges                           *
      *****************************************************************
     C     SrChrg        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'CCTCHG'                           CAP084
     C                   Eval      DDSName = 'PCCTCHG'                          CAP084
     C                   CallB     'FTVCHHD01'   P#List
     C                   Eval      OkCTChg = GenOkFlag3
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************         184060
      * @TrnTyCd - Validate Transaction Type Code                      *        184060
      *****************************************************************         184060
     C     @TrnTyCd      Begsr                                                  184060
                                                                                184060
      ** Reset variables updated by each module                                 184060
     C                   Exsr      SrReset                                      184060
                                                                                184060
      ** Validate                                                               184060
     C*******************Eval      DDSName = 'TRNSTP'                     184060CAP084
     C                   Eval      DDSName = 'PTRNSTP'                          CAP084
     C                   CallB     'FTVTTCD02'   P#List2                        184060
     C                   Eval      OkTRNTP = GenOkFlag3                         184060
                                                                                184060
      ** Update error info with that returned from the validation module        184060
     C                   Exsr      SrUpdate                                     184060
                                                                                184060
     C                   Endsr                                                  184060
      /EJECT
      *****************************************************************
      * SrRgRt - Validate Regulatory Reporting                         *
      *****************************************************************
     C     SrRgRt        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C****************** Eval      DDSName = 'REGRP1'                           CAP084
     C                   Eval      DDSName = 'PREGRP1'                          CAP084
     C                   CallB     'FTVRERE02'   P#List2
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrBop  - Validate Bank Operation Code                          *
      *****************************************************************
     C     SrBop         Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C*******************Eval      DDSName = 'CCTBOC'                           CAP084
     C                   Eval      DDSName = 'PCCTBOC'                          CAP084
     C                   CallB     'FTVBACD01'   P#List2
     C                   Eval      OkCTBoc = GenOkFlag3
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrATxt - Validate Additional Text                              *
      *****************************************************************
     C     SrAtxt        Begsr
 
      ** Reset variables updated by each module
     C                   Exsr      SrReset
 
      ** Validate
     C****************** Eval      DDSName = 'ADNLI1'                           CAP084
     C                   Eval      DDSName = 'PADNLI1'                          CAP084
     C                   CallB     'FTVADDE01'   P#List2
     C                   Eval      OKADIN1 = GenOkFlag3
 
      ** Update error info with that returned from the validation module
     C                   Exsr      SrUpdate
 
     C                   Endsr
      *****************************************************************                       CSW209
      /EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      * SrNtwrk - Validate Network                                     *                      CSW209
      *****************************************************************                       CSW209
     C     SrNtwrk       Begsr                                                                CSW209
                                                                                              CSW209
      ** Reset variables updated by each module                                               CSW209
     C                   Exsr      SrReset                                                    CSW209
                                                                                              CSW209
      ** Validate                                                                             CSW209
     C                   Eval      DDSName = 'CCNWRK'                                         CSW209
     C                   CallB     'FTV2NWK'     P#List2                                      CSW209
                                                                                              CSW209
      ** Update error info with that returned from the validation module                      CSW209
     C                   Exsr      SrUpdate                                                   CSW209
                                                                                              CSW209
     C                   Endsr                                                                CSW209
      *****************************************************************                       CSW209
      /EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      * SrMsgTy - Validate Message Type                                *                      CSW209
      *****************************************************************                       CSW209
     C     SrMsgTy       Begsr                                                                CSW209
                                                                                              CSW209
      ** Reset variables updated by each module                                               CSW209
     C                   Exsr      SrReset                                                    CSW209
                                                                                              CSW209
      ** Validate                                                                             CSW209
     C                   Eval      DDSName = 'CCMTPY'                                         CSW209
     C                   CallB     'FTV2MTP'     P#List2                                      CSW209
                                                                                              CSW209
      ** Update error info with that returned from the validation module                      CSW209
     C                   Exsr      SrUpdate                                                   CSW209
                                                                                              CSW209
     C                   Endsr                                                                CSW209
      *****************************************************************                       CSW209
      /EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      * SrIVlFlg - Validate Incoming Validation Flag                    *                     CSW209
      *****************************************************************                       CSW209
     C     SrIVlFlg      Begsr                                                                CSW209
                                                                                              CSW209
      ** Reset variables updated by each module                                               CSW209
     C                   Exsr      SrReset                                                    CSW209
                                                                                              CSW209
      ** Validate                                                                             CSW209
     C                   Eval      DDSName = 'CCVALF'                                         CSW209
     C                   CallB     'FTV2VLF'     P#List2                                      CSW209
                                                                                              CSW209
      ** Update error info with that returned from the validation module                      CSW209
     C                   Exsr      SrUpdate                                                   CSW209
                                                                                              CSW209
     C                   Endsr                                                                CSW209
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrReset - Reset error information that is received back       *
      *           from each validation module.                        *
      *****************************************************************
     C     SrReset       Begsr
 
     C                   Eval      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *BlankS
     C                   Eval      WMsgIDXAr = *Blanks
     C                   Eval      WMsgDtXAr = *Blanks
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrUpdate - Update error information with that received back   *
      *            from each validation module.                       *
      *****************************************************************
     C     SrUpdate      Begsr
 
      ** Update error fields/message IDs/message data (arrays)
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     FldNamXar     FldNameArr(#I)
     C                   Movea     MsgIDXAr      MsgIdArr(#I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(#I)
     C                   Endif
 
      ** Set Error Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   Eval      Idx = #I - 1
 
      ** Update warning fields/message IDs/message data (arrays)
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     WFldNmXAr     WFldNamArr(#I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(#I)
     C                   Movea     WMsgDtXAr     WMsgDtaArr(#I)
     C                   Endif
 
      ** Set Warning Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   Eval      WIdx = #I - 1
 
     C                   Endsr
      *****************************************************************                       CSW209
      /EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SrInit - Initialises all OTPAYDD fields                       *                       CSW209
      *                                                               *                       CSW209
      * Called by: Main Processing                                    *                       CSW209
      *                                                               *                       CSW209
      * Calls: None                                                   *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
     C     SrInit        Begsr                                                                CSW209
                                                                                              CSW209
      ** Check if SWIFT 2009 is installed                                                     CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM                    PRtCd                                        CSW209
                                                                                              CSW209
     C                   IF        PRtCd = 'CSW2009'                                          CSW209
     C                   EVAL      CSW209 = 'Y'                                               CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      CSW209 = 'N'                                               CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Endsr                                                                CSW209
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        Begsr
 
     C     *ENTRY        PLIST
     C                   Parm                    RtnCodeIn        10
      ** Response mode (1A), from source system common header (A or S)
     C                   Parm                    RespMode          1
      ** Action Code
     C                   Parm                    ActionCode        1
 
      ** Header information (DS) from source system
     C                   Parm                    HdrRcdIn
 
      ** OK Flags Data Structure
     C                   Parm                    OkFlags
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   Parm                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   Parm                    WIdx
 
      ** Set up the name of the MSGF from which the message handler will
      ** get the messages
     C                   Eval      #MsgFile = 'FTUSRMSG'
 
     C     P#List        PLIST
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode
      ** Screen fields
     C                   Parm                    HdrRcdIn
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
 
     C     P#List2       PLIST
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode
      ** Screen fields
     C                   Parm                    HdrRcdIn
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
     C                   Parm                    OkFlags
 
     C                   Endsr
 
      /COPY WNCPYSRC,FTM1027V03
 
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
