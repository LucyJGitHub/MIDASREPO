     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC PEA Transfer Transaction data')               *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000116 - PEA Transfer Transaction data                     *
      *                                                               *
      *  Function:  This program processes messages to be transferred *
      *             between the PEA and the LIVE system through       *
      *             Websphere MQ server connection.                   *
      *                                                               *
      *  Calls - Java MQ Client methods: sndMessage                   *
      *          AOSVALR0                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1043780          Date 07Feb13               *
      *  Prev Amend No. AR1034553          Date 16Oct12               *
      *                 AR995693           Date 27Jun12               *
      *                 AR992769           Date 22Jun12               *
      *                 CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1043780 - PEA need to have stronger monitoring if MQ       *
      *              channel or manager is not running. Better        *
      *              message logging to warn the user with the reason *
      *              of failure. (Child:AR1043782)                    *
      *  AR1034553 - JOB PEACLOSE DOES not complete correctly         *
      *              (Child:AR1034555)                                *
      *  AR995693 - Corrective batch inserted in PEA system did not   *
      *             transfer to the Live system after COB in PEA      *
      *  AR992769 - No class definition found for PEATransaction      *
      *              Playback                                         *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Constant to hold input parameter for AOSVALR0.
 
     D JavaPath        C                   Const('JavaPathStem')
     D JavaHome        C                   Const('JavaHome')                                AR992769
     D*Path1****       C                   Const('/com.ibm.mq.jar')                AR992769 AR995693
     D*Path2****       C                   Const('/commons-logging-1.1.1.jar')     AR992769 AR995693
     D*Path3****       C                   Const('/dom4j-1.6.1.jar')               AR992769 AR995693
     D*Path4****       C                   Const('/midaslogger.jar')               AR992769 AR995693
     D*Path5****       C                   Const('/spring-2.5.6.jar')              AR992769 AR995693
     D*Path6****       C                   Const('/frwkdataaccess.jar')            AR992769 AR995693
 
      ** Array for Path declaration                                                         AR995693
                                                                                            AR995693
     D*PathArr**       S             50    DIM(27) CTDATA PERRCD(1)               AR995693 AR1034553
     D*PathArr**       S             50    DIM(38) CTDATA PERRCD(1)              AR1034553 AR1043780
     D PathArr         S             50    DIM(39) CTDATA PERRCD(1)                        AR1043780
                                                                                            AR995693
      ** Prototype Java methods to be called
 
     D SendMsg         PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.midasplus.logger.ut-
     D                                     il.PEATransactionPlayback':
     D                                     'send')
     D                                     CLASS(*JAVA:
     D                                      'java.lang.String')
     D                                     STATIC
     D GetError        PR            10A   VARYING
     D                                     EXTPROC(*JAVA:
     D                                     'java.lang.String':
     D                                     'getBytes')
 
      ** Prototype Definition for setting classpath
 
     D PutEnv          PR            10I 0 EXTPROC('putenv')
     D  pEnv                           *   VALUE OPTIONS(*STRING)
 
     D GetEnv          PR              *   EXTPROC('getenv')
     D  gEnv                           *   VALUE OPTIONS(*STRING)
 
     D WPtr            S               *
     D WStr            S           1024A   BASED(WPtr)
 
      ** MQ Connection parameters
 
     D retmsg          S               O   CLASS(*JAVA:
     D                                      'java.lang.String')
 
      ** Parameter variables
 
     D PRetCode        S             10A
     D PrtCd           S              7A
     D PSysVal01       S             20A
     D PCurSet01       S            200A
     D PSysVal02       S             20A
     D PCurSet02       S            200A
     D PSysVal03       S             20A
     D PCurSet03       S            200A
     D PSysVal04       S             20A
     D PCurSet04       S            200A
     D PSysVal05       S             20A
     D PCurSet05       S            200A
     D PSysVal06       S             20A
     D PCurSet06       S            200A
     D PSysVal07       S             20A
     D PCurSet07       S            200A
     D PSysVal08       S             20A
     D PCurSet08       S            200A
     D PSysVal09       S             20A
     D PCurSet09       S            200A
     D PSysVal10       S             20A
     D PCurSet10       S            200A
 
      ** Work Variables
 
     D WRetCode        S             10I 0
     D WPath           S            200A
     D WSavPath        S           1024A
     D WNewPath        S           1024A
     D WHome           S            200A                                                    AR992769
     D WSavHome        S           1024A                                                    AR992769
     D WNewHome        S           1024A                                                    AR992769
     D ix              S              2P 0                                                  AR995693
                                                                                            AR992769
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Save and Set CLASSPATH environment variable.
      ** and JAVA_HOME variable                                                             AR992769
 
     C                   EXSR      SRSetCPath
     C                   EXSR      SRSetJHome                                               AR992769
 
      ** Start processing of data.
 
     C                   EXSR      SRProcess
 
      ** Restore CLASSPATH enviroment variable.
      ** and JAVA_HOME variable                                                             AR992769
 
     C                   EXSR      SRRstCPath
     C                   EXSR      SRRstJHome                                               AR992769
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Initialisation                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRetCode
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      JavaPath      PSysVal01
     C                   PARM                    PCurSet01
     C**********         PARM                    PSysVal02                                  AR992769
     C                   PARM      JavaHome      PSysVal02                                  AR992769
     C                   PARM                    PCurSet02
     C                   PARM                    PSysVal03
     C                   PARM                    PCurSet03
     C                   PARM                    PSysVal04
     C                   PARM                    PCurSet04
     C                   PARM                    PSysVal05
     C                   PARM                    PCurSet05
     C                   PARM                    PSysVal06
     C                   PARM                    PCurSet06
     C                   PARM                    PSysVal07
     C                   PARM                    PCurSet07
     C                   PARM                    PSysVal08
     C                   PARM                    PCurSet08
     C                   PARM                    PSysVal09
     C                   PARM                    PCurSet09
     C                   PARM                    PSysVal10
     C                   PARM                    PCurSet10
 
     C                   IF        PrtCd   = *BLANKS
     C                             AND PCurSet01 <> *BLANKS
     C                             AND PCurSet02 <> *BLANKS                                 AR992769
     C                   EVAL      WPath   = PCurSet01
     C                   EVAL      WHome   = PCurSet02                                      AR992769
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Process Transfer PEA data to LIVE                           *
      *                                                              *
      ****************************************************************
     C     SRProcess     BEGSR
 
      ** Call SendMessage to transfer the data to destination system
 
     C                   EVAL      retmsg   = SendMsg()
     C                   EVAL      PRetCode = GetError(retmsg)
 
     C                   IF        PRetCode <> *BLANKS
 
     C                   EXSR      SRRstCPath
     C                   EXSR      SRRstJHome                                               AR992769
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Set Classpath from System values                            *
      *                                                              *
      ****************************************************************
     C     SRSetCPath    BEGSR
 
     C                   EVAL      WPtr     = GetEnv('CLASSPATH')
     C                   EVAL      WSavPath = WStr
 
     C**********         EVAL      WNewPath = 'CLASSPATH='                                  AR995693
     C**********                              + %TRIMR(WPath)                               AR995693
     C**********                              + '/lib/ext'                                  AR995693
     C**********                              + Path1 + ':'                        AR992769 AR995693
     C**********                              + %TRIMR(WPath)                      AR992769 AR995693
     C**********                              + '/lib/ext'                         AR992769 AR995693
     C**********                              + Path2 + ':'                        AR992769 AR995693
     C**********                              + %TRIMR(WPath)                      AR992769 AR995693
     C**********                              + '/lib/ext'                         AR992769 AR995693
     C**********                              + Path3 + ':'                        AR992769 AR995693
     C**********                              + %TRIMR(WPath)                      AR992769 AR995693
     C**********                              + '/lib/ext'                         AR992769 AR995693
     C**********                              + Path4 + ':'                        AR992769 AR995693
     C**********                              + %TRIMR(WPath)                      AR992769 AR995693
     C**********                              + '/lib/ext'                         AR992769 AR995693
     C**********                              + Path5 + ':'                        AR992769 AR995693
     C**********                              + %TRIMR(WPath)                      AR992769 AR995693
     C**********                              + '/lib/ext'                         AR992769 AR995693
     C**********                              + Path6                              AR992769 AR995693
     C                   EVAL      WNewPath = 'CLASSPATH=PEAS'                              AR995693
                                                                                            AR995693
     C                   FOR       ix       = 1 TO %ELEM(PathArr)                           AR995693
     C                   EVAL      WNewPath = %TRIMR(WNewPath)                              AR995693
     C                                      + ':PEA/'                                       AR995693
     C                                      + PathArr(ix)                                   AR995693
     C                   ENDFOR                                                             AR995693
                                                                                            AR995693
     C                   EVAL      WRetCode = PutEnv(%TRIM(WNewPath))
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Restore original CLASSPATH setting                          *
      *                                                              *
      ****************************************************************
     C     SRRstCPath    BEGSR
 
     C                   EVAL      WNewPath = 'CLASSPATH='
     C                                        + %TRIMR(WSavPath)
     C                   EVAL      WRetCode = PutEnv(%TRIM(WNewPath))
 
     C                   ENDSR
      ****************************************************************                      AR992769
      /EJECT                                                                                AR992769
      ****************************************************************                      AR992769
      *                                                              *                      AR992769
      *  Set Java_Home from System Values                            *                      AR992769
      *                                                              *                      AR992769
      ****************************************************************                      AR992769
     C     SRSetJHome    BEGSR                                                              AR992769
                                                                                            AR992769
     C                   EVAL      WPtr     = GetEnv('JAVA_HOME')                           AR992769
     C                   EVAL      WSavHome = WStr                                          AR992769
                                                                                            AR992769
     C                   EVAL      WNewHome = 'JAVA_HOME='                                  AR992769
     C                                        + %TRIMR(WHome)                               AR992769
     C                   EVAL      WRetCode = PutEnv(%TRIM(WNewHome))                       AR992769
                                                                                            AR992769
     C                   ENDSR                                                              AR992769
      ****************************************************************                      AR992769
      /EJECT                                                                                AR992769
      ****************************************************************                      AR992769
      *                                                              *                      AR992769
      *  Restore original JAVA_HOME setting                          *                      AR992769
      *                                                              *                      AR992769
      ****************************************************************                      AR992769
     C     SRRstJHome    BEGSR                                                              AR992769
                                                                                            AR992769
     C                   EVAL      WNewHome = 'JAVA_HOME='                                  AR992769
     C                                        + %TRIMR(WSavHome)                            AR992769
     C                   EVAL      WRetCode = PutEnv(%TRIM(WNewHome))                       AR992769
                                                                                            AR992769
     C                   ENDSR                                                              AR992769
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
     C                   ENDSR
** PathArr                                                                                  AR995693
bfmfcjava.jar                                                                              AR1043780
com.ibm.mq.jar                                                                              AR995693
commons-logging-1.1.1.jar                                                                   AR995693
dom4j-1.6.1.jar                                                                             AR995693
midaslogger.jar                                                                             AR995693
spring-2.5.6.jar                                                                            AR995693
persistence.jar                                                                             AR995693
j2ee.jar                                                                                    AR995693
frwkdataaccess.jar                                                                          AR995693
frwkapi.jar                                                                                 AR995693
frwkapidef.jar                                                                              AR995693
frwkdataview.jar                                                                            AR995693
frwkjavaext.jar                                                                             AR995693
frwkmessagestore.jar                                                                        AR995693
midasplus.jar                                                                               AR995693
mqseriesplugin.jar                                                                          AR995693
jt400.jar                                                                                   AR995693
jaxb-api.jar                                                                                AR995693
jaxb-impl.jar                                                                               AR995693
frwkdtd.jar                                                                                 AR995693
jaxb-libs.jar                                                                               AR995693
jaxb-xjc.jar                                                                                AR995693
activation.jar                                                                              AR995693
relaxngDatatype.jar                                                                         AR995693
xsdlib.jar                                                                                  AR995693
midaspluspasswordutility.jar                                                                AR995693
bfj220.jar                                                                                  AR995693
xercesImpl.jar                                                                              AR995693
com.ibm.ws.runtime.jar                                                                     AR1034553
com.ibm.mq.jmqi.jar                                                                        AR1034553
com.ibm.mq.jmqi.system.jar                                                                 AR1034553
com.ibm.mq.commonservices.jar                                                              AR1034553
com.ibm.mq.headers.jar                                                                     AR1034553
com.ibm.mq.connector.jar                                                                   AR1034553
com.ibm.mq.jmqi.local.jar                                                                  AR1034553
com.ibm.mq.jmqi.remote.jar                                                                 AR1034553
com.ibm.mq.jms.admin.jar                                                                   AR1034553
com.ibm.mq.pcf.jar                                                                         AR1034553
com.ibm.mqjms.jar                                                                          AR1034553
