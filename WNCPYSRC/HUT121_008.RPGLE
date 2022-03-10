      *****************************************************************
      *                                                               *
      *  HUT121_008 - Midas /COPY for GPPRICED                        *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 07Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT121
O    C     X_GZPRICEL1   KLIST                                                                HUT121
O    C                   KFLD                    SEZONE                                       HUT121
O    C                   KFLD                    PSSN                                         HUT121
O    C                   KFLD                    PCNM                                         HUT121
O    C                   KFLD                    PMKT                                         HUT121
O    C                   KFLD                    PBRA                                         HUT121
O    C                   KFLD                    PBOK                                         HUT121
O    C                   KFLD                    PPRT                                         HUT121
O    C                   KFLD                    PTFR                                         HUT121
     C                   KFLD                    PVDT                                         HUT121
      *                                                                                       HUT121
      ** Check if HUT121 is installed                                                         HUT121
      *                                                                                       HUT121
     C                   CALL      'AOSARDR0'                                                 HUT121
     C                   PARM      *BLANKS       PRTCD                                        HUT121
     C                   PARM      '*VERIFY'     POPTN                                        HUT121
     C                   PARM      'HUT121'      PSARD                                        HUT121
                                                                                              HUT121
     C                   IF        PRTCD = *BLANKS                                            HUT121
     C                   MOVE      'Y'           HUT121                                       HUT121
     C                   ELSE                                                                 HUT121
     C                   MOVE      'N'           HUT121                                       HUT121
     C                   ENDIF                                                                HUT121
                                                                                              HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_008                                       *
      *****************************************************************
