/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Send prompt to RE CASH reconcil. Con')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4144  - Send Prompt to RE CASH Reconciliation Job        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CPK015             Date 26Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CCI001             Date 10NOV98              */
/*                      122060             Date 21Aug97              */
/*                      CRT002 *CREATE     Date  1Dec95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK015 - Move data queues fom XLIB to DPLIB.                */
/*       CCI001 - Midas Cashier Enhancements - dtaq RECASH in XLIB   */
/*                not DILIB                                          */
/*       122060 - Remove sending of Prompt msg and only monitor for  */
/*                End msg on DTAQ/RECASH.                            */
/*       CRT002 - Retail Branch Access.                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE)
/**/
/* Copyright statement definition  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
/*********** DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)           */  /*CCI001*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)                /*CCI001*/
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('REC4144 - Send Prompt to RE CASH +
                          Reconciliation Control') TOMSGQ(MRUNQ)
/**/
/**Construct*DILIB**************************************************/ /*CCI001*/
/********** RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)      */ /*CCI001*/
/**********  CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')  */ /*CCI001*/
/**********  CHGVAR     VAR(&RTN_CODE) VALUE(' ')                  */ /*CCI001*/
/**/
/* Construct &XLIB */                                                 /*CCI001*/
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)        /*CCI001*/
             CHGVAR     VAR(&XLIB) VALUE(&DBPREFIX *CAT 'XLIB')       /*CCI001*/
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')                     /*CCI001*/
/**/
/* Check if data queue exists */
/**/
/************CALL       PGM(REC4145)                                                   */ /*CPK015*/
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
/*********** ALCOBJ     OBJ((&DILIB/RECASH *DTAQ *EXCL)) WAIT(0) */   /*CCI001*/
/************ALCOBJ     OBJ((&XLIB/RECASH *DTAQ *EXCL)) WAIT(0)                /*CCI001*/ /*CPK015*/
             ALCOBJ     OBJ((RE4144DRI *DTAQ *EXCL)) WAIT(0)                              /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(SEND)
             ENDDO
/**/
/* Start process */
/**/
             CALL       PGM(REC4143) PARM(&RTN_CODE)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'MRC0009')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
/* Deallocate */
/**/
/*********** DLCOBJ     OBJ((&DILIB/RECASH *DTAQ *EXCL))        */    /*CCI001*/
/************DLCOBJ     OBJ((&XLIB/RECASH *DTAQ *EXCL))                        /*CCI001*/ /*CPK015*/
             DLCOBJ     OBJ((RE4144DRI *DTAQ *EXCL))                                      /*CPK015*/
                                                                      /*122060*/
SEND:                                                                 /*122060*/
                                                                      /*122060*/
/**/
/**Send*data*queue*entry*to*prompt*process**/                         /*122060*/
/**/
/***********SEND:       CHGVAR     VAR(&DATA) VALUE(' ')           */ /*122060*/
/*********** CHGVAR     VAR(&DATA) VALUE('Prompt')                 */ /*122060*/
/*********** CALL       PGM(QSNDDTAQ) PARM('RECASH' &DILIB +       */ /*122060*/
/***********              &FLDLEN &DATA)                           */ /*122060*/
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*********** DLCOBJ     OBJ((&DILIB/RECASH *DTAQ *EXCL)) */           /*CCI001*/
/************DLCOBJ     OBJ((&XLIB/RECASH *DTAQ *EXCL))                        /*CCI001*/ /*CPK015*/
             DLCOBJ     OBJ((RE4144DRI *DTAQ *EXCL))                                      /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program REC4144 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4144 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             ENDPGM
