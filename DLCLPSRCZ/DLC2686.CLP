/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Foreign Exchange Ladder')                    */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC2686 - FOREIGN EXCHANGE LADDER REPORT                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CEU011             Date 11Mar98              */
/*       Prev Amend NO. E27942             Date 03Sep91              */
/*                      S01117             Date 27Sep89              */
/*                         S01194            DATE 17/07/89          */
/*                                                                  */
/*-------------------------------------------------------------------*/
/*       CEU011 - EMU Position/Risk Reporting.                       */
/*       E27942  -  FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A    */
/*                  LEVEL OF BLANKS                                 */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  NEW STANDING DATA FILES                         */
/*                                                                  */
/********************************************************************/
/*********** PGM                                                      /*S01117*/
/* &RSEQ, &RLEV &RENT ARE STANDARD RCF PARMS,                         /*S01117*/
 
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/**/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU011*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU011*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU011*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CEU011*/
             DCL        VAR(&CEU011) TYPE(*CHAR) LEN(1)               /*CEU011*/
/**/                                                                  /*CEU011*/
/* Check if CEU011 is installed */                                    /*CEU011*/
/**/                                                                  /*CEU011*/
             CHGVAR     VAR(&SARD) VALUE('CEU011')                    /*CEU011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CEU011*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CEU011) VALUE('Y'))                    /*CEU011*/
/**/                                                                  /*CEU011*/
             CHGJOB     SWS(00000000)
/**/
             SNDMSG     MSG('FOREIGN EXCHANGE LADDER REPORT') +
                        TOMSGQ(MRUNQ)
/************IF         COND(&RLEV *EQ 'S') THEN(CALL PGM(DL2686) +
/************             PARM(&RSEQ))                        *S01117* *E27942*/
/**/                                                                  /*CEU011*/
             IF         COND(&CEU011 *EQ 'Y') THEN(CLRPFM +
                          FILE(DLEVEUPD))                             /*CEU011*/
/**/                                                                  /*CEU011*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CALL PGM(DL2686) PARM(&RSEQ))          /*E27942*/
             IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(DL2684) +
                        PARM(&RSEQ &RENT))                           /*S01117*/
/**/                                                                  /*CEU011*/
             IF         COND(&CEU011 *EQ 'Y') THEN(DO)                /*CEU011*/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)           /*CEU011*/
/**/                                                                  /*CEU011*/
                  IF    COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') THEN( +
                          OVRDBF FILE(DLEVFXL1) TOFILE(DLEVEUL2))     /*CEU011*/
/**/                                                                  /*CEU011*/
                  IF    COND(&RLEV *EQ 'B') THEN(OVRDBF +
                          FILE(DLEVFXL2) TOFILE(DLEVEUL3))            /*CEU011*/
/**/                                                                  /*CEU011*/
                  CHGJOB     SWS(1XXXXXXX)                            /*CEU011*/
                  IF    COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CALL PGM(DL2686) PARM(&RSEQ))          /*CEU011*/
                  IF    COND(&RLEV *EQ 'B') THEN(CALL PGM(DL2684) +
                          PARM(&RSEQ &RENT))                          /*CEU011*/
                ENDDO                                                 /*CEU011*/
/**/                                                                  /*CEU011*/
                IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)           /*CEU011*/
                  IF    COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(DLTOVR FILE(DLEVFXL1))                 /*CEU011*/
                  IF    COND(&RLEV *EQ 'B') THEN( +
                          DLTOVR FILE(DLEVFXL2))                      /*CEU011*/
                ENDDO                                                 /*CEU011*/
             ENDDO                                                    /*CEU011*/
/**/                                                                  /*CEU011*/
/*********** OVRDBF     FILE(TABLE)   TOFILE(TABDLI)                  /*S01194*/
/*********** CALL       PGM(DL2686)                                   /*S01117*/
/*********** DLTOVR     FILE(TABLE)                                   /*S01194*/
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(SNDPGMMSG +
                        MSG('JOB TERMINATED - DATABASE IN ERROR') +
                        TOMSGQ(MRUNQ MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
