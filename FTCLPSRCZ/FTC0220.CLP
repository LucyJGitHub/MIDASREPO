/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Entry Generation')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas      FUNDS TRANSFER MODULE                        */
/*                                                                   */
/*       FTC0220    ENTRY GENERATION                                 */
/*                  ================                                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU013             Date 08Apr98              */
/*                      056031             Date 07Jun93              */
/*                      S01194               DATE  13DEC90           */
/*                      E22724               DATE  29JUL90           */
/*                      S01189               DATE  03JUL90           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CEU013 - EMU Account Postings Narrative                     */
/*                Add FT posting extension files GEFP1APD and        */
/*                GEFP2APD.                                          */
/*     056031  -  Add reclaim resources to free FT0005.              */
/*                Add blocking of FPKEY.                             */
/*                Call FT0220 with paramter                          */
/*                Combination of errors 041693,045014,042779         */
/*     S01194  -  NEW DATABASE ERROR HANDLING                        */
/*     E22724  -  MENTION IS MADE OF PROCESSING HALTING OR           */
/*                CONTINUING  IF  ACCOUNT KEYS ARE MISSING.          */
/*     S01189  -  COB IMPROVEMENTS PHASE 2                           */
/*                                                                   */
/*********************************************************************/
/*           PGM        PARM(&RECP)                                */ /*S01189*/
             PGM        PARM(&RECP &NAM &SEQ)                         /*S01189*/
/**/
/*           DCL        VAR(&DATA) TYPE(*CHAR) LEN(44)             */ /*S01194*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                /*S01194*/
             DCL        VAR(&RECP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MISSAC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)                 /*S01189*/
             DCL        VAR(&SEQ) TYPE(*DEC) LEN(5 0)                 /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,FTC0220002                                          */
             RTVDTAARA  DTAARA(FTSTAT (5 1)) RTNVAR(&MISSAC)
/*/COPY WNCPYSRC,FTC0220006                                          */
/**/
             SNDPGMMSG  MSG('FTC0220 - Funds Transfer Entry +
                          Generation') TOMSGQ(MRUNQ) /**/
             IF        ((&RECP = 'N')   +
                   *OR  (&RECP = 'S'))  +
             THEN(DO)
                CLRPFM     FILE(GEFPPD)
                CLRPFM     FILE(GEFPZZ)
                CLRPFM     FILE(GEFP1APD)                             /*CEU013*/
             ENDDO
/**/
             IF         (&RECP = 'A')   +
             THEN(DO)
                CLRPFM     FILE(GEFP2PD)
                CLRPFM     FILE(GEFP2ZZ)
                CLRPFM     FILE(GEFP2APD)                             /*CEU013*/
                OVRDBF     FILE(GEFPPD) TOFILE(GEFP2PD)
                OVRDBF     FILE(GEFPZZ) TOFILE(GEFP2ZZ)
                OVRDBF     FILE(GEFP1APD) TOFILE(GEFP2APD)            /*CEU013*/
             ENDDO
/*/COPY WNCPYSRC,FTC0220005                                          */
/**/
             CHGJOB     SWS(XXX0XX00)
/*/COPY WNCPYSRC,FTC0220001                                          */
/* */                                                                 /*056031*/
/* Add blocking of FPKEY */                                           /*056031*/
/* */                                                                 /*056031*/
             OVRDBF     FILE(FPKEY) SEQONLY(*YES 500)                 /*056031*/
/* */                                                                 /*056031*/
/************CALL       PGM(FT0220)                                  //*056031*/
             CALL       PGM(FT0220) PARM(&RECP)                       /*056031*/
/**/
             IF         (&RECP = 'A')   +
             THEN(DO)
/************DLTOVR     FILE(GEFPPD GEFPZZ) */                        /*CEU013*/
             DLTOVR     FILE(GEFPPD GEFPZZ GEFP1APD)                  /*CEU013*/
             ENDDO
/*/COPY WNCPYSRC,FTC0220004                                          */
/**/
/** .. CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*              RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)      */ /*S01194*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01194*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                               TOMSGQ(MRUNQ MOPERQ)
             ENDDO
/**/
/** .. CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM    **/
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG MSG('FILE CONTROLS OUT OF BALANCE') +
                               TOMSGQ(MRUNQ MOPERQ)
             ENDDO
/**/
/** .. CHECK FOR POSSIBLE MISSSING ACCOUNT KEYS TO BE REPORTED **/
/**/
             IF         ((%SWITCH(XXX1XX00))                  +
                    *AND (&MISSAC) = 'N')                     +
             THEN(DO)
/**/
/************   SNDPGMMSG  MSG('ACCOUNT  KEYS  MISSING')     +
                               TOMSGQ(MRUNQ MOPERQ)   **************/ /*E22724*/
                SNDPGMMSG  MSG('ACCOUNT  KEYS  MISSING, PROCES+
                               SING HALTED.')                 +
                               TOMSGQ(MRUNQ MOPERQ)                   /*E22724*/
/**/                                                                  /*S01189*/
/** IF NOT RUN IN I/C INITIATION AND HALT IF ACCOUNT KEYS MISSING **/ /*S01189*/
/** THEN CALL CB0175 TO HALT COB RUN  **/                             /*S01189*/
/**/                                                                  /*S01189*/
                IF   COND(&RECP *NE 'S') THEN(CALL PGM(CB0175) +
                          PARM(&NAM &SEQ))                            /*S01189*/
/**/                                                                  /*S01189*/
             ENDDO
             IF         ((%SWITCH(XXX1XX00))                  +
                    *AND (&MISSAC) = 'Y')                     +
             THEN(DO)
/**/
                SNDPGMMSG  MSG('ACCOUNT  KEYS  MISSING, PROCES+
                               SING CONTINUED')               +
                               TOMSGQ(MRUNQ)                          /*E22724*/
/**/                                                                  /*E22724*/
             CHGJOB     SWS(XXX0XXXX)
             ENDDO
/*/COPY WNCPYSRC,FTC0220003                                          */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
/* Reclaim Resources to remove FT0005 from stack */                   /*056031*/
/* */                                                                 /*056031*/
             RCLRSC     LVL(*CALLER)                                  /*056031*/
/**/
             ENDPGM
