      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GPSDBRCHX0 - On-Line Update of Global File GZSDBRCHX0        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGL052             Date 02Dec15               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL052 - Amend Washout Processing                            *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *                                                               *
      *****************************************************************
     C**********         CALL      'GPSDBRCHX0  '
     C                   CALLB     'GPSDBRCHX0  '
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GPSDBRCHX0'
     C                   EXSR      *PSSR
     C                   END
