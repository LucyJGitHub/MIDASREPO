     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Connect to BF Midas thru Web Services')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000125 - Midas LE Connect to BF Midas thru Web Services    *
      *                                                               *
      *  Function:  This program invokes the BankFusion Web Service   *
      *             Calls by accessing the Web services               *
      *             Patterned from BF000013                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD034502           Date 25May15               *
      *  Prev Amend No. MD033895           Date 15Apr15               *
      *                 MD021278           Date 22Jul13               *
      *                 AR1095331*CREATE   Date 07Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034502 - FB Midas 2.1 SP8 Drop3 COB issues                 *
      *  MD033895 - Password retrieval issue during COB               *
      *  MD021278 - LEC000125 fails with timeout error                *
      *  AR1095331 - BFTC Security Issues                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * srStrOfElement - Call back procedure to call at the start of  *
      *                  each XML element received                    *
      *                   - http_url_post_xml()                       *
      * srEndOfElement - Call back procedure to call at the end of    *
      *                  each XML element received                    *
      *                   - http_url_post_xml()                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** +--------------------------------------+
      ** ¦ GLOBAL work fields                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D wReturnCode     S              7A
     D*wPass1          S            256A                                                    MD033895
     D*wDescr          S             50A                                                    MD033895
     D wPass1          S            600A                                                    MD033895
     D wDescr          S           1000A                                                    MD033895
      *
     D wRc             S                   LIKE(WEB_INT)
     D wUrl            S                   LIKE(WEB_STRVAR)
     D wSoap           S                   LIKE(WEB_STRVAR)
     D wSoapXML        S           5000A
     D wIpAddress      S             64A   VARYING
     D wIpAddrSVal     S            200A
     D wUserName       S             30A   VARYING
     D wUserNmSVal     S            200A
     D*wUserNmVlDl     S            256A                                                    MD033895
     D wUserNmVlDl     S            100A                                                    MD033895
     D wGPrefSVal      S            200A
     D wZonePrefix     S              2A
     D wZPrefSVal      S            200A
     D wValLstLoc      S             10A
     D wPassword       S            200A   VARYING
     D wSoapAction     S            120A   VARYING
      *
     D SysValRet       S              7A
     D Rescnt          S              1S 0                                                  MD021278
     D TimeVar         S              1A                                                    MD021278
      *
      ** +--------------------------------------+
      ** ¦ DATA STRUCTURE                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     D BFWBCONF      E DS                  EXTNAME(BFWBCONF) DTAARA
      *
      ** +-----------------------------------------+
      ** ¦ BankFusion Batch Service (BatchService) ¦
      ** ¦ ======================================= ¦
      ** +-----------------------------------------+
      *
      *  Request Values
      *
     D requestDS       DS                          QUALIFIED
     D   userName                    30A           VARYING
     D   password                    30A           VARYING
     D   request                  32767A           VARYING
      *
      *  Response Values
      *
     D responseDS      DS                          QUALIFIED
     D   errorMessage               300A           VARYING
     D   RetCode                      1A           VARYING
     D   RespXML                   5000A           VARYING
      *
      ** +--------------------------------------+
      ** ¦ PROTOTYPE                            ¦
      ** ¦ =========                            ¦
      ** +--------------------------------------+
      *
      ** Midas BF Web Services Routines
     D/COPY BFCPYSRC,BF000007
      *
      *  Retrieve configurations
      *
     D GPAOSVALR0      PR                  EXTPGM('GPAOSVALR0')
     D   P@RTCD                       7A
     D   P@OP01                      20A   CONST
     D   P@VL01                     200A
     D   P@OP02                      20A   CONST
     D   P@VL02                     200A   CONST
     D   P@OP03                      20A   CONST
     D   P@VL03                     200A   CONST
     D   P@OP04                      20A   CONST
     D   P@VL04                     200A   CONST
     D   P@OP05                      20A   CONST
     D   P@VL05                     200A   CONST
     D   P@OP06                      20A   CONST
     D   P@VL06                     200A   CONST
     D   P@OP07                      20A   CONST
     D   P@VL07                     200A   CONST
     D   P@OP08                      20A   CONST
     D   P@VL08                     200A   CONST
     D   P@OP09                      20A   CONST
     D   P@VL09                     200A   CONST
     D   P@OP10                      20A   CONST
     D   P@VL10                     200A   CONST
      *
     D AOSVALR0        PR                  EXTPGM('AOSVALR0')
     D   P@RTCD                       7A
     D   P@OP01                      20A   CONST
     D   P@VL01                     200A   CONST
     D   P@OP02                      20A   CONST
     D   P@VL02                     200A   CONST
     D   P@OP03                      20A   CONST
     D   P@VL03                     200A   CONST
     D   P@OP04                      20A   CONST
     D   P@VL04                     200A   CONST
     D   P@OP05                      20A   CONST
     D   P@VL05                     200A   CONST
     D   P@OP06                      20A   CONST
     D   P@VL06                     200A   CONST
     D   P@OP07                      20A   CONST
     D   P@VL07                     200A   CONST
     D   P@OP08                      20A   CONST
     D   P@VL08                     200A   CONST
     D   P@OP09                      20A   CONST
     D   P@VL09                     200A   CONST
     D   P@OP10                      20A   CONST
     D   P@VL10                     200A   CONST
      *
     D UT000033        PR                  EXTPGM('UT000033')
     D  PReturnCode                   7A
     D  PAction                       1A   CONST
     D  PValidList                   10A   CONST
     D  PLibrary                     10A
     D**PuserName                   256A                                                    MD033895
     D**PPass1                      256A                                                    MD033895
     D**PPass2                      256A   CONST                                            MD033895
     D**PDescr                       50A                                                    MD033895
     D  PuserName                   100A                                                    MD033895
     D  PPass1                      600A                                                    MD033895
     D  PPass2                      600A   CONST                                            MD033895
     D  PDescr                     1000A                                                    MD033895
      *
      *  Call back procedure to call at the start of each XML element received
      *  - http_url_post_xml()
      *
     D srStrOfElement  PR
     D   pUserData                     *   VALUE
     D   pDepth                            LIKE(ELEM_DEPTH) VALUE
     D   pName                             LIKE(ELEM_NAME) CONST
     D   pPath                             LIKE(ELEM_PATH) CONST
     D   pAttrs                        *   DIM(ELEM_ATTR)
     D                                     CONST OPTIONS(*varsize)
      *
      *  Call back procedure to call at the end of each XML element received
      *  - http_url_post_xml()
      *
     D srEndOfElement  PR
     D   pUserData                     *   VALUE
     D   pDepth                            LIKE(ELEM_DEPTH) VALUE
     D   pName                             LIKE(ELEM_NAME) CONST
     D   pPath                             LIKE(ELEM_PATH) CONST
     D   pValue                            LIKE(ELEM_VALUE) CONST
     D   pAttrs                        *   DIM(ELEM_ATTR)
     D                                     CONST OPTIONS(*varsize)
      *
      /free
 
               in BFWBCONF;
 
       // ********************************************************************
       //  Turn debugging info *ON
       // ********************************************************************
 
               if bfdebug = 'Y';
                    http_debug(*ON);
               endif;
 
       // ********************************************************************
       //  Get the IP address, Global System Prefix, PDP User ID
       // ********************************************************************
 
                    GPAOSVALR0(SysValRet
                         :'BankFusionIPAddress'
                         :wIpAddrSVal
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         );
 
                    AOSVALR0(SysValRet
                         :'GlobalSystemPrefix'
                         :wGPrefSVal
                         :'BrgMidasSystemPrefix'
                         :wZPrefSVal
                         :'MQPDPUserIDCOB'
                         :wUserNmSVal
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         :' '
                         );
 
                 wZonePrefix = wZPrefSVal;
 
       // Assumes that Ip Address is no  longer than 64 char
       // and Username is no longer than 30 char
 
                 wIpAddress = %subst(wIpAddrSVal:1:64);
                 wUserName =  %subst(wUserNmSVal:1:30);
                 wValLstLoc = %subst(wGPrefSVal:1:2) + 'GMLIB';
                 wUserNmVlDl = wUserName;
 
       // Retrieve password from validation list
 
                 UT000033(wReturnCode
                        : 'F'
                        : 'GPLDAPVL'
                        : wValLstLoc
                        : wUserNmVlDl
                        : wPass1
                        : ' '
                        : wDescr
                        );
 
                  wPassword = wPass1;
 
 
       // ********************************************************************
       //  Build the URL
       // ********************************************************************
 
               wUrl = 'http://' + %trim(wIpAddress) +
                                  '/bfweb/services/LoginService.LoginPort';
 
       // ********************************************************************
       //  Set the Request parameters for the call to
       //  BankFusion Batch Service (BatchService)
       // ********************************************************************
 
               requestDS.userName = wUserName;
               requestDS.password = wPassword;
 
       // ********************************************************************
       //  Build the SOAP Message
       // ********************************************************************
 
       // Start Tag - SOAP Envelope
               wSoapXML =
               '<soapenv:Envelope ' +
                 'xmlns:soapenv="http://schemas' +
                          '.xmlsoap.org/soap/envelope/" ' +
                 'xmlns:sec="http://security.' +
                          'webservices.bankfusion.' +
                 'trapedza.com">';
 
       // SOAP Header
       //      wSoapXML = %trim(wSoapXML) + '<soapenv:Header>'                              MD034502
       //          + '<sec:authentication>'                                                 MD034502
       //          + '<password>'                                                           MD034502
       //          +        %trim(RequestDS.password)                                       MD034502
       //          + '</password>'                                                          MD034502
       //          + '<userName>'                                                           MD034502
       //          +        %trim(RequestDS.userName)                                       MD034502
       //          + '</userName>'                                                          MD034502
       //          + '</sec:authentication>'                                                MD034502
       //          + '</soapenv:Header>';                                                   MD034502
 
       // Start of change MD034502
                wSoapXML = %trim(wSoapXML) + '<soapenv:Header>'
                          + '<sec:ApplicationID>'
                          + '<value></value>'
                          + '</sec:ApplicationID>'
                          + '<sec:OSUserID>'
                          + '<value></value>'
                          + '</sec:OSUserID>'
                          + '<sec:passCode>'
                          + '<value></value>'
                          + '</sec:passCode>'
                          + '<sec:userName>'
                          + '<value>'
                          +        %trim(RequestDS.userName)
                          + '</value>'
                          + '</sec:userName>'
                          + '<sec:password>'
                          + '<value>'
                          +        %trim(RequestDS.password)
                          + '</value>'
                          + '</sec:password>'
                          + '</soapenv:Header>';
       // End of change MD034502
 
       // SOAP Body - Concatenate given soap body from caller program
 
               wSoapXML = %trim(wSoapXML) +
                          '<soapenv:Body>' +
                               '<sec:request>' +
                                     %trim(RequestDS.request) +
                               '</sec:request>' +
                          '</soapenv:Body>';
 
       // End Tag - SOAP Envelope
               wSoapXML = %trim(wSoapXML) + '</soapenv:Envelope>';
 
               wSoap = wSoapXML;
 
               wSoapAction = 'Login';
       // ********************************************************************
       //  Call the Web Service
       // ********************************************************************
 
               wRc = WebServiceXML(wUrl
                                 : wSoap
                                 : wSoapAction
                                 : %paddr(srStrOfElement)
                                 : %paddr(srEndOfElement)
                                 );
 
       // If HTTP Error returned, retrieve the last error that occured
               if wRc <> 1;
                    responseDS.errorMessage = http_error;
                    if %scan('Timeout':responseDS.errorMessage) <> 0;
                    exsr SrRes;
                    else;
                    if bfcrash = 'Y';
                         http_crash();
                    endif;
                    exsr *pssr;
                    endif;
               endif;
 
       // ********************************************************************
       //  End Program
       // ********************************************************************
 
               *INLR = '1';
               return;
 
       // ********************************************************************
       //  *PSSR  - Program exception error routine.
       //           Called automatically if a program error occurs,
       //           or directly by the program code using EXSR.
       //           This subroutine DUMPs the program just once.
       //
       //
       // ********************************************************************
               BegSr *pssr;
 
                  DUMP;
                  *InU7 = *On;
                  *InU8 = *On;
                  *InLR = *On;
                  Return;
 
               EndSr;
 
       // ********************************************************************
       //
       //  SrRes  - Resend request for 3 times if timeout to connect
       //           to server is encountered.
       //
       // ********************************************************************
               BegSr SrRes;
 
               Rescnt = 1;
               TimeVar = 'Y';
 
               dow  Rescnt <= 3 and TimeVar = 'Y';
               wRc = WebServiceXML(wUrl
                                 : wSoap
                                 : wSoapAction
                                 : %paddr(srStrOfElement)
                                 : %paddr(srEndOfElement)
                                 );
 
               responseDS.errorMessage = http_error;
               if %scan('Timeout':responseDS.errorMessage) = 0;
                    TimeVar = 'N';
               endif;
 
                    Rescnt = Rescnt + 1;
 
               enddo;
 
               if wRc <> 1;
                    responseDS.errorMessage = http_error;
                    if bfcrash = 'Y';
                         http_crash();
                    endif;
                    exsr *pssr;
               endif;
 
               EndSr;
 
      /end-free
      ************************************************************************
      /EJECT
      ************************************************************************
      *                                                                      *
      *  srStrOfElement - Call back procedure to call at the start of each   *
      *                   XML element received - http_url_post_xml()         *
      *                                                                      *
      ************************************************************************
      *
     P srStrOfElement  B
      *
     D                 PI
     D   pUserData                     *   VALUE
     D   pDepth                            LIKE(ELEM_DEPTH) VALUE
     D   pName                             LIKE(ELEM_NAME) CONST
     D   pPath                             LIKE(ELEM_PATH) CONST
     D   pAttrs                        *   DIM(ELEM_ATTR)
     D                                     CONST OPTIONS(*varsize)
      *
      /free
      /end-free
      *
     P                 E
      *
      /EJECT
      ************************************************************************
      *                                                                      *
      *  srEndOfElement - Call back procedure to call at the end of each     *
      *                   XML element received - http_url_post_xml()         *
      *                                                                      *
      ************************************************************************
      *
     P srEndOfElement  B
      *
     D                 PI
     D   pUserData                     *   VALUE
     D   pDepth                            LIKE(ELEM_DEPTH) VALUE
     D   pName                             LIKE(ELEM_NAME) CONST
     D   pPath                             LIKE(ELEM_PATH) CONST
     D   pValue                            LIKE(ELEM_VALUE) CONST
     D   pAttrs                        *   DIM(ELEM_ATTR)
     D                                     CONST OPTIONS(*varsize)
      *
      /free
      /end-free
      *
     P                 E
      ************************************************************************
