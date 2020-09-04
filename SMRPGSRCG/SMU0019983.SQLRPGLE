     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GL Data Take On for GLACNTTD')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  UTGL0686 - Midas GL Data Take On for GLACNTTD                *
      *                                                               *
      *  Function:  This program will populate the GLACNTTD from      *
      *             ACCNTAB and GLACNTQD files.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD020772           Date 30Sep13               *
      *  Prev Amend No. MD020656 *CREATE   Date 30Sep13               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020772 - Enhance the take on program to prevent 0.00000001 *
      *             difference.                                       *
      *  MD020656 - This program will populate GLACNTTD file from     *
      *             ACCNTAB and GLACNTQD to improve performance.      *
      *                                                               *
      *****************************************************************
 
      ** Execute SQL statement
 
     C/EXEC SQL
     C+ INSERT INTO GPACNTTD
     C+ SELECT
     C+ F1BRCA, F1CNUM, F1CCY, F1ACOD, F1ACSQ,
     C**F1BAV1 / POWER (10, CU.A6NBDP), F1AVA1 / POWER (10, CU.A6NBDP),                     MD020772
      ** Start of MD020772
     C+ F1BAV1/1000, F1AVA1/1000,
      ** End of   MD020772
     C+ DATE(F1DAT1+719892), DATE(F1DAT2+719892) ,DATE(F1OAD+719892),
     C+ F1IABC, AC.ACNO, AC.ANAM, AC.MINB,
     C+ CONCAT(F1BRCA, CONCAT(F1CNUM, CONCAT(F1CCY, CONCAT(digits (F1ACOD),
     C+  digits (F1ACSQ))))) AS RTREF
     C+ FROM  GZGLACNTQD A
     C+ INNER JOIN GZACCNTAB AC
     C+  ON A.F1CNUM = AC.CNUM AND A.F1CCY = AC.CCY AND A.F1ACOD = AC.ACOD
     C+  AND A.F1ACSQ = AC.ACSQ AND A.F1BRCA = AC.BRCA
     C+ LEFT JOIN GZSDCURRPD CU
     C+  ON A.F1CCY = CU.A6CYCD
      ** Start of MD020772
     C+ WHERE CU.A6NBDP = 3
     C/END-EXEC
     C/EXEC SQL
     C+ INSERT INTO GPACNTTD
     C+ SELECT
     C+ F1BRCA, F1CNUM, F1CCY, F1ACOD, F1ACSQ,
     C+ F1BAV1/100, F1AVA1/100,
     C+ DATE(F1DAT1+719892), DATE(F1DAT2+719892) ,DATE(F1OAD+719892),
     C+ F1IABC, AC.ACNO, AC.ANAM, AC.MINB,
     C+ CONCAT(F1BRCA, CONCAT(F1CNUM, CONCAT(F1CCY, CONCAT(digits (F1ACOD),
     C+  digits (F1ACSQ))))) AS RTREF
     C+ FROM  GZGLACNTQD A
     C+ INNER JOIN GZACCNTAB AC
     C+  ON A.F1CNUM = AC.CNUM AND A.F1CCY = AC.CCY AND A.F1ACOD = AC.ACOD
     C+  AND A.F1ACSQ = AC.ACSQ AND A.F1BRCA = AC.BRCA
     C+ LEFT JOIN GZSDCURRPD CU
     C+  ON A.F1CCY = CU.A6CYCD
     C+ WHERE CU.A6NBDP = 2
     C/END-EXEC
     C/EXEC SQL
     C+ INSERT INTO GPACNTTD
     C+ SELECT
     C+ F1BRCA, F1CNUM, F1CCY, F1ACOD, F1ACSQ,
     C+ F1BAV1/10, F1AVA1/10,
     C+ DATE(F1DAT1+719892), DATE(F1DAT2+719892) ,DATE(F1OAD+719892),
     C+ F1IABC, AC.ACNO, AC.ANAM, AC.MINB,
     C+ CONCAT(F1BRCA, CONCAT(F1CNUM, CONCAT(F1CCY, CONCAT(digits (F1ACOD),
     C+  digits (F1ACSQ))))) AS RTREF
     C+ FROM  GZGLACNTQD A
     C+ INNER JOIN GZACCNTAB AC
     C+  ON A.F1CNUM = AC.CNUM AND A.F1CCY = AC.CCY AND A.F1ACOD = AC.ACOD
     C+  AND A.F1ACSQ = AC.ACSQ AND A.F1BRCA = AC.BRCA
     C+ LEFT JOIN GZSDCURRPD CU
     C+  ON A.F1CCY = CU.A6CYCD
     C+ WHERE CU.A6NBDP = 1
     C/END-EXEC
     C/EXEC SQL
     C+ INSERT INTO GPACNTTD
     C+ SELECT
     C+ F1BRCA, F1CNUM, F1CCY, F1ACOD, F1ACSQ,
     C+ F1BAV1, F1AVA1,
     C+ DATE(F1DAT1+719892), DATE(F1DAT2+719892) ,DATE(F1OAD+719892),
     C+ F1IABC, AC.ACNO, AC.ANAM, AC.MINB,
     C+ CONCAT(F1BRCA, CONCAT(F1CNUM, CONCAT(F1CCY, CONCAT(digits (F1ACOD),
     C+  digits (F1ACSQ))))) AS RTREF
     C+ FROM  GZGLACNTQD A
     C+ INNER JOIN GZACCNTAB AC
     C+  ON A.F1CNUM = AC.CNUM AND A.F1CCY = AC.CCY AND A.F1ACOD = AC.ACOD
     C+  AND A.F1ACSQ = AC.ACSQ AND A.F1BRCA = AC.BRCA
     C+ LEFT JOIN GZSDCURRPD CU
     C+  ON A.F1CCY = CU.A6CYCD
     C+ WHERE CU.A6NBDP = 0
      ** End of   MD020772
     C/END-EXEC
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      /EJECT
 
