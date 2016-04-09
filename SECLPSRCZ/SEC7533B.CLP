/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Corporate Actions Audit List')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       CLP/SEC7533B - Corporate Actions Details Audit Report       */
/*                                                                   */
/*       Function: To print the Corporate Actions Details Report.    */
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
/*       Last Amend No. CSE007  *CREATE    Date  1Dec97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &PARM)
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PARM)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM)   TYPE(*CHAR) LEN(52)
             DCL        VAR(&COREF) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MODE)  TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&JOB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
             CHGVAR     VAR(&COREF) VALUE(%SUBSTRING(&PARM 2 6))
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
/* Create LDA if not present */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE))
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/* Retrieve Job attributes */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)
 
             SNDPGMMSG  MSG('SEC7533B - Corporate Actions Report') +
                          TOMSGQ(MRUNQ)
 
/* Override the File on itself */
             OVRDBF     FILE(SECORFL1) SHARE(*YES)
 
/* Call RPG Pgm */
             CALL PGM(SE7533) PARM(&RSEQ &RLEV &RENT &MODE &PARM)
 
/* If error */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
               CHGJOB     SWS(XXXXXX11)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               SNDMSG     MSG('SEC7533B ENDED ABNORMALLY FOR JOB ' *CAT +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               CHGVAR VAR(&MEM) VALUE('SEC7533B - JOB TERMINATED, +
                                       DATABASE IN ERROR')
               SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
 ERROR:      DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             RETURN
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
