/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI COB control program (accruals)')             */
/********************************************************************/
/*                                                                  */
/*       Midas/Trade Innovation Interface Module                    */
/*                                                                  */
/*       TIC0342 - TI COB Control Program (accruals)                */
/*                                                                  */
/*       Submitted by : TIC0500                                     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG3835            Date 28Jul04             */
/* Midas Release 4.01.02 --------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CTI003  *CREATE    Date 12Apr01             */
/*                      Xnnnnn             Date ddmmmyy             */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       BUG3835 - STRCMTCTL fails as already active                */
/*       CTI003 - This program controls the batching of accruals    */
/*                and the generation of Suspense Accounts & the     */
/*                resultant reports.                                */
/********************************************************************/
             PGM
 
/* Copyright statement definition */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Other declarations */
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGF)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACNO) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RUNF) TYPE(*CHAR) LEN(1)
 
/* Global error monitor */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)                                                   /*BUG3835*/
 
/* Call program to process accruals. */
             CALL       PGM(TI0342) PARM('S' '   ' &ACNO &RUNF)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             IF         COND(&RUNF *EQ 'Y') THEN(DO)
                OVRDBF     FILE(GLJENPPD) SHARE(*YES)
                OPNQRYF    FILE((GLJENPPD)) QRYSLT('BTACCD *EQ "' *CAT +
                             &ACNO *CAT '"') KEYFLD((BTCYCD) (BTBTNB))
                CALL       PGM(TI0343)
                DLTOVR     FILE(GLJENPPD)
                CLOF       OPNID(GLJENPPD)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)
             MONMSG     MSGID(CPF0000)
 
             IF         COND(&MSGID *NE '       ') THEN(DO)
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                             MSGDTA(&MSGDTA) TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             SNDPGMMSG  MSG('TIC0342 Midas TI COB Control Program +
                          for Accruals ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
