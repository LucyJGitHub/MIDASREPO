     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Create intermediate table')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000044 - Create intermediate table.                        *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK025  *CREATE    Date 27Jul06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK025 - MidasPlus 1.3 packaging.  New migration tool.       *
      *                                                               *
      *****************************************************************
      *
      * Files with customer name fields
     FSMCNUMPD  IF   E           K DISK
      *
      * DSPFFD outfile
     FUPFFDSTPD IF   E             DISK
      *
      * Variables:
     D PFile           S             10A
     D KFile           S             10
     D ReturnCodeOut   S              7
     D KType           S              8A   INZ('*FILE   ')
     D KFieldName      S             10
     D Mode            S              6
     D Recursive       S              1    INZ('N')
     D FieldsIdx       S              2  0
     D DataQueue       S             10
     D DataQueueLib    S             10
     D DTAQEntryLen    S              5  0
     D DTAQEntry       S             12
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
     C     Key01         KLIST
     C                   KFLD                    KFile
     C                   KFLD                    KType
     C                   KFLD                    KFieldName
      *
     C                   EVAL      ReturnCodeOut = *blanks
     C                   EVAL      KFile = PFile
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
     C                   EVAL      KFieldName = WHFLDI
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
      * Check if the file contains any Customer Number fields.  Only do this if
      *  the field is signed as packed fields will be handled differently.
     C                   EXSR      CheckCustNum
      *
     C                   WHEN      WHFLDT = 'T'
     C                   EVAL      Decimal = *blanks
      *
     C                   WHEN      WHFLDT = 'Z'
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
      /EJECT
      *****************************************************************
      *                                                               *
      *  CheckCustNum - Find out if field needs to be changed         *
      *                                                               *
      *****************************************************************
     C     CheckCustNum  BEGSR
      *
     C     Key01         CHAIN     SMCNUMPD
     C                   IF        %FOUND
     C                   EVAL      Type = 'A'
     C                   EVAL      Decimal = *blanks
      *
      * Send field name to data queue for later use.
     C                   EVAL      DTAQEntry = WHFLDI + DigitsA
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SM000044'    DataQueue
     C                   PARM      'QTEMP'       DataQueueLib
     C                   PARM      12            DTAQEntryLen
     C                   PARM                    DTAQEntry
      *
     C                   ENDIF
      *
     C     CheckCustNumE ENDSR
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
