      *****************************************************************
      *                                                               *
      *  Last Amend No. DUG502 *Created    Date 05Dec17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DUG502 - Security Diary Enhancements                         *
      *                                                               *
      *****************************************************************
      *                                                                                       DUG502
     C                   IF        DUG502 = 'Y'                                               DUG502
     C                   IF        DDSDET <> 'DV' and DDSDBK <> *Blanks                       DUG502
     C                   move      'N'           OKSDBK                                       DUG502
     C                   add       1             Idx                                          DUG502
     C                   eval      FldNameArr(Idx) = 'DDSDBK'                                 DUG502
     C                   eval      MsgIdArr(Idx) = 'XXX5021'                                  DUG502
     C                   EndIF                                                                DUG502
      *                                                                                       DUG502
     C                   IF        DDSDET = 'DV' and DDSDBK <> *Blanks                        DUG502
     C     DDSDBK        Chain(N)  SDBOOKL1                                                   DUG502
     C                   If        Not %FOUND                                                 DUG502
     C                   move      'N'           OKSDBK                                       DUG502
     C                   add       1             Idx                                          DUG502
     C                   eval      FldNameArr(Idx) = 'DDSDBK'                                 DUG502
     C                   eval      MsgIdArr(Idx) = 'XXX5022'                                  DUG502
     C                   EndIF                                                                DUG502
     C                   EndIF                                                                DUG502
      *                                                                                       DUG502
     C                   EndIF                                                                DUG502
      *                                                                                       DUG502
