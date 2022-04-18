     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Script for LF rebuild')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000070 - This program generates script for LF rebuild      *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD059777             Date 12Apr22             *
      *  Prev Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059777 - When LF/view is a dependency without being an     *
      *             affected dependent, it is ignored by the script   *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0

      * Array to store Dependency (PF only)
     D PFFileLibA      S             20    DIM(9999)

      * Array to store Dependent  (LF only)
     D LFFileLibA      S             20    DIM(9999)
     D FILEA           S             10    DIM(9999)
      * DS for PF
     D                 DS
     D  PFDS                   1     20
     D  ArrFPF                 1     10
     D  ArrLPF                11     20

      * DS for LF
     D                 DS
     D  LFDS                   1     20
     D  ArrFLF                 1     10
     D  ArrLLF                11     20

     D SavFile         S             10A
     D Add_DR          S              1A
     D Write_Scr       S              1A
     D*SCCMD           S          32000A
     D IxP             S              5  0
     D IxL             S              5  0
     D Idx             S              5  0
     D #SEQ            S             15  5
     D ##MNLIB         S             10A
     D S##MNLIB        S             10A
     D ERROR           S             10A
     D RETURN          S             10A
     D UPDTBL          S             10A
     D UPDFLD          S             10A
     D UPDVAL          S            100A
     D UPDACT          S             10A
     D SQLDynStmt      S           5000A
     D TOLIB           S             10A
     D TOFILE          S             10A
     D OWNR            S             10A
     D AUTL            S             10A
     D UPGXRR        E DS                  EXTNAME(UPGXRRPD)
     D UPGSCR        E DS                  EXTNAME(UPGSCRTD)
     D UPGORD        E DS                  EXTNAME(UPGORDTD)
     D UPGXRI        E DS                  EXTNAME(UPGXRIPD)
     D                                     Prefix(I)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Prefix            2
     C                   PARM                    RefSys            2
     C                   PARM                    ERROR

     C                   eval      AUTL = Prefix + 'DATABASE'
     C                   eval      OWNR = Prefix + 'OWNER'

      * First, delete script records generated for GV lib (by UP000056) for files
      * which are dependent (listed in UPGORDTD)
     C/exec SQL
      + delete from upgscrtd s where exists
      + (select * from upGordtd o where o.orfile = s.scfile)
      + and sctype = '  ' and sccdsh <> 'DLTF'
     C/end-exec

      * Then load in an array all dependents which have a dependency to be ignored
     C/exec SQL
     C+ declare CursorIgn cursor for
     C+ select * from UPGXRIPD
     C/end-exec

     C/exec SQL
     C+ open CursorIgn
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorIgn
     C+ into :UPGXRI
     C/end-exec

     C                   eval      Idx = 0
     C                   DOW       SQLCODE = 0
     C     IPDEPF        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FILEA(Idx) = IPDEPF
     C                   Endif
     C/exec SQL
     C+ fetch next
     C+ from CursorIgn
     C+ into :UPGXRI
     C/end-exec

     C                   Enddo

     C/exec SQL
     C+ close CursorIgn
     C/end-exec

      * Read Ref System file
     C/exec SQL
     C+ declare CursorRdG cursor for
     C+ select *
     C+ from UPGORDTD a
     C+ order by ORMLIB, ORMFIL, ORSEQ
     C/end-exec
      *
     C/exec SQL
     C+ open CursorRdG
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CursorRdG
     C+ into :UPGORD
     C/end-exec


     C                   DOW       SQLCODE = 0

      ** set main library where files will be moved to prior to CRTDUPOBJ
     C                   eval      ##MNLIB = ORMLIB

      ** If new file, clear arrays and DS
     C                   If        ORMFIL <> SavFile

      ** If previous file not blank, output script
     C                   If        SavFile <> *BLANKS
     C                   exsr      SR_Script
     C                   ENDIF

     C                   clear                   PFFileLibA
     C                   clear                   LFFileLibA
     C                   clear                   PFDS
     C                   clear                   LFDS
     C                   eval      IxP = 0
     C                   eval      IxL = 0
     C                   eval      SavFile = ORMFIL
     C                   eval      S##MNLIB = ORMLIB
     C                   endif

      ** if dependency is from VLIB, check that it exists in the dependent                 MD059777
     C                   eval      RcdCount = 0                                            MD059777
     C                   if        ORFLCY <> ORMFIL                                        MD059777
     C                             and %subst(ORLBCY:4:1) = 'V'                            MD059777
     C/exec SQL                                                                            MD059777
     C+ select count(*) into :RcdCount                                                     MD059777
     C+ from UPGORDTD where ORFILE = :ORFLCY                                               MD059777
     C+ and ORMFIL = :ORMFIL                                                               MD059777
     C/end-exec                                                                            MD059777
     C                   endif                                                             MD059777
      ** Dependency if not the main file
     C                   if        ORFLCY <> ORMFIL
     C                             and %subst(ORLBCY:4:1) <> 'V'
     C                             or ORFLCY <> ORMFIL                                     MD059777
     C                             and %subst(ORLBCY:4:1) = 'V'                            MD059777
     C                             and RcdCount = 0                                        MD059777
     C                   eval      ArrFPF = ORFLCY
     C                   eval      ArrLPF = ORLBCY

      ** Check entry does not exist yet
     C     PFDS          LOOKUP    PFFileLibA                             02
     C                   IF        *IN02 = *OFF
     C                   eval      IxP = IxP + 1
     C                   eval      PFFileLibA(IxP) = PFDS
     C                   endif
     C                   endif

      ** Dependent
     C                   eval      ArrFLF = ORFILE
     C                   eval      ArrLLF = ORLIB

      ** Check entry does not exist yet
     C     LFDS          LOOKUP    LFFileLibA                             02
     C                   IF        *IN02 = *OFF
     C                   eval      IxL = IxL + 1
     C                   eval      LFFileLibA(IxL) = LFDS

      ** need to delete entries that may have been generated when UP000051 ran for DVLIB
      ** but keep DLTF command
     C*exec SQL
     C* delete from UPGSCRTD where SCFILE = :ORFILE
     C* and substr(SCLIB,4,1) = 'V' and sctype = '  '
     C* and SCCMD not like 'DLTF%'
     C*end-exec

     C                   endif

     C/exec SQL
     C+ fetch next
     C+ from CursorRdG
     C+ into :UPGORD
     C/end-exec

     C                   ENDDO

      ** If previous file not blank, output script
     C                   If        SavFile <> *BLANKS
     C                   exsr      SR_Script
     C                   ENDIF

      ** Finally, for VLIB, get number of instructions executed by UP000066 and UP000065
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGSCRTD where (SCTYPE = '  '  and SCLIB like '%VLIB%')
     C+ or SCTYPE = 'RB'
     C/end-exec
     C                   eval      UPDVAL = %char(RcdCount)
      * update DV Number of Instructions
     C                   eval      UPDFLD = 'UPGVNI'

     C                   CALL      'UPGUPDWR'
     C                   PARM      '*UPDATE'     UPDACT           10
     C                   PARM                    Prefix
     C                   PARM                    UPDFLD           10
     C                   PARM                    UPDVAL          100
     C                   PARM                    ERROR
     C                   PARM                    RETURN           10

     C                   If        RETURN <> *BLANKS
     C                   exsr      *pssr
     C                   endif

      ** and get number of back up instructions executed by UP000061
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGSCRTD where SCTYPE = 'BU'
     C/end-exec
     C                   eval      UPDVAL = %char(RcdCount)
      * update DV Number of Instructions
     C                   eval      UPDFLD = 'UPBUNI'

     C                   CALL      'UPGUPDWR'
     C                   PARM      '*UPDATE'     UPDACT           10
     C                   PARM                    Prefix
     C                   PARM                    UPDFLD           10
     C                   PARM                    UPDVAL          100
     C                   PARM                    ERROR
     C                   PARM                    RETURN           10

     C                   If        RETURN <> *BLANKS
     C                   exsr      *pssr
     C                   endif

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************

     C     SR_Script     Begsr

     C                   eval      #SEQ = 0

      * 1. MOVE DEPENDENCY INTO DMLIB - BOTH SYSTEMS
     C                   eval      IxP = 1
     C                   DOW       PFFileLibA(IxP) <> *BLANKS
     C                   eval      PFDS = PFFileLibA(IxP)
     C                   If        ArrLPF <> S##MNLIB

      * 1.1 move dependency into DM if not in DM - Ref System
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' +
     C                             %trimr(ArrLPF) + '/' + %trimr(ArrFPF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' +
     C                             %trimr(S##MNLIB) + ')'

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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'RB'
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:ArrFPF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC

      * 1.2 move dependency into DM if not in DM - Prod System
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' + Prefix +
     C                             %trimr(%subst(ArrLPF:3:8)) +
     C                             '/' + %trimr(ArrFPF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' + Prefix +
     C                             %trimr(%subst(S##MNLIB:3:8)) + ')'

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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'RB'
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:ArrFPF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC

     C                   ENDIF
     C                   eval      IxP = IxP + 1
     C                   ENDDO

      * 2. MOVE DEPENDENT INTO DMLIB - REFERENCE SYSTEM
     C                   eval      IxL = 1
     C                   DOW       LFFileLibA(IxL) <> *BLANKS
     C                   eval      LFDS = LFFileLibA(IxL)

      * but beware it is not a LF as there is no need to move from VLIB to VLIB
     C                   If        %trimr(ArrLLF) <>  %trimr(S##MNLIB)
      * 2.1 move dependent into DM - Ref System
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' +
     C                             %trimr(ArrLLF) + '/' + %trimr(ArrFLF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' +
     C                             %trimr(S##MNLIB) + ')'

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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'RB'
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:ArrFLF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC
     C                   Endif

     C                   eval      IxL = IxL + 1
     C                   ENDDO

      * 3. CREATE DUPLICATE OBJ FROM REFERENCE SYSTEM INTO PROD SYSTEM
      * but if CRTDUPOBJ has been done before (already in script), then use MOVOBJ
      * Note: dependency has to be duplicated first, start from IxL and read 'back'
     C**********         eval      IxL = 1
     C**********         DOW       LFFileLibA(IxL) <> *BLANKS
     C                   eval      IxL = IxL - 1
     C                   DOW       IxL > 0
     C                   eval      LFDS = LFFileLibA(IxL)

      * make sure the file to duplicate is not part of the dependent to be IGNORED
     C     ArrFLF        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'

      * 3.1 Duplicate LF from Reference System (now in DMLIB) into Prod System (DMLIB too)
     C                   eval      #SEQ = #SEQ + 1
      * check if CRTDUPOBJ already exists
     C/exec SQL
     C+ select * into :UPGSCR
     C+ from UPGSCRTD where SCDEPF = :ArrFLF and SCCDSH = 'CRTDUPOBJ'
     C/end-exec

     C                   eval      Add_DR = 'N'
     C                   eval      Write_Scr = 'Y'
     C                   If        SQLCODE = 100
     C                   eval      SCCMD = 'CRTDUPOBJ OBJ(' +
     C                             %trimr(ArrFLF) + ') FROMLIB(' +
     C                             %trimr(S##MNLIB) +
     C                             ') OBJTYPE(*FILE) TOLIB(' + Prefix +
     C                             %trimr(%subst(S##MNLIB:3:8)) + ')'
     C                   eval      TOLIB = Prefix + %trimr(%subst(S##MNLIB:3:8))
     C                   eval      TOFILE = %trimr(ArrFLF)
      * add Disaster Recovery step
     C                   eval      Add_DR = 'Y'
     C                   Else
      * but beware it is not a LF as there is no need to move from VLIB to VLIB
     C                   If        %trimr(Prefix + 'GVLIB') =  Prefix +
     C                             %trimr(%subst(S##MNLIB:3:8))
      * do not write script step
     C                   eval      Write_Scr = 'N'
     C                   else
     C                   eval      SCCMD = 'MOVOBJ OBJ(' +
     C                             %trimr(Prefix + 'GVLIB') + '/' +
     C                             %trimr(ArrFLF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' + Prefix +
     C                             %trimr(%subst(S##MNLIB:3:8)) + ')'
     C                   Endif
     C                   Endif

     C                   If        Write_Scr = 'Y'
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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'RB'
     C+  ,'CLP'
     C+  ,'CRTDUPOBJ'
     C+  ,:ArrFLF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC

      * if there is a CRTDUPOBJ, add a DLTF for DR
     C                   if        Add_DR = 'Y'
     C                   eval      #SEQ = #SEQ + 1
     C
     C                   eval      SCCMD = 'DLTF FILE(' +
     C                              %trimr(Prefix + 'GVLIB') +
     C                             '/' + %trimr(ArrFLF) + ')'
     C
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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'DR'
     C+  ,'CLP'
     C+  ,'DLTF'
     C+  ,:ArrFLF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC

      ** Authority **

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'CHGOBJOWN OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(TOFILE) +
     C                             ') OBJTYPE(' + '''' + '*FILE' + '''' +
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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'RB'
     C+  ,'CLP'
     C+  ,'CHGOBJOWN'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(TOFILE) +
     C                             ') OBJTYPE(' + ''''+ '*FILE' + '''' +
     C                             ') AUTL(' + %trimr(AUTL) + ')'

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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'RB'
     C+  ,'CLP'
     C+  ,'GRTOBJAUT'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'GRTOBJAUT OBJ(' + %trimr(TOLIB) +
     C                             '/' + %trimr(TOFILE) +
     C                             ') OBJTYPE(' + '''' + '*FILE' + '''' +
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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'RB'
     C+  ,'CLP'
     C+  ,'GRTOBJAUT'
     C+  ,' '
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC

     C                   ENDIF
     C                   Endif

     C                   else
      * if found in array, report as 'will not be dupliacted'
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'File is not duplicated.'
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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'XX'
     C+  ,'ERR'
     C+  ,'NOT DUPLI'
     C+  ,:ArrFLF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC
     C                   endif
     C**********         eval      IxL = IxL + 1
     C                   eval      IxL = IxL - 1
     C                   ENDDO

      * 4. MOVE DEPENDENT BACK in DV LIB - BOTH SYSTEMS
     C                   eval      IxL = 1
     C                   DOW       LFFileLibA(IxL) <> *BLANKS
     C                   eval      LFDS = LFFileLibA(IxL)

      * 4.1 move dependent from DM into DV - Ref System
      * but beware it is not a LF as there is no need to move from VLIB to VLIB
     C                   If        %trimr(S##MNLIB) <> %trimr(ArrLLF)
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' +
     C                             %trimr(S##MNLIB) + '/' + %trimr(ArrFLF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' +
     C                             %trimr(ArrLLF)+ ')'

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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'RB'
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:ArrFLF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC

      * 4.2 move dependent from DM into DV - Prod System
      * make sure the file to duplicate is not part of the dependent to be IGNORED
     C     ArrFLF        LOOKUP    FILEA                                  99
     C     *IN99         IFEQ      '0'

     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' +
     C                             Prefix  + %trimr(%subst(S##MNLIB:3:8)) +
     C                             '/' + %trimr(ArrFLF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' + Prefix +
     C                             %trimr(%subst(ArrLLF:3:8)) + ')'

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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'RB'
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:ArrFLF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC
     C                   else
      * if found in array, report as 'will not be dupliacted'
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'File is not duplicated.'
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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'XX'
     C+  ,'ERR'
     C+  ,'NOT MOVED'
     C+  ,:ArrFLF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC
     C                   endif
     C                   Endif

     C                   eval      IxL = IxL + 1
     C                   ENDDO

      * 5. MOVE BACK DEPENDENCY TO THEIR ORIGIN LIB - BOTH SYSTEMS
     C                   eval      IxP = 1
     C                   DOW       PFFileLibA(IxP) <> *BLANKS
     C                   eval      PFDS = PFFileLibA(IxP)
     C                   If        ArrLPF <> S##MNLIB

      * 5.1 move dependency from DM if it was moved to DM in 1. - Ref System
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' +
     C                             %trimr(S##MNLIB) + '/' + %trimr(ArrFPF) +
     C                             ') OBJTYPE(*FILE) TOLIB(' +
     C                             %trimr(ArrLPF) + ')'

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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'RB'
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:ArrFPF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC

      * 5.2 move dependency into DM if it was moved to DM in 1. - Prod System
     C                   eval      #SEQ = #SEQ + 1
     C                   eval      SCCMD = 'MOVOBJ OBJ(' + Prefix +
     C                             %trimr(%subst(S##MNLIB:3:8))  +
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
     C+  ,:SavFile
     C+  ,:ORMLIB
     C+  ,:#SEQ
     C+  ,'RB'
     C+  ,'CLP'
     C+  ,'MOVOBJ'
     C+  ,:ArrFPF
     C+  ,' '
     C+  ,:SCCMD
     C+  ,'UP000070'
     C+ )
     C/END-EXEC

     C                   ENDIF
     C                   eval      IxP = IxP + 1
     C                   ENDDO


     C                   Endsr
      *****************************************************************
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
