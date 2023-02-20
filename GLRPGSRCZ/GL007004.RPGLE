     H DEBUG
     H OPTION(*NOUNREF)
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Chg of Rcvr and Increment of JrnSq-MEMOS')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL007004 - Change of Receiver and Increment of JrnSeq(MEMOS) *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060909  *CREATE  Date 14Feb23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060909 - After COB job FTC0630 go in MSGW.                 *
      *                                                               *
      *****************************************************************

     FGLMEJSTD  IF   E             DISK    INFSR(*PSSR)

      ** Entry Parameters
      **=================

     D PJrnRcv         S                   LIKE( OLJRCV )
     D PJrnSeq         S                   LIKE( OLJSEQ )
     D PMode           S              9A

      ** Standard Variables
     D PSSRDone        S               N   INZ(*OFF)
     D True            C                   CONST( *ON )
     D False           C                   CONST( *OFF )

      ** Work Variables
     D WJrnSeq         S                   INZ LIKE( MEJSEQ )
     D Idx             S              3U 0 INZ

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCESSING                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PJrnSeq
     C                   PARM                    PJrnRcv
     C                   PARM                    PMode

     C                   IF        PMode = 'JRNDTL'
     C     1             CHAIN     GLMEJSTD
     C                   IF        %FOUND
     C                   EVAL      PJrnRcv = MEJRCV
     C                   EVAL      PJrnSeq = MEJSEQ
     C                   ENDIF
     C                   ENDIF

     C                   IF        PMode = 'INCREMENT'
     C                   EVAL      PJrnSeq = %CHAR(%DEC( PJrnSeq
     C                                                 : 20 : 0 ) + 1 )
     C                   ENDIF

     C                   RETURN
      *************************************************************
      /EJECT
      *************************************************************
      *                                                           *
      * *PSSR - Unhandled exception error routine                 *
      *                                                           *
      *************************************************************
     C     *PSSR         BEGSR

     C                   IF        NOT PSSRDone
     C                   EVAL      PSSRDone = True
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
      *************************************************************
