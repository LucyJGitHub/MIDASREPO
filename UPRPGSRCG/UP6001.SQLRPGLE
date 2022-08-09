     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTU output upgrade monitor table')            *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP6001 - Midas UP OTU output upgrade monitor table           *
      *                                                               *
      *  Function: This program writes and updates the upgrade        *
      *            monitor table needed by the monitor screen.        *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CUP044 *CREATE     Date 22May22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP044 - One Touch Bridge Automation Changes - Release/      *
      *           Patch Upgrade                                       *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0

     D ArrLyr          S              2    DIM(11)
     D ##LYRS          S             22A
     D Ix              S              2S 0
     D NoCmp           S              3S 0
     D TMST            S              6A
     D RETURN          S             10A
     D UPDTBL          S             10A
     D UPDFLD          S             10A
     D UPDVAL          S            100A
     D UPDACT          S             10A
     D SQLDynStmt      S           5000A
     D UPOPFX        E DS                  EXTNAME(UPOPFXTD)
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
      * At first, write record in UPGCMPTD
     C                   when      UPDACT = '*WRITE'

      * Retrieve layers from UPOPFXTD
     C/exec SQL
     C+ select * into :UPOPFX
     C+ from UPOPFXTD
     C/end-exec
     C                   If        SQLCode <> 0
     C                   exsr      *pssr
     C                   Endif

     C                   eval      NoCmp = 0
     C                   eval      ArrLyr(1) = GPRFX
     C                   eval      ArrLyr(2) = ZPFX1
     C                   eval      ArrLyr(3) = ZPFX2
     C                   eval      ArrLyr(4) = ZPFX3
     C                   eval      ArrLyr(5) = ZPFX4
     C                   eval      ArrLyr(6) = ZPFX5
     C                   eval      ArrLyr(7) = ZPFX6
     C                   eval      ArrLyr(8) = ZPFX7
     C                   eval      ArrLyr(9) = ZPFX8
     C                   eval      ArrLyr(10) =ZPFX9
     C                   eval      ArrLyr(11) =ZPFX0
     C                   DO        11            Ix
     C                   if        ArrLyr(Ix) <> *blanks
     C                   eval      ##LYRS = %trim(##LYRS) + ArrLyr(Ix)
      * each layer has 7 components (for now)
     C                   eval      NoCmp = NoCmp + 7
     C                   ENDIF
     C                   ENDDO

     C                   TIME                    ##TME             6 0
     C                   eval      TMST = %CHAR(##TME)

     C/EXEC SQL
     C+ insert into UPOTBMTD
     C+ (
     C+   DGPRFX
     C+  ,DLAYRS
     C+  ,DACTVL
     C+  ,DNOCMP
     C+  ,DNOCMC
     C+  ,DSTRTD
     C+  ,DENDED
     C+  ,DCMPG1
     C+  ,DSTRG1
     C+  ,DENDG1
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
     C+  ,DACTNR
     C+ )
     C+ Values
     C+ (
     C+   :GPFX
     C+  ,:##LYRS
     C+  ,' '
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
     C+ )
     C/END-EXEC
     C                   If        SQLCode <> 0
     C                   exsr      *pssr
     C                   Endif

      * Update whatever field is passed as parameter
     C                   when      UPDACT = '*UPDATE'
     C                   eval      SQLDynStmt = *BLANKS

      * If UPDVAL is *ZONE, retrieve zone name
     C                   If        %subst(UPDVAL:1:5) = '*ZONE'
     C/exec SQL
     C+ select ZODESC into :UPDVAL
     C+ from GPZONEPD where ZOMSYS in (select DACTVL from UPOTBMTD)
     C/end-exec
     C                   If        SQLCode <> 0
     C                   exsr      *pssr
     C                   Endif
     C                   ENDIF

     C                   If        UPDFLD = 'DNOCMC'
     C                             and %subst(UPDVAL:1:1) = '+'
     C                   eval      SQLDynStmt = 'update UPOTBMTD set ' +
     C                             UPDFLD + ' = ' + UPDFLD + ' + 1'
     C                   else
     C                   If        UPDFLD = 'DNOCMC'
     C                             and %subst(UPDVAL:1:1) = '-'
     C                   eval      SQLDynStmt = 'update UPOTBMTD set ' +
     C                             UPDFLD + ' = ' + UPDFLD + ' - 1'
     C                   else
     C                   eval      SQLDynStmt = 'update UPOTBMTD set ' +
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
     C                   exsr      *pssr
     C                   Endif

      * if field being updated is the layer, then reset other fields
     C                   If        UPDFLD = 'DACTVL'
     C/EXEC SQL
     C+ update UPOTBMTD set DCMPG1 = ' ', DSTRG1 = ' ', DENDG1 = ' ',
     C+                     DCMPG2 = ' ', DSTRG2 = ' ', DENDG2 = ' ',
     C+                     DCMPG3 = ' ', DSTRG3 = ' ', DENDG3 = ' ',
     C+                     DCMPG4 = ' ', DSTRG4 = ' ', DENDG4 = ' ',
     C+                     DCMPG5 = ' ', DSTRG5 = ' ', DENDG5 = ' ',
     C+                     DCMPG6 = ' ', DSTRG6 = ' ', DENDG6 = ' ',
     C+                     DCMPG7 = ' ', DSTRG7 = ' ', DENDG7 = ' ',
     C+                     DACTNR = ' '
     C/END-EXEC
     C                   If        SQLCode <> 0
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
