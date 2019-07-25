     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Build up job description library list')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation                                       *
      *                                                               *
      *  SM000052 - Build up job description library list             *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CUP042   *CREATE    Date 05Nov14              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - Changes for Bridge deliverable data split           *
      *                                                               *
      *****************************************************************
      *
     D PSubOption      S             20
     D PLayer          S              7
     D PPfx            S              2
     D PGPfx           S              2
     D PReturn         S              1
      *
     D XLIB            S             10
     D ScanPfx         S              2
     D ScanPfx2        S              2
     D Item            S             10
     D Type            S             10
     D FoundPos        S              3  0
     D StartPos        S              3  0
     D Command         S           3000
     D CommandLen      S             15  5 INZ(3000)
     D LibListString   S           2750
      *
     D/COPY GPCPYSRCG,PSDS
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSubOption
     C                   PARM                    PLayer
     C                   PARM                    PPfx
     C                   PARM                    PGPfx
     C                   PARM                    PReturn
      *
     C/exec SQL
     C+ whenever SQLERROR goto ERROR
     C/end-exec
      *
     C                   IF        PLayer = '*GLOBAL'
     C                   EVAL      ScanPfx = 'gg'
     C                   EVAL      XLib = PPfx + 'GXLIB'
     C                   EXSR      GlobalLibs
     C                   ENDIF
     C                   IF        PLayer = '*ZONE  '
     C                   EVAL      ScanPfx = 'zz'
     C                   EVAL      ScanPfx2 = 'gg'
     C                   EVAL      XLib = PPfx + 'XLIB'
     C                   EXSR      ZoneLibs
     C                   ENDIF
      *
     C/exec SQL
     C+ declare SETU cursor for
     C+ select
     C+   DFNAME
     C+ from SMIMPJW0
     C+ where
     C+     DFSMNU =  'CreateJobDesc'
     C+ and DFLAYR =  :PLayer
     C+ and DFCMD  <> '*NORUN'
     C+ and DFDEL  =  'N'
     C+ order by DFSEQN
     C/end-exec
      *
     C/exec SQL
     C+ open SETU
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from SETU
     C+ into
     C+   :Item
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * Set up command.
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'CHGJOBD JOBD(' + XLIB
     C                   EVAL      Command = %TRIMR(Command) + '/' + Item
     C                   EVAL      Command = %TRIMR(Command) + ') INLLIBL(' +
     C                             LibListString
     C                   EVAL      Command = %TRIMR(Command) + ')'
      *
      * Perform command.
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
     C/exec SQL
     C+ fetch next
     C+ from SETU
     C+ into
     C+   :Item
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close SETU
     C/end-exec
      *
     C     ERROR         TAG
     C                   IF        SQLCODE < 0
     C                   EVAL      PReturn = 'E'
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * Create library list for global job descriptions.              *
      *                                                               *
      *****************************************************************
      *
     C     GlobalLibs    BEGSR
      *
     C/exec SQL
     C+ declare SETUG cursor for
     C+ select
     C+   DFNAME
     C+ from SMIMPJW0
     C+ where
     C+     DFSMNU =  'CreateLibrary'
     C+ and DFLAYR =  :PLayer
     C+ and DFDEL  =  'N'
     C+ order by DFSEQN
     C/end-exec
      *
     C/exec SQL
     C+ open SETUG
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from SETUG
     C+ into
     C+   :Item
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * Scan the name to see if any characters need substitution.
     C                   EVAL      StartPos = 1
     C                   DOU       FoundPos = 0
     C                             or FoundPos > 10
     C                   EVAL      FoundPos = %SCAN(ScanPfx:Item:StartPos)
     C                   IF        FoundPos <> 0
     C                   EVAL      %SUBST(Item:FoundPos:2) = PPfx
     C                   EVAL      StartPos = FoundPos + 2
     C                   ENDIF
     C                   ENDDO
      *
     C                   EVAL      LibListString = %TRIMR(LibListString) +
     C                             ' ' + Item
      *
     C/exec SQL
     C+ fetch next
     C+ from SETUG
     C+ into
     C+   :Item
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close SETUG
     C/end-exec
      *
     C     GlobalLibsE   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Create library list for zone job descriptions.                *
      *                                                               *
      *****************************************************************
      *
     C     ZoneLibs      BEGSR
      *
     C/exec SQL
     C+ declare SETUZ cursor for
     C+ select
     C+   DFNAME
     C+ from SMIMPJW0
     C+ where
     C+     DFSMNU =  'CreateLibrary'
     C+ and DFLAYR =  :PLayer
     C+ and DFDEL  =  'N'
     C+ order by DFSEQN
     C/end-exec
      *
     C/exec SQL
     C+ open SETUZ
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from SETUZ
     C+ into
     C+   :Item
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * Scan the name to see if any characters need substitution.
     C                   EVAL      StartPos = 1
     C                   DOU       FoundPos = 0
     C                             or FoundPos > 10
     C                   EVAL      FoundPos = %SCAN(ScanPfx:Item:StartPos)
     C                   IF        FoundPos <> 0
     C                   EVAL      %SUBST(Item:FoundPos:2) = PPfx
     C                   EVAL      StartPos = FoundPos + 2
     C                   ENDIF
     C                   ENDDO
      *
     C                   EVAL      StartPos = 1
     C                   DOU       FoundPos = 0
     C                             or FoundPos > 10
     C                   EVAL      FoundPos = %SCAN(ScanPfx2:Item:StartPos)
     C                   IF        FoundPos <> 0
     C                   EVAL      %SUBST(Item:FoundPos:2) = PGPfx
     C                   EVAL      StartPos = FoundPos + 2
     C                   ENDIF
     C                   ENDDO
      *
     C                   EVAL      LibListString = %TRIMR(LibListString) +
     C                             ' ' + Item
      *
     C/exec SQL
     C+ fetch next
     C+ from SETUZ
     C+ into
     C+   :Item
     C/end-exec
      *
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close SETUZ
     C/end-exec
      *
      * After the zone list has been built up then add the global list.
     C                   EVAL      PLayer = '*GLOBAL'
     C                   EVAL      ScanPfx = 'gg'
     C                   EVAL      ScanPfx2 = PPfx
     C                   EVAL      PPfx = PGPfx
     C                   EXSR      GlobalLibs
      *
      * Reset the layer so that correct job descriptions are picked up.
     C                   EVAL      PLayer = '*ZONE'
     C                   EVAL      PPfx = ScanPfx2
      *
     C     ZoneLibsE     ENDSR
      *
