/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT OUTGOING PAYMENTS UNAUTHORISED - ORBR')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                           */
/*                                                                   */
/*       FTC0516  - CL Component to control FT0515                   */
/*                  Outgoing Payments Reporting.                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01494             Date 25May94              */
/*                      067582             Date 25Feb94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastracture    */
/*       S01494 - BLI Funds Transfer Enhancements                    */
/*       067582 - SHOULD CLOSE OPENED FILE AFTER USE, OTHERWISE      */
/*                PROGRAM FALLS OVER IF THERE ARE DETAILS TO BE      */
/*                REPORTED FOR MORE THAN ONE BRANCH.                 */
/*              - ADD ABNOR PROCESSING                               */
/*                                                                   */
/*********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
        PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
        DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
        DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
        DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
        DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/*******DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                                      */ /*CCB020*/
             DCL        VAR(&RNTP) TYPE(*CHAR) LEN(7)                /*S01494*/
/**/                                                                                      /*CCB020*/
/**  Parameters for call to CBC001001  */                                                 /*CCB020*/
/**/                                                                                      /*CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                             /*067582*/
/**/
      CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD LOCAL +
                          DATA AREA EQUIVALENT') AUT(*USE))
/**/
        CHGJOB     SWS(XXXXXX00)
/************************************************************************              */ /*CCB020*/
/***retreive*data*area*MPHAS*********************************************              */ /*CCB020*/
/************************************************************************              */ /*CCB020*/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
                                                                                          /*CCB020*/
/**/                                                                                      /*CCB020*/
/* Call program CBC001001 to check if program is in COB or IC */                          /*CCB020*/
/* If the return value is *YES, system is in COB */                                       /*CCB020*/
/**/                                                                                      /*CCB020*/
                                                                                          /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
                                                                                          /*CCB020*/
/*******IF* COND(%SST(&MPHAS 1 1) *NE 'A' *AND +                                          /*CCB020*/
/**********      %SST(&MPHAS 1 1) *NE 'C' *AND +                                          /*CCB020*/
/**********      %SST(&MPHAS 1 1) *NE 'D' *AND +                                          /*CCB020*/
/**********      %SST(&MPHAS 1 1) *NE 'F') THEN(DO)                                       /*CCB020*/
/**********  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA('Program +
                          cannot be run at this time') TOPGMQ(*EXT)                    */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
/**/
/** SET UP OVER RIDES **/
/**/
             IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(NOTPYBB) TOFILE(NOTPYOB) POSITION(*KEY 1 +
                          *N &RENT)
             OPNDBF     FILE(NOTPYBB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(NOTPYBB) +
                          POSITION(*END))
             ENDDO
             ELSE       CMD(OVRDBF FILE(NOTPYBB) TOFILE(NOTPYOB))
/**/
/** call program **/
/**/
             CHGVAR     VAR(&RNTP) VALUE('FTM2513')                  /*S01494*/
/*******CALL       PGM(FT0515) PARM('O' &RSEQ &RLEV &RENT) ********/ /*S01494*/
        CALL       PGM(FT0515) PARM('O' &RSEQ &RLEV &RENT &RNTP)     /*S01494*/
/**/
/** check for database errors trapped by program **/
/**/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)
/**********  IF  COND(%SST(&MPHAS 1 1) = 'C') THEN( +
/**********      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
/**********        TOMSGQ(MRUNQ MOPERQ))                                               */ /*CCB020*/
             IF  COND(&COBST = '*YES') THEN( +
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
/**********  IF    COND(%SST(&MPHAS 1 1) = 'C') THEN( +                                   /*CCB020*/
/**********          SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +                           */ /*CCB020*/
/**********             TOMSGQ(MRUNQ MOPERQ))                                          */ /*CCB020*/
             IF    COND(&COBST = '*YES') THEN( +
                     SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                        TOMSGQ(MRUNQ MOERQ))                                              /*CCB020*/
             ELSE  CMD( +
                     SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ))
        ENDDO
/**/                                                                  /*067582*/
             GOTO       CMDLBL(END)                                   /*067582*/
ABNOR:                                                                /*067582*/
/**/                                                                  /*067582*/
             SNDPGMMSG  MSG('FT0515 - Unauthorised Outgoing Payments +
                          report terminated abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*067582*/
             CHGJOB     SWS(XXXXXX11)                                 /*067582*/
/**/                                                                  /*067582*/
END:                                                                  /*067582*/
/**/
/** delete override **/
/**/
             DLTOVR     FILE(NOTPYBB)
             MONMSG     MSGID(CPF0000)                                /*067582*/
/************MONMSG     MSGID(CPF9841)                                /*067582*/
             CLOF       OPNID(NOTPYBB)                                /*067582*/
             MONMSG     MSGID(CPF0000)                                /*067582*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
