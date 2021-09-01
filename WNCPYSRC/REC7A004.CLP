/********************************************************************/
/*                                                                  */
/*  Midas - General Ledger Module                                   */
/*                                                                  */
/*  CLP/REC7A004 - GENERATION OF STANDING ORDERS PAYMENTS           */
/*                                                                  */
/*  (c) Copyright Finastra Ltd 2019                                 */
/*                                                                  */
/*  Last Amend No. LUC118 *CREATE     Date 13Feb19                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*  LUC118 - Upgrade of S21045 to FB Midas 2.1                      */
/*           BV Auto transfer of interbranch account balances       */
/*                                                                  */
/********************************************************************/

/*  Determine if LUC118 switched on and if so replace               */                    /*LUC118*/
/*  account references with alternative ones from BVINTBR           */                    /*LUC118*/
                                                                                          /*LUC118*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*LUC118*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*LUC118*/
             CHGVAR     VAR(&SAR) VALUE('LUC118')                                         /*LUC118*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*LUC118*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*LUC118*/
                                                                                          /*LUC118*/
/*  Replace interbranch accounts with equivalents from BVINTBR      */                    /*LUC118*/
                                                                                          /*LUC118*/
             CALL       PGM(XXC000100) PARM('GESOPD')                                     /*LUC118*/
                                                                                          /*LUC118*/
             ENDDO                                                                        /*LUC118*/

/********************************************************************/
/* End of REC7A004                                                  */
/********************************************************************/
