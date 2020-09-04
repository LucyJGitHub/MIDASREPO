/*******************************************************************************/
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('MQ Series Interface to MidasPlus - Housekeeping')
/*XBI *                                                               *
      *****************************************************************
      *  Midas - Global Processing                                    *
      *                                                               *
      *  SC002500 - MQ Series Interface to MidasPlus - Housekeeping   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. MD027365           Date 19Aug14               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CAP190             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BG18886            Date 22May08               *
      *                 BUG17890           Date 30Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP185  *CREATE    Date 21Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027365 - Unable to insert fee with unexpected errors due   *
      *             to obsolete records in extension file LEFEEDQD.   *
      *             Execute routine to delete the records.            *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CAP190 - Customer Exchange MQ enabling.                      *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BG18886 - Amend non-standard codes.                          *
      *  BUG17890 -  Fees extension record deleted when the customer  *
      *              is the original borrower for participations      *
      *              purchased                                        *
      *  CAP185 - MQ Series Interface                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     FAPMNEXPD  IF   E             DISK
      *
      *****************************************************************
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      *****************************************************************
      *
      ** Dynamic SQL statement work field
     D WSTRSQL         S           1000A   INZ(*BLANKS)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Read through file
     C     1             SETLL     APMNEXPD
     C                   READ      APMNEXPD                               80
      *
     C                   DOW       *IN80 = *OFF
      *
     C                   IF        APHIST = *BLANKS
      *
     C                   EVAL      WSTRSQL = 'Delete from ' + %trim(APEXTN) +
     C                                        ' where '+ %trim(APEKEY) +
     C                                        ' not in(select ' +
     C                                         %trim(APMKEY) + ' from ' +
     C                                         %trim(APMAIN) + ')'
      *
      ** Execute command
     C                   EXSR      DELRTN
      *
     C                   ELSE
      *
     C                   IF        APMAIN = 'LEFEED'                                        BUG17890
     C                   Eval      WSTRSQL = 'Delete from ' + %trim(APEXTN)    +            BUG17890
     C                                        ' where ' + %trim(APEKEY)        +            BUG17890
     C                                        ' not in(select '                +            BUG17890
     C                                        %trim(APMKEY) + ' from '         +            BUG17890
     C                                        %trim(APMAIN) + ') and '         +            BUG17890
     C                                        %trim(APEKEY) + ' not in'        +            BUG17890
     C                                        '(select ' + %trim(APHKEY)       +            BUG17890
     C                                        ' from ' + %trim(APHIST) + ')'   +            BUG17890
     C                                        'and ' + %trim(APEKEY)           +            BUG17890
     C                                       ' not in(select '                 +            BUG17890
     **************                          'FEBRCA**OLNO**FEFACL**FELOAN**'  +    BUG17890 BG18886
     C                                       'FEBRCA concat OLNO concat FEFACL'+    BUG17890 BG18886
     C                                       ' concat FELOAN concat '          +    BUG17890 BG18886
     C                                       'FEFSEQ from  cloancl, lefeed'    +            BUG17890
     C                                       ' where FEBRCA = BRCA and'        +            BUG17890
     C                                       ' FELOAN = LNRF  and '            +            BUG17890
     C                                       '(PTYP = ''64'' or'               +            BUG17890
     C                                       ' PTYP = ''65'' or'               +            BUG17890
     C                                       ' PTYP = ''68'' or'               +            BUG17890
     C                                       ' PTYP = ''71'' ))               '             BUG17890
                                                                                            MD027365
      ** Execute command                                                                    MD027365
     C                   EXSR      DELRTN                                                   MD027365
                                                                                            MD027365
     C                   ELSE                                                               BUG17890
     C                   Eval      WSTRSQL = 'Delete from ' + %trim(APEXTN) +
     C                                        ' where ' + %trim(APEKEY) +
     C                                        ' not in(select ' +
     C                                        %trim(APMKEY) + ' from ' +
     C                                        %trim(APMAIN) + ') and ' +
     C                                        %trim(APEKEY) + ' not in' +
     C                                        '(select ' + %trim(APHKEY) +
     C                                        ' from ' + %trim(APHIST) + ')'
      *
      ** Execute command
     C                   EXSR      DELRTN
      *
     C                   ENDIF                                                              BUG17890
     C                   ENDIF
      *
      ** Check for error in SQL execution
 
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
     C                   MOVEL     'SC002500'    DBPGM
     C                   MOVEL     APEXTN        DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     WSTRSQL       DBKEY
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   READ      APMNEXPD                               80
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * DELRTN - Delete Routine                                       *
      *****************************************************************
      *
     C     DELRTN        BEGSR
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
(c) Misys International Banking Systems Ltd. 2006
