     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG UNIX directory validation')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3608 - UNIX directory validation                           *
      *                                                               *
      *  Function: This sub-module receives AS/400 Local Directory    *
      *            Error messages are issued if it contains invalid   *
      *            formatting or characters.                          *
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
     D LocDir          S             75
     D MsgIdArr        S              7    DIM(25)
     D RtnCode         S              7
 
      * +-------------------+
      * ¦ Standalone fields ¦
      * +-------------------+
     D DirArr1         S              1    DIM(72)
     D InvArr1         S              1    DIM(50)
     D Idx1            S              2  0
     D Idx2            S              2  0
     D Idx3            S              2  0 INZ(0)
     D WrkDir          S             72    INZ(*BLANKS)
 
      * +-----------------+
      * ¦ Named Constants ¦
      * +-----------------+
     D Slash           C                   '/'
     D DoubleSlash     C                   '//'
     D CharQCap        C                   'Q'
     D CharQSmall      C                   'q'
     D InvChars        C                   '\:;*?"<>£]{}+=¦,'
     D BlankChr        C                   ' '
 
      /EJECT
      * +--------------+
      * ¦ Main Routine ¦
      * +--------------+
      *
      *  Load directory name into a work array and a work field 72
      *  characters long.
     C                   MOVEA     LocDir        DirArr1
     C                   EVAL      WrkDir = LocDir
 
      *  Initialise Error message array and index.
     C                   MOVEA     *BLANKS       MsgIdArr
     C                   EVAL      Idx3 = 0
      * +------------------------------------------------------------+
      * ¦ Directory name should start with root directory (i.e.'/'). ¦
      * +------------------------------------------------------------+
 
      *  Initialise array index to 1.
     C                   EVAL      Idx1 = 1
 
      *  If first element of array is not a slash, send error message.
     C                   IF        DirArr1(Idx1) <> Slash
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx3 = Idx3 + 1
     C                   MOVEA     'CGD2543'     MsgIdArr(Idx3)
     C                   ENDIF
 
      * +-----------------------------------------------------+
      * ¦ Directory name should NOT start with character 'Q'. ¦
      * ¦ NOTE: System assumes that directory name which      ¦
      * ¦       starts with a 'Q' is a system directory.      ¦
      * +-----------------------------------------------------+
 
      *  Initialise array index to 2.
     C                   EVAL      Idx1 = 2
 
      *  If 2nd element of array is 'Q', send error message.
     C                   IF        (DirArr1(Idx1) = CharQCap) OR
     C                             (DirArr1(Idx1) = CharQSmall)
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx3 = Idx3 + 1
     C                   MOVEA     'CGD2547'     MsgIdArr(Idx3)
     C                   ENDIF
 
      * +---------------------------------------------------------------+
      * ¦ Directory name should not end with a forward slash (i.e.'/'). ¦
      * +---------------------------------------------------------------+
 
      *  Scan for rightmost non-blank character.
     C     BlankChr      CHECKR    WrkDir        Idx1
 
      *  If rightmost non-blank character is a slash and its index is
      *  greater than 1 (meaning it is not the ROOT dir), send error
      *  message. NOTE : Entry of ROOT ('/') only should be accepted.
     C                   IF        Idx1 > 1 AND
     C                             DirArr1(Idx1) = Slash
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx3 = Idx3 + 1
     C                   MOVEA     'CGD2544'     MsgIdArr(Idx3)
     C                   ENDIF
 
      * +----------------------------------------------------+
      * ¦ Directory name should not contain embedded blanks. ¦
      * +----------------------------------------------------+
 
      *  Scan for rightmost non-blank character and load its index
      *  into variable Idx1.
     C     BlankChr      CHECKR    WrkDir        Idx1
 
      *  Scan for position of first blank character in the array.
     C                   EVAL      Idx2 = 1
     C     BlankChr      LOOKUP    DirArr1(Idx2)                          21
 
      *  If position of first BLANK element is LESS THAN rightmost
      *  NON-BLANK element, theblank element is embedded.
     C                   IF        *IN21 = *ON AND
     C                             Idx2 < Idx1
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx3 = Idx3 + 1
     C                   MOVEA     'CGD2584'     MsgIdArr(Idx3)
     C                   ENDIF
 
      * +------------------------------------------------------------------+
      * ¦ Directory name should not contain 2 adjacent slashes (i.e.'//'). ¦
      * +------------------------------------------------------------------+
 
     C     DoubleSlash   SCAN      WrkDir                                 20
 
     C                   IF        *IN20 = *ON
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx3 = Idx3 + 1
     C                   MOVEA     'CGD2546'     MsgIdArr(Idx3)
     C                   ENDIF
 
      * +--------------------------------------------------------+
      * ¦ Directory name should not contain any of these invalid ¦
      * ¦ characters ('\',':','*','?','"','<','>' or '¦')        ¦
      * +--------------------------------------------------------+
 
      *  Move set of invalid chars in a work array and initialise index.
     C                   MOVEA     InvChars      InvArr1
     C                   EVAL      Idx2 = 1
 
      *  Scan directory name for each invalid characters.
     C                   DOW       Idx2 <= %ELEM(InvArr1) AND
     C                                InvArr1(Idx2) <> *BLANK
     C     InvArr1(Idx2) SCAN      WrkDir                                 20
 
      *  If an invalid character is found...
     C                   IF        *IN20 = *ON
 
      *  Send error message only if it doesn't exist in array.
     C     'CGD2545'     LOOKUP    MsgIdArr                               21
 
     C                   IF        *IN21 = *OFF
     C                   EVAL      RtnCode = '*ERROR '
     C                   EVAL      Idx3 = Idx3 + 1
     C                   MOVEA     'CGD2545'     MsgIdArr(Idx3)
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
     C                   PARM                    LocDir
     C                   PARM                    MsgIdArr
     C                   PARM                    RtnCode
 
     C                   ENDSR
