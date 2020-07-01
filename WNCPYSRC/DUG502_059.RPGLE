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
      ** Access SAR File to determine if DUG502 is switched on                                DUG502
      *                                                                                       DUG502
     C                   EVAL      DUG502 = 'N'                                               DUG502
     C                   CALLB     'AOSARDR0'                                                 DUG502
     C                   PARM      *BLANKS       PRtcd                                        DUG502
     C                   PARM      '*VERIFY'     POptn                                        DUG502
     C                   PARM      'DUG502'      PSard                                        DUG502
     C     SCSARD        PARM      SCSARD        DSFDY                                        DUG502
      *                                                                                       DUG502
     C                   IF        PRtcd = *BLANKS                                            DUG502
     C                   EVAL      DUG502 = 'Y'                                               DUG502
     C                   ENDIF                                                                DUG502
      *                                                                                       DUG502
      ** Issue database error for error return codes                                          DUG502
      *                                                                                       DUG502
     C                   IF        PRtcd <> *BLANKS AND                                       DUG502
     C                             PRtcd <> '*NRF   '                                         DUG502
     C     *LOCK         IN        LDA                                                        DUG502
     C                   EVAL      DBKEY  = 'DUG502'                                          DUG502
     C                   EVAL      DBFILE = 'SCSARDPD'                                        DUG502
     C                   EVAL      DBASE  = 2                                                 DUG502
     C                   OUT       LDA                                                        DUG502
     C                   EXSR      *PSSR                                                      DUG502
     C                   ENDIF                                                                DUG502
      *                                                                                       DUG502
