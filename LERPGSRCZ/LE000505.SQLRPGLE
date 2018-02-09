     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Repayment Priority Matrix Access')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000505 - Midas LE Repayment Priority Matrix Access         *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CLE164 *CREATE     Date 18Aug14               *
      *                                                               *
      *****************************************************************
      *                                                               *
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

     D Main            PR                  EXTPGM('LE000505')
     D pReturnCode                    7A
     D pFTPDPPRGrp                    3A
     D pLSPDPPRGrp                    3A
     D pFCPDPPRGrp                    3A
     D pCategoryCode                  5A
     D pRepPriority                   8S 0
     D pLevelPriority                 1A

     D Main            PI
     D pReturnCode                    7A
     D pFTPDPPRGrp                    3A
     D pLSPDPPRGrp                    3A
     D pFCPDPPRGrp                    3A
     D pCategoryCode                  5A
     D pRepPriority                   8S 0
     D pLevelPriority                 1A

     D ACCESS_SVAL     PR                  EXTPGM('AOSVALR0')
     D pRetCode                       7A
     D pOP01                         20A
     D pVL01                        200A
     D pOP02                         20A
     D pVL02                        200A
     D pOP03                         20A
     D pVL03                        200A
     D pOP04                         20A
     D pVL04                        200A
     D pOP05                         20A
     D pVL05                        200A
     D pOP06                         20A
     D pVL06                        200A
     D pOP07                         20A
     D pVL07                        200A
     D pOP08                         20A
     D pVL08                        200A
     D pOP09                         20A
     D pVL09                        200A
     D pOP10                         20A
     D pVL10                        200A

      **---------------------------------------------------------------
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D RepMatrix     E DS                  EXTNAME(SDMTRXTD)
     D RepCategory   E DS                  EXTNAME(SDRPCKTD)
     D RepDefault    E DS                  EXTNAME(SDRPDFTD)

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D SQLStr          S           2000A   INZ(*BLANKS)
     D QUO             C                   CONST('''')

     ** Work variable of Facility Types Group-ID
     D wFT             S              3A
     ** Work variable of Fee Codes Group-ID
     D wFC             S              3A
     ** Work variable of Loan Type/Subtype Group-ID
     D wLS             S              3A

     ** Constants
     D DEFAULT_LEVEL   C                   CONST('S')

      ** Work Variables
     D wSVRepPriority  S              8S 0 INZ(*ZEROS)
     D wFound          S              1A   INZ(*BLANKS)


      ** AOSVALR0 Parameters
     D pRetCode        S              7A
     D pOP01           S             20A
     D pVL01           S            200A
     D pOP02           S             20A
     D pVL02           S            200A
     D pOP03           S             20A
     D pVL03           S            200A
     D pOP04           S             20A
     D pVL04           S            200A
     D pOP05           S             20A
     D pVL05           S            200A
     D pOP06           S             20A
     D pVL06           S            200A
     D pOP07           S             20A
     D pVL07           S            200A
     D pOP08           S             20A
     D pVL08           S            200A
     D pOP09           S             20A
     D pVL09           S            200A
     D pOP10           S             20A
     D pVL10           S            200A

      /free

       // Start of Main processing
       //  Initial processing is performed automatically: the
       //  *INZSR is executed at program activation.

                   Exsr ProcessRepayment;

                   *Inlr = *On;
                   Return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // ProcessRepayment - Process Repayment Priority              *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       BegSr ProcessRepayment;

                   wFound = FALSE;
                   SQLStr = 'select * from SDRPCKTD ' +
                            'where ' +
                            'RXCATE = ' + ''''+ %TRIM(pCategoryCode) +'''';

                   Exec Sql Prepare P1 from :SQLStr;
                   Exec Sql Declare P1 cursor for P1;
                   Exec Sql Open P1;
                   Exec Sql Fetch P1 into :RepCategory;

                   if Sqlcod <> 0
                      ;
                      DbFile = 'SDRPCKTD';
                      Dbase  = 1;
                      DbKey  = %Trim(pCategoryCode);
                      DbPgm  = 'LE000505';
                      Exsr *Pssr;
                   Endif;

                   SQLStr = 'select * from SDRPDFTD ' +
                            'where ' +
                            'DXCLAS = ' + %EditC(RXCLAS:'X') +
                            ' order by DXLEVL';

                   Exec Sql Prepare P2 from :SQLStr;
                   Exec Sql Declare P2 cursor for P2;
                   Exec Sql Open P2;
                   Exec Sql Fetch P2 into :RepDefault;

                   If Sqlcod <> 0 and Sqlcod <> 100;
                      DbFile = 'SDRPDFTD';
                      Dbase  = 2;
                      DbKey  = %EditC(RXCLAS:'X');
                      DbPgm  = 'LE000505';
                      Exsr *Pssr;
                   Endif;

                   Dow Sqlcod = 0;

                      Exsr SrExecuteSQL;
                      If wFound = True;
                         Leave;
                      Endif;

                      Exec Sql Fetch Next From P2 into :RepDefault;

                      If SQLCOD <> 0 and SQLCOD <> 100;
                         DbFile = 'SDRPDFTD';
                         Dbase  = 3;
                         DbKey  = %EditC(RXCLAS:'X');
                         DbPgm  = 'LE000505';
                         Exsr *Pssr;
                      Endif;

                   Enddo;

                   If wFound = FALSE;
                      pOP01 = 'PDPCAT_' + %Trim(pCategoryCode);
                      CallP ACCESS_SVAL(
                                         pRetCode
                                        :pOP01
                                        :pVL01
                                        :pOP02
                                        :pVL02
                                        :pOP03
                                        :pVL03
                                        :pOP04
                                        :pVL04
                                        :pOP05
                                        :pVL05
                                        :pOP06
                                        :pVL06
                                        :pOP07
                                        :pVL07
                                        :pOP08
                                        :pVL08
                                        :pOP09
                                        :pVL09
                                        :pOP10
                                        :pVL10
                                       );

                      If pRetCode <> *Blanks;
                         DbFile = 'SDSVALPD';
                         Dbase  = 4;
                         DbKey  = pOP01;
                         DbPgm  = 'LE000505';
                         Exsr *Pssr;
                      Endif;

                      If pVL01 <> *Blanks;
                         Monitor;
                            wSVRepPriority = %Int(pVL01);
                         On-Error;
                            DbFile = 'SDSVALPD';
                            Dbase  = 5;
                            DbKey  = pOP01;
                            Exsr *Pssr;
                         EndMon;
                      Else;
                         wSVRepPriority = 0;
                      Endif;
                         pRepPriority = wSVRepPriority;
                         pLevelPriority = DEFAULT_LEVEL;
                   Endif;

                   Exec Sql Close P1;
                   Exec Sql Close P2;

       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // SrExecuteSQL - Execute SQL to query repayment matrix       *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       BegSr SrExecuteSQL;

                   If DXFTID <> *Blanks;
                      wFT = DXFTID;
                   Else;
                      wFT = pFTPDPPRGrp;
                   Endif;

                   If DXLSID <> *Blanks;
                      wLS = DXLSID;
                   Else;
                      wLS = pLSPDPPRGrp;
                   Endif;

                   If DXFCID <> *Blanks;
                      wFC = DXFCID;
                   Else;
                      wFC = pFCPDPPRGrp;
                   Endif;

                   SQLStr = 'select * from SDMTRXTD ' +
                            'where MXFAID = ' + QUO + %TRIM(wFT) + QUO +
                            ' and ' +
                            'MXLTID = ' + QUO + %TRIM(wLS) + QUO  +
                            ' and ' +
                            'MXFEID = ' + QUO + %TRIM(wFC) + QUO +
                            ' and ' +
                            'MXCACD = ' + QUO + %TRIM(pCategoryCode) + QUO;

                   Exec Sql Prepare P3 from :SQLStr;
                   Exec Sql Declare P3 cursor for P3;
                   Exec Sql Open P3;
                   Exec Sql Fetch P3 into :RepMatrix;

                   If Sqlcod = 0;
                      pRepPriority = MXREPR;
                      pLevelPriority = %Subst(%EditC(DXLEVL:'X'):2:1);
                      wFound = TRUE;
                   Elseif Sqlcod <> 0 and Sqlcod <> 100;
                      DbFile = 'SDMTRXTD';
                      Dbase  = 6;
                      DbKey  = wFT + ' ' + wLS + ' ' + wFC + ' ' +
                               pCategoryCode;
                      DbPgm  = 'LE000505';
                      Exsr *Pssr;
                   Endif;
                   Exec Sql Close P3;

       Endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // INZSR - Program Initialisation routine                     *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       Begsr *Inzsr;

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

