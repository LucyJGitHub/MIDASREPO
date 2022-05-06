/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Standard interest statement print')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     Retail Module                                 */
/*                                                                   */
/*       REC3761 - INTEREST STATEMENT PRINT - STANDARD               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD057766           Date 17Mar21              */
/*       Prev Amend No. EMP108             Date 09Feb21              */
/*                      MD046248           DATE 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD057766 - REC376A on MSGW when EMP108 is OFF               */
/*       EMP108 - Retail Interest Capitalisation Statement via CM    */
/*       MD046248 - Finastra Rebranding                              */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2001')
/**/
             DCL        VAR(&ACTION)     TYPE(*CHAR) LEN(8)                    /*EMP108*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                         /*EMP108*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')         /*EMP108*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)                          /*EMP108*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                         /*EMP108*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')               /*EMP108*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')            /*EMP108*/
             DCL        VAR(&BOTH) TYPE(*CHAR) LEN(1)                          /*EMP108*/
             DCL        VAR(&EMP108) TYPE(*CHAR) LEN(1) VALUE('N')             /*EMP108*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                          /*EMP108*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                      /*EMP108*/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
/**/
/* declare &BJLANG as a program field as this hasn't been incorp to */
/*    SDBANKPD yet */
             DCL        VAR(&BJLANG) TYPE(*CHAR) LEN(2) VALUE('GB')
             DCLF       FILE(SDBANKPD)
/**/
             SNDPGMMSG  MSG('REC3761 - Standard Retail interests +
                          statements  ') TOMSGQ(MRUNQ)
/**/
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
              SNDPGMMSG  MSG('Record not found in file : SDBANKPD by +
                          PGM : REC3761') TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&BJLANG) VALUE('GB')
             ENDDO
    CHGVAR         VAR(&MSGF) VALUE(&BJLANG *TCAT 'REPTMSGF')
/**/
             OVRMSGF    MSGF(QUSERMSG) TOMSGF(&MSGF)
/**/
/**   CHECK FOR SWITCHABLE FEATURE EMP108     */                               /*EMP108*/
                                                                               /*EMP108*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                            /*EMP108*/
             CHGVAR     VAR(&SARD) VALUE('EMP108')                             /*EMP108*/
                                                                               /*EMP108*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)          /*EMP108*/
                                                                               /*EMP108*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                     /*EMP108*/
             CHGVAR     VAR(&EMP108) VALUE('Y')                                /*EMP108*/
             ENDDO                                                             /*EMP108*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                            /*EMP108*/
/**/
/*---------------------------------------------------------------*/            /*EMP108*/
/* Access PF/SDMMODPD to determine whether UDC module is on      */            /*EMP108*/
/*---------------------------------------------------------------*/            /*EMP108*/
       IF         COND(&EMP108 *EQ 'Y') THEN(DO)                               /*EMP108*/
       RTVDTAARA  DTAARA(CGREC371) RTNVAR(&BOTH)                               /*EMP007*/
                                                                               /*EMP108*/
       CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)                         /*EMP108*/
         /* */                                                                 /*EMP108*/
         /** Database Error Handling                                           /*EMP108*/
         /* */                                                                 /*EMP108*/
                      IF         COND(&RTCD *NE '       ') THEN(DO)            /*EMP108*/
                      CHGVAR     VAR(&MSG) VALUE('ERROR ON ACCESS TO ICD FILE +
                                   SDMMODPD')                                  /*EMP108*/
                      GOTO       CMDLBL(ERROR)                                 /*EMP108*/
                      ENDDO                                                    /*EMP108*/
                      ENDDO                                                    /*EMP108*/
             OVRDBF     FILE(ACCRACJ) TOFILE(EACCRACJ)
             OVRDBF     FILE(ACCNT) TOFILE(EACCNT)
/*/COPY WNCPYSRC,REC3761001                                          */
             CALL       PGM(RE3761) PARM(&BJLANG)
/*/COPY WNCPYSRC,REC3761002                                          */
             DLTOVR     FILE(*ALL)
/*---------------------------------------------------------------*/            /*EMP108*/
/* If UDC is on & extract is requested...                        */            /*EMP108*/
/*---------------------------------------------------------------*/            /*EMP108*/
       IF         COND(&EMP108 *EQ 'Y') THEN(DO)                               /*EMP108*/
                                                                               /*EMP108*/
    IF   COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                               /*EMP108*/
/* */
     IF     COND(&BOTH = 'Y' *OR &BOTH = 'N') THEN(DO)                         /*EMP108*/
               STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                            CMTSCOPE(*JOB)                                     /*EMP108*/
               MONMSG     MSGID(CPF8351)                                       /*EMP108*/
/*       Commitment control already active                       */            /*EMP108*/
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)                 /*EMP108*/
             MONMSG     MSGID(CPF1023) /*already exists*/                      /*EMP108*/
/*--------------------------------------------------------------*/
/* If Correspondence manager is switched on, override files ... */             /*EMP108*/
/* ... including *MSGF |                                        */             /*EMP108*/
/*--------------------------------------------------------------*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(GBCGUSRMSG)
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                         /*EMP108*/
             CALL       PGM(CGC3605) PARM(&ACTION)                             /*EMP108*/
/* */                                                                          /*EMP108*/
/* ... and call driver / extract programs                */                    /*EMP108*/
    CHGVAR         VAR(&MSGF) VALUE(&BJLANG *TCAT 'REPTMSGF')                  /*EMP108*/
    OVRMSGF    MSGF(QUSERMSG) TOMSGF(&MSGF)                                    /*EMP108*/
             CALL       PGM(CG4861) PARM(&W0RTN &W0CMT &BJLANG)                /*EMP108*/
                                                                               /*EMP108*/
             RCLRSC                                                            /*EMP108*/
               IF         COND(&W0RTN *NE '       ') THEN(DO)                  /*EMP108*/
               CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence +
                            Extract failure')                                  /*EMP108*/
               ROLLBACK                                                        /*EMP108*/
               GOTO       CMDLBL(ERROR)                                        /*EMP108*/
               ENDDO                                                           /*EMP108*/
/* */                                                                          /*EMP108*/
/*  call custom defined extract program                                        /*EMP108*/
/* extract program                                                             /*EMP108*/
/* */                                                                          /*EMP108*/
             CALL       PGM(CGC3604)                                           /*EMP108*/
/* */                                                                          /*EMP108*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                       /*EMP108*/
             CHGVAR     VAR(&MSG) VALUE('Correspondence Manager +
                        Custom-Defined Data Extract failed')                   /*EMP108*/
             GOTO       CMDLBL(ERROR)                                          /*EMP108*/
             ENDDO                                                             /*EMP108*/
/**/                                                                           /*EMP108*/
             ENDDO                                                             /*EMP108*/
             ENDDO                                                             /*EMP108*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
    GOTO       CMDLBL(ENDCL)                                                  /*EMP108*/
       ENDDO       /*EMP108*/
    GOTO       CMDLBL(ENDCL)                                                  /*MD057766*/
/*---------------------------------------------------------------*/           /*EMP108*/
/* Abnormal termination                                          */           /*EMP108*/
/*---------------------------------------------------------------*/           /*EMP108*/
ERROR:                                                                        /*EMP108*/
             CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                        /*EMP108*/
             CALL       PGM(CGC3605) PARM(&ACTION)                            /*EMP108*/
             ROLLBACK                                                         /*EMP108*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                        /*EMP108*/
             CHGJOB     SWS(XXXXXX11)                                         /*EMP108*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                        /*EMP108*/
             DMPCLPGM                                                         /*EMP108*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                        /*EMP108*/
/**/                                                                          /*EMP108*/
             SNDPGMMSG  MSG('Program REC3761 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                        /*EMP108*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC3764 ended abnormally') MSGTYPE(*ESCAPE)         /*EMP108*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                        /*EMP108*/

/*---------------------------------------------------------------*/           /*EMP108*/
ENDCL:       ENDPGM
