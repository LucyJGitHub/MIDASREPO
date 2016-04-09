/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Project Depot Position Events')              */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC1107 - PROJECT DEPOT POSITION EVENTS                    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 088939                  DATE  19AUG96       */
/*       PREV AMEND NO. S01117                  DATE  10JAN91       */
/*                      S01179                  DATE  16/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*         088939 - Call new program SE1465                         */
/*         S01117 - MULTIBRANCHING                                  */
/*         S01179 -     RELEASE                                     */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC1107 - Project Depot +
                          Position Events')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CLEAR OUTPUT FILES */
 
             CLRPFM     FILE(DPEVED)
             CLRPFM     FILE(DPEVEA)
 
/* OVERRIDE FILE USED IN CALLED PROGRAMS */
 
             OVRDBF     FILE(SECEF) SHARE(*NO)
 
/* CALL PROGRAM */
 
             CALL       PGM(SE1460)
             IF         COND(%SWITCH(XXXXXX01) *OR +
                          %SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(ERROR)) /*088939*/
/**/
/* Call new program that will process unsettled position           */ /*088939*/
/* settlements if due date falls on a holiday                      */ /*088939*/
/**/                                                                  /*088939*/
             CALL       PGM(SE1465)                                   /*088939*/
             IF         COND(%SWITCH(XXXXXX01) *OR +
                          %SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(ERROR)) /*088939*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********      RCVDTAARA  DTAARA(LDA)                      *********  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC1107 - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
              CHGVAR     VAR(&MEM) VALUE('SEC1107 - File Controls Out +
                          of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                ENDPGM
