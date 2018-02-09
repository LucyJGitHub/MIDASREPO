/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Report descriptions audit report')           */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module               */
    /*                                                               */
    /*  FCC0304 - REPORT DESCRIPTIONS AUDIT REPORT                   */
    /*                                                               */
/*       (c) Finastra International Limited 2001                     */
    /*                                                               */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01407             Date 26Mar93              */
/*                      LN0077             Date 01May90              */
    /*                                                               */
    /*****************************************************************/
    /*                                                               */
/*       MD046248 - Finastra Rebranding                              */
    /*    S01407 - SWITCHABILITY ENHANCEMENTS                        */
    /*    LN0077 - REINSTATE GLOBAL ERROR MONITORING                 */
    /*                                                               */
    /*****************************************************************/
    /*  THIS PROGRAM WILL CALL THE REPORT DESCRIPTIONS AUDIT REPORT  */
    /*  IN EITHER FULL LIST, OR AUDIT MODE, HAVING MADE A            */
    /*  SELECTION OF THE REQUIRED RECORDS                            */
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
             DCL        VAR(&AUDIT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ETTY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*           MONMSG     MSGID(MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                           */ /*LN0077*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*LN0077*/
 
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGJOB     SWS(XXXXXX00)
 
             IF         COND(&AUDIT *EQ 'A') THEN(CHGJOB SWS(1XXXXXXX))
 
/************OVRDBF     FILE(FCREPTL1) SHARE(*NO)*******************/ /*S01407*/
             OVRDBF     FILE(FCREPTJ0) SHARE(*NO)                     /*S01407*/
 
             CALL       PGM(FC0300) PARM(&SEQ &LVL &ETTY)
 
             IF         COND(%SWITCH(1XXXXX01)) THEN(SNDMSG MSG('File +
                          controls out of balance in FC0300 - Report +
                          Descriptions Audit List') TOMSGQ(MOPERQ))
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                  CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(THEEND))
 
 ABNOR:      SNDPGMMSG  MSG('FCC0304 - Report Descriptions Audit List +
                          terminated abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(THEEND))
 THEEND:     IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
    /*************CLOF       OPNID(FCREPTL1)************************/ /*S01407*/
                  CLOF       OPNID(FCREPTJ0)                          /*S01407*/
                  MONMSG     MSGID(CPF0000)
             ENDDO
             ENDPGM
