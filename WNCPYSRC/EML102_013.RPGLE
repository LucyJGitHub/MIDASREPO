      *****************************************************************                       EML102
      *                                                               *                       EML102
      *  Midas - /COPY Member GL001425                                *                       EML102
      *                                                               *                       EML102
      *  EML102_013 - Midas GL Retrieve Postings by Network Account   *                       EML102
      *                                                               *                       EML102
      *  Last Amend No. EML104             Date 04Feb20               *                       EML104
      *  Prev Amend No. EML102  *CREATE    Date 22Nov19               *                       EML102
      *                                                               *                       EML102
      *---------------------------------------------------------------*                       EML102
      *                                                               *                       EML102
      *  EML104 - Upgrade of EML010 to FB2.1 SP21                     *                       EML104
      *       EML010 - Structured field :86:                          *                       EML104
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
      *                                                                                       EML104
      ** Check if feature EML104 is installed                                                 EML104
      *                                                                                       EML104
     C                   EVAL      EML104 = 'N'                                               EML104
     C                   CALLB     'AOSARDR0'                                                 EML104
     C                   PARM      *BLANKS       PRtcd                                        EML104
     C                   PARM      '*VERIFY'     POptn                                        EML104
     C                   PARM      'EML104 '     PSard                                        EML104
     C     SCSARD        PARM      SCSARD        DSFDY                                        EML104
      *                                                                                       EML104
     C                   IF        PRtcd = *BLANKS                                            EML104
     C                   EVAL      EML104     = 'Y'                                           EML104
     C                   ENDIF                                                                EML104
      *                                                                                       EML104
      ** Retrieve MultiCash Flag on Networks                                                  EML104
      *                                                                                       EML104
     C                   IF        EML104 = 'Y'                                               EML104
      *                                                                                       EML104
     C                   MOVEL     '*FIRST '     POptn                          Option        EML104
      *                                                                                       EML104
     C                   DOU       PRtcd <> *Blanks Or IdxNw = 1                              EML104
     C                   CALLB     'AONWRKR1'                                                 EML104
     C                   PARM      *BLANKS       PRtcd                          Return Code   EML104
     C                   PARM                    POptn                          Option        EML104
     C                   PARM                    PNwrk                          Network       EML104
     C     SDNWRK        PARM      SDNWRK        DSLDY                                        EML104
      *                                                                                       EML104
     C                   IF        PRtcd = *Blanks                                            EML104
     C                   SUB       1             IdxNw                                        EML104
     C                   EVAL      ArNwrk(IdxNw) = EDNWRK                                     EML104
     C                   EVAL      ArMtFmt(IdxNw)= EDMCNW                                     EML104
     C                   ENDIF                                                                EML104
      *                                                                                       EML104
     C                   ENDDO                                                                EML104
      *                                                                                       EML104
     C                   ENDIF                                                                EML104
      *                                                                                       EML102
      *****************************************************************                       EML102
      * End of /COPY EML102_013                                       *                       EML102
      *****************************************************************                       EML102
