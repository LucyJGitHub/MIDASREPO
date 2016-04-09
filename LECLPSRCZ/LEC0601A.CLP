/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE FACILITIES INPUT TODAY')                     */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0601A - FACILITIES INPUT TODAY                          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CLE041             Date 11Oct04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01194             Date 08Feb04              */
/*                                                                  */
/********************************************************************/
/*       CLE041 - Collateralised Lending Phase 2B                    */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
                                                                                          /*CLE041*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CLE041*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CLE041*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CLE041*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)                                  /*CLE041*/
                                                                                          /*CLE041*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('FACILITIES INPUT TODAY REPORT')
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
                                                                                          /*CLE041*/
             CHGJOB     SWS(00000000)                                                     /*CLE041*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE041*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE041*/
             CHGVAR     VAR(&SARD) VALUE('CLE025')                                        /*CLE041*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSFDY)                      /*CLE041*/
                                                                                          /*CLE041*/
             IF         COND((&RTCD *NE '       ') *AND (&RTCD *NE +
                          '*NRF   ')) THEN(DO)                                            /*CLE041*/
               SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                  TOMSGQ(MOPERQ)                                          /*CLE041*/
               CHGJOB SWS(XXXXXX11)                                                       /*CLE041*/
               GOTO       CMDLBL(ENDPGM)                                                  /*CLE041*/
             ENDDO                                                                        /*CLE041*/
                                                                                          /*CLE041*/
             IF         COND(&RTCD *EQ '       ') THEN( +
                          CHGJOB SWS(1XXXXXXX))                                           /*CLE041*/
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
/**/
             CALL       PGM(LE0300)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:                                                                                   /*CLE041*/
             ENDPGM
