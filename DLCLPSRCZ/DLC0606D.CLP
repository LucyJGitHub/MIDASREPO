/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL MERGE INTEREST TAX')                         */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0606D - MERGE INTEREST PAYMENT FILE                     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E29177            DATE  03OCT90             */
/*       PREV AMEND NO. E246              DATE  26FEB90             */
/*                      S01117            DATE  18/07/89            */
/*                      S01194            DATE  18/07/89            */
/*                      S01189            DATE  22/05/89            */
/*                      S01179            DATE  12/09/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       E29177 -  REMOVE UNNECESSARY PARAMETERS                    */
/*       E246   -  FIX TO CORRECT NO. OF PARMS TO DL1410            */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  STANDING DATA CHANGES                           */
/*       S01189 -   COB recovery processing.                        */
/*       S01179  -  AS400 CONVERSION                                */
/*                                                                  */
/********************************************************************/
/*********** PGM                                               S01117*/
/*********** PGM PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT) /*S01189E29177*/ /*S01117*/
             PGM PARM(&CNAM &CSEQ)                         /*E29177*/ /*S01117*/
/**/                                                                  /*S01189*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */  /*S01117E29177*/
/**DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)  /*S01117E29177*/
/**DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/ch)/*S01117E29177*/
/************DCLDTAARA  DTAARA(DLSTAT)                                  S01179*/
/************DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)/*S01179*/   /*S01189*/
             DCL        VAR(&SEQ)  TYPE(*CHAR) LEN(5)        /*S01117*/
/**/
             SNDPGMMSG  MSG('Merge Interest Payment File') +
                           TOMSGQ(MRUNQ)
/**/
/************RCVDTAARA  DTAARA(DLSTAT)                                  S01179*/
/************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)    /*S01179*/  /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/**/
/************IF         COND(%SUBSTRING(&DLSTAT 17 3) *EQ 'OLD') +
                          THEN(DO)                                    /*S01189*/
             IF         COND(&STAT *EQ 'N') THEN(DO)                  /*S01189*/
/**/
                CHGJOB     SWS(00000000)
/**/
                CLRPFM     FILE(MINTTMH)
                CLRPFM     FILE(MINTTMD)
                CLRPFM     FILE(MINTTMT)
/**/
/************** OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                /*S01194*/
/************** CALL       PGM(DL1410)                                /*S01117*/
/********       CALL       PGM(DL1410) PARM(&RSEQ)    S01117          /*E243  */
                CALL       PGM(DL1410)                                /*E243  */
/**/
                IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/******************CHGVAR     VAR(%SUBSTRING(&DLSTAT 17 3)) +
                                 VALUE('NEW')                         /*S01189*/
/***********       SNDDTAARA  DTAARA(DLSTAT)                            S01179*/
/******************CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)*S01179*/  /*S01189*/
                   CHGVAR     VAR(&STAT) VALUE('Y')                   /*S01189*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
                ENDDO
/**/
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
/*************  RCVDTAARA  DTAARA(DLSTAT)                               S01179*/
/***************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT) /*S01179*/  /*S01189*/
                CHGVAR     VAR(&STAT) VALUE(' ')                      /*S01189*/
                CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        /*S01189*/
/**/
/***************IF         COND(%SUBSTRING(&DLSTAT 17 3) *EQ 'NEW') +
                             THEN(DO)                                 /*S01189*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)               /*S01189*/
                   CLRPFM     FILE(MINTRMH)
                   CLRPFM     FILE(MINTRMD)
                   CLRPFM     FILE(MINTRMT)
                   CLRPFM     FILE(MINTNMH)
                   CLRPFM     FILE(MINTNMD)
                   CLRPFM     FILE(MINTNMT)
/**/
                   CPYF       FROMFILE(MINTTMH) TOFILE(MINTRMH) +
                              MBROPT(*ADD) FMTOPT(*NOCHK) COMPRESS(*NO)
                   CPYF       FROMFILE(MINTTMD) TOFILE(MINTRMD) +
                              MBROPT(*ADD) FMTOPT(*NOCHK) COMPRESS(*NO)
                   MONMSG     MSGID(CPF2817)
                   CPYF       FROMFILE(MINTTMT) TOFILE(MINTRMT) +
                              MBROPT(*ADD) FMTOPT(*NOCHK) COMPRESS(*NO)
/**/
/******************CHGVAR     VAR(%SUBSTRING(&DLSTAT 17 3)) +
                                 VALUE('OLD')                         /*S01189*/
/******************SNDDTAARA  DTAARA(DLSTAT)                   S01179*/
/******************CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)/*S01179*/ /*S01189*/
                   CHGVAR     VAR(&STAT) VALUE('N')                   /*S01189*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
/**/
                ENDDO
/**/
             ENDDO
/**/
             ELSE       CMD(DO)
/**/
                CLRPFM     FILE(MINTTMH)
                CLRPFM     FILE(MINTTMD)
                CLRPFM     FILE(MINTTMT)
/**/
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                             TOMSGQ(MOPERQ MRUNQ)
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
