     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
 **** *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Upgrade Utility for SDTRADPD')
 **** *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00114 - Upgrade Utility for SDTRADPD                      *
      *                                                               *
      *  Function:  This program will populate the BLSLAC field with  *
      *             the value from BLSRAC field.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1091579*CREATE   Date 26Feb13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1091579 - Populate BLSLAC with the value from BLSRAC.      *
      *                                                               *
      *****************************************************************
 
      ** Update SDTRADPD
 
     C/exec SQL
     C+ UPDATE SDTRADPD
     C+ SET BLSLAC = BLSRAC
     C+ WHERE BLSLAC = ' '
     C/end-exec
 
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
      *
     C                   RETURN
     C                   EVAL      *INLR = *ON
     C                   ENDSR
      *
      *****************************************************************
