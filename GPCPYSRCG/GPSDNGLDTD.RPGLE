      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GPSDNGLDTD - On-Line Update of Global File GZSDNGLDTD        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD027375           Date 05Jun14               *
      *                 CGL155  *CREATE    Date 18Mar14               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027375 - Group limit details not reflected for all         *
      *             accounts included in the group                    *
      *  CGL155 - Forecast Group Limits                               *
      *                                                               *
      *****************************************************************
     C**********         CALLB     'GPSDNGLDTD  '                                           MD027375
     C                   CALL      'GPSDNGLDTD  '                                           MD027375
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GPSDNGLDTD'
     C                   EXSR      *PSSR
     C                   END
