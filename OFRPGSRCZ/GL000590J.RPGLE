     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas OF Automatic Opening of GL Account - JMS')       *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger module                                *
      *                                                               *
      *  GL000590J - Midas OF Automatic Opening of GL Account - JMS   *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL135B  *CREATE   Date 11Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL135B - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************
      *
      * Bank Details
     D DsBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * General ledger ICD
     D DsGELR        E DS                  EXTNAME(SDGELRPD)
      *
      * Account details
     D DsACCN        E DS                  EXTNAME(ACCNTAB)
      *
      * Account Code details
     D DsACOD        E DS                  EXTNAME(SDACODPD) PREFIX(A)
      *
      * Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Local data Area
     D LDA           E DS                  EXTNAME(LDA) DTAARA
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
     D P_Branch        S                   LIKE(BRCA)                           Branch
     D P_Customer      S                   LIKE(CNUM)                           Customer
     D P_Currency      S                   LIKE(CCY)                            Currency
     D P_AccntCode     S             10P 0                                      Account Code
     D P_AccntSeq      S              2P 0                                      Account Sequence
     D P_RetlAcNo      S             10P 0                                      Retail Account
     D P_OpnDate       S              5P 0                                      Date account opened
      *
      * Account Reference
     D DDBRCA          S              3A                                        Branch
     D DDCUSN          S              6A                                        Customer
     D DDCCY           S              3A                                        Currency
     D DDACOD          S             10A                                        Account Code
     D DDACSQ          S              2A                                        Account Sequence
     D DDACNO          S             10A                                        Retail Account
      *
      * Access objects parameters
     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option
     D P@RETL          S                   LIKE(DDACNO)                         Retail Account
     D P@CNUM          S                   LIKE(DDCUSN)                         Customer
     D P@CUCD          S                   LIKE(DDCCY)                          Currency
     D P@ACCD          S                   LIKE(DDACOD)                         Account Code
     D P@ACSQ          S                   LIKE(DDACSQ)                         Account Sequence
     D P@BRCA          S                   LIKE(DDBRCA)                         Branch
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
     D PfldTag         S             10A
     D PfldData        S           1000A
     D PfldType        S             10A
     D PfldAttr        S             10A
      *
     D PRtCd           S              7                                                    AR1021983
     D PErrMsg         S             30A                                                   AR1021983
     D PRequest        S             10A                                                   AR1021983
     D PQueueNm        S             48A                                                   AR1021983
     D PMsgBuf         S          32000A                                                   AR1021983
     D P@Key           S              4A                                                   AR1021983
     D PMQMgr          S             48A                                                   AR1021983
      *
     D ZDAYNO          S              5  0                                      Value date
     D ZDATFM          S              1A                                        Date format ind
     D ZDATE           S              6  0                                      Value date
     D ZADATE          S              7A                                        Run-date in DDM
     D ZCCY            S                   LIKE(DDCCY)                          Currency
     D ZFREQ           S              1A                                        Frequency
     D ZLOC            S                   LIKE(BJSLCD)                         Location
     D ZMDAY           S              2  0                                      Frequency day
      *
     D WkBckValDat     S              5  0                                      Back Value Date
     D WkTransQueue    S             48A                                        MQ Trans Sdr Queue
     D WkRespQ         S             20A                                        MQ JMS ResponseQueue
     D WkMQMgr         S             48A                                        MQ Queue Mgr
     D WkValLstLoc     S             10A                                        Valib List Library
     D WkUserId        S             10A                                        User Id
     D WkPassWord      S             10A                                        Password
     D WkTimeStamp     S               Z                                        TimeStamp
      *
      *
     D Recursive       S              1
      *
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
     C                   IF        P_Option    = '*CLOSE ' AND                  Option
     C                             P_Branch    = *Blanks   AND                  Branch Code
     C                             P_Customer  = *Blanks   AND                  Customer Number
     C                             P_Currency  = *Blanks   AND                  Currency Code
     C                             P_AccntCode = *Zeros    AND                  Account Code
     C                             P_AccntSeq  = *Zeros    AND                  Account Sequence
     C                             P_RetlAcNo  = *Zeros    AND                  Retail Account Nb
     C                             P_OpnDate   = *Zeros                         Date account opened
     C                   GOTO      END
     C                   ENDIF
      *
      ** Load account details
      ** --------------------
      *
     C                   EVAL      DDBRCA = P_Branch                            Branch
     C                   EVAL      DDCUSN = P_Customer                          Customer
     C                   EVAL      DDCCY  = P_Currency                          Currency
      *
      ** - Account Code
      *
     C                   IF        P_AccntCode <> *Zeros
     C                   MOVE      P_AccntCode   DDACOD                         Account Code
     C                   ELSE
     C                   EVAL      DDACOD = *Blanks                             Account Sequence
     C                   ENDIF
      *
      ** - Account Sequence
      *
     C                   IF        P_AccntSeq <> *Zeros
     C                   MOVE      P_AccntSeq    DDACSQ                         Account Sequence
     C                   ELSE
     C                   EVAL      DDACSQ = *Blanks                             Account Sequence
     C                   ENDIF
      *
      ** - Retail Account
      *
     C                   IF        P_RetlAcNo <> *Zeros
     C                   MOVE      P_RetlAcNo    DDACNO                         Retail Account
     C                   ELSE
     C                   EVAL      DDACNO = *Blanks                             Retail Account
     C                   ENDIF
      *
      ** Check account
      ** -------------
      *
      ** - Check if the account already exists.
      *
     C                   CALLB     'AOACCTR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      DDACNO        P@RETL                         Retail Account
     C                   PARM      DDCUSN        P@CNUM                         Customer
     C                   PARM      DDCCY         P@CUCD                         Currency
     C                   PARM      DDACOD        P@ACCD                         Account Code
     C                   PARM      DDACSQ        P@ACSQ                         Account Sequence
     C                   PARM      DDBRCA        P@BRCA                         Branch
     C     DsACCN        PARM      *Blanks       DSSDY
      *
     C                   IF        P@RTCD = *Blanks
     C                   EVAL      P_RtrnCode = '*EXIST'                        Return Code
     C                   GOTO      END
     C                   ENDIF
      *
      ** - Check if input values are inserted.
      *
     C                   IF        P_Branch    = *Blanks OR
     C                             P_Customer  = *Blanks OR
     C                             P_Currency  = *Blanks OR
     C                             P_AccntCode = *Zeros  OR
     C                             P_AccntSeq  = *Zeros
      *
     C                   EVAL      P_RtrnCode = '*ERROR'                        Return Code
     C                   GOTO      END
      *
     C                   ENDIF
      *
      ** - Check if the opening date is between the back value date and today.
      *
     C                   IF        P_Opndate = *zeros
     C                   EVAL      P_OpnDate =  BJRDNB                          Run Date
     C                   ENDIF
      *
     C                   IF        P_OpnDate < WkBckValDat OR
     C                             P_OpnDate > BJRDNB
     C                   EVAL      P_RtrnCode = '*ERROR'                        Return Code
     C                   GOTO      END
     C                   ENDIF
      *
      ** Retrieve account code details.
      *
     C                   CALLB     'AOACODR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      DDACOD        P@ACCD
     C     DsACOD        PARM      *Blanks       DSSDY
      *
      ** If NOT General Ledger Account code,
      *
     C                   IF        P@RTCD  <> *Blanks OR
     C                             AA5TOIN =  'Y'     OR
     C                             AA5ACTY <> 'G'
     C                   EVAL      P_RtrnCode = '*ERROR'                        Return Code
     C                   GOTO      END
     C                   ENDIF
      *
      ** Build SOAP details.
      ** -------------------
      *
     C                   EVAL      PMode    = '*CLEAR'
     C                   EXSR      SRFmtWMsg
      *
      ** - Action
      *
     C                   EVAL      PMode    = '*ENTER'
     C                   EVAL      PAPIName = 'WRITE!MIDAS.AMAD'
     C                   EVAL      PFormat  = 'AMAD'
      *
      ** - Target System
      *
     C                   EVAL      PFldTag  = 'APTGTSYS'
     C                   EVAL      PFldData = 'MIDAS'
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      *
      ** - Front Office transaction ID
      *
      **   AMAD + Midas run date + HHMMSS + mmmmm
      *
     C                   EVAL      WkTimeStamp = %TIMESTAMP
     C     *ISO0         MOVE(P)   WkTimeStamp   FOTimeStamp
     C                   MOVE      BJRDNB        FOMidasDate
     C                   EVAL      FOType      = 'AMAD'
      *
     C                   EVAL      PFldTag  = 'APFOTRANID'
     C                   EVAL      PFldData = FOTransId
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Confirm valid transaction to front office
      *
     C                   EVAL      PFldTag  = 'APCNFVALFO'
     C                   EVAL      PFldData = 'Y'
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Repair location
      *
     C                   EVAL      PFldTag  = 'APRPRLOCN'
     C                   EVAL      PFldData = 'F'
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Reply Queue
      *
     C                   EVAL      PFldTag  = 'APRPYQUEUE'
     C                   EVAL      PFldData = WkRespQ
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Action code
      *
     C                   EVAL      PFldTag  = 'DDACTN'
     C                   EVAL      PFldData = 'I'
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Branch code
      *
     C                   EVAL      PFldTag  = 'DDBRCA'
     C                   EVAL      PFldData =  DDBRCA
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Customer
      *
     C                   EVAL      PFldTag  = 'DDCUSN'
     C                   EVAL      PFldData =  DDCUSN
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Currency
      *
     C                   EVAL      PFldTag  = 'DDCCY'
     C                   EVAL      PFldData =  DDCCY
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Account Code
      *
     C                   EVAL      PFldTag  = 'DDACOD'
     C                   EVAL      PFldData =  DDACOD
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Account Sequence
      *
     C                   EVAL      PFldTag  = 'DDACSQ'
     C                   EVAL      PFldData =  DDACSQ
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Account Name
      *
     C                   EVAL      PFldTag  = 'DDANAM'
     C                   EVAL      PFldData = %SubSt(AA5ACCN:1:20)
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Opening date
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      P_OpnDate     ZDAYNO
     C                   PARM      BJDFIN        ZDATFM
     C                   PARM      *Zeros        ZDATE
     C                   PARM      *Blanks       ZADATE
      *
     C                   EVAL      PFldTag  = 'DDDACO'
     C                   EVAL      PFldData =  %CHAR(ZDATE)
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Statement Frequency
      *
     C                   EVAL      PFldTag  = 'DDSTFQ'
     C                   EVAL      PFldData =  BKDSFC
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Next Statement date
      *
     C                   EVAL      ZDAYNO    =  BJRDNB
     C                   IF        BKAPFQ    <> 'D'    AND
     C                             BJDNWD    >  BKAPDT
     C                   EVAL      ZDAYNO    =  BJDNWD
     C                   ENDIF
      *
     C                   CALLB     'ZFREQB'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      BKDSFC        ZFREQ                          Frequency
     C                   PARM                    ZDAYNO                         Start date
     C                   PARM      DDCCY         ZCCY                           Currency
     C                   PARM      BJSLCD        ZLOC                           Location
     C                   PARM      *Zeros        ZMDAY                          Frequency date
     C                   PARM      BJDFIN        ZDATFM                         Date Format
     C                   PARM      DsGELR        P@GELR
      *
     C                   IF        P@RTCD = *blanks
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        ZDATFM
     C                   PARM      *Zeros        ZDATE
     C                   PARM      *Blanks       ZADATE
      *
     C                   EVAL      PFldTag  = 'DDNSTD'
     C                   EVAL      PFldData = %CHAR(ZDATE)
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
     C                   ENDIF
      *
      ** - Print Addrss Y/N
      *
     C                   EVAL      PFldTag  = 'DDPTAD'
     C                   EVAL      PFldData =  'Y'
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** - Authorize the transaction
      *
     C                   EVAL      PFldTag  = 'AUTH'
     C                   EVAL      PFldData =  'Y'
     C                   EVAL      PFldType = *Blanks
     C                   EVAL      PFldAttr = *Blanks
     C                   EXSR      SRFmtWMsg
      *
      ** Return SOAP Body
      *
     C                   EVAL      PMode    = '*RETURN'
     C                   EXSR      SRFmtWMsg
      *
     C                   DUMP
      *
      ** - Send message to MQ series queue
      *
     C                   EVAL      PRequest = '*OPEN_PUT'
     C                   EXSR      SRPutMQIO
      *
     C                   EVAL      PRequest = '*PUT'
     C                   EXSR      SRPutMQIO
      *
     C                   EVAL      PRequest = '*CLOSE'
     C                   EXSR      SRPutMQIO
      *
     C     END           TAG
      *
      ** Release resources
      *
     C                   IF        P_Option = '*CLOSE '
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtWsg - Format the WIP message                             *
      *                                                               *
      *****************************************************************
     C     SRFmtWMsg     BEGSR
      *
     C                   CALL      'GPFMT4WIP'                          99
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
      *  SRPutMQIO - Put message to MQ Series queue                   *
      *                                                               *
      *****************************************************************
     C     SRPutMQIO     BEGSR
      *
     C                   CALL      'GPMQMIO'                            99
     C                   PARM      *Blanks       PRtCd
     C                   PARM                    PErrMsg
     C                   PARM                    PRequest
     C                   PARM      WkTransQueue  PQueueNm
     C                   PARM                    PMsgBuf
     C                   PARM                    P@Key
     C                   PARM      WkMQMgr       PMQMgr
      *
     C                   IF        PRtCd <> *BLANKS    OR
     C                             PErrMsg <> *BLANKS  OR
     C                             *IN99
     C                   EVAL      P_RtrnCode = '*ERROR'                        Return Code
     C                   ENDIF
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
     C                   PARM                    P_Branch                       Branch Code
     C                   PARM                    P_Customer                     Customer Number
     C                   PARM                    P_Currency                     Currency Code
     C                   PARM                    P_AccntCode                    Account Code
     C                   PARM                    P_AccntSeq                     Account Sequence
     C                   PARM                    P_RetlAcNo                     Retail Account Nb
     C                   PARM                    P_OpnDate                      Date account opened
      *
      *
      ** Retrieve Bank ICD details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C     DsBANK        PARM      *Blanks       DSFDY
      *
     C                   EVAL      WkBckValDat = BJRDNB - BJBVPD                Back Value Date
      *
      ** Retrieve General ledger ICD details.
      *
     C                   CALLB     'AOGELRR1'
     C                   PARM      '*DBERR '     P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C     DsGELR        PARM      *Blanks       DSFDY
      *
      ** Retrieve JMS details.
      *
     C                   EVAL      P@OP01 = 'MQTransSdrQueue'
     C                   EVAL      P@OP02 = 'MQJMSResponseQueue'
     C                   EVAL      P@OP03 = 'MQQueueMgr'
      *
     C                   CALLB     'AOSVALR0'
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
     C                   EVAL      WkRespQ      = P@VL02
     C                   EVAL      WkMQMgr      = P@VL03
      *
     C                   ENDIF
      *
     C     EINZSR        ENDSR
      *
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
