     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Create intermediate table - graphical')       *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000023 - Create intermediate table for graphical fields    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CUP003  *CREATE    Date 06Aug10               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP003 - Intermediate files for graphical fields.            *
      *                                                               *
      *****************************************************************
      *
      * DSPFFD outfile
     FUPFFDSTPD IF   E             DISK
      *
      * Variables:
     D PFile           S             10A
     D ReturnCodeOut   S              7
     D Mode            S              6
     D Recursive       S              1    INZ('N')
      *
     D SourceLine      DS
     D A_Spec                  6      6    INZ('A')
     D DDS                     7    100
     D R                      17     17
     D RecordFormat           19     28
     D Field                  19     28
     D LengthA                30     34
     D LengthN                33     34
     D Type                   35     35
     D Decimal                36     37
      *
     D                 DS
     D ByteN                   1      5  0
     D ByteA                   1      5
      *
     D                 DS
     D DigitsN                 1      2  0
     D DigitsA                 1      2
      *
     D                 DS
     D PosN                    1      2  0
     D PosA                    1      2
      *
      *****************************************************************
      * Start of MAIN processing
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFile
     C                   PARM                    ReturnCodeOut
      *
     C                   EVAL      ReturnCodeOut = *blanks
      *
      * Read File Field description for information about fields.
     C     1             SETLL     UPFFDSTPD
     C                   READ      UPFFDSTPD
      *
      * For first record get format name and write to source.
     C                   EVAL      R = 'R'
     C                   EVAL      RecordFormat = WHNAME
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SourceLine
     C                   PARM      '*CLEAR'      Mode
      *
     C                   DOU       %EOF
      *
     C                   EVAL      DDS = *blanks
     C                   EVAL      Field = WHFLDI
     C                   EVAL      Type = WHFLDT
     C                   EVAL      ByteN = WHFLDB
     C                   EVAL      DigitsN = WHFLDD
     C                   EVAL      PosN = WHFLDP
      *
      * Set up field attributes.
     C                   SELECT
      *
     C                   WHEN      WHFLDT = 'A'
     C                   EVAL      LengthA = ByteA
     C                   EVAL      Decimal = *blanks
      *
     C                   WHEN      WHFLDT = 'B'
     C                   EVAL      LengthN = DigitsA
     C                   EVAL      Decimal = PosA
      *
     C                   WHEN      WHFLDT = 'L'
     C                   EVAL      Decimal = *blanks
      *
     C                   WHEN      WHFLDT = 'P'
     C                   EVAL      LengthN = DigitsA
     C                   EVAL      Decimal = PosA
      *
     C                   WHEN      WHFLDT = 'S'
     C                   EVAL      LengthN = DigitsA
     C                   EVAL      Decimal = PosA
      *
     C                   WHEN      WHFLDT = 'T'
     C                   EVAL      Decimal = *blanks
      *
     C                   WHEN      WHFLDT = 'Z'
     C                   EVAL      Decimal = *blanks
      *
     C                   WHEN      WHFLDT = 'G'
     C                   EVAL      Type = 'A'
     C                   EVAL      LengthA = ByteA
     C                   EVAL      Decimal = *blanks
      *
     C                   ENDSL
      *
      * Build SQL line and write to SQL.
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SourceLine
     C                   PARM      '*WRITE'      Mode
      *
     C                   READ      UPFFDSTPD
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive <> 'Y'
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      ReturnCodeOut = '*ERROR'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
