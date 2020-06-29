      *****************************************************************
      *                                                               *
      *  Last Amend No. DUG502 *Created    Date 04Dec17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DUG502 - Security Diary Enhancements                         *
      *                                                               *
      *****************************************************************
      *
      ** Access SAR File to determine if DUG502 is switched on
      *
     C                   EVAL      DUG502 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'DUG502'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      DUG502 = 'Y'
     C                   ENDIF
      *
      ** Issue database error for error return codes
      *
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = 'DUG502'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
