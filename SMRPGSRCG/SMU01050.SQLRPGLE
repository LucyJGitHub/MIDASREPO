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
      *  Last Amend No. MD059958           Date 17May22               *
      *  Prev Amend No. MD058089           Date 01Sep21               *
      *                 CSD103    *CREATE  Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059958 - GPST and ZPST successfully run but produced dump. *
      *             Error in SQL insert in GZDEALSDG and DEALSDG      *
      *             due to added fields by CIR020.                    *
      *  MD058089 - Deliverable Data Split for SM and UP              *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
     F*SMFILTRN* IF   E           K DISK    INFSR(*PSSR)                                    MD058089
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
     D Layer           S              6A
     D Zprf            S              2A
     D Gprf            S              2A
     D UFILE           S             10A
     D LIB1            S             10A
     D File            S             10A
     D Member          S             10A
     D thisSQL         S            500
     D thisSQL1        S            500
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
     D SMFILT        E DS                  EXTNAME(SMFITJW0)                                MD058089
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     C******LOVAL        SETLL     SMFILTRN                                                 MD058089
     C**********         READ      SMFLITD0                             3545                MD058089
     C/EXEC SQL                                                                             MD058089
     C+ declare ACursor insensitive scroll cursor for                                       MD058089
     C+ select * from SMFITJW0                                                              MD058089
     C+ order by PFILE                                                                      MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
     C/EXEC SQL                                                                             MD058089
     C+ open ACursor                                                                        MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
     C/EXEC SQL                                                                             MD058089
     C+ fetch next from ACursor into :SMFILT                                                MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
      *
      ** Database error
      *
     C**********         IF        ErrorOnFl = True                                         MD058089
     C                   IF        SQLCODE <> 0                                             MD058089
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SMFLITD0'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Start loop
      *
     C**********         DOW       EndOfFile = False                                        MD058089
     C                   DOW       SQLCODE = 0                                              MD058089
      *
      ** Process Update of files
      *
     C     Layer         IFEQ      'Zonal '
     C     LAYR          ANDEQ     'Zonal  '
     C                   EXSR      SRTransf
      *
      *** Reorganize file after update
      *
     C                   EXSR      ReorgFile
     C                   ENDIF
      *
     C     Layer         IFEQ      'Global'
     C     LAYR          ANDEQ     'Global '
     C                   EXSR      SRTransf1
      *
      *** Reorganize file after update
      *
     C                   EXSR      ReorgFile
     C                   ENDIF
      *
      ** Read next record
      *
     C**********         READ      SMFLITD0                             3545                MD058089
     C/EXEC SQL                                                                             MD058089
     C+ fetch next from ACursor into :SMFILT                                                MD058089
     C/END-EXEC                                                                             MD058089
      *
     C**********         IF        ErrorOnFl = True                                         MD058089
     C                   IF        SQLCODE <> 0                                             MD058089
     C                             AND SQLCODE <> 100                                       MD059958
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C                   EVAL      DBFile = 'SMFLITD0'
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
     C                   EVAL      *INLR = *ON
     C                   RETURN

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
     C                   EVAL      LIB1  = LIB
      *
     C                   IF        UFILE = 'DEALSDG'                                        MD059958
     C                             OR UFILE = 'DLGHISPD'                                    MD059958
     C                             OR UFILE = 'DLUPDDG'                                     MD059958
     C                             OR UFILE = 'IRVCACFPD'                                   MD059958
     C                             OR UFILE = 'IRVCIRSPD'                                   MD059958
     C                             OR UFILE = 'IRVECACFPD'                                  MD059958
     C                             OR UFILE = 'IRVECIRSPD'                                  MD059958
     C                             OR UFILE = 'IRVESIRSPD'                                  MD059958
     C                             OR UFILE = 'IRVEXSRPD'                                   MD059958
     C                             OR UFILE = 'IRVSIRSPD'                                   MD059958
     C                             OR UFILE = 'MXSDLDGPD'                                   MD059958
     C                             OR UFILE = 'TSMDDGPD'                                    MD059958
     C                   EVAL      thisSQL = 'INSERT INTO ' +UFILE+ ' SELECT * '
     C                                     +'FROM QTEMP/' +UFILE                            MD059958
     C                   ELSE                                                               MD059958
     C                   EVAL      thisSQL = 'INSERT INTO ' +UFILE+ ' SELECT * '
     C                                     +'FROM "#.' +Zprf +LIB1+ '"/' +UFILE
     C                   ENDIF                                                              MD059958
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
      * SRTransf1 - Transfer records (for global)                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRTransf1     BEGSR

     C                   EVAL      UFILE = PFILE
     C                   EVAL      LIB1  = LIB

     C                   IF        UFILE = 'GZDEALSDG'                                      MD059958
     C                             OR UFILE = 'GZDLGHISPD'                                  MD059958
     C                   EVAL      thisSQL = 'INSERT INTO ' +UFILE+ ' SELECT * '
     C                                     +'FROM QTEMP/' +UFILE                            MD059958
     C                   ELSE                                                               MD059958
     C                   EVAL      thisSQL = 'INSERT INTO ' +UFILE+ ' SELECT * '
     C                                     +'FROM "#.' +Gprf +LIB1+ '"/' +UFILE
     C                   ENDIF                                                              MD059958
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

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * ReorgFile - Reorganize a file                                 *
      *                                                               *
      * Called by: main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     ReorgFile     BEGSR

     C                   EVAL      File   = PFILE
     C                   EVAL      Member = '*FIRST    '

     C                   CALL      'SCC000060'
     C                   PARM                    File
     C                   PARM                    Member

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *inzsr        BEGSR
      *
     C     *entry        PLIST
      ** Parameters received from caller)
     C                   PARM                    Layer
     C                   PARM                    Zprf
     C                   PARM                    Gprf
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
