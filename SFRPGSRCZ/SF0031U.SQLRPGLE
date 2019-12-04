     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SF Account Code/Authorities SQL Update')         *
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Facility                            *
      *                                                               *
      *  SF0031U - Midas SF Account Code/Authorities SQL Update       *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD053230 *CREATE   Date 12Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053230 - Failed component SFC0031.                         *
      *                                                               *
      *****************************************************************
      *
      ** Local Data Area Data Structure
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
      *
      *
      *****************************************************************
      * Main routine                                                  *
      *****************************************************************
      *
      ** Start commitment control
      *
     C/EXEC SQL
     C+ SET OPTION COMMIT = *CHG
     C/END-EXEC
      *
      ** Update SFACAUPD file
      *
     C/EXEC SQL
     C+  DELETE  FROM SFACAUPD
     C+    WHERE SFACOD NOT IN
     C+      (SELECT A5ACCD FROM SDACODPD)
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0 AND
     C                             SQLCODE <> 100
     C     *LOCK         IN        LDA
     C                   MOVEL     'SFACOD'      DBKEY
     C                   MOVEL     'SFACAUPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   COMMIT
      *
      ** End program
      *
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   DUMP
     C                   ROLBK

     C                   CALL      'DBERRCTL'

     C                   RETURN

     C                   ENDSR
      *****************************************************************
