     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Generate BTD/XTD record for BA8020')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Utility                                              *
      *                                                               *
      *  UP003015 - Generate BTD and XTD record for feature BA8020    *
      *                                                               *
      *  Function: Update bespoke files SCSRSBTD and SCSRSXTD         *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD061877  *CREATE  Date 15Sep23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061877 - Add record for bespoke feature BA8020 in All      *
      *             Switchable Features Files (SCSRSBTD and SCSRSXTD) *
      *                                                               *
      *****************************************************************
     C/EXEC SQL
     C+ Insert into SCSRSBTD
     C+ (AXSARN, AXSARD, AXPRIM, AXCEMI, AXRELL, AXIREL, AXCLVL,
     C+  AXRSTS, AXDFLT, AXMNTB, AXCHRG, AXFLRN, AXDOCN, AXHELP,
     C+  AXPROT, AXMODE)
     C+ Values('BA8020',
     C+        'Enable Inter.Pel Transmission of SWIFT Messages',
     C+        'MS',
     C+        'N',
     C+        'FM2021',
     C+        '00',
     C+        'GEN',
     C+        'R',
     C+        'OFF',
     C+        'B',
     C+        '',
     C+        '',
     C+        '',
     C+        '',
     C+        'Y',
     C+        'B')
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ Insert into SCSRSXTD
     C+    (AXSARN, AXMODE)
     C+    Values('BA8020', 'B')
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      *INLR = '1'
     C                   RETURN
      *****************************************************************
      *    *PSSR                                                      *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   DUMP
     C                   RETURN
     C
     C                   ENDSR
     C*****************************************************************
