      *****************************************************************
      *                                                               *
      *  Last Amend No. DUG502 *CREATE     Date 04Dec17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DUG502 - Security Diary Enhancements                         *
      *                                                               *
      *****************************************************************
      *                                                                                       DUG502
     C                   IF        DUG502 = 'Y'                                               DUG502
      *                                                                                       DUG502
     C                   EVAL      DDAORS = ' '                                               DUG502
     C                   Z-ADD     8             ZADec                                        DUG502
      *                                                                                       DUG502
     C                   IF        SDPP > 0                                                   DUG502
     C                   EVAL      DDAORS = '+'                                               DUG502
     C                   MOVE      *BLANKS       ZField                                       DUG502
     C                   MOVE      SDPP          ZField                                       DUG502
     C                   ENDIF                                                                DUG502
      *                                                                                       DUG502
     C                   IF        SDPP < 0                                                   DUG502
     C                   EVAL      DDAORS = '-'                                               DUG502
     C                   MOVE      *BLANKS       ZField                                       DUG502
     C                   Z-SUB     SDPP          SDPPN                                        DUG502
     C                   MOVE      SDPPN         ZField                                       DUG502
     C                   ENDIF                                                                DUG502
      *                                                                                       DUG502
     C                   ELSE                                                                 DUG502
      *                                                                                       DUG502
