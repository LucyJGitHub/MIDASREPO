/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT CHEQUES TO BE PAID AUDIT AND LIST')          */
/********************************************************************/
/*                                                                  */
/*       Midas     - FUNDS TRANSFER MODULE                      */
/*                                                                  */
/*       FTC0550  - CL COMPONENT TO CONTROL FT0550                  */
/*                - CHEQUES TO BE PAID AUDIT/LIST.                  */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 25Feb94              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      067582             Date 25Feb94              */
/*       PREV AMEND NO. S01117            DATE   28SEP90            */
/*                      S01194            DATE   28SEP90            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       067582 - SHOULD CLOSE OPENED FILE AFTER USE, OTHERWISE     */
/*                PROGRAM FALLS OVER IF THERE ARE DETAILS TO BE     */
/*                REPORTED FOR MORE THAN ONE BRANCH.                */
/*              - ADD ABNOR PROCESSING                              */
/*       S01117 - RELEASE 10 MULTIBRANCHING CHANGES                 */
/*       S01194 - STANDING DATA CHANGES                             */
/********************************************************************/
/**          PGM        PARM(&TYPE)                                  /*S01117*/
             PGM        PARM(&TYPE &RSEQ &RLEV &RENT)                /*S01117*/
 
/**     DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)                    /*S01194*/
        DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                    /*S01194*/
        DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                     /*S01117*/
        DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                     /*S01117*/
        DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                     /*S01117*/
        DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
/*******DCL   VAR(&MPHAS) TYPE(*CHAR)   LEN(1)                                         */ /*CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                 /*S01194*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                             /*067582*/
/**/                                                                 /*S01194*/
/** Check if LDA Data area exists and create it if not **/           /*S01194*/
/**/                                                                 /*S01194*/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)                         /*S01194*/
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))                 /*S01194*/
/**/
        CHGJOB     SWS(XXXXXX00)
/**/
/** RETREIVE DATA AREA MPHAS **/
/**/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
/**/
/**/
/**     IF         COND(%SST(&MPHAS 1 1) = 'C') THEN(SNDPGMMSG + */  /*S01117*/
/**                  MSG('FT0550 -  Cheques to be paid audit +   */
/**                       report') TOMSGQ(MRUNQ))                */
/*****IF  COND((%SST(&MPHAS 1 1) = 'C') *AND (&TYPE *EQ 'A')) THEN( +
            SNDPGMMSG  MSG('FT0550 -  Cheques to be paid audit +
                          report') TOMSGQ(MRUNQ))                               */ /*S01117 CCB020*/
             IF         COND((&COBST  *EQ '*YES') *AND (&TYPE *EQ +
                          'A')) THEN(SNDPGMMSG MSG('FT0550 -  +
                          Cheques to be paid audit report') +
                          TOMSGQ(MRUNQ))                                                  /*CCB020*/
/**/                                                                 /*S01117*/
/** SET UP OVER RIDES **/                                            /*S01117*/
/**/                                                                 /*S01117*/
             IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(CQPACBB) POSITION(*KEY 1 *N &RENT)
             OPNDBF     FILE(CQPACBB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(CQPACBB) +
                          POSITION(*END))
             ENDDO                                                   /*S01117*/
/**/
/**/
/** CALL PROGRAM **/
/**/
/**          CALL       PGM(FT0550) PARM(&TYPE)                      /*S01117*/
             CALL       PGM(FT0550) PARM(&RSEQ &RLEV &RENT &TYPE)    /*S01117*/
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/**          RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&MEM)         /*S01194*/
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)         /*S01194*/
/**********  IF  COND(%SST(&MPHAS 1 1) = 'C') THEN( +
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOMSGQ(MRUNQ MOPERQ))                                               */ /*CCB020*/
             IF  COND(&COBST  *EQ '*YES') THEN( +
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOMSGQ(MRUNQ MOPERQ))                                                  /*CCB020*/
             ELSE  CMD( +
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ))
        ENDDO
/**/
/** CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM    **/
/**/
        IF   COND(%SWITCH(XXXXXX01))   THEN(DO)
/**********  IF    COND(%SST(&MPHAS 1 1) = 'C') THEN( +
                     SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                        TOMSGQ(MRUNQ MOPERQ))                                          */ /*CCB020*/
             IF    COND(&COBST  *EQ '*YES') THEN( +
                     SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                        TOMSGQ(MRUNQ MOPERQ))                                             /*CCB020*/
             ELSE  CMD( +
                     SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ))
        ENDDO
 
             GOTO       CMDLBL(END)                                   /*067582*/
ABNOR:                                                                /*067582*/
                                                                      /*067582*/
             SNDPGMMSG  MSG('FT0550 -  Cheques to be Paid audit +
                          report terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)                        /*067582*/
             CHGJOB     SWS(XXXXXX11)                                 /*067582*/
                                                                     /*S01117*/
END:                                                                  /*067582*/
/** DELETE OVERRIDES    **/                                          /*S01117*/
/**/                                                                 /*S01117*/
             DLTOVR     FILE(CQPACBB)                                /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*067582*/
/************MONMSG     MSGID(CPF9841)                                /*067582*/
             CLOF       OPNID(CQPACBB)                                /*067582*/
             MONMSG     MSGID(CPF0000)                                /*067582*/
                                                                      /*067582*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             ENDPGM
