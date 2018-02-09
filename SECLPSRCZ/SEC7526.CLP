/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Redenominated security codes maintenance')   */
/*********************************************************************/
/*                                                                   */
/*       Midas      Securities Trading Module                        */
/*                                                                   */
/*       SEC7526  - Redenominated Security Codes Maintenance         */
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
/*       Prev Amend No. CEU032  *CREATE    Date 19Nov98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CEU032 - Securities Redenomination Euro Changes             */
/*                                                                   */
/*********************************************************************/
     PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2) VALUE('GB')
             DCL        VAR(&SEUSRMSG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&F3) TYPE(*CHAR) LEN(1) VALUE(' ')
 
             CHGJOB SWS(00000000)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9800) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)
             ENDDO
 
             CHGDTAARA  DTAARA(SESDS) VALUE(' ')
             CHGDTAARA  DTAARA(SESDS (1 8)) VALUE('SE7526')
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')
 
             CHGVAR     VAR(&SEUSRMSG) VALUE(&MULT *CAT 'SEUSRMSG  ')
 
             OVRMSGF    MSGF(SEUSRMSG) TOMSGF(&SEUSRMSG)
             OVRDBF     FILE(SECTYX) TOFILE(SECTY) SHARE(*NO)
 
             CALL       PGM(SE7526) PARM(&F3)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                             Enter to continue.') TOPGMQ(*EXT)
             ENDDO
 
/* If F3 from final screen then ROLLBACK changes from EXVALD */
             IF         COND(&F3 *EQ 'Y') THEN(DO)
                ROLLBACK
             ENDDO
 
/* For Database Errors Recover Data from LDA */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGVAR VAR(&MEM) VALUE('SEC7526 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                ROLLBACK
             ENDDO
 
             RCLRSC
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
