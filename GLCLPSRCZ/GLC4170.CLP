/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Daily Balance Proof Report')                 */
/*********************************************************************/
/*                                                                   */
/*     Midas - General Ledger Module                         */
/*                                                                   */
/*     GLC4170 - DAILY BALANCE PROOF REPORT                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO  E40459            DATE  04JUN92             */
/*       PREV AMEND NO  S01359            DATE  03MAR92             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       E40459 - S01362 put in a call to access program AOSARDR0,  */
/*                to check whether the SAR in question is enabled;  */
/*                however no call was coded with an option of *FREE,*/
/*                to close the file.  This meant that the file was  */
/*                open at Next-day set-up, preventing its being     */
/*                journalled.  A call to AOSARDR0 with *FREE has    */
/*                now been coded in the end processing, which       */
/*                should prevent this happening both now and for    */
/*                any calls to AOSARDR0 which may be added in the   */
/*                future.                                           */
/*     S01359  -  DAILY BALANCE PROOF REPORT                         */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) VALUE('S01359')
/**/
/* DETERMINE IF SAR INSTALLED */
/**/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
/**/
/* ERROR */
/**/
             IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('GLC4170 - JOB TERMINATED - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(EXIT)
             ENDDO
/**/
/* SAR NOT INSTALLED */
/**/
             IF         COND(&SRTCD *EQ '*NRF   ') THEN(DO)
             GOTO       CMDLBL(EXIT)
             ENDDO
 
             SNDMSG     MSG('Daily Balance Proof Extract') +
                          TOMSGQ(MRUNQ)
             OVRDBF     FILE(TABLE) TOFILE(TABDLI)
             CLRPFM     FILE(GLAUDTAP)
             CLRPFM     FILE(GLAUDTDP)
             CLRPFM     FILE(GLAUDTTP)
             CHGJOB     SWS(00000000)
             CALL       PGM(GL4170)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             SNDMSG     MSG('Daily Balance Proof Report') TOMSGQ(MRUNQ)
             CALL       PGM(GL4180) PARM('     ')
             ENDDO
 
ABNOR:       IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +
                                TOMSGQ(MOPERQ MRUNQ)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) +
                   MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)
                ENDDO
                ELSE       CMD(SNDPGMMSG MSG('FILE CONTROLS OUT OF +
                             BALANCE') TOMSGQ(MOPERQ MRUNQ))
                ENDDO
             ELSE          CMD(DO)
/**/
             CLRPFM FILE(GLAUDTAP)
             CLRPFM FILE(GLAUDTDP)
             CLRPFM FILE(GLAUDTTP)
             DLTOVR     FILE(TABLE)
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**EXIT:********ENDPGM                                               /*E40459*/
EXIT:                                                                /*E40459*/
/* */                                                                /*E40459*/
/** Call AOSARDR0 with an option of '*FREE' to close the file.       /*E40459*/
             CHGVAR     VAR(&SOPTN) VALUE('*FREE')                   /*E40459*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)     /*E40459*/
/* */                                                                /*E40459*/
             ENDPGM                                                  /*E40459*/
