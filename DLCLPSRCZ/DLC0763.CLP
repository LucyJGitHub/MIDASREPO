/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FX limit usage 80/100% report')              */
/*********************************************************************/
/*                                                                   */
/*     Midas - DEALING MODULE.                                       */
/*                                                                   */
/*     DLC0763    -   FX LIMIT USAGE (80/100%) REPORT                */
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
/*       Prev Amend No. 146263             Date 28Oct98              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CDL002             Date 22Sep97              */
/*                      094233             Date 06OCT95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*      146263 - Run limits extract program DL0740 if the extract    */
/*               file doesn't already exist.                         */
/*      CDL002 - FX Netting. Set Switches U3 for Parent/Customer     */
/*               processing                                          */
/*      094233 - Add ABNOR processing.                               */
/*                                                                   */
/*********************************************************************/
PGM    PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL VAR(&SWS) TYPE(*CHAR) LEN(8)
/************DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) VALUE('Job +    *094233*/
/************             Terminated - Database in Error')             *094233*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(1)                 /*CDL002*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CDL002*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CDL002*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*146263*/
             DCLF       FILE(EVLXCEC)                                 /*146263*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*094233*/
/**/
             SNDMSG     MSG('FX Limit Usage (80/100%) ')  TOMSGQ(MRUNQ)
                                                                      /*146263*/
             CHGJOB      SWS(00000000)                                /*146263*/
                                                                      /*146263*/
/*  Create limits extract file if it doesn't exist */                 /*146263*/
             RCVF                                                     /*146263*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*146263*/
                                                                      /*146263*/
/*  Allocate file whilst extract runs   */                            /*146263*/
             ALCOBJ     OBJ((EVLXCEC *FILE *EXCL))
                                                                      /*146263*/
/*  Clear files  */                                                   /*146263*/
             CLRPFM      FILE(EVLXCEC)                                /*146263*/
             CLRPFM      FILE(EVLXCEE)                                /*146263*/
             CLRPFM      FILE(EVLXCEG)                                /*146263*/
             CLRPFM      FILE(EVLXCED)                                /*146263*/
             CLRPFM      FILE(EVLXCBH)                                /*146263*/
             CLRPFM      FILE(EVLXCBE)                                /*146263*/
/**/                                                                  /*146263*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*146263*/
             IF          COND(%SUBSTRING(&MMOD 4 1) = 'Y') +
                         THEN(CHGJOB   SWS(X1XXXXXX))                 /*146263*/
                                                                      /*146263*/
/* Block large files  */                                              /*146263*/
             OVRDBF      FILE(EVLXCED) SEQONLY(*YES 100)              /*146263*/
             OVRDBF      FILE(EVLXCEE) SEQONLY(*YES 100)              /*146263*/
                                                                      /*146263*/
/* Determine if S013630 is installed  */                              /*146263*/
             CHGVAR     VAR(&RTCD)  VALUE('       ')                  /*146263*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'S01360')  /*146263*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGJOB +
                          SWS(X1XXXXXX))                              /*146263*/
             CHGVAR     VAR(&RTCD) VALUE(' ')                         /*146263*/
                                                                      /*146263*/
/* Call extract program  */                                           /*146263*/
             CALL        PGM(DL0740)                                  /*146263*/
             DLTOVR      FILE(EVLXCED)                                /*146263*/
             DLTOVR      FILE(EVLXCEE)                                /*146263*/
                                                                      /*146263*/
/*  Deallocate file after extract run   */                            /*146263*/
             DLCOBJ     OBJ((EVLXCEC *FILE *EXCL))                    /*146263*/
                                                                      /*146263*/
/*  Reset job switches  */                                            /*146263*/
             CHGJOB      SWS(00000000)                                /*146263*/
                                                                      /*146263*/
             ENDDO                                                    /*146263*/
/**/                                                                  /*CDL002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CDL002' +
                          &FMT)                                       /*CDL002*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CDL002*/
                CHGJOB     SWS(XX1XXXXX)                              /*CDL002*/
             ENDDO                                                    /*CDL002*/
/**/                                                                  /*CDL002*/
             IF         COND(%SUBSTRING(&RPARM 1 3) *EQ '100') +
                        THEN(CHGJOB  SWS(XXX1XXXX))
             CALL       PGM(DL0763) PARM(&RSEQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*094233*/
                                                                      /*094233*/
             RTVJOBA SWS(&SWS)
                                                                      /*094233*/
             IF COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)
             SNDPGMMSG  MSG('DLC0763 - FX Limit Usage (80/100%) +
                          report completed normally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)         /*094233*/
/************SNDMSG     MSG('MDDR Usage Report') TOMSGQ(MRUNQ)     */ /*094233*/
/*****************RTVJOBA SWS(&SWS)                                */ /*094233*/
             ENDDO
/**/                                                                  /*094233*/
             IF COND(%SUBSTRING(&SWS 7 2) *EQ '11') THEN(DO)
/*****************SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ)                 */ /*094233*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)             /*094233*/
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*094233*/
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
             SNDPGMMSG  MSG('DLC0763 - FX Limit Usage (80/100%) +
                          report ended abnormally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)         /*094233*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*094233*/
/**/                                                                  /*094233*/
END:                                                                  /*094233*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
