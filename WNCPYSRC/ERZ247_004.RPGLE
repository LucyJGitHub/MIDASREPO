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
     C                             Or (SADDC = 'D' And ERZ247 = 'Y'                           ERZ247
     C                             And SDTCH = 'SHA')                                         ERZ247
      *                                                                                       ERZ247
     C                   If        ERZ247 = 'Y' And SDTCH = 'SHA'                             ERZ247
     C                   Move(P)   '0'           SSCH1                                        ERZ247
     C                   Move      SPCCY         SSCC1                                        ERZ247
     C                   Else                                                                 ERZ247
