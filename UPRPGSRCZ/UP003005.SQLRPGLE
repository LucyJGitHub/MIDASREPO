     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Copy global data for a branch')
      *****************************************************************
      *                                                               *
      *  Midas Plus - Bridge                                          *
      *                                                               *
      *  UP003005 - Copy global data for a branch                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSC033  *CREATE    Date 01May07               *
      *  Prev Amend No. xxxxxx             Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC033 - Include global libraries in daily backups.          *
      *                                                               *
      *****************************************************************
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      *  Define SQL DELETE statement.
      *
     D STMT1           S            500A   INZ('DELETE FROM            +
     D                                     WHERE            =             ')
      *
      *  Define SQL INSERT statement.
      *
     D STMT2           S            500A   INZ('INSERT INTO            +
     D                                     SELECT * FROM           /           +
     D                                     WHERE            =             ')
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    INBRANCH          3
     C                   PARM                    RSTGMLIB         10
     C                   PARM                    TABLENAME        10
     C                   PARM                    BRANCHKEY        10
      *
      *  Calculate SQL DELETE statement.
      *
     C                   EVAL      %SUBST(STMT1:13:10) = TABLENAME
     C                   EVAL      %SUBST(STMT1:31:10) = BRANCHKEY
     C                   EVAL      %SUBST(STMT1:44:1) = ''''
     C                   EVAL      %SUBST(STMT1:45:3) = INBRANCH
     C                   EVAL      %SUBST(STMT1:48:1) = ''''
      *
      *  Calculate SQL INSERT statement.
      *
     C                   EVAL      %SUBST(STMT2:13:10) = TABLENAME
     C                   EVAL      %SUBST(STMT2:38:10) = RSTGMLIB
     C                   EVAL      %SUBST(STMT2:49:10) = TABLENAME
     C                   EVAL      %SUBST(STMT2:67:10) = BRANCHKEY
     C                   EVAL      %SUBST(STMT2:80:1) = ''''
     C                   EVAL      %SUBST(STMT2:81:3) = INBRANCH
     C                   EVAL      %SUBST(STMT2:84:1) = ''''
      *
      * Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
      *  Delete records for the branch from the production file.
      *
      *  Prepare STMT as initialised in declare section and modified in calculations.
      *
     C/EXEC SQL
     C+    PREPARE S1 FROM :STMT1
     C/END-EXEC
      *
      * Check for successful completion
      *
     C                   If        (SQLCOD <> 0)
     C                   If        (%SUBST(SQLSTATE:1:2) <> '02')
     C                   ExSR      *PSSR
     C                   EndIf
     C                   EndIf
      *
      * Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
      *  Execute SQL statement to delete records for branch from master library.
      *
     C/EXEC SQL
     C+    EXECUTE S1
     C/END-EXEC
      *
      * Check for successful completion
      *
     C                   If        (SQLCOD <> 0)
     C                   If        (%SUBST(SQLSTATE:1:2) <> '02')
     C                   ExSR      *PSSR
     C                   EndIf
     C                   EndIf
      *
      * Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
      *  Prepare STMT as initialised in declare section and modified in calculations.
      *
     C/EXEC SQL
     C+    PREPARE S2 FROM :STMT2
     C/END-EXEC
      *
      * Check for successful completion
      *
     C                   If        (SQLCOD <> 0)
     C                   If        (%SUBST(SQLSTATE:1:2) <> '02')
     C                   ExSR      *PSSR
     C                   EndIf
     C                   EndIf
      *
      * Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
      *  Execute SQL statement to insert records for branch from restored library.
      *
     C/EXEC SQL
     C+    EXECUTE S2
     C/END-EXEC
      *
      * Check for successful completion
      *
     C                   If        (SQLCOD <> 0)
     C                   If        (%SUBST(SQLSTATE:1:2) <> '02')
     C                   ExSR      *PSSR
     C                   EndIf
     C                   EndIf
      *
     C                   SetOn                                        LR
     C                   Return
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
 
     C                   SetOn                                        LR
     C                   Return
 
     C                   EndSR
 
      **---------------------------------------------------------------
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2007
