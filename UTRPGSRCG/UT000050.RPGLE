     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT FNDUPDSRC search for string')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000050 - Search for string                                 *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUT015  *CREATE    Date 19Apr12               *
      *                 XXXXXXXX           Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT015 - New utility to replace UPDSRC.                      *
      *                                                               *
      *****************************************************************
      * Old and new source.
     FUTSTMTPD  IF A E           K DISK
      * Members containing selected string.
     FUTMBRSPD  IF A E           K DISK
      * Internal source file to be scanned.
     FSEARCHSRC IF   F  112        DISK    INFDS(Source)
     F                                     USROPN
      *
     D String          S            100
     D StringLen       S              3  0
     D WorkLib         S             10
     D CaseSense       S              7
     D ScanString      S            100
     D ScanSource      S            100
     D CheckLen        S            100    VARYING
     D X               S              3  0
     D OldMember       S             10
     D Recursive       S              1
      *
     D LowerCase       C                   CONST('abcdefghijklmnopqrstuvwxyz')
     D UpperCase       C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
      *
     D                 DS
     D  StringLenN             1      3  0
     D  StringLenA             1      3
      *
     D Source          DS
     D  FUSRCF                83     92
     D  NewMember            129    138
     D  Status           *STATUS
      *
     ISEARCHSRC NS
     I                                  1    6 0SRCSEQ
     I                                  7   12 0SRCDAT
     I                                 13  112  SRCDTA
      *
      /EJECT
      * If this is the first call (the work library is blank) then just write
      *  special record to UTSTMTPD.
     C                   IF        WorkLib = *blanks
     C                   EVAL      StringLenN = StringLen
     C                   EVAL      FUNSTR = String
     C                   EVAL      FUOSTR = 'FNDUPDSRC ' + CaseSense +
     C                             StringLenA
     C                   WRITE     UTSTMTD0
      *
     C                   ELSE
     C                   OPEN      SEARCHSRC
     C                   READ      SEARCHSRC
      *
     C                   DOW       NOT(%EOF)
     C                   EVAL      OldMember = NewMember
      * Do for all records in the member.
     C                   DOW       NewMember = OldMember
     C                             and NOT(%EOF)
      * If the scan is not case sensitive then convert string to upper case.
     C                   IF        CaseSense = '*MATCH'
     C                   EVAL      ScanSource = SRCDTA
     C                   ELSE
     C                   EVAL      ScanSource =
     C                             %XLATE(LowerCase:UpperCase:SRCDTA)
     C                   ENDIF
      *
     C     ScanString:X  SCAN      ScanSource                             89
     C                   IF        *IN89 = *ON
      * Add to list of members containing string.
     C                   EVAL      FUMBR  = OldMember
     C                   EVAL      FUFSRC = 'Y'
     C                   EVAL      FUCODE = SRCDTA
     C                   WRITE     UTMBRSD0
      * Check if it has been found before.
     C     SRCDTA        CHAIN     UTSTMTPD
     C                   IF        NOT(%FOUND)
     C                   EVAL      FUOSTR = SRCDTA
     C                   EVAL      FUNSTR = SRCDTA
     C                   WRITE     UTSTMTD0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      SEARCHSRC
     C                   ENDDO
      *
      * Check if the member is already in list; i.e. string found.
     C     MemberKey     CHAIN     UTMBRSPD
     C                   IF        NOT(%FOUND)
     C                   EVAL      FUMBR  = OldMember
     C                   EVAL      FUFSRC = 'N'
     C                   CLEAR                   FUCODE
     C                   WRITE     UTMBRSD0
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   CLOSE     SEARCHSRC
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    String
     C                   PARM                    WorkLib
     C                   PARM                    CaseSense
     C                   PARM                    StringLen
      *
     C     MemberKey     KLIST
     C                   KFLD                    WorkLib
     C                   KFLD                    FUSRCF
     C                   KFLD                    OldMember
      *
     C                   EVAL      FUWLIB = WorkLib
      *
      * If the scan is not case sensitive then convert string to upper case.
     C                   IF        CaseSense = '*MATCH'
     C                   EVAL      ScanString = String
     C                   ELSE
     C                   EVAL      ScanString =
     C                             %XLATE(LowerCase:UpperCase:String)
     C                   ENDIF
      *
      * If the length is not specified then work out length removing leading
      *  and trailing blanks.
     C                   IF        StringLen = 0
     C                   EVAL      CheckLen = %TRIML(ScanString)
     C                   EVAL      CheckLen = %TRIMR(CheckLen)
     C                   EVAL      X = %LEN(CheckLen)
     C                   ELSE
     C                   EVAL      X = StringLen
     C                   ENDIF
      *
     C     EINZSR        ENDSR
      *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      *INU1 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
