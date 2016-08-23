      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GPSDSVALPD - On-Line Update of Global File GZSDSVALPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CAP205   *REBUILD  Date 23Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *                                                               *
      *****************************************************************
     C                   CALL      'GPSDSVALPD  '
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GPSDSVALPD'
     C                   EXSR      *PSSR
     C                   END
