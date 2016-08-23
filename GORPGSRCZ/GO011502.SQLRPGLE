     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GO Bulk Sync of GZSDACUSPD - TS Deletes')
      *****************************************************************
      *                                                               *
      *  Midas  - Global Processing Module                            *
      *                                                               *
      *  GO011502 - Midas GO Bulk Sync of GZSDACUSPD - TS Deletes     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD020205 *CREATE   Date 24Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020205 - Continuous CoB run time improvement               *
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
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C/EXEC SQL
     C+ Delete from GZSDACUSPD where
     C+ not exists(select * from
     C+ SDACUSPD where
     C+ E5CUST = GZSDACUSPD.E5CUST)
     C/END-EXEC
 
      * Check for error in SQL execution
 
     C                   IF        SQLCODE <> 0  AND SQLCODE <> 100
     C                   EVAL      DBPGM = 'GO011502'
     C                   EVAL      DBFILE = 'GZSDACUSPD'
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
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
