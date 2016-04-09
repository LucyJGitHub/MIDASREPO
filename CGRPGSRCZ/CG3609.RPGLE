     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Microsoft WINDOWS directory validation')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3609 - Microsoft WINDOWS directory validation              *
      *                                                               *
      *  Function: This sub-module receives a Window type directory   *
      *            as parameter and validates it. Error               *
      *            messages are issued if it contains invalid         *
      *            formatting and/or characters.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CCG015  *CREATE    Date 19Oct01               *
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
     D WinDir          S             75
     D MsgIdArr        S              7    DIM(25)
     D RtnCode         S              7
 
      * +-------------------+
      * ¦ Standalone fields ¦
      * +-------------------+
     D DirArr          S              1    DIM(75)
     D InvArr          S              1    DIM(50)
     D Idx1            S              2  0
     D Idx2            S              2  0
     D Idx3            S              2  0
 
      * +-----------------+
      * ¦ Named Constants ¦
      * +-----------------+
     D BackSlash       C                   '\'
     D DoubleBack      C                   '\\'
     D Colon           C                   ':'
     D InvChars        C                   '/:;*?"<>£]{}+=¦,'
     D BlankChr        C                   ' '
     D ValRoot         C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ+
     D                                      abcdefghijklmnopqrstuvwxyz'
 
      /EJECT
      * +--------------+
      * ¦ Main Routine ¦
      * +--------------+
      *
      *  Load PC server directory name into a work array.
     C                   MOVEA     WinDir        DirArr
 
      *  Initialise Error message array and index.
     C                   MOVEA     *BLANKS       MsgIdArr
     C                   EVAL      Idx3 = 0
 
      * +-------------------------------------------------------------+
      * ¦ Directory name should start with root directory (i.e.'C:\').¦
      * ¦ Any chars from 'A' to 'Z' or 'a' to 'z' should be accepted. ¦
      * +-------------------------------------------------------------+
 
      * (1) Check that 1st char is any value from £A...Z] or £a...z]
 
      * Initialise array index to 1.
     C                   EVAL      Idx1 = 1
 
      *  Send error msg if first element of array is not an alpha
      *  character (from 'A' to 'Z' and 'a' to 'z').
 
     C     DirArr(Idx1)  SCAN      ValRoot                                20
 
     C                   IF        *IN20 = *OFF
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx3 = Idx3 + 1
     C                   MOVEA     'CGD2548'     MsgIdArr(Idx3)
     C                   ELSE
 
      * (2) Check that 2nd char is a colon (:) and 3rd char is a
      *     backslash (\).
 
     C                   EVAL      Idx1 = 2
 
     C                   IF        (DirArr(Idx1) <> Colon) OR
     C                             (DirArr(Idx1+1) <> BackSlash)
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx3 = Idx3 + 1
     C                   MOVEA     'CGD2548'     MsgIdArr(Idx3)
     C                   ENDIF
 
     C                   ENDIF
 
      * +-----------------------------------------------------------+
      * ¦ Directory name should not end with a backslash (i.e.'\'). ¦
      * +-----------------------------------------------------------+
 
      *  Scan for rightmost non-blank character
     C     BlankChr      CHECKR    WinDir        Idx1
 
      *  Send error msg if rightmost non-blank character is a backslash
      *  and its index is greater than 3 (meaning, it not part of the
      *  ROOT directory). NOTE : Entry of only the ROOT directory ('C:\')
      *  should be accepted.
     C                   IF        Idx1 > 3 AND
     C                             DirArr(Idx1) = BackSlash
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx3 = Idx3 + 1
     C                   MOVEA     'CGD2549'     MsgIdArr(Idx3)
     C                   ENDIF
 
      * +----------------------------------------------------+
      * ¦ Directory name should not contain embedded blanks. ¦
      * +----------------------------------------------------+
 
      *  Scan for rightmost non-blank character and load its index
      *  into variable Idx1.
     C     BlankChr      CHECKR    WinDir        Idx1
 
      *  Scan for position of first blank character in the array.
     C                   EVAL      Idx2 = 1
     C     BlankChr      LOOKUP    DirArr(Idx2)                           21
 
      *  If position of first BLANK element is LESS THAN rightmost
      *  NON-BLANK element, the blank element is embedded.
     C                   IF        *IN21 = *ON AND
     C                             Idx2 < Idx1
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx3 = Idx3 + 1
     C                   MOVEA     'CGD2585'     MsgIdArr(Idx3)
     C                   ENDIF
 
      * +------------------------------------------------------------------+
      * ¦ Directory should not contain 2 adjacent back slashes (i.e.'\\'). ¦
      * +------------------------------------------------------------------+
 
     C     DoubleBack    SCAN      WinDir                                 20
 
     C                   IF        *IN20 = *ON
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx3 = Idx3 + 1
     C                   MOVEA     'CGD2550'     MsgIdArr(Idx3)
     C                   ENDIF
 
      * +------------------------------------------------------+
      * ¦ Directory name should not contain any of the invalid ¦
      * ¦ characters ('/',':','*','?','"','<','>' or '¦')      ¦
      * +------------------------------------------------------+
 
      *  Move set of invalid chars in a work array and initialise index.
     C                   MOVEA     InvChars      InvArr
     C                   EVAL      Idx2 = 1
 
      *  Scan directory name for each invalid characters starting at
      *  position 4 (NOTE : First 3 chars should be like 'c:\').
     C                   DOW       Idx2 <= %ELEM(InvArr) AND
     C                                InvArr(Idx2) <> *BLANK
     C     InvArr(Idx2)  LOOKUP    DirArr(4)                              20
 
      *  If an invalid character is found...
     C                   IF        *IN20 = *ON
 
      *  Send error message only if it doesn't exist in array.
     C     'CGD2551'     LOOKUP    MsgIdArr                               21
     C                   IF        *IN21 = *OFF
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx3 = Idx3 + 1
     C                   MOVEA     'CGD2551'     MsgIdArr(Idx3)
     C                   ENDIF
 
     C                   ENDIF
 
      *  Scan for next invalid character.
     C                   EVAL      Idx2 = Idx2 + 1
     C                   ENDDO
 
     C                   RETURN
 
      /EJECT
      * +------------------------------------------------------------------+
      * ¦ Subr/*INZSR - Initialisation subroutine                          ¦
      * +------------------------------------------------------------------+
     C     *INZSR        BEGSR
 
      *  Define parameter passed from calling program
     C     *ENTRY        PLIST
     C                   PARM                    WinDir
     C                   PARM                    MsgIdArr
     C                   PARM                    RtnCode
 
     C                   ENDSR
