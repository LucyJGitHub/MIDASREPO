     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Write Script for driver Global')         *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000056 - This program                                      *
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
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D MovLib          S             10A
     D @DBFFDP         S             10A
     D @DBFLDP         S             10A
     D TOLIB           S             10A
     D OWNR            S             10A
     D AUTL            S             10A
     D Attr            S             10A
     D SAVFN           S             10A
      * Array to store Dependency (PF only)
     D PFFileLibA      S             20    DIM(9999)

      * DS for PF
     D                 DS
     D  PFDS                   1     20
     D  ArrFPF                 1     10
     D  ArrLPF                11     20
     D IxP             S              5  0
     D TotRow          S             13  0
     D SQLDynStmt      S            500A

     D #SEQ            S             15  5
     D UPGDRV        E DS                  EXTNAME(UPGDRVTD)
     D UPGSCR        E DS                  EXTNAME(UPGSCRTD)
     D UPGLOG        E DS                  EXTNAME(UPCLOGPD)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Library          10
     C                   PARM                    Prefix            2
     C                   PARM                    RefSys            2
     C                   PARM                    #SEQ
     C                   PARM                    SavLib           10
     C                   PARM                    Return           10

     C                   eval      AUTL = Prefix + 'DATABASE'
     C                   eval      OWNR = Prefix + 'OWNER'
      * reset flag 'Script Run' for all
     C/exec SQL
     C+ update UPGDRVTD set DRSCRP = ' '
     C+   where DRLIB = :Library
     C/end-exec
     C                   If        SQLCODE <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   EVAL      Return = '*ERROR'
     C                   RETURN
     C                   ENDIF

     C/exec SQL
     C+ declare ReadDRVG cursor for
     C+ select * from UPGDRVTD a
     C+   where DRLIB = :Library
     C+   order by rrn(a)
     C/end-exec

     C/exec SQL
     C+ open ReadDRVG
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from ReadDRVG
     C+ into
     C+   :UPGDRV
     C/end-exec

     C                   DOW       SQLCODE = 0

      * Depending on ACTION field

     C                   SELECT

      ******************* S Q L  U P D A T E
     C                   WHEN      DRACTN = 'SQL Update'
     C                             or DRACTN = 'SQL Update KEEP'

     C                   If        DRACTN = 'SQL Update KEEP'
     C                   eval      KEEP = 'Y'
     C                   else
     C                   eval      KEEP = 'N'
     C                   Endif

     C                   exsr      SR_Save

     C                   eval      #Lib2 = RefSys + %SUBST(DRLIB:3:8)
     C                   eval      #SEQ = #SEQ + 1

      * check if file has record
     C                   eval      TotRow = 0
     C                   eval      SQLDynStmt = 'select count(*) from ' +
     C                             %trimr(DRLIB) + '/' + %trimr(DRFILE)

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ declare C1 cursor with return to client for DynSQLStmnt
     C/end-exec

     C/EXEC SQL
     C+ open C1
     C/END-EXEC

     C/EXEC SQL
     C+ fetch C1 into :TotRow
     C/END-EXEC
     C                   if        TotRow = 0
     C                   eval      Empty = 'Y'
     C                   else
     C                   eval      Empty = 'N'
     C                   endif

     C/EXEC SQL
     C+ close C1
     C/END-EXEC

     C                   CALL      'UP000057'
     C                   PARM                    DRFILE                         File
     C                   PARM                    DRLIB                          Library
     C                   PARM                    #Lib2            10            Library
     C                   PARM      'A'           Mode              1            Mode
     C                   PARM                    Empty             1
     C                   PARM                    #SEQ             15 5          #SEQ
     C                   PARM                    KEEP              1            KEEP bespoke fields

     C                   exsr      SR_Restore

      * Add script for changed file
     C                   If        DRFLCH = 'Y'
     C                   exsr      SR_FileChange
     C                   Endif

      * update flag 'Script Run'
     C/exec SQL
     C+ update UPGDRVTD set DRSCRP = 'Y'
     C+ where DRFILE = :DRFILE
     C/end-exec
     C                   If        SQLCODE <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   EVAL      Return = '*ERROR'
     C                   RETURN
     C                   ENDIF

      ******************* F I L E  W I L L  B E  C O P I E D
     C                   WHEN      DRACTN = 'File will be copied'

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      #Lib2 = RefSys + %SUBST(DRLIB:3:8)
     C***                eval      SCCMD = 'CPYF FROMFILE(' + %trimr(#Lib2) +
     C***                          '/' + %trimr(DRFILE) + ')' +
     C***                          ' TOFILE(' + %trim(DRLIB) +
     C***                          '/' + %trimr(DRFILE) + ')' +
     C***                          ' CRTFILE(*YES)'
      * instead, use CRTDUPOBJ as CPYF fails if there is no member
     C                   eval      SCCMD = 'CRTDUPOBJ OBJ(' +
     C                             %trimr(DRFILE) + ') FROMLIB(' +
     C                             %trimr(#Lib2) + ') OBJTYPE(*FILE) TOLIB(' +
     C                             Prefix + %trimr(%subst(#Lib2:3:8)) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CRTDUPOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CLRPFM FILE(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CLRPFM'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      ** Authority **

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CHGOBJOWN OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*FILE' + '''' +
     C                             ') NEWOWN(' +
     C                             %trimr(OWNR) + ') CUROWNAUT(*SAME)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CHGOBJOWN'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*FILE' + '''' +
     C                             ') AUTL(' +
     C                             %trimr(AUTL) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'GRTOBJAUT'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE('+ '''' + '*FILE' + '''' +
     C                             ') USER(*PUBLIC) AUT(*AUTL)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'GRTOBJAUT'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   exsr      SR_Delete

      * update flag 'Script Run'
     C/exec SQL
     C+ update UPGDRVTD set DRSCRP = 'Y'
     C+ where DRFILE = :DRFILE
     C/end-exec
     C                   If        SQLCODE <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   EVAL      Return = '*ERROR'
     C                   RETURN
     C                   ENDIF

      ******************* F I L E  W I L L  B E  D U P L I C A
     C                   WHEN      DRACTN = 'Existing file will be duplicated'

     C                   exsr      SR_Save

      * if file is PF or table, it needs to be copied first
     C                   If        %SUBST(DRLIB:4:1) <> 'V'
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CALL PGM(UPC004001) PARM(' +
     C                             '''' + '*GLOBAL' + '''' + ' ' + '''' +
     C                             DRFILE + '''' + ' ' + '''' + DRLIB + '''' +
     C                              ' ' + '''' + '*COPY' + '''' + ' ' + '''' +
     C                             '''' + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CALL'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   ENDIF

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTF FILE(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'DLTF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * LF has to be moved to its dependency library first before CRTDUPOBJ
     C                   If        %SUBST(DRLIB:4:1) = 'V'
     C                   exsr      SR_MOVE
     C                   Endif

     C                   eval      #SEQ = #SEQ + 1
     C                   If        MovLib <> *blanks
     C                   eval      #Lib2 = RefSys + %SUBST(DRLIB:3:8)
     C                   eval      SCCMD = 'CRTDUPOBJ OBJ(' +
     C                             %trimr(DRFILE) + ') FROMLIB(' +
     C                             %trimr(MovLib) + ') OBJTYPE(*FILE) TOLIB(' +
     C                             Prefix + %trimr(%subst(MovLib:3:8)) + ')'
     C                   eval      TOLIB =  Prefix + %trimr(%subst(MovLib:3:8))
     C                   else
     C                   eval      SCCMD = 'CRTDUPOBJ OBJ(' +
     C                             %trimr(DRFILE) + ') FROMLIB(' +
     C                             %trimr(#Lib2) + ') OBJTYPE(*FILE) TOLIB(' +
     C                             %trimr(DRLIB) +  ')'
     C                   eval      TOLIB = DRLIB
     C                   Endif

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CRTDUPOBJ'
     C+  ,:DRFILE
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      ** Authority **

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CHGOBJOWN OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*FILE' + '''' +
     C                             ') NEWOWN(' +
     C                             %trimr(OWNR) + ') CUROWNAUT(*SAME)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CHGOBJOWN'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*FILE' + '''' +
     C                             ') AUTL(' +
     C                             %trimr(AUTL) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'GRTOBJAUT'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE('+ '''' + '*FILE' + '''' +
     C                             ') USER(*PUBLIC) AUT(*AUTL)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'GRTOBJAUT'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * LF has to be moved back and its dependency library have now to be moved back
     C                   If        %SUBST(DRLIB:4:1) = 'V'
     C                   exsr      SR_MOVEBack
     C                   Endif

      * if file is PF or table, it needs to be copied back
     C                   If        %SUBST(DRLIB:4:1) <> 'V'
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CALL PGM(UPC004001) PARM(' +
     C                             '''' + '*GLOBAL' + '''' + ' ' + '''' +
     C                             DRFILE +  '''' + ' ' + '''' + DRLIB + '''' +
     C                             ' ' + '''' + '*COPYBACK' + '''' + ' ' +
     C                             '''' + '''' + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CALL'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC
     C                   Endif

     C                   exsr      SR_Restore

      * update flag 'Script Run'
     C/exec SQL
     C+ update UPGDRVTD set DRSCRP = 'Y'
     C+ where DRFILE = :DRFILE
     C/end-exec
     C                   If        SQLCODE <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   EVAL      Return = '*ERROR'
     C                   RETURN
     C                   ENDIF

      *******************
     C                   WHEN      DRACTN = 'New file will be duplicated'

      * LF has to be moved to its dependency library first before CRTDUPOBJ
     C                   exsr      SR_MOVE

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      #Lib2 = RefSys + %SUBST(DRLIB:3:8)
     C                   eval      SCCMD = 'CRTDUPOBJ OBJ(' +
     C                             %trimr(DRFILE) + ') FROMLIB(' +
     C                             %trimr(MovLib) + ') OBJTYPE(*FILE) TOLIB(' +
     C                             Prefix + %trimr(%subst(MovLib:3:8)) + ')'
     C                   eval      TOLIB = Prefix + %trimr(%subst(MovLib:3:8))

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CRTDUPOBJ'
     C+  ,:DRFILE
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      ** Authority **

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CHGOBJOWN OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*FILE' + '''' +
     C                             ') NEWOWN(' +
     C                             %trimr(OWNR) + ') CUROWNAUT(*SAME)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CHGOBJOWN'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*FILE' + '''' +
     C                             ') AUTL(' +
     C                             %trimr(AUTL) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'GRTOBJAUT'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE('+ '''' + '*FILE' + '''' +
     C                             ') USER(*PUBLIC) AUT(*AUTL)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'GRTOBJAUT'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * LF has to be moved back and its dependency library have now to be moved back
     C                   exsr      SR_MOVEBack

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTF FILE(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'DLTF'
     C+  ,:DRFILE
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * Add script for changed file
     C                   If        DRFLCH = 'Y'
     C                   exsr      SR_FileChange
     C                   Endif

      * update flag 'Script Run'
     C/exec SQL
     C+ update UPGDRVTD set DRSCRP = 'Y'
     C+ where DRFILE = :DRFILE
     C/end-exec
     C                   If        SQLCODE <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   EVAL      Return = '*ERROR'
     C                   RETURN
     C                   ENDIF

      ******************* F I L E  W I L L  B E  D E L E T E D
     C                   WHEN      DRACTN = 'File will be deleted'

     C                   exsr      SR_Save

      * if file is PF or table, it needs to be copied first
     C                   If        %SUBST(DRLIB:4:1) <> 'V'
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CALL PGM(UPC004001) PARM(' +
     C                             '''' + '*GLOBAL' + '''' + ' ' + '''' +
     C                             DRFILE + '''' + ' ' + '''' + DRLIB + '''' +
     C                              ' ' + '''' + '*COPY' + '''' + ' ' + '''' +
     C                             '''' + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CALL'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   ENDIF
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTF FILE(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'DLTF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   exsr      SR_Restore

      * update flag 'Script Run'
     C/exec SQL
     C+ update UPGDRVTD set DRSCRP = 'Y'
     C+ where DRFILE = :DRFILE
     C/end-exec
     C                   If        SQLCODE <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   EVAL      Return = '*ERROR'
     C                   RETURN
     C                   ENDIF

      ******************* F I L E  W I L L  B E  C H A N G E D
     C                   WHEN      DRACTN = 'File will be changed'

     C                   exsr      SR_FileChange


      * update flag 'Script Run'
     C/exec SQL
     C+ update UPGDRVTD set DRSCRP = 'Y'
     C+ where DRFILE = :DRFILE
     C/end-exec
     C                   If        SQLCODE <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   EVAL      Return = '*ERROR'
     C                   RETURN
     C                   ENDIF

      ******************* N E W  D T A A R A  W I L L  B E  D U P L I C A T E D
     C                   WHEN      DRACTN = 'New DTAARA will be duplicated'
     C                             or DRACTN = 'Existing DTAARA will be' +
     C                             ' duplicated'

     C                   If        DRACTN = 'Existing DTAARA will be' +
     C                             ' duplicated'
     C                   exsr      SR_SaveDTAA
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTDTAARA DTAARA(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'DLTDTAARA'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   endif

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CRTDUPOBJ OBJ(' +
     C                             %trimr(DRFILE) + ') FROMLIB(' + RefSys +
     C                             %trimr(%subst(DRLIB:3:8)) + ') +
     C                             OBJTYPE(*DTAARA) TOLIB(' + DRLIB + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CRTDUPOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      ** Authority **

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CHGOBJOWN OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*DTAARA' + '''' +
     C                             ') NEWOWN(' +
     C                             %trimr(OWNR) + ') CUROWNAUT(*SAME)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CHGOBJOWN'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*DTAARA' + '''' +
     C                             ') AUTL(' +
     C                             %trimr(AUTL) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'GRTOBJAUT'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE('+ '''' + '*DTAARA' + '''' +
     C                             ') USER(*PUBLIC) AUT(*AUTL)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'GRTOBJAUT'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   If        DRACTN = 'Existing DTAARA will be' +
     C                             ' duplicated'
     C                   exsr      SR_RestoreDTAA
     C                   endif

      * update flag 'Script Run'
     C/exec SQL
     C+ update UPGDRVTD set DRSCRP = 'Y'
     C+ where DRFILE = :DRFILE
     C/end-exec
     C                   If        SQLCODE <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   EVAL      Return = '*ERROR'
     C                   RETURN
     C                   ENDIF

      ******************* N E W  D T A Q  W I L L  B E  D U P L I C A T E D
     C                   WHEN      DRACTN = 'New DTAQ will be duplicated'
     C                             or DRACTN = 'Existing DTAQ will be' +
     C                             ' duplicated'

     C                   If        DRACTN = 'Existing DTAQ will be' +
     C                             ' duplicated'
     C                   exsr      SR_SaveDTAQ
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTDTAQ DTAQ(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'DLTDTAQ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   endif

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CRTDUPOBJ OBJ(' +
     C                             %trimr(DRFILE) + ') FROMLIB(' + RefSys +
     C                             %trimr(%subst(DRLIB:3:8)) + ') +
     C                             OBJTYPE(*DTAQ) TOLIB(' + DRLIB + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CRTDUPOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      ** Authority **

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CHGOBJOWN OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*DTAQ' + '''' +
     C                             ') NEWOWN(' +
     C                             %trimr(OWNR) + ') CUROWNAUT(*SAME)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CHGOBJOWN'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*DTAQ' + '''' +
     C                             ') AUTL(' +
     C                             %trimr(AUTL) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'GRTOBJAUT'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE('+ '''' + '*DTAQ' + '''' +
     C                             ') USER(*PUBLIC) AUT(*AUTL)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'GRTOBJAUT'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   If        DRACTN = 'Existing DTAQ will be' +
     C                             ' duplicated'
     C                   exsr      SR_RestoreDTAQ
     C                   endif

      * update flag 'Script Run'
     C/exec SQL
     C+ update UPGDRVTD set DRSCRP = 'Y'
     C+ where DRFILE = :DRFILE
     C/end-exec
     C                   If        SQLCODE <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   EVAL      Return = '*ERROR'
     C                   RETURN
     C                   ENDIF

      ******************* I G N O R E
     C                   WHEN      DRACTN = 'IGNORE'
      * update flag 'Script Run'
     C/exec SQL
     C+ update UPGDRVTD set DRSCRP = 'Y'
     C+ where DRFILE = :DRFILE
     C/end-exec
     C                   If        SQLCODE <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   EVAL      Return = '*ERROR'
     C                   RETURN
     C                   ENDIF


     C                   OTHER
     C                   DUMP

     C                   ENDSL

      * Get next
     C/exec SQL
     C+ fetch next
     C+ from ReadDRVG
     C+ into
     C+   :UPGDRV
     C/end-exec

     C                   END

     C/exec SQL
     C+ close ReadDRVG
     C/end-exec

      * when done send MSG to server
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'UP000052'    DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'DONE'        DtqDta           50

     C                   Seton                                        LR
     C                   Return

      *****************************************************************
     C     SR_MOVE       begsr

      * 1. check dependency in Reference System
     C                   eval      #Lib2 = RefSys + %SUBST(DRLIB:3:8)
     C/exec SQL
     C+ declare LEVEL1 cursor for
     C+ select DBFLIB, DBFFIL
     C+ from QADBFDEP
     C+ where DBFFDP = :DRFILE
     C+ and DBFLDP = :#Lib2
     C+ order by DBFFDP
     C/end-exec
      *
     C/exec SQL
     C+ open LEVEL1
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LEVEL1
     C+ into :@DBFLDP,
     C+      :@DBFFDP
     C/end-exec

     C                   eval      MovLib = *BLANKS
     C                   clear                   PFFileLibA
     C                   clear                   PFDS
     C                   eval      IxP = 0

     C                   DOW       SQLCODE = 0
      * store first library which will be the library used for the MOV
     C                   if        MovLib = *blanks
     C                   eval      MovLib = @DBFLDP
     C                   endif

      *store file + lib in array is different from MovLib
     C                   if        MovLib <> @DBFLDP
     C                   eval      ArrFPF = @DBFFDP
     C                   eval      ArrLPF = @DBFLDP

      ** Check entry does not exist yet
     C     PFDS          LOOKUP    PFFileLibA                             02
     C                   IF        *IN02 = *OFF
     C                   eval      IxP = IxP + 1
     C                   eval      PFFileLibA(IxP) = PFDS
     C                   endif
     C                   endif

     C/exec SQL
     C+ fetch next
     C+ from LEVEL1
     C+ into :@DBFLDP,
     C+      :@DBFFDP
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LEVEL1
     C/end-exec

      * 2. if array is not empty, need to move other dependency into MovLib
     C                   If        IxP <> 0

     C                   eval      IxP = 1
     C                   DOW       PFFileLibA(IxP) <> *BLANKS
     C                   eval      PFDS = PFFileLibA(IxP)

      * 2.1 move dependency  - Ref System
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' +
     C                             %trimr(ArrLPF) + '/' + %trimr(ArrFPF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' +
     C                             %trimr(MovLib) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :RefSys
     C+  ,:DRFILE
     C+  ,:#Lib2
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:ArrFPF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * 2.2 move dependency  - Prod System
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' + Prefix +
     C                             %trimr(%subst(ArrLPF:3:8)) +
     C                             '/' + %trimr(ArrFPF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' + Prefix +
     C                             %trimr(%subst(MovLib:3:8)) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:ArrFPF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      IxP = IxP + 1
     C                   ENDDO
     C                   ENDIF

      * 3. finally move LF into its dependency library - Ref System  (no matter what IxP is)
      * provided that MovLib is not blank (which is the case when PF is to be duplicated REINTCPD)
     C                   if        MovLib <> *blanks
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' +
     C                             %trimr(#Lib2) + '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(*FILE) TOLIB(' +
     C                             %trimr(MovLib) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :RefSys
     C+  ,:DRFILE
     C+  ,:#Lib2
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:DRFILE
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC
     C                   endif

     C                   ENDSR
      *****************************************************************
      *****************************************************************
     C     SR_MOVEBack   begsr

      * 1. move back LF - Ref system
     C                   if        MovLib <> *blanks
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' +
     C                             %trimr(MovLib) + '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(*FILE) TOLIB(' +
     C                             %trimr(#Lib2) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :RefSys
     C+  ,:DRFILE
     C+  ,:#Lib2
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:DRFILE
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * 2. move back LF - Prod system
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' + Prefix +
     C                             %trimr(%subst(MovLib:3:8)) + '/' +
     C                             %trimr(DRFILE) +
     C                             ') OBJTYPE(*FILE) TOLIB(' +
     C                             %trimr(DRLIB) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:#Lib2
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:DRFILE
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC
     C                   endif

      * 3. move back dependency - Reference and Prod

     C                   eval      IxP = 1
     C                   DOW       PFFileLibA(IxP) <> *BLANKS
     C                   eval      PFDS = PFFileLibA(IxP)

      * 3.1 move dependency  - Ref System
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' +
     C                             %trimr(MovLib) + '/' + %trimr(ArrFPF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' +
     C                              %trimr(ArrLPF) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :RefSys
     C+  ,:DRFILE
     C+  ,:#Lib2
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:ArrFPF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * 3.2 move dependency  - Prod System
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' + Prefix +
     C                             %trimr(%subst(MovLib:3:8)) +
     C                             '/' + %trimr(ArrFPF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' + Prefix +
     C                             %trimr(%subst(ArrLPF:3:8)) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:ArrFPF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   eval      IxP = IxP + 1
     C                   ENDDO

     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SR_Save       BEGSR

      * Command to CHKOBJ first (to avoid problem in case of re-run)
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CHKOBJ OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) + ')' +
     C                             ' OBJTYPE(*FILE)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'CHKOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * Command to create save file
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CRTSAVF FILE(' + %trimr(SavLib) +
     C                             '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'CRTSAVF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * Command to save file
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'SAVOBJ OBJ(' + %trimr(DRFILE) +
     C                             ') LIB(' + %trimr(DRLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SavLib) +
     C                              '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'SAVOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SR_Restore    BEGSR

      * Command to delete file before restore - Disaster Recovery
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTF FILE(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'DLTF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * Command to restore file - rebuild
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'RSTOBJ OBJ(' + %trimr(DRFILE) +
     C                             ') SAVLIB(' + %trimr(DRLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SavLib) +
     C                              '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'RSTOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SR_Delete     BEGSR

      * Command to delete file - Disaster Recovery
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTF FILE(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'DLTF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SR_FileChange BEGSR

      * Command to change file
      * Retrieve type of change from UPGLOGPD
     C/exec SQL
     C+ declare LogG cursor for
     C+ select * from UPGLOGPD
     C+ where WFILE = :DRFILE and WFLDA like 'AT%'
     C/end-exec

     C/exec SQL
     C+ open LogG
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LogG
     C+ into :UPGLOG
     C/end-exec

     C                   DOW       SQLCODE = 0

     C                   SELECT

     C                   when      WFLDA = 'ATTXT'
     C                   eval      #SEQ = #SEQ + 1
     C                   If        %SUBST(DRLIB:4:1) = 'V'
     C                   eval      SCCMD = 'CHGLF FILE(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ') TEXT(' + '''' +
     C                             %trimr(WWHDS) + '''' + ')'
     C                   else
     C                   eval      SCCMD = 'CHGPF FILE(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ') TEXT(' + '''' +
     C                             %trimr(WWHDS) + '''' + ')'
     C                   Endif

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CHGPF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   when      WFLDA = 'ATWAIT'
     C                   eval      Attr = %subst(WDATA:25:3)
     C                   If        Attr = ' 1-'
     C                   eval      Attr = ''''+ '*IMMED' + ''''
     C                   endif
     C                   eval      #SEQ = #SEQ + 1
     C                   If        %SUBST(DRLIB:4:1) = 'V'
     C                   eval      SCCMD = 'CHGLF FILE(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ') WAITFILE(' +
     C                              %trimr(Attr) + ')'
     C                   else
     C                   eval      SCCMD = 'CHGPF FILE(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ') WAITFILE(' +
     C                              %trimr(Attr) + ')'
     C                   endif

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CHGPF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   when      WFLDA = 'ATWATR'
     C                   eval      Attr = %subst(WDATA:24:3)
     C                   eval      #SEQ = #SEQ + 1
     C                   If        %SUBST(DRLIB:4:1) = 'V'
     C                   eval      SCCMD = 'CHGLF FILE(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ') WAITFILE(' +
     C                              %trimr(Attr) + ')'
     C                   else
     C                   eval      SCCMD = 'CHGPF FILE(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ') WAITRCD(' +
     C                              %trimr(Attr) + ')'
     C                   endif

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CHGPF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   when      WFLDA = 'ATLVLC'
     C                   eval      SCCMD = *BLANKS
     C                   If        %subst(WDATA:1:1) = 'N'
     C                             and %subst(WDATA:22:1) = 'Y'
     C                   eval      #SEQ = #SEQ + 1
     C                   If        %SUBST(DRLIB:4:1) = 'V'
     C                   eval      SCCMD = 'CHGLF FILE(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ') LVLCHK(*YES)'
     C                   else
     C                   eval      SCCMD = 'CHGPF FILE(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ') LVLCHK(*YES)'
     C                   endif
     C                   ENDIF
     C                   If        %subst(WDATA:1:1) = 'Y'
     C                             and %subst(WDATA:22:1) = 'N'
     C                   eval      #SEQ = #SEQ + 1
     C                   If        %SUBST(DRLIB:4:1) = 'V'
     C                   eval      SCCMD = 'CHGLF FILE(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ') LVLCHK(*NO)'
     C                   else
     C                   eval      SCCMD = 'CHGPF FILE(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ') LVLCHK(*NO)'
     C                   endif
     C                   ENDIF

     C                   If        SCCMD <> *BLANKS
     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'  '
     C+  ,'CLP'
     C+  ,'CHGPF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC
     C                   endif

     C                   ENDSL

     C/exec SQL
     C+ fetch next
     C+ from LogG
     C+ into :UPGLOG
     C/end-exec

     C                   Enddo

     C/exec SQL
     C+ close LogG
     C/end-exec
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SR_SaveDTAA   BEGSR

      * Command to CHKOBJ first (to avoid problem in case of re-run)
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CHKOBJ OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) + ')' +
     C                             ' OBJTYPE(*DTAARA)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'CHKOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * Command to create save file
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SAVFN =  %trimr(DRFILE) + '@'
     C                   eval      SCCMD = 'CRTSAVF FILE(' + %trimr(SavLib) +
     C                             '/' + %trimr(SAVFN) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'CRTSAVF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * Command to save file
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'SAVOBJ OBJ(' + %trimr(DRFILE) +
     C                             ') LIB(' + %trimr(DRLIB) +
     C                             ') DEV(*SAVF) OBJTYPE(*DTAARA) ' +
     C                             'SAVF(' + %trimr(SavLib) +
     C                             '/' + %trimr(SAVFN) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'SAVOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SR_RestoreDTAABEGSR

      * Command to delete DTAARA before restore - Disaster Recovery
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTDTAARA DTAARA(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'DLTDTAARA'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * Command to restore file - rebuild
     C                   eval      SAVFN =  %trimr(DRFILE) + '@'
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'RSTOBJ OBJ(' + %trimr(DRFILE) +
     C                             ') SAVLIB(' + %trimr(DRLIB) +
     C                             ') DEV(*SAVF) OBJTYPE(*DTAARA)' +
     C                             ' SAVF(' + %trimr(SavLib) +
     C                              '/' + %trimr(SAVFN) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'RSTOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SR_SaveDTAQ   BEGSR

      * Command to CHKOBJ first (to avoid problem in case of re-run)
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CHKOBJ OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) + ')' +
     C                             ' OBJTYPE(*DTAQ)'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'CHKOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * Command to create save file
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SAVFN =  %trimr(DRFILE)
     C                   eval      SCCMD = 'CRTSAVF FILE(' + %trimr(SavLib) +
     C                             '/' + %trimr(SAVFN) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'CRTSAVF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * Command to save file
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'SAVOBJ OBJ(' + %trimr(DRFILE) +
     C                             ') LIB(' + %trimr(DRLIB) +
     C                             ') DEV(*SAVF) OBJTYPE(*DTAQ) ' +
     C                             'SAVF(' + %trimr(SavLib) +
     C                             '/' + %trimr(SAVFN) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'SAVOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SR_RestoreDTAQBEGSR

      * Command to delete DTAQ before restore - Disaster Recovery
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTDTAQ DTAQ(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'DLTDTAQ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

      * Command to restore file - rebuild
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'RSTOBJ OBJ(' + %trimr(DRFILE) +
     C                             ') SAVLIB(' + %trimr(DRLIB) +
     C                             ') DEV(*SAVF) OBJTYPE(*DTAQ)' +
     C                             ' SAVF(' + %trimr(SavLib) +
     C                              '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPGSCRTD
     C+ (
     C+   SCPRFX
     C+  ,SCFILE
     C+  ,SCLIB
     C+  ,SCSEQ
     C+  ,SCTYPE
     C+  ,SCCMTY
     C+  ,SCCDSH
     C+  ,SCDEPF
     C+  ,SCCDRN
     C+  ,SCCMD
     C+  ,SCOPGM
     C+ )
     C+ Values
     C+ (
     C+   :Prefix
     C+  ,:DRFILE
     C+  ,:DRLIB
     C+  ,:#SEQ
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'RSTOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000056'
     C+ )
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program Exception Error Routine                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   CALL      'QSNDDTAQ'
     C                   PARM      'UP000052'    DtqNam
     C                   PARM      '*LIBL'       DtqLib
     C                   PARM      50            DtqLen
     C                   PARM      'FAIL'        DtqDta

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      Return = '*ERROR'
     C                   RETURN

     C                   ENDSR

      ********************************************************************
