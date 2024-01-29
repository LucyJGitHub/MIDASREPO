     H DEBUG
     H COPYRIGHT('(c) Finastra International 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Deliverable Data Incorporation   ')           *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000730 - This program needs to run when a bespoke feature  *
      *             is delivered into core.                           *
      *             Program will housekeep a series of BTD-XTD        *
      *             tables (see list at the bottom).                  *
      *             (1) BTD records found are deleted                 *
      *             (2) XTD records found have their MODE field       *
      *             'switched' from 'B' to 'C'                        *
      *             Program needs to be added as EXE in UPDLVCPD      *
      *             with *BEFORE.                                     *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD061948 *CREATE     Date 10Oct23             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061948 - Housekeeping program for deliverable data         *
      *                                                               *
      *****************************************************************
      /EJECT

      * Current
     D CGBNMCPA        S             10    DIM(999)
     D CACCOTTA        S             15    DIM(999)
     D CACCOTT1        S             30    DIM(999)
     D CACCOTT2        S             30    DIM(999)
     D CADINDXA        S             10    DIM(999)
     D CAERNAMA        S             25    DIM(999)
     D CAFOBNMA        S             10    DIM(999)
     D CAKPNAMA        S             10    DIM(999)
     D CAHRNAMA        S             10    DIM(999)
     D CGUFILEA        S             10    DIM(999)
     D CGISVALA        S             20    DIM(999)
     D CGTDINDA        S             20  0 DIM(999)

     D SCSRS         E DS                  EXTNAME(SCSRSCTD)
     D SCSRD         E DS                  EXTNAME(SCSRDCTD)
     D SCSRB         E DS                  EXTNAME(SCSRBCTD)
     D SCSRC         E DS                  EXTNAME(SCSRCCTD)
     D SCSRI         E DS                  EXTNAME(SCSRICTD)
     D SCSRM         E DS                  EXTNAME(SCSRMCTD)
     D SCSRN         E DS                  EXTNAME(SCSRNCTD)
     D                                     PREFIX(N)
     D SCSRO         E DS                  EXTNAME(SCSROCTD)
     D SCSRP         E DS                  EXTNAME(SCSRPCTD)
     D SCSRR         E DS                  EXTNAME(SCSRRCTD)
     D SCSRT         E DS                  EXTNAME(SCSRTCTD)
     D SCSRV         E DS                  EXTNAME(SCSRVCTD)
     D SCSRW         E DS                  EXTNAME(SCSRWCTD)
     D SCSRX         E DS                  EXTNAME(SCSRXCTD)
     D  XLCD         E                     EXTFLD(LCD)

     D TotRow          S              5  0
     D DelTotRow       S              5  0
     D Ix              S              5  0
     D Iy              S              5  0
     D IxA             S              5  0
     D IxN             S              5  0
     D FileA           S             10A

     D sqlStat         S            500A
     D SQLString       S            200A
     D F_DDS           S             10A
     D P_FILE          S             10A
     D P_FILEA         S             10A
     D F_NDDS          S             10A
     D AF_DDS          S             10A
     D AF_NDDS         S             10A
     D xWHFLDI         S             10A
     D DDS_Used        S              1A
     D DS              S             10A
     D WHEREA          S            500A
     D XCAR            S              6A
     D v_ProcessA      S              1A
     D WFILEd          S             10A
     D FRoot           S              5A


     D                 DS
     D  FFDS                   1     60
     D  FileDS                 1     10
     D  FDesDs                11     60
     D                 DS
     D  SRCDS                  1     15
     D  COMDS                  1     10
     D  SEQDS                 11     15
     D                 DS
     D  SR1DS                  1     30
     D  CO1DS                  1     10
     D  SE1DS                 11     15
     D  CO2DS                 16     25
     D  SE2DS                 26     30
     D                 DS
     D  REFDS                  1     12
     D  NMCPDS                 1     10
     D  SQNBDS                11     12
     D                 DS
     D  MNUDS                  1     10
     D  MIINDS                 1     10
     D                 DS
     D  MTXDS                  1     10
     D  INDXDS                 1     10
     D                 DS
     D  RCODS                  1     25
     D  RNAMDS                 1     10
     D  COTTDS                11     20
     D  CSEQDS                21     25
     D                 DS
     D  RFSDS                  1     20
     D  YRNADS                 1     10
     D  YRSFDS                11     20
     D                 DS
     D  REPDS                  1     10
     D  DXRNDS                 1     10
     D                 DS
     D  TRGDS                  1     14
     D  FILEDS2                1     10
     D  TIMEDS                11     11
     D  EVNTDS                12     12
     D  SEQQDS                13     14
     D                 DS
     D  SVLDS                  1     20
     D  GISVDS                 1     20
     D                 DS
     D  SVRDS                  1    224
     D  GJREDS                 1      1
     D  GJSVDS                 2     21
     D  GJSEDS                22     24
     D  GJVDDS                25    224
     D                 DS
     D  PWHDS                  1     10
     D  GHHIDS                 1     10  0
     D                 DS
     D  PWNDS                  1     20
     D  PWNDSN                 1     20  0
     D  GLHIDS                 1     10  0
     D  GLDIDS                11     20  0

     D ReturnCode      S              7
     D T_BTD           S             10A
     D T_XTD           S             10A
     D I_JI0           S             10A
     D SQLDynStmt      S           5000A

     D DBASE           S              3A
     D Quote           S              1    INZ('''')
     D FileBTD         S             10A

     D FDataZ          S             80    DIM(15) CTDATA PERRCD(1)
     D FDataG          S             80    DIM(8) CTDATA PERRCD(1)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    LAYER             7
     C                   PARM                    C_MODE            4
     C                   PARM                    FEAT              6
     C                   PARM                    Return           10

     C                   SELECT
     C                   WHEN      LAYER = '*GLOBAL'
     C                   DO        8             Ix
     C                   EXSR      SR_UpdateG
     C                   ENDDO
     C
     C                   WHEN      LAYER = '*ZONE'
     C                   DO        15            Ix
     C                   EXSR      SR_UpdateZ
     C                   ENDDO

     C                   ENDSL

     C                   seton                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_UpdateZ - 1. remove BTD record                             *
      *              2. switch XTD record from 'B' to  'C'            *
      *                                                               *
      *****************************************************************
     C     SR_UpdateZ    BEGSR

      * Store associated records if any
     C                   eval      IxA = %dec((%subst(FDataZ(Ix):30:1)):1:0)
     C                   eval      FileA = %trim(%subst(FDataZ(Ix):1:5)) +
     C                             'BTD'
     C                   Exsr      SR_Store

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             %trim(%subst(FDataZ(Ix):1:5)) + 'BTD' +
     C                             ' WHERE '  +
     C                             %trim(%subst(FDataZ(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '010'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FDataZ(Ix):1:5)) + 'XTD' +
     C                             ' set '  +
     C                             %trim(%subst(FDataZ(Ix):21:6)) + ' = ' +
     C                             Quote + 'C' + Quote +
     C                             ' WHERE '  +
     C                             %trim(%subst(FDataZ(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote + ' and ' +
     C                             %trim(%subst(FDataZ(Ix):21:6)) + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '020'
     C                   exsr      *pssr
     C                   Endif

      * Check if associated tables exist
     C                   eval      IxA = %dec((%subst(FDataZ(Ix):30:1)):1:0)
     C                   eval      FileBTD = %trim(%subst(FDataZ(Ix):1:8))
     C                   Do        IxA           IxN
     C                   eval      FileA = %subst(FDataZ(Ix):30+IxN*10:10)
     C                   exsr      SR_Associate
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR_UpdateG - 1. remove BTD record                             *
      *              2. switch XTD record from 'B' to  'C'            *
      *                                                               *
      *****************************************************************
     C     SR_UpdateG    BEGSR

      * Store associated records if any
     C                   eval      IxA = %dec((%subst(FDataG(Ix):30:1)):1:0)
     C                   eval      FileA = %trim(%subst(FDataG(Ix):1:5)) +
     C                             'BTD'
     C                   Exsr      SR_Store

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             %trim(%subst(FDataG(Ix):1:5)) + 'BTD' +
     C                             ' WHERE '  +
     C                             %trim(%subst(FDataG(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '011'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FDataG(Ix):1:5)) + 'XTD' +
     C                             ' set '  +
     C                             %trim(%subst(FDataG(Ix):21:6)) + ' = ' +
     C                             Quote + 'C' + Quote +
     C                             ' WHERE '  +
     C                             %trim(%subst(FDataG(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote + ' and ' +
     C                             %trim(%subst(FDataG(Ix):21:6)) + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '021'
     C                   exsr      *pssr
     C                   Endif

      * Check if associated tables exist
     C                   eval      IxA = %dec((%subst(FDataG(Ix):30:1)):1:0)
     C                   eval      FileBTD = %trim(%subst(FDataG(Ix):1:8))
     C                   Do        IxA           IxN
     C                   eval      FileA = %subst(FDataG(Ix):30+IxN*10:10)
     C                   exsr      SR_Associate
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_Store - Store in array the associated data                *
      *                                                               *
      *****************************************************************
     C     SR_Store      BEGSR

     C                   SELECT

      * S C S R B B T D
     C                   WHEN      FileA = 'SCSRBBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataZ(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat11
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS11 insensitive scroll cursor for sqlStat11
     C/end-exec

     C/exec SQL
     C+ open CursorS11
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS11
     C+ into :SCSRB
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      CGBNMCPA(Iy) = GBNMCP
     C/exec SQL
     C+ fetch next
     C+ from CursorS11
     C+ into :SCSRB
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS11
     C/end-exec

      * S C S R C B T D
     C                   WHEN      FileA = 'SCSRCBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataZ(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat12
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS12 insensitive scroll cursor for sqlStat12
     C/end-exec

     C/exec SQL
     C+ open CursorS12
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS12
     C+ into :SCSRC
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      COMDS = ACCOTT
     C                   eval      SEQDS = ACCSEQ
     C                   eval      CACCOTTA(Iy) = SRCDS
     C/exec SQL
     C+ fetch next
     C+ from CursorS12
     C+ into :SCSRC
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS12
     C/end-exec

      * S C S R D B T D
     C                   WHEN      FileA = 'SCSRDBTD'

      * S C S R I B T D
     C                   WHEN      FileA = 'SCSRIBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataZ(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat14
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS14 insensitive scroll cursor for sqlStat14
     C/end-exec

     C/exec SQL
     C+ open CursorS14
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS14
     C+ into :SCSRI
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      CADINDXA(Iy) = ADINDX
     C/exec SQL
     C+ fetch next
     C+ from CursorS14
     C+ into :SCSRI
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS14
     C/end-exec

      * S C S R M B T D
     C                   WHEN      FileA = 'SCSRMBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataZ(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat15
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS15 insensitive scroll cursor for sqlStat15
     C/end-exec

     C/exec SQL
     C+ open CursorS15
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS15
     C+ into :SCSRM
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      RNAMDS = AERNAM
     C                   eval      COTTDS = AECOTT
     C                   eval      CSEQDS = AECSEQ
     C                   eval      CAERNAMA(Iy) = RCODS
     C/exec SQL
     C+ fetch next
     C+ from CursorS15
     C+ into :SCSRM
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS15
     C/end-exec

      * S C S R N B T D
     C                   WHEN      FileA = 'SCSRNBTD'

      * S C S R O B T D
     C                   WHEN      FileA = 'SCSROBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataZ(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat16
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS16 insensitive scroll cursor for sqlStat16
     C/end-exec

     C/exec SQL
     C+ open CursorS16
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS16
     C+ into :SCSRO
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      CAFOBNMA(Iy) = AFOBNM
     C/exec SQL
     C+ fetch next
     C+ from CursorS16
     C+ into :SCSRO
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS16
     C/end-exec

      * S C S R P B T D
     C                   WHEN      FileA = 'SCSRPBTD'

      * S C S R R B T D
     C                   WHEN      FileA = 'SCSRRBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataZ(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat17
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS17 insensitive scroll cursor for sqlStat17
     C/end-exec

     C/exec SQL
     C+ open CursorS17
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS17
     C+ into :SCSRR
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      CAHRNAMA(Iy) = AHRNAM
     C/exec SQL
     C+ fetch next
     C+ from CursorS17
     C+ into :SCSRR
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS17
     C/end-exec

      * S C S R S B T D
      * not needed as there is only one password per feature
     C                   WHEN      FileA = 'SCSRSBTD'

      * S C S R T B T D
     C                   WHEN      FileA = 'SCSRTBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataZ(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat18
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS18 insensitive scroll cursor for sqlStat18
     C/end-exec

     C/exec SQL
     C+ open CursorS18
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS18
     C+ into :SCSRT
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      CGUFILEA(Iy) = GUFILE
     C/exec SQL
     C+ fetch next
     C+ from CursorS18
     C+ into :SCSRT
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS18
     C/end-exec

      * S C S R V B T D
     C                   WHEN      FileA = 'SCSRVBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataZ(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat19
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS19 insensitive scroll cursor for sqlStat19
     C/end-exec

     C/exec SQL
     C+ open CursorS19
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS19
     C+ into :SCSRV
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      CGISVALA(Iy) = GSSVAL
     C/exec SQL
     C+ fetch next
     C+ from CursorS19
     C+ into :SCSRV
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS19
     C/end-exec

      * S C S R W B T D
     C                   WHEN      FileA = 'SCSRWBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataZ(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat20
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS20 insensitive scroll cursor for sqlStat20
     C/end-exec

     C/exec SQL
     C+ open CursorS20
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS20
     C+ into :SCSRW
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      GLHIDS = GTHIND
     C                   eval      GLDIDS = GTDIND
     C                   eval      CGTDINDA(Iy) = PWNDSN
     C/exec SQL
     C+ fetch next
     C+ from CursorS20
     C+ into :SCSRW
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS20
     C/end-exec

      * S C S R X B T D
      * not needed as feature name is enough
     C                   WHEN      FileA = 'SCSRXBTD'

      * G P S R S B T D
      * not needed as there is only one password per feature
     C                   WHEN      FileA = 'GPSRSBTD'

      * G P S R D B T D
     C                   WHEN      FileA = 'GPSRDBTD'

      * G P S R I B T D
     C                   WHEN      FileA = 'GPSRIBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataG(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat24
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS24 insensitive scroll cursor for sqlStat24
     C/end-exec

     C/exec SQL
     C+ open CursorS24
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS24
     C+ into :SCSRI
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      CADINDXA(Iy) = ADINDX
     C/exec SQL
     C+ fetch next
     C+ from CursorS24
     C+ into :SCSRI
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS24
     C/end-exec

      * G P S R T B T D
     C                   WHEN      FileA = 'GPSRTBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataG(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat28
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS28 insensitive scroll cursor for sqlStat28
     C/end-exec

     C/exec SQL
     C+ open CursorS28
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS28
     C+ into :SCSRT
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      CGUFILEA(Iy) = GUFILE
     C/exec SQL
     C+ fetch next
     C+ from CursorS28
     C+ into :SCSRT
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS28
     C/end-exec

      * G P S R V B T D
     C                   WHEN      FileA = 'GPSRVBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataG(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat29
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS29 insensitive scroll cursor for sqlStat29
     C/end-exec

     C/exec SQL
     C+ open CursorS29
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS29
     C+ into :SCSRV
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      CGISVALA(Iy) = GSSVAL
     C/exec SQL
     C+ fetch next
     C+ from CursorS29
     C+ into :SCSRV
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS29
     C/end-exec

      * G P S R W B T D
     C                   WHEN      FileA = 'GPSRWBTD'
     C                   eval      Iy = 0
     C                   eval      sqlStat = 'select * from ' +
     C                             %trim(FileA) + ' WHERE '  +
     C                             %trim(%subst(FDataG(Ix):11:10)) + ' = ' +
     C                             Quote + FEAT + Quote
     C/EXEC SQL
     C+ prepare sqlStat30
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare CursorS30 insensitive scroll cursor for sqlStat30
     C/end-exec

     C/exec SQL
     C+ open CursorS30
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorS30
     C+ into :SCSRW
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   eval      Iy = Iy + 1
     C                   eval      GLHIDS = GTHIND
     C                   eval      GLDIDS = GTDIND
     C                   eval      CGTDINDA(Iy) = PWNDSN
     C/exec SQL
     C+ fetch next
     C+ from CursorS30
     C+ into :SCSRW
     C/end-exec

     C                   ENDDO
     C/exec SQL
     C+ close CursorS30
     C/end-exec

     C                   ENDSL


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  SR_Associate - update associated tables                      *
      *                                                               *
      *****************************************************************
     C     SR_Associate  BEGSR

     C                   SELECT

      * S C S R B B T D
      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'SDMRFBTD'
     C                   eval      Iy = 1
     C                   EVAL      REFDS = CGBNMCPA(Iy)

     C                   If        REFDS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       REFDS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where DLNMCP  = ' +
     C                             '''' + NMCPDS + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '022'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set DLMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where DLNMCP  = ' +
     C                             '''' + NMCPDS + ''''  +  ' and ' +
     C                             ' DLMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '023'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      REFDS = CGBNMCPA(Iy)

     C                   ENDDO

      * S C S R C B T D
      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'CBCMPBTD'
     C                   eval      Iy = 1
     C                   EVAL      SRCDS = CACCOTTA(Iy)

     C                   If        SRCDS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       SRCDS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where DHCOTT  = ' +
     C                             '''' + COMDS + '''' + ' and DHCSEQ = ' +
     C                             '''' + SEQDS + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '024'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set DHMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where DHCOTT  = ' +
     C                             '''' + COMDS + '''' + ' and DHCSEQ = ' +
     C                             '''' + SEQDS + ''''   +  ' and ' +
     C                             ' DHMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '025'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      SRCDS = CACCOTTA(Iy)

     C                   ENDDO

      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'CBDPRBTD'
     C                   eval      Iy = 1
     C                   EVAL      SRCDS = CACCOTTA(Iy)

     C                   If        SRCDS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       SRCDS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where (DIDSON  = ' +
     C                             '''' + COMDS + '''' + ' and DIDSOS = ' +
     C                             '''' + SEQDS + '''' + ') or (DIDDON  = ' +
     C                             '''' + COMDS + '''' + ' and DIDDOS = ' +
     C                             '''' + SEQDS + '''' + ')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '026'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set DIMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where (DIDSON  = ' +
     C                             '''' + COMDS + '''' + ' and DIDSOS = ' +
     C                             '''' + SEQDS + '''' + ') or (DIDDON  = ' +
     C                             '''' + COMDS + '''' + ' and DIDDOS = ' +
     C                             '''' + SEQDS + '''' + ')'  +  ' and ' +
     C                             ' DIMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '027'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      SRCDS = CACCOTTA(Iy)

     C                   ENDDO

      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'CBMEXBTD'
     C                   eval      Iy = 1
     C                   EVAL      SRCDS = CACCOTTA(Iy)

     C                   If        SRCDS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       SRCDS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where (DKCOTT  = ' +
     C                             '''' + COMDS + '''' + ' and DKCSEQ = ' +
     C                             '''' + SEQDS + '''' + ') or (DKMECN  = ' +
     C                             '''' + COMDS + '''' + ' and DKMECS = ' +
     C                             '''' + SEQDS + '''' + ')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '028'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set DKMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where (DKCOTT  = ' +
     C                             '''' + COMDS + '''' + ' and DKCSEQ = ' +
     C                             '''' + SEQDS + '''' + ') or (DKMECN  = ' +
     C                             '''' + COMDS + '''' + ' and DKMECS = ' +
     C                             '''' + SEQDS + '''' + ')'  +  ' and ' +
     C                             ' DKMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '029'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      SRCDS = CACCOTTA(Iy)

     C                   ENDDO

      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'CBMDCBTD'
     C                   eval      Iy = 1
     C                   EVAL      SRCDS = CACCOTTA(Iy)

     C                   If        SRCDS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       SRCDS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where DJCOTT  = ' +
     C                             '''' + COMDS + '''' + ' and DJCSEQ = ' +
     C                             '''' + SEQDS + '''' + ')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '030'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set DJMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where DJCOTT  = ' +
     C                             '''' + COMDS + '''' + ' and DJCSEQ = ' +
     C                             '''' + SEQDS + ''''  +  ' and ' +
     C                             ' DJMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '031'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      SRCDS = CACCOTTA(Iy)

     C                   ENDDO

      * S C S R D B T D
      *-------------------------------------------------------------------------

      * S C S R I B T D  -  G P S R I B T D
      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'SFMNUBTD'
     C                   eval      Iy = 1
     C                   EVAL      MNUDS = CADINDXA(Iy)

     C                   If        MNUDS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       MNUDS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where MIINDX  = ' +
     C                             '''' + MIINDS + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '032'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set MIMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where MIINDX  = ' +
     C                             '''' + MIINDS + ''''    +  ' and ' +
     C                             ' MIMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '033'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      MNUDS = CADINDXA(Iy)

     C                   ENDDO

      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'GPMTXBTD'
     C                   eval      Iy = 1
     C                   EVAL      MNUDS = CADINDXA(Iy)

     C                   If        MNUDS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       MNUDS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where MIINDX  = ' +
     C                             '''' + MIINDS + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '034'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set MIMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where MIINDX  = ' +
     C                             '''' + MIINDS + ''''    +  ' and ' +
     C                             ' MIMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '035'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      MNUDS = CADINDXA(Iy)

     C                   ENDDO

      * S C S R M B T D
      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'FCRCOBTD'
     C                   eval      Iy = 1
     C                   EVAL      RCODS = CAERNAMA(Iy)

     C                   If        RCODS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       RCODS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where D3RNAM  = ' +
     C                             '''' + RNAMDS + '''' + ' and D3COTT = ' +
     C                             '''' + COTTDS + '''' + ' and D3CSEQ = ' +
     C                             '''' + CSEQDS + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '036'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set D3MODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where D3RNAM  = ' +
     C                             '''' + RNAMDS + '''' + ' and D3COTT = ' +
     C                             '''' + COTTDS + '''' + ' and D3CSEQ = ' +
     C                             '''' + CSEQDS + '''' +  ' and ' +
     C                             ' D3MODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '037'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      RCODS = CAERNAMA(Iy)

     C                   ENDDO

      * S C S R N B T D
      *-------------------------------------------------------------------------

      * S C S R O B T D
      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'FCRSFBTD'
     C                   eval      Iy = 1
     C                   EVAL      RFSDS = CAFOBNMA(Iy)

     C                   If        RFSDS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       RFSDS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where DYRNAM  = ' +
     C                             '''' + YRNADS + '''' + ' and DYRSFX = ' +
     C                             '''' + YRSFDS + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '038'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set DYMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where DYRNAM  = ' +
     C                             '''' + YRNADS + '''' + ' and DYRSFX = ' +
     C                             '''' + YRSFDS + '''' +  ' and ' +
     C                             ' DYMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '039'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      RFSDS = CAFOBNMA(Iy)

     C                   ENDDO

      * S C S R P B T D
      *-------------------------------------------------------------------------

      * S C S R R B T D
      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'FCREPBTD'
     C                   eval      Iy = 1
     C                   EVAL      REPDS = CAHRNAMA(Iy)

     C                   If        REPDS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       REPDS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where DXRNAM  = ' +
     C                             '''' + DXRNDS + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '040'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set DXMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where DXRNAM  = ' +
     C                             '''' + DXRNDS + ''''  +  ' and ' +
     C                             ' DXMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '041'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      REPDS = CAHRNAMA(Iy)

     C                   ENDDO

      * S C S R S B T D  -  G P S C R S B T D
      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'GPSECBTD'

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where P@SARN  = ' +
     C                             '''' + FEAT + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '042'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set REMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where P@SARN  = ' +
     C                             '''' + FEAT + ''''  +  ' and ' +
     C                             ' REMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '043'
     C                   exsr      *pssr
     C                   Endif

      * S C S R T B T D  -  G P S R T B T D
      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'SCTRGBTD'
     C                             or FileA = 'GPTRGBTD'
     C                   eval      Iy = 1
     C                   EVAL      TRGDS = CGUFILEA(Iy)

     C                   If        TRGDS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       TRGDS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where TRFILE  = ' +
     C                             '''' + FILEDS2 + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '044'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set TRMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where TRFILE  = ' +
     C                             '''' + FILEDS2 + ''''  +  ' and ' +
     C                             ' TRMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '045'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      TRGDS = CGUFILEA(Iy)

     C                   ENDDO

      * S C S R V B T D  -  G P S R V B T D
      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'SDSVLBTD'
     C                             or FileA = 'GPSVLBTD'
     C                   eval      Iy = 1
     C                   EVAL      SVLDS = CGISVALA(Iy)

     C                   If        SVLDS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       SVLDS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where GISVAL  = ' +
     C                             '''' + GISVDS + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '046'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set GIMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where GISVAL  = ' +
     C                             '''' + GISVDS + ''''  +  ' and ' +
     C                             ' GIMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '047'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      SVLDS = CGISVALA(Iy)

     C                   ENDDO

      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'SDSVRBTD'
     C                             or FileA = 'GPSVRBTD'
     C                   eval      Iy = 1
     C                   EVAL      SVRDS = CGISVALA(Iy)

     C                   If        SVRDS = *blanks
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       SVRDS  <> *blanks

      * Remove BTD record

     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where GJSVAL  = ' +
     C                             '''' + GJSVDS + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '048'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set GJMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where GJSVAL  = ' +
     C                             '''' + GJSVDS + ''''  +  ' and ' +
     C                             ' GJMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '049'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      SVRDS = CGISVALA(Iy)

     C                   ENDDO


      * S C S R W B T D  - G P S R W B T D
      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'SDPWHBTD'
     C                   eval      Iy = 1
     C                   EVAL      PWNDSN = CGTDINDA(Iy)

     C                   If        PWNDSN = *zero
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       PWNDSN  <> *zero

      * Remove BTD record

     C                   EVAL      GHHIDS = GLHIDS
     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where GHHIND  = ' +
     C                             %char(GHHIDS)

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '050'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set GHMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where GHHIND  = ' +
     C                             %char(GHHIDS)  +  ' and ' +
     C                             ' GHMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '051'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      PWNDSN = CGTDINDA(Iy)

     C                   ENDDO

      *-------------------------------------------------------------------------
     C                   WHEN      FileA = 'SDPWNBTD'
     C                   eval      Iy = 1
     C                   EVAL      PWNDSN = CGTDINDA(Iy)

     C                   If        PWNDSN = *zero
     C                   GOTO      End_Assoc
     C                   ENDIF

     C                   DOW       PWNDSN <> *zero

      * Remove BTD record

     C                   EVAL      GHHIDS = GLHIDS
     C                   eval      SQLDynStmt = 'delete from ' +
     C                             FileA + ' where GLHIND  = ' +
     C                             %char(GLHIDS)     +   ' and GLDIND = ' +
     C                             %char(GLDIDS)

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '052'
     C                   exsr      *pssr
     C                   Endif

      * Switch XTD record

     C                   eval      SQLDynStmt = 'update  ' +
     C                             %trim(%subst(FileA:1:5)) + 'XTD' +
     C                             ' set GLMODE = ' +
     C                             Quote + 'C' + Quote +
     C                             ' where GLHIND  = ' +
     C                             %char(GLHIDS)     +   ' and GLDIND = ' +
     C                             %char(GLDIDS)  +  ' and ' +
     C                             ' GLMODE ' + ' = ' +
     C                             Quote + 'B' + Quote

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0 and SQLCode <> 100
     C                   eval      DBASE = '053'
     C                   exsr      *pssr
     C                   Endif

     C                   eval      Iy = Iy + 1
     C                   EVAL      PWNDSN = CGTDINDA(Iy)

     C                   ENDDO

      * S C S R X B T D
      * not needed as feature name is enough
     C                   WHEN      FileA = 'SCSRXBTD'

     C                   ENDSL


     C     End_Assoc     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   eval      Return = '*Error'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
** FeatureKey Zone
SCSRBBTD  GBSARN    GBMODE   1         SDMRFBTD
SCSRCBTD  ACSARN    ACMODE   4         CBCMPBTD  CBDPRBTD  CBMEXBTD  CBMDCBTD
SCSRDBTD  SARN      MODE     0
SCSRIBTD  ADSARN    ADMODE   2         SFMNUBTD  GPMTXBTD
SCSRMBTD  AESARN    AEMODE   1         FCRCOBTD
SCSRNBTD  AXSARN    AXMODE   0
SCSROBTD  AFSARN    AFMODE   1         FCRSFBTD
SCSRPBTD  AKSARN    AKMODE   0
SCSRRBTD  AHSARN    AHMODE   1         FCREPBTD
SCSRSBTD  AXSARN    AXMODE   1         GPSECBTD
SCSRTBTD  GUSARN    GUMODE   1         SCTRGBTD
SCSRVBTD  GSSARN    GSMODE   2         SDSVLBTD  SDSVRBTD
SCSRWBTD  GTSARN    GTMODE   2         SDPWHBTD  SDPWNBTD
SCSRXBTD  DSON      XXMODE   0
SCSRXBTD  DDON      XXMODE   0
** FeatureKey Global
GPSRSBTD  AXSARN    AXMODE   1         GPSECBTD
GPSRDBTD  SARN      MODE     0
GPSRIBTD  ADSARN    ADMODE   2         SFMNUBTD  GPMTXBTD
GPSRNBTD  AXSARN    AXMODE   0
GPSRPBTD  AKSARN    AKMODE   0
GPSRTBTD  GUSARN    GUMODE   1         GPTRGBTD
GPSRVBTD  GSSARN    GSMODE   2         GPSVLBTD  GPSVRBTD
GPSRWBTD  GTSARN    GTMODE   2         GPPWHBTD  GPPWNBTD
