/*******************************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Populate Customer Number Field')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00066 - Utility for populating Customer Number Field      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 01Jan10               *
      *  Prev Amend No. BUG16705*CREATE    Date 05Mar08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993  - Delivery of upgrade programs to core.             *
      *           - Renamed program S016705R01.                       *
      *  BUG16705 - The system should automatically generate customer *
      *             number if field is blank                          *
      *                                                               *
      *****************************************************************
      /EJECT
     FSDCUSTL0  IF   E           K DISK
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Dynamic SQL statement work field
     D WSTRSQL         S           1000A   INZ(*BLANKS)
 
     D KCNUM           S              6A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C     *DTAARA       DEFINE                  CNLU              6
     C                   IN        CNLU
     C                   Eval      KCNUM = CNLU
     C     KCNUM         CHAIN     SDCUSTL0
 
     C                   IF        %FOUND
     C                   EXSR      SRCMRK
     C                   EXSR      SRACUS
     C                   EXSR      SRCHEQ
     C                   EXSR      SRSAFE
     C                   EXSR      SRCUX2
     C                   EXSR      SRCUX1
     C                   EXSR      SRCUST
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCMRK - Populate Marketing groups                           *
      *****************************************************************
      *
     C     SRCMRK        BEGSR
      *
     C                   EVAL      WSTRSQL = 'UPDATE SDCMRKPD SET D7CUST = '+
     C                                        ''''+ BBCUST + '''' +
     C                                        ' WHERE D7CUST = ' +
     C                                        '''      '''
      *
      ** Execute command
     C                   EXSR      POPRTN
      *
      *
      ** Check for error in SQL execution
 
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
     C                   MOVEL     'S016705'     DBPGM
     C                   MOVEL     'SDCMRKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     WSTRSQL       DBKEY
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRACUS - Populate Additional Customer Details                *
      *****************************************************************
      *
     C     SRACUS        BEGSR
      *
     C                   EVAL      WSTRSQL = 'UPDATE SDACUSPD SET E5CUST = '+
     C                                        ''''+ BBCUST + '''' +
     C                                        ' WHERE E5CUST = ' +
     C                                        '''      '''
 
      ** Execute command
 
     C                   EXSR      POPRTN
      *
      ** Check for error in SQL execution
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
     C                   MOVEL     'S016705'     DBPGM
     C                   MOVEL     'SDACUSPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     WSTRSQL       DBKEY
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *
      *  SRCHEQ - Populate Cheque Handling Details                    *
      *****************************************************************
      *
     C     SRCHEQ        BEGSR
      *
     C                   EVAL      WSTRSQL = 'UPDATE SDCHEQPD SET SCCUST = '+
     C                                        ''''+ BBCUST + '''' +
     C                                        ' WHERE SCCUST = ' +
     C                                        '''      '''
      *
      ** Execute command
     C                   EXSR      POPRTN
      *
      *
      ** Check for error in SQL execution
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
     C                   MOVEL     'S016705'     DBPGM
     C                   MOVEL     'SDCHEQPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     WSTRSQL       DBKEY
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRSAFE - Populate Safes Details                              *
      *****************************************************************
      *
     C     SRSAFE        BEGSR
      *
     C                   EVAL      WSTRSQL = 'UPDATE SDSAFEPD SET SACUST = '+
     C                                        ''''+ BBCUST + '''' +
     C                                        ' WHERE SACUST = ' +
     C                                        '''      '''
      *
      ** Execute command
     C                   EXSR      POPRTN
      *
      *
      ** Check for error in SQL execution
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
     C                   MOVEL     'S016705'     DBPGM
     C                   MOVEL     'SDSAFEPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     WSTRSQL       DBKEY
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRCUX2 - Populate European Reporting                         *
      *****************************************************************
      *
     C     SRCUX2        BEGSR
      *
     C                   EVAL      WSTRSQL = 'UPDATE SDCUX2PD SET VFCUST = '+
     C                                        ''''+ BBCUST + '''' +
     C                                        ' WHERE VFCUST = ' +
     C                                        '''      '''
      *
      ** Execute command
     C                   EXSR      POPRTN
      *
      ** Check for error in SQL execution
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
     C                   MOVEL     'S016705'     DBPGM
     C                   MOVEL     'SDCUX2PD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     WSTRSQL       DBKEY
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRCUX1 - Populate European Reporting                         *
      *****************************************************************
      *
     C     SRCUX1        BEGSR
      *
     C                   EVAL      WSTRSQL = 'UPDATE SDCUX1PD SET CUCNUM = '+
     C                                        ''''+ BBCUST + '''' +
     C                                        ' WHERE CUCNUM = ' +
     C                                        '''      '''
      *
      ** Execute command
     C                   EXSR      POPRTN
      *
      ** Check for error in SQL execution
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
     C                   MOVEL     'S016705'     DBPGM
     C                   MOVEL     'SDCUX1PD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     WSTRSQL       DBKEY
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRCUST - Populate Customer Details Extension                 *
      *****************************************************************
      *
     C     SRCUST        BEGSR
      *
     C                   EVAL      WSTRSQL = 'UPDATE SDCUSTQD SET CQCUST = '+
     C                                        ''''+ BBCUST + '''' +
     C                                        ' WHERE CQCUST = ' +
     C                                        '''      '''
      *
      ** Execute command
     C                   EXSR      POPRTN
      *
      ** Check for error in SQL execution
     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
     C                   MOVEL     'S016705'     DBPGM
     C                   MOVEL     'SDCUSTQD'    DBFILE
     C                   MOVEL     '007'         DBASE
     C                   MOVEL     WSTRSQL       DBKEY
      *
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * POPRTN - Delete Routine                                       *
      *****************************************************************
      *
     C     POPRTN        BEGSR
      *
      * Prepare SQL statement
 
     C/EXEC SQL
     C+ PREPARE S1 FROM :WSTRSQL
     C/END-EXEC
 
      * Execute SQL statement
 
     C/EXEC SQL
     C+ EXECUTE S1
     C/END-EXEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
