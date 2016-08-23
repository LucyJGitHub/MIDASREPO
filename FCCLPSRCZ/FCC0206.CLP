/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Review today's reporting')                   */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module               */
    /*                                                               */
    /*  FCC0206 - Review Today's Reporting                           */
    /*                                                               */
/*       (c) Misys International Banking Systems Ltd. 2001           */
    /*                                                               */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
    /*       LAST AMEND.NO  LN0149           DATE 08JUN90            */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
    /*   LN0149 - OVRDBF OF FCRREQL0 WITH SHARE(*NO)                 */
    /*                                                               */
    /*****************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* GLOBAL ERROR TRAP                                                 */
/**/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* RESET JOB SWITCHES                                                */
/**/
             CHGJOB     SWS(XXXXXX00)
             OVRDBF     FILE(MAARCDL2) SHARE(*NO)
/**/                                                                  /*LN0149*/
             OVRDBF     FILE(FCRREQL0) SHARE(*NO)                     /*LN0149*/
/**/                                                                  /*LN0149*/
             CALL       PGM(FC0060)
/**/
/* IF DATABASE ERROR OCCURRED                                        */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
             ELSE       CMD(GOTO CMDLBL(END))
 ABNOR:      SNDPGMMSG  MSG('FC0060 - Review Todays Reporting - +
                          Abnormal Termination') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(END))
 END:        ENDPGM
