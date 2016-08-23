/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Affected Customer Positions - Extract Rpt')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7537 - Affected Customer Positions with Prompt           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CSE007             Date 01Apr98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
/** Variables **/
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)    /* Prompt Select */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,SEC7537001                                          */
 
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
 
/***  Clear LDA  ***/
 
             CHGDTAARA  DTAARA(LDA (134 50)) VALUE(' ')
 
/***  Clear Extract file ***/
 
             CLRPFM     FILE(SECOAPPD)
             CLRPFM     FILE(SECOCOPD)
/*/COPY WNCPYSRC,SEC7537002                                          */
 
/***  Call Program SE7537 - Affected Customer Positions Extract ***/
 
             CALL       PGM(SE7537) PARM(&RSEQ &RENT &RPARM)
 
/** If no error end processing **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))
/*/COPY WNCPYSRC,SEC7537003                                          */
 
/***  Call Program SE7538 - Affected Customer Positions Report ***/
 
             CALL       PGM(SE7538) PARM(&RSEQ &RENT)
 
/** If no error end processing **/
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(END))
 
/** Abnormal termination. **/
 
ERROR:
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) +
                 THEN(DO)
                      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                      MONMSG     MSGID(CPF0000)
                      GOTO       CMDLBL(END)
                 ENDDO
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SEC7537 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
