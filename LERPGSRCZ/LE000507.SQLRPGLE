     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Batch Bulk of Repayment Priority')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LE000507 - Midas LE Batch Bulk of Repayment Priority         *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD038258           Date 13Apr16               *
      *                 MD037489           Date 11Feb16               *
      *                 MD037485           Date 11Feb16               *
      *                 MD036881           Date 17Dec15               *
      *                 MD031720           Date 07Jan15               *
      *                 CLE164 *CREATE     Date 18Aug14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD038258 - Bulk update does not work correctly for fees      *
      *           - Priorities are not updated for fees when ran in   *
      *             command line                                      *
      *           - Corrected the passed fee code parameter to sub    *
      *             routine RetrievePDPFC to correctly retrieve       *
      *             the priority group id                             *
      *  MD037489 - Initialize common SQL String build variables      *
      *             between loan and fee access                       *
      *  MD037485 - Only Process Live Loans and Fees when             *
      *             running the program as take-on                    *
      *  MD036881 - Incorrect Repayment Priority and Priority Level   *
      *             retrieved for loan fees during bulk update        *
      *  MD031720 - Job not ended properly when LEC000507 ran         *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *                                                               *
      *****************************************************************

     FCLOANZI0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FLEFEEZI0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FGPDWNLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FLE000507AUO    E             PRINTER
      **------------------------------------------------------------------
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Program Prototypes                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Main            PR                  Extpgm('LE000507')
     D    pParm1                           Likeds(ParmLoan)
     D    pParm2                           Likeds(ParmFees)

     D Main            PI
     D    pParm1                           Likeds(ParmLoan)
     D    pParm2                           Likeds(ParmFees)

     D UPDATE_MATRIX   PR                  Extpgm('LE000506')
     D    pRetCode                    7A
     D    pAction                     8A
     D    pFile                      10A
     D    pLoanRef                    6A
     D    pBranch                     3A
     D    pCustomer                   6A
     D    pFeeFclty                   5S 0
     D    pFeeLoan                    6A
     D    pFeeSeqn                    2S 0
     D    pLSPDPGrpID                 3A
     D    pFTPDPGrpID                 3A
     D    pFCPDPGrpID                 3A
     D    pCategory                   5A

     D  RETRIEVE_REPR  PR                  Extpgm('LE000505')
     D   pRetCode                     7A
     D   pFTPDPPRGrp                  3A
     D   pLSPDPPRGrp                  3A
     D   pFCPDPPRGrp                  3A
     D   pCategoryCod                 5A
     D   pRepPriority                 8S 0
     D   pLvlPriority                 1A

     D  ACCESS_BANK    PR                  Extpgm('AOBANKR0')
     D  @RTCD                         7A
     D  @OPTN                         7A
     D  DSFDY                       200A

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D LoansFile     E DS                  EXTNAME(CLOANCL)
     D FeesFile      E DS                  EXTNAME(LEFEED) PREFIX(F_)
     D LSFile        E DS                  EXTNAME(SDLOANPD)
     D FTFile        E DS                  EXTNAME(SDFACTPD)
     D FCFile        E DS                  EXTNAME(SDFEEPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D GPDWNL        E DS                  EXTNAME(GPDWNLPD)

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+

     D ParmLoan        DS
     D   LoanParm              1    100
     D     UpdLoan             1      1
     D     LoanFac             2      4
     D     LoanTyp             5      6
     D     LoanSub             7      8
     D     LFacGrp             9     11
     D     LLTSGrp            12     14
     D     LoanExM            15     15
     D     LoanDtl             2     14

     D ParmFees        DS
     D   FeeParm               1    100
     D     UpdFee              1      1
     D     FeeFac              2      4
     D     FeeLtyp             5      6
     D     FeeLSub             7      8
     D     FeeFCod             9     10
     D     FFacGrp            11     13
     D     FLTSGrp            14     16
     D     FFeeGrp            17     19
     D     FeeExM             20     20
     D     FeeDtl              2     19

     D SQLSTR          S           2000A   INZ(*BLANKS)
     D SQLLTST         S            500A   INZ(*BLANKS)
     D SQLFACT         S            500A   INZ(*BLANKS)
     D SQLFACT2        S            500A   INZ(*BLANKS)                                   //MD036881
     D SQLFEE          S            500A   INZ(*BLANKS)
     D SQLParse1       S            500A   INZ(*BLANKS)
     D SQLParse2       S            500A   INZ(*BLANKS)
     D QUO             C                   CONST('''')

     D  aCATEGORY      S              5A   DIM(4)
     D  aORIGLN        S              5A   DIM(4)
     D  aPDCL_X        S              5A   DIM(4)
     D  aPDCL_Y        S              5A   DIM(4)
     D  aPDCL_Z        S              5A   DIM(4)
     D  aLoanFee       S              5A   DIM(2)
     D  aFcltFee       S              5A   DIM(2)
     D  aLateFee       S              5A   DIM(2)
     D  Loan_Prefix    S              1A   INZ(*ZEROS)
     D  wRetCode       S              7A
     D  wOption        S              7A
     D  wAction        S              8A
     D  wFile          S             10A
     D  wLoanRef       S              6A   INZ(*BLANKS)
     D  wCustomer      S              6A   INZ(*BLANKS)
     D  wBranch        S              3A   INZ(*BLANKS)
     D  wFeeFclty      S              5S 0 INZ(*ZEROS)
     D  wFeeLoan       S              6A   INZ(*BLANKS)
     D  wFeeSeqn       S              2S 0 INZ(*ZEROS)
     D  wCategory      S              5A   INZ(*BLANKS)
     D  wRepPri        S              8S 0 INZ(*ZEROS)
     D  wLvlPri        S              1A   INZ(*BLANKS)
     D  wFTPDPPRGrp    S              3A   INZ(*BLANKS)
     D  wLSPDPPRGrp    S              3A   INZ(*BLANKS)
     D  wFCPDPPRGrp    S              3A   INZ(*BLANKS)

     D  Index          S              2S 0 INZ(*ZEROS)
     D  MAX_CATEGORY   S              2S 0 INZ(*ZEROS)

     D  @@LTYP         S              3A   INZ(*BLANKS)
     D  @@SUTP         S              3A   INZ(*BLANKS)
     D  @@CLAS         S              4A   INZ(*BLANKS)
     D  @@FACL         S              3A   INZ(*BLANKS)
     D  @@FECD         S              2A   INZ(*BLANKS)
     D  @@LNRF         S              6A   INZ(*BLANKS)
     D  wLSPDPGrpID    S              3A   INZ(*BLANKS)
     D  wFTPDPGrpID    S              3A   INZ(*BLANKS)
     D  wFCPDPGrpID    S              3A   INZ(*BLANKS)

     D  DWNLCount      S              3  0 INZ(*ZEROS)
     D  zPrefix        S              2A   INZ(*BLANKS)
     D  wKeyDesc       S             20A   INZ('PDPRepMatrixBulkUpd')
                                                                                            MD036881
     D  WCLFTYP        S              3A   INZ(*BLANKS)                                     MD036881
     D  WLTYP          S              2A   INZ(*BLANKS)                                     MD036881
     D  WSTYP          S              2A   INZ(*BLANKS)                                     MD036881
                                                                                            MD036881
     D SDSTAT        E DS                  DTAARA(SDSTAT)

     C     KUpdFees      KLIST
     C                   KFLD                    KeyBRCA           3
     C                   KFLD                    KeyCNUM           6
     C                   KFLD                    KeyFACL           5 0
     C                   KFLD                    KeyLOAN           6
     C                   KFLD                    KeyFSEQ           2 0

     C     KDWNL         KLIST
     C                   KFLD                    zPrefix
     C                   KFLD                    wKeyDesc
      /free

       // +--- Start of Main processing -----------------------------+
       // ¦                                                          ¦
       // ¦ Initial processing is performed automatically: the       ¦
       // ¦ *INZSR is executed at program activation.                ¦
       // ¦                                                          ¦
       // +----------------------------------------------------------+

                  Exsr SrDWNLUpd;

                  ParmLoan = pParm1;
                  ParmFees = pParm2;
                  If UpdLoan <> *Blank;
                     PAGE = 1;
                     Write LE000507H1;
                     If UpdLoan = 'Y' and LoanDtl <> *Blank;
                        Write LE000507H2;
                        Write LE000507H4;
                        P1UPDL = UpdLoan;
                        P1LFAC = LoanFac;
                        P1LTYP = LoanTyp;
                        P1LSTP = LoanSub;
                        P1LFGP = LFacGrp;
                        P1LLGP = LLTSGrp;
                        P1EXCL = LoanExM;
                        Write LE000507D4;
                        Exsr UpdateLoans;
                     Endif;

                     If UpdFee = 'Y' and FeeDtl <> *Blank;
                        Write LE000507H3;
                        Write LE000507H5;
                        P1UPDF = UpdFee;
                        P1FFAC = FeeFac;
                        P1FTYP = FeeLtyp;
                        P1FSTP = FeeLSub;
                        P1FCOD = FeeFCod;
                        P1FFGP = FFacGrp;
                        P1FLGP = FLTSGrp;
                        P1FFEG = FFeeGrp;
                        P1EXCF = FeeExM;
                        Write LE000507D5;
                        Exsr UpdateFees;
                     Endif;
                     Write LE000507T1;
                  Else;
                     Exsr InitLoanFee;
                     Exsr ProcessLoans;
                     Exsr ProcessFees;
                  Endif;

                  Exsr SrCloseDWNL;

                  *inlr = *on;                                                           // MD031720
                  Return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // ProcessLoans - Process Loans Extension File                *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr ProcessLoans;

       // Initialize Category Code Arrays

                  aORIGLN(1) = 'OLINT';
                  aORIGLN(2) = 'OLINM';
                  aORIGLN(3) = 'OLPRI';
                  aORIGLN(4) = 'OLPRM';

                  aPDCL_X(1) = 'XINTR';
                  aPDCL_X(2) = 'XINTM';
                  aPDCL_X(3) = 'XPRIN';
                  aPDCL_X(4) = 'XPRIM';

                  aPDCL_Y(1) = 'YINTR';
                  aPDCL_Y(2) = 'YINTM';
                  aPDCL_Y(3) = 'YPRIN';
                  aPDCL_Y(4) = 'YPRIM';

                  aPDCL_Z(1) = 'ZINTR';
                  aPDCL_Z(2) = 'ZINTM';
                  aPDCL_Z(3) = 'ZPRIN';
                  aPDCL_Z(4) = 'ZPRIM';

       //*Select*and*process*all*loans*records*tagged*as*auto-settle*         //MD037485
       // Select and process Live Loans tagged as auto-settle                 //MD037485

       //         SQLStr = 'select * from CLOANCL ' +
       //                   'where AUTO = ' + QUO + 'C' + QUO +
       //                   ' order by LNRF';

                 SQLStr = 'select * from CLOANCL ' +                           //MD037485
                          'where AUTO = ' + QUO + 'C' + QUO +                  //MD037485
                          ' and RECI = ' + QUO + 'D'  + QUO +                  //MD037485
                          ' order by LNRF';                                    //MD037485

                  Exec SQL Prepare P1 from :SQLStr;
                  Exec SQL Declare P1 cursor for P1;
                  Exec SQL Open P1;
                  Exec SQL Fetch Next From P1 into :LoansFile;

                  If Sqlcod <> 0 and Sqlcod <> 100;
                     In *Lock Lda;
                     DbKey = *Blanks;
                     DbFile = 'CLOANCL';
                     Dbase = 001;
                     DbPgm  = 'LE000507';
                     Out Lda;
                     Exsr *Pssr;
                  Endif;

                  Dow Sqlcod = 0;

                     Exsr PopulateLoans;
                     Exec SQL Fetch Next From P1 into :LoansFile;

                     If SQLCOD <> 0 and SQLCOD <> 100;
                        In *Lock Lda;
                        DbKey = *Blanks;
                        DbFile = wFile;
                        Dbase = 002;
                        DbPgm  = 'LE000507';
                        Out Lda;
                        Exsr *PSSR;
                     Endif;

                  Enddo;
                  Exec SQL Close P1;
       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // PopulateLoans - Populate Loans Extension File              *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr PopulateLoans;

       // Initialise Category Codes
                  wLSPDPGrpID = *Blanks;
                  wFTPDPGrpID = *Blanks;
                  wFCPDPGrpID = '***';

       // Retrieve SDLOANPD->PDP Group ID
                  @@LTYP = LTYP;
                  @@SUTP = SUTP;
                  @@CLAS = CLAS;
                  Exsr RetrievePDPLS;

       // Retrieve SDFACTPD->PDP Group ID
                  @@FACL = %Editc(FTYP:'X');
                  Exsr RetrievePDPFT;

                  wAction = '*INSERT';
                  wFile = 'CLOANZTD';
                  wLoanRef  = LNRF;
                  wCustomer = CNUM;
                  wBranch  = *Blanks;
                  wFeeFclty = *Zeros;
                  wFeeLoan = *Blanks;
                  wFeeSeqn = *Zeros;
                  MAX_CATEGORY = 4;


       // ********************************************************* //
       // Original Loans (Auto-Settle = 'C' and must not begin      //
       // with 'X','Y', or 'Z'                                      //
       // ********************************************************* //

                  Loan_Prefix = %SUBST(LTYP:1:1);
                  If AUTO = 'C' And (Loan_Prefix <> 'X'
                     And Loan_Prefix <> 'Y' And
                     Loan_Prefix <> 'Z');

                     aCATEGORY = %Subarr(aORIGLN:1);
                     Exsr ProcessMatrix;

                  Endif;

       // ********************************************************* //
       // PDCL Auto-Settle = 'C' and first character of loan type   //
       // begins with 'X','Y', or 'Z'                               //
       // ********************************************************* //

                  If AUTO = 'C' And (Loan_Prefix = 'X'
                     Or Loan_Prefix = 'Y' Or
                     Loan_Prefix = 'Z');

                     Select;

                        When Loan_Prefix = 'X';
                           aCATEGORY = %Subarr(aPDCL_X:1);
                           Exsr ProcessMatrix;

                        When Loan_Prefix = 'Y';
                           aCATEGORY = %Subarr(aPDCL_Y:1);
                           Exsr ProcessMatrix;

                        When Loan_Prefix = 'Z';
                           aCATEGORY = %Subarr(aPDCL_Z:1);
                           Exsr ProcessMatrix;
                     EndSl;

                  Endif;

       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // PopulateFees - Populate Fees Extension File                *
       //                                                            *
       // Called by: ProcessFees                                     *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr PopulateFees;


       // Initialise Category Codes

                     wFCPDPGrpID = *Blanks;
                     wLSPDPGrpID = *Blanks;
                     wFTPDPGrpID = *Blanks;


       // Retrieve SDFACTPD->PDP Group-ID

                     If  F_FEFACL <> *Zeros And F_FELOAN = *Blanks;
                         @@FACL = %Subst(%Editc(F_FEFACL:'X'):1:3);
                         Exsr RetrievePDPFT;

                         wLSPDPGrpID = '***';

                     Endif;


                     If  F_FEFACL = *Zeros And F_FELOAN <> *Blanks;
                         @@LNRF = F_FELOAN;
                         Exsr RetrieveLoan;

                         @@FACL = %Editc(FTYP:'X');
                         Exsr RetrievePDPFT;

       // Retrieve SDLOANPD->PDP Group-ID
                         @@LTYP = LTYP;
                         @@SUTP = SUTP;
                         @@CLAS = CLAS;
                         Exsr RetrievePDPLS;

                     Endif;


       // Retrieve SDFEEPD->PDP Group-ID
       //            @@FECD = %Editc(F_FEFSEQ:'X');                //MD038258
                     @@FECD = %Editc(F_FEFCOD:'X');                //MD038258
                     Exsr RetrievePDPFC;


                     wAction = '*INSERT';
                     wFile = 'LEFEEZTD';
                     wLoanRef  = *Blanks;
                     wCustomer = F_FECNUM;
                     wBranch  = F_FEBRCA;
                     wFeeFclty = F_FEFACL;
                     wFeeLoan = F_FELOAN;
                     wFeeSeqn = F_FEFSEQ;
                     MAX_CATEGORY = 2;


       // ********************************************************* //
       // Process Loan Fees tagged as pre-check order               //
       // ********************************************************* //

                     If F_FEFACL = *Zeros and F_FELOAN <> *Blanks
                        And F_FECALT <> '90';
                          aCATEGORY = %Subarr(aLoanFee:1);
                          Exsr ProcessMatrix;
                     Endif;


       // ********************************************************* //
       // Process Facility Fees tagged as pre-check order           //
       // ********************************************************* //

                     If F_FEFACL <> *Zeros and F_FELOAN = *Blanks
                        And F_FECALT <> '90';
                          aCATEGORY = %Subarr(aFcltFee:1);
                          Exsr ProcessMatrix;
                     Endif;


       // ********************************************************* //
       // Process Late Fees tagged as pre-check order               //
       // ********************************************************* //
                        If F_FECALT = '90';
                          aCATEGORY = %Subarr(aLateFee:1);
                          Exsr ProcessMatrix;
                     Endif;


       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // ProcessMatrix - Process Repayment Matrix                   *
       //                                                            *
       // Called by: ProcessLoans, ProcessFess                       *
       //                                                            *
       // Calls: UPDATE_MATRIX                                       *
       //                                                            *
       //*************************************************************

       Begsr ProcessMatrix;

                     For Index = 1 to MAX_CATEGORY;

                          CallP UPDATE_MATRIX(
                                  wRetCode
                                : wAction
                                : wFile
                                : wLoanRef
                                : wBranch
                                : wCustomer
                                : wFeeFclty
                                : wFeeLoan
                                : wFeeSeqn
                                : wLSPDPGrpID
                                : wFTPDPGrpID
                                : wFCPDPGrpID
                                : aCATEGORY(Index)
                                );
                          If wRetCode <> *Blanks;
                               In *Lock Lda;
                               DbKey = *Blanks;
                               DbFile = wFile;
                               Dbase = 003;
                               DbPgm  = 'LE000507';
                               Out Lda;
                               Exsr *Pssr;
                          Endif;

                     Endfor;
       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // ProcessFees - Process Fees Extension File                  *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr ProcessFees;

       // Initialize Category Code Arrays

                     aLoanFee(1) = 'LFEE ';
                     aLoanFee(2) = 'LFEM ';

                     aFcltFee(1) = 'FFEE ';
                     aFcltFee(2) = 'FFEM ';

                     aLateFee(1) = 'Fee90';
                     aLateFee(2) = 'Fee9M';

       //            SQLStr = 'select * from LEFEED  ' +                               //MD037485
       //                     'where FEAUTO = ' + QUO + 'C' + QUO +                    //MD037485
       //                     ' order by FEBRCA, FECNUM, FEFACL,FELOAN, FEFSEQ';       //MD037485

                     SQLStr = 'select * from LEFEED ' +                                //MD037485
                              'where FEAUTO = ' + QUO + 'C' + QUO +                    //MD037485
                              'and FERECI = ' + QUO + 'D' + QUO +                      //MD037485
                           ' order by FEBRCA, FECNUM, FEFACL, FELOAN, FEFSEQ';         //MD037485

                     Exec SQL Prepare P2 from :SQLStr;
                     Exec SQL Declare P2 Cursor for P2;
                     Exec SQL Open P2;
                     Exec SQL Fetch Next From P2 into :FeesFile;

                     If Sqlcod <> 0 and Sqlcod <> 100;
                         In *Lock Lda;
                         DbKey = *Blanks;
                         DbFile = 'LEFEED';
                         Dbase = 004;
                         DbPgm  = 'LE000507';
                         Out Lda;
                         Exsr *Pssr;
                     Endif;

                     Dow   SQLCOD = 0;

                          Exsr PopulateFees;
                          Exec SQL Fetch Next From P2 into :FeesFile;

                          If Sqlcod <> 0 and Sqlcod <> 100;
                               In *Lock Lda;
                               DbKey = *Blanks;
                               DbFile = wFile;
                               Dbase = 005;
                               DbPgm  = 'LE000507';
                               Out Lda;
                               Exsr *PSSR;
                          Endif;

                     Enddo;
                     Exec SQL Close P2;

       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // RetrievePDPLS - Retrieve Loan Type/Subtype PDP Group ID    *
       //                                                            *
       // Called by: Populate Fees                                   *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr RetrievePDPLS;

       //Retrieve Loan Type/SubType Group ID

                     SQLStr = 'select * from SDLOANPD ' +
                              'where AYLNTY = ' + QUO + @@LTYP + QUO +
                              ' and ' +
                              ' AYLNST = ' + QUO + @@SUTP + QUO +
                              ' and ' +
                              ' AYLNCL = ' + QUO + @@CLAS + QUO;
                              Exec SQL Prepare P3 from :SQLStr;
                              Exec SQL Declare P3 Cursor for P3;
                              Exec SQL Open P3;
                              Exec SQL Fetch P3 into :LSFile;

                              If Sqlcod <> 0 and Sqlcod <> 100;
                                   In *Lock Lda;
                                   DbKey = @@LTYP + ' ' + @@SUTP;
                                   DbFile = 'SDLOANPD';
                                   Dbase = 006;
                                   DbPgm  = 'LE000507';
                                   Out Lda;
                                   Exsr *PSSR;
                              Endif;

                              wLSPDPGrpID = AYPGID;
                              Exec SQL Close P3;

       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // RetrievePDPFT - Retrieve Facility Type PDP Group ID        *
       //                                                            *
       // Called by: PopulateLoans, PopulateFees                     *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr RetrievePDPFT;

       //Retrieve Facility Types PDP Group ID

                     SQLStr = 'select * from SDFACTPD ' +
                              'where AMFCTY = ' +  @@FACL;

                     Exec SQL Prepare P4 from :SQLStr;
                     Exec SQL Declare P4 Cursor for P4;
                     Exec SQL Open P4;
                     Exec SQL Fetch P4 into :FTFile;

                     If Sqlcod <> 0 and Sqlcod <> 100;
                          In *Lock Lda;
                          DbKey = @@FACL;
                          DbFile = 'SDFACTPD';
                          Dbase = 007;
                          DbPgm  = 'LE000507';
                          Out Lda;
                          Exsr *Pssr;
                     Endif;

                     wFTPDPGrpID = AMPGID;
                     Exec SQL Close P4;

       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // RetrievePDPFC - Retrieve Fee Codes PDP Group ID            *
       //                                                            *
       // Called by: PopulateFees                                    *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr RetrievePDPFC;

       //Retrieve Fee Codes  PDP Group ID

                     SQLStr = 'SELECT * FROM SDFEEPD ' +
                              'WHERE AUFECD = ' +  @@FECD;
                     Exec SQL Prepare P5 from :SQLStr;
                     Exec SQL Declare P5 Cursor for P5;
                     Exec SQL Open P5;
                     Exec SQL Fetch P5 into :FCFile;

                     If Sqlcod <> 0 and Sqlcod <> 100;
                          In *Lock Lda;
                          DbKey = @@FECD;
                          DbFile = 'SDFEEPD';
                          Dbase = 008;
                          Out Lda;
                          Exsr *Pssr;
                     Endif;

                     wFCPDPGrpID = AUPGID;
                     Exec SQL Close P5;

       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // RetrieveLoan - Retrieve Loan Details                       *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr RetrieveLoan;

       //Retrieve Loan Record

                     SQLStr = 'SELECT * FROM CLOANCL ' +
                              'WHERE LNRF  = ' +  QUO + @@LNRF + QUO;
                     Exec SQL Prepare P6 from :SQLStr;
                     Exec SQL Declare P6 Cursor for P6;
                     Exec SQL Open P6;
                     Exec SQL Fetch P6 into :LoansFile;
                     If Sqlcod <> 0 and Sqlcod <> 100;
                          In *Lock Lda;
                          DbKey = @@LNRF;
                          DbFile = 'CLOANCL';
                          Dbase = 009;
                          Out Lda;
                          Exsr *Pssr;
                     Endif;
                     Exec SQL Close P6;

       Endsr;

       //*************************************************************
       //                                                            *
       // UpdateLoans - Updates Loans Extension File                 *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr UpdateLoans;

                  If LoanFac = *Blank;
                     LoanFac = '000';
                  Endif;

                  If LFacGrp <> *Blank;
                     SQLFACT = 'or FTYP in (select AMFCTY from SDFACTPD ' +
                               'where AMPGID = ' + QUO + LFacGrp + QUO + ')';
                  Endif;

                  If LLTSGrp <> *Blank;
                     SQLLTST = 'or (LTYP, SUTP) in (select AYLNTY, AYLNST ' +
                               'from SDLOANPD where AYPGID = ' + QUO + LLTSGrp +
                               QUO + ')';
                  Endif;

                  SQLStr = 'select * from CLOANCL where ' +
                           'AUTO = ''C'' and ' +
                           'RECI = ''D'' and ' +
                           '(FTYP = ' + QUO + LoanFac + QUO + ' or ' +
                           '(LTYP = ' + QUO + LoanTyp + QUO + ' and ' +
                           'SUTP = ' + QUO + LoanSub + QUO + ')' +
                           ' ' + %Trim(SQLFACT) + ' ' + %Trim(SQLLTST) +
                           ')';

                  Exec SQL Prepare CurLoan from :SQLStr;
                  Exec SQL Declare CurLoan cursor for CurLoan;
                  Exec SQL Open CurLoan;
                  Exec SQL Fetch Next From CurLoan into :LoansFile;

                  If Sqlcod <> 0 and Sqlcod <> 100;
                     In *Lock Lda;
                     DbKey = *Blanks;
                     DbFile = 'CLOANCL';
                     Dbase = 001;
                     DbPgm  = 'LE000507';
                     Out Lda;
                     Exsr *Pssr;
                  Endif;

                  Dow Sqlcod = 0;

                     SetLL LNRF CLOANZI0;
                     ReadE LNRF CLOANZI0;

                     Dow %FOUND(CLOANZI0);
                        If LXLEVL <> 'M' and
                           LXLNRF = LNRF or
                           LXLEVL = 'M' and LoanExM = 'N' and
                           LXLNRF = LNRF;
                           wCategory = LXCATE;
                           wFCPDPPRGrp = '***';

                           Exec SQL
                           select AMPGID into :wFTPDPPRGrp from SDFACTPD
                           where AMFCTY = :FTYP;

                           Exec SQL
                           select AYPGID into :wLSPDPPRGrp from SDLOANPD
                           where AYLNTY = :LTYP and AYLNST = :SUTP;

                           CallP RETRIEVE_REPR(  wRetCode
                                               : wFTPDPPRGrp
                                               : wLSPDPPRGrp
                                               : wFCPDPPRGrp
                                               : wCategory
                                               : wRepPri
                                               : wLvlPri
                                               );

                           LXREPR = wRepPri;
                           LXLEVL = wLvlPri;
                           LXLDAT = BJRDNB;
                           LXLTYP = 'A';
                           LXLUSR = %Trim(PSUSER);

                           Update CLOANZD0;

                        EndIf;

                        If LXLNRF <> LNRF;
                           Leave;
                        Endif;

                        Read CLOANZI0;
                        If %EOF(CLOANZI0);
                           Leave;
                        EndIf;

                     Enddo;

                     Exec SQL Fetch Next From CurLoan into :LoansFile;

                     If SQLCOD <> 0 and SQLCOD <> 100;
                        In *Lock Lda;
                        DbKey = *Blanks;
                        DbFile = 'CLOANZTD';
                        Dbase = 002;
                        DbPgm  = 'LE000507';
                        Out Lda;
                        Exsr *PSSR;
                     Endif;

                  Enddo;
                  Exec SQL Close CurLoan;

       Endsr;

       //*************************************************************
       //                                                            *
       // UpdateFees - Updates Fees Extension File                   *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr UpdateFees;

                  If FeeFCod = *Blank;
                     FeeFCod = '00';
                  EndIf;

                  //Initializa SQL strings to avoid conflict on common variables between  //MD034789
                  //loans and fees extracts                                               //MD034789

                  SQLFACT = *Blanks;                                                      //MD034789
                  SQLFACT2 = *Blanks;                                                     //MD034789
                  SQLLTST = *Blanks;                                                      //MD034789
                  SQLFEE = *Blanks;                                                       //MD034789


                  If FFacGrp <> *Blank;
                     SQLFACT = 'or left(FEFACL,3) in (select AMFCTY from ' +
                               'SDFACTPD where AMPGID = ' + QUO + FFacGrp +
                               QUO + ')';
                     SQLFACT2 = 'or(FELOAN <> ' + QUO + QUO + '  +
                                and FEFACL = 0) and +
                                (select FTYP from CLOANCL where +
                                LNRF = FELOAN) in +
                                (select AMFCTY from SDFACTPD where +
                                AMPGID = ' + QUO + FFacGrp + QUO + ')';                  //MD036881
                  Endif;

                  If FLTSGrp <> *Blank;
                     SQLLTST = 'or (FELTYP, FESUTP) in (select AYLNTY, AYLNST' +
                               ' from SDLOANPD where AYPGID = ' + QUO +
                               FLTSGrp + QUO + ')';
                  Endif;

                  If FFeeGrp <> *Blank;
                     SQLFEE = 'or FEFCOD in (select AUFECD from SDFEEPD ' +
                              'where AUPGID = ' + QUO + FFeeGrp + QUO + ')';
                  Endif;

                  If FeeFac <> *Blank;
                     SQLParse1 = 'left(FEFACL,3) = ' + QUO + FeeFac + QUO +
                                 ' or ';
                  Endif;

                  If FeeLTyp <> *Blank and FeeLSub <> *Blank;
                     SQLParse2 = '(FELTYP = ' + QUO + FeeLTyp + QUO + ' and ' +
                                 'FESUTP = ' + QUO + FeeLSub + QUO + ') or ';
                  Endif;

                  SQLStr = 'select * from LEFEED where ' +
                           'FEAUTO = ''C'' and ' +
                           'FERECI = ''D'' and ' +
                           '(' +
                           %Trim(SQLParse1) + ' ' + %Trim(SQLParse2) + ' ' +
                           'FEFCOD = ' + QUO + FeeFCod + QUO +
                           //%Trim(SQLFACT) + ' ' +  %Trim(SQLLTST) + ' ' +                MD036881
                           %Trim(SQLFACT) + ' ' +  %Trim(SQLFACT2) + ' ' +
                           %Trim(SQLLTST) + ' ' +                                        //MD036881
                           %Trim(SQLFEE) + ' ' +
                           ')';

                  Exec SQL Prepare CurFee from :SQLStr;
                  Exec SQL Declare CurFee cursor for CurFee;
                  Exec SQL Open CurFee;
                  Exec SQL Fetch Next From CurFee into :FeesFile;

                  If Sqlcod <> 0 and Sqlcod <> 100;
                     In *Lock Lda;
                     DbKey = *Blanks;
                     DbFile = 'LEFEED';
                     Dbase = 001;
                     DbPgm  = 'LE000507';
                     Out Lda;
                     Exsr *Pssr;
                  Endif;

                  Dow Sqlcod = 0;

                     KeyBRCA = F_FEBRCA;
                     KeyCNUM = F_FECNUM;
                     KeyFACL = F_FEFACL;
                     KeyLOAN = F_FELOAN;
                     KeyFSEQ = F_FEFSEQ;

                     SetLL KUpdFees LEFEEZI0;
                     ReadE KUpdFees LEFEEZI0;

                     Dow %FOUND(LEFEEZI0);
                        If FXLEVL <> 'M' and
                           FXBRCA = F_FEBRCA and
                           FXCNUM = F_FECNUM and
                           FXFACL = F_FEFACL and
                           FXLOAN = F_FELOAN and
                           FXFSEQ = F_FEFSEQ or
                           FXLEVL = 'M' and FeeExM = 'N' and
                           FXBRCA = F_FEBRCA and
                           FXCNUM = F_FECNUM and
                           FXFACL = F_FEFACL and
                           FXLOAN = F_FELOAN and
                           FXFSEQ = F_FEFSEQ;

                           wCategory = FXCATE;

                           Exec SQL
                           select AUPGID into :wFCPDPPRGrp from SDFEEPD
                           where AUFECD = :F_FEFCOD;
                           //If wFCPDPPRGrp = *Blank;                                       MD036881
                           //   wFCPDPPRGrp = '***';                                        MD036881
                           //Endif;                                                         MD036881

                           If F_FEFACL <> 0;
                              Exec SQL
                              select AMPGID into :wFTPDPPRGrp from SDFACTPD
                              where AMFCTY = left(:F_FEFACL,3);
                              //If wFTPDPPRGrp = *Blank;                                    MD036881
                              //   wFTPDPPRGrp = '***';                                     MD036881
                              //Endif;                                                      MD036881
                           //Else;                                                          MD036881
                           // wFTPDPPRGrp = '***';                                          MD036881
                           Endif;

                           //Start of Change MD036881
                           // For Loan Fees Get the Facility of the associated Loan
                           // then get the Priority Group Id for the Facility

                           If F_FEFACL = 0 and F_FELOAN <> *Blank;
                              Exec SQL
                              select FTYP into :wCLFTYP from CLOANCL
                              where LNRF = :F_FELOAN;

                              Exec SQL
                              select AMPGID into :wFTPDPPRGrp from SDFACTPD
                              where AMFCTY = :wCLFTYP;
                           Endif;
                           //End of Change MD036881

                           If F_FELOAN <> *Blank;
                              Exec SQL
                              select LTYP,SUTP into :WLTYP, :WSTYP
                              from CLOANCL
                              where LNRF = :F_FELOAN;

                              Exec SQL
                              select AYPGID into :wLSPDPPRGrp from SDLOANPD
                              where AYLNTY = :WLTYP and AYLNST = :WSTYP;                  //MD036881
                              //where AYLNTY = :LTYP and AYLNST = :SUTP;                    MD036881
                              //If wLSPDPPRGrp = *Blank;                                    MD036881
                              //   wLSPDPPRGrp = '***';                                     MD036881
                              //Endif;                                                      MD036881
                           //Else;                                                          MD036881
                           // wLSPDPPRGrp = '***';                                          MD036881
                           Endif;

                           CallP RETRIEVE_REPR(  wRetCode
                                               : wFTPDPPRGrp
                                               : wLSPDPPRGrp
                                               : wFCPDPPRGrp
                                               : wCategory
                                               : wRepPri
                                               : wLvlPri
                                               );

                           FXREPR = wRepPri;
                           FXLEVL = wLvlPri;
                           FXLDAT = BJRDNB;
                           FXLTYP = 'A';
                           FXLUSR = %Trim(PSUSER);

                           Update LEFEEZD0;

                        EndIf;

                        If FXBRCA <> F_FEBRCA and
                           FXCNUM <> F_FECNUM and
                           FXFACL <> F_FEFACL and
                           FXLOAN <> F_FELOAN and
                           FXFSEQ <> F_FEFSEQ;
                           Leave;
                        Endif;

                        Read LEFEEZI0;
                        If %EOF(LEFEEZI0);
                           Leave;
                        Endif;

                     Enddo;

                     Exec SQL Fetch Next From CurFee into :FeesFile;

                     If SQLCOD <> 0 and SQLCOD <> 100;
                        In *Lock Lda;
                        DbKey = *Blanks;
                        DbFile = 'LEFEEZTD';
                        Dbase = 002;
                        DbPgm  = 'LE000507';
                        Out Lda;
                        Exsr *PSSR;
                     Endif;

                  Enddo;
                  Exec SQL Close CurFee;

       Endsr;

       //*************************************************************
       //                                                            *
       // InitLoanFee - Initialize CLOANZTD and LEFEEZTD             *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr InitLoanFee;

                  Exec sql
                  Delete from CLOANZTD;

                  Exec sql
                  Delete from LEFEEZTD;
       Endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   *INZSR - Program Init Processing Subroutine.             *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       Begsr *INZSR;

                  wRetCode = '*MSG';
                  wOption = '*FIRST';
                  CallP ACCESS_BANK(  wRetCode
                                    : wOption
                                    : DSFDY
                                    );
                  SDBANK = DSFDY;

                  If wRetCode <> *Blank;
                     In Lda;
                     DbKey = '*FIRST';
                     DbFile = 'SDBANKPD';
                     Dbase = 004;
                     DbPgm    = 'LE000506';
                     Out Lda;
                     Exsr *Pssr;
                  Endif;

       Endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   SrDWNLUpd - Update GPDWNLPD                              *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       Begsr SrDWNLUpd;
                   In SDSTAT;
                   zPrefix = Libr;
                   Chain KDWNL GPDWNLL0;
                   If %Found(GPDWNLL0);
                   DLVAL = 'Y';
                   Update @DWNLL0;
                   EndIf;
       Endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   SrCloseDWNL - Finish update of extension files           *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       Begsr SrCloseDWNL;
                   Chain KDWNL GPDWNLL0;
                   If %Found(GPDWNLL0);
                   DLVAL = 'N';
                   Update @DWNLL0;
                   EndIf;
       Endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   *Pssr  - Program Error Processing Subroutine.            *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       Begsr *Pssr;
                  *Inu7 = *ON;
                  *Inu8 = *ON;
                  Dump;
                  *Inlr = *ON;
                  Return;
       Endsr;

      /end-free

