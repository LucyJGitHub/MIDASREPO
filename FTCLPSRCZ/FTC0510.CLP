/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT OUTGOING PAYMENTS AUDIT AND LIST-BRCA')      */
/********************************************************************/
/*                                                                  */
/*       Midas     - Funds Transfer Module                          */
/*                                                                  */
/*       FTC0510  - CL Component to control FT0510                  */
/*                  Outgoing Payments Reporting.                    */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1060743          Date 26Nov12              */
/*                      CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01494             Date 25May94             */
/*                      067582             Date 25Feb94             */
/*                      S01117             DATE 03OCT90             */
/*                      S01194             DATE 03OCT90             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1060743 - All HATS input initial screen appears a        */
/*                   confirmation of NWDC processing                */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure    */
/*       S01494 - BLI Funds Transfer Enhancement.                   */
/*       067582 - SHOULD CLOSE OPENED FILE AFTER USE, OTHERWISE     */
/*                PROGRAM FALLS OVER IF THERE ARE DETAILS TO BE     */
/*                REPORTED FOR MORE THAN ONE BRANCH.                */
/*              - ADD ABNOR PROCESSING                              */
/*       S01117 - RELEASE 10 MULTIBRANCHING CHANGES                 */
/*       S01194 - STANDING DATA CHANGES                             */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**          PGM        PARM(&TYPE)                                  /*S01117*/
             PGM        PARM(&TYPE &RSEQ &RLEV &RENT)                /*S01117*/
 
/**     DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)                    /*S01194*/
        DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                    /*S01194*/
        DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                     /*S01117*/
        DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                     /*S01117*/
        DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                     /*S01117*/
        DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
        DCL        VAR(&RNTP) TYPE(*CHAR) LEN(7) VALUE('FTM2511')    /*S01494*/
/*******DCL   VAR(&MPHAS) TYPE(*CHAR)   LEN(1)                                        */ /*CCB020*/
        DCL   VAR(&MPHAS) TYPE(*CHAR)   LEN(4)                                           /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                     /*S01194*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                             /*067582*/
/**/
/** Check if LDA Data area exists and create it if not **/
/**/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))                 /*S01194*/
 
/**/
        CHGJOB     SWS(XXXXXX00)
/**/
/** retreive data area MPHAS **/
/**/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
/**********  CALL       PGM(CBC000001) PARM(&MPHAS)                             /*CCB020 AR1060743*/
             CALL       PGM(CBC001001) PARM(&MPHAS)                                    /*AR1060743*/
/**/
 
/**   IF  COND((%SST(&MPHAS 1 1) = 'C')  THEN( +                 **/ /*S01117*/
/**         SNDPGMMSG  MSG('FT0510 -  Outgoing Payments Audit List') + **/
/**                TOMSGQ(MRUNQ))                                      **/
/*****IF**COND((%SST(&MPHAS 1 1) = 'C') *AND (&TYPE *EQ 'A')) THEN( +                  */ /*CCB020*/
/********** SNDPGMMSG  MSG('FT0510 -  Outgoing Payments Audit List') +                 */ /*CCB020*/
/**********        TOMSGQ(MRUNQ))                                                      */ /*CCB020*/
      IF        COND((&MPHAS *EQ '*YES') *AND (&TYPE *EQ 'A')) THEN( +
            SNDPGMMSG  MSG('FT0510 -  Outgoing Payments Audit List') +
                   TOMSGQ(MRUNQ))                                                         /*CCB020*/
/**/
/** set up override**/
/**/
             IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(OTPAYBB) POSITION(*KEY 1 *N &RENT)
             OPNDBF     FILE(OTPAYBB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(OTPAYBB) +
                          POSITION(*END))
             ENDDO                                                   /*S01117*/
/**/
/** call program **/
/**/
/**     CALL       PGM(FT0510) PARM(&TYPE)                           /*S01117*/
/*******CALL       PGM(FT0510) PARM(&RSEQ &RLEV &RENT &TYPE)*/ /*S01117S01494*/
        CALL       PGM(FT0510) PARM(&RSEQ &RLEV &RENT &TYPE &RNTP)   /*S01494*/
/**/
/** check for database errors trapped by program **/
/**/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
/**          RTVDTAARA   DTAARA(LDA (134 44))   RTNVAR(&MEM)         /*S01194*/
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)         /*S01194*/
/**********  IF  COND(%SST(&MPHAS 1 1) = 'C') THEN( +                                  */ /*CCB020*/
/**********      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +                  */ /*CCB020*/
/**********        TOMSGQ(MRUNQ MOPERQ))                                               */ /*CCB020*/
             IF  COND(&MPHAS *EQ '*YES') THEN( +
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
/**********  IF    COND(%SST(&MPHAS 1 1) = 'C') THEN( +                                */ /*CCB020*/
/**********          SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +                           */ /*CCB020*/
/**********             TOMSGQ(MRUNQ MOPERQ))                                          */ /*CCB020*/
             IF    COND(&MPHAS *EQ '*YES') THEN( +
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
             SNDPGMMSG  MSG('FT0510 -  Outgoing Payments Audit List +
                          terminated abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*067582*/
/**/                                                                  /*067582*/
             CHGJOB     SWS(XXXXXX11)                                 /*067582*/
/**/                                                                  /*067582*/
END:                                                                  /*067582*/
/** dlete overrides **/
/**/
             DLTOVR     FILE(OTPAYBB)
             MONMSG     MSGID(CPF0000)                                /*067582*/
/************MONMSG     MSGID(CPF9841)                                /*067582*/
             CLOF       OPNID(OTPAYBB)                                /*067582*/
             MONMSG     MSGID(CPF0000)                                /*067582*/
 
/**/                                                                 /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
