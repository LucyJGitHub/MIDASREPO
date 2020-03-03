      *****************************************************************
      *                                                               *
      *  FTVSCHG   - Validate OP Sender's Charges                     *
      *                                                               *
      *  Last Amend No. ERZ247  *CREATE    Date 22Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ247 - Field 71F in MT103 for GPI                          *
      *                                                               *
      *****************************************************************
      *
      */OMITEND                                                                             ERZ247
     C                   If        (WLAST <> WTOTCH And ERZ247='N')                         ERZ247
     C                             Or (WLAST <> WTOTCH And SDTCH <> 'SHA'                   ERZ247
     C                             And ERZ247='Y')                                          ERZ247
     C                             Or (WLAST <> WTOTCH And WLAST <> 0 And                   ERZ247
     C                             SDTCH = 'SHA' And ERZ247='Y')                            ERZ247
