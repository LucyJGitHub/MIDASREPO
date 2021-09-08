     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Account Extension - Italy')          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADIVL - Validate GL Account Extension - Italy            *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2020                 *
      *                                                               *
      *  Last Amend No. LUC139             Date 21Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CRE039             Date 22Oct07               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian Returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CRE039 - Withholding Tax on Credit Interest (Recompile)      *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
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

      ** Standard D-specs
      ** ================

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

      /COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      /COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays

      /COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays

      /COPY ZACPYSRC,ERR_XARRYS

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
     D RegData       E DS                  EXTNAME(GLAMRXPD)
     D ValidItalyExt E DS                  EXTNAME(GLVAMIT1PD)
      ** GL AMAD Valid file

     D OKFlagsItaly  E DS                  EXTNAME(GLEAMIT1PD)
      ** Extension File Error Flags

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D I               S              3S 0

     D DataItaly       DS          1024
     D  I1CNUM                 1      6
     D  I1CCY                  7      9
     D  I1ACOD                10     19
     D  I1ACSQ                20     21
     D  I1BRCA                22     24
     D  I1ATYP                25     25
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation                   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Validate Collocazione Effetti

     C                   EXSR      SrMBCD

      ** Validate Scaduto Dal

     C                   EXSR      SrUNDT

      ** Validate Category Code

     C                   EXSR      SrCATC

      ** Validate Type of Activity

     C                   EXSR      SrTPAC

      ** Validate Client Role CR

     C                   EXSR      SrCLRL

      ** Validate Account Status CR

     C                   EXSR      SrACST

     C                   EXSR      SrLNIT                                       LUC139
     C                   EXSR      SrTEGL                                       LUC139
     C                   EXSR      SrCMPC                                       LUC139

     C                   IF        Idx = 0

      ** Setup Fields of Valid File

     C                   EXSR      SrSetup
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMBCD - Validate Collocazione Effetti                       *
      *                                                               *
      *****************************************************************

     C     SrMBCD        BEGSR

      ** Reset variables updated by each module

     C                   EXSR      RESETERRS

      ** Validate Collocazione Effetti

     C                   CALLB     'GLVMBCD  '

      ** Return Code

     C                   PARM                    ReturnCode

      ** Collocazione Effetti

     C                   PARM                    DDTMBCD

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

      ** Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS

      ** Use the return code's value to set the field's OK flag

     C                   RESET                   DDTMBCDOK
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDTMBCDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUNDT - Validate Scaduto Dal                                *
      *                                                               *
      *****************************************************************

     C     SrUNDT        BEGSR

      ** Reset variables updated by each module

     C                   EXSR      RESETERRS

      ** Validate Scaduto Dal

     C                   CALLB     'GLVUNDT  '

      ** Return Code

     C                   PARM                    ReturnCode

      ** Account Type

     C                   PARM                    I1ATYP

      ** Scaduto Dal

     C                   PARM                    DDTUNDT

      ** Format

     C                   PARM                    ITUNDT

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

      ** Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS

      ** Use the return code's value to set the field's OK flag

     C                   RESET                   DDTUNDTOK
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDTUNDTOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCATC - Validate Category Code                              *
      *                                                               *
      *****************************************************************

     C     SrCATC        BEGSR

      ** Reset variables updated by each module

     C                   EXSR      RESETERRS

      ** Validate Category Code

     C                   CALLB     'GLVCATC  '

      ** Return Code

     C                   PARM                    ReturnCode

      ** Account Type

     C                   PARM                    I1ATYP

      ** Category Code

     C                   PARM                    DDTCATC

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

      ** Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS

      ** Use the return code's value to set the field's OK flag

     C                   RESET                   DDTCATCOK
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDTCATCOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTPAC - Validate Type of Activity                           *
      *                                                               *
      *****************************************************************

     C     SrTPAC        BEGSR

      ** Reset variables updated by each module

     C                   EXSR      RESETERRS

      ** Validate Type of Activity

     C                   CALLB     'GLVTPAC  '

      ** Return Code

     C                   PARM                    ReturnCode

      ** Account Type

     C                   PARM                    I1ATYP

      ** Type of Activity

     C                   PARM                    DDTTPAC

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

      ** Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS

      ** Use the return code's value to set the field's OK flag

     C                   RESET                   DDTTPACOK
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDTTPACOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCLRL - Validate Client Role CR                             *
      *                                                               *
      *****************************************************************

     C     SrCLRL        BEGSR

      ** Reset variables updated by each module

     C                   EXSR      RESETERRS

      ** Validate Client Role CR

     C                   CALLB     'GLVCLRL  '

      ** Return Code

     C                   PARM                    ReturnCode

      ** Account Type

     C                   PARM                    I1ATYP

      ** Client Role CR

     C                   PARM                    DDTCLRL

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

      ** Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS

      ** Use the return code's value to set the field's OK flag

     C                   RESET                   DDTCLRLOK
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDTCLRLOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrACST - Validate Account Status CR                          *
      *                                                               *
      *****************************************************************

     C     SrACST        BEGSR

      ** Reset variables updated by each module

     C                   EXSR      RESETERRS

      ** Validate Account Status CR

     C                   CALLB     'GLVACST  '

      ** Return Code

     C                   PARM                    ReturnCode

      ** Account Type

     C                   PARM                    I1ATYP

      ** Account Status CR

     C                   PARM                    DDTACST

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

      ** Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS

      ** Use the return code's value to set the field's OK flag

     C                   RESET                   DDTACSTOK
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDTACSTOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

     C                   ENDSR
      *****************************************************************                LUC139
      /EJECT                                                                           LUC139
      *****************************************************************                LUC139
      *                                                               *                LUC139
      *  SrLNIT - Validate Line Item of Usura reporting               *                LUC139
      *                                                               *                LUC139
      *****************************************************************                LUC139
                                                                                       LUC139
     C     SrLNIT        BEGSR                                                         LUC139
                                                                                       LUC139
      ** Reset variables updated by each module                                        LUC139
                                                                                       LUC139
     C                   EXSR      RESETERRS                                           LUC139
                                                                                       LUC139
      ** Validate Line Item of Usura reporting                                         LUC139
                                                                                       LUC139
     C                   CALLB     'GLVLNIT  '                                         LUC139
      ** Return Code                                                                   LUC139
     C                   PARM                    ReturnCode                            LUC139
      ** Line Item of Usura reporting                                                  LUC139
     C                   PARM                    DDTLNIT                               LUC139
      ** Error fields/message IDs/message data (arrays) from/to caller                 LUC139
     C                   PARM                    FldNamXAr                             LUC139
     C                   PARM                    MsgIDXAr                              LUC139
     C                   PARM                    MsgDtaXAr                             LUC139
     C                   PARM                    WFldNmXAr                             LUC139
     C                   PARM                    WMsgIDXAr                             LUC139
     C                   PARM                    WMsgDtXAr                             LUC139
                                                                                       LUC139
      ** Update error info with that returned from the validation module               LUC139
                                                                                       LUC139
     C                   EXSR      UPDATERRS                                           LUC139
                                                                                       LUC139
      ** Use the return code's value to set the field's OK flag                        LUC139
                                                                                       LUC139
     C                   RESET                   DDTLNITOK                             LUC139
     C                   CALLB     'ZASETOKFLG'                                        LUC139
     C                   PARM                    DDTLNITOK                             LUC139
     C                   PARM                    ReturnCode                            LUC139
     C                   PARM                    WarnGlobal                            LUC139
                                                                                       LUC139
     C                   ENDSR                                                         LUC139
      *****************************************************************                LUC139
      /EJECT                                                                           LUC139
      *****************************************************************                LUC139
      *                                                               *                LUC139
      *  SrTEGL - Validate Effective Global Rate                      *                LUC139
      *                                                               *                LUC139
      *****************************************************************                LUC139
                                                                                       LUC139
     C     SrTEGL        BEGSR                                                         LUC139
                                                                                       LUC139
      ** Reset variables updated by each module                                        LUC139
                                                                                       LUC139
     C                   EXSR      RESETERRS                                           LUC139
                                                                                       LUC139
      ** Validate Effective Global Rate                                                LUC139
                                                                                       LUC139
     C                   CALLB     'GLVTEGL  '                                         LUC139
      ** Return Code                                                                   LUC139
     C                   PARM                    ReturnCode                            LUC139
      ** Line Item of Usura reporting                                                  LUC139
     C                   PARM                    DDTLNIT                               LUC139
      ** Global Effective Rate                                                         LUC139
     C                   PARM                    DDTTEGL                               LUC139
     C                   PARM                    ITTEGL                                LUC139
      ** Error fields/message IDs/message data (arrays) from/to caller                 LUC139
     C                   PARM                    FldNamXAr                             LUC139
     C                   PARM                    MsgIDXAr                              LUC139
     C                   PARM                    MsgDtaXAr                             LUC139
     C                   PARM                    WFldNmXAr                             LUC139
     C                   PARM                    WMsgIDXAr                             LUC139
     C                   PARM                    WMsgDtXAr                             LUC139
                                                                                       LUC139
      ** Update error info with that returned from the validation module               LUC139
                                                                                       LUC139
     C                   EXSR      UPDATERRS                                           LUC139
                                                                                       LUC139
      ** Use the return code's value to set the field's OK flag                        LUC139
                                                                                       LUC139
     C                   RESET                   DDTTEGLOK                             LUC139
     C                   CALLB     'ZASETOKFLG'                                        LUC139
     C                   PARM                    DDTTEGLOK                             LUC139
     C                   PARM                    ReturnCode                            LUC139
     C                   PARM                    WarnGlobal                            LUC139
                                                                                       LUC139
     C                   ENDSR                                                         LUC139
      *****************************************************************                LUC139
      /EJECT                                                                           LUC139
      *****************************************************************                LUC139
      *                                                               *                LUC139
      *  SrCMPC - Commission Rate of Max. U/Balance                   *                LUC139
      *                                                               *                LUC139
      *****************************************************************                LUC139
                                                                                       LUC139
     C     SrCMPC        BEGSR                                                         LUC139
                                                                                       LUC139
      ** Reset variables updated by each module                                        LUC139
                                                                                       LUC139
     C                   EXSR      RESETERRS                                           LUC139
                                                                                       LUC139
      ** Validate Commission Rate of Max. U/Balance                                    LUC139
                                                                                       LUC139
     C                   CALLB     'GLVCMPC  '                                         LUC139
      ** Return Code                                                                   LUC139
     C                   PARM                    ReturnCode                            LUC139
      ** Line Item of Usura reporting                                                  LUC139
     C                   PARM                    DDTLNIT                               LUC139
      ** Commission Rate of Max. U/Balance                                             LUC139
     C                   PARM                    DDTCMPC                               LUC139
     C                   PARM                    ITCMPC                                LUC139
      ** Error fields/message IDs/message data (arrays) from/to caller                 LUC139
     C                   PARM                    FldNamXAr                             LUC139
     C                   PARM                    MsgIDXAr                              LUC139
     C                   PARM                    MsgDtaXAr                             LUC139
     C                   PARM                    WFldNmXAr                             LUC139
     C                   PARM                    WMsgIDXAr                             LUC139
     C                   PARM                    WMsgDtXAr                             LUC139
                                                                                       LUC139
      ** Update error info with that returned from the validation module               LUC139
                                                                                       LUC139
     C                   EXSR      UPDATERRS                                           LUC139
                                                                                       LUC139
      ** Use the return code's value to set the field's OK flag                        LUC139
                                                                                       LUC139
     C                   RESET                   DDTCMPCOK                             LUC139
     C                   CALLB     'ZASETOKFLG'                                        LUC139
     C                   PARM                    DDTCMPCOK                             LUC139
     C                   PARM                    ReturnCode                            LUC139
     C                   PARM                    WarnGlobal                            LUC139
                                                                                       LUC139
     C                   ENDSR                                                         LUC139
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetup - Move fields to valid file format                   *
      *                                                               *
      *****************************************************************

     C     SrSetup       BEGSR

     C                   MOVE      I1CNUM        ITCNUM
     C                   MOVE      I1CCY         ITCCY
     C                   MOVE      I1ACOD        ITACOD
     C                   MOVE      I1ACSQ        ITACSQ
     C                   MOVE      I1BRCA        ITBRCA
     C                   MOVE      DDTMBCD       ITMBCD
     C                   MOVE      DDTCATC       ITCATC
     C                   MOVE      DDTTPAC       ITTPAC
     C                   MOVE      DDTCLRL       ITCLRL
     C                   MOVE      DDTACST       ITACST
     C                   MOVE      DDTLNIT       ITLNIT                                  LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module                      *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR

     C                   EVAL      ReturnCode = *BLANKS

      ** Reset error & warning fields/message IDs/message data (arrays)

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
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module                      *
      *                                                               *
      *****************************************************************
     C     UPDATERRS     BEGSR

      ** Update error fields/message IDs/message data (arrays)

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FldNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF

      ** Set Error Index

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx

      ** Update warning fields/message IDs/message data (arrays)

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF

      ** Set Warning Index

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

     C                   PARM                    DataItaly
     C                   PARM                    RegData
     C                   PARM                    OKFlagsItaly
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    Widx
     C                   PARM                    ValidItalyExt

      ** Move program name into *LDA field

     C     *LOCK         IN        LDA
     C                   MOVEL     'GLAMADIVL '  DBPGM
     C                   OUT       LDA

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module

      /COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
**  CPY@
(c) Finastra International Systems Ltd. 2020
