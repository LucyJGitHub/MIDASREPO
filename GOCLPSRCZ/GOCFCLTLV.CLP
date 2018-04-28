/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Bulk Update of Global File GZFCLTLVPD')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOCFCLTLV - Bulk Update of Global File GZFCLTLVPD           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2008           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CGP015             Date 06Mar09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 257576  *CREATE    Date 06Nov08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGP015 - Task Split of Bulk update of Facilities listview   */
/*       257576 - Performance: Facilities Input                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RTCD)      TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB)    TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZODNWD)    TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZOBCCY)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB)    TYPE(*DEC)  LEN(1 0)
             DCL        VAR(&MODE)      TYPE(*CHAR) LEN(4)                                /*CGP015*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2008')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             SNDPGMMSG  MSG('GOCFCLTLV - Bulk Update of Global File +
                          GZFCLTLVPD') TOMSGQ(MRUNQ)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')
             MONMSG     MSGID(CPF0000)
             CHGJOB SWS(00000000)
 
/* Get zone */
 
             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
                GOTO CMDLBL(ABNOR)
             ENDDO
 
/******      CALL       PGM(GOFCLTLVPD) PARM(&ZOZONE)                                   /* CGP015 */
             CALL       PGM(GOFCLTLVPD) PARM(&ZOZONE &MODE)                             /* CGP015 */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GOCFCLTLV ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
