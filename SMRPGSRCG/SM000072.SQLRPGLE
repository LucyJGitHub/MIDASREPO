     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Submitted rename of restored libraries')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000072 - Submitted rename of restored libraries            *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CUP042   *CREATE   Date 15Feb12               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - New method to restore libraries.                    *
      *                                                               *
      *****************************************************************
      *
     D PLibrary        S              8
     D PGlbPfx         S              2
     D PZonPfx         S              2
     D PRstPfx         S              2
     D PBF             S              1
      *
     D NoOfProbs       S              1  0
     D Layer           S              7
     D RnmStatus       S              1
     D Command         S            300
     D CommandLen      S             15  5 INZ(300)
     D SQLString       S            200
     D Quote           S              1    INZ('''')
     D JobData         S             34
     D JobDataLen      S              4B 0 INZ(34)
     D Format          S              8    INZ('JOBI0100')
     D JobName         S             26    INZ('*')
     D IntJobID        S             16
     D Recursive       S              1    INZ(*blank)
      *
     D                 DS
     D RNMOBJCmd               1     55
     D                         1     11    INZ('RNMOBJ OBJ(')
     D  FromLib               12     21
     D                        22     44    INZ(') OBJTYPE(*LIB) NEWOBJ(')
     D  ToLib                 45     54
     D                        55     55    INZ(')')
      *
      /COPY GPCPYSRCG,PSDS
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLibrary
     C                   PARM                    PGlbPfx
     C                   PARM                    PZonPfx
     C                   PARM                    PRstPfx
     C                   PARM                    PBF
      *
      * Populate the RNMOBJ command; if the zone prefix is blank then this is
      *  a global library.
     C                   IF        PZonPfx = *blank
     C                   EVAL      FromLib = PRstPfx + PLibrary
     C                   EVAL      ToLib = PGlbPfx + PLibrary
     C                   EVAL      Layer = '*GLOBAL'
     C                   ELSE
      * For BF schemas the zone uses zzgg prefix.
     C                   IF        PBF = 'Y'
     C                   EVAL      FromLib = PRstPfx + PRstPfx + PLibrary
     C                   EVAL      ToLib = PZonPfx + PGlbPfx + PLibrary
     C                   ELSE
     C                   EVAL      FromLib = PRstPfx + PLibrary
     C                   EVAL      ToLib = PZonPfx + PLibrary
     C                   ENDIF
     C                   EVAL      Layer = '*ZONE'
     C                   ENDIF
      *
      ** Get current job information and set status to 'A' (Active).
     C                   EXSR      RtvJobA
     C                   EVAL      RnmStatus = 'A'
     C                   EXSR      UpdStatus
      *
      ** First check to see if any of the restore options failed.  As this job
      **  should only run if the restores have completed it will be known that
      **  there has been an error if the status is not 'C'.  If there was an
      **  error then flag this record as a failure too and do not process any
      **  records.
     C/exec SQL
     C+ select count(*) into :NoOfProbs
     C+ from SMIMPJW0
     C+ where
     C+     DFSMNU = 'RestoreLibraries'
     C+ and DFLAYR = :Layer
     C+ and DFDEL  = 'N'
     C+ and substr(DFSTS,1,1) <> 'C'
     C/end-exec
      *
     C                   IF        NoOfProbs > 0
     C                   EVAL      RnmStatus = 'F'
     C                   EXSR      UpdStatus
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      Command = RNMOBJCmd
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   IF        PSExcpNo <> *blank
     C                   EVAL      RnmStatus = 'F'
     C                   ELSE
     C                   EVAL      RnmStatus = 'C'
     C                   ENDIF
     C                   EXSR      UpdStatus
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *
     C     RtvJobA       BEGSR
      *
     C                   CALL      'QUSRJOBI'
     C                   PARM                    JobData
     C                   PARM                    JobDataLen
     C                   PARM                    Format
     C                   PARM                    JobName
     C                   PARM                    IntJobID
      *
      ** Update extension table with job information.
     C                   EVAL      SQLString = 'update SMIMPXTD set DFSTS = +
     C                             substr(DFSTS, 1, 1) concat ' +
     C                             Quote + %SUBST(JobData:9:26) + Quote +
     C                             ' where DFSMNU = ' +
     C                             Quote + 'RenameLibrariesBack' + Quote +
     C                             ' and DFLAYR = ' + Quote + Layer + Quote +
     C                             ' and DFNAME = ' + Quote + PLibrary + Quote
      *
     C/exec SQL
     C+ execute immediate :SQLString
     C/end-exec
      *
     C     RtvJobAE      ENDSR
      *
      /EJECT
      *****************************************************************
      *
     C     UpdStatus     BEGSR
      *
     C                   EVAL      SQLString = *blanks
     C                   EVAL      SQLString = 'update SMIMPXTD set DFSTS = ' +
     C                             Quote + RnmStatus + Quote +
     C                             ' concat substr(DFSTS,2,39) where  +
     C                             DFSMNU = ' +
     C                             Quote + 'RenameLibrariesBack' + Quote +
     C                             ' and DFLAYR = ' + Quote + Layer + Quote +
     C                             ' and DFNAME = ' + Quote + PLibrary + Quote
      *
     C/exec SQL
     C+ execute immediate :SQLString
     C/end-exec
      *
     C     UpdStatusE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
