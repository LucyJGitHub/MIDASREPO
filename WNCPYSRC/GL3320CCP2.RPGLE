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
      *
     C     LUC140        IFEQ      'Y'                                          LUC140
      *                                                                         LUC140
      ***  Define Keylist                                                       LUC140
      *                                                                         LUC140
     C     KEYSDC        KLIST                                                  LUC140
     C                   KFLD                    #PCUST            6            LUC140
     C                   KFLD                    #PACCY            3            LUC140
     C                   KFLD                    #PACOD           10 0          LUC140
     C                   KFLD                    #PACSQ            2 0          LUC140
     C                   KFLD                    #PBRCA            3            LUC140
      *                                                                         LUC140
      ***  Fill Access key                                                      LUC140
      *                                                                         LUC140
     C                   Move      BRCA          #PBRCA                         LUC140
     C                   Move      CNUM          #PCUST                         LUC140
     C                   Move      CCY           #PACCY                         LUC140
     C                   Move      ACOD          #PACOD                         LUC140
     C                   Move      ACSQ          #PACSQ                         LUC140
      *                                                                         LUC140
      ***  delete extended record if record found                               LUC140
      *                                                                         LUC140
     C     KEYSDC        CHAIN     XXMSTDY0                           43        LUC140
     C     *IN43         IFEQ      *OFF                                         LUC140
     C                   DELETE    SDMSTDD0                                     LUC140
     C                   ENDIF                                                  LUC140
      *                                                                         LUC140
     C                   ENDIF                                                  LUC140
      *
      *****************************************************************
      * End of /COPY GL3320CCP2                                       *
      *****************************************************************
