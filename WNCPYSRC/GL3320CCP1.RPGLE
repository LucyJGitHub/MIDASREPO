      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL3320 - ACCOUNT BALANCES EXTRACT                            *
      *                                                               *
      *  (c) COPYRIGHT Midas-KAPITI International Ltd. 1996           *
      *                                                               *
      *  Last Amend No. LUC140             Date 23Feb21               *
      *  Prev Amend No. MMI013  *Create    DATE 10MAR98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC140 - Upgrade MMI013 to FM2.1                             *
      *  MMI013 - Retail Stamp Duty and Account charges               *
      *                                                               *
      *****************************************************************
      *                                                                                       UIT018
      ***  Access SCSARDPD to know if MMI013 feature is present                               MMI013
      *                                                                                       MMI013
     C                   CALL      'AOSARDR0'                                                 LUC140
     C                   PARM      *BLANKS       PRTCD                                        LUC140
     C                   PARM      '*VERIFY'     POPTN                                        LUC140
     C                   PARM      'LUC140'      PSARD                                        LUC140
     C     SCSARD        PARM      SCSARD        DSFDY                                        LUC140
      *                                                                                       LUC140
     C     PRTCD         IFEQ      *BLANKS                                                    LUC140
     C                   MOVEL     'Y'           LUC140            1                          LUC140
     C                   else                                                                 LUC140
     C                   MOVEL     'N'           LUC140                                       LUC140
     C                   ENDIF                                                                LUC140
      *****************************************************************
      * End of /COPY GL3320CCP1                                       *
      *****************************************************************
