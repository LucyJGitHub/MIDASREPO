/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Run Reconciliation Reports')                 */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0606J - RUN RECONCILIATION PROGRAMS                     */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 196904             Date 15Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CDL008             Date 02May00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01502             DATE 08JUL94              */
/*                      S01117             DATE 10DEC90              */
/*                      E22046             DATE 15JUN89              */
/*                      E22486             DATE 14JUN89              */
/*                      E18881             DATE 10JUL89              */
/*                                                                   */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       196904 - Remove CDL008 as not appropriate                   */
/*       CDL008 - Continuous Linked Settlement                        */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*      S01117 - MULTIBRANCHING                                     */
/*      E22046 - Customer reconciliations not required if portfolio */
/*                clients not licensed.                             */
/*      E22486 - Label 'ERROR' stops pgm compiling with IBM OS/400  */
/*               release 2.                                         */
/*      E18881 - Creation parameters missing. Also the              */
/*               reconciliation report shows files out of balance   */
/*               due to a coding error in this pgm.                 */
/*                                                                  */
/********************************************************************/
/**/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(55)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&ECOUNT1) TYPE(*CHAR) LEN(5) VALUE(' ')
             DCL        VAR(&ECOUNT2) TYPE(*CHAR) LEN(5) VALUE(' ')
             DCL        VAR(&ECOUNT3) TYPE(*CHAR) LEN(5) VALUE(' ')
             DCL        VAR(&ECOUNT4) TYPE(*CHAR) LEN(5) VALUE(' ')
             DCL        VAR(&ECNTN1) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&ECNTN2) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&ECNTN3) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&ECNTN4) TYPE(*DEC) LEN(5 0) VALUE(0)
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(128)*/    /*E22046 S01502*/
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)             /*S01502*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) VALUE('     ')  /*S01117*/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                /*E22046*/
 
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0606J - Reconciliation +
                          reports')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
 
/* CLEAR WORK FILES */
 
             CLRPFM     FILE(REC01D)
             CLRPFM     FILE(REC02D)
 
/*  CALL EXTRACT AND REPORT PROGRAMS TO RECONCILE DEPOT POSITIONS */
 
             CALL       PGM(SE2605)
/************CALL       PGM(SE2610) PARM(&ECOUNT1)                   * *S01117*/
             CALL       PGM(SE2610) PARM(&ECOUNT1 &RSEQ)              /*S01117*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
/*ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              E22486*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*           RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0606J - Job Terminated, +
                          Database in Error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/*  CALL EXTRACT AND REPORT PROGRAMS TO RECONCILE CUSTOMER POSITIONS */
/*  IF PORTFOLIO CLIENTS HAVE BEEN LICENSED.                          /*E22046*/
 
           IF         COND(%SST(&SESTAT 64 1) = 'Y') THEN( +
             DO)                                                      /*E22046*/
             CALL       PGM(SE2615)
/************CALL       PGM(SE2620) PARM(&ECOUNT2)                   * *S01117*/
             CALL       PGM(SE2620) PARM(&ECOUNT2 &RSEQ)              /*S01117*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
/*ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              E22486*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*           RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0606J - Job Terminated, +
                          Database in Error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/*  CALL PROGRAM TO RECONCILE CUSTOMER MOVEMENTS */
 
/************CALL       PGM(SE2630) PARM(&ECOUNT3)                   * *S01117*/
             CALL       PGM(SE2630) PARM(&ECOUNT3 &RSEQ)              /*S01117*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
/*ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              E22486*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*           RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0606J - Job Terminated, +
                          Database in Error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
           ENDDO                                                      /*E22046*/
 
/*  CALL PROGRAM TO RECONCILE BOOK/DEPOT POSITIONS */
 
/************CALL       PGM(SE2640) PARM(&ECOUNT4)                   * *S01117*/
             CALL       PGM(SE2640) PARM(&ECOUNT4 &RSEQ)              /*S01117*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
/*ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              E22486*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*           RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0606J - Job Terminated, +
                          Database in Error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* CHECK FOR DEPOT POSITIONS OUT OF BALANCE */
 
             CHGVAR     VAR(&ECNTN1) VALUE(&ECOUNT1)
             IF         COND(&ECNTN1 *NE 0) THEN(DO)
             CHGVAR     VAR(&MEM) VALUE(' ')
             CHGVAR     VAR(%SST(&MEM 1 10)) VALUE('SEC0606J -')
             CHGVAR     VAR(%SST(&MEM 12 5)) VALUE(&ECOUNT1)
             CHGVAR     VAR(%SST(&MEM 18 30)) VALUE('DEPOT POSITIONS +
                          DO NOT BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* CHECK FOR CUSTOMER POSITIONS OUT OF BALANCE */
/*  IF PORTFOLIO CLIENTS HAVE BEEN LICENSED.                          /*E22046*/
 
           IF         COND(%SST(&SESTAT 64 1) = 'Y') THEN( +
             DO)                                                      /*E22046*/
             CHGVAR     VAR(&ECNTN2) VALUE(&ECOUNT2)
             IF         COND(&ECNTN2 *NE 0) THEN(DO)
             CHGVAR     VAR(&MEM) VALUE(' ')
             CHGVAR     VAR(%SST(&MEM 1 10)) VALUE('SEC0606J -')
             CHGVAR     VAR(%SST(&MEM 12 5)) VALUE(&ECOUNT2)
             CHGVAR     VAR(%SST(&MEM 18 33)) VALUE('CUSTOMER +
                          POSITIONS DO NOT BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* CHECK FOR CUSTOMER MOVEMENTS OUT OF BALANCE */
 
             CHGVAR     VAR(&ECNTN3) VALUE(&ECOUNT3)
             IF         COND(&ECNTN3 *NE 0) THEN(DO)
             CHGVAR     VAR(&MEM) VALUE(' ')
             CHGVAR     VAR(%SST(&MEM 1 10)) VALUE('SEC0606J -')
             CHGVAR     VAR(%SST(&MEM 12 5)) VALUE(&ECOUNT3)
             CHGVAR     VAR(%SST(&MEM 18 33)) VALUE('CUSTOMER +
                          MOVEMENTS DO NOT BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
           ENDDO                                                      /*E22046*/
 
/* CHECK FOR BOOK/DEPOT POSITIONS OUT OF BALANCE */
 
             CHGVAR     VAR(&ECNTN4) VALUE(&ECOUNT4)
             IF         COND(&ECNTN4 *NE 0) THEN(DO)
             CHGVAR     VAR(&MEM) VALUE(' ')
             CHGVAR     VAR(%SST(&MEM 1 10)) VALUE('SEC0606J -')
/*           CHGVAR     VAR(%SST(&MEM 12 5)) VALUE(&ECOUNT3)          /*E18881*/
             CHGVAR     VAR(%SST(&MEM 12 5)) VALUE(&ECOUNT4)          /*E18881*/
             CHGVAR     VAR(%SST(&MEM 18 33)) VALUE('BOOK POSITIONS +
                          DO NOT BALANCE')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* IF ANY ERRORS, HALT END OF DAY */
 
             CHGJOB     SWS(XXXXXXX0)
/************IF         COND((&ECNTN1 *NE 0) *OR (&ECNTN2 *NE 0) *OR +
                          (&ECNTN3 *NE 0) *OR (&ECNTN4 *NE 0)) +
                          THEN(CHGJOB SWS(XXXXXXX1))                  **CDL008*/
 
             IF         COND((&ECNTN1 *NE 0) *OR (&ECNTN2 *NE 0) *OR +
                          (&ECNTN3 *NE 0) *OR (&ECNTN4 *NE 0)) +
                          THEN(CHGJOB SWS(XXXXXXX1))                  /*196904*/
 
/*ENDPGM:*********ENDPGM                                             * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
