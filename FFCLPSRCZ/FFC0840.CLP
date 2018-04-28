/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Margin calculation (COB)')                   */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0840  -  MARGIN CALCULATION (EOC IN COB)                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Last Amend No. 175554             Date 18Oct02              */
/*       Prev Amend No. 154837             Date 18Oct02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      082461             Date 08Mar95              */
/*                      079666             Date 01Dec94              */
/*                      S04662             Date 21JUL93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*  175554   Amendment to fix 161028 - need to check that market     */
/*           status is not 'S' (Setup) before processing, as the     */
/*           file setup for new markets is done in ICI so the file   */
/*           members required for the new market have not been set   */
/*           up yet.                                                 */
/*  154837 - No Initial margin calculated for market that run in     */
/*           EOC (not in EOD).                                       */
/*  CCB009 - Journal files throughout close of business              */
/*  082461 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*  079666 - Add global monitor message processing                   */
/*   S04662 - Switchable Feature for Init Margins for Futures;       */
/*            Deposit and Spread Margin Rate added to DEFLTD.        */
/*            FF0440 has been rewritten and enhanced by FF0445.      */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)                              /*154837*/
/**********  DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)                                   /*154837*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*082461*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**********  DCLF       FILE(MARKTD) RCDFMT(MARKTDF)                           /*154837*/ /*175554*/
             DCLF       FILE(MKCTLD) RCDFMT(MKCTLDF)                                      /*175554*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*079666*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                      /*079666*/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0840 - +
                   Margin Calculation') TOMSGQ(MRUNQ)
/**/
/* START JOURNALLING OF PF/TSMKTD                                   */
/**/
RETRY:                                                                /*082461*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
STRJRNPF   FILE(*LIBL/TSMKTD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
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
             FFCJRN2    FILES(TSMKTD)
/**/
/*  OVERRIDE LF/POSTNC4, LF/TSMKT AND PF/TSMKTD                     */
/**/
             OVRDBF     FILE(POSTNC4) MBR(OTC)
             OVRDBF     FILE(TSMKT) MBR(OTC)
             OVRDBF     FILE(TSMKTD) MBR(OTC) SEQONLY(*YES 100)
/**/
/****CALL*FF0440*- END OF CENTRE MARGIN CALCULATION           **********S04662*/
/****************                                             **********S04662*/
/************CALL       PGM(FF0440)  PARM('  ')               **********S04662*/
/*   CALL FF0445 - END OF CENTRE MARGIN CALCULATION                   /*S04662*/
/**/                                                                  /*S04662*/
             CALL       PGM(FF0445)  PARM('  ')                       /*S04662*/
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/**LOOP*TO*PROCESS*ALL*MARKET*CENTRES*CONTAINED*IN*DTAARA/FFEOC******                     /*154837*/
/**LOOP*TO*PROCESS*ALL*MARKET*CENTRES*CONTAINED*IN*PF/MARKTD*********          /*154837*/ /*175554*/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN PF/MKCTLD                              /*175554*/
/**/
/**********  RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC) */                                   /*154837*/
/**/
 LOOP:
/**********  IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT + */                /*154837*/
/**********               61)) THEN(GOTO CMDLBL(END))                   */                /*154837*/
/**********  CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))                                /*154837*/
/**********  RCVF       RCDFMT(MARKTDF)                                        /*154837*/ /*175554*/
             RCVF       RCDFMT(MKCTLDF)                                                   /*175554*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDLOOP))                         /*154837*/
                                                                                          /*154837*/
             IF         COND(&RECI *NE 'D') THEN(GOTO CMDLBL(LOOP))                       /*154837*/
             IF         COND(&MKCI *EQ 'S') THEN(GOTO CMDLBL(LOOP))                       /*175554*/
             CHGVAR     VAR(&MKT) VALUE(&MRKT)                                            /*154837*/
/**/
/*  OVERRIDE LF/POSTNC4, LF/TSMKT AND PF/TSMKTD                     */
/**/
             OVRDBF     FILE(POSTNC4) MBR(&MKT)
             OVRDBF     FILE(TSMKT) MBR(&MKT)
             OVRDBF     FILE(TSMKTD) MBR(&MKT) SEQONLY(*YES 100)
/**/
/****CALL*FF0440*- END OF CENTRE MARGIN CALCULATION           **********S04662*/
/****************                                             **********S04662*/
/************CALL       PGM(FF0440)  PARM(&MKT)               **********S04662*/
/*   CALL FF0445 - END OF CENTRE MARGIN CALCULATION                   /*S04662*/
/**/                                                                  /*S04662*/
             CALL       PGM(FF0445)  PARM(&MKT)                       /*S04662*/
/**/
/**********  CHGVAR     VAR(&A) VALUE(&A + 2)                                             /*154837*/
             GOTO       CMDLBL(LOOP)
ENDLOOP:                                                                                  /*154837*/
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
END:         DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*  CALL FINAL JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN3    FILES(TSMKTD)
/**/
             GOTO       CMDLBL(ENDPGM)                                /*079666*/
                                                                      /*079666*/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFC0840 - Margin Calculation TERMINATED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             DMPCLPGM                                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             CHGJOB     SWS(XXXXXX11)                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
                                                                      /*079666*/
ENDPGM:                                                               /*079666*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
