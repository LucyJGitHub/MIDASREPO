     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Monitor database restores')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000073 - Monitor database restores                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CUP042   *CREATE   Date 15Feb12               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - New method to restore libraries.                    *
      *                                                               *
      *****************************************************************
      *
     D PLayer          S              7
      *
     D ErrorMsg        S            100
     D ErrorFlag       S              1    INZ('N')
     D RptMode         S              7    INZ('*WRITE')
     D RptProgram      S             10    INZ('SM000073')
     D CRTPFCmd        S             38    INZ('CRTPF FILE(QTEMP/UPERRMQT) +
     D                                     RCDLEN(100)')
     D CommandLen      S             15  5 INZ(38)
     D JobDtls         S             28
     D Recursive       S              1    INZ(*blank)
      *
     D SMIMP         E DS                  EXTNAME(SMIMPJW0)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLayer
      *
      ** Create temporary file for reporting.
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    CRTPFCmd
     C                   PARM                    CommandLen
      *
      ** Select records for submitted jobs where status <> 'C'.
     C/exec SQL
     C+ declare SubmittedJobs cursor for
     C+ select * from SMIMPJW0
     C+ where
     C+     (DFSMNU = 'RestoreLibraries'
     C+ or   DFSMNU = 'RenameLibrariesBack')
     C+ and DFLAYR = :PLayer
     C+ and DFDEL  = 'N'
     C+ and substr(DFSTS, 1, 1) <> 'C'
     C/end-exec
      *
     C/exec SQL
     C+ open SubmittedJobs
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from SubmittedJobs
     C+ into :SMIMP
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** Retrieve the job details and then report the problem.
     C                   EVAL      JobDtls = %TRIMR(%SUBST(DFSTS:22:6)) + '/' +
     C                             %TRIMR(%SUBST(DFSTS:12:10)) + '/' +
     C                             %TRIMR(%SUBST(DFSTS:2:10))
      *
     C                   IF        %SUBST(DFSTS:1:1) = 'F'
     C                   EVAL      ErrorMsg = DFSMNU + DFNAME +
     C                             'Failed - Check job: ' +
     C                             JobDtls
     C                   ENDIF
     C                   IF        %SUBST(DFSTS:1:1) = 'A'
     C                   EVAL      ErrorMsg = DFSMNU + DFNAME +
     C                             'Ended unexpectedly - Check job: ' +
     C                             JobDtls
     C                   ENDIF
     C                   IF        %SUBST(DFSTS:1:1) = ' '
     C                   EVAL      ErrorMsg = 'Job not run: ' + DFSMNU + DFNAME
     C                   ENDIF
      *
     C                   EVAL      ErrorFlag = 'Y'
     C                   EXSR      WriteReport
      *
     C/exec SQL
     C+ fetch next
     C+ from SubmittedJobs
     C+ into :SMIMP
     C/end-exec
      *
     C                   ENDDO
      *
      ** If there were no errors then write 'successful' message.
     C                   IF        ErrorFlag = 'N'
     C                   EVAL      ErrorMsg = 'All jobs completed successfully.'
     C                   EXSR      WriteReport
     C                   ENDIF
      *
     C                   EVAL      RptMode = '*REPORT'
     C                   EXSR      WriteReport
      *
      ** Clear down the status fields.
     C/exec SQL
     C+ update SMIMPXTD
     C+ set
     C+    DFSTS = ' '
     C/end-exec
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *
     C     WriteReport   BEGSR
      *
     C                   CALL      'UP008010'
     C                   PARM                    RptMode
     C                   PARM                    RptProgram
     C                   PARM                    ErrorMsg
      *
     C     WriteReportE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
