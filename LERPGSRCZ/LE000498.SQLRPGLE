     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
     H DFTACTGRP(*NO) ACTGRP('QILE')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Generate Random Repayment Keys')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000498 - Midas LE PDP Available Balance Computation        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE164 *CREATE     Date 18Aug14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
     D Main            PR                  Extpgm('LE000498')
     D  ArraySize                     5S 0 CONST OPTIONS(*NOPASS)
     D  RandomFlag                    1A   CONST OPTIONS(*NOPASS)
     D Main            PI
     D  ArraySize                     5S 0 CONST OPTIONS(*NOPASS)
     D  RandomFlag                    1A   CONST OPTIONS(*NOPASS)

     D  availableBal   PR                  Extpgm('LE000495')
     D  RandomFlag                    1A   CONST OPTIONS(*NOPASS)
     D  printReport    PR                  Extpgm('LEC000496')
     D  UserData                     10A

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D RepaymentKey  E DS                  EXTNAME(SDRPKYTD)

      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+
     D HIGH            C                   CONST(1)
     D LOW             C                   CONST(-1)
     D EQUAL           C                   CONST(0)
     D START           C                   CONST(1)
     D MAX_FILE        C                   CONST(6)
     D MAX_EXTR        C                   CONST(2)
     D MAX_COLS        C                   CONST(35)
     D NOT_EXIST       C                   CONST(-204)
     D NO_ERROR        C                   CONST(0)
     D NO_RECORD       C                   CONST(100)
     D TABLE_CREATED   C                   CONST(7905)
     D IGNORE_ERROR    C                   CONST(30)
     D QUO             C                   CONST('''')

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D  MessageID      S              7A   INZ(*BLANKS)
     D  CommandStr     S            200A   INZ(*BLANKS)
     D  FileStr1       S             10A   INZ(*BLANKS)
     D  FileStr2       S             10A   INZ(*BLANKS)
     D  DPLIB          S             10A   INZ(*BLANKS)
     D  DMLIB          S             10A   INZ(*BLANKS)
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** +--------------------------------------+
      ** ¦ Array declaration                    ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D CEERAN0         PR
     D seed                          10I 0
     D ranno                          8F
     D fc                            12A   options(*omit)

     D highno          s             10I 0 Inz(9)
     D lowno           s             10I 0 Inz(1)
     D seed            s             10I 0 inz(0)
     D rand            s              8F
     D range           s             10I 0
     D result          s             10I 0
     D arrayRepayment  S             20A   DIM(9)
     D arrayDesc       S             60A   DIM(9)
     D newDesc         S             60A   DIM(9)
     D newRepayment    S             20A   DIM(9)
     D newRepSeq       S              1A   DIM(9)
     D repaymentStr    S             20A
     D repaymentDesc   S             60A
     D arraySortSeq    S              1A   DIM(3)
     D NewSortSeq      S              1A   DIM(9)
     D isNotFound      s               N
     D i               s              2S 0
     D j               s              2S 0
     D z               s              2S 0
     D Pos             s              1S 0
     D Ind             s              1S 0
     D numElems        s              8S 0
     D wSqlStr         S           2000A   INZ(*BLANKS)
     D isExit          s               N
     D isDone          s               N
     D SEQN            s             10A

       // ** +--- Start of Main processing -----------------------------------+
       // ** ¦                                                                ¦
       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
       // ** ¦ executed at program activation.                                ¦
       // ** ¦                                                                ¦
       // ** +----------------------------------------------------------------+

      /free
                   if %Parms() <> 0;
                      numElems  = ArraySize;
                   else;
                      numElems  = 10;
                   endif;

                   arraySortSeq(1)   = 'A';
                   arraySortSeq(2)   = 'N';
                   arraySortSeq(3)   = 'D';

                   CommandStr =  'DLTF (QTEMP/PDPDP*)';
                   exsr SrCommand;

                   CommandStr =  'DLTF (QTEMP/PDPDM*)';
                   exsr SrCommand;

                   for i = 1 to numElems;
                      if RandomFlag = 'Y';
                         exsr backupExtractTables;
                         exsr retrieveValues;
                         exsr processBalance;
                         exsr insertTable;
                      endif;
                      callp availableBal();
                      if *inu7 = *off and *inu8 = *off;
                         SEQN = 'SEQ-'+%EditC(i:'X');
                         callp printReport(SEQN);
                         if RandomFlag = 'Y';
                            exsr saveExtractTables;
                            exsr restoreExtractTables;
                         endif;
                      endif;
                   endfor;

                   *Inlr = *On;
                   return;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // processBalance                                             *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr insertTable;

                   wSqlStr = 'delete from SDRPKYTD';
                   exec SQL
                   execute immediate :wSqlStr;

                   if SqlCod <> NO_ERROR AND SqlCod <> NO_RECORD;
                      Dbase    = 001;
                      DbFile   = 'LEXTRCTD';
                      DbKey    = *BLANKS;
                      DbPgm    = 'LE000495';
                      Exsr *Pssr;
                   endif;

             z = 1;
             for j = 1 to 9;
                   if newSortSeq(j) <> 'N';
                      Pos = z;
                      z = z + 1;
                   else;
                      Pos = 0;
                   endif;

                   Ind = %Lookup(newRepayment(j):arrayRepayment);
                   repaymentDesc = arrayDesc(Ind);
                   wSqlStr = 'insert into SDRPKYTD ' +
                             ' values ('+
                             QUO +
                             %Trim(newRepayment(j)) +
                             QUO +
                             ',' +
                             QUO +
                             %Trim(repaymentDesc)   +
                             QUO +
                             ',' +
                             %EditC(Pos:'X') + ',' +
                             QUO +
                             %Trim(newSortSeq(j)) +
                             QUO +
                             ',' +
                             QUO + '' + QUO +
                             ')';

                   exec SQL
                   execute immediate :wSqlStr;

                   if SqlCod <> NO_ERROR AND SqlCod <> NO_RECORD;
                      Dbase    = 002;
                      DbFile   = 'LEXTRCTD';
                      DbKey    = *BLANKS;
                      DbPgm    = 'LE000495';
                      Exsr *Pssr;
                   endif;
             endfor;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // processBalance                                             *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr retrieveValues;
       // Retrieve sorting sequence from Repayment Key File
                   wSQLStr = 'select * from SDRPKYTD ';

                   exec sql prepare P1 from :wSQLStr;
                   exec sql declare P1 cursor for P1;
                   exec sql open P1;
                   exec sql fetch next From P1 into :RepaymentKey;

                   z = 0;
                   if Sqlcod <> 0 and Sqlcod <> 100;
                      DbKey = *Blanks;
                      DbFile = 'SDRPKYTD';
                      Dbase = 003;
                      DbPgm  = 'LE000495';
                      exsr *Pssr;
                   endif;

                   dow Sqlcod = 0;

                      z = z + 1;
                      arrayRepayment(z) = RPKEYF;
                      arrayDesc(z)      = RPKDES;
                      exec sql fetch next from P1 into :RepaymentKey;

                      if SQLCOD <> 0        and SQLCOD <> 100;
                         DbKey = *Blanks;
                         DbFile = 'SDRPKYTD';
                         Dbase = 004;
                         DbPgm  = 'LE000495';
                         Exsr *Pssr;
                      Endif;

                   enddo;

                   exec sql Close P1;


       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // processBalance                                             *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr processBalance;
                   clear newRepayment;
                   clear newDesc;
                   newRepayment(1) = arrayRepayment(1);
                   newDesc     (1) = arrayDesc     (1);
                   newSortSeq  (1) = 'A';
                   for j = 1 to 9;
                      isNotFound = *off;
                      dou (isNotFound = *on);
                         exsr randomNumber;
                         repaymentStr = arrayRepayment(result);
                         if %Lookup(repaymentStr:newRepayment) = 0;
                            isNotFound = *on;
                         endif;
                      enddo;
                      if j <> 1;
                         newRepayment(j) = repaymentStr;
                      endif;

                      result = 0;
                      isExit = *Off;
                      dow isExit = *Off;
                         isDone = *off;
                         dow (isDone = *off);
                            exsr randomNumber;
                            if (j = 1);
                               if (result >= 1 and result <= 3);
                                  leave;
                               endif;
                            else;
                               leave;
                            endif;
                         enddo;
                         if (j = 1);
                            if (arraySortSeq(result) = 'A') or
                               (arraySortSeq(result) = 'D');
                               leave;
                            else;
                               iter;
                            endif;
                         else;
                            if (result >= 1 and result <= 3);
                               leave;
                            else;
                               iter;
                            endif;
                         endif;
                      enddo;
                      newSortSeq  (j) = arraySortSeq(result);
                   endfor;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // randomNumber                                               *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr randomNumber;
                   range = (highno - lowno) + 1;
                   CEERAN0( seed : rand : *omit );
                   result = %int(rand * range) + lowno;
       endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // saveExtractTables                                          *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr saveExtractTables;



                   FileStr1 = 'PDPDP' + %EditC(i:'X');
                   FileStr2 = 'PDPDM' + %EditC(i:'X');
                   CommandStr =  'CRTSAVF FILE(QTEMP/' +
                                 %Trim(FileStr1) +
                                 ') AUT(*ALL)';
                   exsr SrCommand;

                   CommandStr = 'SAVOBJ OBJ('+
                                'LEPK1DPD '+
                                'LEPK2DPD '+
                                'LEPK3DPD '+
                                'LEACCTPD '+
                                'LEACCFPD '+
                                'LEREMRPD) '+
                                'LIB(' + %Trim(DPLIB) +') ' +
                                'DEV(*SAVF) ' +
                                'SAVF(QTEMP/' + %Trim(FileStr1) +')' +
                                ' OUTPUT(*NONE)';
                      exsr SrCommand;

                   FileStr2 = 'PDPDM' + %EditC(i:'X');
                   CommandStr =  'CRTSAVF FILE(QTEMP/' +
                                 %Trim(FileStr2)+
                                 ') AUT(*ALL)';
                   exsr SrCommand;

                   CommandStr = 'SAVOBJ OBJ('+
                                'LELEGDPD) '+
                                'LIB(' + %Trim(DMLIB) +') ' +
                                'DEV(*SAVF) ' +
                                'SAVF(QTEMP/' + %Trim(FileStr2) +')' +
                                ' OUTPUT(*NONE)';
                      exsr SrCommand;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // backupExtractTables                                        *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr backupExtractTables;

                   CommandStr =  'DLTF (QTEMP/PDPDPBACK)';
                   exsr SrCommand;

                   CommandStr =  'DLTF (QTEMP/PDPDMBACK)';
                   exsr SrCommand;

                   FileStr1 = 'PDPDPBACK';
                   CommandStr =  'CRTSAVF FILE(QTEMP/' +
                                 %Trim(FileStr1) +
                                 ') AUT(*ALL)';
                   exsr SrCommand;

                   CommandStr = 'SAVOBJ OBJ('+
                                'LEPK1DPD '+
                                'LEPK2DPD '+
                                'LEPK3DPD '+
                                'LEACCTPD '+
                                'LEACCFPD '+
                                'LEREMRPD) '+
                                'LIB(' + %Trim(DPLIB) +') ' +
                                'DEV(*SAVF) ' +
                                'SAVF(QTEMP/' + %Trim(FileStr1) +')' +
                                ' OUTPUT(*NONE)';
                      exsr SrCommand;

                   FileStr2 = 'PDPDMBACK';
                   CommandStr =  'CRTSAVF FILE(QTEMP/' +
                                 %Trim(FileStr2)+
                                 ') AUT(*ALL)';
                   exsr SrCommand;

                   CommandStr = 'SAVOBJ OBJ('+
                                'LELEGDPD SDRPKYTD) '+
                                'LIB(' + %Trim(DMLIB) +') ' +
                                'DEV(*SAVF) ' +
                                'SAVF(QTEMP/' + %Trim(FileStr2) +')' +
                                ' OUTPUT(*NONE)';
                      exsr SrCommand;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // restoreExtractTables                                       *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************
       begsr restoreExtractTables;

                   FileStr1 = 'PDPDPBACK';

                   CommandStr = 'RSTOBJ OBJ('+
                                'LEPK1DPD '+
                                'LEPK2DPD '+
                                'LEPK3DPD '+
                                'LEACCTPD '+
                                'LEACCFPD '+
                                'LEREMRPD) '+
                                'SAVLIB(' + %Trim(DPLIB) +') ' +
                                'DEV(*SAVF) ' +
                                'SAVF(QTEMP/' + %Trim(FileStr1) +')';
                   exsr SrCommand;

                   FileStr2 = 'PDPDMBACK';
                   CommandStr = 'RSTOBJ OBJ('+
                                'LELEGDPD '+
                                'SDRPKYTD) '+
                                'SAVLIB(' + %Trim(DMLIB) +') ' +
                                'DEV(*SAVF) ' +
                                'SAVF(QTEMP/' + %Trim(FileStr2) +')';
                   exsr SrCommand;

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
                   DPLIB    = LIBR + 'DPLIB';
                   DMLIB    = LIBR + 'DMLIB';

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
                   *inu7 = *ON;
                   *inu8 = *ON;
                   dump;
                   *Inlr = *ON;
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

