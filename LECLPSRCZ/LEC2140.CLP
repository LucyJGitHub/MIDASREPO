/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Manual Facility Utilisation Input')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2140 - Manual Facility Utilisation Input                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CLE005 *Create     Date 22May97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CLE005 - Customer Lending Enhancements - Others             */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&PMODE)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
             CALL       PGM(LE2140) PARM(&PMODE)
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*/COPY WNCPYSRC,LEC2140001                                          */
                GOTO       CMDLBL(END)
             ENDDO
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/* Abnormal or database error processing */
/**/
 
 ABNOR:      SNDPGMMSG  MSG('Transaction failed.  Re-input necessary.  +
                          Enter to continue.') TOPGMQ(*EXT)
/**/
/* End program processing */
/**/
 END:        DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
