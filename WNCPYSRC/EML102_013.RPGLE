      *****************************************************************                       EML102
      *                                                               *                       EML102
      *  Midas - /COPY Member GL001425                                *                       EML102
      *                                                               *                       EML102
      *  EML102_013 - Midas GL Retrieve Postings by Network Account   *                       EML102
      *                                                               *                       EML102
      *  Last Amend No. EML102  *CREATE    Date 22Nov19               *                       EML102
      *                                                               *                       EML102
      *---------------------------------------------------------------*                       EML102
      *                                                               *                       EML102
      *  EML102 - Upgrade of UNL007 to FB2.1 SP21                     *                       EML102
      *       UNL007 - Extended Narratives                            *                       EML102
      *                                                               *                       EML102
      *****************************************************************                       EML102
      *                                                                                       EML102
     C                   MOVE      'N'           EML102            1                          EML102
     C                   CALL      'AOSARDR0'                                                 EML102
     C                   PARM      *Blanks       P@RTCD            7                          EML102
     C                   PARM      '*VERIFY'     P@OPTN            7                          EML102
     C                   PARM      'EML102'      P@SARD            6                          EML102
     C                   PARM                    DSFDY                                        EML102
     C                   IF        P@RTCD = *Blanks                                           EML102
     C                   EVAL      EML102 = 'Y'                                               EML102
     C                   ENDIF                                                                EML102
      *                                                                                       EML102
      *****************************************************************                       EML102
      * End of /COPY EML102_013                                       *                       EML102
      *****************************************************************                       EML102
