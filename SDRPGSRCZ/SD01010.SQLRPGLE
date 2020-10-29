000100201015     H DEBUG
000101201015     H COPYRIGHT('(c) Finastra International Limited 2020')
000102201015      *****************************************************************
000103201015/*STD *  RPGSQLBND                                                    *
000104201015/*EXI *  TEXT('Midas SD Update Base rate fields')                     *
000105201015      *****************************************************************
000106201015      *                                                               *
000107201015      *  Midas - Standing Data Module                                 *
000108201015      *                                                               *
000109201015      *  SD01010 - Update of Base rate fields to conform with new     *
000110201015      *            type of base rates which is alphanumeric           *
000111201015      *                                                               *
000112201015      *  Function: This program will set Base rate fields of files    *
000113201027      *            from zero to blanks and from 'X_' to '0X' where X  *
000114201027      *            is a single digit number.                          *
000115201015      *                                                               *
000116201015      *  (c)Finastra International Limited 2020                       *
000117201015      *                                                               *
000118201015      *  Last Amend No. CSD103    *CREATE  Date 16Oct20               *
000119201015      *                                                               *
000120201015      *---------------------------------------------------------------*
000121201015      *                                                               *
000122201015      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
000123201015      *                                                               *
000124201015      *****************************************************************
000125201015     FSDFILUPD  IF   E           K DISK    INFSR(*PSSR)
000126201015      *Midas SD File Base Rate Fields to Update
000127201019      *
000128201019      **---------------------------------------------------------------
000129201019      ** The following /COPY line includes all the defined fields in
000130201019      ** the Program Status Data Structures.  They have meaningful
000131201019      ** names, prefixed by 'PS'.
000132201019     D/COPY ZACPYSRC,PSDS
000133201019     D/COPY ZACPYSRC,STD_D_SPEC
000134201019      *
000135201015      ** +--------------------------------------+
000136201015      ** ¦ Variable declaration                 ¦
000137201015      ** ¦ ====================                 ¦
000138201015      ** +--------------------------------------+
000139201019     D UFILE           S             10A
000140201019     D UFIELD          S             10A
000141201015     D thisSQL         S            500
000142201027     D thisSQL1        S            500
000143201027     D thisSQL2        S            500
000144201027     D thisSQL3        S            500
000145201027     D thisSQL4        S            500
000146201027     D thisSQL5        S            500
000147201027     D thisSQL6        S            500
000148201027     D thisSQL7        S            500
000149201027     D thisSQL8        S            500
000150201027     D thisSQL9        S            500
000151201019      ** Indicator Array
000152201019     D Indicators      DS                  BASED(IndicatorP)
000153201019     D  ErrorOnFl             35     35
000154201019     D  EndOfFile             45     45
000155201019      ** Pointer for the indicator Array
000156201019     D IndicatorP      S               *   INZ(%Addr(*IN))
000157201019      *
000158201019      ** +--------------------------------------+
000159201019      ** ¦ End of D-specs                       ¦
000160201019      ** ¦ ==============                       ¦
000161201019      ** +--------------------------------------+
000162201015      *
000163201019     C     *LOVAL        SETLL     SDFILUPD
000164201019     C                   READ      SDFILUP1                             3545
000165201019      *
000166201019      ** Database error
000167201019      *
000168201019     C                   IF        ErrorOnFl = True
000169201019     C     *LOCK         IN        LDA
000170201019     C                   EVAL      DBKey = '*FIRST'
000171201019     C                   EVAL      DBFile = 'SDFILUP1'
000172201019     C                   EVAL      DBase = 1
000173201019     C                   OUT       LDA
000174201019     C                   EXSR      *PSSR
000175201019     C                   ENDIF
000176201019      *
000177201019      ** Start loop
000178201019      *
000179201019     C                   DOW       EndOfFile = False
000180201019      *
000181201019      ** Process Update of files
000182201019      *
000183201019     C                   EXSR      SRUpdate
000184201019      *
000185201019      ** Read next record
000186201019      *
000187201019     C                   READ      SDFILUP1                             3545
000188201019      *
000189201019     C                   IF        ErrorOnFl = True
000190201019     C     *LOCK         IN        LDA
000191201019     C                   EVAL      DBKey = '*NEXT'
000192201019     C                   EVAL      DBFile = 'SDFILUP1'
000193201019     C                   EVAL      DBase = 2
000194201019     C                   OUT       LDA
000195201019     C                   EXSR      *PSSR
000196201019     C                   ENDIF
000197201019      *
000198201019     C                   ENDDO
000199201015     C                   EVAL      *INLR = *ON
000200201019
000201201019      *****************************************************************
000202201019      *  P R O G R A M   E N D                                        *
000203201019      *****************************************************************
000204201019      *                                                               *
000205201019      * SRUpdate - Update files                                       *
000206201019      *                                                               *
000207201019      * Called by: Main Processing                                    *
000208201019      *                                                               *
000209201019      * Calls: None                                                   *
000210201019      *                                                               *
000211201019      *****************************************************************
000212201019     C     SRUpdate      BEGSR
000213201019      *
000214201019     C                   EVAL      UFILE = PFILE
000215201019     C                   EVAL      UFIELD = PFIELD
000216201019      *
000217201019     C                   EVAL      thisSQL = 'Update '+UFILE+' SET '+UFIELD
000218201027     C                             +' = ''  '' WHERE '+UFIELD+' = ''00'' '
000219201027     C                             +'OR '+UFIELD+' = ''0 '' '
000220201027     C                             +'OR '+UFIELD+' = '' 0'' '
000221201027     C                   EVAL      thisSQL1 = 'Update '+UFILE+' SET '+UFIELD
000222201027     C                             +' = ''01'' WHERE '+UFIELD+' = ''1 '''
000223201027     C                             +'OR '+UFIELD+' = '' 1'' '
000224201027     C                   EVAL      thisSQL2 = 'Update '+UFILE+' SET '+UFIELD
000225201027     C                             +' = ''02'' WHERE '+UFIELD+' = ''2 '''
000226201027     C                             +'OR '+UFIELD+' = '' 2'' '
000227201027     C                   EVAL      thisSQL3 = 'Update '+UFILE+' SET '+UFIELD
000228201027     C                             +' = ''03'' WHERE '+UFIELD+' = ''3 '''
000229201027     C                             +'OR '+UFIELD+' = '' 3'' '
000230201027     C                   EVAL      thisSQL4 = 'Update '+UFILE+' SET '+UFIELD
000231201027     C                             +' = ''04'' WHERE '+UFIELD+' = ''4 '''
000232201027     C                             +'OR '+UFIELD+' = '' 4'' '
000233201027     C                   EVAL      thisSQL5 = 'Update '+UFILE+' SET '+UFIELD
000234201027     C                             +' = ''05'' WHERE '+UFIELD+' = ''5 '''
000235201027     C                             +'OR '+UFIELD+' = '' 5'' '
000236201027     C                   EVAL      thisSQL6 = 'Update '+UFILE+' SET '+UFIELD
000237201027     C                             +' = ''06'' WHERE '+UFIELD+' = ''6 '''
000238201027     C                             +'OR '+UFIELD+' = '' 6'' '
000239201027     C                   EVAL      thisSQL7 = 'Update '+UFILE+' SET '+UFIELD
000240201027     C                             +' = ''07'' WHERE '+UFIELD+' = ''7 '''
000241201027     C                             +'OR '+UFIELD+' = '' 7'' '
000242201027     C                   EVAL      thisSQL8 = 'Update '+UFILE+' SET '+UFIELD
000243201027     C                             +' = ''08'' WHERE '+UFIELD+' = ''8 '''
000244201027     C                             +'OR '+UFIELD+' = '' 8'' '
000245201027     C                   EVAL      thisSQL9 = 'Update '+UFILE+' SET '+UFIELD
000246201027     C                             +' = ''09'' WHERE '+UFIELD+' = ''9 '''
000247201027     C                             +'OR '+UFIELD+' = '' 9'' '
000248201019      *
000249201019     C/EXEC SQL
000250201019     C+ EXECUTE IMMEDIATE :thisSQL
000251201019     C/END-EXEC
000252201027     C/EXEC SQL
000253201027     C+ EXECUTE IMMEDIATE :thisSQL1
000254201027     C/END-EXEC
000255201027     C/EXEC SQL
000256201027     C+ EXECUTE IMMEDIATE :thisSQL2
000257201027     C/END-EXEC
000258201027     C/EXEC SQL
000259201027     C+ EXECUTE IMMEDIATE :thisSQL3
000260201027     C/END-EXEC
000261201027     C/EXEC SQL
000262201027     C+ EXECUTE IMMEDIATE :thisSQL4
000263201027     C/END-EXEC
000264201027     C/EXEC SQL
000265201027     C+ EXECUTE IMMEDIATE :thisSQL5
000266201027     C/END-EXEC
000267201027     C/EXEC SQL
000268201027     C+ EXECUTE IMMEDIATE :thisSQL6
000269201027     C/END-EXEC
000270201027     C/EXEC SQL
000271201027     C+ EXECUTE IMMEDIATE :thisSQL7
000272201027     C/END-EXEC
000273201027     C/EXEC SQL
000274201027     C+ EXECUTE IMMEDIATE :thisSQL8
000275201027     C/END-EXEC
000276201027     C/EXEC SQL
000277201027     C+ EXECUTE IMMEDIATE :thisSQL9
000278201027     C/END-EXEC
000279201019      *
000280201019     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
000281201019     C                   EXSR      *PSSR
000282201019     C                   ENDIF
000283201019      *
000284201019     C                   ENDSR
000285201015      *****************************************************************
000286201015      *                                                               *
000287201015      *  *PSSR - Subroutine to handle error conditions                *
000288201015      *                                                               *
000289201015      *  Called from:  After abnormal operation occurs                *
000290201015      *                                                               *
000291201015      *  Calls: Nothing                                               *
000292201015      *                                                               *
000293201015      *****************************************************************
000294201019     C     *PSSR         BEGSR
000295201015
000296201019     C                   EVAL      *INU7 = '1'
000297201019     C                   EVAL      *INU8 = '1'
000298201019     C                   DUMP
000299201019     C                   RETURN
000300201015
000301201019     C                   ENDSR
000302201019      *****************************************************************
000303201019**  CPY@
000304201019(c) Finastra International Limited 2020
