     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Set zeros to blanks for customer fields')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000041 - This program has been written especially to deal  *
      *             with the change of Customer Numbers to alpha.  If *
      *             a Customer Number field contained 000000 then it  *
      *             is set to blank.                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK025  *CREATE    Date 06Jul06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPK025 - MidasPlus 1.3 packaging.  New migration tool.       *
      *                                                               *
      *****************************************************************
      *
     D DtaQData        S             80
     D DTAQEntryLen    S              5  0
     D DTAQEntry       S             12
     D DTAQWait        S              5  0
     D PFile           S             10
     D PToLib          S             10
     D Stmt_String     S             80
     D Update          S             32
     D ZerosString     S             20
     D Field           S             10
     D Mode            S              6
     D Count           S              2  0 INZ(0)
     D Recursive       S              1    INZ('N')
     D ReturnCodeOut   S             10
     D QCmdText        S             63
     D QCmdLen         S             15  5 INZ(63)
     D Quote           S              1    INZ('''')
      *
     D ConRunSQL       C                   'RUNSQLSTM SRCFILE(QTEMP/RUNSQL) +
     D                                     SRCMBR(RUNSQLSTM) COMMIT(*NONE)'
      *
     D                 DS
     D DigitsN                 1      2  0
     D DigitsA                 1      2
      *
      * Data queue name and library
     D DtaQ            DS
     D  DataQueue              1     10    INZ('SM000044')
     D  DataQueueLib          11     20    INZ('QTEMP')
      *
      * Data retrieved about data queue
     D DtaQDataDS      DS            80    OCCURS(1)
     D  NoOfEntries           73     76B 0
      *****************************************************************
      *                                                               *
      * Start of MAIN processing                                      *
      *                                                               *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    PToLib
     C                   PARM                    PFile
     C                   PARM                    ReturnCodeOut
      *
      * Find out number of entries on data queue.
     C                   CALL      'UT0073'
     C                   PARM                    DtaQ
     C                   PARM                    DtaQData
     C                   EVAL      DtaQDataDS = DtaQData
      *
      * Begin set up of Update string.
     C                   EVAL      Update = 'UPDATE ' +
     C                             %TRIMR(PToLib) +
     C                             %TRIMR('/') +
     C                             %TRIMR(PFile) +
     C                             ' SET'
      *
      * Receive data queue to pick up field name.
     C                   EXSR      ReceiveDTAQ
      *
      * Receive from data queue until no more entries.
     C                   DOU       Count = NoOfEntries
      *
     C                   EVAL      Count = Count + 1
     C                   EVAL      Field = %SUBST(DTAQEntry:1:10)
     C                   EVAL      DigitsA = %SUBST(DTAQEntry:11:2)
     C                   EVAL      Stmt_String = %TRIMR(Update) +
     C                             ' ' +
     C                             %TRIMR(Field) +
     C                             ' = ' +
     C                             Quote +
     C                             ' ' +
     C                             Quote +
     C                             ' WHERE ' +
     C                             %TRIMR(Field)
      *
      * Build string of zeros.
     C                   EXSR      BuildZeros
      *
     C                   EVAL      Stmt_String = %TRIMR(Stmt_String) +
     C                             ' = ' +
     C                             ZerosString
      *
      * Send string to SQL source file.
     C                   EXSR      WriteSQL
      *
      * Execute RUNSQLSTM.
     C                   EVAL      QCmdText = ConRUNSQL
     C                   CALL      'QCMDEXC'
     C                   PARM                    QCmdText
     C                   PARM                    QCmdLen
      *
      * Get next entry from data queue.
     C                   EXSR      ReceiveDTAQ
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * BuildZeros - Build a string of zeros dependent on length of   *
      *              field.                                           *
      *                                                               *
      *****************************************************************
     C     BuildZeros    BEGSR
      *
     C                   CLEAR                   ZerosString
     C                   EVAL      ZerosString = Quote
      *
     C                   DO        DigitsN
     C                   EVAL      ZerosString = %TRIMR(ZerosString) + '0'
     C                   ENDDO
      *
     C                   EVAL      ZerosString = %TRIMR(ZerosString) + Quote
      *
     C     BuildZerosE   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ReceiveDTAQ - Receive data queue entries                      *
      *                                                               *
      *****************************************************************
     C     ReceiveDTAQ   BEGSR
      *
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DataQueue
     C                   PARM                    DataQueueLib
     C                   PARM      12            DTAQEntryLen
     C                   PARM                    DTAQEntry
     C                   PARM      0             DTAQWait
 
     C     ReceiveDTAQE  ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ReceiveDTAQ - Receive data queue entries                      *
      *                                                               *
      *****************************************************************
     C     WriteSQL      BEGSR
      *
     C                   CALL      'UTWRTSQL'
     C                   PARM                    Stmt_String
     C                   PARM      '*CLEAR'      Mode
 
     C     WriteSQLE     ENDSR
      /EJECT
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive <> 'Y'
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      ReturnCodeOut = '*ERROR'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
