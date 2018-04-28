     H DEBUG
     H OPTION(*NOUNREF)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Change of Receiver and Increment of JrnSq')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL007002 - Change of Receiver and Increment of JrnSeq        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD026169  *REWRITE Date 04Apr14               *
      *  Prev Amend No. MD025679B          Date 29Mar14               *
      *                 MD025679A          Date 21Mar14               *
      *                 MD025679  *CREATE  Date 18Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026169 - GO_ONL_OLP background job is processing           *
      *             full receiver chain                               *
      *  MD025679B - GO_ONL_OLP Background Job Failure                *
      *  MD025679A - API: OLPOS Locking issue Performance Update      *
      *  MD025679 - API: OLPOS Locking issue.                         *
      *                                                               *
      *****************************************************************
 
     FGLOLJSTD  IF   E             DISK    INFSR(*PSSR)
 
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
     D WJrnSeq         S                   INZ LIKE( OLJSEQ )
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
     C     1             CHAIN     GLOLJSTD
     C                   IF        %FOUND
     C                   EVAL      PJrnRcv = OLJRCV
     C                   EVAL      PJrnSeq = OLJSEQ
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
