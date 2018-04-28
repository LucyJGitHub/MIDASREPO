     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas OF Automatic Opening of GL Account')             *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger module                                *
      *                                                               *
      *  GL000590 - Midas OF Automatic Opening of GL Account.         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD023674           Date 29Nov13               *
      *  Prev Amend No. MD023747           Date 23Nov13               *
      *                 CGL135A  *CREATE   Date 11Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD023674 - Invalid date                                      *
      *  MD023747 - Accounting Rules Process (Recompile)              *
      *  CGL135A - Accounting Rules Process                           *
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
      ** Web Config data area
     D BFWBCONF      E DS                  EXTNAME(BFWBCONF) DTAARA
      *
      * Front Office transaction ID
     D                 DS
     D   FOType                6      9A
     D   FOMidasDate          10     14A
     D   FOTimeStamp           1     26A
     D   FOTransId             6     25A
      *
     D WKMsgType       S              4A   INZ('AMAD')                          Message Type
     D WKAction        S             20A   INZ('WRITE!MIDAS.AMAD')              Action
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
     D WkIpAddress     S             64A   VARYING                              IP address
     D WkValLstLoc     S             10A                                        Valib List Library
     D WkZone          S             10A                                        WkZone
     D WkUserId        S             10A                                        User Id
     D WkPassWord      S             10A                                        Password
     D WkTimeStamp     S               Z                                        TimeStamp
     D WkIdx           S             10I 0                                      Index
     D WkDate          S              6A                                        Date        MD023674
      *
     D WkProcRtrn      S                   like(WEB_INT)                        Procedure Return Cod
     D WkSoap          S                   like(WEB_STRVAR)
      *
      *  Collection of all Midas Error Messages
      *
     D WkMidasErrs     DS                  likeDS(midasErrors)
     D WkMidasWarns    DS                  likeDS(midasWarnings)
     D WkOverErrs      DS                  likeDS(overErrors)
     D WkSystemErrs    DS                  likeDS(systemErrors)
      *
     D WkNbErr         S             10I 0                                      Number of Errors
     D WkFldErr        S             20A                                        Field in Error
     D WkDescErr       S            200A                                        Description of error
     D WkOveridden     S              1A                                        Overriden flag
      *
     D Recursive       S              1
      *
      *---------------------------------------------------------------------------------------
      ** PROTOTYPE
      *---------------------------------------------------------------------------------------
     D/COPY BFCPYSRC,BF000007
      *
      /EJECT
      *****************************************************************
      ** Main                                                         *
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
      ** Build account details.
      ** ----------------------
      *
      ** Clear SOAP details.
      *
     C                   RESET                   WkSoap                         SOAP details
      *
      ** Load Head details
      *
     C                   EXSR      SrHead
      *
      ** Load Account details
      *
      ** - Action code
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDACTN'
     C                                                    :'I' )
      *
      ** - Branch code
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDBRCA'
     C                                                    : DDBRCA )
      *
      ** - Customer
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDCUSN'
     C                                                    : DDCUSN )
      *
      ** - Currency
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDCCY'
     C                                                    : DDCCY )
      *
      ** - Account Code
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDACOD'
     C                                                    : DDACOD )
      *
      ** - Account Sequence
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDACSQ'
     C                                                    : DDACSQ )
      *
      ** - Account Name
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDANAM'
     C                                                    :%SubSt(AA5ACCN:1:20))
      *
      ** - Opening date
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      P_OpnDate     ZDAYNO
     C                   PARM      BJDFIN        ZDATFM
     C                   PARM      *Zeros        ZDATE
     C                   PARM      *Blanks       ZADATE
      *
     C                   MOVE      ZDATE         WkDate                                     MD023674
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDDACO'
     C******                                              : %CHAR(ZDATE))                   MD023674
     C                                                    : WkDate )                        MD023674
      *
      ** - Statement Frequency
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDSTFQ'
     C                                                    : BKDSFC )
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
     C                   MOVE      ZDATE         WkDate                                     MD023674
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDNSTD'
     C******                                              : %CHAR(ZDATE))                   MD023674
     C                                                    : WkDate )                        MD023674
      *
     C                   ENDIF
      *
      ** - Print Addrss Y/N
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDPTAD'
     C                                                    : 'Y'    )
      *
      ** - Authorize the transaction
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('AUTH'
     C                                                    : 'Y'    )
      *
      ** Submit Soap
      *
     C                   EXSR      SrSbmSOAP
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
      * SrHead     - Load Head details                                *
      *                                                               *
      *****************************************************************
      *
     C     SrHead        BEGSR
      *
      ** Load Head details
      *
      ** - Message Type
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APTGTTYPE'
     C                                                    : WKMsgType )
      *
      ** - Target System
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APTGTSYS'
     C                                                    :'MIDAS' )
      *
      ** - User id
      *
     C******             EVAL      WkSoap = WkSoap +
     C******                                getOldSoapParm('APUSERID'
     C******                                              : *Blanks )
      *
      ** - Password
      *
     C******             EVAL      WkSoap = WkSoap +
     C******                                getOldSoapParm('APPASSWORD'
     C******                                              : *Blanks )
      *
      ** - Respond Mode - Sync/Async
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APRESPMODE'
     C                                                    :'S' )
      *
      ** - Front Office transaction ID
      *
      **     AMAD + Midas run date + HHMMSS + mmmmm
      *
     C                   EVAL      WkTimeStamp = %TIMESTAMP
     C     *ISO0         MOVE(P)   WkTimeStamp   FOTimeStamp
     C                   MOVE      BJRDNB        FOMidasDate
     C                   EVAL      FOType = WKMsgType
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APFOTRANID'
     C                                                    : FOTransId )
      *
      ** - Confirm valid transaction to front office
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APCNFVALFO'
     C                                                    : 'Y' )
      *
      ** - Repair location
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APRPRLOCN'
     C                                                    : 'F' )
      *
     C     SrHeadE       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSbmSOAP  - Submit Soap                                      *
      *                                                               *
      *****************************************************************
      *
     C     SrSbmSOAP     BEGSR
      *
      ** Setup authentification data
      *
     C                   EVAL      WkProcRtrn =
     C                                 http_setauth( HTTP_AUTH_BASIC
     C                                             : WkUserId
     C                                             : WkPassWord)
      *
      ** Call the Web Service
      *
     C                   EVAL      WkProcRtrn =
     C                                 MPlusAPICoarse( WkIpAddress
     C                                               : WkZone
     C                                               : WKMsgType
     C                                               : WkAction
     C                                               : WkSoap
     C                                               : WkMidasErrs
     C                                               : WkMidasWarns
     C                                               : WkOverErrs
     C                                               : WkSystemErrs)
      *
      ** If Web Service failed
      *
     C                   IF        WkProcRtrn <> 1
      *
     C                   EVAL      P_RtrnCode = '*ERROR'                        Return Code
      *
     C                   IN        BFWBCONF
     C                   IF        BfCrash = 'Y'
     C                   CALLP     http_crash
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Transaction failed
      *
      ** - Midas Error Messages
      *
     C                   IF        WkMidasErrs.eCount <> 0
     C                   EVAL      P_RtrnCode = '*ERROR'                        Return Code
     C                   ENDIF
      *
     C****               EVAL      WkNbErr   = WkMidasErrs.eCount               Number of errors
     C**** 1             DO        WkNbErr       WkIdx
     C****               EVAL      WkFldErr  =
     C****                         WkMidasErrs.midasErr(WkIdx).eFldName         Field in error
     C****               EVAL      WkDescErr =
     C****                         WkMidasErrs.midasErr(WkIdx).eDescription     Description of error
     C****               ENDDO
      *
      ** - Midas Warning messages
      *
     C****               EVAL      WkNbErr   = WkMidasWarns.wnCount             Number of errors
     C**** 1             DO        WkNbErr       WkIdx
     C****               EVAL      WkFldErr  =
     C****                         WkMidasWarns.midasWarn(WkIdx).wFldName       Field in error
     C****               EVAL      WkDescErr =
     C****                         WkMidasWarns.midasWarn(WkIdx).wDescription   Description of error
     C****               ENDDO
      *
      ** - Midas Overridable Error Messages
      *
     C****               EVAL      WkNbErr   = WkOverErrs.oCount                Number of errors
     C**** 1             DO        WkNbErr       WkIdx
     C****               EVAL      WkFldErr  =
     C****                         WkOverErrs.overErr(WkIdx).oFldName           Field in error
     C****               EVAL      WkDescErr =
     C****                         WkOverErrs.overErr(WkIdx).oDescription       Description of error
     C****               EVAL      WkOveridden =
     C****                         WkOverErrs.overErr(WkIdx).isOveridden        Overriden flag
     C****               ENDDO
      *
      ** - Midas System Error Messages
      *
     C                   IF        WkSystemErrs.sCount <> 0
     C                   EVAL      P_RtrnCode = '*ERROR'                        Return Code
     C                   ENDIF
      *
     C****               EVAL      WkNbErr   = WkSystemErrs.sCount              Number of errors
     C**** 1             DO        WkNbErr       WkIdx
     C****               EVAL      WkFldErr  =
     C****                         WkSystemErrs.systemErr(WkIdx).sDescription   Description of error
     C****               ENDDO
      *
     C     SrSbmSOAPE    ENDSR
      *
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
      *
      ** Retrieve IP address, Global System Prefix, User ID
      *
     C                   EVAL      P@OP01 = 'BankFusionIPAddress'
     C                   CALLB     'GPAOSVALR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM                    P@OP01
     C                   PARM                    P@VL01
     C                   PARM                    P@OP02
     C                   PARM                    P@VL02
     C                   PARM                    P@OP03
     C                   PARM                    P@VL03
     C                   PARM                    P@OP04
     C                   PARM                    P@VL04
     C                   PARM                    P@OP05
     C                   PARM                    P@VL05
     C                   PARM                    P@OP06
     C                   PARM                    P@VL06
     C                   PARM                    P@OP07
     C                   PARM                    P@VL07
     C                   PARM                    P@OP08
     C                   PARM                    P@VL08
     C                   PARM                    P@OP09
     C                   PARM                    P@VL09
     C                   PARM                    P@OP10
     C                   PARM                    P@VL10
      *
     C     P@RTCD        IFEQ      *Blanks
     C                   EVAL      WkIpAddress = P@VL01
     C                   ENDIF
      *
      ** Retrieve Global Master Library, Internal SOAP User Id.
      *
     C                   EVAL      P@OP01 = 'GlobalSystemPrefix'
     C                   EVAL      P@OP02 = 'ZoneSystemName'
     C                   EVAL      P@OP03 = 'AcctRulesIntUserAMAD'
      *
     C                   CALLB     'AOSVALR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM                    P@OP01
     C                   PARM      *Blanks       P@VL01
     C                   PARM                    P@OP02
     C                   PARM                    P@VL02
     C                   PARM                    P@OP03
     C                   PARM                    P@VL03
     C                   PARM                    P@OP04
     C                   PARM                    P@VL04
     C                   PARM                    P@OP05
     C                   PARM                    P@VL05
     C                   PARM                    P@OP06
     C                   PARM                    P@VL06
     C                   PARM                    P@OP07
     C                   PARM                    P@VL07
     C                   PARM                    P@OP08
     C                   PARM                    P@VL08
     C                   PARM                    P@OP09
     C                   PARM                    P@VL09
     C                   PARM                    P@OP10
     C                   PARM                    P@VL10
      *
     C     P@RTCD        IFEQ      *Blanks
      *
     C                   EVAL      WkValLstLoc = %TRIM(P@VL01) + 'GMLIB'        Value List Location
     C                   EVAL      WkZone      = P@VL02                         Zone
     C                   EVAL      WkUserId    = P@VL03                         User Id
      *
     C                   ENDIF
      *
      ** Retrieve password
      *
     C                   CALL      'UT000033'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      'F'           P@ACTN                         Find
     C                   PARM      'GPLDAPVL'    P@VLIS                         Valid List
     C                   PARM      WkValLstLoc   P@VLIB                         Valid List Location
     C                   PARM      WkUserId      P@USER                         User Id
     C                   PARM      *Blanks       P@PWD1                         Password 1
     C                   PARM      *Blanks       P@PWD2                         Password 2
     C                   PARM      *Blanks       P@DESC                         Description
      *
     C     P@RTCD        IFEQ      *Blanks
     C                   EVAL      WkPassWord  = P@PWD1                         Password
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
