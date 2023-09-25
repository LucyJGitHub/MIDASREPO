     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas Generate BTD/XTD record for BA8020')             *
      *****************************************************************
      *                                                               *
      *  Midas - Utility                                              *
      *                                                               *
      *  UP003014 - Generate BTD and XTD record for feature BA8020    *
      *                                                               *
      *  Function: Update bespoke files GPCSECBTD and GPSECXTD        *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD061877  *CREATE  Date 15Sep23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061877 - Add record for bespoke feature BA8020 in          *
      *             Global Password Files (GPSECBTD and GPSECXTD).    *
      *                                                               *
      *****************************************************************
     C/EXEC SQL
     C+ Insert into GPSECBTD
     C+ (RECI, P@SARN, SEPASS, SEINTL, REMODE)
     C+ Values('B', 'BA8020', 'DHJBCIMJCTDKHANH', 'N', 'B')
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ Insert into GPSECXTD
     C+ (P@SARN, REMODE)
     C+ Values('BA8020','B')
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
