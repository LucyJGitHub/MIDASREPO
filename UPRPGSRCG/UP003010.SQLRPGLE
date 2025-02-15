     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Clear global customer details for zone')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  UP003010 - Clear global customer details for a zone          *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSC033  *CREATE    Date 16Apr07               *
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
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    INZONE           10
      *
      * Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
      *  Delete records for the zone from the production file.
      *
     C/EXEC SQL
     C+    DELETE FROM GPGLCUSL WHERE CGZONE = :INZONE
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
