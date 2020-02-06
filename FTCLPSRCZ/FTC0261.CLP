/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT Non-Authorised Trans. Shadp')                */
/*****************************************************************/
/*                                                               */
/*     Midas - FUNDS TRANSFER                                    */
/*                                                               */
/*     FTC0261  - Control Update of shadow post files for        */
/*                Non-Authorised Transactions                    */
/*                                                               */
/*       (c) Finastra International Limited 2001                     */
/*                                                               */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAP006             Date 20Nov98              */
/*                      041693             Date 05Jan93              */
/*                    045014            DATE: 07DEC92            */
/*                                                               */
/*---------------------------------------------------------------*/
/*                                                               */
/*       MD046248 - Finastra Rebranding                              */
/*     CAP006 - APIs Phase IV                                    */
/*              Scope commitment control to the job rather than  */
/*              the activation group                             */
/*     041693 - Delivered as part of fix.                        */
/*                                                               */
/*     045014 - New program to call FT0261                       */
/*                                                               */
/*****************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('FTC0261 - Non-Authorised Trans. Shadow +
                          Post') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
/* */
/* Start Commitment Control */
/* */
/**********  STRCMTCTL  LCKLVL(*CHG) **/                                                  /*CAP006*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                                       /*CAP006*/
             MONMSG     MSGID(CPF8351)
/* */
/* Run FT0261 - Shadow post update */
/* */
/*/COPY WNCPYSRC,FTH00383                                            */
             CALL       PGM(FT0261) PARM(&RTN_CODE)
/*/COPY WNCPYSRC,FTH00384                                            */
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program FTC0261 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FTC0261 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)                                                 /*CAP006*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*CAP006*/
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
