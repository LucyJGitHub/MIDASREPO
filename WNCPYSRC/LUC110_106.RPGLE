      *****************************************************************
      *  Start of /COPY LUC110_106                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. MD055854 *Create   Date 15Jun20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055854 - When deleting a batch or batch item from frontend *
      *             the narratives in XXJENPX0 file is not deleted    *
      *             Amend to delete corresponding rec in XXJENPX0     *
      *                                                               *
      *****************************************************************
      *
      ** Check if Extended Narrative is on                                                  MD055854
     C                   MOVE      'N'           LUC110            1                        MD055854
     C                   CALLB     'AOSARDR0'                                               MD055854
     C                   PARM      *BLANKS       PRtnCode                                   MD055854
     C                   PARM      '*VERIFY'     POption                                    MD055854
     C                   PARM      'LUC110'      PSard                                      MD055854
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD055854
                                                                                            MD055854
     C                   IF        PRtnCode = *BLANKS                                       MD055854
     C                   EVAL      LUC110 = 'Y'                                             MD055854
     C                   ENDIF                                                              MD055854
      *
      *****************************************************************
      *  End of /COPY LUC110_106                                      *
      *****************************************************************
