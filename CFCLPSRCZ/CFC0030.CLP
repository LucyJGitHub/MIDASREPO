/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF Dealing confs. status audit rpt.')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - CONFIRMATION MATCHING                       */
/*                                                                   */
/*       CFC0030 - DEALING CONFIRMATIONS STATUS AUDIT REPORT         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01310             Date 06Dec90              */
/*                      S01259             Date 28Jan91              */
/*                      S01184            DATE 15DEC89               */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01310 - RE WRITTEN FOR SWIFT RATIONALISATION               */
/*       S01259 - SWIFT II ON CALL CF0188 ELSE CF0030                */
/*       S01184 - CREATED FOR CONFIRMATION MATCHING                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(50)
/************DCL********VAR(&SWII) TYPE(*CHAR) LEN(1)           /*S01259S01310*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                        TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
 
/************RTVDTAARA**DTAARA(MMOD (95 1)) RTNVAR(&SWII)       /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/***If*SWIFT*II*off*call*CF0030                                 /*S01259S01310*/
/************IF*********COND(&SWII *NE 'Y') THEN(DO)            /*S01259S01310*/
/************CALL*******PGM(*LIBL/CF0030)                             /*S01310*/
/************ENDDO*********                                     /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/***If*SWIFT*II*on*call*CF0188                                  /*S01259S01310*/
/************IF*********COND(&SWII *EQ 'Y') THEN(DO)            /*S01259S01310*/
/************CALL*******PGM(CF0188)                             /*S01259S01310*/
/************ENDDO*********                                     /*S01259S01310*/
/*/COPY WNCPYSRC,CFC0030001                                          */
             CALL       PGM(CF0188) PARM('     ')                     /*S01310*/
/*/COPY WNCPYSRC,CFC0030002                                          */
                                                                      /*S01259*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERRDTA)
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                GOTO ABNOR
                ENDDO
 
             GOTO (END)
 
 ABNOR:      SNDPGMMSG  MSG('CF0030 ENDED ABNORMALLY') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
