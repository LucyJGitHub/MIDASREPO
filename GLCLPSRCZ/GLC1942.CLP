/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Cust. Serv. Fees - DL Holdings Extract')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC1942 - Customer Service Fees - Dealing Holdings Extract  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CSD008  *CREATE    Date 05Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD008 - Customer Service Fees Enhancement                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&CNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)   TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PRE)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SCFEE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MGFEE)  TYPE(*CHAR) LEN(1)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Check whether SC or MG fees have to be accrued */
 
             RTVDTAARA  DTAARA(GLCSFSTAT (1 1)) RTNVAR(&SCFEE)
             RTVDTAARA  DTAARA(GLCSFSTAT (3 1)) RTNVAR(&MGFEE)
 
             IF         COND((&SCFEE *NE 'Y') *AND (&MGFEE *NE 'Y')) +
                          THEN(GOTO CMDLBL(END))
 
/* Send start component message */
 
             SNDPGMMSG  MSG('GLC1942 - Customer Service Fees/DL +
                          Holdings Extract.') TOMSGQ(MRUNQ +
                          MOPERQ) MSGTYPE(*INFO)
 
/* Create QTEMP/LDA */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' '))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/* Retrieve SDSTAT details */
 
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 
/* Check component status */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)
 
/* If restart of component, then set Status Component to "N" */
 
             IF         COND(&STATUS = 'Y') THEN(DO)
 
                  CHGVAR     VAR(&STATUS) VALUE('N')
                  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
             ENDDO
 
 
/* Change Component Status to "started" */
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* If the Working File not in QTEMP, must be create */
/* Before Running Extact Holdings file */
 
             CHKOBJ OBJ(QTEMP/XGLHOLDPD) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(DO)
                CPYF FROMFILE(GLHOLDPD) TOFILE(QTEMP/XGLHOLDPD) +
                     MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
/* Call program */
 
             CLRPFM  FILE(QTEMP/XGLHOLDPD)
             OVRDBF FILE(GLHOLDPD) TOFILE(QTEMP/XGLHOLDPD)
             CALL  PGM(GL1942)
 
/* If No database error, Component is terminated */
 
             IF  COND(%SWITCH(XXXXXX00)) THEN(DO)
 
                DLTOVR     FILE(GLHOLDPD)
                CPYF       FROMFILE(QTEMP/XGLHOLDPD) TOFILE(GLHOLDPD) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
                CHGVAR     VAR(&STATUS) VALUE('N')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Send normal end component message */
 
                SNDPGMMSG  MSG('GLC1942 - Customer Service Fees/DL +
                           Holdings Extract successfully +
                          terminated') TOMSGQ(MRUNQ MOPERQ) +
                          MSGTYPE(*INFO)
 
/* delete files image */
 
             DLTF       FILE(QTEMP/XGLHOLDPD)
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(END)
 
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC1942 ended abnormally - see job log - +
                          PGM ERROR') TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
