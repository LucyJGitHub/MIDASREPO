     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU count distinct')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UPCNTDST - This program counts distinct file for ADBU        *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************

     D SQLDynStmt      S           5000A
     D SQLOK           C                   Const( 0 )

      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    ERROR            10
     C                   PARM                    X_COUNT1          5 0
     C                   PARM                    X_COUNT2          5 0

     C                   eval      ERROR = *BLANK
     C                   eval      X_COUNT1 = 0
     C                   eval      X_COUNT2 = 0

     C/exec SQL
     C+ select count(distinct WHFILE)
     C+ into
     C+   :X_COUNT1
     C+ from QTEMP/DSPFFD1
     C/end-exec
     C                   If        SQLCode <> SQLOK
     C                   eval      ERROR = '*Error'
     C                   Endif

     C/exec SQL
     C+ select count(distinct WHFILE)
     C+ into
     C+   :X_COUNT2
     C+ from QTEMP/DSPFFD2
     C/end-exec
     C                   If        SQLCode <> SQLOK
     C                   eval      ERROR = '*Error'
     C                   Endif

     C                   EVAL      *INLR = *ON
     C                   RETURN

