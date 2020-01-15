     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
     H FIXNBR(*NOINPUTPACKED)
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Recalculate facilities in LETFHAPD')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  RPGLE/UTLE0793 - Program to patch Facility History file      *
      *                                                               *
      *  Function:  This program updates files FACHISA, FACHISH and   *
      *             FACACT. This program runs in two modes according  *
      *             to the parameter being passed into it.            *
      *                                                               *
      *                1. Audit ('A') - passed when checking the      *
      *                      total number of facilities to be         *
      *                      triggered for recalculation.             *
      *                2. Update('U') - passed when updating records  *
      *                      in FACHISA, FACHISH and FACACT.          *
      *                                                               *
      *  Called By: UTCLE0793 - CL program                            *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. AR674226           Date 04Dec19               *
      *  Prev Amend No. MD046248           Date 05Feb18               *
      *                 MD022057 *CREATE   Date 08Nov16               *
      *                 Xxxxxxxx           Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022057 - Recalculate facilities in LETFHAPD.               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FUTLE0793PDIF   E           K DISK    INFSR(*PSSR)
     FLETFHAPD  IF   E           K DISK    INFSR(*PSSR)
     FFCLTYL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FM_)
     FCLOANC    IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     PREFIX(C1_)
     FMLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:MCLONCLF)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     PREFIX(M1_)
     FFACHISHL  UF   E           K DISK    INFSR(*PSSR)
     FFACACT    UF A E           K DISK    INFSR(*PSSR)
     FHISUPD    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FACHISAF:FACHIS2F)
     F                                     IGNORE(HISACTF)
     F                                     PREFIX(F2_)
     FUTLE0793P1O    E             PRINTER OFLIND(*IN89)

      *****************************************************************
      *                                                               *
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *   12 -  No Details to Report                                  *
      *   16 -  Update mode                                           *
      *   80 -  EOF in LETFHAPD                                       *
      *   82 -  Chain to Matured Loan's file 'A' record               *
      *   83 -  EOF in UTLE0793PD                                     *
      *   86 -  Chain to facility history header                      *
      *   87 -  Chain to Loan's file 'A' record                       *
      *   88 -  Read to HISUPD                                        *
      *   89 -  Overflow UTLE0793P1                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * InzSR  - Initialization subroutine                            *
      * ChkForUpdate - Update FACHISA temporarily                     *
      * *PSSR  - Error processing                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /SPACE 5
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** Rundate data structure.

     D RUNDAT        E DS                  EXTNAME(RUNDAT)

      ** Data structure for Currency details.

     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** General Ledger Details.

     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Bank Details.

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data structure for Access Program.

     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D FacUpdate       S              1A   INZ(*blanks)
     D WFCLTY          S              5A   INZ(*blanks)

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /SPACE 5
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   WRITE     HEADER1
      *
      ** Check all LIVE facilities.
      *
     C                   READ      LETFHAPD                               80
      *
     C                   DOW       *IN80 = '0'
      *
     C                   MOVE      DUPBRC        HBRCA             3
     C                   MOVE      'A'           WRCDT             1
     C                   MOVEL     DUPFAC        WFACT             3 0
     C                   MOVE      DUPFAC        WFCNO             2 0
     C     KEY003        CHAIN     FCLTYL1                            81
      *
     C                   IF        *IN81 = '0' and FM_RECI = 'D'
     C                   EVAL      FacUpdate = ' '
      *
      ** Check all facility loan records in history file.
      *
     C     KEY001        SETLL     FACHISAF
     C     KEY001        READE     FACHISAF                               83
      *
     C                   DOW       *IN83 = '0'
      *
      ** Find record in CLOANCL.
      *
     C     KEY002        CHAIN     CLOANC                             87
      *
      ** If loan not found on CLOANCL, check on MCLONCL.
      *
     C                   IF        *IN87 = '1'
     C     KEY002        CHAIN     MLOAN                              82
      *
     C                   IF        *IN87 = '1' and *IN82 = '1'
     C                   EXSR      ChkForUpdate
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      FacUpdate = 'Y'
      *
     C                   IF        FacUpdate = 'Y'
      *
      ** Setup report details.
      *
     C                   EVAL      WFACER = 'ERROR'
     C                   MOVE      DUPFAC        WFCLTY
      *
      ** Update FACHISH and FACACT to recalculate facility on COB.
      *
     C                   IF        *IN16 = '1'
      *
     C     KEY003        CHAIN     FACHISHF                           86
      *
     C                   IF        *IN86 = '0'
     C                   EVAL      FHRWKR = 'Y'
     C     KEY001        SETLL     FACHIS2F
     C                   READ      FACHIS2F                               88
     C                   EVAL      FHRWDT = F2_FADATE
     C                   EVAL      FHRWTP = 'M'
     C                   UPDATE    FACHISHF
      *
     C     KEY001        CHAIN     FACACTF                            86
      *
     C                   IF        *IN86 = '1'
     C                   EVAL      BRCA = HBRCA
     C                   EVAL      FCCNUM = F2_FACNUM
     C                   EVAL      FCFCTY = F2_FAFCTY
     C                   EVAL      FCDATE = F2_FADATE
     C                   WRITE     FACACTF
     C                   ELSE
     C                   EVAL      FCDATE = F2_FADATE
     C                   UPDATE    FACACTF
     C                   ENDIF
      *
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBFILE = 'FACHISH'
     C                   EVAL      DBKEY = HBRCA + DUPNUM + WFCLTY
     C                   EVAL      DBPGM = 'UTLE0793'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   IF        *IN89 = '1'
     C                   ADD       1             PAGE
     C                   WRITE     HEADER1
     C                   EVAL      *IN89 = '0'
     C                   ENDIF
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     KEY001        READE     FACHISAF                               83
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Accumulate facilities in error.
      *
     C                   IF        WFACER = 'ERROR'
     C                   ADD       1             FACERR
     C                   EVAL      WFACER = *BLANKS
      *
     C                   IF        *IN89 = '1'
     C                   ADD       1             PAGENO
     C                   WRITE     HEADER1
     C                   EVAL      *IN89 = '0'
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   ENDIF
      *
     C                   READ      LETFHAPD                               80
     C                   ENDDO
      *
      ** Write Footer.
      *
     C/EXEC SQL
     C+  SELECT COUNT(*) INTO :FACAUD
     C+  FROM FCLTYFM
     C+  WHERE
     C+  RECI = 'D'
     C/END-EXEC
     C                   IF        FACERR = 0
     C                   EVAL      *IN12 = '1'
     C                   ENDIF
     C                   WRITE     TRAILER1
      *
     C                   EVAL      *INLR = '1'
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkForUpdate - Do temporary update of FACHISA so that         *
      *                facility recalculation will not be impacted    *
      *                by unknown record.                             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ChkForUpdate  BEGSR
      *
     C                   IF        *IN16 = '1'
      *
     C/EXEC SQL
     C+  UPDATE FACHISA
     C+  SET FAREVI = 'R', FALCRF = 'DELETE'
     C+  WHERE
     C+  BRCA   = :DUPBRC AND
     C+  FACNUM = :DUPNUM AND
     C+  FAFCTY = :DUPFAC AND
     C+  FALOAN = :FALOAN AND
     C+  FAREVI = ' ' AND
     C+  FAPTYP IN(61, 68) AND
     C+  FAACTN IN('ST', 'PI')
     C/END-EXEC
      *
     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *InzSR        BEGSR
      *
      ** Parameter Entry List.
      *
     C     *Entry        PLIST
     C                   PARM                    Mode              1
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check mode is AUDIT or UPDATE.
      *
     C                   IF        Mode = 'U'
     C                             OR Mode = 'u'
     C                   EVAL      *IN16 = '1'
     C                   ELSE
     C                   EVAL      *IN16 = '0'
     C                   ENDIF
      *
     C     KEY001        KLIST
     C                   KFLD                    HBRCA
     C                   KFLD                    DUPNUM
     C                   KFLD                    DUPFAC
      *
     C     KEY002        KLIST
     C                   KFLD                    FALOAN
     C                   KFLD                    WRCDT
      *
     C     KEY003        KLIST
     C                   KFLD                    HBRCA
     C                   KFLD                    DUPNUM
     C                   KFLD                    WFACT
     C                   KFLD                    WFCNO
      *
     C                   EVAL      *IN12 = '0'
     C                   Z-ADD     0             PAGENO            2 0
     C                   Z-ADD     0             FACAUD            7 0
     C                   Z-ADD     0             FACERR            7 0
     C                   MOVE      *BLANKS       WFACER            5
      *
      ** Access bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = @OPTN                                *************
     C                   EVAL      DBPGM = 'UTLE0793'                           * DBERR 001 *
     C                   EVAL      DBASE = 001                                  *************
     C                   OUT       LDA
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
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
      *
     C                   IF        @RUN = *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2016
