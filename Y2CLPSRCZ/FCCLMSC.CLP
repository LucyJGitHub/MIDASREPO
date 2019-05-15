/*********************************************************************/
/*                                                                   */
/*       Midas - (Module Name) Module                                */
/*                                                                   */
/*       mmCnnnn - (Program Name)                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. XNNNNN  *CREATE    Date DDMmmYY              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       Xnnnnn - (fix description)                                  */
/*                                                                   */
/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Y2 R2.1.1 Clear specified program message queue')     */
/*********************************************************************/
/*T: YAPPOBJ Clear specified program message queue.   */
/*Z: CRTCLPGM LOG(*NO)  */
/*H: SYSTEM     : SYNON/2 - SHIPPED PROGRAM.                           */
/*H: PROGRAMMER : P.WILSON                                             */
/*       (c) Finastra International Limited 2001                     */
/*H: Copy of Y2CLMSC                                                   */
/********************************************************************/
 
/*H:  SYNOPSIS:  Clears a specified program message queue.                   */
 
/*H:  INTERFACE DETAILS ;                                                    */
/*H:  *..................................................................... */
/*H:  *  SEND A MESSGE TO PGM QUEUE                                          */
/*H: C                     CALL 'Y2CLMSC'                  SEND MESSAGE      */
/*H: C                     PARM           ##PGNM 10        I:PGM Q NAME      */
/*H: C                     PARM           ##PGRL  5        I:*SAME,*EXT,*PRV */
/*H:  *                                                    DEFAULT *SAME     */
/*H:  *..................................................................... */
PGM   (&TOPGMQ &PGMQREL)
DCL &TOPGMQ   *CHAR 10 /* MESSAGE QUEUE NAME  */
DCL &PGMQREL  *CHAR  5 /* *SAME,*PRV,*EXT     */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*H: 1. Clear message queue */
           IF (&PGMQREL = ' '  )  CHGVAR &PGMQREL '*SAME'
           RMVMSG     PGMQ(&PGMQREL &TOPGMQ) CLEAR(*ALL)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
