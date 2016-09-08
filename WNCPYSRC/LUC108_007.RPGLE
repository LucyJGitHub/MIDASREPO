      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  LUC108_007 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC108  *CREATE    Date 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      *
     C     LUC108        IFEQ      'Y'
0749 C   41
     COR 43LINCNT        COMP      22                                 45
     C   40LINCNT        COMP      22                                 45
     C   42LINCNT        COMP      22                                 45
     C   44LINCNT        COMP      22                                 45
     C                   ELSE
      *
      *****************************************************************
      * End of /COPY LUC108_007                                       *
      *****************************************************************
