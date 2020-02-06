     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*XBI *  OVRDBF FILE(SMSQLPQT) TOFILE(SMSQLPTD)                       *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM SQL Scripts Processor')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000100 - SQL Scripts Processor                             *
      *                                                               *
      *  Function:  This will apply SQL script deliveries in          *
      *             file SMSQLPQT                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1076132*CREATE   Date 15Feb13               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1076132 - Automate SQL delivery deployment                 *
      *                                                               *
      *****************************************************************
     FSMSQLPQT  UF   E             DISK    RENAME(SMSQLPT0:SQL2RUN)
     F                                     PREFIX('XQ':2)
     D StmEnd          S              5  0
     D StmCount        S              5  0
     D LineTLen        S              5  0
     D isComment       S              5  0
     D isDropTbl       S              5  0
     D isDropVw        S              5  0
     D isCreateVw      S              5  0
     D isDrop          S              5  0
     D Qualifier       S            256A   INZ(*Blanks)
     D QualPos         S              5  0
     D SQLSTMT         S           2048    INZ('')
      *
     D wMsg            S          32740A   INZ(*Blanks)
     D wMsgLen         S              5  0
     D wErrMsgCnt      S              5  0 INZ(0)
     D MsgIndent       S             15A   INZ(*Blanks)
     D wStmPrvw        S             40A   INZ(*Blanks)
     D ReptLine        S            100A
      *
     D SysDets         DS
     D SysName                       10A   INZ(*Blanks)
     D SysSchema                     10A   INZ(*Blanks)
     D ChkDBRStm       S            256A   INZ(*Blanks)
 
      *
     D SQLDS         E DS                  EXTNAME(SMSQLPTD)
      *
     DUP008010         PR                  EXTPGM('UP008010')
     D Mode                           7A   CONST
     D GenPgmName                    10A   CONST
     D Message                      100A   CONST
 
      /include qsysinc/qrpglesrc,QMHRCVPM
      /include qsysinc/qrpglesrc,QMHRTVM
      /include qsysinc/qrpglesrc,QUSEC
 
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              4
      /free
 
       // ------------------------------------------------------------*
       //  M A I N                                                    |
       // ------------------------------------------------------------*
 
       If Mode = '*RUN' or Mode = '*VAL';
 
          ExSr InzSQLFile;
          ExSr Process;
 
       EndIf;
 
       // Print Error Report
       ReptLine = *Blanks;
       ReptLine = %xlate(' ' : '_' : ReptLine );
       UP008010('*WRITE' : 'SM000100' : ReptLine );
       UP008010('*REPORT' : 'SM000100' : '');
 
       *INLR = *ON;
       Return;
 
       // ------------------------------------------------------------*
       // S U B R O U T I N E S                                       |
       // ------------------------------------------------------------*
 
       //-------------------------------------------------------------*
       // SR - PrepAndRun                                             |
       // Description: Prepares and/or Runs SQL Statements and updates|
       //              status flags and error indicators              |
       //-------------------------------------------------------------*
       BegSr PrepAndRun;
 
           Exec SQL Prepare STMT from :SQLSTMT;
           If SQLCODE <> 0;
               SQLECOD = %char(SQLCODE);
 
               // Log Error for Reporting
               ReptLine = *Blanks;
               ReptLine = %xlate(' ' : '_' : ReptLine );
               UP008010('*WRITE' : 'SM000100' : ReptLine );
               wStmPrvw = %subst(SQLSTMT:1:40);
 
               ReptLine = ' SQL Statement ' + %char(SQLNUM) + ' - "' +
                         %trim(wStmPrvw) + '..." failed with SQLCode ' +
                         %char(SQLCODE);
               UP008010('*WRITE' : 'SM000100' : ReptLine );
 
               Exec SQL
                    GET DIAGNOSTICS CONDITION 1 :wMsg = MESSAGE_TEXT;
 
               wMsgLen = %len(%trim(wMsg));
               UP008010('*WRITE' : 'SM000100' : ' ' );
               ReptLine = ' Error Details:';
               UP008010('*WRITE' : 'SM000100' : ReptLine );
 
               wErrMsgCnt = 1;
               DoW wErrMsgCnt < wMsgLen and wMsg <> '';
                   ReptLine = MsgIndent + %subst(wMsg : wErrMsgCnt : 80);
                   UP008010('*WRITE' : 'SM000100' : ReptLine );
                   wErrMsgCnt += 80;
               EndDo;
 
               // Update Driving File Status
               Exec SQL Update SMSQLPQT set SQLOK = 'N', SQLECOD = :SQLECOD
                        where SQLNUM = :SQLNUM;
           Else;
               Exec SQL Update SMSQLPQT set SQLOK = 'Y' where SQLNUM = :SQLNUM;
               If Mode = '*RUN';
                   Exec SQL Execute STMT;
               EndIf;
           EndIf;
 
 
       EndSr;
 
       //-------------------------------------------------------------*
       // SR - InzSQLFile                                             |
       // Description: Initialises the SQL processor main file        |
       //-------------------------------------------------------------*
       BegSr InzSQLFile;
 
           Exec SQL Update SMSQLPQT
                    set SQLOK = '', SQLNUM = 0, SQLECOD = '';
 
           StmCount = 1;
           Read SQL2RUN;
           DoW %EOF <> *ON;
 
               isComment = 0;
               StmEnd = 0;
 
               LineTLen = %len(%trim(XQLLINE));
               If LineTLen > 0;
                   StmEnd = %scan(';' : %subst(%trim(XQLLINE): +
                                  1 : LineTLen));
                   If LineTLen > 1;
                   isComment = %scan('--' : %subst(%trim(XQLLINE):1:2));
                   If isComment = 0;
                       isComment = %scan('/*' : %subst(%trim(XQLLINE):1:2));
                   EndIf;
                   EndIf;
               Else;
                   isComment = 1;
               EndIf;
 
               If isComment = 0;
                   XQLNUM = StmCount;
               Else;
                   XQLNUM = 0;
               EndIf;
 
               Update SQL2RUN;
 
               If StmEnd > 0;
                   StmCount = StmCount + 1;
               EndIf;
 
               Read SQL2RUN;
 
           EndDo;
       EndSr;
 
       //-------------------------------------------------------------*
       // SR - Process                                                |
       // Description: Runs through all statements in file for        |
       //              processing - validate or run                   |
       //-------------------------------------------------------------*
       BegSr Process;
       Exec SQL
            Declare SQLRUN cursor for
            Select
              value(SQLNUM, 0) as SQLNUM
            , value(SQLOK, '') as SQLOK
            , value(SQLECOD,'') as SQLECOD
            , value(SQLLINE,'') as SQLLINE
            , value(SQLZONE,'') as SQLZONE
            from SMSQLPQT
            where SQLZONE = '*GLOBAL'
              and SQLNUM <> 0;
 
       Exec SQL Open SQLRUN;
 
       Exec SQL Fetch next from SQLRUN into :SQLDS;
 
       DoW SQLCODE = 0;
 
           StmEnd = 0;
           LineTLen = 0;
           LineTLen = %len(%trim(SQLLINE));
           If LineTLen <> 0;
           StmEnd = %scan(';' : %subst(%trim(SQLLINE):1:LineTLen));
           EndIf;
 
           If SQLNUM <> 0;
              LineTLen = %len(%trim(SQLSTMT));
              SQLSTMT = %trim(SQLSTMT) + ' ' + %trim(SQLLINE);
              If StmEnd > 0;
                  StmEnd = LineTLen + StmEnd;
                  //Statement Complete - Prepare and Run
                  SQLSTMT = %trim(%xlate(';' : ' ' : SQLSTMT : StmEnd ));
 
                  ExSr PrepAndRun;
                  SQLSTMT = '';
              EndIf;
           EndIf;
 
       Exec SQL Fetch next from SQLRUN into :SQLDS;
 
       EndDo;
 
       Exec SQL
            Close SQLRUN;
 
       EndSr;
 
      /end-free
