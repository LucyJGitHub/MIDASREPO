     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FN Repn. Send a msgs to an API MQ queue')        *
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  A1008009  - Midas FN Repn. Send a msgs to an API MQ queue    *
      *                                                               *
      *  Function:  This module:                                      *
      *             - reads messages from a Transmission queue        *
      *             - determines if additional processing is needed   *
      *             - calls the specified program if necessary        *
      *             - forwards the message to the queue if not        *
      *                                                               *
      *  Calls by:  A1008002 , A1008008                               *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD062029           Date 20Mar24               *
      *  Prev Amend No. MD059522           Date 07Feb22               *
      *                 BA1008   *CREATE   Date 03Jun21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062029 - Trades replication does not work since password   *
      *             change to 12 charaters.                           *
      *             Alter password field length to accept 128-char    *
      *             passwords.                                        *
      *  MD059522 - Replication job RPTRGSRV01 dumps with error on    *
      *             call to QMQM in module A1008009.                  *
      *  BA1008 - Replication of Trades to consolidated branches      *
      *                                                               *
      *****************************************************************
      *
      ** MQSeries includes
      ** -----------------
      *
      ** MQI named constants
      *
     D***/COPY*QMQM/QRPGLESRC,CMQR                                                          MD059522
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD059522
      *
      ** Object Descriptor
      *
     D MQOD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQODR                                                        MD059522
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD059522
      *
      ** Message Descriptor
      *
     D MQMD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQMDR                                                        MD059522
     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD059522
      *
      ** Put message options
      *
     D MQPMO           DS
     D***/COPY*QMQM/QRPGLESRC,CMQPMOR                                                       MD059522
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD059522
      *
      ** Other includes
      ** --------------
      *
      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C/COPY RPCPYSRC,MDN_HD_DS

      ** The following /COPY contains various standard declares
     C/COPY RPCPYSRC,STD_DCL

      *
      ** Declared variables
      ** ------------------
      *
      ** Parameters
      *
      **   Target queue
     D*TgtQueue        S                   LIKE(MQSQueue)
      *
      ** Parameters for the QMQM calls.
      *
     D*CID*****        S              9P 0                                                  MD059522
     D*HCONN***        S              9P 0                                                  MD059522
     D*HOBJ****        S              9P 0                                                  MD059522
     D*BUFLEN**        S              9P 0                                                  MD059522
     D*CCODE***        S              9P 0                                                  MD059522
     D*REASON**        S              9P 0                                                  MD059522
     D*OCODE***        S              9P 0                                                  MD059522
     D*OPTS****        S              9P 0                                                  MD059522
     D HCONN           S             10I 0                                                  MD059522
     D HOBJ            S             10I 0                                                  MD059522
     D BUFLEN          S             10I 0                                                  MD059522
     D CCODE           S             10I 0                                                  MD059522
     D REASON          S             10I 0                                                  MD059522
     D OCODE           S             10I 0                                                  MD059522
     D OPTS            S             10I 0                                                  MD059522
      *
      ** 4-alpha and 6-alpha fields for the MQ error code
      *
     D RCode4A         S              4A
     D RCode6A         S              6A   INZ('RC    ')
      *
      ** Lengths of DS etc
      *
     D ApnHeadLen      S              9P 0
      *
     D** Make DataLen field compatible with called routine
      *
     D DataLen         S              5P 0
      *
      ** Data to be sent
      *
     D DataOut         S           8000A
      *
      ** Copy of input Transaction Data field
      **  - 4096 long to be compatible with called routine
      *
     D TrnDta          S           8000A
      *
      ** Length of input Transaction Data field
      *
     D TransDtaLn      S              5P 0 INZ(8000)
      *                                                                                     MD059522
      ** Queue Manager name                                                                 MD059522
      *                                                                                     MD059522
     D QMNAME          S             48A                                                    MD059522
                                                                                            MD059522
     D PRTCD           S              7                                                     MD059522
     D P@OP01          S             20                                                     MD059522
     D P@VL01          S            200                                                     MD059522
     D P@OP02          S             20                                                     MD059522
     D P@VL02          S            200                                                     MD059522
     D P@OP03          S             20                                                     MD059522
     D P@VL03          S            200                                                     MD059522
     D P@OP04          S             20                                                     MD059522
     D P@VL04          S            200                                                     MD059522
     D P@OP05          S             20                                                     MD059522
     D P@VL05          S            200                                                     MD059522
     D P@OP06          S             20                                                     MD059522
     D P@VL06          S            200                                                     MD059522
     D P@OP07          S             20                                                     MD059522
     D P@VL07          S            200                                                     MD059522
     D P@OP08          S             20                                                     MD059522
     D P@VL08          S            200                                                     MD059522
     D P@OP09          S             20                                                     MD059522
     D P@VL09          S            200                                                     MD059522
     D P@OP10          S             20                                                     MD059522
     D P@VL10          S            200                                                     MD059522

      /EJECT
     C     Start         TAG
      *
      ** Note: the above tag is only there to force the first comments
      ** in the C-specs to appear after the D- or I-specs in compiled
      ** listings.
      *
      ** Connect to MQSeries queue manager                                                  MD059522
      *                                                                                     MD059522
     C                   EXSR      ConnQueue                                                MD059522
      *
      ** Open MQSeries Transmission queue that is to be read
      *
     C                   EXSR      OpenQueue
      *
      ** Set the length of the data in the message ...
      ** Remove use of %len as this is not supported below V3R7
      *
     C                   EVAL      TrnDta     = ApData
     C                   CALLB     'A1008010'
     C                   PARM                    ReturnCode
     C                   PARM                    DataLen
     C                   PARM                    TrnDta
     C                   PARM                    TransDtaLn
      *
      * DataLen now contains the position of the first blank after all
      *  text, reduce this by 1 for the text length
      *
     C                   EVAL      DataLen = DataLen -1
      *
      ** ..and add the Merdidian Header length to get the buffer length
      *
     C                   EVAL      BufLen = ApnHeadLen + DataLen
      *
      ** Set up the data to be sent
      *
     C                   EVAL      DataOut = ApnHeadDS + ApData
      *
      ** Send the message
      *
     C                   EVAL      MDFMT = FMSTR
     C************       EVAL      CID = MQPUT                                              MD059522

     C                   IF        CommitCtl = 'Y'
      *
      ** If requested, specify that syncpointing is required
      *
     C                   Z-ADD     PMSYP         PMOPT
     C                   ENDIF

     C************       CALL      'QMQM'                                                   MD059522
     C************       PARM                    CID                                        MD059522
     C************       PARM                    HCONN                                      MD059522
     C************       PARM                    HOBJ                                       MD059522
     C************       PARM                    MQMD                                       MD059522
     C************       PARM                    MQPMO                                      MD059522
     C************       PARM                    BUFLEN                                     MD059522
     C************       PARM                    DataOut                                    MD059522
     C************       PARM                    CCODE                                      MD059522
     C************       PARM                    REASON                                     MD059522
      *                                                                                     MD059522
     C                   CALLP     MQPUT( HCONN : HOBJ : MQMD : MQPMO :                     MD059522
     C                                    BUFLEN : %ADDR(DataOut) :                         MD059522
     C                                    CCODE : REASON )                                  MD059522
                                                                                            MD059522
      ** If an error occured, put the MQSeries return code into this
      ** module's return code.
      *
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   ENDIF

     C                   EXSR      CloseQueue

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************                     MD059522
      *                                                               *                     MD059522
      * ConnQueue - Connect to MQSeries queue manager                 *                     MD059522
      *                                                               *                     MD059522
      *****************************************************************                     MD059522
                                                                                            MD059522
     C     ConnQueue     BEGSR                                                              MD059522
      *                                                                                     MD059522
     C                   CALLP     MQCONN( QMNAME : HCONN :                                 MD059522
     C                                    OCODE : REASON )                                  MD059522
     C                   IF        REASON <> RCNONE AND                                     MD059522
     C                             REASON <> RC2002                                         MD059522
     C                   EXSR      SetRetCode                                               MD059522
     C                   EXSR      *pssr                                                    MD059522
     C                   ENDIF                                                              MD059522
      *                                                                                     MD059522
     C                   ENDSR                                                              MD059522
      *****************************************************************                     MD059522
      /EJECT                                                                                MD059522
      *****************************************************************
      *                                                               *
      * OpenQueue - Open the MQSeries queue                           *
      *                                                               *
      *****************************************************************

     C     OpenQueue     BEGSR
      *
      ** Set up MQSeries data necessary to open a queue
      ** Open the target message queue for output (and fail if
      ** MQM is quiescing)
      ** Resulting queue handle is HOBJ
      ** Options are Output and Fail-if-quiescing
      ** OOOUT and OOFIQ are MQ named constants, declared in the CMQR
      ** include member.  OPTS is a program-described field declared in the
      ** parameter list below.  MQOPEN is an MQ named constant, also
      ** defined in CMQR, and CID is the call identifier, which defines what
      ** kind of call is being made.
      *
     C                   EVAL      OPTS = OOOUT + OOFIQ
     C************       EVAL      CID = MQOPEN                                             MD059522
      *
      ** ODON is a subfield of the MQOD data structure, which holds the
      ** name of the queue to be opened.  It is declared in the CMQODR
      ** include member.
      *
     C                   EVAL      ODON = TgtQueue
      *
      ** The call returns the parameter HOBJ, an object handle, which
      ** uniquely identifies the queue.  It is used later by the "Put" call.
      ** It also returns OCODE, a completion code, which tells us whether
      ** or not the call was successful, and REASON, which gives details
      ** if there was a failure.
      *
     C************       CALL      'QMQM'                                                   MD059522
     C************       PARM                    CID                                        MD059522
     C************       PARM                    HCONN                                      MD059522
     C************       PARM                    MQOD                                       MD059522
     C************       PARM                    OPTS                                       MD059522
     C************       PARM                    HOBJ                                       MD059522
     C************       PARM                    OCODE                                      MD059522
     C************       PARM                    REASON                                     MD059522
      *                                                                                     MD059522
     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD059522
     C                                    HOBJ : OCODE : REASON )                           MD059522
      *
      ** Report reason, if any; stop if failed
      ** RCNONE is a named constant indicating no failure (it is zero).
      *
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   EXSR      *pssr
     C                   ENDIF
      *
      ** CCFAIL is a named constant containing the value for OCODE
      ** indicating a failure to open the queue.
      *
     C                   IF         OCODE = CCFAIL
     C                   EVAL      ReturnCode = 'ErrOpnOutP'
     C                   EXSR      *pssr
     C                   END

     C                   ENDSR

      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  CloseQueue - Close the MQSeries queue                       *
      *                                                              *
      ****************************************************************
     C     CloseQueue    BEGSR
      *
      ** Close options: NONE
      *
     C                   Z-ADD     CONONE        OPTS
      *
      ** Close queue
      *
     C************       Z-ADD     MQCLOS        CID                                        MD059522
     C************       CALL      'QMQM'                                                   MD059522
     C************       PARM                    CID               9 0                      MD059522
     C************       PARM                    HCONN             9 0                      MD059522
     C************       PARM                    HOBJ              9 0                      MD059522
     C************       PARM                    OPTS              9 0                      MD059522
     C************       PARM                    CCODE             9 0                      MD059522
     C************       PARM                    REASON            9 0                      MD059522
      *                                                                                     MD059522
     C                   CALLP     MQCLOSE( HCONN : HOBJ : OPTS :                           MD059522
     C                                    CCODE : REASON )                                  MD059522
      *
      ** Error processing
      *
     C     REASON        IFNE      RCNONE
     C                   EXSR      SetRetCode
     C                   EXSR      *pssr

     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetRetCode - Set the module return code                       *
      *                                                               *
      * Called by: Main, OpenQueue, CloseQueue                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SetRetCode    BEGSR
      *
      ** First move the (numeric) reason code into a 4-alpha field;
      ** then put it into the rightmost four bytes of a 6-alpha field
      ** which begins with 'RC'; lastly concatenate it with 'Err' for
      ** the return code
      *
     C                   MOVE      REASON        RCode4A
     C                   MOVE      RCode4A       RCode6A
     C                   EVAL      ReturnCode = 'Err' + RCode6A

     C                   ENDSR

      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine.
     C/COPY RPCPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *inzsr        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    TgtQueue         48
     C**********         PARM                    ApnHeadDS       200                        MD062029
     C                   PARM                    ApnHeadDS       318                        MD062029
     C                   PARM                    ApData         8000
     C                   PARM                    CommitCtl         1
      *
      ** ReturnCode declared as 10A in /COPY STD_DCL
      *
     C                   PARM                    ReturnCode
      *
      ** Determine length of the Meridian header
      ** Remove use of %len as this is not supported below V3R7
      *
     C**********         EVAL      ApnHeadLen = 200                                         MD062029
     C                   EVAL      ApnHeadLen = 318                                         MD062029
      *                                                                                     MD059522
      ** Use queue name defined in system values.                                           MD059522
      *                                                                                     MD059522
     C                   EVAL      P@OP01 = 'MQQueueMgr'                                    MD059522
      *                                                                                     MD059522
     C                   CALL      'AOSVALR0'                                               MD059522
     C                   PARM      *BLANKS       PRTCD                                      MD059522
     C                   PARM                    P@OP01                                     MD059522
     C                   PARM      *BLANKS       P@VL01                                     MD059522
     C                   PARM      *BLANKS       P@OP02                                     MD059522
     C                   PARM      *BLANKS       P@VL02                                     MD059522
     C                   PARM      *BLANKS       P@OP03                                     MD059522
     C                   PARM      *BLANKS       P@VL03                                     MD059522
     C                   PARM      *BLANKS       P@OP04                                     MD059522
     C                   PARM      *BLANKS       P@VL04                                     MD059522
     C                   PARM      *BLANKS       P@OP05                                     MD059522
     C                   PARM      *BLANKS       P@VL05                                     MD059522
     C                   PARM      *BLANKS       P@OP06                                     MD059522
     C                   PARM      *BLANKS       P@VL06                                     MD059522
     C                   PARM      *BLANKS       P@OP07                                     MD059522
     C                   PARM      *BLANKS       P@VL07                                     MD059522
     C                   PARM      *BLANKS       P@OP08                                     MD059522
     C                   PARM      *BLANKS       P@VL08                                     MD059522
     C                   PARM      *BLANKS       P@OP09                                     MD059522
     C                   PARM      *BLANKS       P@VL09                                     MD059522
     C                   PARM      *BLANKS       P@OP10                                     MD059522
     C                   PARM      *BLANKS       P@VL10                                     MD059522
                                                                                            MD059522
     C                   IF        PRTCD = *BLANKS                                          MD059522
     C                   EVAL      QMNAME = P@VL01                                          MD059522
     C                   ENDIF                                                              MD059522
                                                                                            
     C                   ENDSR

      ********************************************************************
      /EJECT
      ********************************************************************
