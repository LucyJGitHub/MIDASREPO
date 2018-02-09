/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Teller sign off with override')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                   */
/*                                                                   */
/*       REC4131 - Teller Sign Off With Override                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. TDA035             Date 27Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CRT001  *CREATE    Date 10Nov93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       TDA035 - RTS Signon changes for MidasPlus.                  */
/*       CRT001 - Retail Teller System                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**********  PGM */                                                                       /*TDA035*/
             PGM        PARM(&PRTCD &PWEBUSR)                                             /*TDA035*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL       VAR(&LDA)     TYPE(*CHAR)  LEN(256)
             DCL       VAR(&RTSDTA)  TYPE(*CHAR)  LEN(256) VALUE(' ')
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(50) VALUE(' ')
             DCL        VAR(&PRTCD)   TYPE(*CHAR) LEN(7)                                  /*TDA035*/
             DCL        VAR(&PWEBUSR) TYPE(*CHAR) LEN(1)                                  /*TDA035*/
             DCL        VAR(&MSG80)   TYPE(*CHAR) LEN(80)                                 /*TDA035*/
             DCL        VAR(&TLID)    TYPE(*CHAR) LEN(3)                                  /*TDA035*/
             DCL        VAR(&PTLID)    TYPE(*CHAR) LEN(3)                                 /*TDA035*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
                                                                                          /*TDA035*/
/**  Send info to message queue */                                                        /*TDA035*/
                                                                                          /*TDA035*/
             SNDPGMMSG  MSG('REC4131 - Prompt for Teller SignOFF') +
                          TOMSGQ(MRUNQ)                                                   /*TDA035*/
/**/
/* CHANGE JOB SWITCH SETTINGS */
/**/
             CHGJOB SWS(10000000)
/**/
/* INITIALIZE LDA */
/**/
             CHGDTAARA DTAARA(LDA) VALUE(' ')
/**/
/* CREATE AND INITIALIZE DATAAREA RTSDTA */
/**/
             CRTDTAARA DTAARA(QTEMP/RTSDTA) TYPE(*CHAR) LEN(256) +
             TEXT('RTS Teller Transaction Job Dataarea')
             MONMSG     MSGID(CPF1023)
             IF         COND(&PWEBUSR *EQ 'N') THEN(DO)                                   /*TDA035*/
             CHGDTAARA  (QTEMP/RTSDTA) ' '
             ENDDO                                                                        /*TDA035*/
/**/
/* TELLER - ID PROMPT */
/**/
/**********  CALL          PGM(RE4130)                                                    /*TDA035*/
             CALL       PGM(RE4130) PARM(&PWEBUSR &PTLID)                                 /*TDA035*/
                                                                                          /*TDA035*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNORMAL)
             RTVDTAARA  DTAARA(QTEMP/RTSDTA) RTNVAR(&RTSDTA)
/**********  IF        (%SST(&RTSDTA 1 3) *EQ '   ') +                */                  /*TDA035*/
/**********             THEN(GOTO CMDLBL(ENDPGM))                     */                  /*TDA035*/
             IF         COND(%SST(&RTSDTA 1 3) *EQ '   ') THEN( +
             GOTO       CMDLBL(ENDPGM))                                                   /*TDA035*/
/**/
/* TELLER SIGN-OFF */
/**/
/**********  CALL          PGM(RE4131)                                                    /*TDA035*/
                                                                                          /*TDA035*/
             IF         COND(&PWEBUSR *EQ 'N') THEN( +
                 CALL       PGM(RE4131) PARM(&PWEBUSR &PTLID))                            /*TDA035*/
                                                                                          /*TDA035*/
             IF         COND((&PWEBUSR *EQ 'Y') *AND (&PTLID *NE +
                          '   ')) THEN(DO)                                                /*TDA035*/
                 CALL       PGM(REC004134) PARM(&PRTCD 'OFF' &PTLID)                      /*TDA035*/
             ENDDO                                                                        /*TDA035*/
                                                                                          /*TDA035*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNORMAL)
/**********  ELSE       GOTO ENDPGM                                                       /*TDA035*/
             CHGVAR     VAR(&MSG80) VALUE('REC4131 - The +
                          Teller-ID' *BCAT &PTLID *BCAT 'has signed +
                          off.')                                                          /*TDA035*/
             SNDPGMMSG  MSG(&MSG80) TOMSGQ(MRUNQ)                                         /*TDA035*/
             GOTO ENDPGM                                                                  /*TDA035*/
/**/
/* ABNORMAL TERMINATION */
ABNORMAL:
/**/
/* IF U7 & U8 ON - DATABASE ERRORS */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                CHGVAR     VAR(&PRTCD) VALUE('*ABNOR')                                    /*TDA035*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR    VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                DMPCLPGM                                                                  /*TDA035*/
             ENDDO
/**/
/* FOR ANY ERROR */
ERROR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4131 ended abnormally - see job log') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
