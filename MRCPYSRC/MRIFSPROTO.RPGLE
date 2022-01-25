      /if defined(MRIFSPROTO_inc)
      /eof
      /else
      /define MRIFSPROTO_inc
      /endif

      * -------------------------------------------------------------------
      *
      *  The object created from this source is now used in the iSeries
      *  Management software and in Replication.
      *  If this member is changed an updated object may need to be
      *  copied to Replication.
      *
      *  --------------
      *  Change History
      *  --------------
      *  Date (ISO)  ID       Who   Description (multiple lines if needed)
      *  ----------  --       ---   ----------------------------------------
      *
      *  2021-12-16  MD058809       After installation of MQ9 compatibility patch and
      *                             restart of the Meridian Replication subsystem
      *                             REPMIDASPT, the job MPT1PBSIN ended in MSGW.
      *  2006-03-28  000820   SAO   The object created from this source
      *                             is now used in the iSeries Management
      *                             software and in Replication.
      *                             If this member is changed an updated
      *                             object may need to be copied to
      *                             Replication.
      *
      *  2006-01-04  BUG754   MM    The fclear() API is not supported at
      *                             previous releases (despite the
      *                             compiler not catching this fact).  But
      *                             the ClearIFS() procedure is not
      *                             actually used, so we have commented it
      *                             out.
      *
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * Open an IFS file

     D OpenIFS         PR            10I 0   extproc('OpenIFS')
     D  Filename                    256A     value
     D  OpenForRead                   1A     value
     D  OpenForWrite                  1A     value
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * Open an IFS file with a specified CCSID

     D OpenIFS_CCSID   PR            10I 0   extproc('OpenIFS_CCSID')
     D  Filename                    256A     value
     D  OpenForRead                   1A     value
     D  OpenForWrite                  1A     value
     D  CCSID                         5P 0   value
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * Read from IFS file

     D ReadIFS         PR                    extproc('ReadIFS')
     D  FileDescriptr                10I 0
     D  ReturnString              32767A
     D  StringLength                 10I 0
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * Write to an IFS file starting at a specified offset

     D WriteOffsetIFS  PR            10I 0   extproc('WriteOffsetIFS')
     D  FileDescriptr                10I 0   value
     D  StringToWrite             32767A
     D  StringLength                 10I 0   value
     D  Offset                       10I 0   value
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * Close

     D CloseIFS        PR            10I 0   extproc('CloseIFS')
     D  FileDescriptr                10I 0   value
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * getErrorInt

     D getErrorInt     PR            10I 0
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * Clear an IFS file

     D*ClearIFS********PR            10I 0
     D**FileDescriptr**              10I 0
     D**StringLength***              10I 0
      * -------------------------------------------------------------------

      * -------------------------------------------------------------------
      * Write to an IFS file

     D WriteIFS        PR            10I 0
     D  FileDescriptr                10I 0
     D  StringToWrite             32767A
     D  StringLength                 10I 0
      * -------------------------------------------------------------------

