000100201105     H DEBUG
000101201105     H COPYRIGHT('(c) Finastra International Limited 2020')
000102201105      *****************************************************************
000103201105/*STD *  RPGSQLBND                                                    *
000104201105/*EXI *  TEXT('Midas SM Update Base rate fields')                     *
000105201105      *****************************************************************
000106201105      *                                                               *
000107201105      *  Midas - Implementation Module                                *
000108201105      *                                                               *
000109201106      *  SMU01051 - Update of Base rate fields to conform with new    *
000110201105      *              type of base rates which is alphanumeric         *
000111201105      *                                                               *
000112201105      *  Function: This program will set Base rate fields of files    *
000113201105      *            from zero to blanks and from 'X_' to '0X' where X  *
000114201105      *            is a single digit number.                          *
000115201105      *                                                               *
000116201105      *  (c)Finastra International Limited 2020                       *
000117201105      *                                                               *
000118201105      *  Last Amend No. CSD103    *CREATE  Date 16Oct20               *
000119201105      *                                                               *
000120201105      *---------------------------------------------------------------*
000121201105      *                                                               *
000122201105      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
000123201105      *                                                               *
000124201105      *****************************************************************
000125201105     FSMFILUPD  IF   E           K DISK    INFSR(*PSSR)
000126201105      *Midas SD File Base Rate Fields to Update
000127201105      *
000128201105      **---------------------------------------------------------------
000129201105      ** The following /COPY line includes all the defined fields in
000130201105      ** the Program Status Data Structures.  They have meaningful
000131201105      ** names, prefixed by 'PS'.
000132201105     D/COPY ZACPYSRC,PSDS
000133201105     D/COPY ZACPYSRC,STD_D_SPEC
000134201105      *
000135201105      ** +--------------------------------------+
000136201105      ** ¦ Variable declaration                 ¦
000137201105      ** ¦ ====================                 ¦
000138201105      ** +--------------------------------------+
000139201105     D UFILE           S             10A
000140201105     D UFIELD          S             10A
000141201105     D thisSQL         S            500
000142201105     D thisSQL1        S            500
000143201105     D thisSQL2        S            500
000144201105     D thisSQL3        S            500
000145201105     D thisSQL4        S            500
000146201105     D thisSQL5        S            500
000147201105     D thisSQL6        S            500
000148201105     D thisSQL7        S            500
000149201105     D thisSQL8        S            500
000150201105     D thisSQL9        S            500
000151201105      ** Indicator Array
000152201105     D Indicators      DS                  BASED(IndicatorP)
000153201105     D  ErrorOnFl             35     35
000154201105     D  EndOfFile             45     45
000155201105      ** Pointer for the indicator Array
000156201105     D IndicatorP      S               *   INZ(%Addr(*IN))
000157201105      *
000158201105      ** +--------------------------------------+
000159201105      ** ¦ End of D-specs                       ¦
000160201105      ** ¦ ==============                       ¦
000161201105      ** +--------------------------------------+
000162201105      *
000163201105     C     *LOVAL        SETLL     SMFILUPD
000164201105     C                   READ      SMFILUP1                             3545
000165201105      *
000166201105      ** Database error
000167201105      *
000168201105     C                   IF        ErrorOnFl = True
000169201105     C     *LOCK         IN        LDA
000170201105     C                   EVAL      DBKey = '*FIRST'
000171201105     C                   EVAL      DBFile = 'SMFILUP1'
000172201105     C                   EVAL      DBase = 1
000173201105     C                   OUT       LDA
000174201105     C                   EXSR      *PSSR
000175201105     C                   ENDIF
000176201105      *
000177201105      ** Start loop
000178201105      *
000179201105     C                   DOW       EndOfFile = False
000180201105      *
000181201105      ** Process Update of files
000182201105      *
000183201105     C                   EXSR      SRUpdate
000184201105      *
000185201105      ** Read next record
000186201105      *
000187201105     C                   READ      SMFILUP1                             3545
000188201105      *
000189201105     C                   IF        ErrorOnFl = True
000190201105     C     *LOCK         IN        LDA
000191201105     C                   EVAL      DBKey = '*NEXT'
000192201105     C                   EVAL      DBFile = 'SMFILUP1'
000193201105     C                   EVAL      DBase = 2
000194201105     C                   OUT       LDA
000195201105     C                   EXSR      *PSSR
000196201105     C                   ENDIF
000197201105      *
000198201105     C                   ENDDO
000199201105     C                   EVAL      *INLR = *ON
000200201105
000201201105      *****************************************************************
000202201105      *  P R O G R A M   E N D                                        *
000203201105      *****************************************************************
000204201105      *                                                               *
000205201105      * SRUpdate - Update files                                       *
000206201105      *                                                               *
000207201105      * Called by: Main Processing                                    *
000208201105      *                                                               *
000209201105      * Calls: None                                                   *
000210201105      *                                                               *
000211201105      *****************************************************************
000212201105     C     SRUpdate      BEGSR
000213201105      *
000214201105     C                   EVAL      UFILE = PFILE
000215201105     C                   EVAL      UFIELD = PFIELD
000216201105      *
000217201105     C                   EVAL      thisSQL = 'Update '+UFILE+' SET '+UFIELD
000218201105     C                             +' = ''  '' WHERE '+UFIELD+' = ''00'' '
000219201105     C                             +'OR '+UFIELD+' = ''0 '' '
000220201105     C                             +'OR '+UFIELD+' = '' 0'' '
000221201105     C                   EVAL      thisSQL1 = 'Update '+UFILE+' SET '+UFIELD
000222201105     C                             +' = ''01'' WHERE '+UFIELD+' = ''1 '''
000223201105     C                             +'OR '+UFIELD+' = '' 1'' '
000224201105     C                   EVAL      thisSQL2 = 'Update '+UFILE+' SET '+UFIELD
000225201105     C                             +' = ''02'' WHERE '+UFIELD+' = ''2 '''
000226201105     C                             +'OR '+UFIELD+' = '' 2'' '
000227201105     C                   EVAL      thisSQL3 = 'Update '+UFILE+' SET '+UFIELD
000228201105     C                             +' = ''03'' WHERE '+UFIELD+' = ''3 '''
000229201105     C                             +'OR '+UFIELD+' = '' 3'' '
000230201105     C                   EVAL      thisSQL4 = 'Update '+UFILE+' SET '+UFIELD
000231201105     C                             +' = ''04'' WHERE '+UFIELD+' = ''4 '''
000232201105     C                             +'OR '+UFIELD+' = '' 4'' '
000233201105     C                   EVAL      thisSQL5 = 'Update '+UFILE+' SET '+UFIELD
000234201105     C                             +' = ''05'' WHERE '+UFIELD+' = ''5 '''
000235201105     C                             +'OR '+UFIELD+' = '' 5'' '
000236201105     C                   EVAL      thisSQL6 = 'Update '+UFILE+' SET '+UFIELD
000237201105     C                             +' = ''06'' WHERE '+UFIELD+' = ''6 '''
000238201105     C                             +'OR '+UFIELD+' = '' 6'' '
000239201105     C                   EVAL      thisSQL7 = 'Update '+UFILE+' SET '+UFIELD
000240201105     C                             +' = ''07'' WHERE '+UFIELD+' = ''7 '''
000241201105     C                             +'OR '+UFIELD+' = '' 7'' '
000242201105     C                   EVAL      thisSQL8 = 'Update '+UFILE+' SET '+UFIELD
000243201105     C                             +' = ''08'' WHERE '+UFIELD+' = ''8 '''
000244201105     C                             +'OR '+UFIELD+' = '' 8'' '
000245201105     C                   EVAL      thisSQL9 = 'Update '+UFILE+' SET '+UFIELD
000246201105     C                             +' = ''09'' WHERE '+UFIELD+' = ''9 '''
000247201105     C                             +'OR '+UFIELD+' = '' 9'' '
000248201105      *
000249201105     C/EXEC SQL
000250201105     C+ EXECUTE IMMEDIATE :thisSQL
000251201105     C/END-EXEC
000252201105     C/EXEC SQL
000253201105     C+ EXECUTE IMMEDIATE :thisSQL1
000254201105     C/END-EXEC
000255201105     C/EXEC SQL
000256201105     C+ EXECUTE IMMEDIATE :thisSQL2
000257201105     C/END-EXEC
000258201105     C/EXEC SQL
000259201105     C+ EXECUTE IMMEDIATE :thisSQL3
000260201105     C/END-EXEC
000261201105     C/EXEC SQL
000262201105     C+ EXECUTE IMMEDIATE :thisSQL4
000263201105     C/END-EXEC
000264201105     C/EXEC SQL
000265201105     C+ EXECUTE IMMEDIATE :thisSQL5
000266201105     C/END-EXEC
000267201105     C/EXEC SQL
000268201105     C+ EXECUTE IMMEDIATE :thisSQL6
000269201105     C/END-EXEC
000270201105     C/EXEC SQL
000271201105     C+ EXECUTE IMMEDIATE :thisSQL7
000272201105     C/END-EXEC
000273201105     C/EXEC SQL
000274201105     C+ EXECUTE IMMEDIATE :thisSQL8
000275201105     C/END-EXEC
000276201105     C/EXEC SQL
000277201105     C+ EXECUTE IMMEDIATE :thisSQL9
000278201105     C/END-EXEC
000279201105      *
000280201105     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
000281201105     C                   EXSR      *PSSR
000282201105     C                   ENDIF
000283201105      *
000284201105     C                   ENDSR
000285201105      *****************************************************************
000286201105      *                                                               *
000287201105      *  *PSSR - Subroutine to handle error conditions                *
000288201105      *                                                               *
000289201105      *  Called from:  After abnormal operation occurs                *
000290201105      *                                                               *
000291201105      *  Calls: Nothing                                               *
000292201105      *                                                               *
000293201105      *****************************************************************
000294201105     C     *PSSR         BEGSR
000295201105
000296201105     C                   EVAL      *INU7 = '1'
000297201105     C                   EVAL      *INU8 = '1'
000298201105     C                   DUMP
000299201105     C                   RETURN
000300201105
000301201105     C                   ENDSR
000302201105      *****************************************************************
000303201105**  CPY@
000304201105(c) Finastra International Limited 2020
