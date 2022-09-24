     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTR update monitor work table')               *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP7001 - Midas UP monitor work table                         *
      *                                                               *
      *  Function: This program writes and update the table used for  *
      *            monitoring the refresh.                            *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CUP045 *CREATE     Date 01Jun22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP045 - One Touch Bridge - refresh                          *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0

     D ArrLyr          S              2    DIM(11)
     D D_LAYR          S              7A
     D Ix              S              2S 0
     D NoCmp           S              3S 0
     D TMST            S              6A
     D L_DESC          S             35A
     D RETURN          S             10A
     D UPDTBL          S             10A
     D UPDFLD          S             10A
     D UPDVAL          S            100A
     D UPDACT          S             10A
     D SQLDynStmt      S            500A
     D DBASE           S              3A
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    UPDACT
     C                   PARM                    GPFX              2
     C                   PARM                    UPDFLD
     C                   PARM                    UPDVAL
     C                   PARM                    RETURN           10

     C                   eval      RETURN = *blanks

     C                   Select

     C                   when      UPDACT = '*WRITE'

      * Set start time
     C                   TIME                    ##TME             6 0
     C                   eval      TMST = %CHAR(##TME)

      * Set zone description
     C                   If        %subst(UPDVAL:1:5) = '*ZONE'
     C                   eval      D_LAYR = '*ZONE'
      * If *ZONE, retrieve zone name
     C/exec SQL
     C+ select ZODESC into :L_DESC
     C+ from GPZONEPD where ZOMSYS = :GPFX
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '100'
     C                   exsr      *pssr
     C                   Endif

     C                   else
     C                   eval      D_LAYR = '*GLOBAL'
     C                   eval      L_DESC = '*GLOBAL'
     C                   Endif

     C/EXEC SQL
     C+ insert into UPOTRMTD
     C+ (
     C+   DRPRFX
     C+  ,DLAYRS
     C+  ,DNOCMP
     C+  ,DNOCMC
     C+  ,DSTRTD
     C+  ,DENDED
     C+  ,DCMPG1
     C+  ,DSTRG1
     C+  ,DENDG1
     C+  ,DCMPG11
     C+  ,DSTRG11
     C+  ,DENDG11
     C+  ,DCMPG2
     C+  ,DSTRG2
     C+  ,DENDG2
     C+  ,DCMPG3
     C+  ,DSTRG3
     C+  ,DENDG3
     C+  ,DCMPG4
     C+  ,DSTRG4
     C+  ,DENDG4
     C+  ,DCMPG5
     C+  ,DSTRG5
     C+  ,DENDG5
     C+  ,DCMPG6
     C+  ,DSTRG6
     C+  ,DENDG6
     C+  ,DCMPG7
     C+  ,DSTRG7
     C+  ,DENDG7
     C+  ,DCMPG8
     C+  ,DSTRG8
     C+  ,DENDG8
     C+  ,DACTNR
     C+ )
     C+ Values
     C+ (
     C+   :GPFX
     C+  ,:D_LAYR
     C+  ,:NoCmp
     C+  ,0
     C+  ,:TMST
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:L_DESC
     C+ )
     C/END-EXEC
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '101'
     C                   exsr      *pssr
     C                   Endif

      * Update whatever field is passed as parameter
     C                   when      UPDACT = '*UPDATE'
     C                   eval      SQLDynStmt = *BLANKS

     C                   If        UPDFLD = 'DNOCMC'
     C                             and %subst(UPDVAL:1:1) = '+'
     C                   eval      SQLDynStmt = 'update UPOTRMTD set ' +
     C                             UPDFLD + ' = ' + UPDFLD + ' + 1'
     C                   else
     C                   If        UPDFLD = 'DNOCMC'
     C                             and %subst(UPDVAL:1:1) = '-'
     C                   eval      SQLDynStmt = 'update UPOTRMTD set ' +
     C                             UPDFLD + ' = ' + UPDFLD + ' - 1'
     C                   else
     C                   eval      SQLDynStmt = 'update UPOTRMTD set ' +
     C                             UPDFLD + ' = ' + '''' + %TRIM(UPDVAL) +
     C                             ''''
     C                   ENDIF
     C                   ENDIF

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '102'
     C                   exsr      *pssr
     C                   Endif

      * if field being updated is the layer, then reset other fields
     C                   If        UPDFLD = 'DACTVL'
     C/EXEC SQL
     C+ update UPOTRMTD set DCMPG1 = ' ', DSTRG1 = ' ', DENDG1 = ' ',
     C+                     DCMPG11 = ' ', DSTRG11 = ' ', DENDG11 = ' ',
     C+                     DCMPG2 = ' ', DSTRG2 = ' ', DENDG2 = ' ',
     C+                     DCMPG3 = ' ', DSTRG3 = ' ', DENDG3 = ' ',
     C+                     DCMPG4 = ' ', DSTRG4 = ' ', DENDG4 = ' ',
     C+                     DCMPG5 = ' ', DSTRG5 = ' ', DENDG5 = ' ',
     C+                     DCMPG6 = ' ', DSTRG6 = ' ', DENDG6 = ' ',
     C+                     DCMPG7 = ' ', DSTRG7 = ' ', DENDG7 = ' ',
     C+                     DCMPG8 = ' ', DSTRG8 = ' ', DENDG8 = ' ',
     C+                     DACTNR = ' '
     C/END-EXEC
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '103'
     C                   exsr      *pssr
     C                   Endif
     C                   ENDIF

     C                   when      UPDACT = '*CHECK'

      * At the end, update 'Time Ended' field
     C/EXEC SQL
     C+ select count(*) into :RcdCount from UPGCMPTD
     C/END-EXEC
     C                   If        SQLCode <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   eval      DBASE = '104'
     C                   exsr      *pssr
     C                   Else
      * set RETURN
     C                   If        RcdCount > 0
     C                   eval      RETURN = 'Found     '
     C                   Else
     C                   eval      RETURN = 'Not_found '
     C                   Endif
     C                   Endif

     C                   Endsl

     C     EndTag        Tag
     C                   Seton                                        LR
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   eval      RETURN = '*Error'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
