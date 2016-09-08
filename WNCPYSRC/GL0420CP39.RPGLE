      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420CP39 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC107   *CREATE   Date 21Dec15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC107 - Statement Page Number Enhancement                   *
      *                                                               *
      *****************************************************************
     C     LUC107        IFEQ      'Y'
     C                   SUB       1             LINCNT
     C     STPP          COMP      1                                      48
     C     LINCNT        ADD       1             LINCNT
     C  N48LINCNT        COMP      1                                      50
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL0420CP39                                       *
      *****************************************************************
