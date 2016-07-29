/*******************************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('UDF Configuration to MidasPlus - Data Take-on')
/*XBI *                                                               *
      *****************************************************************
      *  Midas - Global Processing                                    *
      *                                                               *
      *  SC003001 - UDF Configuration to MidasPlus - Data Take-on     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. MD039359           Date 27Jul16               *
      *  Prev Amend No. AR685870           Date 10Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16890 *CREATE   Date 07Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039359 - Abnormal termination is not reported in           *
      *             Switchable Feature initialization screen.         *
      *  AR685870 - Introduce sequence number field.                  *
/*    *             (Child: AR685871)                                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16890 - UDF Configuration to MidasPlus - Data Take-on     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     F***APUDTKPD  IF   E             DISK                                                  AR685870
     FAPUDTKL0  IF   E           K DISK                                                     AR685870
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
     D WPUEXT          S             15A   INZ(*BLANKS)                                     AR685870
     D WPMFLD          S           1000A   INZ(*BLANKS)                                     AR685870
     D WPXFLD          S           1000A   INZ(*BLANKS)                                     AR685870
     D WPZONE          S             10A   INZ(*BLANKS)                                     AR685870
     D WPCOND          S            500A   INZ(*BLANKS)                                     AR685870
     D WPCND2          S            500A   INZ(*BLANKS)                                     AR685870
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C     *ENTRY        PLIST                                                              MD039359
     C                   PARM                    RetCode           7                        MD039359
     C                   PARM                    Mode              1                        MD039359
                                                                                            MD039359
      ** Get zone details for UDF Extension table update
     C                   CALL      'GOGETZONE'
     C                   PARM      *BLANKS       I#RTCD            7
     C                   PARM      *BLANKS       I#ERMS           50
      ** INPUTS
     C                   PARM      'N'           I#FULLCHECK       1
      ** OUTPUTS
     C                   PARM                    O#ZONE           10
     C                   PARM                    O#SHTC            4
     C                   PARM                    O#RDNB            5 0
     C                   PARM                    O#DNWD            5 0
     C                   PARM                    O#BCCY            3
     C                   PARM                    O#NJOB            1 0
      ** Check for error in access object
     C                   IF        I#RTCD <> *BLANKS
     C                   MOVEL     'SC003001'    DBPGM
     C                   MOVEL     'GPZONEPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     *BLANKS       DBKEY
      *
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***Read*through*file                                                                  AR685870
     C*****1****         SETLL     APUDTKPD                                                 AR685870
     C**********         READ      APUDTKPD                               80                AR685870
      **********                                                                            AR685870
     C**********         DOW       *IN80 = *OFF                                             AR685870
      **********                                                                            AR685870
     C**********         EVAL      WSTRSQL = 'Insert into ' + %trim(APUEXT) +               AR685870
     C**********                             ' (' + %trim(APXFLD) + ',' +                   AR685870
     C**********                             %trim(APZONE) + ')' +                          AR685870
     C**********                             ' select ' + %trim(APMFLD) +                   AR685870
     C**********                             ',''' + %trim(O#ZONE) + '''' +                 AR685870
     C**********                             ' from ' + %trim(APMAIN) +                     AR685870
     C**********                             ' where ' + %trim(APCOND) +                    AR685870
     C**********                             ' from ' + %trim(APUEXT) +                     AR685870
     C**********                             ' where ' + %trim(APZONE) +                    AR685870
     C**********                             ' = '''+ %trim(O#ZONE) + '''' +                AR685870
     C**********                             ')'                                            AR685870
      **********                                                                            AR685870
      ***Execute*command                                                                    AR685870
     C**********         EXSR      POPRTN                                                   AR685870
      **********                                                                            AR685870
      **********                                                                            AR685870
      ***Check*for*error*in*SQL*execution                                                   AR685870
      **********                                                                            AR685870
     C**********         IF        SQLCOD <> 0  And SQLCOD <> 100                           AR685870
     C**********         MOVEL     'SC003001'    DBPGM                                      AR685870
     C**********         MOVEL     APUEXT        DBFILE                                     AR685870
     C**********         MOVEL     '001'         DBASE                                      AR685870
     C**********         MOVEL     WSTRSQL       DBKEY                                      AR685870
      **********                                                                            AR685870
     C**********         EXSR      *PSSR                                                    AR685870
     C**********         ENDIF                                                              AR685870
      **********                                                                            AR685870
     C**********         READ      APUDTKPD                               80                AR685870
     C**********         ENDDO                                                              AR685870
      ** Read through file                                                                  AR685870
                                                                                            AR685870
     C     *LOVAL        SETLL     APUDTKL0                                                 AR685870
     C                   READ      APUDTKL0                               80                AR685870
     C                   DOW       *IN80 = *OFF                                             AR685870
                                                                                            AR685870
     C                   IF        APUEXT <> WPUEXT  and                                    AR685870
     C                             WPUEXT <> *BLANKS                                        AR685870
     C                                                                                      AR685870
      ** Build SQL Statement                                                                AR685870
     C                   EXSR      SRSQL                                                    AR685870
      ** Execute command                                                                    AR685870
     C                   EXSR      POPRTN                                                   AR685870
      ** Check for error in SQL execution                                                   AR685870
     C                   EXSR      SRSQLE                                                   AR685870
     C                   ENDIF                                                              AR685870
                                                                                            AR685870
     C                   EVAL      WPMFLD = %trim(WPMFLD) + ' ' + %trim(APMFLD)             AR685870
     C                   EVAL      WPXFLD = %trim(WPXFLD) + ' ' + %trim(APXFLD)             AR685870
     C                   EVAL      WPZONE = %trim(WPZONE) + ' ' + %trim(APZONE)             AR685870
     C                   EVAL      WPCOND = %trim(WPCOND) + ' ' + %trim(APCOND)             AR685870
     C                   EVAL      WPCND2 = %trim(WPCND2) + ' ' + %trim(APCND2)             AR685870
     C                   EVAL      WPMAIN = APMAIN                                          AR685870
     C                   EVAL      WPUEXT = APUEXT                                          AR685870
     C                   READ      APUDTKL0                               80                AR685870
     C                   ENDDO                                                              AR685870
                                                                                            AR685870
     C                   EXSR      SRSQL                                                    AR685870
     C                   EXSR      POPRTN                                                   AR685870
     C                   EXSR      SRSQLE                                                   AR685870
                                                                                            AR685870
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************                     AR685870
      /EJECT                                                                                AR685870
      *****************************************************************                     AR685870
      * SRSQL - Build SQL Statement                                   *                     AR685870
      *****************************************************************                     AR685870
     C     SRSQL         BEGSR                                                              AR685870
     C                   EVAL      WSTRSQL = 'Insert into ' + %trim(WPUEXT) +               AR685870
     C                                       ' (' + %trim(WPXFLD) + ',' +                   AR685870
     C                                       %trim(WPZONE) + ')' +                          AR685870
     C                                       ' select ' + %trim(WPMFLD) +                   AR685870
     C                                       ',''' + %trim(O#ZONE) + '''' +                 AR685870
     C                                       ' from ' + %trim(WPMAIN) +                     AR685870
     C                                       ' m left outer join ' +                        AR685870
     C                                       %trim(WPUEXT) + ' x On ' +                     AR685870
     C                                       %trim(WPCOND) + ' and x.' +                    AR685870
     C                                       %trim(WPZONE) + ' = ' +                        AR685870
     C                                       '''' + %trim(O#ZONE) + '''' +                  AR685870
     C                                       ' where x.' + %trim(WPZONE) +                  AR685870
     C                                       ' is null ' + %trim(WPCND2)                    AR685870
     C                   EVAL      WPMFLD = *BLANKS                                         AR685870
     C                   EVAL      WPXFLD = *BLANKS                                         AR685870
     C                   EVAL      WPZONE = *BLANKS                                         AR685870
     C                   EVAL      WPCOND = *BLANKS                                         AR685870
     C                   EVAL      WPCND2 = *BLANKS                                         AR685870
     C                   ENDSR                                                              AR685870
      *****************************************************************                     AR685870
      /EJECT                                                                                AR685870
      *****************************************************************                     AR685870
      * SRSQLE - Check for error in SQL execution                     *                     AR685870
      *****************************************************************                     AR685870
     C     SRSQLE        BEGSR                                                              AR685870
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100                           AR685870
     C                   MOVEL     'SC003001'    DBPGM                                      AR685870
     C                   MOVEL     APUEXT        DBFILE                                     AR685870
     C                   MOVEL     '001'         DBASE                                      AR685870
     C                   MOVEL     WSTRSQL       DBKEY                                      AR685870
      *                                                                                     AR685870
     C                   EXSR      *PSSR                                                    AR685870
     C                   ENDIF                                                              AR685870
                                                                                            AR685870
     C                   ENDSR                                                              AR685870
      *****************************************************************
      /EJECT
      *****************************************************************
      * POPRTN - SQL Execution Routine                                *
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
     C                   EVAL      RetCode = '*ERROR'                                       MD039359
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
