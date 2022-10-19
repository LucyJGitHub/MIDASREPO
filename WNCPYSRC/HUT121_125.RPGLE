      *****************************************************************
      *                                                               *
      *  HUT121_125 - Midas /COPY for SEVVLDT01                       *
      *                                                               *
      *  Last Amend No. HUT121C            Date 05May22               *
      *  Prev Amend No. HUT121  *CREATE    Date 09Mar22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121C - Changes to allow SE Price Input for Non-working day*
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
     C     ZDAYNO        Ifle      PRUN                                                       HUT121
     C     HUT121        Andeq     'Y'                                                        HUT121
     C     ZDAYNO        OrEq      WRunday                                                   HUT121C
     C     HUT121        Andeq     'Y'                                                       HUT121C
     C                   Move      ' '           ZIND              1                         HUT121C
     C                   Move      ' '           WorkPrice         1                         HUT121C
      *                                                                                      HUT121C
      ** Check if there is an existing live PRICE                                            HUT121C
      *                                                                                      HUT121C
     C     @PRICK        SETLL     XXPRICEL1                                                 HUT121C
     C     @PRICK        READE     XXPRICEL1                              99                 HUT121C
     C     *IN99         DowEQ     '0'                                                       HUT121C
                                                                                             HUT121C
     C                   If        XXPVDT = WRunday                                          HUT121C
     C                   Eval      *IN99 = '1'                                               HUT121C
     C                   Eval      WorkPrice = 'Y'                                           HUT121C
     C                   Else                                                                HUT121C
     C                   CALLB     'ZCHKH'                                                   HUT121C
     C                   PARM                    XXPVDT                                      HUT121C
     C                   PARM      BJLCCY        ZCCY              3                         HUT121C
     C                   PARM                    BJSLCD                                      HUT121C
     C                   PARM                    ZIND              1                         HUT121C
                                                                                             HUT121C
     C     ZIND          Ifeq      'W'                                                       HUT121C
     C                   Eval      *IN99 = '1'                                               HUT121C
     C                   Eval      WorkPrice = 'Y'                                           HUT121C
     C                   Else                                                                HUT121C
     C     @PRICK        READE     XXPRICEL1                              99                 HUT121C
     C                   EndIF                                                               HUT121C
     C                   EndIF                                                               HUT121C
                                                                                             HUT121C
     C                   EndDO                                                               HUT121C
      *                                                                                      HUT121C
     C     DDACTN        Ifeq      'I'                                                       HUT121C
     C     WorkPrice     AndEq     'Y'                                                       HUT121C
     C                   ADD       1             Idx                                          HUT121
     C                   EVAL      FldNamXAr (Idx) = 'DDPVDT'                                 HUT121
     C                   EVAL      MsgIDXAr(Idx) = 'XXX9001'                                  HUT121
     C                   EVAL      DDVDTOK   = 'N'                                            HUT121
     C                   Else                                                                HUT121C
     C                   Z-ADD     ZDAYNO        PVDT                                        HUT121C
     C                   EndIF                                                               HUT121C
      *                                                                                      HUT121C
     C                   Else                                                                 HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_125                                       *
      *****************************************************************
