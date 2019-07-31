     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UPAFCPO) TOFILE(UPAFCPPD)                        *
/*XBIB*  OVRDBF FILE(UPAFCPN) TOFILE(UPAFCPPD)                        *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Compare two Action Files')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP009003 - Compare two Action Files                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. A1084804 *CREATE   Date 30Jan13               *
      *  Prev Amend No. xxxxxxxx           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  A1084804 - Add *MRG option.                                  *
      *                                                               *
      *****************************************************************
      *
     FUP009006P1O    E             PRINTER INFDS(SpoolDS)
      *
     D POldLib         S             10
     D PNewLib         S             10
      *
     D KeyStringO      S           6000
     D KeyStringN      S           6000
     D KeyFound        S              1
     D WriteRec        S              1    INZ('N')
     D SaveFile        S             10
     D LoopCount       S              2  0
     D StartKeyVal     S              5  0
     D x               S              2  0
     D Recursive       S              1    INZ('N')
      *
     D FldPos          S              5  0 DIM(99)
     D FldLen          S              5  0 DIM(99)
      *
     D AFCPO         E DS                  EXTNAME(UPAFCPPD)
     D                                     PREFIX(O)
     D AFCPN         E DS                  EXTNAME(UPAFCPPD)
     D                                     PREFIX(N)
     D AFFD          E DS                  EXTNAME(UPAFFDPD)
      *
     D SpoolDS         DS
     D OverFlowLine          188    189B 0
     D PrintLine             367    368B 0
      *
     C     *ENTRY        PLIST
     C                   PARM                    POldLib
     C                   PARM                    PNewLib
      *
      * Set up report Header
     C                   EVAL      RPGM = 'UP009003'
     C                   EVAL      RHDR = 'MERGE - Clash between two Action +
     C                             Files'
     C                   EVAL      RFL1T = 'First file  :'
     C                   EVAL      RFL2T = 'Second file :'
     C                   EVAL      RFIL1 = %TRIMR(POldLib) + '/UPAFCPPD'
     C                   EVAL      RFIL2 = %TRIMR(PNewLib) + '/UPAFCPPD'
     C                   WRITE     HEADH
      *
      * Start reading through "Old" file.
     C/exec SQL
     C+ declare OldCursor cursor for
     C+ select * from UPAFCPO
     C+ where
     C+     ATACT <> 'AB'
     C+ order by
     C+   ATFILE
     C+ , ATNUMB
     C/end-exec
      *
     C/exec SQL
     C+ open OldCursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from OldCursor
     C+ into: AFCPO
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * If a new file is found then find key fields position and length.
     C                   IF        OATFILE <> SaveFile
     C                   CLEAR                   FldPos
     C                   CLEAR                   FldLen
     C                   EVAL      SaveFile = OATFILE
     C                   EVAL      KeyFound = *blank
     C                   EXSR      GetKey
     C                   EVAL      LoopCount = (x - 1)
     C                   ENDIF
      * If there are no keys for this file then skip processing.
     C                   IF        KeyFound <> 'N'
      *
      * Build string of key values; loop is controlled by number of keys found.
     C                   EVAL      x = 1
     C                   EVAL      StartKeyVal = 1
     C                   CLEAR                   KeyStringO
     C                   DO        LoopCount
     C                   EVAL      %SUBST(KeyStringO:StartKeyVal:FldLen(x)) =
     C                             %SUBST(OATDATA:FldPos(x):FLdLen(x))
     C                   EVAL      StartKeyVal = StartKeyVal + FLdLen(x)
     C                   EVAL      x = x + 1
     C                   ENDDO
      *
      * Once string of key data has been built then compare against records
      *  for the same file in the 'new' version of UPAFCPPD.
     C                   EXSR      CompareKeys
      *
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from OldCursor
     C+ into: AFCPO
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close OldCursor
     C/end-exec
      *
     C                   IF        WriteRec = 'N'
     C                   WRITE     NORECS
     C                   ENDIF
     C                   EXSR      OverFlow
     C                   WRITE     TRAILP
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *    CompareKeys - Read second file but only for records that   *
      *                  relate to the selected deliverable data      *
      *                  file.                                        *
      *                                                               *
      *****************************************************************
     C     CompareKeys   BEGSR
      *
      * Start reading through "new" file but only for matching file.
     C/exec SQL
     C+ declare NewCursor cursor for
     C+ select * from UPAFCPN
     C+ where
     C+     ATFILE = :OATFILE
     C+ and ATACT <> 'AB'
     C+ order by
     C+   ATFILE
     C+ , ATNUMB
     C/end-exec
      *
     C/exec SQL
     C+ open NewCursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from NewCursor
     C+ into: AFCPN
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * If record is found then build string of key values.
     C                   EVAL      x = 1
     C                   EVAL      StartKeyVal = 1
     C                   CLEAR                   KeyStringN
     C                   DO        LoopCount
     C                   EVAL      %SUBST(KeyStringN:StartKeyVal:FldLen(x)) =
     C                             %SUBST(NATDATA:FldPos(x):FLdLen(x))
     C                   EVAL      StartKeyVal = StartKeyVal + FLdLen(x)
     C                   EVAL      x = x + 1
     C                   ENDDO
      *
      * When the key values have been built then compare the strings.
     C                   IF        KeyStringO = KeyStringN
      *
     C                   EXSR      Report
      *
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from NewCursor
     C+ into: AFCPN
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close NewCursor
     C/end-exec
      *
     C     CompareKeysE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    GetKey - This gets the position and lengths of all key     *
      *             fields for the selected file.                     *
      *                                                               *
      *****************************************************************
     C     GetKey        BEGSR
      *
     C                   EVAL      x = 1
      *
     C/exec SQL
     C+ declare FldCursor cursor for
     C+ select * from UPAFFDL0
     C+ where AFFILE = :OATFILE
     C/end-exec
      *
     C/exec SQL
     C+ open FldCursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from FldCursor
     C+ into: AFFD
     C/end-exec
      *
      * First check that data has been found.
     C                   IF        SQLCODE <> 0
     C                   EVAL      KeyStringO = 'No field information for +
     C                             this file.'
     C                   EVAL      KeyFound = 'N'
     C                   EXSR      Report
     C                   ENDIF
      *
     C                   DOU       SQLCODE <> 0
      *
      * If a new file is found then find key fields position and length.
     C                   IF        AFKEYF = 'Y'
     C                   EVAL      FldPos(x) = AFFDPS
     C                   EVAL      FldLen(x) = AFFDLN
     C                   EVAL      x = x + 1
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from FldCursor
     C+ into: AFFD
     C/end-exec
      *
     C                   ENDDO
     C/exec SQL
     C+ close FldCursor
     C/end-exec
      *
      *
     C     GetKeyE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    Report - Write two lines for report                        *
      *                                                               *
      *****************************************************************
     C     Report        BEGSR
      *
     C                   SELECT
     C                   WHEN      OATACT = 'A'
     C                   EVAL      RACTO = 'Amend'
     C                   WHEN      OATACT = 'I'
     C                   EVAL      RACTO = 'Insert'
     C                   WHEN      OATACT = 'D'
     C                   EVAL      RACTO = 'Delete'
     C                   ENDSL
     C                   SELECT
     C                   WHEN      NATACT = 'A'
     C                   EVAL      RACTN = 'Amend'
     C                   WHEN      NATACT = 'I'
     C                   EVAL      RACTN = 'Insert'
     C                   WHEN      NATACT = 'D'
     C                   EVAL      RACTN = 'Delete'
     C                   ENDSL
      *
     C                   EVAL      RFILO = OATFILE
     C                   EVAL      RKEYO = KeyStringO
     C                   EXSR      OverFlow
     C                   WRITE     MRG1
      * Set on flag to indicate that at least one record has been written.
     C                   EVAL      WriteRec = 'Y'
      *
     C     ReportE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    OverFlow - Check for page overflow.                        *
      *                                                               *
      *****************************************************************
     C     OverFlow      BEGSR
      *
     C                   IF        (OverFlowLine - PrintLine) <= 3
     C                   WRITE     HEADH
     C                   ENDIF
      *
     C     OverFlowE     ENDSR
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
