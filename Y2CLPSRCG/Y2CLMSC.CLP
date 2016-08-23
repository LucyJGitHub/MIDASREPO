/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Y2 R2.1.1 Clear specified program message queue')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Synon generated                                     */
/*                                                                   */
/*       Y2CLMSC - Clear specified program message queue             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CUP039  *MOVED     Date 20Apr11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. Xnnnnn  *CREATE    Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP039 - Move program to global layer                       */
/*                                                                   */
/*********************************************************************/
 
/*H:  SYNOPSIS:  Clears a specified program message queue.                   */
 
/*H:  INTERFACE DETAILS ;                                                    */
/*H:  *..................................................................... */
/*H:  *  SEND A MESSGE TO PGM QUEUE                                          */
/*H: C                     CALL 'Y2CLMSC'                  SEND MESSAGE      */
/*H: C                     PARM           ##PGNM 10        I:PGM Q NAME      */
/*H: C                     PARM           ##PGRL  5        I:*SAME,*EXT,*PRV */
/*H:  *                                                    DEFAULT *SAME     */
/*H:  *..................................................................... */
             PGM        PARM(&TOPGMQ &PGMQREL)
 
             DCL        VAR(&TOPGMQ) TYPE(*CHAR) LEN(10) /* MESSAGE +
                          QUEUE NAME  */
             DCL        VAR(&PGMQREL) TYPE(*CHAR) LEN(5) /* +
                          *SAME,*PRV,*EXT     */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*H: 1. Clear message queue */
             IF         COND(&PGMQREL = ' ') THEN(CHGVAR +
                          VAR(&PGMQREL) VALUE('*SAME'))
             RMVMSG     PGMQ(&PGMQREL (&TOPGMQ)) CLEAR(*ALL)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
