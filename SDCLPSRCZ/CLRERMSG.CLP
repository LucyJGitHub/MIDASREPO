/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Clear specified program message queue.')        */
/*********************************************************************/
/*                                                                   */
/*       Midas       Standing Data Module                        */
/*                                                                   */
/*       CLRERMSG - CLEAR SPECIFIED ERROR MESSAGE QUEUE              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01413 *CREATE     DATE 13APR93              */
/*                      xnnnnn             DATE xxnnnxx              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
     PGM PARM(&TOPGMQ &PGMQREL)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
     DCL VAR(&TOPGMQ)   TYPE(*CHAR) LEN(10)
     DCL VAR(&PGMQREL)  TYPE(*CHAR) LEN(5)
 
     IF COND(&PGMQREL = ' ') +
        THEN(CHGVAR VAR(&PGMQREL) VALUE('*SAME'))
 
     RMVMSG PGMQ(&PGMQREL &TOPGMQ) CLEAR(*ALL)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
     ENDPGM
