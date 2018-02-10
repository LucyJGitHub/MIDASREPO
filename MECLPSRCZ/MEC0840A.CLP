/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outgoing messages status summary')              */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC0840A - OUTGOING MESSAGES STATUS SUMMARY                */
/*                                                                  */
/*      (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO.  X00000           DATE 00XXX00              */
/*                       X00000           DATE 00XXX00              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/********************************************************************/
 
             PGM
 
             DCL VAR(&RUNDAT) TYPE(*CHAR) LEN(6)
             DCL VAR(&DATFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&MBIN)  TYPE(*CHAR) LEN(1)
/* Copyright in object */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,MEC0840A01                                          */
 
 
/* Variable for Message from LDA */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             MONMSG     MSGID(CPF0000)
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('OUTGOING MESSAGES STATUS SUMMARY') +
                          TOMSGQ(MRUNQ)
 
/* Set-off database error switches */
             CHGJOB     SWS(XXXXXX00)
 
/* Access data area rundat for the Run date */
 
 
/* Convert rundat DDMMMYY to yymmdd */
             CALL PGM(ZM0080) PARM(&RUNDAT &DATFMT)
 
/*/COPY WNCPYSRC,MEC0840A02                                          */
/* Set up the FROM date & the TO date parameter */
             CHGVAR     VAR(%SST(&PARM  1 6)) VALUE('ALL   ')
             CHGVAR     VAR(%SST(&PARM 15 6)) VALUE(&RUNDAT)
             CHGVAR     VAR(%SST(&PARM 21 6)) VALUE(&RUNDAT)
             CHGVAR     VAR(%SST(&PARM 27 4)) VALUE('1234')
/* Call Outgoing messages by status summary RPG - System level*/
             CALL    PGM(MEC0840) PARM('     ' 'S' '   ' &PARM)
/*/COPY WNCPYSRC,MEC0840A03                                          */
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
 
/* If system is multibranched then produce branch 'ALL' report */
    RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)
 
    IF     COND(&MBIN = 'Y') THEN(DO)
 
/* Call Outgoing messages by status summary RPG - Branch 'ALL'*/
             CALL    PGM(MEC0840) PARM('     ' 'B' 'ALL' &PARM)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
    ENDDO
 
    GOTO END
 ERR:        SNDPGMMSG  MSG('Outgoing Messages status summary ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             DLTOVR     FILE(*ALL)
             MONMSG MSGID(CPF0000 MCH0000)
             RCLRSC
             MONMSG MSGID(CPF0000 MCH0000)
             ENDPGM
