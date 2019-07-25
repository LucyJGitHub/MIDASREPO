/*******************************************************************************/
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('MQ Series Interface to MidasPlus - Data Take-on')
/*XBI *                                                               *
      *****************************************************************
      *  Midas - Global Processing                                    *
      *                                                               *
      *  SC003000 - MQ Series Interface to MidasPlus - Data Take-on   *
      *                                                               *
      *  ((c) Finastra International Limited 2006                     *
      *                                                               *
      *  Last Amend No. AR957012           Date 23Nov12               *
      *  Prev Amend No. AR685870           Date 10Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17641           Date 02Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP185  *CREATE    Date 21Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR957012 - Errors encountered for switchable feature CAP185. *
      *             Increase field length. (Child: AR957014)          *
      *  AR685870 - Introduce sequence number field.                  *
/*    *             (Child: AR685871)                                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17641 - Added Search Condition field                      *
      *  CAP185 - MQ Series Interface                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     F***APDTAKPD  IF   E             DISK                                                  AR685870
     FAPDTAKL0  IF   E           K DISK                                                     AR685870
      *
      *****************************************************************
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      *****************************************************************
      *
      ** Dynamic SQL statement work field
     D*WSTRSQL**       S           1000A   INZ(*BLANKS)                                     AR685870
     D WSTRSQL         S          10000A   INZ(*BLANKS)                                     AR685870
     D WPMAIN          S             15A   INZ(*BLANKS)                                     AR685870
     D WPEXTN          S             15A   INZ(*BLANKS)                                     AR685870
     D***WPFLDS*       S            100A   INZ(*BLANKS)                            AR685870 AR957012
     D WPFLDS          S            500A   INZ(*BLANKS)                                     AR957012
     D WPCOND          S            500A   INZ(*BLANKS)                                     AR685870
     D WPCND2          S            500A   INZ(*BLANKS)                                     AR685870
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Read through file
     C*****1****         SETLL     APDTAKPD                                                 AR685870
     C**********         READ      APDTAKPD                               80                AR685870
      *
     C**********         DOW       *IN80 = *OFF                                             AR685870
      *
     C**********         EVAL      WSTRSQL = 'Insert into ' + %trim(APEXTN) +               AR685870
     C**********                              '(select ' + %trim(APFLDS) +                  BUG17641
     C**********                              ' from ' + %trim(APMAIN) + ')'                BUG17641
     C**********                              ' select ' + %trim(APFLDS) +         BUG17641 AR685870
     C**********                              ' from ' + %trim(APMAIN) +           BUG17641 AR685870
     C**********                              ' where ' + %trim(APCOND) +          BUG17641 AR685870
     C**********                              ' from ' + %trim(APEXTN) + ')'       BUG17641 AR685870
      *
      ***Execute*command                                                                    AR685870
     C**********         EXSR      POPRTN                                                   AR685870
      *
      *
      ***Check*for*error*in*SQL*execution                                                   AR685870

     C**********         IF        SQLCOD <> 0  And SQLCOD <> 100                           AR685870
     C**********         MOVEL     'SC003000'    DBPGM                                      AR685870
     C**********         MOVEL     APEXTN        DBFILE                                     AR685870
     C**********         MOVEL     '001'         DBASE                                      AR685870
     C**********         MOVEL     WSTRSQL       DBKEY                                      AR685870
      *
     C**********         EXSR      *PSSR                                                    AR685870
     C**********         ENDIF                                                              AR685870

     C**********         READ      APDTAKPD                               80                AR685870
     C**********         ENDDO                                                              AR685870
                                                                                            AR685870
     C     *LOVAL        SETLL     APDTAKL0                                                 AR685870
     C                   READ      APDTAKL0                               80                AR685870
     C                   DOW       *IN80 = *OFF                                             AR685870
                                                                                            AR685870
     C                   IF        APEXTN <> WPEXTN  and                                    AR685870
     C                             WPEXTN <> *BLANKS                                        AR685870
                                                                                            AR685870
      ** Build SQL Statement                                                                AR685870
     C                   EXSR      SRSQL                                                    AR685870
      ** Execute command                                                                    AR685870
     C                   EXSR      POPRTN                                                   AR685870
      ** Check for error in SQL execution                                                   AR685870
     C                   EXSR      SRSQLE                                                   AR685870
     C                   ENDIF                                                              AR685870
                                                                                            AR685870
     C                   EVAL      WPFLDS = %trim(WPFLDS) + ' ' + %trim(APFLDS)             AR685870
     C                   EVAL      WPCOND = %trim(WPCOND) + ' ' + %trim(APCOND)             AR685870
     C                   EVAL      WPCND2 = %trim(WPCND2) +' '+ %trim(APCND2)               AR685870
     C                   EVAL      WPMAIN = APMAIN                                          AR685870
     C                   EVAL      WPEXTN = APEXTN                                          AR685870
     C                   READ      APDTAKL0                               80                AR685870
     C                   ENDDO                                                              AR685870
                                                                                            AR685870
     C                   EXSR      SRSQL                                                    AR685870
     C                   EXSR      POPRTN                                                   AR685870
     C                   EXSR      SRSQLE                                                   AR685870
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************                     AR685870
      /EJECT                                                                                AR685870
      *****************************************************************                     AR685870
      * SRSQL - Build SQL Statement                                   *                     AR685870
      *****************************************************************                     AR685870
     C     SRSQL         BEGSR                                                              AR685870
     C                   EVAL      WSTRSQL = 'Insert into ' + %trim(WPEXTN) +               AR685870
     C                                        ' select ' + %trim(WPFLDS) +                  AR685870
     C                                        ' from ' + %trim(WPMAIN) +                    AR685870
     C                                        ' m left outer join ' +                       AR685870
     C                                         %trim(WPEXTN) + ' x On ' +                   AR685870
     C                                         %trim(WPCOND) + ' where ' +                  AR685870
     C                                         %trim(WPCND2)                                AR685870
     C                   EVAL      WPFLDS = *Blanks                                         AR685870
     C                   EVAL      WPCOND = *Blanks                                         AR685870
     C                   EVAL      WPCND2 = *Blanks                                         AR685870
     C                   ENDSR                                                              AR685870
      *****************************************************************                     AR685870
      /EJECT                                                                                AR685870
      *****************************************************************                     AR685870
      * SRSQLE - Check for error in SQL execution                     *                     AR685870
      *****************************************************************                     AR685870
     C     SRSQLE        BEGSR                                                              AR685870
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100                           AR685870
     C                   MOVEL     'SC003000'    DBPGM                                      AR685870
     C                   MOVEL     APEXTN        DBFILE                                     AR685870
     C                   MOVEL     '001'         DBASE                                      AR685870
     C                   MOVEL     WSTRSQL       DBKEY                                      AR685870
      *                                                                                     AR685870
     C                   EXSR      *PSSR                                                    AR685870
     C                   ENDIF                                                              AR685870
                                                                                            AR685870
     C                   ENDSR                                                              AR685870
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * POPRTN - Delete Routine                                       *
      *****************************************************************
      *
     C     POPRTN        BEGSR
      *
      * Prepare SQL statement

     C/EXEC SQL
     C+ PREPARE S1 FROM :WSTRSQL
     C/END-EXEC

      * Execute SQL statement

     C/EXEC SQL
     C+ EXECUTE S1
     C/END-EXEC
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************

**  CPY@
(c) Finastra International Limited 2006
