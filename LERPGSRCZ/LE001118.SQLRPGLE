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
     D dsLEFEED        ds                  likeds(SDLEFEED)

      ** LEFHST
     D HistoryFile   e ds                  extname(LEFHST)
     D  wFENLAI      e                     extfld(FENLAI)
     D arrHist         ds                  likeds(HistoryFile)
     D                                     dim(100)
     D dsLEFHST        ds                  likeds(HistoryFile)

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
     D keyAMTS         s             13p 0 inz(0)
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
                   'select DISTINCT * from LEFHST B' +
                   ' where B.HIRECI = '  + QUO + ACTIVE_RECORD + QUO +
                   ' and B.HIRCTP = '    + QUO + '  ' + QUO +
                   ' and B.HIBRCA = '    + QUO + dsLEFEED.FEBRCA + QUO +
                   ' and B.HICNUM = '    + QUO + dsLEFEED.FECNUM + QUO +
                   ' and B.HIFACL = '    + %TRIM(%CHAR(dsLEFEED.FEFACL)) +
                   ' and B.HILNRF = '    + QUO + dsLEFEED.FELOAN + QUO +
                   ' and B.HIFCOD = '    + %TRIM(%CHAR(dsLEFEED.FEFCOD)) +
                   ' and B.HIFSEQ = '    + %TRIM(%CHAR(dsLEFEED.FEFSEQ)) +
                   ' order by B.HIBRCA,' +
                   ' B.HICNUM,' +
                   ' B.HIFACL,' +
                   ' B.HILNRF,' +
                   ' B.HIFSEQ,' +
                   ' B.HIHDAT';

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
                         HIRCVD = :keyRCVD and
                         HIAMTS = :keyAMTS;

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
                   keyAMTS = 0;

                  exsr checkDuplicate;

                  if isExist;
                       leavesr;
                  endif;

                  clear dsLEFHST;

                  dsLEFHST.HIRECI = ACTIVE_RECORD;
                  dsLEFHST.HIPIND = dsLEFEED.FEPIND;
                  dsLEFHST.HIRCTP = IN_RECORD;
                  dsLEFHST.HILCHD = BJRDNB;
                  dsLEFHST.HIRECI = dsLEFEED.FERECI;
                  dsLEFHST.HIBRCA = dsLEFEED.FEBRCA;
                  dsLEFHST.HICNUM = dsLEFEED.FECNUM;
                  dsLEFHST.HIFACL = dsLEFEED.FEFACL;
                  dsLEFHST.HILNRF = dsLEFEED.FELOAN;
                  dsLEFHST.HIFSEQ = dsLEFEED.FEFSEQ;
                  dsLEFHST.HIFCCY = dsLEFEED.FEFCCY;
                  dsLEFHST.HILCHT = 'I';

       // If there are no records in history file LEFHST, retrieve details from fee record
       // otherwise get the details from the first record of the array retrieved from the
       // history file

                   if wRowsReturned = 0;
                        dsLEFHST.HIFRT1 = dsLEFEED.FEFRT1;
                        dsLEFHST.HIFRT2 = dsLEFEED.FEFRT2;
                        dsLEFHST.HIFRT3 = dsLEFEED.FEFRT3;
                        dsLEFHST.HIFRT4 = dsLEFEED.FEFRT4;
                        dsLEFHST.HIFRT5 = dsLEFEED.FEFRT5;
                        dsLEFHST.HIAMT1 = dsLEFEED.FEAMT1;
                        dsLEFHST.HIAMT2 = dsLEFEED.FEAMT2;
                        dsLEFHST.HIAMT3 = dsLEFEED.FEAMT3;
                        dsLEFHST.HIAMT4 = dsLEFEED.FEAMT4;
                        dsLEFHST.HIAMT5 = dsLEFEED.FEAMT5;
                   else;
                        dsLEFHST.HIFRT1 = arrHist(01).HIFRT1;
                        dsLEFHST.HIFRT2 = arrHist(01).HIFRT2;
                        dsLEFHST.HIFRT3 = arrHist(01).HIFRT3;
                        dsLEFHST.HIFRT4 = arrHist(01).HIFRT4;
                        dsLEFHST.HIFRT5 = arrHist(01).HIFRT5;
                        dsLEFHST.HIAMT1 = arrHist(01).HIAMT1;
                        dsLEFHST.HIAMT2 = arrHist(01).HIAMT2;
                        dsLEFHST.HIAMT3 = arrHist(01).HIAMT3;
                        dsLEFHST.HIAMT4 = arrHist(01).HIAMT4;
                        dsLEFHST.HIAMT5 = arrHist(01).HIAMT5;
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
                        keyRCVD =  arrHist(Ix).HIHDAT;
                        keyBRCA =  arrHist(Ix).HIBRCA;
                        keyCNUM =  arrHist(Ix).HICNUM;
                        keyFACL =  arrHist(Ix).HIFACL;
                        keyLNRF =  arrHist(Ix).HILNRF;
                        keyFSEQ =  arrHist(Ix).HIFSEQ;
                        keyAMTS =  arrHist(Ix).HIAMTS;

                        exsr checkDuplicate;

                        if isExist;
                             iter;
                        endif;

                        clear dsLEFHST;
                        dsLEFHST = arrHist(Ix);
                        dsLEFHST.HIPIND = dsLEFEED.FEPIND;
                        dsLEFHST.HIRCVD= dsLEFHST.HIHDAT;
                        dsLEFHST.HIRCTP = RATE_CHANGE;
                        dsLEFHST.HILCHD = BJRDNB;
                        dsLEFHST.HILCHT = 'I';
                        dsLEFHST.HIAMTS = 0;
                        dsLEFHST.HIHDAT = 0;
                        dsLEFHST.HIAMTD = 0;
                        dsLEFHST.HIHDAT = 0;
                        dsLEFHST.HIOSBR = *Blanks;
                        dsLEFHST.HISTTL = 0;
                        dsLEFHST.HIOURS = *Blanks;
                        dsLEFHST.WFENLAI = *Blanks;
                        dsLEFHST.HISAMT = 0;
                        dsLEFHST.HIAMRI = *Blanks;
                        dsLEFHST.HISTPD = 0;
                        dsLEFHST.HIENPD = 0;
                        dsLEFHST.HIOSDB = *Blanks;
                        dsLEFHST.HIOMDB = *Blanks;
                        dsLEFHST.HIRSTM = 0;
                        dsLEFHST.HIRONS = *Blanks;
                        dsLEFHST.HIRIBN = *Blanks;
                        dsLEFHST.HIRIBA = *Blanks;
                        dsLEFHST.HIROBN = 0;
                        dsLEFHST.HIROCN = 0;
                        dsLEFHST.HIPSTM = 0;
                        dsLEFHST.HIPONS = *Blanks;
                        dsLEFHST.HIPIBN = *Blanks;
                        dsLEFHST.HIPIBA = *Blanks;
                        dsLEFHST.HIPOBN = 0;
                        dsLEFHST.HIPOCN = 0;
                        dsLEFHST.HIRCRN = *Blanks;
                        dsLEFHST.HIRCRA = *Blanks;
                        dsLEFHST.HIRVNO = *Blanks;
                        dsLEFHST.HIAWBN = *Blanks;
                        dsLEFHST.HIAWBA = *Blanks;
                        dsLEFHST.HIBENN = *Blanks;
                        dsLEFHST.HIBENA = *Blanks;
                        dsLEFHST.HIDTP1 = *Blanks;
                        dsLEFHST.HIDTP2 = *Blanks;
                        dsLEFHST.HIDTP2 = *Blanks;
                        dsLEFHST.HIDTP4 = *Blanks;
                        dsLEFHST.HIDCHG = *Blanks;
                        dsLEFHST.HIBTB1 = *Blanks;
                        dsLEFHST.HIBTB2 = *Blanks;
                        dsLEFHST.HIBTB3 = *Blanks;
                        dsLEFHST.HIBTB4 = *Blanks;
                        dsLEFHST.HIBTB5 = *Blanks;
                        dsLEFHST.HIBTB6 = *Blanks;
                        dsLEFHST.HICVMR = *Blanks;
                        dsLEFHST.HIFSCY = *Blanks;
                        dsLEFHST.HIFICY = *Blanks;
                        dsLEFHST.HIPSCY = *Blanks;

       // Get the value of rates and amount from next element in the array if the
       // current index  is not yet equal to total records in the array, otherwise
       // get the value from the last element of the array

                        if Ix < wRowsReturned;
                             Nxt = Ix + 1;
                        else;
                             Nxt = wRowsReturned;
                       endif;

                       dsLEFHST.HIFRT1 =  arrHist(Nxt).HIFRT1;
                       dsLEFHST.HIFRT2 =  arrHist(Nxt).HIFRT2;
                       dsLEFHST.HIFRT3 =  arrHist(Nxt).HIFRT3;
                       dsLEFHST.HIFRT4 =  arrHist(Nxt).HIFRT4;
                       dsLEFHST.HIFRT5 =  arrHist(Nxt).HIFRT5;

                       dsLEFHST.HIAMT1 =  arrHist(Nxt).HIAMT1;
                       dsLEFHST.HIAMT2 =  arrHist(Nxt).HIAMT2;
                       dsLEFHST.HIAMT3 =  arrHist(Nxt).HIAMT3;
                       dsLEFHST.HIAMT4 =  arrHist(Nxt).HIAMT4;
                       dsLEFHST.HIAMT5 =  arrHist(Nxt).HIAMT5;

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
