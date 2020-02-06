     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Update unique numbers for CB* files')         *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009008 - Update unique numbers for CB* files               *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD051541           Date 24Jul18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR967496           Date 10May12               *
      *                 CUP021  *CREATE    Date 02Feb11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051541 - Avoid duplicate key error for CBMEXCPD.           *
      *  MD046248 - Finastra Rebranding                               *
      *  AR967496 - CBMEXCPD Sequencing error                         *
      *             Allow for more than 99 or 999 inserts.            *
      *  CUP021 - Rewrite of Action File processing                   *
      *                                                               *
      *****************************************************************
      *
     FUPAFCPPD  UF   E             DISK
      *
      * Array containing Component and Sequence                                             MD051541
     D COMSEQ          S             15    DIM(999)                                         MD051541
      *                                                                                     MD051541
      * Data structure for DSPDBR array.                                                    MD051541
     D                 DS                                                                   MD051541
     D  COMSEQArray            1     15                                                     MD051541
     D  ArrayCOM               1     10                                                     MD051541
     D  ArraySEQ              11     15                                                     MD051541
      *                                                                                     MD051541
      * Look up data structure.                                                             MD051541
     D                 DS                                                                   MD051541
     D  COMSEQLookUp           1     15                                                     MD051541
     D  LookUpCOM              1     10                                                     MD051541
     D  LookUpSEQ             11     15                                                     MD051541
                                                                                            MD051541
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
     D Index           S              3  0                                                  MD051541
     D Idx             S              3  0                                                  MD051541

     C     *ENTRY        PLIST
     C                   PARM                    PFile
      *
     C                   EVAL      Index = 1                                                MD051541
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
     C**********         IF        ATFILE = 'CBMEXCPD' or                                   MD051541
     C**********                   ATFILE = 'CBMDCNPD'                                      MD051541
     C                   IF        ATFILE = 'CBMDCNPD'                                      MD051541
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
     C                   IF        ATFILE = 'CBMEXCPD'                                      MD051541
     C                   IF        ATACT = 'I'                                              MD051541
     C                   EVAL      Unique2n = 99                                            MD051541
     C                   EVAL      Idx = 1                                                  MD051541
     C                   EVAL      LookUpCOM = %SUBST(ATDATA:1:10)                          MD051541
     C                   EVAL      LookUpSEQ = %SUBST(ATDATA:11:5)                          MD051541
     C     COMSEQLookUp  LOOKUP    COMSEQ(Idx)                            69                MD051541
     C     *IN69         DOWEQ     *ON                                                      MD051541
     C                   EVAL      Unique2n = Unique2n - 1                                  MD051541
     C                   EVAL      Idx = Idx + 1                                            MD051541
     C     COMSEQLookUp  LOOKUP    COMSEQ(Idx)                            69                MD051541
     C                   ENDDO                                                              MD051541
     C                   EVAL      ArrayCOM = %SUBST(ATDATA:1:10)                           MD051541
     C                   EVAL      ArraySEQ = %SUBST(ATDATA:11:5)                           MD051541
     C                   EVAL      COMSEQ(Index) = COMSEQArray                              MD051541
     C                   EVAL      Index = Index + 1                                        MD051541
     C                   EVAL      %SUBST(ATDATA:StartPos:Length) = Unique2a                MD051541
     C                   UPDATE    UPAFCPD0                                                 MD051541
     C                   ENDIF                                                              MD051541
     C                   ENDIF                                                              MD051541
                                                                                            MD051541
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
