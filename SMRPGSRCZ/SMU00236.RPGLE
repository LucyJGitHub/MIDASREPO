     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update GLCOLAPD Front Office Trans. Id.')     *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00236 - Update GLCOLAPD Front Office Trans. Id.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. AR815294*CREATE    Date 23Jun11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR815294 - A new logical (GLCOLAL7) was introduced with a    *
      *             unique key of the Front Office transaction Id.    *
      *             This can  cause the migration to fail as this     *
      *             field is usually blank.  The migration will       *
      *             remove the member for the logical so that the     *
      *             data is copied and this program will populate     *
      *             the Front Office transaction Id. and attempt to   *
      *             add the member back in.                           *
      *                                                               *
      *****************************************************************
      *
     FGLCOLAL2  UF   E           K DISK    INFSR(*PSSR)
      *
     DSaveCACREF       S             10
     DSeq              S              2  0
     DRecursive        S              1
      *
     D FrntOffTransId  DS
     D  Stem                   1     10
     D  SeqA                  11     12
     D  SeqN                  11     12  0
     D  Pad                   13     20    INZ(*blanks)
      *
      * Read file.
     C     *LOVAL        SETLL     GLCOLAL2
     C                   READ      GLCOLAL2
     C                   DOW       NOT(%EOF)
      *
      * If the Front Office transaction Id is blank then update it.
     C                   IF        CAFRNT = *blanks
      * If the Collateral Reference has changed then reset sequence and
      *  save the reference ...
     C                   IF        CACREF <> SaveCACREF
     C                   EVAL      Seq = 1
     C                   EVAL      SaveCACREF = CACREF
      * ... else increment the sequence.
     C                   ELSE
     C                   EVAL      Seq = Seq + 1
     C                   ENDIF
      *
     C                   EVAL      Stem = CACREF
     C                   EVAL      SeqN = Seq
     C                   EVAL      CAFRNT = FrntOffTransId
     C                   UPDATE    GLCOLAD0
      *
     C                   ENDIF
      *
     C                   READ      GLCOLAL2
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
