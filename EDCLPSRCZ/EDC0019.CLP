/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Bulk transfer preparation')                  */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas Export Data Interface Module                 */
/*                                                                  */
/*       EDC0019 - Bulk Transfer Initialisation component           */
/*                                                                  */
/*       Function : This program performs initialisation needed by  */
/*                  each bulk transfer.                             */
/*                                                                  */
/*       Submitted by : COB Process                                 */
/*                                                                  */
/*       Calls :        ED0010                                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 20May08             */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 136831             Date 10Jun98             */
/*                      CED002 *CREATE     DATE 13MAY97             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       BG18886 - Non-standard codes exist in Midas Plus core      */
/*                  sources                                         */
/*       136831 - Batches should be processed in sequence no. order */
/*       CED002 - Created for ED Enhancements                       */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&WRTCD &EXSC)
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Other declarations */
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGF)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WRTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EXSC) TYPE(*CHAR) LEN(10)
 
/* Global error monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Copyright statement definition - at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CHGVAR     VAR(&MEM) VALUE('EDC0019 - ED Bulk Transfer +
                          Initialisation')
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* Prepare for transfer */
 
/* Select records for this extract */
             OVRDBF     FILE(EDBUTFPD) SHARE(*YES)
/*           OPNQRYF    FILE((EDBUTFPD)) QRYSLT('(EDEXSC *EQ "' ** +    136831*/
/*                        &EXSC ** '")')                                136831*/
/*           OPNQRYF    FILE((EDBUTFPD)) QRYSLT('(EDEXSC *EQ "' ** +
                          &EXSC ** '")') KEYFLD((EDEXSC) (EDSQCD))    */ /*136831  BUG18886 */
             OPNQRYF    FILE((EDBUTFPD)) QRYSLT('(EDEXSC *EQ "' *CAT +
                          &EXSC *CAT '")') KEYFLD((EDEXSC) +
                          (EDSQCD))                                      /*136831*/ /*BG18886*/
 
/* Copy PF/EDBUTFPD to PF/EDFBUTPD and DTAQ/EDBULKQ */
             CALL       PGM(ED0010)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             CLOF       OPNID(EDBUTFPD)
 
/* Normal termination */
             GOTO       CMDLBL(ENDCLPGM)
 
 
ABNOR:
 
/* Abnormal termination */
 
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)
             MONMSG     MSGID(CPF0000)
 
             IF         COND(&MSGID *NE '       ') THEN(DO)
                 SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                            MSGDTA(&MSGDTA) TOMSGQ(MOPERQ MRUNQ)
                 MONMSG     MSGID(CPF0000)
             ENDDO
 
             SNDPGMMSG  MSG('EDC0019 Midas ED Bulk Transfer +
                          Initialisation TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               CHGJOB     SWS(XXXXXX11)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDCLPGM:
             ENDPGM
