/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT NOSTRO TRANSFERS UNAUTHORISED - ORBR')       */
/********************************************************************/
/*                                                                  */
/*       Midas       FUNDS TRANSFER MODULE                      */
/*                                                                  */
/*       FTC0536  - CL COMPONENT TO CONTROL FT0535                  */
/*                  NOSTRO TRANSFER LIST                            */
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
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       067582 - SHOULD CLOSE OPENED FILE AFTER USE, OTHERWISE     */
/*                PROGRAM FALLS OVER IF THERE ARE DETAILS TO BE     */
/*                REPORTED FOR MORE THAN ONE BRANCH.                */
/*              - ADD ABNOR PROCESSING                              */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
        DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
        DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
        DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
        DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/*******DCL   VAR(&MPHAS) TYPE(*CHAR)   LEN(1)                                         */ /*CCB020*/
        DCL   VAR(&CBFLG) TYPE(*CHAR)   LEN(4)                                            /*CCB020*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                             /*067582*/
/**/                                                                 /*S01194*/
      CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD LOCAL +
                          DATA AREA EQUIVALENT') AUT(*USE))
/**/
        CHGJOB     SWS(XXXXXX00)
/**/
/***RETREIVE*DATA*AREA*MPHAS***/                                                          /*CCB020*/
/**/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
/**/                                                                                      /*CCB020*/
/** CBFLAGQT Phase Check  **/                                                             /*CCB020*/
/**/                                                                                      /*CCB020*/
             CALL       PGM(CBC001001) PARM(&CBFLG)                                       /*CCB020*/
 
 
/*******IF  COND(%SST(&MPHAS 1 1) *NE 'A' *AND +                                       */ /*CCB020*/
/**********      %SST(&MPHAS 1 1) *NE 'C' *AND +                                       */ /*CCB020*/
/**********      %SST(&MPHAS 1 1) *NE 'D' *AND +                                       */ /*CCB020*/
/**********      %SST(&MPHAS 1 1) *NE 'F') THEN(DO)                                    */ /*CCB020*/
/**********  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA('Program +
                          cannot be run at this time') TOPGMQ(*EXT)                    */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
 
/**/
/** SET UP OVER RIDES **/
/**/
           IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(NNTRNBB) TOFILE(NNTRNOB) POSITION(*KEY 1 +
                          *N &RENT)
             OPNDBF     FILE(NNTRNBB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(NNTRNBB) +
                          POSITION(*END))
           ENDDO
           ELSE       CMD(OVRDBF FILE(NNTRNBB) TOFILE(NNTRNOB))
/**/
/** CALL PROGRAM **/
/**/
        CALL       PGM(FT0535) PARM('O' &RSEQ &RLEV &RENT)
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)
/**********  IF  COND(%SST(&MPHAS 1 1) = 'C') THEN( +                                  */ /*CCB020*/
/**********      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +                  */ /*CCB020*/
/**********        TOMSGQ(MRUNQ MOPERQ))                                               */ /*CCB020*/
             IF  COND(&CBFLG *EQ '*YES') THEN(SNDPGMMSG +
                 MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOMSGQ(MRUNQ MOPERQ))                                                  /*CCB020*/
             ELSE  CMD( +
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOPGMQ(*EXT) TOMSGQ(MOPERQ))
        ENDDO
/**/
/** CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM    **/
/**/
        IF   COND(%SWITCH(XXXXXX01))   THEN(DO)
/**********  IF    COND(%SST(&MPHAS 1 1) = 'C') THEN( +                                */ /*CCB020*/
/**********          SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +                           */ /*CCB020*/
/**********             TOMSGQ(MRUNQ MOPERQ))                                          */ /*CCB020*/
             IF  COND(&CBFLG *EQ '*YES') THEN(SNDPGMMSG +
                 MSGID(MEM0002) MSGF(MIDAS) TOMSGQ(MRUNQ MOPERQ))                         /*CCB020*/
             ELSE  CMD( +
                     SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ))
        ENDDO
/**/                                                                  /*067582*/
             GOTO       CMDLBL(END)                                   /*067582*/
ABNOR:                                                                /*067582*/
/**/                                                                  /*067582*/
             SNDPGMMSG  MSG('FT0535 - Unauthorised Nostro Transfers +
                          report terminated abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*067582*/
             CHGJOB     SWS(XXXXXX11)                                 /*067582*/
/**/                                                                  /*067582*/
END:                                                                  /*067582*/
/** delete overrides **/                                              /*067582*/
/**/
             DLTOVR     FILE(NNTRNBB)
             MONMSG     MSGID(CPF0000)                                /*067582*/
/************MONMSG     MSGID(CPF9841)                         /*S01117 067582*/
             CLOF       OPNID(NNTRNBB)                                /*067582*/
             MONMSG     MSGID(CPF0000)                                /*067582*/
/**/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             ENDPGM
