     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Copy T_MSWIP data for a zone')
      *****************************************************************
      *                                                               *
      *  Midas Plus - Bridge                                          *
      *                                                               *
      *  UP003002 - Copy T_MSWIP data for a zone                      *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
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
     D STMT            S            500A   INZ('INSERT INTO T_MSWIP +
     D                                     SELECT * FROM           /T_MSWIP +
     D                                     WHERE MSWZONE =             ')
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    INZONE           10
     C                   PARM                    RSTGMLIB         10
      *
      *  Calculate SQL INSERT statement.
      *
     C                   EVAL      %SUBST(STMT:35:10) = RSTGMLIB
     C                   EVAL      %SUBST(STMT:70:1) = ''''
     C                   EVAL      %SUBST(STMT:71:10) = INZONE
     C                   EVAL      %SUBST(STMT:81:1) = ''''
      *
      * Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
      *  Delete records for the zone from the production file.
      *
     C/EXEC SQL
     C+    DELETE FROM T_MSWIP WHERE MSWZONE = :INZONE
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
     C+    PREPARE S1 FROM :STMT
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
      *  Execute SQL statement to insert records for zone from restored library.
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
(c) Finastra International Limited 2007
