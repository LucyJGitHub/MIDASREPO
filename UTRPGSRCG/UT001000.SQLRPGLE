     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Populate UTQHSTTD from QHST log')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT001000 - Populate UTQHSTTD from QHST log                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CPK030   *CREATE    Date 19Feb14              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPK030 - New utility to store start and end data of jobs     *
      *                                                               *
      *****************************************************************
      *
     D PStartMDate     S              6
     D PStartMTime     S              6
     D PEndMDate       S              6
     D PEndMTime       S              6
      *
     D StartMDate      S              6
     D EndMDate        S              6
     D EndMDateTime    S             12
     D StartMDateTime  S             12
     D StartDate       S              6
     D StartTime       S              6
     D EndDate         S              6
     D EndTime         S              6
     D SpoolRecord     S            132
     D JobUser         S             10
     D JobName         S             10
     D Day             S              2
     D Month           S              2
     D Year            S              2
     D FullDate        S              6
     D Hour            S              2
     D Minute          S              2
     D Second          S              2
     D FullTime        S              6
     D FullDateTime    S             12
     D FindPos         S              3  0
     D StartPos        S              3  0
     D Length          S              2  0
     D BorA            S              1
     D Recursive       S              1
      *
     D SpoolData       DS
     D  JobNumber             31     36
     D  TheRest               38    132
      *
     C     *ENTRY        PLIST
     C                   PARM                    PStartMDate
     C                   PARM                    PStartMTime
     C                   PARM                    PEndMDate
     C                   PARM                    PEndMTime
      *
      * Convert dates so that they can be compared more easily.
     C                   EVAL      StartMDate = %SUBST(PStartMDate:5:2) +
     C                             %SUBST(PStartMDate:3:2) +
     C                             %SUBST(PStartMDate:1:2)
     C                   EVAL      EndMDate = %SUBST(PEndMDate:5:2) +
     C                             %SUBST(PEndMDate:3:2) +
     C                             %SUBST(PEndMDate:1:2)
     C                   EVAL      StartMDateTime = StartMDate + PStartMTime
     C                   EVAL      EndMDateTime = EndMDate + PEndMTime
      *
      * Read file to find the started jobs.
     C                   EXSR      CheckForStart
      *
      * Read file to find the ended jobs.
     C                   EXSR      CheckForEnd
      *
      * Finally delete any records where the start date / time was after the
      *  end milestone ...
     C/exec SQL
     C+ delete from UTQHSTTD
     C+ where QHEDAT = 'A'
     C/end-exec
      *
      * ... and update any orphaned start data (where the job ended after the
      * end check date / time.
     C/exec SQL
     C+ update UTQHSTTD
     C+ set
     C+   QHEDAT = 'na'
     C+ , QHETIM = ' '
     C+ where
     C+     QHEDAT = 'B'
     C+ and QHETIM = ' '
     C/end-exec
      *
     C                   RETURN
      /EJECT
      ********************************************************************
      *
     C     Breakdown     BEGSR
      *
     C                   EVAL      StartPos = 2
      * Find the job user.
     C                   EVAL      FindPos = %SCAN('/':TheRest:StartPos)
     C                   EVAL      Length = FindPos - StartPos + 1
     C                   EVAL      JobUser = %SUBST(TheRest:1:Length)
      *
      * Find the job name.
     C                   EVAL      StartPos = FindPos + 1
     C                   EVAL      FindPos = %SCAN(' ':TheRest:StartPos)
     C                   EVAL      Length = FindPos - StartPos + 1
     C                   EVAL      JobName =
     C                             %SUBST(TheRest:StartPos:Length)
      *
      * Find the date.
     C                   EVAL      StartPos = FindPos + 1
     C                   EVAL      FindPos = %SCAN('/':TheRest:StartPos)
     C                   EVAL      Day =
     C                             %SUBST(TheRest:(FindPos - 2):2)
     C                   EVAL      Month =
     C                             %SUBST(TheRest:(FindPos + 1):2)
     C                   EVAL      Year =
     C                             %SUBST(TheRest:(FindPos + 4):2)
     C                   EVAL      FullDate = Year + Month + Day
      *
      * Find the time.
     C                   EVAL      StartPos = FindPos + 1
     C                   EVAL      FindPos = %SCAN(':':TheRest:StartPos)
     C                   EVAL      Hour =
     C                             %SUBST(TheRest:(FindPos - 2):2)
     C                   EVAL      Minute =
     C                             %SUBST(TheRest:(FindPos + 1):2)
     C                   EVAL      Second =
     C                             %SUBST(TheRest:(FindPos + 4):2)
     C                   EVAL      FullTime = Hour + Minute + Second
      *
     C                   EVAL      FullDateTime = FullDate + FullTime
      *
     C     BreakdownE    ENDSR
      *
      /EJECT
      ********************************************************************
      *
     C     WriteRec      BEGSR
      *
     C/exec SQL
     C+ insert into UTQHSTTD
     C+ (
     C+   QHJNAM
     C+ , QHJUSR
     C+ , QHJNUM
     C+ , QHSDAT
     C+ , QHSTIM
     C+ , QHEDAT
     C+ , QHETIM
     C+ )
     C+ values
     C+ (
     C+   :JobName
     C+ , :JobUser
     C+ , :JobNumber
     C+ , :StartDate
     C+ , :StartTime
     C+ , :EndDate
     C+ , :EndTime
     C+ )
     C/end-exec
      *
     C     WriteRecE     ENDSR
      *
      /EJECT
      ********************************************************************
      *
     C     CheckStart    BEGSR
      *
     C/exec SQL
     C+ select
     C+   QHSDAT
     C+ , QHSTIM
     C+ into
     C+   :StartDate
     C+ , :StartTime
     C+ from UTQHSTTD
     C+ where
     C+     QHJNAM = :JobName
     C+ and QHJUSR = :JobUser
     C+ and QHJNUM = :JobNumber
     C/end-exec
      *
     C     CheckStartE   ENDSR
      *
      /EJECT
      ********************************************************************
      *
     C     CheckForStart BEGSR
      *
     C/exec SQL
     C+ declare CFS cursor for
     C+ select * from UTC001000F
     C+ where substr(UTC001000F,1,7) = 'CPF1124'
     C/end-exec
      *
     C/exec SQL
     C+ open CFS
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CFS
     C+ into :SpoolRecord
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * Breakdown the data from the flat file.
     C                   EVAL      SpoolData = SpoolRecord
     C                   EXSR      Breakdown
      *
      * Check if the date / time is within the milestone.
     C                   IF        FullDateTime >= EndMDateTime
     C                   EVAL      BorA = 'A'
     C                   ELSE
     C                   EVAL      BorA = 'B'
     C                   ENDIF
      *
      * Write record to the holding file.
     C                   EVAL      StartDate = FullDate
     C                   EVAL      StartTime = FullTime
     C                   EVAL      EndDate = BorA
     C                   EVAL      EndTime = *blanks
     C                   EXSR      WriteRec
      *
     C/exec SQL
     C+ fetch next
     C+ from CFS
     C+ into :SpoolRecord
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close CFS
     C/end-exec
      *
     C     CheckForStartEENDSR
      *
      /EJECT
      ********************************************************************
      *
     C     CheckForEnd   BEGSR
      *
     C/exec SQL
     C+ declare CFE cursor for
     C+ select * from UTC001000F
     C+ where substr(UTC001000F,1,7) = 'CPF1164'
     C/end-exec
      *
     C/exec SQL
     C+ open CFE
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CFE
     C+ into :SpoolRecord
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * Breakdown the data from the flat file.
     C                   EVAL      SpoolData = SpoolRecord
     C                   EXSR      Breakdown
      *
      * If the job end date / time is before the milestone start date / time
      *  then check if there was a start record already written ...
     C                   IF        FullDateTime < StartMDateTime
     C                   EXSR      CheckStart
      * As the job ended before the milestones we are not interested in it and
      *  so, if a record already exists, it can be deleted ...
     C                   IF        SQLCODE = 0
     C/exec SQL
     C+ delete from UTQHSTTD
     C+ where
     C+     QHJNAM = :JobName
     C+ and QHJUSR = :JobUser
     C+ and QHJNUM = :JobNumber
     C/end-exec
      *
      * ... or just ignored.
     C                   ENDIF
      *
      * ... else either update existing record (containg start data or write
      *  new record with just end data.
     C                   ELSE
     C                   EXSR      CheckStart
      * If a record already exists for the job it will contain start data;
      *  update with end data ...
     C                   IF        SQLCODE = 0
     C/exec SQL
     C+ update UTQHSTTD
     C+ set
     C+   QHEDAT = :FullDate
     C+ , QHETIM = :FullTime
     C+ where
     C+     QHJNAM = :JobName
     C+ and QHJUSR = :JobUser
     C+ and QHJNUM = :JobNumber
     C/end-exec
      *
      * ... or write new record with just end data.
     C                   ELSE
     C                   EVAL      StartDate = 'na'
     C                   EVAL      StartTime = *blank
     C                   EVAL      EndDate = FullDate
     C                   EVAL      EndTime = FullTime
     C                   EXSR      WriteRec
     C                   ENDIF
      *
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from CFE
     C+ into :SpoolRecord
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close CFE
     C/end-exec
      *
     C     CheckForEndE  ENDSR
      *
      /EJECT
      ********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     Recursive     IFEQ      *BLANKS
     C                   MOVE      'Y'           Recursive
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
     C                   ENDIF
      *
     C     PSSRE         ENDSR
      *****************************************************************
