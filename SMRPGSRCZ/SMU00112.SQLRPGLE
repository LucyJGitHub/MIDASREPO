     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
 **** *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Migration Utility for SDACUSPD')
 **** *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00112 - Migration Utility for SDACUSPD                    *
      *                                                               *
      *  Function:  This program will update the new SDACUSPD field   *
      *             coming from SDCUSTPD.                             *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. AR1075447*CREATE   Date 06Feb13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1085447 - Migrate the value of PDCU field from SDCUSTPD    *
      *              to SDACUSPD.                                     *
      *                                                               *
      *****************************************************************

     D SQLSTRING       S          32000A   VARYING INZ

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Update SDACUSPD

     C                   EVAL      SQLSTRING =
     C                             'UPDATE SDACUSPD a ' +
     C                             'SET a.E5PDCU = (SELECT b.BBPDCU ' +
     C                             'FROM SMCUSTPD b WHERE a.E5CUST = ' +
     C                             'b.BBCUST)'

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
