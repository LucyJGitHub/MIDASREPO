/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Discount factor initialisation & rebuild')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC9600 - Discount Factor Initialisation & Rebuild          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG9381            Date 25Nov05              */
/*                      228362             Date 08Jul04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAS001  *CREATE    Date 23Nov01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG9381 - Commitment Control program.                       */
/*       228362 - Issue COMMIT command after ZADSFRBL                */
/*       CAS001 - Net Present Value (NPV) Accounting                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCD &MODE)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Monitor for any errors and send appropriate message to MOPERQ */
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             RTVJOBA    TYPE(&JOBTYPE)
 
             SNDMSG     MSG('SDC9600 - Discount Factor Initialisation +
                          & Rebuild') TOMSGQ(MRUNQ)
 
/* Reset Discount Factors */
 
             CHGJOB     SWS(XXXXXX00)
 
/* Start commitment control for batch jobs with file updates */
 
             IF         COND(&MODE *NE '3') THEN(DO)
 
                IF         COND(&JOBTYPE = '0') THEN(DO)
                   STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))
                ENDDO
                                                                                         /*BUG9381*/
                IF         COND(&JOBTYPE = '1') THEN(DO)                                 /*BUG9381*/
                   STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                                /*BUG9381*/
                   MONMSG     MSGID(CPF8351)                                             /*BUG9381*/
                ENDDO                                                                    /*BUG9381*/
 
                CALL       PGM(SD9600)
 
/* Monitor for database error and send appropriate message to MOPERQ */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ERROR)
                ENDDO
 
/* Call Rebuild Program */
 
                CHGJOB     SWS(XXXXXX00)
 
                OVRDBF     FILE(SDYLDRBD) TOFILE(SDYLDRL0)
 
                CALL       PGM(ZADSFRBL) PARM(' ' ' ' ' ' ' ')
 
/* Monitor for database error and send appropriate message to MOPERQ */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ERROR)
                ENDDO
 
             COMMIT                                                                       /*228362*/
             ENDDO
 
             GOTO       CMDLBL(END)
 
ERROR:
             CHGJOB     SWS(XXXXXX11)
 
             SNDMSG     MSG('Discount Factor Initialisation & Rebuild +
                          program has terminated abnormally.') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&RTCD) VALUE('*ERROR*')
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
