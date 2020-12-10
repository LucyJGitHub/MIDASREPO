000100201209     H DEBUG
000110201209     H COPYRIGHT('(c) Finastra International Limited 2020')
000111201209      *****************************************************************
000112201209/*STD *  RPGSQLBND                                                    *
000113201209/*EXI *  TEXT('Midas LE Initialise CLE172 Fields in CLOANCL')         *
000114201209      *****************************************************************
000115201209      *                                                               *
000116201209      *  Midas - Implementation Module                                *
000117201209      *                                                               *
000118201209      *  LE001111 - Initialise CLE172 Fields in CLOANCL               *
000119201209      *                                                               *
000120201209      *  Function:  This program will run during Post Database        *
000121201209      *             Upgrade. It will select all existing base rates   *
000122201209      *             from CLOANCL. Then, it will set the               *
000123201209      *             Backward-Looking rate fields into their default   *
000124201209      *             values if they do not initially contain values    *
000125201209      *                                                               *
000126201209      *  (c) Finastra International Limited 2020                      *
000127201209      *                                                               *
000128201209      *  Last Amend No. CLE172    *CREATE  Date 01Oct20               *
000129201209      *                                                               *
000130201209      *---------------------------------------------------------------*
000131201209      *                                                               *
000132201209      *  CLE172 - LIBOR Deregulation - Lending                        *
000133201209      *                                                               *
000134201209      *****************************************************************
000135201209
000136201209     FSDBSRTL0  UF   E           K DISK    INFSR(*PSSR)
000137201209      ** Midas SD Base Rate Codes File
000138201209
000139201209      *****************************************************************
000140201209      /EJECT
000141201209      *****************************************************************
000142201209
000143201209     D LDA           E DS           256    EXTNAME(LDA)
000144201209      ** Local data area for database error details
000145201209      ** *LOCK IN LDA immediately before and OUT LDA immediately
000146201209      ** after each database error handling.
000147201209      **                                    134 141 DBFILE
000148201209      **       Defines:                     142 170 DBKEY
000149201209      **                                    171 180 DBPGM
000150201209      **                                    181 1830DBASE
000151201209      *
000152201209
000153201209     D/COPY ZACPYSRC,PSDS
000154201209      ** Program Status Data Structure
000155201209
000156201209     D RateDetails     DS
000157201209     D  BACYCD                 1      3
000158201209     D  BABSRC                 4      5
000159201209
000160201209     D @RUN            S              1A
000161201209
000162201209      *****************************************************************
000163201209      /EJECT
000164201209      *****************************************************************
000165201209
000166201209      ** Key Fields for Base Rate File Access
000167201209     C     SDBSRTKEY     KLIST
000168201209     C                   KFLD                    BACYCD
000169201209     C                   KFLD                    BABSRC
000170201209
000171201209      ** Select all existing base rates
000172201209
000173201209     C/EXEC SQL
000174201209     C+ declare RateCursor insensitive scroll cursor for
000175201209     C+ select BACYCD, BABSRC
000176201209     C+ from SDBSRTPD
000177201209     C/END-EXEC
000178201209      *
000179201209     C/EXEC SQL
000180201209     C+ open RateCursor
000181201209     C/END-EXEC
000182201209      *
000183201209     C/EXEC SQL
000184201209     C+ fetch next from RateCursor into :RateDetails
000185201209     C/END-EXEC
000186201209
000187201209     C                   DOW       SQLCOD <> 100
000188201209
000189201209     C                   IF        SQLCODE <> 0 and
000190201209     C                             SQLCODE <> 100
000191201209     C                   EVAL      DBFILE = 'SDBSRTPD'
000192201209     C                   EVAL      DBKEY  = 'SQL ERROR'
000193201209     C                   EVAL      DBPGM  = 'SMU01052'
000194201209     C                   EVAL      DBASE  = SQLCODE
000195201209     C                   EXSR      *PSSR
000196201209     C                   ENDIF
000197201209
000198201209     C     SDBSRTKEY     CHAIN     SDBSRTL0
000199201209     C                   IF        %FOUND(SDBSRTL0)
000200201209     C     BABLRT        IFNE      'Y'
000201201209     C                   EVAL      BABLRT = 'N'
000202201209     C                   UPDATE    @BAREDG
000203201209     C                   ENDIF
000204201209     C                   ELSE
000205201209     C                   EVAL      DBFILE = 'SDBSRTL0'
000206201209     C                   EVAL      DBKEY  = 'RATE NOT FOUND'
000207201209     C                   EVAL      DBPGM  = 'SMU01052'
000208201209     C                   EVAL      DBASE  = 002
000209201209     C                   EXSR      *PSSR
000210201209     C                   ENDIF
000211201209
000212201209     C/EXEC SQL
000213201209     C+ fetch next from RateCursor into :RateDetails
000214201209     C/END-EXEC
000215201209
000216201209     C                   ENDDO
000217201209
000218201209     C/EXEC SQL
000219201209     C+ close RateCursor
000220201209     C/END-EXEC
000221201209
000222201209     C                   EVAL      *INLR = *ON
000223201209     C                   RETURN
000224201209
000225201209      *****************************************************************
000226201209      /EJECT
000227201209      *****************************************************************
000228201209      *                                                               *
000229201209      * *PSSR  - Program exception error routine                      *
000230201209      *          Called automatically if a program error occurs,      *
000231201209      *          or directly by the program code using EXSR.          *
000232201209      *          This subroutine DUMPs the program just once.         *
000233201209      *                                                               *
000234201209      * Called by: (**calling routines**)                             *
000235201209      *                                                               *
000236201209      * Calls: None                                                   *
000237201209      *                                                               *
000238201209      *****************************************************************
000239201209     C     *PSSR         BEGSR
000240201209      *
000241201209     C                   IF        @RUN = *BLANK
000242201209     C                   EVAL      @RUN = 'Y'
000243201209     C                   DUMP
000244201209     C                   ENDIF
000245201209      *
000246201209     C                   EVAL      *INU7 = *ON
000247201209     C                   EVAL      *INU8 = *ON
000248201209     C                   EVAL      *INLR = *ON
000249201209     C                   RETURN
000250201209      *
000251201209     C                   ENDSR
000252201209      *****************************************************************
