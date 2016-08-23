     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT FNDUPDSRC amend lines of code')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000051 - Amend code lines                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CUT015   *CREATE   Date 19Apr12               *
      *  Prev Amend No. xxxxxxxx           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT015 - New utility to replace UPDSRC.                      *
      *                                                               *
      *****************************************************************
      *
     FUT000051DFCF   E             WORKSTN
     F                                     SFILE(UT000051C1:SRRN)
     F                                     SFILE(UT000051C2:SRRN)
      * Old and new statements file.
     FUTSTMTPD  IF   E           K DISK    INFSR(*PSSR)
      *
     D Job             S             10
     D User            S             10
     D ScanString      S             20
     D ScanSource      S            100
     D FoundPos        S              3  0
     D X               S              3  0
     D LastRec         S              5  0
     D Wrk05N          S              5  0
     D WorkStr         S            100
     D Recursive       S              1
      *
     D LowerCase       C                   CONST('abcdefghijklmnopqrstuvwxyz')
     D UpperCase       C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
      *
      /EJECT
      * Initialise subfile.
     C                   EVAL      *IN10 = *ON
     C                   WRITE     UT000051S1
     C                   WRITE     UT000051S2
     C                   EVAL      *IN10 = *OFF
      * Load subfile.
     C                   READ      UTSTMTPD
     C                   DOW       NOT(%EOF)
     C                   IF        %SUBST(FUOSTR:1:10) <> 'FNDUPDSRC'
     C                   EVAL      SRRN = SRRN + 1
     C                   EVAL      SOLDS = FUOSTR
     C                   EVAL      SNEWS = FUNSTR
     C                   WRITE     UT000051C1
     C                   WRITE     UT000051C2
     C                   ENDIF
     C                   READ      UTSTMTPD
     C                   ENDDO
      *
     C                   EVAL      LastRec = SRRN
     C                   EVAL      SCASE = 'N'
      * Start with amending first unaltered statement.
     C                   EVAL      *IN11 = *ON
     C                   EVAL      SPSTN = 0
      * If no records exist.
     C                   IF        SRRN = 0
     C                   EXFMT     UT000051F2
     C                   EVAL      *IN03 = *ON
     C                   ENDIF
      * Do for all requests.
     C                   DOW       *IN03 = *OFF
      * Update file with changes.
     C                   EXSR      UpdateFile
      *
      * If 'Jump to' record number entered ...
     C                   IF        SNXTP > 0
      * ... set subfile pointers.
     C                   EVAL      SPSTN = SNXTP * 9
     C                   EVAL      SCURP = SNXTP
     C                   EVAL      SNXTP = 0
     C                   ENDIF
      *
      * If 'Set to first unchanged record' requested.
     C                   IF        *IN11 = *ON
     C                   EVAL      SPSTN = SPSTN + 1
     C     SPSTN         CHAIN     UT000051C2                         89
      * Do for all subfile records.
     C                   DOW       SOLDS <> SNEWS
     C                             and SOLDS <> *blanks
     C                             and *IN89 = *OFF
     C                             and SPSTN < 9999
     C                   EVAL      SPSTN = SPSTN + 1
     C     SPSTN         CHAIN     UT000051C2                         89
     C                   ENDDO
      *
     C                   EVAL      Wrk05N = SPSTN - 1
     C                   EVAL      SCURP = Wrk05N / 9
     C                   EVAL      SCURP = SCURP + 1
     C                   ENDIF
      *
      * If 'Scan for string' requested ...
     C                   IF        SSCNF <> *blanks
     C     SPSTN         CHAIN     UT000051C2                         89
      * If case sensitive.
     C                   IF        SCASE = 'Y'
     C                   EVAL      ScanString = SSCNF
     C                   ELSE
     C                   EVAL      ScanString =
     C                             %XLATE(LowerCase:UpperCase:SSCNF)
     C                   ENDIF
      * Check for precise length of string to scan for.
     C                   EVAL      X = 0
     C                   EVAL      X = %CHECKR(' ':ScanString)
      * If case sensitive.
     C                   IF        SCASE = 'Y'
     C                   EVAL      ScanSource = SNEWS
     C                   ELSE
      * Convert new source data to upper case.
     C                   EVAL      ScanSource =
     C                             %XLATE(LowerCase:UpperCase:SNEWS)
     C                   ENDIF
      * Scan source data
     C     ScanString:X  SCAN      ScanSource                             88
      * Do for all subfile records.
     C                   DOW       *IN88 = *OFF
     C                             and *IN89 = *OFF
     C                             and SPSTN < 9999
     C                   EVAL      SPSTN = SPSTN + 1
     C     SPSTN         CHAIN     UT000051C2                         89
     C                   IF        SCASE = 'Y'
     C                   EVAL      ScanSource = SNEWS
     C                   ELSE
      * Convert new source data to upper case.
     C                   EVAL      ScanSource =
     C                             %XLATE(LowerCase:UpperCase:SNEWS)
     C                   ENDIF
      * Scan source data.
     C     ScanString:X  SCAN      ScanSource                             88
     C                   ENDDO
      *
     C                   EVAL      Wrk05N = SPSTN - 1
     C                   EVAL      SCURP = Wrk05N / 9
     C                   EVAL      SCURP = SCURP + 1
     C                   ENDIF
      * If position after last record.
     C                   IF        SPSTN > LastRec
     C                   EVAL      SPSTN = LastRec
     C                   EVAL      SCURP = Wrk05N / 9
     C                   EVAL      SCURP = SCURP + 1
     C                   ENDIF
      *
     C                   WRITE     UT000051F1
      * If new statements to be displayed ...
     C                   IF        *IN07 = *OFF
     C                   EXFMT     UT000051S2
      * ... else old statements to be displayed.
     C                   ELSE
     C                   EXFMT     UT000051S1
     C                   EVAL      *IN07 = *OFF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    Job
     C                   PARM                    User
      *
     C                   EVAL      SWSID = Job
     C                   EVAL      SUSER = User
      *
     C     EINZSR        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdateFile - Update file                                      *
      *                                                               *
      * Called by: main processing                                    *
      *                                                               *
      * Calls: UpdateMbr                                              *
      *                                                               *
      *****************************************************************
      *
     C     UpdateFile    BEGSR
      *
      * Read first changed subfile record.
     C                   READC     UT000051C2                             89
      * If at least 1 changed record exists.
     C                   IF        *IN89 = *OFF
      * Do for all changed subfile records.
     C                   DOW       *IN89 = *OFF
      *
      * Update source statements file.
     C/exec SQL
     C+ update UTSTMTPD
     C+ set FUNSTR = :SNEWS
     C+ where FUOSTR = :SOLDS
     C/end-exec
      *
     C                   READC     UT000051C2                             89
     C                   ENDDO
      *
     C                   EVAL      SPSTN = SRRN
     C                   ENDIF
      *
     C     UpdateFileE   ENDSR
      *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      *INU2 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
