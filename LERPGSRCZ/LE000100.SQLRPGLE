     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Reconciliation Report')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000100 - Extension Files (*QD) Reconciliation              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 MD021155 *REWRITE  Date 09Jul13               *
      *                 AR407323           Date 04Dec12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 BUG9020            Date 13Jan06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10705R          Date 09Mar06               *
      *                 BUG10705           Date 28Feb06               *
      *                 BUG10315           Date 07Feb06               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG3937            Date 10Sep04               *
      *                 BUG3830 *CREATE    Date 17Jun04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD021155 - COB Restructure Phase 1 remnants                  *
      *           - Program not rewritten. Parameter mismatch.        *
      *  AR407323 - For newly inserted deals that are 'Reversed'.     *
      *             records are not found in FXDEALPP even if it is   *
      *             actually present.  Fix is not check the branch    *
      *             since this is already redundant.                  *
      *           - Applied for AR991584 (Child: AR991586)            *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG9020 - LEC000100 failed due to missing recs in DLDLDBQD/  *
      *            DEALSDB and DLDLDGQD but missing from DEALSDG      *
      *            (similar fix as BUG10705)                          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10705R- Amend initial fix and delete extension records in *
      *             FX0690 which runs in COB daily.  FXDEALPP should  *
      *             also be checked.                                  *
      *  BUG10705 - LE000100 failed due to missing recs in DEALSDB    *
      *             but existing in DLDLDBQD.                         *
      *  BUG10315 - LDNI: Amend System allowed amendment of matured   *
      *             deal                                              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG3937 - Check extension files against DEALSDB instead of   *
      *            FXDEALPP.                                          *
      *  BUG3830 - Credit Lines Extension Files Reconciliation        *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Main Processing Routine                                       *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PFNAME            8

      ** Process the files based on the parameter passed

     C                   SELECT

     C                   WHEN      PFNAME = 'DLDLDBQD'
     C                   EXSR      DEALBSR

     C                   WHEN      PFNAME = 'DLDLDCQD'
     C                   EXSR      DEALCSR

     C                   WHEN      PFNAME = 'DLDLDGQD'
     C                   EXSR      DEALGSR

     C                   WHEN      PFNAME = 'GLACNTQD'
     C                   EXSR      GLACSR

     C                   WHEN      PFNAME = 'LEFCLTQD'
     C                   EXSR      FCLTYSR

     C                   ENDSL

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DEALBSR - Process DLDLDBQD records                           *
      *                                                               *
      *****************************************************************
     C     DEALBSR       BEGSR

      ** If a deal exists on DLDLDBQD but does not exist on DEALSDB,
      ** DLBHISPD and FXDEALPP, then delete record from DLDLDBQD.

     C/EXEC SQL
     C+ delete from DLDLDBQD A where
     C+   not exists (select * from DEALSDB  B where A.F1DLNO = B.DLNO) and
     C+   not exists (select * from FXDEALPP C where A.F1DLNO = C.FHDN38) and
     C+   not exists (select * from DLBHISPD D where A.F1DLNO = D.DLNO)
     C+ with NC
     C/END-EXEC

     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If a deal exists on DEALSDB but does not exist on DLDLDBQD,
      ** then insert record into DLDLDBQD.

     C/EXEC SQL
     C+ insert into DLDLDBQD (F1BRCA, F1DLNO)
     C+   select BRCA, DLNO from DEALSDB A where not exists
     C+     (select * from DLDLDBQD B where A.DLNO = B.F1DLNO)
     C+ with NC
     C/END-EXEC

     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DEALCSR - Process DLDLDCQD records                           *
      *                                                               *
      *****************************************************************
     C     DEALCSR       BEGSR

      ** If a deal exists on DLDLDCQD but does not exist on DEALSDC,
      ** DLCHISPD and MMDELDPP, then delete record from DLDLDCQD.

     C/EXEC SQL
     C+ delete from DLDLDCQD A where
     C+   not exists (select * from DEALSDC  B where A.F1DLNO = B.DLNO) and
     C+   not exists (select * from MMDELDPP C where A.F1DLNO = C.HKDN38) and
     C+   not exists (select * from DLCHISPD D where A.F1DLNO = D.DLNO)
     C+ with NC
     C/END-EXEC

     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If a deal exists on DEALSDC but does not exist on DLDLDCQD,
      ** then insert record into DLDLDCQD.

     C/EXEC SQL
     C+ insert into DLDLDCQD (F1BRCA, F1DLNO)
     C+   select BRCA, DLNO from DEALSDC A where not exists
     C+     (select * from DLDLDCQD B where A.DLNO = B.F1DLNO)
     C+ with NC
     C/END-EXEC

     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DEALGSR - Process DLDLDGQD records                           *
      *                                                               *
      *****************************************************************
     C     DEALGSR       BEGSR

      ** If a deal exists on DLDLDGQD but does not exist on DEALSDG and
      ** DLGHISPD, then delete record from DLDLDGQD.

     C/EXEC SQL
     C+ delete from DLDLDGQD A where
     C+   not exists (select * from DEALSDG  B where A.F1DLNO = B.DLNO) and
     C+   not exists (select * from DLGHISPD C where A.F1DLNO = C.DLNO)
     C+ with NC
     C/END-EXEC

     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If a deal exists on DEALSDG but does not exist on DLDLDGQD,
      ** then insert record into DLDLDGQD.

     C/EXEC SQL
     C+ insert into DLDLDGQD (F1BRCA, F1DLNO)
     C+   select BRCA, DLNO from DEALSDG A where not exists
     C+     (select * from DLDLDGQD B where A.DLNO = B.F1DLNO)
     C+ with NC
     C/END-EXEC

     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLACSR - Process GLACNTQD records                            *
      *                                                               *
      *****************************************************************
     C     GLACSR        BEGSR

      ** If an account exists on GLACNTQD but does not exist on ACCNTAB,
      ** then delete record from GLACNTQD.

     C/EXEC SQL
     C+ delete from GLACNTQD A where not exists
     C+   (select * from ACCNTAB B where
     C+   A.F1CNUM = B.CNUM and A.F1CCY  = B.CCY and A.F1ACOD = B.ACOD and
     C+   A.F1ACSQ = B.ACSQ and A.F1BRCA = B.BRCA)
     C+ with NC
     C/END-EXEC

     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If an account exists on ACCNTAB but does not exist on GLACNTQD,
      ** then insert record into GLACNTQD.

     C/EXEC SQL
     C+ insert into GLACNTQD (F1CNUM, F1CCY, F1ACOD, F1ACSQ, F1BRCA)
     C+   select CNUM, CCY, ACOD, ACSQ, BRCA from ACCNTAB A where not exists
     C+     (select * from GLACNTQD B where
     C+     A.CNUM = B.F1CNUM and A.CCY  = B.F1CCY and A.ACOD = B.F1ACOD and
     C+     A.ACSQ = B.F1ACSQ and A.BRCA = B.F1BRCA)
     C+ with NC
     C/END-EXEC

     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FCLTYSR - Process LEFCLTQD records                           *
      *                                                               *
      *****************************************************************
     C     FCLTYSR       BEGSR

      ** If a facility exists on LEFCLTQD but does not exist on FCLTYFM,
      ** then delete record from LEFCLTQD.

     C/EXEC SQL
     C+ delete from LEFCLTQD A where not exists
     C+   (select * from FCLTYFM B where A.FCXFCU = B.CNUM and
     C+   A.FCXFTP = B.FACT and A.FCXFNO = B.FCNO)
     C+ with NC
     C/END-EXEC

     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If a facility exists on FCLTYFM but does not exist on LEFCLTQD,
      ** then insert record into LEFCLTQD.

     C/EXEC SQL
     C+ insert into LEFCLTQD (FCXFCU, FCXFTP, FCXFNO, FCXBRC)
     C+   select CNUM, FACT, FCNO, BRCA from FCLTYFM A where not exists
     C+     (select * from LEFCLTQD B where A.CNUM = B.FCXFCU and
     C+     A.FACT = B.FCXFTP and A.FCNO = B.FCXFNO)
     C+ with NC
     C/END-EXEC

     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C     RunBefore     IFEQ      *BLANKS
     C                   MOVE      'Y'           RunBefore         1
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN
     C                   ENDSR
      *****************************************************************
