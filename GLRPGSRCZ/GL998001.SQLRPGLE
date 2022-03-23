     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GL Get Batch APOUTPUTPD data')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL998001 - Get Batch APOUTPUTPD data                         *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD059435 *CREATE   Date 16Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059435 - STP Batch entered Midas as held with an error     *
      *             in the header record                              *
      *                                                               *
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    #ReturnCod        7

     C                   MONITOR

     C/EXEC SQL
     C+ delete from GLCLOBPD
     C/END-EXEC

     C/EXEC SQL
     C+ insert into GLCLOBPD
     C+     SELECT CAST(BUFFER AS VARCHAR(600)) FROM APOUTPUTPD
     C+      where substr(CAST(BUFFER AS VARCHAR(600)),1,6) = 'GLBITH'
     C+      and   substr(CAST(BUFFER AS VARCHAR(600)),257,3) = 'STP' or
     C+            substr(CAST(BUFFER AS VARCHAR(600)),1,6) = 'GLBITP'
     C+      and   substr(CAST(BUFFER AS VARCHAR(600)),257,3) = 'STP'
     C/END-EXEC

     C                   ON-ERROR
     C                   EVAL      #ReturnCod = '*ERROR'
     C                   ENDMON

     C                   EVAL      *INLR = *ON
     C                   RETURN
