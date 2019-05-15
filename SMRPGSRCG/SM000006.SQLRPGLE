     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Find latest release record on SCRELHPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000006 - Find latest release record on release history     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *   Last Amend No. CUP023  *REWRITE      Date 22Mar11           *
      *   Prev Amend No. BUG27791  *CREATE     Date 28May10           *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP023 - Use sequence to find 'from' release level.          *
      *  BUG27791 - Postings reconciliation utility                   *
      *                                                               *
      *****************************************************************
      *
     D MaxRls          S             51
     D PProduct        S             10
     D PRelease        S             10
     D PSubRls         S              2
     D Product         S              3
     D Recursive       S              1    INZ(' ')
      *
     C     *ENTRY        PLIST
     C                   PARM                    PProduct
     C                   PARM                    PRelease
     C                   PARM                    PSubRls
      *
     C/EXEC SQL
     C+ select max(ALLRCD)
     C+ into: MaxRls
     C+ from QTEMP/RELH
     C/END-EXEC
      *
      * Select product.
     C                   EVAL      Product = %SUBST(MaxRls:14:3)
     C                   SELECT
      * BankFusion
     C                   WHEN      Product = 'BFV'
     C                   EVAL      PProduct = 'BankFusion'
     C                   EVAL      PRelease = %SUBST(MaxRls:17:1) + '.' +
     C                             %SUBST(MaxRls:19:1)
      *
      * Midas Plus
     C                   WHEN      Product = 'MPV'
     C                   EVAL      PProduct = 'MidasPlus'
     C                   EVAL      PRelease = %SUBST(MaxRls:17:1) + '.' +
     C                             %SUBST(MaxRls:19:1)
     C                   IF        %SUBST(MaxRls:24:2) = 'T '
     C                   EVAL      PRelease = %TRIMR(PRelease) + '00'
     C                   ELSE
     C                   IF        %SUBST(MaxRls:24:2) = '01'
     C                   EVAL      PRelease = %TRIMR(PRelease) + '.1'
     C                   ENDIF
     C                   ENDIF
     C                   IF        %SUBST(MaxRls:27:7) = 'Service'
     C                   EVAL      PSubRls = %SUBST(MaxRls:40:2)
     C                   ELSE
     C                   EVAL      PSubRls = '00'
     C                   ENDIF
      *
      * Midas
     C                   OTHER
     C                   EVAL      PProduct = 'Midas'
      * ABS
     C                   IF        %SUBST(MaxRls:14:3) = 'ABS'
     C                   EVAL      PRelease = %SUBST(MaxRls:14:4) +
     C                             %SUBST(MaxRls:19:4)
     C                   EVAL      PSubRls  = %SUBST(MaxRls:24:3)
     C                   ENDIF
      * DBA
     C                   IF        %SUBST(MaxRls:14:3) = 'DBA'
     C                   EVAL      PRelease = %SUBST(MaxRls:14:10)
     C                   EVAL      PSubRls  = %SUBST(MaxRls:24:3)
     C                   ENDIF
      * Release 4
     C                   IF        %SUBST(MaxRls:22:2) = '04'
     C                   EVAL      PRelease = 'R4'
     C                   EVAL      PSubRls  = %SUBST(MaxRls:24:3)
     C                   ENDIF
      *
     C                   ENDSL
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
     C                   SETON                                        U7U8LR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C     EPSSR         ENDSR
      *
      *****************************************************************
