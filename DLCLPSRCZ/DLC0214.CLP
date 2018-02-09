/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Today's Deals Rep -I/C On Request')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                                */
/*                                                                  */
/*       DLC0214  - LIST OF TODAY'S DEALS - INPUT CYCLE REPORT      */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL038             Date 10May05              */
/*                      CDL021             Date 03Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408                  Date  19AUG96       */
/*                      S01471                  DATE  26MAR94       */
/*                      045714                  DATE  12OCT92       */
/*                      AUS016                  DATE  14SEP92       */
/*                      E315                    DATE  3APR90        */
/*                      E263                    DATE  14MAR90       */
/*                      S01194                  DATE  11/08/89      */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       CDL038 - Extended Deal Sub Type                            */
/*       CDL021 - Reports by Deal Type                              */
/*       S01408 - Core Hook DLC0214001 Added                        */
/*       S01471 - SEND MESSAGE TO MOPERQ WHEN DATABASE ERROR OCCURS */
/*       045714 - CORRECT INPUT PARAMETERS FOR DL0205               */
/*       AUS016  -  FX/MM List of Today's Deals                     */
/*                  included TYPE (MM, FX, or '  ') as parameter    */
/*       E315   - CORRECT INPUT PARMS AS RCF CHANGES AGAIN          */
/*       E263   - PROG SHOULD RECEIVE SEQUENCE NO. AND LEVEL PARMS  */
/*       S01194 - NEW STANDING DATA FILES                           */
/********************************************************************/
/************PGM                                                        E263*/
/************PGM PARM(&RSEQ &RLEV)                               /*E263 E315*/
/************PGM PARM(&RSEQ &RLEV &RENT)                  */ /*E315*/ /*AUS016*/
/*********** PGM PARM(&TYPE &RSEQ &RLEV &RENT) */                                  /*AUS016 CDL021*/
             PGM PARM(&TYPE &RSEQ &RLEV &RENT &PARMS)                                     /*CDL021*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*E263*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*E263*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
   DCL VAR(&TYPE) TYPE(*CHAR) LEN(2) /* MM, FX, or ALL '  '           /*AUS016*/
/**DCL*VAR(&PARMS)*TYPE(*CHAR)*LEN(4)********************************************CDL021*/ /*CDL038*/
   DCL VAR(&PARMS) TYPE(*CHAR) LEN(8)                                                     /*CDL038*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01471*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01471*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*S01471*/
             RTVJOBA    SWS(&SWS)
             CHGVAR     VAR(&SWS) VALUE('10000000')
             CHGJOB     SWS(&SWS)
                                                                      /*S01471*/
/* CHECK IF S01471 IS SWITCHED ON AND IF SO, OVERIDE OVERFLOW FOR +
   PRINTERFILE DL0205P1 TO 51 */                                      /*S01471*/
                                                                      /*S01471*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE '*VERIFY' +
                          'S01471' '')                                /*S01471*/
                                                                      /*S01471*/
             IF         COND(&RTNCDE *EQ '       ') THEN(OVRPRTF +
                          FILE(DL0205P1) OVRFLW(51))                  /*S01471*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,DLC0214001                                           /*S01408*/
/*                                                                    /*S01408*/
                                                                      /*S01471*/
/************OVRDBF     FILE(TABLE) TOFILE(TABDLEE)   /*E0052*/       /*S01194*/
/************CALL       PGM(DL0205)                                     E263*/
/************CALL       PGM(DL0205) PARM(&RSEQ)           */ /*E263*/ /*AUS016*/
/************CALL       PGM(DL0205) PARM(&TYPE &RSEQ)        /*AUS016* *045714*/
/*********** CALL       PGM(DL0205) PARM(&TYPE &RSEQ &RENT) */                     /*045714 CDL021*/
             CALL       PGM(DL0205) PARM(&TYPE &RSEQ &RENT &PARMS)                        /*CDL021*/
/*/COPY WNCPYSRC,DLC0214002                                          */
/************DLTOVR     FILE(TABLE)                                   /*S01194*/
/*   ERROR MESSAGES                                           */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
/***************SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)************/ /*S01471*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01471*/
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))      /*S01471*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)                              /*S01471*/
             ENDDO
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
