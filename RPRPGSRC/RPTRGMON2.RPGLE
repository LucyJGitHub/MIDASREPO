     H DEBUG
     H*COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPTRGMON2 - Trigger monitor server                           *
      *                                                               *
      *  Function:  This module monitors the initiation queue(s)      *
      *             associated with (typically) transmission queue(s) *
      *             and when a trigger message is received calls the  *
      *             program specified.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 115092 Supportforce Date 25Apr06              *
      *                 CRP026             Date 18Jul05               *
      *                 CRP004             Date 05Aug99               *
      *                 CRP002  *CREATE    Date 13Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  115092 - Change MQ options from calls to QMQM to calls to    *
      *           MQxxxx so that RPTRGMON and RPPRCSMSGS have         *
      *           separate connection handles and when RPPRCSMSGS     *
      *           disconnects it does not affect RPTRGMON.            *
      *  CRP026 - User specified Queue Manager added.                 *
      *  CRP004 - Recompiled over changed STD_DCL /COPY               *
      *  CRP002 - New                                                 *
      *                                                               *
      *****************************************************************
      /EJECT

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Change /COPYs to those needed by new MQ calls                          115092
      ****Declare*MQI*structures needed                                         115092
      *******MQI*Constants*****                                                 115092
     D*COPY*QMQM/QRPGLESRC,CMQR                                                 115092
      *************************                                                 115092
      *******Object*Descriptor*                                                 115092
     D*MQOD************DS******                                                 115092
     D*COPY*QMQM/QRPGLESRC,CMQODR                                               115092
      *************************                                                 115092
      *******Message*Descriptor                                                 115092
     D*MQMD************DS******                                                 115092
     D*COPY*QMQM/QRPGLESRC,CMQMDR                                               115092
      *************************                                                 115092
      *******Get*message*options                                                115092
     D*MQGMO***********DS******                                                 115092
     D*COPY*QMQM/QRPGLESRC,CMQGMOR                                              115092
     D*************************                                                 115092
     D*******Trigger*message*Descriptor                                         115092
     D*MQMTM***********DS******                                                 115092
     D*COPY*QMQM/QRPGLESRC,CMQTMR                                               115092
                                                                                115092
      **  Declare MQI structures needed                                         115092
      *      MQI Constants & Prototypes                                         115092
     D/COPY QMQM/QRPGLESRC,CMQG                                                 115092
                                                                                115092
      *      Object Descriptor                                                  115092
     D MQOD            DS                                                       115092
     D/COPY QMQM/QRPGLESRC,CMQODG                                               115092
                                                                                115092
      *      Message Descriptor                                                 115092
     D MQMD            DS                                                       115092
     D/COPY QMQM/QRPGLESRC,CMQMDR                                               115092
                                                                                115092
      *      Get message options                                                115092
     D MQGMO           DS                                                       115092
     D/COPY QMQM/QRPGLESRC,CMQGMOG                                              115092
                                                                                115092
      *      Trigger message Descriptor                                         115092
     D MQMTM           DS                                                       115092
     D/COPY QMQM/QRPGLESRC,CMQTMG                                               115092

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** The following /COPY contains various standard declares
     C*COPY*RPCPYSRC,Std_Dcl
     C/COPY RPCPYSRC,STD_DCL

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Data structure for incoming message formats - length set at 5000
      **  as it is very unlikely ever to be longer than this
      ** N.B. this includes the MQ header and the Meridian header as well
      **  as the transaction data
     D Buffer          DS          5000

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters
     D InitQueue       S                   LIKE(MQSQueue)

      ** Fields passed to called module
      **   Control member
     D CtlMbr          S             10A
      **   Application program to call
     D AppnPgm         S             10A
      **   Application program with library
     D AppnPgmLib      S             10A
      **   Queue for application program to read
     D InQueue         S                   LIKE(MQSQueue)
      **   Queue for application program to write to
     D OutQueue        S                   LIKE(MQSQueue)

      ** Alpha version of the MQSeries reason code
     D ReasonA         S              9A

      ** Work fields
      **   First 8 bytes of message - looking for 'SHUTDOWN'
     D Shutdown        S              8A

      ** Queue Manager fields                                                   CRP026
     D MQMNAME         S             10A   INZ('MQMNAME   ')                    CRP026
     D ReturnedData    S             64A                                        CRP026
     D ReturnedDataLn  S              2P 0                                      CRP026
     D QueueMgrname    S             48A                                        CRP026
                                                                                CRP026
      ** Fields used in MQ calls                                                115092
     D HConn           S             10I 0                                      115092
     D CmpCod          S             10I 0                                      115092
     D Reason          S             10I 0                                      115092
     D HObj            S             10I 0                                      115092
     D Opts            S             10I 0                                      115092
     D BufLen          S             10I 0                                      115092
     D MesLen          S             10I 0                                      115092
                                                                                115092
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Loop until no messages left
     C                   DOU       Buffer = *blank

     C                   EXSR      GetMsg

      ** Terminate if a 'SHUTDOWN' message is received, commit changes if
      **  appropriate to removew 'SHUTDOWN' message.
     C                   EVAL      Shutdown = %subst(Buffer:1:8)
     C                   IF        Shutdown = 'SHUTDOWN'

     C                   IF        CommitCtl = 'Y'
     C                   COMMIT
     C                   ENDIF

     C                   LEAVE
     C                   ENDIF

      ** Trigger message received, break it down as per the supplied
      **  IBM data structure
     C                   EVAL      MQMTM = Buffer

      ** The name of the program to call is in the first 20 bytes of
      **  the Application identifier data structure subfield
      **    Extract the name of the Application program ...
     C                   EVAL      AppnPgm    = %subst(TMAI:1:10)
      **     ... and the library it is in.
     C                   EVAL      AppnPgmLib = %subst(TMAI:11:10)

      ** Extract the name of the queue that the application program will
      **  read as the Name of triggered queue data structure subfield
     C                   EVAL      Inqueue = TMQN

      ** Extract the name of the control member (in RPAPICL0) as the first
      **  10 bytes of the User data data structure subfield
     C                   EVAL      CtlMbr = %subst(TMUD:1:10)

      ** Extract the name of the MQSeries queue to write to as next 48
      **  bytes of the User data data structure subfield
     C                   EVAL      OutQueue = %subst(TMUD:11:48)

      ** Call CL routine to override to the correct control member and then
      **  call the application program.
     C                   CALLB     'RPTRGMON3'
     C                   PARM                    CtlMbr
     C                   PARM                    AppnPgm
     C                   PARM                    AppnPgmLib
     C                   PARM                    InQueue
     C                   PARM                    OutQueue
     C                   PARM                    CommitCtl
     C                   PARM                    ReturnCode

     C                   IF        ReturnCode <> *BLANK
     C                   DUMP
     C                   RETURN
     C                   ENDIF

     C                   ENDDO

     C                   EXSR      CloseQueue

      *  Disconnect from Queue Manager                                          CRP026
     C                   EXSR      QMDisc                                       CRP026
                                                                                CRP026
     C                   SETON                                        LR

     C                   RETURN
      /EJECT
      ****************************************************************
      *                                                              *
      *  Open receiving queue for input                              *
      *                                                              *
      ****************************************************************
     C     OpenQueue     BEGSR

      ** Use input queue
     C                   MOVEL     InQueue       ODON             48

      ** Open options: INPUT and FAIL_IF_QUIESCING
     C     OOINPQ        ADD       OOFIQ         OPTS

      ** Open queue
     C*******************Z-ADD     MQOPEN        CID                            115092
     C*******************CALL      'QMQM'                                       115092
     C*******************PARM                    CID               9 0          115092
     C*******************PARM                    HCONN             9 0          115092
     C*******************PARM                    MQOD                           115092
     C*******************PARM                    OPTS              9 0          115092
     C*******************PARM                    HIN               9 0          115092
     C*******************PARM                    OCODE             9 0          115092
     C*******************PARM                    REASON            9 0          115092
      /free
        callp MQOPEN( HCONN : MQOD : OPTS : HOBJ : CMPCOD : REASON);          //115092
      /end-free

      ** Error processing
     C     REASON        IFNE      RCNONE

      ** Set up alpha version of messages
     C                   MOVE      REASON        ReasonA                        138019
     C                   EVAL      ReturnCode = 'ErrRC' + ReasonA
     C                   RETURN                                                 138019

     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Wait for incoming messages                                  *
      *                                                              *
      ****************************************************************
     C     GETMSG        BEGSR

      ** Get options: WAIT and CONVERT
     C                   Z-ADD     GMWT          GMOPT
     C                   ADD       GMCONV        GMOPT

      ** Allow truncation of message
     C                   ADD       GMATM         GMOPT

      ** Set wait interval to indefinite
     C                   Z-ADD     WIULIM        GMWI

     C                   IF        CommitCtl = 'Y'
      ** Perform get operation inside commitment control if requested.
     C                   ADD       GMSYP         GMOPT
     C                   ENDIF

      ** MsgId and CorrelId are selectors cleared to ensure messages
      ** are processed in arrival/priority sequence
     C                   MOVEL     MINONE        MDMID
     C                   MOVEL     CINONE        MDCID

      ** Clear message buffer
     C                   MOVEL     *BLANKS       BUFFER

      ** Get message
     C*******************Z-ADD     MQGET         CID                            115092
     C*******************CALL      'QMQM'                                       115092
     C*******************PARM                    CID               9 0          115092
     C*******************PARM                    HCONN             9 0          115092
     C*******************PARM                    HIN               9 0          115092
     C*******************PARM                    MQMD                           115092
     C*******************PARM                    MQGMO                          115092
     C*******************PARM                    BUFLEN            9 0          115092
     C*******************PARM                    BUFFER                         115092
     C*******************PARM                    MESLEN            9 0          115092
     C*******************PARM                    CCODE             9 0          115092
     C*******************PARM                    REASON            9 0          115092
      /free
        callp MQGET( HCONN : HOBJ : MQMD : MQGMO : BUFLEN :
                           %addr( Buffer) : MESLEN : CMPCOD : REASON);        //115092
      /end-free

      ** Error processing
     C                   IF        Reason <> RCNONE AND Reason <> 2079
     C                             AND Reason <> 2033

      ** Set up alpha version of messages
     C                   MOVE      REASON        ReasonA                        138019
     C                   EVAL      ReturnCode = 'ErrRC' + ReasonA
     C                   RETURN                                                 138019

     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Close input queue                                           *
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
     C*******************Z-ADD     MQCLOS        CID                            115092
     C*******************CALL      'QMQM'                                       115092
     C*******************PARM                    CID               9 0          115092
     C*******************PARM                    HCONN             9 0          115092
     C*******************PARM                    HIN               9 0          115092
     C*******************PARM                    OPTS              9 0          115092
     C*******************PARM                    CCODE             9 0          115092
     C*******************PARM                    REASON            9 0          115092
      /free
        callp MQCLOSE( HCONN : HOBJ : OPTS : CMPCOD : REASON);                //115092
      /end-free

      ** Error processing
     C     REASON        IFNE      RCNONE

      ** Set up alpha version of messages
     C                   MOVE      REASON        ReasonA                        138019
     C                   EVAL      ReturnCode = 'ErrRC' + ReasonA
     C                   RETURN                                                 138019

     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
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
     C*******************Z-ADD     MQCONN        CID                      CRP026115092
     C*******************CALL      'QMQM'                                 CRP026115092
     C*******************PARM                    CID               9 0    CRP026115092
     C*******************PARM                    QueueMgrname             CRP026115092
     C*******************PARM                    HCONN             9 0    CRP026115092
     C*******************PARM                    OCODE             9 0    CRP026115092
     C*******************PARM                    REASON            9 0    CRP026115092
      /free
        callp MQCONN( QueueMgrName : HCONN : CMPCOD : REASON);                //115092
      /end-free
                                                                                CRP026
      ** Error if reason code not Okay and not Already connected                CRP026
     C                   IF            REASON <> RCNONE                         CRP026
     C                             AND REASON <> RC2002                         CRP026
                                                                                CRP026
      ** Set up alpha version of messages                                       CRP026
     C                   MOVE      REASON        ReasonA                        CRP026
     C                   EVAL      ReturnCode = 'ErrRC' + ReasonA               CRP026
                                                                                CRP026
      ** Cause a dump                                                           CRP026
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
     C*******************Z-ADD     MQDISC        CID                      CRP026115092
     C*******************CALL      'QMQM'                                 CRP026115092
     C*******************PARM                    CID               9 0    CRP026115092
     C*******************PARM                    HCONN             9 0    CRP026115092
     C*******************PARM                    OCODE             9 0    CRP026115092
     C*******************PARM                    REASON            9 0    CRP026115092
      /free
        callp MQDISC( HCONN : CMPCOD : REASON);                               //115092
      /end-free
                                                                                CRP026
      ** Error if reason code not Okay                                          CRP026
     C                   IF        REASON <> RCNONE                             CRP026
                                                                                CRP026
      ** Set up alpha version of messages                                       CRP026
     C                   MOVE      REASON        ReasonA                        CRP026
     C                   EVAL      ReturnCode = 'ErrRC' + ReasonA               CRP026
                                                                                CRP026
      ** Cause a dump                                                           CRP026
     C                   EXSR      *PSSR                                        CRP026
     C                   RETURN                                                 CRP026
                                                                                CRP026
     C                   ENDIF                                                  CRP026
                                                                                CRP026
     C                   ENDSR                                                  CRP026
      ****************************************************************          CRP026
     C/EJECT
      ********************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine.
     C/COPY RPCPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *inzsr        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    InQueue
     C                   PARM                    CommitCtl

      *  Connect to Queue Manager                                               CRP026
     C                   EXSR      QMConnect                                    CRP026
                                                                                CRP026
      ** Open MQSeries Transmission queue that is to be read
     C                   EXSR      OpenQueue

      ** Determine length of the I/P buffer
      * Remove use of %len as this is not supported below V3R7                  CRP002
     C*******************EVAL      BufLen = %len(MQMTM)
     C                   EVAL      BufLen = 684

     C                   ENDSR
      ********************************************************************
