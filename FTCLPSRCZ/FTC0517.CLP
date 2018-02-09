/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT Unauthorised Regular Payments Rpt')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                           */
/*                                                                   */
/*       FTC0517  - CL Component to control FT0515                   */
/*                  Regular Payments Reporting.                      */
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
/*                      101271             Date 22May96              */
/*                      S01494 *CREATE     DATE 25MAY94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastracture     */
/*       101271 - Corrected the file overrides for FT0516 report.    */
/*       S01494 - BLI Funds Transfer Enhancements                    */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RUNTYP &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&RUNTYP) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RNTP) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR)  LEN(1)                                */ /*CCB020*/
/**/                                                                                      /*CCB020*/
/**  Parameters for call to CBC001001  */                                                 /*CCB020*/
/**/                                                                                      /*CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
/**/
/** Global message monitoring **/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/** Create data area LDA if not yet existing **/
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD LOCAL +
                          DATA AREA EQUIVALENT') AUT(*USE))
/**/
             CHGJOB     SWS(XXXXXX00)
/************************************************************************              */ /*CCB020*/
/***Retrieve*data*area*MPHAS*********************************************              */ /*CCB020*/
/************************************************************************              */ /*CCB020*/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
/**/
/** Call program **/
/**/
/**/                                                                                      /*CCB020*/
/* Call program CBC001001 to check if program is in COB or IC */                          /*CCB020*/
/* If the return value is *YES, system is in COB */                                       /*CCB020*/
/**/                                                                                      /*CCB020*/
                                                                                          /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
                                                                                          /*CCB020*/
/**********  IF         COND(%SST(&MPHAS 1 1) = 'C') THEN(DO)                          */ /*CCB020*/
             IF         COND(&COBST = '*YES') THEN(DO)                                    /*CCB020*/
                CHGVAR     VAR(&TYPE) VALUE('A')
                OVRPRTF    FILE(FT0515P1) OUTQ(MPRINTAU)
             ENDDO
 
/**********  IF         COND(%SST(&MPHAS 1 1) *NE 'A' *AND +                           */ /*CCB020*/
/**********             %SST(&MPHAS 1 1) *NE 'C' *AND +                                */ /*CCB020*/
/**********             %SST(&MPHAS 1 1) *NE 'D' *AND +                                */ /*CCB020*/
/**********             %SST(&MPHAS 1 1) *NE 'F') THEN(DO)                             */ /*CCB020*/
/**********     SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA('Program +
                              cannot be run at this time') TOPGMQ(*EXT)                */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
/**/
/** Set up overrides **/
/**/
             CHGVAR     VAR(&RNTP) VALUE(%SST(&RUNTYP 1 7))
/* */                                                                 /*101271*/
/** Run type is a booking branch for audit                         */ /*101271*/
/* */                                                                 /*101271*/
             IF         COND(&RNTP *EQ 'FTM2514') THEN(OVRDBF +
                             FILE(NOTPYBB) TOFILE(NRPPYBB))           /*101271*/
/**/
/** Run type is a booking branch **/
/**/
             IF         COND(&RNTP *EQ 'FTM2517') THEN(DO)
                IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE +
                           '   '))  THEN(DO)
                  OVRDBF     FILE(NOTPYBB) TOFILE(NRPPYBB) +
                               POSITION(*KEY 1 *N &RENT)
                  OPNDBF     FILE(NOTPYBB) OPTION(*INP)
                  MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(NOTPYBB) +
                               TOFILE(NRPPYBB) POSITION(*END))
                ENDDO
                ELSE      CMD(OVRDBF FILE(NOTPYBB) TOFILE(NRPPYBB))
             ENDDO
/**/
/** Run type is an originating branch **/
/**/
             IF         COND(&RNTP *EQ 'FTM2518') THEN(DO)
                IF         COND((&RENT *NE 'ALL') *AND (&RENT *NE +
                           '   '))  THEN(DO)
                  OVRDBF     FILE(NOTPYBB) TOFILE(NRPPYOB) +
                               POSITION(*KEY 1 *N &RENT)
                  OPNDBF     FILE(NOTPYBB) OPTION(*INP)
                  MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(NOTPYBB) +
                               TOFILE(NRPPYOB) POSITION(*END))
                ENDDO
                ELSE      CMD(OVRDBF FILE(NOTPYBB) TOFILE(NRPPYOB))
             ENDDO
/**/
/** Printer file overrides **/
/**/
             OVRPRTF    FILE(FT0515P1) SPLFNAME(FT0516P1)
             OVRPRTF    FILE(FT0515AU) SPLFNAME(FT0516AU)
 
             CALL       PGM(FT0515) PARM(&TYPE &RSEQ &RLEV &RENT &RNTP)
/**/
/** Check for database errors trapped by program **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50))   RTNVAR(&MEM)
/**********     IF         COND(%SST(&MPHAS 1 1) = 'C') THEN( +
/**********        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
/**********                     TOMSGQ(MRUNQ MOPERQ))                                  */ /*CCB020*/
                IF         COND(&COBST = '*YES') THEN( +
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MRUNQ MOPERQ))                                     /*CCB020*/
                ELSE  CMD( +
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                 TOPGMQ(*EXT) TOMSGQ(MOPERQ))
             ENDDO
 
/**/
/** Check for FOOB errors trapped by program **/
/**/
             IF         COND(%SWITCH(XXXXXX01))   THEN(DO)
/**********     IF         COND(%SST(&MPHAS 1 1) = 'C') THEN( +
/**********        SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
/**********                     TOMSGQ(MRUNQ MOPERQ))                                  */ /*CCB020*/
                IF         COND(&COBST = '*YES') THEN( +
                   SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                                TOMSGQ(MRUNQ MOPERQ))                                     /*CCB020*/
                ELSE  CMD( +
                   SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ))
             ENDDO
/**/
             GOTO       CMDLBL(END)
ABNOR:
/**/
             SNDPGMMSG  MSG('FT0515 - Unauthorised Regular Payments +
                          report terminated abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             CHGJOB     SWS(XXXXXX11)
/**/
END:
/**/
             DLTOVR     FILE(NOTPYBB)
             MONMSG     MSGID(CPF0000)
             CLOF       OPNID(NOTPYBB)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(FT0515P1)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(FT0515AU)
             MONMSG     MSGID(CPF0000)
/**/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
