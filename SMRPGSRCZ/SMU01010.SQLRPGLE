000100200526     H DEBUG
000101200527     H COPYRIGHT('(c) Finastra International Limited 2020')
000102200526      *****************************************************************
000103200526/*STD *  RPGSQLBND                                                    *
000104200527/*EXI *  TEXT('Midas SM Update EACC of ACKEYAL')                      *
000105200526      *****************************************************************
000106200526      *                                                               *
000107200527      *  Midas - Implementation module                                *
000108200526      *                                                               *
000109200529      *  SMU01010 - Upgrade Utility for EACC field Update of ACKEYAL  *
000110200526      *                                                               *
000112200527      *  Function: This program will set EACC value of ACKEYAL from   *
000113200527      *            invalid data to zero.                              *
000115200526      *                                                               *
000116200526      *  (c)Finastra International Limited 2020                       *
000117200526      *                                                               *
000118200526      *  Last Amend No. MD050208 *CREATE   Date 26May20               *
000119200526      *  Prev Amend No. Xxnnnnnn           Date DDMMMYY               *
000120200526      *                                                               *
000121200526      *---------------------------------------------------------------*
000122200526      *                                                               *
000123200526      *  MD050208 - Update EACC field invalid data in ACKEYAL         *
000124200526      *                                                               *
000125200526      *****************************************************************
000126200526
000127200526     D thisSQL         S            500
000128200526
000132200526
000133200526     C                   EVAL      thisSQL = 'Update ACKEYAL SET EACC = 0 ' +
000134200526     C                                       'where HEX(EACC) LIKE ''%40%'''
000136200526
000137200526     C/EXEC SQL
000138200526     C+ EXECUTE IMMEDIATE :thisSQL
000139200526     C/END-EXEC
000140200526
000141200526     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
000142200526     C                   EXSR      *PSSR
000143200526     C                   ENDIF
000144200526
000145200526     C                   EVAL      *INLR = *ON
000146200526
000147200526      *****************************************************************
000148200526      *                                                               *
000149200526      *  *PSSR - Subroutine to handle error conditions                *
000150200526      *                                                               *
000151200526      *  Called from:  After abnormal operation occurs                *
000152200526      *                                                               *
000153200526      *  Calls: Nothing                                               *
000154200526      *                                                               *
000155200526      *****************************************************************
000156200526     C     *PSSR         BEGSR
000157200526
000158200526     C                   EVAL      *INU7 = '1'
000159200526     C                   EVAL      *INU8 = '1'
000160200526     C                   DUMP
000161200526     C                   RETURN
000162200526
000163200526     C                   ENDSR
