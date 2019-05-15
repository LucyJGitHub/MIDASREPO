     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas CB Generic component RPG processing')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business processing                         *
      *                                                               *
      *  CB022001 - Generic component RPG processing                  *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD041010            Date 18Sep16              *
      *                 MD024652            Date 07May14              *
      *                 MD024006A *CREATE   Date 08Jan14              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD041010 - Component CBC022001 00686 failed during COB       *
      *  MD024652 - Missing members of REHIS* files.                  *
      *  MD024006A - Rewrite of generic component.                    *
      *                                                               *
      *****************************************************************
      *
     D PMode           S              4
     D PFile           S             10
     D PMember         S             10
     D PNoOfMbrs       S              5  0
     D PADDLFM         S           1000
      *
     D Complete        S              1    INZ('N')
     D First           S              1    INZ('Y')
     D Share           S              4
     D SaveName        S             10
     D SavePF          S             10
     D SavePFMbr       S             10
     D NoOfRecs        S              2  0
     D DoLoop          S              5  0
     D Quote           S              1    INZ('''')
     D Recursive       S              1
      *
     D MBR           E DS                  EXTNAME(UPFDMBTPD)
     D                                     PREFIX(X)
     D FMBR          E DS                  EXTNAME(SCFMBRTD)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PFile
     C                   PARM                    PMember
     C                   PARM                    PNoOfMbrs
     C                   PARM                    PADDLFM
      *                                                                                     MD024652
     C                   EVAL      Complete = 'N'                                           MD024652
      *
     C                   SELECT
     C                   WHEN      PMode = '*ACC'
     C                   EXSR      AccessPath
      *
     C                   WHEN      PMode = '*ATR'
     C                   EXSR      Attributes
      *
     C                   WHEN      PMode = '*BLD'
     C                   IF        PMember = '*ALL'
     C                   EXSR      BuildAll
     C                   ELSE
     C                   EXSR      Build
     C                   ENDIF
      *
     C                   WHEN      PMode = '*DBR'
     C                   EXSR      DBRelations
      *
     C                   WHEN      PMode = '*DEL'
     C                   EXSR      Delete
      *
     C                   WHEN      PMode = '*WRT'
     C                   IF        PMember = '*ALL'
     C                   EXSR      WriteAll
     C**********         EXSR      UpdateAll                                                MD041010
     C                   ELSE
     C                   EXSR      Write
     C                   EXSR      Update
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   RETURN
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *    AccessPath - Write changed access path to file                *
      *                                                                  *
      ********************************************************************
     C     AccessPath    BEGSR
      *
      ** Check if record exists on file already.
      *
     C/exec SQL
     C+ select count(*)
     C+ into :NoOfRecs
     C+ from SCACCPTD
     C+ where FNAME = :PFile
     C/end-exec
      *
      ** If there is no record already then write one.
      *
     C                   IF        NoOfRecs = 0
     C/exec SQL
     C+ insert into SCACCPTD
     C+ (
     C+   FNAME
     C+ , MAINT
     C+ )
     C+ values
     C+ (
     C+   :PFile
     C+ , :PMember
     C+ )
     C/end-exec

     C                   ENDIF

     C     AccessPathE   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *    Attributes - Delete all records from list of members          *
      *                                                                  *
      ********************************************************************
     C     Attributes    BEGSR

      ** Delete all records from list of members where the file is an SQL type.

     C/exec SQL
     C+ delete from MBR022001T m
     C+ where exists
     C+ (
     C+ select * from ATR022001T a where
     C+ a.ATFILE = m.MBFILE
     C+ and a.ATSQLT <> '0'
     C+ )
     C/end-exec

      ** Delete all records from list of members where the member is blank.

     C/exec SQL
     C+ delete from MBR022001T
     C+ where
     C+ MBNAME = ' '
     C/end-exec

     C     AttributesE   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *    Build - Build string for ADDLFM                               *
      *                                                                  *
      ********************************************************************
     C     Build         BEGSR

     C/exec SQL
     C+ declare Build cursor for
     C+ select * from SCFMBRTD
     C+ where MBFILE = :PFile
     C+ and MBNAME = :PMember
     C+ and MBPERM = 'N'
     C+ order by
     C+   MBFILE
     C+ , MBNAME
     C/end-exec

     C/exec SQL
     C+ open Build
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Build
     C+ into :FMBR
     C/end-exec

      ** Do nothing if there are no records found.

     C                   IF        SQLCODE = 0

     C                   EVAL      PADDLFM = 'ADDLFM FILE(' + PFile
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) + ')'

      ** If there is only one member then DTAAMBRS(*ALL) can be used.

     C                   IF        MBNSCM = 0
     C                   EVAL      PNoOfMbrs = 1
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ' MBR(' + MBNAME
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ')'
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ' DTAMBRS((*ALL)'
     C                   EVAL      Complete = 'Y'
     C                   ELSE
     C                   EVAL      DoLoop = MBNSCM - 1
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ' MBR(' + MBNAME
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ') DTAMBRS('
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             '(' + MBBOF
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ' (' + MBBOM
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             '))'
      *
     C                   DO        DoLoop

     C/exec SQL
     C+ fetch next
     C+ from Build
     C+ into :FMBR
     C/end-exec

     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             '(' + MBBOF
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ' (' + MBBOM
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             '))'

     C                   ENDDO
     C                   ENDIF

     C/exec SQL
     C+ close Build
     C/end-exec

     C                   IF        MBRSHR = 'N'
     C                   EVAL      Share = '*NO'
     C                   ELSE
     C                   EVAL      Share = '*YES'
     C                   ENDIF
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ') TEXT(' + Quote + MBMTXT
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             Quote + ') SHARE(' + Share + ')'

     C                   ELSE
     C                   EVAL      PADDLFM = *blanks
     C                   ENDIF

     C     BuildE        ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *    BuildAll - Build string for ADDLFM                            *
      *                                                                  *
      ********************************************************************
     C     BuildAll      BEGSR

     C/exec SQL
     C+ declare BuildAll cursor for
     C+ select * from SCFMBRTD
     C+ where MBFILE = :PFile
     C+ and MBPERM = 'N'
     C+ order by
     C+   MBFILE
     C+ , MBNAME
     C/end-exec

     C/exec SQL
     C+ open BuildAll
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from BuildAll
     C+ into :FMBR
     C/end-exec

      ** Do nothing if there are no records found.

     C                   IF        SQLCODE = 0

     C                   EVAL      PADDLFM = 'ADDLFM FILE(' + PFile
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) + ')'

      ** If there is only one member then DTAAMBRS(*ALL) can be used.

     C                   IF        MBNSCM = 0
     C                   EVAL      PNoOfMbrs = 1
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ' MBR(' + MBNAME
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ')'
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ' DTAMBRS((*ALL)'
     C                   EVAL      Complete = 'Y'
     C                   ELSE
     C                   EVAL      PNoOfMbrs = MBNOMB
     C                   EVAL      DoLoop = MBNSCM - 1
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ' MBR(' + MBNAME
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ') DTAMBRS('
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             '(' + MBBOF
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ' (' + MBBOM
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             '))'

     C                   DO        DoLoop
     C/exec SQL
     C+ fetch next
     C+ from BuildAll
     C+ into :FMBR
     C/end-exec

     C     SQL_00081     IFEQ      '1'                                                      MD041010
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             '(' + MBBOF
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ' (' + MBBOM
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             '))'
     C                   ENDIF                                                              MD041010
      *
     C                   ENDDO
     C                   ENDIF

     C/exec SQL
     C+ close BuildAll
     C/end-exec

      ** If *ALL members was specified then return individual member name to
      ** main program so that correct records can be deleted later.

     C                   EVAL      PMember = MBNAME
     C                   IF        MBRSHR = 'N'
     C                   EVAL      Share = '*NO'
     C                   ELSE
     C                   EVAL      Share = '*YES'
     C                   ENDIF
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             ') TEXT(' + Quote + MBMTXT
     C                   EVAL      PADDLFM = %TRIMR(PADDLFM) +
     C                             Quote + ') SHARE(' + Share + ')'

     C                   ELSE
     C                   EVAL      PADDLFM = *blanks
     C                   ENDIF

     C     BuildAllE     ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *    DBRelations - Delete duplicate logical file records           *
      *                                                                  *
      ********************************************************************
      *
     C     DBRelations   BEGSR

      ** Delete all records from list of logicals where there is a duplicate
      ** record or the logical is blank.

     C/exec SQL
     C+ delete from DBR022001T a
     C+ where rrn(a) >
     C+ (
     C+ select min (rrn(b))
     C+ from DBR022001T b
     C+ where a.WHREFI = b.WHREFI
     C+ or a.WHREFI = ' '
     C+ )
     C/end-exec

     C     DBRelationsE  ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *    Delete - Delete records from SCFMBRTD for a single logical    *
      *             file member                                          *
      *                                                                  *
      ********************************************************************
     C     Delete        BEGSR

     C/exec SQL
     C+ delete from SCFMBRTD
     C+ where MBFILE = :PFile
     C+ and MBNAME = :PMember
     C/end-exec

     C     DeleteE       ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *    Write - Write records to SCFMBRTD for a single logical        *
      *            file member                                           *
      ********************************************************************
     C     Write         BEGSR

     C/exec SQL
     C+ declare Write cursor for
     C+ select * from MBR022001T
     C+ where MBFILE = :PFile
     C+ and MBNAME = :PMember
     C/end-exec

     C/exec SQL
     C+ open Write
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Write
     C+ into :MBR
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                             and Complete = 'N'

      ** The number of records written will depend on the relationship
      ** between the logical and physical members.

     C                   EXSR      WriteRec

     C/exec SQL
     C+ fetch next
     C+ from Write
     C+ into :MBR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Write
     C/end-exec

     C     WriteE        ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *    WriteAll -  Write records to SCFMBRTD for all logical file    *
      *                members removed                                   *
      *                                                                  *
      ********************************************************************
     C     WriteAll      BEGSR

     C/exec SQL
     C+ declare WriteAll cursor for
     C+ select * from MBR022001T
     C+ where MBFILE = :PFile
     C/end-exec

     C/exec SQL
     C+ open WriteAll
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from WriteAll
     C+ into :MBR
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                             and Complete = 'N'

      ** The number of records written will depend on the relationship
      ** between the logical and physical members.

     C                   EXSR      WriteRec

     C/exec SQL
     C+ fetch next
     C+ from WriteAll
     C+ into :MBR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close WriteAll
     C/end-exec

     C     WriteAllE     ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *    WriteRec - Write records in SCFMBRTD file                     *
      *                                                                  *
      ********************************************************************
     C     WriteRec      BEGSR

     C/exec SQL
     C+ insert into SCFMBRTD
     C+ (
     C+   MBFILE
     C+ , MBNAME
     C+ , MBNOMB
     C+ , MBNSCM
     C+ , MBMTXT
     C+ , MBRSHR
     C+ , MBBOF
     C+ , MBBOM
     C+ , MBNPFM
     C+ , MBPERM
     C+ )
     C+ values
     C+ (
     C+   :XMBFILE
     C+ , :XMBNAME
     C+ , :XMBNOMB
     C+ , :XMBNSCM
     C***+*,*:XMBMTXT                                                                       MD041010
     C+ , :XMBTXT                                                                           MD041010
     C+ , :XMBRSHR
     C+ , :XMBBOF
     C+ , :XMBBOM
     C+ , 0
     C+ , 'N'
     C+ )
     C/end-exec

     C     WriteRecE     ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *    Update - Update SCFMBRTD file                                 *
      *                                                                  *
      ********************************************************************
     C     Update        BEGSR

      ** Build string to allow update of SCFMBRTD.

     C/exec SQL
     C+ declare Update cursor for
     C+ select * from SCFMBRTD
     C+ where MBFILE = :PFile
     C+ and MBNAME = :PMember
     C+ and MBPERM = 'N'
     C+ order by
     C+   MBFILE
     C+ , MBNAME
     C/end-exec

     C/exec SQL
     C+ open Update
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Update
     C+ into :FMBR
     C/end-exec

      ** Do nothing if there are no records found.

     C                   DOW       SQLCODE = 0

     C                   IF        MBNAME <> SaveName
     C                   EVAL      SaveName = MBNAME
     C                   EVAL      SavePF = MBBOF
     C                   EVAL      SavePFMbr = MBBOM
     C                   ELSE

      ** If the physical file member is the same then preserve all records for
      ** the logical file.

     C                   IF        MBBOM <> SavePFMbr
     C/exec SQL
     C+ delete from SCFMBRTD
     C+ where current of Update
     C/end-exec
     C                   ENDIF
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from Update
     C+ into :FMBR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close Update
     C/end-exec

     C                   EXSR      SetMBNSCM

     C     UpdateE       ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *
      *    UpdateAll
      *
      ********************************************************************
     C     UpdateAll     BEGSR

     C/exec SQL
     C+ declare UpdateAll cursor for
     C+ select * from SCFMBRTD
     C+ where MBFILE = :PFile
     C+ and MBPERM = 'N'
     C+ order by
     C+   MBFILE
     C+ , MBNAME
     C/end-exec

     C/exec SQL
     C+ open UpdateAll
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from UpdateAll
     C+ into :FMBR
     C/end-exec

      ** Do nothing if there are no records found.

     C                   DOW       SQLCODE = 0

     C                   IF        MBNAME <> SaveName
     C                   EVAL      SaveName = MBNAME
     C                   EVAL      SavePF = MBBOF
     C                   EVAL      SavePFMbr = MBBOM
     C                   ELSE

      ** If the physical file member is the same then preserve all records for
      ** the logical file.

     C                   IF        MBBOM <> SavePFMbr
     C/exec SQL
     C+ delete from SCFMBRTD
     C+ where current of UpdateAll
     C/end-exec
     C                   ENDIF
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from UpdateAll
     C+ into :FMBR
     C/end-exec

     C                   ENDDO

     C                   EXSR      SetMBNSCM

     C     UpdateAllE    ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *    SetMBNSCM -                                                   *
      *                                                                  *
      ********************************************************************
     C     SetMBNSCM     BEGSR

     C/exec SQL
     C+ update SCFMBRTD a
     C+ set MBNSCM = 0
     C+ where exists
     C+ (
     C+ select * from
     C+ (
     C+ select
     C+   MBFILE
     C+ , MBNAME
     C+ , count (*) as NumRecs
     C+ from SCFMBRTD
     C+ group by
     C+   MBFILE
     C+ , MBNAME
     C+ ) b
     C+ where
     C+     a.MBFILE = b.MBFILE
     C+ and a.MBNAME = b.MBNAME
     C+ and a.MBPERM = 'N'
     C+ and a.MBNOMB = 1
     C+ and NumRecs = 1
     C+ )
     C/end-exec

     C     SetMBNSCME    ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      *   *PSSR                                                          *
      *                                                                  *
      ********************************************************************
     C     *PSSR         BEGSR

     C     Recursive     IFEQ      *BLANKS
     C                   MOVE      'Y'           Recursive
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
     C                   ENDIF
     C     PSSRE         ENDSR
      *****************************************************************
