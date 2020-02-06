/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis Account Details Report')              */
/********************************************************************/
/*                                                                  */
/*   Midas - Midas-Fontis Interface                                 */
/*                                                                  */
/*   GLC2803    Fontis Accounts Details Report                      */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Prev Amend No. CGL004 *CREATE       Date 10JAN97               */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   MD046248 - Finastra Rebranding                                 */
/*   CGL004 - Midas-Fontis Interface                                */
/*                                                                  */
/********************************************************************/
/**/
             PGM        PARM(&RSEQ &LVL &ENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&KY) TYPE(*CHAR) LEN(18)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             SNDPGMMSG  MSG('GLC2803-Fontis Account Details Report') +
                          TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
/*                 IF COND(&ENT *NE 'ALL' *AND &ENT *NE '   ') +     */
/*                    THEN(DO)                                       */
/*           CHGVAR     VAR(&KY) VALUE(&ENT *CAT '               ')  */
/*           OVRDBF     FILE(GLFONAL0) POSITION(*KEYBE 1 GLFONAD0 &KY*/
/*                    ENDDO                                          */
/*                                                                   */
             CALL       PGM(GL2803) PARM(&RSEQ &ENT)
             DLTOVR     FILE(*ALL)
/**/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
/**/
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GL2803 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
