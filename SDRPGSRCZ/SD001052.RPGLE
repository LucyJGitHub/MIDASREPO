000100210301     H DEBUG
000101210301     H COPYRIGHT('(c) Finastra International Limited 2020')
000102210301      *****************************************************************
000103210301/*STD *  RPGBASEBND                                                   *
000104210302/*EXI *  TEXT('Midas SD Housekeeping of ARR Daily Rates file')                 *
000105210301      *****************************************************************
000106210301      *                                                               *
000107210301      *  Midas - Implementation Module                                *
000108210301      *                                                               *
000109210302      *  SD001052 - Housekeeping of ARR Daily Rates file.             *
000110210302      *             Transactions in historical file must be housekept *
000111210302      *             as well during the housekeeping of main           *
000112210302      *             transaction file.                                 *
000113210301      *                                                               *
000114210302      *  Function: This program will delete the transaction in ARR    *
000115210302      *            Daily Rates file if the main transaction is deleted*
000116210302      *            in main transaction file.                          *
000117210301      *                                                               *
000118210301      *  (c)Finastra International Limited 2020                       *
000119210301      *                                                               *
000120210301      *  Last Amend No. CSD103    *CREATE  Date 10Aug20               *
000121210301      *                                                               *
000122210301      *---------------------------------------------------------------*
000123210301      *                                                               *
000124210301      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
000125210301      *                                                               *
000126210301      *****************************************************************
000127210301     FSDHISTSX  UF   E           K DISK    INFSR(*PSSR)
000128210301     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
000129210301     F                                     IGNORE(CLOANCKF)
000130210301     F                                     IGNORE(CLOANZ1F)
000131210301     FDEALS     IF   E           K DISK    INFSR(*PSSR)
000132210301     F                                     IGNORE(DEALSDAF)
000133210301     F                                     IGNORE(DEALSDBF)
000134210301     F                                     IGNORE(DEALSDDF)
000135210301     F                                     IGNORE(DEALSDEF)
000136210301     F                                     IGNORE(DEALSDFF)
000139210301      *
000140210301      **---------------------------------------------------------------
000141210301      ** The following /COPY line includes all the defined fields in
000142210301      ** the Program Status Data Structures.  They have meaningful
000143210301      ** names, prefixed by 'PS'.
000144210301     D/COPY ZACPYSRC,PSDS
000145210301     D/COPY ZACPYSRC,STD_D_SPEC
000146210301      *
000147210301      ** +--------------------------------------+
000148210301      ** ¦ Variable declaration                 ¦
000149210301      ** ¦ ====================                 ¦
000150210301      ** +--------------------------------------+
000151210301      ** Indicator Array
000152210301     D Indicators      DS                  BASED(IndicatorP)
000153210301     D  ErrorOnFl             35     35
000154210301     D  EndOfFile             45     45
000155210301      ** Pointer for the indicator Array
000156210301     D IndicatorP      S               *   INZ(%Addr(*IN))
000157210301      *
000158210301      ** +--------------------------------------+
000159210301      ** ¦ End of D-specs                       ¦
000160210301      ** ¦ ==============                       ¦
000161210301      ** +--------------------------------------+
000162210301      *
000163210301     C     *LOVAL        SETLL     SDHISTSX
000164210301     C                   READ      SDHISTS0                             3545
000165210301      *
000166210301      ** Database error
000167210301      *
000168210301     C                   IF        ErrorOnFl = True
000169210301     C     *LOCK         IN        LDA
000170210301     C                   EVAL      DBKey = '*FIRST'
000171210301     C                   EVAL      DBFile = 'SDHISTS0'
000172210301     C                   EVAL      DBase = 1
000173210301     C                   OUT       LDA
000174210301     C                   EXSR      *PSSR
000175210301     C                   ENDIF
000176210301      *
000177210301      ** Start loop
000178210301      *
000179210301     C                   DOW       EndOfFile = False
000181210301      ** Processing of Loans
000183210301     C     SDMOD         IFEQ      'LE'
000184210301     C                   EXSR      SRLoan
000185210301     C                   ENDIF
000186210301      *
000187210301     C     SDMOD         IFEQ      'DL'
000188210301     C                   MOVEL     SDREF         SDDLNO            6 0
000189210301      ** Processing of Deals
000190210301     C     SDTRAN        IFEQ      'DEAL'
000191210301     C                   EXSR      SRDeal
000192210301     C                   ENDIF
000193210301      ** Processing of IRS
000194210301     C     SDTRAN        IFEQ      'IRS'
000195210301     C                   EXSR      SRIRS
000196210301     C                   ENDIF
000197210301      *
000198210301     C                   ENDIF
000199210301      *
000200210301      ** Read next record
000201210301      *
000202210301     C                   READ      SDHISTS0                             3545
000203210301      *
000204210301     C                   IF        ErrorOnFl = True
000205210301     C     *LOCK         IN        LDA
000206210301     C                   EVAL      DBKey = '*NEXT'
000207210301     C                   EVAL      DBFile = 'SDHISTS0'
000208210301     C                   EVAL      DBase = 2
000209210301     C                   OUT       LDA
000210210301     C                   EXSR      *PSSR
000211210301     C                   ENDIF
000212210301      *
000213210301     C                   ENDDO
000214210301     C                   EVAL      *INLR = *ON
000215210301     C                   RETURN
000216210301      *****************************************************************
000217210301      *  P R O G R A M   E N D                                        *
000218210301      *****************************************************************
000219210301      *                                                               *
000220210301      * SRLoan - Update of Loan                                       *
000221210301      *                                                               *
000222210301      * Called by: Main Processing                                    *
000223210301      *                                                               *
000224210301      * Calls: None                                                   *
000225210301      *                                                               *
000226210301      *****************************************************************
000227210301     C     SRLoan        BEGSR
000228210301     C     SDREF         CHAIN     CLOANCLF                           90
000229210301     C                   IF        *IN90 = '1'
000230210301     C                   DELETE    SDHISTS0
000231210301     C                   ENDIF
000232210301     C                   ENDSR
000233210301      *****************************************************************
000234210301      *                                                               *
000235210301      * SRDeal - Update of Deal                                       *
000236210301      *                                                               *
000237210301      * Called by: Main Processing                                    *
000238210301      *                                                               *
000239210301      * Calls: None                                                   *
000240210301      *                                                               *
000241210301      *****************************************************************
000242210301     C     SRDeal        BEGSR
000243210301     C     SDDLNO        CHAIN     DEALSDCF                           90
000244210301     C                   IF        *IN90 = '1'
000245210301     C                   DELETE    SDHISTS0
000246210301     C                   ENDIF
000247210301     C                   ENDSR
000248210301      *****************************************************************
000249210301      *                                                               *
000250210301      * SRIRS - Update of IRS                                         *
000251210301      *                                                               *
000252210301      * Called by: Main Processing                                    *
000253210301      *                                                               *
000254210301      * Calls: None                                                   *
000255210301      *                                                               *
000256210301      *****************************************************************
000257210301     C     SRIRS         BEGSR
000258210301     C     SDDLNO        CHAIN     DEALSDGF                           90
000259210301     C                   IF        *IN90 = '1'
000260210301     C                   DELETE    SDHISTS0
000261210301     C                   ENDIF
000262210301     C                   ENDSR
000263210301
000264210301      *****************************************************************
000265210301      *                                                               *
000266210301      *  *PSSR - Subroutine to handle error conditions                *
000267210301      *                                                               *
000268210301      *  Called from:  After abnormal operation occurs                *
000269210301      *                                                               *
000270210301      *  Calls: Nothing                                               *
000271210301      *                                                               *
000272210301      *****************************************************************
000273210301     C     *PSSR         BEGSR
000274210301
000275210301     C                   EVAL      *INU7 = '1'
000276210301     C                   EVAL      *INU8 = '1'
000277210301     C                   DUMP
000278210301     C                   RETURN
000279210301
000280210301     C                   ENDSR
000281210301      *****************************************************************
000282210301**  CPY@
000283210301(c) Finastra International Limited 2020
