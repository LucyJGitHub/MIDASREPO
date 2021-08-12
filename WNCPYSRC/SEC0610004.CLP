/********************************************************************/
/*                                                                  */
/*  Midas - General Ledger Module                                   */
/*                                                                  */
/*  CLP/SEC0610004 - GENERATE ACCOUNTING ENTRIES                    */
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

/*  Determine if LUC118 switched on and if so replace               */
/*  account references with alternative ones from BVINTBR           */

             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('LUC118')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(DO)

/*  Replace interbranch accounts with equivalents from BVINTBR      */

             IF         COND(&TYPE *EQ '1') THEN(DO)
             CALL       PGM(XXC000100) PARM('GESTPD')
             ENDDO
             ELSE       CMD(DO)
             CALL       PGM(XXC000100) PARM('GEST1PD')
             ENDDO

             ENDDO

/********************************************************************/
/* End of SEC0610004                                                */
/********************************************************************/
