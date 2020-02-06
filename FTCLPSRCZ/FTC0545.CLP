/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT CHEQUES FOR COLLECTION UNAUTHORISED')        */
/********************************************************************/
/*                                                                  */
/*       Midas       FUNDS TRANSFER MODULE                      */
/*                                                                  */
/*       FTC0545  - CL COMPONENT TO CONTROL FT0545                  */
/*                - CHEQUES FOR COLLECTION AUDIT/LIST.              */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      133172             Date 29Apr99              */
/*                      067582            DATE   25FEB94            */
/*                      S01117            DATE  15/01/91            */
/*                      S01194            DATE  15/01/91            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       133172 - REMOVE PRINTER FILE OVERRIDE                      */
/*       067582 - SHOULD CLOSE OPENED FILE AFTER USE, OTHERWISE     */
/*                PROGRAM FALLS OVER IF THERE ARE DETAILS TO BE     */
/*                REPORTED FOR MORE THAN ONE BRANCH.                */
/*              - ADD ABNOR PROCESSING                              */
/*                S01194- NEW DATABASE HANDLING                      */
/*                S01117- RCF PROCESSING                             */
/********************************************************************/
/**          PGM                                                     /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                      /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**     DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)                    /*S01194*/
/**     DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)                     /*S01117*/
        DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                    /*S01194*/
        DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1) VALUE(B)            /*S01117*/
        DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                     /*S01117*/
        DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                     /*S01117*/
        DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                     /*S01117*/
/*******DCL   VAR(&MPHAS) TYPE(*CHAR)   LEN(1)                     */                     /*CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
/**/                                                                 /*S01194*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                             /*067582*/
/**/                                                                 /*S01194*/
      CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD LOCAL +
                          DATA AREA EQUIVALENT') AUT(*USE))
/**/                                                                 /*S01194*/
/**/
        CHGJOB     SWS(XXXXXX00)
/**/
/***RETREIVE*DATA*AREA*MPHAS **/                                                          /*CCB020*/
/**/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)               */                     /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
/**/
/**/
 
/*******IF  COND(%SST(&MPHAS 1 1) = 'C') THEN(DO)                                      */ /*CCB020*/
        IF  COND(&COBST *EQ '*YES') THEN(DO)                                              /*CCB020*/
             CHGVAR     VAR(&TYPE) VALUE('A')
/*           OVRPRTF    FILE(FT0545P1) OUTQ(MPRINTAU)                  S01117  133172 */
             ENDDO
 
/**     IF  COND(%SST(&MPHAS 1 1) = 'A' *OR +                        /*S01117*/
/**              %SST(&MPHAS 1 1) = 'D' *OR +                        /*S01117*/
/**              %SST(&MPHAS 1 1) = 'F') THEN(DO)                    /*S01117*/
/**          CHGVAR     VAR(&TYPE) VALUE('L')                        /*S01117*/
/**          ENDDO                                                   /*S01117*/
 
/*******IF  COND(%SST(&MPHAS 1 1) *NE 'A' *AND +
                 %SST(&MPHAS 1 1) *NE 'C' *AND +
                 %SST(&MPHAS 1 1) *NE 'D' *AND +
                 %SST(&MPHAS 1 1) *NE 'F') THEN(DO)                */                     /*CCB020*/
/**********  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA('Program +
                          cannot be run at this time') TOPGMQ(*EXT)*/                     /*CCB020*/
/**********  ENDDO                                                 */                     /*CCB020*/
 
/**/                                                                 /*S01117*/
/** SET UP OVER RIDES **/                                            /*S01117*/
/**/                                                                 /*S01117*/
         IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(CQCODBB) POSITION(*KEY 1 *N &RENT)
             OPNDBF     FILE(CQCODBB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(CQCODBB) +
                          POSITION(*END))
         ENDDO                                                       /*S01117*/
/**/
/**/
/** CALL PROGRAM **/
/**/
/**     CALL       PGM(FT0545) PARM(&TYPE)                           /*S01117*/
        CALL       PGM(FT0545) PARM(&TYPE &RSEQ &RLEV &RENT)         /*S01117*/
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/**          RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&MEM)    **/  /*S01194*/
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
/**/                                                                  /*067582*/
             GOTO       CMDLBL(END)                                   /*067582*/
ABNOR:                                                                /*067582*/
/**/                                                                  /*067582*/
             SNDPGMMSG  MSG('FT0545 - Unauthorised Cheques for +
                          Collection report terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)                        /*067582*/
             CHGJOB     SWS(XXXXXX11)                                 /*067582*/
/**/                                                                  /*067582*/
END:                                                                  /*067582*/
/** delete overrides **/                                              /*067582*/
/**/
             DLTOVR     FILE(CQCODBB)                                /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*067582*/
/************MONMSG     MSGID(CPF9841)                                /*067582*/
             CLOF       OPNID(CQCODBB)                                /*067582*/
             MONMSG     MSGID(CPF0000)                                /*067582*/
             DLTOVR     FILE(FT0545P1)                               /*S01117*/
             MONMSG     MSGID(CPF9841)                               /*S01117*/
/**/                                                                 /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
