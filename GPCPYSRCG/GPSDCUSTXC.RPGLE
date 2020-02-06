      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GPSDCUSTXC - On-Line Update of Global File GZSDCUSTXC        *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD050212 *Create   Date 02Apr18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050212 - Replication processing for file PF/SDCUSTXC       *
      *                                                               *
      *****************************************************************
     C                   CALL      'GPSDCUSTXC  '
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GPSDCUSTXC'
     C                   EXSR      *PSSR
     C                   END
