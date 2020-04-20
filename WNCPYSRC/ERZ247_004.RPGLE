      *****************************************************************
      *                                                               *
      *  FTVSCHG   - Validate OP Sender's Charges                     *
      *                                                               *
      *  Last Amend No. MD055398A          Date 27Feb20               *
      *  Prev Amend No. ERZ247  *CREATE    Date 22Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055398A-Duplicate 0.00 (ERZ247)                            *
      *  ERZ247 - Field 71F in MT103 for GPI                          *
      *                                                               *
      *****************************************************************
     C                             Or (SADDC = 'D' And ERZ247 = 'Y'                           ERZ247
     C                             And SDTCH = 'SHA')                                         ERZ247
      *                                                                                       ERZ247
     C                   If        ERZ247 = 'Y' And SDTCH = 'SHA'                             ERZ247
     C                   Move(P)   '0'           SSCH1                                        ERZ247
     C                   Move      SPCCY         SSCC1                                        ERZ247
     C                   Move      'Y'           WALREADY                            ERZ247MD055398A
     C                   Else                                                                 ERZ247
