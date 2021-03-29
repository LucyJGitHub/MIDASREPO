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
     C                             or ((WSCHG = *Blank) And (SDTCH = 'SHA')                   ERZ247
     C                             And (@MT103='Y') And (ERZ247='Y'))                         ERZ247
