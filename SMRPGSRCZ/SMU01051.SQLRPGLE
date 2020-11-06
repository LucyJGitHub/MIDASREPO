     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update Base rate fields')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU01051 - Update of Base rate fields to conform with new    *
      *              type of base rates which is alphanumeric         *
      *                                                               *
      *  Function: This program will set Base rate fields of files    *
      *            from zero to blanks and from 'X_' to '0X' where X  *
      *            is a single digit number.                          *
      *                                                               *
      *  (c)Finastra International Limited 2020                       *
      *                                                               *
      *  Last Amend No. CSD103    *CREATE  Date 16Oct20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
     FSMFILUPD  IF   E           K DISK    INFSR(*PSSR)
      *Midas SD File Base Rate Fields to Update
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
     D UFIELD          S             10A
     D thisSQL         S            500
     D thisSQL1        S            500
     D thisSQL2        S            500
     D thisSQL3        S            500
     D thisSQL4        S            500
     D thisSQL5        S            500
     D thisSQL6        S            500
     D thisSQL7        S            500
     D thisSQL8        S            500
     D thisSQL9        S            500
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
     C     *LOVAL        SETLL     SMFILUPD
     C                   READ      SMFILUP1                             3545
      *
      ** Database error
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SMFILUP1'
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
     C                   EXSR      SRUpdate
      *
      ** Read next record
      *
     C                   READ      SMFILUP1                             3545
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C                   EVAL      DBFile = 'SMFILUP1'
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
      * SRUpdate - Update files                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
      *
     C                   EVAL      UFILE = PFILE
     C                   EVAL      UFIELD = PFIELD
      *
     C                   EVAL      thisSQL = 'Update '+UFILE+' SET '+UFIELD
     C                             +' = ''  '' WHERE '+UFIELD+' = ''00'' '
     C                             +'OR '+UFIELD+' = ''0 '' '
     C                             +'OR '+UFIELD+' = '' 0'' '
     C                   EVAL      thisSQL1 = 'Update '+UFILE+' SET '+UFIELD
     C                             +' = ''01'' WHERE '+UFIELD+' = ''1 '''
     C                             +'OR '+UFIELD+' = '' 1'' '
     C                   EVAL      thisSQL2 = 'Update '+UFILE+' SET '+UFIELD
     C                             +' = ''02'' WHERE '+UFIELD+' = ''2 '''
     C                             +'OR '+UFIELD+' = '' 2'' '
     C                   EVAL      thisSQL3 = 'Update '+UFILE+' SET '+UFIELD
     C                             +' = ''03'' WHERE '+UFIELD+' = ''3 '''
     C                             +'OR '+UFIELD+' = '' 3'' '
     C                   EVAL      thisSQL4 = 'Update '+UFILE+' SET '+UFIELD
     C                             +' = ''04'' WHERE '+UFIELD+' = ''4 '''
     C                             +'OR '+UFIELD+' = '' 4'' '
     C                   EVAL      thisSQL5 = 'Update '+UFILE+' SET '+UFIELD
     C                             +' = ''05'' WHERE '+UFIELD+' = ''5 '''
     C                             +'OR '+UFIELD+' = '' 5'' '
     C                   EVAL      thisSQL6 = 'Update '+UFILE+' SET '+UFIELD
     C                             +' = ''06'' WHERE '+UFIELD+' = ''6 '''
     C                             +'OR '+UFIELD+' = '' 6'' '
     C                   EVAL      thisSQL7 = 'Update '+UFILE+' SET '+UFIELD
     C                             +' = ''07'' WHERE '+UFIELD+' = ''7 '''
     C                             +'OR '+UFIELD+' = '' 7'' '
     C                   EVAL      thisSQL8 = 'Update '+UFILE+' SET '+UFIELD
     C                             +' = ''08'' WHERE '+UFIELD+' = ''8 '''
     C                             +'OR '+UFIELD+' = '' 8'' '
     C                   EVAL      thisSQL9 = 'Update '+UFILE+' SET '+UFIELD
     C                             +' = ''09'' WHERE '+UFIELD+' = ''9 '''
     C                             +'OR '+UFIELD+' = '' 9'' '
      *
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL1
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL2
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL3
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL4
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL5
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL6
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL7
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL8
     C/END-EXEC
     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :thisSQL9
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
