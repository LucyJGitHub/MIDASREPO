/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE COB Secuties Trading Housekeeping')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       SEC1000 - Request COB Securities Trading Housekeeping       */
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
/*       PREV AMEND NO. S01513 *CREATE     DATE 25OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01513 - SE drop runs separately from EOD.                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCLF       FILE(SE1000DF)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
/* Allocate data area SESTAT */
/**/
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCL))
/**/
             RTVJOBA    JOB(&WJOB) USER(&WUSER)
/**/
/* Amend data area SESTAT */
/**/
             CHGDTAARA  DTAARA(SESTAT (81 1)) VALUE('Y')
/**/
/* Display screen */
/**/
             SNDRCVF    RCDFMT(SE1000S0)
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/* Error processing */
/**/
 ABNOR:      SNDPGMMSG  MSG('Request COB Securities Trading Housekeeping +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 ENDPGM:     DLCOBJ     OBJ((SESTAT *DTAARA *EXCL))
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
