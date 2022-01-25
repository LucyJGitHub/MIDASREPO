      /if defined(MQBASIC_inc)
      /eof
      /else
      /define MQBASIC_inc
      /endif

      * -------------------------------------------------------------------
      *
      *  --------------
      *  Change History
      *  --------------
      *  Date (ISO)  ID       Who   Description (multiple lines if needed)
      *  ----------  --       ---   ----------------------------------------
      *
      *
      *  2021-12-16  MD058809       After installation of MQ9 compatibility patch and
      *                             restart of the Meridian Replication subsystem
      *                             REPMIDASPT, the job MPT1PBSIN ended in MSGW.
      *  2006-09-13  128748   SAO   Created as part of this change to enable a
      *              Supportforce   program that stops because of a queue full
      *                             condition to easily report the queue's maximum
      *                             depth.
      *
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------  +
      * Basic fields

     D MQ_Name         S             48A
     D MQ_Handle       S             10I 0
     D MQ_Int          S             10I 0
     D RetCodeBase     S            128A
      * -------------------------------------------------------------------  +

      * -------------------------------------------------------------------  +
      * Connect to a queue manager

     D ConnectToQM     PR            10I 0 extproc('ConnectToQM')
     D  QueueMgrName                       like(MQ_Name)
     D  RetCode                            like(RetCodeBase)
      * -------------------------------------------------------------------  +

      * -------------------------------------------------------------------  +
      * Disconnect from queue manager

     D DisconnectFromQM...
     D                 PR                  extproc('DisconnectFromQM')
     D  QueueMgrHndle                      like(MQ_Handle)
      * -------------------------------------------------------------------  +

      * -------------------------------------------------------------------  +
      * Open an MQ queue
     D OpenMQQueue     PR            10I 0 extproc('OpenMQQueue')
     D  QMHandle                           like(MQ_Handle)
     D  QueueName                          like(MQ_Name)
     D  OpenFlags                    64A
     D  RetCode                            like(RetCodeBase)
      * -------------------------------------------------------------------  +

      * -------------------------------------------------------------------  +
      * Close an MQ queue
     D CloseMQQueue    PR                  extproc('CloseMQQueue')
     D  QMHandle                           like(MQ_Handle)
     D  QueueHandle                        like(MQ_Handle)
      * -------------------------------------------------------------------  +

