/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Corporate Action Details Audit Report')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       CL/SEC7533A - Corporate Actions Details Audit Report        */
/*                                                                   */
/*       Function:                                                   */
/*                                                                   */
/*       Calls :   SE7533 - Corporate Action Details Report Program  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No.  CSE007 *CREATE    Date  1Dec97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&MODE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&EXPR) TYPE(*CHAR) LEN(55) +
                          VALUE('MALCD = BJRDNB')
 
/** Global monitor message */
 
             MONMSG   MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
 
/* Create LDA if not present */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
             CHGJOB   SWS(00000000)
             CHGVAR   VAR(&PARM) VALUE('       Y')
 
/** Select Reference with Status = 'C' */
/** All Corporate Actions  */
 
               OVRDBF   FILE(SECORFL1) TOFILE(SECORFL1)
               OPNQRYF  FILE((SECORFL1) (SDBANKPD)) OPTION(*INP) +
                 FORMAT(SECORFL1) QRYSLT(&EXPR) KEYFLD(*FILE)
 
             CALL PGM(SE7533) PARM(&RSEQ &RLEV &RENT &MODE &PARM)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
             GOTO       CMDLBL(END)
 
ABNOR:       RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
               TOMSGQ(MOPERQ MRUNQ)
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('SEC7533A ENDED ABNORMALLY') +
               TOMSGQ(MOPERQ MRUNQ)
             MONMSG        MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CLOF          OPNID(SECORFL1)
             MONMSG        MSGID(CPF0000 MCH0000)
             DLTOVR        FILE(*ALL)
             MONMSG        MSGID(CPF0000 MCH0000)
             ENDPGM
