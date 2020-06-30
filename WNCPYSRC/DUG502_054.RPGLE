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
      ** Check if DUG502 is enabled.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'DUG502'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   MOVE      'N'           DUG502            1
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      DUG502 = 'Y'
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = PSARD
     C                   EVAL      DBase = 102
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *
