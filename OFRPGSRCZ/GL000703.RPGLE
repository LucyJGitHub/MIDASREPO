     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas OF Send Forecast Individ. Msg to JMS')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger module                                *
      *                                                               *
      *  GL000703 - Midas OF Automatic Update/Create Indivdidual      *
      *             Forecast - JAVA API Forecast                      *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 27Jul20               *
      *  Prev Amend No. CSD101             Date 07Dec18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD033895           Date 09Jun14               *
      *                 MD027428           Date 09Jun14               *
      *                 MD027243           Date 29May14               *
      *                 MD025783           Date 19May14               *
      *                 MD025967           Date 24Apr14               *
      *                 MD026339           Date 24Apr14               *
      *                 MD024878B          Date 17Mar14               *
      *                 MD025204           Date 20Feb14               *
      *                 MD024362           Date 14Jan14               *
      *                 MD023712 *CREATE   Date 30Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD055451.                             *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033895 - Correct parameters for UT000033.                  *
      *  MD027428 - Forecast update error. Actual amount of the Total *
      *             forecast should not update if there is an update  *
      *             in the individual forecast. (Recompile)           *
      *  MD027243 - Printer Overflow Issue in GL009562P1. (Recompile) *
      *   MD025783 - FORI and SBJB message structure enhancement.     *
      *   MD025967 - Recompile due to changes in GL009562.            *
      *   MD026339 - Recompile due to changes in GL009562.            *
      *  MD024878B - Additional validation for blank Source Customer  *
      *              Note that for some reasons, this module          *
      *              needs to be recompiled in order for the end to   *
      *              end test to work during PS UAT. (Recompile)      *
      *  MD025204 - Rename new system values to start with 'Forecast' *
      *  MD024362 - Subsidiaries Daily Sweeping Forecasts             *
      *             Amendment of GLFORITD and GLFORTTD does not work  *
      *             Missing coding records since last version         *
      *  MD023712 - Subsidiaries Daily Sweeping Forecasts             *
      *             Update of Actual Amounts against Forecasts        *
      *             from the Accounting Rules Process                 *
      *                                                               *
      *****************************************************************
      *
      ** Midas SD Nostro details retrieval
     FSDNOSTL4  IF   E           K DISK
      *
      ** Midas GP Zone File
     FGPZONEL0  IF   E           K DISK
      *
      *****************************************************************
      * Bank Details
     D DsBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * General ledger ICD
     D DsGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)
      *
      * Forecast Individual details
     D DsFORI        E DS                  EXTNAME(GLFORITD)
      *
      * Account details
     D DsACCN        E DS                  EXTNAME(ACCNTAB)
      *
      * Account Code details
     D DsACOD        E DS                  EXTNAME(SDACODPD) PREFIX(A)
      *
      * Nostro Code details
     D DsNOSC        E DS                  EXTNAME(SDNOSTPD) PREFIX(N)

      * Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      * Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Local data Area
     D LDA           E DS                  EXTNAME(LDA) DTAARA
      ** SD data area                                                                         CSD101
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD101
      *
      * Front Office transaction ID
     D                 DS
     D   FOType                6      9A
     D   FOMidasDate          10     14A
     D   FOTimeStamp           1     26A
     D   FOTransId             6     25A
      *
      * Entry's parameters
     D P_RtrnCode      S              7A                                        Return Code
     D P_Option        S              7A                                        Option
     D P_Action        S              1A                                        Action Code
     D P_Customer      S                   LIKE(CNUM)                           Customer No.
     D P_CustSourcAcc  S             34A                                        Customer Source A/C
     D P_Currency      S                   LIKE(CCY)                            Currency
     D P_NostroCode    S              2A                                        Nostro Code
     D P_Date          S              5P 0                                      Event Date
     D P_SequenNbr     S              2P 0                                      Sequence number
     D P_FullGLAcc     S             24A                                        Full Gl Account Nbr
     D P_Operatype     S             20A                                        Operation Type
     D P_RetlAcNo      S             10S 0                                      Retail Account
     D P_Amount        S             15S 0                                      Forecast Amount
     D P_ActualAmnt    S             15S 0                                      Forecast Actual Amnt
     D P_Reference     S             30A                                        Forecast Reference
     D****P_Narrative     S             10A                            Forecast Narrative   MD024362
     D P_Narrative     S             30A                                        Narrative   MD024362
     D P_FrontOffId    S             20A                                        Forecast FrontOffId
     D P_Zone          S             10A                                        Forecast Zone
     D P_ActualIsZero  S              1A                                        Forec.Actual is Zero
      *
      * Access objects parameters
      *
     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option
     D P@RETL          S                   LIKE(IFACNO)                         Retail Account
     D P@CNUM          S                   LIKE(IFCUST)                         Customer
     D P@CUCD          S                   LIKE(IFCCY)                          Currency
      *
     D KAccount        DS
     D P@FACN                  1     24                                         Full GL Account
     D  DDBRCA                 1      3                                         Branch
     D  DDCNUM                 4      9                                         Customer
     D  DDCUCD                10     12                                         Currency
     D  DDACOD                13     22  0                                      Account Code
     D  DDACSQ                23     24  0                                      Account Sequence
      *
     D P@ACCD          S                   LIKE(ACOD)                           Account Code
     D P@ACSQ          S                   LIKE(ACSQ)                           Account Sequence
     D P@BRCA          S                   LIKE(BRCA)                           Branch
     D P@OP01          S             20A
     D P@VL01          S            200A
     D P@OP02          S             20A
     D P@VL02          S            200A
     D P@OP03          S             20A
     D P@VL03          S            200A
     D P@OP04          S             20A
     D P@VL04          S            200A
     D P@OP05          S             20A
     D P@VL05          S            200A
     D P@OP06          S             20A
     D P@VL06          S            200A
     D P@OP07          S             20A
     D P@VL07          S            200A
     D P@OP08          S             20A
     D P@VL08          S            200A
     D P@OP09          S             20A
     D P@VL09          S            200A
     D P@OP10          S             20A
     D P@VL10          S            200A
     D P@ACTN          S              1A                                        Action
     D P@VLIS          S             10A                                        Valid List
     D P@VLIB          S             10A                                        Valib List Library
     D P@USER          S            256A                                        User ID
     D P@PWD1          S            256A                                        Password 1
     D P@PWD2          S            256A                                        Password 1
     D P@DESC          S             50A                                        Description
     D P@GELR          S                   LIKE(DsGELR)                         General Ledger ICD
      *
     D PMode           S             10A
     D PAPIName        S            100A
     D Pformat         S            100A
     D PfldTag         S            300A
     D PfldData        S           1000A
     D WAmount         S             15  0
     D PfldType        S             10A
     D PfldAttr        S             10A
      *
     D PRequest        S             10A
     D PQueueNm        S             48A
     D PMsgBuf         S          32000A
     D PMQMgr          S             48A
      *
     D**  DATA STRUCTURE FOR SR. ZDATE9 - FIELD IS @@VDT
     D                 DS
     D  @@VDT                  1      8  0
     D  @@YR                   1      4  0
     D  @@Z71M                 5      6  0
     D  @@Z71D                 7      8  0
      *
     D  IFDDS          DS
     D  @@YRF                  1      4
     D  TRUN1                  5      5
     D  @@MMF                  6      7
     D  TRUN2                  8      8
     D  @@DDF                  9     10
      *
     D ZCCY            S                   LIKE(IFCCY)                          Currency
     D ZFREQ           S              1A                                        Frequency
     D ZLOC            S                   LIKE(BJSLCD)                         Location
     D ZMDAY           S              2  0                                      Frequency day
      *
     D WkTransQueue    S             48A                                        MQ Trans Sdr Queue
     D WkRespQ         S             20A                                        MQ JMS ResponseQueue
     D WkMQMgr         S             48A                                        MQ Queue Mgr
     D WkValLstLoc     S             10A                                        Valib List Library
     D WkUserId        S             10A                                        User Id
     D***WkPassWord      S             10A                                           Password CSD101
     D WkPassWord      S            128A                                                      CSD101
     D WkTimeStamp     S               Z                                        TimeStamp
      *
      ** Validation List Parameter
     D PRtnCode        S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D***PUserName**   S            256A                                                    MD033895
     D***PPassword1*   S            256A                                                    MD033895
     D***PPassword2*   S            256A                                                    MD033895
     D***PDescrptn**   S             50A                                                    MD033895
     D PUserName       S            100A                                                    MD033895
     D***PPassword1      S            600A                                           MD033895 CSD101
     D PPassword1      S            128A                                                      CSD101
     D***PPassword2      S            600A                                           MD033895 CSD101
     D PDescrptn       S           1000A                                                    MD033895
     D WRETCD          S              7
      *
     D Recursive       S              1
      *
      /EJECT
      ** Test data used as input
     D*Data            S             60    DIM(3) CTData
     D Buffer          S          32000A
     D pInBuffer       S               *
     D pOutBuffer      S               *
     D nInLen          S             10I 0
     D nOutLen         S             10i 0
     D AddrBufferZ     S               *

      ** Buffer length
     D*BufferLength    S             10I 0 INZ(%LEN(Data))
     D BufferLength    S             10I 0 INZ(%LEN(PMsgBuf))

      ** Connection Handle
     D HConn           S             10I 0

      ** Options
     D Options         S             10I 0

      ** Object handle
     D HObj            S             10I 0

      ** Completion codes
     D OpenCode        S             10I 0
     D CompletionCode  S             10I 0

      ** Reasons
     D Reason          S             10I 0
     D ConnReason      S             10I 0

      ** Loop Counter
     D I               S             10I 0 INZ(1)

      /copy qmqm/qrpglesrc,cmqg

     D mqod            ds                  Qualified
      /copy qmqm/qrpglesrc,cmqodg

     D mqmd            ds                  Qualified
      /copy qmqm/qrpglesrc,cmqmdg

     D mqgmo           ds                  Qualified
      /copy qmqm/qrpglesrc,cmqgmog

     D mqpmo           ds                  Qualified
      /copy qmqm/qrpglesrc,cmqpmog

     D mqtmc           ds                  Qualified
      /copy qmqm/qrpglesrc,cmqtmc2r

     D mqrfh2          ds                  Qualified
      /copy qmqm/qrpglesrc,cmqrfh2g

      * Must define NameValueLength/NameValueData pairs as there may
      * be any number of pairs per RFH2 header. Here we define 2:
      * one for usr.x properties and one for mcd.x properties. You
      * cannot define properties from different folders in the same
      * NameValueData field - each must have its own. To set jms.x
      * properties, you must add another RF2NVLx/RF2NVDx field here.

      * using UCS2 data directly in RPG
      * Length of user data field
     D RF2NVL                        10I 0 Inz(%Size(mqrfh2.RF2NVD))
      ** HF: length is now 512

      * Value of user data field
     D RF2NVD                       256C   Ccsid(13488)

      ** Optional parameters
     D Qmgr            S             48A

      ** Output fields
     D Status          S              5A
     D MQCall          S              7A
     D ReasonCode      S              4A
     D Message         S             50A
      /EJECT
      *****************************************************************
      *                                                               *
      ** Main                                                         *
      *                                                               *
      *****************************************************************
      *
      ** Clear Return Code
      *
     C                   EVAL      P_RtrnCode = *Blanks                         Return Code
      *
      ** Release resource
      ** ----------------
      *
     C                   IF        P_Option     = '*CLOSE ' AND                  Option
     C                             P_Action     = *Blanks   AND                  Action Code
     C                             P_Customer   = *Blanks   AND                  Customer Number
     C                             P_CustSourcAcc = *Blanks AND                  Customer Source A/C
     C                             P_Operatype  = *Blanks   AND                  Operation Type
     C                             P_Date       = *Zeros    AND                  Forecast Event Date
     C                             P_FullGLAcc  = *Blanks   AND                  Full GL Account nbr
     C                             P_Currency   = *Blanks   AND                  Currency Code
     C                             P_NostroCode = *Blanks   AND                  Nostro Code
     C                             P_RetlAcNo   = *Zeros    AND                  Retail Account Nb
     C                             P_Amount     = *Zeros    AND                  Amount
     C                             P_ActualAmnt = *Zeros    AND                  Actual Amount
     C                             P_Reference  = *Blanks   AND                  Reference
     C                             P_Narrative  = *Blanks                        Narrative
      *
     C                   GOTO      END
     C                   ENDIF
      *
      ** Load Forecast Individual Details
      ** --------------------------------
      *
     C                   EVAL      IFCUST = P_Customer                          Customer
     C                   EVAL      IFCSAC = P_CustSourcAcc                      Customer Source A/C
     C                   EVAL      IFCCY  = P_Currency                          Currency
     C                   EVAL      IFNOSC = P_NostroCode                        Nostro Code
     C                   EVAL      IFDATE = P_Date                              Forecast Event Date
     C                   EVAL      IFOPTY = P_Operatype                         Operation Type
      *
      ** - Forecast Sequence
      *
     C                   IF        P_SequenNbr <> *Zeros
     C                   MOVE      P_SequenNbr   IFSEQN                          Sequence Number
     C                   ELSE
     C                   EVAL      IFSEQN  = 1                                   Sequence Number
     C                   ENDIF
      *
      ** Load account details
      ** --------------------
      *
      ** - Full GL Account number
      *
     C*******************IF        P_FullGLAcc <> *Zeros                                    MD024362
     C                   IF        P_FullGLAcc <> *Blanks                                   MD024362
     C                   MOVE      P_FullGLAcc   P@FACN                         Full GL Account Nb
     C*******************ELSE                                                               MD024362
     C*******************EVAL      IFFACN  = *blanks                                        MD024362
     C*******************ENDIF                                                              MD024362
      *
     C                   Move      DDBRCA        P_Brch            3             Branch
     C                   Move      DDCNUM        P_Cust            6             Customer
     C                   Move      DDCUCD        P_Ccy             3             Currency
      *
      ** - Account Code
      *
     C                   MOVE      DDACOD        P_AccntCode      10 0           Account Code
     C                   IF        P_AccntCode <> *Zeros
     C                   MOVE      DDACOD        P_AccntCode      10 0           Account Code
     C                   ELSE
     C                   Z-ADD     0             DDACOD                         Account Sequence
     C                   ENDIF
      *
      ** - Account Sequence
      *
     C                   MOVE      DDACSQ        P_AccntSeq        2 0           Account Sequence
     C                   IF        P_AccntSeq <> *Zeros
     C                   MOVE      DDACSQ        P_AccntSeq        2 0           Account Sequence
     C                   ELSE
     C                   Z-ADD     0             DDACSQ                         Account Sequence
     C                   ENDIF
      *
     C                   ELSE                                                               MD024362
     C                   EVAL      IFFACN  = *blanks                                        MD024362
     C                   ENDIF                                                              MD024362
      *                                                                                     MD024362
      ** - Retail Account
      *
     C                   IF        P_RetlAcNo <> *Zeros
     C                   MOVE      P_RetlAcNo    IFACNO                         Retail Account
     C                   ELSE
     C                   EVAL      IFACNO = 0
     C                   ENDIF
      *
      ** Check account
      ** -------------
      *
      ** - Check if the account exists.
      *
     C                   IF        P_FullGLAcc <> *Blanks                                   MD024362
     C*******************CALL      'AOACCTR0'                                               MD024362
     C                   CALLB     'AOACCTR0'                                               MD024362
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      IFACNO        P@RETL                         Retail Account
     C                   PARM      DDCNUM        P@CNUM                         Customer
     C                   PARM      DDCUCD        P@CUCD                         Currency
     C                   PARM      DDACOD        P@ACCD                         Account Code
     C                   PARM      DDACSQ        P@ACSQ                         Account Sequence
     C                   PARM      DDBRCA        P@BRCA                         Branch
     C*****DsACCN        PARM      *Blanks       DSSDY                                      MD024362
     C     DsACCN        PARM      DsACCN        DSSDY                                      MD024362
      *
     C*******************MOVE      CCY           P@CUCD                         account ccy MD024362
      *
     C                   IF        P@RTCD <> *Blanks
     C                   EVAL      P_RtrnCode = '*ERROR'                        Return Code
     C                   ENDIF
      *
      ** - Check and retrieve Account number
      *
     C     ACNO          IFNE      0
     C                   MOVE      ACNO          IFACNO                         Retail Account
     C                   END
      *
      ** Retrieve account code details.
      *
     C     ACOD          IFNE      0                                                        MD024362
     C                   CALL      'AOACODR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      ACOD          P@ACCD
     C     DsACOD        PARM      *Blanks       DSSDY
      *
      ** If NOT General Ledger Account code,
      *
     C                   IF        P@RTCD  = *Blanks  OR
     C                             AA5ACTY ='R'
     C                   EVAL      IFACNO     =  ACNO
     C*******************ENDIF                                                              MD024362
     C                   END                                                                MD024362
     C                   END                                                                MD024362
     C                   END                                                                MD024362
      *
      ** Retrieve Nostro Code details.
      *
     C     P_NostroCode  IFNE      *blanks
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      *BLANKS       @CUST             6
     C                   PARM      IFCCY         P@CCY             3
     C                   PARM      *BLANKS       @ACCD            10
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM      IFNOSC        P@NOSC            3
     C                   PARM      *BLANKS       @BRCA             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     DsNOSC        PARM      *Blanks       DSSDY
      *
      ** If NOT Nostro Code,
      *
     C*******************IF        P@RTCD  <> *Blanks OR                                    MD024362
     C*****************************AA5TOIN =  'Y'     OR                                    MD024362
     C*****************************AA5ACTY <> 'N'                                           MD024362
     C                   IF        P@RTCD  <> *Blanks                                       MD024362
     C                   EVAL      P_RtrnCode = '*ERROR'                        Return Code
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If account type is Nostro find back the nostro code and ccy code
      *
     C     P_NostroCode  IFEQ      *blanks
     C     AA5ACTY       ANDEQ     'N'
      *
      ** Find the nostro number on SDNOSTL4 and get the customer name
      ** and town.
      *
     C                   MOVE      CNUM          A7CUST
     C                   MOVE      CCY           A7CYCD
     C                   MOVE      ACOD          A7ACCD
     C                   MOVE      ACSQ          A7ACSN
     C                   MOVE      BRCA          A7BRCD
      *
     C     WRKKEY        CHAIN     SDNOSTL4                           10
      *
     C     *IN10         IFEQ      '0'
     C                   MOVE      A7CYCD        IFCCY
     C                   MOVE      A7NONB        IFNOSC
     C                   END
      *
     C                   ENDIF
      *                                                                                     MD024362
     C     DDCUCD        IFNE      *BLANKS                                                  MD024362
     C                   MOVE      DDCUCD        P@CUCD                                     MD024362
     C                   ELSE                                                               MD024362
     C                   MOVE      IFCCY         P@CUCD                                     MD024362
     C                   END                                                                MD024362
      *
      ** Establish the connection to the MQ
      *
     C                   EXSR      SRMQConnect
      *
      ** Build the Message Header
      *
     C                   EXSR      SRBldMsgHeader
      *
      ** Build the Message Body
      *
     C                   EXSR      SRBldMsgBody
      *
      ** Open the connection to the MQ
      *
     C                   EXSR      SRMQOpen
      *
      ** Send the message to the MQ
      *
     C                   EXSR      SRMQPutMessage
     C*******************DUMP                                                               MD024362
      *
      ** Close the connection to the MQ
      *
     C                   EXSR      SRMQClose
      *
      ** Disconnect from the MQ
      *
     C                   EXSR      SRMQDisconnect
      *
     C     END           TAG
      *
      ** Release resources
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMQConnect - Establish the connection to the MQ              *
      *                                                               *
      *****************************************************************
     C     SRMQConnect   BEGSR
      *
      ** Establish the connection to the message queue
      *
     C**********         CALL      'MQCONN'                                                 MD041126
     C**********         PARM                    PMQMgr                                     MD041126
     C**********         PARM                    HConn                                      MD041126
     C**********         PARM                    CompletionCode                             MD041126
     C**********         PARM                    ConnReason                                 MD041126
     C                   CALLP     MQCONN( PMQMgr : HConn :                                 MD041126
     C                                     CompletionCode :                                 MD041126
     C                                     ConnReason )                                     MD041126

     C                   If        CompletionCode = CCFAIL
     C                   ExSr      *PSSR
     C                   EndIf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMQOpen - Open the connection to the MQ                      *
      *                                                               *
      *****************************************************************
     C     SRMQOpen      BEGSR
      *
      ** Open the connection to the message queue
      *
     C                   EVAL      MQOD.ODON = PQueueNm
     C                   EVAL      Options = OOOUT + OOFIQ
     C**********         CALL      'MQOPEN'                                                 MD041126
     C**********         PARM                    HConn                                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM                    Options                                    MD041126
     C**********         PARM                    HObj                                       MD041126
     C**********         PARM                    OpenCode                                   MD041126
     C**********         PARM                    Reason                                     MD041126
     C                   CALLP     MQOPEN( HConn : MQOD : Options :                         MD041126
     C                                     HObj : OpenCode : Reason )                       MD041126

     C                   If        OpenCode = CCFAIL
     C                   ExSr      *PSSR
     C                   EndIf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMQClose - Close the connection to the MQ                    *
      *                                                               *
      *****************************************************************
     C     SRMQClose     BEGSR
      *
      ** Close the opened queue
      *
     C                   If        OpenCode <> CCFAIL
     C                   EVAL      Options = CONONE
     C**********         CALL      'MQCLOSE'                                                MD041126
     C**********         PARM                    HConn                                      MD041126
     C**********         PARM                    HObj                                       MD041126
     C**********         PARM                    Options                                    MD041126
     C**********         PARM                    CompletionCode                             MD041126
     C**********         PARM                    Reason                                     MD041126
     C                   CALLP     MQCLOSE( HConn : HObj : Options :                        MD041126
     C                                      CompletionCode : Reason )                       MD041126
     C
     C                   If        Reason <> RCNONE
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMQDisconnect - Disconnect from the MQ                       *
      *                                                               *
      *****************************************************************
     C     SRMQDisconnectBEGSR
      *
      ** Disconnect from the message queue manager
      *
     C                   If        ConnReason <> RC2002
     C**********         CALL      'MQDISC'                                                 MD041126
     C**********         PARM                    HConn                                      MD041126
     C**********         PARM                    CompletionCode                             MD041126
     C**********         PARM                    Reason                                     MD041126
     C                   CALLP     MQDISC( HConn : CompletionCode :                         MD041126
     C                                     Reason )                                         MD041126
     C                   If        CompletionCode = CCFAIL
     C                   ExSr      *PSSR
     C                   EndIf
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMQPutMessage - Put the message to the MQ                    *
      *                                                               *
      *****************************************************************
     C     SRMQPutMessageBEGSR
      *
      ** Put the messages to the message queue
      *
     C                   EVAL      CompletionCode = OpenCode
     C                   EVAL      MQMD.MDFMT = FMRFH2

     C                   If        CompletionCode <> CCFAIL
     C                             AND PMsgBuf <> *Blanks
     C
     C                   EVAL      Buffer = MQRFH2 + %TRIMR(PMsgBuf)
     C                   EVAL      BufferLength = MQRFH2.RF2LEN
     C                                          + %LEN(%TRIMR(PMsgBuf))
     C
      /free
              MQPUT(HConn : HObj : MQMD : MQPMO : BufferLength : %ADDR(Buffer) :
                    CompletionCode : Reason);
      /end-free
      *
     C
     C                   If        Reason <> RCNONE
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldMsgHeader - Build the Message Header                     *
      *                                                               *
      *****************************************************************
     C     SRBldMsgHeaderBEGSR
      *
     C                   EVAL      MQRFH2.RF2NVC = 13488
                                                                                            MD025783
      ** - Zone                                                                             MD025783
      *                                                                                     MD025783
     C                   MOVE      *BLANKS       WZONE                                      MD025783
     C     P_Zone        CHAIN     GPZONEL0                                                 MD025783
     C                   IF        %Found                                                   MD025783
     C                   MOVE      ZOMSYS        WZONE                                      MD025783
     C                   ENDIF                                                              MD025783
      *
     C     P_Action      IFEQ      'I'                                                      MD024362
     C                   EVAL      Buffer = '<usr><ServiceName>FORI_CREATE'+
     C**********                            '</ServiceName></usr>'                          MD025783
     C                                       '</ServiceName><zone>' +                       MD025783
     C                                        WZONE + '</zone></usr>'                       MD025783
     C                   ELSE                                                               MD024362
     C                   EVAL      Buffer = '<usr><ServiceName>FORI_UPDATE'+                MD024362
     C**********                            '</ServiceName></usr>'                 MD024362 MD025783
     C                                      '</ServiceName><zone>' +                        MD025783
     C                                       WZONE + '</zone></usr>'                        MD025783
     C                   END                                                                MD024362
                                                                                            MD024362
     C                   EVAL      MQRFH2.RF2NVD = %UCS2(Buffer)
     C                   EVAL      MQRFH2.RF2NVL = %Size(MQRFH2.RF2NVD)
      *
     C                   EVAL      MQRFH2.RF2LEN = %Size(MQRFH2)
     C                   EVAL      MQRFH2.RF2FMT = FMSTR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldMsgBody - Build the WIP message                          *
      *                                                               *
      *****************************************************************
     C     SRBldMsgBody  BEGSR
      *
      ** ----------------------------
      ** Build JMS Strongly Typed API
      ** ----------------------------
      *

     C                   EVAL      PMode    = '*CLEAR'
     C                   EXSR      SRFmtWMsg
      *
      ** - Action
      *
     C     P_Action      IFEQ      'I'
     C                   EVAL      PMode    = '*ENTER'
     C                   EVAL      PAPIName = 'FORI_CREATE'                                 MD024362
     C                   ELSE
     C                   EVAL      PMode    = '*UPDATE'
     C                   EVAL      PAPIName = 'FORI_UPDATE'                                 MD024362
     C                   END

      ** - xml version
      *
     C                   EVAL      PFldTag = '?xml version="1.0"' +
     C                             ' encoding="UTF-8" ?'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg

      ** - bf: JMSMessageData
      *
     C                   EVAL      PFldTag = 'bf:JMSMessageData xmlns:bf="' +
     C                             'http://www.misys.com/Bankfusion' +
     C                             '/Attributes"'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg

      ** - msgDAta
     C     P_Action      IFEQ      'I'                                                      MD024362
     C                   EVAL      PFldTag = 'for:msgData xsi:type="' +
     C**********                   'for:createForecastRequest" ' +                          MD025783
     C                             'for:createForecastRqType" ' +                           MD025783
     C                             'xmlns:for="http://www.misys.' +
     C**********                   'com/midas/bfmidas/attributes/' +                        MD025783
     C**********                   'forecastmanagement" xmlns:xsi="' +                      MD025783
     C                             'com/midas/bfmidas/attrib/foriV1" ' +                    MD025783
     C                             'xmlns:core="http://www.misys.' +                        MD025783
     C                             'com/midas/bfmidas/attributes/core" ' +                  MD025783
     C                             'xmlns:xsi="' +                                          MD025783
     C                             'http://www.w3.org/2001/XMLSchema' +
     C                             '-instance"'
     C                   ELSE                                                               MD024362
     C                   EVAL      PFldTag = 'for:msgData xsi:type="' +                     MD024362
     C**********                   'for:updateForecastRequest" ' +                 MD024362 MD025783
     C                             'for:updateForecastRqType" ' +                           MD025783
     C                             'xmlns:for="http://www.misys.' +                         MD024362
     C**********                   'com/midas/bfmidas/attributes/' +               MD024362 MD025783
     C**********                   'forecastmanagement" xmlns:xsi="' +             MD024362 MD025783
     C                             'com/midas/bfmidas/attrib/foriV1" ' +                    MD025783
     C                             'xmlns:core="http://www.misys.' +                        MD025783
     C                             'com/midas/bfmidas/attributes/core" ' +                  MD025783
     C                             'xmlns:xsi="' +                                          MD025783
     C                             'http://www.w3.org/2001/XMLSchema' +                     MD024362
     C                             '-instance"'                                             MD024362
     C                   END                                                                MD024362
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** - Create Header Request
      *
     **********C     P_Action      IFEQ      'I'                                   MD024362 MD025783
     C**********         EVAL      PFldTag = 'for:createHeaderRequest xsi:type='            MD025783
     C**********                   + '"header:requestHeader" '+                             MD025783
     C                   EVAL      PFldTag = 'for:header xsi:type='                         MD025783
     C                             + '"header:requestHeaderType" '+                         MD025783
     C                             'xmlns:header="http://www.misys'
     C                             + '.com/midas/bfmidas/attributes/header"'
     C**********         ELSE                                                      MD024362 MD025783
     C**********         EVAL      PFldTag = 'for:updateHeaderRequest xsi:type='   MD024362 MD025783
     C**********                   + '"header:requestHeader" '+                    MD024362 MD025783
     C**********                   'xmlns:header="http://www.misys'                MD024362 MD025783
     C**********                   + '.com/midas/bfmidas/attributes/header"'       MD024362 MD025783
     C**********         END                                                       MD024362 MD025783
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ***-*Request*Message*Type**********                                                   MD025783
      *
     C**********         EVAL      PFldTag  = 'header:requestMessageType'                   MD025783
     C**********         EVAL      PFldType = *BLANK                                        MD025783
     C**********         EVAL      PFldAttr = *BLANK                                        MD025783
     C**********         EXSR      SRFmtWMsg                                                MD025783
      *
      ***-*Operation**********                                                              MD025783
      *
     C**********         EVAL      PFldTag  = 'header:operation'                            MD025783
     C**********         EVAL      PFldType = *BLANK                                        MD025783
     C**********         EVAL      PFldAttr = *BLANK                                        MD025783
     C**********         EXSR      SRFmtWMsg                                                MD025783
      *
      ***-*Response Queue**********                                                         MD025783
      *
     C**********         EVAL      PFldTag  = 'header:responseQueue'                        MD025783
     C**********         EVAL      PFldType = *BLANK                                        MD025783
     C**********         EVAL      PFldAttr = *BLANK                                        MD025783
     C**********         EXSR      SRFmtWMsg                                                MD025783
      *
      ** - autoAuthorise
      *
     C                   EVAL      PFldTag  = 'header:autoAuthorise'
     C                   EVAL      PFldData = 'true'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** - Front Office transaction ID
      *
      **   FORI + Midas run date + HHMMSS + mmmmm
      *
     C                   EVAL      WkTimeStamp = %TIMESTAMP
     C     *ISO0         MOVE(P)   WkTimeStamp   FOTimeStamp
     C                   MOVE      BJRDNB        FOMidasDate
     C                   EVAL      FOType      = 'FORI'
      *
     C                   EVAL      PFldTag  = 'header:frontOfficeTransactionID'
     C     P_FrontOffId  IFEQ      *BLANK
     C                   EVAL      PFldData = P_FrontOffId
     C                   ELSE
     C                   EVAL      PFldData = FOTransId
     C                   END
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ***-*Response*Required**********                                                      MD025783
      *
     C**********         EVAL      PFldTag  = 'header:responseRequired'                     MD025783
     C**********         EVAL      PFldData = 'false'                                       MD025783
     C**********         EVAL      PFldType = *BLANK                                        MD025783
     C**********         EVAL      PFldAttr = *BLANK                                        MD025783
     C**********         EXSR      SRFmtWMsg                                                MD025783
      *
      ** - Force Post
      *
     C                   EVAL      PFldTag  = 'header:forcePost'
     C                   EVAL      PFldData = 'false'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** - Source System
      *
     C                   EVAL      PFldTag  = 'header:sourceSystem'
     C                   EVAL      PFldData = 'MIDAS'
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ***-*Confirm*fo*Front*Office**********                                                MD025783
      *
     C**********         EVAL      PFldTag  = 'header:confirmToFrontOffice'                 MD025783
     C**********         EVAL      PFldData = 'N'                                           MD025783
     C**********         EVAL      PFldType = *Blanks                                       MD025783
     C**********         EVAL      PFldAttr = *Blanks                                       MD025783
     C**********         EXSR      SRFmtWMsg                                                MD025783
      *
      ** - Repair location
      *
     C                   EVAL      PFldTag  = 'header:repairLocation'
     C                   EVAL      PFldData = 'B'
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Zone
      *
     C                   MOVE      *BLANKS       WZONE             2
     C     P_Zone        CHAIN     GPZONEL0
     C                   IF        %Found
     C                   MOVE      ZOMSYS        WZONE
     C                   ENDIF
      *                                                                                     MD024362
     C                   EVAL      PFldTag  = 'header:zone'
     C                   EVAL      PFldData = WZONE
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Overridable Errors Collection
      *
     C                   EVAL      PFldTag ='header:overridableErrorsCollection'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** - Overridable Errors Collection
      *
     C                   EVAL      PFldTag='/header:overridableErrorsCollection'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** - /Create Header Request
      *
     C**********     P_Action      IFEQ      'I'                                   MD024362 MD025783
     C**********         EVAL      PFldTag  = '/for:createHeaderRequest'                    MD025783
     C                   EVAL      PFldTag  = '/for:header'                                 MD025783
     C**********         ELSE                                                      MD024362 MD025783
     C**********         EVAL      PFldTag  = '/for:updateHeaderRequest'           MD024362 MD025783
     C**********         END                                                       MD024362 MD025783
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** - Create Action code
      *
     C**********     P_Action      IFEQ      'I'                                            MD025783
     C**********         EVAL      PFldTag  = 'for:createActionCode'               MD024362 MD025783
                                                                                            MD025783
     C                   EVAL      PFldTag  = 'for:actionCode'                              MD025783
                                                                                            MD025783
     C     P_Action      IFEQ      'I'                                                      MD025783
     C                   EVAL      PFldData = 'I'
     C                   END
     C     P_Action      IFEQ      'A'
     C**********         EVAL      PFldTag  = 'for:updateActionCode'               MD024362 MD025783
     C                   EVAL      PFldData = 'A'
     C                   END
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ***-*Create*Request**********                                                         MD025783
      *
     C**********     P_Action      IFEQ      'I'                                   MD024362 MD025783
     C**********         EVAL      PFldTag  = 'for:createRequest'                           MD025783
     C**********         ELSE                                                      MD024362 MD025783
     C**********         EVAL      PFldTag  = 'for:updateRequest'                  MD024362 MD025783
     C**********         END                                                       MD024362 MD025783
     C**********         EVAL      PFldType = *BLANK                                        MD025783
     C**********         EVAL      PFldAttr = *BLANK                                        MD025783
     C**********         EXSR      SRFmtWMsg                                                MD025783
      *
      ** - ForecastKeysrequest
      *
     C**********         EVAL      PFldTag  = 'keys:forecastKeysRequest xsi' +              MD025783
     C**********                   ':type="keys:forecastKeysRequest"' +                     MD025783
     C**********                    ' xmlns:keys="http:' +                                  MD025783
     C**********                   '//www.misys.com/midas/bfmidas/attributes/' +            MD025783
     C**********                   'forecastmanagement"'                                    MD025783
     C                   EVAL      PFldTag  = 'for:forecastKeys xsi' +                      MD025783
     C                             ':type="for:forecastKeysType"' +                         MD025783
     C                              ' xmlns:for="http:' +                                   MD025783
     C                             '//www.misys.com/midas/bfmidas/attrib/' +                MD025783
     C                             'foriV1"'                                                MD025783
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** - Forecast Customer
      *
     C**********         EVAL      PFldTag  = 'keys:custKey'                                MD025783
                                                                                            MD025783
     C                   EVAL      PFldTag  = 'for:custKey xsi:type' +                      MD025783
     C                             '="core:custKeyType"'                                    MD025783
     C                   EVAL      PFldType = *BLANK                                        MD025783
     C                   EVAL      PFldAttr = *BLANK                                        MD025783
     C                   EXSR      SRFmtWMsg                                                MD025783
                                                                                            MD025783
     C                   EVAL      PFldTag  = 'core:cusNumShortName'                        MD025783
     C     P_Action      IFEQ      'I'
     C                   EVAL      PFldData = P_Customer
     C                   ELSE
     C                   EVAL      PFldData = IFCUST
     C                   END
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
                                                                                            MD025783
     C                   EVAL      PFldTag  = 'core:isCustNum'                              MD025783
     C                   EVAL      PFldType = *BLANK                                        MD025783
     C                   EVAL      PFldAttr = *BLANK                                        MD025783
     C                   EXSR      SRFmtWMsg                                                MD025783
                                                                                            MD025783
     C                   EVAL      PFldTag  = '/for:custKey'                                MD025783
     C                   EVAL      PFldType = *BLANK                                        MD025783
     C                   EVAL      PFldAttr = *BLANK                                        MD025783
     C                   EXSR      SRFmtWMsg                                                MD025783
      *
      ** - Forecast Customer Source Account
      *
     C**********         EVAL      PFldTag  = 'keys:custSourcAcc'                           MD025783
     C                   EVAL      PFldTag  = 'for:custSourcAcc'                            MD025783
     C     P_Action      IFEQ      'I'
     C                   EVAL      PFldData = P_CustSourcAcc
     C                   ELSE
     C                   EVAL      PFldData = IFCSAC
     C                   END
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Forecast Currency
      *
     C**********         EVAL      PFldTag  = 'keys:forecastCurrency'                       MD025783
     C                   EVAL      PFldTag  = 'for:currency'                                MD025783
     C     P_Action      IFEQ      'I'
     C                   EVAL      PFldData = P_Currency
     C                   ELSE
     C                   EVAL      PFldData = IFCCY
     C                   END
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Forecast Nostro Code
      *
     C**********         EVAL      PFldTag  = 'keys:nostroCode'                             MD025783
     C                   EVAL      PFldTag  = 'for:nostroCd'                                MD025783
     C     P_Action      IFEQ      'I'
     C                   EVAL      PFldData = P_NostroCode
     C                   ELSE
     C                   EVAL      PFldData = IFNOSC
     C                   END
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Forecast Event Date
      *
     C                   Z-ADD     IFDATE        @@DAYN            5 0
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM                    @@VDT             8 0
     C                   PARM                    @@RTN             1
      *
      ***   date format  YYYY-MM-DD
      *
     C                   MOVE      @@YR          @@YRF
     C                   MOVE      '-'           TRUN1
     C                   MOVE      @@Z71M        @@MMF
     C                   MOVE      '-'           TRUN2
     C                   MOVE      @@Z71D        @@DDF
      *
     C**********         EVAL      PFldTag  = 'keys:date'                                   MD025783
     C                   EVAL      PFldTag  = 'for:date'                                    MD025783
     C*    P_Action      IFEQ      'I'
     C*                  MOVEL     P_Date        PFldData
     C*                  ELSE
     C                   EVAL      PFldData = IFDDS
     C*                  END
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Forecast Sequence
      *
     C**********         EVAL      PFldTag  = 'keys:sequenceNumber'                         MD025783
     C                   EVAL      PFldTag  = 'for:sequenceNum'                             MD025783
     C     P_Action      IFEQ      'I'
     C                   MOVEL     '001'         PFldData
     C                   ELSE
     C                   MOVEL     IFSEQN        PFldData
     C                   END
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Forecast Operation Type
      *
     C**********         EVAL      PFldTag  = 'keys:operationType'                          MD025783
     C                   EVAL      PFldTag  = 'for:operationType'                           MD025783
     C*****P_Action      IFEQ      'I'                                                      MD024362
     C*******************EVAL      PFldData = 'Forecast'                                    MD024362
     C*******************ELSE                                                               MD024362
     C                   EVAL      PFldData = IFOPTY
     C*******************END                                                                MD024362
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Forecast Retail Number
      *
     C**********         EVAL      PFldTag  = 'keys:retailAcctNum'                          MD025783
                                                                                            MD025783
     C                   EVAL      PFldTag  = 'for:retailAcct xsi:' +                       MD025783
     C                             'type="core:retailAcctType"'                             MD025783
     C                   EVAL      PFldType = *BLANK                                        MD025783
     C                   EVAL      PFldAttr = *BLANK                                        MD025783
     C                   EXSR      SRFmtWMsg                                                MD025783
                                                                                            MD025783
     C                   EVAL      PFldTag  = 'core:acctNum'                                MD025783
     C     IFACNO        IFEQ      0
     C                   MOVEL     *BLANK        PFldData
     C                   ELSE
     C                   MOVEL     IFACNO        PFldData
     C                   END
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
                                                                                            MD025783
     C                   EVAL      PFldTag  = 'core:acctIDFormat'                           MD025783
     C                   EVAL      PFldType = *BLANK                                        MD025783
     C                   EVAL      PFldAttr = *BLANK                                        MD025783
     C                   EXSR      SRFmtWMsg                                                MD025783
                                                                                            MD025783
     C                   EVAL      PFldTag  = '/for:retailAcct'                             MD025783
     C                   EVAL      PFldType = *BLANK                                        MD025783
     C                   EVAL      PFldAttr = *BLANK                                        MD025783
     C                   EXSR      SRFmtWMsg                                                MD025783
      *
      ** - Forecast Keys Request
      *
     C**********         EVAL      PFldTag  = '/keys:forecastKeysRequest'                   MD025783
     C                   EVAL      PFldTag  = '/for:forecastKeys'                           MD025783
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** - Forecast Details Request
      *
     C**********         EVAL      PFldTag  = 'details:forecastDetailsRequest '+            MD025783
     C**********                   'xsi:type="details:forecastDetailsRequest" '+            MD025783
     C**********                   'xmlns:details="http://www.misys.com/midas/'+            MD025783
     C**********                   'bfmidas/attributes/forecastmanagement"'                 MD025783
     C                   EVAL      PFldTag  = 'for:forecastDtls xsi' +                      MD025783
     C                             ':type="for:forecastDtlsType"' +                         MD025783
     C                              ' xmlns:for="http:' +                                   MD025783
     C                             '//www.misys.com/midas/bfmidas/attrib/' +                MD025783
     C                             'foriV1"'                                                MD025783
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** - Forecast Amount
      *
     C**********         EVAL      PFldTag = 'amount:forecastAmount xsi:type=' +            MD025783
     C**********                   '"amount:aggregateAmountType" ' +                        MD025783
     C**********                   'xmlns:amount="http://www.misys.com/midas' +             MD025783
     C**********                   '/bfmidas/attributes/forecastmanagement"'                MD025783
     C                   EVAL      PFldTag  = 'for:amount xsi:' +                           MD025783
     C                             'type="core:amountType"'                                 MD025783
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ***-*Forecast*Iso*Currency*Code**********                                             MD025783
      *
     C**********         EVAL      PFldTag  = 'amount:isoCurrencyCode'                      MD025783
     C**********         EVAL      PFldData = P@CUCD                                        MD025783
     C**********         EVAL      PFldType = *Blanks                                       MD025783
     C**********         EVAL      PFldAttr = *Blanks                                       MD025783
     C**********         EXSR      SRFmtWMsg                                                MD025783
      *
      ** - Amount Edited
      *
     C     P_Action      Ifeq      'I'
     C                   Z-Add     0             IFAMNT
     C                   ELSE
     C                   MOVEL     P_Amount      IFAMNT
     C                   END
     C                   Exsr      GetDecimal
     C                   EVAL      PDecPlace = A6NBDP
     C**********         EVAL      PFldTag  = 'amount:amountEdited'                         MD025783
     C                   EVAL      PFldTag  = 'core:amount'                                 MD025783
     C                   EVAL      WAmount = IFAMNT

     C                   CALL      'ZSEDIT'
     C                   PARM                    WAmount
     C                   PARM                    PDecPlace         1 0
     C                   PARM      'L'           PEdtCode          1
     C                   PARM                    WField           21
     C
     C     '-'           SCAN      WField        FOUND             3 0    90
     C                   IF        *IN90 = *ON
     C                   EVAL      PFldData='-'+ %TRIM(%SUBST(WFIELD:1:FOUND-1))
     C                   ELSE
     C                   EVAL      PFldData = %TRIM(WField)
     C                   ENDIF
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      ** Currency                                                                           MD025783
      *                                                                                     MD025783
     C                   EVAL      PFldTag  = 'core:currency'                               MD025783
     C                   EVAL      PFldData = P@CUCD                                        MD025783
     C                   EVAL      PFldType = *Blanks                                       MD025783
     C                   EVAL      PFldAttr = *Blanks                                       MD025783
     C                   EXSR      SRFmtWMsg                                                MD025783
      *
      ** - /Forecast Amount
      *
     C**********         EVAL      PFldTag  = '/amount:forecastAmount '                     MD025783
     C                   EVAL      PFldTag  = '/for:amount'                                 MD025783
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** - Actual Amount
      *
     C**********         EVAL      PFldTag  = 'amount:actualAmount ' +                      MD025783
     C**********                   'xsi:type="amount:aggregateAmountType" ' +               MD025783
     C**********                   'xmlns:amount="http://www.misys.com/midas' +             MD025783
     C**********                   '/bfmidas/attributes/forecastmanagement"'                MD025783
     C                   EVAL      PFldTag  = 'for:actualAmount xsi:' +                     MD025783
     C                             'type="core:amountType"'                                 MD025783
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ***-*Forecast*Iso*Currency*Code**********                                             MD025783
      *
     C**********         EVAL      PFldTag  = 'amount:isoCurrencyCode'                      MD025783
     C**********         EVAL      PFldData = P@CUCD                                        MD025783
     C**********         EVAL      PFldType = *Blanks                                       MD025783
     C**********         EVAL      PFldAttr = *Blanks                                       MD025783
     C**********         EXSR      SRFmtWMsg                                                MD025783
      *
      ** - Actual Amount Edited
      *
     C                   MOVEL     P_ActualAmnt  IFACTL
     C                   Exsr      GetDecimal
     C                   EVAL      PDecPlace = A6NBDP
     C**********         EVAL      PFldTag  = 'amount:amountEdited'                         MD025783
     C                   EVAL      PFldTag  = 'core:amount'                                 MD025783
     C                   EVAL      WAmount = IFACTL

     C                   CALL      'ZSEDIT'
     C                   PARM                    WAmount
     C                   PARM                    PDecPlace         1 0
     C                   PARM      'L'           PEdtCode          1
     C                   PARM                    WField           21

     C     '-'           SCAN      WField        FOUND             3 0    90
     C                   IF        *IN90 = *ON
     C                   EVAL      PFldData='-'+ %TRIM(%SUBST(WFIELD:1:FOUND-1))
     C                   ELSE
     C                   EVAL      PFldData = %TRIM(WField)
     C                   ENDIF
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      ** Currency                                                                           MD025783
      *                                                                                     MD025783
     C                   EVAL      PFldTag  = 'core:currency'                               MD025783
     C                   EVAL      PFldData = P@CUCD                                        MD025783
     C                   EVAL      PFldType = *Blanks                                       MD025783
     C                   EVAL      PFldAttr = *Blanks                                       MD025783
     C                   EXSR      SRFmtWMsg                                                MD025783
      *
      ** - /Actual Amount
      *
     C**********         EVAL      PFldTag  = '/amount:actualAmount'                        MD025783
     C                   EVAL      PFldTag  = '/for:actualAmount'                           MD025783
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *                                                                                     MD025783
      ** - Forecast Actual is Zero                                                          MD025783
      *                                                                                     MD025783
     C     IFACTL        IFNE      0                                                        MD025783
     C                   MOVE      'N'           IFACZR                                     MD025783
     C                   END                                                                MD025783
      *                                                                                     MD025783
     C                   EVAL      PFldTag  = 'for:actualIsZero'                            MD025783
      *                                                                                     MD025783
     C     IFACTL        IFNE      0                                                        MD025783
     C                   EVAL      PFldData = 'false'                                       MD025783
     C                   ELSE                                                               MD025783
     C                   EVAL      PFldData = 'true'                                        MD025783
     C                   ENDIF                                                              MD025783
      *                                                                                     MD025783
     C                   EVAL      PFldType = *Blanks                                       MD025783
     C                   EVAL      PFldAttr = *Blanks                                       MD025783
     C                   EXSR      SRFmtWMsg                                                MD025783
      *
      ** - Forecast Project on Nostro
      *
     C**********         EVAL      PFldTag  = 'details:projectOnNostro'                     MD025783
     C                   EVAL      PFldTag  = 'for:incInNostroBal'                          MD025783
     C*******************EVAL      PFldData = IFPRON                                        MD024362
     C**********         EVAL      PFldData = 'N'                                  MD024362 MD025783
     C                   EVAL      PFldData = 'false'                                       MD025783
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Forecast Project on Retail account
      *
     C**********         EVAL      PFldTag  = 'details:projectOnRetailAcct'                 MD025783
     C                   EVAL      PFldTag  = 'for:incInRetailBal'                          MD025783
     C*******************EVAL      PFldData = IFPROR                                        MD024362
     C**********         EVAL      PFldData = 'N'                                  MD024362 MD025783
     C                   EVAL      PFldData = 'false'                                       MD025783
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Forecast Reference
      *
     C**********         EVAL      PFldTag  = 'details:reference'                           MD025783
     C                   EVAL      PFldTag  = 'for:reference'                               MD025783
     C*****P_Action      Ifeq      'I'                                                      MD024362
     C                   EVAL      PFldData = P_Reference
     C*******************ELSE                                                               MD024362
     C*******************EVAL      PFldData = IFREFN                                        MD024362
     C*******************END                                                                MD024362
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Forecast Narrative
      *
     C**********         EVAL      PFldTag  = 'details:narrative'                           MD025783
     C                   EVAL      PFldTag  = 'for:narrative'                               MD025783
     C*******************EVAL      PFldData = IFNARR                                        MD024362
     C                   EVAL      PFldData = P_Narrative                                   MD024362
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ***-*Forecast*Actual*is*Zero********                                                  MD025783
      *
     C**********     IFACTL        IFNE      0                                              MD025783
     C**********         MOVE      'N'           IFACZR                                     MD025783
     C**********         END                                                                MD025783
      *
     C**********         EVAL      PFldTag  = 'details:actualIsZero'                        MD025783
     C**********         EVAL      PFldData = IFACZR                                        MD025783
     C**********         EVAL      PFldType = *Blanks                                       MD025783
     C**********         EVAL      PFldAttr = *Blanks                                       MD025783
     C**********         EXSR      SRFmtWMsg                                                MD025783
      *
      *
      ** - /Forecast Details Request
      *
     C**********         EVAL      PFldTag  = '/details:forecastDetailsRequest'             MD025783
     C                   EVAL      PFldTag  = '/for:forecastDtls'                           MD025783
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ***-*/Create*Request**********                                                        MD025783
      *
     C**********     P_Action      Ifeq      'I'                                   MD024362 MD025783
     C**********         EVAL      PFldTag  = '/for:createRequest'                          MD025783
     C**********         ELSE                                                      MD024362 MD025783
     C**********         EVAL      PFldTag  = '/for:updateRequest'                 MD024362 MD025783
     C**********         END                                                       MD024362 MD025783
     C**********         EVAL      PFldType = *BLANK                                        MD025783
     C**********         EVAL      PFldAttr = *BLANK                                        MD025783
     C**********         EXSR      SRFmtWMsg                                                MD025783
      *
      ** - Create User Extension Request
      *
     C**********     P_Action      Ifeq      'I'                                   MD024362 MD025783
     C**********         EVAL      PFldTag  = 'for:createUserExtensionRequest'              MD025783
     C                   EVAL      PFldTag  = 'for:userExtension'                           MD025783
     C**********         ELSE                                                      MD024362 MD025783
     C**********         EVAL      PFldTag  = 'for:updateUserExtensionRequest'     MD024362 MD025783
     C**********         END                                                       MD024362 MD025783
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg

      ** - /Create User Extension Request
      *
     C**********     P_Action      Ifeq      'I'                                   MD024362 MD025783
     C**********         EVAL      PFldTag  = '/for:createUserExtensionRequest'             MD025783
     C                   EVAL      PFldTag  = '/for:userExtension'                          MD025783
     C**********         ELSE                                                      MD024362 MD025783
     C**********         EVAL      PFldTag  = '/for:updateUserExtensionRequest'    MD024362 MD025783
     C**********         END                                                       MD024362 MD025783
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg

      ** - /msgData
      *
     C                   EVAL      PFldTag  = '/for:msgData'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** - /bf: JMSMessageData
      *
     C                   EVAL      PFldTag  = '/bf:JMSMessageData'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Return JMS Body
      *
     C                   EVAL      PMode    = '*RETURN'
     C                   EXSR      SRFmtWMsg
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtWsg - Format the WIP message                             *
      *                                                               *
      *****************************************************************
     C     SrFmtWMsg     BEGSR
      *
     C                   CALL      'GL010000'                           99
     C                   PARM                    PMode
     C                   PARM                    PAPIName
     C                   PARM                    Pformat
     C                   PARM                    PfldTag
     C                   PARM                    PfldData
     C                   PARM                    PfldType
     C                   PARM                    PfldAttr
     C                   PARM                    PMsgBuf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P_RtrnCode                     Return Code
     C                   PARM                    P_Option                       Option
     C                   PARM                    P_Action                       Action Code
     C                   PARM                    P_Customer                     Customer No.
     C                   PARM                    P_CustSourcAcc                 Customer Source A/C
     C                   PARM                    P_Operatype                    Operation Type
     C                   PARM                    P_Date                         Event Date
     C                   PARM                    P_FullGLAcc                    Full Gl Account Nbr
     C                   PARM                    P_Currency                     Currency
     C                   PARM                    P_NostroCode                   Nostro Code
     C                   PARM                    P_RetlAcNo                     Retail Account
     C                   PARM                    P_Amount                       Forecast Amount
     C                   PARM                    P_ActualAmnt                   Forecast Actual Amnt
     C                   PARM                    P_Reference                    Forecast Reference
     C                   PARM                    P_Narrative                    Forecast Narrative
     C                   PARM                    P_FrontOffId                   Forecast Front OffId
     C                   PARM                    P_Zone                         Zone
     C                   PARM                    P_ActualIsZero                 Force.Actual is zero
      *
      ** Retrieve Bank ICD details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C     DsBANK        PARM      *Blanks       DSFDY
      *
      ** Retrieve General ledger ICD details.
      *
     C                   CALL      'AOGELRR1'
     C                   PARM      '*DBERR '     P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C     DsGELR        PARM      *Blanks       DSFDY
      *
      ** Retrieve JMS details for Individual Forecast
      *
     C**********         EVAL      P@OP01 = 'MQForecSdrQueue'                               MD025204
     C                   EVAL      P@OP01 = 'ForecastMQSdrQueue'                            MD025204
     C                   EVAL      P@OP02 = 'MQJMSResponseQueue'
     C                   EVAL      P@OP03 = 'MQQueueMgr'
     C**********         EVAL      P@OP04 = 'IndivdualForecastUsr'                          MD025204
     C                   EVAL      P@OP04 = 'ForecastUsr'                                   MD025204
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM                    P@OP01
     C                   PARM      *Blanks       P@VL01
     C                   PARM                    P@OP02
     C                   PARM      *Blanks       P@VL02
     C                   PARM                    P@OP03
     C                   PARM      *Blanks       P@VL03
     C                   PARM                    P@OP04
     C                   PARM      *Blanks       P@VL04
     C                   PARM                    P@OP05
     C                   PARM      *Blanks       P@VL05
     C                   PARM      *Blanks       P@OP06
     C                   PARM      *Blanks       P@VL06
     C                   PARM      *Blanks       P@OP07
     C                   PARM      *Blanks       P@VL07
     C                   PARM      *Blanks       P@OP08
     C                   PARM      *Blanks       P@VL08
     C                   PARM      *Blanks       P@OP09
     C                   PARM      *Blanks       P@VL09
     C                   PARM      *Blanks       P@OP10
     C                   PARM      *Blanks       P@VL10
      *
     C     P@RTCD        IFEQ      *Blanks
      *
     C                   EVAL      WkTransQueue = P@VL01
     C                   EVAL      PQueueNm     = P@VL01
     C                   EVAL      WkRespQ      = P@VL02
     C                   EVAL      WkMQMgr      = P@VL03
     C                   EVAL      PMQMgr       = P@VL03
     C                   EVAL      WkUserId     = %TRIM(P@VL04)
      *
     C                   ENDIF
      ** Retrieve password
      *
     C                   EXSR      getPassWord
      *
     C     WRKKEY        KLIST
     C                   KFLD                    A7CUST
     C                   KFLD                    A7CYCD
     C                   KFLD                    A7ACCD
     C                   KFLD                    A7ACSN
     C                   KFLD                    A7BRCD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    GetDecimal - Currency decimal places                       *
      *                                                               *
      *****************************************************************
     C     GetDecimal    BEGSR

      ** Access currency details via access program

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM      '*KEY'        POptn             7
     C                   PARM      P@CUCD        PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY

      ** Database error

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 020
     C                   OUT       LDA
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * getPassWord - Get password in Validation List                 *
      *                                                               *
      * Called by: callPDCL                                           *
      *                                                               *
      * Calls: SRFmtWMsg                                              *
      *                                                               *
      *****************************************************************
     C     getPassWord   BEGSR
      *
     C**********         CALL      'UT000033'                                                 CSD101
     C**********         PARM      '*BLANKS'     PRtnCode                                     CSD101
     C**********         PARM      'F'           PAction                                      CSD101
     C**********         PARM      'GPLDAPVL'    PValidList                                   CSD101
     C**********         PARM      '*LIBL'       PLibrary                                     CSD101
     C**********         PARM      WkUserId      PUserName                                    CSD101
     C**********         PARM      *BLANKS       PPassword1                                   CSD101
     C**********         PARM      *BLANKS       PPassword2                                   CSD101
     C**********         PARM      *BLANKS       PDescrptn                                    CSD101
      *
     C                   IN        SDSTAT                                                     CSD101
     C                   EVAL      PLibrary = LIBR + 'DMLIB'                                  CSD101
     C                   EVAL      PUserName = 'BANKFUSION_' + WkUserId                       CSD101
      *                                                                                       CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PRtnCode                                     CSD101
     C                   PARM      'F'           PAction                                      CSD101
     C                   PARM      'SDINTFVL'    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PUserName                                    CSD101
     C                   PARM      *Blanks       PPassword1                                   CSD101
     C                   PARM      *Blanks       PDescrptn                                    CSD101
                                                                                              CSD101
     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      WRETCD = '*ERROR'
     C                   EVAL      DBKEY  = WkUserId
     C**********         EVAL      DBFILE = 'GPLDAPVL'                                        CSD101
     C                   EVAL      DBFILE = 'SDINTFVL'                                        CSD101
     C                   EVAL      DBASE = 030
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *                                                                   *
      * Called by:                                                        *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      ********************************************************************
