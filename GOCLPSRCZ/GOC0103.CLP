/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO On-line synch. of global layer')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0103 - On-Line Synchronisation of Global Layer           */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1064975          Date 05Dec12              */
/*                      AR1004827          Date 30Jul12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG16177A          Date 08Apr08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1064975 -  Issue on GO_ONL_SYN                            */
/*       AR1004827 - Global updater stops immediately/fails when     */
/*                   receiver changes (BUG16177A incomplete)         */
/*       BUG16177A- Background job EQ_ONL_SYN is not working         */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&TEMPENTYP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JSEQN) TYPE(*DEC) LEN(10)
             DCL        VAR(&JSEQNA) TYPE(*CHAR) LEN(10)                               /*AR1064975*/
             DCL        VAR(&JSEQA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JRCVR) TYPE(*CHAR) LEN(10)                                /*BUG16177A*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
             DCL        VAR(&JSEQN2) TYPE(*DEC) LEN(10)                                /*AR1004827*/
             DCL        VAR(&JSEQA2) TYPE(*CHAR) LEN(20)                               /*AR1004827*/
             DCL        VAR(&JRCVR2) TYPE(*CHAR) LEN(10)                               /*AR1004827*/
             DCL        VAR(&JSEQNA) TYPE(*CHAR) LEN(10)                               /*AR1064975*/
 
             DCLF       FILE(GOOSJSPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             ALCOBJ     OBJ((GOOSJSPD *FILE *EXCLRD)) WAIT(30)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
             SNDPGMMSG  MSG('Attempt to start Universal Transactions +
                          Manager has failed. Probable cause: +
                          process is active already.') +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             CHGJOB SWS(00000000)
 
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)
 
             RCVF
                                                                                       /*AR1004827*/
/* If the CoB has stopped and IC has been reopened, or the database     */             /*AR1004827*/
/* has been refreshed, it can happen that the sequence number on file   */             /*AR1004827*/
/* comes before a 'shutdown' request in the journal, so the job shuts   */             /*AR1004827*/
/* down immediately.                                                    */             /*AR1004827*/
/* Check if there is a 'shutdown' request after the entry on file.      */             /*AR1004827*/
                                                                                       /*AR1004827*/
             CHGVAR     VAR(&JSEQN2) VALUE(&I#LASTSEQ)                                 /*AR1004827*/
             CHGVAR     VAR(&JSEQNA) VALUE(&I#LASTSEQ)                                 /*AR1064975*/
/*           RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) +
                          FROMENTLRG(*FIRST) TOENTLRG(JSEQN2) +
                          SEARCH(*DESCEND) JRNCDE((U)) ENTTYP(OS) +
                          RTNSEQLRG(&JSEQA2) RTNRCV(&JRCVR2)          */     /*AR1004827 AR1064975*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) +
                          FROMENTLRG(*FIRST) TOENTLRG(&JSEQNA) +
                          SEARCH(*DESCEND) JRNCDE((U)) ENTTYP(OS) +
                          RTNSEQLRG(&JSEQA2) RTNRCV(&JRCVR2)                           /*AR1064975*/
             MONMSG     MSGID(CPF0000)                                                 /*AR1004827*/
                                                                                       /*AR1004827*/
 
             CHGVAR     VAR(&JSEQN) VALUE(&I#LASTSEQ)
             CHGVAR     VAR(&JRCVR) VALUE(&I#LASTRCV)                                  /*BUG16177A*/
             IF         COND(&JSEQA2 = '                    ') +
                          THEN(GOTO CMDLBL(RERUN))                                     /*AR1004827*/
             CHGVAR     VAR(&JSEQN2) VALUE(&JSEQA2)                                    /*AR1004827*/
             CHGVAR     VAR(&JSEQNA) VALUE(&JSEQA2)                                    /*AR1064975*/
             IF         COND(&JSEQN2 > &JSEQN) THEN(DO)                                /*AR1004827*/
                CHGVAR     VAR(&JSEQN) VALUE(&JSEQN2)                                  /*AR1004827*/
                CHGVAR     VAR(&JRCVR) VALUE(&JRCVR2)                                  /*AR1004827*/
             ENDDO                                                                     /*AR1004827*/
                                                                                       /*AR1004827*/
 
/* Check if journal sequence exists. */
/* If journal sequence does not exist, set to restart at first entry */
 
/*RERUN:***  RTVJRNE    JRN(ICJRN) FROMENT(&JSEQN) +
                          TOENT(&JSEQN) RTNENTTYP(&TEMPENTYP)                          /*BUG16177A*/
/**********     MONMSG     MSGID(CPF0000) EXEC(DO)                                     /*BUG16177A*/
/**********        CHGVAR     VAR(&JSEQN) VALUE(0)                                     /*BUG16177A*/
/**********        RTVJRNE    JRN(ICJRN) FROMENT(*FIRST) +
                                TOENT(*FIRST) RTNSEQNBR(&JSEQN)                        /*BUG16177A*/
/**********        MONMSG     MSGID(CPF0000)                                           /*BUG16177A*/
/**********     ENDDO                                                                  /*BUG16177A*/
 
   RERUN:    IF         COND(&JSEQN = 0) THEN(DO)                                      /*BUG16177A*/
             RTVJRNE    JRN(ICJRN) RCVRNG(&JRCVR) FROMENT(*FIRST) +
                          TOENT(*FIRST) RTNRCV(&JRCVR) +
                          RTNSEQNBR(&JSEQN)                                            /*AR1004827*/
/**********               TOENT(*FIRST) RTNSEQNBR(&JSEQN)            */      /*BUG16177A AR1004827*/
               MONMSG     MSGID(CPF0000) EXEC(DO)                                      /*BUG16177A*/
                          CHGVAR     VAR(&JSEQN) VALUE(0)                              /*BUG16177A*/
                          CHGVAR     VAR(&JRCVR) VALUE('*CURRENT')                     /*BUG16177A*/
                          CHGVAR     VAR(&JRCVR) VALUE('*CURCHAIN')                    /*AR1004827*/
                          GOTO       CMDLBL(RERUN)                                     /*BUG16177A*/
               ENDDO                                                                   /*BUG16177A*/
             ENDDO                                                                     /*BUG16177A*/
             ELSE       CMD(DO)                                                        /*BUG16177A*/
             RTVJRNE    JRN(ICJRN) RCVRNG(&JRCVR) FROMENT(&JSEQN) +
                          TOENT(*LAST) RTNENTTYP(&TEMPENTYP)                           /*BUG16177A*/
               MONMSG     MSGID(CPF0000) EXEC(DO)                                      /*BUG16177A*/
                          CHGVAR     VAR(&JSEQN) VALUE(0)                              /*BUG16177A*/
                          CHGVAR     VAR(&JRCVR) VALUE('*CURRENT')                     /*BUG16177A*/
                          GOTO       CMDLBL(RERUN)                                     /*BUG16177A*/
               ENDDO                                                                   /*BUG16177A*/
             ENDDO                                                                     /*BUG16177A*/
                                                                                       /*BUG16177A*/
             CHGVAR     VAR(&JSEQN) VALUE(&JSEQN + 1)
 
/* overrides */
 
             OVRDBF     FILE(GPULOGPD) SHARE(*NO) SEQONLY(*YES 1)
             OVRDBF     FILE(GOOSJSPD) SHARE(*NO)
             OVRDBF     FILE(GOOSJSPDN) TOFILE(GOOSJSPD) SHARE(*NO)
 
/* Receive journal entries*/
 
             CHGVAR     VAR(&JSEQA) VALUE(&JSEQN)
 /********** CALL       PGM(GOOLSYNGC) PARM(&JSEQA)                                    /*BUG16177A*/
             CALL       PGM(GOOLSYNGC) PARM(&JSEQA &JRCVR)                             /*BUG16177A*/
 
 
             DLTOVR *ALL
 
 
                                                                                       /*AR1004827*/
/* Receiver has changed - get new starting details for RCVJRNE command */              /*AR1004827*/
             IF COND(%SWITCH(XXXXX100)) THEN(DO)
/**********     CHGVAR     VAR(&JSEQN) VALUE(0)  */                                    /*AR1004827*/
                CALL       PGM(GOC0103A) PARM(&JSEQN &JRCVR)                           /*AR1004827*/
                CHGVAR     VAR(&JSEQN) VALUE(&JSEQN + 1)                               /*AR1004827*/
                CHGJOB     SWS(00000000)
                GOTO       CMDLBL(RERUN)
             ENDDO
 
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             GOC0103 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
 
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GOC0103 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 
             DLCOBJ     OBJ((GOOSJSPD *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
