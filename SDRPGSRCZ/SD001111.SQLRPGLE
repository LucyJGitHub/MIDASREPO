000100201124     H DEBUG
000101201124     H COPYRIGHT('(c) Finastra International Limited 2020')
000102201124      *****************************************************************
000103201124/*STD *  RPGSQLBND                                                    *
000104201124/*EXI *  TEXT('Midas SD Initialise CSD103 Fields in SDBSRTPD')        *
000105201124      *****************************************************************
000106201124      *                                                               *
000107201124      *  Midas - Implementation Module                                *
000108201124      *                                                               *
000109201124      *  SD001111 - Initialise CSD103 Fields in SDBSRTPD              *
000110201124      *                                                               *
000111201124      *  Function:  This program will run during Post Database        *
000112201124      *             Upgrade. It will select all existing base rates   *
000113201124      *             from SDBSRTPD. Then, it will set the              *
000114201124      *             Backward-Looking rate fields into their default   *
000115201124      *             values if they do not initially contain values    *
000116201124      *                                                               *
000117201124      *  (c) Finastra International Limited 2020                      *
000118201124      *                                                               *
000119201124      *  Last Amend No. CSD103    *CREATE  Date 10Aug20               *
000120201124      *                                                               *
000121201124      *---------------------------------------------------------------*
000122201124      *                                                               *
000123201124      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
000124201124      *                                                               *
000125201124      *****************************************************************
000126201124
000127201124     FSDBSRTL0  UF   E           K DISK    INFSR(*PSSR)
000128201124      ** Midas SD Base Rate Codes File
000129201124
000130201124      *****************************************************************
000131201124      /EJECT
000132201124      *****************************************************************
000133201124
000134201124     D LDA           E DS           256    EXTNAME(LDA)
000135201124      ** Local data area for database error details
000136201124      ** *LOCK IN LDA immediately before and OUT LDA immediately
000137201124      ** after each database error handling.
000138201124      **                                    134 141 DBFILE
000139201124      **       Defines:                     142 170 DBKEY
000140201124      **                                    171 180 DBPGM
000141201124      **                                    181 1830DBASE
000142201124      *
000143201124
000144201124     D/COPY ZACPYSRC,PSDS
000145201124      ** Program Status Data Structure
000146201124
000147201124     D RateDetails     DS
000148201124     D  BACYCD                 1      3
000149201124     D  BABSRC                 4      5
000150201124
000151201124     D @RUN            S              1A
000152201124
000153201124      *****************************************************************
000154201124      /EJECT
000155201124      *****************************************************************
000156201124
000157201124      ** Key Fields for Base Rate File Access
000158201124     C     SDBSRTKEY     KLIST
000159201124     C                   KFLD                    BACYCD
000160201124     C                   KFLD                    BABSRC
000161201124
000162201124      ** Select all existing base rates
000163201124
000164201124     C/EXEC SQL
000165201124     C+ declare RateCursor insensitive scroll cursor for
000166201124     C+ select BACYCD, BABSRC
000167201124     C+ from SDBSRTPD
000168201124     C/END-EXEC
000169201124      *
000170201124     C/EXEC SQL
000171201124     C+ open RateCursor
000172201124     C/END-EXEC
000173201124      *
000174201124     C/EXEC SQL
000175201124     C+ fetch next from RateCursor into :RateDetails
000176201124     C/END-EXEC
000177201124
000178201124     C                   DOW       SQLCOD <> 100
000179201124
000180201124     C                   IF        SQLCODE <> 0 and
000181201124     C                             SQLCODE <> 100
000182201124     C                   EVAL      DBFILE = 'SDBSRTPD'
000183201124     C                   EVAL      DBKEY  = 'SQL ERROR'
000184201124     C                   EVAL      DBPGM  = 'SMU01052'
000185201124     C                   EVAL      DBASE  = SQLCODE
000186201124     C                   EXSR      *PSSR
000187201124     C                   ENDIF
000188201124
000189201124     C     SDBSRTKEY     CHAIN     SDBSRTL0
000190201124     C                   IF        %FOUND(SDBSRTL0)
000191201124     C     BABLRT        IFNE      'Y'
000192201124     C                   EVAL      BABLRT = 'N'
000193201124     C                   UPDATE    @BAREDG
000194201124     C                   ENDIF
000195201124     C                   ELSE
000196201124     C                   EVAL      DBFILE = 'SDBSRTL0'
000197201124     C                   EVAL      DBKEY  = 'RATE NOT FOUND'
000198201124     C                   EVAL      DBPGM  = 'SMU01052'
000199201124     C                   EVAL      DBASE  = 002
000200201124     C                   EXSR      *PSSR
000201201124     C                   ENDIF
000202201124
000203201124     C/EXEC SQL
000204201124     C+ fetch next from RateCursor into :RateDetails
000205201124     C/END-EXEC
000206201124
000207201124     C                   ENDDO
000208201124
000209201124     C/EXEC SQL
000210201124     C+ close RateCursor
000211201124     C/END-EXEC
000212201124
000213201124     C                   EVAL      *INLR = *ON
000214201124     C                   RETURN
000215201124
000216201124      *****************************************************************
000217201124      /EJECT
000218201124      *****************************************************************
000219201124      *                                                               *
000220201124      * *PSSR  - Program exception error routine                      *
000221201124      *          Called automatically if a program error occurs,      *
000222201124      *          or directly by the program code using EXSR.          *
000223201124      *          This subroutine DUMPs the program just once.         *
000224201124      *                                                               *
000225201124      * Called by: (**calling routines**)                             *
000226201124      *                                                               *
000227201124      * Calls: None                                                   *
000228201124      *                                                               *
000229201124      *****************************************************************
000230201124     C     *PSSR         BEGSR
000231201124      *
000232201124     C                   IF        @RUN = *BLANK
000233201124     C                   EVAL      @RUN = 'Y'
000234201124     C                   DUMP
000235201124     C                   ENDIF
000236201124      *
000237201124     C                   EVAL      *INU7 = *ON
000238201124     C                   EVAL      *INU8 = *ON
000239201124     C                   EVAL      *INLR = *ON
000240201124     C                   RETURN
000241201124      *
000242201124     C                   ENDSR
000243201124      *****************************************************************
