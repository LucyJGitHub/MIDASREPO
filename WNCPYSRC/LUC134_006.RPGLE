      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (MMVLDNICUS)                            *
      *                                                               *
      *  LUC134_006 - Call AOSARDR0 and AOSVALR0                      *
      *                                                               *
      *  Last Amend No. LUC134  *Create    Date 19Sep19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC134 - Amend Customer Restrictions for MM deals            *
      *                                                               *
      *****************************************************************
      *
     C                   CALLB     'AOSARDR0'                                                 LUC134
     C                   PARM      *BLANKS       PRtCd                                        LUC134
     C                   PARM      '*VERIFY'     POptn                                        LUC134
     C                   PARM      'LUC134'      PSARD                                        LUC134
     C     SCSARD        PARM      SCSARD        DSFDY                                        LUC134
                                                                                              LUC134
     C                   Move      'N'           LUC134            1                          LUC134
     C                   If        PRtCd = *Blanks                                            LUC134
     C                   Eval      LUC134 = 'Y'                                               LUC134
     C                   Endif                                                                LUC134
      *                                                                                       LUC134
     C                   If        LUC134 = 'Y'                                               LUC134
      *                                                                                       LUC134
      ** Allow deal types IT and IP for Non-Bank Customers                                    LUC134
     C                   CALLB     'AOSVALR0'                                                 LUC134
     C                   PARM      *BLANKS       PRtCd             7                          LUC134
     C                   PARM      PSysVal1      PSysVal01                                    LUC134
     C                   PARM                    PCurSet01                                    LUC134
     C                   PARM                    PSysVal02                                    LUC134
     C                   PARM                    PCurSet02                                    LUC134
     C                   PARM                    PSysVal03                                    LUC134
     C                   PARM                    PCurSet03                                    LUC134
     C                   PARM                    PSysVal04                                    LUC134
     C                   PARM                    PCurSet04                                    LUC134
     C                   PARM                    PSysVal05                                    LUC134
     C                   PARM                    PCurSet05                                    LUC134
     C                   PARM                    PSysVal06                                    LUC134
     C                   PARM                    PCurSet06                                    LUC134
     C                   PARM                    PSysVal07                                    LUC134
     C                   PARM                    PCurSet07                                    LUC134
     C                   PARM                    PSysVal08                                    LUC134
     C                   PARM                    PCurSet08                                    LUC134
     C                   PARM                    PSysVal09                                    LUC134
     C                   PARM                    PCurSet09                                    LUC134
     C                   PARM                    PSysVal10                                    LUC134
     C                   PARM                    PCurSet10                                    LUC134
                                                                                              LUC134
     C                   If        PRtCd <> *Blanks                                           LUC134
     C     *LOCK         In        LDA                                                        LUC134
     C                   Eval      DBFile = 'SDSVALPD'                                        LUC134
     C                   Eval      DBase = 901                                                LUC134
     C                   Select                                                               LUC134
     C                   When      %SUBST(PCurSet01:1:1) = '*NRF'                             LUC134
     C                   Eval      DBKey = PSysVal01                                          LUC134
     C                   Endsl                                                                LUC134
     C                   Out       LDA                                                        LUC134
     C                   ExSR      *PSSR                                                      LUC134
     C                   EndIf                                                                LUC134
                                                                                              LUC134
      * Setup ITIPSV                                                                          LUC134
     C                   MOVEL     PCurSet01     ITIPSV            1                          LUC134
      *                                                                                       LUC134
      ** Allow deal types TD and TI for Bank Customers                                        LUC134
     C                   CALLB     'AOSVALR0'                                                 LUC134
     C                   PARM      *BLANKS       PRtCd             7                          LUC134
     C                   PARM      PSysVal2      PSysVal01                                    LUC134
     C                   PARM                    PCurSet01                                    LUC134
     C                   PARM                    PSysVal02                                    LUC134
     C                   PARM                    PCurSet02                                    LUC134
     C                   PARM                    PSysVal03                                    LUC134
     C                   PARM                    PCurSet03                                    LUC134
     C                   PARM                    PSysVal04                                    LUC134
     C                   PARM                    PCurSet04                                    LUC134
     C                   PARM                    PSysVal05                                    LUC134
     C                   PARM                    PCurSet05                                    LUC134
     C                   PARM                    PSysVal06                                    LUC134
     C                   PARM                    PCurSet06                                    LUC134
     C                   PARM                    PSysVal07                                    LUC134
     C                   PARM                    PCurSet07                                    LUC134
     C                   PARM                    PSysVal08                                    LUC134
     C                   PARM                    PCurSet08                                    LUC134
     C                   PARM                    PSysVal09                                    LUC134
     C                   PARM                    PCurSet09                                    LUC134
     C                   PARM                    PSysVal10                                    LUC134
     C                   PARM                    PCurSet10                                    LUC134
                                                                                              LUC134
     C                   If        PRtCd <> *Blanks                                           LUC134
     C     *LOCK         In        LDA                                                        LUC134
     C                   Eval      DBFile = 'SDSVALPD'                                        LUC134
     C                   Eval      DBase = 902                                                LUC134
     C                   Select                                                               LUC134
     C                   When      %SUBST(PCurSet01:1:1) = '*NRF'                             LUC134
     C                   Eval      DBKey = PSysVal01                                          LUC134
     C                   Endsl                                                                LUC134
     C                   Out       LDA                                                        LUC134
     C                   ExSR      *PSSR                                                      LUC134
     C                   EndIf                                                                LUC134
                                                                                              LUC134
      * Setup TDTISV                                                                          LUC134
     C                   MOVEL     PCurSet01     TDTISV            1                          LUC134
     C                   else                                                                 LUC134
     C                   Movel     'N'           ITIPSV                                       LUC134
     C                   Movel     'N'           TDTISV                                       LUC134
     C                   Endif                                                                LUC134
      *
      *****************************************************************
      * End of /COPY LUC134_006                                       *
      *****************************************************************
