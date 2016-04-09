/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Movements Status Audit List')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC4300 - Movements Status Audit List                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSE039   *CREATE   Date 06Mar03              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE039 - Automatic Settlement of Trades                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT &PARM)
 
/** Variables **/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)   /* Prompt Select */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PPAS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TRAD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DPMV) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ALL) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/** Global monitor message **/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/** Set off all job switches **/
             CHGJOB     SWS(00000000)
 
/** Create LDA for job in QTEMP if it does not already exist **/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                        CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                        ENDDO
 
/***  Clear LDA   **/
             CHGDTAARA  DTAARA(LDA (134 50)) VALUE(' ')
 
             CHGVAR     VAR(&PPAS) VALUE('I')
             CHGVAR     VAR(&TRAD) VALUE(%SST(&PARM 1 6))
             CHGVAR     VAR(&DPMV) VALUE(%SST(&PARM 7 12))
             CHGVAR     VAR(&ALL) VALUE(%SST(&PARM 13 13))
 
/***  Call Program SE4300  ***/
             CALL       PGM(SE4300) PARM(&PPAS &RSEQ &RLEV &RENT +
                          &TRAD &DPMV &ALL)
 
/** If no error end processing **/
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(END))
 
/** Abnormal termination. **/
 
ERROR:
 
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(END)
             ENDDO
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SEC4300 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
