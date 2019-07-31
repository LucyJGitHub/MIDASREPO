/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Account postings enquiry control')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC0090 - Account Postings Enquiry Control                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 249971             Date 11Sep07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                                         Date                      */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CGL007  *CREATE    Date 26Mar99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       249971 - Include QVRDBF for file MUSER to avoid error       */
/*                wrong allocation of file.                          */
/*       241168 - Applied fix 239795 to avoid database error on      */
/*                Account Postings screen.                           */
/*       239795 - Create data area DLSDS in QTEMP to avoid database  */
/*                error when selecting DL transactions from          */
/*                Account Movements screen.                          */
/*       CGL007 - Account Postings Enquiry.                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
 
/**/
/* Declaration of parameters */
/**/
 
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(256)
             DCL        VAR(&BPARM) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/**/
/* Global monitor message */
/**/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**/
/*  LDA */
/**/
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/                                                                                      /*239795*/
             CHKOBJ     OBJ(QTEMP/DLSDS) OBJTYPE(*DTAARA)                                 /*239795*/
             MONMSG     MSGID(CPF9800) EXEC(DO)                                           /*239795*/
             CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167)                          /*239795*/
             ENDDO                                                                        /*239795*/
             CHGDTAARA  DTAARA(QTEMP/DLSDS) VALUE(' ')                                    /*239795*/
             CHGJOB     SWS(XXXXXX00)
 
             CHKOBJ     OBJ(FFCODS)  OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/FFCODS) TYPE(*CHAR) LEN(60))
 
/**/
/* Call program */
/**/
 
             OVRDBF     FILE(MUSER) WAITRCD(1) SHARE(*NO)                                /*249971*/
             OVRDBF     FILE(POSETX) TOFILE(POSET1) SHARE(*NO)
             OVRDBF     FILE(POSETDZ1) TOFILE(POSETDY1) SHARE(*NO)
             OVRDBF     FILE(POSETDZ2) TOFILE(POSETDY2) SHARE(*NO)
 
             CHGVAR     VAR(&BPARM) VALUE(' ')
             CALL       PGM(GL0090) PARM(&BPARM)
 
/**/
/* Database error processing */
/**/
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                      TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   CHGVAR VAR(&MEM) VALUE('GLC0090 - Job terminated, +
                      Database in error.')
                   SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
/**/
 
             GOTO       CMDLBL(ENDPGM)
 
/**/
/* Abnormal termination */
/**/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                           Enter to continue.') TOPGMQ(*EXT)
 
/**/
/*   E N D   P R O C E S S I N G   */
/**/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             DLTOVR     FILE(MUSER)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             ENDPGM
