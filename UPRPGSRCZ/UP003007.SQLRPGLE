     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Update global file with branch key')
      *****************************************************************
      *                                                               *
      *  Midas Plus - Bridge                                          *
      *                                                               *
      *  UP003007 - Rebuild global file that has branch key           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSC033  *CREATE    Date 01May07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC033 - Include global libraries in backups                 *
      *                                                               *
      *****************************************************************
      *
     D  INZONE         S             10
     D  INBRANCH       S              3
     D  INFILE         S             10
     D  RSTGMLIB       S             10
     D  BRANCHKEY      S             10
     D  X              S              3P 0
      *
      * Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
     C/EXEC SQL DECLARE C1 CURSOR FOR
     C+    SELECT DISTINCT A8BRCD FROM GZSDBRCHPD WHERE A8ZONE = :INZONE
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
     C/EXEC SQL
     C+  OPEN C1
     C/END-EXEC
      *
     C/EXEC SQL WHENEVER NOT FOUND GO TO McENDER
     C/END-EXEC
      *
      *  While end of branches file has not been reached,
      *
     C     *IN01         DOWEQ     *OFF
      *
      *  read a record for the zone from the branches file.
      *
     C/EXEC SQL
     C+    FETCH C1 INTO  :INBRANCH
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
      *  If not end of file,
      *
     C     SQLSTATE      IFNE      '02000'
      *
      *  call program UP003005 to update the file.
      *
     C                   CALL      'UP003005'
     C                   PARM                    INBRANCH
     C                   PARM                    RSTGMLIB
     C                   PARM                    INFILE
     C                   PARM                    BRANCHKEY
      *
      *  If end of file,
      *
     C                   ELSE
      *
     C                   MOVE      *ON           *IN01
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     McENDER       TAG
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      /SPACE 5
      ********************************************************************
      * *INZSR - Initial Processing
      ********************************************************************
     C     *INZSR        BEGSR
      *
      *  Program parameter list.
      *
     C     *ENTRY        PLIST
     C                   PARM                    INZONE           10
     C                   PARM                    RSTGMLIB         10
     C                   PARM                    INFILE           10
     C                   PARM                    BRANCHKEY        10
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     RunBefore     IFEQ      *BLANKS
 
     C                   MOVE      'Y'           RunBefore         1
 
     C                   DUMP
     C                   ENDIF
 
     C                   SETON                                        LRU7U8
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
