      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GPREMEMLPD - On-Line Update of Global File GZREMEMLPD        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. MD035554 *CREATE   Date 11May16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD035554 - 2o'clock/ABC compatibility                        *
      *                                                               *
      *****************************************************************
     C                   CALLB     'GPREMEMLPD  '
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GPREMEMLPD'
     C                   EXSR      *PSSR
     C                   END
