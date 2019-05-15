/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER - Commissariat Aux Bourses Component')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting (Luxembourg)                     */
/*                                                                   */
/*       ERCLUCB - Commissariat Aux Bourses                          */
/*                 COB Every day                                     */
/*                 I/C on demand                                     */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX008             Date 21Jul00              */
/*                      ULX008             Date 22Mar00              */
/*                      ULX008             Date 23Feb00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX008 - "Commissariat aux Bourses" : Change Control C      */
/*       ULX008 - "Commissariat aux Bourses" : Change Control A      */
/*       ULX008 - CSSF Statutory Reporting : Commissariat aux Bourses*/
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FEAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FRMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDATE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DATE6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000) EXEC(CHGDTAARA DTAARA(LDA) +
                          VALUE(' '))
             CHGJOB     SWS(XXXXXX00)
 
             CHGVAR     VAR(&OPTN) VALUE(*VERIFY)
             CHGVAR     VAR(&FEAT) VALUE(ULX008)
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &FEAT)
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(END))
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&FRMLIB) VALUE(&PREFIX *CAT 'DPLIB')
 
/***  Use a temporay files in QTEMP.  ***/
 
             DLTF       FILE(QTEMP/ERFT14PP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ERFT14PP) FROMLIB(&FRMLIB) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*NO)
             OVRDBF     FILE(ERFT14PP) TOFILE(QTEMP/ERFT14PP)
 
             RTVDTAARA  DTAARA(ERSTAT (31 10)) RTNVAR(&STATUS)
 
             DLTF       FILE(QTEMP/ERLUCBPP)
             MONMSG     MSGID(CPF0000)
 
/*           IF         COND(&STATUS *NE 'RESTART') THEN(DO)    */        /*ULX008*/
             IF         COND(&STATUS *NE 'ABNORMAL') THEN(DO)             /*ULX008*/
             CRTDUPOBJ  OBJ(ERLUCBPP) FROMLIB(&FRMLIB) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*NO)
             ENDDO
 
/*           IF         COND(&STATUS *EQ 'RESTART') THEN(DO)    */        /*ULX008*/
             IF         COND(&STATUS *EQ 'ABNORMAL') THEN(DO)             /*ULX008*/
             CRTDUPOBJ  OBJ(ERLUCBPP) FROMLIB(&FRMLIB) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*YES)
             ENDDO
 
             OVRDBF     FILE(ERLUCBPP) TOFILE(QTEMP/ERLUCBPP)
 
/***  Do SE Extraction. ***/
 
             CHGVAR     VAR(&PDATE) VALUE(%SST(&RPARM 1 5))
             CALL       PGM(ERLUSE) PARM(&PDATE)
 
             DLTOVR     FILE(ERLUCBPP)
             CPYF       FROMFILE(QTEMP/ERLUCBPP) +
                          TOFILE(&FRMLIB/ERLUCBPP) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&FRMLIB/ERLUCBPP))
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/*           CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('RESTART') */        /*ULX008*/
             CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('ABNORMAL')          /*ULX008*/
                GOTO       CMDLBL(END)
             ENDDO
 
/***  Do Depot Movement Extract ***/
 
             CLRPFM     FILE(QTEMP/ERLUCBPP)
             OVRDBF     FILE(ERLUCBPP) TOFILE(QTEMP/ERLUCBPP)
             CALL       PGM(ERLUDM) PARM(&PDATE)
 
             DLTOVR     FILE(ERLUCBPP)
             CPYF       FROMFILE(QTEMP/ERLUCBPP) +
                          TOFILE(&FRMLIB/ERLUCBPP) MBROPT(*ADD)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/*           CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('RESTART')  */       /*ULX008*/
             CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('ABNORMAL')          /*ULX008*/
                GOTO       CMDLBL(END)
             ENDDO
 
/***  Do FF Extraction. ***/
 
             CLRPFM     FILE(QTEMP/ERLUCBPP)
             OVRDBF     FILE(ERLUCBPP) TOFILE(QTEMP/ERLUCBPP)
             CALL       PGM(ERCLUFF) PARM(&PDATE)
 
             DLTOVR     FILE(ERLUCBPP)
             CPYF       FROMFILE(QTEMP/ERLUCBPP) +
                          TOFILE(&FRMLIB/ERLUCBPP) MBROPT(*ADD)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/*           CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('RESTART')  */       /*ULX008*/
             CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('ABNORMAL')          /*ULX008*/
                GOTO       CMDLBL(END)
             ENDDO
 
/***  Do Print of Extracted details ***/
 
             OVRDBF     FILE(ERLUCBPP) TOFILE(QTEMP/ERLUCBPP)
             CALL       PGM(ERLU57) PARM(&RSEQ &PDATE)
             DLTOVR     FILE(ERLUCBPP)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/*           CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('RESTART')  */       /*ULX008*/
             CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('ABNORMAL')          /*ULX008*/
                GOTO       CMDLBL(END)
             ENDDO
 
/***  Do Formattage into ERFT14PP ***/
 
             CHGVAR     VAR(&DATE6) VALUE('UNKNOW')
 
             CALL       PGM(ERLUFT14) PARM(&PDATE &DATE6)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/*           CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('RESTART')  */       /*ULX008*/
             CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('ABNORMAL')          /*ULX008*/
                GOTO       CMDLBL(END)
             ENDDO
 
/*** Copy formatted file to DPLIB ***/
 
             DLTOVR     FILE(ERFT14PP)
             CPYF       FROMFILE(QTEMP/ERFT14PP) +
                          TOFILE(&FRMLIB/ERFT14PP) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/*** Copy file in specified Folder. ***/
 
             CALL       PGM(ERLUTOPC) PARM(&PREFIX &DATE6 'RT14')
 
/***  Component Correctly terminated.  ***/
 
             CHGDTAARA  DTAARA(ERSTAT (31 10)) VALUE('          ')
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          ERCLUCB  ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             ENDPGM
