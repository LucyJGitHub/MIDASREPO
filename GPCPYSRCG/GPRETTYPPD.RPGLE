      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GPRETTYPPD - On-Line Update of Global File GZRETTYPPD        *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD035554 *CREATE   Date 25May16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD035554 - 2o'clock/ABC compatibility                        *
      *                                                               *
      *****************************************************************
     C                   CALLB     'GPRETTYPPD  '
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GPRETTYPPD'
     C                   EXSR      *PSSR
     C                   END
