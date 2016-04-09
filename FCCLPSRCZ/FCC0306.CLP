/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Periodic requests audit list')               */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module               */
    /*                                                               */
    /*  FCC0306 - PERIODIC REPORTS AUDIT LIST                        */
    /*                                                               */
/*       (c) Misys International Banking Systems Ltd. 2001           */
    /*                                                               */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
    /*       LAST AMEND.NO.                  DATE 00/00/00           */
    /*       PREV AMEND.NO.                  DATE 00/00/00           */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
    /*  THIS PROGRAM WILL CALL THE PERIODIC REQUESTS AUDIT LIST      */
    /*                                                               */
    /*****************************************************************/
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&AUDIT &SEQ &LVL &ETTY)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&AUDIT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ETTY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(FC0210P) PARM('' &AUDIT &SEQ &LVL &ETTY)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                  CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(THEEND))
 
 ABNOR:      SNDPGMMSG  MSG('FCC0306 - Periodic Requests Audit List +
                          terminated abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(THEEND))
 THEEND:
             ENDPGM
