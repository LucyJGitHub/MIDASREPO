      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (MG000940)                              *
      *                                                               *
      *  MGH00031 - Midas MG MT940 Message Generation                 *
      *                                                               *
      *  Last Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
     C                   MOVEL     'N'           UUC103            1            UUC103
     C                   CALLB     'AOSARDR0'                                   UUC103
     C                   PARM      *BLANKS       P@RTCD                         UUC103
     C                   PARM      '*VERIFY'     P@OPTN                         UUC103
     C                   PARM      'UUC103 '     PSard                          UUC103
     C     SCSARD        PARM      SCSARD        DSFDY                          UUC103
                                                                                UUC103
     C                   IF        P@RTCD = *BLANKS                             UUC103
     C                   MOVEL     'Y'           UUC103            1            UUC103
     C                   ENDIF                                                  UUC103
                                                                                UUC103
