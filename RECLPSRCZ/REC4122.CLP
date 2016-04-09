/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE CI teller cross/treasury cash in/cash out')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4122 - RE CI Teller Cross/Treasury Cash In/Cash Out      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 237730             Date 12Jun06              */
/*       Prev Amend No. CAP084             Date 08Jul03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      208846             Date 29Aug02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CRT005  *CREATE    Date 09Aug01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       237730 - Print to corresponding teller printer.             */
/*       CAP084 - Parameter added to ZMUSER for Java wrappers        */
/*       208846 - Limit the submitted RE41220* jobs to a maximum     */
/*                of 5                                               */
/*       CRT005 - Cashier Enhancement for Cash In/Cash Out           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FNCD &PMODE)
 
/* Declare variables */
 
             DCL        VAR(&FNCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ZZRTSF) TYPE(*CHAR) LEN(9)
             DCL        VAR(&ZZMIDAS) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ZZY2USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&ACTN)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBSRUNJE) TYPE(*DEC) LEN(3 0)                               /*208846*/
             DCL        VAR(&JOBSRUNJF) TYPE(*DEC) LEN(3 0)                               /*208846*/
             DCL        VAR(&JOBSRUN0E) TYPE(*DEC) LEN(3 0)                               /*208846*/
             DCL        VAR(&JOBSRUN0F) TYPE(*DEC) LEN(3 0)                               /*208846*/
             DCL        VAR(&ZMUSER) TYPE(*CHAR) LEN(10)                                  /*CAP084*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Copyright Misys International Banking Syst+
                          ems Ltd. 2001')
             DCL        VAR(&OUTQ)   TYPE(*CHAR) LEN(10)                                  /*237730*/
             DCL        VAR(&OUTQLIB) TYPE(*CHAR) LEN(10)                                 /*237730*/
/*/COPY WNCPYSRC,REH00293                                            */
 
/*  Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*/COPY WNCPYSRC,REH00294                                            */
 
             CHGJOB     SWS(XXXXXX00)
 
             IF         COND(&PMODE = 'P') THEN(DO)
 
                CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
                MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                ENDDO
 
                CHKOBJ     OBJ(QTEMP/ZMUSER) OBJTYPE(*DTAARA)
                MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
/************   CALL       PGM(ZMUSER) PARM(&ERRORC)                                      /*CAP084*/
                CALL       PGM(ZMUSER) PARM(&ERRORC &ZMUSER)                              /*CAP084*/
                IF         COND(&ERRORC *NE 0) THEN(DO)
                  SNDPGMMSG  MSG('Default Branch or Department not +
                          valid') TOPGMQ(*EXT) MSGTYPE(*INFO)
                  GOTO       CMDLBL(ABNOR)
                ENDDO
                ENDDO
 
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
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
 
               CHGVAR   VAR(&ACTN) VALUE('I')
               RTVJOBA  JOB(&JOB) USER(&USR) NBR(&NBR)
               CALL     PGM(RE4436) PARM(&ACTN &JOB &USR &NBR)
 
             ENDDO
 
/* Call Teller Cross/Treasury transaction program */
/*/COPY WNCPYSRC,REH00295                                            */
 
             RTVJOBA    OUTQ(&OUTQ) OUTQLIB(&OUTQLIB)                                     /*237730*/
             CHGJOB     OUTQ(*USRPRF)                                                     /*237730*/
             CALL       PGM(RE4122) PARM(&FNCD &PMODE)
             IF         COND(&OUTQLIB *NE '          ') THEN(CHGJOB +
                          OUTQ(&OUTQLIB/&OUTQ))                                           /*237730*/
             IF         COND(&OUTQLIB *EQ '          ') THEN(CHGJOB +
                          OUTQ(&OUTQ))                                                    /*237730*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*/COPY WNCPYSRC,REH00296                                            */
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
/*/COPY WNCPYSRC,REH00297                                            */
             ENDDO
 
             RTVJOBA    JOB(&JOB)                                                         /*208846*/
                                                                                          /*208846*/
             IF         COND(&JOB *EQ 'RE41220JE') THEN(DO)                               /*208846*/
                RTVDTAARA  DTAARA(RE41220JE) RTNVAR(&JOBSRUNJE)                           /*208846*/
                CHGVAR     VAR(&JOBSRUNJE) VALUE(&JOBSRUNJE - 1)                          /*208846*/
                IF         COND(&JOBSRUNJE *GE 0) THEN(CHGDTAARA +
                             DTAARA(RE41220JE) VALUE(&JOBSRUNJE))                         /*208846*/
             ENDDO                                                                        /*208846*/
                                                                                          /*208846*/
             IF         COND(&JOB *EQ 'RE41220JF') THEN(DO)                               /*208846*/
                RTVDTAARA  DTAARA(RE41220JF) RTNVAR(&JOBSRUNJF)                           /*208846*/
                CHGVAR     VAR(&JOBSRUNJF) VALUE(&JOBSRUNJF - 1)                          /*208846*/
                IF         COND(&JOBSRUNJF *GE 0) THEN(CHGDTAARA +
                             DTAARA(RE41220JF) VALUE(&JOBSRUNJF))                         /*208846*/
             ENDDO                                                                        /*208846*/
                                                                                          /*208846*/
             IF         COND(&JOB *EQ 'RE412200E') THEN(DO)                               /*208846*/
                RTVDTAARA  DTAARA(RE412200E) RTNVAR(&JOBSRUN0E)                           /*208846*/
                CHGVAR     VAR(&JOBSRUN0E) VALUE(&JOBSRUN0E - 1)                          /*208846*/
                IF         COND(&JOBSRUN0E *GE 0) THEN(CHGDTAARA +
                             DTAARA(RE412200E) VALUE(&JOBSRUN0E))                         /*208846*/
             ENDDO                                                                        /*208846*/
                                                                                          /*208846*/
             IF         COND(&JOB *EQ 'RE412200F') THEN(DO)                               /*208846*/
                RTVDTAARA  DTAARA(RE412200F) RTNVAR(&JOBSRUN0F)                           /*208846*/
                CHGVAR     VAR(&JOBSRUN0F) VALUE(&JOBSRUN0F - 1)                          /*208846*/
                IF         COND(&JOBSRUN0F *GE 0) THEN(CHGDTAARA +
                             DTAARA(RE412200F) VALUE(&JOBSRUN0F))                         /*208846*/
             ENDDO                                                                        /*208846*/
                                                                                          /*208846*/
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4122 ended abnormally - see job log') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('Copyright Misys Interna+
                          tional Banking Systems Ltd.')
 
             IF         COND(&PMODE = 'P') THEN(DO)
               CHGVAR   VAR(&ACTN) VALUE('D')
               CALL     PGM(RE4436) PARM(&ACTN &JOB &USR &NBR)
               MONMSG   MSGID(CPF0000 MCH0000)
                ENDCMTCTL
               MONMSG   MSGID(CPF0000 MCH0000)
             ENDDO
 
             ENDPGM
