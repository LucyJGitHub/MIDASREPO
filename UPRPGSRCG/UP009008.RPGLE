     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Update unique numbers for CB* files')         *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009008 - Update unique numbers for CB* files               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR967496           Date 10May12               *
      *  Prev Amend No. CUP021  *CREATE    Date 02Feb11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR967496 - CBMEXCPD Sequencing error                         *
      *             Allow for more than 99 or 999 inserts.            *
      *  CUP021 - Rewrite of Action File processing                   *
      *                                                               *
      *****************************************************************
      *
     FUPAFCPPD  UF   E             DISK
      *
     D PFile           S             10
     D StartPos        S              2  0
     D Length          S              1  0
     D Recursive       S              1
     D SaveCmp         S             10                                                     AR967496
     D SaveSeq         S              5                                                     AR967496
      *
     D                 DS
     D  Unique3a               1      3
     D  Unique3n               1      3  0
     D                 DS
     D  Unique2a               1      2
     D  Unique2n               1      2  0
 
     C     *ENTRY        PLIST
     C                   PARM                    PFile
      *
      * Setup initial values.
     C                   IF        PFile = 'CBDPRLPD'
     C**********         EVAL      Unique3n = 999                                           AR967496
     C                   EVAL      StartPos = 16
     C                   EVAL      Length = 3
     C                   ENDIF
      *
     C                   IF        PFile = 'CBMEXCPD' or
     C                             PFile = 'CBMDCNPD'
     C**********         EVAL      Unique2n = 99                                            AR967496
     C                   EVAL      StartPos = 16
     C                   EVAL      Length = 2
     C                   ENDIF
      *
      * Read Action File.
     C     1             SETLL     UPAFCPPD
     C                   READ      UPAFCPPD
     C                   DOW       NOT(%EOF)
      * The program is only interested in 'Inserts'.
      *
     C                   IF        ATFILE = PFile
      *
     C                   IF        ATFILE = 'CBDPRLPD'
     C                   IF        ATACT = 'I'
     C                   IF        %SUBST(ATDATA:1:10) <> SaveCmp                           AR967496
     C                             or %SUBST(ATDATA:11:5) <> SaveSeq                        AR967496
     C                   EVAL      Unique3n = 999                                           AR967496
     C                   EVAL      SaveCmp = %SUBST(ATDATA:1:10)                            AR967496
     C                   EVAL      SaveSeq = %SUBST(ATDATA:11:5)                            AR967496
     C                   ELSE                                                               AR967496
     C**********         EVAL      %SUBST(ATDATA:StartPos:Length) = Unique3a                AR967496
     C                   EVAL      Unique3n = Unique3n - 1
     C                   ENDIF                                                              AR967496
     C                   EVAL      %SUBST(ATDATA:StartPos:Length) = Unique3a                AR967496
     C                   UPDATE    UPAFCPD0
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ATFILE = 'CBMEXCPD' or
     C                             ATFILE = 'CBMDCNPD'
     C                   IF        ATACT = 'I'
     C                   IF        %SUBST(ATDATA:1:10) <> SaveCmp                           AR967496
     C                             or %SUBST(ATDATA:11:5) <> SaveSeq                        AR967496
     C                   EVAL      Unique2n = 99                                            AR967496
     C                   EVAL      SaveCmp = %SUBST(ATDATA:1:10)                            AR967496
     C                   EVAL      SaveSeq = %SUBST(ATDATA:11:5)                            AR967496
     C                   ELSE                                                               AR967496
     C**********         EVAL      %SUBST(ATDATA:StartPos:Length) = Unique2a                AR967496
     C                   EVAL      Unique2n = Unique2n - 1
     C                   ENDIF                                                              AR967496
     C                   EVAL      %SUBST(ATDATA:StartPos:Length) = Unique2a                AR967496
     C                   UPDATE    UPAFCPD0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   READ      UPAFCPPD
     C                   ENDDO
      *
     C                   SETON                                        LR
      *
      /EJECT
      ********************************************************************
     C     *PSSR         BEGSR
      *
     C     Recursive     IFEQ      *blanks
     C                   MOVE      'Y'           Recursive
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
      *
     C     PSSRE         ENDSR
      *********************************************************************
