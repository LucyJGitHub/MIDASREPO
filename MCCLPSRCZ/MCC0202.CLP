/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Control Groups Report Control')              */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                      */
/*                                                                   */
/*   MCC0202 - Control Groups Report Control                         */
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
/*       Prev Amend No. XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   XXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                      */
/*                                                                   */
/*********************************************************************/
 
/*   Job switch use                                                  */
 
/*   U1 - Audit is 'Y'                                               */
/*   U7 - Database error                                             */
/*   U8 - Database error                                             */
 
/*********************************************************************/
             PGM        PARM(&AUDIT &SEQNO &LEVEL &ENTTY)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&AUDIT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SEQNO) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENTTY) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50) VALUE('Error +
                          message variable')
 
/* Global error message                                              */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* Create local data area                                            */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF1023) /* LDA already exists */
 
/* Reset job switches U1, U7, U8                                     */
             CHGJOB     SWS(0XXXXX00)
 
             IF         COND(&AUDIT *EQ 'A') THEN(CHGJOB SWS(1XXXXXXX))
             ELSE       CMD(CHGJOB SWS(0XXXXXXX))
 
/* Call the Periodic drop program                                    */
             CALL       PGM(MC0202) PARM(&SEQNO)
 
/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO      /* End of database error section */
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:      SNDPGMMSG  MSG('Control Groups Report ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
ENDPGM: ENDPGM
