     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Validate XML element name')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3610 - Validate XML Element Name                           *
      *                                                               *
      *  Function: This sub-module receives XML Element Name input    *
      *            as parameter and validates it. Error messages      *
      *            are be issued if it contains invalid formatting    *
      *            or characters.                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CCG015  *CREATE    Date 13Sep01               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCG015 - Correspondence Manager                              *
      *                                                               *
      *****************************************************************
      /EJECT
 
      * +-----------------------+
      * ¦ Parameter Declaration ¦
      * +-----------------------+
     D ElemName        S             30
     D MsgIdArr        S              7    DIM(25)
     D RtnCode         S              7
 
      * +-------------------+
      * ¦ Standalone fields ¦
      * +-------------------+
     D ElemArr         S              1    DIM(30)
     D Idx1            S              2  0
     D Idx2            S              2  0
     D FldPos          S              2  0
 
      * +-----------------+
      * ¦ Named Constants ¦
      * +-----------------+
     D BlankChar       C                   ' '
     D UnderScore      C                   '_'
     D ValidAlpha      C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ+
     D                                      abcdefghijklmnopqrstuvwxyz'
     D ValidDigits     C                    '0123456789'
     D ValidSymbols    C                    '.-_'
     D UpperX          C                    'X'
     D LowerX          C                    'x'
     D UpperM          C                    'M'
     D LowerM          C                    'm'
     D UpperL          C                    'L'
     D LowerL          C                    'l'
 
      /EJECT
      * +--------------+
      * ¦ Main Routine ¦
      * +--------------+
 
      *  Load XML Element Name into a work array.
 
     C                   MOVEA     ElemName      ElemArr
 
      *  Initialise Error message array and its index.
 
     C                   MOVEA     *BLANKS       MsgIdArr
     C                   EVAL      Idx2 = 0
 
      * +--------------------------------------------------------------+
      * ¦ (1) XML Element Name SHOULD NOT start with 'XML' and all of  ¦
      * ¦     its combinations in upper and lower cases.               ¦
      * +--------------------------------------------------------------+
 
     C                   IF        (ElemArr(1)=UpperX or ElemArr(1)=LowerX)
     C                             AND (ElemArr(2)=UpperM or ElemArr(2)=LowerM)
     C                             AND (ElemArr(3)=UpperL or ElemArr(3)=LowerL)
 
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx2 = Idx2 + 1
     C                   MOVEA     'CGD2552'     MsgIdArr(Idx2)
 
     C                   ENDIF
 
 
      * +------------------------------------------------------------------+
      * ¦ (2) Element Name must begin with an alpha char OR an underscore. ¦
      * +------------------------------------------------------------------+
 
     C     ElemArr(1)    SCAN      ValidAlpha                             20
 
      *  If element is not an Alpha char AND NOT an Underscore.
 
     C                   IF        (*IN20 = *OFF) AND
     C                             (ElemArr(1) <> UnderScore)
 
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx2 = Idx2 + 1
     C                   MOVEA     'CGD2553'     MsgIdArr(Idx2)
 
     C                   ENDIF
 
      * +--------------------------------------------------------+
      * ¦ (3) Element Name should not contain embedded blank(s). ¦
      * +--------------------------------------------------------+
 
      *  Reset array index.
 
     C                   EVAL      Idx1 = 1
 
      *  Process each element while index is less than array size.
      *  This is so to be able to check element next to it. If
      *  next element is non-blank, then an embedded blank exists.
 
     C                   DOW       Idx1 < %ELEM(ElemArr)
 
     C                   IF        ElemArr(Idx1) = BlankChar AND
     C                             ElemArr(Idx1+1) <> BlankChar
 
      *  Send error message only if it doesn't exist in array.
 
     C     'CGD2555'     LOOKUP    MsgIdArr                               21
 
     C                   IF        *IN21 = *OFF
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx2 = Idx2 + 1
     C                   MOVEA     'CGD2555'     MsgIdArr(Idx2)
     C                   ENDIF
 
     C                   ENDIF
 
      *  Increment array index.
 
     C                   EVAL      Idx1 = Idx1 + 1
     C                   ENDDO
 
      * +--------------------------------------------------------+
      * ¦ (4) Element Name should not contain other chars apart  ¦
      * ¦     from ALPHA, DIGITS, PERIOD, HYPHEN and UNDERSCORE. ¦
      * +--------------------------------------------------------+
 
      *  Reset array index.
 
     C                   EVAL      Idx1 = 1
 
      *  Locate position of the last non-blank character in the
      *  XML Element Name.
 
     C     BlankChar     CHECKR    ElemName      FldPos
 
      *  Process each element (starting from left) until the last
      *  non-blank character (as located via FldPos) is reached.
 
     C                   DOW       Idx1 <= FldPos
 
      *  Check each element if Alpha, Digit or any of the valid
      *  symbols ('.', '-' or '_')
 
     C     ElemArr(Idx1) SCAN      ValidAlpha                             20
     C  N20ElemArr(Idx1) SCAN      ValidDigits                            20
     C  N20ElemArr(Idx1) SCAN      ValidSymbols                           20
 
     C                   IF        *IN20 = *OFF
 
      *  Send error message only if it doesn't exist yet in array.
 
     C     'CGD2554'     LOOKUP    MsgIdArr                               21
 
     C                   IF        *IN21 = *OFF
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx2 = Idx2 + 1
     C                   MOVEA     'CGD2554'     MsgIdArr(Idx2)
     C                   ENDIF
 
     C                   ENDIF
 
      *  Increment array index.
 
     C                   EVAL      Idx1 = Idx1 + 1
     C                   ENDDO
 
      *  Return to calling program.
 
     C                   RETURN
 
      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Subr/*INZSR - Initialisation subroutine                          ¦
      * +------------------------------------------------------------------+
     C     *INZSR        BEGSR
 
      *  Define parameter passed from calling program
 
     C     *ENTRY        PLIST
     C                   PARM                    ElemName
     C                   PARM                    MsgIdArr
     C                   PARM                    RtnCode
 
     C                   ENDSR
