     H DEBUG
     H NOMAIN
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas BF Invoke BF Web Service Common')                *
      *****************************************************************
      *                                                               *
      *  Midas - BankFusion Module                                    *
      *                                                               *
      *  BF000013 - Invoke BF Web Service Common                      *
      *                                                               *
      *  Function:  This program invokes the BankFusion Web Service   *
      *             Calls by accessing the Web services               *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSD101             Date 07Dec18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD044342           Date 01Mar17               *
      *                 MD033895           Date 16Apr15               *
      *                 MD023747           Date 23Nov13               *
      *                 AR884111A *CREATE  Date 25Jan12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044342 - Business date in BF is not being updated          *
      *  MD033895 - Password retrieval issue during COB               *
      *  MD023747 - HTTP call failure (Recompile due to CGL135        *
      *             changes)                                          *
      *  AR884111A - Update Business Date in BF                       *
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
     D timeDelay       S             10U 0 INZ(5)
     D wRc1            S                   LIKE(WEB_INT)
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
     D wRequestName    S            100A   VARYING
     D wResponseName   S            100A   VARYING
     D wSoapAction     S            120A   VARYING
      *
     D SysValRet       S              7A
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
     D requestDS1      DS                          QUALIFIED
     D   userName                    30A           VARYING
     D   password                    30A           VARYING
     D   zonePrefix                   2A
     D   COBstate                     5A
     D   soapAction                 120A           VARYING
      *
      *  Response Values
      *
     D responseDS1     DS                          QUALIFIED
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
      *  Time Delay in seconds
      *
     D Sleep           PR            10I 0 EXTPROC('sleep')
     D   Seconds                     10U 0 VALUE
      *
      *  Retrieve configurations
      *
     D GPAOSVALR0      PR                  EXTPGM('GPAOSVALR0')
     D   P@RTCD                       7A
     D   P@OP01                      20A   CONST
     D   P@VL01                     200A
     D   P@OP02                      20A   CONST
     D   P@VL02                     200A
     D   P@OP03                      20A   CONST
     D   P@VL03                     200A
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
     D*UT000033        PR                  EXTPGM('UT000033')
     D SD000404        PR                  EXTPGM('SD000404')
     D  PReturnCode                   7A
     D  PAction                       1A   CONST
     D  PValidList                   10A   CONST
     D  PLibrary                     10A
     D**PuserName                   256A                                                    MD033895
     D**PPass1                      256A                                                    MD033895
     D**PPass2                      256A   CONST                                            MD033895
     D**PDescr                       50A                                                    MD033895
     D  PuserName                   100A                                                    MD033895
     D**PPass1                      600A                                             MD033895 CSD101
     D  PPass1                      128A                                                      CSD101
     D**PPass2                      600A   CONST                                     MD033895 CSD101
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
     D BF000013        PR            10I 0
     D   setURL                      64A
     D   setSpEnvAdd                500A
     D   setSpXMLBody              5000A
     D   setSpAction                120A
     D   setPPath                    64A
      *
      /EJECT
      *
      *  *ENTRY Interface for Main procedure
      *
     P BF000013        B                   EXPORT
      *
     D BF000013        PI            10I 0
     D   setURL                      64A
     D   setSpEnvAdd                500A
     D   setSpXMLBody              5000A
     D   setSpAction                120A
     D   setPPath                    64A
      *
      /EJECT
      *
      /free
 
               in BFWBCONF;
 
       // *********************************************************
       //  Turn debugging info *ON
       // *********************************************************
 
               if bfdebug = 'Y';
                    http_debug(*ON);
               endif;
 
       // *********************************************************
       //  Get the user, password, zone prefix
       // *********************************************************
 
                    GPAOSVALR0(SysValRet
                         :'BankFusionIPAddress'
                         :wIpAddrSVal
                         :'BankFusionUserName'
                         :wUserNmSVal
                         :'BrgMidasGlobalPrefix'
                         :wGPrefSVal
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
                         :'BrgMidasSystemPrefix'
                         :wZPrefSVal
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
 
                 wZonePrefix = wZPrefSVal;
 
       //Assumes that Ip Address is no  longer than 64 char
       // and Username is no longer than 30 char
 
                 wIpAddress = %subst(wIpAddrSVal:1:64);
                 wUserName =  %subst(wUserNmSVal:1:30);
          //     wValLstLoc = %subst(wGPrefSVal:1:2) + 'GMLIB';                             //CSD101
                 wValLstLoc = %subst(wZPrefSVal:1:2) + 'DMLIB';                             //CSD101
          //     wUserNmVlDl = wUserName;                                                   //CSD101
                 wUserNmVlDl = 'BANKFUSION_' + wUserName;                                   //CSD101
 
       //Retrieve password from validation list
 
          //         UT000033(wReturnCode                                                   //CSD101
          //                : 'F'                                                           //CSD101
          //                : 'GPLDAPVL'                                                    //CSD101
          //                : wValLstLoc                                                    //CSD101
          //                : wUserNmVlDl                                                   //CSD101
          //                : wPass1                                                        //CSD101
          //                : ' '                                                           //CSD101
          //                : wDescr                                                        //CSD101
          //                );                                                              //CSD101
 
                     SD000404(wReturnCode                                                   //CSD101
                            : 'F'                                                           //CSD101
                            : 'SDINTFVL'                                                    //CSD101
                            : wValLstLoc                                                    //CSD101
                            : wUserNmVlDl                                                   //CSD101
                            : wPass1                                                        //CSD101
                            : wDescr                                                        //CSD101
                            );                                                              //CSD101
                                                                                            //CSD101
                  wPassword = wPass1;
 
          wSoapAction = %trim(setSpAction);
 
       // *********************************************************
       //  Build the URL
       // *********************************************************
 
               wUrl = 'http://' + %trim(wIpAddress) +
                      %trim(setURL);
 
       // *********************************************************
       //  Set the Request parameters for the call to
       //  BankFusion Batch Service (BatchService)
       // *********************************************************
 
               requestDS1.userName = wUserName;
               requestDS1.password = wPassword;
               requestDS1.soapAction = wSoapAction;
               requestDS1.zonePrefix = wZonePrefix;
 
       // *********************************************************
       //  Build the SOAP Message
       // *********************************************************
 
          // Start Tag - SOAP Envelope
               wSoapXML =
               '<soapenv:Envelope ' +
                 'xmlns:soapenv="http://schemas' +
                          '.xmlsoap.org/soap/envelope/" ' +
                 'xmlns:web="http://webservices' +
                          '.bankfusion.trapedza.com" ' +
                 %trim(setSpEnvAdd) + '>';
 
          // SOAP Header
               wSoapXML = %trim(wSoapXML) + '<soapenv:Header>'
                   + '<web:bfgenericsoapheader>'
                   + '<web:authentication>'
                   + '<userName>'
                   +        %trim(RequestDS1.userName)
                   + '</userName>'
                   + '<password>'
                   +        %trim(RequestDS1.password)
                   + '</password>'
                   + '<web:passCode></web:passCode>'                                      //MD044342
                   + '<web:userLocator></web:userLocator>'
                   + '</web:authentication>'
                   + '<BFHeader>'
                   + '<att:correlationID></att:correlationID>'
          //       + '<att:zone></att:zone>'                                              //MD044342
                   + '<att:zone>'                                                         //MD044342
                   +        %trim(RequestDS1.zonePrefix)                                  //MD044342
                   + '</att:zone>'                                                        //MD044342
                   + '<att:autoAuthorize></att:autoAuthorize>'                            //MD044342
                   + '<att:extension/>'                                                   //MD044342
                   + '</BFHeader>'
                   + '</web:bfgenericsoapheader>'
                   + '</soapenv:Header>';
 
          // SOAP Body - Concatenate given soap body from caller program
 
               wSoapXML = %trim(wSoapXML) + %trim(setSpXMLBody);
 
          // End Tag - SOAP Envelope
               wSoapXML = %trim(wSoapXML) + '</soapenv:Envelope>';
 
               wSoap = wSoapXML;
 
       // *********************************************************
       //  Call the Web Service
       // *********************************************************
 
               wRc = WebServiceXML(wUrl
                                 : wSoap
                                 : %trim(RequestDS1.soapAction)
                                 : %paddr(srStrOfElement)
                                 : %paddr(srEndOfElement)
                                 );
 
          // If HTTP Error returned, retrieve the last error that occured
               if wRc <> 1;
                    responseDS1.errorMessage = http_error;
               else;
                    responseDS1.RespXML = wSoap;
                    responseDS1.RetCode = '1';
               endif;
 
       // *********************************************************
       //  End Program
       // *********************************************************
 
               *INLR = '1';
               return wRc;
 
      /end-free
     P                 E
 
      *****************************************************************
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
      *
      /EJECT
      ************************************************************************
