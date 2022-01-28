      /if defined(MQINQWRAP_inc)
      /eof
      /else
      /define MQINQWRAP_inc
      /endif

     D/copy RPCPYSRC,MQBASIC

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
      * Retreive a single attribute of a queue
     D RtvQAttr        PR                  extproc('RtvQAttr')
     D  QMHandle                           options(*OMIT) like(MQ_Handle)
     D  QMName                             options(*OMIT) like(MQ_Name)
     D  QueueName                          like(MQ_Name)
     D  AttrWanted                         like(MQ_Int)
     D  AttrValue                    64A
     D  RetCode                            like(RetCodeBase)
      * -------------------------------------------------------------------  +

      * -------------------------------------------------------------------  +
      * Retreive max depth of a remote queue definition
     D RtvRmtQMaxDepth...
     D                 PR                  extproc('RtvRmtQMaxDepth')
     D  QMHandle                           options(*OMIT) like(MQ_Handle)
     D  QMName                             options(*OMIT) like(MQ_Name)
     D  QueueName                          like(MQ_Name)
     D  MaxDepth                           like(MQ_Int)
     D  RetCode                            like(RetCodeBase)
      * -------------------------------------------------------------------  +


