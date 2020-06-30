      *****************************************************************
      *                                                               *
      *  Last Amend No. DUG502 *CREATE     Date 04Dec17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DUG502 - Security Diary Enhancements                         *
      *                                                               *
      *****************************************************************
      *
     C                   IF        DUG502 = 'Y'
      *
     C                   EVAL      DDAORS = ' '
     C                   Z-ADD     8             ZADec
      *
     C                   IF        SDPP > 0
     C                   EVAL      DDAORS = '+'
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      SDPP          ZField
     C                   ENDIF
      *
     C                   IF        SDPP < 0
     C                   EVAL      DDAORS = '-'
     C                   MOVE      *BLANKS       ZField
     C                   Z-SUB     SDPP          SDPPN
     C                   MOVE      SDPPN         ZField
     C                   ENDIF
      *
     C                   ELSE
      *
