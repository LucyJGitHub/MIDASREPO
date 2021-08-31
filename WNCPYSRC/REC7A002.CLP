/********************************************************************/
/*                                                                  */
/*  Midas - General Ledger Module                                   */
/*                                                                  */
/*  CLP/REC7A002 - GENERATION OF STANDING ORDERS PAYMENTS           */
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

             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')                                                /*LUC118*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*LUC118*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)  +
                          VALUE('      ')                                                 /*LUC118*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*LUC118*/

/********************************************************************/
/* End of REC7A002                                                  */
/********************************************************************/

