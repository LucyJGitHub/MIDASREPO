/********************************************************************/
/*OVRF*  OVRDBF FILE(EDOUTFPD) TOFILE(QAFDMBR)                      */
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Historic balances special processing')       */
/********************************************************************/
/*                                                                  */
/*       Midas - Export Data Interface Module                       */
/*                                                                  */
/*       EDC0415 - Historic Balances Special Processing             */
/*                                                                  */
/*       Function : This program is part of the special processing  */
/*                  for the historic balances file and calls ED0415 */
/*                  to write formatted records from GLHIBLPD and    */
/*                  GLAVBLPD to EDBULKPD                            */
/*                                                                  */
/*       Calls :    EDC0020                                         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CED002 *CREATE     DATE 16MAY97             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CED002 - Midas ED Enhancements                             */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&USVLIB &UFILEN &UMEMBN &USQCD &USTREM)
 
 
/* Copyright statement definition */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&USVLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&UFILEN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UMEMBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USQCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USTREM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGF)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
 
             DCLF       FILE(EDOUTFPD)
 
 
/* Global error monitor */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Copyright statement definition - at runtime */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
 
/* Get Record */
             RCVF
             MONMSG     MSGID(CPF0864 CPF5264) EXEC(GOTO CMDLBL(FINAL))
READ:
             IF         COND((&UMEMBN *EQ ' ') *OR (&UMEMBN *EQ +
                          &MBNAME)) THEN(DO)
 
               OVRDBF     FILE(GLHIBLL1) MBR(&MBNAME)
               OVRDBF     FILE(GLAVBLL1) MBR(&MBNAME)
               CALL       PGM(ED0415) PARM(&USVLIB &UFILEN &MBNAME +
                          &USQCD &USTREM)
               IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
             ENDDO
 
/* Get Record */
             RCVF
             MONMSG     MSGID(CPF0864 CPF5264) EXEC(GOTO +
                          CMDLBL(ENDREAD))
 
             GOTO       CMDLBL(READ)
 
ENDREAD:
 
/* Dummy call to delete the general request */
             IF         COND(&UMEMBN *EQ ' ') THEN(DO)
 
               CALL       PGM(ED0410) PARM('*CLOSE' 'GLHIBLPD' ' ' +
                          'EDC0415' ' ' ' ' ' ')
               IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
             ENDDO
 
/* Delete overrides */
             DLTOVR     FILE(GLHIBLL1)
             DLTOVR     FILE(GLAVBLL1)
 
 
/* Normal termination */
FINAL:
             GOTO       CMDLBL(ENDCLPGM)
 
 
/* Abnormal termination */
ABNOR:
 
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)
             MONMSG     MSGID(CPF0000)
 
             IF         COND(&MSGID *NE '       ') THEN(DO)
                 SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                            MSGDTA(&MSGDTA) TOMSGQ(MOPERQ MRUNQ)
                 MONMSG     MSGID(CPF0000)
 
             ENDDO
 
             CHGVAR     VAR(&MEM) VALUE('EDC0415 - ED Failed to +
                          Process' *BCAT &UFILEN)
             IF         COND(&UMEMBN *NE ' ') THEN(CHGVAR VAR(&MEM) +
                          VALUE(&MEM *TCAT ' Member' *BCAT &UMEMBN))
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
 
             SNDPGMMSG  MSG('EDC0415 - ED Historic Balances Special +
                          Processing TERMINATED ABNORMALLY') +
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
