/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL CS Fees Charges Report Control')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1993 - Customer Service Fees Charges Report Control      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CSD008  *CREATE    Date 05Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT &RSTAT)
 
/** Variables **/
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RSTAT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/** Global monitor message **/
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/** Set off all job switches **/
 
             CHGJOB     SWS(00000000)
 
/** Create LDA for job in QTEMP if it does not already exist **/
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
 
/** Clear LDA **/
 
             CHGDTAARA  DTAARA(LDA (134 50)) VALUE(' ')
             CHGVAR     VAR(&MODE) VALUE('*FULL')
 
 
/*   Call program  */
 
             OVRDBF  FILE(GLCHRGPD) SHARE(*YES)
 
             CALL       PGM(GL1993) +
                        PARM(&MODE &RSEQ &RENT &RSTAT)
             DLTOVR     FILE(GLCHRGPD)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) +
                 THEN(DO)
                      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                      MONMSG     MSGID(CPF0000)
                      GOTO       CMDLBL(END)
                 ENDDO
 
/** If no error end processing **/
 
             GOTO       CMDLBL(END)
 
/** Abnormal termination. **/
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GLC1993 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
