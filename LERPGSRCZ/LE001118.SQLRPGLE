000100231218     H DEBUG
000101231218     H COPYRIGHT('(c) Finastra International Limited 2023')
000102231218      *****************************************************************
000103231218/*STD *  RPGSQLBND                                                    *
000104231218/*EXI *  TEXT('Midas LE CLE071 Takeon program for calculated fees')   *
000105231218      *****************************************************************
000106231218      *                                                               *
000107231218      *  Midas - Midas LE CLE071 Takeon program for calculated fees   *
000108231218      *                                                               *
000109231218      *  LE001118 - Midas LE CLE071 Takeon program for                *
000110231218      *             calculated fees                                   *
000111231218      *                                                               *
000112231218      *  (c) Finastra International Limited 2023                      *
000113231218      *                                                               *
000114231222      *  Last Amend No. MD062082 *CREATE   Date 24Dec23               *
000115231218      *                                                               *
000116231218      *****************************************************************
000117231218      *                                                               *
000118231222      *  MD062082 - CLE071 Takeon program for calculated fees         *
000119231218      *                                                               *
000120231218      *****************************************************************
000121231218      *
000122231218      **---------------------------------------------------------------
000123231218      ** The following /COPY line includes all the defined fields in
000124231218      ** the Program Status Data Structures.  They have meaningful
000125231218      ** names, prefixed by 'PS'.
000126231218
000127231218      ** Standard D-specs
000128231218     D/COPY ZACPYSRC,PSDS
000129231218     D/COPY ZACPYSRC,STD_D_SPEC
000130231218
000131231218      ** +--------------------------------------+
000132231218      ** ¦ Program Prototypes                   ¦
000133231218      ** ¦ ==================                   ¦
000134231218      ** +--------------------------------------+
000135231222     D  ACCESS_SDBANK  pr                  extpgm('AOBANKR0')
000136231222     D    pReturnCode                 7A
000137231222     D    pOption                     7A
000138231222     D    pDSFDY                    200A
000139231218
000140231218      *  +----------------+
000141231218      ** |Parameter lists |
000142231218      ** +----------------+
000143231218
000144231218      ** +--------------------------------------+
000145231218      ** ¦ Manually included D-specs            ¦
000146231218      ** ¦ =========================            ¦
000147231218      ** +--------------------------------------+
000148231218      ** +--------------------------------------+
000149231218      *
000150231218      ** LEFEED
000151231218     D SDLEFEED      e ds                  extname(LEFEED)
000152231218     D dsLEFEED        ds                  likeds(SDLEFEED)
000153231218
000154231218      ** LEFHST
000168231218     D HistoryFile   e ds                  extname(LEFHST)
000169231219     D  wFENLAI      e                     extfld(FENLAI)
000183231218     D arrHist         ds                  likeds(HistoryFile)
000184231219     D                                     dim(100)
000185231219     D dsLEFHST        ds                  likeds(HistoryFile)
000187231218
000188231218      ** Core data structures
000190231218     D dsfdy         e ds                  extname(DSFDY)
000191231222     D sdbank        e ds                  extname(SDBANKPD)
000192231218
000193231218      ** +--------------------------------------+
000194231218      ** ¦ Constants declaration                ¦
000195231218      ** ¦ =====================                ¦
000196231218      ** +--------------------------------------+
000197231218     D NOT_EXIST       c                   const(-204)
000198231218     D NO_ERROR        c                   const(0)
000199231218     D NO_RECORD       c                   const(100)
000200231218     D NOT_FOUND       c                   const(-204)
000201231218     D NO_COLUMN       c                   const(-205)
000202231218     D NULL_VALUES     c                   const(-305)
000203231218     D DUPLICATE       c                   const(-803)
000204231218     D QUO             c                   const('''')
000205231219     D RATE_CHANGE     c                   const('RC')
000206231219     D IN_RECORD       c                   const('IN')
000207231226     D ACTIVE_RECORD   c                   const('D')
000208231218
000209231218      ** +--------------------------------------+
000210231218      ** ¦ Variable declaration                 ¦
000211231218      ** ¦ ====================                 ¦
000212231218      ** +--------------------------------------+
000213231218
000214231219     D Nxt             s              6s 0 inz(0)
000215231219     D Ix              s              6s 0 inz(0)
000216231219     D prevSQLCOD      s              6s 0 inz(0)
000217231227     D prevSQLMAI      s              6s 0 inz(0)
000218231219     D isExist         s               n   inz(False)
000219231219     D isFirstPass     s               n   inz(True)
000220231219     D isRateChange    s               n   inz(False)
000221231219     D MAX_ARRAY       s              8s 0 inz(100)
000222231219     D wRowsReturned   s             10s 0 inz(*zeros)
000223231218     D wSqlStr         s           2000a   inz(*blanks)
000228231219     D keyRCTP         s              2a   inz(*blanks)
000229231219     D keyBRCA         s              3a   inz(*blanks)
000230231219     D keyCNUM         s              6a   inz(*blanks)
000231231219     D keyFACL         s              5S 0 inz(0)
000232231219     D keyLNRF         s              6a   inz(*blanks)
000233231219     D keyFSEQ         s              2s 0 inz(0)
000234231219     D keyRCVD         s              5S 0 inz(0)
000235231226     D keyAMTS         s             13p 0 inz(0)
000236231219     D wTotal          s              6s 0 inz(0)
000237231224     D pReturnCode     s              7a   inz(*blanks)
000238231224     D pOption         s              7a   inz(*blanks)
000239231218
000240231218      ** +--------------------------------------+
000241231218      ** ¦ Array declaration                    ¦
000242231218      ** ¦ ==================                   ¦
000243231218      ** +--------------------------------------+
000244231218
000245231218      /free
000246231218
000247231218       // ** +--- Start of Main processing -----------------------------------+
000248231218       // ** ¦                                                                ¦
000249231218       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000250231218       // ** ¦ executed at program activation.                                ¦
000251231218       // ** ¦                                                                ¦
000252231218       // ** +----------------------------------------------------------------+
000253231218
000254231218       // Set compile options for this program, Commit = *Chg is specified to
000255231218       // ensure that commit/rollback processing would be peformed
000256231218
000257231218                   exec sql
000258231218                      set option
000259231218                         Naming    = *Sys,
000260240105                         Commit    = *None,
000261231218                         UsrPrf    = *Owner,
000262231218                         DynUsrPrf = *Owner,
000263231218                         Datfmt    = *iso,
000264231218                         CloSqlCsr = *EndMod;
000265231218
000266231222                   // Call subroutine to excute take on process
000267231222                   exsr takeOnProgram;
000268231218
000269231218                   *Inlr = *On;
000270231218                   return;
000271231218
000272231218       //*************************************************************
000273231218       /EJECT
000274231218       //*************************************************************
000275231218       //                                                            *
000276231222       // takeOnProgram - Start take on program                      *
000277231218       //                                                            *
000278231218       // Called by: Main processing                                 *
000279231218       //                                                            *
000280231222       //  Calls: processThisRecord                                  *
000281231218       //                                                            *
000282231218       //*************************************************************
000283231218
000284231222       begsr takeOnProgram;
000285231218
000286231219                   //Select all live calculated fees
000287231224                   clear wSQLStr;
000288231218                   wSQLStr = 'select * from LEFEED A' +
000289231224                             ' where A.FERECI = ' + QUO + ACTIVE_RECORD + QUO +
000290231218                             ' and   A.FECALT <>  ' + QUO + ' ' + QUO +
000291231218                             ' order by A.FEBRCA,' +
000292231219                             ' A.FECNUM,' +
000293231219                             ' A.FEFACL,' +
000294231219                             ' A.FELOAN,' +
000295231219                             ' A.FEFSEQ';
000296231218
000297231218                   exec sql prepare P1 from :wSQLStr;
000298231218                   exec sql declare P1 cursor for P1;
000299231218                   exec sql open P1;
000300231218                   exec sql fetch next from P1 into :dsLEFEED;
000301231218
000302231218                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
000303231218                      and SqlCod <> NO_COLUMN;
000304231218                      dBkey = *Blanks;
000305231218                      dBFile = 'LEFEED';
000306231218                      dBase = 001;
000307231218                      dBPgm  = 'LE001118';
000308231218                      exsr *pssr;
000309231218                   endif;
000310231219
000311231218                   if sqlCod <> NO_RECORD;
000312231222                      exsr processThisRecord;
000313231218                   endif;
000314231218
000315231218                   dow sqlCod = NO_ERROR;
000316231218
000317231224                       exec sql fetch next from P1 into :dsLEFEED;
000318231218
000319231224                       if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD
000320231224                          and sqlCod <> NO_COLUMN;
000321231224                          dBkey = *Blanks;
000322231224                          dBFile = 'LEFEED';
000323231224                          dBase = 002;
000324231224                          dBPgm  = 'LE001118';
000325231224                          exsr *pssr;
000326231224                       endif;
000327231218
000328231218                       if sqlCod <> NO_RECORD;
000329231222                          exsr processThisRecord;
000330231218                       endif;
000331231218
000332231224                   enddo;
000333231218
000334231218                   exec sql close P1;
000335231218
000336231218       endsr;
000337231218
000338231218       //*************************************************************
000339231218       /EJECT
000340231218       //*************************************************************
000341231218       //                                                            *
000342231222       // processThisRecord - Process current fee record             *
000343231218       //                                                            *
000344231222       // Called by: takeOnProgram                                   *
000345231218       //                                                            *
000346231218       //  Calls: loadArray                                          *
000347231218       //                                                            *
000348231218       //                                                            *
000349231218       //*************************************************************
000350231218
000351231222       begsr processThisRecord;
000352231219
000354231218                   exsr loadArray;
000355231218
000356231218       endsr;
000357231218
000358231218       //*************************************************************
000359231218       /EJECT
000360231218       //*************************************************************
000361231218       //                                                            *
000362231224       // loadArray - Load array from LEFHST records whose fee       *
000363231224       //             matches multiple entries from history file     *
000364231218       //                                                            *
000365231222       // Called by: processThisRecord                               *
000366231218       //                                                            *
000367231222       //  Calls: generateINRecord, processHistoryArray              *
000368231218       //                                                            *
000369231218       //*************************************************************
000370231218
000371231218       begsr loadArray;
000372231218
000373231218                   clear arrHist;
000374231224                   clear wSQLStr;
000375231227                   prevSQLMAI = SQLCOD;
000376231218
000377231218                   wSQLStr =
000378231219                     'select DISTINCT * from LEFHST B' +
000379231224                     ' where B.HIRECI = '  + QUO + ACTIVE_RECORD + QUO +
000380231224                     ' and B.HIRCTP = '    + QUO + '  ' + QUO +
000381231224                     ' and B.HIBRCA = '    + QUO + dsLEFEED.FEBRCA + QUO +
000382231224                     ' and B.HICNUM = '    + QUO + dsLEFEED.FECNUM + QUO +
000383231224                     ' and B.HIFACL = '    + %TRIM(%CHAR(dsLEFEED.FEFACL)) +
000384231224                     ' and B.HILNRF = '    + QUO + dsLEFEED.FELOAN + QUO +
000385231224                     ' and B.HIFCOD = '    + %TRIM(%CHAR(dsLEFEED.FEFCOD)) +
000386231224                     ' and B.HIFSEQ = '    + %TRIM(%CHAR(dsLEFEED.FEFSEQ)) +
000387231219                     ' order by B.HIBRCA,' +
000388231224                     ' B.HICNUM,' +
000389231219                     ' B.HIFACL,' +
000390231219                     ' B.HILNRF,' +
000391231219                     ' B.HIFSEQ,' +
000392231219                     ' B.HIHDAT';
000393231218
000394231218                   exec sql prepare P2 from :wSQLStr;
000395231218                   exec sql declare P2 cursor for P2;
000396231218                   exec sql open P2;
000397231218                   exec sql fetch next from P2 for :MAX_ARRAY
000398231218                   rows into :arrHist;
000399231218
000400231218                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000401231218                      dBkey = *Blanks;
000402231219                      dBFile = 'LEFHST';
000403231219                      dBase = 003;
000404231219                      dBPgm  = 'LE001118';
000405231218                      exsr *pssr;
000406231218                   endif;
000407231218
000408231219                   wRowsReturned = SqlErrd(3);
000409231227                   exsr generateINRecord;
000410231219                   if sqlCod <> NO_RECORD;
000411231227                      exsr processHistoryArray;
000415231219                   endif;
000416231219
000417231218                   dow sqlCod = NO_ERROR;
000418231219
000419231224                       exec sql fetch next from P2 for :MAX_ARRAY
000420231224                       rows into :arrHist;
000421231218
000422231224                       if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000423231224                          dBkey = *Blanks;
000424231224                          dBfile = 'LEFHST';
000425231224                          dBase = 004;
000426231224                          dBpgm  = 'LE001118';
000427231224                          exsr *pssr;
000428231224                       endif;
000429231218
000430231224                       wRowsReturned = SqlErrd(3);
000432231224                       if sqlCod <> NO_RECORD;
000433231227                          exsr processHistoryArray;
000435231224                       endif;
000436231219
000437231224                   enddo;
000438231218                   exec sql close P2;
000439231219
000440231227                   SQLCOD = PrevSQLMAI;
000441231218
000442231218       endsr;
000443231224
000474231219       //*************************************************************
000475231219       /EJECT
000476231219       //*************************************************************
000477231219       //                                                            *
000478231219       // insertHistoryRecord                                        *
000479231219       //                                                            *
000480231224       // Called by: generateINRecord, processHistoryArray           *
000481231219       //                                                            *
000482231224       // Calls: none                                                *
000483231219       //                                                            *
000484231219       //                                                            *
000485231219       //*************************************************************
000486231219
000487231219       begsr insertHistoryRecord;
000488231219
000489231219             prevSQLCOD = SQLCOD;
000490231219
000491231219             exec sql insert into LEFHST
000492231219             values (:dsLEFHST);
000493231224
000494231219             if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000495231222                dBase    = 005;
000496231219                dBfile   = 'LEFHST';
000497231219                dBkey    = *blanks;
000498231219                dBpgm    = 'LE001118';
000499231219                exsr *pssr;
000500231219             endif;
000501231219
000502231219             SQLCOD = prevSQLCOD;
000503231219
000504231219       endsr;
000505231224
000506231219       //*************************************************************
000507231219       /EJECT
000508231219       //*************************************************************
000509231219       //                                                            *
000510231219       // checkDuplicate                                             *
000511231219       //                                                            *
000512231224       // Called by: generateINRecord, processHistoryArray           *
000513231219       //                                                            *
000514231224       // Calls: none                                               *
000515231219       //                                                            *
000516231219       //                                                            *
000517231219       //*************************************************************
000518231219
000519231219       begsr checkDuplicate;
000520231219
000521231219             clear wTotal;
000522231219             prevSQLCOD = SQLCOD;
000523231219             isExist = False;
000524231219
000525231219             exec sql select count(*) into :wTotal  FROM   LEFHST
000526231219             where HIBRCA = :keyBRCA and
000527231219                   HICNUM = :keyCNUM and
000528231219                   HIFACL = :keyFACL and
000529231219                   HILNRF = :keyLNRF and
000530231219                   HIFSEQ = :keyFSEQ and
000531231219                   HIRCTP = :keyRCTP and
000532231226                   HIRCVD = :keyRCVD and
000533231226                   HIAMTS = :keyAMTS;
000534231219
000535231219             if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000536231222                dBase    = 006;
000537231219                dBfile   = 'LEFHST';
000538231219                dBkey    = *blanks;
000539231219                dBpgm    = 'LE001118';
000540231219                exsr *pssr;
000541231219             endif;
000542231219
000543231219             if wTotal <> 0;
000544231219                isExist = True;
000545231219             endif;
000546231219
000547231219             SQLCOD = prevSQLCOD;
000548231224
000549231219       endsr;
000550231219
000551231219       //*************************************************************
000552231219       /EJECT
000553231219       //*************************************************************
000554231219       //                                                            *
000555231219       // generateINRecord                                           *
000556231219       //                                                            *
000557231222       // Called by: loadArray                                       *
000558231219       //                                                            *
000559231222       //  Calls: checkDuplicate, insertHistoryRecord                *
000560231219       //                                                            *
000561231219       //                                                            *
000562231219       //*************************************************************
000563231219
000564231219       begsr generateINRecord;
000565231219
000566231219             keyRCTP =  'IN';
000567231219             keyRCVD =  0;
000568231219             keyBRCA =  dsLEFEED.FEBRCA;
000569231219             keyCNUM =  dsLEFEED.FECNUM;
000570231219             keyFACL =  dsLEFEED.FEFACL;
000571231219             keyLNRF =  dsLEFEED.FELOAN;
000572231219             keyFSEQ =  dsLEFEED.FEFSEQ;
000573231226             keyAMTS = 0;
000574231219
000575231219             exsr checkDuplicate;
000576231219
000577231219             if isExist;
000578231219                leavesr;
000579231219             endif;
000580231219
000581231219             clear dsLEFHST;
000582231224
000583231224             dsLEFHST.HIRECI = ACTIVE_RECORD;
000584231222             dsLEFHST.HIPIND = dsLEFEED.FEPIND;
000585231222             dsLEFHST.HIRCTP = IN_RECORD;
000586231222             dsLEFHST.HILCHD = BJRDNB;
000587231219             dsLEFHST.HIRECI = dsLEFEED.FERECI;
000588231219             dsLEFHST.HIBRCA = dsLEFEED.FEBRCA;
000589231219             dsLEFHST.HICNUM = dsLEFEED.FECNUM;
000590231219             dsLEFHST.HIFACL = dsLEFEED.FEFACL;
000591231219             dsLEFHST.HILNRF = dsLEFEED.FELOAN;
000592231219             dsLEFHST.HIFSEQ = dsLEFEED.FEFSEQ;
000593231219             dsLEFHST.HIFCCY = dsLEFEED.FEFCCY;
000594231219             dsLEFHST.HILCHT = 'I';
000595231222
000596231224             // If there are no records in history file LEFHST, retrieve details from fee record
000597231222             // otherwise get the details from the first record of the array retrieved from the
000598231222             // history file
000599231222
000600231219             if wRowsReturned = 0;
000601231224                dsLEFHST.HIFRT1 = dsLEFEED.FEFRT1;
000602231224                dsLEFHST.HIFRT2 = dsLEFEED.FEFRT2;
000603231224                dsLEFHST.HIFRT3 = dsLEFEED.FEFRT3;
000604231224                dsLEFHST.HIFRT4 = dsLEFEED.FEFRT4;
000605231224                dsLEFHST.HIFRT5 = dsLEFEED.FEFRT5;
000606231224                dsLEFHST.HIAMT1 = dsLEFEED.FEAMT1;
000607231224                dsLEFHST.HIAMT2 = dsLEFEED.FEAMT2;
000608231224                dsLEFHST.HIAMT3 = dsLEFEED.FEAMT3;
000609231224                dsLEFHST.HIAMT4 = dsLEFEED.FEAMT4;
000610231224                dsLEFHST.HIAMT5 = dsLEFEED.FEAMT5;
000611231219             else;
000612231224                dsLEFHST.HIFRT1 = arrHist(01).HIFRT1;
000613231224                dsLEFHST.HIFRT2 = arrHist(01).HIFRT2;
000614231224                dsLEFHST.HIFRT3 = arrHist(01).HIFRT3;
000615231224                dsLEFHST.HIFRT4 = arrHist(01).HIFRT4;
000616231224                dsLEFHST.HIFRT5 = arrHist(01).HIFRT5;
000617231224                dsLEFHST.HIAMT1 = arrHist(01).HIAMT1;
000618231224                dsLEFHST.HIAMT2 = arrHist(01).HIAMT2;
000619231224                dsLEFHST.HIAMT3 = arrHist(01).HIAMT3;
000620231224                dsLEFHST.HIAMT4 = arrHist(01).HIAMT4;
000621231224                dsLEFHST.HIAMT5 = arrHist(01).HIAMT5;
000622231219             endif;
000623231222
000624231219             exsr insertHistoryRecord;
000625231219
000626231219       endsr;
000627231219       //*************************************************************
000628231219       /EJECT
000629231219       //*************************************************************
000630231219       //                                                            *
000631231219       // processHistoryArray                                        *
000632231219       //                                                            *
000633231219       // Called by: loadArray                                       *
000634231219       //                                                            *
000635231222       //  Calls: checkDuplicate, insertHistoryRecord                *
000636231219       //                                                            *
000637231219       //                                                            *
000638231219       //*************************************************************
000639231219
000640231219       begsr processHistoryArray;
000641231219
000642231219             for Ix = 1 to wRowsReturned;
000643231219
000644231219                 keyRCTP =  'RC';
000645231219                 keyRCVD =  arrHist(Ix).HIHDAT;
000646231219                 keyBRCA =  arrHist(Ix).HIBRCA;
000647231219                 keyCNUM =  arrHist(Ix).HICNUM;
000648231219                 keyFACL =  arrHist(Ix).HIFACL;
000649231219                 keyLNRF =  arrHist(Ix).HILNRF;
000650231219                 keyFSEQ =  arrHist(Ix).HIFSEQ;
000651231226                 keyAMTS =  arrHist(Ix).HIAMTS;
000652231226
000653231219
000654231219                 exsr checkDuplicate;
000655231219
000656231219                 if isExist;
000657231219                    iter;
000658231219                 endif;
000659231219
000660231219                 dsLEFHST = arrHist(Ix);
000661231219                 dsLEFHST.HIPIND = dsLEFEED.FEPIND;
000662231219                 dsLEFHST.HIRCVD= dsLEFHST.HIHDAT;
000663231219                 dsLEFHST.HIRCTP = RATE_CHANGE;
000664231219                 dsLEFHST.HIHDAT= 0;
000665231219
000666231222                 // Get the value of rates and amount from next element in the array if the
000667231222                 // current index  is not yet equal to total records in the array, otherwise
000668231222                 // get the value from the last element of the array
000669231222
000670231219                 if Ix < wRowsReturned;
000671231219                    Nxt = Ix + 1;
000672231219                 else;
000673231219                    Nxt = wRowsReturned;
000674231219                 endif;
000675231219
000676231219                 dsLEFHST.HIFRT1 =  arrHist(Nxt).HIFRT1;
000677231219                 dsLEFHST.HIFRT2 =  arrHist(Nxt).HIFRT2;
000678231219                 dsLEFHST.HIFRT3 =  arrHist(Nxt).HIFRT3;
000679231219                 dsLEFHST.HIFRT4 =  arrHist(Nxt).HIFRT4;
000680231219                 dsLEFHST.HIFRT5 =  arrHist(Nxt).HIFRT5;
000681231219
000682231219                 dsLEFHST.HIAMT1 =  arrHist(Nxt).HIAMT1;
000683231219                 dsLEFHST.HIAMT2 =  arrHist(Nxt).HIAMT2;
000684231219                 dsLEFHST.HIAMT3 =  arrHist(Nxt).HIAMT3;
000685231219                 dsLEFHST.HIAMT4 =  arrHist(Nxt).HIAMT4;
000686231219                 dsLEFHST.HIAMT5 =  arrHist(Nxt).HIAMT5;
000687231219
000688231219                 exsr insertHistoryRecord;
000689231219
000690231219             endfor;
000691231219
000692231219       endsr;
000693231218
000694231218       //*************************************************************
000695231218       /EJECT
000696231218       //*************************************************************
000697231218       //                                                            *
000698231218       // *inzsr - Program Initialisation routine                    *
000699231218       //                                                            *
000700231218       // Called by: Main processing                                 *
000701231218       //                                                            *
000702231218       //  Calls: None                                               *
000703231218       //                                                            *
000704231218       //*************************************************************
000705231218
000706231218       begsr *inzsr;
000707231222
000708231222                  pOption = '*FIRST';
000709231222                  pReturnCode = *Blanks;
000710231222
000711231222                  callp ACCESS_SDBANK(
000712231222                                  pReturnCode
000713231222                                : pOption
000714231222                                : dsfdy
000715231222                               );
000716231222                   SDBANK = dsfdy;
000717231222
000718231222                   if pReturnCode <> *blanks;
000719231222                      dBase    = 007;
000720231222                      dBfile   = 'SDBANKPD';
000721231222                      dBkey    = *blanks;
000722231222                      dBpgm    = 'LE001118';
000723231222                      exsr *pssr;
000724231222                   endif;
000725231218
000726231222
000727231218       endsr;
000728231218
000729231218       //*************************************************************
000730231218       /EJECT
000731231218       //*************************************************************
000732231218       //                                                            *
000733231218       //   *pssr - Standard Error Handler                           *
000734231218       //                                                            *
000735231218       //   Called By: Main Processing, various subroutines          *
000736231218       //                                                            *
000737231218       //*************************************************************
000738231218
000739231218       begsr *pssr;
000740231218                   *inu7 = *on;
000741231218                   *inu8 = *on;
000742231218                   *Inlr = *on;
000743231218                   dump;
000744231218                   return;
000745231218       endsr;
000746231218
000747231218       //**************************************************************
000748231218
000749231218      /end-free
000750231218      *****************************************************************
000751231218**  CPY@
000752231218(c) Finastra International Limited 2023
