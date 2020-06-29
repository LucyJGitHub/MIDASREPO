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
     C                   IF        DDAORS = *Blank                                            DUG502
     C                   moveL     'N'           OKCAMT                                       DUG502
     C                   add       1             IDx                                          DUG502
     C                   eval      FldNamXAr(IDx) = 'DDAORS'                                 DUG502
     C                   eval      MsgIdXAr(IDx) = 'XXX5023'                                  DUG502
     C                   goto      ESRCalAmt                                                  DUG502
     C                   EndIF                                                                DUG502
     C                   EndIF                                                                DUG502
