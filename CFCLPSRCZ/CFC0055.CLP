/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF Dealing confs. status report')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - CONFIRMATION MATCHING                       */
/*                                                                   */
/*       CFC0055 - DEALING CONFIRMATIONS STATUS REPORT               */
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
/*       S01310 - SWIFT RATIONALISATION                              */
/*       S01259 - SWIFT II ON CALL CF0190 ELSE CF0055                */
/*       S01184 - CREATED FOR CONFIRMATION MATCHING                  */
/*                                                                   */
/*********************************************************************/
/************PGM*PARM(&SFDS &SFDE &SLT &ARY)                            S01310*/
             PGM        PARM(&RSEQ &RLEV &RENT &PARAM)                /*S01310*/
 
/************DCL VAR(&SFDS) TYPE(*CHAR) LEN(6)                        /*S01310*/
/************DCL VAR(&SFDE) TYPE(*CHAR) LEN(6)                        /*S01310*/
/************DCL VAR(&SLT) TYPE(*CHAR) LEN(3)                         /*S01310*/
/************DCL VAR(&ARY) TYPE(*CHAR) LEN(9)                         /*S01310*/
             DCL VAR(&ERRDTA) TYPE(*CHAR) LEN(50)
             DCL VAR(&SWII) TYPE(*CHAR) LEN(1)                        /*S01259*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01310*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01310*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01310*/
             DCL        VAR(&PARAM) TYPE(*CHAR) LEN(23)               /*S01310*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                        TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
 
/************RTVDTAARA**DTAARA(MMOD (95 1)) RTNVAR(&SWII)       /*S01259S01310*/
                                                                      /*S01259*/
/***If*SWIFT*II*off*call*CF0055                                 /*S01259S01310*/
/************IF*********COND(&SWII *NE 'Y') THEN(DO)            /*S01259S01310*/
/************CALL*CF0055*(&SFDS &SFDE &SLT &ARY)                /*S01259S01310*/
/************ENDDO*********                                     /*S01259S01310*/
                                                                      /*S01259*/
/*  If SWIFT II on call CF0190                                        /*S01259*/
/*/COPY WNCPYSRC,CFC0055001                                          */
             CALL       PGM(CF0190) PARM(&RSEQ &RLEV &RENT &PARAM)    /*S01310*/
/*/COPY WNCPYSRC,CFC0055002                                          */
 
/************IF*********COND(&SWII *EQ 'Y') THEN(DO)            /*S01259S01310*/
/************CALL*******PGM(CF0190) PARM(&SFDS &SFDE &SLT &ARY) /*S01259S01310*/
/************ENDDO*********                                     /*S01259S01310*/
                                                                      /*S01259*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERRDTA)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO ABNOR
             ENDDO
 
             GOTO END
 ABNOR:      SNDPGMMSG  MSG('CFC0055 ENDED ABNORMALLY') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 END:        ENDPGM
