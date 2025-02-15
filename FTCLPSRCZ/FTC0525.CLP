/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT INCOMING PAYMENTS UNAUTHORISED - BRCA')      */
/********************************************************************/
/*                                                                  */
/*       Midas       FUNDS TRANSFER MODULE                      */
/*                                                                  */
/*       FTC0525  - CL COMPONENT TO CONTROL FT0525                  */
/*                  INCOMING PAYMENTS REPORTING.                    */
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
/*                      067582             Date 25Feb94              */
/*                      S01117            DATE  08/11/90            */
/*                      S01194            DATE  08/11/90            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       067582 - SHOULD CLOSE OPENED FILE AFTER USE, OTHERWISE     */
/*                PROGRAM FALLS OVER IF THERE ARE DETAILS TO BE     */
/*                REPORTED FOR MORE THAN ONE BRANCH.                */
/*              - ADD ABNOR PROCESSING                              */
/*                S01194- NEW DATABASE HANDLING                     */
/*                S01117- RCF PROCESSING                            */
/********************************************************************/
/**          PGM                                                     /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                      /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**          DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               /*S01194*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)               /*S01194*/
/**          DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)                /*S01117*/
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1) VALUE(B)       /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                /*S01117*/
/*******DCL   VAR(&MPHAS) TYPE(*CHAR)   LEN(1)                     */                     /*CCB020*/
                                                                                          /*CCB020*/
/* Parameter for call to CBC001001 */                                                     /*CCB020*/
             DCL        VAR(&WCOB) TYPE(*CHAR) LEN(4)                                     /*CCB020*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                             /*067582*/
/**/                                                                 /*S01194*/
      CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD LOCAL +
                          DATA AREA EQUIVALENT') AUT(*USE))
/**/                                                                 /*S01194*/
             CHGJOB     SWS(XXXXXX00)
/**/
/***retreive*data*area*MPHAS***/                                                          /*CCB020*/
/**/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                      /*CCB020*/
/**/
/* Call program CBC001001 to check if program is in COB or IC */                          /*CCB020*/
/* If the return value is *YES, system is in COB */                                       /*CCB020*/
                                                                                          /*CCB020*/
             CALL       PGM(CBC001001) PARM(&WCOB)                                        /*CCB020*/
                                                                                          /*CCB020*/
/**/
/** call program **/
/**/
 
/*******IF  COND(%SST(&MPHAS 1 1) = 'C') THEN(DO)                  */                     /*CCB020*/
        IF  COND(&WCOB = '*YES') THEN(DO)                                                 /*CCB020*/
             CHGVAR     VAR(&TYPE) VALUE('A')
             OVRPRTF    FILE(FT0525P1) OUTQ(MPRINTAU)                /*S01117*/
             ENDDO
 
/**     IF  COND(%SST(&MPHAS 1 1) = 'A' *OR +                        /*S01117*/
/**              %SST(&MPHAS 1 1) = 'D' *OR +                        /*S01117*/
/**              %SST(&MPHAS 1 1) = 'F') THEN(DO)                    /*S01117*/
/**          CHGVAR     VAR(&TYPE) VALUE('L')                        /*S01117*/
/**          ENDDO                                                   /*S01117*/
 
/*******IF  COND(%SST(&MPHAS 1 1) *NE 'A' *AND +                   */                     /*CCB020*/
/**********      %SST(&MPHAS 1 1) *NE 'C' *AND +                   */                     /*CCB020*/
/**********      %SST(&MPHAS 1 1) *NE 'D' *AND +                   */                     /*CCB020*/
/**********      %SST(&MPHAS 1 1) *NE 'F') THEN(DO)                */                     /*CCB020*/
/**********  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA('Program +                      /*CCB020*/
/**********               cannot be run at this time') TOPGMQ(*EXT)*/                     /*CCB020*/
/**********  ENDDO                                                 */                     /*CCB020*/
/**/                                                                 /*S01117*/
/** SET UP OVER RIDES **/                                            /*S01117*/
/**/                                                                 /*S01117*/
          IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(NINPYBB) POSITION(*KEY 1 *N &RENT)      /*S01117*/
             OPNDBF     FILE(NINPYBB) OPTION(*INP)                   /*S01117*/
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(NINPYBB) +
                          POSITION(*END))                            /*S01117*/
           ENDDO                                                     /*S01117*/
 
/**     CALL       PGM(FT0525) PARM(&TYPE)                           /*S01117*/
        CALL       PGM(FT0525) PARM(&TYPE &RSEQ &RLEV &RENT)         /*S01117*/
/**/
/** check for database errors trapped by program **/
/**/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/**          RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&MEM)         /*S01194*/
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)         /*S01194*/
/**********  IF  COND(%SST(&MPHAS 1 1) = 'C') THEN( +              */                     /*CCB020*/
             IF  COND(&WCOB = '*YES') THEN( +
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOMSGQ(MRUNQ MOPERQ))                                                  /*CCB020*/
             ELSE  CMD( +
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ))
        ENDDO
 
/**/
/** check for FOOB errors trapped by program **/
/**/
        IF   COND(%SWITCH(XXXXXX01))   THEN(DO)
/**********  IF    COND(%SST(&MPHAS 1 1) = 'C') THEN( +            */                     /*CCB020*/
             IF    COND(&WCOB = '*YES') THEN( +
                     SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                        TOMSGQ(MRUNQ MOPERQ))                                             /*CCB020*/
             ELSE  CMD( +
                     SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ))
        ENDDO
 
             GOTO       CMDLBL(END)                                   /*067582*/
ABNOR:                                                                /*067582*/
/**/                                                                  /*067582*/
             SNDPGMMSG  MSG('FT0525 - Unauthorised Incoming Payments +
                          report terminated abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*067582*/
             CHGJOB     SWS(XXXXXX11)                                 /*067582*/
/**/                                                                  /*067582*/
END:                                                                  /*067582*/
/** delete overrides **/                                              /*067582*/
/**/
             DLTOVR     FILE(NINPYBB)                                /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*067582*/
/************MONMSG     MSGID(CPF9841)                         /*S01117 067582*/
             CLOF       OPNID(NINPYBB)                                /*067582*/
             MONMSG     MSGID(CPF0000)                                /*067582*/
             DLTOVR     FILE(FT0525P1)                               /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*067582*/
/************MONMSG     MSGID(CPF9841)                         /*S01117 067582*/
/**/                                                                 /*S01117*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
