/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Exception Report Generator')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0070 - Exception Report Generator.                       */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BG4543             Date 13Oct04              */
/*                      CGP008  *CREATE    Date 24Sep04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG4543 - Pass correct parameters for ZSFILE.                */
/*       CGP008 - Exception Reporting                                */
/*                Print Report Listing all Exceptions processed today*/
/*                                                                   */
/*********************************************************************/
/************PGM                                                     */                 /* BG4543 */
             PGM        PARM(&RSEQ &RLEV &RENT)                                         /* BG4543 */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                                   /* BG4543 */
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                                   /* BG4543 */
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                                   /* BG4543 */
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC0070 - Exception Reporting +
                          Housekeeping') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
 
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)
 
 
                                                                                  /* Begin 207863 */
                CLRPFM     FILE(*LIBL/GOEXKSPD)
                                                                                    /* End 207863 */
             CALL       PGM(GOEXRPEXTR)
/*********** CALL       PGM(GOEXRPREPT)                                        */   /*   BG4543   */
             CALL       PGM(GOEXRPREPT) PARM(&RSEQ &RLEV &RENT)                     /*   BG4543   */
 
 
/*error*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
                   SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                                GOC0070 ended abnormally - see job log') +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
                IF         COND(&JOBTYPE = '1') THEN(DO)
                   SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             GOC0050 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
