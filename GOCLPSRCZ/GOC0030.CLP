/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Update Work TRAP - DEALING/LENDING')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0030 - Update Work TRAP - DEALING/LENDING                */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BUG18886           Date 30May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG18886 - Non-standard codes exist in Midas Plus core      */
/*                  sources                                          */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MOD)
 
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZODNWD)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZOBCCY)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB)  TYPE(*DEC)  LEN(1 0)
 
             DCL        VAR(&MOD    ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&QRYSLT ) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             IF         COND(&MOD = 'DL')   THEN(DO)
                SNDPGMMSG  MSG('GOC0030 - Update Work TRAP - DEALING') +
                             TOMSGQ(MRUNQ)
             ENDDO
/**********  IF         COND(&MOD *= 'DL')  THEN(DO)                                */ /*BUG18886 */
             IF         COND(&MOD *NE 'DL')  THEN(DO)                                  /*BUG18886 */
                SNDPGMMSG  MSG('GOC0030 - Update Work TRAP - LENDING') +
                             TOMSGQ(MRUNQ)
             ENDDO
 
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
             CLRPFM     FILE(GOWTRAPPD) MBR(&MOD)
 
/* OPNQRY*/
             IF         COND(&MOD = 'DL')   THEN(DO)
             OPNQRYF    FILE((GOTRAPL0)) OPTION(*INP) QRYSLT('T_MOD +
                          = "DL"') KEYFLD((T_TREF)) OPNSCOPE(*JOB)
             CHGVAR     VAR(&QRYSLT) VALUE('T_MOD = "DL"' +
                          *CAT ' *AND T_ZONE = "' *CAT &ZOZONE +
                          *CAT '"')
             OPNQRYF    FILE((GPTRAPL0)) OPTION(*INP) +
                          QRYSLT(&QRYSLT) KEYFLD((T_TREF)) +
                          OPNSCOPE(*JOB)
             ENDDO
/**********  IF         COND(&MOD *= 'DL')  THEN(DO)                                */ /*BUG18886 */
             IF         COND(&MOD *NE 'DL')  THEN(DO)                                  /*BUG18886 */
             OPNQRYF    FILE((GOTRAPL0)) OPTION(*INP) QRYSLT('T_MOD +
                          = "LE"') KEYFLD((T_TREF)) OPNSCOPE(*JOB)
             CHGVAR     VAR(&QRYSLT) VALUE('T_MOD = "LE"' +
                          *CAT ' *AND T_ZONE = "' *CAT &ZOZONE +
                          *CAT '"')
             OPNQRYF    FILE((GPTRAPL0)) OPTION(*INP) +
                          QRYSLT(&QRYSLT) KEYFLD((T_TREF)) +
                          OPNSCOPE(*JOB)
             ENDDO
 
/*overrides*/
             OVRDBF     FILE(GOTRAPL0) SHARE(*YES) OPNSCOPE(*JOB)
             OVRDBF     FILE(GPTRAPL0) SHARE(*YES) OPNSCOPE(*JOB)
             OVRDBF     FILE(GOWTRAPPD) MBR(&MOD) SEQONLY(*YES 5000)
 
             CALL       PGM(GOUTRAPDL)
 
             CLOF       OPNID(GOTRAPL0)
             CLOF       OPNID(GPTRAPL0)
             DLTOVR     FILE(GOTRAPL0 )
             DLTOVR     FILE(GPTRAPL0 )
             DLTOVR     FILE(GOWTRAPPD)
 
/* error */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
                   SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                                GOC0030 ended abnormally - see job log') +
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
                            GOC0030 ended abnormally - see job log') +
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
