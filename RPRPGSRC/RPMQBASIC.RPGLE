     H DEBUG NOMAIN
     H OPTION(*SRCSTMT : *NODEBUGIO)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPMQBASIC - Basic MQ functions                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 128748 Supportforce                           *
      *                         *CREATE     Date 13Sep06              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  128748 - Created as part of this change to enable a program  *
      *           that stops because of a queue full condition to     *
      *           easily report the queue's maximum depth.            *
      *                                                               *
      *****************************************************************

      *****************************************************************

      * -------------------------------------------------------------------
      * Global D-specs
      * -------------------------------------------------------------------

      **  Declare MQI structures needed
      *      MQI Constants & Prototypes
     D/COPY QMQM/QRPGLESRC,CMQG

      *      Object Descriptor
     D MQOD            DS
     D/COPY QMQM/QRPGLESRC,CMQODG

      **  Prototypes for procedures defined in this module
     D/copy RPCPYSRC,MQBASIC

      /EJECT
      * -------------------------------------------------------------------
      * Connect to a queue manager
     P ConnectToQM     B                   export
     D ConnectToQM     PI                  like(MQ_Handle)
     D  QueueMgrNameIn...
     D                                     like(MQ_Name)
     D  RetCode                            like(RetCodeBase)

     D  QueueMgrNameToUse...
     D                 S                   like(MQ_Name)
     D  QueueMgrHndle  S                   like(MQ_Handle)

     D CMPCOD          S                   like(MQ_Int)
      * Completion Code
     D REASON          S                   like(MQ_Int)
      * Reason Code

      /free
        clear RetCode;

        QueueMgrNameToUse = QueueMgrNameIn;
        if QueueMgrNameIn = '*DFT';
           QueueMgrNameToUse = *BLANK;
        endif;

        // QueueMgrHndle is the returned Connection Handle for the
        // Queue Manager
        // CMPCOD is the Completion Code and REASON is the Reason Code
        callp MQCONN( QueueMgrNameToUse : QueueMgrHndle : CMPCOD : REASON);

        // Error processing
        if REASON <> RCNONE;
           if REASON = RC2002;
              RetCode = 'MQ_RC_' + %char( RC2002);
           else;
              RetCode = 'When connecting to ' + %trim( QueueMgrNameIn) +
                       ': Reason code ' + %char( REASON) + ' received';
              DisconnectFromQM( QueueMgrHndle);
              return -1;
           endif;
        endif;

        return QueueMgrHndle;

       // ***************************************************************
      /end-free
      * -------------------------------------------------------------------
     P ConnectToQM     E
      * -------------------------------------------------------------------
      /EJECT
      * -------------------------------------------------------------------
      * Disconnect from queue manager
     P DisconnectFromQM...
     P                 B                   export
     D DisconnectFromQM...
     D                 PI
     D  QueueMgrHndle                      like(MQ_Handle)

     D CMPCOD          S                   like(MQ_Int)
      * Completion Code
     D REASON          S                   like(MQ_Int)
      * Reason Code

      /free
        // QueueMgrName is the Connection Handle for the Queue Manager
        //  - obtained earlier
        // CMPCOD is the Completion Code and REASON is the Reason Code
        callp MQDISC( QueueMgrHndle : CMPCOD : REASON);

        // Don't worry about errors

       // ***************************************************************
      /end-free
      * -------------------------------------------------------------------
     P DisconnectFromQM...
     P                 E
      * -------------------------------------------------------------------
      /EJECT
      * -------------------------------------------------------------------
      * Open an MQ queue
     P OpenMQQueue     B                   export
     D OpenMQQueue     PI                  like(MQ_Handle)
     D  QMHandle                           like(MQ_Handle)
     D  QueueName                          like(MQ_Name)
     D  OpenFlags                    64A
     D  RetCode                            like(RetCodeBase)

     D  QueueHandle    S                   like(MQ_Handle)

     D OPTS            S                   like(MQ_Int)
      * Options
     D CMPCOD          S                   like(MQ_Int)
      * Completion Code
     D REASON          S                   like(MQ_Int)
      * Reason Code

      * -------------------------------------------------------------------
      /free
        clear RetCode;

        // Set name of queue to be opened.
        //  ODON is a subfield of the supplied data structure MQOD
        ODON = QueueName;

        // Open options:
        // always FAIL_IF_QUIESCING
        OPTS = OOFIQ;

        // if asked for: OUTPUT
        if %scan('OUTPUT' : OpenFlags) > 0;
           OPTS = OPTS + OOOUT;
        endif;

        // if asked for: INPUT
        if %scan('INPUT' : OpenFlags) > 0;
           OPTS = OPTS + OOINPQ;
        endif;

        // if asked for: INQUIRE
        if %scan('INQUIRE' : OpenFlags) > 0;
           OPTS = OPTS + OOINQ;
        endif;

        // if asked for: Browse
        if %scan('BROWSE' : OpenFlags) > 0;
           OPTS = OPTS + OOBRW;
        endif;

        // QMHandle is the Connection Handle for the Queue Manager
        //  - obtained earlier
        // QueueHandle is the returned Connection Handle for the Queue
        // CMPCOD is the Completion Code and REASON is the Reason Code
        callp MQOPEN( QMHandle : MQOD : OPTS : QueueHandle : +
                                        CMPCOD : REASON);

        // Treat any non-zero reason codes as an error
        if REASON <> RCNONE;
           RetCode = 'When opening queue ' + %trim( QueueName) +
                     ': Reason code ' + %char( REASON) + ' received';
           CloseMQQueue( QMHandle : QueueHandle);
           return -1;
        endif;

        return QueueHandle;

       // ***************************************************************
      /end-free
      * -------------------------------------------------------------------
     P OpenMQQueue     E
      * -------------------------------------------------------------------
      /EJECT
      * -------------------------------------------------------------------
      * Close an MQ queue
     P CloseMQQueue    B                   export
     D CloseMQQueue    PI
     D  QMHandle                           like(MQ_Handle)
     D  QueueHandle                        like(MQ_Handle)

     D OPTS            S                   like(MQ_Int)
      * Options
     D CMPCOD          S                   like(MQ_Int)
      * Completion Code
     D REASON          S                   like(MQ_Int)
      * Reason Code

      * -------------------------------------------------------------------
      /free
        // Close options: CONONE (No optional processing to be performed)
        OPTS = CONONE;

        // QMHandle is the Connection Handle for the Queue Manager
        //  - obtained earlier
        // QueueHandle is the Connection Handle for the Queue
        // CMPCOD is the Completion Code and REASON is the Reason Code
        callp MQCLOSE( QMHandle : QueueHandle : OPTS : CMPCOD : REASON);

        // Don't worry about errors

       // ***************************************************************
      /end-free
      * -------------------------------------------------------------------
     P CloseMQQueue    E
      * -------------------------------------------------------------------
