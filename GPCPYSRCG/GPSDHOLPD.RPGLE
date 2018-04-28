      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GPSDHOLPD  - On-Line Update of Global File GZSDHOLPD         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. BUG27844A*CREATE   Date 15Jul10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27844A - Incorrect 'from date' default from SOAP enquiry  *
      *                                                               *
      *****************************************************************
     C                   CALL      'GPSDHOLPD   '
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GPSDHOLPD '
     C                   EXSR      *PSSR
     C                   END
