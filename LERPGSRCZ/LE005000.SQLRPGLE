     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Initialisation program for CLE138')           *
      *****************************************************************
      *                                                               *
      *  Midas - Midas LE CLE138 Initialisation Program               *
      *                                                               *
      *  LE005000 - Midas LE CLE138 Initialisation Program            *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CLE138  *CREATE    Date 02Nov21               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CLE138 - Class Codes for Facilities.                         *
      *                                                               *
      *****************************************************************
      *
      ** Past Due Call Loans Account Keys Generated Report
     FLE005000AUO    E             PRINTER INFDS(SPOOL1)
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
      ** SDTCLDPD
     D SDTCLDDS      e ds                  extname(SDTCLDPD)
     D dsSDTCLD        ds                  likeds(SDTCLDDS)
      ** SDTCLSPD
     D SDTCLSDS      e ds                  extname(SDTCLSPD)
     D dsSDTCLS        ds                  likeds(SDTCLSDS)
      ** SDFACTPD
     D SDFACTPDDS    e ds                  extname(SDFACTPD)
     D dsFACTPD        ds                  likeds(SDFACTPDDS)
      ** ACKEYAL
     D ACKEYALDS     e ds                  extname(ACKEYAL)
     D dsACKEYAL       ds                  likeds(ACKEYALDS)
      ** PSTTOM
     D PSTTOMDS      e ds                  extname(PSTTOM)
     D                                     prefix(P_)
     D dsPSTTOM        ds                  likeds(PSTTOMDS)

      ** Core data structures
     D dssdy         e ds                  extname(DSSDY)
     D dsfdy         e ds                  extname(DSFDY)
     D SDBANK        e ds                  extname(SDBANKPD)
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
     D BLK_CLASS       c                   const('    ')
     D CONST_CLASS     c                   const('XXXX')

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D wSqlStr         s           2000a   inz(*blanks)
     D pReturnCode     s              7a
     D pOption         s              7a
     D DefaultClass    s              4a
     D processRecord   s               n
     D currentAKEY     s             14a
     D newAKEY         s             14a
     D facilityClass   s              4a
     D PrevSQLCod      s             10s 0
     D CurFacTyp       s              3a
     D FileToUpdate    s             10a

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

                   // Call subroutine to start initialisation of files
                   exsr startInitialisation;

                   *Inlr = *On;
                   return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // startInitialisation - Start initialisation of files        *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: initialiseSDTCLDPD, initialiseSDTCLSPD,            *
       //         initialiseLEFEED, initialiseLEFCLTQD,              *
       //         initialiseTABLETQ, initialiseSDFACTPD,             *
       //         initialiseLEAGFTQD, initialiseLEFCAMQD,            *
       //         initialiseACKEYAL                                  *
       //                                                            *
       //*************************************************************

       begsr startInitialisation;

                   //Call subroutine to initialise Midas SD Transaction Class Defaults
                   exsr initialiseSDTCLDPD;

                   //Call subroutine to initialise Midas SD Transaction Class
                   exsr initialiseSDTCLSPD;

                   //Call subroutine to initialise Midas LE Fees master detail
                   exsr initialiseLEFEED;

                   //Call subroutine to initialise Midas SD Table File - Facility Types
                   exsr initialiseTABLETQ;

                   //Call subroutine to initialise Midas SD Facility Type Class
                   exsr initialiseSDFACTPD;

                   //Call subroutine to initialise Midas LE Facilities Extension File
                   exsr initialiseLEFCLTQD;

                   //Call subroutine to initialise Midas LE Aggregate Facilities Trailer
                   exsr initialiseLEAGFTQD;

                   //Call subroutine to initialise Midas LE Facility amendment extension file
                   exsr initialiseLEFCAMQD;

                   //Call subroutine to initialise Midas LE Agg. Facility
                   //Amendment Trans Ext extension file
                   exsr initialiseLEAGAMQD;

                   //Call subroutine to initialise Midas LE Facility history header
                   exsr initialiseFACHISH;

                   //Call subroutine to initialise Midas LE Facility amounts
                   exsr initialiseFACHISA;

                   //Call subroutine to initialise account keys
                   exsr initialiseACKEYAL;

                   //Call subroutine to initialise fees tomorrows acct keys
                   exsr initialisePSTTOM;

                   //Call Print Audit Report
                   exsr printReport;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialiseSDTCLDPD                                         *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr initialiseSDTCLDPD;

                   // Check if there is a record in SDTCLDPD
                   wSQLStr = 'select * from SDTCLDPD';
                   exec sql close P0;
                   exec sql prepare P0 from :wSQLStr;
                   exec sql declare P0 cursor for P0;
                   exec sql open P0;
                   exec sql fetch next From P0 into :dsSDTCLD;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                      and sqlCod  <> NO_COLUMN;
                      dBase    = 001;
                      dBfile   = 'SDTCLDPD';
                      dBkey    = *blanks;
                      dBpgm    = 'LE005000';
                      exsr *pssr;
                   endif;

                   if sqlCod = NO_COLUMN;
                      COL1 = 'LECLAS';
                      ERRMSG1 = 'COLUMN DOES NOT EXIST';
                      leavesr;
                   endif;

                   if sqlCod = NO_RECORD;

                      //No record? then write a record with 'XXXX' as default value
                      DefaultClass = CONST_CLASS;
                      dsSDTCLD.LECLAS = CONST_CLASS;
                      exec sql insert into SDTCLDPD
                          values (:dsSDTCLD);
                          if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                             dBase    = 002;
                             dBfile   = 'SDTCLDPD';
                             dBkey    = *blanks;
                             dBpgm    = 'LE005000';
                             exsr *pssr;
                          endif;
                          Count7 = SQLER3;
                   else;

                      if dsSDTCLD.LECLAS <> *blanks;
                         // Retrieve the default class from SDTCLDPD.LECLAS
                         DefaultClass = dsSDTCLD.LECLAS;
                         Count7 = 1;
                      else;
                         // Record exist, however LE class is not define. Default the
                         // LE class with 'XXXX' and update the record
                         DefaultClass = CONST_CLASS;
                         dsSDTCLD.LECLAS = CONST_CLASS;
                         //Update SDTCLDPD record
                         wSqlStr = 'update SDTCLDPD A SET ' +
                                   'A.LECLAS = ' + QUO + dsSDTCLD.LECLAS + QUO;
                         exec sql
                         execute immediate :wSqlStr;
                         Count7 = SQLER3;
                         if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                            dBase    = 003;
                            dBfile   = 'SDTCLDPD';
                            dBkey    = *blanks;
                            dBpgm    = 'LE005000';
                            exsr *pssr;
                         endif;
                      endif;
                   endif;
                   exec sql close P0;
                   DFTCLAS = DefaultClass;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialiseSDTCLSPD                                         *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr initialiseSDTCLSPD;

                   // Check if there is a record in SDTCLSPD
                   wSQLStr = 'select * from SDTCLSPD' +
                             ' where TCCLAS = ' + QUO + CONST_CLASS + QUO;
                   exec sql close P1;
                   exec sql prepare P1 from :wSQLStr;
                   exec sql declare P1 cursor for P1;
                   exec sql open P1;
                   exec sql fetch next From P1 into :dsSDTCLS;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                      and sqlCod <> NO_COLUMN;
                      dBase    = 004;
                      dBfile   = 'SDTCLSPD';
                      dBkey    = *blanks;
                      dBpgm    = 'LE005000';
                      exsr *pssr;
                   endif;

                   if sqlCod = NO_COLUMN;
                      COL2 = 'TCCLAS';
                      ERRMSG2 = 'COLUMN DOES NOT EXIST';
                      leavesr;
                   endif;

                   if sqlCod = NO_RECORD;

                      //No record? then write a record with 'XXXX' as default value
                      dsSDTCLS.TCCLAS = CONST_CLASS;
                      dsSDTCLS.TCCDSC = '** NAME REQUIRED **';
                      dsSDTCLS.TCLCD  = BJRDNB;
                      dsSDTCLS.TCTYLC = 'I';

                      exec sql insert into SDTCLSPD
                          values (:dsSDTCLS);
                          if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                             dBase    = 005;
                             dBfile   = 'SDTCLSPD';
                             dBkey    = *blanks;
                             dBpgm    = 'LE005000';
                             exsr *pssr;
                          endif;
                          Count8 = SQLER3;
                   endif;
                   exec sql close P1;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialiseLEFEED                                           *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr initialiseLEFEED;

                         //Update LEFEED
                         wSqlStr = 'update LEFEED A SET ' +
                                   'A.FECLAS = ' + QUO + DefaultClass + QUO +
                                   ' where A.FELOAN = ' + QUO + '      ' + QUO;
                         exec sql
                         execute immediate :wSqlStr;
                         Count1 = SQLER3;
                         if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                            and sqlCod <>  NO_COLUMN;
                            dBase    = 006;
                            dBfile   = 'LEFEED';
                            dBkey    = *blanks;
                            dBpgm    = 'LE005000';
                            exsr *pssr;
                         endif;

                         if sqlCod = NO_COLUMN;
                            COL9 = 'FECLAS';
                            ERRMSG9 = 'COLUMN DOES NOT EXIST';
                            leavesr;
                         endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialiseSDFACTPD                                         *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr initialiseSDFACTPD;

                         //Update SDFACTPD
                         wSqlStr = 'update SDFACTPD A SET ' +
                                   'A.AMCLAS = ' + QUO + DefaultClass + QUO +
                                   ' where A.AMCLAS =  ' + QUO + BLK_CLASS
                                     +  QUO;
                         exec sql
                         execute immediate :wSqlStr;
                         Count12 = SQLER3;
                         if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                            and sqlCod <> NO_COLUMN
                            and sqlCod <> DUPLICATE;
                            dBase    = 007;
                            dBfile   = 'SDFACTPD';
                            dBkey    = *blanks;
                            dBpgm    = 'LE005000';
                            exsr *pssr;
                         endif;

                          if sqlCod = NO_COLUMN;
                            COL12 = 'AMCLAS';
                            ERRMSG12 = 'COLUMN DOES NOT EXIST';
                            leavesr;
                         endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialiseTABLETQ                                          *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr initialiseTABLETQ;

                         //Update TABLETQ
                         wSqlStr = 'update TABLETQ A SET ' +
                                   'A.FCLS = ' + QUO + DefaultClass + QUO +
                                   ' where A.FCLS =  ' + QUO + BLK_CLASS
                                     +  QUO;
                         exec sql
                         execute immediate :wSqlStr;
                         Count13 = SQLER3;
                         if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                            and sqlCod <> NO_COLUMN;
                            dBase    = 007;
                            dBfile   = 'SDFACTPD';
                            dBkey    = *blanks;
                            dBpgm    = 'LE005000';
                            exsr *pssr;
                         endif;

                          if sqlCod = NO_COLUMN;
                            COL13 = 'AMCLAS';
                            ERRMSG13 = 'COLUMN DOES NOT EXIST';
                            leavesr;
                         endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialiseLEFCLTQD                                         *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr initialiseLEFCLTQD;

                         //Update LEFCLTQD
                         wSqlStr = 'update LEFCLTQD A SET ' +
                                     'A.FCXCLS = ' + QUO + DefaultClass + QUO +
                                     ' where A.FCXCLS =  ' + QUO + BLK_CLASS
                                     +  QUO;
                         exec sql
                         execute immediate :wSqlStr;
                         Count3 = SQLER3;
                         if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                           and sqlCod <> NO_COLUMN;
                            dBase    = 008;
                            dBfile   = 'LEFCLTQD';
                            dBkey    = *blanks;
                            dBpgm    = 'LE005000';
                            exsr *pssr;
                         endif;

                         if sqlCod = NO_COLUMN;
                            COL4 = 'FCXCLS';
                            ERRMSG4 = 'COLUMN DOES NOT EXIST';
                            leavesr;
                         endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialiseLEAGFTQD                                         *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr initialiseLEAGFTQD;

                         //Update LEAGFTQD
                         wSqlStr = 'update LEAGFTQD A SET ' +
                                   'A.FCXCLS = ' + QUO + DefaultClass + QUO +
                                   ' where A.FCXCLS =  ' + QUO + BLK_CLASS
                                     +  QUO;
                         exec sql
                         execute immediate :wSqlStr;
                         Count4 = SQLER3;
                         if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                            and SqlCod <> NO_COLUMN;
                            dBase    = 009;
                            dBfile   = 'LEAGFTQD';
                            dBkey    = *blanks;
                            dBpgm    = 'LE005000';
                            exsr *pssr;
                         endif;

                         if sqlCod = NO_COLUMN;
                            COL5 = 'FCXSLC';
                            ERRMSG5 = 'COLUMN DOES NOT EXIST';
                            leavesr;
                         endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialiseLEFCAMQD                                         *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr initialiseLEFCAMQD;

                         //Update LEFCAMQD
                         wSqlStr = 'update LEFCAMQD A SET ' +
                                   'A.FACLAS = ' + QUO + DefaultClass + QUO +
                                    ' where A.FACLAS =  ' + QUO + BLK_CLASS
                                     +  QUO;
                         exec sql
                         execute immediate :wSqlStr;
                         Count5 = SQLER3;
                         if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                            and sqlCod <> NO_COLUMN;
                            dBase    = 010;
                            dBfile   = 'LEFCAMQD';
                            dBkey    = *blanks;
                            dBpgm    = 'LE005000';
                            exsr *pssr;
                         endif;

                         if sqlCod = NO_COLUMN;
                            COL6 = 'FACLAS';
                            ERRMSG6 = 'COLUMN DOES NOT EXIST';
                            leavesr;
                         endif;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialiseLEAGAMQD                                         *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr initialiseLEAGAMQD;

                         //Update LEAGAMQD
                         wSqlStr = 'update LEAGAMQD A SET ' +
                                   'A.FACLAS = ' + QUO + DefaultClass + QUO +
                                    ' where A.FACLAS =  ' + QUO + BLK_CLASS
                                     +  QUO;
                         exec sql
                         execute immediate :wSqlStr;
                         Count9 = SQLER3;
                         if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                            and sqlCod <>  NO_COLUMN;
                            dBase    = 011;
                            dBfile   = 'LEAGAMQD';
                            dBkey    = *blanks;
                            dBpgm    = 'LE005000';
                            exsr *pssr;
                         endif;

                         if sqlCod = NO_COLUMN;
                            COL7 = 'FACLAS';
                            ERRMSG7 = 'COLUMN DOES NOT EXIST';
                            leavesr;
                         endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialiseFACHISH                                          *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr initialiseFACHISH;

                         //Update FACHISH
                         wSqlStr = 'update FACHISH A SET ' +
                                   'A.FHFCLS = ' + QUO + DefaultClass + QUO +
                                   ',' +
                                   'A.FHPCLS = ' + QUO + DefaultClass + QUO +
                                   ' where A.FHFCLS =  ' + QUO + BLK_CLASS
                                     +  QUO + ' and ' +
                                   ' A.FHPCLS =  ' + QUO + BLK_CLASS
                                     +  QUO;
                         exec sql
                         execute immediate :wSqlStr;
                         Count10 = SQLER3;
                         if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                            and sqlCod <>  NO_COLUMN;
                            dBase    = 007;
                            dBfile   = 'FACHISH';
                            dBkey    = *blanks;
                            dBpgm    = 'LE005000';
                            exsr *pssr;
                         endif;

                         if sqlCod = NO_COLUMN;
                            COL10 = 'FACHISH';
                            ERRMSG10 = 'COLUMN DOES NOT EXIST';
                            leavesr;
                         endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialiseFACHISA                                          *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr initialiseFACHISA;

                         //Update FACHISH
                         wSqlStr = 'update FACHISA A SET ' +
                                   'A.FAFCLS = ' + QUO + DefaultClass + QUO +
                                   ' where FAACTN = ' + QUO + 'FS' + QUO +
                                   ' and A.FAFCLS =  ' + QUO + BLK_CLASS + QUO;
                         exec sql
                         execute immediate :wSqlStr;
                         Count11 = SQLER3;
                         if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                            and sqlCod <>  NO_COLUMN;
                            dBase    = 008;
                            dBfile   = 'FACHISA';
                            dBkey    = *blanks;
                            dBpgm    = 'LE005000';
                            exsr *pssr;
                         endif;

                         if sqlCod = NO_COLUMN;
                            COL11 = 'FACHISA';
                            ERRMSG11 = 'COLUMN DOES NOT EXIST';
                            leavesr;
                         endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialiseACKEYAL                                          *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: checkIfProcess, updateRecord                       *
       //                                                            *
       //*************************************************************

       begsr initialiseACKEYAL;

                   wSQLStr = 'select * from ACKEYAL';
                   Count6 = 0;
                   exec sql prepare P2 from :wSQLStr;
                   exec sql declare P2 cursor for P2;
                   exec sql open P2;
                   exec sql fetch next from P2 into :dsACKEYAL;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                      and SqlCod <> NO_COLUMN;
                      dBkey = *Blanks;
                      dBFile = 'ACKEYAL';
                      dBase = 012;
                      dBPgm  = 'LE005000';
                      exsr *pssr;
                   endif;

                   if sqlCod = NO_COLUMN;
                      COL8 = 'AKEY';
                      ERRMSG8 = 'COLUMN DOES NOT EXIST';
                      leavesr;
                   endif;

                   processRecord = *Off;
                   CurFacTyp = %subst(dsACKEYAL.AKEY:1:3);
                   exsr checkIfProcess;
                   if ProcessRecord;
                      FileToUpdate = 'ACKEYAL';
                      currentAKEY = dsACKEYAL.AKEY;
                      exsr updateRecord;
                   endif;


                   dow sqlCod = NO_ERROR;

                      exec sql fetch next from P2 into :dsACKEYAL;

                      if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                         and sqlCod <> NO_COLUMN;
                         dBkey = *Blanks;
                         dBFile = 'ACKEYAL';
                         dBase = 013;
                         dBPgm  = 'LE005000';
                         exsr *pssr;
                       endif;

                       if sqlCod = NO_COLUMN;
                          COL8 = 'AKEY';
                          ERRMSG8 = 'COLUMN DOES NOT EXIST';
                          leavesr;
                       endif;

                       processRecord = *Off;
                       CurFacTyp = %subst(dsACKEYAL.AKEY:1:3);
                       exsr checkIfProcess;
                       if ProcessRecord;
                          FileToUpdate = 'ACKEYAL';
                          currentAKEY = dsACKEYAL.AKEY;
                          exsr updateRecord;
                       endif;
                   enddo;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // initialisePSTTOM                                           *
       //                                                            *
       // Called by: startInitialisation                             *
       //                                                            *
       //  Calls: checkIfProcess, updateRecord                       *
       //                                                            *
       //*************************************************************

       begsr initialisePSTTOM;

                   wSQLStr = 'select * from PSTTOM';
                   Count6 = 0;
                   exec sql prepare P4 from :wSQLStr;
                   exec sql declare P4 cursor for P4;
                   exec sql open P4;
                   exec sql fetch next from P4 into :dsPSTTOM;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                      and SqlCod <> NO_COLUMN;
                      dBkey = *Blanks;
                      dBFile = 'PSTTOM';
                      dBase = 014;
                      dBPgm  = 'LE005000';
                      exsr *pssr;
                   endif;

                   if sqlCod = NO_COLUMN;
                      COL14= 'AKEY';
                      ERRMSG14= 'COLUMN DOES NOT EXIST';
                      leavesr;
                   endif;

                   processRecord = *Off;
                   CurFacTyp = %subst(dsPSTTOM.P_LKAKEY:1:3);
                   exsr checkIfProcess;
                   if ProcessRecord;
                      FileToUpdate = 'PSTTOM';
                      currentAKEY = dsPSTTOM.P_LKAKEY;
                      exsr updateRecord;
                   endif;


                   dow sqlCod = NO_ERROR;

                      exec sql fetch next from P4 into :dsPSTTOM;

                      if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                         and sqlCod <> NO_COLUMN;
                         dBkey = *Blanks;
                         dBFile = 'PSTTOM';
                         dBase = 015;
                         dBPgm  = 'LE005000';
                         exsr *pssr;
                       endif;

                       if sqlCod = NO_COLUMN;
                          COL14= 'AKEY';
                          ERRMSG14= 'COLUMN DOES NOT EXIST';
                          leavesr;
                       endif;

                       processRecord = *Off;
                       CurFacTyp = %subst(dsPSTTOM.P_LKAKEY:1:3);
                       exsr checkIfProcess;
                       if ProcessRecord;
                          FileToUpdate = 'PSTTOM';
                          currentAKEY = dsPSTTOM.P_LKAKEY;
                          exsr updateRecord;
                       endif;
                   enddo;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // checkIfProcess                                             *
       //                                                            *
       // Called by: initialiseACKEYAL, initialisePSTTOM             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr checkIfProcess;
                   PrevSQLCod = SQLCOD;
                   wSQLStr = 'select * from SDFACTPD A' +
                             ' where A.AMFCTY = ' + QUO +
                             CurFacTyp + QUO;

                   exec sql prepare P3 from :wSQLStr;
                   exec sql declare P3 cursor for P3;
                   exec sql open P3;
                   exec sql fetch next from P3 into :dsFACTPD;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dBase    = 016;
                      dBfile   = 'SDFACTPD';
                      dBkey    = *blanks;
                      dBpgm    = 'LE005000';
                      exsr *pssr;
                   endif;

                  if sqlCod =  NO_RECORD;
                     processRecord = *Off;
                  else;
                     processRecord = *On;
                     facilityClass =   dsFACTPD.AMCLAS;
                  endif;
                  exec sql close P3;
                  SQLCOD = PrevSQLCod;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // updateRecord                                               *
       //                                                            *
       // Called by: initialiseACKEYAL, initialisePSTTOM             *
       //                                                            *
       //  Calls: none                                               *
       //                                                            *
       //*************************************************************

       begsr updateRecord;
                   PrevSQLCod = SQLCOD;
                   if FileToUpdate = 'ACKEYAL';
                      Count6 = Count6 + 1;
                      newAKEY = %replace(facilityCLASS:dsACKEYAL.AKEY:11);
                      wSQLStr = 'update ACKEYAL A' +
                                ' set AKEY = ' + QUO + NewAKEY + QUO +
                                ' where A.AKEY = ' + QUO + currentAKEY + QUO;

                      exec sql
                      execute immediate :wSqlStr;

                      if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                         and sqlCod <> DUPLICATE;
                         dBase    = 017;
                         dBfile   = 'ACKEYAL';
                         dBkey    = *blanks;
                         dBpgm    = 'LE005000';
                         exsr *pssr;
                      endif;
                   else;
                      Count14 = Count14 + 1;
                      newAKEY = %replace(facilityCLASS:dsPSTTOM.P_LKAKEY:11);
                      wSQLStr = 'update PSTTOM  A' +
                                ' set LKAKEY = ' + QUO + NewAKEY + QUO +
                                ' where A.LKAKEY = ' + QUO + currentAKEY + QUO;

                      exec sql
                      execute immediate :wSqlStr;

                      if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                         and sqlCod <> DUPLICATE;
                         dBase    = 018;
                         dBfile   = 'PSTTOM';
                         dBkey    = *blanks;
                         dBpgm    = 'LE005000';
                         exsr *pssr;
                      endif;
                   endif;
                   SQLCOD = PrevSQLCod;
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
                      count3 <> 0
                      or
                      count4  <> 0
                      or
                      count5 <> 0
                      or
                      count6  <> 0
                      or
                      count7 <> 0
                      or
                      count8 <> 0;

                      write control;

                   else;

                      write nodtls;

                   endif;

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
                      dBase    = 018;
                      dBfile   = 'SDBANKPD';
                      dBkey    = *blanks;
                      dBpgm    = 'LE005000';
                      exsr *pssr;
                   endif;

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
