      *****************************************************************                       HUT109
      *                                                               *                       HUT109
      *  Midas - /COPY Member SDAUTHFNC                               *                       HUT109
      *                                                               *                       HUT109
      *  SDH00560 - Midas SD Standing Data Authorisation Function     *                       HUT109
      *                                                               *                       HUT109
      *  Last Amend No. HUT109  *CREATE    Date 15Apr20               *                       HUT109
      *                                                               *                       HUT109
      *---------------------------------------------------------------*                       HUT109
      *                                                               *                       HUT109
      *  HUT109 - Partial upgrade of HUT020 to FBM 2.1 SP22.          *                       HUT109
      *           Additional Authorisation Steps in SE Module         *                       HUT109
      *                                                               *                       HUT109
      *****************************************************************                       HUT109
      *                                                                                       HUT109
     C                   WHEN      DDFUNC = 'SE STD SETTLEMNT INST'                           HUT109
     C                   CALLB     'XXSSIPAUT'                                                HUT109
     C                   PARM      *BLANKS       RETCODE                                      HUT109
     C                   PARM                    DDKEY                                        HUT109
     C                   PARM                    DDOPTN                                       HUT109
     C                   PARM      *BLANKS       ERRMSG                                       HUT109
     C                   PARM                    MSGF             10                          HUT109
     C                   PARM                    @INKC                                        HUT109
      *                                                                                       HUT109
      *****************************************************************                       HUT109
      * End of /COPY SDH00560                                         *                       HUT109
      *****************************************************************                       HUT109
