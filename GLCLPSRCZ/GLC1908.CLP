/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Cust. Serv. Fees - Fees Charge Maint.')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1908  - Customer Service Fees Charge Control             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CSD008  *CREATE    Date 05Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RPARM1 &RPARM2)
 
/* Declare variables */
 
             DCL        VAR(&RPARM1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RPARM2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create LDA if not present */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                        CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                                   AUT(*EXCLUDE)
                        ENDDO
 
/* Reset external switches */
 
             CHGJOB     SWS(00000000)
 
/* Call program */
 
             CALL       PGM(GL1908) PARM(&RPARM1 &RPARM2)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        ROLLBACK
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                   TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        GOTO       CMDLBL(END)
                        ENDDO
 
             COMMIT
             GOTO       CMDLBL(END)
 
/* Error processing */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC1908 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
