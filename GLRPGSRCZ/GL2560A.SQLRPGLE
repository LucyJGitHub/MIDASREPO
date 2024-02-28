     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2024')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GL Transfer batches to history files cleanup')   *
      *****************************************************************
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL2560A - Midas GL Transfer batches to history files cleanup *
      *                                                               *
      *            Performs cleanup of GLJEH* files in case of        *
      *            failure occured during the previous run of GL2560. *
      *            Name of the file to be cleaned is passed as a      *
      *            parameter.                                         *
      *                                                               *
      *  Called By: GL2560                                            *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. MD062210 *CREATE   Date 15Feb24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062210 - COB: GLC0404 performance enhancement.             *
      *           - Enhance performance of GL2560 program by writing  *
      *             new records directly to the historic files and    *
      *             introducing new recovery failure logic with       *
      *             historic files cleanup. GLJEHXPD is also included *
      *             into the recovery logic now.                      *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************

     D/COPY ZACPYSRC,STD_D_SPEC

      *****************************************************************

     D SQLTXT          S            100A

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    RETCOD            7
     C                   PARM                    FILNAM           10
     C                   PARM                    KEYFLD           10

     C                   EVAL      RETCOD = *Blanks

      ** Compose SQL statement text

     C                   EVAL      SQLTXT = 'delete from ' + FILNAM
     C                                    + ' where '      + KEYFLD
     C                                    + '=(select BJRDNB from SDBANKPD)'

      ** Execute SQL statement

     C/EXEC SQL
     C+ execute immediate :SQLTXT
     C/END-EXEC

      ** Check for error in SQL execution

     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100
     C                   MOVEL     SQLSTT        RETCOD
     C                   MOVEL     'GL2560A'     DBPGM
     C                   MOVEL     FILNAM        DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     KEYFLD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

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
(c) Finastra International Limited 2024
