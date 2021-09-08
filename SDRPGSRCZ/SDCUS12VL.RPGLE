     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Puma II Details - Italian')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCUS12VL - Midas SD Customer Puma II Details - Validation   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. MD058097           Date 23Apr21               *
      *  Prev Amend No. LUC139             Date 23Dec20               *
      *                 BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058097 - CUSD Insert check                                 *
      *  LUC139 - UCI Italian Returns Upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------

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

     D*NwCuScnFmt    E DS                  EXTNAME(SDCURXPD)                       LUC139
     D NwCuScnFmt    E DS                  EXTNAME(SDCUS2PD)                       LUC139
      ** Transaction Details in screen format

     D OKFlags       E DS                  EXTNAME(SDECUIT2PD)
      ** Transaction Details OK indicators

     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPD)
      ** Main Customer Details file layout

     D*NwCuFilFmt2   E DS                  EXTNAME(SDVCUIT2PD)                      LUC139
     D NwCuFilFmt2   E DS                  EXTNAME(SDCUT2PD)                        LUC139
     D                                     PREFIX(V)                                LUC139
      ** Puma II Details file layout

     D NwCuFilFmt1   E DS                  EXTNAME(SDCUT1PD)                        LUC139
      ** BOI Customer Details file layout                                           LUC139
                                                                                            MD058097
     D PDATA           DS          1024                                                     MD058097
     D #1CUST                  1      6                                                     MD058097
     D #1PAIN                  7      7                                                     MD058097
     D #1PCNB                  8     13                                                     MD058097
     D #1COLC                 15     16                                                     MD058097
     D #1LINC                 17     18                                                     MD058097
     D #1BRCD                 19     21                                                     MD058097
     D #1BNBI                 22     22                                                     MD058097
     D #2CNCZ                 23     24                                                     MD058097
     D #1FOTR                 45     64                                                     MD058097
     D #1TMST                 65     90Z                                                    MD058097
     D #1CRNM                 91    110                                                     MD058097

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Idx             S              3P 0
      ** Index for arrays of of error message ids etc

     D WIdx            S              3P 0
      ** Index for arrays of of warning message ids etc

     D I               S              3P 0
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Validate Consolidation Code

     C                   EXSR      SRCONS

      ** Validate Counterparty Code

     C                   EXSR      SRCPTY

      ** Validate Economical Sector Classification

     C                   EXSR      SRECSG

      ** Validate ABI Code or Financial Counterparty depending on
      ** residenza and bank/non bank indicator

     C**********         IF        DDTA004 = '1' AND                                       LUC139
     C                   IF        BBA004 = '1' AND                                        LUC139
     C**********                   CUBNBI = 'Y'                                          MD058097
     C                             #1BNBI = 'Y'                                          MD058097

      ** Validate ABI Code

     C                   EXSR      SRABI
     C                   ELSE

      ** Validate Financial Counterparty Id

     C                   EXSR      SRFIID
     C                   ENDIF

      ** Validate Doubtful Code

     C                   EXSR      SRDBCD

      ** Validate Economical Branch Class

     C                   EXSR      SRECBC

      ** Validate Italian CAP Code

     C                   EXSR      SRPRCT

      ** Validate Counterparty Type

     C                   EXSR      SRCNTP

      ** Validate Partita IVA (VAT Code)

     C                   EXSR      SRFSCD

      ** Validate Customer CR Name

     C                   EXSR      SRCUCR

      ** Validate Customer CR Type

     C                   EXSR      SRCRTP

      ** Validate Counterparty Participation

     C                   EXSR      SRCPPT

      ** Validate Birth Province

     C                   EXSR      SRBRPR

      ** Validate CAB Customer Residence Code

     C                   EXSR      SRHLCD

      ** Validate Italian Province Code

     C                   EXSR      SRPROV

      ** Validate CCIAA Residence                                               LUC139
     C                   EXSR      SRCCCL                                       LUC139
                                                                                LUC139
      ** Validate Reporting Filter                                              LUC139
     C                   EXSR      SRCURF                                       LUC139
                                                                                LUC139
      ** Setup valids file

     C                   IF        Idx = 0
     C                   EXSR      SRSetVal
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCONS - Validate Consolidation Code                         *
      *                                                               *
      *****************************************************************
     C     SRCONS        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTCONS'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTCONS

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTCONSOK                                  LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTCONSOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCPTY - Validate Counterpary Code                           *
      *                                                               *
      *****************************************************************
     C     SRCPTY        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTCPTY'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTCONS
     C                   PARM                    DDTCPTY

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTCPTYOK                                  LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTCPTYOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRECSG - Validate Sector Classification Code                 *
      *                                                               *
      *****************************************************************
     C     SRECSG        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTECSG'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTECSG

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTECSGOk                                  LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTECSGOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRABI - Validate ABI Code                                    *
      *                                                               *
      *****************************************************************
     C     SRABI         BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTABI'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTABI
     C                   PARM                    DDTABIK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTABIKOk                                 LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTABIKOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFIID - Validate Financial Counterparty Id                  *
      *                                                               *
      *****************************************************************
     C     SRFIID        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTFIID'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTFIID
     C**********         PARM                    CUBNBI                               MD058097
     C                   PARM                    #1BNBI                               MD058097
     C                   PARM                    BBA004                                LUC139

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTFIIDOk                                  LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTFIIDOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDBCD - Validate Doubtful Code                              *
      *                                                               *
      *****************************************************************
     C     SRDBCD        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTDBCD'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTDBCD

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTDBCDOk                                   LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTCONSOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRECBC - Validate Economical Branch Class                    *
      *                                                               *
      *****************************************************************
     C     SRECBC        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTECBC'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTECBC

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTECBCOk                                  LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTECBCOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPRCT - Validate Italian CAP Code                           *
      *                                                               *
      *****************************************************************
     C     SRPRCT        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTPRCT'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTPRCT

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTPRCTOk                                 LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTPrctOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCNTP - Validate Counterparty Type                          *
      *                                                               *
      *****************************************************************
     C     SRCNTP        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTCNTP'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTCNTP

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTCNTPOk                                  LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTCNTPOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFSCD - Validate Partita IVA (VAT Code)                     *
      *                                                               *
      *****************************************************************
     C     SRFSCD        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTFSCD'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTFSCD

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTFSCDOk                                LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTFSCDOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBRPR - Validate Birth Province                             *
      *                                                               *
      *****************************************************************
     C     SRBRPR        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTBRPR'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTBRPR

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTBRPROk                                  LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTBrprOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCUCR - Validate Customer CR Name                           *
      *                                                               *
      *****************************************************************
     C     SRCUCR        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTCUCR'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTCUCR
     C                   PARM                    DDTECSG                                LUC139

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTCUCROk                                LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTCUCrOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCRTP - Validate Customer CR Type                           *
      *                                                               *
      *****************************************************************
     C     SRCRTP        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTCRTP'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTCRTP

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTCRTPOk                                 LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTCrtpOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCPPT - Validate Counterparty Participation                 *
      *                                                               *
      *****************************************************************
     C     SRCPPT        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTCPPT'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTCPPT

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTCPPTOk                                  LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTCpptOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHLCD - Validate CAB Customer Residence Code                *
      *                                                               *
      *****************************************************************
     C     SRHLCD        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTHLCD'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTHLCD
     C                   PARM                    DDTHLCK
     C**********         PARM                    CUBNBI                                 MD058097
     C                   PARM                    #1BNBI                                 MD058097
     C**********         PARM                    DDTA004                                  LUC139
     C                   PARM                    BBA004                                   LUC139

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTHLCDOk                                  LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTHlcdOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROV - Validate Italian Province Code                      *
      *                                                               *
      *****************************************************************
     C     SRPROV        BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'SDVTPROV'

     C                   PARM                    ReturnCode
     C                   PARM                    DDTPROV

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDTPROVOk                                  LUC139

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C*********          CALLB     'ZASETOKFLG'                                             LUC139
     C*********          PARM                    DDTProvOK                                  LUC139
     C*********          PARM                    ReturnCode                                 LUC139
     C*********          PARM                    WarnGlobal                                 LUC139

     C                   ENDSR
      *****************************************************************                  LUC139
      /EJECT                                                                             LUC139
      *****************************************************************                  LUC139
      *                                                               *                  LUC139
      *  SRCCCL - Validate CCIAA Customer Residence                   *                  LUC139
      *                                                               *                  LUC139
      *****************************************************************                  LUC139
     C     SRCCCL        BEGSR                                                           LUC139
                                                                                         LUC139
      ** Reset variables updated by validation                                           LUC139
                                                                                         LUC139
     C                   EXSR      RESETERRS                                             LUC139
                                                                                         LUC139
      ** Validate Field                                                                  LUC139
                                                                                         LUC139
     C                   CALLB     'SDVTCCCL'                                            LUC139
                                                                                         LUC139
     C                   PARM                    ReturnCode                              LUC139
     C**********         PARM                    CUPAIN                         LUC139 MD058097
     C                   PARM                    #1PAIN                                MD058097
     C                   PARM                    DDTCCCL                                 LUC139
                                                                                         LUC139
      ** Outputs                                                                         LUC139
      ** Error fields/message IDs/message data (arrays) from/to caller                   LUC139
                                                                                         LUC139
     C                   PARM                    FldNamXAr                               LUC139
     C                   PARM                    MsgIDXAr                                LUC139
     C                   PARM                    MsgDtaXAr                               LUC139
     C                   PARM                    WFldNmXAr                               LUC139
     C                   PARM                    WMsgIDXAr                               LUC139
     C                   PARM                    WMsgDtXAr                               LUC139
     C                   PARM                    DDTCCCLOk                               LUC139
                                                                                         LUC139
      ** Update error info with that returned from the validation                        LUC139
      ** module                                                                          LUC139
                                                                                         LUC139
     C                   EXSR      UPDATERRS                                             LUC139
                                                                                         LUC139
     C                   ENDSR                                                           LUC139
      *****************************************************************                  LUC139
      /EJECT                                                                             LUC139
      *****************************************************************                  LUC139
      *                                                               *                  LUC139
      *  SRCURF - Validate Reporting Filter                           *                  LUC139
      *                                                               *                  LUC139
      *****************************************************************                  LUC139
     C     SRCURF        BEGSR                                                           LUC139
                                                                                         LUC139
      ** Reset variables updated by validation                                           LUC139
                                                                                         LUC139
     C                   EXSR      RESETERRS                                             LUC139
                                                                                         LUC139
      ** Validate Field                                                                  LUC139
                                                                                         LUC139
     C                   CALLB     'SDVTCURF'                                            LUC139
                                                                                         LUC139
     C                   PARM                    ReturnCode                              LUC139
     C                   PARM                    DDTCURF                                 LUC139
                                                                                         LUC139
      ** Outputs                                                                         LUC139
      ** Error fields/message IDs/message data (arrays) from/to caller                   LUC139
                                                                                         LUC139
     C                   PARM                    FldNamXAr                               LUC139
     C                   PARM                    MsgIDXAr                                LUC139
     C                   PARM                    MsgDtaXAr                               LUC139
     C                   PARM                    WFldNmXAr                               LUC139
     C                   PARM                    WMsgIDXAr                               LUC139
     C                   PARM                    WMsgDtXAr                               LUC139
     C                   PARM                    DDTCURFOk                               LUC139
                                                                                         LUC139
      ** Update error info with that returned from the validation                        LUC139
      ** module                                                                          LUC139
                                                                                         LUC139
     C                   EXSR      UPDATERRS                                             LUC139
                                                                                         LUC139
     C                   ENDSR                                                           LUC139
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module                      *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR

     C                   EVAL      RetCodeOut = *Blanks

      ** Reset error & warning fields/message IDs/message data (arrays)

     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      WFldNmXAr = *BLANK
     C                   EVAL      WMsgIDXAr = *BLANK
     C                   EVAL      WMsgDtXAr = *BLANK

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
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
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
      *  SRSetVal - Set Values to Valids record                       *
      *                                                               *
      *****************************************************************
     C     SRSetVal      BEGSR

     C**********         MOVE      CUCUST        VPCCUST                                MD058097
     C                   MOVE      #1CUST        VPCCUST                                MD058097
     C                   MOVE      DDTCONS       VPCCONS
     C                   MOVE      DDTCPTY       VPCCPTY
     C                   MOVE      DDTECSG       VPCECSG

     C**********         IF        CUBNBI = 'Y' AND                                     MD058097
     C                   IF        #1BNBI = 'Y' AND                                     MD058097
     C**********                   DDTA004 = '1'                                           LUC139
     C                             BBA004 = '1'                                            LUC139
     C                   EVAL      VPCFIID = '000' + DDTABI + DDTABIK
     C                   ELSE
     C                   MOVE      DDTFIID       VPCFIID
     C                   ENDIF

     C                   MOVE      DDTDBCD       VPCDBCD
     C                   MOVE      DDTECBC       VPCECBC
     C                   MOVE      DDTPRCT       VPCPRCT
     C                   MOVE      DDTPROV       VPCPROV
     C                   MOVE      DDTCNTP       VPCCNTP
     C                   MOVE      DDTFSCD       VPCFSCD
     C                   MOVE      DDTBNTP       VPCBNTP
     C                   MOVE      DDTCUCR       VPCCUCR
     C                   MOVE      DDTCRTP       VPCCRTP
     C                   MOVE      DDTCRNM       VPCCRNM
     C                   MOVE      DDTFCCR       VPCFCCR
     C                   MOVEL     DDTHLCD       VPCHLCD
     C                   MOVE      DDTHLCK       VPCHLCD
     C                   MOVE      DDTCCCN       VPCCCCN
     C                   MOVE      DDTCPPT       VPCCPPT
     C                   MOVE      DDTBRPR       VPCBRPR
     C                   MOVE      DDTCCCL       VPCCCCL                                 LUC139
     C                   MOVE      DDTCURF       VPCCURF                                 LUC139

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

      ** Inputs
      ** Transaction Details

     C**********         PARM                    NwCuFilFmt                              MD058097
     C                   Parm                    PData                                   MD058097
     C                   PARM                    NwCuScnFmt
     C                   PARM                    NwCuFilFmt1                             LUC139

      ** Outputs
      ** Transaction Details OK inds

     C                   PARM                    OKFlags

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    WIdx

      ** Valid Transaction details layout (DS) from/to caller

     C                   PARM                    NwCuFilFmt2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module
      /COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
