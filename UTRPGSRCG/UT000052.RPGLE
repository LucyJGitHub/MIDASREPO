     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT FNDUPDSRC update multiple sources')           *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000052 - Update multiple sources                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CUT015   *CREATE   Date 20Apr12               *
      *  Prev Amend No. xxxxxxxx           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT015 - New utility to replace UPDSRC.                      *
      *                                                               *
      *****************************************************************
      * Old and new source.
     FUTSTMTPD  IF   E           K DISK
      * Source files being updated.
     FSEARCHSRC UF   F  112        DISK    INFDS(Source)
     F                                     USROPN
      *
     D String          S            100
     D StringLen       S              3
     D WorkLib         S             10
     D CaseSense       S              7
     D ScanString      S            100
     D ScanSource      S            100
     D CheckLen        S            100    VARYING
     D X               S              3  0
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
     D  Status           *STATUS
      *
     ISEARCHSRC NS
     I                                  1    6 0SRCSEQ
     I                                  7   12 0SRCDAT
     I                                 13  112  SRCDTA
      *
      /EJECT
     C                   OPEN      SEARCHSRC
     C                   READ      SEARCHSRC
      *
     C                   DOW       NOT(%EOF)
      * If the scan is not case sensitive then convert string to upper case.
     C                   IF        CaseSense = '*MATCH'
     C                   EVAL      ScanSource = SRCDTA
     C                   ELSE
     C                   EVAL      ScanSource =
     C                             %XLATE(LowerCase:UpperCase:SRCDTA)
     C                   ENDIF
      *
      * The scan is performed again to reduce the number of chains to UTSTMTPD.
     C     ScanString:X  SCAN      ScanSource                             89
     C                   IF        *IN89 = *ON
     C     SRCDTA        CHAIN     UTSTMTPD
     C                   IF        %FOUND
     C                             and FUOSTR <> FUNSTR
     C                   EVAL      SRCDTA = FUNSTR
     C                   EXCEPT    NewLine
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      SEARCHSRC
     C                   ENDDO
      *
     C                   CLOSE     SEARCHSRC
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
     C                   PARM                    CaseSense
     C                   PARM                    StringLen
      *
      * If the scan is not case sensitive then convert string to upper case.
     C                   IF        CaseSense = '*MATCH'
     C                   EVAL      ScanString = String
     C                   ELSE
     C                   EVAL      ScanString =
     C                             %XLATE(LowerCase:UpperCase:String)
     C                   ENDIF
      *
     C                   EVAL      StringLenA = StringLen
      * If the length is not specified then work out length removing leading
      *  and trailing blanks.
     C                   IF        StringLenN = 0
     C                   EVAL      CheckLen = %TRIML(ScanString)
     C                   EVAL      CheckLen = %TRIMR(CheckLen)
     C                   EVAL      X = %LEN(CheckLen)
     C                   ELSE
     C                   EVAL      X = StringLenN
     C                   ENDIF
      *
     C     EINZSR        ENDSR
      *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      *INU3 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
      /EJECT
     OSEARCHSRC E            NewLine
     O                       SRCDTA             112
