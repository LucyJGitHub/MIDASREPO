     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Retrieve object description')                 *
      *****************************************************************
      *                                                               *
      *  Midas - UT Module                                            *
      *                                                               *
      *  UTRTVOBJD - Retrieve object description details              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CUP042  *CREATE    Date 23Feb15               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - New utility.                                        *
      *                                                               *
      *****************************************************************
      *
     D PObject         S             10A
     D PLibrary        S             10A
     D PObjectType     S             10A
     D PRtnCode        S              1A
     D RtvData         S            180A
     D Object          S             20A
     D RtvDataLen      S              4B 0 INZ(180)
     D Format          S              8A
      *
     D                 DS
     D ErrorInf                1     15
     D  Error1                 1      4B 0 INZ(15)
     D  Error2                 5      8B 0
     D  Error3                 9     15
      *
      * Parameters passed to program
     C     *ENTRY        PLIST
     C                   PARM                    PObject
     C                   PARM                    PLibrary
     C                   PARM                    PObjectType
      *
     C                   PARM                    PRtnCode
     C                   PARM                    RtvData
      *
     C                   EVAL      PRtnCode = *blank
     C                   EVAL      Object = PObject + PLibrary
     C                   CALL(e)   'QUSROBJD'
     C                   PARM                    RtvData
     C                   PARM                    RtvDataLen
     C                   PARM      'OBJD0200'    Format
     C                   PARM                    Object
     C                   PARM                    PObjectType
     C                   PARM                    ErrorInf
      * Move error message to parameter so that calling program can handle it.
     C                   IF        Error3 <> *blank
     C                   EVAL      PRtnCode = 'E'
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
