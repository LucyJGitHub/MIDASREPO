      *****************************************************************
      *  Start of /COPY GL0600FFP1                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. LUC110  *Create    Date 24Jan19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *                                                               *
      *****************************************************************
      *                                                                             LUC110
     FSACPOX    IF   F  145    39AIDISK                                             LUC110
      *  RTV: Sorted Account Postings Extension file                                LUC110
      *                                                                             LUC110
     FXXCLEAX0  O    F  145        DISK    EXTIND(*INU5)                            LUC110
     F                                     COMMIT                                   LUC110
      *  OUT: Items-in-Clearing Extension file                                      LUC110
      *                                                                             LUC110
      *****************************************************************
      *  End of /COPY GL0600FFP1                                      *
      *****************************************************************
