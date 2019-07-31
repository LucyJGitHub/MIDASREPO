     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Upd. SDFCTLPA')
      *****************************************************************
      *                                                               *
      *  Midas Plus - Bridge                                          *
      *                                                               *
      *  UP003007 - Update program for SDFCTLPA trailers              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD027649 *CREATE   Date 26Jun14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027649-Tag description not found for 96J                   *
      *                                                               *
      *****************************************************************
      *
      * Program variables
      *
     D  SchemLib       S             10
     D  SchemFile      S             10
     D  SchemFileRows  S              5P 0
     D  FileName       S             10
      *
      ** Data area containing system prefix
      *
     D SDSTAT        E DS                  DTAARA(SDSTAT)
      *
      *****************************************************************
      *
      * Set SQL return code
      *
     C                   Eval      SQLCOD = 0
      *
     C/exec SQL
     C+ declare C1 cursor for
     C+    Select Number_Rows
     C+      from SysPartitionStat
     C+      Where     System_Table_Schema = :SchemLib
     C+            and System_Table_Name = :SchemFile
     C/end-exec
 
     C/exec sql
     C+  open C1
     C/end-exec
 
      ** Check for successful completion
 
     C                   If        (SQLCOD <> 0)
     C                   If        (%SUBST(SQLSTATE:1:2) <> '02')
     C                   ExSR      *PSSR
     C                   EndIf
     C                   EndIf
 
     C/exec SQL
     C+    fetch
     C+    from C1
     C+    into: SchemFileRows
     C/end-exec
 
      ** Check for successful completion
 
     C                   If        (SQLCOD <> 0)
     C                   If        (%SUBST(SQLSTATE:1:2) <> '02')
     C                   ExSR      *PSSR
     C                   EndIf
     C                   EndIf
 
     C/exec SQL
     C+ update SDFCTLPA set AHNORC = :SchemFileRows
     C+ where AHFLNM = :SchemFile
     C/end-exec
 
      ** Check for successful completion
 
     C                   If        (SQLCOD <> 0)
     C                   If        (%SUBST(SQLSTATE:1:2) <> '02')
     C                   ExSR      *PSSR
     C                   EndIf
     C                   EndIf
 
     C     McENDER       TAG
 
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
     C                   PARM                    FileName
      *
      ** Retrieve system prefix
      *
     C                   In        SDSTAT
     C                   Eval      SchemLib = Libr + 'DTALIB'
     C                   Eval      SchemFile = FileName
      *
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
