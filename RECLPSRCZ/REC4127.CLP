/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Savings A/C Passbook Updt Reversal')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4127 - Savings A/C Passbook Update Reversal              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK009             Date 09Aug99              */
/*       Prev Amend No. CRT003  *CREATE    DATE 22Jul96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CRT003 - Cashier Interface.                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&AUTH)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&AUTH)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&MULT)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&ZZRTSF)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&ZZMIDAS) TYPE(*CHAR) LEN(7)
             DCL        VAR(&GROUP)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL)  TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO)   TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC)  TYPE(*DEC) LEN(1) VALUE(0)
 
             DCL        VAR(&ACTN)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)    TYPE(*CHAR) LEN(6)
 
/**/
/*  Global monitor message  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('Passbook printing/update Reversal') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
 
               CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL +
                            &TIMEO &ERRORC &MULT)
               IF         COND(&MULT *EQ '  ') THEN(DO)
                 CHGVAR     VAR(&MULT) VALUE('GB')
               ENDDO
               CHGVAR     VAR(&ZZRTSF)  VALUE(&MULT *CAT 'RTSMSGF')
               OVRMSGF    MSGF(RTSMSGF) TOMSGF(&ZZRTSF)
               CHGVAR     VAR(&ZZMIDAS) VALUE(&MULT *CAT 'MIDAS')
               OVRMSGF    MSGF(MIDAS)   TOMSGF(&ZZMIDAS)
 
/**********    STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))          /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
               CHGVAR   VAR(&ACTN) VALUE('I')
               RTVJOBA  JOB(&JOB) USER(&USR) NBR(&NBR)
               CALL     PGM(RE4436) PARM(&ACTN &JOB &USR &NBR)
 
             ENDDO
/**/
/* CALL THE PROGRAM */
/**/
             CALL       PGM(RE4127) PARM(&AUTH)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4127 ended abnormally - see job log') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CHGVAR   VAR(&ACTN) VALUE('D')
             CALL     PGM(RE4436) PARM(&ACTN &JOB &USR &NBR)
             ENDCMTCTL
             ENDPGM
