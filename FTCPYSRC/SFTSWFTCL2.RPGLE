     C/EJECT
      *****************************************************************
      *                                                               *
      *  SFTSWFTCL2: Validate SWIFT Address                           *
      *              Allowable characters are A-Z, 0-9                *
      *                                                               *
      *  CALLED BY:        -                                          *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *  Last Amend No. HUT106I03          Date 06Mar20               *
      *  Prev Amend No. HUT106 *CREATE     Date 06Mar20               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT106I03 - Conflict with CFT129                             *
      *  HUT106 - Upgrade HUT012 to FBM 2.1 SP22                      *
      *           Allow FISC Bank Reference to be entered in SWIFT ID *
      *           Field                                               *
      *                                                               *
      *****************************************************************
     C     SWIFT2        BEGSR                                                                HUT106
      *                                                                                       HUT106
     C                   MOVE      ' '           FISCRF            1                          HUT106
      *                                                                                       HUT106
     C                   if        HUT106 = 'Y'                                               HUT106
     C     ' '           CHECKR    SDST1         #POS              2 0                        HUT106
      *                                                                                       HUT106
     C                   ADD       1             #POS                                         HUT106
      *                                                                                       HUT106
     C                   if        #POS = 8                                                   HUT106
      *                                                                                       HUT106
      ** Check if the SWIFT ID has numeric characters                                         HUT106
      *                                                                                       HUT106
     C                   MOVE      *BLANKS       WKFWCA                                       HUT106
     C**********         MOVE      SDST1         WKFWCA                             HUT106 HUT106I03
     C                   MOVEL     SDST1         WKFWCA                                    HUT106I03
      *                                                                                       HUT106
     C                   CALL      'ZALIGN'                                                   HUT106
     C                   PARM                    @RTCD             7                          HUT106
     C                   PARM                    WKFWCA           16                          HUT106
     C                   PARM      *ZERO         DECIMA            1 0                        HUT106
     C                   PARM      7             #DIGITS           2 0                        HUT106
     C                   PARM      *BLANK        WKFWCD           16                          HUT106
      *                                                                                       HUT106
      ** If @RTCD <> *BLANKS the SWIFT ID contains non-numeric character(s)                   HUT106
      *                                                                                       HUT106
     C                   if        @RTCD = *BLANKS                                            HUT106
     C                             and SPCCY = 'TWD'                                          HUT106
     C                   MOVE      '1'           FISCRF                                       HUT106
     C                   Goto      EXSWFT2                                                    HUT106
     C                   endIF                                                                HUT106
      *                                                                                       HUT106
     C                   endIF                                                                HUT106
      *                                                                                       HUT106
     C                   endIF                                                                HUT106
                                                                                              HUT106
     C                   Movea     '00'          *IN(31)                                      HUT106
                                                                                              HUT106
      *  Test positions 1-8 for valid SWIFT Characters                                        HUT106
                                                                                              HUT106
      *  Check how many characters are alphanumeric                                           HUT106
     C                   Movel     *Blanks       FLD                                          HUT106
     C                   Movel     CLSWTK        FLD              35                          HUT106
     C     ALPHAN        Check     FLD           X#                3 0    90                  HUT106
                                                                                              HUT106
      * If the first 8 or 11 are ok proceed                                                   HUT106
     C                   If        *IN90 = *On and                                            HUT106
     C                             X# = 9      or                                             HUT106
     C                             *IN90 = *On and                                            HUT106
     C                             X# = 12                                                    HUT106
     C     ' '           Check     FLD:X#                                 90                  HUT106
                                                                                              HUT106
      * Check for blanks if before 8 or 11 then assume address                                HUT106
     C                   If        *IN90 = *On and                                            HUT106
     C                             X# = 11                                                    HUT106
     C                   Eval      *IN31 = *On                                                HUT106
     C                   Eval      ##CSID = 'Y'                                               HUT106
     C                   Goto      EXSWFT2                                                    HUT106
     C                   End                                                                  HUT106
     C                   End                                                                  HUT106
                                                                                              HUT106
      *  Invalid format - Not a S.W.I.F.T.                                                    HUT106
     C                   If        *IN90 = *On                                                HUT106
     C                   Eval      ##CSID = 'N'                                               HUT106
     C                   Goto      EXSWFT2                                                    HUT106
     C                   End                                                                  HUT106
                                                                                              HUT106
      *  Call Access object to validate identifier                                            HUT106
     C                   Movel     FLD           W9BICC                                       HUT106
     C     3             Subst     FLD:9         W9BICB                                       HUT106
                                                                                              HUT106
     C                   CALL      'ME1400'                                                   HUT106
     C                   Parm      *Blanks       W9RTN             7                          HUT106
     C                   Parm                    W9BICC            8                          HUT106
     C                   Parm                    W9BICB            3                          HUT106
     C                   Parm                    SDCUST                                       HUT106
     C                   Parm                    SDCNST                                       HUT106
     C                   Parm                    MEBICD                                       HUT106
     C                   Parm      *Blanks       W9CUST            1                          HUT106
     C                   Parm      *Blanks       W9CNST            1                          HUT106
     C                   Parm      *Blanks       W9BICD            1                          HUT106
                                                                                              HUT106
     C                   Select                                                               HUT106
                                                                                              HUT106
      *  Record not found on directory but found on others                                    HUT106
      *  - BIC directory has data so error                                                    HUT106
     C                   When      W9RTN = 'MIN0244' or                                       HUT106
     C                             W9RTN = 'MIN0245' or                                       HUT106
     C                             W9RTN = 'MIN0246'                                          HUT106
     C                   Eval      *IN31 = *On                                                HUT106
     C                   Eval      ##CSID = 'Y'                                               HUT106
                                                                                              HUT106
      *  Record not found - S.W.I.F.T does not exist                                          HUT106
     C                   When      W9RTN = 'Y2U0005'                                          HUT106
     C                   Eval      *IN32 = *On                                                HUT106
     C                   Eval      ##CSID = 'Y'                                               HUT106
                                                                                              HUT106
      *  Record found - BIC exists                                                            HUT106
     C                   When      W9RTN = *Blanks                                            HUT106
     C                   Eval      ##CSID = 'Y'                                               HUT106
                                                                                              HUT106
     C                   End                                                                  HUT106
                                                                                              HUT106
     CSR   EXSWFT2       ENDSR                                                                HUT106
