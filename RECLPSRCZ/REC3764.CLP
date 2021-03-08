/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE FRENCH TICKET D AGIOS')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     Retail Module                                 */
/*                                                                   */
/*       REC3764 - INTEREST STMT PRINT - TICKET D'AGIO               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. EMP107             DATE 09Feb21              */
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
/*       EMP107 - French Ticket d'Agios Advices via CM               */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&ACTION)     TYPE(*CHAR) LEN(8)           /*EMP107*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*EMP107*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ') /*EMP107*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)                 /*EMP107*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*EMP107*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*EMP107*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*EMP107*/
             DCL        VAR(&BOTH) TYPE(*CHAR) LEN(1)                 /*EMP107*/
             DCL        VAR(&EMP107) TYPE(*CHAR) LEN(1) VALUE('N')    /*EMP107*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*EMP107*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*EMP107*/
             DCLF       FILE(TABTBRE)
             RCVF       RCDFMT(TABTBREF)
/**/
/**   CHECK FOR SWITCHABLE FEATURE EMP107     */                      /*EMP107*/
                                                                      /*EMP107*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*EMP107*/
             CHGVAR     VAR(&SARD) VALUE('EMP107')                    /*EMP107*/
                                                                      /*EMP107*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD) /*EMP107*/
                                                                      /*EMP107*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*EMP107*/
             CHGVAR     VAR(&EMP107) VALUE('Y')                       /*EMP107*/
             ENDDO                                                    /*EMP107*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*EMP107*/
/**/
             IF         COND(&TAIA *EQ 'Y') THEN(DO)
/**/
             SNDPGMMSG  MSG('REC3764 - Tickect d''agio') TOMSGQ(MRUNQ)
/**/
/*/COPY WNCPYSRC,REC3764001                                          */
/* */                                                                 /*EMP107*/
       IF         COND(&EMP107 *EQ 'Y') THEN(DO)                      /*EMP107*/
/* */                                                                 /*EMP107*/
             RTVDTAARA  DTAARA(CGREC376) RTNVAR(&BOTH)                /*EMP107*/
             IF         COND(&BOTH = 'Y' *OR &BOTH = ' ') THEN(DO)    /*EMP107*/
             CALL       PGM(RE3764)
             ENDDO                                                    /*EMP107*/
/* */                                                                 /*EMP107*/
/** Access PF/SDMMODPD to determine whether UDC module is on          /*EMP107*/
/* */                                                                 /*EMP107*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*EMP107*/
/**/
/* */                                                                 /*EMP107*/
/** Database error handling                                           /*EMP107*/
/* */                                                                 /*EMP107*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*EMP107*/
             CHGVAR     VAR(&MSG) VALUE('Error on access to ICD file +
                          SDMMODPD')                                  /*EMP107*/
             GOTO       CMDLBL(ERROR)                                 /*EMP107*/
             ENDDO                                                    /*EMP107*/
                                                                      /*EMP107*/
/* */                                                                 /*EMP107*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*EMP107*/
/* */                                                                 /*EMP107*/
             IF         COND(&BOTH = 'Y' *OR &BOTH = 'N') THEN(DO)    /*EMP107*/
/* */                                                                 /*EMP107*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*EMP107*/
             MONMSG     MSGID(CPF8351)                                /*EMP107*/
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)        /*EMP107*/
             MONMSG     MSGID(CPF1023)                                /*EMP107*/
/* */
/* */                                                                 /*EMP107*/
/* If Correspondence manager is switched on, override files           /*EMP107*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                /*EMP107*/
             CALL       PGM(CGC3605) PARM(&ACTION)                    /*EMP107*/
/* */                                                                 /*EMP107*/
             CALL       PGM(CG4864) PARM(&W0RTN &W0CMT)               /*EMP107*/
                                                                      /*EMP107*/
             RCLRSC                                                   /*EMP107*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*EMP107*/
             CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence +
                          Extract failure')                           /*EMP107*/
             ROLLBACK                                                 /*EMP107*/
             GOTO       CMDLBL(ERROR)                                 /*EMP107*/
             ENDDO                                                    /*EMP107*/
/* */                                                                 /*EMP107*/
/* If Correspondence manager is switched on, call custom defined      /*EMP107*/
/* extract program                                                    /*EMP107*/
/* */                                                                 /*EMP107*/
             CALL       PGM(CGC3604)                                  /*EMP107*/
/* */                                                                 /*EMP107*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*EMP107*/
             CHGVAR     VAR(&MSG) VALUE('Correspondence Manager +
                        Custom-Defined Data Extract failed')          /*EMP107*/
             GOTO       CMDLBL(ERROR)                                 /*EMP107*/
             ENDDO                                                    /*EMP107*/
/**/                                                                  /*EMP107*/
             ENDDO                                                    /*EMP107*/
             ENDDO                                                    /*EMP107*/
/**/                                                                  /*EMP107*/
             ENDDO                                                    /*EMP107*/
/**/                                                                  /*EMP107*/
/*/COPY WNCPYSRC,REC3764002                                          */
             ENDDO
             ELSE DO
             SNDPGMMSG  MSG('No records to process by RE3764') +
                          TOMSGQ(MRUNQ)
                          ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             GOTO       CMDLBL(ENDCL)                                 /*EMP107*/
/**/                                                                  /*EMP107*/
/* Abnormal termination processing                       */           /*EMP107*/
/**/                                                                  /*EMP107*/
ERROR:                                                                /*EMP107*/
             CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                /*EMP107*/
             CALL       PGM(CGC3605) PARM(&ACTION)                    /*EMP107*/
             ROLLBACK                                                 /*EMP107*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*EMP107*/
             CHGJOB     SWS(XXXXXX11)                                 /*EMP107*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*EMP107*/
             DMPCLPGM                                                 /*EMP107*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*EMP107*/
/**/                                                                  /*EMP107*/
             SNDPGMMSG  MSG('Program REC3764 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*EMP107*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC3764 ended abnormally') MSGTYPE(*ESCAPE) /*EMP107*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*EMP107*/
ENDCL:       ENDPGM
