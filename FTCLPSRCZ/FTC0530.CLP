/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT NOSTRO TRANSFERS AUDIT AND LIST- BRCA')      */
/********************************************************************/
/*                                                                  */
/*       Midas     - FUNDS TRANSFER MODULE                      */
/*                                                                  */
/*       FTC0530  - CL COMPONENT TO CONTROL FT0530                  */
/*                  NOSTRO TRANSFER AUDIT/LIST                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CCB020            Date 06Aug12               */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. 191537            Date   27Mar01            */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      067582            Date   25Feb94            */
/*                      S01117            Date   05Oct90            */
/*                      S01194            DATE   05OCT90            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       191537 - Loops in ABNOR processing.                        */
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
/*******DCL   VAR(&MPHAS) TYPE(*CHAR)   LEN(1)                                            /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                                          /*CCB020*/
/* Parameter for call to CBC001001 */                                                     /*CCB020*/
             DCL        VAR(&WCOB) TYPE(*CHAR) LEN(4)                                     /*CCB020*/
 
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
/***RETREIVE*DATA*AREA*MPHAS***/                                                          /*CCB020*/
/**/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)               */                     /*CCB020*/
                                                                                          /*CCB020*/
/* Call program CBC001001 to check if program is in COB or IC */                          /*CCB020*/
/* If the return value is *YES, system is in COB */                                       /*CCB020*/
                                                                                          /*CCB020*/
             CALL       PGM(CBC001001) PARM(&WCOB)                                        /*CCB020*/
/**/
/**     IF  COND(%SST(&MPHAS 1 1) = 'C') THEN( +                 **/ /*S01117*/
/**      SNDPGMMSG  MSG('FT0530 -  Nostro Transfers Audit List') + **/
/**                TOMSGQ(MRUNQ))                                **/
/*****IF  COND((%SST(&MPHAS 1 1) = 'C') *AND (&TYPE *EQ 'A')) THEN( +*/                   /*CCB020*/
      IF  COND((&WCOB = '*YES') *AND (&TYPE *EQ 'A')) THEN( +
            SNDPGMMSG  MSG('FT0530 -  Nostro Transfers Audit List') +
                   TOMSGQ(MRUNQ))                                                  /*S01117 CCB020*/
/**/                                                                 /*S01117*/
/** set up override **/                                              /*S01117*/
/**/                                                                 /*S01117*/
          IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO) /*S01117*/
             OVRDBF     FILE(NTRANBB) POSITION(*KEY 1 *N &RENT)
             OPNDBF     FILE(NTRANBB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(NTRANBB) +
                          POSITION(*END))
           ENDDO                                                     /*S01117*/
/**/
/** CALL PROGRAM **/
/**/
/**     CALL       PGM(FT0530) PARM(&TYPE)                           /*S01117*/
        CALL       PGM(FT0530) PARM(&RSEQ &RLEV &RENT &TYPE)         /*S01117*/
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
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
/** CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM    **/
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
/**/                                                                  /*067582*/
             GOTO       CMDLBL(END)                                   /*067582*/
ABNOR:                                                                /*067582*/
/**/                                                                  /*067582*/
/************SNDPGMMSG  MSG('FT0530 -  Nostro Transfers Audit List +   *191537*/
/************             terminated abnormally') TOMSGQ(OPERQ +       *191537*/
/************             MRUNQ)                             /*067582* *191537*/
             SNDPGMMSG  MSG('FT0530 -  Nostro Transfers Audit List +
                          terminated abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*191537*/
             MONMSG     MSGID(CPF0000)                                /*191537*/
             CHGJOB     SWS(XXXXXX11)                                 /*067582*/
             MONMSG     MSGID(CPF0000)                                /*191537*/
/**/                                                                  /*067582*/
END:                                                                  /*067582*/
/** delete overrides **/                                             /*S01117*/
/**/                                                                 /*S01117*/
             DLTOVR     FILE(NTRANBB)                                /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*067582*/
/************MONMSG     MSGID(CPF9841)                         /*S01117 067582*/
             CLOF       OPNID(NTRANBB)                                /*067582*/
             MONMSG     MSGID(CPF0000)                                /*067582*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             ENDPGM
