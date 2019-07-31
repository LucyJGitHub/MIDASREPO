/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Futures transactions reconciliaton extrct')  */
/********************************************************************/
/*                                                                  */
/*  Midas - Midas Export Data Module                                */
/*                                                                  */
/*  EDC0240 - FF Transactions Reconciliation Extract Control        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 113682             Date 04Feb98              */
/*                      101973 *C *CREATE  Date 08Feb96              */
/*                 Ennnnn                  DATE DDMMMYY             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*  113682 - Error messages should be sent to MOPERQ not QSYSOPR.   */
/*  101973 - Reconciliation Reporting - this program created.       */
/*                                                                  */
/********************************************************************/
             PGM
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,EDC0240001                                          */
 
/* Global error monitor and other initial actions */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(00000000)
 
             SNDPGMMSG  MSG('EDC0240 - FF Transactions +
                          Reconciliation Extract') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
/* Clear extract file and then call extract program */
 
             CLRPFM     FILE(EDREC4PD)
/*/COPY WNCPYSRC,EDC0240003                                          */
             CALL       PGM(ED0240)
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,EDC0240002                                          */
/* Copyright statement definition - at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             GOTO       CMDLBL(ENDCLPGM)
 
 /* Error processing */
 
ABNOR:
/************SNDPGMMSG  MSG('EDC0240 - FF Transactions +
                          Reconciliation Extract TERMINATED +
                          ABNORMALLY') TOMSGQ(*SYSOPR) MSGTYPE(*INQ) /*113682*/
             SNDPGMMSG  MSG('EDC0240 - FF Transactions +
                          Reconciliation Extract TERMINATED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)          /*113682*/
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000 MCH0000)
                DMPCLPGM
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
ENDCLPGM:
             ENDPGM
