     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update EACC of ACKEYAL')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU01010 - Upgrade Utility for EACC field Update of ACKEYAL  *
      *                                                               *
      *  Function: This program will set EACC value of ACKEYAL from   *
      *            invalid data to zero.                              *
      *                                                               *
      *  (c)Finastra International Limited 2020                       *
      *                                                               *
      *  Last Amend No. MD050208 *CREATE   Date 26May20               *
      *  Prev Amend No. Xxnnnnnn           Date DDMMMYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050208 - Update EACC field invalid data in ACKEYAL         *
      *                                                               *
      *****************************************************************

     D thisSQL         S            500


     C                   EVAL      thisSQL = 'Update ACKEYAL SET EACC = 0 ' +
     C                                       'where HEX(EACC) LIKE ''%40%'''

     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      *INLR = *ON

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
