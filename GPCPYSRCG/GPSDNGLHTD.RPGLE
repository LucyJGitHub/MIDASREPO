      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GPSDNGLHTD - On-Line Update of Global File GZSDNGLHTD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD027375           Date 05Jun14               *
      *  Prev Amend No. CGL155   *Create   Date 18Mar14               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027375 - Group limit details not reflected for all         *
      *             accounts included in the group                    *
      *  CGL155 - Forecast Group Limits                               *
      *                                                               *
      *****************************************************************
     C**********         CALLB     'GPSDNGLHTD  '                                           MD027375
     C                   CALL      'GPSDNGLHTD  '                                           MD027375
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GPSDNGLHTD'
     C                   EXSR      *PSSR
     C                   END
