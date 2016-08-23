/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Stock Register Report')                         */
/*******************************************************************/
/*                                                                 */
/*       Midas     - STANDING DATA MODULE                      */
/*                                                                 */
/*        SDC0935 - Stockregister list                             */
/*                                                                 */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                 */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*          LAST AMEND : S01469         DATE : 12MAR93             */
/*                                                                 */
/*-----------------------------------------------------------------*/
/*                                                                 */
/* S01469 - GERMAN FEATURE INCORPORATED TO RELEASE 10                */
/*                                                                 */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TYPE &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF +
                          sequence number */
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level +
                          flag (S/C/B)*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity +
                          code (all/comp/bch)*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             MONMSG MSGID(CPF0000 MCH0000 RPG0000) +
                         EXEC(GOTO CMDLBL(ERROR))
             CHGJOB     SWS(00000000)
/**/
/*     CREATE A TEMPORARY LDA                */
/**/
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(*BLANKS) TEXT('Temporary data area +
                          for SD0935 report pgm')
               MONMSG     MSGID(CPF1023)
/**/
             SNDPGMMSG  MSG('SDC0935 - Stock Register Report') +
                          TOMSGQ(MRUNQ)
 
/* IF MANDATORY MONTHLY REPORT SWITCH ON U2 */
 
             IF         COND(&TYPE *EQ 'C') THEN(CHGJOB SWS(01000000))
 
/*  REPORT BY SYSTEM  */
 
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CALL PGM(SD0935) PARM(&RSEQ))
 
/*  REPORT BY BRANCH  */
 
             IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(SD0936) +
                        PARM(&RSEQ &RENT))
 
/*  REPORT BY COMPANY */
 
             IF         COND(&RLEV *EQ 'C') THEN(CALL PGM(SD0937) +
                        PARM(&RSEQ &RENT))
 
ERROR:
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG  MSG('SDC0935 - Stock Register Report +
                           terminated abnormally') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
