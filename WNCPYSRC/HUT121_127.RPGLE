      *****************************************************************
      *                                                               *
      *  HUT121_127 - Midas /COPY for SEVVLDT01                       *
      *                                                               *
      *  Last Amend No. HUT121C            Date 28Apr22               *
      *  Prev Amend No. HUT121A            Date 25Mar22               *
      *                 HUT121  *CREATE    Date 09Mar22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121C - Further changes to ensure only 1 working day Price *
      *            exists on PRICED and '*' record is updated if any  *
      *  HUT121A - Do JNSTAT processing regardless of feature ON/OFF  *
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
                                                                                             HUT121C
      ***  Access bank details                                                               HUT121C
      *                                                                                      HUT121C
     C                   CALLB     'AOBANKR0'                                                HUT121C
     C                   PARM      *BLANKS       PRTCD                                       HUT121C
     C                   PARM      '*FIRST '     POPTN                                       HUT121C
     C     SDBANK        PARM      SDBANK        DSFDY                                       HUT121C
      *                                                                                      HUT121C
      ***  Database error                                                                    HUT121C
      *                                                                                      HUT121C
     C     PRTCD         IFNE      *BLANKS                                                   HUT121C
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************HUT121C
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *HUT121C
     C                   MOVEL     POPTN         DBKEY                          *************HUT121C
     C                   EXSR      *PSSR                                                     HUT121C
     C                   END                                                                 HUT121C
                                                                                             HUT121C
     C                   Move      'N'           HUT121            1                          HUT121
     C                   CALLB     'AOSARDR0'                                                 HUT121
     C                   PARM      *BLANKS       PRtCd                                        HUT121
     C                   PARM      '*VERIFY'     POptn                                        HUT121
     C                   PARM      'HUT121'      PSard                                        HUT121
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT121
     C                   IF        PRtCd = *Blanks                                            HUT121
     C                   Eval      HUT121 = 'Y'                                               HUT121
     C**********         IN        JNSTAT                                             HUT121 HUT121A
     C                   Endif                                                                HUT121
     C                   IN        JNSTAT                                                    HUT121A
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_127                                       *
      *****************************************************************
