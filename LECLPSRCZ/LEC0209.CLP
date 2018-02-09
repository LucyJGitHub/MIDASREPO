/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE ADJUSTMENTS TO COMMITMENT FEES')             */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*            LEC0209-ADJUSTMENTS TO COMMITMENT FEES INPUT          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01194             Date 08Feb90              */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(35)
/*    ADJUSTMENTS TO COMMITMENT FEES INPUT                          */
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
             CALL       PGM(LE0100)
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
/*     ERROR MESSAGES                                               */
             IF         COND(%SWITCH(XXXXX1X1)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED-STRAN FILE +
                                         FULL')
                RTVJOBA    JOB(&JOB) SWS(&SWS)
                SNDPGMMSG  MSG(&MSG) TOMSGQ(&JOB) MSGTYPE(*INFO)
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                CHGVAR     VAR(&SWS) VALUE('XXXXX0X0')
                CHGJOB     SWS(&SWS)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
