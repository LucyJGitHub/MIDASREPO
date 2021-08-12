/********************************************************************/
/*                                                                  */
/*  Midas - General Ledger Module                                   */
/*                                                                  */
/*  CLP/REC35003 - CUSTOMER EXCHANGE INPUT TODAY                    */
/*                                                                  */
/*  (c) Copyright Finastra Ltd 2019                                 */
/*                                                                  */
/*  Last Amend No. LUC118 *CREATE     Date 13Feb19                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*  LUC118 - Upgrade of LUC118 to FB Midas 2.1                      */
/*           BV Auto transfer of interbranch account balances       */
/*                                                                  */
/********************************************************************/

/*  Determine if LUC118 switched on and if so replace               */
/*  account references with alternative ones from BVINTBR           */

             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('LUC118')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(DO)

/*  Replace interbranch accounts with equivalents from BVINTBR      */

             CALL       PGM(XXC000100) PARM('GECEPD')

             ENDDO

/********************************************************************/
/* End of REC35003                                                  */
/********************************************************************/
