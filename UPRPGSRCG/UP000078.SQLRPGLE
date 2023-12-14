     H DEBUG
     H COPYRIGHT('(c) Finastra International 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU rebuild order')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000078 - ADBU rebuild order                                *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD061992             Date 23Oct23             *
      *  Prev Amend No. MD060960 *CREATE     Date 16Jan23             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061992 - Allow 3 char prefix for reference libraries       *
      *  MD060960 - Some dependents do not exist yet as their         *
      *             CRTDUPOBJ has not been executed yet. Fix is to    *
      *             rebuild the order.                                *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D SQLDynStmt      S           2000A
     D*SYS******       S              2A                                                    MD061992
     D SYS             S              3A                                                    MD061992
     D ERROR           S             10A
     D GMlib           S             10A
     D GPlib           S             10A
     D GVlib           S             10A
     D GTAlib          S             10A


     D count1          S              5  0
     D count2          S              5  0
     D UPGDEP        E DS                  EXTNAME(UPGDEPTD)

     D/COPY ZACPYSRC,PSDS
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    SYS
     C                   PARM                    ERROR

     C                   eval      GMlib = SYS + 'GMLIB'
     C                   eval      GPlib = SYS + 'GPLIB'
     C                   eval      GVlib = SYS + 'GVLIB'
     C                   eval      GTAlib = SYS + 'GTALIB'

      * First use all PF that will be changed for the first level.
      * This will list all 'direct' dependents
     C                   eval      SQLDynStmt = ' insert into UPGDEPTD ' +
     C                             '(select DBFLIB, substr(DBFFIL,1,10),' +
     C                             ' DBFLDP, substr(DBFFDP,1,10), DBFTDP, 0 ' +
     C                             'from QADBFDEP q WHERE exists ' +
     C                             '(select * from UPGDRVTD u where (' +
     C                             'u.DRACTN = ' + '''' + 'SQL Update' + '''' +
     C                             ' or u.DRACTN = ' + '''' +
     C                             'File will be copied' + '''' +
     C                             ' or u.DRACTN = ' + '''' +
     C                             'Existing file will be duplicated' + '''' +
     C                             ' or u.DRACTN = ' + '''' +
     C                             'New file will be duplicated' + '''' +
     C                             ' or u.DRACTN = ' + '''' +
     C                             'SQL Update KEEP' + '''' + ')' +
     C                             ' and u.DRFILE = q.DBFFIL and q.DBFLIB in' +
     C                             ' (' + '''' + GMlib + '''' + ', ' +
     C                             '''' + GPlib + '''' + ', ' +
     C                             '''' + GVlib + '''' + ', ' +
     C                             '''' + GTAlib + '''' + ')) ' +
     C                             'group by substr(DBFFDP,1,10), DBFFIL, ' +
     C                             'DBFLIB, DBFLDP, DBFTDP)'

     C/exec SQL
     C+ execute immediate :SQLDynStmt
     C/end-exec

     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   exsr      *PSSR
     C                   endif

      * This will be the result (as an example)

      * Ex1
      *  SXGPLIB    GZCLOANCL    SXGVLIB     GZCLOANLL0    D       0

      * Ex2
      *  RFDTALIB    GPPWHCTD    RFDVLIB     GPPWHJI0      D       0

      * Ex3
      *  RFDMLIB     GPPWHBTD    RFDVLIB     GPPWHJW1      I       0
      *  RFDTALIB    GPPWHCTD    RFDVLIB     GPPWHJW1      I       0
      *  RFDMLIB     GPPWHXTD    RFDVLIB     GPPWHJW1      I       0

      * Ex4
      *  RFDTALIB    GPPWHCTD    RFDVLIB     GPPWHJW0      I       0
      *  RFDMLIB     GPPWHBTD    RFDVLIB     GPPWHJW0      I       0
      *  RFDMLIB     GPPWHXTD    RFDVLIB     GPPWHJW0      D       0

      * Ex1 and Ex2 shows type Data, this means that the dependent can be compiled
      * Ex3 shows type Indirect, GPPWHJW1 cannot be compiled as it depends on...
      * Ex4 shows both types, Data as the JW0 directly depends on XTD, Indirect as
      * JW0 depends on UW0. So Ex4 cannot be compiled. So the type 'D' needs to be
      * forced to 'I'

     C/exec SQL
     C+ update UPGDEPTD a set UPFLAG = 'I'
     C+ where UPFLAG = 'D' and exists (select * from UPGDEPTD b
     C+ where b.UPFILD = a.UPFILD and b.UPFLAG = 'I')
     C/end-exec

     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   exsr      *PSSR
     C                   endif

      * Now for dependent having type 'D', ouput their repsective dependent (if any),
      * level flag is now set to 1

     C                   eval      SQLDynStmt = ' insert into UPGDEPTD ' +
     C                             'select DBFLIB, substr(DBFFIL,1,10),' +
     C                             ' DBFLDP, substr(DBFFDP,1,10), DBFTDP, 1 ' +
     C                             'from QADBFDEP q WHERE exists ' +
     C                             '(select * from UPGDEPTD d where ' +
     C                             'd.UPFILD = q.DBFFIL and q.DBFLDP = ' +
     C                             '''' + GVlib + '''' + ' and q.DBFLIB = ' +
     C                             '''' + GVlib + '''' + ' and d.UPLEVL = 0' +
     C                             ' and d.UPFLAG <> ' + '''' + 'I' + '''' + ')'

     C/exec SQL
     C+ execute immediate :SQLDynStmt
     C/end-exec

     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   exsr      *PSSR
     C                   endif

      * loop until records are found
     C                   eval      count2 = 2
     C                   eval      count1 = 1

     C                   DOW       SQLCode = 0
     C                   eval      SQLDynStmt = ' insert into UPGDEPTD ' +
     C                             'select DBFLIB, substr(DBFFIL,1,10),' +
     C                             ' DBFLDP, substr(DBFFDP,1,10), DBFTDP,' +
     C                             %char(count2) +
     C                             ' from QADBFDEP q WHERE exists ' +
     C                             '(select * from UPGDEPTD d where ' +
     C                             'd.UPFILD = q.DBFFIL and q.DBFLDP = ' +
     C                             '''' + GVlib + '''' + ' and q.DBFLIB = ' +
     C                             '''' + GVlib + '''' + ' and d.UPLEVL = ' +
     C                             %char(count1) + ')'

     C/exec SQL
     C+ execute immediate :SQLDynStmt
     C/end-exec

     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   exsr      *PSSR
     C                   endif
     C                   eval      count2 = count2 + 1
     C                   eval      count1 = count1 + 1

     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN

      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      ERROR = '*Error'
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
