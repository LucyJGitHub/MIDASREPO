     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details Validation')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACMVAL - Midas SD Joint Account Member Details Validate   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. AR916535           Date 21Feb12               *
      *  Prev Amend No. AR739551           Date 30Mar11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23732           Date 23Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244537             Date 17Aug05               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 31Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR916535 - Cannot add members to joint customer              *
      *  AR739551-Selection (?) is not working for NAH field in       *
      *           Joint Account Member Maint. Part of core fix 233207 *
      *           was missed during incorp and needs to be re-applied.*
      *           (Child: AR739552)                                   *
      *  233207 - Non-account Holders Selection Processing            *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23732 - Joint Account Threshold                           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  244537 - To avoid overriding front office identifier         *
      *           (Recompile)                                         *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
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
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** API Validation Error Array Declarations
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** API Validation X Error Array Declarations
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Customer Number Array
     D PACUST          S              6A   DIM(100)
 
      ** Non-a/c Holder Array
     D PANAHO          S             10A   DIM(100)
 
      ** Investment Proportion Array
     D PAINVP          S             10A   DIM(100)
 
      ** Prime A/c Holder Array                                                               232543
     D PAPAHO          S              1A   DIM(100)                                           232543
                                                                                              232543
      ** Prime A/c Holder for Tax Array
     D PAPAHT          S              1A   DIM(100)
 
      ** Joint A/c Member Details - Screen Format
     D JAcMScrFmt    E DS                  EXTNAME(SDJACMPD)
 
      ** OK - Joint A/c Member Details
     D OKJAcMDets    E DS                  EXTNAME(SDEJACMPD)
 
      ** Valid Joint A/c Member Details Layout From/To Caller
     D ValidJAcM     E DS                  EXTNAME(SDVJACMPD)
                                                                                              CSW207
      ** Short Access Object Data Structure                                                   CSW207
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSW207
                                                                                              CSW207
      ** External DS for Midas modules details                                                CSW207
     D SDMMOD        E DS                  Extname(SDMMODPD)                                  CSW207
      *                                                                                     BUG23732
      ** Switchable Feature Details Data Structure                                          BUG23732
      *                                                                                     BUG23732
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG23732
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PResMode        S              1A
     D OKACTN          S              1A
 
      ** API Parameters
     D PRetCode        S             10A
     D PValMode        S              6A
     D PDACTN          S              1A
     D PDJANO          S              6A
     D PDCUST          S              6A
     D PDNAHO          S             10A
     D PDINVP          S             10A
     D PDPAHT          S              1A
     D PDPAHO          S              1A
 
      ** Access Object Parameters                                                             CSW207
     D PRtCd           S              7A                                                      CSW207
     D POptn           S              7A                                                      CSW207
     D PSARD           S              6A                                                      CSW207
                                                                                              CSW207
      ** Working Variables
     D Ix              S              3P 0
     D WIx             S              3P 0
     D WI              S              3P 0
     D CGL031          S              1    INZ(' ')                                           CSW207
     D CGL032          S              1    INZ(' ')                                           CSW207
     D PrivBank        S              1    INZ(' ')                                           CSW207
     D CER048          S              1A                                                    BUG23732
     D WActn           S              1A                                                    BUG23732
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Validate Joint A/c Member details.
 
     C                   IF        PValMode = '*FIELD'
     C                   EXSR      SRFldVal
     C                   ELSE
     C                   EXSR      SRGrpVal
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFldVal - Handles field validation.                         *
      *                                                               *
      *****************************************************************
     C     SRFldVal      BEGSR
 
      ** Validate Customer Number.
 
     C                   EXSR      SRVCust
 
      ** Validate Non-a/c Holder.
 
     C                   EXSR      SRVNAHo
 
      ** Crosscheck Customer Number & Non-a/c Holder.
 
     C                   EXSR      SRVJAMB
 
      ** Validate Investment Proportion.
 
     C                   EXSR      SRVInvP
 
      ** Validate Prime A/c Holder for Tax Purposes.
 
     C                   IF        (CGL031 = 'Y' AND CGL032 = 'Y') OR                         CSW207
     C                             PrivBank = 'Y'                                             CSW207
     C                   EXSR      SRVPAHT
     C                   ENDIF                                                                CSW207
 
      ** Validate Prime A/c Holder.
 
     C                   EXSR      SRVPAHo
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGrpVal - Handles group validation.                         *
      *                                                               *
      *****************************************************************
     C     SRGrpVal      BEGSR
 
      ** Group check Investment Proportion.
 
     C                   IF        PValMode <> '*SVIPG'
     C                   EXSR      SRVInvG
     C                   ENDIF
 
      ** Group check Joint A/c Holder.
 
     C                   IF        PValMode <> '*SVJAG'
     C                   EXSR      SRVJAMG
     C                   ENDIF
 
      ** Group check Prime A/c Holder for Tax.
 
     C                   IF        PValMode <> '*SVPTG'
     C                   IF        (CGL031 = 'Y' AND CGL032 = 'Y') OR                       AR916535
     C                             PrivBank = 'Y'                                           AR916535
     C                   EXSR      SRVPHTG
     C                   ENDIF                                                              AR916535
     C                   ENDIF
 
      ** Group check Prime A/c Holder.                                                        232543
                                                                                              232543
     C                   IF        PValMode <> '*SVPHG'                                       232543
     C                   EXSR      SRVPHOG                                                    232543
     C                   ENDIF                                                                232543
                                                                                              232543
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCust - Validates Customer Number.                         *
      *                                                               *
      *****************************************************************
     C     SRVCust       BEGSR
 
     C                   EXSR      SRResErA
 
     C                   CALLB     'SDVCUSM01'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      DDJANO        PDJANO
     C     DDCUST        PARM      DDCUST        PDCUST
     C                   PARM      DDACTN        PDACTN                                     BUG23732
     C                   PARM                    CER048                                     BUG23732
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKCUST
 
     C                   IF        CER048 = 'Y' AND                                         BUG23732
     C                             OKCUST = 'S'                                             BUG23732
     C                   EVAL      WActn = DDACTN                                           BUG23732
     C                   EVAL      DDACTN = 'I'                                             BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   IF        DDACTN <> 'I'
     C                   EXSR      SREtoW
     C                   ENDIF
      *                                                                                     BUG23732
     C                   IF        CER048 = 'Y' AND                                         BUG23732
     C                             OKCUST = 'S'                                             BUG23732
     C                   EVAL      OKCUST = 'N'                                             BUG23732
     C                   EVAL      DDACTN = WActn                                           BUG23732
     C                   ENDIF                                                              BUG23732
 
     C                   EXSR      SRUpdErA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVNAHo - Validates Non-a/c Holder.                          *
      *                                                               *
      *****************************************************************
     C     SRVNAHo       BEGSR
 
     C                   EXSR      SRResErA
 
     C                   CALLB     'SDVNAHM01'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      DDJANO        PDJANO
     C**********         PARM      DDNAHO        PDNAHO                                       233207
     C     DDNAHO        PARM      DDNAHO        PDNAHO                                       233207
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKNAHO
 
     C                   IF        DDACTN <> 'I'
     C                   EXSR      SREtoW
     C                   ENDIF
 
     C                   EXSR      SRUpdErA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVJAMB - Crosschecks Customer Number & Non-a/c Holder.      *
      *                                                               *
      *****************************************************************
     C     SRVJAMB       BEGSR
 
     C                   EXSR      SRResErA
 
     C                   CALLB     'SDVJAMB01'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      DDCUST        PDCUST
     C                   PARM      DDNAHO        PDNAHO
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKCUST
     C                   PARM                    OKNAHO
 
     C                   IF        DDACTN <> 'I'
     C                   EXSR      SREtoW
     C                   ENDIF
 
     C                   EXSR      SRUpdErA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVInvP - Validates Investment Proportion.                   *
      *                                                               *
      *****************************************************************
     C     SRVInvP       BEGSR
 
     C                   EXSR      SRResErA
 
     C                   CALLB     'SDVINVP01'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      DDJANO        PDJANO
     C                   PARM      DDCUST        PDCUST
     C                   PARM      DDNAHO        PDNAHO
     C                   PARM      DDINVP        PDINVP
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKINVP
 
     C                   EXSR      SRUpdErA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPAHT - Validates Prime A/c Holder for Tax Purposes.       *
      *                                                               *
      *****************************************************************
     C     SRVPAHT       BEGSR
 
     C                   EXSR      SRResErA
 
     C                   CALLB     'SDVPAHT01'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      DDPAHT        PDPAHT
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKPAHT
 
     C                   EXSR      SRUpdErA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPAHo - Validates Prime A/c Holder.                        *
      *                                                               *
      *****************************************************************
     C     SRVPAHo       BEGSR
 
     C                   EXSR      SRResErA
 
     C                   CALLB     'SDVPAHO01'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      DDPAHO        PDPAHO
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKPAHO
 
     C                   EXSR      SRUpdErA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVJAMG - Group checks Joint A/c Holder.                     *
      *                                                               *
      *****************************************************************
     C     SRVJAMG       BEGSR
 
     C                   EXSR      SRResErA
 
     C                   CALLB     'SDVJAMG01'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      DDACTN        PDACTN
     C                   PARM                    PACUST
     C                   PARM                    PANAHO
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKCUST
     C                   PARM                    OKNAHO
 
     C                   EXSR      SRUpdErA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVInvG - Group checks Investment Proportion.                *
      *                                                               *
      *****************************************************************
     C     SRVInvG       BEGSR
 
     C                   EXSR      SRResErA
 
     C                   CALLB     'SDVINVG01'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      DDJANO        PDJANO
     C                   PARM                    PACUST
     C                   PARM                    PANAHO
     C                   PARM                    PAINVP
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKINVP
 
     C                   EXSR      SRUpdErA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPHTG - Group checks Prime A/c Holder for Tax.             *
      *                                                               *
      *****************************************************************
     C     SRVPHTG       BEGSR
 
     C                   EXSR      SRResErA
 
     C                   CALLB     'SDVPHTG01'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      DDJANO        PDJANO
     C                   PARM                    PACUST
     C                   PARM                    PANAHO
     C                   PARM                    PAPAHT
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKPAHT
 
     C                   EXSR      SRUpdErA
 
     C                   ENDSR
      *****************************************************************                       232543
      /EJECT                                                                                  232543
      *****************************************************************                       232543
      *                                                               *                       232543
      *  SRVPHOG - Group checks Prime A/c Holder.                     *                       232543
      *                                                               *                       232543
      *****************************************************************                       232543
     C     SRVPHOG       BEGSR                                                                232543
                                                                                              232543
     C                   EXSR      SRResErA                                                   232543
                                                                                              232543
     C                   CALLB     'SDVPHOG01'                                                232543
     C                   PARM      *BLANKS       PRetCode                                     232543
     C                   PARM      DDJANO        PDJANO                                       232543
     C                   PARM                    PACUST                                       232543
     C                   PARM                    PANAHO                                       232543
     C                   PARM                    PAPAHO                                       232543
     C                   PARM                    FldNamXAr                                    232543
     C                   PARM                    MsgIDXAr                                     232543
     C                   PARM                    MsgDtaXAr                                    232543
     C                   PARM                    OKPAHO                                       232543
                                                                                              232543
     C                   EXSR      SRUpdErA                                                   232543
                                                                                              232543
     C                   ENDSR                                                                232543
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResErA - Resets error arrays.                              *
      *                                                               *
      *****************************************************************
     C     SRResErA      BEGSR
 
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdErA - Updates error arrays.                             *
      *                                                               *
      *****************************************************************
     C     SRUpdErA      BEGSR
 
      ** Update Error Fields/Message IDs/Message Data (arrays).
 
     C                   EVAL      WI = %LOOKUP(' ':FldNameArr:1)
 
     C                   IF        WI <> *ZERO
     C                   MOVEA     FldNamXAr     FldNameArr(WI)
     C                   MOVEA     MsgIDXAr      MsgIdArr(WI)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(WI)
     C                   ENDIF
 
     C                   EVAL      WI = %LOOKUP(' ':FldNameArr:1)
     C                   EVAL      Ix = WI - 1
 
      ** Update Warning Fields/Message IDs/Message Data (arrays).
 
     C                   EVAL      WI = %LOOKUP(' ':FldNameArr:1)
 
     C                   IF        WI <> *ZERO
     C                   MOVEA     WFldNmXAr     WFldNamArr(WI)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(WI)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(WI)
     C                   ENDIF
 
     C                   EVAL      WI = %LOOKUP(' ':WFldNamArr:1)
     C                   EVAL      WIx = WI - 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREtoW - Converts error messages to warning messages.        *
      *                                                               *
      *****************************************************************
     C     SREtoW        BEGSR
 
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
 
     C                   MOVEA     FldNamXAr     WFldNmXAr
     C                   MOVEA     MsgIDXAr      WMsgIDXAr
     C                   MOVEA     MsgDtaXAr     WMsgDtXAr
 
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Response Mode
     C                   PARM                    PResMode
 
      ** Validate Mode
     C                   PARM                    PValMode
 
      ** Joint A/c Member Details - Screen Format
     C                   PARM                    JAcMScrFmt
 
      ** Customer Number Array
     C                   PARM                    PACUST
 
      ** Non-a/c Holder Array
     C                   PARM                    PANAHO
 
      ** Investment Proportion Array
     C                   PARM                    PAINVP
 
      ** Prime A/c Holder Array                                                               232543
     C                   PARM                    PAPAHO                                       232543
                                                                                              232543
      ** Prime A/c Holder for Tax Array
     C                   PARM                    PAPAHT
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** OK - Action Code
     C                   PARM                    OKACTN
 
      ** OK - Joint A/c Member Details
     C                   PARM                    OKJAcMDets
 
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array Index (3P0) From/To Caller
     C                   PARM                    Ix
 
      ** Warning Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array Index (3P0) From/To Caller
     C                   PARM                    WIx
 
      ** Valid Joint A/c Member Details Layout From/To Caller
     C                   PARM                    ValidJAcM
      ** Check CGL031 feature                                                                 CSW207
     C                   Call      'AOSARDR0'                                                 CSW207
     C                   Parm      *Blanks       PRtCd                                        CSW207
     C                   Parm      '*VERIFY'     POptn                                        CSW207
     C                   Parm      'CGL031'      PSARD                                        CSW207
     C                   Parm                    DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS AND                                       CSW207
     C                             PRtCd <> '*NRF   '                                         CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'CGL031'                                          CSW207
     C                   EVAL      DBKey = POptn                                              CSW207
     C                   EVAL      DBase = 1                                                  CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ELSE                                                                 CSW207
     C                   IF        PRtCd = '*NRF   '                                          CSW207
     C                   EVAL      CGL031 = 'N'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CGL031 = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
      ** Check CGL032 feature                                                                 CSW207
     C                   Call      'AOSARDR0'                                                 CSW207
     C                   Parm      *Blanks       PRtCd                                        CSW207
     C                   Parm      '*VERIFY'     POptn                                        CSW207
     C                   Parm      'CGL032'      PSARD                                        CSW207
     C                   Parm                    DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS AND                                       CSW207
     C                             PRtCd <> '*NRF   '                                         CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'CGL032'                                          CSW207
     C                   EVAL      DBKey = POptn                                              CSW207
     C                   EVAL      DBase = 2                                                  CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ELSE                                                                 CSW207
     C                   IF        PRtCd = '*NRF   '                                          CSW207
     C                   EVAL      CGL032 = 'N'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CGL032 = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
      ** Check if Private Banking Module is available                                         CSW207
     C                   Call      'AOMMODR0'                                                 CSW207
     C                   Parm      *Blanks       PRtCd                                        CSW207
     C                   Parm      '*FIRST'      POptn                                        CSW207
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS                                           CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'SDMMODPD'                                        CSW207
     C                   EVAL      DBKey = POptn                                              CSW207
     C                   EVAL      DBase = 3                                                  CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ENDIF                                                                CSW207
     C                   IF        BGN4ST = 'Y'                                               CSW207
     C                   EVAL      PrivBank = 'Y'                                             CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      *                                                                                     BUG23732
      ** Check if CER048 is enabled.                                                        BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOSARDR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*VERIFY'     POptn                                      BUG23732
     C                   PARM      'CER048'      PSard                                      BUG23732
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23732
      *                                                                                     BUG23732
     C                   EVAL      CER048 = 'N'                                             BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd = *BLANKS                                          BUG23732
      *                                                                                     BUG23732
     C                   EVAL      CER048 = 'Y'                                             BUG23732
      *                                                                                     BUG23732
     C                   ELSE                                                               BUG23732
      *                                                                                     BUG23732
     C                   IF        (PRtcd <> *BLANKS) AND                                   BUG23732
     C                             (PRtcd <> '*NRF   ')                                     BUG23732
      *                                                                                     BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG23732
     C                   EVAL      DBKEY = 'CER048'                                         BUG23732
     C                   EVAL      DBASE = 111                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** ILE RPG Program Status Subroutine
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
