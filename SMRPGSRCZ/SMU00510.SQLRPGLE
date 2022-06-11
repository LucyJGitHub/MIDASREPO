     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Process CAR migration')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Midas SM Process CAR migration                       *
      *                                                               *
      *  SMU00510 - Midas SM Process CAR migration                    *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CLE138  *CREATE    Date 02Nov21               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CLE138 - Class Codes for Facilities                          *
      *                                                               *
      *****************************************************************
      *
      ** Past Due Call Loans Account Keys Generated Report
     FSMU00510AUO    E             PRINTER INFDS(SPOOL1)
     F                                     OFLIND(*IN50)
     F                                     INFSR(*PSSR)

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.

      ** Standard D-specs
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Program Prototypes                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D Main            pr                  extpgm('SMU00510')
     D  OldLibrary                    7a
     D  NewLibrary                    7a
     D Main            pi
     D  OldLibrary                    7a
     D  NewLibrary                    7a
      *
     D  ACCESS_SDBANK  pr                  extpgm('AOBANKR0')
     D    pReturnCode                 7A
     D    pOption                     7A
     D    pDSFDY                    200A

      *  +----------------+
      ** |Parameter lists |
      ** +----------------+

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      *
      ** SDFACTX0
     D SDFACTX0DS    e ds                  extname(SDFACTX0)
     D                                     prefix(X0)
     D dsSDFACT        ds                  likeds(SDFACTX0DS)
      *
      ** SDFACTPD
     D SDFACTPDDS    e ds                  extname(SDFACTPD)
     D dsNewFile       ds                  likeds(SDFACTPDDS)
     D                                     dim(1000)
     D rtvSDFACT       ds                  likeds(SDFACTPDDS)
     D insSDFACT       ds                  likeds(SDFACTPDDS)

      ** Core data structures
     D dssdy         e ds                  extname(DSSDY)
     D dsfdy         e ds                  extname(DSFDY)
     D SDBANK        e ds                  extname(SDBANKPD)

      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+

     D NO_ERROR        c                   const(0)
     D NO_RECORD       c                   const(100)
     D NO_COLUMN       c                   const(-205)
     D QUO             c                   const('''')

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+

     D wSqlStr         s           2000a   inz(*blanks)
     D pReturnCode     s              7a
     D pOption         s              7a
     D ErrorFlag       s              7a
     D Ctr             s              6s 0
     D i               s              6s 0
     D LastRecord      s              6s 0
     D PrevSQLCod      s             10s 0

      ** +--------------------------------------+
      ** ¦ Array declaration                    ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D SPOOL1          DS
     D SFILE1                 83     92
     D SFNUM1                123    124B 0
     D OFLLN1                188    189B 0
     D PRTLN1                367    368B 0


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

                   exsr startMigration;

                   *Inlr = *On;
                   return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // startMigration - Start Migration of Files                  *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: migrateLEFCLTQD, migrateLEFCAMQD, migrateSDFACTPD  *
       //                                                            *
       //*************************************************************

       begsr startMigration;

                   // Call subroutine to migrate LEFCLTQD
                      exsr migrateLEFCLTQD;

                   // Call subroutine to migrate LEFCAMQD
                      exsr migrateLEFCAMQD;

                   // Call subroutine to migrate SDFACTPD
                      exsr migrateSDFACTPD;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // migrateLEFCLTQD;                                           *
       //                                                            *
       // Called by: startMigration                                  *
       //                                                            *
       //  Calls: printReport                                        *
       //                                                            *
       //*************************************************************

       begsr migrateLEFCLTQD;

                   // Execute SQL Statement to update LEFCLTQD
                   wSQLStr = 'update ' + NewLibrary +
                                  '/LEFCLTQD A' +
                                  ' set  FCXCLS = ' +
                                  ' (select FCLS from ' +
                                    OldLibrary + '/FCLTYFN B' +
                                  ' where A.FCXFCU = DIGITS(B.CNUM)' +
                                  ' and A.FCXFNO = DIGITS(B.FCNO)' +
                                  ' and A.FCXFTP = DIGITS(B.FACT))' +
                                  ' where exists (' +
                                  ' select 1 from ' + OldLibrary +
                                  '/FCLTYFN B' +
                                  ' where A.FCXFCU = DIGITS(B.CNUM)' +
                                  ' and A.FCXFNO = DIGITS(B.FCNO)' +
                                  ' and A.FCXFTP = DIGITS(B.FACT))';


                   exec sql
                   execute immediate :wSqlStr;
                   Count3 = SQLER3;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                     and sqlCod  <> NO_COLUMN;
                      dBase    = 001;
                      dBfile   = 'LEFCLTQD';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00510';
                      exsr *pssr;
                   endif;

                   if sqlCod = NO_COLUMN;
                      leavesr;
                   endif;

                   //Get total count in FCLTYFN
                   wSQLStr = 'select count(*) from ' + OldLibrary +
                   '/FCLTYFN';
                   exec sql prepare P1 from :wSQLStr;
                   exec sql declare P1 cursor for P1;
                   exec sql open P1;
                   exec sql fetch P1 into :Count1;
                   exec sql close P1;
                   File1 = OldLibrary + '/FCLTYFN';

                   //Get total count in LEFCLTQD
                   wSQLStr = 'select count(*) from ' + NewLibrary +
                   '/LEFCLTQD';
                   exec sql prepare P2 from :wSQLStr;
                   exec sql declare P2 cursor for P2;
                   exec sql open P2;
                   exec sql fetch P2 into :Count2;
                   exec sql close P2;
                   File2 = NewLibrary + '/LEFCLTQD';

                   //Print Audit Report
                   exsr PrintReport;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // migrateLEFCAMQD;                                           *
       //                                                            *
       // Called by: startMigration                                  *
       //                                                            *
       //  Calls: printReport                                        *
       //                                                            *
       //*************************************************************

       begsr migrateLEFCAMQD;

                   // Execute SQL Statement to update LEFCAMQD
                   wSQLStr = 'update ' + NewLibrary +
                                  '/LEFCAMQD A' +
                                  ' set  FACLAS   = ' +
                                  ' (select FCLS  from ' + OldLibrary +
                                  '/LEFCAMPD B' +
                                  ' where A.FACNUM = DIGITS(B.CNUM)' +
                                  ' and A.FAFCNO = B.FCNO' +
                                  ' and A.FAFTYP = B.FACT' +
                                  ' and A.FAFATP = B.FATP' +
                                  ' and A.FASQNO = B.SQNO)' +
                                  ' where exists (' +
                                  ' select 1 from ' + OldLibrary +
                                  '/LEFCAMPD B' +
                                  ' where A.FACNUM = DIGITS(B.CNUM)' +
                                  ' and A.FAFCNO = B.FCNO' +
                                  ' and A.FAFTYP = B.FACT' +
                                  ' and A.FAFATP = B.FATP' +
                                  ' and A.FASQNO = B.SQNO)';

                   exec sql
                   execute immediate :wSqlStr;
                   Count3 = SQLER3;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                      and sqlCod  <> NO_COLUMN;
                      dBase    = 002;
                      dBfile   = 'LEFCAMQD';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00510';
                      exsr *pssr;
                   endif;

                   if sqlCod = NO_COLUMN;
                      leavesr;
                   endif;

                   //Get total count in LEFCAMPD
                   wSQLStr = 'select count(*) from ' + OldLibrary +
                   '/LEFCAMPD';
                   exec sql prepare P3 from :wSQLStr;
                   exec sql declare P3 cursor for P3;
                   exec sql open P3;
                   exec sql fetch P3 into :Count1;
                   exec sql close P3;
                   File1 = OldLibrary + '/LEFCAMPD';

                   //Get total count in LEFCAMQD
                   wSQLStr = 'select count(*) from ' + NewLibrary +
                   '/LEFCAMQD';
                   exec sql prepare P4 from :wSQLStr;
                   exec sql declare P4 cursor for P4;
                   exec sql open P4;
                   exec sql fetch P4 into :Count2;
                   exec sql close P4;
                   File2 = NewLibrary + '/LEFCAMQD';

                   //Print Audit Report
                   exsr PrintReport;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // migrateSDFACTPD;                                           *
       //                                                            *
       // Called by: startMigration                                  *
       //                                                            *
       //  Calls: printReport                                        *
       //                                                            *
       //*************************************************************

       begsr migrateSDFACTPD;

                   Ctr = 0;

                   // Read all records from SDFACTX0
                   wSQLStr = 'select * from ' + OldLibrary +
                   '/SDFACTX0';
                   exec sql prepare P5 from :wSQLStr;
                   exec sql declare P5 cursor for P5;
                   exec sql open P5;
                   exec sql fetch next from P5 into :dsSDFACT;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                      and sqlCod <> NO_COLUMN;
                      dBkey = *Blanks;
                      dBFile = 'SDFACTX0';
                      dBase = 003;
                      dBPgm  = 'SMU00510';
                      exsr *pssr;
                   endif;

                   if sqlCod = NO_COLUMN;
                      leavesr;
                   endif;

                   Ctr = Ctr + 1;

                   exsr retrieveSDFACTPD;

                   dsNewFile(Ctr).AMFCTY =  dsSDFACT.X0AMFCTY;
                   dsNewFile(Ctr).AMCLAS =  dsSDFACT.X0AMCLAS;
                   dsNewFile(Ctr).AMLCD  =  BJRDNB;
                   dsNewFile(Ctr).AMTYLC  = 'I';
                   dsNewFile(Ctr).AMFCNM  = rtvSDFACT.AMFCNM;
                   dsNewFile(Ctr).AMZONE  = rtvSDFACT.AMZONE;
                   dsNewFile(Ctr).AMIUSR  = rtvSDFACT.AMIUSR;
                   dsNewFile(Ctr).AMAUSR  = rtvSDFACT.AMAUSR;
                   dsNewFile(Ctr).AMXUSR  = rtvSDFACT.AMXUSR;
                   dsNewFile(Ctr).AMAACC  = rtvSDFACT.AMAACC;
                   dsNewFile(Ctr).AMEACC  = rtvSDFACT.AMEACC;
                   dsNewFile(Ctr).AMGPDT  = rtvSDFACT.AMGPDT;
                   dsNewFile(Ctr).QQAMPC  = rtvSDFACT.QQAMPC;
                   dsNewFile(Ctr).AMPGID  = rtvSDFACT.AMPGID;

                   dow sqlCod = NO_ERROR;

                      exec sql fetch next from P5 into :dsSDFACT;

                      if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                        and sqlCod <> NO_COLUMN;
                         dBkey = *Blanks;
                         dBFile = 'SDFACTX0';
                         dBase = 004;
                         dBPgm  = 'SMU00510';
                         exsr *pssr;
                       endif;

                       Ctr = Ctr + 1;

                       exsr retrieveSDFACTPD;

                       dsNewFile(Ctr).AMFCTY =  dsSDFACT.X0AMFCTY;
                       dsNewFile(Ctr).AMCLAS =  dsSDFACT.X0AMCLAS;
                       dsNewFile(Ctr).AMLCD  =  BJRDNB;
                       dsNewFile(Ctr).AMTYLC  = 'I';
                       dsNewFile(Ctr).AMFCNM  = rtvSDFACT.AMFCNM;
                       dsNewFile(Ctr).AMZONE  = rtvSDFACT.AMZONE;
                       dsNewFile(Ctr).AMIUSR  = rtvSDFACT.AMIUSR;
                       dsNewFile(Ctr).AMAUSR  = rtvSDFACT.AMAUSR;
                       dsNewFile(Ctr).AMXUSR  = rtvSDFACT.AMXUSR;
                       dsNewFile(Ctr).AMAACC  = rtvSDFACT.AMAACC;
                       dsNewFile(Ctr).AMEACC  = rtvSDFACT.AMEACC;
                       dsNewFile(Ctr).AMGPDT  = rtvSDFACT.AMGPDT;
                       dsNewFile(Ctr).QQAMPC  = rtvSDFACT.QQAMPC;
                       dsNewFile(Ctr).AMPGID  = rtvSDFACT.AMPGID;

                   enddo;
                   LastRecord = Ctr;
                   File1 = OldLibrary + '/SDFACTX0';
                   Count1 = Ctr;
                   exec sql close P5;

                   //Delete records from SDFACTPD;
                   exsr deleteSDFACTPD;

                   //Insert records into SDFACTPD;
                   exsr insertSDFACTPD;
                   File2 = NewLibrary + '/SDFACTPD';
                   Count2 = LastRecord;
                   Count3 = LastRecord;

                   //Print Audit Report
                   exsr PrintReport;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // retrieveSDFACTPD                                           *
       //                                                            *
       // Called by: migrateSDFACTPD                                 *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr retrieveSDFACTPD;

                  PrevSQLCod = SQLCOD;
                  clear   rtvSDFACT;
                  wSQLStr = 'select * from ' + NewLibrary +
                    '/SDFACTPD' +
                            ' where AMFCTY= ' + QUO +
                            dsSDFACT.X0AMFCTY + QUO;

                   exec sql prepare P6 from :wSQLStr;
                   exec sql declare P6 cursor for P6;
                   exec sql open P6;
                   exec sql fetch next from P6 into :rtvSDFACT;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                      and sqlCod <> NO_COLUMN;
                      dBkey = *Blanks;
                      dBFile = 'SDFACTPD';
                      dBase = 005;
                      dBPgm  = 'SMU00510';
                      exsr *pssr;
                   endif;

                   if sqlCod = NO_COLUMN;
                      leavesr;
                   endif;

                   exec sql close P6;
                   SQLCOD = PrevSQLCod;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // deleteSDFACTPD                                             *
       //                                                            *
       // Called by: migrateSDFACTPD                                 *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr deleteSDFACTPD;

                  for i = 1 to LastRecord;
                      wSqlStr = 'delete from ' + NewLibrary +
                        '/SDFACTPD ' +
                                'where AMFCTY = ' + QUO +
                                dsNewFile(i).AMFCTY + QUO;
                      exec sql
                      execute immediate :wSqlStr;

                      if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                         and sqlCod <> NO_COLUMN;
                        dBase    = 006;
                        dBfile   = 'SDFACTPD';
                         dBkey    = *BLANKS;
                        dBpgm    = 'SMU00510';
                        exsr *pssr;
                     endif;

                     if sqlCod = NO_COLUMN;
                         leavesr;
                     endif;

                  endfor;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // insertSDFACTPD                                             *
       //                                                            *
       // Called by: migrateSDFACTPD                                 *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr insertSDFACTPD;

                  for i = 1 to LastRecord;

                      insSDFACT   =   dsNewFile(i);
                      exec sql insert into SDFACTPD
                          values (:insSDFACT);
                       if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                          and sqlCod <> NO_COLUMN;
                          dBase    = 007;
                          dBfile   = 'SDFACTPD';
                          dBkey    = *BLANKS;
                          dBpgm    = 'SMU00510';
                          exsr *pssr;
                       endif;

                       if sqlCod = NO_COLUMN;
                         leavesr;
                     endif;

                  endfor;

       endsr;



       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // printReport;                                               *
       //                                                            *
       // Called by: Various subroutines                             *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr printReport;

                   write headau;

                   if count1 <> 0
                       or
                         count2  <> 0
                           or
                             count3 <> 0;
                      write control;
                   else;
                      write nodtls;
                   endif;

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


                   pOption = '*FIRST';
                   pReturnCode = *Blanks;

                  callp ACCESS_SDBANK(
                                  pReturnCode
                                : pOption
                                : dsfdy
                               );
                   SDBANK = dsfdy;

                   if pReturnCode <> *blanks;
                      dBase    = 008;
                      dBfile   = 'SDBANKPD';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00510';
                      exsr *pssr;
                   endif;

                   Count1 = 0;
                   Count2 = 0;
                   Count3 = 0;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // printError;                                                *
       //                                                            *
       // Called by: Various subroutines                             *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr printError;

                   write headau;

                   write dberror;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   *pssr - Standard Error Handler                           *
       //                                                            *
       //   Called By: Main Processing, various subroutines          *
       //                                                            *
       //*************************************************************

       begsr *pssr;
                   exsr printError;
                   *inu7 = *on;
                   *inu8 = *on;
                   *Inlr = *on;
                   dump;
                   return;
       endsr;

       //**************************************************************

      /end-free
      *****************************************************************
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2022
