      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  STR_PR     - Prototypes for string-handling procedures       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Last Amend No. CRP013  *CREATE    Date 04Jun01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  CRP013 - New                                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      /if not defined(StrProtosInc)
      /define StrProtosInc

     D rightAlign      PR         32767A   varying
     D   inString                 32767A   varying value
     D   returnLength                10U 0 value options(*nopass)

     D rightAlignFixed10...
     D                 PR            10A
     D   inString                    10A

      /endif
