     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update SDFACTPD')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Midas CAR Migration Program                          *
      *                                                               *
      *  SMU00202 - Midas SM Update SDFACTPD Program                  *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD061009           Date 23Jan23               *
      *  Prev Amend No. MD060092 *CREATE   Date 01Aug22               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD061009 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD060092 - Revert CLE138 changes in SDFACTPD, AOFACTR0 and   *
      *             SD Facility Type Maintenance. Apply CLE138        *
      *             design of SDFACTX0 to store facility classes.     *
      *                                                               *
      *****************************************************************
      *
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
     D Main            pr                  extpgm('SMU00202')
     D  Param                         6a
     D Main            pi
     D  Param                         6a

      *  +----------------+
      ** |Parameter lists |
      ** +----------------+

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      *

      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+

     D NOT_EXIST       c                   const(-204)
     D NO_ERROR        c                   const(0)
     D NO_RECORD       c                   const(100)
     D NOT_FOUND       c                   const(-204)
     D NO_COLUMN       c                   const(-205)
     D DUPLICATE       c                   const(-803)
     D QUO             c                   const('''')

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+

     D Count1          s              5  0 inz(*zeros)
     D Count2          s              5  0 inz(*zeros)
     D workLib         s             10a
     D wSqlStr         s           2000a   inz(*blanks)
     D thisFile        s             20a
     D thatFile        s             20a
     D wkAHNORC        s              5  0 inz(*zeros)
     D wkNREC          s              5  0 inz(*zeros)

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
                         Commit    = *None,
                         UsrPrf    = *Owner,
                         DynUsrPrf = *Owner,
                         Datfmt    = *iso,
                         CloSqlCsr = *EndMod;

                   select;

                        when Param = 'GLOBAL';
                             exsr processGLOBAL;

                        when Param = 'ZONEDL';
                             exsr processZONEDL;

                        when Param = 'ZONEPT';
                             exsr processZONEPT;

                   endsl;

                   *Inlr = *On;
                   return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   processGLOBAL;                                           *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       begsr processGLOBAL;

                  // Copy distinct GZSDFACTPD type, class and zone to QTEMP/SMFACTF1
                  thisFile = 'QTEMP/SMFACTF1';
                  thatFile = 'GZSDFACTPD';

                   wSqlStr = 'INSERT INTO ' + %TRIM(thisFile) +
                              ' SELECT ' +
                               ' AMFCTY, ' +
                               ' AMLCD,  ' +
                               ' AMTYLC, ' +
                               ' AMFCNM, ' +
                               ' AMZONE, ' +
                               ' AMIUSR, ' +
                               ' AMAUSR, ' +
                               ' AMXUSR, ' +
                               ' AMAACC, ' +
                               ' AMEACC, ' +
                               ' AMGPDT, ' +
                               ' QQAMPC, ' +
                               ' AMPGID, ' +
                               ' AMCLAS  ' +
                               ' FROM    ' +
                               '( SELECT GZSDFACTPD.*, ROW_NUMBER()' +
                               ' OVER (PARTITION BY AMFCTY, AMZONE ORDER ' +
                               ' BY AMFCTY, AMZONE) AS RECNO' +
                               ' FROM GZSDFACTPD) AS TBL WHERE RECNO =1';

                   exec sql
                   execute immediate :wSqlStr;
                   if sqlCod <> NO_ERROR;
                      dBase    = 001;
                      dBfile   = 'GZSDFACTPD';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00202';
                      exsr *pssr;
                   endif;

                   //delete records from GZSDFACTPD which does not exist in SMFACTF1
                   wSqlStr = 'DELETE FROM ' + %TRIM(thatFile) +
                              ' A WHERE NOT EXISTS (' +
                               'SELECT * FROM ' + %TRIM(thisFile) +
                               ' B WHERE ' +
                               ' A.AMZONE = B.AMZONE AND ' +
                               ' A.AMFCTY = B.AMFCTY AND ' +
                               ' A.AMCLAS = B.AMCLAS) ';

                   exec sql
                   execute immediate :wSqlStr;
                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 002;
                      dBfile   = 'GZSDFACTPD';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00202';
                      exsr *pssr;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   processZONEDL;                                           *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       begsr processZONEDL;

                  exsr copySDFACT_to_File2;

                  exsr createSMFACTF3;

                  exsr copySDFACT_to_File3;

                  exsr deleteSDFACTPD;

                  exsr deleteTABLETQ;

                  exsr updateSDFCTLPA;

                  exsr updateTABLETX;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   copySDFACT_to_File2;                                     *
       //                                                            *
       //   Called By: processZONEDL                                 *
       //                                                            *
       //*************************************************************

       begsr copySDFACT_to_File2;

                  thisFile = 'QTEMP/SMFACTF2';
                  wSqlStr = 'INSERT INTO ' + %TRIM(thisFile) +
                              ' SELECT ' +
                               ' AMFCTY, ' +
                               ' AMLCD,  ' +
                               ' AMTYLC, ' +
                               ' AMFCNM, ' +
                               ' AMZONE, ' +
                               ' AMIUSR, ' +
                               ' AMAUSR, ' +
                               ' AMXUSR, ' +
                               ' AMAACC, ' +
                               ' AMEACC, ' +
                               ' AMGPDT, ' +
                               ' QQAMPC, ' +
                               ' AMPGID, ' +
                               ' AMCLAS  ' +
                               ' FROM    ' +
                               '( SELECT SDFACTPD.*, ROW_NUMBER()' +
                               ' OVER (PARTITION BY AMFCTY, AMZONE ORDER ' +
                               ' BY AMFCTY, AMZONE) AS RECNO' +
                               ' FROM SDFACTPD) AS TBL WHERE RECNO =1';

                   exec sql
                   execute immediate :wSqlStr;
                   if sqlCod <> NO_ERROR;
                      dBase    = 003;
                      dBfile   = 'SDFACTPD';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00202';
                      exsr *pssr;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   copySDFACT_to_File3;                                     *
       //                                                            *
       //   Called By: processZONEDL                                 *
       //                                                            *
       //*************************************************************

       begsr copySDFACT_to_File3;

                  thisFile = 'QTEMP/SMFACTF3';
                  thatFile = 'SDFACTPD';

                  wSqlStr = 'INSERT INTO ' + %TRIM(thisFile) +
                              ' SELECT ' +
                               ' AMFCTY, ' +
                               ' AMCLAS  ' +
                               ' FROM    ' + %TRIM(thatFile) +
                               ' WHERE AMCLAS <> ' + QUO + ' ' + QUO;

                   exec sql
                   execute immediate :wSqlStr;
                   if sqlCod <> NO_ERROR
                      and   sqlCod <> NO_RECORD;
                      dBase    = 004;
                      dBfile   = 'SDFACTPD';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00202';
                      exsr *pssr;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   createSMFACTF3;                                          *
       //                                                            *
       //   Called By: processZONEDL                                 *
       //                                                            *
       //*************************************************************

       begsr createSMFACTF3;

                    workLib =  'QTEMP';
                    wSqlStr = ('create table ' +
                               %trim(workLib) +
                              '/SMFACTF3 +
                               ( AMFCTY CHAR(3) ,   +
                                 AMCLAS CHAR(4) +
                               )'
                               );
                   exec sql
                   execute immediate :wSqlStr;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   deletSDFACTPD;                                           *
       //                                                            *
       //   Called By: processZONEDL                                 *
       //                                                            *
       //*************************************************************

       begsr deleteSDFACTPD;

                   thisFile = 'QTEMP/SMFACTF2';
                   thatFile = 'SDFACTPD';

                   //delete records from SDFACTPD which does not exist in SMFACTF2

                   wSqlStr = 'DELETE FROM ' + %TRIM(thatFile) +
                              ' A WHERE NOT EXISTS (' +
                               'SELECT * FROM ' + %TRIM(thisFile) +
                               ' B WHERE ' +
                               ' A.AMFCTY = B.AMFCTY AND ' +
                               ' A.AMCLAS = B.AMCLAS) ';

                   exec sql
                   execute immediate :wSqlStr;
                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 005;
                      dBfile   = 'SDFACTPD';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00202';
                      exsr *pssr;
                   endif;
                   Count1 = SQLER3;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   deletTABLETQ;                                            *
       //                                                            *
       //   Called By: processZONEDL                                 *
       //                                                            *
       //*************************************************************

       begsr deleteTABLETQ;

                   thisFile = 'QTEMP/SMFACTF2';
                   thatFile = 'TABLETQ';

                   //delete records from TABLETQ which does not exist in SMFACTF2
                   wSqlStr = 'DELETE FROM ' + %TRIM(thatFile) +
                              ' A WHERE NOT EXISTS (' +
                               'SELECT * FROM ' + %TRIM(thisFile) +
                               ' B WHERE ' +
                               ' A.FACT = B.AMFCTY AND ' +
                               ' A.FCLS = B.AMCLAS) ';

                   exec sql
                   execute immediate :wSqlStr;
                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 006;
                      dBfile   = 'SDFACTPD';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00202';
                      exsr *pssr;
                   endif;
                   Count2 = SQLER3;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   updateSDFCTLPA;                                          *
       //                                                            *
       //   Called By: processZONEDL                                 *
       //                                                            *
       //*************************************************************

       begsr updateSDFCTLPA;

                   thisFile = 'QTEMP/SMFACTF2';
                   thatFile = 'SDFCTLPA';

                   // Retrieve value of AHNORC in SDFCTLPA
                 //wSQLStr = 'select AHNORC from SDFCTLPA' +                              //MD061009
                 //          ' where AHFLNM = ' + QUO + 'SDFACTPD' +                      //MD061009
                 //          QUO;                                                         //MD061009
                   wSQLStr = 'select AHNORC from SDCTLXTD' +                              //MD061009
                             ' where AHFLNM = ' + QUO + 'SDFACTPD' +                      //MD061009
                             QUO;                                                         //MD061009
                   exec sql close P0;
                   exec sql prepare P0 from :wSQLStr;
                   exec sql declare P0 cursor for P0;
                   exec sql open P0;
                   exec sql fetch next From P0 into :wkAHNORC;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 007;
                      dBfile   = 'SDFCTLPA';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00202';
                      exsr *pssr;
                   endif;

                   wkAHNORC = wkAHNORC - Count1;

                  //wSQLStr = 'update SDFCTLPA' +                                         //MD061009
                  //          ' set AHNORC = ' + %Char(wkAHNORC) +                        //MD061009
                  //         ' where AHFLNM = ' + QUO + 'SDFACTPD' +                      //MD061009
                  //         QUO;                                                         //MD061009
                    wSQLStr = 'update SDCTLXTD' +                                         //MD061009
                              ' set AHNORC = ' + %Char(wkAHNORC) +                        //MD061009
                             ' where AHFLNM = ' + QUO + 'SDFACTPD' +                      //MD061009
                             QUO;                                                         //MD061009
                   exec sql
                   execute immediate :wSqlStr;
                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 008;
                      dBfile   = 'SDFCTLPA';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00202';
                      exsr *pssr;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   updateTABLETX;                                           *
       //                                                            *
       //   Called By: processZONEDL                                 *
       //                                                            *
       //*************************************************************

       begsr updateTABLETX;

                   thisFile = 'QTEMP/SMFACTF2';
                   thatFile = 'TABLETX';

                   // Retrieve value of NREC field from TABLETX
                   wSQLStr = 'select NREC  from TABLETX' +
                             ' where RECT = 46';

                   exec sql close P1;
                   exec sql prepare P1 from :wSQLStr;
                   exec sql declare P1 cursor for P1;
                   exec sql open P1;
                   exec sql fetch next From P1 into :wkNREC;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 009;
                      dBfile   = 'TABLETX';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00202';
                      exsr *pssr;
                   endif;

                   wkNREC   = wkNREC   - Count2;

                   wSQLStr = 'update TABLETX' +
                              ' set NREC   = ' + %Char(wkNREC) +
                             ' where RECT  = 46';
                   exec sql
                   execute immediate :wSqlStr;
                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 010;
                      dBfile   = 'TABLETX';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00202';
                      exsr *pssr;
                   endif;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   processZONEPT;                                           *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       begsr processZONEPT;

                  thisFile = 'QTEMP/SMFACTF3';
                  thatFile = 'SDFACTX0';

                  wSqlStr = 'INSERT INTO ' + %TRIM(thatFile) +
                              ' SELECT ' +
                               ' AMFCTY, ' +
                               ' AMCLAS  ' +
                               ' FROM    ' + %TRIM(thisFile);

                   exec sql
                   execute immediate :wSqlStr;
                   if sqlCod <> NO_ERROR
                      and   sqlCod <> NO_RECORD;
                      dBase    = 011;
                      dBfile   = 'SDFACTX0';
                      dBkey    = *blanks;
                      dBpgm    = 'SMU00202';
                      exsr *pssr;
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
