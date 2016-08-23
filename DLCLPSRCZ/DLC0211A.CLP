/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL P/R TELEXES EXTRACTS')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0211A - PAY/RECEIVE TELEXES EXTRACTS                    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E19344                  DATE  24JUL90       */
/*       PREV AMEND NO. SO1194                  DATE  21/04/89      */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       E19344 - DATABASE ERROR IN DL0300 SHOULD HALT PROGRAM     */
/*       S01194 - STANDING DATA CHANGES                             */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/**/
             CLRPFM     FILE(DTRIEHH)
             CLRPFM     FILE(DTRIEPH)
             CLRPFM     FILE(DTRIEZZ)
             CLRPFM     FILE(PREX1HH)
             CLRPFM     FILE(PREX1PH)
             CLRPFM     FILE(PREX1ZZ)
             CLRPFM     FILE(PREX2HH)
             CLRPFM     FILE(PREX2PH)
             CLRPFM     FILE(PREX2ZZ)
             CLRPFM     FILE(PREX3HH)
             CLRPFM     FILE(PREX3PH)
             CLRPFM     FILE(PREX3ZZ)
/*  OUTSTANDING DEAL TRANSACTIONS INDEX EXTRACT                */
             SNDPGMMSG  MSG('CREATE PAY/RECEIVE EXTRACT FILE') +
                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('XXXXXX0X')
             CHGJOB     SWS(&SWS)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01194*/
             CALL       PGM(DL0300)
/*********** DLTOVR     FILE(*ALL)                                    /*S01194*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)     /*E19344*/
/*  CREATE PAY/RECEIVE EXTRACT FILE                            */
             SNDPGMMSG  MSG('PAY/RECEIVE EXTRACT FILES CREATION') +
                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('00000010')
             CHGJOB     SWS(&SWS)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01194*/
             OVRDBF     FILE(TRANS) TOFILE(DTRIN)
             CALL       PGM(DL0304)
             DLTOVR     FILE(*ALL)
             ENDDO                                           /*E19344*/
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CLRPFM     FILE(DTRIEHH)
                CLRPFM     FILE(DTRIEPH)
                CLRPFM     FILE(DTRIEZZ)
             ENDDO
/*   ERROR MESSAGES                                             */
             ELSE       DO
                IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED-+
                                               DATABASE IN ERROR')
                ENDDO
                IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('FILE CONTROLS OUT OF +
                                               BALANCE')
                ENDDO
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                SNDPGMMSG  MSG(&MSG) TOMSGQ(&JOB) MSGTYPE(*INFO)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
