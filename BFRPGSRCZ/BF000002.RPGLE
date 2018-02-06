     H COPYRIGHT('(c) Finastra International Limited 2011')
     H NOMAIN
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas BF Midas Plus Coarse-grained API Call')          *
      *****************************************************************
      *                                                               *
      *  Midas - BankFusion Module                                    *
      *                                                               *
      *  BF000002 - Midas Plus Coarse-grained API Call                *
      *                                                               *
      *  Function:  This program provides functionality for call to   *
      *             Midas Plus Coarse-grained APIs                    *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD023747           Date 23Nov13               *
      *                 CBF006             Date 04Jul11               *
      *                 XXXXXX             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD023747 - HTTP call failure (Recompile due to CGL135        *
      *             changes)                                          *
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
      ** GLOBAL work fields
      *---------------------------------------------------------------------------------------
      *
     D errorElem       S             30A   dim(2) ctdata
     D warnElem        S             30A   dim(2) ctdata
     D overElem        S             30A   dim(3) ctdata
     D systElem        S             30A   dim(1) ctdata
      *
      *---------------------------------------------------------------------------------------
      *  GLOBAL data structure
      *---------------------------------------------------------------------------------------
      *
      *  Error Messages
      *
     D errorMessage    DS
     D   values                     200A   dim(10) varying
      *
      *  Collection of all Midas Error Messages
      *
     D midasErrs       DS                  likeDS(midasErrors) inz
     D midasWarns      DS                  likeDS(midasWarnings) inz
     D overErrs        DS                  likeDS(overErrors) inz
     D systemErrs      DS                  likeDS(systemErrors) inz
      *
      *---------------------------------------------------------------------------------------
      *  PROTOTYPE
      *---------------------------------------------------------------------------------------
     D/COPY BFCPYSRC,BF000007
     D/COPY BFCPYSRC,BF000006
     D/COPY BFCPYSRC,BF000005
      *
      *  Call back for the API web service - http_url_post_raw()
      *
     D srCallBack      PR                  like(WEB_INT)
     D  pDescriptor                        like(WEB_INT) value
     D  pData                          *   value
     D  pDataLen                           like(WEB_INT) value
      *
      *  Extract the Midas errors returned from the API call
      *
     D getMidasErrors  PR
     D  pData                     32767A   value varying
     D  pErrorType                   30A   value varying
     D  pErrorGroup                  30A   value varying
     D  pErrorCount                  10I 0
     D  pErrorMsg                          likeDS(errorMessage)
     D                                     dim(MAX_MSGS)
      *
      /EJECT
      **********************************************************************
      *                                                                    *
      *  MPlusAPICoarse - Call a Midas Plus Coarse-grained API             *
      *                                                                    *
      **********************************************************************
      *
     P MPlusAPICoarse  B                   EXPORT
      *
     D                 PI                  like(WEB_INT)
     D  pIpAddress                         like(WEB_NAME) value
     D  pZone                              like(WEB_NAME) value
     D  pApiName                           like(WEB_NAME) value
     D  pApiAction                         like(WEB_NAME) value
     D  pSoapBody                          like(WEB_STRVAR) value
     D  pMidasErrs                         likeDS(midasErrors)
     D  pMidasWarns                        likeDS(midasWarnings)
     D  pOverErrs                          likeDS(overErrors)
     D  pSystemErrs                        likeDS(systemErrors)
      *
      ** Work fields
      *
     D wUrl            S                   like(WEB_STRVAR)
     D wSoap           S                   like(WEB_STRVAR)
     D wRc             S                   like(WEB_INT)
      *
      /free
 
       // *********************************************************
       //  Build the URL
       // *********************************************************
 
               wUrl = 'http://' + %trim(pIpAddress) +
                      '/frwksoapapi/servlet/rpcrouter';
 
       // *********************************************************
       //  Build the SOAP Message
       // *********************************************************
 
          // Start Tag - SOAP Header
               wSoap =
                     '<SOAP-ENV:Envelope xmlns:SOAP-ENV='
                   + '"http://schemas.xmlsoap.org/soap/envelope/" '
                   + 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
                   + 'xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
 
          // Start Tag - SOAP Body
               wSoap = wSoap + '<SOAP-ENV:Body>';
 
          // Start Tag - midasActionAPI
               wSoap = wSoap
                   + '<ns1:midasActionAPI '
                   + 'xmlns:ns1='
                   + '"http://tempuri.org/com.misys.midas.soapapi.'
                   + 'MidasActionAPISoapHandler" '
                   + 'SOAP-ENV:encodingStyle='
                   + '"http://schemas.xmlsoap.org/soap/encoding/">';
 
          // Tag - apiNames
               wSoap = wSoap
                   + '<apiNames xsi:type="xsd:string">'
                   + %trim(pApiAction)
                   + '</apiNames>';
 
          // Tag - zone
               wSoap = wSoap
                   + '<zone xsi:type="xsd:string">'
                   + %trim(pZone)
                   + '</zone>';
 
          // Tag - xml
               wSoap = wSoap
                   + '<xml xsi:type="xsd:string">'
                   + '&lt;midasActionAPI&gt;'
                   + '&lt;' + %trim(pApiName) + '&gt;'
                   + %trim(pSoapBody)
                   + '&lt;/' + %trim(pApiName) + '&gt;'
                   + '&lt;/midasActionAPI&gt;'
                   + '</xml>';
 
          // Tag - returnFormat
               wSoap = wSoap
                   + '<returnFormat xsi:type="xsd:int">'
                   + '0'
                   + '</returnFormat>';
 
          // End Tag - midasActionAPI
               wSoap = wSoap + '</ns1:midasActionAPI>';
 
          // End Tag - SOAP Body
               wSoap = wSoap + '</SOAP-ENV:Body>';
 
          // End Tag - SOAP Header
               wSoap = wSoap + '</SOAP-ENV:Envelope>';
 
       // *********************************************************
       //  Call the Web Service
       // *********************************************************
 
               wRc = WebServiceRaw(wUrl
                                 : wSoap
                                 : 'midasActionAPI'
                                 : %paddr(srCallBack)
                                 );
 
          // If HTTP Error returned, retrieve the last error that occured
               if wRc <> 1;
                    systemErrs.sCount = 1;
                    systemErrs.systemErr(1).sDescription = http_error;
               endif;
 
       // *********************************************************
       //  Return the error messages retrieved
       // *********************************************************
 
               pMidasErrs = midasErrs;
               pMidasWarns = midasWarns;
               pOverErrs = overErrs;
               pSystemErrs = systemErrs;
 
          // Return the status of the web service
               return  wRc;
 
      /end-free
     P                 E
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  getOldSoapParm - Get the SOAP Parameter for the Old SOAP     *
      *                                                               *
      *****************************************************************
      *
     P getOldSoapParm  B                   EXPORT
      *
     D                 PI                  like(WEB_STRVAR)
     D  pEntity                            like(WEB_ENTITY) value
     D  pValue                             like(WEB_VALUE) value
      *
      ** Work fields
      *
     D wSoap           S                   like(WEB_STRVAR)
      *
      /free
 
       // *********************************************************
       //  Setup the XML string
       // *********************************************************
 
               wSoap = '&lt;' + %trim(pEntity) + '&gt;'
                     + %trim(pValue)
                     + '&lt;/' + %trim(pEntity) + '&gt;';
 
               return wSoap;
 
      /end-free
      *
     P                 E
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  srCallBack - Call back for the API web service -             *
      *               http_url_post_raw()                             *
      *                                                               *
      *****************************************************************
      *
     P srCallBack      B
      *
     D                 PI                  like(WEB_INT)
     D  pDescriptor                        like(WEB_INT) value
     D  pData                          *   value
     D  pDataLen                           like(WEB_INT) value
      *
      ** Work fields
      *
     D wData           S          32767A
     D wX              S             10I 0
     D wCount          S             10I 0
     D wErrors         DS                  likeDS(errorMessage)
     D                                     dim(MAX_MSGS)
      *
      /free
 
       // *********************************************************
       //  Convert the response data from the job ccsid to UTF-8
       // *********************************************************
 
               toCCSID.CCSID = 0;
               fromCCSID.CCSID = 1208;
               iconv_t = initCCSID(toCCSID:fromCCSID);
 
               if iconv_t.return_Value = -1;
               endif;
 
               wData = cvtCCSID(iconv_t:pData:pDatalen);
 
       // *********************************************************
       //  Replace special characters
       // *********************************************************
 
               wData = StrSubstitute(wData : '&lt;' : '<');
               wData = StrSubstitute(wData : '&gt;' : '>');
               wData = StrSubstitute(wData : '&apos;' : '''');
 
       // *********************************************************
       //  Extract Midas errors
       // *********************************************************
 
          // Midas Error Messages
               clear wErrors;
               getMidasErrors(wData: 'errors': 'error': wCount: wErrors);
 
               midasErrs.eCount = wCount;
               for wX = 1 to wCount;
                   midasErrs.midasErr(wX).eFldName = wErrors(wX).values(1);
                   midasErrs.midasErr(wX).eDescription = wErrors(wX).values(2);
               endfor;
 
          // Midas Warning Messages
               clear wErrors;
               getMidasErrors(wData: 'warnings': 'warning': wCount: wErrors);
 
               midasWarns.wnCount = wCount;
               for wX = 1 to wCount;
                   midasWarns.midasWarn(wX).wFldName = wErrors(wX).values(1);
                   midasWarns.midasWarn(wX).wDescription =wErrors(wX).values(2);
               endfor;
 
          // Midas Overrridable Error Messages
               clear wErrors;
               getMidasErrors(wData: 'overridableErrors': 'overridableError':
                              wCount: wErrors);
 
               overErrs.oCount = wCount;
               for wX = 1 to wCount;
                   overErrs.overErr(wX).oFldName = wErrors(wX).values(1);
                   overErrs.overErr(wX).oDescription = wErrors(wX).values(2);
                   overErrs.overErr(wX).isOveridden = wErrors(wX).values(3);
               endfor;
 
          // Midas System Error Messages
               clear wErrors;
               getMidasErrors(wData: 'systemErrors': 'systemError':
                              wCount: wErrors);
 
               systemErrs.sCount = wCount;
               for wX = 1 to wCount;
                   systemErrs.systemErr(wX).sDescription =wErrors(wX).values(1);
               endfor;
 
               return pDataLen;
 
      /end-free
      *
     P                 E
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  getMidasErrors - Extract the Midas errors returned from the  *
      *                   API call                                    *
      *                                                               *
      *****************************************************************
      *
     P getMidasErrors  B
      *
     D                 PI
     D  pData                     32767A   value varying
     D  pErrorType                   30A   value varying
     D  pErrorGroup                  30A   value varying
     D  pErrorCount                  10I 0
     D  pErrorMsg                          likeDS(errorMessage)
     D                                     dim(MAX_MSGS)
      *
      ** Work fields
      *
     D wTags           S             30A   dim(10) varying
     D wIndex          S             10I 0
     D wX              S             10I 0
     D wPos            S             10I 0
     D wPos1           S             10I 0
     D wStrMainTag     S             30A   varying
     D wEndMainTag     S             30A   varying
     D wStrGrpTag      S             30A   varying
     D wStrFldTag      S             30A   varying
     D wEndFldTag      S             30A   varying
     D wStrMainPos     S             10I 0
     D wEndMainPos     S             10I 0
      *
      /free
 
       // ****************************************************************
       //  Midas errors part of the Response data has the following format
       //       <errors>
       //            <error>
       //                 <name></name>
       //                 <description></description>
       //            </error>
       //            .........
       //       </errors>
       //       <warnings>
       //            <warning>
       //                 <name></name>
       //                 <description></description>
       //            </warning>
       //            ..........
       //       </warnings>
       //       <overridableErrors>
       //            <overridableError>
       //                 <name></name>
       //                 <description></description>
       //                 <isOveridden></isOveridden>
       //            </overridableError>
       //            ...................
       //       </overridableErrors>
       //       <systemErrors>
       //            <systemError>
       //                 <description></description>
       //            </systemError>
       //            ..............
       //       </systemErrors>
       // *********************************************************
 
       // Get the appropriate Tag elements (depending on the error type)
              select;
                  when %trim(pErrorType) = 'errors';
                       wTags = errorElem;
                  when %trim(pErrorType) = 'warnings';
                       wTags = warnElem;
                  when %trim(pErrorType) = 'overridableErrors';
                       wTags = overElem;
                  when %trim(pErrorType) = 'systemErrors';
                       wTags = systElem;
              endsl;
 
              wIndex = 0;
 
       // Start of Main Tag (ie. '<errors>')
       // End of Main Tag (ie. '</errors>')
       // Start of Group Tag (ie. '<error>')
              wStrMainTag = '<' + %trim(pErrorType) + '>';
              wEndMainTag = '</' + %trim(pErrorType) + '>';
              wStrGrpTag = '<' + %trim(pErrorGroup) + '>';
              wStrMainPos = %scan(wStrMainTag: pData: 1);
              wEndMainPos = %scan(wEndMainTag: pData: 1);
 
              if (wStrMainPos>0 and wEndMainPos>0);
                  wPos = wStrMainPos;
 
                  // Process all the errors within the Main Tag
                  dou (wPos=0 or wPos>wEndMainPos);
                      wPos = %scan(wStrGrpTag: pData: wPos);
 
                      if (wPos>0 and wPos<wEndMainPos);
 
                          // Process all the elements within the Group Tag
                          wX = 1;
                          wIndex = wIndex + 1;
                          dow %trim(wTags(wX)) <> '';
                              // Start of Element
                              if (wPos>0 and wPos<wEndMainPos);
                                  wStrFldTag = '<' + %trim(wTags(wX)) + '>';
                                  wPos = %scan(wStrFldTag: pData: wPos);
                              endif;
                              // End of Element
                              if (wPos>0 and wPos<wEndMainPos);
                                  wPos1 = wpos + %len(wStrFldTag);
                                  wEndFldTag = '</' + %trim(wTags(wX)) + '>';
                                  wPos = %scan(wEndFldTag: pData: wPos);
                              endif;
                              // Value of the Element
                              if (wPos>0 and wPos<wEndMainPos);
                                  pErrorMsg(wIndex).values(wX) =
                                                %subst(pData:wPos1: wPos-wPos1);
                              endif;
                              wX = wX + 1;
                          enddo;
 
                      endif;
 
                  enddo;
              endif;
 
              pErrorCount = wIndex;
 
      /end-free
      *
     P                 E
** errorElem - Errors
name
description
** warnElem - Warnings
name
description
** overElem - Overridable Errors
name
description
isOveridden
** systElem - System Errors
description
