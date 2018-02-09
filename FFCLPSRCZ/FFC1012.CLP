/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Accounting entry gen (EOC)')                 */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC1012  -  ACCOUNTING ENTRY GENERATION (EOC)                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CFF007             Date 13Feb01              */
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      163444             Date 03Aug99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      B9582              Date 08Jan96              */
/*                  S01408             DATE 10OCT95                  */
/*                  E23409             DATE 31AUG90                  */
/*                  S01117             DATE 11APR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CFF007 - Futures and Options Enhancement for Private        */
/*                Banking.                                           */
/*   163444 - Y2K sort order and file allocation.                    */
/*   B9582  - Add a parameter to the call of RPG/FF0427 to mean      */
/*            EOC activities or not.                                 */
/*   S01408 - Apply Core Hook  FFC1012001                            */
/*   E23409 - SETTLEMENT ACROSS RETAIL ACCOUNTS ALLOWED IF RETAIL II */
/*            OR INTEREST ON ACCOUNTS INSTALLED - SETON U2 IF RE OR  */
/*            IA = 'Y'.   NOTE - RETAIL I NOT SUPPORTED ON AS/400    */
/*   S01117 - MULTIBRANCHING                                         */
/*                                                                   */
/*********************************************************************/
             PGM  (&MARKET)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&MARKET) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(70)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&AKYIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&POBIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MKBIND) TYPE(*CHAR) LEN(1) VALUE('Y')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CFF007*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CFF007*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CFF007*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CFF007*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,FFC1012002                                          */
/**/
/* Global monitor message                                           */
/**/
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/*   TEST FOR RETAIL II OR INTEREST ON ACCOUNTS       */           /*E23409*/
/*     ( SET ON U2 IF PRESENT)                        */           /*E23409*/
/**/                                                               /*E23409*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)            /*E23409*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))               /*E23409*/
/**/                                                               /*E23409*/
/****TEST*FOR*RETAIL*II*MODULE*-*SETON*U2*IF*PRESENT***//************E23409*/
/************RTVDTAARA**DTAARA(MMOD *ALL) RTNVAR(&MMOD)**************E23409*/
/************IF*********COND((%SST(&MMOD 3 1) *EQ 'Y') *AND +********E23409*/
/*************************(%SST(&MMOD 16 1) *EQ 'Y')) +**************E23409*/
/*************************THEN(CHGJOB SWS(X1XXXXXX))*****************E23409*/
/**/
/* Override multimember files to relevant member for market centre  */
/* for which EOC is running                                         */
/**/
             OVRDBF     FILE(FOKEY) MBR(&MARKET)
             OVRDBF     FILE(FOKEYA) MBR(&MARKET)
             OVRDBF     FILE(MGEFF) MBR(&MARKET)
             OVRDBF     FILE(MGEFFHH) MBR(&MARKET)
             OVRDBF     FILE(MGEFFPD) MBR(&MARKET) SEQONLY(*YES 100)
             OVRDBF     FILE(MGEFFZZ) MBR(&MARKET)
 
/*/COPY WNCPYSRC,FFC1012001                                        */ /*S01408*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CFF007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CFF007*/
             CHGVAR     VAR(&SARD) VALUE('CFF007')                                        /*CFF007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CFF007*/
             IF         COND(&RTCD *EQ '       ') THEN(OVRDBF +
                          FILE(TRANS) MBR(&MARKET))                                       /*CFF007*/
 
/**/
/* CALL GENERATE ACCOUNTING ENTRIES PROGRAM FF0420                  */
/**/
             CHGJOB     SWS(XXX00100)
             CALL       PGM(FF0420) PARM(&MARKET &MKBIND &AKYIND +
                         &POBIND)
/*/COPY WNCPYSRC,FFC1012003                                          */
/**/
/* DATABASE ERROR?                                                  */
/**/
             IF  (%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/* FILE CONTROLS?                                                   */
/**/
             IF  (%SWITCH(XXXXXX01)) THEN(GOTO FILCTL)
/**/
/* If Account Keys are missing, check if continuation requested     */
/**/
             IF  COND((%SWITCH(XXX1XX00)) *AND (&AKYIND *EQ 'N')) +
               THEN(DO)
                 SNDPGMMSG  MSG('Account Keys Missing - End of +
                          Centre run HALTED') TOMSGQ(MOPERQ)
                 CHGVAR     VAR(&ACT) VALUE('I')
                 CHGVAR     VAR(&MSG) VALUE('Account Keys Missing - +
                          End of Centre run HALTED')
                 CALL       FF0473 PARM(&MARKET &ACT &MSG)
               CHGJOB     SWS(XXXXXXX1)
               GOTO       END
             ENDDO
/**/
/* If continuation is not requested - just send message             */
/**/
             IF  COND((%SWITCH(XXX1XX00)) *AND (&AKYIND *EQ 'Y')) +
               THEN(DO)
                 SNDPGMMSG  MSG('Account Keys Missing - End of +
                          Centre run CONTINUING') TOMSGQ(MOPERQ)
                 CHGVAR     VAR(&ACT) VALUE(' ')
                 CHGVAR     VAR(&MSG) VALUE('Account Keys Missing - +
                          End of Centre run CONTINUING')
                 CALL       FF0473 PARM(&MARKET &ACT &MSG)
             ENDDO
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
                                                                      /*163444*/
 AGAIN:      ALCOBJ     OBJ((FFKEY1PD *FILE *EXCL))                   /*163444*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*163444*/
             RCVMSG     WAIT(60) RMV(*NO)                             /*163444*/
             CHGVAR     VAR(&SIX) VALUE(&SIX + 1)                     /*163444*/
             IF         COND(&SIX *LE 6) THEN(GOTO CMDLBL(AGAIN))     /*163444*/
             ELSE       CMD(DO)                                       /*163444*/
             SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*163444*/
             GOTO       CMDLBL(ENDAGAIN)                              /*163444*/
             ENDDO                                                    /*163444*/
             ENDDO                                                    /*163444*/
             OPNQRYF    FILE((FOKEY1         )) FORMAT(FFKEY1PD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFKEY1PD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((FOKEY1         )) FORMAT(FFKEY1PD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFKEY1PD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
/**/
/*   CALL FF0427 - ACCOUNT KEYS GENERATED TODAY LIST                */
/**/
/*********** CALL       PGM(FF0427) PARM(&MARKET)                      *B9582 */
             CALL       PGM(FF0427) PARM(&MARKET &MKBIND)             /*B9582 */
             DLCOBJ     OBJ((FFKEY1PD *FILE *EXCL))                   /*163444*/
ENDAGAIN:                                                             /*163444*/
/**/
/* Database error?                                                  */
/**/
             IF  (%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/* If no previous error, call FF0425                                */
/**/
             CALL       PGM(FF0425) PARM(&MARKET)
/**/
/* Check that no error occured on previous program                  */
/**/
             IF  (%SWITCH(XXXX0X00)) THEN(GOTO END)
/**/
/* Database error?                                                  */
/**/
             IF  (%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/* FILE CONTROLS?                                                   */
/**/
             IF  (%SWITCH(XXXXXX01)) THEN(GOTO FILCTL)
/**/
/* If Postings Out Of Balance, check if continuation requested     */
/**/
             IF  COND((%SWITCH(XXXX1X00)) *AND (&POBIND *EQ 'N')) +
               THEN(DO)
                 SNDPGMMSG  MSG('Postings out of Balance - End of +
                          Centre run HALTED') TOMSGQ(MOPERQ)
                 CHGVAR     VAR(&ACT) VALUE('I')
                 CHGVAR     VAR(&MSG) VALUE('Postings out of +
                          Balance - End of Centre run HALTED')
                 CALL       FF0473 PARM(&MARKET &ACT &MSG)
               CHGJOB     SWS(XXXXXXX1)
               GOTO       END
             ENDDO
/**/
/* If continuation is not requested - just send message             */
/**/
             IF  COND((%SWITCH(XXXX1X00)) *AND (&POBIND *EQ 'Y')) +
               THEN(DO)
                 SNDPGMMSG  MSG('Postings out of Balance - End of +
                          Centre run CONTINUING') TOMSGQ(MOPERQ)
                 CHGVAR     VAR(&ACT) VALUE(' ')
                 CHGVAR     VAR(&MSG) VALUE('Postings out of +
                          Balance - End of Centre run CONTINUING')
                 CALL       FF0473 PARM(&MARKET &ACT &MSG)
               GOTO       END
             ENDDO
/**/
/* Database error processing. Message to MOPERQ                     */
/**/
DBERR:
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
                 CHGVAR     VAR(&ACT) VALUE('I')
                 CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1012')
                 CALL       FF0473 PARM(&MARKET &ACT &MSG)
                 GOTO       CMDLBL(END)
/**/
/* File Controls processing. Message to MOPERQ                      */
/**/
FILCTL:
                 SNDPGMMSG  MSG('File Controls out of Balance - +
                          FFC1012') TOMSGQ(MOPERQ)
                 CHGVAR     VAR(&ACT) VALUE('I')
                 CHGVAR     VAR(&MSG) VALUE('File Controls out of +
                          Balance - FFC1012')
                 CALL       FF0473 PARM(&MARKET &ACT &MSG)
                 GOTO       CMDLBL(END)
/**/
/* Abnormal error processing. Set on U7                             */
/**/
ABNOR:
             CHGJOB     SWS(XXXXXX1X)
/*                                                                  */
 END:
/**/
/* Delete overrides on multimember files                            */
/**/
             DLTOVR     FILE(FOKEY)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(FOKEYA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(MGEFF)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(MGEFFHH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(MGEFFPD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(MGEFFZZ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
/*                                                                  */
