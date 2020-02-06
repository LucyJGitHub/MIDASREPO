/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE General ledger transfer - cash in/out')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4111 - GL Account Transfer - Cash In/Out                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      118134             Date 02Jun97              */
/*                      CRT003             Date 22Jul96              */
/*                      CRT002  *CREATE    DATE  1Dec95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Cashier Interface.                                 */
/*       CRT002 - Retail Branch Access.                              */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&FNCD &PMODE)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&FNCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ZZRTSF) TYPE(*CHAR) LEN(9)
             DCL        VAR(&ZZMIDAS) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ZZY2USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
                                                                      /*CRT003*/
             DCL        VAR(&ACTN)   TYPE(*CHAR) LEN(1)               /*CRT003*/
             DCL        VAR(&JOB)    TYPE(*CHAR) LEN(10)              /*CRT003*/
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)              /*CRT003*/
             DCL        VAR(&NBR)    TYPE(*CHAR) LEN(6)               /*CRT003*/
/**/
/*  Global monitor message  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
/**/
             IF         COND(&PMODE = 'P') THEN(DO)
/**/
                CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
                MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                ENDDO
/**/
                CALL     PGM(SF0410) PARM(&GROUP &USER &SLEVEL +
                          &TIMEO &ERRORC &MULT)
                IF         COND(&MULT *EQ '  ') THEN(DO)
                  CHGVAR     VAR(&MULT) VALUE('GB')
                ENDDO
                CHGVAR   VAR(&ZZRTSF) VALUE(&MULT *CAT 'RTSMSGF')
                OVRMSGF    MSGF(RTSMSGF) TOMSGF(&ZZRTSF)
                CHGVAR   VAR(&ZZMIDAS) VALUE(&MULT *CAT 'MIDAS')
                OVRMSGF    MSGF(MIDAS) TOMSGF(&ZZMIDAS)
                CHGVAR   VAR(&ZZY2USR) VALUE(&MULT *CAT 'Y2USRMSG')
                OVRMSGF    MSGF(Y2USRMSG) TOMSGF(&ZZY2USR)
/**/
/**********     STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))         /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
                                                                      /*CRT003*/
               CHGVAR   VAR(&ACTN) VALUE('I')                         /*CRT003*/
               RTVJOBA  JOB(&JOB) USER(&USR) NBR(&NBR)                /*CRT003*/
               CALL     PGM(RE4436) PARM(&ACTN &JOB &USR &NBR)        /*CRT003*/
                                                                      /*CRT003*/
             ENDDO
/**/
             CALL       PGM(RE4111) PARM(&FNCD &PMODE)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)                                 /*CRT003*/
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4111 ended abnormally - see job log') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             IF         COND(&PMODE = 'P') THEN(DO)
               CHGVAR   VAR(&ACTN) VALUE('D')                         /*CRT003*/
               CALL     PGM(RE4436) PARM(&ACTN &JOB &USR &NBR)        /*CRT003*/
               MONMSG   MSGID(CPF0000 MCH0000)                        /*118134*/
                ENDCMTCTL
               MONMSG   MSGID(CPF0000 MCH0000)                        /*118134*/
             ENDDO
/**/
             ENDPGM
