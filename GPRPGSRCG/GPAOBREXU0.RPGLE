     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Branch Code Extension Updater')               *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAOBREXU0 - Midas GP Branch Code Extension Updater          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR792029           Date 22Jun11               *
      *  Prev Amend No. AR694360 *CREATE   Date 06Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR792029 - INZZ Option in Bridge Failed                      *
      *  AR694360 - Initialise GPBRCHEXPD. (Child: AR694361)          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *  LR - Last record indicator (program termination)             *
      *  U7 and U8 - DB error processing indicator                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FGPBRCHEXL0UF A E           K DISK    INFSR(*PSSR)
     F**********                           COMMIT                                           AR792029
      *
      ** Array containing Copyright statement
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Parameter Variables
      *
     D PReturnCode     S              7A
     D PBRC            S              3A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN - Main processing                                       *
      *                                                               *
      *****************************************************************
     C     PBRC          CHAIN     GPBRCHEXL0
     C                   IF        NOT %FOUND()
      *
     C                   EVAL      BXBRCD = PBRC
     C                   EVAL      BXACOC = *BLANKS
     C                   WRITE     GPBRCHEXD0
      *
     C                   ENDIF
      *
      ** End of Program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine for Initial First Cycle processing       *
      *                                                               *
      *  Called by: Automatically called upon entry to the module     *
      *                                                               *
      *  Calls: SR/*PSSR                                              *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PReturnCode
     C                   PARM                    PBRC
 
     C                   MOVEA     CPY@          BIS@             80
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called by: SR/*INZSR                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C
     C                   EVAL      PReturnCode = '*ERROR'
     C                   DUMP
 
     C                   RETURN
 
     C                   ENDSR
     C****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2011
