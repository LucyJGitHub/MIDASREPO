      *****************************************************************
      *  Start of /COPY HUT107_010                                    *
      *****************************************************************
      *                                                               *
      *  RE005010P  - RE WHT Daily report                             *
      *                                                               *
      *  Last Amend No. HUT107    *Create  Date 27May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT107 - Additional 3rd Party Trust Indicator                *
      *           (Upgrade HUT016 to FM2.1 SP22)                      *
      *                                                               *
      *****************************************************************
     C     HUT107        Ifeq      'Y'                                                   HUT107
     C                   Open      UTRACCTDM                                             HUT107
     C     CNUM          Setll     UTRACCTDM                              11             HUT107
     C     *IN11         Ifeq      *On                                                   HUT107
     C                   move      'Y'           XTrust                                  HUT107
     C                   else                                                            HUT107
     C                   move      *Blanks       XTrust                                  HUT107
     C                   Endif                                                           HUT107
     C                   Close     UTRACCTDM                                             HUT107
     C                   Endif                                                           HUT107
      *****************************************************************
      * End of /COPY HUT107_010                                       *
      *****************************************************************
