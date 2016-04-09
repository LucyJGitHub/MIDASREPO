/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Dealing Events Generation (COB)')            */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0690  -  DEALING EVENTS GENERATION (COB)                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. 112020             DATE 27FEB97                  */
/*   PREV AMEND NO. S01393             DATE 21SEP92                  */
/*                  S01220             DATE 06AUG92                  */
/*                  S01117             DATE 17APR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   112020  -  AVOID LOCKING PROBLEMS ON FOEVED                     */
/*   S01393  -  Upgrade Strategic Risk Management to R10             */
/*              Always generate RM events. Remove RM0009             */
/*   S01220  -  STRATEGIC RISK MANAGEMENT AMENDMENT: Dealing events  */
/*              generation is required by SRM therefore call to      */
/*              FF0500 is now additionally executed if an RM Run is  */
/*              required. RM Run requirement is determined by a call */
/*              to RM0009 which returns 'Y' or 'N' to the program    */
/*              variable &RMRUN.                                     */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &HPEI         TYPE(*CHAR)  LEN(1)
             DCL        &MMOD         TYPE(*CHAR)  LEN(256)
             DCL        &RMRUN        TYPE(*CHAR)  LEN(1) VALUE('N') /*S01220*/
                                                                     /*S01220*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*   DECLARE FILE                                                   */
/**/
             DCLF       FILE(TABTB80) RCDFMT(TABTB80F)
/**/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDMSG     MSG('FFC0690 - Dealing +
                          Events Generation') TOMSGQ(MRUNQ)
/**/
/*   TEST FOR DEALING MODULE - BYTE 2 OF MMOD                       */
/**/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)
/**/
             IF         COND(%SST(&MMOD 2 1) *NE 'Y') THEN(GOTO END)
/**/
 FOICD:      RCVF       DEV(*FILE) RCDFMT(TABTB80F)
             MONMSG     MSGID(CPF0861) EXEC(GOTO TB80)
/**/
             IF         COND(&RECI *NE 'D') THEN(GOTO FOICD)
 
/****If*the*Risk*Management*module*is*on*determine*if*an*RM*RunS01220* S01393*/
/****is*required*(NEXT*RM*Run*Date*<*Date*of*Next*working*day)*S01220* S01393*/
/****(If*a*database*error*occurs*in*called*program*retrieve*datS01220* S01393*/
/****from*LDA*and*send*message*to*MOPERQ*and*MRUNQ.)***********S01220* S01393*/
/**************************************************************        S01393*/
/*********** IF         COND(%SST(&MMOD 63 1) *EQ 'Y') THEN(DO)S01220* S01393*/
/***********                                                           S01393*/
/***********     CALL       PGM(RM0009) PARM(&RMRUN)           S01220* S01393*/
/***********                                                           S01393*/
/***********     IF         COND(%SWITCH(XXXXXX11)) THEN(DO)   S01220* S01393*/
/***********         RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MES01220* S01393*/
/***********         SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +           S01393*/
/***********                    MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNS01220* S01393*/
/***********         GOTO       CMDLBL(END)                    S01220* S01393*/
/***********                                                           S01393*/
/***********     ENDDO                                         S01220* S01393*/
/***********                                                           S01393*/
/*********** ENDDO                                             S01220* S01393*/
/*************/                                                      /*S01220*/
/****IF*HEDGED*POSITIONS*IN*EVENTS*INDICATOR*(HPEI*ON*TABTB80)<>'Y*/ /*S01220*/
/*************/                                                      /*S01220*/
/************IF         COND(&HPEI *NE 'Y') THEN(GOTO END)        */ /*S01220*/
                                                                     /*S01393*/
/*   Always run RM events generation                              */ /*S01393*/
                                                                     /*S01393*/
             CHGVAR     VAR(&RMRUN) VALUE('Y')                       /*S01393*/
                                                                     /*S01393*/
/*   If Hedged Positions in Events Indicator (HPEI ON TABTB80)    */ /*S01220*/
/*   = 'Y' or RM RUN Required = 'Y'                               */ /*S01220*/
 
             IF         COND(&HPEI *EQ 'Y' *OR &RMRUN *EQ 'Y') +
                        THEN(DO)                                     /*S01220*/
/**/
/*   CLEAR FILE                                                    */
/**/
 ALC1:       ALCOBJ     OBJ((FOEVED *FILE *EXCL)) WAIT(5)            /*112020*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ALC1))       /*112020*/
             DLCOBJ     OBJ((FOEVED *FILE *EXCL))                    /*112020*/
             CLRPFM     FOEVED
             CLRPFM     FOEVEZZ
/**/                                                                 /*S01220*/
/*   IF RM RUN IS REQUIRED, CLEAR THE RM EVENTS FILE              */ /*S01220*/
/**/                                                                 /*S01220*/
             IF         COND(&RMRUN *EQ 'Y') THEN(DO)                /*S01220*/
                CLRPFM     RMFFEVP                                   /*S01220*/
             ENDDO                                                   /*S01220*/
/**/
/*   SET OFF ALL EXTERNAL SWITCHES                                  */
/**/
             CHGJOB     SWS(00000000)
/**/
/*   CALL FF0500 TO GENERATE DEALING EVENTS                        */
/**/
             CALL       PGM(FF0500)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/*  If Hedged Positions In Events Indicator is not equal to 'Y'   */ /*S01220*/
/*  the events generated by FF0500 are ONLY required by Risk      */ /*S01220*/
/*  Management:Therefore copy the events (from FOEVED) for Risk   */ /*S01220*/
/*  processing and then restore FF files to their original state. */ /*S01220*/
/*  (If Hedged Positions In Events Indicator IS equal to 'Y' the  */ /*S01220*/
/*  copy of events for Risk processing is executed during Risk    */ /*S01220*/
/*  Management COB Processing)                                    */ /*S01220*/
 
             IF         COND(&HPEI *NE 'Y') THEN(DO)                 /*S01220*/
 
                 CPYF       FROMFILE(FOEVED) TOFILE(RMFFEVP) +
                            MBROPT(*ADD) FMTOPT(*MAP *DROP)          /*S01220*/
                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)           /*S01220*/
 
                 CLRPFM     FOEVED                                   /*S01220*/
                 CLRPFM     FOEVEZZ                                  /*S01220*/
 
             ENDDO                                                   /*S01220*/
 
             ENDDO                                                   /*S01220*/
 
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF RECORD NOT FOUND ON PF/TABTB80            */
/**/
 TB80:       SNDPGMMSG  MSG('DATABASE IN ERROR IN PROGRAM FFC0690 +
                        , FILE TABTB80, KEY 01        10') +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
END:         ENDPGM
/**/
