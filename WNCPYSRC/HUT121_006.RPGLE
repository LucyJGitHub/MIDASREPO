      *****************************************************************
      *                                                               *
      *  HUT121_006 - Midas /COPY for GPPRICED                        *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 07Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT121
O    FXGZPRICEL1UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)              HUT121
O    F                                     RENAME(PRICEDF     :X_PRICEDF      )               HUT121
O    F                                     USROPN                                             HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_006                                       *
      *****************************************************************
