000100201027     H DEBUG
000101201027     H COPYRIGHT('(c) Finastra International Limited 2020')
000102201027      *****************************************************************
000103201027/*STD *  RPGSQLBND                                                    *
000104201028/*EXI *  TEXT('Midas SD Transfer records from type P to A')           *
000105201027      *****************************************************************
000106201027      *                                                               *
000107201027      *  Midas - Standing Data Module                                 *
000108201027      *                                                               *
000109201027      *  SD01011 - Transfer records from files (previously packed)    *
000110201028      *            to new files (changed to alphanumeric)             *
000112201027      *                                                               *
000115201027      *  (c)Finastra International Limited 2020                       *
000116201027      *                                                               *
000117201027      *  Last Amend No. CSD103    *CREATE  Date 27Oct20               *
000118201027      *                                                               *
000119201027      *---------------------------------------------------------------*
000120201027      *                                                               *
000121201027      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
000122201027      *                                                               *
000123201027      *****************************************************************
000124201028     FSDFILTRN  IF   E           K DISK    INFSR(*PSSR)
000125201029      *Midas SD File Index Packed to Alpanumeric
000126201027      *
000127201027      **---------------------------------------------------------------
000128201027      ** The following /COPY line includes all the defined fields in
000129201027      ** the Program Status Data Structures.  They have meaningful
000130201027      ** names, prefixed by 'PS'.
000131201027     D/COPY ZACPYSRC,PSDS
000132201027     D/COPY ZACPYSRC,STD_D_SPEC
000133201027      *
000134201027      ** +--------------------------------------+
000135201027      ** ¦ Variable declaration                 ¦
000136201027      ** ¦ ====================                 ¦
000137201027      ** +--------------------------------------+
000138201027     D UFILE           S             10A
000140201027     D thisSQL         S            500
000141201027     D thisSQL1        S            500
000142201027      ** Indicator Array
000143201027     D Indicators      DS                  BASED(IndicatorP)
000144201027     D  ErrorOnFl             35     35
000145201027     D  EndOfFile             45     45
000146201027      ** Pointer for the indicator Array
000147201027     D IndicatorP      S               *   INZ(%Addr(*IN))
000148201027      *
000149201027      ** +--------------------------------------+
000150201027      ** ¦ End of D-specs                       ¦
000151201027      ** ¦ ==============                       ¦
000152201027      ** +--------------------------------------+
000153201027      *
000154201028     C     *LOVAL        SETLL     SDFILTRN
000155201028     C                   READ      SDFILTR1                             3545
000156201027      *
000157201027      ** Database error
000158201027      *
000159201027     C                   IF        ErrorOnFl = True
000160201027     C     *LOCK         IN        LDA
000161201027     C                   EVAL      DBKey = '*FIRST'
000162201028     C                   EVAL      DBFile = 'SDFILTR1'
000163201027     C                   EVAL      DBase = 1
000164201027     C                   OUT       LDA
000165201027     C                   EXSR      *PSSR
000166201027     C                   ENDIF
000167201027      *
000168201027      ** Start loop
000169201027      *
000170201027     C                   DOW       EndOfFile = False
000171201027      *
000172201027      ** Process Update of files
000173201027      *
000174201027     C                   EXSR      SRTransf
000175201027      *
000176201027      ** Read next record
000177201027      *
000178201028     C                   READ      SDFILTR1                             3545
000179201027      *
000180201027     C                   IF        ErrorOnFl = True
000181201027     C     *LOCK         IN        LDA
000182201027     C                   EVAL      DBKey = '*NEXT'
000183201028     C                   EVAL      DBFile = 'SDFILTR1'
000184201027     C                   EVAL      DBase = 2
000185201027     C                   OUT       LDA
000186201027     C                   EXSR      *PSSR
000187201027     C                   ENDIF
000188201027      *
000189201027     C                   ENDDO
000190201027     C                   EVAL      *INLR = *ON
000191201027
000192201027      *****************************************************************
000193201027      *  P R O G R A M   E N D                                        *
000194201027      *****************************************************************
000195201027      *                                                               *
000196201027      * SRTransf - Transfer records                                   *
000197201027      *                                                               *
000198201027      * Called by: Main Processing                                    *
000199201027      *                                                               *
000200201027      * Calls: None                                                   *
000201201027      *                                                               *
000202201027      *****************************************************************
000203201027     C     SRTransf      BEGSR
000204201027      *
000205201027     C                   EVAL      UFILE = PFILE
000206201027      *
000207201028     C                   EVAL      thisSQL = 'INSERT INTO ' +UFILE+ ' SELECT * '
000208201027     C                                     + 'FROM TEMPLIB/' +UFILE
000209201027      *
000210201027      * Delete corrupted records
000211201027      *
000212201027     C                   EVAL      thisSQL1 = 'DELETE FROM ' +UFILE
000213201027      *
000214201027     C/EXEC SQL
000215201027     C+ EXECUTE IMMEDIATE :thisSQL1
000216201027     C/END-EXEC
000217201027      *
000218201027     C/EXEC SQL
000219201027     C+ EXECUTE IMMEDIATE :thisSQL
000220201027     C/END-EXEC
000221201027      *
000222201027     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
000223201027     C                   EXSR      *PSSR
000224201027     C                   ENDIF
000225201027      *
000226201027     C                   ENDSR
000227201027      *****************************************************************
000228201027      *                                                               *
000229201027      *  *PSSR - Subroutine to handle error conditions                *
000230201027      *                                                               *
000231201027      *  Called from:  After abnormal operation occurs                *
000232201027      *                                                               *
000233201027      *  Calls: Nothing                                               *
000234201027      *                                                               *
000235201027      *****************************************************************
000236201027     C     *PSSR         BEGSR
000237201027
000238201027     C                   EVAL      *INU7 = '1'
000239201027     C                   EVAL      *INU8 = '1'
000240201027     C                   DUMP
000241201027     C                   RETURN
000242201027
000243201027     C                   ENDSR
000244201027      *****************************************************************
000245201027**  CPY@
000246201027(c) Finastra International Limited 2020
