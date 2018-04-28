      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GPSDHCILPD - On-Line Update of Global File GZSDHCILPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD027295 *CREATE   Date 24May14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027295 - SDC009697 COB component run too long              *
      *                                                               *
      *****************************************************************
     C                   CALL      'GPSDHCILPD  '
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GPSDHCILPD'
     C                   EXSR      *PSSR
     C                   END
