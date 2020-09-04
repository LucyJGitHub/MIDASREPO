     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GO Global Update of Cust Det-DeleteTskSpl')
      *****************************************************************
      *                                                               *
      *  Midas  - Global Processing Module                            *
      *                                                               *
      *  GO011402 - Midas GO Global Update of Customer Details        *
      *             Deletion Task Split                               *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8 -  Database Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR      -  Program exception error routine                *
      *  *INZSR     -  Initialisation Subroutine                      *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.           *
      *                                                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** Ê Automatically included D-specs       Ê
      ** Ê ==============================       Ê
      ** +--------------------------------------+
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** Ê Declared variables                   Ê
      ** Ê ==================                   Ê
      ** +--------------------------------------+
      *
      * Dynamic SQL statement work field
     D WSTRSQL         S            200A   INZ(*BLANKS)
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   Eval      WSTRSQL = 'delete from GZSDCUSTPD where ' +
     C                                     'exists(select * from ' +
     C                                     'SDBRCHL1 where ' +
     C                                     'A8BRCD=GZSDCUSTPD.BBBRCD) and ' +
     C                                     'not exists(select * from ' +
     C                                     'SDCUDLPD where ' +
     C                                     'BBCUST=GZSDCUSTPD.BBCUST)'

      * Prepare SQL statement

     C/EXEC SQL
     C+ PREPARE S1 FROM :WSTRSQL
     C/END-EXEC

      * Execute SQL statement

     C/EXEC SQL
     C+ EXECUTE S1
     C/END-EXEC

      * Check for error in SQL execution

     C                   IF        SQLCODE <> 0  AND SQLCODE <> 100
     C                   EVAL      DBPGM = 'GO011402'
     C                   EVAL      DBFILE = 'GZSDCUSTPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = WSTRSQL
      *
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WSTRSQL = *BLANKS

     C                   EVAL      WSTRSQL = 'Delete From GPGLCUSL where ' +
     C                                     'exists(select * from ' +
     C                                     'SDBRCHL1 where ' +
     C                                     'A8BRCD=GPGLCUSL.CGBRCD) and ' +
     C                                     'not exists(select * from ' +
     C                                     'SDCUDLPD where ' +
     C                                     'BBCUST=GPGLCUSL.CGCUST)'

      * Prepare SQL statement

     C/EXEC SQL
     C+ PREPARE S1 FROM :WSTRSQL
     C/END-EXEC

      * Execute SQL statement

     C/EXEC SQL
     C+ EXECUTE S1
     C/END-EXEC
     C                   IF        SQLCODE <> 0  AND SQLCODE <> 100
     C                   EVAL      DBPGM = 'GO011402'
     C                   EVAL      DBFILE = 'GPGLCUSL'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = WSTRSQL
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

**  CPY@
(c) Misys International Banking Systems Ltd. 2012
