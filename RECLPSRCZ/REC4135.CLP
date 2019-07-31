/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Enquiry program in PC Mode')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4135 - Controlling CL Component for Enquiry Program in   */
/*                 PC Mode                                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAP084             Date 08Jul03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CRT003             DATE 22JUL96              */
/*                      CRT002 *CREATE     DATE  1DEC95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP084 - Parameter added to ZMUSER for Java wrappers        */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CRT003 - Cashier Interface.                                 */
/*       CRT002 - Retail Branch Access.                              */
/*                                                                   */
/*********************************************************************/
/* */
             PGM        PARM(&PMODE)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)
/* */
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&REUSRMSG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MIDAS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZZMSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MIUSRMSG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/* */
                                                                      /*CRT003*/
             DCL        VAR(&ACTN)   TYPE(*CHAR) LEN(1)               /*CRT003*/
             DCL        VAR(&JOB)    TYPE(*CHAR) LEN(10)              /*CRT003*/
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)              /*CRT003*/
             DCL        VAR(&NBR)    TYPE(*CHAR) LEN(6)               /*CRT003*/
             DCL        VAR(&ZMUSER) TYPE(*CHAR) LEN(10)                                  /*CAP084*/
/* */                                                                 /*CRT003*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/* */
             CHGJOB     SWS(XXXXXX00)
/* */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
/* */
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)
/* */
/*   Create and set up user data area            */
/* */
             IF         COND(&MBIN *EQ 'Y') THEN(CALL PGM(SFC0400))
/* */
             CHKOBJ     OBJ(QTEMP/ZMUSER) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
/************CALL       PGM(ZMUSER) PARM(&ERRORC)                                         /*CAP084*/
             CALL       PGM(ZMUSER) PARM(&ERRORC &ZMUSER)                                 /*CAP084*/
             IF         COND(&ERRORC *NE 0) THEN(DO)
             SNDPGMMSG  MSG('Default Branch or Department not +
                          valid') TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
/* */
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO +
                          &ERRORC &MULT)
/* */
             IF         COND(&MULT *EQ '  ') THEN(DO)
             CHGVAR     VAR(&MULT) VALUE('GB')
             ENDDO
/* */
             CHGVAR   VAR(&REUSRMSG)  VALUE(&MULT *CAT 'REUSRMSG')
             CHGVAR   VAR(&MIDAS) VALUE(&MULT *CAT 'MIDAS')
             CHGVAR   VAR(&ZZMSGF) VALUE('ZZ' *CAT &MULT *CAT 'MSGF')
             CHGVAR   VAR(&MIUSRMSG) VALUE(&MULT *CAT 'MIUSRMSG')
/* */
             OVRMSGF    MSGF(REUSRMSG) TOMSGF(&REUSRMSG)
             OVRMSGF    MSGF(MIDAS)    TOMSGF(&MIDAS)
             OVRMSGF    MSGF(ZZMSGF)   TOMSGF(&ZZMSGF)
             OVRMSGF    MSGF(MIUSRMSG)   TOMSGF(&MIUSRMSG)
 
/**/
 
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
             CHGVAR   VAR(&ACTN) VALUE('I')                           /*CRT003*/
             RTVJOBA  JOB(&JOB) USER(&USR) NBR(&NBR)                  /*CRT003*/
             CALL     PGM(RE4436) PARM(&ACTN &JOB &USR &NBR)          /*CRT003*/
 
             OVRDBF     FILE(RECOMD) SHARE(*NO)
             CALL       PGM(RE3360) PARM(&PMODE)
/**/
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS)  +
                             MSGDTA(&MEM) TOMSGQ(MOPERQ)
                        ENDDO
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4135 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
               CHGVAR   VAR(&ACTN) VALUE('D')                         /*CRT003*/
               CALL     PGM(RE4436) PARM(&ACTN &JOB &USR &NBR)        /*CRT003*/
 
             ENDCMTCTL
 
             ENDPGM
