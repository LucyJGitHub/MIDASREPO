     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Write Script for DLTF')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000050 - This program prepare script to delete all         *
      *             dependent files whose dependency is reported in   *
      *             the log file (UPZLOGPD/UPGLOGPD).                 *
      *                                                               *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. MD050666 *CREATE     Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050666 - Adaptive Database Upgrade                         *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D LFArr           S             10A   DIM(9999)
     D Idx             S              5  0
     D LFArrM          S             10A   DIM(9999)
     D Idm             S              5  0
     D XFile           S             10A
     D UPZSCR        E DS                  EXTNAME(UPZSCRTD)
     D UPZOPD        E DS                  EXTNAME(UPZOPDTD)
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
     C+ declare ReadDBRZ cursor for
     C+ select * from UPZOPDTD a
     C+   order by rrn(a)
     C/end-exec
      *
     C/exec SQL
     C+ open ReadDBRZ
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from ReadDBRZ
     C+ into
     C+   :UPZOPD
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

      * Command to CHKOBJ first (to avoid problem in case of re-run)
     C                   eval      Sequence = Sequence + 1
     C                   eval      SCCMD = 'CHKOBJ OBJ(' + %trimr(ORLIB) +
     C                             '/' + %trimr(ORFILE) + ')' +
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
     C+  ,:ORFILE
     C+  ,:ORLIB
     C+  ,:Sequence
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'CHKOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000050'
     C+ )
     C/END-EXEC

      * Command to create save file
     C                   eval      Sequence = Sequence + 1
     C                   eval      SCCMD = 'CRTSAVF FILE(' + %trimr(SavLib) +
     C                             '/' + %trimr(ORFILE) + ')'

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
     C+  ,:ORFILE
     C+  ,:ORLIB
     C+  ,:Sequence
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'CRTSAVF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000050'
     C+ )
     C/END-EXEC

      * Command to save file
     C                   eval      Sequence = Sequence + 1
     C                   eval      SCCMD = 'SAVOBJ OBJ(' + %trimr(ORFILE) +
     C                             ') LIB(' + %trimr(ORLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SavLib) +
     C                              '/' + %trimr(ORFILE) + ')'

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
     C+  ,:ORFILE
     C+  ,:ORLIB
     C+  ,:Sequence
     C+  ,'BU'
     C+  ,'CLP'
     C+  ,'SAVOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000050'
     C+ )
     C/END-EXEC

      * Command to delete file
     C                   eval      Sequence = Sequence + 1
     C                   eval      SCCMD = 'DLTF FILE(' + %trimr(ORLIB) +
     C                             '/' + %trimr(ORFILE) + ')'

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
     C+  ,:ORFILE
     C+  ,:ORLIB
     C+  ,:Sequence
     C+  ,'DD'
     C+  ,'CLP'
     C+  ,'DLTF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000050'
     C+ )
     C/END-EXEC

      * Command to restore file - disaster recovery
     C                   eval      Sequence = Sequence + 1
     C                   eval      SCCMD = 'RSTOBJ OBJ(' + %trimr(ORFILE) +
     C                             ') SAVLIB(' + %trimr(ORLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SavLib) +
     C                              '/' + %trimr(ORFILE) + ')'

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
     C+  ,:ORFILE
     C+  ,:ORLIB
     C+  ,:Sequence
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'RSTOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000050'
     C+ )
     C/END-EXEC

     C                   ENDIF
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from ReadDBRZ
     C+ into
     C+   :UPZOPD
     C/end-exec

     C                   END

     C/exec SQL
     C+ close ReadDBRZ
     C/end-exec

      * Now add DLTF and RSTOBJ for main LF for Disaster Recovery only
     C                   eval      Idm = 1
     C                   DOW       LFArrM(Idm) <> *BLANKS

     C                   eval      XFile = LFArrM(Idm)
     C                   eval      SCCMD = 'DLTF FILE(' + %trimr(ORMLIB) +
     C                             '/' + %trimr(XFile) + ')'

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
     C+  ,:XFile
     C+  ,:ORMLIB
     C+  ,0
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'DLTF'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000050'
     C+ )
     C/END-EXEC

     C                   eval      SCCMD = 'RSTOBJ OBJ(' + %trimr(XFile) +
     C                             ') SAVLIB(' + %trimr(ORMLIB) +
     C                             ') DEV(*SAVF) SAVF(' + %trimr(SavLib) +
     C                              '/' + %trimr(XFile) + ')'

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
     C+  ,:XFile
     C+  ,:ORMLIB
     C+  ,99999
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'RSTOBJ'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000050'
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
