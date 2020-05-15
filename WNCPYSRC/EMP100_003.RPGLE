      *****************************************************************
      *  Start of /COPY EMP100_003                                    *
      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GOSETLOAN - Define variables                                 *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. EMP100   *Create   Date 16Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EMP100 - ML Date Adjustment                                  *
      *                                                               *
      *****************************************************************
      *                                                                                  EMP100
      ** Check for feature EMP100                                                        EMP100
      *                                                                                  EMP100
     C                   Call      'AOSARDR0'                                            EMP100
     C                   Parm      *BLANKS       WRTCD             7                     EMP100
     C                   Parm      '*VERIFY'     WOPTN             7                     EMP100
     C                   Parm      'EMP100'      WSARD             6                     EMP100
     C     SCSARD        Parm      SCSARD        DSFDY                                   EMP100
                                                                                         EMP100
     C     WRTCD         Ifeq      *BLANKS                                               EMP100
      *                                                                                  EMP100
     C                   Movel     'Y'           EMP100                                  EMP100
      *                                                                                  EMP100
     C                   Call      'AOBANKR0'                                            EMP100
     C                   Parm      *BLANK        WRtcd                                   EMP100
     C                   Parm      '*FIRST '     WOptn                                   EMP100
     C     SDBANK        Parm      SDBANK        DSFDY                                   EMP100
      *                                                                                  EMP100
      ** Get Max End Date                                                                EMP100
     C                   EVAL      PSysValK1 = WEMP100                                   EMP100
     C                   CALL      'AOSVALR0'                                            EMP100
     C                   PARM      *BLANKS       PRetCode                                EMP100
     C                   PARM                    PSysValK1                               EMP100
     C                   PARM                    PSysVal1                                EMP100
     C                   PARM                    PSysValK2                               EMP100
     C                   PARM                    PSysVal2                                EMP100
     C                   PARM                    PSysValK3                               EMP100
     C                   PARM                    PSysVal3                                EMP100
     C                   PARM                    PSysValK4                               EMP100
     C                   PARM                    PSysVal4                                EMP100
     C                   PARM                    PSysValK5                               EMP100
     C                   PARM                    PSysVal5                                EMP100
     C                   PARM                    PSysValK6                               EMP100
     C                   PARM                    PSysVal6                                EMP100
     C                   PARM                    PSysValK7                               EMP100
     C                   PARM                    PSysVal7                                EMP100
     C                   PARM                    PSysValK8                               EMP100
     C                   PARM                    PSysVal8                                EMP100
     C                   PARM                    PSysValK9                               EMP100
     C                   PARM                    PSysVal9                                EMP100
     C                   PARM                    PSysValK10                              EMP100
     C                   PARM                    PSysVal10                               EMP100
      *                                                                                  EMP100
     C                   If        PRetCode <> *BLANKS                                   EMP100
     C     *LOCK         IN        LDA                                                   EMP100
     C                   Eval      DBFILE =  'SDSVALPD'                                  EMP100
     C                   Eval      DBKEY  =  PSysValK1                                   EMP100
     C                   Eval      DBASE  =  900                                         EMP100
     C                   Out       LDA                                                   EMP100
     C                   Exsr      *PSSR                                                 EMP100
     C                   Endif                                                           EMP100
      *                                                                                  EMP100
     C                   Z-Add     0             DateIn                                  EMP100
     C                   Z-Add     0             DayNoOut                                EMP100
     C                   Movel     PSysVal1      DateIn                                  EMP100
                                                                                         EMP100
     C                   Call      'ZDATE1'                             90               EMP100
     C                   Parm      *Blanks       WRtcd                                   EMP100
     C                   Parm                    DateIn                                  EMP100
     C                   Parm                    Wudff                                   EMP100
     C                   Parm                    DayNoOut                                EMP100
      *                                                                                  EMP100
     C                   If        WRtcd <> '*ERROR'                                     EMP100
     C                   Z-Add     DayNoOut      MaxEndDate                              EMP100
     C                   Endif                                                           EMP100
      *                                                                                  EMP100
     C                   Else                                                            EMP100
     C                   Movel     'N'           EMP100                                  EMP100
     C                   Endif                                                           EMP100
      *                                                                                  EMP100
      *****************************************************************
      *  End of /COPY EMP100_003                                      *
      *****************************************************************
