     H DEBUG
     H DFTACTGRP(*NO)
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE PDP New Available Balance Computation')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000495 - Midas LE PDP Available Balance Computation        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD039450           Date 04Aug16               *
      *                 MD031723 *REWRITE  Date 09Jan15               *
      *                 CLE164 *CREATE     Date 18Aug14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039450 - Improve COB component LEC000495 performance       *
      *             Added 1 column to prevent SQL0030                 *
      *  MD031723 - LEC000495 Failed during COB due to conflict       *
      *             on the lenght of field AKEY on file LEKP1DPD      *
      *             and LEPK2DPD                                      *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *                                                               *
      *****************************************************************

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Program Prototypes                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D Main            pr                  extpgm('LE000495')
     D  ArraySize                     8s 0 const options(*nopass)
     D Main            pi
     D  ArraySize                     8s 0 const options(*nopass)

     D  bSearch        pr              *   extproc('bsearch')
     D    searchFor                    *   value
     D    dataStart                    *   value
     D    elemCount                  10u 0 value
     D    elemSize                   10u 0 value
     D    compareFunc                  *   ProcPtr value

     D  qSort          pr                  extproc('qsort')
     D    dataStart                    *   value
     D    elemCount                  10u 0 value
     D    elemSize                   10u 0 value
     D    compareFunc                  *   procptr value

     D  SortFunc       pr            10i 0
     D   Candidate1                        likeds(CombineFile)
     D   Candidate2                        likeds(CombineFile)

     D  searchForName  pr            10i 0
     D   searchName                  24a
     D   Candidate                         likeds(SortedDS)

     D  pSeqProcedure  S               *   procptr
     D                                     inz(%Paddr(SortFunc))

     D  pSearchForNam  S               *   procptr
     D                                     inz(%Paddr(SearchForName))

     D  getOrder       pr             6a
     D    SortOder                    1a

     D  GetBalance     pr                  extpgm('LE000476')
     D    pReturnCd                   1a
     D    pCustCode                   6a
     D    pCurrency                   3a
     D    pAcctCode                  10s 0
     D    pAcctSeqn                   2s 0
     D    pBranchCd                   3a
     D    pRetailAc                  10s 0
     D    pClrAdjBal                 15p 0
     D    pClearBal                  15p 0
     D    pAvailBal                  15p 0
     D    pHeldItem                  15p 0
     D    pOverDrLn                  15p 0
     D    pCollateral                15p 0
     D    pBlockDebit                 1a
     D    pCAP205                     1a
     D    pABCFlag                    1a

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D SDSTAT        e ds                  extname(SDSTAT) dtaara(SDSTAT)
     D RepaymentKey  e ds                  extname(SDRPKYTD)
     D ExtractFile   e ds                  extname(LETMPLTD)
     D   RECNO                        8s 0
     D LatestBalance e ds                  extname(LETMPLTD)
     D                                     prefix(A_)
     D AvailableBal  e ds                  extname(LETMPLTD)
     D                                     prefix(B_)
     D   B_RECNO                      8s 0                                                  MD039450
     D CombineFile   e ds                  extname(LETMPLTD)
     D                                     prefix(C_)
     D TransactDS      ds                  likeds(CombineFile)
     D                                     dim(1000)
     D SortedDS        ds                  likeds(CombineFile)
     D                                     dim(1000)
     D Result          ds                  likeds(CombineFile)
     D                                     based(pResult)
     D CustomerDS      ds                  likeds(ExtractFile)
     D                                     dim(1000)
     D CustSaveDS      ds                  likeds(CombineFile)
     D                                     dim(1000)

      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+
     D EQUAL           c                   const(0)
     D HIGH            c                   const(1)
     D IGNORE_ERROR    c                   const(30)
     D LOW             c                   const(-1)
     D MAX_TABLE       c                   const(7)
     D MAX_EXTR        c                   const(3)
     D MAX_COLS        c                   const(34)
     D NOT_EXIST       c                   const(-204)
     D NO_ERROR        c                   const(0)
     D NO_RECORD       c                   const(100)
     D NOT_ALL_GRANT   c                   const(570)
     D NOT_FOUND       c                   const(-204)
     D QUO             c                   const('''')
     D START           c                   const(1)
     D TABLE_CREATED   c                   const(7905)
     D TABLE_IS_OPEN   c                   const(-501)

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
      ** Array counters
     D i               s             10s 0
     D j               s             10s 0
     D wIndex          s              2s 0 inz(0)
     D wIdxPrvBal      s              8s 0 inz(0)
     D SEARCH_START    s              8s 0 inz(0)

     D wReturnCd       s              1a
     D wClearBal       s             15p 0
     D wavailBal       s             15p 0
     D wOverDrLn       s             15p 0
     D wRetailAc       s             10s 0
     D wHeldItem       s             15p 0
     D CurBalance      s             15p 0
     D wCollateral     s             15p 0
     D wClrAdjBal      s             15p 0
     D wBlockDebit     s              1a
     D wCAP205         s              1a
     D wABCFlag        s              1a

     D sortSequence    s           2000a   inz(*blanks)
     D wSqlStr         s           2000a   inz(*blanks)
     D wNameStr        s           2000a   inz(*blanks)
     D wValueStr       s           2000a   inz(*blanks)
     D wStr1           s           2000a   inz(*blanks)
     D wSEFILE         s             10a   inz(*blanks)
     D wSEAAMT         s             10a   inz(*blanks)
     D wSEIPFL         s             10a   inz(*blanks)
     D wSQLTable       s             10a   inz(*blanks)

     D isFound         s               n
     D wLibrary        s             10a   inz(*blanks)
     D SearchArgument  s             24a   inz(*blanks)

     D wOverdraftAmt   s             15p 0 inz(*zeros)
     D wOverdraftBal   s             15p 0 inz(*zeros)
     D wAvailBalance   s             15p 0 inz(*zeros)
     D wBalance        s             15p 0 inz(*zeros)
     D wRowsReturned   s             10s 0 inz(*zeros)
     D MAX_ARRAY       s              8s 0 inz(30000)
     D  MessageID      S              7A   INZ(*BLANKS)
     D  CommandStr     S            200A   INZ(*BLANKS)

      ** +--------------------------------------+
      ** ¦ Array declaration                    ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D aColName        s             10a   dim(35)
     D aValName        s           2000a   dim(35)
     D aFilName        s             10a   dim(7)
     D aTblName        s             10a   dim(4)

      /free

       // ** +--- Start of Main processing -----------------------------------+
       // ** ¦                                                                ¦
       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
       // ** ¦ executed at program activation.                                ¦
       // ** ¦                                                                ¦
       // ** +----------------------------------------------------------------+

       // Set compile options for this program, Commit = *Chg is specified to
       // ensure that commit/rollback processing would be peformed

                   exec sql
                      set option
                         Naming    = *Sys,
                         Commit    = *Chg,
                         UsrPrf    = *Owner,
                         DynUsrPrf = *Owner,
                         Datfmt    = *iso,
                         CloSqlCsr = *EndMod;

       // Initialise array of extract files

                   aFilName(1) = 'LEPK1DPD';
                   aFilName(2) = 'LEPK2DPD';
                   aFilName(3) = 'LEPK3DPD';
                   aFilName(4) = 'LEACCTPD';
                   aFilName(5) = 'LEACCFPD';
                   aFilName(6) = 'LEREMRPD';
                   aFilName(7) = 'LELEGDPD';

       // If parameter to this program is passed, set maximum array
       // element to current parameter passed, otherwise default this
       // to 1000 elements

                   if %Parms() <> 0;
                      MAX_ARRAY = ArraySize;
                   else;
                      MAX_ARRAY = 1000;
                   endif;

                   exsr prepareAdjTable;

                   exsr clearExtractTables;

                   exsr resetIdentityColumn;

                   exsr determineRepaymentSequence;

       // Loop through all extract tables and combine them to a single one
       // called LETMPLTD

                   for i = START to MAX_TABLE;
                      exsr combineExtractTable;
                   endFor;

                   exsr processCustomerBalances;

                   exsr processAvailableBalance;

       // Loop through all extract tables and extract available
       // amount column from LEXTRCTD, this will be use to update
       // the individual extract tables, which is later referred
       // to by other PDP components such as LEC000131, LEC000138 and
       // LEC000456

                   for i = START to MAX_TABLE;
                      exsr distributeAvailableBalance;
                   endFor;

       // Ensure that an SQL COMMIT statement is executed so that
       // the changes will be commited to affected tables

                   exsr  commitTransaction;

                   *Inlr = *On;
                   return;
       //*************************************************************
       //                                                            *
       // prepareAdjTable - Prepare GLACPML0 table                   *
       // ===============                                            *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: srCommand                                           *
       //                                                            *
       //*************************************************************

       begsr prepareAdjTable;

                   CommandStr =  'CLRPFM FILE(GLACPMPD)';
                   exsr SrCommand;

                   CommandStr =  'CLRPFM FILE(GLACRMPD)';
                   exsr SrCommand;

                   CommandStr =  'CPYF FROMFILE(ACPO1) ' +
                                 ' TOFILE(GLACPMPD) ' +
                                 ' MBROPT(*REPLACE) ' +
                                 ' RCDFMT(APOSTPDF) ';
                   exsr SrCommand;

                   CommandStr =  'CPYF FROMFILE(GLACPOL0) ' +
                                 ' TOFILE(GLACPMPD) ' +
                                 ' MBROPT(*ADD) ' +
                                 ' RCDFMT(APOSTPDF) ';
                   exsr SrCommand;

                   CommandStr =  'CPYF FROMFILE(ACPO1) ' +
                                 ' TOFILE(GLACRMPD) ' +
                                 ' MBROPT(*ADD) ' +
                                 ' RCDFMT(APOSTRAF) ';
                   exsr SrCommand;

       endsr;

       //*************************************************************
       //                                                            *
       // clearExtractTables - This function will process all        *
       // ==================   tempoprary extract tables and call a  *
       // subroutine to clear them                                   *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: clearTable                                          *
       //                                                            *
       //*************************************************************

       begsr clearExtractTables;

                   aTblName(1) = 'LETMPLTD';
                   aTblName(2) = 'LETBL1TD';
                   aTblName(3) = 'LEXTRCTD';

                   for i = START to MAX_EXTR;
                      wSQLTable = %Trim(aTblName(i));
                      exsr clearTable;
                   endfor;
                   Commit;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // clearTable - This will issue an SQL DELETE statement to    *
       // ==========   clear the contents of affected table          *
       //                                                            *
       // Called by: clearExtractTables                              *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr clearTable;

                   wSqlStr = 'delete from ' + wSQLTable;
                   exec sql
                   execute immediate :wSqlStr;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 001;
                      dBfile   = wSQlTable;
                      dBkey    = *BLANKS;
                      dBpgm    = 'LE000495';
                      exsr *pssr;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // resetIdentityColumn - This will issue an SQL RESET         *
       // ===================   statement over LETMPLTD to ensure    *
       // that identity column SEUNIQ always starts with 1           *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr resetIdentityColumn;

                   wSqlStr = 'alter table LETMPLTD ' +
                             'alter column SEUNIQ restart with 1';
                   exec sql
                   execute immediate :wSqlStr;

                   if sqlCod <> NO_ERROR;
                      dBase    = 002;
                      dBFile   = 'LETMPLTD';
                      dBkey    = *BLANKS;
                      dBpgm    = 'LE000495';
                      exsr *pssr;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // determineRepaymentSequence - This subroutine will select   *
       // ==========================   all records in table SDRPKYTD *
       // sorted by column RPKPOS so that repayment order can be     *
       // determined. This sorting sequence will be used for         *
       // subsequent SQL SELECT statements                           *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr determineRepaymentSequence;

                   wSQLStr = 'select * from SDRPKYTD ' +
                             'where RPKPOS <> 0 ' +
                             'order by RPKPOS';

                   exec sql prepare P1 from :wSQLStr;
                   exec sql declare P1 cursor for P1;
                   exec sql open P1;
                   exec sql fetch next From P1 into :RepaymentKey;

                   if sqlCod = TABLE_IS_OPEN;
                      exec sql open P1;
                      exec sql fetch next From P1 into :RepaymentKey;
                   endif;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBkey = *Blanks;
                      dBfile = 'SDRPKYTD';
                      dBase = 003;
                      dBpgm  = 'LE000495';
                      exsr *pssr;
                   endif;

                   dow sqlCod = NO_ERROR;

                      exsr buildSortSequence;
                      exec sql fetch next from P1 into :RepaymentKey;

                      if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                         dBkey = *Blanks;
                         dBfile = 'SDRPKYTD';
                         dBase = 004;
                         dBpgm  = 'LE000495';
                         exsr *pssr;
                      endif;

                   enddo;

                   sortSequence = %Subst(%Trim(sortSequence):1:
                                  %Len(%Trim(sortSequence))-1);

                   exec sql close P1;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // buildSortSequence - This subroutine will concatenate/build *
       // =================   sortSequence variable                  *
       //                                                            *
       // Called by: determineRepaymentSequence                      *
       //                                                            *
       // Calls: getOrder()                                          *
       //                                                            *
       //*************************************************************

       begsr buildSortSequence;

                   select;
                      when %Trim(RPKEYF) = 'RepaymentPR';
                         sortSequence = %TRIM(SortSequence) + 'SEREPR ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'CategoryCOPR';
                         sortSequence = %TRIM(SortSequence) + 'SECAPR ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'ORTStartDate';
                         sortSequence = %TRIM(SortSequence) + 'SESDAT ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'ORTEndDate';
                         sortSequence = %TRIM(SortSequence) + 'SEMDAT ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'Reference';
                         sortSequence = %TRIM(SortSequence) + 'SETREF ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'PAYValueDate';
                         sortSequence = %TRIM(SortSequence) + 'SEVDPY ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'PDCLValueDate';
                         sortSequence = %TRIM(SortSequence) + 'SEVDPD ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'Amount';
                         sortSequence = %TRIM(SortSequence) + 'SEPAMT ' +
                                        getOrder(RPKORD);
                      when %Trim(RPKEYF) = 'Timestamp';
                         sortSequence = %TRIM(SortSequence) + 'SETMST ' +
                                        getOrder(RPKORD);
                   endsl;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // combineExtractTable - This subroutine will issue an SQL    *
       // ===================   INSERT statement to combine          *
       // individual extract table to LETMPLTD                       *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr combineExtractTable;

       // Initialise array of column names to be included in select

                   aColName( 1) = 'SEFILE';
                   aColName( 2) = 'SETRID';
                   aColName( 3) = 'SEBRCA';
                   aColName( 4) = 'SEACCY';
                   aColName( 5) = 'SECNUM';
                   aColName( 6) = 'SEACOD';
                   aColName( 7) = 'SEACSQ';
                   aColName( 8) = 'SEFCUS';
                   aColName( 9) = 'SELNRF';
                   aColName(10) = 'SEFACL';
                   aColName(11) = 'SEFSEQ';
                   aColName(12) = 'SEFCOD';
                   aColName(13) = 'SEAKEY';
                   aColName(14) = 'SEVDAT';
                   aColName(15) = 'SEREVI';
                   aColName(16) = 'SEOVFL';
                   aColName(17) = 'SECATC';
                   aColName(18) = 'SEREPR';
                   aColName(19) = 'SECAPR';
                   aColName(20) = 'SETREF';
                   aColName(21) = 'SESDAT';
                   aColName(22) = 'SEMDAT';
                   aColName(23) = 'SEVDPD';
                   aColName(24) = 'SEVDPY';
                   aColName(25) = 'SEPAMT';
                   aColName(26) = 'SETMST';
                   aColName(27) = 'SEACNO';
                   aColName(28) = 'SEAAMT';
                   aColName(29) = 'SEEAMT';
                   aColName(30) = 'SEOAMT';
                   aColName(31) = 'SEIPFL';
                   aColName(32) = 'SEKEYF';
                   aColName(33) = 'SEIND1';
                   aColName(34) = 'SEIND2';

       // Initialise array of column names to be included in select

                   aValName( 1) = '*SAME';
                   aValName( 2) = '*SAME';
                   aValName( 3) = '*SAME';
                   aValName( 4) = '*SAME';
                   aValName( 5) = '*SAME';
                   aValName( 6) = '*SAME';
                   aValName( 7) = '*SAME';
                   aValName( 8) = '*BLANKS';
                   aValName( 9) = '*BLANKS';
                   aValName(10) = '*BLANKS';
                   aValName(11) = '*BLANKS';
                   aValName(12) = '*BLANKS';
                   aValName(13) = '*BLANKS';
                   aValName(15) = '*ZEROS';
                   aValName(14) = '*SAME';

                   select;
                      when aFilName(i) = 'LEPK1DPD';
                           aValName( 9) = 'LNNO';
                           aValName(13) = 'substr(AKEY,1,10)';
                           aValName(14) = 'EDAT';
                           aValName(15) = 'REVI';

                      when aFilName(i) = 'LEPK2DPD' Or
                           aFilName(i) = 'LEPK3DPD';
                           aValName( 8) = 'LKCNU2';
                           aValName( 9) = 'LKLOAN';
                           aValName(10) = 'LKFACL';
                           aValName(11) = 'LKFSE2';
                           aValName(12) = 'LKFCOD';
                           aValName(13) = 'substr(LKAKEY,1,10)';
                           aValName(14) = 'LKEDAT';
                           aValName(15) = 'LKREVI';
                      when aFilName(i) = 'LEACCFPD';
                           aValName( 8) = 'SEFCUS';
                           aValName( 9) = 'SELNRF';
                           aValName(10) = '*BLANKS';
                           aValName(11) = 'SEFSEQ';
                           aValName(12) = 'SEFCOD';
                      when aFilName(i) = 'LEACCTPD' Or
                           aFilName(i) = 'LELEGDPD';
                           aValName( 9) = 'SELNRF';
                           aValName(13) = '*SAME';
                      when aFilName(i) = 'LEREMRPD'  Or
                           aFilName(i) = 'LELEGDPD';
                           aValName(14) = 'VDAT';
                   endSl;

                   aValName(16) = '*SAME';
                   aValName(17) = '*SAME';
                   aValName(18) = '*SAME';
                   aValName(19) = '*SAME';
                   aValName(20) = '*SAME';
                   aValName(21) = '*SAME';
                   aValName(22) = '*SAME';
                   aValName(23) = '*SAME';
                   aValName(24) = '*SAME';
                   aValName(25) = '*SAME';
                   aValName(26) = '*SAME';
                   aValName(27) = '*ZEROS';
                   aValName(28) = '*ZEROS';
                   aValName(29) = 'SEPAMT';
                   aValName(30) = '*ZEROS';
                   aValName(31) = QUO + 'N' + QUO;
                   aValName(32) = 'secnum || seaccy ||' +
                                  'substr(digits(seacod),1,10) || '+
                                  'substr(digits(seacsq),1,2) ||' +
                                  'sebrca';
                   aValName(33) = '*ZEROS';
                   aValName(34) = '*ZEROS';

       // Initialise Column Names String

                   for wIndex = START to MAX_COLS;
                      if wIndex = 1;
                         wNameStr = '(';
                      endIf;
                      wNameStr = %Trim(wNameStr) + %Trim(aColName(wIndex));
                      if wIndex <> MAX_COLS;
                         wNameStr = %Trim(wNameStr) + ', ';
                      else;
                         wNameStr = %Trim(wNameStr) + ') ';
                      endif;
                   endfor;

       // Initialise Column Values String

                   wValueStr = '';
                   for wIndex = START to MAX_COLS;
                      select;
                         when %Trim(aValName(wIndex)) = '*SAME';
                            wValueStr = %Trim(wValueStr) +
                                       %Trim(aColName(wIndex));
                         when %Trim(aValName(wIndex)) = '*BLANKS';
                            wValueStr = %Trim(wValueStr) + QUO + QUO;
                         when %Trim(aValName(wIndex)) = '*ZEROS';
                            wValueStr = %Trim(wValueStr) + '0';
                         other;
                            wValueStr =  %Trim(wValueStr) +
                                         %Trim(aValName(wIndex));
                      endsl;
                      if wIndex <> MAX_COLS;
                            wValueStr = %Trim(wValueStr) + ', ';
                      endif;
                   endFor;

       // Execute INSERT SQL for each of the extract file in the array

                   wSqlStr = 'insert into LETMPLTD ' +
                             %Trim(wNameStr) +
                             ' select ' + %Trim(wValueStr) +
                             ' from ' +
                             %Trim(aFilName(i)) +
                             ' where secnum <> ' + QUO + ' ' + QUO +
                             ' and ' +
                             ' seaccy <> ' + QUO + ' ' + QUO +
                             ' and ' +
                             ' seacod <> 0 ' +
                             ' and ' +
                             ' seacsq <> 0 ' +
                             ' and ' +
                             ' sebrca <> ' + QUO + ' ' + QUO;

                   if aFilName(i) = 'LEPK1DPD';
                      wSqlStr = %Trim(wSqlStr) +
                                ' and (REVI = 0 and EAMT > 0) ' +
                                ' or  (REVI = 1 and EAMT < 0) ';
                   endif;

                   exec sql
                   execute immediate :wSqlStr;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 005;
                      dBfile   = 'LETMPLTD';
                      dBKey    = *BLANKS;
                      dBPgm    = 'LE000495';
                      exsr *pssr;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // processCustomerBalances - This subroutine will extract a   *
       // =======================   subset of LETMPLTD wherein it    *
       // will only retrieve the first occurence of a settlement     *
       // account so that it can process and retrieve initial        *
       // balances for the said account                              *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr processCustomerBalances;

                   wStr1   = 'SECNUM, SEACCY, SEACOD, SEACSQ, SEBRCA,';

                   wSQLStr = 'select * from ' +
                             '(select LETMPLTD.*, ROW_NUMBER() over ' +
                             '(partition by SECNUM, SEACCY, SEACOD, ' +
                             'SEACSQ, SEBRCA order by ' +
                             %Trim(wStr1) + ' ' +
                             %Trim(SortSequence) +
                             ') as RecNo from LETMPLTD) as ' +
                             'Tbl where RecNo = 1';

                   exec sql prepare P2 from :wSQLStr;
                   exec sql declare P2 cursor for P2;
                   exec sql open P2;
                   exec sql fetch next from P2 for :MAX_ARRAY
                   rows into :CustomerDS;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBkey = *Blanks;
                      dBFile = 'LETBL1TD';
                      dBase = 006;
                      dBPgm  = 'LE000495';
                      exsr *pssr;
                   endif;

                   dow sqlCod = NO_ERROR;

                      wRowsReturned = SqlErrd(3);
                      exsr updateCurrentBalance;

                      exec sql fetch next from P2 for :MAX_ARRAY
                      rows into :CustomerDS;

                      if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                         dBkey = *Blanks;
                         dBfile = 'LETBL1TD';
                         dBase = 007;
                         dBpgm  = 'LE000495';
                         exsr *pssr;
                      endif;

                   enddo;
                   exec sql close P2;

                   wSqlStr = 'update LETMPLTD A set (A.SEAAMT, ' +
                             'A.SEOAMT,A.SEAVFL, A.SEIPFL, SEACNO,'+
                             'A.SERAMT, A.SECLBL, A.SECOLL,' +
                             'A.SERETB, A.SEHELD, A.SEC205, A.SEABCF,'+
                             'A.SEAVOD) = ' +
                             '(select SEAAMT, SEOAMT, SEAVFL, SEIPFL,' +
                             ' SEACNO, SERAMT, SECLBL, SECOLL,'+
                             ' SERETB, SEHELD, SEC205, SEABCF, SEAVOD'+
                             ' from LETBL1TD B where ' +
                             'A.SEUNIQ = B.SEUNIQ) where exists ' +
                             '(select * from LETBL1TD C where ' +
                             'A.SEUNIQ = C.SEUNIQ)';
                   exec sql
                   execute immediate :wSqlStr;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 008;
                      dBfile   = 'LETMPLTD';
                      dBkey    = *BLANKS;
                      dBpgm    = 'LE000495';
                      exsr *pssr;
                   endif;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // updateCurrentBalance - This subroutine will call           *
       // ====================   getBalance API to retrieve customer *
       // balances then updates current customer array element       *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: GetBalance()                                        *
       //                                                            *
       //*************************************************************

       begsr updateCurrentBalance;

       // Process all settlement account records loaded in a paged
       // array by calling GetBalance API to retrieve Available Amount,
       // Cleared Balances and Adjustments, Held Items, Overdraft
       // amount and Blocked Collateral

                   for i = START to wRowsReturned;
                      wReturnCd = *Blanks;
                      wClrAdjBal= 0;
                      wClearBal = 0;
                      wAvailBal = 0;
                      wOverDrLn = 0;
                      wCollateral = 0;
                      callp getBalance(
                                         wReturnCd
                                       : CustomerDS(i).SECNUM
                                       : CustomerDS(i).SEACCY
                                       : CustomerDS(i).SEACOD
                                       : CustomerDS(i).SEACSQ
                                       : CustomerDS(i).SEBRCA
                                       : wRetailAc
                                       : wClrAdjBal
                                       : wClearBal
                                       : wAvailBal
                                       : wHeldItem
                                       : wOverDrLn
                                       : wCollateral
                                       : wBlockDebit
                                       : wCAP205
                                       : wABCFlag
                                      );
                      if wReturnCd <> *blanks;
                         dBkey = *blanks;
                         dBfile = 'LETBL1TD';
                         dBase = 009;
                         dBpgm  = 'LE000495';
                         exsr *pssr;
                      else;
                         CustomerDS(i).SECLBL = wClrAdjBal;
                         CustomerDS(i).SEHELD = wHeldItem;
                         CustomerDS(i).SECOLL = wCollateral;
                         CustomerDS(i).SEOAMT = wOverDrln;
                         CustomerDS(i).SEACNO = wRetailAc;
                         CustomerDS(i).SEAAMT = wAvailBal;
                         CustomerDS(i).SERETB = wBlockDebit;
                         CustomerDS(i).SEC205 = wCAP205;
                         CustomerDS(i).SEABCF = wABCFlag;

       // Set current balance to Available amount as retrieved from
       // current settlement account. Overdraft amount is added if
       // overdraft flag of transaction is set to 'Y'

                         CurBalance = CustomerDS(i).SEAAMT;
                         CustomerDS(i).SEAVOD = CustomerDS(i).SEAAMT +
                                                    CustomerDS(i).SEOAMT;
                         if CustomerDS(i).SEOVFL = 'Y';
                            CurBalance += CustomerDS(i).SEOAMT;
                         endif;

       // If current available balance is greater than or equal to
       // event amount set amount repaid to event amount otherwise
       // set this to current available balance

                         if CurBalance >= 0;
                            CustomerDS(i).SERAMT = 0;
                         else;
                            if (CurBalance * -1) >=
                                  CustomerDS(i).SEEAMT;
                               CustomerDS(i).SERAMT =
                                  CustomerDS(i).SEEAMT;
                            else;
                               CustomerDS(i).SERAMT =
                                  CurBalance * -1;
                            endif;
                         endif;

                         CustomerDS(i).SEIPFL = 'Y';
                         CustomerDS(i).SEAVFL = 'Y';
                      endif;

                   endfor;

       // Insert one page of data to temporary combined extract table
       // LETBL1TD, a page is defined as the number of array defined
       // in MAX_ARRAY variable which is initially set to 500

                   CustSaveDS = %Subarr(CustomerDS:1);
                   exec sql insert into LETBL1TD
                        :wRowsReturned rows
                        values (:CustSaveDS);

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 010;
                      dBfile   = 'LETBL1TD';
                      dBkey    = *BLANKS;
                      dBpgm    = 'LE000495';
                      exsr *pssr;
                   endif;

       endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // processAvailableBalance - This subroutine will process     *
       // =======================   available balances for the       *
       // combined extract table                                     *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: updateAvailableBalance                              *
       //                                                            *
       //*************************************************************

       begsr processAvailableBalance;

       // Process all records from combined extract file sorted by
       // repayment sequence as defined in SRPKYTD

                   wSQLStr= 'select * from LETMPLTD order by ' +
                            %Trim(SortSequence);
                   exec sql prepare P3 from :wSQLStr;
                   exec sql declare P3 cursor for P3;
                   exec sql open P3;
                   exec sql fetch next from P3 for :MAX_ARRAY
                   rows into :TransactDS;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBkey = *Blanks;
                      dBfile = 'LETMPLTD';
                      dBase = 011;
                      dBpgm  = 'LE000495';
                      exsr *pssr;
                   endif;

                   dow sqlCod = NO_ERROR;

                      wRowsReturned = SqlErrd(3);

                      for i = START to wRowsReturned;
                          TransactDS(i).C_SEIND1    = i;
                      endfor;

                      exsr updateAvailableBalance;
                      exec sql fetch next from P3 for :MAX_ARRAY
                      rows into :TransactDS;

                      if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                         dBkey = *Blanks;
                         dBfile = 'LEXTRCTD';
                         dBase = 012;
                         dBpgm  = 'LE000495';
                         exsr *pssr;
                      endif;

                   enddo;

                   exec sql close P3;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // updateAvailableBalance - This subroutine will perform      *
       // ======================   the calculation to retrieve       *
       // available balance for an individual extract table element  *
       //                                                            *
       // Called by: processAvailableBalance                         *
       //                                                            *
       // Calls: qSORT API; bSEARCH API                              *
       //                                                            *
       //*************************************************************

       begsr updateAvailableBalance;

       // Create a new DS array which is sorted by customer, this will
       // be initialised to Transact DS array

                   sortedDS = %Subarr(TransactDS:1);

       // Call QSORT API to sort the array elements since
       // BSEARCH API will work only in sorted arrays

                   qSort(%Addr(SortedDS)
                         :wRowsReturned
                         :%Size(SortedDS)
                         :pSeqProcedure);

                   for i = START to wRowsReturned;
                       sortedDS(i).C_SEIND2 = i;
                   endfor;

       // Populate TransactDS.SEIND2

                   for i = START to wRowsReturned;
                      transactDS(sortedDS(i).C_SEIND1).C_SEIND2 =
                      sortedDS(i).C_SEIND2;
                   endfor;

                   for i = START to wRowsReturned;
                      searchArgument = transactDS(i).C_SEKEYF;
                      if transactDS(i).C_SEAVFL <> 'Y';

       // Search for the item using Binary Search algorithm, as
       // comparison with linear search %Lookup, using 1000 elements
       // Linear Search: 500.5 comparison Binary Search: 10.976 comparison
       // which makes bSearch ideal when processing time is crucial

                         pResult =
                         bSearch(
                                      %Addr(SearchArgument)
                                    : %Addr(SortedDS)
                                    : wRowsReturned
                                    : %Size(SortedDS)
                                    : pSearchForNam
                                );
                         if pResult <> *null;
                            isFound = *Off;
                            SEARCH_START = Result.C_SEIND2;

       // Search starts at the middle to end of array

                            for j = SEARCH_START to wRowsReturned;
                               if SearchArgument =
                                  sortedDS(j).C_SEKEYF;
                                  if SortedDS(j).C_SEAVFL = 'Y';
                                     wIdxPrvBal =
                                     sortedDS(j).C_SEIND2;
                                     j = wRowsReturned;
                                     isFound = *On;
                                  endif;
                               else;
                                  j = wRowsReturned;
                               endif;
                            endfor;

       // Search starts at the middle to beginning of array

                            if isFound = *Off;
                               for j = SEARCH_START downto 1;
                                  if searchArgument =
                                     sortedDS(j).C_SEKEYF;
                                     if sortedDS(j).C_SEAVFL = 'Y';
                                        wIdxPrvBal =
                                        sortedDS(j).C_SEIND2;
                                        j = 1;
                                        isFound = *On;
                                     endif;
                                  else;
                                     j = 1;
                                  endif;
                               endfor;
                            endif;

            // If current settlement account is found in array,
            // retrieve account balances details on this array
            // otherwise retrieve this from LEXTRCTD table

                            if  isFound;
                               exsr retrieveFromArray;
                            else;
                               exsr retrieveFromTable;
                            endif;
                            transactDS(i).C_SEIPFL = 'Y';
                         endif;
                      endif;
                   endFor;

            // Issue an SQL INSERt statement to insert page full of
            // information to LEXTRCTD

                   exec sql insert into LEXTRCTD
                        :wRowsReturned rows
                        values (:transactDS);

                   if sqlCod <> NO_ERROR and sqlCod <> NO_ERROR;
                      dBase    = 013;
                      dBfile   = 'LEXTRCTD';
                      dBKey    = *BLANKS;
                      dBPgm    = 'LE000495';
                      exsr *pssr;
                  endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // retrieveFromArray - Retrieve details from an array elem    *
       // =================                                          *
       // Called by: updateAvailableBalance                          *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr retrieveFromArray;

       // Current Available Balance is set from previous Available
       // Amount without Overdraft + previous Amount Repaid

                   wAvailBalance =
                      sortedDS(wIdxPrvBal).C_SEAAMT +
                         sortedDS(wIdxPrvBal).C_SERAMT;

       // Current Available Amount with Ovderdraft is set to Previous
       // Available Amount with Overdraft + previous Amount Repaid

                   wOverdraftAmt =
                      sortedDS(wIdxPrvBal).C_SEAVOD +
                            sortedDS(wIdxPrvBal).C_SERAMT;

       // Set Current Balance to Computed Available Amount without
       // Overdraft. If current transaction Overdraft Flag is 'Y'
       // set this to Available Amount with Overdraft

                   CurBalance = wAvailBalance * -1;
                   if transactDS(i).C_SEOVFL = 'Y';
                      CurBalance = wOverdraftAmt * -1;
                   endif;

       // If current available balance is greater than or equal to
       // event amount set amount repaid to event amount otherwise
       // set this to current available balance

                   if CurBalance >= 0;
                      transactDS(i).C_SERAMT = transactDS(i).C_SEEAMT;
                      sortedDS(TransactDS(i).C_SEIND2).C_SERAMT =
                         transactDS(i).C_SEEAMT;
                      if CurBalance < transactDS(i).C_SEEAMT;
                         transactDS(i).C_SERAMT = CurBalance;
                         sortedDS(TransactDS(i).C_SEIND2).C_SERAMT =
                            CurBalance;
                      endif;
                   endif;

                   sortedDS(wIdxPrvBal).C_SEAVFL = ' ';
                   transactDS(i).C_SEAAMT = wAvailBalance;
                   transactDS(i).C_SEAVOD = wOverdraftAmt;
                   transactDS(i).C_SEAVFL = 'Y';
                   transactDS(i).C_SERETB = sortedDS(wIdxPrvBal).C_SERETB;
                   transactDS(i).C_SEACNO = sortedDS(wIdxPrvBal).C_SEACNO;
                   transactDS(i).C_SEC205 = sortedDS(wIdxPrvBal).C_SEC205;

                   sortedDS(TransactDS(i).C_SEIND2).C_SEAVFL =
                       'Y';
                   sortedDS(TransactDS(i).C_SEIND2).C_SEAAMT =
                   wAvailBalance;
                   sortedDS(TransactDS(i).C_SEIND2).C_SEAVOD =
                   wOverdraftAmt;
                   sortedDS(TransactDS(i).C_SEIND2).C_SERETB =
                   sortedDS(wIdxPrvBal).C_SERETB;
                   sortedDS(TransactDS(i).C_SEIND2).C_SEACNO =
                   sortedDS(wIdxPrvBal).C_SEACNO;
                   sortedDS(TransactDS(i).C_SEIND2).C_SEC205 =
                   sortedDS(wIdxPrvBal).C_SEC205;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // retrieveFromTable - Retrieve details from LEXTRCTD table   *
       // =================                                          *
       //                                                            *
       // Called by: updateAvailableBalance                          *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr retrieveFromTable;

                   wSQLStr = 'select *  from (select LEXTRCTD.*,'+
                             'row_number() over (partition by ' +
                             'SEKEYF order by SEKEYF) as RecNo ' +
                             'from LEXTRCTD) as Tbl where ' +
                             'SEKEYF = ' + QUO +
                             TransactDS(i).C_SEKEYF + QUO +
                             ' and SEAVFL = ' + QUO + 'Y' + QUO +
                             ' order by RecNo DESC ' +
                             ' fetch first 1 row only';
                   exec sql prepare P4 from :wSQLStr;
                   exec sql declare P4 cursor for P4;
                   exec sql open P4;
                   exec sql fetch P4 into :AvailableBal;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                      and sqlCod <> IGNORE_ERROR;
                      dbKey = *Blanks;
                      dbFile = 'LEXTRCTD';
                      dbase = 014;
                      dbPgm  = 'LE000495';
                      out Lda;
                   endif;

       // Current Available Balance is set from previous Available
       // Amount without Overdraft + previous Amount Repaid

                   wAvailBalance = B_SEAAMT + B_SERAMT;

       // Current Available Amount with Ovderdraft is set to Previous
       // Available Amount with Overdraft + previous Amount Repaid

                   wOverdraftAmt = B_SEAVOD + B_SERAMT;

       // Set Current Balance to Computed Available Amount without
       // Overdraft. If current transaction Overdraft Flag is 'Y'
       // set this to Available Amount with Overdraft

                   CurBalance = wAvailBalance * -1;
                   if transactDS(i).C_SEOVFL = 'Y';
                      CurBalance = wOverdraftAmt * -1;
                   endif;

       // If current available balance is greater than or equal to
       // event amount set amount repaid to event amount otherwise set
       // this to current available balance

                   if CurBalance >= 0;
                      transactDS(i).C_SERAMT = transactDS(i).C_SEEAMT;
                      sortedDS(TransactDS(i).C_SEIND2).C_SERAMT =
                         transactDS(i).C_SEEAMT;
                      if CurBalance < transactDS(i).C_SEEAMT;
                         transactDS(i).C_SERAMT = CurBalance;
                         sortedDS(TransactDS(i).C_SEIND2).C_SERAMT =
                         CurBalance;
                      endif;
                   endif;

                   transactDS(i).C_SEAVOD = wOverdraftAmt;
                   transactDS(i).C_SEAAMT = wAvailBalance;
                   transactDS(i).C_SEAVFL = 'Y';
                   transactDS(i).C_SERETB = B_SERETB;
                   transactDS(i).C_SEACNO = B_SEACNO;
                   transactDS(i).C_SEC205 = B_SEC205;

                   sortedDS(TransactDS(i).C_SEIND2).C_SEAVFL =
                       'Y';
                   sortedDS(TransactDS(i).C_SEIND2).C_SEAAMT =
                   wAvailBalance;
                   sortedDS(TransactDS(i).C_SEIND2).C_SEAVOD =
                   wOverdraftAmt;
                   sortedDS(TransactDS(i).C_SEIND2).C_SERETB =
                   B_SERETB;
                   sortedDS(TransactDS(i).C_SEIND2).C_SEACNO =
                   B_SEACNO;
                   sortedDS(TransactDS(i).C_SEIND2).C_SEC205 =
                   B_SEC205;

                   exec sql close P4;

       endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // distributeAvailableBalance - This subroutine will issue an *
       // ==========================   SQL UPDATE statement to       *
       // update individual extract tables                           *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr distributeAvailableBalance;

                   wSEFILE = %Trim(aFilName(i));

                   select;
                      when wSEFILE = 'LEPK1DPD';
                         wSEAAMT = 'AAMT';
                         wSEIPFL = 'IPFL';
                      when wSEFILE = 'LEPK2DPD' or
                           wSEFILE = 'LEPK3DPD';
                         wSEAAMT = 'LKAAMT';
                         wSEIPFL = 'LKIPFL';
                      other;
                         wSEAAMT = 'SEAAMT';
                         wSEIPFL = 'SEIPFL';
                   endsl;

                   wStr1 = 'case when SERETB <> ' + QUO + 'Y' + QUO +
                           ' then case when SEOVFL = ' + QUO + 'Y' + QUO +
                           ' then SEAVOD else SEAAMT end else 0 end';
                   wSqlStr = 'update ' + wSEFILE + ' A' +
                              ' set (A.' + %Trim(wSEAAMT) + ',' +
                              ' A.' + %Trim(wSEIPFL) + ') = ' +
                             '(select ' + %Trim(wStr1) + ',' +
                             'SEIPFL' +
                             ' from LEXTRCTD B where ' +
                             'A.SETRID = B.SETRID AND A.SEFILE = ' +
                             ' B.SEFILE) where exists ' +
                             '(select * from LEXTRCTD C where ' +
                             'A.SETRID = C.SETRID AND A.SEFILE ' +
                             ' = C.SEFILE)';
                   exec sql
                   execute immediate :wSqlStr;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 015;
                      dBfile   = wSEFILE;
                      dBkey    = *BLANKS;
                      dBpgm    = 'LE000495';
                      exsr *pssr;
                   endif;

       endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // rollBackTransaction - Roll back all updated transactions   *
       // ===================                                        *
       //                                                            *
       // Called by: *pssr                                           *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr rollBackTransaction;
                   wSqlStr = 'rollback';
                   exec sql
                   execute immediate :wSqlStr;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // commitTransaction - Commit changes to tables               *
       // =================                                          *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr commitTransaction;
                   wSqlStr = 'commit';
                   exec sql
                   execute immediate :wSqlStr;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // inzsr - Program Initialisation routine                     *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr *inzsr;
                   In Sdstat;
                   wLibrary = LIBR + 'DMLIB';
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   *pssr  - Program Error Processing Subroutine.            *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       begsr *pssr;
                   *inu7 = *on;
                   *inu8 = *on;
                   *Inlr = *on;
                   dump;
       // Ensure that an SQL ROLLBACK statement is issued to rollback
       // changes made to individual tables
                   exsr  rollBackTransaction;
                   return;
       endsr;

      /end-free

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCommand - Execute CL Command                               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: QCMDEXC                                                *
      *                                                               *
      *****************************************************************
     C     SrCommand     BEGSR
     C                   EVAL      MessageID = *BLANKS
     C                   EVAL      CommandLen = 200
     C                   CALL  (E) 'QCMDEXC'
     C                   PARM                    CommandStr
     C                   PARM                    CommandLen       15 5
     C                   IF        %ERROR
     C                   EVAL      MessageID = PSExcpType+
     C                             PSExcpNo
     C                   ENDIF
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getOrder - Determine whether ASC or DESC keywoard should     *
      *             be returned                                       *
      *                                                               *
      *****************************************************************

     P getOrder        B
     D getOrder        PI             6A
     D   SortOrder                    1A
     D   retVal        S              6A
     D
     C                   SELECT
     C                   WHEN      SortOrder = 'A'
     C                   EVAL      RetVal = 'ASC'
     C                   WHEN      SortOrder = 'D'
     C                   EVAL      RetVal = 'DESC'
     C                   ENDSL
     C                   EVAL      RetVal  = %TRIM(RetVal) + ', '
     C                   RETURN    RetVal
     P   getOrder      E

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SortFunc - Sort function called by QSORT                     *
      *                                                               *
      *****************************************************************

     P SortFunc        B
     D SortFunc        PI            10I 0
     D   Candidate1                        LIKEDS(CombineFile)
     D   Candidate2                        LIKEDS(CombineFile)
     C                   IF        Candidate1.C_SEKEYF > Candidate2.C_SEKEYF
     C                   Return    HIGH
     C                   ELSEIF    Candidate1.C_SEKEYF < Candidate2.C_SEKEYF
     C                   Return    LOW
     C                   ELSE
     C                   Return    EQUAL
     C                   ENDIF
     C
     P SortFunc        E

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SeachForName - Search function called by BSEARCH             *
      *                                                               *
      *****************************************************************

     P searchForName   B
     D searchForName   PI            10I 0
     D   searchName                  24A
     D   Candidate                         LIKEDS(SortedDS)
     C                   IF        searchName  > Candidate.C_SEKEYF
     C                   Return    HIGH
     C                   ELSEIF    searchName < Candidate.C_SEKEYF
     C                   Return    LOW
     C                   ELSE
     C                   Return    EQUAL
     C                   ENDIF
     C
     P searchForName   E


