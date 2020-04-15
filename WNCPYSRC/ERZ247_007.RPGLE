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
      */OMITEND                                                                               ERZ247
     C                   If        (@PDAM = *Zero And SPYTP <> 'RP'                           ERZ247
     C                             and @@AMT <> 0                                             ERZ247
     C                             and ERZ247='N')                                            ERZ247
     C                             or (@PDAM = *Zero And SPYTP <> 'RP'                        ERZ247
     C                             and @@AMT <> 0 and SDTCH <> 'SHA'                          ERZ247
     C                             and ERZ247='Y')                                            ERZ247
