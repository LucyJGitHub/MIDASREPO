      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GPSDEERTTD - On-Line Update of Global File GZSDEERTTD        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL153  *CREATE    Date 05Feb14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL153 - Bank Position Report                                *
      *                                                               *
      *****************************************************************
     C                   CALL      'GPSDEERTTD  '
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GPSDEERTTD'
     C                   EXSR      *PSSR
     C                   END
