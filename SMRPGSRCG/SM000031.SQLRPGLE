     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Generic implementation program')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation                                       *
      *                                                               *
      *  SM000031 - Generic implementation program                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CUP042   *CREATE    Date 03Nov14              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - Changes for Bridge deliverable data split           *
      *                                                               *
      *****************************************************************
      *
     D PSubOption      S             20
     D PLayer          S              7
     D PPfx            S              2
     D PSpare          S             50
     D PReturn         S              1
      *
     D ScanPfx         S              2
     D ScanPfx2        S              2
     D SystemName      S              8
     D Item            S             10
     D Type            S             10
     D FoundPos        S              3  0
     D StartPos        S              3  0
     D Command         S            300
     D CommandLen      S             15  5 INZ(300)
     D CommandBld      S                   LIKE(Command)
      *
     D                 DS
     D Spare                   1     50
     D  IASP                   1     10
     D  GPfx                  11     12
     D  SysName               13     20
     D  SubmitJob             21     24
      *
     D/COPY GPCPYSRCG,PSDS
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSubOption
     C                   PARM                    PLayer
     C                   PARM                    PPfx
     C                   PARM                    PSpare
     C                   PARM                    PReturn
      *
     C                   EVAL      Spare = PSpare
     C                   IF        PLayer = '*GLOBAL'
     C                   EVAL      ScanPfx = 'gg'
     C                   ENDIF
     C                   IF        PLayer = '*ZONE  '
     C                   EVAL      ScanPfx = 'zz'
     C                   EVAL      ScanPfx2 = 'gg'
     C                   ENDIF
     C/exec SQL
     C+ whenever SQLERROR goto ERROR
     C/end-exec
      *
     C/exec SQL
     C+ declare SETU cursor for
     C+ select
     C+   DFNAME
     C+ , DFTYPE
     C+ , DFCMD
     C+ from SMIMPJW0
     C+ where
     C+     DFSMNU =  :PSubOption
     C+ and DFLAYR =  :PLayer
     C+ and DFCMD  <> '*NORUN'
     C+ and DFDEL  =  'N'
     C+ order by DFSEQN
     C/end-exec
      *
     C/exec SQL
     C+ open SETU
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from SETU
     C+ into
     C+   :Item
     C+ , :Type
     C+ , :Command
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * Scan the name to see if any characters need substitution.
     C                   EVAL      FoundPos = 999
     C                   EVAL      StartPos = 1
     C                   DOU       FoundPos = 0
     C                   EVAL      FoundPos = %SCAN(ScanPfx:Command:StartPos)
     C                   IF        FoundPos <> 0
     C                   EVAL      %SUBST(Command:FoundPos:2) = PPfx
     C                   EVAL      StartPos = FoundPos + 2
     C                   ENDIF
     C                   ENDDO
      *
      * If this is the zone layer then scan for the global prefix too.
     C                   IF        PLayer = '*ZONE'
     C                   EVAL      FoundPos = 999
     C                   EVAL      StartPos = 1
      *
     C                   DOU       FoundPos = 0
     C                   EVAL      FoundPos = %SCAN(ScanPfx2:Command:StartPos)
     C                   IF        FoundPos <> 0
     C                   EVAL      %SUBST(Command:FoundPos:2) = GPfx
     C                   EVAL      StartPos = FoundPos + 2
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
      * Perform command.
     C                   EVAL      PSExcpType = *blank
     C                   IF        PSubOption = 'CreateLibrary'
     C                   EXSR      LibProc
     C                   ENDIF
     C                   IF        PSubOption = 'AddDirectoryEntry'
     C                   EXSR      DirEntProc
     C                   ENDIF
     C                   IF        PSubOption = 'CreateJobDesc'
     C                   EXSR      JobDescProc
     C                   ENDIF
     C                   IF        PSubOption = 'CreateSubSysDesc'
     C                   EXSR      SubSysDProc
     C                   ENDIF
     C                   IF        SubmitJob = '*YES'
     C                   EVAL      Command = 'SBMJOB CMD(' + Command
     C                   EVAL      Command = %TRIMR(Command) + ') JOB(' + Type
     C                   EVAL      Command = %TRIMR(Command) + ') JOBD(SETUP) +
     C                             JOBQ(SMJOBQNM)'
     C                   ENDIF
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      * Check for error; the program is not trapping
      * - error on creation if the object already exists
      * - error on deletion / removal if object or item does not alraedy exist
     C                   IF        PSExcpType <> *blank
     C                   EXSR      ErrorCheck
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from SETU
     C+ into
     C+   :Item
     C+ , :Type
     C+ , :Command
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close SETU
     C/end-exec
      *
     C     ERROR         TAG
     C                   IF        SQLCODE < 0
     C                   EVAL      PReturn = 'E'
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * Check for specific error messages                             *
      *                                                               *
      *****************************************************************
      *
     C     ErrorCheck    BEGSR
      *
      * Library already exists.
     C                   IF        PSExcpNo <> '2111'
      * User profile already exists.
     C                             and PSExcpNo <> '2214'
      * Authorisation list already exists.
     C                             and PSExcpNo <> '2278'
      * Authorisation list entry does not exist.
     C                             and PSExcpNo <> '2285'
      * Authorisation list entry already exists.
     C                             and PSExcpNo <> '2282'
      * Directory entry already exists.
     C                             and PSExcpNo <> '9082'
      * Object already exists.
     C                             and PSExcpNo <> '7010'
      * Error in creating journal.
     C                             and PSExcpNo <> '7015'
      * Subsystem not changed.
     C                             and PSExcpNo <> '1697'
      * Active subsystem may or may not changed.
     C                             and PSExcpNo <> '1691'
      * File not created.
     C                             and PSExcpNo <> '7302'
      * Job queue already exists.
     C                             and PSExcpNo <> '3323'
      * Message queue already exists.
     C                             and PSExcpNo <> '2112'
      * Job description not created.
     C                             and PSExcpNo <> '1621'
      * Class already exists.
     C                             and PSExcpNo <> '1064'
      * Subsystem description not created.
     C                             and PSExcpNo <> '1696'
      * Output queue already exists.
     C                             and PSExcpNo <> '3353'
      * Data area already exists.
     C                             and PSExcpNo <> '1023'
     C                   EVAL      PReturn = 'E'
     C                   ENDIF
      *
     C     ErrorCheckE   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Special processing for libraries.                             *
      *                                                               *
      *****************************************************************
      *
     C     LibProc       BEGSR
      *
      * Check if the spare parameter contains an IASP.
     C                   IF        IASP <> *blank
     C                   IF        %SUBST(Item:3:8) <> 'XLIB'
     C                             and %SUBST(Item:3:8) <> 'GXLIB'
     C                   EVAL      Command = %TRIMR(Command) + ' ASPDEV(' +
     C                             IASP + ')'
     C                   ENDIF
     C                   ENDIF
      *
     C     LibProcE      ENDSR
      *
      *****************************************************************
      *                                                               *
      * Special processing for directory entries.                     *
      *                                                               *
      *****************************************************************
      *
     C     DirEntProc    BEGSR
      *
     C                   EVAL      CommandBld = *blanks
      * Put system name into command string; search for first open bracket ...
     C                   EVAL      FoundPos = %SCAN('(':Command:1)
     C                   EVAL      StartPos = FoundPos
      * ... and then look for next space.
     C                   EVAL      FoundPos = %SCAN(' ':Command:StartPos)
      * Start to build command string.
     C                   EVAL      StartPos = FoundPos
     C                   EVAL      CommandBld = %SUBST(Command:1:StartPos)
      * Add system name.
     C                   EVAL      CommandBld = %TRIMR(CommandBld) + ' ' +
     C                             SysName
      * Add the rest of the command; find the closing bracket first.
     C                   EVAL      FoundPos = %SCAN(')':Command:StartPos)
     C                   EVAL      StartPos = FoundPos
     C                   EVAL      CommandBld = %TRIMR(CommandBld) +
     C                             %SUBST(Command:StartPos:100)
     C                   EVAL      Command = CommandBld
      *
     C     DirEntProcE   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Special processing for job descriptions                       *
      *                                                               *
      *****************************************************************
      *
     C     JobDescProc   BEGSR
      *
      * Check if the spare parameter contains an IASP.
     C                   IF        IASP <> *blank
     C                   EVAL      Command = %TRIMR(Command) + ' INLASPGRP(' +
     C                             IASP + ')'
     C                   ENDIF
      *
     C     JobDescProcE  ENDSR
      *
      *****************************************************************
      *                                                               *
      * Special processing for subsystem descriptions                 *
      *                                                               *
      *****************************************************************
      *
     C     SubSysDProc   BEGSR
      *
      * Check if the spare parameter contains an IASP.
     C                   IF        IASP <> *blank
     C                   EVAL      Command = %TRIMR(Command) + ' ASPGRP(' +
     C                             IASP + ')'
     C                   ENDIF
      *
     C     SubSysDProcE  ENDSR
      *
