/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Update Work TRAP - GENERAL LEDGER')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0032 - Update Work TRAP - GENERAL LEDGER                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BUG18886           Date 30May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG18886 - Non-standard codes exist in Midas Plus core      */
/*                  sources                                          */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZODNWD)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZOBCCY)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB)  TYPE(*DEC)  LEN(1 0)
 
             DCL        VAR(&QRYSLT ) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC0032 - Update Work TRAP - GENERAL +
                          LEDGER') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/* Get zone */
 
             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)
 
/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                           */ /*BUG18886 */
             IF         COND(&RTCD *NE '       ') THEN(DO)                             /*BUG18886 */
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/* clear files*/
             CLRPFM     FILE(GOWTRAPPD) MBR(GL)
 
/* OPNQRY*/
             OPNQRYF    FILE((GOTRAPL0)) OPTION(*INP) QRYSLT('T_MOD +
                          = "GL"') KEYFLD((T_CNUM) (T_BRCA) +
                          (T_ACCY) (T_ACOD) (T_ACSQ)) OPNSCOPE(*JOB)
             CHGVAR     VAR(&QRYSLT) VALUE('T_MOD = "GL"' +
                          *CAT ' *AND T_ZONE = "' *CAT &ZOZONE +
                          *CAT '"')
             OPNQRYF    FILE((GPTRAPL0)) OPTION(*INP) +
                          QRYSLT(&QRYSLT) KEYFLD((T_CNUM) (T_BRCA) +
                          (T_ACCY) (T_ACOD) (T_ACSQ)) OPNSCOPE(*JOB)
 
/*overrides*/
             OVRDBF     FILE(GOTRAPL0) SHARE(*YES) OPNSCOPE(*JOB)
             OVRDBF     FILE(GPTRAPL0) SHARE(*YES) OPNSCOPE(*JOB)
             OVRDBF     FILE(GOWTRAPPD) MBR(GL) SEQONLY(*YES 5000)
 
             CALL       PGM(GOUTRAPGL)
 
             CLOF       OPNID(GOTRAPL0)
             CLOF       OPNID(GPTRAPL0)
             DLTOVR     FILE(GOTRAPL0 )
             DLTOVR     FILE(GPTRAPL0 )
             DLTOVR     FILE(GOWTRAPPD)
 
/* error */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
                   SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                                GOC0032 ended abnormally - see job log') +
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
                            GOC0032 ended abnormally - see job log') +
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
                          Misys International Banking Systems Ltd.')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
