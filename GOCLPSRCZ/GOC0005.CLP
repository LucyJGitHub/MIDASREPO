/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Universal transactions updater')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0005 - Universal Transactions Updater                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/*                      AR750189           Date 28May11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       AR750189 - SCKOBJLCK Failed due to GPUTULUX11               */
/*                  (Child: AR750190)                                */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ZONE &DTAQ)
 
             DCL        VAR(&ZONE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQ)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                                  /*AR750189*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/** Skipped submitting GOC0005 if system is not input cycle */                          /*AR750189*/
            RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                     /*AR750189*/
/********** IF         COND(&MPHAS *NE 'A') THEN(GOTO +
/**********              CMDLBL(END))                                            /*AR750189 CCB020*/
             IF         COND((&MPHAS *NE 'A') *AND (&MPHAS *NE 'G')) +
                          THEN(GOTO CMDLBL(END))                                          /*CCB020*/
                                                                                        /*AR750189*/
             ALCOBJ     OBJ((&DTAQ *DTAQ *EXCLRD)) WAIT(30)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
             SNDPGMMSG  MSG('Attempt to start Universal Transactions +
                          Updater has failed. Probable cause: +
                          process is active already.') TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
 
             CHGJOB SWS(00000000)
 
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)
 
/* overrides */
 
             OVRDBF     FILE(GPUTAXL1) TOFILE(*FILE) SHARE(*NO)
             OVRDBF     FILE(GPTRAPL0) TOFILE(*FILE) SHARE(*NO)
             OVRDBF     FILE(GPULOGPD) SHARE(*NO) SEQONLY(*YES 1)
 
             OVRDBF     FILE(DEALSX) TOFILE(DEALS) SHARE(*NO)
             OVRDBF     FILE(CLOANX) TOFILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(CLOANS) TOFILE(CLOAN) SHARE(*NO)
 
             CALL       PGM(GOUTUPDTR) PARM(&ZONE &DTAQ)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               ROLLBACK
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GOC0005 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               GOTO       CMDLBL(END)
             ENDDO
 
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GOC0005 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             DLCOBJ     OBJ((&DTAQ *DTAQ *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
