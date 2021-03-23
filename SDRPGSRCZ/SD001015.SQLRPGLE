000100210302     H DEBUG
000101210302     H COPYRIGHT('(c) Finastra International Limited 2020')
000102210302      *****************************************************************
000103210302/*STD *  RPGSQLBND                                                    *
000104210302/*EXI *  TEXT('Midas SD Housekeeping of ARR Daily Rates file')        *
000105210302      *****************************************************************
000106210302      *                                                               *
000107210302      *  Midas - Implementation Module                                *
000108210302      *                                                               *
000109210308      *  SD001015 - Housekeeping of ARR Daily Rates file.             *
000110210302      *             Transactions in historical file must be housekept *
000111210302      *             as well during the housekeeping of main           *
000112210302      *             transaction file.                                 *
000113210302      *                                                               *
000114210302      *  Function: This program will delete the transaction in ARR    *
000115210302      *            Daily Rates file if the main transaction is deleted*
000116210302      *            in main transaction file.                          *
000117210302      *                                                               *
000118210302      *  (c)Finastra International Limited 2020                       *
000119210302      *                                                               *
000120210302      *  Last Amend No. CSD103    *CREATE  Date 10Aug20               *
000121210302      *                                                               *
000122210302      *---------------------------------------------------------------*
000123210302      *                                                               *
000124210302      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
000125210302      *                                                               *
000126210302      *****************************************************************
000128210323     FSDHSDRTL1 IF   E           K DISK    INFSR(*PSSR)
000130210302     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
000131210302     F                                     IGNORE(CLOANCKF)
000132210302     F                                     IGNORE(CLOANZ1F)
000133210302     FDEALS     IF   E           K DISK    INFSR(*PSSR)
000134210302     F                                     IGNORE(DEALSDAF)
000135210302     F                                     IGNORE(DEALSDBF)
000136210302     F                                     IGNORE(DEALSDDF)
000137210302     F                                     IGNORE(DEALSDEF)
000138210302     F                                     IGNORE(DEALSDFF)
000139210302      *
000140210302      **---------------------------------------------------------------
000141210302      ** The following /COPY line includes all the defined fields in
000142210302      ** the Program Status Data Structures.  They have meaningful
000143210302      ** names, prefixed by 'PS'.
000144210302     D/COPY ZACPYSRC,PSDS
000145210302     D/COPY ZACPYSRC,STD_D_SPEC
000146210302      *
000147210302      ** +--------------------------------------+
000148210302      ** ¦ Variable declaration                 ¦
000149210302      ** ¦ ====================                 ¦
000150210302      ** +--------------------------------------+
000152210302     D CTRNIDX         S              6A
000154210302     D thisSQL         S            500
000155210302     D thisSQL1        S            500
000157210302      ** Indicator Array
000158210302     D Indicators      DS                  BASED(IndicatorP)
000159210302     D  ErrorOnFl             35     35
000160210302     D  EndOfFile             45     45
000161210302      ** Pointer for the indicator Array
000162210302     D IndicatorP      S               *   INZ(%Addr(*IN))
000163210302      *
000164210302      ** +--------------------------------------+
000165210302      ** ¦ End of D-specs                       ¦
000166210302      ** ¦ ==============                       ¦
000167210302      ** +--------------------------------------+
000168210302      *
000169210323     C     *LOVAL        SETLL     SDHSDRTL1
000170210302     C                   READ      SDHSDRT0                             3545
000171210302      *
000172210302      ** Database error
000173210302      *
000174210302     C                   IF        ErrorOnFl = True
000175210302     C     *LOCK         IN        LDA
000176210302     C                   EVAL      DBKey = '*FIRST'
000177210302     C                   EVAL      DBFile = 'SDHSDRT0'
000178210302     C                   EVAL      DBase = 1
000179210302     C                   OUT       LDA
000180210302     C                   EXSR      *PSSR
000181210302     C                   ENDIF
000182210302      *
000183210302      ** Start loop
000184210302      *
000185210302     C                   DOW       EndOfFile = False
000186210302      *
000187210302     C                   MOVEL     CTRNID        CTRNIDX
000188210302      *
000189210302      ** Processing of Lending Transactions
000190210302      *
000191210302     C     CMODID        IFEQ      'LE'
000192210302     C                   EXSR      SRLending
000193210302     C                   ENDIF
000194210302      *
000195210302      ** Processing of Dealing Transactions
000196210302      *
000197210302     C     CMODID        IFEQ      'DL'
000198210302     C                   MOVEL     CTRNID        CTRNIDDL          6 0
000199210302     C                   EXSR      SRDealing
000200210302     C                   ENDIF
000201210302      *
000202210302      ** Read next record
000203210302      *
000204210302     C                   READ      SDHSDRT0                             3545
000205210302      *
000206210302     C                   IF        ErrorOnFl = True
000207210302     C     *LOCK         IN        LDA
000208210302     C                   EVAL      DBKey = '*NEXT'
000209210302     C                   EVAL      DBFile = 'SDHSDRT0'
000210210302     C                   EVAL      DBase = 2
000211210302     C                   OUT       LDA
000212210302     C                   EXSR      *PSSR
000213210302     C                   ENDIF
000214210302      *
000215210302     C                   ENDDO
000216210302     C                   EVAL      *INLR = *ON
000217210302     C                   RETURN
000218210302      *****************************************************************
000219210302      *  P R O G R A M   E N D                                        *
000220210302      *****************************************************************
000221210302      *                                                               *
000222210302      * SRLending - Processing of Lending Transactions                *
000223210302      *                                                               *
000224210302      * Called by: Main Processing                                    *
000225210302      *                                                               *
000226210302      * Calls: None                                                   *
000227210302      *                                                               *
000228210302      *****************************************************************
000229210302     C     SRLending     BEGSR
000230210302     C     CTRNID        CHAIN     CLOANCLF                           90
000231210302      *
000232210302      ** If no record found, delete the transactions
000233210302      *
000234210302     C                   IF        *IN90 = '1'
000235210302     C                   EVAL      thisSQL = 'Delete from SDHSDRTD where +
000236210302     C                              CTRNID = '+CTRNIDX+''
000237210302     C                   EVAL      thisSQL1 = 'Delete from SDARRLOGTD where +
000238210302     C                              SJTREF = '+CTRNIDX+''
000241210302      *
000242210302     C/EXEC SQL
000243210302     C+ EXECUTE IMMEDIATE :thisSQL
000244210302     C/END-EXEC
000245210302     C/EXEC SQL
000246210302     C+ EXECUTE IMMEDIATE :thisSQL1
000247210302     C/END-EXEC
000251210302      *
000252210302     C                   ENDIF
000253210302     C                   ENDSR
000254210302      *****************************************************************
000255210302      *                                                               *
000256210302      * SRDealing - Processing of Dealing Transactions                *
000257210302      *                                                               *
000258210302      * Called by: Main Processing                                    *
000259210302      *                                                               *
000260210302      * Calls: None                                                   *
000261210302      *                                                               *
000262210302      *****************************************************************
000263210302     C     SRDealing     BEGSR
000264210302     C     CTRNIDDL      CHAIN     DEALSDCF                           91
000265210302      *
000266210302      ** If not existing in DEALSDC, check DEALSDG
000267210302      *
000268210302     C                   IF        *IN91 = '1'
000269210302     C     CTRNIDDL      CHAIN     DEALSDGF                           92
000270210302      *
000271210302      ** If still not existing, delete the transactions
000272210302      *
000273210302     C                   IF        *IN92 = '1'
000274210302     C                   EVAL      thisSQL = 'Delete from SDHSDRTD where +
000275210302     C                              CTRNID = '+CTRNIDX+''
000276210302     C                   EVAL      thisSQL1 = 'Delete from SDARRLOGTD where +
000277210302     C                              SJTREF = '+CTRNIDX+''
000280210302      *
000281210302     C/EXEC SQL
000282210302     C+ EXECUTE IMMEDIATE :thisSQL
000283210302     C/END-EXEC
000284210302     C/EXEC SQL
000285210302     C+ EXECUTE IMMEDIATE :thisSQL1
000286210302     C/END-EXEC
000287210302      *
000288210302     C                   ENDIF
000289210302     C                   ENDIF
000290210302     C                   ENDSR
000314210302      *****************************************************************
000315210302      *                                                               *
000316210302      *  *PSSR - Subroutine to handle error conditions                *
000317210302      *                                                               *
000318210302      *  Called from:  After abnormal operation occurs                *
000319210302      *                                                               *
000320210302      *  Calls: Nothing                                               *
000321210302      *                                                               *
000322210302      *****************************************************************
000323210302     C     *PSSR         BEGSR
000324210302
000325210302     C                   EVAL      *INU7 = '1'
000326210302     C                   EVAL      *INU8 = '1'
000327210302     C                   DUMP
000328210302     C                   RETURN
000329210302
000330210302     C                   ENDSR
000331210302      *****************************************************************
000332210302**  CPY@
000333210302(c) Finastra International Limited 2020
