000100201105     H DEBUG
000101201105     H COPYRIGHT('(c) Finastra International Limited 2020')
000102201105      *****************************************************************
000103201105/*STD *  RPGSQLBND                                                    *
000104201105/*EXI *  TEXT('Midas SM Transfer records from type P to A')           *
000105201105      *****************************************************************
000106201105      *                                                               *
000107201105      *  Midas - Implementation Module                                *
000108201105      *                                                               *
000109201106      *  SMU01050 - Transfer records from files (previously packed)   *
000110201105      *            to new files (changed to alphanumeric)             *
000111201105      *                                                               *
000112201105      *  (c)Finastra International Limited 2020                       *
000113201105      *                                                               *
000114201105      *  Last Amend No. CSD103    *CREATE  Date 27Oct20               *
000115201105      *                                                               *
000116201105      *---------------------------------------------------------------*
000117201105      *                                                               *
000118201105      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
000119201105      *                                                               *
000120201105      *****************************************************************
000121201105     FSMFILTRN  IF   E           K DISK    INFSR(*PSSR)
000122201105      *Midas SM File Index Packed to Alpanumeric
000123201105      *
000124201105      **---------------------------------------------------------------
000125201105      ** The following /COPY line includes all the defined fields in
000126201105      ** the Program Status Data Structures.  They have meaningful
000127201105      ** names, prefixed by 'PS'.
000128201105     D/COPY ZACPYSRC,PSDS
000129201105     D/COPY ZACPYSRC,STD_D_SPEC
000130201105      *
000131201105      ** +--------------------------------------+
000132201105      ** ¦ Variable declaration                 ¦
000133201105      ** ¦ ====================                 ¦
000134201105      ** +--------------------------------------+
000135201105     D UFILE           S             10A
000136201105     D thisSQL         S            500
000137201105     D thisSQL1        S            500
000138201105      ** Indicator Array
000139201105     D Indicators      DS                  BASED(IndicatorP)
000140201105     D  ErrorOnFl             35     35
000141201105     D  EndOfFile             45     45
000142201105      ** Pointer for the indicator Array
000143201105     D IndicatorP      S               *   INZ(%Addr(*IN))
000144201105      *
000145201105      ** +--------------------------------------+
000146201105      ** ¦ End of D-specs                       ¦
000147201105      ** ¦ ==============                       ¦
000148201105      ** +--------------------------------------+
000149201105      *
000150201105     C     *LOVAL        SETLL     SMFILTRN
000151201105     C                   READ      SMFILTR1                             3545
000152201105      *
000153201105      ** Database error
000154201105      *
000155201105     C                   IF        ErrorOnFl = True
000156201105     C     *LOCK         IN        LDA
000157201105     C                   EVAL      DBKey = '*FIRST'
000158201105     C                   EVAL      DBFile = 'SMFILTR1'
000159201105     C                   EVAL      DBase = 1
000160201105     C                   OUT       LDA
000161201105     C                   EXSR      *PSSR
000162201105     C                   ENDIF
000163201105      *
000164201105      ** Start loop
000165201105      *
000166201105     C                   DOW       EndOfFile = False
000167201105      *
000168201105      ** Process Update of files
000169201105      *
000170201105     C                   EXSR      SRTransf
000171201105      *
000172201105      ** Read next record
000173201105      *
000174201105     C                   READ      SMFILTR1                             3545
000175201105      *
000176201105     C                   IF        ErrorOnFl = True
000177201105     C     *LOCK         IN        LDA
000178201105     C                   EVAL      DBKey = '*NEXT'
000179201105     C                   EVAL      DBFile = 'SMFILTR1'
000180201105     C                   EVAL      DBase = 2
000181201105     C                   OUT       LDA
000182201105     C                   EXSR      *PSSR
000183201105     C                   ENDIF
000184201105      *
000185201105     C                   ENDDO
000186201105     C                   EVAL      *INLR = *ON
000187201105
000188201105      *****************************************************************
000189201105      *  P R O G R A M   E N D                                        *
000190201105      *****************************************************************
000191201105      *                                                               *
000192201105      * SRTransf - Transfer records                                   *
000193201105      *                                                               *
000194201105      * Called by: Main Processing                                    *
000195201105      *                                                               *
000196201105      * Calls: None                                                   *
000197201105      *                                                               *
000198201105      *****************************************************************
000199201105     C     SRTransf      BEGSR
000200201105      *
000201201105     C                   EVAL      UFILE = PFILE
000202201105      *
000203201105     C                   EVAL      thisSQL = 'INSERT INTO ' +UFILE+ ' SELECT * '
000204201105     C                                     + 'FROM TEMPLIB/' +UFILE
000205201105      *
000206201105      * Delete corrupted records
000207201105      *
000208201105     C                   EVAL      thisSQL1 = 'DELETE FROM ' +UFILE
000209201105      *
000210201105     C/EXEC SQL
000211201105     C+ EXECUTE IMMEDIATE :thisSQL1
000212201105     C/END-EXEC
000213201105      *
000214201105     C/EXEC SQL
000215201105     C+ EXECUTE IMMEDIATE :thisSQL
000216201105     C/END-EXEC
000217201105      *
000218201105     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
000219201105     C                   EXSR      *PSSR
000220201105     C                   ENDIF
000221201105      *
000222201105     C                   ENDSR
000223201105      *****************************************************************
000224201105      *                                                               *
000225201105      *  *PSSR - Subroutine to handle error conditions                *
000226201105      *                                                               *
000227201105      *  Called from:  After abnormal operation occurs                *
000228201105      *                                                               *
000229201105      *  Calls: Nothing                                               *
000230201105      *                                                               *
000231201105      *****************************************************************
000232201105     C     *PSSR         BEGSR
000233201105
000234201105     C                   EVAL      *INU7 = '1'
000235201105     C                   EVAL      *INU8 = '1'
000236201105     C                   DUMP
000237201105     C                   RETURN
000238201105
000239201105     C                   ENDSR
000240201105      *****************************************************************
000241201105**  CPY@
000242201105(c) Finastra International Limited 2020
