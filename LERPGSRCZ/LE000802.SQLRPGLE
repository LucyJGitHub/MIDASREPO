     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Retrieve Repayment Priority')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000802 - Midas LE Retrieve Repayment Priority              *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CLE138             Date 02Nov21               *
      *  Prev Amend No. CLE172             Date 01Oct20               *
      *                 CSD103             Date 10Aug20               *
      *                 CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE164 *CREATE     Date 18Aug14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CLE138 - Class Codes for Facilities                          *
      *  CLE172 - LIBOR Deregulation - Lending (Recompile)            *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
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

     D Main            PR                  EXTPGM('LE000802')
     D pReturnCode                    7A
     D pCategoryCode                  5A
     D pFile                         10A
     D pLoan                          6A
     D pBranch                        3A
     D pCustomer                      6A
     D pFacility                      5S 0
     D pFeeSequence                   2S 0
     D pRepPriority                   8S 0
     D pOvrdftflg                     1A

     D Main            PI
     D pReturnCode                    7A
     D pCategoryCode                  5A
     D pFile                         10A
     D pLoan                          6A
     D pBranch                        3A
     D pCustomer                      6A
     D pFacility                      5S 0
     D pFeeSequence                   2S 0
     D pRepPriority                   8S 0
     D pOvrdftflg                     1A

     D ACCESS_FILE     PR                  EXTPGM('LE000506')
     D  pRetCode                      7A
     D  pAction                       8A
     D  pFile                        10A
     D  pLoanRef                      6A
     D  pBranch                       3A
     D  pCustomer                     6A
     D  pFeeFclty                     5S 0
     D  pFeeLoan                      6A
     D  pFeeSeqn                      2S 0
     D  pLSPDPGrpID                   3A
     D  pFTPDPGrpID                   3A
     D  pFCPDPGrpID                   3A
     D  pCategory                     5A

     D ACCESS_LOAN     PR                  EXTPGM('AOLOANR1')
     D  pRTCD                         7A
     D  pOPTN                         7A
     D  pLTYP                         2A
     D  pSUTP                         2A
     D  pCLAS                         2A
     D  pDSSDY                      800A

     D ACCESS_FACT     PR                  EXTPGM('AOFACTR0')
     D  pRTCD                         7A
     D  pOPTN                         7A
     D  pFACT                         3A
     D  @@CLAS                        4A                                                      CLE138
     D  pDSSDY                      800A

     D ACCESS_FEE      PR                  EXTPGM('AOFEER0')
     D  pRTCD                         7A
     D  pOPTN                         7A
     D  pFEE                          2A
     D  pDSSDY                      800A
                                                                                              CLE138
     D  check_SARD     pr                  extpgm('AOSARDR0')                                 CLE138
     D    pReturnCode                 7A                                                      CLE138
     D    pOption                     7A                                                      CLE138
     D    pSARD                       6A                                                      CLE138
     D    pDSSDY1                   200A                                                      CLE138
      **---------------------------------------------------------------
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D DSFees        E DS                  EXTNAME(LEFEEZTD)
     D DSLoans       E DS                  EXTNAME(CLOANZTD)
     D DSCLIP        E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(LN_)
     D DSFEEM        E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(FE_)
     D DSSDLOAN      E DS                  EXTNAME(SDLOANPD)
     D DSSDFACT      E DS                  EXTNAME(SDFACTPD)
     D DSSDFEE       E DS                  EXTNAME(SDFEEPD)
     D SCSARD        e ds                  EXTNAME(SCSARDPD)                                  CLE138

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D SQLSTR          S           2000A   INZ(*BLANKS)
     D qPDPGrp         S           2000A   INZ(*BLANKS)
     D QUO             C                   CONST('''')
     D OrigLoan        S              6A
     D LTYPPref        S              1A

     D  pRetCode       S              7A
     D  pAction        S              8A
     D  pLoanRef       S              6A
     D  pFeeFclty      S              5S 0
     D  pFeeLoan       S              6A
     D  pFeeSeqn       S              2S 0
     D  pLSPDPGrpID    S              3A
     D  pFTPDPGrpID    S              3A
     D  pFCPDPGrpID    S              3A
     D  pCategory      S              5A
     D  pRTCD          S              7A
     D  pOPTN          S              7A
     D  pLTYP          S              2A
     D  pSUTP          S              2A
     D  pCLAS          S              2A
     D  pFACT          S              3A
     D  @@CLAS         S              4A                                                      CLE138
     D  @@CUST         S              6A                                                      CLE138
     D  @@FTYP         S              3A                                                      CLE138
     D  @@FSEQ         S              2A                                                      CLE138
     D  pFEE           S              2A
     D  pDSSDY         S            800A
     D  wREPR          S              8S 0
     D CLE138          s              1a                                                      CLE138
     D pOption         s              7A                                                      CLE138
     D pSARD           s              6A                                                      CLE138
     D pDSSDY1         s            200A                                                      CLE138

      /free

       // Start of Main processing
       //   Initial processing is performed automatically:
       //   *INZSR is executed at program activation.

                  Exsr RetrieveRepaymentPriority;

                  *Inlr = *On;
                  Return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // RetrieveRepaymentPriority - Retrieve Repayment Priority    *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       BegSr RetrieveRepaymentPriority;

                   Select;

                      When pFile = 'CLOANZTD';
                         SQLStr = 'select * from CLOANZTD ' +
                                  'where ' +
                                  'LXLNRF = ' + QUO + pLoan + QUO +
                                  ' And ' +
                                  'LXCATE = ' + QUO + pCategoryCode +
                                  QUO;
                      When pFile = 'LEFEEZTD';
                         SQLStr = 'select * from LEFEEZTD ' +
                                  'where ' +
                                  'FXBRCA = ' + QUO + pBranch + QUO +
                                  ' And ' +
                                  'FXCNUM = ' + QUO + pCustomer +
                                  QUO +
                                  ' And ' +
                                  'FXLOAN = ' + QUO + pLoan +
                                  QUO +
                                  ' And ' +
                                  'FXFACL = ' + %EditC(pFacility:'X') +

                                  ' And ' +
                                  'FXFSEQ = ' + %EditC(pFeeSequence:
                                                'X') +
                                  ' And ' +
                                  'FXCATE = ' + QUO + pCategoryCode +
                                  QUO;

                   EndSl;

                      Exec Sql Prepare P1 from :SQLStr;
                      Exec Sql Declare P1 cursor for P1;
                      Exec Sql Prepare P2 from :SQLStr;
                      Exec Sql Declare P2 cursor for P2;

                   If pFile = 'CLOANZTD';
                      Exec Sql Open P1;
                      Exec Sql Fetch P1 into :DSLoans;
                   Else;
                      Exec Sql Open P2;
                      Exec Sql Fetch P2 into :DSFees;
                   Endif;

                   if Sqlcod <> 0 and SqlCod <> 100;
                      If pFile = 'CLOANZTD';
                         DbFile = 'CLOANZTD';
                         DbKey  = %Trim(pCategoryCode) + ' ' +
                                  %Trim(pLoan);
                      Else;
                         DbFile = 'LEFEEZTD';
                         DbKey  = %Trim(pCategoryCode) + ' ' +
                                  %Trim(pBranch) + ' ' +
                                  %Trim(pCustomer) + ' ' +
                                  %Trim(pLoan) + ' ' +
                                  %EditC(pFacility:'X') + ' ' +
                                  %EditC(pFeeSequence:'X');
                      Endif;
                      Dbase  = 1;
                      DbPgm  = 'LE000802';
                      Exsr *Pssr;
                   Else;
                      If SqlCod = 100;
                         pAction = '*INSERT';
                         pCategory = pCategoryCode;
                         If pFile = 'CLOANZTD';
                            pLoanRef = pLoan;
                         Else;
                            pFeeFclty = pFacility;
                            pFeeLoan = pLoan;
                            pFeeSeqn = pFeeSequence;
                         Endif;
                         Exsr SRPGPGroupID;
                         Exsr SRAccessFile;
                      Else;
                         Exsr SRRetOvfl;
                         If pFile = 'CLOANZTD';
                            pRepPriority = LXREPR;
                         Else;
                            pRepPriority = FXREPR;
                         Endif;
                      Endif;
                   Endif;

                   If pFile = 'CLOANZTD';
                      exec sql
                      select * into :DSLoans from CLOANZTD
                      where
                      LXLNRF = :pLoan and
                      LXCATE = :pCategory;
                      wREPR = LXREPR;
                      pRepPriority = LXREPR;
                   Else;
                      exec sql
                      select * into :DSFees from LEFEEZTD
                      where
                      FXBRCA = :pBranch and
                      FXCNUM = :pCustomer and
                      FXFACL = :pFacility and
                      FXLOAN = :pLoan and
                      FXFSEQ = :pFeeSequence and
                      FXCATE = :pCategory;
                      wREPR = FXREPR;
                      pRepPriority = FXREPR;
                   EndIf;

                   If wREPR = 0;
                      pAction = '*DELETE';
                      If pFile = 'CLOANZTD';
                         pLoanRef = pLoan;
                      Else;
                         pFeeFclty = pFacility;
                         pFeeLoan = pLoan;
                         pFeeSeqn = pFeeSequence;
                      Endif;
                      Exsr SRAccessFile;

                      pAction = '*INSERT';
                      pCategory = pCategoryCode;
                      If pFile = 'CLOANZTD';
                         pLoanRef = pLoan;
                      Else;
                         pFeeFclty = pFacility;
                         pFeeLoan = pLoan;
                         pFeeSeqn = pFeeSequence;
                      Endif;
                      Exsr SRPGPGroupID;
                      Exsr SRAccessFile;
                   EndIf;

                   If pFile = 'CLOANZTD';
                      exec sql
                      select * into :DSLoans from CLOANZTD
                      where
                      LXLNRF = :pLoan and
                      LXCATE = :pCategory;
                      wREPR = LXREPR;
                      pRepPriority = LXREPR;
                   Else;
                      exec sql
                      select * into :DSFees from LEFEEZTD
                      where
                      FXBRCA = :pBranch and
                      FXCNUM = :pCustomer and
                      FXFACL = :pFacility and
                      FXLOAN = :pLoan and
                      FXFSEQ = :pFeeSequence and
                      FXCATE = :pCategory;
                      wREPR = FXREPR;
                      pRepPriority = FXREPR;
                   EndIf;

                   If pFile = 'CLOANZTD';
                      Exec Sql Close P1;
                   Else;
                      Exec Sql Close P2;
                   Endif;

       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // SRAccessFile - Access/Update Loan/Fee Extension File       *
       //                                                            *
       // Called by: RetrieveRepaymentPriority                       *
       //                                                            *
       // Calls: ACCESS_FILE                                         *
       //                                                            *
       //*************************************************************

       Begsr SRAccessFile;
                   CallP ACCESS_FILE (  pRetCode
                                      : pAction
                                      : pFile
                                      : pLoanRef
                                      : pBranch
                                      : pCustomer
                                      : pFeeFclty
                                      : pFeeLoan
                                      : pFeeSeqn
                                      : pLSPDPGrpID
                                      : pFTPDPGrpID
                                      : pFCPDPGrpID
                                      : pCategory
                                        );
       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // SRPDPGroupID - Access PDP Priority Group ID                *
       //                                                            *
       // Called by: RetrieveRepaymentPriority                       *
       //                                                            *
       // Calls: AOLOANR0, AOFEER0, AOFACTR0                         *
       //                                                            *
       //*************************************************************

       Begsr SRPGPGroupID;
                   pRTCD = ' ';
                   pOPTN = '*KEY';

                   If pFile = 'CLOANZTD';
                      exec sql
                      select * into :DSCLIP from CLOANCL
                      where
                      LNRF = :pLoan;
                      CallP ACCESS_LOAN (  pRTCD
                                         : pOPTN
                                         : LN_LTYP
                                         : LN_SUTP
                                         : LN_CLAS
                                         : pDSSDY
                                           );

                      LTYPPref = %Subst(LN_LTYP:1:1);
                      If LTYPPref = 'X' or LTYPPref = 'Y' or
                         LTYPPref = 'Z';
                         If LN_ORLN <> *Blank;
                            OrigLoan = LN_ORLN;
                            exec sql
                            select * into :DSCLIP from CLOANCL
                            where
                            LNRF = :OrigLoan;
                            CallP ACCESS_LOAN (  pRTCD
                                               : pOPTN
                                               : LN_LTYP
                                               : LN_SUTP
                                               : LN_CLAS
                                               : pDSSDY
                                                 );
                         Endif;
                      Endif;
                      DSSDLOAN = pDSSDY;
                      pOvrdftflg = AYOVRD;

                      pFACT = %EditC(LN_FTYP:'X');
                                                                                            //CLE138
                      @@CLAS = *Blanks;                                                     //CLE138
                      if CLE138 = 'Y';                                                      //CLE138
                         @@CUST = LN_FCUS;                                                  //CLE138
                         @@FTYP = %EditC(LN_FTYP:'X');                                      //CLE138
                         @@FSEQ = %EditC(LN_FSEQ:'X');                                      //CLE138
                         exsr RetrieveClass;                                                //CLE138
                      endif;                                                                //CLE138

                      CallP ACCESS_FACT (  pRTCD
                                         : pOPTN
                                         : pFACT
                                         : @@CLAS                                           //CLE138
                                         : pDSSDY
                                           );
                      DSSDFACT = pDSSDY;
                      pLSPDPGrpID = AYPGID;
                      pFTPDPGrpID = AMPGID;
                      pFCPDPGrpID = '***';

                   Else;
                      pFEE = %EditC(pFeeSequence:'X');
                      CallP ACCESS_FEE (  pRTCD
                                        : pOPTN
                                        : pFEE
                                        : pDSSDY
                                          );
                      DSSDFEE = pDSSDY;
                      pOvrdftflg = AUOVRA;
                      If pFacility = 00000;
                         exec sql
                         select * into :DSCLIP from CLOANCL
                         where
                         LNRF = :pLoan;
                         CallP ACCESS_LOAN (  pRTCD
                                            : pOPTN
                                            : LN_LTYP
                                            : LN_SUTP
                                            : LN_CLAS
                                            : pDSSDY
                                              );
                         DSSDLOAN = pDSSDY;

                         pFACT = %EditC(LN_FTYP:'X');
                                                                                            //CLE138
                         @@CLAS = *Blanks;                                                  //CLE138
                         if CLE138 = 'Y';                                                   //CLE138
                            @@CUST = LN_FCUS;                                               //CLE138
                            @@FTYP = %EditC(LN_FTYP:'X');                                   //CLE138
                            @@FSEQ = %EditC(LN_FSEQ:'X');                                   //CLE138
                            exsr RetrieveClass;                                             //CLE138
                         endif;                                                             //CLE138
                                                                                            //CLE138
                         CallP ACCESS_FACT (  pRTCD
                                            : pOPTN
                                            : pFACT
                                            : @@CLAS                                        //CLE138
                                            : pDSSDY
                                              );
                         DSSDFACT = pDSSDY;
                         pLSPDPGrpID = AYPGID;
                         pFTPDPGrpID = AMPGID;
                         pFCPDPGrpID = AUPGID;
                      Else;
                         pFACT = %EditC(pFacility:'X');
                                                                                            //CLE138
                         @@CLAS = *Blanks;                                                  //CLE138
                         if CLE138 = 'Y';                                                   //CLE138
                            @@CUST = pCustomer;                                             //CLE138
                            @@FTYP = %Subst(%EditC(pFacility:'X'):1:3);                     //CLE138
                            @@FTYP = %Subst(%EditC(pFacility:'X'):4:2);                     //CLE138
                            exsr RetrieveClass;                                             //CLE138
                         endif;                                                             //CLE138
                                                                                            //CLE138
                         CallP ACCESS_FACT (  pRTCD                                         //CLE138
                                            : pOPTN
                                            : pFACT
                                            : @@CLAS                                        //CLE138
                                            : pDSSDY
                                              );
                         DSSDFACT = pDSSDY;
                         pFTPDPGrpID = AMPGID;
                         pFCPDPGrpID = AUPGID;
                         pLSPDPGrpID = '***';
                      EndIf;
                   EndIf;
       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // SRRetOvfl - Access PDP Overdraft Flag                     *
       //                                                            *
       // Called by:                                                 *
       //                                                            *
       // Calls: AOLOANR0, AOFEER0                                   *
       //                                                            *
       //*************************************************************

       BegSR SRRetOvfl;
                   pRTCD = ' ';
                   pOPTN = '*KEY';

                   If pFile = 'CLOANZTD';
                      exec sql
                      select * into :DSCLIP from CLOANCL
                      where
                      LNRF = :pLoan;
                      CallP ACCESS_LOAN (  pRTCD
                                         : pOPTN
                                         : LN_LTYP
                                         : LN_SUTP
                                         : LN_CLAS
                                         : pDSSDY
                                           );

                      LTYPPref = %Subst(LN_LTYP:1:1);
                      If LTYPPref = 'X' or LTYPPref = 'Y' or
                         LTYPPref = 'Z';
                         If LN_ORLN <> *Blank;
                            OrigLoan = LN_ORLN;
                            exec sql
                            select * into :DSCLIP from CLOANCL
                            where
                            LNRF = :OrigLoan;
                            CallP ACCESS_LOAN (  pRTCD
                                               : pOPTN
                                               : LN_LTYP
                                               : LN_SUTP
                                               : LN_CLAS
                                               : pDSSDY
                                                 );
                         Endif;
                      Endif;
                      DSSDLOAN = pDSSDY;
                      pOvrdftflg = AYOVRD;
                   Else;
                      pFEE = %EditC(pFeeSequence:'X');
                      CallP ACCESS_FEE (  pRTCD
                                        : pOPTN
                                        : pFEE
                                        : pDSSDY
                                          );
                      DSSDFEE = pDSSDY;
                      pOvrdftflg = AUOVRA;
                   Endif;

       Endsr;

       //*************************************************************                      //CLE138
       /EJECT                                                                               //CLE138
       //*************************************************************                      //CLE138
       //                                                            *                      //CLE138
       // RetrieveClass - Get class code from LEFCLTQD               *                      //CLE138
       //                                                            *                      //CLE138
       // Called by: Various                                         *                      //CLE138
       //                                                            *                      //CLE138
       // Calls: None                                                *                      //CLE138
       //                                                            *                      //CLE138
       //*************************************************************                      //CLE138
                                                                                            //CLE138
       Begsr RetrieveClass;                                                                 //CLE138
                                                                                            //CLE138
             exec sql                                                                       //CLE138
                      select FCXCLS into :@@CLAS from LEFCLTQD                              //CLE138
                      where                                                                 //CLE138
                      FCXFCU = : @@CUST                                                     //CLE138
                      and                                                                   //CLE138
                      FCXFTP = : @@FTYP                                                     //CLE138
                      and                                                                   //CLE138
                      FCXFNO = : @@FSEQ;                                                    //CLE138
                                                                                            //CLE138
       Endsr;                                                                               //CLE138

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // *Inzsr - Program Initialisation routine                    *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr *Inzsr;
                   //Check if CLE138 is switched on                                         //CLE138
                   pOption = '*VERIFY';                                                     //CLE138
                   pSARD = 'CLE138';                                                        //CLE138
                   callp check_SARD(                                                        //CLE138
                                  pReturnCode                                               //CLE138
                                : pOption                                                   //CLE138
                                : pSARD                                                     //CLE138
                                : pDSSDY                                                    //CLE138
                               );                                                           //CLE138
                   SCSARD = pDSSDY1;                                                        //CLE138
                                                                                            //CLE138
                   if pReturnCode = *blanks;                                                //CLE138
                      CLE138 = 'Y';                                                         //CLE138
                   endif;                                                                   //CLE138
                                                                                            //CLE138
       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   *PSSR  - Program Error Processing Subroutine.            *
       //                                                            *
       //   Called By: Main Processing                               *
       //                                                            *
       //*************************************************************

       Begsr *Pssr;
                  pReturnCode = '*ERROR';
                  *Inu7 = *ON;
                  *Inu8 = *ON;
                  Dump;
                  *Inlr = *ON;
                  Return;
       Endsr;

      /end-free
