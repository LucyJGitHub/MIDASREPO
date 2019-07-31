      *****************************************************************
     H DEBUG
     H BNDDIR('HTTPAPI')
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  DFTACTGRP(*NO)                                               *
/*EXI *  TEXT('Midas SC Caching of Feature')                          *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000351 - Midas SC Caching of Feature                       *
      *                                                               *
      *  Function:  This program will call the URL to Cache the       *
      *             Features in Java using REST HTTPAPI.              *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. CSW219 *CREATE     Date 04Mar19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW219 - SWIFT Changes 2019                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      *  SrGetUserPass - Get User and Password by calling JAVA        *
      *  SrProcess - Process All URLs                                 *
      *  SrHTTP    - Call URL via REST HTTPAPI                        *
      *  SrPrint   - Print Error Report                               *
      *  SrArrError- Array to contain the Error Code and Description  *
      *              that will appear in the report                   *
      *  SrArrURL  - Array to contain the URLs that will appear in the*
      *              report                                           *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      **
     FSCIPADPD  IF   E             DISK
      ** Midas SC IP Address for URL Caching
     FSC000351AUO    E             PRINTER INFDS(SPoolU)USROPN
      ** Midas SC Caching of Feature Error Report - Audit
      *
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D/copy qrpglesrc,HTTPAPI_H
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      *
     DPSDS            SDS
      **  Exception type.
     D PSExcpType             40     42
      **  Exception number.
     D PSExcpNo               43     46
      ** Job name.
     D PSJobName             244    253
      ** User name.
     D PSUser                254    263
      *
      ** +--------------------------------------+
      ** ¦ Program Prototypes                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Prototype for a Java String object
     D crtString       PR              O   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             *CONSTRUCTOR)
     D   value                       50A   CONST VARYING
      *
      ** Prototype for java string's getBytes method
     D cvtToBytes      PR          9999A   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             'getBytes')
     D                                     VARYING
      *
      ** Create UserPassword object field
     D UsPwClassObj    S               O   CLASS(*JAVA:
     D                                     'com.misys.midas.bankfusion.+
     D                                     swift.SwiftUtil')
      *
      ** Prototype for UserPasswrod object creation (instantiation)
     D crtUsPwClass    PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.bankfusion.+
     D                                     swift.SwiftUtil':
     D                                     *CONSTRUCTOR)
      *
      ** Prototype for UserPassword class 'getUsPw' method
     D getUsPw         PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.bankfusion.+
     D                                     swift.SwiftUtil':
     D                                     'getMidasInterfaceUserId')
     D                                     CLASS(*JAVA:'java.lang.String')
     D zonePrefix                      O   CLASS(*JAVA:'java.lang.String')
     D                                     CONST
      *
      ** Create string objects
     D Parm1           S               O   CLASS(*JAVA:'java.lang.String')
     D WRcvUsPw        S               O   CLASS(*JAVA:'java.lang.String')
      *
     D WCvUsPw         S            999A   VARYING
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D Ar_IPAdd        S            256A   DIM(50)
     D Ar_Msg          S             80A   DIM(50)
     D Ar_RC           S             10I 0 DIM(50)
      *
      ** File Information Data Structure for SC000351AU.
     DSpoolU           DS
     DSFileU                  83     92
     DSFNumU                 123    124B 0
     DOflLnU                 188    189B 0
     DPrtLnU                 367    368B 0
      *
     D SDBank        E DS                  EXTNAME(SDBankpd)
      *
      ** First DS for Access programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D rc              S             10I 0
     D URL             S            256A
     D debugLog        S           1000A   VARYING
     D msg             S             80A
      *
     D WRun            S              1A
      *
      ** ZSFILE Parameters
     D PSeq            S              5A
     D PSEnty          S              3A
     D PZFile          S             10A
     D PZSerr          S              1A
     D PZSNum          S              6  0
      *
      ** System Value Parameter
     D PRetCode        S              7A
     D POP01           S             20A
     D PVL01           S            200A
     D POP02           S             20A
     D PVL02           S            200A
     D POP03           S             20A
     D PVL03           S            200A
     D POP04           S             20A
     D PVL04           S            200A
     D POP05           S             20A
     D PVL05           S            200A
     D POP06           S             20A
     D PVL06           S            200A
     D POP07           S             20A
     D PVL07           S            200A
     D POP08           S             20A
     D PVL08           S            200A
     D POP09           S             20A
     D PVL09           S            200A
     D POP10           S             20A
     D PVL10           S            200A
      *
     D POption         S              7A
      *
     D Ax              S              2S 0
     D i               S              2S 0
     D Failure         S              1A
     D s1              S            100A
     D s2              S            100A
     D s3              S            100A
     D WZone           S             10A
     D ArFill          S              1A
     D Response        S            100A
      *
     D WFirst          S              1A
     D Idx             S              2  0
     D Pos             S              3S 0
     D Len             S              3S 0
     D userName        S             50A
     D passWord        S            128A
     D PZonePfx        S              2A
      *
      /EJECT
      *****************************************************************
      * MAIN - Processing
      *****************************************************************
      *
     C                   EXSR      SrGetUserPass
     C                   EXSR      SrProcess
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetUserPass - Get User and Password by calling JAVA        *
      *                                                               *
      *****************************************************************
     C     SrGetUserPass BEGSR
      *
      ** Create/Instantiate 'UsPwClass' java object (one time only)
      ** so as to access its 'getUsPw' method later
      *
     C                   IF        WFirst = 'Y'
     C                   EVAL      UsPwClassObj = crtUsPwClass()
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
      *
     C                   EVAL      Parm1 = crtString(PZonePfx)
      *
      ** Invoke the retrieve UserPassword method of the UsPwClass
      ** object
      *
     C                   EVAL      WRcvUsPw = getUsPw(UsPwClassObj:
     C                                                Parm1)
      *
      ** Convert the received java string to RPG bytes
      *  (Varying alpha field)
      *
     C                   EVAL      WCvUsPw = *BLANKS
     C                   EVAL      WCvUsPw = cvtToBytes(WRcvUsPw)
      *
      ** Retrieve field from received string via substring function
      *
     C                   IF        WCvUsPw <> ' '
     C                   EVAL      Pos = %SCAN(' ':WCvUsPw:1)
     C                   EVAL      Len = %LEN(%TRIM(WCvUsPw))
     C                   EVAL      userName = %SUBST(WCvUsPw:1:Pos - 1)
     C                   EVAL      passWord = %SUBST(WCvUsPw:Pos + 1:Len - Pos)
      *
     C                   ELSE
      *
      ** User and Password cannot be blank
      *
     C                   EVAL      DBase = 3
     C                   EVAL      DBKey = 'User/Password is blank.'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcess - Process All URLs                                 *
      *                                                               *
      *****************************************************************
     C     SrProcess     BEGSR
      *
     C     1             SETLL     SCIPADPD
     C                   READ      SCIPADPD
      *
     C                   DOW       NOT%EOF(SCIPADPD)
     C                   EXSR      SrHTTP
     C                   READ      SCIPADPD
     C                   ENDDO
      *
      ** If 1 of the URLs fails, produce an error report
      *
     C                   IF        Failure = 'Y'
     C                   EXSR      SrPrint
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrHTTP - Call URL via REST HTTPAPI                           *
      *                                                               *
      *****************************************************************
     C     SrHTTP        BEGSR
      /free
       // Write a Debug log out to the IFS.
        debugLog = '/RestWeb/dbg_' + %trim(SIPADD) + '.txt';
        http_debug(*on : debugLog);

       // Basic authentication.
                   http_setAuth( HTTP_AUTH_BASIC
                               : %trim(userName)
                               : %trim(passWord));
       // Setup URL.
                   Clear URL;
                   s1 = 'http://';
                   s2 = '/frwksoapapi/refreshcache?zone=';
                   s3 = '&switchablefeaturecache=y';
                   Response = '/RestWeb/rsp_' + %trim(SIPADD) + '.txt';
                   URL = %trim(s1) + %trim(SIPADD)+ %trim(s2) + %trim(wZone)+
                         %trim(s3);

       // Get request.
                   rc = http_url_get(URL : Response);
                   msg = http_error;
                   if msg = *blanks and rc <> 1;
                   msg = 'A remote host''s port cannot establish a connection.';
                   endif;

       // Initialise variables.
                   i = 0;
                   ArFill = ' ';

                   if rc <> 1;

        // If failure is encountered retry 1 time.
                     for i = 1 to 1;
                        if ArFill = ' ';
                          Ax = Ax + 1 ;
                          Ar_IPAdd(Ax) = %TRIM(URL);
                          Ar_Msg(Ax) = msg;
                          Ar_RC(Ax) = rc;
                          ArFill = 'Y';
                        endif;

       // Retry Request.
                        rc = http_url_get(URL : Response);
                        if rc = 1 ;
                          Ar_IPAdd(Ax) = *blanks;
                          Ar_Msg(Ax) = *blanks;
                          Ar_RC(Ax) = 0;
                          Ax = Ax - 1;
                          leave;
                        endif;
                     endfor;
                   endif;

                   if Failure = ' ';
                     if i > 1;
                       Failure = 'Y';
                     endif;
                   endif;
      /end-free
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrint - Print Error Report                                 *
      *                                                               *
      *****************************************************************
     C     SrPrint       BEGSR
      *
      ** Open printer file
      *
     C                   OPEN      SC000351AU
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   EVAL      PZSNum = SFNumU
     C                   EVAL      PZFile = SFileU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PSEnty
     C                   PARM                    PZFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSerr
      *
      ** If error occurs during ZSFILE processing, then return to the
      ** calling program.
      *
     C                   IF        PZSerr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   EVAL      RURL = URL
     C                   WRITE     HeadAu
     C                   WRITE     Detail1
     C                   EXSR      SrArrError
     C                   WRITE     Detail2
     C                   EXSR      SrArrURL
     C                   WRITE     Detail4
     C                   WRITE     EndRept
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrArrError -  Array to contain the Error Code and Description*
      *                that will appear in the report                 *
      *                                                               *
      *****************************************************************
     C     SrArrError    BEGSR
      *
     C                   EVAL      Ax = 1
     C                   DOW       Ar_MSG(Ax) <> *BLANKS
     C                   CLEAR                   RDESC1
     C                   EVAL      RDESC1 = %TRIM(Ar_MSG(Ax)) + '(code:' +
     C                             %CHAR(Ar_RC(Ax))+ ')'
     C                   WRITE     Detail1A
     C                   EVAL      Ax = Ax + 1
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrArrURL -  Array to contain the URLs that will appear in    *
      *              the report                                       *
      *                                                               *
      *****************************************************************
     C     SrArrURL      BEGSR
      *
     C                   EVAL      Ax = 1
     C                   DOW       Ar_IPAdd(Ax) <> *BLANKS
     C                   CLEAR                   RURL
     C                   EVAL      RURL = Ar_IPAdd(Ax)
     C                   WRITE     Detail3
     C                   EVAL      Ax = Ax + 1
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PZonePfx
      *
      ** Prepare LDA.
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SC000351'
     C                   OUT       LDA
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBank        PARM      SDBank        DSFDY
      *
      ** Handle Database Error.
      *
     C                   IF        PRetcode <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      POP01 = 'ZoneSystemName'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    POP01
     C                   PARM      *BLANKS       PVL01
     C                   PARM      *BLANKS       POP02
     C                   PARM      *BLANKS       PVL02
     C                   PARM      *BLANKS       POP03
     C                   PARM      *BLANKS       PVL03
     C                   PARM      *BLANKS       POP04
     C                   PARM      *BLANKS       PVL04
     C                   PARM      *BLANKS       POP05
     C                   PARM      *BLANKS       PVL05
     C                   PARM      *BLANKS       POP06
     C                   PARM      *BLANKS       PVL06
     C                   PARM      *BLANKS       POP07
     C                   PARM      *BLANKS       PVL07
     C                   PARM      *BLANKS       POP08
     C                   PARM      *BLANKS       PVL08
     C                   PARM      *BLANKS       POP09
     C                   PARM      *BLANKS       PVL09
     C                   PARM      *BLANKS       POP10
     C                   PARM      *BLANKS       PVL10
      *
     C                   IF        PRetCode <>  *BLANKS
     C                   EVAL      DBKey = POP01
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 2
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      wZone = %TRIM(PVL01)
      *
     C                   EVAL      Failure = *BLANKS
     C                   EVAL      WFirst = 'Y'
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically If a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Password should not be shown in dump.
      *
     C                   IF        passWord <> *BLANKS
     C                   CLEAR                   passWord
     C                   EVAL      passWord = '******'
     C                   ENDIF
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
