      *****************************************************************
      *  Start of /COPY LUC110_106                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. MD055854 *CREATE   Date 15Jun20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055854 - When deleting a batch or batch item from frontend *
      *             the narratives in XXJENPX0 file is not deleted    *
      *             Amend to delete corresponding rec in XXJENPX0.    *
      *                                                               *
      *****************************************************************
      *
      ** Check if Extended Narrative is on
     C                   MOVE      'N'           LUC110            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'LUC110'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtnCode = *BLANKS
     C                   EVAL      LUC110 = 'Y'
     C                   ENDIF
      *
      *****************************************************************
      *  End of /COPY LUC110_106                                      *
      *****************************************************************
