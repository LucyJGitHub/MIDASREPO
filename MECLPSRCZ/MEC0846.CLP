/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ISO Mail / Single message')                     */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC0846 - ISO Mail / Single message print                  */
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
 
PGM          PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* Parameters received from  RCF */
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)   /* SEQUENCE */
             DCL        VAR(&RLVL)  TYPE(*CHAR) LEN(1)   /* LEVEL    */
             DCL        VAR(&RBCH)  TYPE(*CHAR) LEN(3)   /* BRANCH   */
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100) /* PARMS    */
 
/* Variable for Message from LDA */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/* Copyright in object */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('ISO Mail / Single message print') +
                          TOMSGQ(MRUNQ)
 
/* Set-off database error switches */
             CHGJOB     SWS(XXXXXX00)
 
/* Create data queue MEISOPRT */
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90)
 
/* Override file to prevent share of open data paths */
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)
 
/* Call Single message print RPG */
             CALL    PGM(ME0846) PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('ISO Mail / Single message print ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             DLTOVR     FILE(*ALL)
             MONMSG MSGID(CPF0000 MCH0000)
             RCLRSC
             MONMSG MSGID(CPF0000 MCH0000)
             ENDPGM
