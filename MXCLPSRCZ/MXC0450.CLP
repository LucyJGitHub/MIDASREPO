/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Clear MXMQ* files')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0450 - Clear MXMQ* Files                                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG12677           Data 16Nov06              */
/*       Prev Amend No. CMX013             Data 29Jun06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX001  *CREATE    Data 01Jan00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG12677 - Skip abnormal process if there is no error.      */
/*              Also add error handling.                             */
/*       CMX013 - Allow Additional Members                           */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MXC0450INT                                          */
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
 /* CMX013 START */
      /*     DCL        VAR(&MBR)  TYPE(*CHAR) LEN(5)            */
      /*     DCL        VAR(&PR)   TYPE(*CHAR) LEN(1) VALUE(C)   */
      /*     DCL        VAR(&CNT)  TYPE(*DEC)  LEN(4 0) VALUE(0) */
      /*     DCL        VAR(&CNTA) TYPE(*CHAR) LEN(4)            */
 /* CMX013 END   */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,MXC0450MPS                                          */
 
 /* CMX013 START */
     /* LOOP:        CHGVAR     VAR(&CNT) VALUE(&CNT + 1) */
     /*      CHGVAR     VAR(&CNTA) VALUE(&CNT)            */
     /*      CHGVAR     VAR(&MBR) VALUE(&PR *CAT &CNTA)   */
     /*      CLRPFM     FILE(MXPLOGPD) MBR(&MBR)   */
     /*      CLRPFM     FILE(MXMQDLPD) MBR(&MBR)   */
     /*      CLRPFM     FILE(MXMQDMPD) MBR(&MBR)   */
     /*      CLRPFM     FILE(MXMQDSPD) MBR(&MBR)   */
     /*      CLRPFM     FILE(MXMQDVPD) MBR(&MBR)   */
     /*      CLRPFM     FILE(MXMQDXPD) MBR(&MBR)   */
             CLRPFM     FILE(MXPLOGPD) MBR(*ALL)
             MONMSG     MSGID(CPF0000)                                                  /*BUG12677*/
             CLRPFM     FILE(MXMQDLPD) MBR(*ALL)
             MONMSG     MSGID(CPF0000)                                                  /*BUG12677*/
             CLRPFM     FILE(MXMQDMPD) MBR(*ALL)
             MONMSG     MSGID(CPF0000)                                                  /*BUG12677*/
             CLRPFM     FILE(MXMQDSPD) MBR(*ALL)
             MONMSG     MSGID(CPF0000)                                                  /*BUG12677*/
             CLRPFM     FILE(MXMQDVPD) MBR(*ALL)
             MONMSG     MSGID(CPF0000)                                                  /*BUG12677*/
             CLRPFM     FILE(MXMQDXPD) MBR(*ALL)
 /* CMX013 END */
             MONMSG     MSGID(CPF0000)
 /* CMX013 START */
      /*     IF         COND(&CNT = 60) THEN(GOTO CMDLBL(END))   */
      /*     GOTO LOOP                                           */
 /* CMX013 END */
 
             GOTO       CMDLBL(END)                                                     /*BUG12677*/
 
/*/COPY WNCPYSRC,MXC0450MPE                                          */
 
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0450ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0450 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,MXC0450END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
