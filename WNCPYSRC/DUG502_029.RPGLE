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
     C                   If        DUG502 = 'Y'                                               DUG502
     C                   If        PSDETSel = 'DV'                                            DUG502
     C                   MoveL     PSDBKSel      DDSDBK                                       DUG502
     C                   Else                                                                 DUG502
     C                   MoveL     *blanks       DDSDBK                                       DUG502
     C                   Endif                                                                DUG502
     C                   Endif                                                                DUG502
      *                                                                                       DUG502
