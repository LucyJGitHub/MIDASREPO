     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Retrieve Repayment/Category Code Priority')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000801 - Midas LE Retrieve Repayment/Category Code         *
      *             Priority                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
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
 
     D Main            PR                  EXTPGM('LE000801')
     D pReturnCode                    7A
     D pCategoryCode                  5A
     D pFile                         10A
     D pLoan                          6A
     D pBranch                        3A
     D pCustomer                      6A
     D pFacility                      5S 0
     D pFeeSequence                   2S 0
     D pRepPriority                   8S 0
     D pCatPriority                   8S 0
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
     D pCatPriority                   8S 0
     D pOvrdftflg                     1A
 
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
 
     D RET_REPAYMENT   PR                  EXTPGM('LE000802')
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
 
      **---------------------------------------------------------------
      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
 
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
 
                   CallP RET_REPAYMENT(
                                         pReturnCode
                                       : pCategoryCode
                                       : pFile
                                       : pLoan
                                       : pBranch
                                       : pCustomer
                                       : pFacility
                                       : pFeeSequence
                                       : pRepPriority
                                       : pOvrdftflg
                                         );
 
                   pOP01 = 'PDPCAT_' + %Trim(pCategoryCode);
                   CallP ACCESS_SVAL(
                                       pRetCode
                                     : pOP01
                                     : pVL01
                                     : pOP02
                                     : pVL02
                                     : pOP03
                                     : pVL03
                                     : pOP04
                                     : pVL04
                                     : pOP05
                                     : pVL05
                                     : pOP06
                                     : pVL06
                                     : pOP07
                                     : pVL07
                                     : pOP08
                                     : pVL08
                                     : pOP09
                                     : pVL09
                                     : pOP10
                                     : pVL10
                                       );
 
                   If pRetCode <> *Blanks;
                      DbFile = 'SDSVALPD';
                      Dbase  = 2;
                      DbKey  = pOP01;
                      DbPgm  = 'LE000801';
                      Exsr *Pssr;
                   Endif;
 
                   If pVL01 <> *Blanks;
                      Monitor;
                         pCatPriority   = %Int(pVL01);
                      On-Error;
                         DbFile = 'SDSVALPD';
                         Dbase  = 3;
                         DbKey  = pOP01;
                         DbPgm  = 'LE000801';
                         Exsr *Pssr;
                      EndMon;
                   Else;
                      DbFile = 'SDSVALPD';
                      Dbase  = 4;
                      DbKey  = pOP01;
                      DbPgm  = 'LE000801';
                      Exsr *Pssr;
                   Endif;
 
       Endsr;
 
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // *Inzsr - Program Initialisation routine                    *
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
