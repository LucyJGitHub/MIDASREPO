     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPLOGWRITE - Functions to write to log file (X6PF)           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. CRP026             Date 18Jul05               *
      *                 CRP020             Date 20Feb02               *
      *                 CRP019  *CREATE    Date 16Dec02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  CRP026 - New procedure (CloseLog) introduced as part of      *
      *           Feeder rewrite.                                     *
      *  CRP020 - Add comments relating type of message to the number *
      *           on X6PF                                             *
      *  CRP019 - Introduce a Monitor of the Feeder job               *
      *           These procedures added to enable the monitor to     *
      *           write to the log file.                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  There are four procedures in this module, each of which      *
      *  relates to a particular type of X6PF message                 *
      *                                                               *
      *  Proc.    X6PF Purpose                                        *
      *           No.                                                 *
      *  =====    ==== =======                                        *
      *                                                               *
      *  ErrorOut  1   Errors - unexpected events                     *
      *  EntryOut  2   Main processing steps - submit/start/stop etc  *
      *  TraceOut  3   Detailed processing steps - message read or    *
      *                written, queue manager committed               *
      *  DebugOut  4   More detailed info - Journal Entry read.       *
      *                                                               *
      *****************************************************************
      /EJECT

      *--------------------------------------------------------------------
      * Prototype for Replication C procedure logout - to make it
      *  accessible to RPG
      *--------------------------------------------------------------------
     D logoutR         PR              *   extproc('logout')
     D  Now                          10I 0 value
     D pProcess                        *   value
     D  Level                        10I 0 value
     D pDataToLog                      *   value

      *--------------------------------------------------------------------
      * Prototype for Replication C procedure close_log to make it
      *  accessible to RPG
      *--------------------------------------------------------------------
     D close_logR      PR                  extproc('close_log')

      *--------------------------------------------------------------------

      * Following /COPY contains the prototypes and the standard fields
      *   used by these routines
      /COPY RPCPYSRC,LOG_WRITE

     D LogLevelIn      S              1A   inz('N')
     D LogLevel        S              5S 0 dtaara(KMDLEV)

      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END

     C                   SETON                                        U7U8LR
     C                   RETURN

     C                   ENDSR
      /EJECT

      *****************************************************************
      *    Procedure   : ErrorOut                                     *
      *    Purpose     : Write an ERROR level message to the log file *
      *    Called by   : External routine                             *
      *****************************************************************

     P ErrorOut        B                   export
     D                 PI
     D   Process                     25A   const
     D   ErrorString               1024A   const

     C                   if        LogLevelIn = 'N'
     C                   eval      LogLevelIn = 'Y'
     C                   in        LogLevel
     C                   endif

     C                   if        LOG_ERROR <= LogLevel

      * The Process name / Message to be written needs to passed as a
      *  pointer, which is extracted using %addr.  However %addr does not
      *  work on the incoming parameter (possibly because of 'const') so
      *  the parameter is put into an ordinary field first.
     C                   eval      ProcessToWrite = Process
     C                   eval      pOutProcess = %addr(ProcessToWrite)
     C                   eval      StringToWrite = ErrorString
     C                   eval      pOutData = %addr(StringToWrite)

     C                   callp     logoutR(NowDefault : pOutProcess :
     C                                     LOG_ERROR : pOutData)

     C                   endif

     P ErrorOut        E

      *****************************************************************
      *    Procedure   : EntryOut                                     *
      *    Purpose     : Write an ENTRY level message to the log file *
      *    Called by   : External routine                             *
      *****************************************************************

     P EntryOut        B                   export

     D                 PI
     D   Process                     25A   const
     D   EntryString               1024A   const

     C                   if        LogLevelIn = 'N'
     C                   eval      LogLevelIn = 'Y'
     C                   in        LogLevel
     C                   endif

     C                   if        LOG_ENTRY <= LogLevel

      * The Process name / Message to be written needs to passed as a
      *  pointer, which is extracted using %addr.  However %addr does not
      *  work on the incoming parameter (possibly because of 'const') so
      *  the parameter is put into an ordinary field first.
     C                   eval      ProcessToWrite = Process
     C                   eval      pOutProcess = %addr(ProcessToWrite)
     C                   eval      StringToWrite = EntryString
     C                   eval      pOutData = %addr(StringToWrite)

     C                   callp     logoutR(NowDefault : pOutProcess :
     C                                     LOG_ENTRY : pOutData)

     C                   endif

     P EntryOut        E

      *****************************************************************
      *    Procedure   : TraceOut                                     *
      *    Purpose     : Write an TRACE level message to the log file *
      *    Called by   : External routine                             *
      *****************************************************************

     P TraceOut        B                   export

     D                 PI
     D   Process                     25A   const
     D   TraceString               1024A   const

     C                   if        LogLevelIn = 'N'
     C                   eval      LogLevelIn = 'Y'
     C                   in        LogLevel
     C                   endif

     C                   if        LOG_TRACE <= LogLevel

      * The Process name / Message to be written needs to passed as a
      *  pointer, which is extracted using %addr.  However %addr does not
      *  work on the incoming parameter (possibly because of 'const') so
      *  the parameter is put into an ordinary field first.
     C                   eval      ProcessToWrite = Process
     C                   eval      pOutProcess = %addr(ProcessToWrite)
     C                   eval      StringToWrite = TraceString
     C                   eval      pOutData = %addr(StringToWrite)

     C                   callp     logoutR(NowDefault : pOutProcess :
     C                                     LOG_TRACE : pOutData)

     C                   endif

     P TraceOut        E

      *****************************************************************
      *    Procedure   : DebugOut                                     *
      *    Purpose     : Write an DEBUG level message to the log file *
      *    Called by   : External routine                             *
      *****************************************************************

     P DebugOut        B                   export

     D                 PI
     D   Process                     25A   const
     D   DebugString               1024A   const

     C                   if        LogLevelIn = 'N'
     C                   eval      LogLevelIn = 'Y'
     C                   in        LogLevel
     C                   endif

     C                   if        LOG_DEBUG <= LogLevel

      * The Process name / Message to be written needs to passed as a
      *  pointer, which is extracted using %addr.  However %addr does not
      *  work on the incoming parameter (possibly because of 'const') so
      *  the parameter is put into an ordinary field first.
     C                   eval      ProcessToWrite = Process
     C                   eval      pOutProcess = %addr(ProcessToWrite)
     C                   eval      StringToWrite = DebugString
     C                   eval      pOutData = %addr(StringToWrite)

     C                   callp     logoutR(NowDefault : pOutProcess :
     C                                     LOG_DEBUG : pOutData)

     C                   endif

     P DebugOut        E


      *****************************************************************
      *    Procedure   : CloseLog                                     *
      *    Purpose     : Close log file                               *
      *    Called by   : External routine                             *
      *****************************************************************

     P CloseLog        B                   export

     D                 PI

      * Call C routine to actually close log file.

     C                   callp     close_logR()

     P CloseLog        E

