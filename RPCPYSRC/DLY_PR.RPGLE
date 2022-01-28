      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  DLY_PR     - Prototypes for delay/retry procedures           *
      *                                                               *
      *  Function:  This member contains the prototypes for some      *
      *  delaying and retrying procedures.                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 128748 Supportforce Date 13Sep06              *
      *                 CRP013  *CREATE    Date 04Jun01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  128748 - Add in prototype for generic job delay CL           *
      *           Remove prototypes no longer needed                  *
      *  CRP013 - New                                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      /if not defined(DlyProtosInc)
      /define DlyProtosInc

     D*getWaitTime**** PR            10I 0                                      128748

     D*getTotalTries** PR            10I 0                                      128748

     D*getTimesTried** PR            10I 0                                      128748

     D*setTimesTried** PR                                                       128748
     D***timesTried***               10I 0 value                                128748

     D RPDELAY         PR                                                       128748
     D   delayTime                   10I 0                                      128748
                                                                                128748
      /endif
