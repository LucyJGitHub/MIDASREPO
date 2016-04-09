/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Retail History Update Report Component')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC0263 - Interbranch entries at Item/Batch Level component */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CCB003  *Create    Date 05Nov96              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                Call of GL0263 and GL0264                          */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,GLC0263INT                                          */
 
             DCLF       FILE(SDGELRPD)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GLC0263 - Interbranch entries +
                          Item/Batch Level') TOMSGQ(MRUNQ)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,GLC0263MPS                                          */
 
/* Call RPG/GL0263 */
             CALL       PGM(GL0263)
 
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Call RPG/GL0264 */
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)
             RCVF
             IF         COND(&BKIEBI *EQ 'B' *AND &MBIN *EQ 'Y') +
                          THEN(CALL PGM(GL0264))
 
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*/COPY WNCPYSRC,GLC0263MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/*/COPY WNCPYSRC,GLC0263ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Program GLC0263 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,GLC0263END                                          */
 
             ENDPGM
