     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPSNDMQMSG - Send a message to an MQSeries queue.            *
      *                                                               *
      *  Function:  This is a copy of the Midas module ZAMSTTOFO,     *
      *             with an additional parameter to allow the queue   *
      *             to be closed after the message is sent.           *
      *                                                               *
      *  Possible return codes                                        *
      *  =====================                                        *
      *    ErrOpnOutP - Unable to open queue for output               *
      *    ErrRCnnnn  - An MQSeries reason code, where nnnn is a four-*
      *                 digit number; see the MQSeries documentation  *
      *                 for their meanings.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 191375 Supportforce Date 07Jun07              *
      *                 115092 Supportforce Date 25Apr06              *
      *                 000752  Bugzilla   Date 14Dec05               *
      *                 CRP026             Date 18Jul05               *
      *                 146556 (RoyalBlue) Date 24Apr03               *
      *                 192680  *CREATE    Date 30Apr01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  191375 - Add a dump when an error is reported to enable      *
      *           easier problem investigation.                       *
      *           *PSSR alread does a dump but it was not called in   *
      *           all cases.                                          *
      *           Also MQOPEN / MQPUT / MQCLOSE changed to callp so   *
      *           the connection handle obtained from the MQCONN      *
      *           should actually be used.  However the connection    *
      *           handle created in one call does not seem to be      *
      *           available in the next call so the program is fully  *
      *           shut down each time.                                *
      *  115092 - If Close parameter is *YES then set on LR to close  *
      *           program and force *INZSR to be run next time and    *
      *           reconnect to the queue manager.                     *
      *  000752 - Change CLOSE processing to include the disconnect   *
      *           from the queue manager as well.                     *
      *  CRP026 - User specified Queue Manager added.                 *
      *  146556 - Remove Midas dependencies from this module          *
      *  192680 - Created to allow a queue to be closed after an      *
      *           ad-hoc message was sent to it by SNDMSGMQQ.         *
      *                                                               *
      *****************************************************************

      *****************************************************************
      *  +--------------------------------------+
      *  ¦ Automatically included D-specs       ¦
      *  ¦ ==============================       ¦
      *  +--------------------------------------+

     D***/COPY ZACPYSRC,STD_D_7PEC                                              146556

      *  Program Status Data Structure
      *  =============================
      *  The following /COPY line includes all the defined fields in the
      *  PSDS.  They have meaningful names, prefixed by 'PS'.

     D***/COPY ZACPYSRC,PSDS                                                    146556

      *  +--- MQSeries includes ----------------+
      *  ¦                                      ¦
      *  ¦ The following set of includes is     ¦
      *  ¦ provided by IBM for use with         ¦
      *  ¦ MQSeries.  See the source file       ¦
      *  ¦ QMQM/QRPGLESRC for details of their  ¦
      *  ¦ values.                              ¦
      *  ¦                                      ¦
      *  +--------------------------------------+

      *  MQI named constants
      *******************                                                       191375
     D*COPY*QMQM/QRPGLESRC,CMQR                                                 191375
      *******************                                                       191375
      ***Object*Descriptor                                                      191375
     D*MQOD************DS                                                       191375
     D*COPY*QMQM/QRPGLESRC,CMQODR                                               191375
      *******************                                                       191375
      ***Message*Descriptor                                                     191375
     D*MQMD************DS                                                       191375
     D*COPY*QMQM/QRPGLESRC,CMQMDR                                               191375
      *******************                                                       191375
      ***Put*message*options                                                    191375
     D*MQPMO***********DS                                                       191375
     D*COPY*QMQM/QRPGLESRC,CMQPMOR                                              191375
                                                                                191375
      **  Declare MQI structures needed                                         191375
      *      MQI Constants & Prototypes                                         191375
     D/COPY QMQM/QRPGLESRC,CMQG                                                 191375
                                                                                191375
      *      Object Descriptor                                                  191375
     D MQOD            DS                                                       191375
     D/COPY QMQM/QRPGLESRC,CMQODG                                               191375
                                                                                191375
      *      Message Descriptor                                                 191375
     D MQMD            DS                                                       191375
     D/COPY QMQM/QRPGLESRC,CMQMDR                                               191375
                                                                                191375
      *      Put message options                                                191375
     D MQPMO           DS                                                       191375
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                              191375

      *  +--------------------------------------+
      *  ¦ End of automatically included D-specs¦
      *  ¦ =====================================¦
      *  +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      *  +--------------------------------------+
      *  ¦ Manually included D-specs            ¦
      *  ¦ =========================            ¦
      *  +--------------------------------------+

      *  +--------------------------------------+
      *  ¦ Arrays and Data Structures           ¦
      *  ¦ ==========================           ¦
      *  +--------------------------------------+

      *  +--------------------------------------+
      *  ¦ Named constants                      ¦
      *  ¦ ===============                      ¦
      *  +--------------------------------------+

      *  +--------------------------------------+
      *  ¦ Declared variables                   ¦
      *  ¦ ==================                   ¦
      *  +--------------------------------------+

      *  4-alpha and 6-alpha fields for the MQ error code
     D RCode4A         S              4A
     D RCode6A         S              6A   INZ('RC    ')

      *  The name of the queue to use
     D Queue           S             48A                                        CAP006

      *  The name of the last queue used                                        CAP004
     D LastQueue       S             48A                                        CAP006
                                                                                CAP004
      *  The message to be sent to the front office
     D MQString        S           1102A

     D Close           S              4A

      *  Return code, from this module to caller                                146556
     D ReturnCode      S             10A                                        146556
                                                                                146556
      *  Flag to stop *PSSR looping                                             146556
     D RunBefore       S              1A                                        146556
                                                                                146556
      ** Queue Manager fields                                                   CRP026
     D MQMNAME         S             10A   INZ('MQMNAME   ')                    CRP026
     D ReturnedData    S             64A                                        CRP026
     D ReturnedDataLn  S              2P 0                                      CRP026
     D QueueMgrname    S             48A                                        CRP026

      ** Fields used in MQ calls                                                115092
     D HConn           S             10I 0                                      115092
     D CmpCod          S             10I 0                                      115092
     D Reason          S             10I 0                                      115092
     D HObj            S             10I 0                                      115092
     D Opts            S             10I 0                                      115092
     D BufLen          S             10I 0                                      115092
     D*MesLen          S             10I 0                                      115092

      *  +--------------------------------------+
      *  ¦ End of D-specs                       ¦
      *  ¦ ==============                       ¦
      *  +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

     C
      *  +--- Start of Main processing -----------------------------------+
      *  ¦                                                                ¦
      *  ¦ Initial processing is performed automatically: the *INZSR is   ¦
      *  ¦ executed at program activation.                                ¦
      *  ¦                                                                ¦
      *  +----------------------------------------------------------------+

      *  +--- Open MQSeries queue --------------+                               CAP004
      *  ¦                                      ¦                               CAP004
      *  ¦ For each message, the queue has to   ¦                               CAP004
      *  ¦ be opened.  The queue is closed and  ¦                               CAP004
      *  ¦ opened if the queue name has changed ¦                               CAP004
      *  ¦ since the previous call (except the  ¦                               CAP004
      *  ¦ first time through, when LastQueue   ¦                               CAP004
      *  ¦ will be blank).                      ¦                               CAP004
      *  ¦                                      ¦                               CAP004
      *  +--------------------------------------+                               CAP004
     C                   IF        Queue <> LastQueue                           CAP004
                                                                                CAP004
     C                   IF        LastQueue <> *blanks                         CAP004
     C                   EXSR      CloseQueue                                   CAP004
     C                   ENDIF                                                  CAP004
                                                                                CAP004
     C                   EXSR      OpenQueue
     C                   ENDIF                                                  CAP004


      *  +--- Set the length of the message ----+
      *  ¦                                      ¦
      *  ¦ The length of the message is         ¦
      *  ¦ calculated so that unnecessary blank ¦
      *  ¦ bytes are not included.  This is     ¦
      *  ¦ only really needed for 'SHUTDOWN',   ¦
      *  ¦ or other ad hoc messages.  If        ¦
      *  ¦ the performance of messages being    ¦
      *  ¦ returned to the front office becomes ¦
      *  ¦ a problem, this section can be       ¦
      *  ¦ removed and all messages sent as     ¦
      *  ¦ 1102 bytes.                          ¦
      *  ¦                                      ¦
      *  +--------------------------------------+
      *  Set the buffer length of the MQSeries to the length of the message
      *  field.
     C                   EVAL      BUFLEN = %LEN(%TRIMR(MQString))
                                                                                CAP006
      *   Set the message prority                                               CAP006
                                                                                CAP006
     C                   RESET                   MDPRI                          CAP006
     C                   Z-ADD     5             MDPRI                          CAP006

      *  +--- Send the message -----------------+
      *  ¦                                      ¦
      *  ¦ Call the MQSeries program, using the ¦
      *  ¦ handle returned when opening the     ¦
      *  ¦ queue.                               ¦
      *  ¦                                      ¦
      *  +--------------------------------------+
      *  MDFMT (Format Name) is a subfield of the MQMD data structure,
      *  defined in the include member CMQMDR.  FMSTR is a named constant
      *  defined in CMQR; it contains 'MQSTR   '.  MQPUT is a named constant
      *  defined in CMQR; it contains 6.
     C                   EVAL      MDFMT = FMSTR
      * CID is redundant after the change to callp                              191375
     C*******************EVAL      CID = MQPUT                                  191375
     C                   Z-ADD     PMNMID        PMOPT

     C*******************CALL      'QMQM'                                       191375
     C*******************PARM                    CID               9 0          191375
     C*******************PARM                    HCONN             9 0          191375
     C*******************PARM                    HOBJ              9 0          191375
     C*******************PARM                    MQMD                           191375
     C*******************PARM                    MQPMO                          191375
     C*******************PARM                    BUFLEN            9 0          191375
     C*******************PARM                    MQString                       191375
     C*******************PARM                    CCODE             9 0          191375
     C*******************PARM                    REASON            9 0          191375
      /free
         callp MQPUT( HConn : HObj : MQMD : MQPMO : BUFLEN :
                         %addr( MQString) : CmpCod : Reason);
      /end-free


      *  If an error occured, put the MQSeries return code into this
      *  module's return code.
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   EXSR      *pssr                                        191375
     C                   ENDIF

      *  +--- Close MQSeries queue -------------+
      *  ¦                                      ¦
      *  ¦ If requested, close the queue.       ¦
      *  ¦                                      ¦
      *  +--------------------------------------+

      * A shutdown is wanted in all cases.  If the Close parameter              191375
      * is *NO change it to *YES.  This form of coding is done                  191375
      * in order to minimise the code change and to make it easier              191375
      * to back out this in future if a better solution is found.               191375
     C                   IF        %parms > 3 and Close = '*NO'                 191375
     C                   EVAL      Close = '*YES'                               191375
     C                   ENDIF                                                  191375
                                                                                191375
      * If the optional parameter was passed, and it contains a
      * request to close the queue, then do so.
     C                   IF        %parms > 3 and Close = '*YES'                CAP004

     C                   EXSR      CloseQueue

      * If we are explicitly closing the queue, we also clear out the
      * name of the last queue.  This is done because, if this function
      * is started again with the same queue name, it will expect the
      * queue to be open.  Clearing this variable will force it to be
      * reopened.
     C                   EVAL      LastQueue = *blanks

      *  Disconnect from Queue Manager                                          000752
     C                   EXSR      QMDisc                                       000752
                                                                                000752
     C                   SETON                                        LR        115092
                                                                                115092
     C                   ENDIF

      ***Disconnect*from Queue Manager                                   CRP026 000752
     C****************** EXSR      QMDisc                                CRP026 000752
      ******************                                                 CRP026 000752
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * OpenQueue - Open the MQSeries queue                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: PGM/QMQM                                               *
      *                                                               *
      *****************************************************************

     C     OpenQueue     BEGSR

      *  Set up MQSeries data necessary to open a queue

      *   Open the target message queue for output (and fail if
      *   MQM is quiescing)
      *   Resulting queue handle is HOBJ

      *  Options are Output and Fail-if-quiescing
      *  OOOUT and OOFIQ are MQ named constants, declared in the CMQR
      *  include member.  OPTS is a program-described field declared in the
      *  parameter list below.  MQOPEN is an MQ named constant, also
      *  defined in CMQR, and CID is the call identifier, which defines what
      *  kind of call is being made.
     C                   EVAL      OPTS = OOOUT + OOFIQ
      * CID is redundant after the change to callp                              191375
     C*******************EVAL      CID = MQOPEN                                 191375

      *  ODON is a subfield of the MQOD data structure, which holds the
      *  name of the queue to be opened.  It is declared in the CMQODR
      *  include member.
     C                   EVAL      ODON = Queue

      *  The call returns the parameter HOBJ, an object handle, which
      *  uniquely identifies the queue.  It is used later by the "Put" call.
      *  It also returns OCODE, a completion code, which tells us whether
      *  or not the call was successful, and REASON, which gives details
      *  if there was a failure.
     C*******************CALL      'QMQM'                                       191375
     C*******************PARM                    CID               9 0          191375
     C*******************PARM                    HCONN             9 0          191375
     C*******************PARM                    MQOD                           191375
     C*******************PARM                    OPTS              9 0          191375
     C*******************PARM                    HOBJ              9 0          191375
     C*******************PARM                    OCODE             9 0          191375
     C*******************PARM                    REASON            9 0          191375
      /free
        callp MQOPEN( HConn : MQOD : Opts : HObj : CmpCod : Reason);          //191375
      /end-free

      *  Report reason, if any; stop if failed
      *  RCNONE is a named constant indicating no failure (it is zero).
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   EXSR      *pssr
     C                   ENDIF

      *******************                                                       191375
      ***CCFAIL*is*a*named constant containing the value for OCODE              191375
      ***indicating*a*failure to open the queue.                                191375
     C*******************IF         OCODE = CCFAIL                              191375
      *  CCFAIL is a named constant containing the value for CmpCod             191375
      *  indicating a failure to open the queue.                                191375
     C                   IF        CmpCod = CCFAIL                              191375
     C                   EVAL      ReturnCode = 'ErrOpnOutP'
     C                   EXSR      *pssr
     C                   END
                                                                                CAP004
      *  If all was successful, save the name of the queue for checking         CAP004
      *  on subsequent calls.                                                   CAP004
     C                   EVAL      LastQueue = Queue                            CAP004

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CloseQueue - Close the MQSeries queue                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: PGM/QMQM                                               *
      *                                                               *
      *****************************************************************

     C     CloseQueue    BEGSR

      *  Set up MQSeries data necessary to close a queue

      *  CONONE is a named constant (equal to zero) indicating that no
      *  options are to be used.  MQCLOS is a named constant indicating
      *  that the queue is to be closed.  Both are defined in CMQR.
     C                   EVAL      OPTS = CONONE
      * CID is redundant after the change to callp                              191375
     C*******************EVAL      CID = MQCLOS                                 191375

      *  The call returns CCODE, a completion code, which tells us whether
      *  or not the call was successful, and REASON, which gives details
      *  if there was a failure.
      *******************                                                       191375
     C*******************CALL      'QMQM'                                       191375
     C*******************PARM                    CID               9 0          191375
     C*******************PARM                    HCONN             9 0          191375
     C*******************PARM                    HOBJ              9 0          191375
     C*******************PARM                    OPTS              9 0          191375
     C*******************PARM                    CCODE             9 0          191375
     C*******************PARM                    REASON            9 0          191375
      /free
        callp MQCLOSE( HConn : HObj : Opts : CmpCod : Reason);                //191375
      /end-free

      *  Report reason, if any; stop if failed
      *  RCNONE is a named constant indicating no failure (it is zero).
     C                   IF        REASON <> RCNONE
     C                   EXSR      SetRetCode
     C                   EXSR      *pssr
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT                                                                    CRP026
      ****************************************************************          CRP026
      *                                                              *          CRP026
      *  Connect to Queue Manager                                    *          CRP026
      *                                                              *          CRP026
      ****************************************************************          CRP026
     C     QMConnect     BEGSR                                                  CRP026
                                                                                CRP026
      * Get Queue Manager name                                                  CRP026
     C                   CALLB     'RPBOIF99'                                   CRP026
     C                   PARM                    MQMNAME                        CRP026
     C                   PARM                    ReturnedData                   CRP026
     C                   PARM                    ReturnedDataLn                 CRP026
     C                   EVAL      QueueMgrname =                               CRP026
     C                               %subst(ReturnedData : 1 : ReturnedDataLn)  CRP026
     C                   IF        QueueMgrname = '*DFT'                        CRP026
     C                   EVAL      QueueMgrname = *BLANK                        CRP026
     C                   ENDIF                                                  CRP026
                                                                                CRP026
      * Connect to Queue Manager                                                CRP026
      * CID is redundant after the change to callp                              191375
     C*******************Z-ADD     MQCONN        CID                            191375
      *******************                                                       191375
     C*******************CALL      'QMQM'                                CRP026 191375
     C*******************PARM                    CID               9 0   CRP026 191375
     C*******************PARM                    QueueMgrname            CRP026 191375
     C*******************PARM                    HCONN             9 0   CRP026 191375
     C*******************PARM                    OCODE             9 0   CRP026 191375
     C*******************PARM                    REASON            9 0   CRP026 191375
      /free
        callp MQCONN( QueueMgrName : HConn : CmpCod : Reason);                //191375
      /end-free

      ** Error if reason code not Okay and not Already connected                CRP026
     C                   IF            REASON <> RCNONE                         CRP026
     C                             AND REASON <> RC2002                         CRP026
     C                   EXSR      SetRetCode
     C                   EXSR      *PSSR                                        CRP026
     C                   RETURN                                                 CRP026
                                                                                CRP026
     C                   ENDIF                                                  CRP026
                                                                                CRP026
     C                   ENDSR                                                  CRP026
      ****************************************************************          CRP026
      /EJECT                                                                    CRP026
      ****************************************************************          CRP026
      *                                                              *          CRP026
      *  Disconnect from Queue Manager                               *          CRP026
      *                                                              *          CRP026
      ****************************************************************          CRP026
     C     QMDisc        BEGSR                                                  CRP026
                                                                                CRP026
      * Disconnect from Queue Manager                                           CRP026
      * CID is redundant after the change to callp                              191375
     C*******************Z-ADD     MQDISC        CID                            191375
      *******************                                                       191375
     C*******************CALL      'QMQM'                                CRP026 191375
     C*******************PARM                    CID               9 0   CRP026 191375
     C*******************PARM                    HCONN             9 0   CRP026 191375
     C*******************PARM                    OCODE             9 0   CRP026 191375
     C*******************PARM                    REASON            9 0   CRP026 191375
      /free
        callp MQDISC( HConn : CmpCod : Reason);                               //191375
      /end-free

      ** Error if reason code not Okay                                          CRP026
     C                   IF        REASON <> RCNONE                             CRP026
     C                   EXSR      SetRetCode
     C                   EXSR      *PSSR                                        CRP026
     C                   RETURN                                                 CRP026
                                                                                CRP026
     C                   ENDIF                                                  CRP026
                                                                                CRP026
     C                   ENDSR                                                  CRP026
      ****************************************************************          CRP026
      /EJECT
      *****************************************************************
      *                                                               *
      * SetRetCode - Set the module return code                       *
      *                                                               *
      * Called by: Main, OpenQueue                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SetRetCode    BEGSR

      *  First move the (numeric) reason code into a 4-alpha field; then
      *  put it into the rightmost four bytes of a 6-alpha field which
      *  begins with 'RC'; lastly concatenate it with 'Err' for the return
      *  code
     C                   MOVE      REASON        RCode4A
     C                   MOVE      RCode4A       RCode6A
     C                   EVAL      ReturnCode = 'Err' + RCode6A

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST                                                  CAP006
      *  Return code (10A, returned from this module to caller)                 CAP006
     C                   PARM                    ReturnCode                     CAP006
      *  Queue to send message to (48A = maximumn, received from caller)        CAP006
     C                   PARM                    Queue                          CAP006
      *  String containing message to send (1102A, received from caller)        CAP006
     C                   PARM                    MQString                       CAP006
      *  Close the queue after sending?
     C                   PARM                    Close

      *  Program, module and procedure names for database error processing.
      *  =================================================================
      *  The following /COPY sets these values, and also defines LDA as
      *  an external data area

      *  Set the buffer length of the MQSeries to the length of the message
      *  field.
     C                   EVAL      BUFLEN = %LEN(MQString)

      *  Connect to Queue Manager                                               CRP026
     C                   EXSR      QMConnect                                    CRP026
                                                                                CRP026
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
     C***/COPY ZACPYSRC,PSSR_ILE                                                146556
     C/COPY RPCPYSRC,PSSR_ILE                                                   146556
      ********************************************************************
