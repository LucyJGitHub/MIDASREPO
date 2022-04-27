     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM record Update of SCSQLSPD')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU90004 - Upgrade Utility for record Update of SCSQLSPD     *
      *                                                               *
      *  Function: This program will update bespoke records for table *
      *            SCSQLSPD.                                          *
      *                                                               *
      *  (c)Finastra International Limited 2020                       *
      *                                                               *
      *  Last Amend No. MDSC037735 *CREATE Date 26Apr22               *
      *  Prev Amend No. Xxnnnnnn           Date DDMMMYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MDSC037735 - Update record of SCSQLSPD for bespoke changes.  *
      *                                                               *
      *****************************************************************

     D createSQL       S            500
     D deleteSQL       S            500
     D PReturn         S              1A

     C                   EVAL      createSQL =
     C                             'CREATE VIEW QTEMP/VXXLOAMX0 AS SELECT ' +
     C                             'A.* FROM XXLOAMX0 A LEFT EXCEPTION ' +
     C                             'JOIN LOAMSDK B ON TRIM(A.SCLNRF) = ' +
     C                             'TRIM(B.LNRF) AND TRIM(A.SCVDAT) = ' +
     C                             'TRIM(B.VDAT) AND TRIM(CAST(A.SCLASN ' +
     C                             'AS INT)) = TRIM(B.LASN)'

     C                   EVAL      deleteSQL =
     C                             'DELETE FROM XXLOAMX0 WHERE (SCLNRF,' +
     C                             'SCVDAT,SCLASN) IN (SELECT SCLNRF,' +
     C                             'SCVDAT,SCLASN FROM VXXLOAMX0)'

     C/EXEC SQL
     C+ insert into SCSQLBTD
     C+ (
     C+   SQLSTMID
     C+  ,SQLCREAT
     C+  ,SQLDELET
     C+  ,SQMODE
     C+ )
     C+ values
     C+ (
     C+   '65'
     C+  ,:createSQL
     C+  ,:deleteSQL
     C+  ,'B'
     C+ )
     C/END-EXEC

     C                   IF        SQLCOD <> 0
     C                   EVAL      PReturn = 'E'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      *INLR = *ON

      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  Called from:  After abnormal operation occurs                *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   DUMP
     C                   RETURN

     C                   ENDSR
