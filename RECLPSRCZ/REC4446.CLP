/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI Read of RECITHPD for Jrn Seq and Rcv')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4446 - Read of RECITHPD for Journal Seq No and           */
/*                 Journal Receiver                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 118134             Date 02Jun97              */
/*       Prev Amend No. CRT003  *CREATE    Date 22JUL96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Cashier Interface                                  */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&JNSQ1 &JNRCN1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&JNSQ1)  TYPE(*DEC)  LEN(10)
             DCL        VAR(&JNRCN1) TYPE(*CHAR) LEN(10)
             DCLF       FILE(RECITHPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Main Processing */
 
             OVRDBF     FILE(RECITHPD) SHARE(*NO)
             DLYJOB     DLY(30)
             OPNDBF     FILE(RECITHPD) OPTION(*INP)
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
               CLOF OPNID(RECITHPD)
               CHGJOB SWS(XXXXXX11)
               GOTO CMDLBL(DBERR)
             ENDDO
 
             CHGVAR     VAR(&JNSQ1)  VALUE(&RSJOSQ)
             CHGVAR     VAR(&JNRCN1) VALUE(&RSNXRC)
             CLOF       OPNID(RECITHPD)
 
             GOTO       CMDLBL(END)
 
 /* Database error processing */
 
 DBERR:
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('CI Read of RECITHPD Ended +
                          Abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG  MSGID(CPF2469)  EXEC(DO)                         /*118134*/
                SNDPGMMSG  MSG('CI Read of RECITHPD Ended +
                          Abnormally') TOMSGQ(QSYSOPR)                /*118134*/
             ENDDO                                                    /*118134*/
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
