     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Add new Action File processing')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  UP000002 - Add new Action File processing                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. Ar863945 *CREATE   Date 11Nov11               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Ar863945 - New option to add Action File processing.         *
      *                                                               *
      *****************************************************************
     FUPAFDVPD  UF   E             DISK
      *
     D PLayer          S              7
     D CommandLen      S             15  5 INZ(70)
     D Recursive       S              1    INZ('N')
      *
     D AFCommand       DS
     D  Comamnd                1     27    INZ('ACTIONFILE MODE(*ADD) FILE(')
     D  AFile                 28     37
     D  KeyFParm              38     44    INZ(') KEYF(')
     D  KFile                 45     54
     D  LayerParm             55     62    INZ(') LAYER(')
     D  Layer                 63     69
     D  CBracket              70     70    INZ(')')
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLayer
      *
      * Read through the Action File checking to see if an Insert has
      *  been delivered for UPACTFPD, but only for the correct layer.
     C                   READ      UPAFDVPD
     C                   DOU       %EOF
     C                   IF        ATFILE = 'UPACTFPD' and
     C                             ATACT = 'I' and
     C                             %SUBST(ATDATA:21:7) = PLayer
      *
      * Break down the data for the ACTIONFILE command.
     C                   EVAL      AFile = %SUBST(ATDATA:1:10)
     C                   EVAL      KFile = %SUBST(ATDATA:11:10)
     C                   EVAL      Layer = PLayer
      *
      * Attempt to delete records on UPACTFPD and UPAFFDPD first.
     C                   EXSR      DeleteRecs
      * Run the ACTIONFILE command.
     C                   EXSR      AddAF
      * Update the files sp that they are ignored for later processing.
     C                   EXSR      UpdateRecs
     C                   ENDIF
      *
     C                   READ      UPAFDVPD
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *
     C     DeleteRecs    BEGSR
      *
     C/exec SQL
     C+ delete from UPACTFPD
     C+ where AABONF = :AFile
     C/end-exec
      *
     C                   IF        SQLCODE <> 0 and
     C                             SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/exec SQL
     C+ delete from UPAFFDPD
     C+ where AFFILE = :AFile
     C/end-exec
      *
     C                   IF        SQLCODE <> 0 and
     C                             SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     DeleteRecsE   ENDSR
      *
      /EJECT
      *****************************************************************
      *
     C     AddAF         BEGSR
      *
      * Execute ACTIONFILE command.
     C                   CALL      'QCMDEXC'
     C                   PARM                    AFCommand
     C                   PARM                    CommandLen
      *
     C     AddAFE        ENDSR
      *
      /EJECT
      *****************************************************************
      *
     C     UpdateRecs    BEGSR
      *
     C                   EVAL      ATIGNA = 'Y'
     C                   UPDATE    UPAFCPD0
      *
     C/exec SQL
     C+ update UPAFDVPD
     C+ set ATIGNA = 'Y'
     C+ where ATFILE = 'UPAFFDPD' and ATACT = 'I'
     C+ and SUBSTR(ATDATA, 1, 10) = :AFile
     C/end-exec
      *
     C                   IF        SQLCODE <> 0
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     UpdateRecsE   ENDSR
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
