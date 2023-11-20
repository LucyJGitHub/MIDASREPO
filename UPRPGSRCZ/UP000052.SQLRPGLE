     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Write Script for driver')                *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000052 - This program is very similar to UP000051. It      *
      *             generates the script from one particular file     *
      *             enquired in UP4020.                               *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. MD061962             Date 14Nob23             *
      *  Prev Amend No. MD061992             Date 23Oct23             *
      *                 MD061906             Date 23Sep23             *
      *                 MD061912             Date 27Sep23             *
      *                 CUP047               Date 27Aug23             *
      *                 MD060709             Date 08Nov22             *
      *                 CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061962 - Add CHGPF and CHGLF for database objects changed  *
      *             with SQL                                          *
      *  MD061992 - Allow 3 char prefix for reference libraries       *
      *  MD061906 - Bridge journalling improvement                    *
      *  MD061912 - DTAQ not upgraded with aDBU                       *
      *  CUP047 - Alternative OWNER and AUTL for Bridge upgrade       *
      *  MD060709 - Change in LF dynamic selection is omitted         *
      *             File is not deleted when both DTAARA and file     *
      *             have the same name.                               *
      *             Change in PF key is omitted                       *
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
     D X_OWNR          S             10A                                                      CUP047
     D X_AUTL          S             10A                                                      CUP047
     D REFLIB          S             10A                                                    MD061962
     D OBJSRC          S             10A                                                    MD061962
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

      * DS for DTAQ                                                                         MD061912
     D                 DS                                                                   MD061912
     D  DSOLD                  1     20                                                     MD061912
     D  OLDDTQ                 1     10                                                     MD061912
     D  OLDLIB                11     20                                                     MD061912
     D                 DS                                                                   MD061912
     D  DSNEW                  1     20                                                     MD061912
     D  NEWDTQ                 1     10                                                     MD061912
     D  NEWLIB                11     20                                                     MD061912
                                                                                            MD061912
     D #SEQ            S             15  5
     D UPZDRV        E DS                  EXTNAME(UPZDRVTD)
     D UPZSCR        E DS                  EXTNAME(UPZSCRTD)
     D UPZLOG        E DS                  EXTNAME(UPCLOGPD)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Library          10
     C                   PARM                    Prefix            2
     C**********         PARM                    RefSys            2                        MD061992
     C                   PARM                    RefSys            3                        MD061992
     C                   PARM                    #SEQ
     C                   PARM                    SavLib           10
     C                   PARM                    Return           10
     C                   PARM                    S_File           10

     C                   eval      AUTL = Prefix + 'DATABASE'
     C                   eval      OWNR = Prefix + 'OWNER'
                                                                                              CUP047
      ** Determine if CUP047 is on                                                            CUP047
                                                                                              CUP047
     C                   Call      'AOSARDR0'                                                 CUP047
     C                   Parm      *BLANKS       @RTCD             7                          CUP047
     C                   Parm      '*VERIFY'     @OPTN             7                          CUP047
     C                   Parm      'CUP047'      PSARD             6                          CUP047
                                                                                              CUP047
     C                   If        @RTCD = *Blanks                                            CUP047
      ** If feature is on, check system values                                                CUP047
     C/exec SQL                                                                               CUP047
     C+ select GIVAL into :X_AUTL from SDSVLXTD                                               CUP047
     C+ where GISVAL = 'AlternativeBrgAUTLDB'                                                 CUP047
     C/end-exec                                                                               CUP047
     C                   If        SQLCODE = 0 and                                            CUP047
     C                             X_AUTL <> *blanks                                          CUP047
     C                   eval      AUTL = X_AUTL                                              CUP047
     C                   Endif                                                                CUP047
                                                                                              CUP047
     C/exec SQL                                                                               CUP047
     C+ select GIVAL into :X_OWNR from SDSVLXTD                                               CUP047
     C+ where GISVAL = 'AlternativeBrgOWNER'                                                  CUP047
     C/end-exec                                                                               CUP047
     C                   If        SQLCODE = 0 and                                            CUP047
     C                             X_OWNR <> *blanks                                          CUP047
     C                   eval      OWNR = X_OWNR                                              CUP047
     C                   Endif                                                                CUP047
                                                                                              CUP047
     C                   Endif                                                                CUP047
                                                                                              CUP047
      * remove records from script file if any
     C/exec SQL
     C+ delete UPZSCRTD
     C+   where SCLIB = :Library and SCFILE = :S_File
     C/end-exec
     C                   If        SQLCODE <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   EVAL      Return = '*ERROR'
     C                   RETURN
     C                   ENDIF

     C/EXEC SQL
     C+ SELECT *
     C+ into :UPZDRV
     C+ from UPZDRVTD
     C+ where DRLIB = :Library and DRFILE = :S_File
     C/END-EXEC

     C                   If        SQLCODE = 0

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

     C                   CALL      'UP000053'
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

      * Add script for updating the source library                                          MD061962
     C                   exsr      SR_UpdSrcLib                                             MD061962
                                                                                            MD061962

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
     C**********                   Prefix + %trimr(%subst(#Lib2:3:8)) + ')'                 MD061992
     C                             Prefix + %trimr(%subst(DRLIB:3:8)) + ')'                 MD061992

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CLRPFM FILE(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*FILE' + '''' +
     C                             ') AUTL(' +
     C                             %trimr(AUTL) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE('+ '''' + '*FILE' + '''' +
     C                             ') USER(*PUBLIC) AUT(*AUTL)'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * Adding journalling instruction                                                      MD061906
     C                   eval      #SEQ = #SEQ + 1                                          MD061906
     C                   eval      SCCMD = 'STRJRNPF FILE(' + %trimr(DRLIB) +               MD061906
     C                             '/' + %trimr(DRFILE) +                                   MD061906
     C                             ') JRN(ICJRN) IMAGES(*BOTH) OMTJRNE(*OPNCLO)'            MD061906
                                                                                            MD061906
     C/EXEC SQL                                                                             MD061906
     C+ insert into UPZSCRTD                                                                MD061906
     C+ (                                                                                   MD061906
     C+   SCPRFX                                                                            MD061906
     C+  ,SCFILE                                                                            MD061906
     C+  ,SCLIB                                                                             MD061906
     C+  ,SCSEQ                                                                             MD061906
     C+  ,SCTYPE                                                                            MD061906
     C+  ,SCCMTY                                                                            MD061906
     C+  ,SCCDSH                                                                            MD061906
     C+  ,SCDEPF                                                                            MD061906
     C+  ,SCCDRN                                                                            MD061906
     C+  ,SCCMD                                                                             MD061906
     C+  ,SCOPGM                                                                            MD061906
     C+ )                                                                                   MD061906
     C+ Values                                                                              MD061906
     C+ (                                                                                   MD061906
     C+   :Prefix                                                                           MD061906
     C+  ,:DRFILE                                                                           MD061906
     C+  ,:DRLIB                                                                            MD061906
     C+  ,:#SEQ                                                                             MD061906
     C+  ,'  '                                                                              MD061906
     C+  ,'CLP'                                                                             MD061906
     C+  ,'STRJRNPF'                                                                        MD061906
     C+  ,' '                                                                               MD061906
     C+  ,' '                                                                               MD061906
     C+  ,:SCCMD                                                                            MD061906
     C+  ,'UP000051'                                                                        MD061906
     C+ )                                                                                   MD061906
     C/END-EXEC                                                                             MD061906
                                                                                            MD061906
     C                   exsr      SR_Delete


      ******************* F I L E  W I L L  B E  D U P L I C A
     C                   WHEN      DRACTN = 'Existing file will be duplicated'

     C                   exsr      SR_Save

      * if file is PF or table, it needs to be copied first
     C                   If        %SUBST(DRLIB:4:1) <> 'V'
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CALL PGM(UPC004001) PARM(' +
     C                             '''' + '*ZONE' + '''' + ' ' + '''' + DRFILE +
     C                             '''' + ' ' + '''' + DRLIB + '''' + ' ' +
     C                             '''' + '*COPY' + '''' + ' ' + '''' +
     C                             '''' + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   ENDIF

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTF FILE(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C**********                   Prefix + %trimr(%subst(MovLib:3:8)) + ')'                MD061992
     C                             Prefix + %trimr(%subst(MovLib:4:7)) + ')'                MD061992
     C**********         eval      TOLIB =  Prefix + %trimr(%subst(MovLib:3:8))             MD061992
     C                   eval      TOLIB =  Prefix + %trimr(%subst(MovLib:4:7))             MD061992
     C                   else
     C                   eval      SCCMD = 'CRTDUPOBJ OBJ(' +
     C                             %trimr(DRFILE) + ') FROMLIB(' +
     C                             %trimr(#Lib2) + ') OBJTYPE(*FILE) TOLIB(' +
     C                             %trimr(DRLIB) +  ')'
     C                   eval      TOLIB = DRLIB
     C                   Endif

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*FILE' + '''' +
     C                             ') AUTL(' +
     C                             %trimr(AUTL) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE('+ '''' + '*FILE' + '''' +
     C                             ') USER(*PUBLIC) AUT(*AUTL)'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * Adding journalling instruction for PF only                                          MD061906
     C                   If        %SUBST(DRLIB:4:1) <> 'V'                                 MD061906
     C                   eval      #SEQ = #SEQ + 1                                          MD061906
     C                   eval      SCCMD = 'STRJRNPF FILE(' + %trimr(DRLIB) +               MD061906
     C                             '/' + %trimr(DRFILE) +                                   MD061906
     C                             ') JRN(ICJRN) IMAGES(*BOTH) OMTJRNE(*OPNCLO)'            MD061906
                                                                                            MD061906
     C/EXEC SQL                                                                             MD061906
     C+ insert into UPZSCRTD                                                                MD061906
     C+ (                                                                                   MD061906
     C+   SCPRFX                                                                            MD061906
     C+  ,SCFILE                                                                            MD061906
     C+  ,SCLIB                                                                             MD061906
     C+  ,SCSEQ                                                                             MD061906
     C+  ,SCTYPE                                                                            MD061906
     C+  ,SCCMTY                                                                            MD061906
     C+  ,SCCDSH                                                                            MD061906
     C+  ,SCDEPF                                                                            MD061906
     C+  ,SCCDRN                                                                            MD061906
     C+  ,SCCMD                                                                             MD061906
     C+  ,SCOPGM                                                                            MD061906
     C+ )                                                                                   MD061906
     C+ Values                                                                              MD061906
     C+ (                                                                                   MD061906
     C+   :Prefix                                                                           MD061906
     C+  ,:DRFILE                                                                           MD061906
     C+  ,:DRLIB                                                                            MD061906
     C+  ,:#SEQ                                                                             MD061906
     C+  ,'  '                                                                              MD061906
     C+  ,'CLP'                                                                             MD061906
     C+  ,'STRJRNPF'                                                                        MD061906
     C+  ,' '                                                                               MD061906
     C+  ,' '                                                                               MD061906
     C+  ,:SCCMD                                                                            MD061906
     C+  ,'UP000051'                                                                        MD061906
     C+ )                                                                                   MD061906
     C/END-EXEC                                                                             MD061906
     C                   ENDIF                                                              MD061906
                                                                                            MD061906
      * LF has to be moved back and its dependency library have now to be moved back
     C                   If        %SUBST(DRLIB:4:1) = 'V'
     C                   exsr      SR_MOVEBack
     C                   Endif

      * if file is PF or table, it needs to be copied back
     C                   If        %SUBST(DRLIB:4:1) <> 'V'
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CALL PGM(UPC004001) PARM(' +
     C                             '''' + '*ZONE' + '''' + ' ' + '''' + DRFILE +
     C                             '''' + ' ' + '''' + DRLIB + '''' + ' ' +
     C                             '''' + '*COPYBACK' + '''' + ' ' + '''' +
     C                             '''' + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC
     C                   Endif

     C                   exsr      SR_Restore


      *******************
     C                   WHEN      DRACTN = 'New file will be duplicated'

      * LF has to be moved to its dependency library first before CRTDUPOBJ
     C                   exsr      SR_MOVE

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      #Lib2 = RefSys + %SUBST(DRLIB:3:8)
     C                   eval      SCCMD = 'CRTDUPOBJ OBJ(' +
     C                             %trimr(DRFILE) + ') FROMLIB(' +
     C                             %trimr(MovLib) + ') OBJTYPE(*FILE) TOLIB(' +
     C**********                   Prefix + %trimr(%subst(MovLib:3:8)) + ')'                MD061992
     C                             Prefix + %trimr(%subst(MovLib:4:7)) + ')'                MD061992
     C**********         eval      TOLIB = Prefix + %trimr(%subst(MovLib:3:8))              MD061992
     C                   eval      TOLIB = Prefix + %trimr(%subst(MovLib:4:7))              MD061992

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*FILE' + '''' +
     C                             ') AUTL(' +
     C                             %trimr(AUTL) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE('+ '''' + '*FILE' + '''' +
     C                             ') USER(*PUBLIC) AUT(*AUTL)'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * LF has to be moved back and its dependency library have now to be moved back
     C                   exsr      SR_MOVEBack

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTF FILE(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * Add script for changed file
     C                   If        DRFLCH = 'Y'
     C                   exsr      SR_FileChange
     C                   Endif

      ******************* F I L E  W I L L  B E  D E L E T E D
     C                   WHEN      DRACTN = 'File will be deleted'

     C                   exsr      SR_Save

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTF FILE(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   exsr      SR_Restore


      ******************* F I L E  W I L L  B E  C H A N G E D
     C                   WHEN      DRACTN = 'File will be changed'

     C                   exsr      SR_FileChange

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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   endif

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CRTDUPOBJ OBJ(' +
     C                             %trimr(DRFILE) + ') FROMLIB(' + RefSys +
     C                             %trimr(%subst(DRLIB:3:8)) + ') +
     C                             OBJTYPE(*DTAARA) TOLIB(' + DRLIB + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*DTAARA' + '''' +
     C                             ') AUTL(' +
     C                             %trimr(AUTL) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE('+ '''' + '*DTAARA' + '''' +
     C                             ') USER(*PUBLIC) AUT(*AUTL)'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * Adding journalling instruction                                                      MD061906
     C                   eval      #SEQ = #SEQ + 1                                          MD061906
     C                   eval      SCCMD = 'STRJRNOBJ OBJ(' + %trimr(DRLIB) +               MD061906
     C                             '/' + %trimr(DRFILE) +                                   MD061906
     C                             ') OBJTYPE(*DTAARA) JRN(ICJRN) IMAGES(*BOTH)'            MD061906
                                                                                            MD061906
     C/EXEC SQL                                                                             MD061906
     C+ insert into UPZSCRTD                                                                MD061906
     C+ (                                                                                   MD061906
     C+   SCPRFX                                                                            MD061906
     C+  ,SCFILE                                                                            MD061906
     C+  ,SCLIB                                                                             MD061906
     C+  ,SCSEQ                                                                             MD061906
     C+  ,SCTYPE                                                                            MD061906
     C+  ,SCCMTY                                                                            MD061906
     C+  ,SCCDSH                                                                            MD061906
     C+  ,SCDEPF                                                                            MD061906
     C+  ,SCCDRN                                                                            MD061906
     C+  ,SCCMD                                                                             MD061906
     C+  ,SCOPGM                                                                            MD061906
     C+ )                                                                                   MD061906
     C+ Values                                                                              MD061906
     C+ (                                                                                   MD061906
     C+   :Prefix                                                                           MD061906
     C+  ,:DRFILE                                                                           MD061906
     C+  ,:DRLIB                                                                            MD061906
     C+  ,:#SEQ                                                                             MD061906
     C+  ,'  '                                                                              MD061906
     C+  ,'CLP'                                                                             MD061906
     C+  ,'STRJRNPF'                                                                        MD061906
     C+  ,' '                                                                               MD061906
     C+  ,' '                                                                               MD061906
     C+  ,:SCCMD                                                                            MD061906
     C+  ,'UP000051'                                                                        MD061906
     C+ )                                                                                   MD061906
     C/END-EXEC                                                                             MD061906
                                                                                            MD061906
     C                   If        DRACTN = 'Existing DTAARA will be' +
     C                             ' duplicated'
     C                   exsr      SR_RestoreDTAA
     C                   endif

      ******************* D T A A R A  W I L L  B E  D E L E T E D                          MD060709
     C                   WHEN      DRACTN = 'DTAARA will be deleted'                        MD060709
                                                                                            MD060709
     C                   exsr      SR_SaveDTAA                                              MD060709
                                                                                            MD060709
     C                   eval      #SEQ = #SEQ + 1                                          MD060709
     C                   eval      SCCMD = 'DLTDTAARA DTAARA(' +                            MD060709
     C                             %trimr(DRLIB) +                                          MD060709
     C                             '/' + %trimr(DRFILE) + ')'                               MD060709
                                                                                            MD060709
     C/EXEC SQL                                                                             MD060709
     C+ insert into UPZSCRTD                                                                MD060709
     C+ (                                                                                   MD060709
     C+   SCPRFX                                                                            MD060709
     C+  ,SCFILE                                                                            MD060709
     C+  ,SCLIB                                                                             MD060709
     C+  ,SCSEQ                                                                             MD060709
     C+  ,SCTYPE                                                                            MD060709
     C+  ,SCCMTY                                                                            MD060709
     C+  ,SCCDSH                                                                            MD060709
     C+  ,SCDEPF                                                                            MD060709
     C+  ,SCCDRN                                                                            MD060709
     C+  ,SCCMD                                                                             MD060709
     C+  ,SCOPGM                                                                            MD060709
     C+ )                                                                                   MD060709
     C+ Values                                                                              MD060709
     C+ (                                                                                   MD060709
     C+   :Prefix                                                                           MD060709
     C+  ,:DRFILE                                                                           MD060709
     C+  ,:DRLIB                                                                            MD060709
     C+  ,:#SEQ                                                                             MD060709
     C+  ,'  '                                                                              MD060709
     C+  ,'CLP'                                                                             MD060709
     C+  ,'DLTF'                                                                            MD060709
     C+  ,' '                                                                               MD060709
     C+  ,' '                                                                               MD060709
     C+  ,:SCCMD                                                                            MD060709
     C+  ,'UP000051'                                                                        MD060709
     C+ )                                                                                   MD060709
     C/END-EXEC                                                                             MD060709
                                                                                            MD060709
     C                   exsr      SR_RestoreDTAA                                           MD060709
                                                                                            MD060709
                                                                                            MD060709
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   endif

     C                   eval      #SEQ = #SEQ + 1
      ** DTAQ cannot be duplicated with CRTDUPOBJ                                           MD061912
     C**********         eval      SCCMD = 'CRTDUPOBJ OBJ(' +                               MD061912
     C**********                   %trimr(DRFILE) + ') FROMLIB(' + RefSys +                 MD061912
     C**********                   %trimr(%subst(DRLIB:3:8)) + ') +                         MD061912
     C**********                   OBJTYPE(*DTAQ) TOLIB(' + DRLIB + ')'                     MD061912
      ** instead call new program                                                           MD061912
     C                   eval      OLDDTQ = DRFILE                                          MD061912
     C                   eval      OLDLIB = RefSys + %trimr(%subst(DRLIB:3:8))              MD061912
     C                   eval      NEWDTQ = DRFILE                                          MD061912
     C                   eval      NEWLIB = DRLIB                                           MD061912
     C                   eval      SCCMD = 'CALL PGM(UPC000084) PARM(' +                    MD061912
     C                             '''' + DSOLD  + '''' + ' ' + '''' +                      MD061912
     C                             DSNEW + '''' + ' ' + ''''  + '''' + ')'                  MD061912

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C*+**,'CRTDUPOBJ'                                                                      MD061912
     C+  ,'CALL'                                                                            MD061912
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE(' +'''' + '*DTAQ' + '''' +
     C                             ') AUTL(' +
     C                             %trimr(AUTL) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(DRLIB) +
     C                             '/' + %trimr(DRFILE) +
     C                             ') OBJTYPE('+ '''' + '*DTAQ' + '''' +
     C                             ') USER(*PUBLIC) AUT(*AUTL)'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * Adding journalling instruction                                                      MD061906
     C                   eval      #SEQ = #SEQ + 1                                          MD061906
     C                   eval      SCCMD = 'STRJRNOBJ OBJ(' + %trimr(DRLIB) +               MD061906
     C                             '/' + %trimr(DRFILE) +                                   MD061906
     C                             ') OBJTYPE(*DTAQ) JRN(ICJRN)'                            MD061906
                                                                                            MD061906
     C/EXEC SQL                                                                             MD061906
     C+ insert into UPZSCRTD                                                                MD061906
     C+ (                                                                                   MD061906
     C+   SCPRFX                                                                            MD061906
     C+  ,SCFILE                                                                            MD061906
     C+  ,SCLIB                                                                             MD061906
     C+  ,SCSEQ                                                                             MD061906
     C+  ,SCTYPE                                                                            MD061906
     C+  ,SCCMTY                                                                            MD061906
     C+  ,SCCDSH                                                                            MD061906
     C+  ,SCDEPF                                                                            MD061906
     C+  ,SCCDRN                                                                            MD061906
     C+  ,SCCMD                                                                             MD061906
     C+  ,SCOPGM                                                                            MD061906
     C+ )                                                                                   MD061906
     C+ Values                                                                              MD061906
     C+ (                                                                                   MD061906
     C+   :Prefix                                                                           MD061906
     C+  ,:DRFILE                                                                           MD061906
     C+  ,:DRLIB                                                                            MD061906
     C+  ,:#SEQ                                                                             MD061906
     C+  ,'  '                                                                              MD061906
     C+  ,'CLP'                                                                             MD061906
     C+  ,'STRJRNPF'                                                                        MD061906
     C+  ,' '                                                                               MD061906
     C+  ,' '                                                                               MD061906
     C+  ,:SCCMD                                                                            MD061906
     C+  ,'UP000051'                                                                        MD061906
     C+ )                                                                                   MD061906
     C/END-EXEC                                                                             MD061906
                                                                                            MD061906
     C                   If        DRACTN = 'Existing DTAQ will be' +
     C                             ' duplicated'
     C                   exsr      SR_RestoreDTAQ
     C                   endif

      ******************* I G N O R E
     C                   WHEN      DRACTN = 'IGNORE'

     C                   OTHER
     C                   DUMP

     C                   ENDSL

     C                   END

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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * 2.2 move dependency  - Prod System
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' + Prefix +
     C**********                   %trimr(%subst(ArrLPF:3:8)) +                             MD061992
     C                             %trimr(%subst(ArrLPF:4:7)) +                             MD061992
     C                             '/' + %trimr(ArrFPF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' + Prefix +
     C**********                   %trimr(%subst(MovLib:3:8)) + ')'                         MD061992
     C                             %trimr(%subst(MovLib:4:7)) + ')'                         MD061992

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * 2. move back LF - Prod system
      *
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' + Prefix +
     C**********                   %trimr(%subst(MovLib:3:8)) + '/' +                       MD061992
     C                             %trimr(%subst(MovLib:4:7)) + '/' +                       MD061992
     C                             %trimr(DRFILE) +
     C                             ') OBJTYPE(*FILE) TOLIB(' +
     C                             %trimr(DRLIB) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * 3.2 move dependency  - Prod System
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' + Prefix +
     C**********                   %trimr(%subst(MovLib:3:8)) +                             MD061992
     C                             %trimr(%subst(MovLib:4:7)) +                             MD061992
     C                             '/' + %trimr(ArrFPF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' + Prefix +
     C**********                   %trimr(%subst(ArrLPF:3:8)) + ')'                         MD061992
     C                             %trimr(%subst(ArrLPF:4:7)) + ')'                         MD061992

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * Command to create save file
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CRTSAVF FILE(' + %trimr(SavLib) +
     C                             '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * Command to save file
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'SAVOBJ OBJ(' + %trimr(DRFILE) +
     C                             ') LIB(' + %trimr(DRLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SavLib) +
     C                              '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * Command to restore file - rebuild
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'RSTOBJ OBJ(' + %trimr(DRFILE) +
     C                             ') SAVLIB(' + %trimr(DRLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SavLib) +
     C                              '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SR_FileChange BEGSR

      * Command to change file
      * Retrieve type of change from UPZLOGPD
     C/exec SQL
     C+ declare LogZ cursor for
     C+ select * from UPZLOGPD
     C+ where WFILE = :DRFILE and WFLDA like 'AT%'
     C/end-exec

     C/exec SQL
     C+ open LogZ
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from LogZ
     C+ into :UPZLOG
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC
     C                   endif

     C                   ENDSL

     C/exec SQL
     C+ fetch next
     C+ from LogZ
     C+ into :UPZLOG
     C/end-exec

     C                   Enddo

     C/exec SQL
     C+ close LogZ
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * Command to create save file
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SAVFN =  %trimr(DRFILE) + '@'
     C                   eval      SCCMD = 'CRTSAVF FILE(' + %trimr(SavLib) +
     C                             '/' + %trimr(SAVFN) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

      * Command to create save file
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SAVFN =  %trimr(DRFILE)
     C                   eval      SCCMD = 'CRTSAVF FILE(' + %trimr(SavLib) +
     C                             '/' + %trimr(SAVFN) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SR_RestoreDTAQBEGSR

      * Command to delete DTAQ before restore - Disaster Recovery
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'DLTDTAQ DTAQ(' + %trimr(DRLIB) +
     C                              '/' + %trimr(DRFILE) + ')'

     C/EXEC SQL
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
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
     C+ insert into UPZSCRTD
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
     C+  ,'UP000051'
     C+ )
     C/END-EXEC

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                MD061962
      *****************************************************************                     MD061962
      *                                                               *                     MD061962
      * SR_UpdSrcLib - geneate command to update the source library   *                     MD061962
      *                                                               *                     MD061962
      * Calls: None                                                   *                     MD061962
      *                                                               *                     MD061962
      *****************************************************************                     MD061962
      *****************************************************************                     MD061962
     C     SR_UpdSrcLib  BEGSR                                                              MD061962
                                                                                            MD061962
      * Retrieve source library                                                             MD061962
      * set the library name to the reference system                                        MD061962
     C                   eval      REFLIB = RefSys + %SUBST(DRLIB:3:8)                      MD061962
                                                                                            MD061962
     C                   CALL      'UPC4016'                                                MD061962
     C                   PARM                    REFLIB                                     MD061962
     C                   PARM                    DRFILE                                     MD061962
     C                   PARM      *BLANKS       OBJSRC                                     MD061962
                                                                                            MD061962
     C                   eval      #SEQ = #SEQ + 1                                          MD061962
     C                   eval      SCCMD = 'CHGOBJ OBJ(' + %trimr(DRLIB) +                  MD061962
     C                              '/' + %trimr(DRFILE) + ')' +                            MD061962
     C                             ' OBJTYP(*FILE) NEWLIB(' + OBJSRC + ')'                  MD061962
                                                                                            MD061962
     C/EXEC SQL                                                                             MD061962
     C+ insert into UPGSCRTD                                                                MD061962
     C+ (                                                                                   MD061962
     C+   SCPRFX                                                                            MD061962
     C+  ,SCFILE                                                                            MD061962
     C+  ,SCLIB                                                                             MD061962
     C+  ,SCSEQ                                                                             MD061962
     C+  ,SCTYPE                                                                            MD061962
     C+  ,SCCMTY                                                                            MD061962
     C+  ,SCCDSH                                                                            MD061962
     C+  ,SCDEPF                                                                            MD061962
     C+  ,SCCDRN                                                                            MD061962
     C+  ,SCCMD                                                                             MD061962
     C+  ,SCOPGM                                                                            MD061962
     C+ )                                                                                   MD061962
     C+ Values                                                                              MD061962
     C+ (                                                                                   MD061962
     C+   :Prefix                                                                           MD061962
     C+  ,:DRFILE                                                                           MD061962
     C+  ,:DRLIB                                                                            MD061962
     C+  ,:#SEQ                                                                             MD061962
     C+  ,'  '                                                                              MD061962
     C+  ,'CLP'                                                                             MD061962
     C+  ,'CHGOBJ'                                                                          MD061962
     C+  ,' '                                                                               MD061962
     C+  ,' '                                                                               MD061962
     C+  ,:SCCMD                                                                            MD061962
     C+  ,'UP000056'                                                                        MD061962
     C+ )                                                                                   MD061962
     C/END-EXEC                                                                             MD061962
                                                                                            MD061962
     C                   ENDSR                                                              MD061962
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

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      Return = '*ERROR'
     C                   RETURN

     C                   ENDSR

      ********************************************************************
