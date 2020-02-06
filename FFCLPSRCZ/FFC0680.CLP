/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Client COB updates (COB)')                   */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0680  -  CLIENT COB UPDATES (COB)                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAP067             Date 21Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  S71062             Date 08Nov95                  */
/*                  S01408             Date 04Sep95                  */
/*                  082461             DATE 08MAR95                  */
/*                  E22558             DATE 20JUN90                  */
/*                  E21816             DATE 05MAY90                  */
/*                  S01117             DATE 22MAR90                  */
/*                  E20352             DATE 04JAN90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       CER0001 - LUX Upgrade to MidasPlus                          */
/*   CAP067 - Make PF/FFDEALS and LF/FFDLS1 permanent files.         */
/*   CCB009 - Journal files throughout close of business             */
/*   S71062 - FF/PM Initial margin                                   */
/*   S01408 - Addition of hooks FFC0680001                           */
/*                              FFC0680002                           */
/*   082461 - If journalling fails because pgm cannot allocate file, */
/*            retry before failing.                                  */
/*   E22558  -  USE OVRDBF AND CLRPFM ON PF/FFDEALS FOR FF0510.      */
/*              N.B. REPLACES E20352                                 */
/*   E21816  -  JOURNAL SDFOCSPD AS IT IS UPDATED BY FF0510.         */
/*   S01117  -  MULTIBRANCHING                                       */
/*   E20352  -  RPG PROGRAM FF0510 UNABLE TO ALLOCATE DEALSDD.       */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
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
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CER001*/
             DCL        VAR(&ULX043) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CER001*/
                                                                                          /*CER001*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*082461*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                                          /*CER001*/
/** Check for switchable feature ULX043  */                                               /*CER001*/
                                                                                          /*CER001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY'   +
                          'ULX043' &AOFMT)                                                /*CER001*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&ULX043) VALUE('Y'))                                        /*CER001*/
                                                                      /*082461*/
/* Audit message to MRUNQ                                           */
/**/
             SNDPGMMSG  MSG('FFC0680 - Client +
                          Updates') TOMSGQ(MRUNQ)
/**/
/* Clear output files                                               */
/**/
             CLRPFM     CUSSTD
             CLRPFM     WCOLTD
             CLRPFM     WCOLTDM                                       /*S71062*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,FFC0680001                                          */
             IF         COND(&ULX043 *EQ 'Y') +
                          THEN(DO)                                                        /*CER001*/
             CLRPFM     FILE(ILCOLTPD)                                                    /*CER001*/
             MONMSG     MSGID(CPF0000)                                                    /*CER001*/
             ENDDO                                                                        /*CER001*/
                                                                      /*S01408*/
/**/
/* START JOURNALLING OF ALL UPDATE OR OUTPUT FILES                  */
/**/
/*STRJRNPF FILE(*LIBL/FOCLTD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +        /*E21816*/
/************OMTJRNE(*OPNCLO)                                         /*E21816*/
RETRY:                                                                /*082461*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             STRJRNPF   FILE(*LIBL/FOCLTD SDFOCSPD) JRN(*LIBL/FFJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*E21816*/
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
/*  CALL INITIAL JOURNAL PROCESSING FOR SUB-COMPONENT               */
/**/
/*********** FFCJRN2    FILES(FOCLTD)                                 /*E21816*/
             FFCJRN2    FILES(FOCLTD SDFOCSPD)                        /*E21816*/
/**/
             OVRDBF     FILE(CUSSTD) SEQONLY(*YES 50)
/*********** OVRDBF     FILE(WCOLTD) SEQONLY(*YES 50)              */ /*S01117*/
             CHGJOB     SWS(XXXXXX00)
/**/
/* Call FF0510                                                      */
/**/
/**INTRODUCE*AN*ALLOCATE*JOB*COMMAND***********         */ /*E20352*/ /*E22558*/
/***********                                            */ /*E20352*/ /*E22558*/
/*********** ALCOBJ  OBJ((DEALSDD *FILE *EXCLRD)) WAIT(9999)*E20352*/ /*E22558*/
/**                                                                   /*E22558*/
/** Override DLSDD1 to FFDLS1 (& its PF; FFDEALS which is a           /*E22558*/
/** copy of DEALSDD at I/C term.)                                     /*E22558*/
/**                                                                   /*E22558*/
             OVRDBF     FILE(DLSDD1) TOFILE(FFDLS1) SECURE(*YES)      /*E22558*/
             CALL       PGM(FF0510)
/*********** DLCOBJ  OBJ((DEALSDD *FILE *EXCLRD))       */ /*E20352*/ /*E22558*/
/**/
             IF  COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
             ENDDO
                                                                      /*E22558*/
/**                                                                   /*E22558*/
/** If FF0510 completed succesfully then delete the copy of DEALSDD   /*E22558*/
/** and copy file WCOLTDM                                             /*S71062*/
/**                                                                   /*E22558*/
             ELSE       CMD(DO)                                       /*E22558*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,FFC0680002                                          */
/** Save working file for active collaterals  */                                          /*CER001*/
                                                                                          /*CER001*/
             IF         COND(&ULX043 *EQ 'Y') +
                          THEN(DO)                                                        /*CER001*/
             CPYF       FROMFILE(WCOLTD) TOFILE(ILCOLTPD) +
                             MBROPT(*REPLACE)                                             /*CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CER001*/
             ENDDO                                                                        /*CER001*/
                                                                                          /*CER001*/
                                                                      /*S01408*/
                        CPYF FROMFILE(WCOLTD) TOFILE(WCOLTDM) +
                             MBROPT(*REPLACE)                         /*S71062*/
             MONMSG     MSGID(CPF2869 CPF2817)                        /*S71062*/
/**********             DLTF FILE(FFDLS1)  */                                  /*E22558*/ /*CAP067*/
/**********             DLTF FILE(FFDEALS) */                                  /*E22558*/ /*CAP067*/
                        CLRPFM     FILE(FFDEALS)                                          /*CAP067*/
                        ENDDO                                         /*E22558*/
                                                                      /*E22558*/
/**/
             GOTO       CMDLBL(END)                                   /*082461*/
ABNOR:                                                                /*082461*/
             SNDPGMMSG  MSG('FFC0680 - Client Updates TERMINATED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
             DMPCLPGM                                                 /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
             CHGJOB     SWS(XXXXXX11)                                 /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
                                                                      /*082461*/
END:                                                                  /*082461*/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*  CALL FINAL JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
/*********** FFCJRN3    FILES(FOCLTD)                                 /*E21816*/
             FFCJRN3    FILES(FOCLTD SDFOCSPD)                        /*E21816*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
/**/
