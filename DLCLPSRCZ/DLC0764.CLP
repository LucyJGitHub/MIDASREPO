/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL MDDR Usage 70/100% Report')                  */
/*********************************************************************/
/*                                                                   */
/*     Midas - DEALING MODULE.                                       */
/*                                                                   */
/*     DLC0764    -   MDDR USAGE 70/100% REPORT                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL002             Date 22Sep97              */
/*                      094233             Date 06Oct95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDL002 - FX Netting. Set Switches U3 for Parent/Customer    */
/*                processing                                         */
/*      094233 - Add ABNOR processing.                               */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
   DCL VAR(&RPARM) TYPE(*CHAR) LEN(100) /* RCF PARAMETERS     */
 
/**/
             DCL VAR(&SWS) TYPE(*CHAR) LEN(8)
 
/************DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) VALUE('Job +    *094233*/
/************             Terminated - Database in Error')             *094233*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(1)                 /*CDL002*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CDL002*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CDL002*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*094233*/
/**/
             SNDMSG     MSG('MDDR Usage Report') TOMSGQ(MRUNQ)
 
/*/COPY WNCPYSRC,DLC0764001                                          */
/**/                                                                  /*CDL002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CDL002' +
                          &FMT)                                       /*CDL002*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CDL002*/
                CHGJOB     SWS(XX1XXXXX)                              /*CDL002*/
             ENDDO                                                    /*CDL002*/
/**/                                                                  /*CDL002*/
             IF         COND(%SUBSTRING(&RPARM 1 3) *EQ '100') +
                        THEN(CHGJOB  SWS(XXX1XXXX))
             CALL       PGM(DL0764) PARM(&RSEQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*094233*/
/**/
             RTVJOBA SWS(&SWS)
             IF COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)
             SNDPGMMSG  MSG('DLC0764 - MDDR Usage (70/100%) +
                          report completed normally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)         /*094233*/
/************SNDMSG     MSG('MDDR Usage Report') TOMSGQ(MRUNQ)     */ /*094233*/
             ENDDO
/**/                                                                  /*094233*/
             IF COND(%SUBSTRING(&SWS 7 2) *EQ '11') THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)             /*094233*/
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*094233*/
/*****************SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ)                 */ /*094233*/
             ENDDO
/**/                                                                  /*094233*/
             IF COND(%SUBSTRING(&SWS 7 2) *NE '00') THEN(DO)          /*094233*/
             GOTO       CMDLBL(ABNOR)                                 /*094233*/
             ENDDO                                                    /*094233*/
/**/                                                                  /*094233*/
       CHGJOB SWS(00000000)
             GOTO       CMDLBL(END)                                   /*094233*/
/**/                                                                  /*094233*/
ABNOR:                                                                /*094233*/
             CHGJOB     SWS(XXXXXX11)                                 /*094233*/
             SNDPGMMSG  MSG('DLC0764 - MDDR Usage (70/100%) +
                          report ended abnormally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)         /*094233*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*094233*/
/**/                                                                  /*094233*/
END:                                                                  /*094233*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
