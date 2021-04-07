      *****************************************************************
      *  Start of /COPY HUT107_009                                    *
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
      *                                                                                  HUT107
     C                   Call      'AOSARDR0'                                            HUT107
     C                   Parm      *BLANKS       WRTCD             7                     HUT107
     C                   Parm      '*VERIFY'     WOPTN             7                     HUT107
     C                   Parm      'HUT107'      WSARD             6                     HUT107
     C     SCSARD        Parm      SCSARD        DSFDY                                   HUT107
                                                                                         HUT107
     C     WRTCD         Ifeq      *BLANKS                                               HUT107
     C                   Movel     'Y'           HUT107            1                     HUT107
     C                   Move      *On           *In30                                   HUT107
     C                   else                                                            HUT107
     C                   Movel     'N'           HUT107            1                     HUT107
     C                   Move      *Off          *In30                                   HUT107
     C                   Endif                                                           HUT107
      *****************************************************************
      * End of /COPY HUT107_009                                       *
      *****************************************************************
