/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Historic Interface Detls File Purge Ctl')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC4490 - Historic Interface Details File Purge Control     */
/*                                                                   */
/*       (C) Copyright Finastra International Limited 2003           */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 05Aug04              */
/*                      CGL028  *CREATE    Date 26Sep03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CGL028 - GL Postings Interface                              */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) +
                          VALUE('Copyright Finastra International +
                          Banking System Ltd. 2003')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LDA)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
/**/
/**  Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                             CMDLBL(ABNOR))
 
             SNDMSG     MSG('GLC4490 - Historic Interface Details +
                          File Purge') TOMSGQ(MRUNQ)
/**/
/**  Create LDA if it's not yet existing */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas Local Data Area'))
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
             CHGJOB     SWS(00000000)
/**/
/**  Call purge program  */
/**/
             CALL       PGM(GL4490)
 
             RTVJOBA    SWS(&SWS)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/**********  RGZPFM     FILE(GLHSIFPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('GLHSIFPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Program GLC4490 ended abnormally. +
                          Please check joblog') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('Copyright Finastra +
                          International Banking Systems Ltd. 2003')
             ENDPGM
