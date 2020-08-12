/*********************************************************************/
/*                                                                   */
/*       Midas - /COPY Member (CLP)                                  */
/*                                                                   */
/*       FVT102_002 - MCC0540 - Call AOSARDR0                        */
/*                                                                   */
/*       (c) Finastra International Limited 2019                     */
/*                                                                   */
/*       Last Amend No. FVT102   *CREATE   Date 09May17              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       FVT102 - Posting of P/L to Multiple Retained Earnings       */
/*                                                                   */
/*********************************************************************/
/**/                                                                                      /*FVT102*/
/* Check if FVT102 is installed */                                                        /*FVT102*/
/**/                                                                                      /*FVT102*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*FVT102*/
             CHGVAR     VAR(&SARD) VALUE('FVT102')                                        /*FVT102*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*FVT102*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&FVT102) VALUE('Y'))                                        /*FVT102*/

/*********************************************************************/
/*      End of /COPY FVT102_002                                      */
/*********************************************************************/
