      *****************************************************************
      *                                                               *
      *  Midas GENERAL LEDGER MODULE                                  *
      *                                                               *
      *  LUC108_007 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC108  *CREATE    DATE 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      *
     C     LUC108        IFEQ      'Y'                                                        LUC108
0749 C   41                                                                                   LUC108
     COR 43LINCNT        COMP      22                                 45                      LUC108
     C   40LINCNT        COMP      22                                 45                      LUC108
     C   42LINCNT        COMP      22                                 45                      LUC108
     C   44LINCNT        COMP      22                                 45                      LUC108
     C                   ELSE                                                                 LUC108
      *
      *****************************************************************
      * End of /COPY LUC108_007                                       *
      *****************************************************************
