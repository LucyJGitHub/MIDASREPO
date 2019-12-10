     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
 **** *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Migration Utility for SDSVALPD')
 **** *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00111 - Migration Utility for SDSVALPD                    *
      *                                                               *
      *  Function:  This program will map the PDCL system values in   *
      *             SDSVALPD.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 05Feb18               *
      *                 AR1085447*CREATE   Date 06Feb13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1085447 - Migrate current settings to the PDCL system      *
      *              values that were renamed.                        *
      *                                                               *
      *****************************************************************

     D SQLSTRING       S          32000A   VARYING INZ

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Update SDSVALPD

     C                   EVAL      SQLSTRING =
     C**********                   'UPDATE SDSVALPD a ' +                                   MD054605
     C                             'UPDATE SDSVLXTD a ' +                                   MD054605
     C                             'SET a.GIVAL = (SELECT b.GIVAL FROM ' +
     C                             'SMSVALPD b WHERE b.GISVAL = ' +
     C                             '''AutoAdjSchedRepaymnt'') WHERE ' +
     C                             'a.GISVAL = ''PDCLAutoAdjSchedRep'''

     C/exec SQL
     C+ execute immediate :SQLSTRING
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
