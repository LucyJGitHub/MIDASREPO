     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Transfer records from type P to A')           *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU01050 - Transfer records from files (previously packed)   *
      *            to new files (changed to alphanumeric)             *
      *                                                               *
      *  (c)Finastra International Limited 2020                       *
      *                                                               *
      *  Last Amend No. CSD103    *CREATE  Date 27Oct20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
     FSMFILTRN  IF   E           K DISK    INFSR(*PSSR)
      *Midas SM File Index Packed to Alpanumeric
      *
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D UFILE           S             10A
     D thisSQL         S            500
     D thisSQL1        S            500
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     C     *LOVAL        SETLL     SMFILTRN
     C                   READ      SMFILTR1                             3545
      *
      ** Database error
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SMFILTR1'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Start loop
      *
     C                   DOW       EndOfFile = False
      *
      ** Process Update of files
      *
     C                   EXSR      SRTransf
      *
      ** Read next record
      *
     C                   READ      SMFILTR1                             3545
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C                   EVAL      DBFile = 'SMFILTR1'
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
     C                   EVAL      *INLR = *ON

      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *                                                               *
      * SRTransf - Transfer records                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRTransf      BEGSR
      *
     C                   EVAL      UFILE = PFILE
      *
     C                   EVAL      thisSQL = 'INSERT INTO ' +UFILE+ ' SELECT * '
     C                                     + 'FROM TEMPLIB/' +UFILE
      *
      * Delete corrupted records
      *
     C                   EVAL      thisSQL1 = 'DELETE FROM ' +UFILE
      *
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL1
     C/END-EXEC
      *
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
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
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2020
