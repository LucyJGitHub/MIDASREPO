     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Update UDF Extension files')
      *****************************************************************
      *                                                               *
      *  Midas Plus - Bridge                                          *
      *                                                               *
      *  UP003001 - Update program for UDF extesion files             *
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
     D  UDFTABLES      S             10    DIM(44) PERRCD(1) CTDATA
     D  ZONEKEYS       S             10    DIM(44) PERRCD(1) CTDATA
     D  INZONE         S             10
     D  INFILE         S             10
     D  RSTGMLIB       S             10
     D  ZONEKEY        S             10
     D  X              S              3P 0
      *
      * Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
     C/EXEC SQL DECLARE C1 CURSOR FOR
     C+    SELECT DISTINCT UDFDD FROM T_UDFDEF
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
      *  While end of UDF Definitions file has not been reached,
      *
     C     *IN01         DOWEQ     *OFF
      *
      *  read a record from the UDF Definitions file.
      *
     C/EXEC SQL
     C+    FETCH C1 INTO  :INFILE
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
      *  look up the table name in the table of file names,
      *
     C                   EVAL      X = 1
     C     INFILE        LOOKUP    UDFTABLES(X)                           02
      *
      *  determine the name of the zone field on the file,
      *
     C     *IN02         IFEQ      *ON
     C                   EVAL      ZONEKEY = ZONEKEYS(X)
      *
      *  and call program UP003004 to update the file.
      *
     C                   CALL      'UP003004'
     C                   PARM                    INZONE
     C                   PARM                    RSTGMLIB
     C                   PARM                    INFILE
     C                   PARM                    ZONEKEY
      *
     C                   ENDIF
      *
      *  If not end of file,
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
** UDFTABLES
T_GZAMADEX
T_GZBITHEX
T_GZBITPEX
T_GZBRCEXT
T_GZCACFEX
T_GZCCTDEX
T_GZCCT2EX
T_GZCIRSEX
T_GZCLIPEX
T_GZCLSPEX
T_GZCLS2EX
T_GZCUSXEX
T_GZDEAMEX
T_GZDPMVEX
T_GZFAMDEX
T_GZFCIPEX
T_GZFEADEX
T_GZFEEMEX
T_GZFESTEX
T_GZFRAEX
T_GZFUNDEX
T_GZFXDLEX
T_GZHDITEX
T_GZINTCEX
T_GZIPAYEX
T_GZLDNIEX
T_GZLERIEX
T_GZLOAMEX
T_GZMAPYEX
T_GZNASPEX
T_GZNASSEX
T_GZOPAYEX
T_GZOTCCEX
T_GZOTCOEX
T_GZPRCSEX
T_GZRFTDEX
T_GZRFT2EX
T_GZRPSCEX
T_GZSECSEX
T_GZSEDEEX
T_GZSIRSEX
T_GZSTCQEX
T_GZSTOREX
T_GZTRADEX
** ZONEKEYS
ZONE
ZONE
ZONE
GBZONE
ZONE
ZONE
ZONE
CUSTZONE
ZONE
ZONE
ZONE
CUSTZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
CUSTZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
ZONE
CUSTZONE
CUSTZONE
CUSTZONE
ZONE
