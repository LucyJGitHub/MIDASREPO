     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business processing for T_GZLDNIEX          *
      *                                                               *
      *  GO220005 - Midas UDF file update for LDNI                    *
      *                                                               *
      *  Function:  This program will update the T_GZLDNIEX UDF file  *
      *             by writing the new repo deal generated during     *
      *             automatic rollover of deals.                      *
      *                                                               *
      *  (c) Misys Banking Systems Ltd. 2011                          *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  Last Amend No. AR746974 *CREATE   Date 26May11               *
      *  Prev Amend No. ARnnnnnn           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR746974 - Midas UDF file update for LDNI during automatic   *
      *             rollover of repo deals - RECOMPILE.               *
      *             (Child: AR746975)                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FGPZONEL2  IF   E           K DISK
      *
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
     D SQLStmt         S           1000A   INZ(*Blanks)
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** LDNI
      *
     C/EXEC SQL
     C+ CREATE TABLE QTEMP/TEMPLDNI LIKE T_GZLDNIEX
     C/END-EXEC
      *
     C                   EVAL      SQLStmt= 'INSERT INTO QTEMP/TEMPLDNI ' +
     C                                      '(SELECT * FROM T_GZLDNIEX ' +
     C                                      'WHERE ZONE = ' + '''' +
     C                                      %TRIM(LZONE) + '''' +
     C                                      ' AND ' + 'DDDLNO = ' +
     C                                      '''' + %TRIM(ODLNO) + '''' + ')'
     C/EXEC SQL
     C+                  EXECUTE   Immediate :SQLStmt
     C/END-EXEC
      *
     C                   EVAL      SQLStmt= 'UPDATE QTEMP/TEMPLDNI SET ' +
     C                                      'ZONE = ' + '''' + %TRIM(LZONE) +
     C                                       '''' + ', ' + 'DDDLNO = ' + '''' +
     C                                      %TRIM(NDLNO) + ''''
     C/EXEC SQL
     C+                  EXECUTE   Immediate :SQLStmt
     C/END-EXEC
      *
     C                   EVAL      SQLStmt= 'INSERT INTO T_GZLDNIEX ' +
     C                                      '(SELECT * FROM QTEMP/TEMPLDNI)'
     C/EXEC SQL
     C+                  EXECUTE   Immediate :SQLStmt
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DROP TABLE QTEMP/TEMPLDNI
     C/END-EXEC
      *
      *
     C                   MOVE      '1'           *INLR
      *
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
     C                   PARM                    ODLNO             6
     C                   PARM                    NDLNO             6
      *
     C                   MOVE      *blank        UDFKey          800
      *
     C     *DTAARA       DEFINE                  LDA
     C                   IN        SDSTAT
      *
     C                   MOVE      *BLANKS       LZONE            10
     C     LIBR          CHAIN     GPZONEL2
     C                   EVAL      LZONE = ZOZONE
      *
     C                   ENDSR
