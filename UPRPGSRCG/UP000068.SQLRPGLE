     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Write Script for DLTF Global')           *
/*OVRF*: OVRDBF UPGXRFPD UPXREFPD
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000068 - This program prepare script to delete all         *
      *             dependent files that will be duplicated from      *
      *             Ref system for which a DLTF does not exist yet.   *
      *                                                               *
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

     D LFArr           S             10A   DIM(9999)
     D Idx             S              5  0
     D LFArrM          S             10A   DIM(9999)
     D Idm             S              5  0
     D XFile           S             10A
     D PRLIB           S             10A
     D UPGSCR        E DS                  EXTNAME(UPGSCRTD)
     D UPGORD        E DS                  EXTNAME(UPGORDTD)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Prefix            2
     C                   PARM                    Sequence         15 5
     C                   PARM                    SavLib           10
     C                   PARM                    Return           10

     C/exec SQL
     C+ declare ReadDBRG cursor for
     C+ select * from UPGORDTD a
     C+ where a.orfile
     C+ not in(select scfile from upgscrtd where SCCDSH ='DLTF')
     C+ and a.orfile not in(select drfile from upgdrvtd where DRACTN
     C+ =  'New file will be duplicated')
     C+   order by rrn(a)
     C/end-exec
      *
     C/exec SQL
     C+ open ReadDBRG
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from ReadDBRG
     C+ into
     C+   :UPGORD
     C/end-exec

     C                   eval      Idx = 1
     C                   eval      Idm = 1
     C                   DOW       SQLCODE = 0

      * For LF, store the main file in a separate array that will be used a the end
     C                   If        %subst(ORMLIB:4:1) = 'V'
     C     ORMFIL        LOOKUP    LFArrM                                 99
     C     *IN99         IFEQ      '0'
     C                   eval      LFArrM(Idm) = ORMFIL
     C                   eval      Idm = Idm + 1
     C                   endif
     C                   endif

      * Fill array if not yet in
     C     ORFILE        LOOKUP    LFArr                                  99
     C     *IN99         IFEQ      '0'
     C                   eval      LFArr(Idx) = ORFILE
     C                   eval      Idx = Idx + 1

      * Set PRLIB to Prod Prefix and ORLIB as Ref files are being used
     C                   eval      PRLIB = Prefix + %subst(ORLIB:3:7)

      * Command to CHKOBJ first (to avoid problem in case of re-run)
     C                   eval      Sequence = Sequence + 1
     C                   eval      SCCMD = 'CHKOBJ OBJ(' + %trimr(PRLIB) +
     C                             '/' + %trimr(ORFILE) + ')' +
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
     C+  ,:ORFILE
     C+  ,:PRLIB
     C+  ,:Sequence
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'CHKOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000068'
     C+ )
     C/END-EXEC

      * Command to create save file
     C                   eval      Sequence = Sequence + 1
     C                   eval      SCCMD = 'CRTSAVF FILE(' + %trimr(SavLib) +
     C                             '/' + %trimr(ORFILE) + ')'

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
     C+  ,:ORFILE
     C+  ,:PRLIB
     C+  ,:Sequence
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'CRTSAVF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000068'
     C+ )
     C/END-EXEC

      * Command to save file
     C                   eval      Sequence = Sequence + 1
     C                   eval      SCCMD = 'SAVOBJ OBJ(' + %trimr(ORFILE) +
     C                             ') LIB(' + %trimr(PRLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SavLib) +
     C                              '/' + %trimr(ORFILE) + ')'

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
     C+  ,:ORFILE
     C+  ,:PRLIB
     C+  ,:Sequence
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'SAVOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000068'
     C+ )
     C/END-EXEC

      * Command to delete file
     C                   eval      Sequence = Sequence + 1
     C                   eval      SCCMD = 'DLTF FILE(' + %trimr(PRLIB) +
     C                             '/' + %trimr(ORFILE) + ')'

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
     C+  ,:ORFILE
     C+  ,:PRLIB
     C+  ,:Sequence
     C+  ,'DD'
     C+  ,'CLP'
     C+  ,'DLTF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000068'
     C+ )
     C/END-EXEC

      * Command to restore file - disaster recovery
     C                   eval      Sequence = Sequence + 1
     C                   eval      SCCMD = 'RSTOBJ OBJ(' + %trimr(ORFILE) +
     C                             ') SAVLIB(' + %trimr(PRLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SavLib) +
     C                              '/' + %trimr(ORFILE) + ')'

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
     C+  ,:ORFILE
     C+  ,:PRLIB
     C+  ,:Sequence
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'RSTOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000068'
     C+ )
     C/END-EXEC

     C                   ENDIF
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from ReadDBRG
     C+ into
     C+   :UPGORD
     C/end-exec

     C                   END

     C/exec SQL
     C+ close ReadDBRG
     C/end-exec

      * Now add DLTF and RSTOBJ for main LF for Disaster Recovery only
     C                   eval      Idm = 1
     C                   DOW       LFArrM(Idm) <> *BLANKS

     C                   eval      XFile = LFArrM(Idm)
     C                   eval      SCCMD = 'DLTF FILE(' + %trimr(ORMLIB) +
     C                             '/' + %trimr(XFile) + ')'

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
     C+  ,:XFile
     C+  ,:ORMLIB
     C+  ,0
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'DLTF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000068'
     C+ )
     C/END-EXEC

     C                   eval      SCCMD = 'RSTOBJ OBJ(' + %trimr(XFile) +
     C                             ') SAVLIB(' + %trimr(ORMLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SavLib) +
     C                              '/' + %trimr(XFile) + ')'

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
     C+  ,:XFile
     C+  ,:ORMLIB
     C+  ,99999
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'RSTOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000068'
     C+ )
     C/END-EXEC

     C                   eval      Idm = Idm + 1
     C                   Enddo


     C                   Seton                                        LR
     C                   Return

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

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      Return = '*ERROR'
     C                   RETURN

     C                   ENDSR

      ********************************************************************
