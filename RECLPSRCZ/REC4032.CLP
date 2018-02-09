/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Passbook print and update')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4032 - Savings A/C Passbook Print/Update                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG8085            Date 26Aug05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      148202             Date 19NOV98              */
/*                      118134             Date 02Jun97              */
/*                      CRT003             Date 22JUL96              */
/*                      CRT002             Date  1Dec95              */
/*                      096490             Date 28Nov95              */
/*                      CRT001  *CREATE    DATE 28FEB95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG8085 - Print to teller printer, change Standard Parameter*/
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       148202 - Reference to testing should not be present         */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Cashier Interface.                                 */
/*       CRT002 - Retail Branch Access.                              */
/*       096490 - Remove creation parameters which were adopting the */
/*                owners user profile.                               */
/*                Use the standard CLP creation parameters instead.  */
/*       CRT001  -  Retail Teller System                             */
/*                                                                   */
/*********************************************************************/
/*           PGM        PARM(&AUTH)                                */ /*CRT002*/
             PGM        PARM(&AUTH &PMODE)                            /*CRT002*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&AUTH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/*/COPY WNCPYSRC,REC4032003                                          */
/**/                                                                  /*CRT002*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*CRT002*/
             DCL        VAR(&ZZRTSF) TYPE(*CHAR) LEN(9)               /*CRT002*/
             DCL        VAR(&ZZMIDAS) TYPE(*CHAR) LEN(7)              /*CRT002*/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)               /*CRT002*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)                /*CRT002*/
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)                /*CRT002*/
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)                 /*CRT002*/
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)       /*CRT002*/
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)                /*CRT002*/
                                                                      /*CRT003*/
             DCL        VAR(&ACTN)   TYPE(*CHAR) LEN(1)               /*CRT003*/
             DCL        VAR(&JOB)    TYPE(*CHAR) LEN(10)              /*CRT003*/
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)              /*CRT003*/
             DCL        VAR(&NBR)    TYPE(*CHAR) LEN(6)               /*CRT003*/
             DCL        VAR(&OUTQ)   TYPE(*CHAR) LEN(10)                                 /*BUG8085*/
             DCL        VAR(&OUTQLIB) TYPE(*CHAR) LEN(10)                                /*BUG8085*/
/*/COPY WNCPYSRC,REC4032001                                          */
/**/
/*  Global monitor message  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* SEND PGM MESSAGE */
/**/
/************SNDPGMMSG  MSG('Testing passbook printing /update') + */ /*148202*/
/*************************TOMSGQ(MRUNQ) MSGTYPE(*INFO)             */ /*148202*/
             SNDPGMMSG  MSG('Passbook printing /update') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/* CLEAR SWITCHES */
/**/
             CHGJOB    SWS(00000000)
/*/COPY WNCPYSRC,REC4032002                                          */
                                                                      /*CRT002*/
             IF         COND(&PMODE = 'P') THEN(DO)                   /*CRT002*/
/**/                                                                  /*CRT002*/
                CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)            /*CRT002*/
                MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)            /*CRT002*/
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)     /*CRT002*/
                ENDDO                                                 /*CRT002*/
/**/                                                                  /*CRT002*/
                CALL     PGM(SF0410) PARM(&GROUP &USER &SLEVEL +
                          &TIMEO &ERRORC &MULT)                       /*CRT002*/
                IF         COND(&MULT *EQ '  ') THEN(DO)              /*CRT002*/
                  CHGVAR     VAR(&MULT) VALUE('GB')                   /*CRT002*/
                ENDDO                                                 /*CRT002*/
                CHGVAR   VAR(&ZZRTSF) VALUE(&MULT *CAT 'RTSMSGF')     /*CRT002*/
                OVRMSGF    MSGF(RTSMSGF) TOMSGF(&ZZRTSF)              /*CRT002*/
                CHGVAR   VAR(&ZZMIDAS) VALUE(&MULT *CAT 'MIDAS')      /*CRT002*/
                OVRMSGF    MSGF(MIDAS) TOMSGF(&ZZMIDAS)               /*CRT002*/
/**/                                                                  /*CRT002*/
/**********     STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))  /*CRT002 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
                                                                      /*CRT003*/
               CHGVAR   VAR(&ACTN) VALUE('I')                         /*CRT003*/
               RTVJOBA  JOB(&JOB) USER(&USR) NBR(&NBR)                /*CRT003*/
               CALL     PGM(RE4436) PARM(&ACTN &JOB &USR &NBR)        /*CRT003*/
                                                                      /*CRT003*/
             ENDDO                                                    /*CRT002*/
/**/
/* CALL THE PROGRAM */
/**/
             RTVJOBA    OUTQ(&OUTQ) OUTQLIB(&OUTQLIB)                                    /*BUG8085*/
             CHGJOB     OUTQ(*USRPRF)                                                    /*BUG8085*/
/**********  CALL       PGM(RE4032) PARM(&AUTH)                    */ /*CRT002*/
             CALL       PGM(RE4032) PARM(&AUTH &PMODE)                /*CRT002*/
             IF         COND(&OUTQLIB *NE '          ') THEN(CHGJOB +
                          OUTQ(&OUTQLIB/&OUTQ))                                          /*BUG8085*/
             IF         COND(&OUTQLIB *EQ '          ') THEN(CHGJOB +
                          OUTQ(&OUTQ))                                                   /*BUG8085*/
/**/                                                                  /*CRT002*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)                                 /*CRT003*/
             ENDDO
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4032 ended abnormally - see job log') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/                                                                  /*CRT002*/
             IF         COND(&PMODE = 'P') THEN(DO)                   /*CRT002*/
               CHGVAR   VAR(&ACTN) VALUE('D')                         /*CRT003*/
               CALL     PGM(RE4436) PARM(&ACTN &JOB &USR &NBR)        /*CRT003*/
               MONMSG   MSGID(CPF0000 MCH0000)                        /*118134*/
                ENDCMTCTL                                             /*CRT002*/
               MONMSG   MSGID(CPF0000 MCH0000)                        /*118134*/
             ENDDO                                                    /*CRT002*/
/**/                                                                  /*CRT002*/
             ENDPGM
