/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Back/Forward Valued Posting Audit')          */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                      */
/*                                                                   */
/*   MCC0280 - Back/Forward Valued Postings Audit                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. XXXXXX     DATE DDMMMYY                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   XXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                      */
/*                                                                   */
/*********************************************************************/
 
/*   Job switch use:                                                 */
/*   U7 - Database error                                             */
/*   U8 - Database error                                             */
 
             PGM        PARM(&SEQNUMBER &LEVEL &ENTITY)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50) VALUE('Error +
                          message variable')
             DCL        VAR(&SEQNUMBER) TYPE(*DEC) LEN(5 0) +
                          /* Sequence Number */
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1) /* Level */
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3) /* Entity */
 
 
/* Global error message                                              */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* Create local data area                                            */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas Local Data Area')
             MONMSG     MSGID(CPF1023) /* LDA already exists */
 
/* Reset job switches U7, U8                                         */
             CHGJOB     SWS(XXXXX000)
 
/* Call Back/Forward Valued Postings Audit program                  */
             CALL       PGM(MC0280) PARM(&SEQNUMBER)
 
/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11) *OR +
                          %SWITCH(XXXXX1XX)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO      /* End of database error section */
 
             GOTO       CMDLBL(ENDPGM)
 
 ERROR:      SNDPGMMSG  MSG('Back/Forward Valued Postings Audit +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
ENDPGM: ENDPGM
