     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Update Repayment Priority Extension Table')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LE000506 - Midas LE Update Repayment Priority Extension      *
      *             Table                                             *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD036704B          Date 11Aug15               *
      *  Prev Amend No. CLE164 *CREATE     Date 18Aug14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD036704B - System allows input of loans with identical      *
      *              FrontOfficeID.                                   *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *                                                               *
      *****************************************************************
      *                                                               *
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
     D Main            PR                  EXTPGM('LE000506')
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

     D Main            PI
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

     D USER_DET        PR                  EXTPGM('SFC000026')
     D  pUser                        10A

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D RepAccess     E DS                  EXTNAME(SDMTRXTD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ***  Midas API Message Header Format Definition
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+

     D pLevel          S              1A   INZ(*BLANKS)
     D pRepayment      S              8S 0 INZ(*ZEROS)
     D SQLSTR          S           2000A   INZ(*BLANKS)
     D QUO             C                   CONST('''')
     D pUser           S             10A

     C/EXEC SQL                                                                            MD036704B
     C+ SET OPTION COMMIT = *CHG                                                           MD036704B
     C/END-EXEC                                                                            MD036704B

      /free

       // +--- Start of Main processing -----------------------------+
       // ¦                                                          ¦
       // ¦ Initial processing is performed automatically: the       ¦
       // ¦ *INZSR is executed at program activation.                ¦
       // ¦                                                          ¦
       // +----------------------------------------------------------+

                  If pAction = '*INSERT';
                     Exsr InsertRepaymentPriorityDetails;

                  Elseif pAction = '*DELETE';
                     Exsr DeleteRepaymentPriorityDetails;

                  Endif;

                  Return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // InsertRepaymentPriorityDetails                             *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: RETRIEVE_REPR                                       *
       //                                                            *
       //*************************************************************

       Begsr InsertRepaymentPriorityDetails;

                  CallP RETRIEVE_REPR(
                                       pRetCode
                                     : pFTPDPGrpID
                                     : pLSPDPGrpID
                                     : pFCPDPGrpID
                                     : pCategory
                                     : pRepayment
                                     : pLevel
                                    );


                  If pRetCode <> *Blanks;
                     Dbase    = 001;
                     DbFile   = pFile;
                     DbKey    = *BLANKS;
                     pRetCode = '*ERROR';
                     DbPgm    = 'LE000506';
                     Exsr *Pssr;
                  Endif;

                  If pFile = 'CLOANZTD';
                     SQLStr = 'insert into ' + PFILE  +
                              ' ' +
                              '(' +
                              'LXLNRF' +
                              ',' +
                              'LXCATE' +
                              ',' +
                              'LXREPR' +
                              ',' +
                              'LXLEVL' +
                              ',' +
                              'LXLDAT' +
                              ',' +
                              'LXLTYP' +
                              ',' +
                              'LXLUSR' +
                              ',' +
                              'LXCUST' +
                              ')' +
                              ' ' +
                              'VALUES' +
                              '(' +
                              QUO + pLoanRef + QUO +
                              ',' +
                              QUO + pCategory + QUO +
                              ',' +
                              %Editc(pRepayment:'X') +
                              ',' +
                              QUO + pLevel + QUO +
                              ',' +
                              QUO + %Editc(BJRDNB:'X') + QUO +
                              ',' +
                              QUO + 'I' + QUO +
                              ',' +
                              QUO + %Trim(PSUSER) + QUO +
                              ',' +
                              QUO + pCustomer + QUO +
                              ')';
                  Elseif pFile = 'LEFEEZTD';
                     SQLStr = 'insert into ' + PFILE  +
                              ' ' +
                              '(' +
                              'FXBRCA' +
                              ',' +
                              'FXCNUM' +
                              ',' +
                              'FXFACL' +
                              ',' +
                              'FXLOAN' +
                              ',' +
                              'FXFSEQ' +
                              ',' +
                              'FXCATE' +
                              ',' +
                              'FXREPR' +
                              ',' +
                              'FXLEVL' +
                              ',' +
                              'FXLDAT' +
                              ',' +
                              'FXLTYP' +
                              ',' +
                              'FXLUSR' +
                              ',' +
                              'FXCUST' +
                              ')' +
                              ' ' +
                              'VALUES' +
                              '(' +
                               QUO + pBranch + QUO +
                               ',' +
                               QUO + pCustomer + QUO  +
                               ',' +
                               QUO + %EditC(pFeeFclty:'X') + QUO +
                               ',' +
                               QUO + pFeeLoan  + QUO  +
                               ',' +
                               %Editc(pFeeSeqn:'X') +
                               ',' +
                               QUO + pCategory + QUO  +
                               ',' +
                               %Editc(pRepayment:'X') +
                               ',' +
                               QUO + pLevel + QUO  +
                               ',' +
                               QUO + %Editc(BJRDNB:'X') + QUO  +
                               ',' +
                               QUO + 'I' + QUO +
                               ',' +
                               QUO + %Trim(PSUSER) + QUO  +
                              ',' +
                              QUO + pCustomer + QUO +
                               ')';
                  Endif;

                  Exec SQL Execute Immediate :SQLStr;
                  If SqlCod <> 0 And Sqlcod  <> 100;
                     Dbase    = 002;
                     DbFile   = pFile;
                     DbKey    = *BLANKS;
                     pRetCode = '*ERROR';
                     DbPgm    = 'LE000506';
                     Exsr *Pssr;
                  Endif;
       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // DeleteRepaymentPriorityDetails                             *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       Begsr DeleteRepaymentPriorityDetails;

                  If pFile = 'CLOANZTD';
                     SQLStr = 'delete from ' + pFile +
                              ' where LXLNRF = ' +
                              QUO + pLoanRef + QUO;

                  Elseif pFile = 'LEFEEZTD';
                     SQLStr = 'delete from ' + pFile + 'where ' +
                     ' FXBRCA = ' + QUO + pBranch + QUO  +
                     ' AND FXCNUM = ' + QUO + pCustomer + QUO  +
                     ' AND FXFACL = ' + %Editc(pFeeFclty:'X') +
                     ' AND FXLOAN = ' + QUO  + pFeeLoan + QUO +
                     ' AND FXFSEQ = ' + %Editc(pFeeSeqn:'X');

                  Endif;

                  Exec SQL Execute Immediate :SQLStr;
                  If Sqlcod <> 0 And Sqlcod <> 100;
                     Dbase    = 003;
                     DbFile   = pFile;
                     DbKey    = *BLANKS;
                     pRetCode = '*ERROR';
                     DbPgm    = 'LE000506';
                     Exsr *Pssr;
                  Endif;

       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // INZSR - Program Initialisation routine                     *
       //                                                            *
       // Called by: Automaticall upon program activation            *
       //                                                            *
       //  Calls: ACCESS_BANK                                        *
       //                                                            *
       //*************************************************************

       Begsr *Inzsr;

                  @RTCD = *Blanks;
                  @RTCD = '*MSG';
                  @OPTN = '*FIRST';
                  DSFDY = SDBANK;
                  CallP ACCESS_BANK(
                                      @RTCD
                                    : @OPTN
                                    : DSFDY
                                   );

                  If @RTCD <> *Blanks;
                     In Lda;
                     DbKey = '*FIRST';
                     DbFile = 'SDBANKPD';
                     Dbase = 004;
                     DbPgm    = 'LE000506';
                     Out Lda;
                     Exsr *Pssr;
                  Endif;

                  SDBANK = DSFDY;

                  CallP USER_DET(
                                 pUser
                                );

                  If pUser <> *Blanks;
                     PsUser = pUser;
                  Endif;

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

                  pRetCode = '*ERROR';
                  *Inu7 = *ON;
                  *Inu8 = *ON;
                  Dump;
                  *Inlr = *ON;
                  Return;
       Endsr;

      /end-free

