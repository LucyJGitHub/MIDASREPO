     H DEBUG
     H COPYRIGHT('(c)Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas Data correction for SCHLPBTD/XTD')               *
      *****************************************************************
      *                                                               *
      *  Midas - Utility                                              *
      *                                                               *
      *  UP003013- Midas Data correction for HelpText files XTD/BTD   *
      *                                                               *
      *  Function: Update bespoke files SCHLPBTD and SCHLPXTD         *
      *                                                               *
      *  (c)Finastra International Limited 2022                       *
      *                                                               *
      *  Last Amend No. MD060296  *CREATE  Date 15Aug22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060296 - Help text is not available for FT Outgoing        *                             
      *             Fix is to add the record (FTOPAY1DF.FTOPAY1DX)    *
      *             in Help Text files (SCHLPBTD and SCHLPXTD).       *
      *             Tag will be the same as FTOPAY1DF.FTOPAY1D1       *
      *                                                               *
      *****************************************************************
     C/EXEC SQL
     C+ Insert into SCHLPBTD
     C+ (HPJSP, HPHTAG, HPMODE)
     C+ select
     C+    'FTOPAY1DF.FTOPAY1DX',
     C+    HPHTAG,
     C+    'B' FROM SCHLPCTD
     C+ where HPJSP='FTOPAY1DF.FTOPAY1D1'
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
     C/EXEC SQL
     C+ Insert into SCHLPXTD
     C+    (HPJSP, HPMODE)
     C+    Values('FTOPAY1DF.FTOPAY1DX','B')
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
