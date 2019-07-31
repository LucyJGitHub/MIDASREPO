/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL EVENT REP. BY DEAL SUB-TYPE/DEAL')           */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0805 - EVENT3 REPORTING BY DEAL SUB-TYPE/DEAL           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E27942             DATE 03SEP91             */
/*       PREV AMEND NO. S01117             DATE 17/07/89            */
/*                      S01194             DATE 17/07/89            */
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       E27942  -  FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A    */
/*                  LEVEL OF BLANKS                                 */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  STANDING DATA CHANGES.                          */
/*                                                                  */
/********************************************************************/
/************PGM                                                        S01117*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/**/
             CHGJOB     SWS(00000000)
/**/
             SNDMSG     MSG('DEALS BY SUB-TYPE REPORT')  TOMSGQ(MRUNQ)
/*********** OVRDBF     FILE(TABLE)   TOFILE(TABDLEE)                 /*S01194*/
/*********** CALL       PGM(DL0730)                                   /*S01117*/
 
/*  REPORT BY SYSTEM  */                                              /*S01117*/
/************IF         COND(&RLEV *EQ 'S') THEN(CALL PGM(DL0730) +
/************             PARM(&RSEQ))                       /*S01117* *E27942*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CALL PGM(DL0730) PARM(&RSEQ))          /*E27942*/
                                                                      /*S01117*/
/*  REPORT BY BRANCH  */                                              /*S01117*/
             IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(DL0731) +
                        PARM(&RSEQ &RENT))                            /*S01117*/
                                                                      /*S01117*/
/*  REPORT BY COMPANY */                                              /*S01117*/
             IF         COND(&RLEV *EQ 'C') THEN(CALL PGM(DL0732) +
                        PARM(&RSEQ &RENT))                            /*S01117*/
                                                                      /*S01117*/
             RTVJOBA    SWS(&SWS)
/*********** DLTOVR     FILE(TABLE)                                   /*S01194*/
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(SNDMSG +
                        MSG('Job terminated - database in error') +
                        TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '01') THEN(SNDMSG +
                        MSG('File controls out of balance') +
                        TOMSGQ(MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
