     H DEBUG NOMAIN
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
     H OPTION(*SRCSTMT : *NODEBUGIO)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPMQPRCS  - Procedures for MQ handling                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 269576 (SFDC)      Date 18Aug08               *
      *                 000820 (Bugzilla)                             *
      *                         *CREATE    Date 28Mar06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  269573 - The fix ensures that all queue managers are stored  *
      *           regardless of the position of the default queue     *
      *           manager stanza in the configuration file.           *
      *                                                               *
      *  000820 - Created to enable routines to work with MQ data     *
      *           such as checking if a queue manager exists          *
      *****************************************************************
      /EJECT

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the prototypes for the procedures
      ** defined in this member.
     D/COPY RPCPYSRC,MQ_PR
      **--------------------------------------------------------------------------------------------

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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D QmgrsMax        C                   const(50)
      * Maximum number of queue managers this program deals with

     D QMDtlsArr       DS                  Dim(QmgrsMax) Qualified
     D  QMName                       48A
     D  LibName                      10A
     D  IsDefault                     1A
      * Queue manager information stored

     D QmgrsListBuilt  S              1A   inz('N')
      * Flag to show that the list of queue managers
      * has been built.

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      * --------------------------------------------------------------------
      * This procedure returns a Y/N as to whether a specified queue
      * manager has been defined.

     P ISMANAGERDEFINED...
     P                 B                   export
     D ISMANAGERDEFINED...
     D                 PI
     D  inManagerName                48A
     D  inputIsAQM                    1A

     D LoopIdx         S              9P 0
      * Index to use on any loop that needs one

      /free
       // If the list of Queue Managers has not been built then build it.
       if QmgrsListBuilt = 'N';
          buildList();
       endif;

       // Check whether the input Queue Manager is in the list
       inputIsAQM = 'N';
       for LoopIdx = 1 by 1 to QmgrsMax;
          if QMDtlsArr(LoopIdx).QMName = inManagerName;
             inputIsAQM = 'Y';
             leave;
          endif;
       endfor;

       // return inputIsAQM;
      /end-free

     P ISMANAGERDEFINED...
     P                 E
      * --------------------------------------------------------------------

      * --------------------------------------------------------------------
      * This procedure builds a list of the queue managers that have been
      * defined together with some of their attributes.
     P buildList       B
     D buildList       PI

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the prototypes for the procedures
      ** used by this member.
     D/COPY MRCPYSRC,MRIFSPROTO
      **--------------------------------------------------------------------------------------------

     D IFSFileName     S            256A
     D OpenForRead     S              1A
     D OpenForWrite    S              1A
     D FileDescriptr   S             10I 0
     D ReturnString    S          32767A
     D StringLength    S             10I 0
     D ReturnValue     S             10I 0

      // SFDC00269573
     D BegString       S          16383A
     D EndString       S          16384A

     D CR              S              1A   inz(x'0D')
     D LFiSeries       S              1A   inz(x'25')
     D LFWindows       S              1A   inz(x'0A')
     D CRLFiSeries     S              2A   inz(x'0D25')
     D CRLFWindows     S              2A   inz(x'0D0A')
     D Terminator      S              2A

     D LoopIdx         S              9P 0
      * Index to use on any loop that needs one

     D ScanResult      S              5P 0 inz(0)
     D ScanResult2     S              5P 0 inz(0)
     D ScanStart       S              5P 0
     D CopyStart       S              5P 0
     D CopyEnd         S              5P 0
     D CopyLength      S              5P 0

      // SFDC00269573
     D StringPart1End  S              5P 0
     D StringPart2Start...
     D                 S              5P 0

     D DFTQMName       S             48A

      /free

       // Open the file /QIBM/UserData/mqm/mqs.ini and read it for
       //  the names of the Queue Managers & associated libraries

       // Request file open with read only
       OpenForRead  = 'Y';
       OpenForWrite = 'N';
       IFSFileName = '/QIBM/UserData/mqm/mqs.ini';
       FileDescriptr = OpenIFS( IFSFileName : OpenForRead : OpenForWrite);
       if FileDescriptr < 0;
          return;
       endif;

       // Read entire contents of file into a long string
       callp ReadIFS( FileDescriptr : ReturnString : StringLength);
       if StringLength < 1;
          return;
       endif;

       // Determine the type of line end being used
       exsr sr_get_term;

       // Data is in the form of
       //  DefaultQueueManager:
       //     Name=LNR
       //  QueueManager:
       //     Name=LNR
       //     Prefix=/QIBM/UserData/mqm
       //     Library=QMLNR0
       //     Directory=LNR
       // with the QueueManager: block being repeated.
       // Initially scan for the first 'DefaultQueueManager:' and get
       // the name then scan for the first 'QueueManager:', and
       // scan for pairs of 'Name=' and 'Library=' and pick up the
       // associated values.

       // Later experiences show that the DefaultQueueManager: stanza
       // need not be before the other stanzas, and fix SFDC00269573
       // addresses this.  As well, a default queue manager does
       // not have to be set, so the code now copes with the absence of
       // this stanza, or with it existing but not having a Name= clause.

       ScanStart = 1;
       ScanResult = %scan('DefaultQueueManager:' : ReturnString : ScanStart);

       // Retrieve the first half of the ReturnString up to the position
       // before the 'DefaultQueueManager:' text.  If the string was not
       // found, then we bypass the next section.
       if ScanResult > 0;

          StringPart1End = ScanResult - 1;
          BegString = %subst(ReturnString : ScanStart : StringPart1End);

          // Start the next scan after the end of the string that was just
          // found ("DefaultQueueManager:").
          ScanStart = ScanResult + 20;
          ScanResult = %scan('Name=' : ReturnString : ScanStart);

          // It may be the case (though it seems unlikely) that there will
          // be a DefaultQueueManager stanza, but no Name= clause within it.
          // However, finding "Name=" will not tell us that, as there
          // are instances of that string in other stanzas.  So we search
          // for the next colon and check its location relevant to the
          // "Name=".  We also take account of the possibility of hitting
          // EoF.
          ScanResult2 = %scan(':' : ReturnString : ScanStart);
          if ScanResult = 0 OR
             (ScanResult2 > 0 AND ScanResult2 < ScanResult);
             StringPart2Start = ScanStart;
          else;

             // Get and store the Default Queue Manager name
             CopyStart  = ScanResult + 5;
             ScanStart  = ScanResult;
             ScanResult = %scan(%trim( Terminator) :
                                ReturnString : ScanStart);

             // Another unlikely possibility: if CopyStart and ScanResult
             // are the same here, then we have a "Name=" clause with no
             // value, in which case we don't want to continue, but we'll
             // still want to make sure the DefaultQueueManager stanza
             // is removed from the string for later scanning.
             if CopyStart = ScanResult;
                StringPart2Start = CopyStart;
             else;

                CopyEnd    = ScanResult - 1;
                CopyLength = CopyEnd - CopyStart + 1;
                DftQMName  = %subst( ReturnString : CopyStart : CopyLength);

                // Retrieve the second part of the ReturnString
                // starting from the position after the name
                // of the DefaultQueueManager to the end of the string.
                StringPart2Start = CopyEnd + 1;

             endif; // End of "if CopyStart = ScanResult"

          endif; // End of "if ScanResult2 < ScanResult OR ScanResult < 0"

          // Join the two strings, omitting the DefaultQueueManager stanza.
          // This will prevent the name of the
          // default queue manager being stored twice once the scanning
          // process for building the list of queue managers starts.
          EndString = %subst( ReturnString : StringPart2Start);
          ReturnString = BegString + EndString;

       endif; // End of "if ScanResult > 0" for DefaultQueueManager:

       // Before scanning for the list of the QueueManagers, set
       // ScanStart to the beginning of the string.  This will
       // ensure that all of the queue managers listed will be stored,
       // irrespective of what happened in the block above.
       ScanStart = 1;

       // Now get and store all the Queue Manager name & information
       for LoopIdx = 1 by 1 to 999999;
          ScanResult = %scan('Name=' : ReturnString : ScanStart);

          if ScanResult = 0;
          // All Queue Managers read so exit loop
             QmgrsListBuilt = 'Y';
             leave;
          endif;

          // Queue Manager found so find the end of the name
          CopyStart  = ScanResult + 5;
          ScanStart  = ScanResult;
          ScanResult = %scan(%trim( Terminator) : ReturnString : ScanStart);
          CopyEnd    = ScanResult - 1;
          CopyLength = CopyEnd - CopyStart + 1;

          // Store the Queue Manager name
          QMDtlsArr(LoopIdx).QMName =
             %subst( ReturnString : CopyStart : CopyLength);

          // Now get the library name
          ScanResult = %scan('Library=' : ReturnString : ScanStart);
          CopyStart  = ScanResult + 8;
          ScanStart  = ScanResult;
          ScanResult = %scan(%trim( Terminator) : ReturnString : ScanStart);
          CopyEnd    = ScanResult - 1;
          CopyLength = CopyEnd - CopyStart + 1;

          // Store the Queue Manager library name
          QMDtlsArr(LoopIdx).LibName =
             %subst( ReturnString : CopyStart : CopyLength);

          // Set a flag to show if this is the Default Queue Manager
          QMDtlsArr(LoopIdx).IsDefault = 'N';
          if QMDtlsArr(LoopIdx).QMName =  DftQMName;
             QMDtlsArr(LoopIdx).IsDefault = 'Y';
          endif;
       endfor;

      /EJECT
       //********************************************************************
       //  sr_get_term    : Find out what line terminator is being used     *
       //********************************************************************
       begsr sr_get_term;

       // Determine the type of line end being used
       ScanResult = %scan( CRLFiSeries : ReturnString);
       if ScanResult > 0;
          Terminator = CRLFiSeries;
          leavesr;
       endif;

       ScanResult = %scan( CRLFWindows : ReturnString);
       if ScanResult > 0;
          Terminator = CRLFWindows;
          leavesr;
       endif;

       ScanResult = %scan( LFiSeries : ReturnString);
       if ScanResult > 0;
          Terminator = LFiSeries;
          leavesr;
       endif;

       ScanResult = %scan( LFWindows : ReturnString);
       if ScanResult > 0;
          Terminator = LFWindows;
          leavesr;
       endif;

       ScanResult = %scan( CR : ReturnString);
       if ScanResult > 0;
          Terminator = CR;
          leavesr;
       endif;

       endsr;

      /end-free

     P buildList       E
      * --------------------------------------------------------------------

