/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SWIFT accounts maintenance')                    */
/********************************************************************/
/*                                                                  */
/*        Midas     S.W.I.F.T. DIRECT LINK                      */
/*                                                                  */
/*        MSC101     S.W.I.F.T. Accounts Maintenance                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E23412             DATE  06SEP90            */
/*       PREV AMEND NO. LN0480             DATE 17JUL90             */
/*                      S01117             DATE  8DEC89             */
/*                      S01194             DATE  8DEC89             */
/*                      S01179             DATE  9/09/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     E23412  -  MMOD WAS CHECKED IN POSITION 3 TO SEE IF RETAIL 1 */
/*                WAS SWITCHED ON.  THIS IS NOW OBSELETE AND MMOD   */
/*                SHOULD BE CHECKED IN POSITIONS 16 AND 23 FOR      */
/*                RETAIL 2 OR INTEREST ON ACCOUNTS.                 */
/*     LN0480 - NON-MB INCORPORATED IN MS0021 PGM/MS0020 NOT NEEDED)*/
/*     S01117 - MULTIBRANCHING                                      */
/*     S01194 - STANDING DATA CHANGES.                              */
/*     S01179  -  CHANGE RCVDTAARA TO RTVDTAARA FOR AS400           */
/*                                                                  */
/********************************************************************/
             PGM
/*                                                                    /*S01194*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                   */
/**/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                /*S01117*/
/**/
/*           DCLDTAARA  DTAARA(MSSTAT)                              *  *S01179*/
/*           DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
             DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
             DCL        VAR(&MMOD)   TYPE(*CHAR) LEN(256)             /*S01179*/
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)             /*S01179*/
/*********** DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)          /*S01117*LN0480*/
/**/
/*                                                                    /*S01117*/
/* Global monitor message                                             /*S01117*/
/*                                                                    /*S01117*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                    /*S01117*/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
/*                                                                   /*S01194*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*                                                                   /*S01117*/
/*           RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)   /*S01117*LN0480*/
/*                                                                   /*S01117*/
/*           RCVDTAARA  DTAARA(MSSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(MSSTAT)  RTNVAR(&MSSTAT)               /*S01179*/
/**/
             IF         COND(%SUBSTRING(&MSSTAT 1 1) *EQ 'N') +
                          THEN(CHGJOB SWS(01000000))
/**/
             ELSE       CMD(CHGJOB SWS(00000000))
/**/
/*           RCVDTAARA  DTAARA(MMOD)                                *  *S01179*/
             RTVDTAARA  DTAARA(MMOD)    RTNVAR(&MMOD)                 /*S01179*/
/**/
/*********   IF         COND(%SUBSTRING(&MMOD 3 1) *EQ 'Y') + /*E23412*/
/*E23412*/
             IF         COND((%SUBSTRING(&MMOD 16 1) = 'Y') +
                        *OR (%SUBSTRING(&MMOD 23 1)) = 'Y') +
                          THEN(CHGJOB SWS(1XXXXXXX))
/*E23412*/
/**/
/************CALL       PGM(MS0020)                                   /*S01117*/
/**/                                                                  /*S01117*/
/*           IF         COND(&MBIN *EQ 'Y') THEN(DO)           /*S01117*LN0480*/
             OVRDBF     FILE(SWACBCHG) TOFILE(SWACB) SHARE(*NO)
                        CALL MS0021                                   /*S01117*/
/*           ENDDO                                                    /*LN0480*/
/*           ELSE       CALL MS0020                            /*S01117*LN0480*/
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**/
/*              RCVDTAARA  DTAARA(LDA)                              *  *S01179*/
                RTVDTAARA  DTAARA(LDA)    RTNVAR(&LDA)                /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING( +              /*S01117*/
/*****************************&LDA 134 44))                           /*S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING( +
                              &LDA 134 50))
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO ENDPGM
/**/
             ENDDO
/**/
/*                                                                    /*S01117*/
             GOTO       CMDLBL(ENDPGM)
/*                                                                    */
 ABNOR:         ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                SNDPGMMSG MSG('Transaction failed. Re-input +
                     necessary. Enter to continue.') TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                    /*S01117*/
ENDPGM:      ENDPGM
