     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas API Main-UDF Extension Common - Housekeeping')
      *****************************************************************
      *  Midas - Global Processing                                    *
      *                                                               *
      *  SC002501 - Midas API Main-UDF Extension Common - Housekeeping*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR1071195          Date 25Jan13               *
      *  Prev Amend No. AR685870           Date 10Dec10               *
      *                 BUG28093A          Date 08Sep10               *
      *                 BUG28093 *CREATE   Date 03Sep10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1071195 - Optimise API UDF Extension Files Housekeeping    *
      *  AR685870 - Introduce sequence number field.                  *
/*    *             (Child: AR685871)                                 *
      *  BUG28093A - SCC0404 failed                                   *
      *  BUG28093 - Housekeeping program for APUDTKPD                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     F***APUDTKPD  IF   E             DISK                                                 AR1071195
     FSCSQLSPD  IF   E             DISK                                                    AR1071195
 
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *****************************************************************
 
      ** Dynamic SQL statement work field
     D***WSTRSQL         S           1000A   INZ(*BLANKS)                                  AR1071195
     D I#RTCD          S              7A
     D I#ERMS          S             50A
     D I#FULLCHECK     S              1A
     D O#ZONE          S             10A
     D O#SHTC          S              4A
     D O#RDNB          S              5S 0
     D O#DNWD          S              5S 0
     D O#BCCY          S              3A
     D O#NJOB          S              1S 0
     D SQLSTM          S            510A   INZ(*BLANKS)                                    AR1071195
     D Marker          S              3  0 INZ(0)                                          AR1071195
     D PreMarker       S            500A                                                   AR1071195
     D PostMarker      S            500A                                                   AR1071195
     D SQLLen          S              3  0 INZ(0)                                          AR1071195
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Get zone details for UDF Extension table update
 
     C                   CALL      'GOGETZONE'
     C                   PARM      *BLANKS       I#RTCD
     C                   PARM      *BLANKS       I#ERMS
      ** INPUTS
     C                   PARM      'N'           I#FULLCHECK
      ** OUTPUTS
     C                   PARM                    O#ZONE
     C                   PARM                    O#SHTC
     C                   PARM                    O#RDNB
     C                   PARM                    O#DNWD
     C                   PARM                    O#BCCY
     C                   PARM                    O#NJOB
 
      ** Check for error in access object
 
     C                   IF        I#RTCD <> *BLANKS
     C                   MOVEL     'SC002501'    DBPGM
     C                   MOVEL     'GPZONEPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     *BLANKS       DBKEY
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Read through file
 
     C*****1****         SETLL     APUDTKPD                                                AR1071195
     C**********         READ      APUDTKPD                                                AR1071195
     C     1             SETLL     SCSQLSPD                                                AR1071195
     C                   READ      SCSQLSPD                                                AR1071195
 
     C**********         DOW       NOT %EOF(APUDTKPD)                                      AR1071195
     C                   DOW       NOT %EOF(SCSQLSPD)                                      AR1071195
 
     C**********         IF        APSEQN = '01' AND                              AR685870 AR1071195
     C**********                   APCON2 <> *BLANKS                              AR685870 AR1071195
      **********                                                                  AR685870 AR1071195
     C**********         EVAL      WSTRSQL = 'Delete from ' + %trim(APUEXT) +              BUG28093A
     C**********                              ' where ' + %trim(APZONE)+ ' = ' +           BUG28093A
     C**********                              '''' + %trim(O#ZONE) + '''' +                BUG28093A
     C**********                              ' and (' +   %trim(APXFLD) +                 BUG28093A
     C**********                              ' not in(select ' +                          BUG28093A
     C**********                               %trim(APMFLD) + ' from ' +                  BUG28093A
     C**********                               %trim(APMAIN) + ')' + ')'                   BUG28093A
     C**********         EVAL      WSTRSQL = 'Delete from ' + %trim(APUEXT) +              AR1071195
     C**********                              ' where ' + %trim(APZONE)+ ' = ' +           AR1071195
     C**********                              '''' + %trim(O#ZONE) + '''' +                AR1071195
     C**********                              ' and (' + %trim(APCON2) +                   AR1071195
     C**********                              ' from ' + %trim(APMAIN) +                   AR1071195
     C**********                              ')' + ')'                          BUG28093A AR1071195
 
      ** Execute command
 
     C                   EXSR      DELRTN
 
      ** Check for error in SQL execution
 
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
     C                   MOVEL     'SC002501'    DBPGM
     C**********         MOVEL     APUEXT        DBFILE                                    AR1071195
     C                   MOVEL     SQLDELET      DBFILE                                    AR1071195
     C                   MOVEL     '002'         DBASE
     C**********         MOVEL     WSTRSQL       DBKEY                                     AR1071195
 
     C                   EXSR      *PSSR
     C                   ENDIF
     C**********         ENDIF                                                    AR685870 AR1071195
 
     C**********         READ      APUDTKPD                                                AR1071195
     C                   READ      SCSQLSPD                                                AR1071195
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * DELRTN - Delete Routine                                       *
      *****************************************************************
 
     C     DELRTN        BEGSR
 
      ** Prepare SQL statement
 
     C                   EVAL      SQLSTM = ''                                             AR1071195
     C                   EVAL      SQLSTM = SQLCREAT                                       AR1071195
     C                   EXSR      REPZON                                                  AR1071195
     C/EXEC SQL
     C*+*PREPARE S1 FROM :WSTRSQL                                                          AR1071195
     C+ PREPARE S1 FROM :SQLSTM                                                            AR1071195
     C/END-EXEC
 
      ** Execute SQL statement
 
     C/EXEC SQL
     C+ EXECUTE S1                                                                         AR1071195
     C/END-EXEC
                                                                                           AR1071195
      ** Prepare SQL statement                                                             AR1071195
                                                                                           AR1071195
     C                   EVAL      SQLSTM = ''                                             AR1071195
     C                   EVAL      SQLSTM = SQLDELET                                       AR1071195
     C                   EXSR      REPZON                                                  AR1071195
     C/EXEC SQL                                                                            AR1071195
     C+ PREPARE S2 FROM :SQLSTM                                                            AR1071195
     C/END-EXEC                                                                            AR1071195
                                                                                           AR1071195
      ** Execute SQL statement                                                             AR1071195
                                                                                           AR1071195
     C/EXEC SQL                                                                            AR1071195
     C+ EXECUTE S2                                                                         AR1071195
     C/END-EXEC                                                                            AR1071195
 
     C                   ENDSR
                                                                                           AR1071195
      *****************************************************************                    AR1071195
      * REPZON - Replace marker with zone value                       *                    AR1071195
      *****************************************************************                    AR1071195
                                                                                           AR1071195
     C     REPZON        BEGSR                                                             AR1071195
      ** Scan for marker ? and replace with zone value                                     AR1071195
      /free                                                                              //AR1071195
        Marker = %SCAN('?' : SQLSTM);                                                    //AR1071195
        If Marker > 0;                                                                   //AR1071195
           PreMarker = '';                                                               //AR1071195
           PostMarker = '';                                                              //AR1071195
           SQLLen = %len(%trim(SQLSTM));                                                 //AR1071195
           PreMarker = %subst(SQLSTM : 1 : Marker-1);                                    //AR1071195
           If Marker < SQLLen;                                                           //AR1071195
              PostMarker = %subst(%trim(SQLSTM) : Marker+1 : SQLLen - Marker);           //AR1071195
           EndIf;                                                                        //AR1071195
           SQLSTM = %trimr(PreMarker) + '''' + %trim(O#ZONE)
                    + '''' + %trimr(PostMarker);                                         //AR1071195
        EndIf;                                                                           //AR1071195
                                                                                         //AR1071195
      /end-free                                                                          //AR1071195
                                                                                           AR1071195
     C                   ENDSR                                                             AR1071195
 
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2010
