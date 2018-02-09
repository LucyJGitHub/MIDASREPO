     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Report on source object cross checks')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000312 - Report on source/object cross reference problems  *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CUT011  *CREATE    Date 12Dec07               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT011 - Rewrite of command.  Make it more flexible and      *
      *           easier to maintain.                                 *
      *                                                               *
      *****************************************************************
     FUTSCOBQF  IF   E             DISK
     FUT000312P1O    E             PRINTER OFLIND(*IN37)
      /EJECT
     D WTitle          C                   'Report of mismatched source-
     D                                     /objects based on the source library'
     D SourceLib       S             10
     D Recursive       S              1
     D WorkSourceF     S                   LIKE(SOSRCF)
     D ObjFlag         S              1
     D SrcFlag         S              1
     D MatFlag         S              1
     D X               S              1  0
      *
     D                 DS
     D  DateStamp              1     12
     D  yy                     1      2
     D  mm                     3      4
     D  dd                     5      6
      *
      /SPACE 3
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     C     *ENTRY        PLIST
     C                   PARM                    SourceLib
      *
     C     *LIKE         DEFINE    SOSRCF        WSRCF
      *
      * Set up main report title.
     C                   EVAL      @TITLE = WTitle
     C                   EVAL      @TITLE = %TRIMR(@TITLE) + ' ' + SourceLib
      *
      * Write main page header.
     C                   WRITE     HEADH
      * Write header for object mismatch.
     C                   WRITE     OHEAD
      *
     C     1             SETLL     UPSCOBD0
     C                   READ      UPSCOBD0
      *
      * If there are no records at all write 'no records' for all types
      * of mis-matches.
     C                   IF        %EOF
     C                   WRITE     NORECS
     C                   WRITE     SHEAD
     C                   WRITE     NORECS
     C                   WRITE     MHEAD
     C                   WRITE     NORECS
     C                   WRITE     TRAILP
     C                   GOTO      ENDPGM
      *
     C                   ENDIF
      *
     C                   DOW       NOT(%EOF)
      *
      * If records are found assume that they are object mismatches.
     C                   IF        ObjFlag <> 'C'
     C                   IF        SORECT = 'O'
     C                   EXSR      Object
     C                   ENDIF
     C                   ENDIF
      *
      * Check if there are any source mismatches.
     C                   IF        SrcFlag <> 'C'
     C                   IF        SORECT = 'S'
      *
      * If ObjFlag is blank this means there were no object mismatches
      *  to report.
     C                   IF        ObjFlag = *blanks
     C                   WRITE     NORECS
     C                   ENDIF
      *
     C                   EVAL      ObjFlag = 'C'
     C                   EXSR      Source
     C                   ENDIF
     C                   ENDIF
      *
      * Check if there are any date mismatches.
     C                   IF        SORECT = 'M'
      *
      * If ObjFlag is blank this means there were no object mismatches
      *  to report.
     C                   IF        ObjFlag = *blanks
     C                   WRITE     NORECS
     C                   ENDIF
      *
     C                   EVAL      ObjFlag = 'C'
      * Must be a date mismatch record unless SrcFlag is blank
      *  which means there were no source mismatches to report.
     C                   IF        SrcFlag = *blanks
     C                   WRITE     HEADH
     C                   WRITE     SHEAD
     C                   WRITE     NORECS
     C                   ENDIF
      *
     C                   EVAL      SrcFlag = 'C'
     C                   EXSR      Match
     C                   ENDIF
      *
      * Read next record.
     C                   READ      UPSCOBD0
      *
     C                   ENDDO
      *
      * If no matching records written then write 'no records'
      *  but first check if there were any records at all (if SrcFlag
      *  is *NE 'C' then it reached end of file before being set).
      * If ObjFlag is blank this means there were no object mismatches
      *  to report.
     C                   IF        ObjFlag = *blanks
     C                   WRITE     NORECS
     C                   ENDIF
     C                   EVAL      ObjFlag = 'C'
      *
      * If SrcFlag is blank this means there were no source mismatches
      *  to report.
     C                   IF        SrcFlag = *blanks
     C                   WRITE     HEADH
     C                   WRITE     SHEAD
     C                   WRITE     NORECS
     C                   ENDIF
     C                   EVAL      SrcFlag = 'C'
      *
     C                   IF        MatFlag = *blanks
     C                   WRITE     HEADH
     C                   WRITE     MHEAD
     C                   WRITE     NORECS
     C                   ENDIF
      * Write trailer and end program.
     C                   WRITE     TRAILP
      *
     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * Object - Objects with non-matching source                     *
      *                                                               *
      *****************************************************************
     C     Object        BEGSR
      *
      * If object is a source file then do not report.
     C                   IF        %SUBST(SOOBJ:6:3) <> 'SRC' and
     C                             %SUBST(SOOBJ:1:3) <> 'STD' and
     C                             %SUBST(SOOBJ:1:2) <> 'SK' and
     C                             SOOBJ <> 'H'
      *
     C                   EVAL      @OBJ = SOOBJ
     C                   EVAL      @OBJT = SOOBJT
     C                   EVAL      @OTXT = SOOTXT
      * If overflow on then write header.
     C                   IF        *IN37 = *ON
     C                   WRITE     HEADH
     C                   WRITE     OHEAD
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
     C                   WRITE     ODTL
      * Set flag to indicate that a record has been written.
     C                   EVAL      ObjFlag = 'Y'
     C                   ENDIF
      *
     C     ObjectE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Source - Source with non-matching objects                     *
      *                                                               *
      *****************************************************************
     C     Source        BEGSR
      *
      * If source is /COPY type then do not report,
      *   or type is REDUNDANT, MOVED or RENAMED,
      *   or source is skeleton.
     C                   IF        %SUBST(SOSRCF:3:3) <> 'CPY' and
     C                             %SUBST(SOSRCF:1:2) <> 'SK' and
     C                             %SUBST(SOSRCF:1:5) <> 'QWIND' and
     C                             %SUBST(SOSRCF:1:3) <> 'ZSR' and
     C                             %SUBST(SOSRCF:1:3) <> 'STD' and
     C                             %SUBST(SOSRCF:1:5) <> 'GPZSR' and
     C                             SOSRCF <> 'H' and
     C                             SOMBTP <> 'REDUNDANT' and
     C                             SOMBTP <> 'RENAMED' and
     C                             SOMBTP <> 'MOVED'
      * Check if global and/or zone requested before writing record.
     C                   EVAL      @MBNM = SOMBNM
     C                   IF        SOLIB = SourceLib
     C                   EVAL      @MBTP = SOMBTP
     C                   ELSE
     C                   EVAL      @MBTP = SOLIB
     C                   ENDIF
     C                   IF        SOSRCF = WorkSourceF and
     C                             *IN37 <> *ON
     C                   EVAL      @SRCF = *blanks
     C                   ELSE
     C                   EVAL      @SRCF = SOSRCF
     C                   ENDIF
     C                   EVAL      @MTXT = SOMTXT
      * If overflow on then write header.
     C                   IF        *IN37 = *ON or
     C                             SrcFlag = *blanks
     C                   WRITE     HEADH
     C                   WRITE     SHEAD
     C                   EVAL      WorkSourceF = *blanks
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
     C                   WRITE     SDTL
      * Set flag to indicate that a record has been written.
     C                   EVAL      SrcFlag = 'Y'
     C                   EVAL      WorkSourceF = SOSRCF
     C                   ENDIF
      *
     C     SourceE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Match - Matching source and object but change dates are out   *
      *         of sync.                                              *
      *                                                               *
      *****************************************************************
     C     Match         BEGSR
      *
     C                   EVAL      @MBNM = SOMBNM
     C                   EVAL      @MBTP = SOMBTP
     C                   IF        SOSRCF = WorkSourceF
     C                   EVAL      @SRCF = *blanks
     C                   ELSE
     C                   EVAL      @SRCF = SOSRCF
     C                   ENDIF
     C                   EVAL      @MTXT = SOMTXT
      *
      * Set up date fields.
     C                   EVAL      DateStamp = SOOCHG
     C                   EVAL      @ODAT = dd + '/' + mm + '/' + yy
      *
     C                   EVAL      DateStamp = SOSCHG
     C                   EVAL      @SDAT = dd + '/' + mm + '/' + yy
      *
      * If overflow on then write header.
     C                   IF        *IN37 = *ON or
     C                             MatFlag = *blanks
     C                   WRITE     HEADH
     C                   WRITE     MHEAD
     C                   EVAL      WorkSourceF = *blanks
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
     C                   WRITE     MDTL
      * Set flag to indicate that a record has been written.
     C                   EVAL      @ODAT = *blanks
     C                   EVAL      @SDAT = *blanks
     C                   EVAL      MatFLAG = 'Y'
      *
     C     MatchE        ENDSR
      *
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
     C     Recursive     IFEQ      *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
