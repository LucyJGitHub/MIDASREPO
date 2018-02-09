/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Today's FX Deals from TI - I/C on request')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0218 - FX Deals Received from Trade Innovation           */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CTI004  *CREATE    Date 12Apr04              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CTI004 - MidasPlus-TI Integration Enhancements              */
/*                FX Deals Integration                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(DL0208) PARM(&RSEQ)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('JOB DLC0218 TERMINATED ABNORMALLY') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
