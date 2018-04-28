/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF Dealing Confirmations status enq.')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - CONFIRMATION MATCHING                       */
/*                                                                   */
/*       CFC0040 - DEALING CONFIRMATIONS STATUS ENQUIRY CONTROL      */
/*                 (CALLED FROM MITEMDD, CALLS CF0040)               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01310            DATE 03JUN91               */
/*       PREV AMEND NO. S01259            DATE 28JAN91               */
/*                      S01184            DATE 15DEC89               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01310 - SWIFT RATIONALIZATION                              */
/*       S01259 - SWIFT II ON CALL CF0189 ELSE CF0040                */
/*       S01184 - CREATED FOR CONFIRMATION MATCHING                  */
/*                                                                   */
/*********************************************************************/
     PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SWII) TYPE(*CHAR) LEN(1)           /*S01259S01310*/
 
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
             CHGJOB     SWS(00000000)
 
/*  Call main DEALING CONFIRMATIONS STATUS REPORT program            */
 
/************RTVDTAARA**DTAARA(MMOD (95 1)) RTNVAR(&SWII)       /*S01259S01310*/
                                                                      /*S01259*/
/***If*SWIFT*II*off*call*CF0040                                 /*S01259S01310*/
/************IF*********COND(&SWII *NE 'Y') THEN(DO)            /*S01259S01310*/
/************CALL*******PGM(CF0040)                             /*S01310S01310*/
/************ENDDO*********                                     /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/***If*SWIFT*II*on*call*CF0189                                  /*S01259S01310*/
/************IF*********COND(&SWII *EQ 'Y') THEN(DO)            /*S01259S01310*/
/*/COPY WNCPYSRC,CFC0040001                                          */
             CALL       PGM(CF0189)                                   /*S01259*/
/*/COPY WNCPYSRC,CFC0040002                                          */
/************ENDDO*********                                     /*S01259S01310*/
                                                                      /*S01259*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERRDTA)
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                SNDPGMMSG  MSG('Job Terminated - Database in Error') +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                GOTO (ABNOR)
             ENDDO
 
             GOTO (END)
 
 ABNOR:      SNDPGMMSG  MSG('CFC0040 ENDED ABNORMALLY') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
