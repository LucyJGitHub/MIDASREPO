/********************************************************************/
/*                                                                  */
/*  Midas - General Ledger Module                                   */
/*                                                                  */
/*  GLC0802C07 - Midas Events by Nostro                             */
/*                                                                  */
/*  (c) Finastra International Limited 2020                         */
/*                                                                  */
/*  Last Amend No. LUC137 *CREATE     Date 28Aug20                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*  LUC137 - Include Non-Auto Settle Loans events on GL0580         */
/*                                                                  */
/********************************************************************/

             DCL        VAR(&LUC137) TYPE(*CHAR) LEN(1)

/* Access switchable features file to see if feature LUC137     */
/* is installed  */
             CHGVAR     VAR(&SARD) VALUE('LUC137')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&LUC137) VALUE('Y'))

/********************************************************************/
/* End of GLC0802C07                                                */
/********************************************************************/
