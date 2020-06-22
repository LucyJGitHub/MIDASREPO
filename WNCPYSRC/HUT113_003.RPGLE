      *****************************************************************
      * Start of /COPY HUT113_003                                     *
      *****************************************************************
      *                                                               *
      *  PMPFDM2RV                                                    *
      *                                                               *
      *  Last Amend No. HUT113    *CREATE  Date 01Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Full Private Banking Functionality in Midas         *
      *           Upgrade HUT026 to FBM 2.1 SP 22                     *
      *           Allow Portfolio Definitions Input in Midas          *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT113
      ** Access SAR file to determine if HUT113 is installed.
      *
     C                   Call      'AOSARDR0'                                                 HUT113
     C                   Parm      *BLANKS       PRtcd             7                          HUT113
     C                   Parm      '*VERIFY'     POptn             7                          HUT113
     C                   Parm      'HUT113'      PSard             6                          HUT113
     C                   Parm                    DSFDY                                        HUT113
      *
     C                   Select                                                               HUT113
     C                   When      PRtcd=*BLANKS                                              HUT113
     C                   Move      'Y'           HUT113            1                          HUT113
      *                                                                                       HUT113
     C                   When      PRtcd='*NRF   '                                            HUT113
     C                   Move      'N'           HUT113                                       HUT113
      *
     C                   Other                                                                HUT113
     C                   Eval      DBKEY =  PSard                                             HUT113
     C                   Eval      DBFILE = 'SCSARDPD'                                        HUT113
     C                   Eval      DBASE =  900                                               HUT113
     C                   Exsr      *PSSR                                                      HUT113
     C                   EndSl                                                                HUT113
      *                                                                                       HUT113
      *****************************************************************
      * End of /COPY HUT113_003                                       *
      *****************************************************************
