/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Clear specified program message queue.')        */
/*********************************************************************/
/*                                                                   */
/*       Midas       Standing Data Module                        */
/*                                                                   */
/*       CLRERMSG - CLEAR SPECIFIED ERROR MESSAGE QUEUE              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01413 *CREATE     DATE 13APR93              */
/*       PREV AMEND NO. xnnnnn             DATE xxnnnxx              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
     PGM PARM(&TOPGMQ &PGMQREL)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
     DCL VAR(&TOPGMQ)   TYPE(*CHAR) LEN(10)
     DCL VAR(&PGMQREL)  TYPE(*CHAR) LEN(5)
 
     IF COND(&PGMQREL = ' ') +
        THEN(CHGVAR VAR(&PGMQREL) VALUE('*SAME'))
 
     RMVMSG PGMQ(&PGMQREL &TOPGMQ) CLEAR(*ALL)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
     ENDPGM
