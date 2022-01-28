     H DEBUG NOMAIN
     H OPTION(*SRCSTMT : *NODEBUGIO)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPMQINQ   - Wrapper function around MQINQ                    *
      *                                                               *
      *  Function:  This module receives requests for information     *
      *             about an MQ object, gets the information by means *
      *             of MQINQ and returns it to the caller.            *
      *                                                               *
      *  As originally written, this module contained a single        *
      *  procedure, RtvQAttr, that gets a single queue attribute      *
      *  using a Queue Manager handle supplied by the caller.         *
      *  During development other functions were needed, such as      *
      *  getting an attribute when the caller does not have a QM      *
      *  handle, so new procedure(s) have been written.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
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

      **  Prototypes for procedures used by this module
     D/copy RPCPYSRC,MQBASIC

      **  Prototypes for procedures defined in this module
     D/copy RPCPYSRC,MQINQWRAP

      /EJECT
      * -------------------------------------------------------------------
      * Retreive a single attribute of a queue
      * If the caller has a Handle for the appropriate Queue Manager
      *  then it should pass that in as parameter 1, with *OMIT in
      *  parameter 2.  If the caller does not have  a Handle for the
      *  Queue Manager then it should pass *OMIT in parameter 1 and
      *  the Queue Manager name in parameter 2.
     P RtvQAttr        B                   export
     D RtvQAttr        PI
     D  QMHandleIn                         options(*OMIT) like(MQ_Handle)
     D  QMName                             options(*OMIT) like(MQ_Name)
     D  QueueName                          like(MQ_Name)
     D  AttrWanted                         like(MQ_Int)
     D  AttrValue                    64A
     D  RetCodeOut                         like(RetCodeBase)

     D RunMode         S              6A
      * Has this procedure been called with a Name or a Handle

     D QMHandleToUse   S                   like(QMHandleIn) static
      * Cannot use the field 'QMHandleIn' in this code because a
      *  'Pointer not set' error will occur when a handle is not
      *  passed in

     D QMHandleAlreadyExistedInCaller...
     D                 S              1A   inz('N') static

     D QueueHandle     S                   static like(MQ_Handle)

     D SelCount        S                   inz(1) like(MQ_Int)
      * Count of selectors passed to MQINQ - always 1
     D Selector        S                   like(MQ_Int)
      * 'Array' of selectors passed to MQINQ - only one element
     D IntAttrCount    S                   inz(1) like(MQ_Int)
      * Count of integer atributes expected from MQINQ - 0 or 1
     D IntAttrArr      S                   like(MQ_Int)
      * 'Array' of integer atributes returned by MQINQ - only 1 element
     D CharAttrLen     S                   inz(64) like(MQ_Int)
      * Length of character attributes buffer expected from MQINQ
     D CharAttrBuff    S             64A
      * Buffer of character attributes returned by MQINQ

     D OPTS            S                   like(MQ_Int)
      * Options
     D CMPCOD          S                   like(MQ_Int)
      * Completion Code
     D REASON          S                   like(MQ_Int)
      * Reason Code

     D OpenFlags       S             64A   inz('INQUIRE')

     D RetCodeIn       S                   like(RetCodeBase)
      * Return Code received from called routines

     D SRSTack         S             64    dim(100)
     D SRIdx           S              3P 0 inz(0)
     D* Subroutine stack

      * -------------------------------------------------------------------
      /free
        // Routine may be called without reinitialisation.  If called
        //  a second time but the inquiry is not successful, e.g.
        //  looking for an attribute not applicable to that type of
        //  call, any variables that have been passed back to the
        //  caller will have their value from the first call which
        //  may cause a problem.
        //  Solution is simply to clear these variables.
        clear AttrValue;
        clear RetCodeOut;

        // Exactly one of the queue manager handle and the queue
        //  manager name must be specified
        if    %addr( QMHandleIn) = *NULL AND %addr( QMName) = *NULL
           OR %addr( QMHandleIn) <> *NULL AND %addr( QMName) <> *NULL;
           RetCodeOut = 'Queue manager handle or name, but not both, +
                         must be passed';
           return;
        endif;

        // Check if an MQINQ is actually needed
        // Valid attribute values will either be in the range IAFRST
        // to IALAST or in the range CAFRST to CALAST.
        // If the attribute value asked for is outside both of these
        // ranges then report an error
        if     AttrWanted < IAFRST OR AttrWanted > IALAST
           AND AttrWanted < CAFRST OR AttrWanted > CALAST;
           RetCodeOut = 'Attribute selected is not valid';
           return;
        endif;

        // Set run mode so code knows if we have a QM handle or a QM name
        if %addr( QMHandleIn) <> *NULL;
           RunMode = 'Handle';
           QMHandleToUse = QMHandleIn;
        else;
           RunMode = 'Name';
        endif;

        // If passsed a QM name rather than a QM handle get a
        //  Queue Manager handle
        if RunMode = 'Name';
           QMHandleToUse = ConnectToQM( QMName : RetCodeIn);
           if QMHandleToUse = -1;
              RetCodeOut = RetCodeIn;
              return;
           endif;
           if RetCodeIn = 'MQ_RC_' + %char( RC2002);
           // This should never happen, if the caller has a handle it
           //  should be passed, but better safe than sorry
              RetCodeIn = *BLANK;
              QMHandleAlreadyExistedInCaller = 'Y';
           endif;
        endif;

        // Perform actual processing
        exsr ConnectAndEnquire;

        CloseMQQueue( QMHandleToUse : QueueHandle);
        if RunMode = 'Name';
           // If passsed a QM name rather than a QM handle
           DisconnectFromQM( QMHandleToUse);
        endif;

      /EJECT
       // ***************************************************************
        begsr ConnectAndEnquire;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'ConnectAndEnquire';

        // Open queue for inquiry as most opens will not do this.
        QueueHandle = OpenMQQueue( QMHandleToUse : QueueName :
                                   OpenFlags : RetCodeIn);
        if QueueHandle = -1;
           RetCodeOut = RetCodeIn;
           return;
        endif;

        Selector = AttrWanted;
        callp MQINQ( QMHandleToUse : QueueHandle : SelCount :
                 Selector : IntAttrCount : IntAttrArr : CharAttrLen :
                 %addr( CharAttrBuff) : CMPCOD : REASON);

        // Cater for Selector not applicable to queue type
        if REASON = RC2068;
           RetCodeOut = %char( REASON) + ': Selector not applicable +
                     to this type of queue. Queue is ' + QueueName;
        else;
           // Cater for Selector not applicable to queues
           if REASON = RC2067;
              RetCodeOut = %char( REASON) + ': Selector not +
                        applicable to queues. Queue is ' + QueueName;
           else;
              // Treat other non-zero reason codes as an error
              if REASON <> RCNONE;
                 RetCodeOut = 'When inquiring on queue ' + QueueName +
                      ': Reason code ' + %char( REASON) + ' received';
              else;

                 // Get the returned value from the field it is in
                 if IALAST >= Selector AND Selector >= IAFRST;
                    AttrValue = %char( IntAttrArr);
                 endif;
                 if CALAST >= Selector AND Selector >= CAFRST;
                    AttrValue = CharAttrBuff;
                 endif;
              endif;
           endif;
        endif;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************

      /end-free
      * -------------------------------------------------------------------
     P RtvQAttr        E
      * -------------------------------------------------------------------
      /EJECT
      * -------------------------------------------------------------------
      * Retrieve max depth of a remote queue definition
      *  A remote queue definition does not have a max depth,
      *  what is actually wanted is the max depth of the associated
      *  transmission queue.
     P RtvRmtQMaxDepth...
     P                 B                   export
     D RtvRmtQMaxDepth...
     D                 PI
     D  QMHandle                           options(*omit) like(MQ_Handle)
     D  QMName                             options(*omit) like(MQ_Name)
     D  QueueNameIn                        like(MQ_Name)
     D  MaxDepth                           like(MQ_Int)
     D  RetCodeOut                         like(RetCodeBase)

     D QueueNameToUse  S                   like(MQ_Name)
      * As two different queue names are used (Rmt and Xmit) the value
      *  used must be different from the input value to prevent the
      *  input value from being updated

     D RunMode         S              6A
      * Have we been called with a Name or a Handle

     D AttrWanted      S                   like(MQ_Int)
     D AttrValue       S             64A

     D RetCodeIn       S                   like(RetCodeBase)
      * Return Code received from called routines

     D ErrorOnCall     S              1A   inz('N')

      * -------------------------------------------------------------------
      /free
        clear RetCodeOut;
        reset ErrorOnCall;
        clear MaxDepth;

        // Set run mode so code knows if we have a QM handle or a QM name
        if %addr( QMHandle) <> *NULL;
           RunMode = 'Handle';
        else;
           RunMode = 'Name';
        endif;

        //  First get the transmission queue associated with the
        //  remote queue definition
        AttrWanted = CAXQN;
        QueueNameToUse = QueueNameIn;
        if RunMode = 'Handle';
           callp RtvQAttr ( QMHandle : *OMIT : QueueNameToUse : AttrWanted :
                             AttrValue : RetCodeIn);
        else;
           callp RtvQAttr ( *OMIT : QMName : QueueNameToUse : AttrWanted :
                             AttrValue : RetCodeIn);
        endif;

        if RetCodeIn <> *BLANK;
           // Simply pass all MQ errors back to the caller
           ErrorOnCall = 'Y';
           RetCodeOut = RetCodeIn;
        else;
           if AttrValue = *BLANK;
              // Cater for remote queue definition does not have a
              // transmission queue.
              // It is not clear if this condition will ever be met
              // as removing the xmit queue from a remote queue seems
              // to cause a 2087 (MQRC_UNKNOWN_REMOTE_Q_MGR) error.
              ErrorOnCall = 'Y';
              RetCodeOut = 'No transmission queue defined';
           endif;
        endif;

        if ErrorOnCall = 'Y';
           return;
        endif;

        // To get to here there must be no error and an
        // transmission queue defined
        QueueNameToUse = AttrValue;
        AttrWanted = IAMDEP;
        if RunMode = 'Handle';
           callp RtvQAttr ( QMHandle : *OMIT : QueueNameToUse : AttrWanted :
                             AttrValue : RetCodeIn);
        else;
           callp RtvQAttr ( *OMIT : QMName : QueueNameToUse : AttrWanted :
                             AttrValue : RetCodeIn);
        endif;

        if RetCodeIn <> *BLANK;
           RetCodeOut = RetCodeIn;
           return;
        endif;

        MaxDepth = %int( AttrValue);

      /end-free
      * -------------------------------------------------------------------
     P RtvRmtQMaxDepth...
     P                 E
      * -------------------------------------------------------------------
