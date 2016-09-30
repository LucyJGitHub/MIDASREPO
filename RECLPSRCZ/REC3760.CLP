/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE REFERRAL/EXCESS REPORTS EXTRACT')            */
/*********************************************************************/
/*                                                                   */
/*       Midas       Retail Module                               */
/*                                                                   */
/*       REC3760 -  REFERRAL AND EXCESS EXTRACT                      */
/*                                                                   */
/*   WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.           */                 /*CRE083BU*/
/*             DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT   */                 /*CRE083BU*/
/*             ABLE TO RUN IN TASK SPLIT.                            */                 /*CRE083BU*/
/*                                                                   */                 /*CRE083BU*/
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD041343           Date 15Sep16              */
/*       Prev Amend No. MD022097           Date 30Aug13              */
/*                      AR1097467B         Date 17Apr13              */
/*                      MD002850           Date 08Apr13              */
/*                      CRE083BU           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CGL002             Date 28OCT96              */
/*                      S01413 *CREATE     Date 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD041343 - Undefined record type found in file SSRACJL      */
/*       MD022097 - Low performance of REC3760T2                     */
/*       AR1097467B - Expected 15% COB run optimization not met      */
/*       MD002850 - Correct the processing for restart of subtasks   */
/*                  after failure.                                   */
/*       CRE083BU - COB Restructure - RE COB Optimisation Phase 1    */
/*       CGL002 - Block GL Accounts in Journal Entry Input           */
/*       S01413  -  Retail 3 Incorporation                           */
/*                  and changes for Release 10 standards.            */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                      */                /*CRE083BU*/
             PGM        PARM(&CNAM &CSEQ)                                               /*CRE083BU*/
                                                                                        /*CRE083BU*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN(7) VALUE(' ')     /*CGL002*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CGL002*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                                  /*CRE083BU*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                                  /*CRE083BU*/
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)                                  /*CRE083BU*/
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)                                /*CRE083BU*/
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)                              /*CRE083BU*/
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)                   /*CRE083BU*/
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)                               /*CRE083BU*/
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)                               /*CRE083BU*/
             DCL        VAR(&RCVDTAQ) TYPE(*CHAR) LEN(10)                               /*CRE083BU*/
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600)                    /*CRE083BU*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)                                /*CRE083BU*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)                                   /*CRE083BU*/
             DCL        VAR(&SNDMSG) TYPE(*CHAR) LEN(1) VALUE('N')                      /*CRE083BU*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                                  /*CRE083BU*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                                   /*CRE083BU*/
             DCL        VAR(&INDEXFL) TYPE(*CHAR) LEN(10) +
                          VALUE('RERACIPD')                                             /*CRE083BU*/
             DCL        VAR(&NBREC) TYPE(*DEC) LEN(10 0)                                /*CRE083BU*/
             DCL        VAR(&CGL002) TYPE(*CHAR) LEN(1) VALUE('N')                      /*MD022097*/
             DCL        VAR(&SKEYVALUE) TYPE(*CHAR) LEN(24)                             /*MD022097*/
             DCL        VAR(&EKEYVALUE) TYPE(*CHAR) LEN(24)                             /*MD022097*/
                                                                                        /*CRE083BU*/
/* Global monitor message */                                                            /*CRE083BU*/
                                                                                        /*CRE083BU*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                                                /*CRE083BU*/
/**/
             SNDPGMMSG  MSG('REC3760 - Referral & Excess Reports +
                          Extract') TOMSGQ(MRUNQ)
                CHGJOB SWS(00000000)
/**/
/**********     CLRPFM FILE(ODACON)                                */                   /*CRE083BU*/
/**********     CLRPFM FILE(RTZZ) MBR(ODAC)                        */                   /*CRE083BU*/
/**********     CLRPFM FILE(REFRLRL)                               */                   /*CRE083BU*/
/**********     CLRPFM FILE(RTZZ) MBR(REFRL)                       */                   /*CRE083BU*/
/**********     CLRPFM FILE(REFRLGL)                               */                   /*CRE083BU*/
/**********     CLRPFM FILE(REFRLGZ)                               */                   /*CRE083BU*/
/**/
/*  If Block GL Accounts Enhancement is installed, perform file  */   /*CGL002*/
/*  overrides to include both GL and Retail accounts             */   /*CGL002*/
/**/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL002' +
                          &DSFDY)                                     /*CGL002*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*CGL002*/
/**********     OVRDBF     FILE(SSRACJL) TOFILE(GLACCTJ0)          */            /*CGL002 CRE083BU*/
                CHGVAR     VAR(&CGL002) VALUE('Y')                                      /*MD022097*/
                OVRDBF     FILE(SRETP) TOFILE(GLEODPL0)               /*CGL002*/
             ENDDO                                                    /*CGL002*/
                                                                                        /*CRE083BU*/
/* Read COB components file to check the restart status */                              /*CRE083BU*/
                                                                                        /*CRE083BU*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)                             /*CRE083BU*/
                                                                                        /*CRE083BU*/
/* Check if any problems with CB0160 call */                                            /*CRE083BU*/
                                                                                        /*CRE083BU*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                /*CRE083BU*/
             GOTO       CMDLBL(ABNOR)                                                   /*CRE083BU*/
             ENDDO                                                                      /*CRE083BU*/
                                                                                        /*CRE083BU*/
             CHGVAR     VAR(&RESTART) VALUE(&STAT)                                      /*CRE083BU*/
                                                                                        /*CRE083BU*/
/* Set restart status to 'Y' */                                                         /*CRE083BU*/
                                                                                        /*CRE083BU*/
             CHGVAR     VAR(&STAT) VALUE('Y')                                           /*CRE083BU*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                             /*CRE083BU*/
                                                                                        /*CRE083BU*/
/* Set up call to QSNDDTAQ and override files to their members */                       /*CRE083BU*/
                                                                                        /*CRE083BU*/
             CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                                        /*CRE083BU*/
             CHGVAR     VAR(&MEMBER) VALUE('RAERE' *CAT &CSEQC)                         /*CRE083BU*/
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                                   /*CRE083BU*/
             CHGVAR     VAR(&SNDDTAQ) VALUE('RAERESERVE')                               /*CRE083BU*/
             CHGVAR     VAR(&RCVDTAQ) VALUE(&MEMBER)                                    /*CRE083BU*/
                                                                                        /*CRE083BU*/
             OVRDBF     FILE(RERACDPD) TOFILE(RERACDPD) MBR(&MEMBER)                    /*CRE083BU*/
                                                                                        /*CRE083BU*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                                     /*CRE083BU*/
                                                                                        /*CRE083BU*/
/* If restart from component failed because of no respond from Server */                /*CRE083BU*/
/* So resend message to Server and wait */                                              /*CRE083BU*/
                                                                                        /*CRE083BU*/
             IF         COND(&RESTART = 'F') THEN(DO)                                   /*CRE083BU*/
             GOTO       CMDLBL(LOOP)                                                    /*CRE083BU*/
             ENDDO                                                                      /*CRE083BU*/
                                                                                        /*CRE083BU*/
/* If restart, not caused by server do not responds, */                                 /*CRE083BU*/
/* do not wait for the data queue entry */                                              /*CRE083BU*/
/* Clear any old data queue message from server but ensure that an */                   /*CRE083BU*/
/* 'END' message, sent from the end proc job is not lost */                             /*CRE083BU*/
                                                                                        /*CRE083BU*/
             IF         COND(&RESTART = 'Y') THEN(DO)                                   /*CRE083BU*/
                CHGVAR     VAR(&RCVWAIT) VALUE(5)                                       /*CRE083BU*/
                CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                             &MSGLENGTH &MSGDATA &RCVWAIT)                              /*CRE083BU*/
                CHGVAR     VAR(&RCVWAIT) VALUE(600)                                     /*CRE083BU*/
                CHGVAR     VAR(&MSGLENGTH) VALUE(50)                                    /*CRE083BU*/
                IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)                    /*CRE083BU*/
                CALL       PGM(QSNDDTAQ) PARM(&MEMBER &DTAQLIBL +
                             &MSGLENGTH &MSGDATA)                                       /*CRE083BU*/
                ENDDO                                                                   /*CRE083BU*/
                GOTO       CMDLBL(RESTART)                                              /*CRE083BU*/
             ENDDO                                                                      /*CRE083BU*/
                                                                                        /*CRE083BU*/
LOOP:                                                                                   /*CRE083BU*/
                                                                                        /*CRE083BU*/
/* Send message to main data queue */                                                   /*CRE083BU*/
                                                                                        /*CRE083BU*/
             CLRPFM     FILE(RERACDPD) MBR(&MEMBER)                                   /*AR1097467B*/
             CHGVAR     VAR(&MSGDATA) VALUE(&MEMBER)                                    /*CRE083BU*/
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                                          /*CRE083BU*/
/**********  CHGVAR     VAR(&STAT) VALUE('F')                    */            /*CRE083BU MD002850*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)      */            /*CRE083BU MD002850*/
                                                                                        /*CRE083BU*/
/* Wait on reply for 5 minutes */                                                       /*CRE083BU*/
                                                                                        /*CRE083BU*/
DTAQWAIT:                                                                               /*MD022097*/
             CALL       PGM(QRCVDTAQ) PARM(&RCVDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)                                 /*CRE083BU*/
                                                                                        /*CRE083BU*/
/* If no reply, check if the server is still active */                                  /*CRE083BU*/
/* If Server is not active then error message and Terminate */                          /*CRE083BU*/
/* If Server is active, then resend a message to server */                              /*CRE083BU*/
/* If Server still do not respond after message send, then */                           /*CRE083BU*/
/* error message and terminate */                                                       /*CRE083BU*/
                                                                                        /*CRE083BU*/
             IF         COND(&MSGLENGTH = 0) THEN(DO)                                   /*CRE083BU*/
                ALCOBJ     OBJ((&INDEXFL *FILE *EXCL)) WAIT(0)                          /*CRE083BU*/
                MONMSG     MSGID(CPF1002) EXEC(DO)                                      /*CRE083BU*/
                IF         COND(&SNDMSG *EQ 'Y') THEN(DO)                               /*CRE083BU*/
                   CHGVAR     VAR(&STAT) VALUE('F')                                     /*MD002850*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                       /*MD002850*/
                   SNDPGMMSG  MSG('No response from server for REC3760') +
                                TOMSGQ(MOPERQ MRUNQ)                                    /*CRE083BU*/
                   GOTO       CMDLBL(ABNOR)                                             /*CRE083BU*/
                ENDDO                                                                   /*CRE083BU*/
                ELSE       CMD(DO)                                                      /*CRE083BU*/
                   CHGVAR     VAR(&SNDMSG) VALUE('Y')                                   /*CRE083BU*/
                   CHGVAR     VAR(&MSGLENGTH) VALUE(50)                                 /*MD022097*/
                   GOTO       CMDLBL(LOOP)                                              /*CRE083BU*/
                ENDDO                                                                   /*CRE083BU*/
                ENDDO                                                                   /*CRE083BU*/
                                                                                        /*MD002850*/
                CHGVAR     VAR(&STAT) VALUE('F')                                        /*MD002850*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                          /*MD002850*/
                SNDPGMMSG  MSG('Server for REC3760 not active') +
                             TOMSGQ(MOPERQ MRUNQ)                                       /*CRE083BU*/
                GOTO       CMDLBL(ABNOR)                                                /*CRE083BU*/
             ENDDO                                                                      /*CRE083BU*/
                                                                                        /*CRE083BU*/
/* If reply = END, set restart status to 'N' and terminate */                           /*CRE083BU*/
                                                                                        /*CRE083BU*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)                       /*CRE083BU*/
                CHGVAR     VAR(&STAT) VALUE('N')                                        /*CRE083BU*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                          /*CRE083BU*/
                GOTO       CMDLBL(ENDPGM)                                               /*CRE083BU*/
             ENDDO                                                                      /*CRE083BU*/
                                                                                        /*CRE083BU*/
 RESTART:                                                                               /*CRE083BU*/
             RTVMBRD    FILE(RERACDPD) MBR(&MEMBER) NBRCURRCD(&NBREC)                   /*MD022097*/
             IF         COND(&NBREC *EQ 0) THEN(DO)                                     /*MD022097*/
                GOTO       CMDLBL(DTAQWAIT)                                             /*MD022097*/
             ENDDO                                                                      /*MD022097*/
             ELSE       CMD(DO)                                                         /*MD022097*/
                CALL       PGM(REC3760RD) PARM(&SKEYVALUE &EKEYVALUE)                   /*MD022097*/
             ENDDO                                                                      /*MD022097*/
                                                                                        /*MD022097*/
/* If CGL002 is installed, override file to include both */                             /*MD022097*/
/* the GL and Retail accounts */                                                        /*MD022097*/
                                                                                        /*MD022097*/
             IF         COND(&CGL002 *EQ 'Y') THEN(DO)                                  /*MD022097*/
/**********     OVRDBF     FILE(SSRACJL) TOFILE(GLACCTJ0) POSITION(*KEY +
                             5 GLACCTJF &SKEYVALUE)                */          /*MD022097 MD041343*/
                OVRDBF     FILE(SSRACJL) TOFILE(GLACCTJ0) POSITION(*KEY +
                             5 SSRACJF &SKEYVALUE)                                      /*MD041343*/
             ENDDO                                                                      /*MD022097*/
             ELSE       CMD(DO)                                                         /*MD022097*/
                OVRDBF     FILE(SSRACJL) TOFILE(SSRACJL) POSITION(*KEY +
                             5 SSRACJF &SKEYVALUE)                                      /*MD022097*/
             ENDDO                                                                      /*MD022097*/
/**/
/**********     OVRDBF FILE(ODACZZ) TOFILE(RTZZ) MBR(ODAC)         */                   /*CRE083BU*/
/**********     OVRDBF FILE(REFRLZZ) TOFILE(RTZZ) MBR(REFRL)       */                   /*CRE083BU*/
             OVRDBF     FILE(ODACZZ) TOFILE(RTZZ) MBR(ODACTX)                           /*CRE083BU*/
             OVRDBF     FILE(REFRLZZ) TOFILE(RTZZ) MBR(REFRLTX)                         /*CRE083BU*/
             OVRDBF     FILE(REFRLGZ) TOFILE(REFRLGZ) MBR(FRLGTX)                       /*CRE083BU*/
/**********  OVRDBF     FILE(SSRACJL) TOFILE(RERACDPD) MBR(&MEMBER)*/          /*CRE083BU MD022097*/
/**********  ALCOBJ     OBJ((ACCNT *FILE *EXCLRD)) WAIT(9999)      */                   /*CRE083BU*/
/**********     CALL PGM(RE3760)                                   */                   /*MD022097*/
             CALL       PGM(RE3760) PARM(&EKEYVALUE)                                    /*MD022097*/
                                                                                        /*MD022097*/
/**********  DLCOBJ     OBJ((ACCNT *FILE *EXCLRD))                 */                   /*CRE083BU*/
/**********     DLTOVR FILE(*ALL)                                  */                   /*MD022097*/
             DLTOVR     FILE(ODACZZ REFRLZZ REFRLGZ)                                    /*MD022097*/
/**/
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   SNDPGMMSG MSG('FILE OUT OF BALANCE - RE3760') TOMSGQ(MOPERQ)
                ENDDO
                                                                                        /*CRE083BU*/
/* Add rollback if error */                                                             /*CRE083BU*/
                                                                                        /*CRE083BU*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)                           /*CRE083BU*/
                RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)                                /*CRE083BU*/
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))                           /*CRE083BU*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                                       /*CRE083BU*/
                ROLLBACK                                                                /*CRE083BU*/
                GOTO       CMDLBL(ABNOR)                                                /*CRE083BU*/
             ENDDO                                                                      /*CRE083BU*/
                                                                                        /*CRE083BU*/
/* Commit changes */                                                                    /*CRE083BU*/
                                                                                        /*CRE083BU*/
             COMMIT                                                                     /*CRE083BU*/
             CHGVAR     VAR(&RESTART) VALUE('N')                                        /*CRE083BU*/
             GOTO       CMDLBL(LOOP)                                                    /*CRE083BU*/
                                                                                        /*CRE083BU*/
 ABNOR:                                                                                 /*CRE083BU*/
             SNDPGMMSG  MSG('Program REC3760 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                                          /*CRE083BU*/
             MONMSG     MSGID(CPF0000 MCH0000)                                          /*CRE083BU*/
             CHGJOB     SWS(XXXXXX11)                                                   /*CRE083BU*/
/**/
 ENDPGM:                                                                                /*CRE083BU*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             DLTOVR     FILE(*ALL)                                                      /*MD022097*/
             MONMSG     MSGID(CPF0000)                                                  /*MD022097*/
             ENDCMTCTL                                                                  /*CRE083BU*/
             MONMSG     MSGID(CPF0000)                                                  /*CRE083BU*/
             ENDPGM
