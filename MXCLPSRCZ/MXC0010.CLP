/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX COB Bulk Extract - 'Current' Cmps or Fmts')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0010 - COB Bulk Extract - 'Current' Composites or Formats*/
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSW034             Date 09JAN04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CMX011             Date 29Dev01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CMX001  *CREATE    Data 01Jan00              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSW034 - Midas Message Manager Global Processing            */
/*       CMX011 - Enable Meridian Export to use data queue as well   */
/*                as MQ queue.                                       */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMI &FMT)
 
/*/COPY WNCPYSRC,MXC0010INT                                          */
 
             DCL        VAR(&COMI)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FMT )   TYPE(*CHAR) LEN(10)
 
/* Mode = COB, Extract Type = CURRENT, Function = EXTRACT           */
 
             DCL        VAR(&MODE)  TYPE(*CHAR) LEN(1) VALUE('C')
             DCL        VAR(&EXTT)  TYPE(*CHAR) LEN(1) VALUE('C')
             DCL        VAR(&FUNC)  TYPE(*CHAR) LEN(1) VALUE('X')
 
             DCL        VAR(&DTAG)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&MEMBR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DRVACT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DRIVFL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODI  ) TYPE(*CHAR) LEN(3)
                                                                               /*CMX011*/
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(20)                         /*CMX011*/
             DCL        VAR(&KDTAQ) TYPE(*CHAR) LEN(1)                         /*CSW034*/
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,MXC0010MPS                                          */
 
 
/* Get Extract Parameters of Composite or Format */
 
/*********** CALL       PGM(MXGETEXTP) PARM(&RTCD &ERMS &COMI &EXTT +  */      /*CMX011*/
/***********              &FMT &DTAG &MEMBR &DRVACT &DRIVFL &MODI)     */      /*CMX011*/
/*********** CALL       PGM(MXGETEXTP) PARM(&RTCD &ERMS &COMI &EXTT +            CSW034*/
/***********              &FMT &DTAG &MEMBR &DRVACT &DRIVFL &MODI +              CSW034*/
/***********              &DTAQ)                                          CMX011 CSW034*/
             CALL       PGM(MXGETEXTP) PARM(&RTCD &ERMS &COMI &EXTT +
                          &FMT &DTAG &MEMBR &DRVACT &DRIVFL &MODI +
                          &DTAQ &KDTAQ)                                        /*CSW034*/
 
 
/* If there was an error getting the extract parameters then end */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)
 
 
 
/* Override to driver file */
 
             OVRDBF     FILE(FILE) TOFILE(&DRIVFL) SHARE(*NO) +
                          SEQONLY(*YES 200)
 
 
/* Clear Performance Data and override */
 
             CLRPFM     FILE(MXPLOGPD) MBR(&MEMBR)
             OVRDBF     FILE(MXPLOGPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES 500)
 
/* Clear MQ Series Data and override */
 
             CLRPFM     FILE(MXMQDLPD) MBR(&MEMBR)
             CLRPFM     FILE(MXMQDMPD) MBR(&MEMBR)
             CLRPFM     FILE(MXMQDSPD) MBR(&MEMBR)
             CLRPFM     FILE(MXMQDVPD) MBR(&MEMBR)
             CLRPFM     FILE(MXMQDXPD) MBR(&MEMBR)
 
 
             OVRDBF     FILE(MXMQDLPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES  10)
             OVRDBF     FILE(MXMQDMPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES  20)
             OVRDBF     FILE(MXMQDSPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES  40)
             OVRDBF     FILE(MXMQDVPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES  80)
             OVRDBF     FILE(MXMQDXPD) MBR(&MEMBR) SHARE(*NO) +
                          SEQONLY(*YES 400)
 
/* Call extract program  */
 
             CALL       PGM(MXBULKEXT) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT &FMT)
 
             DLTOVR *ALL
 
             RCLRSC
             RCLRSC     LVL(*CALLER)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
 
/* If the extract is enabled and there was no error in the extract */
 
             IF COND(%SWITCH(XXXXX000)) THEN(DO)
 
/* Override Performance Data */
 
             OVRDBF     FILE(MXPLOGL1) MBR(&MEMBR) SHARE(*NO)
 
/* Call statistics update program  */
 
             CALL       PGM(MXUPDSTAT) PARM(&RTCD &ERMS &MODE &COMI +
                          &EXTT &FMT &FUNC)
 
             ENDDO
 
/* Error */
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0010 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,MXC0010MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0010ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0010 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,MXC0010END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
