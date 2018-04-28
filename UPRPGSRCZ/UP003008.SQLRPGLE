     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Update global static data files')
      *****************************************************************
      *                                                               *
      *  Midas Plus - Bridge                                          *
      *                                                               *
      *  UP003008 - Update global static data files                   *
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
      *  Define SQL INSERT statement.
      *
     D STMT1           S            500A   INZ('INSERT INTO            +
     D                                     SELECT * FROM           /           +
     D                                     WHERE            NOT IN +
     D                                     (SELECT            FROM           )')
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    RSTGMLIB         10
     C                   PARM                    TABLENAME        10
     C                   PARM                    KEYFIELD         10
      *
      *  Calculate SQL INSERT statement.
      *
     C                   EVAL      %SUBST(STMT1:13:10) = TABLENAME
     C                   EVAL      %SUBST(STMT1:38:10) = RSTGMLIB
     C                   EVAL      %SUBST(STMT1:49:10) = TABLENAME
     C                   EVAL      %SUBST(STMT1:66:10) = KEYFIELD
     C                   EVAL      %SUBST(STMT1:92:10) = KEYFIELD
     C                   EVAL      %SUBST(STMT1:108:10) = TABLENAME
      *
      * Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
      *  Merge records from the restored file into the production file.
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
     C                   ExSR      *PSSR
     C                   EndIf
      *
      *  Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
      *  Execute the prepared statement.
      *
     C/EXEC SQL
     C+   EXECUTE S1
     C/END-EXEC
      *
      *  Check for successful completion
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
