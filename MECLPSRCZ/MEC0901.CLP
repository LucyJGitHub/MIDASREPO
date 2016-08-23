/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MG MT970 Accounts List')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - ME Module                                           */
/*                                                                   */
/*       MEC0901 - MT970 Account List                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSW099  *CREATE    Date 28Feb05              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSW099 - Creation of MT970 Netting Statements               */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&SEQ &LVL &ENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
/* Monitor for any errors and send appropriate message to MOPERQ */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             SNDMSG     MSG('MEC0901 - MT970 Accounts List') +
                          TOMSGQ(MRUNQ)
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 local +
                          data area equivalent'))
 
             CHGJOB     SWS(00000000)
 
/* Call program */
             CALL       PGM(ME0901) PARM(&SEQ)
 
/* Monitor for database error and send appropriate message to MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ERROR:      DMPCLPGM
             CHGJOB     SWS(XXXXXX11)
             SNDMSG     MSG('MT970 Accounts List has terminated +
                          abnormally.') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
