     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Branch Code - Setup PF/GPBRCHEXPD')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDBRCHEX1 - Midas SD Branch Code - Setup PF/GPBRCHEXPD       *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR694360 *CREATE   Date 10Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
     FSDBRX2PD  IF   E             DISK
      *
      ** Array containing Copyright statement
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Work Variables
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
     C                   READ      SDBRX2PD
     C                   DOW       NOT %EOF()
      *
     C                   CALL      'GPAOBREXU0'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      VEBRCD        PBRC
      *
     C                   READ      SDBRX2PD
     C                   ENDDO
      *
      ** End of Program
      *
     C                   EVAL      *INLR = *ON
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
(c) Finastra International Limited 2011
