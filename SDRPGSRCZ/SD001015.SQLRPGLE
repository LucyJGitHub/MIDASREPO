     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Housekeeping of ARR Daily Rates file')        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SD001015 - Housekeeping of ARR Daily Rates file.             *
      *             Transactions in historical file must be housekept *
      *             as well during the housekeeping of main           *
      *             transaction file.                                 *
      *                                                               *
      *  Function: This program will delete the transaction in ARR    *
      *            Daily Rates file if the main transaction is deleted*
      *            in main transaction file.                          *
      *                                                               *
      *  (c)Finastra International Limited 2020                       *
      *                                                               *
      *  Last Amend No. CSD103    *CREATE  Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
     FSDHSDRTL1 IF   E           K DISK    INFSR(*PSSR)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
      *
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D CTRNIDX         S              6A
     D thisSQL         S            500
     D thisSQL1        S            500
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     C     *LOVAL        SETLL     SDHSDRTL1
     C                   READ      SDHSDRT0                             3545
      *
      ** Database error
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDHSDRT0'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Start loop
      *
     C                   DOW       EndOfFile = False
      *
     C                   MOVEL     CTRNID        CTRNIDX
      *
      ** Processing of Lending Transactions
      *
     C     CMODID        IFEQ      'LE'
     C                   EXSR      SRLending
     C                   ENDIF
      *
      ** Processing of Dealing Transactions
      *
     C     CMODID        IFEQ      'DL'
     C                   MOVEL     CTRNID        CTRNIDDL          6 0
     C                   EXSR      SRDealing
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      SDHSDRT0                             3545
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C                   EVAL      DBFile = 'SDHSDRT0'
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *                                                               *
      * SRLending - Processing of Lending Transactions                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRLending     BEGSR
     C     CTRNID        CHAIN     CLOANCLF                           90
      *
      ** If no record found, delete the transactions
      *
     C                   IF        *IN90 = '1'
     C                   EVAL      thisSQL = 'Delete from SDHSDRTD where +
     C                              CTRNID = '+CTRNIDX+''
     C                   EVAL      thisSQL1 = 'Delete from SDARRLOGTD where +
     C                              SJTREF = '+CTRNIDX+''
      *
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL1
     C/END-EXEC
      *
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRDealing - Processing of Dealing Transactions                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDealing     BEGSR
     C     CTRNIDDL      CHAIN     DEALSDCF                           91
      *
      ** If not existing in DEALSDC, check DEALSDG
      *
     C                   IF        *IN91 = '1'
     C     CTRNIDDL      CHAIN     DEALSDGF                           92
      *
      ** If still not existing, delete the transactions
      *
     C                   IF        *IN92 = '1'
     C                   EVAL      thisSQL = 'Delete from SDHSDRTD where +
     C                              CTRNID = '+CTRNIDX+''
     C                   EVAL      thisSQL1 = 'Delete from SDARRLOGTD where +
     C                              SJTREF = '+CTRNIDX+''
      *
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL1
     C/END-EXEC
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
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
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2020
