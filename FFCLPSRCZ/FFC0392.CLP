/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF FX deals generated on exercise report')      */
/*********************************************************************/
/*                                                                   */
/*   Midas - Futures and Options Module                              */
/*                                                                   */
/*   FFC0392  -  FX DEALS GENERATED ON EXERCISE REPORT               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. CFF003             DATE 03APR97                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   CFF003  -  ENHANCED OTC PROCESSING - PHASE II                   */
/*              UPGRADE FROM BLI LUX LBL001                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        &RSEQ         TYPE(*CHAR)  LEN(5)
             DCL        &RLEV         TYPE(*CHAR)  LEN(1)
             DCL        &RENT         TYPE(*CHAR)  LEN(3)
             DCL        &MEM          TYPE(*CHAR)  LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGJOB     SWS(00000000)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
             CALL       PGM(FF0392) PARM(&RSEQ &RENT)
             RCLRSC
/*                                                                 */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND     */
/* MESSAGE TO MOPERQ AND MRUNQ.                                    */
/*                                                                 */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/*                                                                 */
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
 ABNOR:      SNDPGMMSG  MSG('FFC0392 - FX DEALS GENERATED +
                   REPORT ENDED ABNORMALLY') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
