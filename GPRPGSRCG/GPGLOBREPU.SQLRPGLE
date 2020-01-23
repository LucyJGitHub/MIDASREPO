     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Global Data Replicated Update')               *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GPGLOBREPU - Midas GP Global Data Replicated Update          *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD054423 *CREATE   Date 20Jan20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054423 - GOC011501 failed due to GPGDRPPD overflow.        *
      *                                                               *
      *****************************************************************
      *
      ** Local Data Area Data Structure
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
      *
      ** Working variables
     D I#RTCD          S              7A
     D I#ERMS          S             50A
     D I#FULLCHECK     S              1A
     D O#ZONE          S             10A
     D O#SHTC          S              4A
     D O#RDNB          S              5S 0
     D O#DNWD          S              5S 0
     D O#BCCY          S              3A
     D O#NJOB          S              1S 0
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
      ** Get zone by calling GOGETZONE
      *
     C                   CALL      'GOGETZONE'
     C                   PARM      *BLANKS       I#RTCD
     C                   PARM      *BLANKS       I#ERMS
      * INPUTS
     C                   PARM      'N'           I#FULLCHECK
      * OUTPUTS
     C                   PARM                    O#ZONE
     C                   PARM                    O#SHTC
     C                   PARM                    O#RDNB
     C                   PARM                    O#DNWD
     C                   PARM                    O#BCCY
     C                   PARM                    O#NJOB
      *
      ** Error detected  (*PSSR will end the program)
      *
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EXSR      *PSSR
     C                   END
      *
      ** Update GPGDRPPD file
      *
     C/EXEC SQL
     C+  DELETE  FROM GPGDRPPD
     C+    WHERE GDZONE = :O#ZONE
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
