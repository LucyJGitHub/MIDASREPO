/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Telex report (COB)')                         */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0694  -  TELEX REPORT (COB)                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*   Last Amend No. CCB009             Date 01Jun00                  */
/* Midas DBA 3.01 ---------------------------------------------------*/
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/*   Prev Amend No. 163444             Date 06Aug99                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  082461             Date 08Mar95                  */
/*                  S01299             DATE  29AUG90                 */
/*                  S01117             DATE  02APR90                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   CCB009  - Journal files throughout close of business            */
/*   163444  - Y2K sort order and file allocation                    */
/*  082461 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*   S01299  -  Allow up to 32 market centres as per original        */
/*              specification.                                       */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*/COPY WNCPYSRC,FFC0694001                                          */
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*082461*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*082461*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                      /*082461*/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0694 - Telex +
                          Report') TOMSGQ(MRUNQ)
/*                                                                  */
/* CLEAR FILE PF/CNFRPD                                             */
/*                                                                  */
             CLRPFM     CNFRPD
/**/
/* START JOURNALLING OF UPDATE/OUTPUT FILES                         */
/**/
RETRY:                                                                /*082461*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
STRJRNPF   FILE(*LIBL/TSCCYD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POCHGCC) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POCHGRC) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POCHGTC) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POSTNCD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
                                                                      /*082461*/
             GOTO       CMDLBL(BYPASS)                                /*082461*/
                                                                      /*082461*/
JRNFAIL:                                                              /*082461*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                 /*082461*/
             IF         COND(&COUNT *LE 3) THEN(DO)                   /*082461*/
             DLYJOB     DLY(60)                                       /*082461*/
             GOTO       CMDLBL(RETRY)                                 /*082461*/
             ENDDO                                                    /*082461*/
             ELSE       CMD(DO)                                       /*082461*/
             GOTO       CMDLBL(ABNOR)                                 /*082461*/
             ENDDO                                                    /*082461*/
BYPASS:                                                               /*082461*/
             ENDDO                                                    /*CCB009*/
/**/
/*  CALL START JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN2    FILES(TSCCYD POCHGCC POCHGRC POCHGTC POSTNCD)
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/*  OVERRIDE LF/POCHG5X AND PF/CNFRPD                               */
/**/
/************OVRDBF     FILE(POCHG5X) TOFILE(POCHG5) SHARE(*NO)         S01299*/
             OVRDBF     FILE(CNFRPD) SEQONLY(*YES 50)
/*/COPY WNCPYSRC,FFC0694002                                          */
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
                                                                      /*163444*/
 LOOP:       ALCOBJ     OBJ((FFPSNCPD *FILE *EXCL))                   /*163444*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*163444*/
             RCVMSG     WAIT(60) RMV(*NO)                             /*163444*/
             CHGVAR     VAR(&SIX) VALUE(&SIX + 1)                     /*163444*/
             IF         COND(&SIX *LE 6) THEN(GOTO CMDLBL(LOOP))      /*163444*/
             ELSE       CMD(DO)                                       /*163444*/
             SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*163444*/
             GOTO       CMDLBL(ENDLOOP)                               /*163444*/
             ENDDO                                                    /*163444*/
             ENDDO                                                    /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNC1        )) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNC1        )) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
/**/
/*   CALL FF0590 - TELEX REPORT                                     */
/**/
             CALL       PGM(FF0590)
             DLCOBJ     OBJ((FFPSNCPD *FILE *EXCL))                   /*163444*/
/**/
/*  DELETE OVERRIDES                                                */
/**/
/************DLTOVR     FILE(POCHG5X)                                   S01299*/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                  S01299*/
             DLTOVR     FILE(CNFRPD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
ENDLOOP:                                                               /*163444*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
/*  OVERRIDE TO PAY DETAILS                                         */
/**/
             OVRDBF     FILE(CNFRPX) TOFILE(CNFRP2)
/**/
/*   CALL FF0592 - NOSTRO SETTLEMENT TELEX REPORT                   */
/**/
             CALL       PGM(FF0592) PARM(P)
/**/
/*  DELETE OVERRIDE                                                 */
/**/
             DLTOVR     FILE(CNFRPX)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
/*  OVERRIDE TO RECEIVE DETAILS                                     */
/**/
             OVRDBF     FILE(CNFRPX) TOFILE(CNFRP3)
/**/
/*   CALL FF0592 - NOSTRO SETTLEMENT TELEX REPORT                   */
/**/
             CALL       PGM(FF0592) PARM(R)
/**/
/*  DELETE OVERRIDE                                                 */
/**/
             DLTOVR     FILE(CNFRPX)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/                                                                  /*082461*/
             GOTO       CMDLBL(END)                                   /*082461*/
ABNOR:                                                                /*082461*/
             SNDPGMMSG  MSG('FFC0694 - Telex Report +
                          TERMINATED ABNORMALLY') TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
             DMPCLPGM                                                 /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
             CHGJOB     SWS(XXXXXX11)                                 /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
END:
/**/
/*  CALL FINAL JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN3    FILES(TSCCYD POCHGCC POCHGRC POCHGTC POSTNCD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
