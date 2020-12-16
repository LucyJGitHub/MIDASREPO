     H DEBUG
     H NOMAIN
     H COPYRIGHT('(c) Finastra International Limited 2017')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas BF Invoke BF Web Service Common')                *
      *****************************************************************
      *                                                               *
      *  Midas - BankFusion Module                                    *
      *                                                               *
      *  BF004020 - Invoke BF Web Service Common                      *
      *                                                               *
      *  Function:  This program invokes the BankFusion Web Service   *
      *             Calls by accessing the Web services               *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. MD050405           Date 03Jun20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CBF023  *CREATE    Date 04Jan17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050405 - Fusion Midas 2.1 Platform Upgrade                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF023 - Soft Delete Feature on Security Related Modules     *
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
     D wPass1          S            600A
     D wDescr          S           1000A
      *
     D wRc             S                   LIKE(WEB_INT)
     D wUrl            S                   LIKE(WEB_STRVAR)
     D wSoap           S                   LIKE(WEB_STRVAR)
     D wSoapXML        S           5000A
     D wIpAddress      S             64A   VARYING
     D wIpAddrSVal     S            200A
     D wIpAddress_SSL  S             64A   VARYING                                          MD050405
     D wIpAddrSSLVal   S            200A                                                    MD050405
     D wUserName       S             30A   VARYING
     D wUserNmSVal     S            200A
     D wUserNmVlDl     S            100A
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
     D***UT000033        PR                  EXTPGM('UT000033')                             MD050405
     D SD000404        PR                  EXTPGM('SD000404')                               MD050405
     D  PReturnCode                   7A
     D  PAction                       1A   CONST
     D  PValidList                   10A   CONST
     D  PLibrary                     10A
     D  PuserName                   100A
     D***PPass1                      600A                                                   MD050405
     D***PPass2                      600A   CONST                                           MD050405
     D  PPass1                      128A                                                    MD050405
     D  PDescr                     1000A
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
     D BF004020        PR            10I 0
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
     P BF004020        B                   EXPORT
      *
     D BF004020        PI            10I 0
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
                         :'BrgMidasGlobalPrefix'
                         :wGPrefSVal
          //**********   :' '                                                             //MD050405
          //**********   :' '                                                             //MD050405
                         :'BankFusionIPAdd_SSL'                                           //MD050405
                         :wIpAddrSSLVal                                                   //MD050405
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
                         :'BatchProcPurgeWSUser'
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
                         :' '
                         :' '
                         );

                 wZonePrefix = wZPrefSVal;

       //Assumes that Ip Address is no  longer than 64 char
       // and Username is no longer than 30 char

                 wIpAddress = %subst(wIpAddrSVal:1:64);
                 wIpAddress_SSL = %subst(wIpAddrSSLVal:1:64);                             //MD050405
                 wUserName =  %subst(wUserNmSVal:1:30);
          //*****wValLstLoc = %subst(wGPrefSVal:1:2) + 'GMLIB';                           //MD050405
          //*****wUserNmVlDl = wUserName;                                                 //MD050405
                 wValLstLoc = %subst(wZPrefSVal:1:2) + 'DMLIB';                           //MD050405
                 wUserNmVlDl = 'BANKFUSION_' + wUserName;                                 //MD050405

       //Retrieve password from validation list

          //*********UT000033(wReturnCode
          //**********      : 'F'
          //**********      : 'GPLDAPVL'
          //**********      : wValLstLoc
          //**********      : wUserNmVlDl
          //**********      : wPass1
          //**********      : ' '
          //**********      : wDescr
          //**********      );

                     SD000404(wReturnCode                                                 //MD050405
                            : 'F'                                                         //MD050405
                            : 'SDINTFVL'                                                  //MD050405
                            : wValLstLoc                                                  //MD050405
                            : wUserNmVlDl                                                 //MD050405
                            : wPass1                                                      //MD050405
                            : wDescr                                                      //MD050405
                            );                                                            //MD050405
                                                                                          //MD050405
                  wPassword = wPass1;

          wSoapAction = %trim(setSpAction);

       // *********************************************************
       //  Build the URL
       // *********************************************************

               wUrl = 'http://' + %trim(wIpAddress) +
                      %trim(setURL);

          // If BankFusionIPAdd_SSL contains a value, use the https url                   //MD050405
               if wIpAddress_SSL <> *BLANKS;                                              //MD050405
                 wUrl = 'https://' + %trim(wIpAddress_SSL) +                              //MD050405
                      %trim(setURL);                                                      //MD050405
               endif;                                                                     //MD050405
                                                                                          //MD050405
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
                   + '<web:userLocator></web:userLocator>'
                   + '</web:authentication>'
                   + '<BFHeader>'
                   + '<att:correlationID></att:correlationID>'
                   + '<att:zone>'
                   +        %trim(requestDS1.zonePrefix)
                   + '</att:zone>'
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

               http_setauth ( HTTP_AUTH_BASIC : wUserName : wPassword );                  //MD050405
                                                                                          //MD050405
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
