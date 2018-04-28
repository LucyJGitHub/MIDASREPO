     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas Data correction for GPAMADPD')
      *****************************************************************
      *                                                               *
      *  Midas - Utility                                              *
      *                                                               *
      *  UT000315 - Midas Data correction for GPAMADPD                *
      *                                                               *
      *  Function: Synchronizes the zone's SDCUSTPD to GPAMADPD       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD026387  *CREATE  Date 15Apr14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026387 - Reconciliation issue with GPAMADPD                *
      *                                                               *
      *****************************************************************
 
     ** For CGCSSN
 
     C/EXEC SQL
     C+ Update GPAMADPD A
     C+ set A.CGCSSN = (Select BBCSSN from SDCUSTPD B
     C+ where A.CNUM = B.BBCUST)
     C+ where exists
     C+ (Select * from SDCUSTPD B where A.CNUM = B.BBCUST
     C+ and A.CGCSSN <> B.BBCSSN)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
 
     ** For CGRNM
 
     C/EXEC SQL
     C+ Update GPAMADPD A
     C+ set A.CGRNM = (Select BBCRNM from SDCUSTPD B
     C+ where A.CNUM = B.BBCUST)
     C+ where exists
     C+ (Select * from SDCUSTPD B where A.CNUM = B.BBCUST
     C+ and A.CGRNM <> B.BBCRNM)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
 
     ** For CGRTN
 
     C/EXEC SQL
     C+ Update GPAMADPD A
     C+ set A.CGRTN = (Select BBCRTN from SDCUSTPD B
     C+ where A.CNUM = B.BBCUST)
     C+ where exists
     C+ (Select * from SDCUSTPD B where A.CNUM = B.BBCUST
     C+ and A.CGRTN <> B.BBCRTN)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
 
     ** For CGCNCZ
 
     C/EXEC SQL
     C+ Update GPAMADPD A
     C+ set A.CGCNCZ = (Select BBCNCZ from SDCUSTPD B
     C+ where A.CNUM = B.BBCUST)
     C+ where exists
     C+ (Select * from SDCUSTPD B where A.CNUM = B.BBCUST
     C+ and A.CGCNCZ <> B.BBCNCZ)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
 
     ** For CGCOLC
 
     C/EXEC SQL
     C+ Update GPAMADPD A
     C+ set A.CGCOLC = (Select BBCOLC from SDCUSTPD B
     C+ where A.CNUM = B.BBCUST)
     C+ where exists
     C+ (Select * from SDCUSTPD B where A.CNUM = B.BBCUST
     C+ and A.CGCOLC <> B.BBCOLC)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
 
     ** For CGBRCD
 
     C/EXEC SQL
     C+ Update GPAMADPD A
     C+ set A.CGBRCD = (Select BBBRCD from SDCUSTPD B
     C+ where A.CNUM = B.BBCUST)
     C+ where exists
     C+ (Select * from SDCUSTPD B where A.CNUM = B.BBCUST
     C+ and A.CGBRCD <> B.BBBRCD)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
 
     ** For CGCUST
 
     C/EXEC SQL
     C+ Update GPAMADPD A
     C+ set A.CGCUST = (Select BBCUST from SDCUSTPD B
     C+ where A.CNUM = B.BBCUST)
     C+ where exists
     C+ (Select * from SDCUSTPD B where A.CNUM = B.BBCUST
     C+ and A.CGCUST <> B.BBCUST)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
 
     ** For CGZONE
 
     C/EXEC SQL
     C+ Update GPAMADPD A
     C+ set A.CGZONE = 'MOSCOW'
     C+ where A.CGZONE = ' '
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
 
     ** For CGACO
 
     C/EXEC SQL
     C+ Update GPAMADPD A
     C+ set A.CGACO = (Select BBACOC from SDCUSTPD B
     C+ where A.CNUM = B.BBCUST)
     C+ where exists
     C+ (Select * from SDCUSTPD B where A.CNUM = B.BBCUST
     C+ and A.CGACO <> B.BBACOC)
     C/END-EXEC
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
 
     ** For CGGLOB
 
     C/EXEC SQL
     C+ Update GPAMADPD A
     C+ set A.CGGLOB = (Select CONCAT(CONCAT(BBBRCD,'-'),BBCUST)
     C+ from SDCUSTPD B where A.CNUM = B.BBCUST)
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
