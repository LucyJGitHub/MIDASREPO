/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Fac/loan/dep reconciliation extract')        */
/*********************************************************************/
/*                                                                   */
/*  Midas - Midas Export Data Module                                 */
/*                                                                   */
/*  EDC0250 - Facility/Loan/Deposit Reconciliation Extract Control   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO. 113682                  DATE 04FEB98             */
/*  PREV AMEND NO. 101973 *CREATE          DATE 08FEB96              */
/*                 Ennnnn                  DATE DDMMMYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  113682 - Error messages should be sent to MOPERQ not QSYSOPR.    */
/*  101973 - Reconciliation Reporting - this program created.        */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,EDC0250001                                          */
 
/* Global error monitor and other initial actions */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(00000000)
 
             SNDPGMMSG  MSG('EDC0250 - Fac/Loan/Deposit +
                          Reconciliation Extract') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
/* Clear extract file and then call extract program */
 
             CLRPFM     FILE(EDREC5PD)
/*/COPY WNCPYSRC,EDC0250003                                          */
             CALL       PGM(ED0250)
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,EDC0250002                                          */
/* Copyright statement definition - at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             GOTO       CMDLBL(ENDCLPGM)
 
 /* Error processing */
ABNOR:
/************SNDPGMMSG  MSG('EDC0250 - Fac/Loan/Deposit +
                          Reconciliation Extract TERMINATED +
                          ABNORMALLY') TOMSGQ(*SYSOPR) MSGTYPE(*INQ) /*113682*/
             SNDPGMMSG  MSG('EDC0250 - Fac/Loan/Deposit +
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
