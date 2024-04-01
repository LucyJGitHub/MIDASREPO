      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001432)                              *
      *                                                               *
      *  GLH00425 - Midas GL Format Posting details                   *
      *                                                               *
      *  Last Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
      ** Use Cheque number if statement line references a cheque.                             UUC103
     C                   IF        %SUBST(MGSFD6:2:3) = 'CHK'                                 UUC103
     C                             And GLCHQN <> 0                                            UUC103
     C                             And UUC103 = 'Y'                                           UUC103
     C                   MOVE      GLCHQN        MGSFD7                         Cheque Number UUC103
     C                   ELSE                                                                 UUC103
      *                                                                                       UUC103
      ** Use Batch number if Source of posting is numeric.                                    UUC103
     C                   IF        GLSPOSNUM = 'Y'                                            UUC103
     C                             And UUC103 = 'Y'                                           UUC103
     C                   EVAL      MGSFD7 = %SUBST(GLSPOS:1:6)                  Batch #/SPOS  UUC103
     C                   ELSE                                                                 UUC103
