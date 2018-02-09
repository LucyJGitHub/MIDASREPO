     H DEBUG
     H COPYRIGHT('(c)Finastra International Limited 2012')
 **** *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Alpha Loan - Packed Fields Conversion')
 **** *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00252 - SM Alpha Loan - Packed Fields Conversion          *
      *                                                               *
      *  Function:  This program will update files SDLENOPD, GPLENOPD *
      *             and GZSDLENOPD to move the values of fields       *
      *             F9FRAN, F9LRAN and F9NALN to fields F9FRAA,       *
      *             F9LRAA and F9NALA and initiallise F9FRAN, F9LRAN  *
      *             and F9NALN to 0.                                  *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c)Finastra International Limited 2012                       *
      *                                                               *
      *  Last Amend No. AR1070673          Date 20Jan13               *
      *  Prev Amend No. CLE148  *CREATE    Date 23Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1070673 - ALR utility program should be re-runnable.       *
      *  CLE148 - Alpha Loan Reference                                *
      *                                                               *
      *****************************************************************

     D WCount          S              3I 0 INZ                                             AR1070673
      *                                                                                    AR1070673
      ** Check if fields F9FRAA, F9LRAA and F9NALA are not blanks                          AR1070673
      *                                                                                    AR1070673
     C/Exec SQL                                                                            AR1070673
     C+  SELECT COUNT(*)                                                                   AR1070673
     C+    INTO :WCount                                                                    AR1070673
     C+    FROM SDLENOPD                                                                   AR1070673
     C+    WHERE F9FRAA <> ' ' AND                                                         AR1070673
     C+          F9LRAA <> ' ' AND                                                         AR1070673
     C+          F9NALA <> ' '                                                             AR1070673
     C/End-Exec                                                                            AR1070673
      *                                                                                    AR1070673
     C                   IF        WCount = 0                                              AR1070673
      ** File SDLENOPD
     C/Exec SQL
     C+  UPDATE SDLENOPD
     C+  SET F9FRAA=CASE WHEN F9FRAN=0 THEN '      ' ELSE CONCAT(
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=1 THEN '00000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=2 THEN '0000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=3 THEN '000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=4 THEN '00' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=5 THEN '0' ELSE ''
     C+    END END END END END,TRIM(CHAR(F9FRAN))) END, F9FRAN=0,
     C+    F9LRAA=CASE WHEN F9LRAN=0 THEN '      ' ELSE CONCAT(
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=1 THEN '00000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=2 THEN '0000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=3 THEN '000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=4 THEN '00' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=5 THEN '0' ELSE ''
     C+    END END END END END,TRIM(CHAR(F9LRAN))) END, F9LRAN=0,
     C+    F9NALA=CASE WHEN F9NALN=0 THEN '      ' ELSE CONCAT(
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=1 THEN '00000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=2 THEN '0000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=3 THEN '000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=4 THEN '00' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=5 THEN '0' ELSE ''
     C+    END END END END END,TRIM(CHAR(F9NALN))) END, F9NALN=0
     C/End-Exec

      ** File GPLENOPD
     C/Exec SQL
     C+  UPDATE GPLENOPD
     C+  SET F9FRAA=CASE WHEN F9FRAN=0 THEN '      ' ELSE CONCAT(
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=1 THEN '00000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=2 THEN '0000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=3 THEN '000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=4 THEN '00' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=5 THEN '0' ELSE ''
     C+    END END END END END,TRIM(CHAR(F9FRAN))) END, F9FRAN=0,
     C+    F9LRAA=CASE WHEN F9LRAN=0 THEN '      ' ELSE CONCAT(
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=1 THEN '00000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=2 THEN '0000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=3 THEN '000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=4 THEN '00' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=5 THEN '0' ELSE ''
     C+    END END END END END,TRIM(CHAR(F9LRAN))) END, F9LRAN=0,
     C+    F9NALA=CASE WHEN F9NALN=0 THEN '      ' ELSE CONCAT(
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=1 THEN '00000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=2 THEN '0000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=3 THEN '000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=4 THEN '00' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=5 THEN '0' ELSE ''
     C+    END END END END END,TRIM(CHAR(F9NALN))) END, F9NALN=0
     C/End-Exec

      ** File GZSDLENOPD
     C/Exec SQL
     C+  UPDATE GZSDLENOPD
     C+  SET F9FRAA=CASE WHEN F9FRAN=0 THEN '      ' ELSE CONCAT(
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=1 THEN '00000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=2 THEN '0000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=3 THEN '000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=4 THEN '00' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9FRAN)))=5 THEN '0' ELSE ''
     C+    END END END END END,TRIM(CHAR(F9FRAN))) END, F9FRAN=0,
     C+    F9LRAA=CASE WHEN F9LRAN=0 THEN '      ' ELSE CONCAT(
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=1 THEN '00000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=2 THEN '0000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=3 THEN '000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=4 THEN '00' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9LRAN)))=5 THEN '0' ELSE ''
     C+    END END END END END,TRIM(CHAR(F9LRAN))) END, F9LRAN=0,
     C+    F9NALA=CASE WHEN F9NALN=0 THEN '      ' ELSE CONCAT(
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=1 THEN '00000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=2 THEN '0000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=3 THEN '000' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=4 THEN '00' ELSE
     C+    CASE WHEN LENGTH(TRIM(CHAR(F9NALN)))=5 THEN '0' ELSE ''
     C+    END END END END END,TRIM(CHAR(F9NALN))) END, F9NALN=0
     C/End-Exec
     C                   ENDIF                                                             AR1070673

      ** If there's an SQL error, set on U7 and U8.
     C                   IF        SQLCOD < 0
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   RETURN
