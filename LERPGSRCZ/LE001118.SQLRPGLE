     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE CLE071 Takeon program for calculated fees')   *
      *****************************************************************
      *                                                               *
      *  Midas - Midas LE CLE071 Takeon program for calculated fees   *
      *                                                               *
      *  LE001118 - Midas LE CLE071 Takeon program for                *
      *             calculated fees                                   *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD062082 *CREATE   Date 24Dec23               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD062082 - CLE071 Takeon program for calculated fees         *
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
      ** LEFEED
     D SDLEFEED      e ds                  extname(LEFEED)
     D  wFENLAI      e                     extfld(FENLAI)
     D dsLEFEED        ds                  likeds(SDLEFEED)

      ** LEFHST
     D HistoryFile1  e ds                  extname(LEFHST)
     D                                     prefix(A_)
     D   RECNO                        8s 0
     D HistoryFile2  e ds                  extname(LEFHST)
     D                                     prefix(B_)
     D arrHist         ds                  likeds(HistoryFile1)
     D                                     dim(100)
     D dsLEFHST        ds                  likeds(HistoryFile2)

      ** Core data structures
     D dsfdy         e ds                  extname(DSFDY)
     D sdbank        e ds                  extname(SDBANKPD)

      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+
     D NOT_EXIST       c                   const(-204)
     D NO_ERROR        c                   const(0)
     D NO_RECORD       c                   const(100)
     D NOT_FOUND       c                   const(-204)
     D NO_COLUMN       c                   const(-205)
     D NULL_VALUES     c                   const(-305)
     D DUPLICATE       c                   const(-803)
     D QUO             c                   const('''')
     D RATE_CHANGE     c                   const('RC')
     D IN_RECORD       c                   const('IN')
     D ACTIVE_RECORD   c                   const('D')

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+

     D Nxt             s              6s 0 inz(0)
     D Ix              s              6s 0 inz(0)
     D prevSQLCOD      s              6s 0 inz(0)
     D prevSQLMAI      s              6s 0 inz(0)
     D isExist         s               n   inz(False)
     D isFirstPass     s               n   inz(True)
     D isRateChange    s               n   inz(False)
     D MAX_ARRAY       s              8s 0 inz(100)
     D wRowsReturned   s             10s 0 inz(*zeros)
     D wSqlStr         s           2000a   inz(*blanks)
     D keyRCTP         s              2a   inz(*blanks)
     D keyBRCA         s              3a   inz(*blanks)
     D keyCNUM         s              6a   inz(*blanks)
     D keyFACL         s              5S 0 inz(0)
     D keyLNRF         s              6a   inz(*blanks)
     D keyFSEQ         s              2s 0 inz(0)
     D keyRCVD         s              5S 0 inz(0)
     D wTotal          s              6s 0 inz(0)
     D pReturnCode     s              7a   inz(*blanks)
     D pOption         s              7a   inz(*blanks)

      ** +--------------------------------------+
      ** ¦ Array declaration                    ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
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

       // Call subroutine to excute take on process
                   exsr takeOnProgram;

                   *Inlr = *On;
                   return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // takeOnProgram - Start take on program                      *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: processThisRecord                                  *
       //                                                            *
       //*************************************************************

       begsr takeOnProgram;

       //Select all live calculated fees
                   clear wSQLStr;
                   wSQLStr = 'select * from LEFEED A' +
                   ' where A.FERECI = ' + QUO + ACTIVE_RECORD + QUO +
                   ' and   A.FECALT <>  ' + QUO + ' ' + QUO +
                   ' order by A.FEBRCA,' +
                   ' A.FECNUM,' +
                   ' A.FEFACL,' +
                   ' A.FELOAN,' +
                   ' A.FEFSEQ';

                   exec sql prepare P1 from :wSQLStr;
                   exec sql declare P1 cursor for P1;
                   exec sql open P1;
                   exec sql fetch next from P1 into :dsLEFEED;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                        and SqlCod <> NO_COLUMN;
                        dBkey = *Blanks;
                        dBFile = 'LEFEED';
                        dBase = 001;
                        dBPgm  = 'LE001118';
                        exsr *pssr;
                   endif;

                   if sqlCod <> NO_RECORD;
                        exsr processThisRecord;
                   endif;

                   dow sqlCod = NO_ERROR;

                        exec sql fetch next from P1 into :dsLEFEED;

                        if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
                             and sqlCod <> NO_COLUMN;
                             dBkey = *Blanks;
                             dBFile = 'LEFEED';
                             dBase = 002;
                             dBPgm  = 'LE001118';
                             exsr *pssr;
                        endif;

                        if sqlCod <> NO_RECORD;
                             exsr processThisRecord;
                        endif;

                   enddo;

                   exec sql close P1;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // processThisRecord - Process current fee record             *
       //                                                            *
       // Called by: takeOnProgram                                   *
       //                                                            *
       //  Calls: loadArray                                          *
       //                                                            *
       //                                                            *
       //*************************************************************

       begsr processThisRecord;

                   exsr loadArray;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // loadArray - Load array from LEFHST records whose fee       *
       //             matches multiple entries from history file     *
       //                                                            *
       // Called by: processThisRecord                               *
       //                                                            *
       //  Calls: generateINRecord, processHistoryArray              *
       //                                                            *
       //*************************************************************

       begsr loadArray;

                   clear arrHist;
                   clear wSQLStr;
                   prevSQLMAI = SQLCOD;

                   wSQLStr =
                   'SELECT * FROM ' +
                   '(SELECT LEFHST.*, ' +
                   'ROW_NUMBER() OVER (PARTITION BY '  +
                   'HIBRCA, ' +
                   'HICNUM, ' +
                   'HIFACL, ' +
                   'HILNRF, ' +
                   'HIFSEQ, ' +
                   'HIHDAT ' +
                   'ORDER BY HILCHD DESC ) AS SEQNO ' +
                   'FROM LEFHST) AS RECNO ' +
                   'WHERE HIRECI = '  + QUO + ACTIVE_RECORD + QUO +
                   ' AND HIRCTP = '    + QUO + '  ' + QUO +
                   ' AND HIBRCA = '    + QUO + dsLEFEED.FEBRCA + QUO +
                   ' AND HICNUM = '    + QUO + dsLEFEED.FECNUM + QUO +
                   ' AND HIFACL = '    + %TRIM(%CHAR(dsLEFEED.FEFACL)) +
                   ' AND HILNRF = '    + QUO + dsLEFEED.FELOAN + QUO +
                   ' AND HIFCOD = '    + %TRIM(%CHAR(dsLEFEED.FEFCOD)) +
                   ' AND HIFSEQ = '    + %TRIM(%CHAR(dsLEFEED.FEFSEQ)) +
                   ' AND SEQNO = 1 ' +
                   ' ORDER by HIBRCA, ' +
                   ' HICNUM,' +
                   ' HIFACL,' +
                   ' HILNRF,' +
                   ' HIFSEQ,' +
                   ' HIHDAT';

                   exec sql prepare P2 from :wSQLStr;
                   exec sql declare P2 cursor for P2;
                   exec sql open P2;
                   exec sql fetch next from P2 for :MAX_ARRAY
                   rows into :arrHist;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                        dBkey = *Blanks;
                        dBFile = 'LEFHST';
                        dBase = 003;
                        dBPgm  = 'LE001118';
                        exsr *pssr;
                   endif;

                   wRowsReturned = SqlErrd(3);
                   exsr generateINRecord;
                   if sqlCod <> NO_RECORD;
                        exsr processHistoryArray;
                   endif;

                   dow sqlCod = NO_ERROR;

                        exec sql fetch next from P2 for :MAX_ARRAY
                        rows into :arrHist;

                        if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                             dBkey = *Blanks;
                             dBfile = 'LEFHST';
                             dBase = 004;
                             dBpgm  = 'LE001118';
                             exsr *pssr;
                        endif;

                        wRowsReturned = SqlErrd(3);
                        if sqlCod <> NO_RECORD;
                             exsr processHistoryArray;
                        endif;

                   enddo;
                   exec sql close P2;

                   SQLCOD = PrevSQLMAI;

        endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // insertHistoryRecord                                        *
       //                                                            *
       // Called by: generateINRecord, processHistoryArray           *
       //                                                            *
       // Calls: none                                                *
       //                                                            *
       //                                                            *
       //*************************************************************

       begsr insertHistoryRecord;

                   prevSQLCOD = SQLCOD;

                   exec sql insert into LEFHST
                   values (:dsLEFHST);

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                        dBase    = 005;
                        dBfile   = 'LEFHST';
                        dBkey    = *blanks;
                        dBpgm    = 'LE001118';
                        exsr *pssr;
                   endif;

                   SQLCOD = prevSQLCOD;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // checkDuplicate                                             *
       //                                                            *
       // Called by: generateINRecord, processHistoryArray           *
       //                                                            *
       // Calls: none                                                *
       //                                                            *
       //                                                            *
       //*************************************************************

       begsr checkDuplicate;

                   clear wTotal;
                   prevSQLCOD = SQLCOD;
                   isExist = False;

                   exec sql select count(*) into :wTotal  FROM   LEFHST
                   where HIBRCA = :keyBRCA and
                         HICNUM = :keyCNUM and
                         HIFACL = :keyFACL and
                         HILNRF = :keyLNRF and
                         HIFSEQ = :keyFSEQ and
                         HIRCTP = :keyRCTP and
                         HIRCVD = :keyRCVD;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                        dBase    = 006;
                        dBfile   = 'LEFHST';
                        dBkey    = *blanks;
                        dBpgm    = 'LE001118';
                        exsr *pssr;
                   endif;

                   if wTotal <> 0;
                        isExist = True;
                   endif;

                   SQLCOD = prevSQLCOD;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // generateINRecord                                           *
       //                                                            *
       // Called by: loadArray                                       *
       //                                                            *
       //  Calls: checkDuplicate, insertHistoryRecord                *
       //                                                            *
       //                                                            *
       //*************************************************************

       begsr generateINRecord;

                   keyRCTP =  'IN';
                   keyRCVD =  0;
                   keyBRCA =  dsLEFEED.FEBRCA;
                   keyCNUM =  dsLEFEED.FECNUM;
                   keyFACL =  dsLEFEED.FEFACL;
                   keyLNRF =  dsLEFEED.FELOAN;
                   keyFSEQ =  dsLEFEED.FEFSEQ;

                  exsr checkDuplicate;

                  if isExist;
                       leavesr;
                  endif;

                  clear dsLEFHST;

                  dsLEFHST.B_HIRECI = ACTIVE_RECORD;
                  dsLEFHST.B_HIPIND = dsLEFEED.FEPIND;
                  dsLEFHST.B_HIRCTP = IN_RECORD;
                  dsLEFHST.B_HILCHD = BJRDNB;
                  dsLEFHST.B_HIRECI = dsLEFEED.FERECI;
                  dsLEFHST.B_HIBRCA = dsLEFEED.FEBRCA;
                  dsLEFHST.B_HICNUM = dsLEFEED.FECNUM;
                  dsLEFHST.B_HIFACL = dsLEFEED.FEFACL;
                  dsLEFHST.B_HILNRF = dsLEFEED.FELOAN;
                  dsLEFHST.B_HIFSEQ = dsLEFEED.FEFSEQ;
                  dsLEFHST.B_HIFCCY = dsLEFEED.FEFCCY;
                  dsLEFHST.B_HILCHT = 'I';

       // If there are no records in history file LEFHST, retrieve details from fee record
       // otherwise get the details from the first record of the array retrieved from the
       // history file

                   if wRowsReturned = 0;
                        dsLEFHST.B_HIFRT1 = dsLEFEED.FEFRT1;
                        dsLEFHST.B_HIFRT2 = dsLEFEED.FEFRT2;
                        dsLEFHST.B_HIFRT3 = dsLEFEED.FEFRT3;
                        dsLEFHST.B_HIFRT4 = dsLEFEED.FEFRT4;
                        dsLEFHST.B_HIFRT5 = dsLEFEED.FEFRT5;
                        dsLEFHST.B_HIAMT1 = dsLEFEED.FEAMT1;
                        dsLEFHST.B_HIAMT2 = dsLEFEED.FEAMT2;
                        dsLEFHST.B_HIAMT3 = dsLEFEED.FEAMT3;
                        dsLEFHST.B_HIAMT4 = dsLEFEED.FEAMT4;
                        dsLEFHST.B_HIAMT5 = dsLEFEED.FEAMT5;
                   else;
                        dsLEFHST.B_HIFRT1 = arrHist(01).A_HIFRT1;
                        dsLEFHST.B_HIFRT2 = arrHist(01).A_HIFRT2;
                        dsLEFHST.B_HIFRT3 = arrHist(01).A_HIFRT3;
                        dsLEFHST.B_HIFRT4 = arrHist(01).A_HIFRT4;
                        dsLEFHST.B_HIFRT5 = arrHist(01).A_HIFRT5;
                        dsLEFHST.B_HIAMT1 = arrHist(01).A_HIAMT1;
                        dsLEFHST.B_HIAMT2 = arrHist(01).A_HIAMT2;
                        dsLEFHST.B_HIAMT3 = arrHist(01).A_HIAMT3;
                        dsLEFHST.B_HIAMT4 = arrHist(01).A_HIAMT4;
                        dsLEFHST.B_HIAMT5 = arrHist(01).A_HIAMT5;
                   endif;

                   exsr insertHistoryRecord;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // processHistoryArray                                        *
       //                                                            *
       // Called by: loadArray                                       *
       //                                                            *
       //  Calls: checkDuplicate, insertHistoryRecord                *
       //                                                            *
       //                                                            *
       //*************************************************************

       begsr processHistoryArray;

                   for Ix = 1 to wRowsReturned;

                        keyRCTP =  'RC';
                        keyRCVD =  arrHist(Ix).A_HIHDAT;
                        keyBRCA =  arrHist(Ix).A_HIBRCA;
                        keyCNUM =  arrHist(Ix).A_HICNUM;
                        keyFACL =  arrHist(Ix).A_HIFACL;
                        keyLNRF =  arrHist(Ix).A_HILNRF;
                        keyFSEQ =  arrHist(Ix).A_HIFSEQ;

                        exsr checkDuplicate;

                        if isExist;
                             iter;
                        endif;

                        clear dsLEFHST;
                        dsLEFHST = arrHist(Ix);
                        dsLEFHST.B_HIPIND = dsLEFEED.FEPIND;
                        dsLEFHST.B_HIRCVD= dsLEFHST.B_HIHDAT;
                        dsLEFHST.B_HIRCTP = RATE_CHANGE;
                        dsLEFHST.B_HILCHD = BJRDNB;
                        dsLEFHST.B_HILCHT = 'I';
                        dsLEFHST.B_HIFCOD = 0;
                        dsLEFHST.B_HIAMTS = 0;
                        dsLEFHST.B_HIHDAT = 0;
                        dsLEFHST.B_HIAMTD = 0;
                        dsLEFHST.B_HIHDAT = 0;
                        dsLEFHST.B_HIOSBR = *Blanks;
                        dsLEFHST.B_HISTTL = 0;
                        dsLEFHST.B_HIOURS = *Blanks;
                        dsLEFHST.B_FENLAI = *Blanks;
                        dsLEFHST.B_HISAMT = 0;
                        dsLEFHST.B_HIAMRI = *Blanks;
                        dsLEFHST.B_HISTPD = 0;
                        dsLEFHST.B_HIENPD = 0;
                        dsLEFHST.B_HIOSDB = *Blanks;
                        dsLEFHST.B_HIOMDB = *Blanks;
                        dsLEFHST.B_HIRSTM = 0;
                        dsLEFHST.B_HIRONS = *Blanks;
                        dsLEFHST.B_HIRIBN = *Blanks;
                        dsLEFHST.B_HIRIBA = *Blanks;
                        dsLEFHST.B_HIROBN = 0;
                        dsLEFHST.B_HIROCN = 0;
                        dsLEFHST.B_HIPSTM = 0;
                        dsLEFHST.B_HIPONS = *Blanks;
                        dsLEFHST.B_HIPIBN = *Blanks;
                        dsLEFHST.B_HIPIBA = *Blanks;
                        dsLEFHST.B_HIPOBN = 0;
                        dsLEFHST.B_HIPOCN = 0;
                        dsLEFHST.B_HIRCRN = *Blanks;
                        dsLEFHST.B_HIRCRA = *Blanks;
                        dsLEFHST.B_HIRVNO = *Blanks;
                        dsLEFHST.B_HIAWBN = *Blanks;
                        dsLEFHST.B_HIAWBA = *Blanks;
                        dsLEFHST.B_HIBENN = *Blanks;
                        dsLEFHST.B_HIBENA = *Blanks;
                        dsLEFHST.B_HIDTP1 = *Blanks;
                        dsLEFHST.B_HIDTP2 = *Blanks;
                        dsLEFHST.B_HIDTP2 = *Blanks;
                        dsLEFHST.B_HIDTP4 = *Blanks;
                        dsLEFHST.B_HIDCHG = *Blanks;
                        dsLEFHST.B_HIBTB1 = *Blanks;
                        dsLEFHST.B_HIBTB2 = *Blanks;
                        dsLEFHST.B_HIBTB3 = *Blanks;
                        dsLEFHST.B_HIBTB4 = *Blanks;
                        dsLEFHST.B_HIBTB5 = *Blanks;
                        dsLEFHST.B_HIBTB6 = *Blanks;
                        dsLEFHST.B_HICVMR = *Blanks;
                        dsLEFHST.B_HIFSCY = *Blanks;
                        dsLEFHST.B_HIFICY = *Blanks;
                        dsLEFHST.B_HIPSCY = *Blanks;

       // Get the value of rates and amount from next element in the array if the
       // current index  is not yet equal to total records in the array, otherwise
       // get the value from the last element of the array

                        if Ix < wRowsReturned;
                             Nxt = Ix + 1;
                        else;
                             Nxt = wRowsReturned;
                       endif;

                       dsLEFHST.B_HIFRT1 =  arrHist(Nxt).A_HIFRT1;
                       dsLEFHST.B_HIFRT2 =  arrHist(Nxt).A_HIFRT2;
                       dsLEFHST.B_HIFRT3 =  arrHist(Nxt).A_HIFRT3;
                       dsLEFHST.B_HIFRT4 =  arrHist(Nxt).A_HIFRT4;
                       dsLEFHST.B_HIFRT5 =  arrHist(Nxt).A_HIFRT5;

                       dsLEFHST.B_HIAMT1 =  arrHist(Nxt).A_HIAMT1;
                       dsLEFHST.B_HIAMT2 =  arrHist(Nxt).A_HIAMT2;
                       dsLEFHST.B_HIAMT3 =  arrHist(Nxt).A_HIAMT3;
                       dsLEFHST.B_HIAMT4 =  arrHist(Nxt).A_HIAMT4;
                       dsLEFHST.B_HIAMT5 =  arrHist(Nxt).A_HIAMT5;

                       exsr insertHistoryRecord;

                   endfor;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // *inzsr - Program Initialisation routine                    *
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

                  if pReturnCode <> *blanks;
                        dBase    = 007;
                        dBfile   = 'SDBANKPD';
                        dBkey    = *blanks;
                        dBpgm    = 'LE001118';
                        exsr *pssr;
                   endif;

                  SDBANK = dsfdy;

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
**  CPY@
(c) Finastra International Limited 2023
