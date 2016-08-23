/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Interest history report')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC9105 - PRINT INTEREST HISTORY REPORT                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 073175 *CREATE     DATE 21MAR97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       073175 - Interest history enquiry print <F9> resulted in    */
/*                message 'Interest history print unsuccessful'.     */
/*                Introduce pgm DLC9105 and DLC9110. Fix originally  */
/*                done in core as 048911 but has been lost.          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SEQ &LEV &ENT &MBRNAM)
 
/*/COPY WNCPYSRC,DLC9105INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MBRNAM) TYPE(*CHAR) LEN(9)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(2)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
/**/
/* Monitor for error messages not trapped in the rest of the */
/* program. If they occur reclaim resources and exit.        */
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,DLC9105MPS                                          */
 
             OVRDBF     FILE(HISTEAA) MBR(&MBRNAM)
             CALL       PGM(DL9105)  PARM(&SEQ)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ERROR)
             ENDDO
/**/
/*** Clear file after program is called successfully               ***/
RETRY:
             CLRPFM     FILE(HISTEAA) MBR(&MBRNAM)
             MONMSG     MSGID(CPF3130) EXEC(DO)
             GOTO       CMDLBL(FAIL)
             ENDDO
 
/*/COPY WNCPYSRC,DLC9105MPE                                          */
 
             GOTO       CMDLBL(ENDPGM)
FAIL:
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             IF         COND(&COUNT *LE 12) THEN(DO)
             DLYJOB     DLY(5)
             GOTO       CMDLBL(RETRY)
             ENDDO
             ELSE       CMD(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
ERROR:
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
ABNOR:
/*/COPY WNCPYSRC,DLC9105ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/*  CALL SCC0010 TO SEND ABNORMAL TERMINATION SCREEN  */
             RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
             RTVMSG     MSGID(SCM0088) MSGF(MIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (3 1)) VALUE('1')
             MONMSG     MSGID(CPF0000 MCH0000)
             CALL       PGM(SCC0010) PARM('DLC9105' 'ENTER' &NOREPLY)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,DLC9105END                                          */
 
             ENDPGM
