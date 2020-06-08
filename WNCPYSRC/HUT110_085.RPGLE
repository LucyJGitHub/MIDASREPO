      *****************************************************************                       HUT110
      *                                                               *                       HUT110
      *  Midas - /COPY Member FTVXVXV                                 *                       HUT110
      *                                                               *                       HUT110
      *  FTVXVXV - Midas FT Validate cross-validations                *                       HUT110
      *                                                               *                       HUT110
      *  Last Amend No. HUT110  *CREATE    Date 21Apr20               *                       HUT110
      *                                                               *                       HUT110
      *---------------------------------------------------------------*                       HUT110
      *                                                               *                       HUT110
      *  HUT110 - Upgraded HUT022 to FBM 2.1 SP22                     *                       HUT110
      *           RTGS via SWIFT.                                     *                       HUT110
      *                                                               *                       HUT110
      *****************************************************************                       HUT110
      *                                                                                       HUT110
      ** Access SCSARDPD to determine if HUT110 is installed                                  HUT110
      *                                                                                       HUT110
     C                   EVAL      HUT110 = 'N'                                               HUT110
     C                   CALLB     'AOSARDR0'                                                 HUT110
     C                   PARM      *BLANKS       PRTCD                                        HUT110
     C                   PARM      '*VERIFY'     POPTN                                        HUT110
     C                   PARM      'HUT110'      PSARD                                        HUT110
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT110
      *                                                                                       HUT110
      ** NRF (No Record Found) return code is valid.                                          HUT110
      ** Issue database error only for error return codes.                                    HUT110
      *                                                                                       HUT110
     C                   IF        PRTCD <> *BLANKS AND                                       HUT110
     C                             PRTCD <> '*NRF   '                                         HUT110
     C                   EVAL      DBFILE = 'SCSARDPD'                                        HUT110
     C                   EVAL      DBASE = 10                                                 HUT110
     C                   EVAL      DBKEY = 'HUT110'                                           HUT110
     C                   EXSR      *PSSR                                                      HUT110
     C                   ENDIF                                                                HUT110
      *                                                                                       HUT110
     C                   IF        PRTCD = *BLANKS                                            HUT110
     C                   EVAL      HUT110 = 'Y'                                               HUT110
      *                                                                                       HUT110
      ** Retrieve system value 'RTGS_Nostro'                                                  HUT110
      *                                                                                       HUT110
     C                   CALLB     'AOSVALR0'                                                 HUT110
     C                   PARM      *BLANKS       PRtnCode          7                          HUT110
     C                   PARM      RTGSNostro    PSysVal01        20                          HUT110
     C                   PARM                    PCurSet01       200                          HUT110
     C                   PARM                    PSysVal02        20                          HUT110
     C                   PARM                    PCurSet02       200                          HUT110
     C                   PARM                    PSysVal03        20                          HUT110
     C                   PARM                    PCurSet03       200                          HUT110
     C                   PARM                    PSysVal04        20                          HUT110
     C                   PARM                    PCurSet04       200                          HUT110
     C                   PARM                    PSysVal05        20                          HUT110
     C                   PARM                    PCurSet05       200                          HUT110
     C                   PARM                    PSysVal06        20                          HUT110
     C                   PARM                    PCurSet06       200                          HUT110
     C                   PARM                    PSysVal07        20                          HUT110
     C                   PARM                    PCurSet07       200                          HUT110
     C                   PARM                    PSysVal08        20                          HUT110
     C                   PARM                    PCurSet08       200                          HUT110
     C                   PARM                    PSysVal09        20                          HUT110
     C                   PARM                    PCurSet09       200                          HUT110
     C                   PARM                    PSysVal10        20                          HUT110
     C                   PARM                    PCurSet10       200                          HUT110
      *                                                                                       HUT110
     C                   EVAL      WRTGSNost = %subst(PCurSet01:1:100)                        HUT110
     C                   ENDIF                                                                HUT110
      *                                                                                       HUT110
      *****************************************************************                       HUT110
      * End of /COPY HUT110_085                                       *                       HUT110
      *****************************************************************                       HUT110
