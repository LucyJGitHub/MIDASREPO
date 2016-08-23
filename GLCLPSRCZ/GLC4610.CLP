/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Account Code Balance Enquiry')               */
/********************************************************************/
/*                                                                  */
/*       Midas       GENERAL LEDGER                                 */
/*                                                                  */
/*       GLC4610  - ACCOUNT CODES BALANCES ENQUIRY                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  S01399 *CREATE      DATE  19MAY92          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   S01399 - NEW CL PROGRAM TO ENQUIRE ON ACCOUNT CODE             */
/*            BALANCES (SAR NO. MIS0020)  UPGRADE TO REL 10         */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*  SET OFF SWITCHES U7 & U8                                                  */
/**/
             CHGJOB     SWS(XXXXXX00)
             SNDPGMMSG  MSG('GLC4610 - Account Code Balances +
                          Enquiry') TOMSGQ(MRUNQ)
/**/
             OVRDBF     FILE(AUACNTV1) SEQONLY(*YES 100)
             OVRDBF     FILE(AUAPOSV1) SEQONLY(*YES 100)
/**/
/*  CALL ACCOUNT CODE BALANCES ENQUIRY PROGRAM                                */
/**/
             CALL       PGM(GL4610)
/**/
/*  DATABASE ERROR HANDLING                                                   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
               SNDPGMMSG  MSG('GLC4610 terminated - Database error') +
                          TOMSGQ(MRUNQ MOPERQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
