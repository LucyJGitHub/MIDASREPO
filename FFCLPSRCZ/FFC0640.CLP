/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Extract mat insts for amort.(COB)')          */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                        */
/*                                                                   */
/*   FFC0640  -  EXTRACT MATURED INSTRUMENTS FOR AMORTIZATION (COB)  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      082461             Date 08Mar95              */
/*                  S01117             Date 19Feb90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  CCB009 - Journal files throughout close of business              */
/*  082461 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*082461*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
             SNDPGMMSG  MSG('FFC0640 - Extract +
                          Matured Instruments for Amortization') +
                          TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/**/
/* START JOURNALLING OF PF/AMORTD                                   */
/**/
RETRY:                                                                /*082461*/
STRJRNPF   FILE(*LIBL/AMORTD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
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
             ENDDO                                                    /*CCB009*/
BYPASS:                                                               /*082461*/
/**/
/*  CALL START JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN2    FILES(AMORTD)
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/*   CALL FF0610 - EXTRACT MATURED INSTRUMENTS FOR AMORTIZATION     */
/**/
             CALL       PGM(FF0610)
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
             GOTO       CMDLBL(END)                                   /*082461*/
                                                                      /*082461*/
ABNOR:                                                                /*082461*/
             SNDPGMMSG  MSG('FFC0640 - Extract Matured Instruments +
                          for Amortisation TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
             DMPCLPGM                                                 /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
             CHGJOB     SWS(XXXXXX11)                                 /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
                                                                      /*082461*/
END:                                                                  /*082461*/
/**/
/*  CALL FINAL JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN3    FILES(AMORTD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
