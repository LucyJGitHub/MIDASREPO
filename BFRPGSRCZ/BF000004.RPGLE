     H COPYRIGHT('(c) Finastra International Limited 2012')
     H NOMAIN
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas BF Web Services Routines')                       *
      *****************************************************************
      *                                                               *
      *  Midas - BankFusion Module                                    *
      *                                                               *
      *  BF000004 - Web Services Routines                             *
      *                                                               *
      *  Function:  This program provides functionality to access     *
      *             Web services                                      *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD027566           Date 13Jun14               *
      *                 MD023747           Date 23Nov13               *
      *                 AR884111A          Date 25Jan12               *
      *                 CBF006             Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027566 - Webservice time-out error.                        *
      *  MD023747 - HTTP call failure (Recompile due to CGL135        *
      *             changes)                                          *
      *  AR884111A - Update Business Date in BF                       *
      *  CBF006 - BF Infrastructure: Initiating BankFusion Services   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      *---------------------------------------------------------------------------------------
      *  PROTOTYPE
      *---------------------------------------------------------------------------------------
     D/COPY BFCPYSRC,BF000007
      *                                                                                    AR884111A
      ** Procedure to set SOAPAction value in Header                                       AR884111A
      *                                                                                    AR884111A
     D Add_SOAPACTION  PR                                                                  AR884111A
     D   Header                    1024A   varying                                         AR884111A
     D   UserData                      *   value                                           AR884111A
      *                                                                                    AR884111A
      /EJECT
      **********************************************************************
      *                                                                    *
      *  WebServiceXML - Call a web service, receiving an xml response data*
      *                                                                    *
      **********************************************************************
      *
     P WebServiceXML   B                   EXPORT
      *
     D                 PI                  like(WEB_INT)
     D  pUrl                               like(WEB_STRVAR) value
     D  pSoap                              like(WEB_STRVAR) value
     D**pSoapAction                        like(WEB_NAME) value                            AR884111A
     D  pSoapAction                1000A   value                                           AR884111A
     D  pStrOfElement                  *   procptr value
     D  pEndOfElement                  *   procptr value
     D  pContentType                       like(WEB_NAME) options(*nopass:*omit)
     D  pTimeout                           like(WEB_INT) options(*nopass)
     D  pUserAgent                         like(WEB_NAME) options(*nopass:*omit)
      *
      ** Work Fields
      *
     D wContentType    S                   like(WEB_NAME)
     D wTimeout        S                   like(WEB_INT)
     D wUserAgent      S                   like(WEB_NAME)
     D wRc             S                   like(WEB_INT)
      *
      /free
       // *********************************************************
       //  Set up optional parameters
       // *********************************************************
 
          // Content Type
               if %parms >= 6;
                    wContentType = pContentType;
               else;
                    wContentType = 'text/xml';
               endif;
 
          // Timeout
               if %parms >= 7;
                    wTimeout = pTimeout;
               else;
                    wTimeout = HTTP_TIMEOUT;
               endif;
 
          // User Agent
               if %parms >= 8;
                    wUserAgent = pUserAgent;
               else;
                    wUserAgent = HTTP_USERAGENT;
               endif;
 
       // *********************************************************
       //  Add SOAPAction to header
       // *********************************************************
 
       http_xproc( HTTP_POINT_ADDL_HEADER
                 : %paddr(Add_SOAPACTION)
                 : %addr(pSoapAction)
                 );
 
       // *********************************************************
       //  Call the Web Service
       // *********************************************************
 
               wRc = http_url_post_xml(pUrl
                                     : %addr(pSoap) + 2
                                     : %len(pSoap)
                                     : pStrOfElement
                                     : pEndOfElement
                                     : *NULL
                                     : wTimeout
                                     : wUserAgent
                                     : wContentType
       //****************************: pSoapAction********************                     AR884111A
                                     );
 
          // Return the status of the web service
               return  wRc;
 
      /end-free
     P                 E
      *
      /EJECT
      **********************************************************************
      *                                                                    *
      *  WebServiceRaw - Call a web service, receiving a raw response data *
      *                                                                    *
      **********************************************************************
      *
     P WebServiceRaw   B                   EXPORT
      *
     D                 PI                  like(WEB_INT)
     D  pUrl                               like(WEB_STRVAR) value
     D  pSoap                              like(WEB_STRVAR) value
     D**pSoapAction                        like(WEB_NAME) value                            AR884111A
     D  pSoapAction                1000A   value                                           AR884111A
     D  pCallBack                      *   procptr value
     D  pContentType                       like(WEB_NAME) options(*nopass:*omit)
     D  pTimeout                           like(WEB_INT) options(*nopass)
     D  pUserAgent                         like(WEB_NAME) options(*nopass:*omit)
      *
      ** Work Fields
      *
     D wContentType    S                   like(WEB_NAME)
     D wTimeout        S                   like(WEB_INT)
     D wUserAgent      S                   like(WEB_NAME)
     D wRc             S                   like(WEB_INT)
      *                                                                                     MD027566
      ** Retrieve Global System Value                                                       MD027566
      *                                                                                     MD027566
     D GPAOSVALR0      PR                  EXTPGM('GPAOSVALR0')                             MD027566
     D   P@RTCD                       7A                                                    MD027566
     D   P@OP01                      20A   CONST                                            MD027566
     D   P@VL01                     200A                                                    MD027566
     D   P@OP02                      20A   CONST                                            MD027566
     D   P@VL02                     200A   CONST                                            MD027566
     D   P@OP03                      20A   CONST                                            MD027566
     D   P@VL03                     200A   CONST                                            MD027566
     D   P@OP04                      20A   CONST                                            MD027566
     D   P@VL04                     200A   CONST                                            MD027566
     D   P@OP05                      20A   CONST                                            MD027566
     D   P@VL05                     200A   CONST                                            MD027566
     D   P@OP06                      20A   CONST                                            MD027566
     D   P@VL06                     200A   CONST                                            MD027566
     D   P@OP07                      20A   CONST                                            MD027566
     D   P@VL07                     200A   CONST                                            MD027566
     D   P@OP08                      20A   CONST                                            MD027566
     D   P@VL08                     200A   CONST                                            MD027566
     D   P@OP09                      20A   CONST                                            MD027566
     D   P@VL09                     200A   CONST                                            MD027566
     D   P@OP10                      20A   CONST                                            MD027566
     D   P@VL10                     200A   CONST                                            MD027566
      *                                                                                     MD027566
     D SysValRet       S              7A                                                    MD027566
     D WebTimeout      S            200A                                                    MD027566
      *
      /free
                                                                                          //MD027566
       // *********************************************************                       //MD027566
       //  Get the Webservice time-out value                                              //MD027566
       // *********************************************************                       //MD027566
                                                                                          //MD027566
                    GPAOSVALR0(SysValRet                                                  //MD027566
                         :'HTTPTimeOut'                                                   //MD027566
                         :WebTimeout                                                      //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         :' '                                                             //MD027566
                         );                                                               //MD027566
                                                                                          //MD027566
       // *********************************************************
       //  Set up optional parameters
       // *********************************************************
 
          // Content Type
               if %parms >= 5;
                    wContentType = pContentType;
               else;
                    wContentType = 'text/xml';
               endif;
 
          // Timeout
               if %parms >= 6;
                    wTimeout = pTimeout;
               else;
       //********** wTimeout = HTTP_TIMEOUT;                                              //MD027566
                    wTimeout = %Dec(WebTimeout:4:0);                                      //MD027566
               endif;
 
          // User Agent
               if %parms >= 7;
                    wUserAgent = pUserAgent;
               else;
                    wUserAgent = HTTP_USERAGENT;
               endif;
 
       // *********************************************************
       //  Add SOAPAction to header
       // *********************************************************
 
       http_xproc( HTTP_POINT_ADDL_HEADER
                 : %paddr(Add_SOAPACTION)
                 : %addr(pSoapAction)
                 );
 
       // *********************************************************
       //  Call the Web Service
       // *********************************************************
 
               wRc = http_url_post_raw(pUrl
                                     : %addr(pSoap) + 2
                                     : %len(pSoap)
                                     : 1
                                     : pCallBack
                                     : wTimeout
                                     : wUserAgent
                                     : wContentType
       //****************************: pSoapAction********************                     AR884111A
                                     );
 
          // Return the status of the web service
               return  wRc;
 
      /end-free
     P                 E
      *                                                                                    AR884111A
      /EJECT                                                                               AR884111A
      **********************************************************************               AR884111A
      *                                                                    *               AR884111A
      *  Add_SOAPACTION - Set SOAPAction value to Header                   *               AR884111A
      *                                                                    *               AR884111A
      **********************************************************************               AR884111A
      *                                                                                    AR884111A
     P Add_SOAPACTION  B                                                                   AR884111A
     D Add_SOAPACTION  PI                                                                  AR884111A
     D   Header                    1024A   varying                                         AR884111A
     D   UserData                      *   value                                           AR884111A
      *                                                                                    AR884111A
      /free                                                                                AR884111A
         Header = 'SOAPAction: '
                + %str(UserData:1000)
                + x'0d25';                                                               //AR884111A
      /end-free                                                                            AR884111A
      *                                                                                    AR884111A
     P                 E                                                                   AR884111A
      **********************************************************************               AR884111A
