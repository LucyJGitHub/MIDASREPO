     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *************************************************************************
/*STD *  RPGBASEBNC                                                           *
/*EXI *  TEXT('Midas GL Change of Receiver and Increment of JrnSq')   *
      *************************************************************************
      *                                                                       *
      *  Midas - General Ledger Module                                        *
      *                                                                       *
      *  GL007012 - Change of Receiver and Increment of JrnSeq                *
      *                                                                       *
      *  (c) Finastra International Limited 2018                              *
      *                                                                       *
      *  Last Amend No. MD022132 *CREATE   Date 09Mar18                       *
      *                                                                       *
      *-----------------------------------------------------------------------*
      *                                                                       *
      *  MD022132 - Triggers don't pick up Rollback deletes of ABC files.     *
      *           - Applied for MD-35969.                                     *
      *                                                                       *
      *************************************************************************

     FGLABJSTD  IF   E             DISK    INFSR(*PSSR)

      ** Entry Parameters
      **=================

     D PJrnRcv         S                   LIKE( ABJRCV )
     D PJrnSeq         S                   LIKE( ABJSEQ )
     D PMode           S              9A

      ** Standard Variables
     D PSSRDone        S               N   INZ(*OFF)
     D True            C                   CONST( *ON )
     D False           C                   CONST( *OFF )

      ** Work Variables
     D WJrnSeq         S                   INZ LIKE( ABJSEQ )
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
     C     1             CHAIN     GLABJSTD
     C                   IF        %FOUND
     C                   EVAL      PJrnRcv = ABJRCV
     C                   EVAL      PJrnSeq = ABJSEQ
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
