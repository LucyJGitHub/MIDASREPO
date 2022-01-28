      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  LOG_WRITE - Journal Feeder                                   *
      *                                                               *
      *  Function:  These prototypes are used by procedure that       *
      *             enable RPG & CL routines to write to the log file.*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. CRP026             Date 18Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  CRP026 - New procedure (CloseLog) introduced as part of      *
      *           Feeder rewrite.                                     *
      *                                                               *
      *****************************************************************
      /if defined(LOG_WRITE_inc)
      /eof
      /else
      /define LOG_WRITE_inc
      /endif

      *--------------------------------------------------------------------
      * Prototype for Replication RPG procedure ErrorOut  - a wrapper to
      *  the C procedure logout
      *--------------------------------------------------------------------
     D ErrorOut        PR
     D Process                       25A   const
     D ErrorString                 1024A   const
      *--------------------------------------------------------------------

      *--------------------------------------------------------------------
      * Prototype for Replication RPG procedure EntryOut  - a wrapper to
      *  the C procedure logout
      *--------------------------------------------------------------------
     D EntryOut        PR
     D Process                       25A   const
     D EntryString                 1024A   const
      *--------------------------------------------------------------------

      *--------------------------------------------------------------------
      * Prototype for Replication RPG procedure TraceOut  - a wrapper to
      *  the C procedure logout
      *--------------------------------------------------------------------
     D TraceOut        PR
     D Process                       25A   const
     D TraceString                 1024A   const
      *--------------------------------------------------------------------

      *--------------------------------------------------------------------
      * Prototype for Replication RPG procedure DebugOut  - a wrapper to
      *  the C procedure logout
      *--------------------------------------------------------------------
     D DebugOut        PR
     D Process                       25A   const
     D DebugString                 1024A   const
      *--------------------------------------------------------------------

      *--------------------------------------------------------------------
      * Prototype for Replication C function close_log
      *--------------------------------------------------------------------
     D CloseLog        PR
      *--------------------------------------------------------------------

      *--------------------------------------------------------------------
     D NowDefault      S             10I 0 INZ(0)
     D ProcessDefault  S               *

     D LOG_ERROR       C                   const(1)
     D LOG_ENTRY       C                   const(2)
     D LOG_TRACE       C                   const(3)
     D LOG_DEBUG       C                   const(4)

     D StringToWrite   S           1024A
     D ProcessToWrite  S             25A

     D pOutData        S               *

     D pOutProcess     S               *
      *--------------------------------------------------------------------

