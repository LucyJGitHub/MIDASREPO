/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Cash withdrawal account currency')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4116 - Cash Withdrawal                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG8085            Date 26Aug05              */
/*       Prev Amend No. CAP084             Date 08Jul03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      118134             Date 02Jun97              */
/*                      CRT003             Date 22JUL96              */
/*                      CRT002             Date  1Dec95              */
/*                      CRT001  *CREATE    Date 28Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG8085 - Print to teller printer, change Standard Parameter*/
/*       CAP084 - Parameter added to ZMUSER for Java wrappers        */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Cashier Interface.                                 */
/*       CRT002 - Retail Branch Access.                              */
/*       CRT001 - Retail Teller System.                              */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&FNCD)                                */ /*CRT002*/
             PGM        PARM(&FNCD &PMODE)                            /*CRT002*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&FNCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
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
 
             DCL        VAR(&ACTN)   TYPE(*CHAR) LEN(1)               /*CRT003*/
             DCL        VAR(&JOB)    TYPE(*CHAR) LEN(10)              /*CRT003*/
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)              /*CRT003*/
             DCL        VAR(&NBR)    TYPE(*CHAR) LEN(6)               /*CRT003*/
             DCL        VAR(&ZMUSER) TYPE(*CHAR) LEN(10)                                  /*CAP084*/
             DCL        VAR(&OUTQ)   TYPE(*CHAR) LEN(10)                                 /*BUG8085*/
             DCL        VAR(&OUTQLIB) TYPE(*CHAR) LEN(10)                                /*BUG8085*/
/*/COPY WNCPYSRC,REH00235                                            */
                                                                      /*CRT003*/
/**/
/*    Global monitor message                                         */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,REH00236                                            */
             OVRDBF     FILE(TTCHGPD) SEQONLY(*NO)
                                                                      /*CRT002*/
             IF         COND(&PMODE = 'P') THEN(DO)                   /*CRT002*/
/**/                                                                  /*CRT002*/
                CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)            /*CRT002*/
                MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)            /*CRT002*/
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)     /*CRT002*/
                ENDDO                                                 /*CRT002*/
/**/                                                                  /*CRT002*/
                CHKOBJ     OBJ(QTEMP/ZMUSER) OBJTYPE(*DTAARA)         /*CRT002*/
                MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)            /*CRT002*/
/************   CALL       PGM(ZMUSER) PARM(&ERRORC)                  /*CRT002*/          /*CAP084*/
                CALL       PGM(ZMUSER) PARM(&ERRORC &ZMUSER)                              /*CAP084*/
                IF         COND(&ERRORC *NE 0) THEN(DO)               /*CRT002*/
                  SNDPGMMSG  MSG('Default Branch or Department not +
                          valid') TOPGMQ(*EXT) MSGTYPE(*INFO)         /*CRT002*/
                  GOTO       CMDLBL(ABNOR)                            /*CRT002*/
                ENDDO                                                 /*CRT002*/
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
               CHGVAR   VAR(&ACTN) VALUE('I')                         /*CRT003*/
               RTVJOBA  JOB(&JOB) USER(&USR) NBR(&NBR)                /*CRT003*/
                                                                      /*CRT003*/
               CALL     PGM(RE4436) PARM(&ACTN &JOB &USR &NBR)        /*CRT003*/
                                                                      /*CRT003*/
             ENDDO                                                    /*CRT002*/
 
/*/COPY WNCPYSRC,REH00237                                            */
/**********  CALL       PGM(RE4116) PARM(&FNCD)                    */ /*CRT002*/
             RTVJOBA    OUTQ(&OUTQ) OUTQLIB(&OUTQLIB)                                    /*BUG8085*/
             CHGJOB     OUTQ(*USRPRF)                                                    /*BUG8085*/
             CALL       PGM(RE4116) PARM(&FNCD &PMODE)                /*CRT002*/
             IF         COND(&OUTQLIB *NE '          ') THEN(CHGJOB +
                          OUTQ(&OUTQLIB/&OUTQ))                                          /*BUG8085*/
             IF         COND(&OUTQLIB *EQ '          ') THEN(CHGJOB +
                          OUTQ(&OUTQ))                                                   /*BUG8085*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*/COPY WNCPYSRC,REH00238                                            */
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)                                 /*CRT003*/
/*/COPY WNCPYSRC,REH00239                                            */
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4116 ended abnormally - see job log') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/                                                                  /*CRT002*/
             IF         COND(&PMODE = 'P') THEN(DO)                   /*CRT002*/
               CHGVAR   VAR(&ACTN) VALUE('D')                         /*CRT003*/
               CALL     PGM(RE4436) PARM(&ACTN &JOB &USR &NBR)        /*CRT003*/
               MONMSG   MSGID(CPF0000 MCH0000)                        /*118134*/
                ENDCMTCTL                                             /*CRT002*/
               MONMSG   MSGID(CPF0000 MCH0000)                        /*118134*/
             ENDDO                                                    /*CRT002*/
/**/
             ENDPGM
