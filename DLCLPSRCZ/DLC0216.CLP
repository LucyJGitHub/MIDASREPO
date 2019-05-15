/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Deal Amendments Input Today - I/c')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0216  - LIST OF DEAL AMENDMENTS INPUT TODAY - I/C ON REQ*/
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01471             Date 26Mar94              */
/*                      E47380             Date 1FEb93               */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       S01471 - ACCESS LDA FOR DETAILS OF DATABASE ERRORS         */
/*       E47380 - CREATED SO AVAILABLE ON REQUEST IN INPUT CYCLE    */
/********************************************************************/
             PGM PARM(&TYPE &RSEQ &RLEV &RENT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)*/
   DCL VAR(&TYPE) TYPE(*CHAR) LEN(2) /* MM, FX, or ALL '  '*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01471*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01471*/
   CHGVAR  VAR(&RENT) VALUE(ALL)
             CALL       PGM(DL0215) PARM(&RSEQ &RENT)
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
