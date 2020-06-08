     C/EJECT
      *****************************************************************
      *                                                               *
      *  SWIFT    : Validate SWIFT Address                            *
      *             Allowable characters are A-Z, 0-9                 *
      *                                                               *
      *  CALLED BY:        -                                          *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *  Last Ament No. HUT106I03          Date 06Mar20               *
      *  Prev Ament No. HUT106 *CREATE     Date 06Mar20               *
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
     C     SWIFT2        BEGSR
      *
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

     C                   Movea     '00'          *IN(31)

      *  Test positions 1-8 for valid SWIFT Characters

      *  Check how many characters are alphanumeric
     C                   Movel     *Blanks       FLD
     C                   Movel     CLSWTK        FLD              35
     C     ALPHAN        Check     FLD           X#                3 0    90

      * If the first 8 or 11 are ok proceed
     C                   If        *IN90 = *On and
     C                             X# = 9      or
     C                             *IN90 = *On and
     C                             X# = 12
     C     ' '           Check     FLD:X#                                 90

      * Check for blanks if before 8 or 11 then assume address
     C                   If        *IN90 = *On and
     C                             X# = 11
     C                   Eval      *IN31 = *On
     C                   Eval      ##CSID = 'Y'
     C                   Goto      EXSWFT2
     C                   End
     C                   End

      *  Invalid format - Not a S.W.I.F.T.
     C                   If        *IN90 = *On
     C                   Eval      ##CSID = 'N'
     C                   Goto      EXSWFT2
     C                   End

      *  Call Access object to validate identifier
     C                   Movel     FLD           W9BICC
     C     3             Subst     FLD:9         W9BICB

     C                   CALL      'ME1400'
     C                   Parm      *Blanks       W9RTN             7
     C                   Parm                    W9BICC            8
     C                   Parm                    W9BICB            3
     C                   Parm                    SDCUST
     C                   Parm                    SDCNST
     C                   Parm                    MEBICD
     C                   Parm      *Blanks       W9CUST            1
     C                   Parm      *Blanks       W9CNST            1
     C                   Parm      *Blanks       W9BICD            1

     C                   Select

      *  Record not found on directory but found on others
      *  - BIC directory has data so error
     C                   When      W9RTN = 'MIN0244' or
     C                             W9RTN = 'MIN0245' or
     C                             W9RTN = 'MIN0246'
     C                   Eval      *IN31 = *On
     C                   Eval      ##CSID = 'Y'

      *  Record not found - S.W.I.F.T does not exist
     C                   When      W9RTN = 'Y2U0005'
     C                   Eval      *IN32 = *On
     C                   Eval      ##CSID = 'Y'

      *  Record found - BIC exists
     C                   When      W9RTN = *Blanks
     C                   Eval      ##CSID = 'Y'

     C                   End

     CSR   EXSWFT2       ENDSR
