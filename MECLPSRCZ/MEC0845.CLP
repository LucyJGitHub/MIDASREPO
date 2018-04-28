/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outgoing messages / Single message')            */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC0845 - Outgoing message detail print                    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  X00000           DATE 00XXX00              */
/*       PREV AMEND NO.  X00000           DATE 00XXX00              */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
PGM          PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* Parameters received from  RCF */
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)   /* SEQUENCE */
             DCL        VAR(&RLVL)  TYPE(*CHAR) LEN(1)   /* LEVEL    */
             DCL        VAR(&RBCH)  TYPE(*CHAR) LEN(3)   /* BRANCH   */
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100) /* PARMS    */
/* Copyright in object */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Variable for Message from LDA */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('Outgoing message detail print / Single +
                          message') TOMSGQ(MRUNQ)
 
/* Set-off database error switches */
             CHGJOB     SWS(XXXXXX00)
 
/* Create data queue MEDTQPRT */
             CRTDTAQ    DTAQ(QTEMP/MEDTQPRT) MAXLEN(125)
 
/* Call Single message print RPG */
             CALL    PGM(ME0845) PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('Outgoing message detail print / Single +
                          message ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             RCLRSC
             MONMSG MSGID(CPF0000 MCH0000)
             ENDPGM
