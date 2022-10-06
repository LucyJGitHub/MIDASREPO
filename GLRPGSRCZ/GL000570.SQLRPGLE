     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                   AR1097467B
/*STD *  RPGSQLBND                                                    *                   AR1097467B
/*EXI *  TEXT('Midas GL Inactive/Blocked Accounts Extract')
/*XBIA*: OVRDBF FILE(IBPAIZZ) TOFILE(RTZZ) MBR(IBPA)                : *
/*XBIB*: OVRDBF FILE(RETACZZ) TOFILE(RTZZ) MBR(RETAC)               : *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL000570 - Inactive/Blocked Accounts                         *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD059762           Date 20Apr22               *
      *  Prev Amend No. CSD103             Date 10Aug20               *
      *                 MD056972           Date 25Nov20               *
      *                 MD046248           Date 27Oct17               *
      *                 AR1097467B         Date 23Apr13               *
      *                 AR1097467A         Date 12Apr13               *
      *                 CGL127AP *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059762 - COB: GLC0570 failed due to variable overflow      *
      *             Amend to change EVAL to ADD to accept value even  *
      *             though field reached maximum.                     *
      *             Applied for MD060567.                             *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD056972 - SWIFT accounts not closed when accounts close     *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1097467B - Expected 15% COB run optimization not met       *
      *  AR1097467A - Expected 15% COB run optimization not met       *
      *  CGL127AP - COB Restructure - GL COB Optimisation Phase 1     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    41 - Print Retail Records count                            *
      *    42 - Print IBPA record output count                        *
      *    43 - Print AXFI record output count                        *
      *    44 - Print RETAC record output count                       *
      *    45 - Print ACDET record output count                       *                     MD056972
      *                                                               *
      *****************************************************************
      *
      ** File Declarations
      *
     F***LBACCNL1  IF   E           K DISK    INFSR(*PSSR)                                AR1097467B
      ***Retail*Accounts*file*by*CNUM**********************************                   AR1097467B

     FSTOPB     IF   E           K DISK    INFSR(*PSSR)
      ** Stopped Checques by Branch

     F***IBPAIB    O    E             DISK    INFSR(*PSSR)                                AR1097467B
      ***Inactive*Blocked*Past*Due*Accounts****************************                   AR1097467B

     FIBPAIZZ   O    E             DISK    RENAME(RTZZF : IBPATRL)
     F                                     PREFIX('IBPA')
     F                                     INFSR(*PSSR)
      ** RTZZ trailer file member IBPA

     F***RETACRE   O    E             DISK    INFSR(*PSSR)                                AR1097467B
      ***Retail*Account*Balances***************************************                   AR1097467B

     FRETACZZ   O    E             DISK    RENAME(RTZZF : RETACTRL)
     F                                     PREFIX('RETAC')
     F                                     INFSR(*PSSR)
      ** RTZZ trailer file member RETAC
                                                                                            MD056972
     FACCNTAC   IF   E             DISK    INFSR(*PSSR) PREFIX(AC_)                         MD056972
     FACDETAA   O    E             DISK    RENAME(ACCNTAAF:ACDETAAF)                        MD056972
     F                                     PREFIX(AA_)                                      MD056972
     F                                     INFSR(*PSSR)                                     MD056972
     FACDETAC   O    E             DISK    RENAME(ACCNTACF:ACDETACF)                        MD056972
     F                                     PREFIX(AC_)                                      MD056972
     F                                     INFSR(*PSSR)                                     MD056972

     FGL000570AUO    E             PRINTER USROPN
      ** GL Accounts Detail Extract - Audit

      /EJECT
      *
      ** DS/Variable/Constant Declarations
      *
     D PgmName         C                   CONST('GL000570')
     D True            C                   CONST(*ON)
     D False           C                   CONST(*OFF)
     D StopBNotEmpty   S               N   INZ(False)                                     AR1097467B
     D RptNameOffset   S              5U 0 INZ
     D*PSSRDone*       S              1N   INZ                                            AR1097467B
     D PSSRDone        S              1N   INZ(False)                                     AR1097467B
     D*PrevCNUM*       S                   INZ LIKE(CNUM)                                 AR1097467B
     D*WRetB****       S                   INZ LIKE(RETB)                                 AR1097467B
     D RecordCount     S                   INZ LIKE(RRECCOUNT)
     D RETACCount      S                   INZ LIKE(RRETACCTR)
     D IBPACount       S                   INZ LIKE(RIBPACTR)
     D ACDETCount      S                   INZ LIKE(RIBPACTR)                               MD056972
     D*ArrSz****       C                   CONST( 32000 )                        AR1097467B MD056972
     D ArrSz           C                   CONST( 24000 )                                   MD056972
     D ULimit          S              5P 0 INZ( ArrSz )                                   AR1097467B
     D RowCtr          S              5P 0 INZ                                            AR1097467B
     D InsIBPA         S              5P 0 INZ                                            AR1097467B
     D InsRETAC        S              5P 0 INZ                                            AR1097467B
     D InsACDET        S              5P 0 INZ                                              MD056972
     D POption         S              7A   INZ                                            AR1097467B
     D PRetCode        S              7A   INZ                                            AR1097467B
     D CGL013          S              1A                                                    MD056972
     D P@RTCD          S              7A                                        Return code MD056972
     D P@OPTN          S              7A                                        Option      MD056972
     D P@SARD          S              6                                         Sar         MD056972
      ** Bit constants for testing bits of RETB

     D Bit2            C                   X'20'
     D Bit3            C                   X'10'
     D Bit4            C                   X'08'
     D Bit6            C                   X'02'
     D Bit7            C                   X'01'

      ***File*Data*structure*for*LBACCNL1******************************                   AR1097467B
      *****************************************************************                   AR1097467B
     D*ACCNL1DS*     E DS                  EXTNAME(LBACCNL1)                              AR1097467B
     D**RECIAC**     E                     EXTFLD(RECI)                                   AR1097467B
     D WRetB           DS                  INZ QUALIFIED                                  AR1097467B
     D  In                                 LIKE( ACC_RETB )                               AR1097467B
     D  Out                                LIKE( ACC_RETB )                               AR1097467B
                                                                                          AR1097467B
     D ACCTFMT       E DS                  EXTNAME( ACCNTAB )                             AR1097467B
     D                                     PREFIX( 'ACC_' )                               AR1097467B
                                                                                          AR1097467B
     D ACCT            DS                  INZ QUALIFIED                                  AR1097467B
     D                                     DIM( ArrSz )                                   AR1097467B
     D  ACCRECI                            LIKE( ACC_RECI )                               AR1097467B
     D  BRCA                               LIKE( ACC_BRCA )                               AR1097467B
     D  ATYP                               LIKE( ACC_ATYP )                               AR1097467B
     D  STYP                               LIKE( ACC_STYP )                               AR1097467B
     D  CNUM                               LIKE( ACC_CNUM )                               AR1097467B
     D  CCY                                LIKE( ACC_CCY  )                               AR1097467B
     D  ACODQQ                             LIKE( ACC_ACODQQ )                             AR1097467B
     D  ACSQ                               LIKE( ACC_ACSQ )                               AR1097467B
     D  ACNO                               LIKE( ACC_ACNO )                               AR1097467B
     D  EFAC                               LIKE( ACC_EFAC )                               AR1097467B
     D  RETB                               LIKE( ACC_RETB )                               AR1097467B
     D  LRCR                               LIKE( ACC_LRCR )                               AR1097467B
     D  LDBL                               LIKE( ACC_LDBL )                               AR1097467B
     D  CLBL                               LIKE( ACC_CLBL )                               AR1097467B
     D  LACD                               LIKE( ACC_LACD )                               AR1097467B
     D  HELD                               LIKE( ACC_HELD )                               AR1097467B
     D  MINB                               LIKE( ACC_MINB )                               AR1097467B
     D  ODLN                               LIKE( ACC_ODLN )                               AR1097467B
     D  ODED                               LIKE( ACC_ODED )                               AR1097467B
     D  DLIM                               LIKE( ACC_DLIM )                               AR1097467B
     D  EPLB                               LIKE( ACC_EPLB )                               AR1097467B
     D  EPCB                               LIKE( ACC_EPCB )                               AR1097467B
     D  RTLB                               LIKE( ACC_RTLB )                               AR1097467B
     D  RTCB                               LIKE( ACC_RTCB )                               AR1097467B
     D  STFQ                               LIKE( ACC_STFQ )                               AR1097467B
     D  DACO                               LIKE( ACC_DACO )                               AR1097467B
     D  ACOD                               LIKE( ACC_ACOD )                               AR1097467B
     D  ACST                               LIKE( ACC_ACST )                                 MD056972
     D  ORED                               LIKE( ACC_ORED )                                 MD056972
     D  LCD                                LIKE( ACC_LCD  )                                 MD056972
     D  CHTP                               LIKE( ACC_CHTP )                                 MD056972
     D  BBCUST                             LIKE( CUS_BBCUST )                             AR1097467B
     D  BBCASC                             LIKE( CUS_BBCASC )                             AR1097467B
     D  BBCRNM                             LIKE( CUS_BBCRNM )                             AR1097467B
     D  BBACOC                             LIKE( CUS_BBACOC )                             AR1097467B
     D  BBCLST                             LIKE( CUS_BBCLST )                             AR1097467B
     D  BBDTDL                             LIKE( CUS_BBDTDL )                             AR1097467B

      ** File Data structure for IBPAIB
      ***Rename*fields*to*be*the*same*as*SDCUSTPD/ACCNL1***************                   AR1097467B
      ** Rename fields to be the same as ACCT                                             AR1097467B

     D*IBPAIBDS*     E DS                  EXTNAME(IBPAIB:*OUTPUT)                        AR1097467B
     D**********                           QUALIFIED INZ                                  AR1097467B
     D IBPAIBDS      E DS                  EXTNAME( IBPAIB ) INZ                          AR1097467B
     D                                     QUALIFIED DIM( ArrSz )                         AR1097467B
     D  IBRECI       E                     EXTFLD(RECI) INZ('D')
     D  BBCRNM       E                     EXTFLD(CRNM)
     D  BBACOC       E                     EXTFLD(ACOC)
     D  LDBL         E                     EXTFLD(GRBL)
     D  CLBL         E                     EXTFLD(NETB)

      ** File Data structure for RETACRE
      ***Rename*fields*to*be*the*same*as*SDCUSTPD/ACCNL1***************                   AR1097467B
      ** Rename fields to be the same as ACCT                                             AR1097467B

     D*RETACREDS     E DS                  EXTNAME(RETACRE:*OUTPUT)                       AR1097467B
     D**********                           QUALIFIED INZ                                  AR1097467B
     D RETACREDS     E DS                  EXTNAME(RETACRE) INZ                           AR1097467B
     D                                     QUALIFIED DIM( ArrSz )                         AR1097467B
     D  RETRECI      E                     EXTFLD(RECI) INZ('D')
     D  BBCASC       E                     EXTFLD(CASK)
     D  BBCRNM       E                     EXTFLD(CRNM)
     D  BBACOC       E                     EXTFLD(ACOC)
     D  EPLB         E                     EXTFLD(EPGB)
     D  EPCB         E                     EXTFLD(EPNB)
                                                                                            MD056972
      ** File Data structures for ACDET                                                     MD056972
     D ACDETABDS     E DS                  EXTNAME(ACDETAB) INZ                             MD056972
     D                                     QUALIFIED DIM( ArrSz )                           MD056972
     D ACDET_AA      E DS                  EXTNAME(ACDETAA) Prefix(AA_)                     MD056972
     D ACDET_AC      E DS                  EXTNAME(ACDETAC) Prefix(AC_)                     MD056972

     D AccountStatus   DS
      ** Data structure for Retail Account Status
     D  BlockedDebit                  1N   INZ(False)
     D  BlockedCredit                 1N   INZ(False)
     D  InactiveAcct                  1N   INZ(False)
     D  Bankrupt                      1N   INZ(False)
     D  BadDebt                       1N   INZ(False)

     D SDCUSTDS      E DS                  INZ EXTNAME(SDCUSTPD)
     D                                     PREFIX( 'CUS_')                                AR1097467B
      ** Data structure for Customer Details

     D SDBANKDS      E DS                  INZ EXTNAME(SDBANKPD)
      ** Data structure for Bank Details

     D LDA           E DS                  INZ EXTNAME(LDA)
      ** Data Area Data structure for LDA
     D                                     DTAARA('LDA')
     D                                     QUALIFIED

     D PSSRDS          DS                  INZ LIKEDS(LDA)
      ** Data structure for PSSR error logging

     D DSFDY         E DS                  INZ EXTNAME(DSFDY)
      ** Short Dummy Data Structure for Access Object programs

     D DSLDY         E DS                  INZ EXTNAME(DSLDY)
      ** Long Dummy Data Structure for Access Object programs

     D*AOPgmParm       DS                  INZ                                            AR1097467B
      ***Access*Object*program*parameters******************************                   AR1097467B
     D**PRetCode                      7A                                                  AR1097467B
     D**POption*                      7A                                                  AR1097467B
     D**PKey****                     10A                                                  AR1097467B
     D**PKeyStatus                    7A                                                  AR1097467B
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SS)                     MD056972
      **  Data Structure for Switchable features descriptions.                              MD056972

      ** Name *IN indicators

     D IndicatorPtr    S               *   INZ(%ADDR(*IN))
     D Indicator       DS                  BASED(IndicatorPtr)
     D  PrtRecCount           41     41
     D  PrtIBPACount          42     42
     D  PrtAXFICount          43     43
     D  PrtRETACCount         44     44
     D  PrtACDETCount         45     45                                                     MD056972

     I***ACCNTABF                                                                         AR1097467B
     I**********    RECI                        RECIAC                                    AR1097467B

D     /EJECT
      ****************************************************************
      *                                                              *
      *                    MAIN PROCESSING                           *
      *                                                              *
      ****************************************************************

     C**********         READ      LBACCNL1                                               AR1097467B
     C**********         DOW       NOT %EOF(LBACCNL1) AND NOT *INU7                       AR1097467B
     C/EXEC SQL                                                                           AR1097467B
     C+ open ACCTCursor                                                                   AR1097467B
     C/END-EXEC                                                                           AR1097467B
                                                                                          AR1097467B
     C/EXEC SQL                                                                           AR1097467B
     C+ fetch next from ACCTCursor                                                        AR1097467B
     C+ for :ULimit rows                                                                  AR1097467B
     C+ into :ACCT                                                                        AR1097467B
     C/END-EXEC                                                                           AR1097467B
                                                                                          AR1097467B
      ** Begin process when SQL codes are non-errors and rows > 0                         AR1097467B
      ** and no encountered DBASE errors                                                  AR1097467B
                                                                                          AR1097467B
     C                   DOW       (SQLCODE = 0 OR SQLCODE = 100)                         AR1097467B
     C                             AND SQLERRD(3) > 0 AND NOT *INU7                       AR1097467B
                                                                                          AR1097467B
      ** Reinitialize number of records to be inserted                                    AR1097467B
                                                                                          AR1097467B
     C                   EVAL      InsIBPA = 0                                            AR1097467B
     C                   EVAL      InsRETAC = 0                                           AR1097467B
     C                   EVAL      InsACDET = 0                                             MD056972
                                                                                          AR1097467B
     C                   FOR       RowCtr = 1 to SQLERRD(3) by 1                          AR1097467B

      ** Process live retail accounts only

     C**********         IF        RECIAC = 'D'                                           AR1097467B
     C                   IF        ACCT( RowCtr ).ACCRECI = 'D'                           AR1097467B
     C                             AND ACCT( RowCtr ).ATYP = 'R'                            MD056972
     C                   EXSR      CHKACTSTAT
     C                   EXSR      GETCUSTDTL
     C                   EXSR      OUTTOFILE
     C                   ENDIF
                                                                                            MD056972
      * Process accounts changed today                                                      MD056972
                                                                                            MD056972
     C                   IF        ACCT( RowCtr ).LCD = BJRDNB                              MD056972
     C                   EVAL      InsACDET = InsACDET + 1                                  MD056972
     C                   EVAL-CORR ACDETABDS( InsACDET ) = ACCT( RowCtr )                   MD056972
     C                   EVAL      ACDETABDS( InsACDET ).RECI =                             MD056972
     C                             ACCT( RowCtr ).ACCRECI                                   MD056972
     C                   EVAL      ACDETCount = ACDETCount + 1                              MD056972
     C                   ENDIF                                                              MD056972

     C                   EVAL      RecordCount = RecordCount + 1
     C**********         READ      LBACCNL1                                               AR1097467B
     C                   ENDFOR                                                           AR1097467B
                                                                                          AR1097467B
      ** Output to files when there are records to be inserted                            AR1097467B
                                                                                          AR1097467B
     C                   IF        InsRETAC > 0                                           AR1097467B
     C/EXEC SQL                                                                           AR1097467B
     C+ insert into RETACRE                                                               AR1097467B
     C+ :InsRETAC rows                                                                    AR1097467B
     C+ values(:RETACREDS)                                                                AR1097467B
     C+ with nc                                                                           AR1097467B
     C/END-EXEC                                                                           AR1097467B
                                                                                          AR1097467B
     C                   IF        SQLCODE <> 0                                           AR1097467B
     C                   EVAL      PSSRDS.DBFile = 'RETACRE'                              AR1097467B
     C                   EVAL      PSSRDS.DBKey = '*MULTI'                                AR1097467B
     C                   EVAL      PSSRDS.DBProc = 'SQLINS'                               AR1097467B
     C                   EVAL      PSSRDS.DBase = 4                                       AR1097467B
     C                   EXSR      *PSSR                                                  AR1097467B
     C                   ENDIF                                                            AR1097467B
     C                   ENDIF                                                            AR1097467B
                                                                                          AR1097467B
     C                   IF        InsIBPA > 0                                            AR1097467B
     C/EXEC SQL                                                                           AR1097467B
     C+ insert into IBPAIB                                                                AR1097467B
     C+ :InsIBPA rows                                                                     AR1097467B
     C+ values(:IBPAIBDS)                                                                 AR1097467B
     C+ with nc                                                                           AR1097467B
     C/END-EXEC                                                                           AR1097467B
                                                                                          AR1097467B
     C                   IF        SQLCODE <> 0                                           AR1097467B
     C                   EVAL      PSSRDS.DBFile = 'IBPAIB'                               AR1097467B
     C                   EVAL      PSSRDS.DBKey = '*MULTI'                                AR1097467B
     C                   EVAL      PSSRDS.DBProc = 'SQLINS'                               AR1097467B
     C                   EVAL      PSSRDS.DBase = 5                                       AR1097467B
     C                   EXSR      *PSSR                                                  AR1097467B
     C                   ENDIF                                                            AR1097467B
     C                   ENDIF                                                            AR1097467B
                                                                                            MD056972
     C                   IF        InsACDET > 0                                             MD056972
     C                             AND CGL013 = 'N'                                         MD056972
     C/EXEC SQL                                                                             MD056972
     C+ insert into ACDETAB                                                                 MD056972
     C+ :InsACDET rows                                                                      MD056972
     C+ values(:ACDETABDS)                                                                  MD056972
     C+ with nc                                                                             MD056972
     C/END-EXEC                                                                             MD056972
                                                                                            MD056972
     C                   IF        SQLCODE <> 0                                             MD056972
     C                   EVAL      PSSRDS.DBFile = 'ACDETAB'                                MD056972
     C                   EVAL      PSSRDS.DBKey = '*MULTI'                                  MD056972
     C                   EVAL      PSSRDS.DBProc = 'SQLINS'                                 MD056972
     C                   EVAL      PSSRDS.DBase = 6                                         MD056972
     C                   EXSR      *PSSR                                                    MD056972
     C                   ENDIF                                                              MD056972
     C                   ENDIF                                                              MD056972
                                                                                          AR1097467B
     C/EXEC SQL                                                                           AR1097467B
     C+ fetch next from ACCTCursor                                                        AR1097467B
     C+ for :ULimit rows                                                                  AR1097467B
     C+ into :ACCT                                                                        AR1097467B
     C/END-EXEC                                                                           AR1097467B
                                                                                          AR1097467B
     C                   ENDDO
                                                                                          AR1097467B
     C/EXEC SQL                                                                           AR1097467B
     C+ close ACCTCursor                                                                  AR1097467B
     C/END-EXEC                                                                           AR1097467B

      ** Write trailer file for IBPA and RETAC
      ** Add 2 for header and trailer

     C                   EVAL      IBPARECI = 'T'
     C                   EVAL      IBPACount = IBPACount + 2
     C                   MOVE      IBPACount     IBPANORE
     C                   WRITE     IBPATRL

     C                   EVAL      RETACRECI = 'T'
     C                   EVAL      RETACCount = RETACCount + 2
     C                   MOVE      RETACCount    RETACNORE
     C                   WRITE     RETACTRL
                                                                                            MD056972
      * Write ACDET header and trailer                                                      MD056972
                                                                                            MD056972
     C                   IF        CGL013 = 'N'                                             MD056972
     C                   CLEAR                   ACDET_AA                                   MD056972
     C                   EVAL      AA_RECI = 'H'                                            MD056972
     C                   WRITE     ACDETAAF                                                 MD056972
                                                                                            MD056972
     C                   READ      ACCNTAC                                                  MD056972
     C**********         EVAL      AC_NORE = ACDETCount+ 2                         MD056972 MD059762
     C     ACDETCount    ADD       2             AC_NORE                                    MD059762
     C                   WRITE     ACDETACF                                                 MD056972
     C                   ENDIF                                                              MD056972

      ** Print audit report GL000570AU

     C                   OPEN      GL000570AU
     C                   WRITE     HEADAU

      ** Setup fields for GL000570AU/CONTROL details

     C                   EVAL      RRECCOUNT = RecordCount
     C                   EVAL      RIBPACTR = IBPACount
     C                   EVAL      RRETACCTR = RETACCount
     C                   EVAL      RACDETLS = ACDETCount                                    MD056972

     C                   WRITE     CONTROL

      ** Print DBERROR in audit report for errors

     C                   IF        *INU7
     C                   EVAL      RDBASE = PSSRDS.DBase
     C                   EVAL      RDBFILE = PSSRDS.DBFile
     C                   EVAL      RDBKEY = PSSRDS.DBKey
     C                   WRITE     DBERROR
     C                   ENDIF

     C                   CLOSE     GL000570AU
     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine for initial program processing    *
      * Called by: At first program startup                           *
      * Calls : AOBANKR0                                              *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Key list for access on STOPB file

     C     STOPBKEY      KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        PRetCode
     C                   PARM      '*FIRST'      POption
     C     SDBANKDS      PARM      SDBANKDS      DSFDY

     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      PSSRDS.DBFile = 'SDBANKPD'
     C                   EVAL      PSSRDS.DBKey = POption
     C                   EVAL      PSSRDS.DBProc = POption
     C                   EVAL      PSSRDS.DBase = 1
     C                   EXSR      *PSSR
     C                   ENDIF

                                                                                            MD056972
      ** Check if feature CGL013 (Cash Management feature) is installed                     MD056972
                                                                                            MD056972
     C                   EVAL      CGL013 = 'N'                                             MD056972
     C                   EVAL      *IN13 = *OFF                                             MD056972
                                                                                            MD056972
     C                   CALL      'AOSARDR0'                                               MD056972
     C                   PARM      *BLANKS       P@RTCD                         Return Code MD056972
     C                   PARM      '*VERIFY'     P@OPTN                         Option      MD056972
     C                   PARM      'CGL013 '     P@SARD                         Feature Ref.MD056972
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD056972
                                                                                            MD056972
     C                   IF        P@RTCD = *BLANKS                                         MD056972
     C                   EVAL      CGL013 = 'Y'                                             MD056972
     C                   EVAL      *IN13 = *ON                                              MD056972
     C                   ENDIF                                                              MD056972
      ** Set DBPGM to be equal to program name

     C                   EVAL      PSSRDS.DBPGM = PgmName

      ** Setup Report Header fields

     C                   EVAL      RREFNAME = PgmName
     C                   EVAL      RMRDT = BJMRDT

      ** Set-up and center Report Name

     C                   EVAL      RptNameOffset = (%LEN(RURPT) -
     C                               %LEN(%TRIM(BJURPT)))/2 + 1
     C                   EVAL      %SUBST(RURPT : RptNameOffset) =
     C                                BJURPT

      ** Setup which record counts are to be printed

     C                   EVAL      PrtRecCount = True
     C                   EVAL      PrtIBPACount = True
     C                   EVAL      PrtRETACCount = True
     C                   EVAL      PrtAXFICount = False
     C                   EVAL      PrtACDETCount = True                                     MD056972

     C     *LOVAL        SETLL     STOPB                                                  AR1097467B
     C                   READ      STOPB                                                  AR1097467B
     C                   IF        NOT %EOF( STOPB )                                      AR1097467B
     C                   EVAL      StopBNotEmpty = True                                   AR1097467B
     C                   ENDIF                                                            AR1097467B
                                                                                          AR1097467B
      ** Retrieve only needed fields from ACCNTAB and SDCUSTPD                            AR1097467B
                                                                                          AR1097467B
     C/EXEC SQL                                                                           AR1097467B
     C+ declare ACCTCursor cursor for                                                     AR1097467B
     C+  select                                                                           AR1097467B
     C+         ACCT.RECI                                                                 AR1097467B
     C+        ,ACCT.BRCA                                                                 AR1097467B
     C+        ,ACCT.ATYP                                                                 AR1097467B
     C+        ,ACCT.STYP                                                                 AR1097467B
     C+        ,ACCT.CNUM                                                                 AR1097467B
     C+        ,ACCT.CCY                                                                  AR1097467B
     C+        ,ACCT.ACODQQ                                                               AR1097467B
     C+        ,ACCT.ACSQ                                                                 AR1097467B
     C+        ,ACCT.ACNO                                                                 AR1097467B
     C+        ,ACCT.EFAC                                                                 AR1097467B
     C+        ,ACCT.RETB                                                                 AR1097467B
     C+        ,ACCT.LRCR                                                                 AR1097467B
     C+        ,ACCT.LDBL                                                                 AR1097467B
     C+        ,ACCT.CLBL                                                                 AR1097467B
     C+        ,ACCT.LACD                                                                 AR1097467B
     C+        ,ACCT.HELD                                                                 AR1097467B
     C+        ,ACCT.MINB                                                                 AR1097467B
     C+        ,ACCT.ODLN                                                                 AR1097467B
     C+        ,ACCT.ODED                                                                 AR1097467B
     C+        ,ACCT.DLIM                                                                 AR1097467B
     C+        ,ACCT.EPLB                                                                 AR1097467B
     C+        ,ACCT.EPCB                                                                 AR1097467B
     C+        ,ACCT.RTLB                                                                 AR1097467B
     C+        ,ACCT.RTCB                                                                 AR1097467B
     C+        ,ACCT.STFQ                                                                 AR1097467B
     C+        ,ACCT.DACO                                                                 AR1097467B
     C+        ,ACCT.ACOD                                                                 AR1097467B
     C+        ,ACCT.ACST                                                                   MD056972
     C+        ,ACCT.ORED                                                                   MD056972
     C+        ,ACCT.LCD                                                                    MD056972
     C+        ,ACCT.CHTP                                                                   MD056972
     C+        ,CUST.BBCUST                                                               AR1097467B
     C+        ,CUST.BBCASC                                                               AR1097467B
     C+        ,CUST.BBCRNM                                                               AR1097467B
     C+        ,CUST.BBACOC                                                               AR1097467B
     C+        ,CUST.BBCLST                                                               AR1097467B
     C+        ,CUST.BBDTDL                                                               AR1097467B
     C+  from ACCNTAB as ACCT                                                             AR1097467B
     C+    left join SDCUSTPD as CUST                                                     AR1097467B
     C+    on ACCT.CNUM = CUST.BBCUST                                                     AR1097467B
     C+  where ATYP = 'R'                                                                 AR1097467B
     C+  or LCD =:BJRDNB                                                                    MD056972
     C+  order by ACCT.CNUM, ACCT.CCY, ACCT.ACOD, ACCT.ACSQ                                 MD056972
     C+  for read only                                                                    AR1097467B
     C***optimize for 32000 rows                                                 AR1097467B MD056972
     C+  optimize for 24000 rows                                                            MD056972
     C/END-EXEC                                                                           AR1097467B
                                                                                          AR1097467B
     C                   ENDSR

      *****************************************************************
      *                                                               *
      * CHKACTSTAT - Check account status of customer                 *
      * Called by: Main Processing                                    *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************

     C     CHKACTSTAT    BEGSR

      ** Check for inactive/blocked - IBPA
      ** Test the bits, if on, set corresponding account status                           AR1097467B

     C                   RESET                   AccountStatus
                                                                                          AR1097467B
     C                   EVAL      WRetB.In = ACCT( RowCtr ).RETB                         AR1097467B

     C                   SELECT
     C**********         WHEN      %BITAND(RETB:BIT2) = BIT2                              AR1097467B
     C                   WHEN      %BITAND( WRetB.In : BIT2 ) = BIT2                      AR1097467B
     C                   EVAL      BlockedDebit = True

     C**********         WHEN      %BITAND(RETB:BIT3) = BIT3                              AR1097467B
     C                   WHEN      %BITAND( WRetB.In : BIT3 ) = BIT3                      AR1097467B
     C                   EVAL      BlockedCredit = True

     C**********         WHEN      %BITAND(RETB:BIT4) = BIT4                              AR1097467B
     C                   WHEN      %BITAND( WRetB.In : BIT4 ) = BIT4                      AR1097467B
     C                   EVAL      InactiveAcct = True

     C**********         WHEN      %BITAND(RETB:BIT6) = BIT6                              AR1097467B
     C                   WHEN      %BITAND( WRetB.In : BIT6 ) = BIT6                      AR1097467B
     C                   EVAL      Bankrupt = True

     C**********         WHEN      %BITAND(RETB:BIT7) = BIT7                              AR1097467B
     C                   WHEN      %BITAND( WRetB.In : BIT7 ) = BIT7                      AR1097467B
     C                   EVAL      BadDebt = True
     C                   ENDSL

      ** Check if any stopped checques for this customer.
      ***Ensure*that*bit*7*in*WRetB*is*set*off*first,*it*is*used*for***                   AR1097467B
      ** Ensure that bit 7 in WRetB.Out is set off first, it is used for                  AR1097467B
      ** Bad Debts indicator in RETB.

     C**********         EVAL      WRetB = RETB                                           AR1097467B
     C**********         EVAL      WRetB = %BITAND(WRetB:%BITNOT(Bit7))                   AR1097467B
     C                   EVAL      WRetB.Out = WretB.In                                   AR1097467B
     C                   EVAL      WRetB.Out = %BITAND( WRetB.Out                         AR1097467B
     C                                                : %BITNOT( BIT7 )                   AR1097467B
     C                                                )                                   AR1097467B

      ** If same account reference found on STOPB, set on bit 7
                                                                                          AR1097467B
     C                   IF        StopBNotEmpty                                          AR1097467B
                                                                                          AR1097467B
     C                   EVAL      BRCA = ACCT( RowCtr ).BRCA                             AR1097467B
     C                   EVAL      CNUM = ACCT( RowCtr ).CNUM                             AR1097467B
     C                   EVAL      CCY  = ACCT( RowCtr ).CCY                              AR1097467B
     C                   EVAL      ACOD = ACCT( RowCtr ).ACOD                             AR1097467B
     C                   EVAL      ACSQ = ACCT( RowCtr ).ACSQ                             AR1097467B

     C     STOPBKEY      SETLL     STOPB
     C     STOPBKEY      READE     STOPB
     C                   DOW       NOT %EOF(STOPB)
                                                                                          AR1097467B
     C                   IF        %FOUND(STOPB) AND RECI = 'D'
     C**********         EVAL      WRetB = %BITOR(WRetB:Bit7)                             AR1097467B
     C                   EVAL      WRetB.Out = %BITOR( WRetB.Out                          AR1097467B
     C                                               : Bit7 )                             AR1097467B
     C                   LEAVE
     C                   ENDIF
                                                                                          AR1097467B
     C     STOPBKEY      READE     STOPB
     C                   ENDDO
                                                                                          AR1097467B
     C                   ENDIF                                                            AR1097467B

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * GETCUSTDTL - Get customer details, flag *INU7 on errors       *
      * Called by: Main Processing                                    *
      **Calls*:*AOCUSTR1,*PSSR*****************************************                   AR1097467B
      * Calls : PSSR                                                  *                   AR1097467B
      *                                                               *
      *****************************************************************

     C     GETCUSTDTL    BEGSR

      ***Obtain*Retail*Customer*details*on*CNUM*change*****************                   AR1097467B
      *****************************************************************                   AR1097467B
     C**********         IF        CNUM <> PrevCNUM                                       AR1097467B
     C**********         CALL      'AOCUSTR1'                                             AR1097467B
     C**********         PARM      '*MSG'        PRetCode                                 AR1097467B
     C**********         PARM      '*KEY'        POption                                  AR1097467B
     C**********         PARM      CNUM          PKey                                     AR1097467B
     C**********         PARM                    PKeyStatus                               AR1097467B
     C*****SDCUSTDS      PARM      SDCUSTDS      DSLDY                                    AR1097467B
     C**********         EVAL      PrevCNUM = CNUM                             AR1097467A AR1097467B
     C**********         ENDIF                                                            AR1097467B

      ** DBASE error if live customer does not exist for a live a/c

     C**********         IF        RECI = 'D' AND (                                       AR1097467B
     C**********                   PKeyStatus <> '*CNUM' OR                               AR1097467B
     C**********                   PRetCode <> *BLANK AND                                 AR1097467B
     C**********                   BBCLST <> 'Y' OR BBDTDL <>  0)                         AR1097467B
     C                   IF        ACCT( RowCtr ).ACCRECI = 'D' AND                       AR1097467B
     C                             (ACCT( RowCtr ).BBCUST = *BLANKS OR                    AR1097467B
     C                              ACCT( RowCtr ).BBCUST <> *BLANKS AND                  AR1097467B
     C                              (ACCT( RowCtr ).BBCLST = 'Y' OR                       AR1097467B
     C                               ACCT( RowCtr ).BBDTDL <>  0 ))                       AR1097467B
     C                   EVAL      PSSRDS.DBase = 2
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INLR = *ON
     C                   END
     C

      ** DBASE error if no customer exists for a closed account

     C**********         IF        RECI = 'C' AND NOT *INU7 AND (                         AR1097467B
     C**********                   PKeyStatus <> '*CNUM' OR                               AR1097467B
     C**********                   PRetCode <> *BLANK)                                    AR1097467B
     C                   IF        ACCT( RowCtr ).ACCRECI = 'C' AND                       AR1097467B
     C                             ACCT( RowCtr ).BBCUST = *BLANKS AND                    AR1097467B
     C                             NOT *INU7                                              AR1097467B
     C                   EVAL      PSSRDS.DBase = 3
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF

      ** Exit loop if DBASE error

     C                   IF        *INU7
     C                   EVAL      PSSRDS.DBFile = 'SDCUSTPD'
     C**********         EVAL      PSSRDS.DBKey = CNUM                                    AR1097467B
     C**********         EVAL      PSSRDS.DBProc = POption                                AR1097467B
     C                   EVAL      PSSRDS.DBKey = ACCT( RowCtr).CNUM                      AR1097467B
     C                   EVAL      PSSRDS.DBProc = '*KEY'                                 AR1097467B
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * OUTTOFILE - Output record counts to file                      *
      * Called by: Main Processing                                    *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************

     C     OUTTOFILE     BEGSR

      ***Write*to*Retail*Accounts**************************************                   AR1097467B
      ***If*any*account*statuses*on,*write*to*IBPA*********************                   AR1097467B
      ** Populate RETAC with corresponding fields from ACCT                               AR1097467B
      ** If any account statuses on, populate IBPA                                        AR1097467B
      ** Increment record counters

     C**********         EVAL-CORR RETACREDS = ACCNL1DS                                   AR1097467B
     C**********         EVAL-CORR RETACREDS = SDCUSTDS                                   AR1097467B
     C**********         EVAL      RETACREDS.RETB = WRetB                                 AR1097467B
     C**********         WRITE     RETACREF      RETACREDS                                AR1097467B
     C                   EVAL      InsRETAC = InsRETAC + 1                                AR1097467B
     C                   EVAL-CORR RETACREDS( InsRETAC ) = ACCT( RowCtr )                 AR1097467B
     C                   EVAL      RETACREDS( InsRETAC ).RETB = WRetB.Out                 AR1097467B
     C                   EVAL      RETACCount = RETACCount + 1

     C                   IF        BlockedDebit OR BlockedCredit OR
     C                             InactiveAcct OR Bankrupt OR BadDebt
     C**********         EVAL-CORR IBPAIBDS = ACCNL1DS                                    AR1097467B
     C**********         EVAL-CORR IBPAIBDS = SDCUSTDS                                    AR1097467B
     C**********         WRITE     IBPAIBF       IBPAIBDS                                 AR1097467B
     C                   EVAL      InsIBPA = InsIBPA + 1                                  AR1097467B
     C                   EVAL-CORR IBPAIBDS( InsIBPA ) = ACCT( RowCtr )                   AR1097467B
     C                   EVAL      IBPACount = IBPACount + 1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR - Subroutine to handle and report program errors        *
      * Called by: Program exception errors or EXSR                   *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR
     C                   IF        NOT PSSRDone
     C                   EVAL      PSSRDone = True                                        AR1097467B
     C     *LOCK         IN        LDA
     C                   EVAL-CORR LDA = PSSRDS
     C                   OUT       LDA
     C                   DUMP
     C**********         EVAL      PSSRDone = True                                        AR1097467B
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
