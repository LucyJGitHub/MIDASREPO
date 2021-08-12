/********************************************************************/
/*                                                                  */
/*  Midas - General Ledger Module                                   */
/*                                                                  */
/*  CLP/LUC118_001 - GENERATED ENTRIES FILE MERGE (COB)             */
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
                          VALUE('       ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)  +
                          VALUE('      ')
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)

/********************************************************************/
/* End of LUC118_001                                                */
/********************************************************************/
